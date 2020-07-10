#!/bin/bash

# Read in properties file
. ./Legacy/legacy-release-config.properties

###############################################################################

# Ensure we're using JDK8
export PATH="${JDK8_PATH}/bin:${PATH}:${JDK8_PATH}/bin"
export JAVA_HOME="${JDK8_PATH}"

# Enter correct directory
cd Releases/4

# Remove the base pom if it's present to prevent error
rm pom.xml

# Upload the release to Nexus (Staging)
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara/payara-${VERSION}.zip -Dsources=Payara/payara-${VERSION}-sources.jar -Djavadoc=Payara/payara-${VERSION}-javadoc.jar -DpomFile=Payara/payara-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara/payara-${VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara/payara-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara/payara-${VERSION}.tar.gz -DpomFile=Payara/payara-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara/payara-${VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara/payara-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-ML/payara-ml-${VERSION}.zip -Dsources=Payara-ML/payara-ml-${VERSION}-sources.jar -Djavadoc=Payara-ML/payara-ml-${VERSION}-javadoc.jar -DpomFile=Payara-ML/payara-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-ML/payara-ml-${VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara-ML/payara-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-ML/payara-ml-${VERSION}.tar.gz -DpomFile=Payara-ML/payara-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-ML/payara-ml-${VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara-ML/payara-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Web/payara-web-${VERSION}.zip -Dsources=Payara-Web/payara-web-${VERSION}-sources.jar -Djavadoc=Payara-Web/payara-web-${VERSION}-javadoc.jar -DpomFile=Payara-Web/payara-web-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Web/payara-web-${VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara-Web/payara-web-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Web/payara-web-${VERSION}.tar.gz -DpomFile=Payara-Web/payara-web-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Web/payara-web-${VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara-Web/payara-web-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Web-ML/payara-web-ml-${VERSION}.zip -Dsources=Payara-Web-ML/payara-web-ml-${VERSION}-sources.jar -Djavadoc=Payara-Web-ML/payara-web-ml-${VERSION}-javadoc.jar -DpomFile=Payara-Web-ML/payara-web-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Web-ML/payara-web-ml-${VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara-Web-ML/payara-web-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Web-ML/payara-web-ml-${VERSION}.tar.gz -DpomFile=Payara-Web-ML/payara-web-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Web-ML/payara-web-ml-${VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara-Web-ML/payara-web-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Micro/payara-micro-${VERSION}.jar -Dsources=Payara-Micro/payara-micro-${VERSION}-sources.jar -Djavadoc=Payara-Micro/payara-micro-${VERSION}-javadoc.jar -DpomFile=Payara-Micro/payara-micro-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Micro/payara-micro-${VERSION}-jdk7.jar -Dclassifier=jdk7 -DpomFile=Payara-Micro/payara-micro-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Embedded-All/payara-embedded-all-${VERSION}.jar -Dsources=Payara-Embedded-All/payara-embedded-all-${VERSION}-sources.jar -Djavadoc=Payara-Embedded-All/payara-embedded-all-${VERSION}-javadoc.jar -DpomFile=Payara-Embedded-All/payara-embedded-all-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Embedded-All/payara-embedded-all-${VERSION}-jdk7.jar -Dclassifier=jdk7 -DpomFile=Payara-Embedded-All/payara-embedded-all-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Embedded-Web/payara-embedded-web-${VERSION}.jar -Dsources=Payara-Embedded-Web/payara-embedded-web-${VERSION}-sources.jar -Djavadoc=Payara-Embedded-Web/payara-embedded-web-${VERSION}-javadoc.jar -DpomFile=Payara-Embedded-Web/payara-embedded-web-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Embedded-Web/payara-embedded-web-${VERSION}-jdk7.jar -Dclassifier=jdk7 -DpomFile=Payara-Embedded-Web/payara-embedded-web-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -DgroupId=fish.payara.extras -DartifactId=payara-source -Dversion=${VERSION}.RC${RC_VERSION} -Dpackaging=zip -Dfile=SourceExport/payara-source-${VERSION}.zip -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-API/payara-api-${VERSION}.jar -DpomFile=Payara-API/payara-api-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dsources=Payara-API/payara-api-${VERSION}-sources.jar -Djavadoc=Payara-API/payara-api-${VERSION}-javadoc.jar
