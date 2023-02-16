/**
 * @description       : Class Test For AccountTriggerHandler
 * @author            : CLEPILLOUER
 * @last modified on  : 16/02/2023
 * @last modified by  : CLEPILLOUER
**/
@isTest
public class AccountTriggerHandler_TST {

    @TestSetup
    static void createTestData() {
        Account acc = DataFactory.createAccount(true);
    }

    @isTest(seeAllData=false)
    public static void checkIfAccountInsert(){
        Test.startTest();
        List<Account> accountsToCheck = [SELECT Id FROM Account];
        Test.stopTest();
        System.assertEquals(1, accountsToCheck.size(), 'checkIfAccountInsert() => accountsToCheck size should be equal to 1');
    }

    @isTest(seeAllData=false)
    public static void checkIfAccountUpdate(){
        Test.setMock(HttpCalloutMock.class, new MockFactory_TST('MockInfolegale'));
        Account acc = [SELECT Id, Name FROM Account LIMIT 1];
        acc.Registration_Number__c = '00001';
        update acc;

        Test.startTest();
        List<Account> accountsToCheck = [SELECT Id, Registration_Number__c FROM Account];
        Test.stopTest();
  
        System.assertEquals('00001', acc.Registration_Number__c, 'checkIfAccountUpdate() => acc.Registration_Number__c should be equal 00001');
    }

    @isTest(seeAllData=false)
    public static void checkIfAccountDelete(){
        Account acc = [SELECT Id FROM Account LIMIT 1];
        delete acc;
        Test.startTest();
        List<Account> accountsToCheck = [SELECT Id FROM Account];
        Test.stopTest();
        System.assertEquals(0, accountsToCheck.size(), 'checkIfAccountIsDelete() => accountsToCheck size should be equal to 0');
    }

    @isTest(seeAllData=false)
    public static void checkNameTrigger(){
        AccountTriggerHandler trigg = new AccountTriggerHandler();
        String nameTrigger = trigg.getTriggerName();
        System.assertEquals('AccountTrigger', nameTrigger, 'checkNameTrigger() => nameTrigger should be AccountTrigger');
    }


}