#!/bin/bash

# Read in properties file
. ./Community/community-release-config.properties

###############################################################################

RELEASE_VERSION="$RELEASE_MAJOR_VERSION.$RELEASE_MINOR_VERSION.$RELEASE_PATCH_VERSION"

# Ensure we're using JDK8
export PATH="${JDK8_PATH}/bin:${PATH}:${JDK8_PATH}/bin"
export JAVA_HOME="${JDK8_PATH}"

# Enter correct release directory
cd Releases/Community

# Remove the base pom if it's present to prevent error
rm pom.xml

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara/payara-${RELEASE_VERSION}.zip -Dsources=Payara/payara-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara/payara-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara/payara-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara/payara-${RELEASE_VERSION}.tar.gz -DpomFile=Payara/payara-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-ML/payara-ml-${RELEASE_VERSION}.zip -Dsources=Payara-ML/payara-ml-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-ML/payara-ml-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara-ML/payara-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-ML/payara-ml-${RELEASE_VERSION}.tar.gz -DpomFile=Payara-ML/payara-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Web/payara-web-${RELEASE_VERSION}.zip -Dsources=Payara-Web/payara-web-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-Web/payara-web-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara-Web/payara-web-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Web/payara-web-${RELEASE_VERSION}.tar.gz -DpomFile=Payara-Web/payara-web-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.zip -Dsources=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.tar.gz -DpomFile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Micro/payara-micro-${RELEASE_VERSION}.jar -Dsources=Payara-Micro/payara-micro-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-Micro/payara-micro-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara-Micro/payara-micro-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}.jar -Dsources=Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}.jar -Dsources=Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -DgroupId=fish.payara.extras -DartifactId=payara-source -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dpackaging=zip -Dfile=SourceExport/payara-source-${RELEASE_VERSION}.zip -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-API/payara-api-${RELEASE_VERSION}.jar -DpomFile=Payara-API/payara-api-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dsources=Payara-API/payara-api-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-API/payara-api-${RELEASE_VERSION}-javadoc.jar

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-EJB-HTTP-Client/ejb-http-client-${RELEASE_VERSION}.jar -DpomFile=Payara-EJB-HTTP-Client/ejb-http-client-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dsources=Payara-EJB-HTTP-Client/ejb-http-client-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-EJB-HTTP-Client/ejb-http-client-${RELEASE_VERSION}-javadoc.jar

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Appclient/payara-client-${RELEASE_VERSION}.jar -DpomFile=Payara-Appclient/payara-client-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dsources=Payara-Appclient/payara-client-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-Appclient/payara-client-${RELEASE_VERSION}-javadoc.jar

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -DpomFile=Payara-BOM/payara-bom-${RELEASE_VERSION}.pom -Dfile=Payara-BOM/payara-bom-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
