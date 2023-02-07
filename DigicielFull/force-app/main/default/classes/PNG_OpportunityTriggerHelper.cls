public without sharing class PNG_OpportunityTriggerHelper {
    private static boolean run = true;
    static Map<Id,QuoteLineItem> lineItemsMap= new Map<Id,QuoteLineItem>();
    public static void createAssetRecords(Map<id, Opportunity> newOpportunityMap, Map<id, Opportunity> oldOpportunityMap){
        
        List<OpportunityLineItem> opportunityLineItems =[Select Id, name, OpportunityId, Quantity, Opportunity.AccountId, 
                                                         Opportunity.RecordTypeId, Opportunity.StageName, Opportunity.Opportunity_Contact__c,
                                                         Opportunity.ContractId, Product2Id, TotalPrice
                                                         From OpportunityLineItem where 
                                                         OpportunityId=:newOpportunityMap.keySet() and
                                                         Opportunity.RecordTypeId=:System.Label.PNG_OpprtunityRecordTypeId and 
                                                         Opportunity.StageName=:System.Label.PNG_OppClosedWon];
        system.debug('opportunityLineItems: '+ opportunityLineItems);
        Set<id> lineItemsIds = new Set<id>();
        for(OpportunityLineItem oli : opportunityLineItems){
            Id lineItemId=String.valueOf(oli.id).substring(0, 15);
            lineItemsIds.add(lineItemId);
        }
        system.debug('opportunityLineItems ids set: '+ lineItemsIds);
        List<QuoteLineItem> quoteLineItems=[Select id,QuoteId,OpportunityLineItemId,PNG_GPSCoordinates__Latitude__s,PNG_GPSCoordinates__Longitude__s
                                            from QuoteLineItem where Quote.IsSyncing=true and
                                            OpportunityLineItemId=:lineItemsIds];
        system.debug('quote Line items: '+quoteLineItems);
        
        for(QuoteLineItem qli: quoteLineItems){
            lineItemsMap.put(qli.OpportunityLineItemId, qli);
        }
        system.debug('map of line items:'+lineItemsMap);
        List<Asset> newAssetsList = new List<Asset>();
        if(opportunityLineItems.size()>0){            
            for(OpportunityLineItem lineItem: opportunityLineItems) {
                if(oldOpportunityMap.get(lineItem.OpportunityId).StageName != Label.PNG_OppClosedWon && run==true 
                   && lineItemsMap!=null && lineItemsMap.containsKey(lineItem.Id)){
                       system.debug('In for to go to create asset');
                	newAssetsList.add(createNewAsset(lineItem));
                }
            }
            
            run=false;
        }
        
        system.debug('asset list : '+ newAssetsList);
        if(newAssetsList.size()>0){
            Database.insert(newAssetsList);
        }
        system.debug('opportunityLineItems: '+ opportunityLineItems);
        
    }
    
    private static Asset createNewAsset(OpportunityLineItem lineItem){
        system.debug('In asset creation method');
        Asset newAsset = new Asset();
        newAsset.RecordTypeId = Label.PNG_AssetRecordTypeId;			//Set Record Type to PNG Asset Record Type
        newAsset.Name = lineItem.Name + ' : Asset ';					//Set Name to opportunity Line item name with asset appended
        newAsset.AccountId = lineItem.Opportunity.AccountId;			//Set AccountId as Account Id of opportunity
        newAsset.PurchaseDate = System.today();							//Set Purchase Date to today
        newAsset.Product2Id = lineItem.Product2Id;						//Set ProductId as productId of Opportunity line item
        newAsset.Quantity = lineItem.Quantity;							//Set Quantity as Quantity of Opportunity line item
        newAsset.Price = lineItem.TotalPrice;							//Set Total Price as Total Price of Opportunity line item
        newAsset.ContactId = lineItem.Opportunity.Opportunity_Contact__c;
        newAsset.PNG_Contract__c = lineItem.Opportunity.ContractId;
        QuoteLineItem quoteLineItem =lineItemsMap.get(lineItem.Id);
        newAsset.PNG_Location__Latitude__s=quoteLineItem.PNG_GPSCoordinates__Latitude__s;
        newAsset.PNG_Location__Longitude__s=quoteLineItem.PNG_GPSCoordinates__Longitude__s;
        system.debug('newAsset: '+ newAsset);
        return newAsset;
    }
    
}