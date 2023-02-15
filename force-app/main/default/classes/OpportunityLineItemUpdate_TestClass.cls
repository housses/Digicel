@isTest(seeAllData=true)
private class OpportunityLineItemUpdate_TestClass{

    public static testMethod void test_setFields(){
        //Create Account
        Id rtId_trend = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_Trends' And SObjectType = 'Account'].Id;
        Account AccountObject = new Account(Name= 'Test', RecordTypeId = rtId_trend);
        insert AccountObject;
    
        //Create Opportunity
        Opportunity OpportunityObject = new Opportunity();
        OpportunityObject.Name = 'Test';
        OpportunityObject.StageName = 'Prospecting';
        OpportunityObject.CloseDate = system.today().addDays(10);
        OpportunityObject.AccountId = AccountObject.Id;
        OpportunityObject.OwnerId = userinfo.getUserId();
        OpportunityObject.Go_Live_Date__c = date.today();
        OpportunityObject.Go_Live_Date_Approved__c = TRUE;
        insert OpportunityObject;
        
        Pricebook2 pbook = [select id from Pricebook2 where IsStandard = true limit 1];
        
        Id rtId_PNG = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_PNG' And SObjectType = 'Product2'].Id;
        
        User usuario = new User(Id = userinfo.getUserId(), Digicel_Country__c = 'PNG');
        update usuario;
        
        //Create Product
        Product2 ProductObject = new Product2();
        ProductObject.Family = 'Test Product Family';
        ProductObject.Name = 'Test Product';
        ProductObject.Country__c = 'Jamaica';
        ProductObject.isActive = TRUE;
        ProductObject.Security_Deposit__c = 10;
        ProductObject.Monthly_Fee__c = 10;
        ProductObject.RecordTypeId = rtId_PNG;
        insert ProductObject;
        
        //Create Commission and Target
        Commission_Target__c oneCT = new Commission_Target__c();
        oneCT.Sales_Representative__c = usuario.Id;
        oneCT.Monthly_Target__c = 100;
        oneCT.Commission_Rate_per_Activation__c = 100;
        oneCT.Product__c = ProductObject.Id;
        insert oneCT;
        
        //Create Aditional PricebookEntry
        PricebookEntry PricebookEntryObject = new PricebookEntry();
        PricebookEntryObject.Pricebook2Id = pbook.Id;
        PricebookEntryObject.Product2Id = ProductObject.Id;
        PricebookEntryObject.UnitPrice = 0.0;
        PricebookEntryObject.isActive = TRUE;
        insert PricebookEntryObject;
        
        //Create OpportunityLineItem 
        OpportunityLineItem oppli = new OpportunityLineItem();
        oppli.OpportunityId = OpportunityObject.Id;
        oppli.PricebookEntryId = PricebookEntryObject.Id;
        oppli.Quantity = 1;
        oppli.TotalPrice = 0.0;
        insert oppli;
        
        OpportunityLineItem[] opls = new OpportunityLineItem[]{oppli};
        
        Test.startTest();
        
        OpportunityLineItemUpdate.setFields(opls);
        
        Test.stopTest();
        
    }
  
}