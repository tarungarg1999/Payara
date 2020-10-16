#!/bin/bash

#cd into script location
cd $(dirname $BASH_SOURCE)

REPO_DIR="./payara-enterprise"

#Change to HTTPS if running locally
ENTERPRISE_REMOTE="https://github.com/AlanRoth/payara-enterprise"

if [ ! -f payara.versions ]; then
    echo "payara.versions file is missing!"
    exit -1
fi

#Should return 0. All payara versions should match the regex
invalidVersions=$(grep -P -v -c "(5|4).(1.2.191|\d{2}).(\d+)" payara.versions)
if [ ! ${invalidVersions} == 0 ]; then
    echo "There is a invalid version in payara.versions"
    #Return invalid versions
    echo $(grep -P -v "(5|4).(1.2.191|\d{2}).(\d+)" payara.versions)
    exit -1
fi

if [ ! -d payara-enterprise ]; then
    echo "Source code directory is not where expected or does not exist."
    git clone $ENTERPRISE_REMOTE
fi

#Map payara versions to a local array
mapfile -t versionArray < payara.versions

#Sort array
sortedVersionArray=( $( printf "%s\n" "${versionArray[@]}" | sort -nr ) )

cd ${REPO_DIR}

#Payara 5+ will be processed first in the sorted list
git checkout master

#For loop for every version in version array
for i in "${sortedVersionArray[@]}"
do
    #Check out maintenance if payara4
    if [ ${i:0:1} == "4" ]; then
        git checkout payara-server-4.1.2.191.maintenance
    fi

    docker system prune --all
    mvn clean install -PBuildDockerImages -Dpayara.version=$i -pl :docker-images -amd -U
    . ../docker-tag.sh ${i}
    
    #Danger Zone
    #. ../docker-test.sh ${i}
    #. ../docker-push ${i}
    #----------
done
