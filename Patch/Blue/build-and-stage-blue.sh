#!/bin/sh
 
#############################################################################
 
# Read in properties file
. ./release-config.properties
 
#############################################################################
 
### Create branches, Update version, and Build ###
# Move to Git Repo
cd ${REPO_DIR}
  
# Reset and Cleanup
git reset --hard HEAD
git clean -fdx
  
# Update Branches
git fetch ${GITHUB_REMOTE}
git fetch ${BITBUCKET_REMOTE}
git checkout Payara4
git pull ${GITHUB_REMOTE} Payara4
git checkout payara-blue
git pull ${GITHUB_REMOTE} payara-blue
git checkout payara-blue-${MAINTENANCE_VERSION}.maintenance
git pull ${BITBUCKET_REMOTE} payara-blue-${MAINTENANCE_VERSION}.maintenance
  
# Create new branch
git branch -D PAYARA-${JIRA_NUMBER}-Blue-${VERSION}-Release
git branch PAYARA-${JIRA_NUMBER}-Blue-${VERSION}-Release
git checkout PAYARA-${JIRA_NUMBER}-Blue-${VERSION}-Release
  
# Increment Versions
find . -name "pom.xml" -print0 | xargs -0 sed -i "s/${ESCAPED_OLD_VERSION}/${ESCAPED_VERSION}/g"
sed -i "s/payara_update_version>${OLD_UPDATE_VERSION}</payara_update_version>${UPDATE_VERSION}</g" appserver/pom.xml
sed -i "s/payara_update_version=${OLD_UPDATE_VERSION}/payara_update_version=${UPDATE_VERSION}/g" appserver/extras/payara-micro/payara-micro-boot/src/main/resources/MICRO-INF/domain/branding/glassfish-version.properties
  
# Commit changes
git commit -a -m "PAYARA-${JIRA_NUMBER} Increment version numbers"
git tag -d payara-blue-${VERSION}.RC${RC_VERSION}
git tag payara-blue-${VERSION}.RC${RC_VERSION}
  
# Push changes
git push ${BITBUCKET_REMOTE} PAYARA-${JIRA_NUMBER}-Blue-${VERSION}-Release --force
git push ${BITBUCKET_REMOTE} payara-blue-${VERSION}.RC${RC_VERSION} --force
 
# Ensure we're using JDK8
export PATH="${JDK8_PATH}/bin:${PATH}:${JDK8_PATH}/bin"
export JAVA_HOME="${JDK8_PATH}"
 
# Build
MAVEN_OPTS="-Xmx3G -Djavax.net.ssl.trustStore=${JAVA_HOME}/jre/lib/security/cacerts -Djdk.tls.client.protocols=TLSv1,TLSv1.1,TLSv1.2 -Dhttps.protocols=TLSv1,TLSv1.1,TLSv1.2" \
mvn clean install -PBuildExtras -Dbuild.number=${BUILD_NUMBER}
  
# Move back
cd -
 
################################################################################
  
# Create ReleaseDirs
mkdir Payara-Blue
mkdir Payara-Blue-Web
mkdir Payara-Blue-ML
mkdir Payara-Blue-Web-ML
mkdir Payara-Blue-Micro
mkdir Payara-Blue-Embedded-All
mkdir Payara-Blue-Embedded-Web
mkdir SourceExport-Blue
  
# Copy Distributions
cp ${REPO_DIR}/appserver/distributions/payara/target/payara.zip Payara-Blue/
cp ${REPO_DIR}/appserver/distributions/payara-ml/target/payara-ml.zip Payara-Blue-ML/
cp ${REPO_DIR}/appserver/distributions/payara-web/target/payara-web.zip Payara-Blue-Web/
cp ${REPO_DIR}/appserver/distributions/payara-web-ml/target/payara-web-ml.zip Payara-Blue-Web-ML/
cp ${REPO_DIR}/appserver/extras/payara-micro/payara-micro-distribution/target/payara-micro.jar Payara-Blue-Micro/
cp ${REPO_DIR}/appserver/extras/embedded/all/target/payara-embedded-all.jar Payara-Blue-Embedded-All/
cp ${REPO_DIR}/appserver/extras/embedded/web/target/payara-embedded-web.jar Payara-Blue-Embedded-Web/
  
# Rename and NetBeans fix
cd Payara-Blue
unzip payara.zip
mv payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-${VERSION}.jar payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-4.1.jar
zip -r payara-${VERSION}.zip payara41/
tar -czvf payara-${VERSION}.tar.gz payara41/
rm -rf payara41
rm -rf payara.zip
cd ..
  
cd Payara-Blue-Web
unzip payara-web.zip
mv payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-${VERSION}.jar payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-4.1.jar
zip -r payara-web-${VERSION}.zip payara41/
tar -czvf payara-web-${VERSION}.tar.gz payara41/
rm -rf payara41
rm -rf payara-web.zip
cd ..
  
cd Payara-Blue-ML
unzip payara-ml.zip
mv payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-${VERSION}.jar payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-4.1.jar
zip -r payara-ml-${VERSION}.zip payara41/
tar -czvf payara-ml-${VERSION}.tar.gz payara41/
rm -rf payara41
rm -rf payara-ml.zip
cd ..
  
cd Payara-Blue-Web-ML
unzip payara-web-ml.zip
mv payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-${VERSION}.jar payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-4.1.jar
zip -r payara-web-ml-${VERSION}.zip payara41/
tar -czvf payara-web-ml-${VERSION}.tar.gz payara41/
rm -rf payara41
rm -rf payara-web-ml.zip
cd ..
   
cd Payara-Blue-Micro
mv payara-micro.jar payara-micro-${VERSION}.jar
rm -rf payara-micro.jar
cd ..
   
cd Payara-Blue-Embedded-All
mv payara-embedded-all.jar payara-embedded-all-${VERSION}.jar
rm -rf payara-embedded-all.jar
cd ..
   
cd Payara-Blue-Embedded-Web
mv payara-embedded-web.jar payara-embedded-web-${VERSION}.jar
rm -rf payara-embedded-web.jar
cd ..
  
# Create Source and Javadoc
cd ${REPO_DIR}
mvn pre-site -Psource
cd -
 
 
#################################################################################
 
RELEASE_DIR=$(pwd)
 
# Copy Source and Javadoc
cp ${REPO_DIR}/target/payara-${VERSION}-sources.jar Payara-Blue/payara-${VERSION}-sources.jar
cp ${REPO_DIR}/target/payara-${VERSION}-sources.jar Payara-Blue-ML/payara-ml-${VERSION}-sources.jar
cp ${REPO_DIR}/target/payara-${VERSION}-sources.jar Payara-Blue-Web/payara-web-${VERSION}-sources.jar
cp ${REPO_DIR}/target/payara-${VERSION}-sources.jar Payara-Blue-Web-ML/payara-web-ml-${VERSION}-sources.jar
cp ${REPO_DIR}/target/payara-${VERSION}-sources.jar Payara-Blue-Micro/payara-micro-${VERSION}-sources.jar
cp ${REPO_DIR}/target/payara-${VERSION}-sources.jar Payara-Blue-Embedded-All/payara-embedded-all-${VERSION}-sources.jar
cp ${REPO_DIR}/target/payara-${VERSION}-sources.jar Payara-Blue-Embedded-Web/payara-embedded-web-${VERSION}-sources.jar
 
# Export Source
cd ${REPO_DIR}
git archive --format zip --output ${RELEASE_DIR}/SourceExport-Blue/payara-source-${VERSION}.zip Payara-Blue-${VERSION}-Release
cd ${RELEASE_DIR}
 
# Create Base POM
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > pom.xml
echo "<!--" >> pom.xml
echo "  " >> pom.xml
echo "    DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER." >> pom.xml
echo "  " >> pom.xml
echo "    Copyright (c) 1997-2014 Oracle and/or its affiliates. All rights reserved." >> pom.xml
echo "  " >> pom.xml
echo "   The contents of this file are subject to the terms of either the GNU" >> pom.xml
echo "   General Public License Version 2 only (\"GPL\") or the Common Development" >> pom.xml
echo "   and Distribution License(\"CDDL\") (collectively, the "License").  You" >> pom.xml
echo "   may not use this file except in compliance with the License.  You can" >> pom.xml
echo "   obtain a copy of the License at" >> pom.xml
echo "   https://glassfish.dev.java.net/public/CDDL+GPL_1_1.html" >> pom.xml
echo "   or packager/legal/LICENSE.txt.  See the License for the specific" >> pom.xml
echo "   language governing permissions and limitations under the License." >> pom.xml
echo " " >> pom.xml
echo "   When distributing the software, include this License Header Notice in each" >> pom.xml
echo "   file and include the License file at packager/legal/LICENSE.txt." >> pom.xml
echo " " >> pom.xml
echo "   GPL Classpath Exception:" >> pom.xml
echo "   Oracle designates this particular file as subject to the \"Classpath\"" >> pom.xml
echo "   exception as provided by Oracle in the GPL Version 2 section of the License" >> pom.xml
echo "   file that accompanied this code." >> pom.xml
echo " " >> pom.xml
echo "   Modifications:" >> pom.xml
echo "   If applicable, add the following below the License Header, with the fields" >> pom.xml
echo "   enclosed by brackets [] replaced by your own identifying information:" >> pom.xml
echo "   \"Portions Copyright [year] [name of copyright owner]\"" >> pom.xml
echo " " >> pom.xml
echo "   Contributor(s):" >> pom.xml
echo "   If you wish your version of this file to be governed by only the CDDL or" >> pom.xml
echo "   only the GPL Version 2, indicate your decision by adding \"[Contributor]" >> pom.xml
echo "   elects to include this software in this distribution under the [CDDL or GPL" >> pom.xml
echo "   Version 2] license.\"  If you don't indicate a single choice of license, a" >> pom.xml
echo "   recipient has the option to distribute your version of this file under" >> pom.xml
echo "   either the CDDL, the GPL Version 2 or to extend the choice of license to" >> pom.xml
echo "   its licensees as provided above.  However, if you add GPL Version 2 code" >> pom.xml
echo "   and therefore, elected the GPL Version 2 license, then the option applies" >> pom.xml
echo "   only if the new code is made subject to such option by the copyright" >> pom.xml
echo "   holder." >> pom.xml
echo " " >> pom.xml
echo "-->" >> pom.xml
echo "<!-- Portions Copyright [2016-2018] [Payara Foundation] -->" >> pom.xml
echo "<project xmlns=\"http://maven.apache.org/POM/4.0.0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://maven.apache.org/POM/4.0.0http://maven.apache.org/maven-v4_0_0.xsd\">" >> pom.xml
echo "  <modelVersion>4.0.0</modelVersion>" >> pom.xml
echo "  " >> pom.xml
echo "  <groupId>fish.payara.distributions</groupId>" >> pom.xml
echo "  <artifactId>payara</artifactId>" >> pom.xml
echo "  <version>4.1.1.171.0.1</version>" >> pom.xml
echo "  <name>Payara Server</name>" >> pom.xml
echo "  <packaging>zip</packaging>" >> pom.xml
echo "  " >> pom.xml
echo "  <description>Full Distribution of the Payara Project</description>" >> pom.xml
echo "  <url>https://github.com/payara/Payara</url>" >> pom.xml
echo "" >> pom.xml
echo "" >> pom.xml
echo "  <scm>" >> pom.xml
echo "      <connection>scm:git:git@github.com:payara/payara.git</connection>" >> pom.xml
echo "      <url>scm:git:git@github.com:payara/payara.git</url>" >> pom.xml
echo "      <developerConnection>scm:git:git@github.com:payara/payara.git</developerConnection>" >> pom.xml
echo "      <tag>payara-server-4.1.1.171.0.1</tag>" >> pom.xml
echo "  </scm>" >> pom.xml
echo "  " >> pom.xml
echo "  <licenses>" >> pom.xml
echo "      <license>" >> pom.xml
echo "          <name>CDDL + GPLv2 with classpath exception</name>" >> pom.xml
echo "          <url>http://glassfish.java.net/nonav/public/CDDL+GPL.html</url>" >> pom.xml
echo "          <distribution>repo</distribution>" >> pom.xml
echo "          <comments>A business-friendly OSS license</comments>" >> pom.xml
echo "      </license>" >> pom.xml
echo "  </licenses>" >> pom.xml
echo "  " >> pom.xml
echo "  <developers>" >> pom.xml
echo "      <developer>" >> pom.xml
echo "          <name>Payara Team</name>" >> pom.xml
echo "          <email>info@payara.fish</email>" >> pom.xml
echo "          <organization>Payara Foundation</organization>" >> pom.xml
echo "          <organizationUrl>http://www.payara.fish</organizationUrl>" >> pom.xml
echo "      </developer>" >> pom.xml
echo "  </developers>" >> pom.xml
echo "  " >> pom.xml
echo "</project>" >> pom.xml
 
# Create POM Files
cp pom.xml Payara-Blue/payara-${VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara</g" Payara-Blue/payara-${VERSION}.pom
sed -i "s/groupId>fish.payara.distributions</groupId>fish.payara.blue.distributions</g" Payara-Blue/payara-${VERSION}.pom
sed -i "s/version>${OLD_VERSION}</version>${VERSION}</g" Payara-Blue/payara-${VERSION}.pom
sed -i "s/tag>payara-server-${OLD_VERSION}</tag>payara-blue-${VERSION}</g" Payara-Blue/payara-${VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Blue</g" Payara-Blue/payara-${VERSION}.pom
sed -i "s/packaging>zip</packaging>zip</g" Payara-Blue/payara-${VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Full Distribution of the Payara Project for IBM JDK</g" Payara-Blue/payara-${VERSION}.pom
  
cp pom.xml Payara-Blue-ML/payara-ml-${VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-ml</g" Payara-Blue-ML/payara-ml-${VERSION}.pom
sed -i "s/groupId>fish.payara.distributions</groupId>fish.payara.blue.distributions</g" Payara-Blue-ML/payara-ml-${VERSION}.pom
sed -i "s/version>${OLD_VERSION}</version>${VERSION}</g" Payara-Blue-ML/payara-ml-${VERSION}.pom
sed -i "s/tag>payara-server-${OLD_VERSION}</tag>payara-blue-${VERSION}</g" Payara-Blue-ML/payara-ml-${VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Blue ML</g" Payara-Blue-ML/payara-ml-${VERSION}.pom
sed -i "s/packaging>zip</packaging>zip</g" Payara-Blue-ML/payara-ml-${VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Full ML Distribution of the Payara Project for IBM JDK</g" Payara-Blue-ML/payara-ml-${VERSION}.pom
  
cp pom.xml Payara-Blue-Web/payara-web-${VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-web</g" Payara-Blue-Web/payara-web-${VERSION}.pom
sed -i "s/groupId>fish.payara.distributions</groupId>fish.payara.blue.distributions</g" Payara-Blue-Web/payara-web-${VERSION}.pom
sed -i "s/version>${OLD_VERSION}</version>${VERSION}</g" Payara-Blue-Web/payara-web-${VERSION}.pom
sed -i "s/tag>payara-server-${OLD_VERSION}</tag>payara-blue-${VERSION}</g" Payara-Blue-Web/payara-web-${VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Blue</g" Payara-Blue-Web/payara-web-${VERSION}.pom
sed -i "s/packaging>zip</packaging>zip</g" Payara-Blue-Web/payara-web-${VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Web Distribution of the Payara Project for IBM JDK</g" Payara-Blue-Web/payara-web-${VERSION}.pom
  
cp pom.xml Payara-Blue-Web-ML/payara-web-ml-${VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-web-ml</g" Payara-Blue-Web-ML/payara-web-ml-${VERSION}.pom
sed -i "s/groupId>fish.payara.distributions</groupId>fish.payara.blue.distributions</g" Payara-Blue-Web-ML/payara-web-ml-${VERSION}.pom
sed -i "s/version>${OLD_VERSION}</version>${VERSION}</g" Payara-Blue-Web-ML/payara-web-ml-${VERSION}.pom
sed -i "s/tag>payara-server-${OLD_VERSION}</tag>payara-blue-${VERSION}</g" Payara-Blue-Web-ML/payara-web-ml-${VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Blue ML</g" Payara-Blue-Web-ML/payara-web-ml-${VERSION}.pom
sed -i "s/packaging>zip</packaging>zip</g" Payara-Blue-Web-ML/payara-web-ml-${VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Web ML Distribution of the Payara Project for IBM JDK</g" Payara-Blue-Web-ML/payara-web-ml-${VERSION}.pom
  
cp pom.xml Payara-Blue-Micro/payara-micro-${VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-micro</g" Payara-Blue-Micro/payara-micro-${VERSION}.pom
sed -i "s/groupId>fish.payara.distributions</groupId>fish.payara.blue.extras</g" Payara-Blue-Micro/payara-micro-${VERSION}.pom
sed -i "s/version>${OLD_VERSION}</version>${VERSION}</g" Payara-Blue-Micro/payara-micro-${VERSION}.pom
sed -i "s/tag>payara-server-${OLD_VERSION}</tag>payara-blue-${VERSION}</g" Payara-Blue-Micro/payara-micro-${VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Blue Micro</g" Payara-Blue-Micro/payara-micro-${VERSION}.pom
sed -i "s/packaging>zip</packaging>jar</g" Payara-Blue-Micro/payara-micro-${VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Micro Distribution of the Payara Project for IBM JDK</g" Payara-Blue-Micro/payara-micro-${VERSION}.pom
  
cp pom.xml Payara-Blue-Embedded-All/payara-embedded-all-${VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-embedded-all</g" Payara-Blue-Embedded-All/payara-embedded-all-${VERSION}.pom
sed -i "s/groupId>fish.payara.distributions</groupId>fish.payara.blue.extras</g" Payara-Blue-Embedded-All/payara-embedded-all-${VERSION}.pom
sed -i "s/version>${OLD_VERSION}</version>${VERSION}</g" Payara-Blue-Embedded-All/payara-embedded-all-${VERSION}.pom
sed -i "s/tag>payara-server-${OLD_VERSION}</tag>payara-blue-${VERSION}</g" Payara-Blue-Embedded-All/payara-embedded-all-${VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Blue Embedded-All</g" Payara-Blue-Embedded-All/payara-embedded-all-${VERSION}.pom
sed -i "s/packaging>zip</packaging>jar</g" Payara-Blue-Embedded-All/payara-embedded-all-${VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Embedded-All Distribution of the Payara Project for IBM JDK</g" Payara-Blue-Embedded-All/payara-embedded-all-${VERSION}.pom
  
cp pom.xml Payara-Blue-Embedded-Web/payara-embedded-web-${VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-embedded-web</g" Payara-Blue-Embedded-Web/payara-embedded-web-${VERSION}.pom
sed -i "s/groupId>fish.payara.distributions</groupId>fish.payara.blue.extras</g" Payara-Blue-Embedded-Web/payara-embedded-web-${VERSION}.pom
sed -i "s/version>${OLD_VERSION}</version>${VERSION}</g" Payara-Blue-Embedded-Web/payara-embedded-web-${VERSION}.pom
sed -i "s/tag>payara-server-${OLD_VERSION}</tag>payara-blue-${VERSION}</g" Payara-Blue-Embedded-Web/payara-embedded-web-${VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Blue Embedded-Web</g" Payara-Blue-Embedded-Web/payara-embedded-web-${VERSION}.pom
sed -i "s/packaging>zip</packaging>jar</g" Payara-Blue-Embedded-Web/payara-embedded-web-${VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Embedded-Web Distribution of the Payara Project for IBM JDK</g" Payara-Blue-Embedded-Web/payara-embedded-web-${VERSION}.pom
 
################################################################################
 
# Building JDK7 release
 
echo "Switch to JDK7"
export PATH="${JDK7_PATH}/bin:${PATH}:${JDK7_PATH}/bin"
export JAVA_HOME="${JDK7_PATH}"
 
cd ${REPO_DIR}
 
MAVEN_OPTS="-Xmx2G -XX:MaxPermSize=512m -Djavax.net.ssl.trustStore=${JAVA_HOME}/jre/lib/security/cacerts -Djdk.tls.client.protocols=TLSv1,TLSv1.1,TLSv1.2 -Dhttps.protocols=TLSv1,TLSv1.1,TLSv1.2" \
mvn clean install -PBuildExtras -Dbuild.number=${BUILD_NUMBER}
 
cd -
 
echo "Switch back to JDK8"
export PATH="${JDK8_PATH}/bin:${PATH}:${JDK8_PATH}/bin"
export JAVA_HOME="${JDK8_PATH}"
 
################################################################################
  
# Copy JDK7 Distributions
cp ${REPO_DIR}/appserver/distributions/payara/target/payara.zip Payara-Blue/
cp ${REPO_DIR}/appserver/distributions/payara-ml/target/payara-ml.zip Payara-Blue-ML/
cp ${REPO_DIR}/appserver/distributions/payara-web/target/payara-web.zip Payara-Blue-Web/
cp ${REPO_DIR}/appserver/distributions/payara-web-ml/target/payara-web-ml.zip Payara-Blue-Web-ML/
cp ${REPO_DIR}/appserver/extras/payara-micro/payara-micro-distribution/target/payara-micro.jar Payara-Blue-Micro/
cp ${REPO_DIR}/appserver/extras/embedded/all/target/payara-embedded-all.jar Payara-Blue-Embedded-All/
cp ${REPO_DIR}/appserver/extras/embedded/web/target/payara-embedded-web.jar Payara-Blue-Embedded-Web/
  
# Rename JDK7 Releases and NetBeans Fix
cd Payara-Blue
unzip payara.zip
mv payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-${VERSION}.jar payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-4.1.jar
zip -r payara-${VERSION}-jdk7.zip payara41/
tar -czvf payara-${VERSION}-jdk7.tar.gz payara41/
rm -rf payara41
rm -rf payara.zip
cd ..
    
cd Payara-Blue-Web
unzip payara-web.zip
mv payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-${VERSION}.jar payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-4.1.jar
zip -r payara-web-${VERSION}-jdk7.zip payara41/
tar -czvf payara-web-${VERSION}-jdk7.tar.gz payara41/
rm -rf payara41
rm -rf payara-web.zip
cd ..
    
cd Payara-Blue-ML
unzip payara-ml.zip
mv payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-${VERSION}.jar payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-4.1.jar
zip -r payara-ml-${VERSION}-jdk7.zip payara41/
tar -czvf payara-ml-${VERSION}-jdk7.tar.gz payara41/
rm -rf payara41
rm -rf payara-ml.zip
cd ..
    
cd Payara-Blue-Web-ML
unzip payara-web-ml.zip
mv payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-${VERSION}.jar payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-4.1.jar
zip -r payara-web-ml-${VERSION}-jdk7.zip payara41/
tar -czvf payara-web-ml-${VERSION}-jdk7.tar.gz payara41/
rm -rf payara41
rm -rf payara-web-ml.zip
cd ..
   
cd Payara-Blue-Micro
mv payara-micro.jar payara-micro-${VERSION}-jdk7.jar
rm -rf payara-micro.jar
cd ..
   
cd Payara-Blue-Embedded-All
mv payara-embedded-all.jar payara-embedded-all-${VERSION}-jdk7.jar
rm -rf payara-embedded-all.jar
cd ..
   
cd Payara-Blue-Embedded-Web
mv payara-embedded-web.jar payara-embedded-web-${VERSION}-jdk7.jar
rm -rf payara-embedded-web.jar
cd ..
  
# Upload to Nexus Staging
rm pom.xml
   
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue/payara-${VERSION}.zip -Dsources=Payara-Blue/payara-${VERSION}-sources.jar -DpomFile=Payara-Blue/payara-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue/payara-${VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara-Blue/payara-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue/payara-${VERSION}.tar.gz -DpomFile=Payara-Blue/payara-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore -Dpackaging=tar.gz
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue/payara-${VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara-Blue/payara-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore -Dpackaging=tar.gz
    
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue-ML/payara-ml-${VERSION}.zip -Dsources=Payara-Blue-ML/payara-ml-${VERSION}-sources.jar -DpomFile=Payara-Blue-ML/payara-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue-ML/payara-ml-${VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara-Blue-ML/payara-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue-ML/payara-ml-${VERSION}.tar.gz -DpomFile=Payara-Blue-ML/payara-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore -Dpackaging=tar.gz
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue-ML/payara-ml-${VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara-Blue-ML/payara-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore -Dpackaging=tar.gz
    
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue-Web/payara-web-${VERSION}.zip -Dsources=Payara-Blue-Web/payara-web-${VERSION}-sources.jar -DpomFile=Payara-Blue-Web/payara-web-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue-Web/payara-web-${VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara-Blue-Web/payara-web-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue-Web/payara-web-${VERSION}.tar.gz -DpomFile=Payara-Blue-Web/payara-web-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore -Dpackaging=tar.gz
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue-Web/payara-web-${VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara-Blue-Web/payara-web-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore -Dpackaging=tar.gz
    
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue-Web-ML/payara-web-ml-${VERSION}.zip -Dsources=Payara-Blue-Web-ML/payara-web-ml-${VERSION}-sources.jar -DpomFile=Payara-Blue-Web-ML/payara-web-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue-Web-ML/payara-web-ml-${VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara-Blue-Web-ML/payara-web-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue-Web-ML/payara-web-ml-${VERSION}.tar.gz -DpomFile=Payara-Blue-Web-ML/payara-web-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore -Dpackaging=tar.gz
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue-Web-ML/payara-web-ml-${VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara-Blue-Web-ML/payara-web-ml-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore -Dpackaging=tar.gz
   
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue-Micro/payara-micro-${VERSION}.jar -Dsources=Payara-Blue-Micro/payara-micro-${VERSION}-sources.jar -DpomFile=Payara-Blue-Micro/payara-micro-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue-Micro/payara-micro-${VERSION}-jdk7.jar -Dclassifier=jdk7 -DpomFile=Payara-Blue-Micro/payara-micro-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore
   
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue-Embedded-All/payara-embedded-all-${VERSION}.jar -Dsources=Payara-Blue-Embedded-All/payara-embedded-all-${VERSION}-sources.jar -DpomFile=Payara-Blue-Embedded-All/payara-embedded-all-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue-Embedded-All/payara-embedded-all-${VERSION}-jdk7.jar -Dclassifier=jdk7 -DpomFile=Payara-Blue-Embedded-All/payara-embedded-all-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore
   
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue-Embedded-Web/payara-embedded-web-${VERSION}.jar -Dsources=Payara-Blue-Embedded-Web/payara-embedded-web-${VERSION}-sources.jar -DpomFile=Payara-Blue-Embedded-Web/payara-embedded-web-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore
mvn deploy:deploy-file -Dversion=${VERSION}.RC${RC_VERSION} -Dfile=Payara-Blue-Embedded-Web/payara-embedded-web-${VERSION}-jdk7.jar -Dclassifier=jdk7 -DpomFile=Payara-Blue-Embedded-Web/payara-embedded-web-${VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore
   
mvn deploy:deploy-file -DgroupId=fish.payara.blue.extras -DartifactId=payara-source -Dversion=${VERSION}.RC${RC_VERSION} -Dpackaging=zip -Dfile=SourceExport-Blue/payara-source-${VERSION}.zip -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=/tmp/mavenKeystore
