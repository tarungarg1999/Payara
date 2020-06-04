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
git fetch ${MASTER_REMOTE}
git checkout ${MASTER_REMOTE}/master
  
# Create new branch
git branch -D QACI-${JIRA_NUMBER}-Payara-${NEW_MAJOR_VERSION}.${NEW_MINOR_VERSION}.${NEW_PATCH_VERSION}-Release
git branch QACI-${JIRA_NUMBER}-Payara-${NEW_MAJOR_VERSION}.${NEW_MINOR_VERSION}.${NEW_PATCH_VERSION}-Release
git checkout QACI-${JIRA_NUMBER}-Payara-${NEW_MAJOR_VERSION}.${NEW_MINOR_VERSION}.${NEW_PATCH_VERSION}-Release
  
# Increment Versions
find . -name "pom.xml" -print0 | xargs -0 sed -i "s/${ESCAPED_CURRENT_VERSION}/${NEW_MAJOR_VERSION}\.${NEW_MINOR_VERSION}\.${NEW_PATCH_VERSION}/g"
sed -i "s/minor_version>${CURRENT_PATCH_VERSION}-SNAPSHOT</minor_version>${NEW_PATCH_VERSION}</g" appserver/pom.xml
sed -i "s/minor_version=${CURRENT_PATCH_VERSION}-SNAPSHOT/minor_version=${NEW_PATCH_VERSION}/g" appserver/extras/payara-micro/payara-micro-boot/src/main/resources/MICRO-INF/domain/branding/glassfish-version.properties
sed -i "s/${ESCAPED_CURRENT_VERSION}/${NEW_MAJOR_VERSION}\.${NEW_MINOR_VERSION}\.${NEW_PATCH_VERSION}/g" appserver/packager/appserver-base/src/main/docs/README.txt
sed -i "s/${CURRENT_PATCH_VERSION}/${NEW_PATCH_VERSION}/g" appserver/packager/appserver-base/src/main/docs/README.txt
  
# Commit changes
git commit -a -m "QACI-${JIRA_NUMBER} Increment version numbers"
git tag -d payara-server-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.RC${RC_VERSION}
git tag payara-server-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.RC${RC_VERSION}
  
# Push changes
git push ${MASTER_REMOTE} QACI-${JIRA_NUMBER}-Payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-Release --force
git push ${MASTER_REMOTE} payara-server-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.RC${RC_VERSION} --force
  
# Create Version Increment Branch
git branch -D QACI-${JIRA_NUMBER}-Increment-Version-Numbers-${FUTURE_VERSION}
git checkout master
git checkout -b QACI-${JIRA_NUMBER}-Increment-Version-Numbers-${FUTURE_VERSION}
  
# Update Version Numbers for master branch
find . -name "pom.xml" -print0 | xargs -0 sed -i "s/${ESCAPED_CURRENT_VERSION}/${ESCAPED_FUTURE_VERSION}-SNAPSHOT/g"
sed -i "s/minor_version>${CURRENT_PATCH_VERSION}-SNAPSHOT</minor_version>${FUTURE_PATCH_VERSION}}</g" appserver/pom.xml
sed -i "s/minor_version=${CURRENT_PATCH_VERSION}-SNAPSHOT/minor_version=${FUTURE_PATCH_VERSION}-SNAPSHOT/g" appserver/extras/payara-micro/payara-micro-boot/src/main/resources/MICRO-INF/domain/branding/glassfish-version.properties
sed -i "s/${ESCAPED_CURRENT_VERSION}/${ESCAPED_FUTURE_VERSION}/g" appserver/packager/appserver-base/src/main/docs/README.txt
sed -i "s/${CURRENT_PATCH_VERSION}/${ESCAPED_FUTURE_VERSION}/g" appserver/packager/appserver-base/src/main/docs/README.txt

# Commit and push
git commit -a -m "QACI-${JIRA_NUMBER} Increment version numbers"
git push ${MASTER_REMOTE} QACI-${JIRA_NUMBER}-Increment-Version-Numbers-${FUTURE_VERSION} --force
  
# Checkout Release Branch again
git checkout QACI-${JIRA_NUMBER}-Payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-Release
 
# Ensure we're using JDK8
export PATH="${JDK8_PATH}/bin:${PATH}:${JDK8_PATH}/bin"
export JAVA_HOME="${JDK8_PATH}"
 
# Build
MAVEN_OPTS="-Xmx2G -Djavax.net.ssl.trustStore=${JAVA_HOME}/jre/lib/security/cacerts" \
mvn clean install -PBuildExtras -Dbuild.number=${BUILD_NUMBER} -U
  
# Move back
cd -
 
################################################################################
  
# Create ReleaseDirs
mkdir Payara
mkdir Payara-Web
mkdir Payara-ML
mkdir Payara-Web-ML
mkdir Payara-Micro
mkdir Payara-Embedded-All
mkdir Payara-Embedded-Web
mkdir SourceExport
mkdir Payara-API
mkdir Payara-EJB-HTTP-Client
mkdir Payara-Appclient
mkdir Payara-BOM
  
# Copy Distributions
cp ${REPO_DIR}/appserver/distributions/payara/target/payara.zip Payara/
cp ${REPO_DIR}/appserver/distributions/payara-ml/target/payara-ml.zip Payara-ML/
cp ${REPO_DIR}/appserver/distributions/payara-web/target/payara-web.zip Payara-Web/
cp ${REPO_DIR}/appserver/distributions/payara-web-ml/target/payara-web-ml.zip Payara-Web-ML/
cp ${REPO_DIR}/appserver/extras/payara-micro/payara-micro-distribution/target/payara-micro.jar Payara-Micro/
cp ${REPO_DIR}/appserver/extras/embedded/all/target/payara-embedded-all.jar Payara-Embedded-All/
cp ${REPO_DIR}/appserver/extras/embedded/web/target/payara-embedded-web.jar Payara-Embedded-Web/
  
# Rename and NetBeans fix
cd Payara
unzip payara.zip
zip -r payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.zip payara5/
tar -czvf payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.tar.gz payara5/

# Create and copy appclient
./payara5/glassfish/bin/package-appclient
cp payara5/glassfish/lib/appclient.jar ../Payara-Appclient/payara-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.jar

# Cleanup
rm -rf payara5
rm -rf payara.zip
cd ..
   
cd Payara-Web
unzip payara-web.zip
zip -r payara-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.zip payara5/
tar -czvf payara-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.tar.gz payara5/
rm -rf payara5
rm -rf payara-web.zip
cd ..
   
cd Payara-ML
unzip payara-ml.zip
zip -r payara-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.zip payara5/
tar -czvf payara-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.tar.gz payara5/
rm -rf payara5
rm -rf payara-ml.zip
cd ..
   
cd Payara-Web-ML
unzip payara-web-ml.zip
zip -r payara-web-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.zip payara5/
tar -czvf payara-web-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.tar.gz payara5/
rm -rf payara5
rm -rf payara-web-ml.zip
cd ..
   
cd Payara-Micro
mv payara-micro.jar payara-micro-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.jar
rm -rf payara-micro.jar
cd ..
   
cd Payara-Embedded-All
mv payara-embedded-all.jar payara-embedded-all-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.jar
rm -rf payara-embedded-all.jar
cd ..
   
cd Payara-Embedded-Web
mv payara-embedded-web.jar payara-embedded-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.jar
rm -rf payara-embedded-web.jar
cd ..
  
# Copy API Artefacts
cp ${REPO_DIR}/api/payara-api/target/payara-api-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.jar Payara-API/payara-api-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.jar
cp ${REPO_DIR}/api/payara-api/target/payara-api-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar Payara-API/payara-api-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar
cp ${REPO_DIR}/api/payara-api/target/payara-api-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar Payara-API/payara-api-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar
 
# Copy EJB-HTTP-Client Artefacts
cp ${REPO_DIR}/appserver/ejb/ejb-http-remoting/client/target/ejb-http-client.jar Payara-EJB-HTTP-Client/ejb-http-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.jar
cp ${REPO_DIR}/appserver/ejb/ejb-http-remoting/client/target/ejb-http-client-javadoc.jar Payara-EJB-HTTP-Client/ejb-http-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar
cp ${REPO_DIR}/appserver/ejb/ejb-http-remoting/client/target/ejb-http-client-sources.jar Payara-EJB-HTTP-Client/ejb-http-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar

# Create Source and Javadoc
cd ${REPO_DIR}
mvn pre-site -Psource
mvn pre-site -Pjavadoc
cd -
 
 
#################################################################################
 
RELEASE_DIR=$(pwd)
 
# Copy Source and Javadoc
cp ${REPO_DIR}/target/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar Payara/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar
cp ${REPO_DIR}/target/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar Payara-ML/payara-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar
cp ${REPO_DIR}/target/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar Payara-Web/payara-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar
cp ${REPO_DIR}/target/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar Payara-Web-ML/payara-web-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar
cp ${REPO_DIR}/target/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar Payara-Micro/payara-micro-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar
cp ${REPO_DIR}/target/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar Payara-Embedded-All/payara-embedded-all-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar
cp ${REPO_DIR}/target/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar Payara-Embedded-Web/payara-embedded-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar
cp ${REPO_DIR}/target/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar Payara-Appclient/payara-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar
  
cp ${REPO_DIR}/target/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar Payara/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar
cp ${REPO_DIR}/target/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar Payara-ML/payara-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar
cp ${REPO_DIR}/target/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar Payara-Web/payara-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar
cp ${REPO_DIR}/target/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar Payara-Web-ML/payara-web-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar
cp ${REPO_DIR}/target/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar Payara-Micro/payara-micro-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar
cp ${REPO_DIR}/target/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar Payara-Embedded-All/payara-embedded-all-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar
cp ${REPO_DIR}/target/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar Payara-Embedded-Web/payara-embedded-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar
cp ${REPO_DIR}/target/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar Payara-Appclient/payara-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar
 
# Export Source
cd ${REPO_DIR}
git archive --format zip --output ${RELEASE_DIR}/SourceExport/payara-source-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.zip Payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-Release
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
cp pom.xml Payara/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara</g" Payara/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/version>${ESCAPED_CURRENT_VERSION}</version>${MAJOR_VERSION}\.${MINOR_VERSION}\.${PATCH_VERSION}</g" Payara/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/tag>payara-server-${ESCAPED_CURRENT_VERSION}</tag>payara-server-${MAJOR_VERSION}\.${MINOR_VERSION}\.${PATCH_VERSION}</g" Payara/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Server</g" Payara/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/packaging>zip</packaging>zip</g" Payara/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Full Distribution of the Payara Project</g" Payara/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
  
cp pom.xml Payara-ML/payara-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-ml</g" Payara-ML/payara-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/version>${ESCAPED_CURRENT_VERSION}</version>${MAJOR_VERSION}\.${MINOR_VERSION}\.${PATCH_VERSION}</g" Payara-ML/payara-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/tag>payara-server-${ESCAPED_CURRENT_VERSION}</tag>payara-server-${MAJOR_VERSION}\.${MINOR_VERSION}\.${PATCH_VERSION}</g" Payara-ML/payara-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Server ML</g" Payara-ML/payara-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/packaging>zip</packaging>zip</g" Payara-ML/payara-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Full ML Distribution of the Payara Project</g" Payara-ML/payara-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
  
cp pom.xml Payara-Web/payara-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-web</g" Payara-Web/payara-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/version>${ESCAPED_CURRENT_VERSION}</version>${MAJOR_VERSION}\.${MINOR_VERSION}\.${PATCH_VERSION}</g" Payara-Web/payara-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/tag>payara-server-${ESCAPED_CURRENT_VERSION}</tag>payara-server-${MAJOR_VERSION}\.${MINOR_VERSION}\.${PATCH_VERSION}</g" Payara-Web/payara-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Web</g" Payara-Web/payara-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/packaging>zip</packaging>zip</g" Payara-Web/payara-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Web Distribution of the Payara Project</g" Payara-Web/payara-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
  
cp pom.xml Payara-Web-ML/payara-web-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-web-ml</g" Payara-Web-ML/payara-web-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/version>${ESCAPED_CURRENT_VERSION}</version>${MAJOR_VERSION}\.${MINOR_VERSION}\.${PATCH_VERSION}</g" Payara-Web-ML/payara-web-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/tag>payara-server-${ESCAPED_CURRENT_VERSION}</tag>payara-server-${MAJOR_VERSION}\.${MINOR_VERSION}\.${PATCH_VERSION}</g" Payara-Web-ML/payara-web-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Web ML</g" Payara-Web-ML/payara-web-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/packaging>zip</packaging>zip</g" Payara-Web-ML/payara-web-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Web ML Distribution of the Payara Project</g" Payara-Web-ML/payara-web-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
  
cp pom.xml Payara-Micro/payara-micro-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-micro</g" Payara-Micro/payara-micro-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/groupId>fish.payara.distributions</groupId>fish.payara.extras</g" Payara-Micro/payara-micro-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/version>${ESCAPED_CURRENT_VERSION}</version>${MAJOR_VERSION}\.${MINOR_VERSION}\.${PATCH_VERSION}</g" Payara-Micro/payara-micro-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/tag>payara-server-${ESCAPED_CURRENT_VERSION}</tag>payara-server-${MAJOR_VERSION}\.${MINOR_VERSION}\.${PATCH_VERSION}</g" Payara-Micro/payara-micro-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Micro</g" Payara-Micro/payara-micro-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/packaging>zip</packaging>jar</g" Payara-Micro/payara-micro-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Micro Distribution of the Payara Project</g" Payara-Micro/payara-micro-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
  
cp pom.xml Payara-Embedded-All/payara-embedded-all-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-embedded-all</g" Payara-Embedded-All/payara-embedded-all-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/groupId>fish.payara.distributions</groupId>fish.payara.extras</g" Payara-Embedded-All/payara-embedded-all-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/version>${ESCAPED_CURRENT_VERSION}</version>${MAJOR_VERSION}\.${MINOR_VERSION}\.${PATCH_VERSION}</g" Payara-Embedded-All/payara-embedded-all-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/tag>payara-server-${ESCAPED_CURRENT_VERSION}</tag>payara-server-${MAJOR_VERSION}\.${MINOR_VERSION}\.${PATCH_VERSION}</g" Payara-Embedded-All/payara-embedded-all-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Embedded-All</g" Payara-Embedded-All/payara-embedded-all-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/packaging>zip</packaging>jar</g" Payara-Embedded-All/payara-embedded-all-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Embedded-All Distribution of the Payara Project</g" Payara-Embedded-All/payara-embedded-all-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
  
cp pom.xml Payara-Embedded-Web/payara-embedded-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-embedded-web</g" Payara-Embedded-Web/payara-embedded-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/groupId>fish.payara.distributions</groupId>fish.payara.extras</g" Payara-Embedded-Web/payara-embedded-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/version>${ESCAPED_CURRENT_VERSION}</version>${MAJOR_VERSION}\.${MINOR_VERSION}\.${PATCH_VERSION}</g" Payara-Embedded-Web/payara-embedded-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/tag>payara-server-${ESCAPED_CURRENT_VERSION}</tag>payara-server-${MAJOR_VERSION}\.${MINOR_VERSION}\.${PATCH_VERSION}</g" Payara-Embedded-Web/payara-embedded-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Embedded-Web</g" Payara-Embedded-Web/payara-embedded-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/packaging>zip</packaging>jar</g" Payara-Embedded-Web/payara-embedded-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Embedded-Web Distribution of the Payara Project</g" Payara-Embedded-Web/payara-embedded-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
 
cp pom.xml Payara-API/payara-api-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-api</g" Payara-API/payara-api-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/groupId>fish.payara.distributions</groupId>fish.payara.api</g" Payara-API/payara-api-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/version>${ESCAPED_CURRENT_VERSION}</version>${MAJOR_VERSION}\.${MINOR_VERSION}\.${PATCH_VERSION}</g" Payara-API/payara-api-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/tag>payara-server-${ESCAPED_CURRENT_VERSION}</tag>payara-server-${MAJOR_VERSION}\.${MINOR_VERSION}\.${PATCH_VERSION}</g" Payara-API/payara-api-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/name>Payara Server</name>Payara API</g" Payara-API/payara-api-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/packaging>zip</packaging>jar</g" Payara-API/payara-api-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Artefact that exposes public API of Payara Application Server</g" Payara-API/payara-api-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom

cp pom.xml Payara-Appclient/payara-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-client</g" Payara-Appclient/payara-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/groupId>fish.payara.distributions</groupId>fish.payara.server.appclient</g" Payara-Appclient/payara-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/version>${ESCAPED_CURRENT_VERSION}</version>${MAJOR_VERSION}\.${MINOR_VERSION}\.${PATCH_VERSION}</g" Payara-Appclient/payara-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/tag>payara-server-${ESCAPED_CURRENT_VERSION}</tag>payara-server-${MAJOR_VERSION}\.${MINOR_VERSION}\.${PATCH_VERSION}</g" Payara-Appclient/payara-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Appclient</g" Payara-Appclient/payara-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/packaging>zip</packaging>jar</g" Payara-Appclient/payara-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Appclient for Payara Server</g" Payara-Appclient/payara-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom

cp ${REPO_DIR}/appserver/ejb/ejb-http-remoting/client/target/flattened-pom.xml Payara-EJB-HTTP-Client/ejb-http-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom
cp ${REPO_DIR}/api/payara-bom/target/flattened-pom.xml Payara-BOM/payara-bom-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom

################################################################################
  
# Upload to Nexus Staging
rm pom.xml
   
mvn deploy:deploy-file -Dversion=${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.RC${RC_VERSION} -Dfile=Payara/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.zip -Dsources=Payara/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar -Djavadoc=Payara/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar -DpomFile=Payara/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.RC${RC_VERSION} -Dfile=Payara/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.tar.gz -DpomFile=Payara/payara-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dversion=${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.RC${RC_VERSION} -Dfile=Payara-ML/payara-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.zip -Dsources=Payara-ML/payara-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar -Djavadoc=Payara-ML/payara-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar -DpomFile=Payara-ML/payara-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.RC${RC_VERSION} -Dfile=Payara-ML/payara-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.tar.gz -DpomFile=Payara-ML/payara-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dversion=${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.RC${RC_VERSION} -Dfile=Payara-Web/payara-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.zip -Dsources=Payara-Web/payara-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar -Djavadoc=Payara-Web/payara-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar -DpomFile=Payara-Web/payara-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.RC${RC_VERSION} -Dfile=Payara-Web/payara-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.tar.gz -DpomFile=Payara-Web/payara-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dversion=${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.RC${RC_VERSION} -Dfile=Payara-Web-ML/payara-web-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.zip -Dsources=Payara-Web-ML/payara-web-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar -Djavadoc=Payara-Web-ML/payara-web-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar -DpomFile=Payara-Web-ML/payara-web-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.RC${RC_VERSION} -Dfile=Payara-Web-ML/payara-web-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.tar.gz -DpomFile=Payara-Web-ML/payara-web-ml-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dversion=${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.RC${RC_VERSION} -Dfile=Payara-Micro/payara-micro-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.jar -Dsources=Payara-Micro/payara-micro-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar -Djavadoc=Payara-Micro/payara-micro-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar -DpomFile=Payara-Micro/payara-micro-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -Dversion=${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.RC${RC_VERSION} -Dfile=Payara-Embedded-All/payara-embedded-all-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.jar -Dsources=Payara-Embedded-All/payara-embedded-all-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar -Djavadoc=Payara-Embedded-All/payara-embedded-all-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar -DpomFile=Payara-Embedded-All/payara-embedded-all-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
   
mvn deploy:deploy-file -Dversion=${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.RC${RC_VERSION} -Dfile=Payara-Embedded-Web/payara-embedded-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.jar -Dsources=Payara-Embedded-Web/payara-embedded-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar -Djavadoc=Payara-Embedded-Web/payara-embedded-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar -DpomFile=Payara-Embedded-Web/payara-embedded-web-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
   
mvn deploy:deploy-file -DgroupId=fish.payara.extras -DartifactId=payara-source -Dversion=${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.RC${RC_VERSION} -Dpackaging=zip -Dfile=SourceExport/payara-source-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.zip -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
 
mvn deploy:deploy-file -Dversion=${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.RC${RC_VERSION} -Dfile=Payara-API/payara-api-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.jar -DpomFile=Payara-API/payara-api-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dsources=Payara-API/payara-api-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar -Djavadoc=Payara-API/payara-api-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar

mvn deploy:deploy-file -Dversion=${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.RC${RC_VERSION} -Dfile=Payara-EJB-HTTP-Client/ejb-http-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.jar -DpomFile=Payara-EJB-HTTP-Client/ejb-http-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dsources=Payara-EJB-HTTP-Client/ejb-http-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar -Djavadoc=Payara-EJB-HTTP-Client/ejb-http-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar

mvn deploy:deploy-file -Dversion=${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.RC${RC_VERSION} -Dfile=Payara-Appclient/payara-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.jar -DpomFile=Payara-Appclient/payara-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dsources=Payara-Appclient/payara-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-sources.jar -Djavadoc=Payara-Appclient/payara-client-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-javadoc.jar

mvn deploy:deploy-file -Dversion=${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.RC${RC_VERSION} -DpomFile=Payara-BOM/payara-bom-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom -Dfile=Payara-BOM/payara-bom-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
