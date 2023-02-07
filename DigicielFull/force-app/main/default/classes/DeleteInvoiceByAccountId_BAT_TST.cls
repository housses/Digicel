// This test class creates a test account and an invoice associated with that account. 
// Then it creates a set of the account IDs and calls the batch class. 
// After running the batch, the test verifies if the invoice has been deleted by checking if it still exists in the database.
@isTest
private class DeleteInvoiceByAccountId_BAT_TST {

    static testMethod void testBatch() {
        // Prepare test data
        Map<String, Schema.RecordTypeInfo> accountRTs = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        Id accClientRT = accountRTs.get('Digicel_Business_Account').getRecordTypeId();
        Account acc = new Account(
            Name = 'Test Account',
            Active__c = true,
            BillingCity = 'Paris',
            TelesoftNumber__c = null,
            Registration_Number__c = '510464001',
            BillingCountryCode = 'BB',
            AvanceOrder__c = '',
            BillingPostalCode = '75004',
            BillingStreet = '7 rue de Rivoli',
            RecordTypeId = accClientRT);
        insert acc;

        Invoice__c inv = new Invoice__c(AccountName__c=acc.Id);
        insert inv;

        // Get the set of account IDs
        Set<String> setAccountId = new Set<String>{acc.Id};

        // Call the batch class
        Test.startTest();
        DeleteInvoiceByAccountId_BAT batch = new DeleteInvoiceByAccountId_BAT(setAccountId);
        Id batchId = Database.executeBatch(batch, 200);
        Test.stopTest();

        // Verify the result
        List<Invoice__c> deletedInv = [SELECT Id FROM Invoice__c WHERE Id=:inv.Id];
        System.assertEquals(0, deletedInv.size(), 'The invoice should have been deleted');
    }
}