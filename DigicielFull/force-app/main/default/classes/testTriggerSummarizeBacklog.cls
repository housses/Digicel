@isTest(seeAllData=false)
private class testTriggerSummarizeBacklog{
    static testMethod void myUnitTest_BacklogSummary() {
        RecordType recordType_JamaicaOpp = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_Business_Opportunity' AND SobjectType = 'Opportunity'];
        RecordType recordType_JamaicaAcc = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_Business_Account' AND SobjectType = 'Account'];
        RecordType recordType_HaitiAcc = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_Business_Account' AND SobjectType = 'Account'];
        RecordType recordType_MarketAcc = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_Business_Account' AND SobjectType = 'Account'];
        
        Account mktAcc = new Account(Name = 'Test Market Account',billing_Country__c='Jamaica', RecordTypeId = recordType_MarketAcc.Id);
        insert mktAcc;
        
        Account acc = new Account(Name = 'Test Account',billing_Country__c='Jamaica', RecordTypeId = recordType_JamaicaAcc.Id);
        insert acc;
        
        
        Test.startTest();
        
        Backlog__c backlog = new Backlog__c(Account_Name__c = mktAcc.Id, Date__c = System.today(), Target__c = 100, Backlog_Currency__c = 100, Current_Month__c = false);
        insert backlog;
        
        Backlog__c backlog2 = new Backlog__c(Account_Name__c = mktAcc.Id, Date__c = System.today().addMonths(1), Target__c = 100, Backlog_Currency__c = 100, Current_Month__c = true);
        insert backlog2;
        
        backlog.Target__c = 1000;
        update backlog;
        
        backlog.Date__c = System.today().addMonths(2);
        update backlog;
        
        delete backlog;
        
        acc.Billing_Country__c = 'Haiti';
        acc.RecordTypeId = recordType_HaitiAcc.Id;
        update acc;
        
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        String jobid = System.schedule('Prueba', CRON_EXP, new classVerifyBacklogsMonth());
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        // Verify the expressions are the same  
        System.assertEquals(CRON_EXP, ct.CronExpression);
    
        // Verify the job has not run  
        System.assertEquals(0, ct.TimesTriggered);
         
        Test.stopTest();
    }
    
    static testMethod void myUnitTest_BacklogWithoutSummary() {
        RecordType recordType_JamaicaOpp = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_Business_Opportunity' AND SobjectType = 'Opportunity'];
        RecordType recordType_JamaicaAcc = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_Business_Account' AND SobjectType = 'Account'];
        RecordType recordType_HaitiAcc = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_Business_Account' AND SobjectType = 'Account'];
        RecordType recordType_MarketAcc = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_Business_Account' AND SobjectType = 'Account'];
        
        Account acc = new Account(Name = 'Test Market Account',billing_Country__c='Jamaica', RecordTypeId = recordType_MarketAcc.Id);
        insert acc;
        
        Test.startTest();
        Summary__c[] allSummary = [Select Id From Summary__c];
        for (Summary__c sm:allSummary) {
            delete sm;
        }
        
        Backlog__c backlog = new Backlog__c(Account_Name__c = acc.Id, Date__c = System.today(), Target__c = 100, Backlog_Currency__c = 100, Current_Month__c = false);
        insert backlog;
        
        allSummary = [Select Id From Summary__c];
        for (Summary__c sm:allSummary) {
            delete sm;
        }
        
        backlog.Date__c = System.today().addMonths(2);
        update backlog;
        
        allSummary = [Select Id From Summary__c];
        for (Summary__c sm:allSummary) {
            delete sm;
        }
        
        delete backlog;
         
        Test.stopTest();
    }
}