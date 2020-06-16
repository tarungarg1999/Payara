#!/bin/bash

# Read in properties file
. ./release-config.properties

##################################################################

RELEASE_VERSION="$RELEASE_MAJOR_VERSION.$RELEASE_MINOR_VERSION.$RELEASE_PATCH_VERSION"

# Ensure we're using JDK8
export PATH="${JDK8_PATH}/bin:${PATH}:${JDK8_PATH}/bin"
export JAVA_HOME="${JDK8_PATH}"

# Sign the Files
gpg2 -ab Payara/payara-${RELEASE_VERSION}.pom
gpg2 -ab Payara/payara-${RELEASE_VERSION}.zip
gpg2 -ab Payara/payara-${RELEASE_VERSION}-sources.jar
gpg2 -ab Payara/payara-${RELEASE_VERSION}-javadoc.jar

gpg2 -ab Payara-ML/payara-ml-${RELEASE_VERSION}.pom
gpg2 -ab Payara-ML/payara-ml-${RELEASE_VERSION}.zip
gpg2 -ab Payara-ML/payara-ml-${RELEASE_VERSION}-sources.jar
gpg2 -ab Payara-ML/payara-ml-${RELEASE_VERSION}-javadoc.jar

gpg2 -ab Payara-Web/payara-web-${RELEASE_VERSION}.pom
gpg2 -ab Payara-Web/payara-web-${RELEASE_VERSION}.zip
gpg2 -ab Payara-Web/payara-web-${RELEASE_VERSION}-sources.jar
gpg2 -ab Payara-Web/payara-web-${RELEASE_VERSION}-javadoc.jar

gpg2 -ab Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.pom
gpg2 -ab Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.zip
gpg2 -ab Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}-sources.jar
gpg2 -ab Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}-javadoc.jar

gpg2 -ab Payara-Micro/payara-micro-${RELEASE_VERSION}.pom
gpg2 -ab Payara-Micro/payara-micro-${RELEASE_VERSION}.jar
gpg2 -ab Payara-Micro/payara-micro-${RELEASE_VERSION}-sources.jar
gpg2 -ab Payara-Micro/payara-micro-${RELEASE_VERSION}-javadoc.jar

gpg2 -ab Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}.pom
gpg2 -ab Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}.jar
gpg2 -ab Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}-sources.jar
gpg2 -ab Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}-javadoc.jar

gpg2 -ab Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}.pom
gpg2 -ab Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}.jar
gpg2 -ab Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}-sources.jar
gpg2 -ab Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}-javadoc.jar

gpg2 -ab Payara-API/payara-api-${RELEASE_VERSION}.pom
gpg2 -ab Payara-API/payara-api-${RELEASE_VERSION}.jar
gpg2 -ab Payara-API/payara-api-${RELEASE_VERSION}-sources.jar
gpg2 -ab Payara-API/payara-api-${RELEASE_VERSION}-javadoc.jar

gpg2 -ab Payara-EJB-HTTP-Client/ejb-http-client-${RELEASE_VERSION}.pom
gpg2 -ab Payara-EJB-HTTP-Client/ejb-http-client-${RELEASE_VERSION}.jar
gpg2 -ab Payara-EJB-HTTP-Client/ejb-http-client-${RELEASE_VERSION}-sources.jar
gpg2 -ab Payara-EJB-HTTP-Client/ejb-http-client-${RELEASE_VERSION}-javadoc.jarls

gpg2 -ab Payara-Appclient/payara-client-${RELEASE_VERSION}.pom
gpg2 -ab Payara-Appclient/payara-client-${RELEASE_VERSION}.jar
gpg2 -ab Payara-Appclient/payara-client-${RELEASE_VERSION}-sources.jar
gpg2 -ab Payara-Appclient/payara-client-${RELEASE_VERSION}-javadoc.jar

gpg2 -ab Payara-BOM/payara-bom-${RELEASE_VERSION}.pom

# Create JAR bundles
jar -cvf Payara/bundle.jar -C Payara payara-${RELEASE_VERSION}.zip -C Payara payara-${RELEASE_VERSION}.zip.asc -C Payara payara-${RELEASE_VERSION}-sources.jar -C Payara payara-${RELEASE_VERSION}-sources.jar.asc -C Payara payara-${RELEASE_VERSION}-javadoc.jar -C Payara payara-${RELEASE_VERSION}-javadoc.jar.asc -C Payara payara-${RELEASE_VERSION}.pom -C Payara payara-${RELEASE_VERSION}.pom.asc

jar -cvf Payara-ML/bundle.jar -C Payara-ML payara-ml-${RELEASE_VERSION}.zip -C Payara-ML payara-ml-${RELEASE_VERSION}.zip.asc -C Payara-ML payara-ml-${RELEASE_VERSION}-sources.jar -C Payara-ML payara-ml-${RELEASE_VERSION}-sources.jar.asc -C Payara-ML payara-ml-${RELEASE_VERSION}-javadoc.jar -C Payara-ML payara-ml-${RELEASE_VERSION}-javadoc.jar.asc -C Payara-ML payara-ml-${RELEASE_VERSION}.pom -C Payara-ML payara-ml-${RELEASE_VERSION}.pom.asc

jar -cvf Payara-Web/bundle.jar -C Payara-Web payara-web-${RELEASE_VERSION}.zip -C Payara-Web payara-web-${RELEASE_VERSION}.zip.asc -C Payara-Web payara-web-${RELEASE_VERSION}-sources.jar -C Payara-Web payara-web-${RELEASE_VERSION}-sources.jar.asc -C Payara-Web payara-web-${RELEASE_VERSION}-javadoc.jar -C Payara-Web payara-web-${RELEASE_VERSION}-javadoc.jar.asc -C Payara-Web payara-web-${RELEASE_VERSION}.pom -C Payara-Web payara-web-${RELEASE_VERSION}.pom.asc

jar -cvf Payara-Web-ML/bundle.jar -C Payara-Web-ML payara-web-ml-${RELEASE_VERSION}.zip -C Payara-Web-ML payara-web-ml-${RELEASE_VERSION}.zip.asc -C Payara-Web-ML payara-web-ml-${RELEASE_VERSION}-sources.jar -C Payara-Web-ML payara-web-ml-${RELEASE_VERSION}-sources.jar.asc -C Payara-Web-ML payara-web-ml-${RELEASE_VERSION}-javadoc.jar -C Payara-Web-ML payara-web-ml-${RELEASE_VERSION}-javadoc.jar.asc -C Payara-Web-ML payara-web-ml-${RELEASE_VERSION}.pom -C Payara-Web-ML payara-web-ml-${RELEASE_VERSION}.pom.asc

jar -cvf Payara-Micro/bundle.jar -C Payara-Micro payara-micro-${RELEASE_VERSION}.jar -C Payara-Micro payara-micro-${RELEASE_VERSION}.jar.asc -C Payara-Micro payara-micro-${RELEASE_VERSION}-sources.jar -C Payara-Micro payara-micro-${RELEASE_VERSION}-sources.jar.asc -C Payara-Micro payara-micro-${RELEASE_VERSION}-javadoc.jar -C Payara-Micro payara-micro-${RELEASE_VERSION}-javadoc.jar.asc -C Payara-Micro payara-micro-${RELEASE_VERSION}.pom -C Payara-Micro payara-micro-${RELEASE_VERSION}.pom.asc

jar -cvf Payara-Embedded-All/bundle.jar -C Payara-Embedded-All payara-embedded-all-${RELEASE_VERSION}.jar -C Payara-Embedded-All payara-embedded-all-${RELEASE_VERSION}.jar.asc -C Payara-Embedded-All payara-embedded-all-${RELEASE_VERSION}-sources.jar -C Payara-Embedded-All payara-embedded-all-${RELEASE_VERSION}-sources.jar.asc -C Payara-Embedded-All payara-embedded-all-${RELEASE_VERSION}-javadoc.jar -C Payara-Embedded-All payara-embedded-all-${RELEASE_VERSION}-javadoc.jar.asc -C Payara-Embedded-All payara-embedded-all-${RELEASE_VERSION}.pom -C Payara-Embedded-All payara-embedded-all-${RELEASE_VERSION}.pom.asc

jar -cvf Payara-Embedded-Web/bundle.jar -C Payara-Embedded-Web payara-embedded-web-${RELEASE_VERSION}.jar -C Payara-Embedded-Web payara-embedded-web-${RELEASE_VERSION}.jar.asc -C Payara-Embedded-Web payara-embedded-web-${RELEASE_VERSION}-sources.jar -C Payara-Embedded-Web payara-embedded-web-${RELEASE_VERSION}-sources.jar.asc -C Payara-Embedded-Web payara-embedded-web-${RELEASE_VERSION}-javadoc.jar -C Payara-Embedded-Web payara-embedded-web-${RELEASE_VERSION}-javadoc.jar.asc -C Payara-Embedded-Web payara-embedded-web-${RELEASE_VERSION}.pom -C Payara-Embedded-Web payara-embedded-web-${RELEASE_VERSION}.pom.asc

jar -cvf Payara-API/bundle.jar -C Payara-API payara-api-${RELEASE_VERSION}.jar -C Payara-API payara-api-${RELEASE_VERSION}.jar.asc -C Payara-API payara-api-${RELEASE_VERSION}-sources.jar -C Payara-API payara-api-${RELEASE_VERSION}-sources.jar.asc -C Payara-API payara-api-${RELEASE_VERSION}-javadoc.jar -C Payara-API payara-api-${RELEASE_VERSION}-javadoc.jar.asc -C Payara-API payara-api-${RELEASE_VERSION}.pom -C Payara-API payara-api-${RELEASE_VERSION}.pom.asc

jar -cvf Payara-EJB-HTTP-Client/bundle.jar -C Payara-EJB-HTTP-Client ejb-http-client-${RELEASE_VERSION}.jar -C Payara-EJB-HTTP-Client ejb-http-client-${RELEASE_VERSION}.jar.asc -C Payara-EJB-HTTP-Client ejb-http-client-${RELEASE_VERSION}-sources.jar -C Payara-EJB-HTTP-Client ejb-http-client-${RELEASE_VERSION}-sources.jar.asc -C Payara-EJB-HTTP-Client ejb-http-client-${RELEASE_VERSION}-javadoc.jar -C Payara-EJB-HTTP-Client ejb-http-client-${RELEASE_VERSION}-javadoc.jar.asc -C Payara-EJB-HTTP-Client ejb-http-client-${RELEASE_VERSION}.pom -C Payara-EJB-HTTP-Client ejb-http-client-${RELEASE_VERSION}.pom.asc

jar -cvf Payara-Appclient/bundle.jar -C Payara-Appclient payara-client-${RELEASE_VERSION}.jar -C Payara-Appclient payara-client-${RELEASE_VERSION}.jar.asc -C Payara-Appclient payara-client-${RELEASE_VERSION}-sources.jar -C Payara-Appclient payara-client-${RELEASE_VERSION}-sources.jar.asc -C Payara-Appclient payara-client-${RELEASE_VERSION}-javadoc.jar -C Payara-Appclient payara-client-${RELEASE_VERSION}-javadoc.jar.asc -C Payara-Appclient payara-client-${RELEASE_VERSION}.pom -C Payara-Appclient payara-client-${RELEASE_VERSION}.pom.asc

jar -cvf Payara-BOM/bundle.jar -C Payara-BOM payara-bom-${RELEASE_VERSION}.pom -C Payara-BOM payara-bom-${RELEASE_VERSION}.pom.asc
