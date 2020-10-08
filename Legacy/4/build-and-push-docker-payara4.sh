#!/bin/sh

#############################################################################

# Read in properties file

. ./Legacy/legacy-release-config.properties

#############################################################################

RELEASE_VERSION="4.1.2.191.$RELEASE_PATCH_VERSION"

### Checkout the release tag - should be created by now, if it fails the script will fail too
set -e
cd ${REPO_DIR}
git fetch ${MASTER_REMOTE}
git checkout payara-server-${RELEASE_VERSION}

# Remove all local docker images and build for jdk8 and jdk11
docker system prune --all
mvn clean install -PBuildDockerImages -pl :docker-images -amd -Dbuild.number=${BUILD_NUMBER}

# Move back to release-scripts dir
cd -

### Tag images
# Server Full
docker tag payara/server-full:${RELEASE_VERSION} nexus.payara.fish:5000/payara/server-full:${RELEASE_VERSION}

# Store server full as a tar for enterprise evaluation
mkdir Releases/4/Docker
docker save payara/server-full:${RELEASE_VERSION} > ./Releases/4/Docker/server-full.tar.gz

# Server Web
docker tag payara/server-web:${RELEASE_VERSION} nexus.payara.fish:5000/payara/server-web:${RELEASE_VERSION}

# Micro
docker tag payara/micro:${RELEASE_VERSION} nexus.payara.fish:5000/payara/micro:${RELEASE_VERSION}

### Push images to Nexus
docker push nexus.payara.fish:5000/payara/server-full:${RELEASE_VERSION}

docker push nexus.payara.fish:5000/payara/server-web:${RELEASE_VERSION}

docker push nexus.payara.fish:5000/payara/micro:${RELEASE_VERSION}
