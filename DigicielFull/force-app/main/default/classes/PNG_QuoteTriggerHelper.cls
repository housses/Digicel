public without sharing class PNG_QuoteTriggerHelper {
    
    public static void createContractRecord(Map<Id, Quote> newQuoteMap, Map<Id, Quote> oldQuoteMap){
        
        List<Quote> updatedQuotes=[select id,name,AccountID,OpportunityId,Opportunity.Opportunity_Contact__c,Opportunity.Contract_Term_SP__c,Status,RecordTypeId,PNG_QuoteType__c from Quote where id=:newQuoteMap.keySet() and RecordTypeId=:System.Label.PNG_ApprovedQuoteRecordType and Status =: System.Label.PNG_QStatusAccept];
        system.debug('Updated quotes '+ updatedQuotes);
        system.debug('Updated quotes size: '+ updatedQuotes.size());
                
        List<Contract> contractsList= new List<Contract>();
        
        if(updatedQuotes.size()>0){
        	
            for(Quote quote: updatedQuotes){
                if(oldQuoteMap.get(quote.Id).Status != Label.PNG_QStatusAccept){
                     contractsList.add(createNewContract(quote));
                }
            }
        }
        
        if(contractsList.size()>0){
            Database.insert(contractsList);
        }               
       
    }
        
    private static Contract createNewContract(Quote quote){
		
        Contract newContract = new Contract();
        newContract.RecordTypeId = Label.PNG_ContractRecordTypeId;					//Set PNG record type to contract
        newContract.Name = quote.Name + ' Contract';
        newContract.AccountId = quote.AccountId;
        newContract.Opportunity__c = quote.OpportunityId;
        newContract.Status = Label.PNG_ContractStatusDraft;    						//Set Contract status as draft     
        newContract.StartDate= Date.today();
        if(quote.Opportunity.Contract_Term_SP__c!=null){
            newContract.ContractTerm = quote.Opportunity.Contract_Term_SP__c.intValue();	//Set contract term from the opportunity
        }
        newContract.PNG_OpportunityContact__c = quote.Opportunity.Opportunity_Contact__c;	//Set opportunity contact
        newContract.PNG_Quote__c=quote.Id;
        newContract.PNG_Active__c=true;														//Make the contract active
        if(quote.PNG_QuoteType__c == Label.PNG_QTypeICT){
            newContract.Contract_Type__c = Label.PNG_QTypeICT;
        }
        else if(quote.PNG_QuoteType__c == Label.PNG_QTypeGSM){
            newContract.Contract_Type__c= Label.PNG_QTypeGSM;
        }
        else if(quote.PNG_QuoteType__c== System.Label.PNG_QTypeICTGSM){
            newContract.Contract_Type__c= System.Label.PNG_CTypeICTGSM;
        }
        system.debug('Contract: '+ newContract);
        
        return newContract;
    }
}