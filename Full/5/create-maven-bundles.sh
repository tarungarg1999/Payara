#!/bin/bash
 
# Read in properties file
. ./release-config.properties
  
##################################################################
 
# Ensure we're using JDK8
export PATH="${JDK8_PATH}/bin:${PATH}:${JDK8_PATH}/bin"
export JAVA_HOME="${JDK8_PATH}"
 
# Sign the Files
gpg2 -ab Payara/payara-${VERSION}.pom
gpg2 -ab Payara/payara-${VERSION}.zip
gpg2 -ab Payara/payara-${VERSION}-sources.jar
gpg2 -ab Payara/payara-${VERSION}-javadoc.jar
 
gpg2 -ab Payara-ML/payara-ml-${VERSION}.pom
gpg2 -ab Payara-ML/payara-ml-${VERSION}.zip
gpg2 -ab Payara-ML/payara-ml-${VERSION}-sources.jar
gpg2 -ab Payara-ML/payara-ml-${VERSION}-javadoc.jar
 
gpg2 -ab Payara-Web/payara-web-${VERSION}.pom
gpg2 -ab Payara-Web/payara-web-${VERSION}.zip
gpg2 -ab Payara-Web/payara-web-${VERSION}-sources.jar
gpg2 -ab Payara-Web/payara-web-${VERSION}-javadoc.jar
 
gpg2 -ab Payara-Web-ML/payara-web-ml-${VERSION}.pom
gpg2 -ab Payara-Web-ML/payara-web-ml-${VERSION}.zip
gpg2 -ab Payara-Web-ML/payara-web-ml-${VERSION}-sources.jar
gpg2 -ab Payara-Web-ML/payara-web-ml-${VERSION}-javadoc.jar
 
gpg2 -ab Payara-Micro/payara-micro-${VERSION}.pom
gpg2 -ab Payara-Micro/payara-micro-${VERSION}.jar
gpg2 -ab Payara-Micro/payara-micro-${VERSION}-sources.jar
gpg2 -ab Payara-Micro/payara-micro-${VERSION}-javadoc.jar
 
gpg2 -ab Payara-Embedded-All/payara-embedded-all-${VERSION}.pom
gpg2 -ab Payara-Embedded-All/payara-embedded-all-${VERSION}.jar
gpg2 -ab Payara-Embedded-All/payara-embedded-all-${VERSION}-sources.jar
gpg2 -ab Payara-Embedded-All/payara-embedded-all-${VERSION}-javadoc.jar
 
gpg2 -ab Payara-Embedded-Web/payara-embedded-web-${VERSION}.pom
gpg2 -ab Payara-Embedded-Web/payara-embedded-web-${VERSION}.jar
gpg2 -ab Payara-Embedded-Web/payara-embedded-web-${VERSION}-sources.jar
gpg2 -ab Payara-Embedded-Web/payara-embedded-web-${VERSION}-javadoc.jar
 
gpg2 -ab Payara-API/payara-api-${VERSION}.pom
gpg2 -ab Payara-API/payara-api-${VERSION}.jar
gpg2 -ab Payara-API/payara-api-${VERSION}-sources.jar
gpg2 -ab Payara-API/payara-api-${VERSION}-javadoc.jar
 
gpg2 -ab Payara-EJB-HTTP-Client/ejb-http-client-${VERSION}.pom
gpg2 -ab Payara-EJB-HTTP-Client/ejb-http-client-${VERSION}.jar
gpg2 -ab Payara-EJB-HTTP-Client/ejb-http-client-${VERSION}-sources.jar
gpg2 -ab Payara-EJB-HTTP-Client/ejb-http-client-${VERSION}-javadoc.jar
 
# Create JAR bundles
jar -cvf Payara/bundle.jar -C Payara payara-${VERSION}.zip -C Payara payara-${VERSION}.zip.asc -C Payara payara-${VERSION}-sources.jar -C Payara payara-${VERSION}-sources.jar.asc -C Payara payara-${VERSION}-javadoc.jar -C Payara payara-${VERSION}-javadoc.jar.asc -C Payara payara-${VERSION}.pom -C Payara payara-${VERSION}.pom.asc
  
jar -cvf Payara-ML/bundle.jar -C Payara-ML payara-ml-${VERSION}.zip -C Payara-ML payara-ml-${VERSION}.zip.asc -C Payara-ML payara-ml-${VERSION}-sources.jar -C Payara-ML payara-ml-${VERSION}-sources.jar.asc -C Payara-ML payara-ml-${VERSION}-javadoc.jar -C Payara-ML payara-ml-${VERSION}-javadoc.jar.asc -C Payara-ML payara-ml-${VERSION}.pom -C Payara-ML payara-ml-${VERSION}.pom.asc
  
jar -cvf Payara-Web/bundle.jar -C Payara-Web payara-web-${VERSION}.zip -C Payara-Web payara-web-${VERSION}.zip.asc -C Payara-Web payara-web-${VERSION}-sources.jar -C Payara-Web payara-web-${VERSION}-sources.jar.asc -C Payara-Web payara-web-${VERSION}-javadoc.jar -C Payara-Web payara-web-${VERSION}-javadoc.jar.asc -C Payara-Web payara-web-${VERSION}.pom -C Payara-Web payara-web-${VERSION}.pom.asc
  
jar -cvf Payara-Web-ML/bundle.jar -C Payara-Web-ML payara-web-ml-${VERSION}.zip -C Payara-Web-ML payara-web-ml-${VERSION}.zip.asc -C Payara-Web-ML payara-web-ml-${VERSION}-sources.jar -C Payara-Web-ML payara-web-ml-${VERSION}-sources.jar.asc -C Payara-Web-ML payara-web-ml-${VERSION}-javadoc.jar -C Payara-Web-ML payara-web-ml-${VERSION}-javadoc.jar.asc -C Payara-Web-ML payara-web-ml-${VERSION}.pom -C Payara-Web-ML payara-web-ml-${VERSION}.pom.asc
  
jar -cvf Payara-Micro/bundle.jar -C Payara-Micro payara-micro-${VERSION}.jar -C Payara-Micro payara-micro-${VERSION}.jar.asc -C Payara-Micro payara-micro-${VERSION}-sources.jar -C Payara-Micro payara-micro-${VERSION}-sources.jar.asc -C Payara-Micro payara-micro-${VERSION}-javadoc.jar -C Payara-Micro payara-micro-${VERSION}-javadoc.jar.asc -C Payara-Micro payara-micro-${VERSION}.pom -C Payara-Micro payara-micro-${VERSION}.pom.asc
  
jar -cvf Payara-Embedded-All/bundle.jar -C Payara-Embedded-All payara-embedded-all-${VERSION}.jar -C Payara-Embedded-All payara-embedded-all-${VERSION}.jar.asc -C Payara-Embedded-All payara-embedded-all-${VERSION}-sources.jar -C Payara-Embedded-All payara-embedded-all-${VERSION}-sources.jar.asc -C Payara-Embedded-All payara-embedded-all-${VERSION}-javadoc.jar -C Payara-Embedded-All payara-embedded-all-${VERSION}-javadoc.jar.asc -C Payara-Embedded-All payara-embedded-all-${VERSION}.pom -C Payara-Embedded-All payara-embedded-all-${VERSION}.pom.asc
  
jar -cvf Payara-Embedded-Web/bundle.jar -C Payara-Embedded-Web payara-embedded-web-${VERSION}.jar -C Payara-Embedded-Web payara-embedded-web-${VERSION}.jar.asc -C Payara-Embedded-Web payara-embedded-web-${VERSION}-sources.jar -C Payara-Embedded-Web payara-embedded-web-${VERSION}-sources.jar.asc -C Payara-Embedded-Web payara-embedded-web-${VERSION}-javadoc.jar -C Payara-Embedded-Web payara-embedded-web-${VERSION}-javadoc.jar.asc -C Payara-Embedded-Web payara-embedded-web-${VERSION}.pom -C Payara-Embedded-Web payara-embedded-web-${VERSION}.pom.asc
  
jar -cvf Payara-API/bundle.jar -C Payara-API payara-api-${VERSION}.jar -C Payara-API payara-api-${VERSION}.jar.asc -C Payara-API payara-api-${VERSION}-sources.jar -C Payara-API payara-api-${VERSION}-sources.jar.asc -C Payara-API payara-api-${VERSION}-javadoc.jar -C Payara-API payara-api-${VERSION}-javadoc.jar.asc -C Payara-API payara-api-${VERSION}.pom -C Payara-API payara-api-${VERSION}.pom.asc

jar -cvf Payara-EJB-HTTP-Client.jar -C Payara-EJB-HTTP-Client ejb-http-client-${VERSION}.jar -C Payara-EJB-HTTP-Client ejb-http-client-${VERSION}.jar.asc -C Payara-EJB-HTTP-Client ejb-http-client-${VERSION}-sources.jar -C Payara-EJB-HTTP-Client ejb-http-client-${VERSION}-sources.jar.asc -C Payara-EJB-HTTP-Client ejb-http-client-${VERSION}-javadoc.jar -C Payara-EJB-HTTP-Client ejb-http-client-${VERSION}-javadoc.jar.asc -C Payara-EJB-HTTP-Client ejb-http-client-${VERSION}.pom -C Payara-EJB-HTTP-Client ejb-http-client-${VERSION}.pom.asc
