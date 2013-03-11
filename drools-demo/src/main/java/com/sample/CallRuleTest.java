package com.sample;

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
import org.drools.runtime.rule.impl.AgendaImpl;

import com.sample.models.Message;

/**
 * Simple Class to test calling a rule (DRL file) that is part of a jbpm process (ruleflow).
 * 
 * The DRL uses ruleflow-group "group1" and therefore the Agenda has to activate the ruleflow-group explicitly. 
 * 
 * @author Miguel
 *
 */
public class CallRuleTest {
	
	
	public static final void main(String[] args) {
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
            
            //To call a rule that is part of a process, first we need to activate it.
            AgendaImpl agenda = (AgendaImpl)ksession.getAgenda();
            agenda.activateRuleFlowGroup("group1");
            
            //ksession.startProcess("log-me");
            ksession.fireAllRules();
            
            logger.close();
        } catch (Throwable t) {
            t.printStackTrace();
        }
    }
	
	private static KnowledgeBase readKnowledgeBase() throws Exception {
		KnowledgeBuilder kbuilder = KnowledgeBuilderFactory.newKnowledgeBuilder();
		kbuilder.add(ResourceFactory.newClassPathResource("log-me.drl"), ResourceType.DRL);
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
