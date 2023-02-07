public with sharing class OpportunityUpdate{

    private static Decimal deposit = 0;
    private static Decimal monthlyFee = 0;
    private static List<Opportunity> opportunityList = new List<Opportunity>();
    private static List<Opportunity> oppsToBeUpdated = new List<Opportunity>();
    private static List<OpportunityLineItem> oppLineItemsList = new List<OpportunityLineItem>();
    private static Set<Id> finalOpportunityIdsToUpdate = new Set<Id>();
    
    public static void setOpportunityTotals(List<OpportunityLineItem> oppLineItems){
    //Clear values
    opportunityList.clear();
    oppsToBeUpdated.clear();
    oppLineItemsList.clear();
    finalOpportunityIdsToUpdate.clear();
    
    // Get the Opportunity Ids
    Set<Id> opportunityIds = new Set<Id>();
    for(OpportunityLineItem opl: OppLineItems){
        opportunityIds.add(opl.OpportunityId); 
           
    }
    
    //Get a list of Opportunities and their Line Items
    opportunityList = [Select o.Id, o.Customer_Deposit_Waived__c From Opportunity o Where o.Id in: opportunityIds];
    oppLineItemsList = [Select o.Id, o.UnitPrice, o.FORMULA_Monthly_Fee__c, o.FORMULA_Deposit__c, o.Quantity, o.OpportunityId  
                        From OpportunityLineItem o Where o.OpportunityId in:opportunityIds];
    
                        
    // Get the values from the Line Items and sum them up to the opportunity    
    system.debug('### opportunityList = ' + opportunityList);  
    for(Opportunity oneOpp:opportunityList){
        Decimal tmpMonthlyFee = 0; 
        Decimal tmpDeposit = 0;
        monthlyFee = 0;   
        deposit = 0;
        
        for(OpportunityLineItem oneOLI: oppLineItemsList){
            if(oneOLI.OpportunityId == oneOpp.Id){
              //Monthly Fee
              if(oneOLI.FORMULA_Monthly_Fee__c!= null){
                  system.debug('### monthlyFee = '+ oneOLI.FORMULA_Monthly_Fee__c);
                  system.debug('### Quantity = '+ oneOLI.Quantity);
                  tmpMonthlyFee = (oneOLI.FORMULA_Monthly_Fee__c * oneOLI.Quantity)* 12;
                  monthlyFee += tmpMonthlyFee;
                  system.debug('### Total monthlyFee = '+ tmpMonthlyFee);
            }
            
              //Deposit 
              if(oneOLI.FORMULA_Deposit__c != null){
                  system.debug('### Deposit = '+ oneOLI.FORMULA_Deposit__c);
                  system.debug('### Quantity = '+ oneOLI.Quantity);
                  tmpDeposit = oneOLI.FORMULA_Deposit__c * oneOLI.Quantity;
                  deposit += tmpDeposit;
                  system.debug('### Total Deposit = '+ deposit); 
              }
            }
        }
        
        // Check if deposit is waived for this customer and then set all totals
        if(oneOpp.Customer_Deposit_Waived__c == 'NO'){
            oneOpp.Total_Deposit__c = deposit;  
        }
        else{
            oneOpp.Total_Deposit__c = 0;    
        }
        
        oneOpp.Total_Recurring_Revenue__c = monthlyFee;
        
        /*Add Opportunity to the list for update - we need to put a check in place to make sure we are not 
          adding the same Id twice*/
        if(!finalOpportunityIdsToUpdate.contains(oneOpp.Id)){
            finalOpportunityIdsToUpdate.add(oneOpp.Id); 
            oppsToBeUpdated.add(oneOpp);   
        }
          
    }
        //Update Opportunity
        if(oppsToBeUpdated.size()>0){
            upsert oppsToBeUpdated;
        }            
                        
    }
}