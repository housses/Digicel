/**
 * @description       : 
 * @author            : JBBARTHELEMY
 * @group             : 
 * @last modified on  : 08/11/2022
 * @last modified by  : JBBARTHELEMY
**/
@isTest
public class ClientTelesoft_BAT_TST {
 
    @TestSetup
    static void makeData(){  
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
    }

        @isTest
        static void testBatchClientTelesoft(){
           
            Test.setMock(HttpCalloutMock.class, new MockClientTelesoft_TST());
            Test.startTest();
            ClientTelesoft_BAT httpBatch = new ClientTelesoft_BAT();
            Id batchJobId = Database.executebatch(httpBatch,100);    
            Test.stopTest();
            Account acc = [SELECT Id, Name, TelesoftNumber__c , Registration_Number__c FROM Account];
            system.assertEquals('50003', acc.TelesoftNumber__c, 'should be the same');
        }


}