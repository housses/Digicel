trigger updateAOP on Opportunity (after update) {
    List<Id> idsOpportunity = new List<Id>();
    
    for(Opportunity opp: Trigger.new){
        idsOpportunity.add(opp.Id);
    }
    OpportunityLineItem[] oliUpdateList = [Select Id, Net_Value_AOP_Installation_OTC__c, Net_Value_AOP_MRC__c, 
            Net_Value_AOP_Rental_or_Lease__c, Net_Contract_Value_Installation_OTC__c, Net_Contract_Value_MRC__c, 
            Net_Contract_Value_Rental_or_Lease__c, Net_Value_AOP_MRC_Currency__c, Net_Value_AOP_Installation_OTC_Currency__c ,
            Net_Value_AOP_Rental_or_Lease_Currency__c, Net_Contract_Value_Installation_OTC_Curr__c, Net_Contract_Value_MRC_Curr__c,
            Net_Contract_Value_Rental_or_Lease_Curr__c, Net_AOP_Total__c, Net_Contract_Value_Total__c
            from OpportunityLineItem where OpportunityId IN :idsOpportunity];
    
    List<OpportunityLineItem> listOppLineItem = new List<OpportunityLineItem>();
    for(OpportunityLineItem oli : oliUpdateList){
    
        if(oli.Net_Value_AOP_MRC_Currency__c != oli.Net_Value_AOP_MRC__c 
            || oli.Net_Value_AOP_Installation_OTC_Currency__c != oli.Net_Value_AOP_Installation_OTC__c
            || oli.Net_Value_AOP_Rental_or_Lease_Currency__c != oli.Net_Value_AOP_Rental_or_Lease__c
            || oli.Net_Contract_Value_Installation_OTC_Curr__c != oli.Net_Contract_Value_Installation_OTC__c
            || oli.Net_Contract_Value_MRC_Curr__c != oli.Net_Contract_Value_MRC__c
            || oli.Net_Contract_Value_Rental_or_Lease_Curr__c != oli.Net_Contract_Value_Rental_or_Lease__c
            || oli.Net_Contract_Value_Total__c != (oli.Net_Contract_Value_Installation_OTC__c + oli.Net_Contract_Value_MRC__c + oli.Net_Contract_Value_Rental_or_Lease__c)
            || oli.Net_AOP_Total__c != (oli.Net_Value_AOP_MRC__c + oli.Net_Contract_Value_Installation_OTC__c + oli.Net_Value_AOP_Rental_or_Lease__c)){
            
                oli.Net_Value_AOP_MRC_Currency__c = oli.Net_Value_AOP_MRC__c;
                oli.Net_Value_AOP_Installation_OTC_Currency__c = oli.Net_Value_AOP_Installation_OTC__c;
                oli.Net_Value_AOP_Rental_or_Lease_Currency__c = oli.Net_Value_AOP_Rental_or_Lease__c;
                oli.Net_Contract_Value_Installation_OTC_Curr__c = oli.Net_Contract_Value_Installation_OTC__c;
                oli.Net_Contract_Value_MRC_Curr__c = oli.Net_Contract_Value_MRC__c;
                oli.Net_Contract_Value_Rental_or_Lease_Curr__c = oli.Net_Contract_Value_Rental_or_Lease__c;
                oli.Net_Contract_Value_Total__c = oli.Net_Contract_Value_Installation_OTC__c + oli.Net_Contract_Value_MRC__c + oli.Net_Contract_Value_Rental_or_Lease__c;
                oli.Net_AOP_Total__c = oli.Net_Value_AOP_MRC__c + oli.Net_Contract_Value_Installation_OTC__c + oli.Net_Value_AOP_Rental_or_Lease__c;
                
                listOppLineItem.add(oli);
        }
    }
    
    if(listOppLineItem.size()>0) update listOppLineItem;

}