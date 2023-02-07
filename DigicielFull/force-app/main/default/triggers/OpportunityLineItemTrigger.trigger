/*This trigger will only affect SP users*/
trigger OpportunityLineItemTrigger on OpportunityLineItem (before insert, before update, after insert, after update, after delete) {

    List<OpportunityLineItem> oplListToUpdate = new List<OpportunityLineItem>();
    
    //SP Opportunity Record Type
    String[] recordTypeIds = new String[]{
        '012d0000000tMdA','012d0000000sds8','012d0000000tMdF',
        '012d0000000tMcq','012d0000000sdru','012d0000000tMd5',
        '012d0000000tMdU','012d0000000sdsF','012d0000000tMdZ',
        '012d0000000tMdK','012d0000000sds9','012d0000000tMdP',
        '012d0000000tMde','012d0000000sdsI','012d0000000tMdj',
        '012d0000000sds4'};
    
    // Limit to a set of record types
    
    List<Id> idsOpportunities = new List<Id>();
    if(trigger.isDelete){
        for(OpportunityLineItem opl:trigger.old){
        	idsOpportunities.add(opl.OpportunityId);
            //Opportunity[] oppId = [Select o.Id From Opportunity o Where o.Id = :opl.OpportunityId AND o.RecordTypeId in:recordTypeIds];
            //if (oppId.size() == 0) return;
        }
    }
    else{
        for(OpportunityLineItem opl:trigger.new){
        	idsOpportunities.add(opl.OpportunityId);
            //Opportunity[] oppId = [Select o.Id From Opportunity o Where o.Id = :opl.OpportunityId AND o.RecordTypeId in:recordTypeIds];
            //if (oppId.size() == 0) return;
        }
    }
    
    Map<Id, Opportunity> mapOpportunities = new Map<Id, Opportunity>([Select o.Id From Opportunity o Where o.Id in:idsOpportunities AND o.RecordTypeId in:recordTypeIds]);
    
    //Before -Set Opportunity Commissions and Targets
    if(trigger.isBefore){
      if(trigger.isInsert || trigger.isUpdate){
        for(OpportunityLineItem opl:trigger.new){
        	if(mapOpportunities.containsKey(opl.OpportunityId)){
          		oplListToUpdate.add(opl);
        	}
        }
      }
      if(oplListToUpdate.size()>0){
        OpportunityLineItemUpdate.setFields(oplListToUpdate);
      }
    }
    
    //After - Set Opportunity totals (Deposit, Monthly Fee, Additional Fees)
    if(trigger.isAfter){
    	List<OpportunityLineItem> listOpportunityLineItemUpdate = new List<OpportunityLineItem>();
    	if(Trigger.isDelete){
    		for(OpportunityLineItem opl:trigger.old){
	    		if(mapOpportunities.containsKey(opl.OpportunityId)){
					listOpportunityLineItemUpdate.add(opl);
	    		}
	    	}
    	}else{
	    	for(OpportunityLineItem opl:trigger.new){
	    		if(mapOpportunities.containsKey(opl.OpportunityId)){
					listOpportunityLineItemUpdate.add(opl);
	    		}
	    	}
    	}
      	if(listOpportunityLineItemUpdate.size()>0){
      		OpportunityUpdate.setOpportunityTotals(listOpportunityLineItemUpdate);
      	}
    }
}