#!/bin/bash

# Read in properties file
. ./blue-release-config.properties

###############################################################################

# Ensure we're using JDK8
export PATH="${JDK8_PATH}/bin:${PATH}:${JDK8_PATH}/bin"
export JAVA_HOME="${JDK8_PATH}"

# Enter correct directory
cd Releases/Blue

# Remove the base pom if it's present to prevent error
rm pom.xml

# Upload the release to Nexus (Patches)
mvn deploy:deploy-file -Dfile=Payara-Blue/payara-${VERSION}.zip -Dsources=Payara-Blue/payara-${VERSION}-sources.jar -DpomFile=Payara-Blue/payara-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-Blue/payara-${VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara-Blue/payara-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-Blue/payara-${VERSION}.tar.gz -DpomFile=Payara-Blue/payara-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz
mvn deploy:deploy-file -Dfile=Payara-Blue/payara-${VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara-Blue/payara-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dfile=Payara-Blue-ML/payara-ml-${VERSION}.zip -Dsources=Payara-Blue-ML/payara-ml-${VERSION}-sources.jar -DpomFile=Payara-Blue-ML/payara-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-Blue-ML/payara-ml-${VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara-Blue-ML/payara-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-Blue-ML/payara-ml-${VERSION}.tar.gz -DpomFile=Payara-Blue-ML/payara-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz
mvn deploy:deploy-file -Dfile=Payara-Blue-ML/payara-ml-${VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara-Blue-ML/payara-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dfile=Payara-Blue-Web/payara-web-${VERSION}.zip -Dsources=Payara-Blue-Web/payara-web-${VERSION}-sources.jar -DpomFile=Payara-Blue-Web/payara-web-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-Blue-Web/payara-web-${VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara-Blue-Web/payara-web-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-Blue-Web/payara-web-${VERSION}.tar.gz -DpomFile=Payara-Blue-Web/payara-web-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz
mvn deploy:deploy-file -Dfile=Payara-Blue-Web/payara-web-${VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara-Blue-Web/payara-web-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dfile=Payara-Blue-Web-ML/payara-web-ml-${VERSION}.zip -Dsources=Payara-Blue-Web-ML/payara-web-ml-${VERSION}-sources.jar -DpomFile=Payara-Blue-Web-ML/payara-web-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-Blue-Web-ML/payara-web-ml-${VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara-Blue-Web-ML/payara-web-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-Blue-Web-ML/payara-web-ml-${VERSION}.tar.gz -DpomFile=Payara-Blue-Web-ML/payara-web-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz
mvn deploy:deploy-file -Dfile=Payara-Blue-Web-ML/payara-web-ml-${VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara-Blue-Web-ML/payara-web-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dfile=Payara-Blue-Micro/payara-micro-${VERSION}.jar -Dsources=Payara-Blue-Micro/payara-micro-${VERSION}-sources.jar -DpomFile=Payara-Blue-Micro/payara-micro-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-Blue-Micro/payara-micro-${VERSION}-jdk7.jar -Dclassifier=jdk7 -DpomFile=Payara-Blue-Micro/payara-micro-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -Dfile=Payara-Blue-Embedded-All/payara-embedded-all-${VERSION}.jar -Dsources=Payara-Blue-Embedded-All/payara-embedded-all-${VERSION}-sources.jar -DpomFile=Payara-Blue-Embedded-All/payara-embedded-all-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-Blue-Embedded-All/payara-embedded-all-${VERSION}-jdk7.jar -Dclassifier=jdk7 -DpomFile=Payara-Blue-Embedded-All/payara-embedded-all-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -Dfile=Payara-Blue-Embedded-Web/payara-embedded-web-${VERSION}.jar -Dsources=Payara-Blue-Embedded-Web/payara-embedded-web-${VERSION}-sources.jar -DpomFile=Payara-Blue-Embedded-Web/payara-embedded-web-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dfile=Payara-Blue-Embedded-Web/payara-embedded-web-${VERSION}-jdk7.jar -Dclassifier=jdk7 -DpomFile=Payara-Blue-Embedded-Web/payara-embedded-web-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -DgroupId=fish.payara.blue.extras -DartifactId=payara-source -Dversion=${VERSION} -Dpackaging=zip -Dfile=SourceExport-Blue/payara-source-${VERSION}.zip -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-patches/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
