@isTest
public class PNG_QuoteTriggerHelperTest {
    @isTest
    public static void createContractRecordTest(){
        Account acc= new Account();
        acc.Name='New Test Account';
        acc.Type='Customer';
        insert acc;
        Contact con=new Contact();
        con.FirstName='New';
        con.LastName='Test Contact';
        con.AccountId=acc.Id;
        insert con;
        
        List<Opportunity> opportunities= new List<Opportunity>();
        List<Quote> quotes= new List<Quote>();
        
        Opportunity opp1= new Opportunity();
        opp1.RecordTypeId=System.Label.PNG_OpprtunityRecordTypeId;
        opp1.Name ='New Test Opportunity: 1';
        opp1.AccountId=acc.Id;
        opp1.StageName='Prospecting & Qualification';
        opp1.CloseDate=System.today()+15;
        opp1.PNG_OpportunityType__c=System.Label.PNG_QTypeICT;
        opp1.Contract_Term_SP__c=12;
        opp1.Opportunity_Contact__c=con.Id;
        opportunities.add(opp1);
        
        Opportunity opp2= new Opportunity();
        opp2.RecordTypeId=System.Label.PNG_OpprtunityRecordTypeId;
        opp2.Name ='New Test Opportunity: 2';
        opp2.AccountId=acc.Id;
        opp2.StageName='Prospecting & Qualification';
        opp2.CloseDate=System.today()+10;
        opp2.PNG_OpportunityType__c=System.Label.PNG_QTypeGSM;
        opp2.Contract_Term_SP__c=12;
        opp2.Opportunity_Contact__c=con.Id;
        opportunities.add(opp2);
        
        Opportunity opp3= new Opportunity();
        opp3.RecordTypeId=System.Label.PNG_OpprtunityRecordTypeId;
        opp3.Name ='New Test Opportunity: 3';
        opp3.AccountId=acc.Id;
        opp3.StageName='Prospecting & Qualification';
        opp3.CloseDate=System.today()+10;
        opp3.PNG_OpportunityType__c=System.Label.PNG_QTypeICTGSM;
        opp3.Contract_Term_SP__c=12;
        opp3.Opportunity_Contact__c=con.Id;
        opportunities.add(opp3);
        insert opportunities;
        
        Quote quote1=new Quote();
        quote1.RecordTypeId=System.Label.PNG_QuoteRecordTypeId;
        quote1.Name='Test Quote : 1';
        quote1.OpportunityId=opp1.Id;
        quote1.Status='Draft';
        quotes.add(quote1);
        
        Quote quote2=new Quote();
        quote2.RecordTypeId=System.Label.PNG_QuoteRecordTypeId;
        quote2.Name='Test Quote : 2';
        quote2.OpportunityId=opp2.Id;
        quote2.Status='Approved';
        quote2.RecordTypeId=System.Label.PNG_ApprovedQuoteRecordType;
        quotes.add(quote2);
        
        Quote quote3=new Quote();
        quote3.RecordTypeId=System.Label.PNG_QuoteRecordTypeId;
        quote3.Name='Test Quote : 3';
        quote3.OpportunityId=opp3.Id;
        quote3.Status='Draft';
        quotes.add(quote3);
        insert quotes;
        System.debug('Quotes type:'+ quote3.PNG_QuoteType__c);
        
        quote1.Status='Needs Review';
        update quote1;
        quote1.Status='In Technical Feasibility Check';
        update quote1;
        quote1.Status='Technical Feasibility Approved';
        update quote1;
        quote1.Status='In Solution Review';
        update quote1;
        quote1.Status='Solution Approved';
        update quote1;
        quote1.Status='Approved';
        quote1.RecordTypeId=System.Label.PNG_ApprovedQuoteRecordType;
        update quote1;
    
        quote3.Status='Needs Review';
        update quote3;
        quote3.Status='In Technical Feasibility Check';
        update quote3;
        quote3.Status='Technical Feasibility Approved';
        update quote3;
        quote3.Status='In Solution Review';
        update quote3;
        quote3.Status='Solution Approved';
        update quote3;
        quote3.Status='Approved';
        quote3.RecordTypeId=System.Label.PNG_ApprovedQuoteRecordType;
        update quote3;
        
        Test.startTest();
        quote1.Status='Accepted';
        update quote1;
        System.assertNotEquals(null,quote1.OpportunityId);
        System.assertNotEquals(null,[select id, name,PNG_Quote__c from Contract where PNG_Quote__c=:quote1.id]);
        
        quote2.Status='Accepted';
        update quote2;
        System.assertNotEquals(null,quote2.OpportunityId);
        System.assertNotEquals(null,[select id, name,PNG_Quote__c from Contract where PNG_Quote__c=:quote2.id]);
       
        quote3.Status='Accepted';
        update quote3;
        System.assertNotEquals(null,quote3.OpportunityId);
        System.assertNotEquals(null,[select id, name,PNG_Quote__c from Contract where PNG_Quote__c=:quote3.id]);
        Test.stopTest();
  
    }
}