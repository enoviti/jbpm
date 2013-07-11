#!/bin/bash
SRC_DIR=./installs
BRMS=brms-p-5.3.1.GA-deployable-ee6.zip
VERSION=5.3.1.BRMS

command -v mvn -q >/dev/null 2>&1 || { echo >&2 "Maven is required but not installed yet... aborting."; exit 1; }

installPom() {
    echo "--> Installing pom:" $2-$VERSION.pom.xml
    mvn -q install:install-file -Dfile=../$SRC_DIR/$2-$VERSION.pom.xml -DgroupId=$1 -DartifactId=$2 -Dversion=$VERSION -Dpackaging=pom;
}

installBinary() {
    echo "--> Installing jar:" $1.$2-$VERSION.jar
    unzip -q $2-$VERSION.jar META-INF/maven/$1/$2/pom.xml;
    mvn -q install:install-file -DpomFile=./META-INF/maven/$1/$2/pom.xml -Dfile=$2-$VERSION.jar -DgroupId=$1 -DartifactId=$2 -Dversion=$VERSION -Dpackaging=jar;
}

echo
echo Installing the BRMS binaries into the Maven repository:
echo

unzip -q $SRC_DIR/$BRMS jboss-brms-engine.zip
unzip -q jboss-brms-engine.zip binaries/*
unzip -q $SRC_DIR/$BRMS jboss-jbpm-engine.zip
unzip -q -o -d ./binaries jboss-jbpm-engine.zip
cd binaries

#echo
echo Installing parent POMs:
installPom org.drools droolsjbpm-parent
installPom org.drools droolsjbpm-knowledge
installPom org.drools drools-multiproject
installPom org.drools droolsjbpm-tools
installPom org.drools droolsjbpm-integration
installPom org.drools guvnor
installPom org.jbpm jbpm

echo
echo Installing Drools binaries:
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
echo Installing jBPM binaries:
installBinary org.jbpm jbpm-flow
installBinary org.jbpm jbpm-flow-builder
installBinary org.jbpm jbpm-persistence-jpa
installBinary org.jbpm jbpm-bam
installBinary org.jbpm jbpm-bpmn2
installBinary org.jbpm jbpm-workitems
installBinary org.jbpm jbpm-human-task
installBinary org.jbpm jbpm-test

cd ..
rm -rf binaries
rm jboss-brms-engine.zip
rm jboss-jbpm-engine.zip

echo Installation of binaries "for" BRMS $VERSION complete.
echo

