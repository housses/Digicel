public class DataFactory {

    /** 
    * ********************************************************
    * This method is test data for create multiple Accounts
    * ********************************************************
    */
    public static List<Account> insertAccounts(Integer numRecords, Boolean doInsert) {
        Test.setMock(HttpCalloutMock.class, new MockFactory_TST('MockInfolegale'));
        List<Account> results = new List<Account>();
        Map<String, Schema.RecordTypeInfo> accountRTs = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        Map<String, Schema.RecordTypeInfo> oppRTs = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName();
        Id accClientRT = accountRTs.get('Digicel_Business_Account').getRecordTypeId();

        for (Integer counter = 1; counter <= numRecords; counter++) {
            Account record = new Account();
            record.Name = 'TEST'+counter;
            record.Active__c = true;
            record.BillingCity = 'Paris';
            record.BillingCountryCode = 'FR';
            record.AvanceOrder__c = '';
            record.Registration_Number__c = '00000';
            record.BillingPostalCode = '75004';
            record.BillingStreet = '7 rue de Rivoli';
            record.RecordTypeId = accClientRT;
            results.add(record);
        }
        if(doInsert){
            AccountTriggerHandler.triggerDisabled = true;
            insert results;
            AccountTriggerHandler.triggerDisabled = false;
        }
        return results;
    }

    /** 
    * ********************************************************
    * This method is test data for create one Account
    * ********************************************************
    */
    public static Account createAccount(Boolean doInsert) {
        Test.setMock(HttpCalloutMock.class, new MockFactory_TST('MockInfolegale'));
      
        Map<String, Schema.RecordTypeInfo> accountRTs = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        // Map<String, Schema.RecordTypeInfo> oppRTs = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName();
        Id accClientRT = accountRTs.get('Digicel_Business_Account').getRecordTypeId();

        Account record = new Account();
        record.Name = 'TEST';
        record.Active__c = true;
        record.BillingCity = 'Paris';
        record.BillingCountryCode = 'FR';
        record.AvanceOrder__c = '';
        record.Registration_Number__c = '00000';
        record.BillingPostalCode = '75004';
        record.BillingStreet = '7 rue de Rivoli';
        record.RecordTypeId = accClientRT;
        if(doInsert){
            insert record;
        }
        return record;
    }

    /** 
    * ********************************************************
    * This method is test data for create multiple Invoices
    * ********************************************************
    */
    public static List<Invoice__c> insertInvoices(Integer numRecords, Account acc, Boolean doInsert) {
        List<Invoice__c> results = new List<Invoice__c>();
        for (Integer counter = 1; counter <= numRecords; counter++) {
            Invoice__c record = new Invoice__c();
            record.AccountName__c = acc.Id;
            record.InvoiceID__c = '111'+counter;
            record.TechMoreOlderThen12Months__c = true;
            results.add(record);
        }
        if(doInsert){
            insert results;
        }
        return results;
    }

}