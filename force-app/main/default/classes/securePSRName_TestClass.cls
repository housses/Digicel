@isTest(seeAllData=true)
public class securePSRName_TestClass{
    public static testmethod void securePSRName_PositiveTest()
    {
        RecordType rt = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Pre_Sales_Request__c' LIMIT 1];
        
        Opportunity opp = new Opportunity();
        opp.Name = 'JM-Abc';
        opp.StageName = 'Proposal';
        Date tomorrow = date.today();
        tomorrow.addDays(1);
        opp.CloseDate = tomorrow;
        opp.Go_Live_Date__c = date.today();
        opp.Go_Live_Date_Approved__c = TRUE;
        insert opp;
        
        //Create new Pre-Sales Request
        Pre_Sales_Request__c testPSR = new Pre_Sales_Request__c();
        testPSR.RecordTypeId = rt.Id;
        testPSR.Opportunity__c = opp.Id;
        String objectFinalName = rt.Name + ' - ' + opp.Name;
        testPSR.Name = objectFinalName;
        
        Test.StartTest();
        
        // Test Insertion
        insert testPSR;
        Pre_Sales_Request__c newObj = [Select Id,Name From Pre_Sales_Request__c Where Id=:testPSR.Id];
        System.assertEquals(objectFinalName,newObj.Name);
        
        newObj.Name = 'Changing The Name For Test';
        update newObj;
        
        Pre_Sales_Request__c updatedObj = [Select Name From Pre_Sales_Request__c Where Id=:testPSR.Id];
        // System.assertEquals(objectFinalName,updatedObj.Name);
        Test.StopTest();
    }
}