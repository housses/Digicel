public class OpportunityLineItemUpdate{
    
    private static List<Commission_Target__c> ctList = new List<Commission_Target__c>(); 
    
    public static void setFields(List<OpportunityLineItem> OppLineItems){
    
    //Get the Product Id for each entry
    //Map<Id, String> productMap = new Map <Id, String>();
    Set<Id> productIds = new Set<Id>();
    Set<Id> userIds = new Set<Id>();
	
	List<Id> pricebookEntryIds = new List<Id>();
	List<Id> opportunityIds = new List<Id>();
	for(OpportunityLineItem opl: OppLineItems){
		pricebookEntryIds.add(opl.PricebookEntryId);
		opportunityIds.add(opl.OpportunityId);
	}
	
	Map<Id, PricebookEntry> mapPriceBookEntries = new Map<Id, PricebookEntry>([Select Id, Product2Id From PricebookEntry Where Id IN:pricebookEntryIds]);
	Map<Id, Opportunity> mapOpportunities = new Map<Id, Opportunity>([Select Id, OwnerId From Opportunity Where Id IN:opportunityIds]);
	
    for(OpportunityLineItem opl: OppLineItems){
    	if(mapPriceBookEntries.containsKey(opl.PricebookEntryId)){
	        opl.HIDDEN_Product_Id__c = mapPriceBookEntries.get(opl.PricebookEntryId).Product2Id;//productMap.get(opl.PricebookEntryId);
	        productIds.add(opl.HIDDEN_Product_Id__c);
    	}
    	if(mapOpportunities.containsKey(opl.OpportunityId)){
    		userIds.add(mapOpportunities.get(opl.OpportunityId).OwnerId);
    	}
    }
    
    //Check for matching Commissions and Targets
    ctList = [Select c.Sales_Representative__c, C.Monthly_Target__c, C.Id, c.Commission_Rate_per_Activation__c,
                c.Product__c From Commission_Target__c c Where c.Sales_Representative__c in:userIds AND c.Product__c in:productIds];
        
    //Set field values on the Line Items
    if(ctList.Size()>0){
        for(OpportunityLineItem oneOPL: OppLineItems){
          for(Commission_Target__c oneCT: ctList){
          	if(mapOpportunities.containsKey(oneOPL.OpportunityId)){
	            if(mapOpportunities.get(oneOPL.OpportunityId).OwnerId == oneCT.Sales_Representative__c && oneOPL.HIDDEN_Product_Id__c == oneCT.Product__c){
	              oneOPL.Rate_per_Activation__c = oneCT.Commission_Rate_per_Activation__c;
	              oneOPL.Monthly_Target__c = oneCT.Monthly_Target__c;
	            }
          	}
          }
        }
    }            
    } 
}