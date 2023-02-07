trigger triggerAssignParentMarketAccount on Account (before insert, before update) {
    List<String> listBillingCountries = new List<String>();
    
    Id MarketAccountRecordTypeId = classCustomChart.getRecordTypeId_MarketAccount();
    
    for(Account acc: Trigger.new){
        if(acc.RecordTypeId != MarketAccountRecordTypeId){
            if(Trigger.isUpdate){
                if(Trigger.oldMap!=null && Trigger.oldMap.containsKey(acc.Id) 
                    && Trigger.oldMap.get(acc.Id).Billing_Country__c != acc.Billing_Country__c){
                        listBillingCountries.add(acc.Billing_Country__c);
                }
            }else{
                listBillingCountries.add(acc.Billing_Country__c);
            }
        }
    }
    
    
    List<Account> listMarketAccount = [SELECT Id, Billing_Country__c From Account WHERE Billing_Country__c IN: listBillingCountries
                                        AND RecordTypeId =: MarketAccountRecordTypeId];
    
    Map<String, Account> mapMarketAccount = new Map<String, Account>();
    for(Account mktAccount: listMarketAccount){
        mapMarketAccount.put(mktAccount.Billing_Country__c, mktAccount);
    }
    
    for(Account acc: Trigger.new){
        if(acc.RecordTypeId != MarketAccountRecordTypeId){
            if(mapMarketAccount.containsKey(acc.Billing_Country__c)){
                acc.Parent_Market_Account__c = mapMarketAccount.get(acc.Billing_Country__c).Id;
            }
        }
    }
}