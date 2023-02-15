/*This trigger will not affect the SP Users */

trigger triggerSummarizeOpportunitiesDelete on Opportunity (after delete) {
    Id[] recordTypeIds = new Id[]{
        '012d0000000tMdA','012d0000000sds8','012d0000000tMdF',
        '012d0000000tMcq','012d0000000sdru','012d0000000tMd5',
        '012d0000000tMdU','012d0000000sdsF','012d0000000tMdZ',
        '012d0000000tMdK','012d0000000sds9','012d0000000tMdP',
        '012d0000000tMde','012d0000000sdsI','012d0000000tMdj',
        '012d0000000sds4'};
    
    // Limit to a set of record types
    for(Opportunity opp:trigger.old){
        for (Id rt:recordTypeIds)
        {
            if (rt == opp.RecordTypeId) return;
        }
    }

    System.debug('Trigger is running: triggerSummarizeOpportunitiesDelete'); 
    
    List<String> billingCountries = new List<String>();
    Map<String, Map<Date, Summary__c>> mapSummaryByCountry = new Map<String, Map<Date, Summary__c>>();
    Map<String,Map<Date, List<Summary_by_Charge_Type__c>>> mapChargeTypeSummaryByCountry = new Map<String,Map<Date, List<Summary_by_Charge_Type__c>>>();
    Map<String, map<String, decimal>> convertionRate = classCustomChart.getConversionRate();
    
    Map<Id, Id> mapUpdatedSummary = new Map<Id,Id>();
    
    List<Id> idsAccount = new List<Id>();
    List<Integer> listYears = new List<Integer>();
    List<Integer> listMonths = new List<Integer>();
    for(Opportunity opp: Trigger.old){
        if(opp.AccountId!=null) idsAccount.add(opp.AccountId);
        if(opp.Estimated_Billed_Date__c!=null) listMonths.add(opp.Estimated_Billed_Date__c.month());
        if(opp.Estimated_Billed_Date__c!=null) listYears.add(opp.Estimated_Billed_Date__c.year());
    }
    
    Map<Id, Account> mapAccounts = new Map<Id, Account>([SELECT Id, Billing_Country__c FROM Account WHERE Id IN: idsAccount]);
    
    for(Account acc: mapAccounts.values()){
        billingCountries.add(acc.Billing_Country__c);
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
                            s.Net_MTH_Rental_or_Lease__c, s.Net_MTH_Total__c,
                            (Select Id, Name, CurrencyIsoCode, Charge_Type__c, Charge_Value__c, 
                            Summary__c From Summaries_by_Charge_Type__r) From Summary__c s
                            WHERE (s.Billing_Country__c IN: billingCountries or s.Billing_Country__c != null)
                            AND CALENDAR_MONTH(s.Start_Date__c) IN: listMonths
                            AND CALENDAR_YEAR(s.Start_Date__c) IN: listYears];
                            
    for(Summary__c summary: listSummary){
        Map<Date, Summary__c> summaryByDate = new Map<Date, Summary__c>(); 
        
        if(mapSummaryByCountry.containsKey(summary.Billing_Country__c)){
            summaryByDate = mapSummaryByCountry.get(summary.Billing_Country__c);
        }
        
        summaryByDate.put(summary.Start_Date__c, summary);
        mapSummaryByCountry.put((summary.Billing_Country__c==null?'':summary.Billing_Country__c), summaryByDate);
        
        List<Summary_by_Charge_Type__c> listSummaryByChargeType = (List<Summary_by_Charge_Type__c>) summary.Summaries_by_Charge_Type__r;
        Map<Date, List<Summary_by_Charge_Type__c>> mapChargeTypeSummaryByDate = new Map<Date, List<Summary_by_Charge_Type__c>>();
        
        if(mapChargeTypeSummaryByCountry.containsKey(summary.Billing_Country__c)){
            mapChargeTypeSummaryByDate = mapChargeTypeSummaryByCountry.get(summary.Billing_Country__c); 
        }
        if(mapChargeTypeSummaryByDate.containsKey(summary.Start_Date__c)){
            listSummaryByChargeType.addAll(mapChargeTypeSummaryByDate.get(summary.Start_Date__c));
        }
        
        mapChargeTypeSummaryByDate.put(summary.Start_Date__c, listSummaryByChargeType);
        mapChargeTypeSummaryByCountry.put(summary.Billing_Country__c, mapChargeTypeSummaryByDate);
    }
    
    for(Opportunity opp: Trigger.old){
        if(opp.Estimated_Billed_Date__c!=null){
            String accountBillingCountry = (mapAccounts.containsKey(opp.AccountId)?
                                                mapAccounts.get(opp.AccountId).Billing_Country__c:'');
            
            Decimal convertionRateUSD = convertionRate.get('USD').get(opp.CurrencyIsoCode);
            
            Map<Date, Summary__c> summaryByDate = new Map<Date, Summary__c>();
            Summary__c summary = new Summary__c(); 
            
            if(mapSummaryByCountry.containsKey(accountBillingCountry)){
                summaryByDate = mapSummaryByCountry.get(accountBillingCountry);
            }
            if(summaryByDate.containsKey(opp.Estimated_Billed_Date__c.toStartOfMonth())){
                summary = summaryByDate.get(opp.Estimated_Billed_Date__c.toStartOfMonth());
            }
            
            List<Summary_by_Charge_Type__c> listSummaryByChargeType = (List<Summary_by_Charge_Type__c>) summary.Summaries_by_Charge_Type__r;
            Map<Date, List<Summary_by_Charge_Type__c>> mapChargeTypeSummaryByDate = new Map<Date, List<Summary_by_Charge_Type__c>>();
            
            if(mapChargeTypeSummaryByCountry.containsKey(accountBillingCountry)){
                mapChargeTypeSummaryByDate = mapChargeTypeSummaryByCountry.get(accountBillingCountry);
            }
            if(mapChargeTypeSummaryByDate.containsKey(opp.Estimated_Billed_Date__c.toStartOfMonth())){
                listSummaryByChargeType = mapChargeTypeSummaryByDate.get(opp.Estimated_Billed_Date__c.toStartOfMonth());
            }
            
            if(summary.Id == null){
                summary.Billing_Country__c = accountBillingCountry;
                summary.Start_Date__c = opp.Estimated_Billed_Date__c.toStartOfMonth();
                summary.End_Date__c = Date.newInstance(opp.Estimated_Billed_Date__c.year(), opp.Estimated_Billed_Date__c.month(), 
                                            Date.daysInMonth(opp.Estimated_Billed_Date__c.year(), opp.Estimated_Billed_Date__c.month()));
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
            }else{
                mapUpdatedSummary.put(summary.Id, summary.Id);
            }
            
            Integer monthDifference = 16 - summary.Start_Date__c.month();
            Decimal estimatedAOP = (opp.Estimated_Billed_Date__c!=null?opp.Installation__c + opp.OTC__c + ((opp.MRC__c + opp.Rental_or_Lease__c) * (monthDifference>12?(monthDifference-12):monthDifference)):0);
            Decimal commitedPipeline = (opp.StageName == 'Closed Won'?estimatedAOP:0);
            Decimal weightedPipeline = (opp.Probability > 0.33 && !opp.IsClosed?estimatedAOP:0);
            Decimal netCommitedPipeline = (opp.StageName == 'Closed Won' && opp.Net_AOP_Total__c!=null?opp.Net_AOP_Total__c:0);
            Decimal netWeightedPipeline = (opp.Probability > 0.33 && !opp.IsClosed && opp.Net_AOP_Total__c!=null?opp.Net_AOP_Total__c:0);
            Decimal netMthTotal = (opp.Net_MTH_Installation_OTC__c!=null?opp.Net_MTH_Installation_OTC__c:0)+
                                    (opp.Net_MTH_MRC_Total__c!=null?opp.Net_MTH_MRC_Total__c:0)+
                                    (opp.Net_MTH_Rental_or_Lease__c!=null?opp.Net_MTH_Rental_or_Lease__c:0);
            
            summary.Committed_Pipeline__c += (commitedPipeline!=null?commitedPipeline * convertionRateUSD:0);
            summary.Estimated_AOP__c += (estimatedAOP!=null?estimatedAOP * convertionRateUSD:0);
            summary.Weighted_Pipeline__c += (weightedPipeline!=null?weightedPipeline * convertionRateUSD:0);
            summary.Net_AOP_Installation_OTC__c += (opp.Net_AOP_Installation_OTC__c!=null?opp.Net_AOP_Installation_OTC__c * convertionRateUSD:0);
            summary.Net_AOP_MRC__c += (opp.Net_AOP_MRC__c!=null?opp.Net_AOP_MRC__c * convertionRateUSD:0);
            summary.Net_AOP_Rental_or_Lease__c += (opp.Net_AOP_Rental_or_Lease__c!=null?opp.Net_AOP_Rental_or_Lease__c * convertionRateUSD:0);
            summary.Net_AOP_Total__c += (opp.Net_AOP_Total__c!=null?opp.Net_AOP_Total__c * convertionRateUSD:0);
            summary.Net_Contract_Value_Installation_OTC__c += (opp.Net_Contract_Value_Installation_OTC__c!=null?opp.Net_Contract_Value_Installation_OTC__c * convertionRateUSD:0);
            summary.Net_Contract_Value_MRC__c += (opp.Net_Contract_Value_MRC__c!=null?opp.Net_Contract_Value_MRC__c * convertionRateUSD:0);
            summary.Net_Contract_Value_Rental_or_Lease__c += (opp.Net_Contract_Value_Rental_or_Lease__c!=null?opp.Net_Contract_Value_Rental_or_Lease__c * convertionRateUSD:0);
            summary.Net_Contract_Value_Total__c += (opp.Net_Contract_Value_Total__c!=null?opp.Net_Contract_Value_Total__c * convertionRateUSD:0);
            summary.Net_Commited_Pipeline__c += (netCommitedPipeline!=null?netCommitedPipeline * convertionRateUSD:0);
            summary.Net_Weighted_Pipeline__c += (netWeightedPipeline!=null?netWeightedPipeline * convertionRateUSD:0);
            summary.Net_MTH_Installation_OTC__c += (opp.Net_MTH_Installation_OTC__c!=null?opp.Net_MTH_Installation_OTC__c * convertionRateUSD:0);
            summary.Net_MTH_MRC_Total__c += (opp.Net_MTH_MRC_Total__c!=null?opp.Net_MTH_MRC_Total__c * convertionRateUSD:0);
            summary.Net_MTH_Rental_or_Lease__c += (opp.Net_MTH_Rental_or_Lease__c!=null?opp.Net_MTH_Rental_or_Lease__c * convertionRateUSD:0);
            summary.Net_MTH_Total__c += (netMthTotal!=null?netMthTotal * convertionRateUSD:0);
            summary.Amount__c += (opp.Amount!=null?opp.Amount * convertionRateUSD:0);    
            
            
            if(summary.Id != null){
                summaryByDate.put(summary.Start_Date__c, summary);
                mapSummaryByCountry.put(summary.Billing_Country__c, summaryByDate);
            }
            Boolean foundInstallation = false;
            Boolean foundMRC = false;
            Boolean foundOTC = false;
            Boolean foundRentalLease = false;
            Boolean foundMRCByContract = false;
            Boolean foundEstimatedAOP = false;
            Boolean foundContractValue = false;
            
            for(Summary_by_Charge_Type__c summaryChargeType: listSummaryByChargeType){
                if(summaryChargeType.Charge_Type__c == 'Installation'){ 
                    summaryChargeType.Charge_Value__c += (opp.Installation__c!=null?opp.Installation__c * convertionRateUSD:0);
                    foundInstallation=true;
                }
                if(summaryChargeType.Charge_Type__c == 'MRC by Contract Term'){ 
                    summaryChargeType.Charge_Value__c += (opp.MRC_by_Contract_Term__c!=null?opp.MRC_by_Contract_Term__c * convertionRateUSD:0);
                    foundMRCByContract=true;
                }
                if(summaryChargeType.Charge_Type__c == 'OTC'){ 
                    summaryChargeType.Charge_Value__c += (opp.OTC__c!=null?opp.OTC__c * convertionRateUSD:0);
                    foundOTC=true;
                }
                if(summaryChargeType.Charge_Type__c == 'Rental or Lease'){ 
                    summaryChargeType.Charge_Value__c += (opp.Rental_or_Lease__c!=null?opp.Rental_or_Lease__c * convertionRateUSD:0);
                    foundRentalLease=true;
                }
                if(summaryChargeType.Charge_Type__c == 'MRC'){ 
                    summaryChargeType.Charge_Value__c += (opp.MRC__c!=null?opp.MRC__c * convertionRateUSD:0);
                    foundMRC=true;
                }
                if(summaryChargeType.Charge_Type__c == 'Contract Value'){ 
                    summaryChargeType.Charge_Value__c += (opp.Contract_Value__c!=null?opp.Contract_Value__c * convertionRateUSD:0);
                    foundContractValue=true;
                }
                if(summaryChargeType.Charge_Type__c == 'Estimated AOP'){ 
                    summaryChargeType.Charge_Value__c += (opp.Estimated_AOP__c!=null?opp.Estimated_AOP__c * convertionRateUSD:0);
                    foundEstimatedAOP=true;
                }
            }
            
            if(!foundInstallation){
                listSummaryByChargeType.add(new Summary_by_Charge_Type__c(
                        Charge_Type__c = 'Installation',
                        Charge_Value__c = (opp.Installation__c!=null?opp.Installation__c * convertionRateUSD:0)));
            }
            if(!foundMRC){
                listSummaryByChargeType.add(new Summary_by_Charge_Type__c(
                        Charge_Type__c = 'MRC by Contract Term',
                        Charge_Value__c = (opp.MRC_by_Contract_Term__c!=null?opp.MRC_by_Contract_Term__c * convertionRateUSD:0)));
            }
            if(!foundOTC){
                listSummaryByChargeType.add(new Summary_by_Charge_Type__c(
                        Charge_Type__c = 'OTC',
                        Charge_Value__c = (opp.OTC__c!=null?opp.OTC__c * convertionRateUSD:0)));
            }
            if(!foundRentalLease){
                listSummaryByChargeType.add(new Summary_by_Charge_Type__c(
                        Charge_Type__c = 'Rental or Lease',
                        Charge_Value__c = (opp.Rental_or_Lease__c!=null?opp.Rental_or_Lease__c * convertionRateUSD:0)));
            }
            if(!foundMRC){
                listSummaryByChargeType.add(new Summary_by_Charge_Type__c(
                        Charge_Type__c = 'MRC',
                        Charge_Value__c = (opp.MRC__c!=null?opp.MRC__c * convertionRateUSD:0)));
            }
            if(!foundEstimatedAOP){
                listSummaryByChargeType.add(new Summary_by_Charge_Type__c(
                        Charge_Type__c = 'Estimated AOP',
                        Charge_Value__c = (opp.Estimated_AOP__c!=null?opp.Estimated_AOP__c * convertionRateUSD:0)));
            }
            if(!foundContractValue){
                listSummaryByChargeType.add(new Summary_by_Charge_Type__c(
                        Charge_Type__c = 'Contract Value',
                        Charge_Value__c = (opp.Contract_Value__c!=null?opp.Contract_Value__c * convertionRateUSD:0)));
            }
            
            if(summary.Id!=null){
                mapChargeTypeSummaryByDate.put(summary.Start_Date__c,listSummaryByChargeType);
                mapChargeTypeSummaryByCountry.put(summary.Billing_Country__c, mapChargeTypeSummaryByDate);
            }
            
        }
    }
    
    List<Summary__c> listSummary_Upsert = new List<Summary__c>();
    List<Summary_by_Charge_Type__c> listSummaryChargeType_Upsert = new List<Summary_by_Charge_Type__c>();
   
    for(String billingCountry: mapSummaryByCountry.keySet()){
        Map<Date, Summary__c> mapSummaryByDate = mapSummaryByCountry.get(billingCountry);
        for(Date d: mapSummaryByDate.keySet()){
            Summary__c summary = mapSummaryByDate.get(d);
            if(summary.Id == null || mapUpdatedSummary.containsKey(summary.Id)){
                listSummary_Upsert.add(summary);
            }
        }
    }
    
    if(listSummary_Upsert.size()>0) upsert listSummary_Upsert;
    
    for(String billingCountry: mapChargeTypeSummaryByCountry.keySet()){
        Map<Date, List<Summary_by_Charge_Type__c>> mapChargeTypeSummaryByDate = mapChargeTypeSummaryByCountry.get(billingCountry);
        for(Date d: mapChargeTypeSummaryByDate.keySet()){
            List<Summary_by_Charge_Type__c> listChargeTypeSummary = mapChargeTypeSummaryByDate.get(d);
            for(Summary_by_Charge_Type__c chargeTypeSummary: listChargeTypeSummary){
                if(mapSummaryByCountry.containsKey(billingCountry)&&mapSummaryByCountry.get(billingCountry).containsKey(d)){
                    if(chargeTypeSummary.Summary__c == null)
                        chargeTypeSummary.Summary__c = mapSummaryByCountry.get(billingCountry).get(d).Id;
                    if(mapUpdatedSummary.containsKey(mapSummaryByCountry.get(billingCountry).get(d).Id)){
                        listSummaryChargeType_Upsert.add(chargeTypeSummary);
                    }
                }
            }
        }
    }
    
    if(listSummaryChargeType_Upsert.size()>0) upsert listSummaryChargeType_Upsert;
}