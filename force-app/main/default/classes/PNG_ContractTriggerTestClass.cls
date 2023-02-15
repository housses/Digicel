@isTest
public class PNG_ContractTriggerTestClass {
    
	static Id contractRecId = [Select id from RecordType where sObjectType = 'Contract' and developername ='PNG_Digicel_ICT_GSM' ].id ;
	
    @testSetup static void setup() {
        Account acc = new Account(Name='Test Acc1', Type='Customer');
        insert acc;
        Contact con = new Contact(AccountId=acc.Id, FirstName='Test',LastName='contact');
        insert con;
		Id oppRecId = [Select id from RecordType where sObjectType = 'Opportunity' and developername ='PNG_Digicel_ICT_GSM' ].id ;
        Opportunity opp= new Opportunity(RecordTypeId=oppRecId, Name = 'Test Opportunity',
                                         AccountId = acc.Id, Opportunity_Contact__c= con.Id,
                                         PNG_OpportunityType__c='ICT',
                                         StageName = 'Prospecting & Qualification', CloseDate = System.today()+10,
                                        Pricebook2Id = Test.getStandardPricebookId());
        insert opp;
    }
    
	@isTest
    public static void testGoldMobileServicesEntitlement(){
        
        Account acc = [SELECT Id, PNG_Account_Level__c FROM Account WHERE Name='Test Acc1' LIMIT 1];
        acc.PNG_Account_Level__c = 'Gold';
        update acc;
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name= 'Test Opportunity' LIMIT 1];
        opp.PNG_OpportunityType__c = 'GSM';
        update opp;
        Test.startTest();
        Contract cont = new Contract(RecordTypeId = contractRecId, Status ='PNG_Customer_Signed_Approved',
                                    AccountID = acc.Id, Opportunity__c = opp.Id);
        insert cont;
        cont.Status='PNG_Contract mutually signed';
        update cont;
        Test.stopTest();
        Account updatedAcc = [SELECT Id, PNG_EntitlementLevel__c FROM Account WHERE Name='Test Acc1' LIMIT 1];
        System.assertEquals(updatedAcc.PNG_EntitlementLevel__c, 'Gold');
    }
    @isTest
    public static void testGoldConnectivityEnterpriseEntitlement(){
        
        Account acc = [SELECT Id,PNG_Account_Level__c FROM Account WHERE Name='Test Acc1' LIMIT 1];
        acc.PNG_Account_Level__c = 'Gold';
        update acc;
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name= 'Test Opportunity' LIMIT 1];
        opp.PNG_OpportunityType__c = 'ICT';
        update opp;
        Test.startTest();
        Contract cont = new Contract(RecordTypeId = contractRecId, Status = 'PNG_Customer_Signed_Approved',
                                    AccountID = acc.Id, Opportunity__c = opp.Id);
        insert cont;
        cont.Status='PNG_Contract mutually signed';
        update cont;
        Test.stopTest();
        Account updatedAcc = [SELECT Id, PNG_EntitlementLevel__c FROM Account WHERE Name='Test Acc1' LIMIT 1];
        System.assertEquals(updatedAcc.PNG_EntitlementLevel__c, 'Gold');
    }
    @isTest
    public static void testSilverMobileServicesEntitlement(){
        
        Account acc = [SELECT Id, PNG_Account_Level__c FROM Account WHERE Name='Test Acc1' LIMIT 1];
        acc.PNG_Account_Level__c = 'Silver';
        update acc;
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name= 'Test Opportunity' LIMIT 1];
        opp.PNG_OpportunityType__c = 'GSM';
        update opp;
        Test.startTest();
        Contract cont = new Contract(RecordTypeId = contractRecId, Status = 'PNG_Customer_Signed_Approved',
                                    AccountID = acc.Id, Opportunity__c = opp.Id);
        insert cont;
        cont.Status='PNG_Contract mutually signed';
        update cont;
        Test.stopTest();
        Account updatedAcc = [SELECT Id, PNG_EntitlementLevel__c FROM Account WHERE Name='Test Acc1' LIMIT 1];
        System.assertEquals(updatedAcc.PNG_EntitlementLevel__c, 'Silver');
    }
    @isTest
    public static void testSilverConnectivityEnterpriseEntitlement(){
        
        Account acc = [SELECT Id,PNG_Account_Level__c FROM Account WHERE Name='Test Acc1' LIMIT 1];
        acc.PNG_Account_Level__c = 'Silver';
        update acc;
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name= 'Test Opportunity' LIMIT 1];
        opp.PNG_OpportunityType__c = 'ICT';
        update opp;
        Test.startTest();
        Contract cont = new Contract(RecordTypeId = contractRecId, Status = 'PNG_Customer_Signed_Approved',
                                    AccountID = acc.Id, Opportunity__c = opp.Id);
        insert cont;
        cont.Status='PNG_Contract mutually signed';
        update cont;
        Test.stopTest();
        Account updatedAcc = [SELECT Id, PNG_EntitlementLevel__c FROM Account WHERE Name='Test Acc1' LIMIT 1];
        System.assertEquals(updatedAcc.PNG_EntitlementLevel__c, 'Silver');
    }
        @isTest
    public static void testBronzeMobileServicesEntitlement(){
        
        Account acc = [SELECT Id, PNG_Account_Level__c FROM Account WHERE Name='Test Acc1' LIMIT 1];
        acc.PNG_Account_Level__c = 'Bronze';
        update acc;
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name= 'Test Opportunity' LIMIT 1];
        opp.PNG_OpportunityType__c = 'GSM';
        update opp;
        Test.startTest();
        Contract cont = new Contract(RecordTypeId = contractRecId, Status = 'PNG_Customer_Signed_Approved',
                                    AccountID = acc.Id, Opportunity__c = opp.Id);
        insert cont;
        cont.Status='PNG_Contract mutually signed';
        update cont;
        Test.stopTest();
        Account updatedAcc = [SELECT Id, PNG_EntitlementLevel__c FROM Account WHERE Name='Test Acc1' LIMIT 1];
        System.assertEquals(updatedAcc.PNG_EntitlementLevel__c, 'Bronze');
    }
    @isTest
    public static void testBronzeConnectivityEnterpriseEntitlement(){
        
        Account acc = [SELECT Id,PNG_Account_Level__c FROM Account WHERE Name='Test Acc1' LIMIT 1];
        acc.PNG_Account_Level__c = 'Bronze';
        update acc;
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name= 'Test Opportunity' LIMIT 1];
        opp.PNG_OpportunityType__c = 'ICT';
        update opp;
        Test.startTest();
        Contract cont = new Contract(RecordTypeId = contractRecId, Status = 'PNG_Customer_Signed_Approved',
                                    AccountID = acc.Id, Opportunity__c = opp.Id);
        insert cont;
        cont.Status='PNG_Contract mutually signed';
        update cont;
        Test.stopTest();
        Account updatedAcc = [SELECT Id, PNG_EntitlementLevel__c FROM Account WHERE Name='Test Acc1' LIMIT 1];
        System.assertEquals(updatedAcc.PNG_EntitlementLevel__c, 'Bronze');
    }
     @isTest
    public static void testDeactivateExistingEntitlement(){
        
        Account acc = [SELECT Id,PNG_Account_Level__c,PNG_EntitlementLevel__c FROM Account WHERE Name='Test Acc1' LIMIT 1];
        acc.PNG_Account_Level__c = 'Bronze';
        acc.PNG_EntitlementLevel__c ='Silver';
        update acc;
        Entitlement ent = new Entitlement(Name ='Test entitlement',AccountId = acc.Id,StartDate=System.today()-1);
        insert ent;
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name= 'Test Opportunity' LIMIT 1];
        opp.PNG_OpportunityType__c = 'ICT';
        update opp;
        Contract cont = new Contract(RecordTypeId = contractRecId, Status = 'PNG_Customer_Signed_Approved',
                                    AccountID = acc.Id, Opportunity__c = opp.Id);
        insert cont;
        Test.startTest();
        cont.Status = 'PNG_Contract mutually signed';
        update cont;
        Test.stopTest();
        Account updatedAcc = [SELECT Id, PNG_EntitlementLevel__c FROM Account WHERE Name='Test Acc1' LIMIT 1];
        System.assertEquals(updatedAcc.PNG_EntitlementLevel__c, 'Bronze');
    }
    @isTest
    public static void testUpdateExistingGSMEntitlement(){
        
        Account acc = [SELECT Id,PNG_Account_Level__c,PNG_EntitlementLevel__c FROM Account WHERE Name='Test Acc1' LIMIT 1];
        acc.PNG_Account_Level__c = 'Bronze';
        acc.PNG_EntitlementLevel__c ='Bronze';
        update acc;
        Entitlement ent = new Entitlement(Name ='Test entitlement',AccountId = acc.Id, StartDate=System.today()-8,
                                          PNG_EntitlementType__c = 'Mobile Services',EndDate=System.today()+1);
        insert ent;
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name= 'Test Opportunity' LIMIT 1];
        opp.PNG_OpportunityType__c = 'GSM';
        update opp;
        Contract cont = new Contract(RecordTypeId = contractRecId, Status = 'PNG_Customer_Signed_Approved',
                                    AccountID = acc.Id, Opportunity__c = opp.Id, StartDate=System.today()-10,ContractTerm=1);
        insert cont;
        Test.startTest();
        cont.Status = 'PNG_Contract mutually signed';
        update cont;
        Test.stopTest();
        Account updatedAcc = [SELECT Id, PNG_EntitlementLevel__c FROM Account WHERE Name='Test Acc1' LIMIT 1];
        System.assertEquals(updatedAcc.PNG_EntitlementLevel__c, 'Bronze');
    }
    @isTest
    public static void testUpdateExistingICTEntitlement(){
        
        Account acc = [SELECT Id,PNG_Account_Level__c,PNG_EntitlementLevel__c FROM Account WHERE Name='Test Acc1' LIMIT 1];
        acc.PNG_Account_Level__c = 'Bronze';
        acc.PNG_EntitlementLevel__c ='Bronze';
        update acc;
        Entitlement ent = new Entitlement(Name ='Test entitlement',AccountId = acc.Id, StartDate=System.today()-8,
                                          PNG_EntitlementType__c = 'Connectivity & Enterprise',EndDate=System.today()+1);
        insert ent;
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name= 'Test Opportunity' LIMIT 1];
        opp.PNG_OpportunityType__c = 'ICT';
        update opp;
        Contract cont = new Contract(RecordTypeId = contractRecId, Status = 'PNG_Customer_Signed_Approved',
                                    AccountID = acc.Id, Opportunity__c = opp.Id, StartDate=System.today()-10,ContractTerm=1);
        insert cont;
        Test.startTest();
        cont.Status = 'PNG_Contract mutually signed';
        update cont;
        Test.stopTest();
        Account updatedAcc = [SELECT Id, PNG_EntitlementLevel__c FROM Account WHERE Name='Test Acc1' LIMIT 1];
        System.assertEquals(updatedAcc.PNG_EntitlementLevel__c, 'Bronze');
    }
}