/*This trigger will not affect the SP Users */

trigger triggerSummarizeBacklogUpdate on Backlog__c (after update) {
    Id[] recordTypeIds = new Id[]{
        '012d0000000tMaa','012d0000000tMaL','012d0000000tMaf',
        '012d0000000tMaQ','012d0000000tMaV','012d0000000sdor'};
    
    // Limit to a set of record types
    for(Backlog__c bl:trigger.new){
        Account[] queryResult = [Select Id From Account Where Id=:bl.Account_Name__c and RecordTypeId in:recordTypeIds];
        if(queryResult.size()>0) return;
    }
    
    System.debug('Trigger is running: triggerSummarizeBacklogUpdate');
    
    Map<String, Map<Date, Summary__c>> mapSummaryByCountry = new Map<String, Map<Date, Summary__c>>();
    Map<String, map<String, decimal>> convertionRate = classCustomChart.getConversionRate();
    
    List<String> billingCountries = new List<String>();
    List<Id> accountIds = new List<Id>();
    for(Backlog__c backlog: Trigger.new){
        accountIds.add(backlog.Account_Name__c);
    }
    for(Backlog__c backlog: Trigger.old){
        accountIds.add(backlog.Account_Name__c);
    }
    
    Map<Id, String> mapBillingCountry = new Map<Id, String>();
    List<Account> listAccount = [SELECT Id, Billing_Country__c FROM Account WHERE Id IN: accountIds];
    for(Account acc: listAccount){
        billingCountries.add(acc.Billing_Country__c);
        mapBillingCountry.put(acc.Id, acc.Billing_Country__c);
    }
    
    List<Summary__c> listSummary = [Select s.Weighted_Pipeline__c, s.Target_Total__c, s.Start_Date__c, 
                            s.Id, s.Estimated_AOP__c, s.End_Date__c, s.Committed_Pipeline__c, 
                            s.Billing_Country__c, s.Backlog_Total__c, s.CurrencyIsoCode,
                            s.Net_AOP_Installation_OTC__c, s.Net_AOP_MRC__c,
                            s.Net_AOP_Rental_or_Lease__c, s.Net_AOP_Total__c,
                            s.Net_Commited_Pipeline__c, s.Net_Contract_Value_Installation_OTC__c,
                            s.Net_Contract_Value_MRC__c, s.Net_Contract_Value_Rental_or_Lease__c,
                            s.Net_Contract_Value_Total__c, s.Net_Weighted_Pipeline__c, s.Amount__c,
                            s.Net_MTH_Installation_OTC__c, s.Net_MTH_MRC_Total__c,
                            s.Net_MTH_Rental_or_Lease__c, s.Net_MTH_Total__c
                            From Summary__c s
                            WHERE (s.Billing_Country__c IN: billingCountries or s.Billing_Country__c = NULL)];
                            
    for(Summary__c summary: listSummary){
        Map<Date, Summary__c> summaryByDate = new Map<Date, Summary__c>(); 
        
        if(mapSummaryByCountry.containsKey(summary.Billing_Country__c)){
            summaryByDate = mapSummaryByCountry.get(summary.Billing_Country__c);
        }
        
        summaryByDate.put(summary.Start_Date__c, summary);
        mapSummaryByCountry.put((summary.Billing_Country__c==null?'':summary.Billing_Country__c), summaryByDate);
    }
    
    for(Backlog__c backlog: Trigger.new){
        if(backlog.Date__c!=null){
            Decimal convertionRateUSD = convertionRate.get('USD').get(backlog.CurrencyIsoCode);
            
            String billingCountry = (mapBillingCountry.containsKey(backlog.Account_Name__c)?
                                        mapBillingCountry.get(backlog.Account_Name__c):'');
            
            Map<Date, Summary__c> summaryByDate = new Map<Date, Summary__c>();
            Summary__c summary = new Summary__c(); 
            if(mapSummaryByCountry.containsKey(billingCountry)){
                summaryByDate = mapSummaryByCountry.get(billingCountry);
            }
            if(summaryByDate.containsKey(backlog.Date__c.toStartOfMonth())){
                summary = summaryByDate.get(backlog.Date__c.toStartOfMonth());
            }
            
            if(summary.Id == null){
                summary.Billing_Country__c = billingCountry;
                summary.Start_Date__c = backlog.Date__c.toStartOfMonth();
                summary.End_Date__c = Date.newInstance(backlog.Date__c.year(), backlog.Date__c.month(), 
                                            Date.daysInMonth(backlog.Date__c.year(), backlog.Date__c.month()));
                summary.Weighted_Pipeline__c = 0;
                summary.Estimated_AOP__c = 0;
                summary.Committed_Pipeline__c = 0;
                summary.Target_Total__c = 0;
                summary.Backlog_Total__c = 0;
                summary.CurrencyIsoCode = 'USD';
                summary.Net_AOP_Installation_OTC__c = 0;
                summary.Net_AOP_MRC__c = 0;
                summary.Net_AOP_Rental_or_Lease__c = 0;
                summary.Net_AOP_Total__c = 0;
                summary.Net_Commited_Pipeline__c = 0;
                summary.Net_Contract_Value_Installation_OTC__c = 0;
                summary.Net_Contract_Value_MRC__c = 0;
                summary.Net_Contract_Value_Rental_or_Lease__c = 0;
                summary.Net_Contract_Value_Total__c = 0;
                summary.Net_Weighted_Pipeline__c = 0;
                summary.Amount__c = 0;
                summary.Net_MTH_Installation_OTC__c = 0;
                summary.Net_MTH_MRC_Total__c = 0;
                summary.Net_MTH_Rental_or_Lease__c = 0;
                summary.Net_MTH_Total__c = 0;
            }
            
            summary.Backlog_Total__c += (backlog.Backlog_Currency__c!=null? backlog.Backlog_Currency__c * convertionRateUSD : 0);
            summary.Target_Total__c += (backlog.Target__c!=null? backlog.Target__c * convertionRateUSD : 0);
            
            summaryByDate.put(summary.Start_Date__c, summary);
            mapSummaryByCountry.put(summary.Billing_Country__c, summaryByDate);
        }
    }
    
    for(Backlog__c backlog: Trigger.old){
        if(backlog.Date__c!=null){
            Decimal convertionRateUSD = convertionRate.get('USD').get(backlog.CurrencyIsoCode);
            
            String billingCountry = (mapBillingCountry.containsKey(backlog.Account_Name__c)?
                                        mapBillingCountry.get(backlog.Account_Name__c):'');
            
            Map<Date, Summary__c> summaryByDate = new Map<Date, Summary__c>();
            Summary__c summary = new Summary__c(); 
            if(mapSummaryByCountry.containsKey(billingCountry)){
                summaryByDate = mapSummaryByCountry.get(billingCountry);
            }
            if(summaryByDate.containsKey(backlog.Date__c.toStartOfMonth())){
                summary = summaryByDate.get(backlog.Date__c.toStartOfMonth());
            }
            
            if(summary.Id == null){
                summary.Billing_Country__c = billingCountry;
                summary.Start_Date__c = backlog.Date__c.toStartOfMonth();
                summary.End_Date__c = Date.newInstance(backlog.Date__c.year(), backlog.Date__c.month(), 
                                            Date.daysInMonth(backlog.Date__c.year(), backlog.Date__c.month()));
                summary.Weighted_Pipeline__c = 0;
                summary.Estimated_AOP__c = 0;
                summary.Committed_Pipeline__c = 0;
                summary.Target_Total__c = 0;
                summary.Backlog_Total__c = 0;
                summary.CurrencyIsoCode = 'USD';
                summary.Net_AOP_Installation_OTC__c = 0;
                summary.Net_AOP_MRC__c = 0;
                summary.Net_AOP_Rental_or_Lease__c = 0;
                summary.Net_AOP_Total__c = 0;
                summary.Net_Commited_Pipeline__c = 0;
                summary.Net_Contract_Value_Installation_OTC__c = 0;
                summary.Net_Contract_Value_MRC__c = 0;
                summary.Net_Contract_Value_Rental_or_Lease__c = 0;
                summary.Net_Contract_Value_Total__c = 0;
                summary.Net_Weighted_Pipeline__c = 0;
                summary.Amount__c = 0;
                summary.Net_MTH_Installation_OTC__c = 0;
                summary.Net_MTH_MRC_Total__c = 0;
                summary.Net_MTH_Rental_or_Lease__c = 0;
                summary.Net_MTH_Total__c = 0;
            }
            
            summary.Backlog_Total__c -= (backlog.Backlog_Currency__c!=null? backlog.Backlog_Currency__c * convertionRateUSD : 0);
            summary.Target_Total__c -= (backlog.Target__c!=null? backlog.Target__c * convertionRateUSD : 0);
            
            if(summary.Id!=null){
                summaryByDate.put(summary.Start_Date__c, summary);
                mapSummaryByCountry.put(summary.Billing_Country__c, summaryByDate);
            }
        }
    }
    
    List<Summary__c> listSummaryUpsert = new List<Summary__c>();
    for(String billingCountry: mapSummaryByCountry.keySet()){
        Map<Date, Summary__c> mapSummaryByDate = mapSummaryByCountry.get(billingCountry);
        listSummaryUpsert.addAll(mapSummaryByDate.values());
    }
    if(listSummaryUpsert.size()>0) upsert listSummaryUpsert;
}