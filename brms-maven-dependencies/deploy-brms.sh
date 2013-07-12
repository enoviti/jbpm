#!/bin/bash
SRC_DIR=./installs
BRMS=brms-p-5.3.1.GA-deployable-ee6.zip
VERSION=5.3.1.BRMS
SERVER_ID=deployment
SERVER_URL=http://dendcvch05.aimco.com:8081/nexus/content/repositories/thirdparty

command -v mvn -q >/dev/null 2>&1 || { echo >&2 "Maven is required but not installed yet... aborting."; exit 1; }

installPom() {
    echo "--> Deploying pom:" $2-$VERSION.pom.xml 
    mvn -q deploy:deploy-file -Dfile=../$SRC_DIR/$2-$VERSION.pom.xml -DgroupId=$1 -DartifactId=$2 -Dversion=$VERSION -Dpackaging=pom -DrepositoryId=$SERVER_ID -Durl=$SERVER_URL;
}

installBinary() {
    echo "--> Deploying jar:" $1.$2-$VERSION.jar 
    unzip -q $2-$VERSION.jar META-INF/maven/$1/$2/pom.xml;
    mvn -q deploy:deploy-file -DpomFile=./META-INF/maven/$1/$2/pom.xml -Dfile=$2-$VERSION.jar -DgroupId=$1 -DartifactId=$2 -Dversion=$VERSION -Dpackaging=jar -DrepositoryId=$SERVER_ID -Durl=$SERVER_URL;
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
cd binaries

echo
echo Deploying parent poms:
installPom org.drools droolsjbpm-parent
installPom org.drools droolsjbpm-knowledge
installPom org.drools drools-multiproject
installPom org.drools droolsjbpm-tools
installPom org.drools droolsjbpm-integration
installPom org.drools guvnor
installPom org.jbpm jbpm

echo
echo Deploying Drools binaries:
# droolsjbpm-knowledge
installBinary org.drools knowledge-api
# drools-multiproject
installBinary org.drools drools-core
installBinary org.drools drools-compiler
installBinary org.drools drools-jsr94
installBinary org.drools drools-verifier
installBinary org.drools drools-persistence-jpa
installBinary org.drools drools-templates
installBinary org.drools drools-decisiontables
# droolsjbpm-tools
installBinary org.drools drools-ant
# droolsjbpm-integration
installBinary org.drools drools-camel
# guvnor
installBinary org.drools droolsjbpm-ide-common

echo
echo Deploying jBPM binaries:
installBinary org.jbpm jbpm-flow
installBinary org.jbpm jbpm-flow-builder
installBinary org.jbpm jbpm-persistence-jpa
installBinary org.jbpm jbpm-bam
installBinary org.jbpm jbpm-bpmn2
installBinary org.jbpm jbpm-workitems
installBinary org.jbpm jbpm-human-task
installBinary org.jbpm jbpm-test
installBinary org.jbpm jbpm-gwt-core
installBinary org.jbpm jbpm-gwt-form
installBinary org.jbpm jbpm-gwt-graph
installBinary org.jbpm jbpm-gwt-shared

cd ..
rm -rf binaries
rm jboss-brms-engine.zip
rm jboss-jbpm-engine.zip
rm jboss-jbpm-console-ee6.zip

echo Installation of binaries "for" BRMS $VERSION complete.
echo

