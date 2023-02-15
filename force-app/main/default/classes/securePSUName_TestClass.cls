@isTest(seeAllData=true)
public class securePSUName_TestClass{
    public static testmethod void securePSUName_PositiveTest()
    {
        
        Test.StartTest();
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
        
        //Create new Service Request
        Pre_Sales_Request__c testPSR = new Pre_Sales_Request__c();
        testPSR.RecordTypeId = rt.Id;
        testPSR.Opportunity__c = opp.Id;
        // testPSR.Name = rt.Name + ' - ' + opp.Name;
        insert testPSR;
        
        // Create New Service Delivery Update
        Pre_Sales_Update__c testPSU = new Pre_Sales_Update__c();
        testPSU.Pre_Sales_Request__c = testPSR.Id;
        Datetime currentDate = Datetime.now();
        String currentDateStr = currentDate.format('dd-MM-yyyy');
        String objectFinalName = testPSR.Name + ' - ' + currentDateStr;
        testPSU.Name = objectFinalName;
        
        
        
        // Test Insertion
        insert testPSU;
        Pre_Sales_Update__c newObj = [Select Id,Name From Pre_Sales_Update__c Where Id=:testPSU.Id];
        // System.assertEquals(objectFinalName,newObj.Name);
        
        newObj.Name = 'Changing The Name For Test';
        update newObj;
        
        Pre_Sales_Update__c updatedObj = [Select Name From Pre_Sales_Update__c Where Id=:testPSU.Id];
        // System.assertEquals(objectFinalName,updatedObj.Name);
        Test.StopTest();
    }
}