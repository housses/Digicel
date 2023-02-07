/**
 * @description       : 
 * @author            : JBBARTHELEMY
 * @group             : 
 * @last modified on  : 08/11/2022
 * @last modified by  : JBBARTHELEMY
**/
@IsTest
public  class Infolegale_BAT_TST {
    
    @isTest
    static void testBatchInfolegale(){

        Map<String, Schema.RecordTypeInfo> accountRTs = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        Id accClientRT = accountRTs.get('Digicel_Business_Account').getRecordTypeId();
        Account acc = new Account(
            Name = 'TEST',
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
       
        Test.setMock(HttpCalloutMock.class, new MockInfolegale_TST());
        Test.startTest();
        Infolegale_BAT httpBatch = new Infolegale_BAT(new Set<Id>{acc.Id});
        Id batchJobId = Database.executebatch(httpBatch,100);  
        Test.stopTest();
        Account accToTest = [SELECT Id, INFOLEGALERating__c, Registration_Number__c FROM Account];
        system.assertEquals(6, accToTest.INFOLEGALERating__c, 'infolegale score should be the same ');
    }

}