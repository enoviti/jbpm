package se.sjv.rules;

import static org.junit.Assert.assertEquals;

import java.math.BigDecimal;

import org.drools.KnowledgeBase;
import org.drools.KnowledgeBaseFactory;
import org.drools.builder.KnowledgeBuilder;
import org.drools.builder.KnowledgeBuilderError;
import org.drools.builder.KnowledgeBuilderErrors;
import org.drools.builder.KnowledgeBuilderFactory;
import org.drools.builder.ResourceType;
import org.drools.command.assertion.AssertEquals;
import org.drools.io.Resource;
import org.drools.io.ResourceFactory;
import org.drools.logger.KnowledgeRuntimeLogger;
import org.drools.logger.KnowledgeRuntimeLoggerFactory;
import org.drools.runtime.StatefulKnowledgeSession;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

/**
 *
 * @author 
 */
public class BigDecimalTest {
	
	static KnowledgeBase kbase;
	static StatefulKnowledgeSession ksession;
	static KnowledgeRuntimeLogger logger;
	
	@BeforeClass
	public static void setupKsession() {
		try {
			// load up the knowledge base
			kbase = readKnowledgeBase();
			ksession = kbase.newStatefulKnowledgeSession();
			logger = KnowledgeRuntimeLoggerFactory.newThreadedFileLogger(ksession, "log/policyQuote", 500);

		} catch (Throwable t) {
			t.printStackTrace();
		}
	}
	
	@AfterClass
	public static void closeKsession() {
		try {
			// load up the knowledge base
			logger.close();
			ksession.dispose();

		} catch (Throwable t) {
			t.printStackTrace();
		}
	}

	/**
	 * Djurhagarna är ok.
	 */
	@Test
	public void testCalculation() {
		DataCarrier result = new DataCarrier(new BigDecimal(0));
		for (int i = 0; i < 10; i++) {
			ksession.insert(new DataCarrier(new BigDecimal("0.1")));
		}
		ksession.fireAllRules();
		
		assertEquals("Inserted 10 items", result.getValue(), new BigDecimal("1.0"));
		
	}
	
	private static KnowledgeBase readKnowledgeBase() throws Exception {
		KnowledgeBuilder kbuilder = KnowledgeBuilderFactory.newKnowledgeBuilder();
		kbuilder.add(ResourceFactory.newClassPathResource("BigDecimalTest.drl"), ResourceType.DRL);
		hasErrors(kbuilder);
		
		kbase.addKnowledgePackages(kbuilder.getKnowledgePackages());

		return kbase;
	}
		
	private static void hasErrors(KnowledgeBuilder kbuilder) throws Exception {
		KnowledgeBuilderErrors errors = kbuilder.getErrors();
		if (errors.size() > 0) {
			for (KnowledgeBuilderError error: errors) {
				System.err.println(error);
			}
			throw new IllegalArgumentException("Could not parse knowledge.");
		}
		
	}

}
