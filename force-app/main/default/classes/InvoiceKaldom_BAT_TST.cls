@isTest
public  class InvoiceKaldom_BAT_TST {

    @TestSetup
    static void makeData(){  
        Map<String, Schema.RecordTypeInfo> accountRTs = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        Id accClientRT = accountRTs.get('Digicel_Business_Account').getRecordTypeId();

        User user = [SELECT Id FROM User WHERE Digicel_Country__c = 'FWI' LIMIT 1];

        Account acc = new Account(
            Name = 'TEST',
            Owner = user,
            Active__c = true,
            BillingCity = 'Paris',
            TelesoftNumber__c = '50092',
            Registration_Number__c = '510464001',
            BillingCountryCode = 'BB',
            AvanceOrder__c = '',
            BillingPostalCode = '75004',
            BillingStreet = '7 rue de Rivoli',
            RecordTypeId = accClientRT);
        AccountTriggerHandler.triggerDisabled = true;
        insert acc;
        AccountTriggerHandler.triggerDisabled = false;
    }

    @isTest
    static void testBatchInvoiceKaldom(){

        Test.setMock(HttpCalloutMock.class, new MockLoginKaldom());
        Test.startTest();
        Id batchJobId = Database.executebatch(new InvoiceKaldom_BAT(13,14), 100);   
        Test.stopTest();
        
        List<Invoice__c> listToCheck = [SELECT Id, Name, ClientNumber__c FROM Invoice__c WHERE ClientNumber__c = '2590'];
        system.assert(listToCheck.size() > 0, 'size should be superior to 0');

    }

}