@isTest
public class AccountTriggerHandler_TST {

    @isTest
    public static void checkHandler() {
        Test.setMock(HttpCalloutMock.class, new MockInfolegale_TST());

        Map<String, Schema.RecordTypeInfo> accountRTs = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        Map<String, Schema.RecordTypeInfo> oppRTs = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName();
        Id accClientRT = accountRTs.get('Digicel_Business_Account').getRecordTypeId();

        Account acc = new Account(
            Name = 'TEST',
            Active__c = true,
            BillingCity = 'Paris',
            BillingCountryCode = 'BB',
            AvanceOrder__c = '',
            Registration_Number__c = '00000',
            BillingPostalCode = '75004',
            BillingStreet = '7 rue de Rivoli',
            RecordTypeId = accClientRT);
        insert acc;
        Invoice__c inv = new Invoice__c(
            AccountName__c = acc.Id,
            InvoiceID__c = '111',
            TechMoreOlderThen12Months__c = true
        );
        insert inv;

        acc.Registration_Number__c = '00001';
        update acc;

        Account accToTest = [SELECT Registration_Number__c FROM Account LIMIT 1];
        List<Invoice__c> listToCheck = [SELECT Id, Name FROM Invoice__c WHERE AccountName__c = :accToTest.Id];
        System.assertEquals(acc.Registration_Number__c, '00001', 'should be the same ');
        System.assertEquals(listToCheck.size(), 0, 'should be empty ');


        delete acc;
        
        AccountTriggerHandler trigg = new AccountTriggerHandler();
        String nameTrigger = trigg.getTriggerName();
        System.assertEquals(nameTrigger, 'AccountTrigger', 'should be AccountTrigger');
    }
}