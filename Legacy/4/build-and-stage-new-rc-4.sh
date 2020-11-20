#!/bin/sh

#############################################################################

# Read in properties file
. ./Legacy/legacy-release-config.properties

#############################################################################

### Create branches, Update version, and Build ###
# Move to Git Repo
cd ${REPO_DIR}

RELEASE_VERSION="$BASE_VERSION.$RELEASE_PATCH_VERSION"

# Reset and Cleanup
git reset --hard HEAD
git clean -fdx

# Update Branches
git fetch ${MASTER_REMOTE}
git checkout Payara4
git pull ${MASTER_REMOTE} Payara4
git checkout payara-server-${BASE_VERSION}.maintenance
git pull ${MASTER_REMOTE} payara-server-${BASE_VERSION}.maintenance

# Checkout and update release branch
git checkout Payara-${RELEASE_VERSION}-Release
git pull ${MASTER_REMOTE} Payara-${RELEASE_VERSION}-Release

# Tag release
git tag -d payara-server-${RELEASE_VERSION}.RC${RC_VERSION}
git tag payara-server-${RELEASE_VERSION}.RC${RC_VERSION}

# Push changes
git push ${MASTER_REMOTE} payara-server-${RELEASE_VERSION}.RC${RC_VERSION} --force

# Ensure we're using JDK8
export PATH="${JDK8_PATH}/bin:${PATH}:${JDK8_PATH}/bin"
export JAVA_HOME="${JDK8_PATH}"

# Build
MAVEN_OPTS="-Xmx2G -Djavax.net.ssl.trustStore=${JAVA_HOME}/jre/lib/security/cacerts" \
mvn clean install -PBuildExtras -Dbuild.number=${BUILD_NUMBER} -U

# Move back
cd -

################################################################################

# Recreate ReleaseDirs
rm -rf Releases/4
mkdir Releases/4
cd Releases/4
mkdir Payara
mkdir Payara-Web
mkdir Payara-ML
mkdir Payara-Web-ML
mkdir Payara-Micro
mkdir Payara-Embedded-All
mkdir Payara-Embedded-Web
mkdir SourceExport
mkdir Payara-API

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
mv payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-${RELEASE_VERSION}.jar payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-4.1.jar
zip -r payara-${RELEASE_VERSION}.zip payara41/
tar -czvf payara-${RELEASE_VERSION}.tar.gz payara41/
rm -rf payara41
rm -rf payara.zip
cd ..

cd Payara-Web
unzip payara-web.zip
mv payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-${RELEASE_VERSION}.jar payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-4.1.jar
zip -r payara-web-${RELEASE_VERSION}.zip payara41/
tar -czvf payara-web-${RELEASE_VERSION}.tar.gz payara41/
rm -rf payara41
rm -rf payara-web.zip
cd ..

cd Payara-ML
unzip payara-ml.zip
mv payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-${RELEASE_VERSION}.jar payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-4.1.jar
zip -r payara-ml-${RELEASE_VERSION}.zip payara41/
tar -czvf payara-ml-${RELEASE_VERSION}.tar.gz payara41/
rm -rf payara41
rm -rf payara-ml.zip
cd ..

cd Payara-Web-ML
unzip payara-web-ml.zip
mv payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-${RELEASE_VERSION}.jar payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-4.1.jar
zip -r payara-web-ml-${RELEASE_VERSION}.zip payara41/
tar -czvf payara-web-ml-${RELEASE_VERSION}.tar.gz payara41/
rm -rf payara41
rm -rf payara-web-ml.zip
cd ..

cd Payara-Micro
mv payara-micro.jar payara-micro-${RELEASE_VERSION}.jar
rm -rf payara-micro.jar
cd ..

cd Payara-Embedded-All
mv payara-embedded-all.jar payara-embedded-all-${RELEASE_VERSION}.jar
rm -rf payara-embedded-all.jar
cd ..

cd Payara-Embedded-Web
mv payara-embedded-web.jar payara-embedded-web-${RELEASE_VERSION}.jar
rm -rf payara-embedded-web.jar
cd ..

# Copy API Artefacts
cp ${REPO_DIR}/api/payara-api/target/payara-api.jar Payara-API/payara-api-${RELEASE_VERSION}.jar
cp ${REPO_DIR}/api/payara-api/target/payara-api-javadoc.jar Payara-API/payara-api-${RELEASE_VERSION}-javadoc.jar
cp ${REPO_DIR}/api/payara-api/target/payara-api-sources.jar Payara-API/payara-api-${RELEASE_VERSION}-sources.jar

# Create Source and Javadoc
cd ${REPO_DIR}
mvn pre-site -Psource
mvn pre-site -Pjavadoc
cd -


#################################################################################

RELEASE_DIR=$(pwd)

# Copy Source and Javadoc
cp ${REPO_DIR}/target/payara-${RELEASE_VERSION}-sources.jar Payara/payara-${RELEASE_VERSION}-sources.jar
cp ${REPO_DIR}/target/payara-${RELEASE_VERSION}-sources.jar Payara-ML/payara-ml-${RELEASE_VERSION}-sources.jar
cp ${REPO_DIR}/target/payara-${RELEASE_VERSION}-sources.jar Payara-Web/payara-web-${RELEASE_VERSION}-sources.jar
cp ${REPO_DIR}/target/payara-${RELEASE_VERSION}-sources.jar Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}-sources.jar
cp ${REPO_DIR}/target/payara-${RELEASE_VERSION}-sources.jar Payara-Micro/payara-micro-${RELEASE_VERSION}-sources.jar
cp ${REPO_DIR}/target/payara-${RELEASE_VERSION}-sources.jar Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}-sources.jar
cp ${REPO_DIR}/target/payara-${RELEASE_VERSION}-sources.jar Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}-sources.jar

cp ${REPO_DIR}/target/payara-${RELEASE_VERSION}-javadoc.jar Payara/payara-${RELEASE_VERSION}-javadoc.jar
cp ${REPO_DIR}/target/payara-${RELEASE_VERSION}-javadoc.jar Payara-ML/payara-ml-${RELEASE_VERSION}-javadoc.jar
cp ${REPO_DIR}/target/payara-${RELEASE_VERSION}-javadoc.jar Payara-Web/payara-web-${RELEASE_VERSION}-javadoc.jar
cp ${REPO_DIR}/target/payara-${RELEASE_VERSION}-javadoc.jar Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}-javadoc.jar
cp ${REPO_DIR}/target/payara-${RELEASE_VERSION}-javadoc.jar Payara-Micro/payara-micro-${RELEASE_VERSION}-javadoc.jar
cp ${REPO_DIR}/target/payara-${RELEASE_VERSION}-javadoc.jar Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}-javadoc.jar
cp ${REPO_DIR}/target/payara-${RELEASE_VERSION}-javadoc.jar Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}-javadoc.jar

# Export Source
cd ${REPO_DIR}
git archive --format zip --output ${RELEASE_DIR}/SourceExport/payara-source-${RELEASE_VERSION}.zip Payara-${RELEASE_VERSION}-Release
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
cp pom.xml Payara/payara-${RELEASE_VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara</g" Payara/payara-${RELEASE_VERSION}.pom
sed -i "s/version>${OLD_VERSION}</version>${RELEASE_VERSION}</g" Payara/payara-${RELEASE_VERSION}.pom
sed -i "s/tag>payara-server-${OLD_VERSION}</tag>payara-server-${RELEASE_VERSION}</g" Payara/payara-${RELEASE_VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Server</g" Payara/payara-${RELEASE_VERSION}.pom
sed -i "s/packaging>zip</packaging>zip</g" Payara/payara-${RELEASE_VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Full Distribution of the Payara Project</g" Payara/payara-${RELEASE_VERSION}.pom

cp pom.xml Payara-ML/payara-ml-${RELEASE_VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-ml</g" Payara-ML/payara-ml-${RELEASE_VERSION}.pom
sed -i "s/version>${OLD_VERSION}</version>${RELEASE_VERSION}</g" Payara-ML/payara-ml-${RELEASE_VERSION}.pom
sed -i "s/tag>payara-server-${OLD_VERSION}</tag>payara-server-${RELEASE_VERSION}</g" Payara-ML/payara-ml-${RELEASE_VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Server ML</g" Payara-ML/payara-ml-${RELEASE_VERSION}.pom
sed -i "s/packaging>zip</packaging>zip</g" Payara-ML/payara-ml-${RELEASE_VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Full ML Distribution of the Payara Project</g" Payara-ML/payara-ml-${RELEASE_VERSION}.pom

cp pom.xml Payara-Web/payara-web-${RELEASE_VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-web</g" Payara-Web/payara-web-${RELEASE_VERSION}.pom
sed -i "s/version>${OLD_VERSION}</version>${RELEASE_VERSION}</g" Payara-Web/payara-web-${RELEASE_VERSION}.pom
sed -i "s/tag>payara-server-${OLD_VERSION}</tag>payara-server-${RELEASE_VERSION}</g" Payara-Web/payara-web-${RELEASE_VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Web</g" Payara-Web/payara-web-${RELEASE_VERSION}.pom
sed -i "s/packaging>zip</packaging>zip</g" Payara-Web/payara-web-${RELEASE_VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Web Distribution of the Payara Project</g" Payara-Web/payara-web-${RELEASE_VERSION}.pom

cp pom.xml Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-web-ml</g" Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.pom
sed -i "s/version>${OLD_VERSION}</version>${RELEASE_VERSION}</g" Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.pom
sed -i "s/tag>payara-server-${OLD_VERSION}</tag>payara-server-${RELEASE_VERSION}</g" Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Web ML</g" Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.pom
sed -i "s/packaging>zip</packaging>zip</g" Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Web ML Distribution of the Payara Project</g" Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.pom

cp pom.xml Payara-Micro/payara-micro-${RELEASE_VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-micro</g" Payara-Micro/payara-micro-${RELEASE_VERSION}.pom
sed -i "s/groupId>fish.payara.distributions</groupId>fish.payara.extras</g" Payara-Micro/payara-micro-${RELEASE_VERSION}.pom
sed -i "s/version>${OLD_VERSION}</version>${RELEASE_VERSION}</g" Payara-Micro/payara-micro-${RELEASE_VERSION}.pom
sed -i "s/tag>payara-server-${OLD_VERSION}</tag>payara-server-${RELEASE_VERSION}</g" Payara-Micro/payara-micro-${RELEASE_VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Micro</g" Payara-Micro/payara-micro-${RELEASE_VERSION}.pom
sed -i "s/packaging>zip</packaging>jar</g" Payara-Micro/payara-micro-${RELEASE_VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Micro Distribution of the Payara Project</g" Payara-Micro/payara-micro-${RELEASE_VERSION}.pom

cp pom.xml Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-embedded-all</g" Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}.pom
sed -i "s/groupId>fish.payara.distributions</groupId>fish.payara.extras</g" Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}.pom
sed -i "s/version>${OLD_VERSION}</version>${RELEASE_VERSION}</g" Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}.pom
sed -i "s/tag>payara-server-${OLD_VERSION}</tag>payara-server-${RELEASE_VERSION}</g" Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Embedded-All</g" Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}.pom
sed -i "s/packaging>zip</packaging>jar</g" Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Embedded-All Distribution of the Payara Project</g" Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}.pom

cp pom.xml Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-embedded-web</g" Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}.pom
sed -i "s/groupId>fish.payara.distributions</groupId>fish.payara.extras</g" Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}.pom
sed -i "s/version>${OLD_VERSION}</version>${RELEASE_VERSION}</g" Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}.pom
sed -i "s/tag>payara-server-${OLD_VERSION}</tag>payara-server-${RELEASE_VERSION}</g" Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}.pom
sed -i "s/name>Payara Server</name>Payara Embedded-Web</g" Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}.pom
sed -i "s/packaging>zip</packaging>jar</g" Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Embedded-Web Distribution of the Payara Project</g" Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}.pom

cp pom.xml Payara-API/payara-api-${RELEASE_VERSION}.pom
sed -i "s/artifactId>payara</artifactId>payara-api</g" Payara-API/payara-api-${RELEASE_VERSION}.pom
sed -i "s/groupId>fish.payara.distributions</groupId>fish.payara.api</g" Payara-API/payara-api-${RELEASE_VERSION}.pom
sed -i "s/version>${OLD_VERSION}</version>${RELEASE_VERSION}</g" Payara-API/payara-api-${RELEASE_VERSION}.pom
sed -i "s/tag>payara-server-${OLD_VERSION}</tag>payara-server-${RELEASE_VERSION}</g" Payara-API/payara-api-${RELEASE_VERSION}.pom
sed -i "s/name>Payara Server</name>Payara API</g" Payara-API/payara-api-${RELEASE_VERSION}.pom
sed -i "s/packaging>zip</packaging>jar</g" Payara-API/payara-api-${RELEASE_VERSION}.pom
sed -i "s/description>Full Distribution of the Payara Project</description>Artefact that exposes public API of Payara Application Server</g" Payara-API/payara-api-${RELEASE_VERSION}.pom

################################################################################

# Building JDK7 release

echo "Switch to JDK7"
export PATH="${JDK7_PATH}/bin:${PATH}:${JDK7_PATH}/bin"
export JAVA_HOME="${JDK7_PATH}"

cd ${REPO_DIR}

MAVEN_OPTS="-Xmx2G -XX:MaxPermSize=512m -Djavax.net.ssl.trustStore=${JAVA_HOME}/jre/lib/security/cacerts" \
mvn clean install -PBuildExtras -Dbuild.number=${BUILD_NUMBER} -U

cd -

echo "Switch back to JDK8"
export PATH="${JDK8_PATH}/bin:${PATH}:${JDK8_PATH}/bin"
export JAVA_HOME="${JDK8_PATH}"

################################################################################

# Copy JDK7 Distributions
cp ${REPO_DIR}/appserver/distributions/payara/target/payara.zip Payara/
cp ${REPO_DIR}/appserver/distributions/payara-ml/target/payara-ml.zip Payara-ML/
cp ${REPO_DIR}/appserver/distributions/payara-web/target/payara-web.zip Payara-Web/
cp ${REPO_DIR}/appserver/distributions/payara-web-ml/target/payara-web-ml.zip Payara-Web-ML/
cp ${REPO_DIR}/appserver/extras/payara-micro/payara-micro-distribution/target/payara-micro.jar Payara-Micro/
cp ${REPO_DIR}/appserver/extras/embedded/all/target/payara-embedded-all.jar Payara-Embedded-All/
cp ${REPO_DIR}/appserver/extras/embedded/web/target/payara-embedded-web.jar Payara-Embedded-Web/

# Rename JDK7 Releases and NetBeans Fix
cd Payara
unzip payara.zip
mv payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-${RELEASE_VERSION}.jar payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-4.1.jar
zip -r payara-${RELEASE_VERSION}-jdk7.zip payara41/
tar -czvf payara-${RELEASE_VERSION}-jdk7.tar.gz payara41/
rm -rf payara41
rm -rf payara.zip
cd ..

cd Payara-Web
unzip payara-web.zip
mv payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-${RELEASE_VERSION}.jar payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-4.1.jar
zip -r payara-web-${RELEASE_VERSION}-jdk7.zip payara41/
tar -czvf payara-web-${RELEASE_VERSION}-jdk7.tar.gz payara41/
rm -rf payara41
rm -rf payara-web.zip
cd ..

cd Payara-ML
unzip payara-ml.zip
mv payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-${RELEASE_VERSION}.jar payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-4.1.jar
zip -r payara-ml-${RELEASE_VERSION}-jdk7.zip payara41/
tar -czvf payara-ml-${RELEASE_VERSION}-jdk7.tar.gz payara41/
rm -rf payara41
rm -rf payara-ml.zip
cd ..

cd Payara-Web-ML
unzip payara-web-ml.zip
mv payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-${RELEASE_VERSION}.jar payara41/glassfish/lib/install/applications/__admingui/WEB-INF/lib/console-core-4.1.jar
zip -r payara-web-ml-${RELEASE_VERSION}-jdk7.zip payara41/
tar -czvf payara-web-ml-${RELEASE_VERSION}-jdk7.tar.gz payara41/
rm -rf payara41
rm -rf payara-web-ml.zip
cd ..

cd Payara-Micro
mv payara-micro.jar payara-micro-${RELEASE_VERSION}-jdk7.jar
rm -rf payara-micro.jar
cd ..

cd Payara-Embedded-All
mv payara-embedded-all.jar payara-embedded-all-${RELEASE_VERSION}-jdk7.jar
rm -rf payara-embedded-all.jar
cd ..

cd Payara-Embedded-Web
mv payara-embedded-web.jar payara-embedded-web-${RELEASE_VERSION}-jdk7.jar
rm -rf payara-embedded-web.jar
cd ..

# Upload to Nexus Staging
rm pom.xml

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara/payara-${RELEASE_VERSION}.zip -Dsources=Payara/payara-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara/payara-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara/payara-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara/payara-${RELEASE_VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara/payara-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara/payara-${RELEASE_VERSION}.tar.gz -DpomFile=Payara/payara-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz
mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara/payara-${RELEASE_VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara/payara-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-ML/payara-ml-${RELEASE_VERSION}.zip -Dsources=Payara-ML/payara-ml-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-ML/payara-ml-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara-ML/payara-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-ML/payara-ml-${RELEASE_VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara-ML/payara-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-ML/payara-ml-${RELEASE_VERSION}.tar.gz -DpomFile=Payara-ML/payara-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz
mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-ML/payara-ml-${RELEASE_VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara-ML/payara-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Web/payara-web-${RELEASE_VERSION}.zip -Dsources=Payara-Web/payara-web-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-Web/payara-web-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara-Web/payara-web-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Web/payara-web-${RELEASE_VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara-Web/payara-web-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Web/payara-web-${RELEASE_VERSION}.tar.gz -DpomFile=Payara-Web/payara-web-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz
mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Web/payara-web-${RELEASE_VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara-Web/payara-web-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.zip -Dsources=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}-jdk7.zip -Dclassifier=jdk7 -DpomFile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.tar.gz -DpomFile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz
mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}-jdk7.tar.gz -Dclassifier=jdk7 -DpomFile=Payara-Web-ML/payara-web-ml-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dpackaging=tar.gz

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Micro/payara-micro-${RELEASE_VERSION}.jar -Dsources=Payara-Micro/payara-micro-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-Micro/payara-micro-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara-Micro/payara-micro-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Micro/payara-micro-${RELEASE_VERSION}-jdk7.jar -Dclassifier=jdk7 -DpomFile=Payara-Micro/payara-micro-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}.jar -Dsources=Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}-jdk7.jar -Dclassifier=jdk7 -DpomFile=Payara-Embedded-All/payara-embedded-all-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}.jar -Dsources=Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}-javadoc.jar -DpomFile=Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts
mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}-jdk7.jar -Dclassifier=jdk7 -DpomFile=Payara-Embedded-Web/payara-embedded-web-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -DgroupId=fish.payara.extras -DartifactId=payara-source -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dpackaging=zip -Dfile=SourceExport/payara-source-${RELEASE_VERSION}.zip -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts

mvn deploy:deploy-file -Dversion=${RELEASE_VERSION}.RC${RC_VERSION} -Dfile=Payara-API/payara-api-${RELEASE_VERSION}.jar -DpomFile=Payara-API/payara-api-${RELEASE_VERSION}.pom -DrepositoryId=payara-nexus -Durl=https://nexus.payara.fish/content/repositories/payara-staging/ -Djavax.net.ssl.trustStore=${JDK8_PATH}/jre/lib/security/cacerts -Dsources=Payara-API/payara-api-${RELEASE_VERSION}-sources.jar -Djavadoc=Payara-API/payara-api-${RELEASE_VERSION}-javadoc.jar
