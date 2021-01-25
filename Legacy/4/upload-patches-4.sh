#!/bin/bash

# Read in properties file
. ./Legacy/legacy-release-config.properties

BASE_VERSION=4.1.2.191

RELEASE_VERSION="$BASE_VERSION.$RELEASE_PATCH_VERSION"

###############################################################################

# Ensure we're using JDK8
export PATH="${JDK8_PATH}/bin:${PATH}:${JDK8_PATH}/bin"
export JAVA_HOME="${JDK8_PATH}"

# Enter correct directory
cd Releases/4

# Remove the base pom if it's present to prevent error
rm pom.xml

# Upload the release to Nexus (Patches)
mvn deploy:deploy-file -Dfile=Payara/payara-${RELEASE_VERSION}.zip -Dsources=Payara/payara-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara/payara-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara/payara-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara/payara-${RELEASE_VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara/payara-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara/payara-${RELEASE_VERSION}.tar.gz -DpomFile=Payara/payara-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz
mvn deploy:deploy-file -Dfile=Payara/payara-${RELEASE_VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara/payara-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dfile=Payara-ML/payara-ml-${RELEASE_VERSION}.zip -Dsources=Payara-ML/payara-ml-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-ML/payara-ml-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara-ML/payara-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-ML/payara-ml-${RELEASE_VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara-ML/payara-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-ML/payara-ml-${RELEASE_VERSION}.tar.gz -DpomFile=Payara-ML/payara-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz
mvn deploy:deploy-file -Dfile=Payara-ML/payara-ml-${RELEASE_VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara-ML/payara-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dfile=Payara-Web/payara-web-${RELEASE_VERSION}.zip -Dsources=Payara-Web/payara-web-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-Web/payara-web-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara-Web/payara-web-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-Web/payara-web-${RELEASE_VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara-Web/payara-web-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-Web/payara-web-${RELEASE_VERSION}.tar.gz -DpomFile=Payara-Web/payara-web-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz
mvn deploy:deploy-file -Dfile=Payara-Web/payara-web-${RELEASE_VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara-Web/payara-web-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dfile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.zip -Dsources=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.tar.gz -DpomFile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz
mvn deploy:deploy-file -Dfile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dfile=Payara-Micro/payara-micro-${RELEASE_VERSION}.jar -Dsources=Payara-Micro/payara-micro-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-Micro/payara-micro-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara-Micro/payara-micro-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-Micro/payara-micro-${RELEASE_VERSION}-jdk7.jar -Dclassifier=jdk7 -DpomFile=Payara-Micro/payara-micro-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -Dfile=Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}.jar -Dsources=Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}-jdk7.jar -Dclassifier=jdk7 -DpomFile=Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -Dfile=Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}.jar -Dsources=Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}-jdk7.jar -Dclassifier=jdk7 -DpomFile=Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -DgroupId=fish.payara.extras -DartifactId=payara-source -Dversion=${RELEASE_VERSION} -Dpackaging=zip -Dfile=SourceExport/payara-source-${RELEASE_VERSION}.zip -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION} -Dfile=Payara-API/payara-api-${RELEASE_VERSION}.jar -DpomFile=Payara-API/payara-api-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dsources=Payara-API/payara-api-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-API/payara-api-${RELEASE_VERSION}-javadoc.jar
