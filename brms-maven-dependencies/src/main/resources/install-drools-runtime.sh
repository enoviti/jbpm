#!/bin/bash

# This script installs the necessary libraries from the drools runtime into maven
FILES=*BRMS*
echo "Going to install the following files"

for filename in $FILES

do
  echo "$filename"
done

for filename in $FILES

do
  brmsVersion=$(echo $filename | grep -oE "([0-9]{1}\.)*BRMS")
  artifactId=$(echo $filename | grep -oE "(.*)-")
  fileType=$(echo $filename | grep -oE "(.ar)$")
    if (echo $filename | grep -q "^jbpm") then
        mvn install:install-file -Dfile=$filename -DgroupId=org.jbpm -DartifactId=${artifactId%?} -Dversion=$brmsVersion -Dpackaging=$fileType -DgeneratePom=true -DcreateChecksum=true
    else
        mvn install:install-file -Dfile=$filename -DgroupId=org.drools -DartifactId=${artifactId%?} -Dversion=$brmsVersion -Dpackaging=$fileType -DgeneratePom=true -DcreateChecksum=true
    fi
done

MVEL=*mvel2*

for filename in $MVEL

do
    mvelVersion=$(echo $filename | grep -oE "([0-9]{1})\.([0-9]{1})\.([0-9]{1}).[a-zA-Z]*([0-9])*")
    mvn install:install-file -Dfile=$filename -DgroupId=org.mvel -DartifactId=mvel2 -Dversion=$mvelVersion -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true
done

ANTLR=*antlr-runtime*

for filename in $ANTLR
do 
    antlrVersion=$(echo $filename | grep -oE "([0-9]{1})\.([0-9]{1})")
    mvn install:install-file -Dfile=$filename -DgroupId=org.antlr -DartifactId=antlr-runtime -Dversion=$antlrVersion -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true
done

ECJ=*ecj*

for filename in $ECJ
do
    ecjVersion=$(echo $filename | grep -oE "([0-9]{1})\.([0-9]{1})\.([0-9]{1})")
    mvn install:install-file -Dfile=$filename -DgroupId=org.eclipse.jdt.core.compiler -DartifactId=ecj -Dversion=$ecjVersion -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true
done

