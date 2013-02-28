package com.miguel.swedish;

import org.drools.KnowledgeBase;
import org.drools.KnowledgeBaseFactory;
import org.drools.builder.KnowledgeBuilder;
import org.drools.builder.KnowledgeBuilderError;
import org.drools.builder.KnowledgeBuilderErrors;
import org.drools.builder.KnowledgeBuilderFactory;
import org.drools.builder.ResourceType;
import org.drools.io.ResourceFactory;
import org.drools.logger.KnowledgeRuntimeLogger;
import org.drools.logger.KnowledgeRuntimeLoggerFactory;
import org.drools.runtime.StatefulKnowledgeSession;
import org.junit.Test;

import com.sample.models.Message;

public class SwedishCharatersTest {
	
	private void setupTestCase() {
		try {
            // load up the knowledge base
            KnowledgeBase kbase = readKnowledgeBase();
            StatefulKnowledgeSession ksession = kbase.newStatefulKnowledgeSession();
            KnowledgeRuntimeLogger logger = KnowledgeRuntimeLoggerFactory.newFileLogger(ksession, "test");
            // start a new process instance
     
            Message message = new Message();
            message.setMessage("Hello World");
            message.setStatus(Message.HELLO);
            ksession.insert(message);
            
            //AgendaImpl agenda = (AgendaImpl)ksession.getAgenda();
            //agenda.activateRuleFlowGroup("group1");
            
            //ksession.startProcess("log-me");
            ksession.fireAllRules();
            
            logger.close();
        } catch (Throwable t) {
            t.printStackTrace();
        }
		
	}
	
	@Test
	public void loadRuleWithSwedishCharaters() {
		setupTestCase();
		
	}
	
	private static KnowledgeBase readKnowledgeBase() throws Exception {
		KnowledgeBuilder kbuilder = KnowledgeBuilderFactory.newKnowledgeBuilder();
		kbuilder.add(ResourceFactory.newClassPathResource("Swedish.drl"), ResourceType.DRL);
		KnowledgeBuilderErrors errors = kbuilder.getErrors();
		
		if(errors.size() > 0){
			for(KnowledgeBuilderError error : errors) {
				System.err.println(error);
			}
			throw new IllegalArgumentException("Could not parse knowledge.");
		}
		KnowledgeBase kbase = KnowledgeBaseFactory.newKnowledgeBase();
		kbase.addKnowledgePackages(kbuilder.getKnowledgePackages());
        return kbase;
		
	}
	

}
