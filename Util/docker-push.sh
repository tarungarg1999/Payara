RELEASE_VERSION=$1

if [[ -z ${RELEASE_VERSION} ]]; then
    echo "Release version was not provided!"
    exit -1
fi

MAJOR_VERSION=${RELEASE_VERSION:0:1}

### Push images
docker push nexus.payara.fish:5000/payara/server-full:${RELEASE_VERSION}
docker push nexus.payara.fish:5000/payara/server-web:${RELEASE_VERSION}
docker push nexus.payara.fish:5000/payara/micro:${RELEASE_VERSION}

###Push JDK11 Versions & Images not applicable to Payara 4
if [[ ${MAJOR_VERSION} != "4" ]]; then
    docker push nexus.payara.fish:5000/payara/micro:${RELEASE_VERSION}-jdk11
    docker push nexus.payara.fish:5000/payara/server-web:${RELEASE_VERSION}-jdk11
    docker push nexus.payara.fish:5000/payara/server-full:${RELEASE_VERSION}-jdk11
    docker push nexus.payara.fish:5000/payara/server-node:${RELEASE_VERSION}-jdk11

    docker push nexus.payara.fish:5000/payara/server-node:${RELEASE_VERSION}
fi

