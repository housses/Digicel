/**
 * @description       : 
 * @author            : JBBARTHELEMY
 * @group             : 
 * @last modified on  : 08/11/2022
 * @last modified by  : JBBARTHELEMY
**/
@IsTest
public  class InfolegaleOppBAT_TST {
    
    @isTest
    static void testBatchInfolegale(){

        Map<String, Schema.RecordTypeInfo> accountRTs = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        Id accClientRT = accountRTs.get('Digicel_Business_Account').getRecordTypeId();
        Map<String, Schema.RecordTypeInfo> oppRTs = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName();
        Id oppRTsId = oppRTs.get('Digicel_Business_Opportunity').getRecordTypeId();
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
        Opportunity opp = new Opportunity(
            Name = 'Opportunity Test ',
            StageName = 'Commercial Review',
            Type = 'Standard Deal',
            SaleType__c = 'New',
            Country__c = 'Guadeloupe',
            Estimated_Billed_Date__c = Date.today().addDays(14),
            CurrencyIsoCode = 'USD',
            AccountId = acc.Id,
            RecordTypeId = oppRTsId,
            Product_Interest__c = 'Data VPN',
            CloseDate = Date.today().addDays(7)
        );
        insert opp;
       
        Test.setMock(HttpCalloutMock.class, new MockInfolegale_TST());
        Test.startTest();
        InfolegaleOpp_BAT httpBatch = new InfolegaleOpp_BAT(new Set<Id>{opp.Id});
        Id batchJobId = Database.executebatch(httpBatch,100);  
        Test.stopTest();

        Opportunity oppToTest = [SELECT Id, INFOLEGALERating__c, Score_INFOLEGALE__c, AccountId, StageName FROM Opportunity];
        system.assertEquals(6, oppToTest.INFOLEGALERating__c, 'oportunity rating infolegale score should be the same ');
        system.assertEquals(6, oppToTest.Score_INFOLEGALE__c, 'oportunity scoring infolegale score should be the same ');

        Account accToTest = [SELECT Id, INFOLEGALERating__c, Registration_Number__c FROM Account];
        system.assertEquals(6, accToTest.INFOLEGALERating__c, 'infolegale rating account should be the same');
    }

}