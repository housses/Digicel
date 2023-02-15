@isTest(seeAllData=true)
private class OpportunityUpdate_TestClass{

    public static testMethod void test_setOpportunityTotals(){
    
        //Set up some variables
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
        OpportunityObject.Go_Live_Date__c = date.today();
        OpportunityObject.Go_Live_Date_Approved__c = TRUE;
        insert OpportunityObject;
        
        
        Pricebook2 pbook = [select id from Pricebook2 where IsStandard = true limit 1];
        
        //Create Product 
        Product2 ProductObject = new Product2();
        ProductObject.Family = 'Test Product Family';
        ProductObject.Name = 'Test Product';
        ProductObject.Country__c = 'Jamaica';
        ProductObject.IsActive = TRUE;
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
        
        //1- Test add a new opportunity line item with deposit waived
        OpportunityLineItem OpportunityLineItemObject = new OpportunityLineItem();
        OpportunityLineItemObject.OpportunityId = OpportunityObject.Id;
        OpportunityLineItemObject.PricebookEntryId = PricebookEntryObject.Id;
        OpportunityLineItemObject.Quantity = 1;
        OpportunityLineItemObject.TotalPrice = 0.0;
        insert OpportunityLineItemObject;
        
        OpportunityLineItem[] oppLineItems = new OpportunityLineItem[]{OpportunityLineItemObject};
        
        OpportunityUpdate.setOpportunityTotals(oppLineItems);
        
        //2- test delete the opportunity line item with deposit waived 
        delete OpportunityLineItemObject;
        
        //3- test add a new opportunity line item without deposit waived
        AccountObject.Deposits_Waived__c = FALSE;
        upsert AccountObject;
        
        OpportunityLineItem OpportunityLineItemObject2 = new OpportunityLineItem();
        OpportunityLineItemObject2.OpportunityId = OpportunityObject.Id;
        OpportunityLineItemObject2.PricebookEntryId = PricebookEntryObject.Id;
        OpportunityLineItemObject2.Quantity = 1;
        OpportunityLineItemObject2.TotalPrice = 0.0;
        insert OpportunityLineItemObject2;
        
        oppLineItems = new OpportunityLineItem[]
        {OpportunityLineItemObject2};            
        
        OpportunityUpdate.setOpportunityTotals(oppLineItems);
        
        Test.stopTest();
        
    }
}