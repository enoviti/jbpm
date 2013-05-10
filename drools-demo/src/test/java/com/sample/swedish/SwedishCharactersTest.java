package com.sample.swedish;

import org.drools.KnowledgeBase;
import org.drools.KnowledgeBaseFactory;
import org.drools.builder.*;
import org.drools.io.ResourceFactory;
import org.drools.logger.KnowledgeRuntimeLogger;
import org.drools.logger.KnowledgeRuntimeLoggerFactory;
import org.drools.runtime.StatefulKnowledgeSession;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.junit.Assert.assertEquals;

public class SwedishCharactersTest {
	
	private void setupTestCase() {
		try {
            // load up the knowledge base
            KnowledgeBase kbase = readKnowledgeBase();
            StatefulKnowledgeSession ksession = kbase.newStatefulKnowledgeSession();
            KnowledgeRuntimeLogger logger = KnowledgeRuntimeLoggerFactory.newFileLogger(ksession, "rules-log");

            List<String> list = new ArrayList<String>();
			ksession.getGlobals().set("messageList", list);
			
            ksession.fireAllRules();
			System.out.println("Expecting MyÅÄÖ, got: " + list);
			assertEquals(list, Arrays.asList("MyÅÄÖ"));
            
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
