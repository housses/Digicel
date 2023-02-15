@isTest
public class PNG_OpportunityTriggerHelperTest {
    @isTest 
    public static void createAssetRecordsTest() {
        Account account= new Account();
        account.Name='New Test Account';
        account.Type='Customer';
        insert account;
        
        Contact contact=new Contact();
        contact.FirstName='New';
        contact.LastName='Test Contact';
        contact.AccountId=account.Id;
        insert contact;
        
        Opportunity opportunity= new Opportunity();
        opportunity.RecordTypeId=System.Label.PNG_OpprtunityRecordTypeId;
        opportunity.Name ='New Test Opportunity';
        opportunity.AccountId=account.Id;
        opportunity.Opportunity_Contact__c= contact.Id;
        opportunity.StageName='Prospecting & Qualification';
        opportunity.CloseDate=System.today()+10;
        opportunity.Pricebook2Id = Test.getStandardPricebookId();
        insert opportunity;
        
        Id pricebookId = Test.getStandardPricebookId();
        Product2 product1 = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true
        );
        insert product1;
        
        Product2 product2 = new Product2(
            Name = 'Product2 X',
            ProductCode = 'Pro2-X',
            isActive = true
        );
        insert product2;
        
        Quote quote=new Quote();
        quote.RecordTypeId=System.Label.PNG_QuoteRecordTypeId;
        quote.Name='Test Quote';
        quote.OpportunityId=opportunity.Id;
        quote.Pricebook2Id=pricebookId;
        quote.Status='Draft';
        insert quote;
        quote.Status='Needs Review';
        update quote;
        quote.Status='In Technical Feasibility Check';
        update quote;
        quote.Status='Technical Feasibility Approved';
        update quote;
        quote.Status='In Solution Review';
        update quote;
        quote.Status='Solution Approved';
        update quote;
        quote.Status='Approved';
        quote.RecordTypeId=System.Label.PNG_ApprovedQuoteRecordType;
        update quote;
        quote.Status='Accepted';
        update quote;
        
        opportunity.SyncedQuoteId=quote.Id;
        update opportunity;
        
        List<PricebookEntry> pricebookEntries= new List<PricebookEntry>();
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = product1.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        pricebookEntries.add(pbEntry);
        
        PricebookEntry pbEntry2 = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = product2.Id,
            UnitPrice = 150.00,
            IsActive = true
        );
        pricebookEntries.add(pbEntry2);
        insert pricebookEntries;
        
        List<QuoteLineItem> qLineItems= new List<QuoteLineItem>();
        List<OpportunityLineItem> oLineItems= new List<OpportunityLineItem>();
        
        QuoteLineItem quoteLineItem1= new QuoteLineItem();
		quoteLineItem1.QuoteId=quote.Id;
		quoteLineItem1.Quantity=3;
        quoteLineItem1.PricebookEntryId=pbEntry.Id;
        quoteLineItem1.PNG_HasInstallationProduct__c=true;
        quoteLineItem1.UnitPrice=quoteLineItem1.Quantity * pbEntry.UnitPrice;
        qLineItems.add(quoteLineItem1);
        
        QuoteLineItem quoteLineItem2= new QuoteLineItem();
		quoteLineItem2.QuoteId=quote.Id;
		quoteLineItem2.Quantity=2;
        quoteLineItem2.PricebookEntryId=pbEntry2.Id;
        quoteLineItem2.PNG_HasInstallationProduct__c=true;
        quoteLineItem2.UnitPrice=quoteLineItem2.Quantity * pbEntry2.UnitPrice;
        qLineItems.add(quoteLineItem2);
        
        insert qLineItems;
                
        Test.startTest();
        opportunity.StageName='Closed-Won';
        update opportunity;
        System.assertNotEquals(null,[select id,AccountId,RecordTypeId,Product2Id from Asset where AccountId=:account.Id and 
                                     RecordTypeId=:System.Label.PNG_AssetRecordTypeId and Product2Id=:quoteLineItem1.Product2Id]);
        System.assertNotEquals(null,[select id,AccountId,RecordTypeId,Product2Id from Asset where AccountId=:account.Id and 
                                     RecordTypeId=:System.Label.PNG_AssetRecordTypeId and Product2Id=:quoteLineItem2.Product2Id]);        
        Test.stopTest();
        
    }
}