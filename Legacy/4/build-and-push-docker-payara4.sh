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
. ./Util/docker-tag.sh ${RELEASE_VERSION}

# Store server full as a tar for enterprise evaluation
mkdir Releases/4/Docker
docker save payara/server-full:${RELEASE_VERSION} > ./Releases/4/Docker/payara-server-enterprise-evaluation-docker-server-full.tar.gz

#Push Docker Images
. /Util/docker-push.sh ${RELEASE_VERSION}
