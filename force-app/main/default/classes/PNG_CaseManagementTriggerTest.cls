@isTest
public class PNG_CaseManagementTriggerTest {
    static Id supportCaseRecId = [Select id from RecordType where sObjectType = 'Case' and developername ='PNG_SupportCase'].id ;
    
	@testSetup static void setup() {
                Case parentCase = new Case(Status='New', RecordTypeId= supportCaseRecId, Subject='Parent Case', PNG_RootCause__c = 'LAN issue');
        insert parentCase;
        
    }
     @isTest
    public static void testCloseNoChildCases(){
        Case parentCase = [SELECT Id, Status,PNG_RootCause__c FROM Case WHERE Subject=:'Parent Case' LIMIT 1];
        Test.startTest();
        parentCase.Status = 'Closed';
        update parentCase;
        Test.stopTest();
        System.assertEquals(parentCase.PNG_RootCause__c, 'LAN issue');
    }
    @isTest
    public static void testCloseAllLevelOChildCases(){
        Case parentCase = [SELECT Id, Status,PNG_RootCause__c FROM Case WHERE Subject=:'Parent Case' LIMIT 1];
        Case childCase = new Case(Status='New', RecordTypeId= supportCaseRecId, Subject='Child Case', ParentId = parentCase.Id,
                                  PNG_RootCause__c = 'Line of Sight');
        insert childCase;
        Test.startTest();
        parentCase.Status = 'Closed';
        update parentCase;
        Test.stopTest();
        Case closedChildCase = [SELECT Id, PNG_RootCause__c FROM Case WHERE ParentId =: parentCase.Id LIMIT 1];
        System.assertEquals(parentCase.PNG_RootCause__c, closedChildCase.PNG_RootCause__c);
    }
     @isTest
    	public static void testSelectEntitlementGSM(){
            Account acc = new Account(Name='Test Acc1', Type='Customer');
        	insert acc;
            Entitlement ent = new Entitlement(Name = 'Test Entitlement',AccountId = acc.id, PNG_EntitlementType__c ='Mobile Services',
                                             StartDate = System.Today()-1, EndDate = System.Today()+2);
           	insert ent;
            Case parentCase = [SELECT Id FROM Case WHERE Subject=:'Parent Case' LIMIT 1]; 
            Test.startTest();
            parentCase.AccountId = acc.Id;
            parentCase.PNG_CaseType__c = 'GSM';
            update parentCase;
            Test.stopTest();
           	Case updatedCase = [SELECT Id, EntitlementId FROM Case WHERE Subject=:'Parent Case' LIMIT 1];
            System.assertEquals(updatedCase.EntitlementId, ent.id);
        }
    @isTest
    	public static void testSelectEntitlementICT(){
            Account acc = new Account(Name='Test Acc1', Type='Customer');
        	insert acc;
            Entitlement ent = new Entitlement(Name = 'Test Entitlement',AccountId = acc.id, PNG_EntitlementType__c ='Connectivity & Enterprise Services',
                                             StartDate = System.Today()-1, EndDate = System.Today()+2);
           	insert ent;
            Case parentCase = [SELECT Id FROM Case WHERE Subject=:'Parent Case' LIMIT 1]; 
            Test.startTest();
            parentCase.AccountId = acc.Id;
            parentCase.PNG_CaseType__c = 'ICT';
            update parentCase;
            Test.stopTest();
           	Case updatedCase = [SELECT Id, EntitlementId FROM Case WHERE Subject=:'Parent Case' LIMIT 1];
            System.assertEquals(updatedCase.EntitlementId, ent.id);
        }
}