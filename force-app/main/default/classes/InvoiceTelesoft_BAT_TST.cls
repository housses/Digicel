/**
 * @description       : 
 * @author            : JBBARTHELEMY
 * @group             : 
 * @last modified on  : 08/11/2022
 * @last modified by  : JBBARTHELEMY
**/
@isTest
public class InvoiceTelesoft_BAT_TST {
 
    @TestSetup
    static void makeData(){  
        Map<String, Schema.RecordTypeInfo> accountRTs = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        Id accClientRT = accountRTs.get('Digicel_Business_Account').getRecordTypeId();
        Account acc = new Account(
            Name = 'TEST',
            Active__c = true,
            BillingCity = 'Paris',
            TelesoftNumber__c = '50092',
            Registration_Number__c = '510464001',
            BillingCountryCode = 'BB',
            AvanceOrder__c = '',
            BillingPostalCode = '75004',
            BillingStreet = '7 rue de Rivoli',
            RecordTypeId = accClientRT);
        insert acc;
       
        Test.setMock(HttpCalloutMock.class, new MockFactory_TST('MockInfolegale'));
        Test.startTest();
        Infolegale_BAT httpBatch = new Infolegale_BAT(new Set<Id>{acc.Id});
        Id batchJobId = Database.executebatch(httpBatch,100);   
        Test.stopTest();
    }

        @isTest
        static void testBatchClientTelesoft(){        
            Test.setMock(HttpCalloutMock.class, new MockFactory_TST('MockInvoiceTelesoft'));

            Test.startTest();
            InvoiceTelesoft_BAT httpBatch2 = new InvoiceTelesoft_BAT(0,1);
            Id batchJobId2 = Database.executebatch(httpBatch2,100);    
            Test.stopTest();
            
            Account acc = [SELECT Id, Name, TelesoftNumber__c , Registration_Number__c FROM Account];
            List<Invoice__c> listToCheck = [SELECT Id, Name, ClientNumber__c FROM Invoice__c WHERE ClientNumber__c = '50092' ];
            
            system.assert(listToCheck.size() > 0, 'size should be superior to 0');
        }

}