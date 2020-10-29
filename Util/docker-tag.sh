RELEASE_VERSION=$1

if [[ -z ${RELEASE_VERSION} ]]; then
    echo "Release version was not provided!"
    exit -1
fi

MAJOR_VERSION=${RELEASE_VERSION:0:1}

### Tag images
docker tag payara/server-full:${RELEASE_VERSION} nexus.payara.fish:5000/payara/server-full:${RELEASE_VERSION}
docker tag payara/server-web:${RELEASE_VERSION} nexus.payara.fish:5000/payara/server-web:${RELEASE_VERSION}
docker tag payara/micro:${RELEASE_VERSION} nexus.payara.fish:5000/payara/micro:${RELEASE_VERSION}

###Tag JDK11 Versions & Images not applicable to Payara 4
if [[ ${MAJOR_VERSION} != "4" ]]; then
    docker tag payara/server-node:${RELEASE_VERSION} nexus.payara.fish:5000/payara/server-node:${RELEASE_VERSION}
    
    docker tag payara/server-node:${RELEASE_VERSION}-jdk11 nexus.payara.fish:5000/payara/server-node:${RELEASE_VERSION}-jdk11
    docker tag payara/server-full:${RELEASE_VERSION}-jdk11 nexus.payara.fish:5000/payara/server-full:${RELEASE_VERSION}-jdk11
    docker tag payara/server-web:${RELEASE_VERSION}-jdk11 nexus.payara.fish:5000/payara/server-web:${RELEASE_VERSION}-jdk11
    docker tag payara/micro:${RELEASE_VERSION}-jdk11 nexus.payara.fish:5000/payara/micro:${RELEASE_VERSION}-jdk11
fi
