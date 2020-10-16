#!/bin/sh

#############################################################################

# Read in properties file

. ./Enterprise/enterprise-release-config.properties

#############################################################################

RELEASE_VERSION="$RELEASE_MAJOR_VERSION.$RELEASE_MINOR_VERSION.$RELEASE_PATCH_VERSION"

### Checkout the release tag - should be created by now, if it fails the script will fail too
set -e
cd ${REPO_DIR}
git fetch ${MASTER_REMOTE}
git checkout payara-server-${RELEASE_VERSION}

# Remove all local docker images and build for jdk8 and jdk11
docker system prune --all
mvn clean install -PBuildDockerImages -pl :docker-images -amd -Dbuild.number=${BUILD_NUMBER} -U

# Move back to release-scripts dir
cd -

#Tag Images

. ./Util/docker-tag.sh ${RELEASE_VERSION}

### Tag images for latest
# Server Node
docker tag nexus.payara.fish:5000/payara/server-node:${RELEASE_VERSION} nexus.payara.fish:5000/payara/server-node:latest

# Server Full
docker tag nexus.payara.fish:5000/payara/server-full:${RELEASE_VERSION} nexus.payara.fish:5000/payara/server-full:latest

# Store server full as a tar for enterprise evaluation
mkdir Releases/Enterprise/Docker
docker save payara/server-full:${RELEASE_VERSION} > ./Releases/Enterprise/Docker/server-full.tar.gz

# Server Web
docker tag nexus.payara.fish:5000/payara/server-web:${RELEASE_VERSION} nexus.payara.fish:5000/payara/server-web:latest

# Micro
docker tag nexus.payara.fish:5000/payara/micro:${RELEASE_VERSION} nexus.payara.fish:5000/payara/micro:latest

### Push images to Nexus
. ./Util/docker-push.sh ${RELEASE_VERSION}
