#!/bin/bash

REPO_DIR="./payara-enterprise"

#Change to HTTPS if running locally
ENTERPRISE_REMOTE="git@github.com:payara/payara-enterprise.git"

if [ ! -f payara.versions ]; then
    echo "payara.versions file is missing!"
    exit -1
fi

if [ ! -d payara-enterprise ]; then
    echo "Source code directory is not where expected."
    git clone $ENTERPRISE_REMOTE
fi

#Map payara versions to a local array
mapfile -t versionArray < payara.versions

cd ${REPO_DIR}

#For loop for every version in version array
for i in "${versionArray[@]}"
do
    #Checkout master
    git checkout master

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
