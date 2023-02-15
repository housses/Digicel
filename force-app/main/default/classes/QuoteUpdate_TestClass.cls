@isTest(seeAllData = true)
private class QuoteUpdate_TestClass{

    public static testMethod void
     test_setQuoteTotals(){
    
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
    OpportunityObject.Go_Live_Date__c = date.today();
    OpportunityObject.Go_Live_Date_Approved__c = TRUE;
    // OpportunityObject.RecordTypeId = '012d0000000tMdK'; 
    OpportunityObject.RecordTypeId = '0120W000001Yde8';
    insert OpportunityObject;
    
    
    //Standard Pricebook
    Pricebook2 pbook = [SELECT Id FROM Pricebook2 WHERE isStandard = TRUE LIMIT 1];
    
    //Create Product
    Product2 ProductObject = new Product2();
    ProductObject.Family = 'Test Product Family';
    ProductObject.Name = 'Test Product';
    ProductObject.Security_Deposit__c = 10;
    ProductObject.Monthly_Fee__c = 10;
    ProductObject.Country__c = 'Anguilla';
    insert ProductObject;
    
    
    //Create Additional PricebookEntry
    PricebookEntry PricebookEntryObject = new PricebookEntry();
    PricebookEntryObject.Pricebook2Id = pbook.Id;
    PricebookEntryObject.Product2Id = ProductObject.Id;
    PricebookEntryObject.UnitPrice = 0.0;
    PricebookEntryObject.IsActive = TRUE;
    insert PricebookEntryObject;
    
    
    //1- test add a new opportunity line item with deposit waived
    OpportunityLineItem OpportunityLineItemObject = new OpportunityLineItem();
    OpportunityLineItemObject.OpportunityId = OpportunityObject.Id;
    OpportunityLineItemObject.PricebookEntryId = PricebookEntryObject.Id;
    OpportunityLineItemObject.Quantity = 1;
    OpportunityLineItemObject.TotalPrice = 0.0;
    insert OpportunityLineItemObject;
    
    //Create Quote
    Quote quoteObject = new Quote();
    quoteObject.Pricebook2Id = pbook.Id;
    quoteObject.OpportunityId = OpportunityObject.Id;
    quoteObject.Name = 'Test';
    insert quoteObject;
    
    //1- test add a new quote line item with deposit waived
    QuoteLineItem QuoteLineItemObject = new QuoteLineItem();
    QuoteLineItemObject.QuoteId = quoteObject.Id;
    QuoteLineItemObject.Quantity = 1;
    QuoteLineItemObject.PricebookEntryId = PricebookEntryObject.Id;
    QuoteLineItemObject.UnitPrice = 0.0;
    insert QuoteLineItemObject;
    
    //2- test delete the opportunity line item with deposit waived
    delete QuoteLineItemObject;
    
    //3- test ass a new opportunity line item without deposit waived
    AccountObject.Deposits_Waived__c = FALSE;
    upsert AccountObject;
    
    QuoteLineItem QuoteLineItemObject2 = new QuoteLineItem();
    QuoteLineItemObject2.QuoteId = quoteObject.Id;
    QuoteLineItemObject2.Quantity = 1;
    QuoteLineItemObject2.PricebookEntryId = PricebookEntryObject.Id;
    QuoteLineItemObject2.UnitPrice = 0.0;
    insert QuoteLineItemObject2;    
    }
}