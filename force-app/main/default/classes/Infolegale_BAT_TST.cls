/**
 * @description       : Class test for Infolegale_BAT
 * @author            : CLEPILLOUER
 * @last modified on  : 16/02/2023
 * @last modified by  : CLEPILLOUER
**/
@IsTest
public  class Infolegale_BAT_TST {
    
    @TestSetup
    static void createTestData() {
        Account acc = DataFactory.createAccount(true);
    }

    @isTest
    static void testBatchInfolegale(){
        Set<Id> ids = (new Map<Id, Account>([SELECT Id FROM Account])).keySet();
        Test.setMock(HttpCalloutMock.class, new MockFactory_TST('MockInfolegale'));
        Test.startTest();
        Id batchJobId = Database.executebatch(new Infolegale_BAT(ids) , 100);  
        Test.stopTest();
        Account accToTest = [SELECT Id, INFOLEGALERating__c, Registration_Number__c FROM Account];
        system.assertEquals(6, accToTest.INFOLEGALERating__c, 'infolegale score should be the same ');
    }

}