@isTest(seeAllData=true)
public class secureSRName_TestClass{
    public static testmethod void secureSRName_PositiveTest()
    {
        RecordType rt = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Service_Request__c' LIMIT 1];
        
        Opportunity opp = new Opportunity();
        opp.Name = 'JM-Abc';
        opp.StageName = 'Proposal';
        Date tomorrow = date.today();
        tomorrow.addDays(1);
        opp.CloseDate = tomorrow;
        opp.Go_Live_Date__c = date.today();
        opp.Go_Live_Date_Approved__c = TRUE;
        insert opp;
        
        //Create new Service Request
        Service_Request__c testSR = new Service_Request__c();
        testSR.RecordTypeId = rt.Id;
        testSR.Opportunity__c = opp.Id;
        String objectFinalName = rt.Name + ' - ' + opp.Name;
        // testSR.Name = objectFinalName;
        
        Test.StartTest();
        
        // Test Insertion
        insert testSR;
        Service_Request__c newObj = [Select Id,Name From Service_Request__c Where Id=:testSR.Id];
        // System.assertEquals(objectFinalName,newObj.Name);
        
        // newObj.Name = 'Changing The Name For Test';
        update newObj;
        
        Service_Request__c updatedObj = [Select Name From Service_Request__c Where Id=:testSR.Id];
        // System.assertEquals(objectFinalName,updatedObj.Name);
        Test.StopTest();
    }
}