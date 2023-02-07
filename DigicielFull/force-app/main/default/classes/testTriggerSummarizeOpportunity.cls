@isTest (seeAllData=true)
private class testTriggerSummarizeOpportunity {
    static testMethod void myUnitTest_OpportunitySummaryInsert() {
        RecordType recordType_JamaicaOpp = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_Business_Opportunity' AND SobjectType = 'Opportunity'];
        RecordType recordType_JamaicaAcc = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_Business_Account' AND SobjectType = 'Account'];
        
        Account acc = new Account(Name = 'Test Account',billing_Country__c='Jamaica', RecordTypeId = recordType_JamaicaAcc.Id);
        insert acc;

        //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        insert pbk1;
        
        Product2 prd1 = new Product2 (Name='Test Product Entry 1', Country__c='Jamaica',Description='Test Product Entry 1',productCode = 'ABC', isActive = true);
        insert prd1;
        
        
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=50, isActive=true);
        insert pbe1;
        
        Summary__c summary = new Summary__c(); 
        summary.Billing_Country__c = acc.billing_Country__c;
        summary.Start_Date__c = (Date.today()+11).toStartOfMonth();
        summary.End_Date__c = Date.newInstance(Date.today().year(), Date.today().month(), 
                                    Date.daysInMonth(Date.today().year(), Date.today().month()));
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
        insert summary;
        
        Test.startTest();
        
        Opportunity opp1 = new Opportunity (Go_Live_Date_Approved__c = TRUE, Go_Live_Date__c = date.today(), Name='JM-beta',StageName='none',Estimated_Billed_Date__c = Date.today()+11,CloseDate=Date.today()+10,Pricebook2Id = pbe1.Pricebook2Id, AccountId = acc.id, RecordTypeId = recordType_JamaicaOpp.Id, Country__c = 'Jamaica');
        insert opp1;
        
        Opportunity opp2 = new Opportunity (Go_Live_Date_Approved__c = TRUE, Go_Live_Date__c = date.today(), Name='JM-beta',StageName='none',Estimated_Billed_Date__c = Date.today().addMonths(2),CloseDate=Date.today()+10,Pricebook2Id = pbe1.Pricebook2Id, AccountId = acc.id, RecordTypeId = recordType_JamaicaOpp.Id, Country__c = 'Jamaica');
        insert opp2;
        
        // System.debug('Product Id:' + prd1.Id);
        // System.debug('PriceBook Entry Product Id:' + pbe1.Product2ID);
        // OpportunityLineItem lineItem1 = new OpportunityLineItem (OpportunityID=opp1.Id,PriceBookEntryID=pbe1.id, quantity=4,Charge_Type__c='Installation');
        // insert lineItem1;
        // OpportunityLineItem lineItem2 = new OpportunityLineItem (OpportunityID=opp1.Id,PriceBookEntryID=pbe1.id, quantity=4,Charge_Type__c='OTC');
        // insert lineItem2;
        // OpportunityLineItem lineItem3 = new OpportunityLineItem (OpportunityID=opp1.Id,PriceBookEntryID=pbe1.id, quantity=4,Charge_Type__c='MRC');
        // insert lineItem3;
        
        Test.stopTest();
    }
    
    static testMethod void myUnitTest_OpportunitySummaryUpdate() {
        RecordType recordType_JamaicaOpp = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_Business_Opportunity' AND SobjectType = 'Opportunity'];
        RecordType recordType_JamaicaAcc = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_Business_Account' AND SobjectType = 'Account'];
        
        Account acc = new Account(Name = 'Test Account',billing_Country__c='Jamaica', RecordTypeId = recordType_JamaicaAcc.Id);
        insert acc;
        
        //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        insert pbk1;
        
        Product2 prd1 = new Product2 (Name='Test Product Entry 1', Country__c='Jamaica',Description='Test Product Entry 1',productCode = 'ABC', isActive = true);
        insert prd1;
        
        
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=50, isActive=true);
        insert pbe1;
        
        
        Opportunity opp1 = new Opportunity (Go_Live_Date_Approved__c = TRUE, Go_Live_Date__c = date.today(), Name='JM-beta',StageName='none',Estimated_Billed_Date__c = Date.today()+11,CloseDate=Date.today()+10,Pricebook2Id = pbe1.Pricebook2Id, AccountId = acc.id, RecordTypeId = recordType_JamaicaOpp.Id, Country__c = 'Jamaica');
        insert opp1;
        
        Opportunity opp2 = new Opportunity (Go_Live_Date_Approved__c = TRUE, Go_Live_Date__c = date.today(), Name='JM-beta',StageName='none',Estimated_Billed_Date__c = Date.today().addMonths(2),CloseDate=Date.today()+10,Pricebook2Id = pbe1.Pricebook2Id, AccountId = acc.id, RecordTypeId = recordType_JamaicaOpp.Id, Country__c = 'Jamaica');
        insert opp2;
        
        System.debug('Product Id:' + prd1.Id);
        System.debug('PriceBook Entry Product Id:' + pbe1.Product2ID);
        OpportunityLineItem lineItem1 = new OpportunityLineItem (OpportunityID=opp1.Id,PriceBookEntryID=pbe1.id, quantity=4,Charge_Type__c='Installation');
        insert lineItem1;
        OpportunityLineItem lineItem2 = new OpportunityLineItem (OpportunityID=opp1.Id,PriceBookEntryID=pbe1.id, quantity=4,Charge_Type__c='OTC');
        insert lineItem2;
        OpportunityLineItem lineItem3 = new OpportunityLineItem (OpportunityID=opp1.Id,PriceBookEntryID=pbe1.id, quantity=4,Charge_Type__c='MRC');
        insert lineItem3;
        
        
        Test.startTest();
        
        opp1.CloseDate = System.today().addMonths(2);
        opp1.Estimated_Billed_Date__c = System.today().addMonths(5);
        //opp1.Actual_Billed_Date__c = System.today().addMonths(6);
        update opp1;
        
        Test.stopTest();
    }
    
    static testMethod void myUnitTest_OpportunitySummaryDelete() {
        RecordType recordType_JamaicaOpp = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_Business_Opportunity' AND SobjectType = 'Opportunity'];
        RecordType recordType_JamaicaAcc = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_Business_Account' AND SobjectType = 'Account'];
        
        Account acc = new Account(Name = 'Test Account',billing_Country__c='Jamaica', RecordTypeId = recordType_JamaicaAcc.Id);
        insert acc;
        
        //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        insert pbk1;
        
        Product2 prd1 = new Product2 (Name='Test Product Entry 1', Country__c='Jamaica',Description='Test Product Entry 1',productCode = 'ABC', isActive = true);
        insert prd1;
        
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=50, isActive=true);
        insert pbe1;
        
        Opportunity opp1 = new Opportunity (Go_Live_Date_Approved__c = TRUE, Go_Live_Date__c = date.today(), Name='JM-beta',StageName='none',Estimated_Billed_Date__c = Date.today()+11,CloseDate=Date.today()+10,Pricebook2Id = pbe1.Pricebook2Id, AccountId = acc.id, RecordTypeId = recordType_JamaicaOpp.Id, Country__c = 'Jamaica');
        insert opp1;
        
        Opportunity opp2 = new Opportunity (Go_Live_Date_Approved__c = TRUE, Go_Live_Date__c = date.today(), Name='JM-beta',StageName='none',Estimated_Billed_Date__c = Date.today().addMonths(2),CloseDate=Date.today()+10,Pricebook2Id = pbe1.Pricebook2Id, AccountId = acc.id, RecordTypeId = recordType_JamaicaOpp.Id, Country__c = 'Jamaica');
        insert opp2;
        
        System.debug('Product Id:' + prd1.Id);
        System.debug('PriceBook Entry Product Id:' + pbe1.Product2ID);
        OpportunityLineItem lineItem1 = new OpportunityLineItem (OpportunityID=opp1.Id,PriceBookEntryID=pbe1.id, quantity=4,Charge_Type__c='Installation');
        insert lineItem1;
        OpportunityLineItem lineItem2 = new OpportunityLineItem (OpportunityID=opp1.Id,PriceBookEntryID=pbe1.id, quantity=4,Charge_Type__c='OTC');
        insert lineItem2;
        OpportunityLineItem lineItem3 = new OpportunityLineItem (OpportunityID=opp1.Id,PriceBookEntryID=pbe1.id, quantity=4,Charge_Type__c='MRC');
        insert lineItem3;
        
        Test.startTest();
        
        delete opp1;
        
        //Summary__c[] summaries = [Select Id From Summary__c];
        //delete summaries;
        
        delete opp2;
        
        Test.stopTest();
    }
}