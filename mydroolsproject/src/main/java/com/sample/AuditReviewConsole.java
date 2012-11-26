package com.sample;

import org.drools.runtime.process.WorkItem;
import org.drools.runtime.process.WorkItemHandler;
import org.drools.runtime.process.WorkItemManager;

public class AuditReviewConsole implements WorkItemHandler {
  @Override
  public void executeWorkItem(WorkItem workItem, WorkItemManager manager) {
    
    System.out.println("Hellow world ");
    manager.completeWorkItem(workItem.getId(), null);
  }

  @Override
  public void abortWorkItem(WorkItem workItem, WorkItemManager manager) {}
}
