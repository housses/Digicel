/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest (seeAllData=true)
public class testTriggerOpportunityAOP {
    static testMethod void myTest_OpportunityAOP() {
        
        RecordType recordType_JamaicaOpp = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_Business_Opportunity' AND SobjectType = 'Opportunity'];
        RecordType recordType_JamaicaAcc = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_Business_Account' AND SobjectType = 'Account'];
        
        Account acc = new Account(RecordTypeId = recordType_JamaicaAcc.Id, Name = 'Test Account', billing_Country__c='Jamaica' );
        insert acc;
        
        
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        insert pbk1;
        
        Product2 prd = new Product2 (Name='Test Product 1', Country__c='Jamaica', Description='Test Product Entry 1',productCode = '321', isActive = true);
        insert prd;
        
        
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd.id,Pricebook2ID=standardPb.id,UnitPrice=40, isActive=true);
        insert pbe1;
        
            //Opportunity[] oppsToCreate = new Opportunity[]{};

        //for(Integer x=0; x<3;x++){
        Opportunity opp1 = new Opportunity (Name='JM-TestOpp',StageName='none', Estimated_Billed_Date__c=Date.today()+20,CloseDate=Date.today()+10,Pricebook2Id = pbe1.Pricebook2Id, AccountId = acc.id, RecordTypeId = recordType_JamaicaOpp.Id, Country__c = 'Jamaica');

            
        insert opp1;
            
       
            
        //insert oppsToCreate;
        
    
     //Opportunity[] oppsadded = [SELECT Id FROM Opportunity WHERE Id IN : oppsToCreate];        
     //for (Opportunity opp2 : oppsadded){
        OpportunityLineItem lineItem1 = new OpportunityLineItem (OpportunityID=opp1.Id,PriceBookEntryID=pbe1.id, quantity=4, Margin_markup_percent__c = 40, Charge_Type__c='Installation');
        insert lineItem1;
        OpportunityLineItem lineItem2 = new OpportunityLineItem (OpportunityID=opp1.Id,PriceBookEntryID=pbe1.id, Margin_markup_percent__c = 40, quantity=4,Charge_Type__c='OTC');
        insert lineItem2;
        OpportunityLineItem lineItem3 = new OpportunityLineItem (OpportunityID=opp1.Id,PriceBookEntryID=pbe1.id, Margin_markup_percent__c = 40, quantity=4,Charge_Type__c='MRC');
        insert lineItem3;


              
        
        //}
                

        Test.startTest();
        
   
                
        opp1.CloseDate = System.today().addMonths(2);
        //opp1.Actual_Billed_Date__c = System.today().addMonths(3);
        
        opp1.Estimated_Billed_Date__c = System.today().addMonths(3);
        update opp1;
        
        System.assertEquals(lineItem3.Net_Value_AOP_MRC__c, lineItem3.Net_Value_AOP_MRC_Currency__c);                
        
        
        
        
        
       
        
   
        
        Test.stopTest();
    
    }

}