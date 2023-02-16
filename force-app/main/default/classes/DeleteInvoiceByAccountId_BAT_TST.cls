// This test class creates a test account and an invoice associated with that account. 
// Then it creates a set of the account IDs and calls the batch class. 
// After running the batch, the test verifies if the invoice has been deleted by checking if it still exists in the database.
@isTest
private class DeleteInvoiceByAccountId_BAT_TST {

    @TestSetup
    static void createTestData() {
        Account acc = DataFactory.createAccount(true);
        List<Invoice__c> invs = DataFactory.insertInvoices(5, acc, true);
    }

    @isTest(seeAllData=false)
    public static void testBatch() {
        Set<String> setAccountId = (new Map<String, Account>([SELECT Id FROM Account])).keySet();
        Test.startTest();
        DeleteInvoiceByAccountId_BAT batch = new DeleteInvoiceByAccountId_BAT(setAccountId);
        Id batchId = Database.executeBatch(batch, 200);
        Test.stopTest();

        List<Invoice__c> deletedInv = [SELECT Id FROM Invoice__c];
        System.assertEquals(0, deletedInv.size(), 'The invoices should have been deleted => deletedInv size should be equal to 0');
    }
}