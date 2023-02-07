@isTest(seeAllData = true)
public class OpportunityLineItemTrigger_TestClass{

    public static testMethod void OportunityLineItem_Test(){
    
        //Create Account
        Account AccountObject = new Account();
        AccountObject.Name = 'Test';
        AccountObject.Deposits_Waived__c = true;
        insert AccountObject;
        
        //Create Opportunity
        Opportunity OpportunityObject = new Opportunity();
        OpportunityObject.Name = 'Test';
        OpportunityObject.StageName = 'Prospecting';
        OpportunityObject.CloseDate = system.today().addDays(10);
        OpportunityObject.AccountId = AccountObject.Id;
        OpportunityObject.Country__c = 'Jamaica';
        OpportunityObject.RecordTypeId = '012d0000000tMdA';
        OpportunityObject.Go_Live_Date__c = date.today();
        OpportunityObject.Go_Live_Date_Approved__c = TRUE;
        insert OpportunityObject;
        
        Pricebook2 pbook = [select id from Pricebook2 where IsStandard = true limit 1];
        
        //Create Product
        Product2 ProductObject = new Product2();
        ProductObject.Family = 'Test Product Family';
        ProductObject.Name = 'Test Product';
        ProductObject.Country__c = 'Jamaica';
        ProductObject.isActive = TRUE;
        ProductObject.Security_Deposit__c = 10;
        ProductObject.Monthly_Fee__c = 10;
        insert ProductObject;
        
        //Create Aditional PricebookEntry
        PricebookEntry PricebookEntryObject = new PricebookEntry();
        PricebookEntryObject.Pricebook2Id = pbook.Id;
        PricebookEntryObject.Product2Id = ProductObject.Id;
        PricebookEntryObject.UnitPrice = 0.0;
        PricebookEntryObject.isActive = TRUE;
        insert PricebookEntryObject;
    
        Test.startTest();
        
        //1. First of all, insert a OpportunityLineItem.
        
        //Create OpportunityLineItem 
        OpportunityLineItem oppli = new OpportunityLineItem();
        oppli.OpportunityId = OpportunityObject.Id;
        oppli.PricebookEntryId = PricebookEntryObject.Id;
        oppli.Quantity = 1;
        oppli.TotalPrice = 0.0;
        insert oppli;
    
        // 2. Now delete it.    
    
        delete oppli;    
    
        Test.stopTest();
    }
}