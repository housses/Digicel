/**
 * @description       : Class Test For ClientTelesoft_BAT
 * @author            : CLEPILLOUER
 * @last modified on  : 16/02/2023
 * @last modified by  : CLEPILLOUER
**/
@isTest
public class ClientTelesoft_BAT_TST {
 
    @TestSetup
    static void createTestData(){  
        Account acc = DataFactory.createAccount(true);
    }

    @isTest
    static void testBatchClientTelesoft(){
        Test.setMock(HttpCalloutMock.class, new MockFactory_TST('MockClientTelesoft'));

        Test.startTest();
        Id batchJobId = Database.executebatch(new ClientTelesoft_BAT() , 10);    
        Test.stopTest();

        Account acc = [SELECT Id, Name, TelesoftNumber__c , Registration_Number__c FROM Account];
        system.assertEquals('50003', acc.TelesoftNumber__c, 'acc.TelesoftNumber__c should be equal to 50003');
    }


}