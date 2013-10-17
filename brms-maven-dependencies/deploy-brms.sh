#!/bin/bash
SRC_DIR=./installs
BRMS=brms-p-5.3.1.GA-deployable-ee6.zip
BRMS_SRC=brms-p-5.3.1.GA-src.zip
VERSION=5.3.1.BRMS
SERVER_ID=deployment
SERVER_URL=http://dendcvch05.aimco.com:8081/nexus/content/repositories/thirdparty

command -v mvn -q >/dev/null 2>&1 || { echo >&2 "Maven is required but not installed yet... aborting."; exit 1; }

deployPom() {
    echo "--> Deploying pom:" $2-$VERSION.pom.xml
    mvn -q deploy:deploy-file -Dfile=../$SRC_DIR/$2-$VERSION.pom.xml -DgroupId=$1 -DartifactId=$2 -Dversion=$VERSION -Dpackaging=pom -DrepositoryId=$SERVER_ID -Durl=$SERVER_URL;
}

deployBinary() {
    echo "--> Deploying jar:" $1.$2-$VERSION.jar
    unzip -q $2-$VERSION.jar META-INF/maven/$1/$2/pom.xml;
    mvn -q deploy:deploy-file -DpomFile=./META-INF/maven/$1/$2/pom.xml -Dfile=$2-$VERSION.jar -DgroupId=$1 -DartifactId=$2 -Dversion=$VERSION -Dpackaging=jar -DrepositoryId=$SERVER_ID -Durl=$SERVER_URL;
}

deploySource() {
    echo "--> Deploying source jar:" $1.$2-$VERSION-sources.jar 
    zip -r ../sources/$2-$VERSION-sources.jar ../sources/$3;
#    mvn -q deploy:deploy-file -DpomFile=$3/pom.xml -Dfile=$2-$VERSION-sources.jar -DgroupId=$1 -DartifactId=$2 -Dversion=$VERSION -Dpackaging=jar -Dclassifier=sources -DrepositoryId=$SERVER_ID -Durl=$SERVER_URL;
}

echo
echo Deploying the BRMS binaries into the Maven repository: $SERVER_URL using $SERVER_ID credentials from settings.xml 
echo

unzip -q $SRC_DIR/$BRMS jboss-brms-engine.zip
unzip -q jboss-brms-engine.zip binaries/*
unzip -q $SRC_DIR/$BRMS jboss-jbpm-engine.zip
unzip -q -o -d ./binaries jboss-jbpm-engine.zip
unzip -q $SRC_DIR/$BRMS jboss-jbpm-console-ee6.zip
unzip -q -o -j -d ./binaries jboss-jbpm-console-ee6.zip business-central-server.war/WEB-INF/lib/jbpm-gwt*
unzip -q -d ./sources $SRC_DIR/$BRMS_SRC
cd binaries

echo
echo Deploying parent POMs:
deployPom org.drools droolsjbpm-parent
deployPom org.drools droolsjbpm-knowledge
deployPom org.drools drools-multiproject
deployPom org.drools droolsjbpm-tools
deployPom org.drools droolsjbpm-integration
deployPom org.drools guvnor
deployPom org.jbpm jbpm
deployPom org.jbpm jbpm-gwt

echo
echo Deploying Drools binaries:
# droolsjbpm-knowledge
deployBinary org.drools knowledge-api
# drools-multiproject
deployBinary org.drools drools-core
deployBinary org.drools drools-compiler
deployBinary org.drools drools-jsr94
deployBinary org.drools drools-verifier
deployBinary org.drools drools-persistence-jpa
deployBinary org.drools drools-templates
deployBinary org.drools drools-decisiontables
# droolsjbpm-tools
deployBinary org.drools drools-ant
# droolsjbpm-integration
deployBinary org.drools drools-camel
# guvnor
deployBinary org.drools droolsjbpm-ide-common

echo
echo Deploying jBPM binaries:
deployBinary org.jbpm jbpm-flow
deployBinary org.jbpm jbpm-flow-builder
deployBinary org.jbpm jbpm-persistence-jpa
deployBinary org.jbpm jbpm-bam
deployBinary org.jbpm jbpm-bpmn2
deployBinary org.jbpm jbpm-workitems
deployBinary org.jbpm jbpm-human-task
deployBinary org.jbpm jbpm-test
deployBinary org.jbpm jbpm-gwt-core
deployBinary org.jbpm jbpm-gwt-form
deployBinary org.jbpm jbpm-gwt-graph
deployBinary org.jbpm jbpm-gwt-shared

cd ..
rm -rf binaries
rm -rf sources
rm jboss-brms-engine.zip
rm jboss-jbpm-engine.zip
rm jboss-jbpm-console-ee6.zip

echo Installation of binaries "for" BRMS $VERSION complete.
echo

