package com.sample;

import org.drools.runtime.process.WorkItem;
import org.drools.runtime.process.WorkItemHandler;
import org.drools.runtime.process.WorkItemManager;

public class ShipmentHandler implements WorkItemHandler {

	@Override
	public void abortWorkItem(WorkItem arg0, WorkItemManager arg1) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void executeWorkItem(WorkItem i, WorkItemManager m) {
		System.out.println("Executing shipment: " + i.getParameter("ShipmentId"));
		System.out.println("To --> " + i.getParameter("To"));
		m.completeWorkItem(i.getId(), null);
	}

}
