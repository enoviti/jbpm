Project to extract BRMS dependencies from a ZIP distribution (brms-p-5.3.1.GA-deployable-ee6.zip not included) 
and install them in your local Maven Repository.

Copy ZIP file to:
- src
  - main
  - resources
       - brms-p-5.3.1.GA-deployable-ee6.zip

To install dependencies:
$ mvn clean install -Pdeploy-to-maven
Note: The last step (creation of the JAR) can be killed (ctrl + c) because by you don't actually need that JAR file. 
By the time that this jar creation is going on, all the dependencies have been installed with 'mvn install'.

Dependencies installed by this project:

	antlr-runtime-3.3.jar
	brms-bulk-importer-5.3.1.BRMS.jar
	drools-ant-5.3.1.BRMS.jar
	drools-camel-5.3.1.BRMS.jar
	drools-compiler-5.3.1.BRMS.jar
	drools-core-5.3.1.BRMS.jar
	drools-decisiontables-5.3.1.BRMS.jar
	drools-examples-5.3.1.BRMS.jar
	droolsjbpm-ide-common-5.3.1.BRMS.jar
	drools-jsr94-5.3.1.BRMS.jar
	drools-persistence-jpa-5.3.1.BRMS.jar
	drools-spring-5.3.1.BRMS.jar
	drools-templates-5.3.1.BRMS.jar
	drools-verifier-5.3.1.BRMS.jar
	ecj-3.5.1.jar
	jbpm-bam-5.3.1.BRMS.jar
	jbpm-bpmn2-5.3.1.BRMS.jar
	jbpm-flow-5.3.1.BRMS.jar
	jbpm-flow-builder-5.3.1.BRMS.jar
	jbpm-gwt-console-tomcat-integration-5.3.1.BRMS.jar
	jbpm-human-task-5.3.1.BRMS.jar
	jbpm-persistence-jpa-5.3.1.BRMS.jar
	jbpm-test-5.3.1.BRMS.jar
	jbpm-workitems-5.3.1.BRMS.jar
	knowledge-api-5.3.1.BRMS.jar
	mvel2-2.1.3.Final.jar
