#!/bin/bash

### VARIABLES ###
readonly RELEASE_VERSION=$1

if [[ -z ${RELEASE_VERSION} ]]; then
    echo "Release version was not provided!"
    exit -1
fi

readonly MAJOR_VERSION=${RELEASE_VERSION:0:1}

readonly TEST_FILE="test-failures-$RELEASE_VERSION.txt"

readonly PAYARA_HOME="/opt/payara/appserver/glassfish"
readonly DOMAIN_DIR="$PAYARA_HOME/domains/production"

readonly LATEST_JDK8_VERSION=1.8.0_262
readonly LATEST_JDK11_VERSION=11.0.7

DISTRIBUTIONS=("server-full" "server-web" "micro")
#Add payara5 only distributions
if [ $MAJOR_VERSION -ge 5 ]; then
    DISTRIBUTIONS+=("server-node")
fi

#Used to reference the currently running container and distribution under test
CONTAINER_ID=""
DISTRIBUTION=""

### UTILITY FUNCTIONS ###

#Asserts if the passed in value is equal to the RESULT variable - returns 1 if not
function assertResultEqual() {
    #Remove special characters from result
    RESULT=$(echo $RESULT | tr -dc '[:alnum:]_. ' )
    if [[ ${RESULT} != ${1} ]]; then
        return 1
    fi
    return 0
}

function report() {
    local expected=$1
    local actual=$2
    local message=$3
    echo "FAILURE: ${message} Expected: ${expected} Actual: ${actual}: " >> $TEST_FILE
}

function startContainer() {
    local distribution=$1
    local release_version=$2
    local entry_point=$3
    if [[ ! -z $entry_point && ! isMicro ]]; then
        CONTAINER_ID=$(docker run --entrypoint="$entry_point" -it -d payara/$distribution:$release_version)
        else
        CONTAINER_ID=$(docker run -it -d payara/$distribution:$release_version)
    fi
}

function stopAndRemoveContainer() {
    docker rm $CONTAINER_ID -f
}

function hasDatePassed() {
    local date_seconds=$(date -d "$date" +"%s")
    local date_now_seconds=$(date +"%s")
    
    #If the date is less than now in seconds since epoch it means the date is in the past
    if [ $date_seconds -le  $date_now_seconds ]; then
        return 1
    fi
    return 0
}

#Some tests cannot be performed on micro
function isMicro() {
    if [ $DISTRIBUTION == 'micro' ]; then
        return 0
    fi
    return 1
}

#Some tests cannot be performed on server-node
function isServerNode() {
    if [ $DISTRIBUTION == 'server-node' ]; then
        return 0
    fi
    return 1
}

function containerHasFile() {
    local file_path=$1
    if [ $(docker exec -it ${CONTAINER_ID} test -f $file_path && echo 0) ]; then
        return 0
    fi
    return 1
}

### TEST FUNCTIONS ###

function testJDKVersion() {
    local jdk_version=$1

    RESULT=$(docker exec -it ${CONTAINER_ID} java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    
    if ! assertResultEqual $jdk_version ; then
    	report $jdk_version $RESULT "$FUNCNAME $DISTRIBUTION $RELEASE_VERSION"
    fi
}

function testCertExpiry() {
    if isMicro ; then
        return 1
    fi
    
    local dateRegex="(?<=until: )\w{3} \w{3} \d{2} \d{2}:\d{2}:\d{2} \w{3} \w{4}"
    
    RESULT=''
    
    #Workaround for making an newline delimited array instead of the default whitespace delimiter
    ifs_old=$IFS
    IFS=$'\n'
    expiry_dates=( $(docker exec -it ${CONTAINER_ID} keytool -list -v -keystore "${DOMAIN_DIR}/config/cacerts.jks" -storepass 'changeit' | grep -P -o "$dateRegex") )
    IFS=$ifs_old
    
    for date in "${expiry_dates[@]}"
    do
        if ! hasDatePassed "$date" ; then
            RESULT=${date}
            break
        fi
    done
    
    #No dates should be returned as being in the past - hence the check for empty string
    if ! assertResultEqual "" ; then
    	report "No expired certificates" "$RESULT" "$FUNCNAME $DISTRIBUTION $RELEASE_VERSION"
    fi
}

function testServerLog() {
    if isServerNode ; then
        return 1
    fi

    if isMicro ; then
        RESULT=$(docker logs ${CONTAINER_ID} | grep -E -o -c "WARNING|SEVERE")
    else
        #Make sure server.log exists before continuing
        if ! containerHasFile "$DOMAIN_DIR/logs/server.log" ; then
            sleep 5
            #If server.log does not exist after 5 seconds, report it as a failure and exit
            if ! containerHasFile "$DOMAIN_DIR/logs/server.log" ; then
                report "server.log to exist" "server.log does not exist" "$FUNCNAME $DISTRIBUTION $RELEASE_VERSION"
                return 1
            fi
        fi
        RESULT=$(docker exec -it ${CONTAINER_ID} grep -E -o -c "WARNING|SEVERE" "$DOMAIN_DIR/logs/server.log")
    fi

    if ! assertResultEqual 0 ; then
    	report "0" "${RESULT}" "$FUNCNAME $distribution $RELEASE_VERSION"
    fi
}

function testVersion() {
    if isServerNode ; then
        return 1
    fi
    
    if isMicro ; then
        RESULT=$(docker exec -it ${CONTAINER_ID} java -jar payara-micro.jar --version | grep -P -o "$RELEASE_VERSION")
    else
    	RESULT=$(docker exec -it ${CONTAINER_ID} $PAYARA_HOME/bin/asadmin version --local | grep -P -o "$RELEASE_VERSION")
    fi
    
    if ! assertResultEqual $RELEASE_VERSION ; then
    	report "$RELEASE_VERSION" "$RESULT" "$FUNCNAME $DISTRIBUTION $RELEASE_VERSION"
    fi
}

#If old failures file exists - timestamp it
if [ -f $TEST_FILE ]; then
    mv $TEST_FILE $TEST_FILE-$(date +"%Y-%m-%d_%H-%M-%S")
fi

### RUN TESTS ###

for i in "${DISTRIBUTIONS[@]}"
do  
    DISTRIBUTION=$i
    
    ##TEST JDK 8 VERSIONS
    startContainer $DISTRIBUTION $RELEASE_VERSION "/bin/bash"
    
    testJDKVersion $LATEST_JDK8_VERSION
    testCertExpiry
    
    stopAndRemoveContainer
    
    startContainer $DISTRIBUTION $RELEASE_VERSION
    
    testServerLog
    testVersion
    
    stopAndRemoveContainer
    
    ##TEST JDK11 VERSIONS
    if [ $MAJOR_VERSION -ge 5 ]; then
        startContainer $i $RELEASE_VERSION-jdk11 "/bin/bash"
    
        testJDKVersion $LATEST_JDK11_VERSION
        testCertExpiry
        
        stopAndRemoveContainer
        
        startContainer $DISTRIBUTION $RELEASE_VERSION-jdk11
        
        testServerLog
        testVersion
        
        stopAndRemoveContainer
    fi
done

#If file exists after testing and is non-zero size
if [ -s $TEST_FILE ]; then
    echo "There are Test Failures! Check $TEST_FILE"
    exit -1
fi
