@isTest
public class OpportunityTriggerHandler_TST {
    @isTest
    public static void checkOpportunityHandler() {
        Test.setMock(HttpCalloutMock.class, new MockInfolegale_TST());

        Map<String, Schema.RecordTypeInfo> accountRTs = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        Map<String, Schema.RecordTypeInfo> oppRTs = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName();
        Id accClientRT = accountRTs.get('Digicel_Business_Account').getRecordTypeId();
        Id oppRTsId = oppRTs.get('Digicel_Business_Opportunity').getRecordTypeId();
        Account acc = new Account(
            Name = 'TEST',
            Active__c = true,
            BillingCity = 'Paris',
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
        opp.StageName = 'Commercial Review';
        update opp;
        Opportunity oppToTest = [SELECT StageName FROM Opportunity LIMIT 1];
        delete opp;
        System.assertEquals(oppToTest.StageName, 'Commercial Review');
        OpportunityTriggerHandler trigg = new OpportunityTriggerHandler();
        String nameTrigger = trigg.getTriggerName();
        System.assertEquals(nameTrigger, 'OpportunityTrigger', 'should be OpportunityTrigger');
    }
}