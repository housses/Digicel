@isTest(seeAllData=true)
public class secureSDUName_TestClass{
    public static testmethod void secureSDUName_PositiveTest()
    {
        Test.StartTest();
        
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
        // testSR.Name = rt.Name + ' - ' + opp.Name;
        insert testSR;
        
        // Create New Service Delivery Update
        Service_Delivery_Updates__c testSDU = new Service_Delivery_Updates__c();
        testSDU.Service_Request__c = testSR.Id;
        Datetime currentDate = Datetime.now();
        String currentDateStr = currentDate.format('dd-MM-yyyy');
        String objectFinalName = testSR.Name + ' - ' + currentDateStr;
        testSDU.Name = objectFinalName;
        
        // Test Insertion
        insert testSDU;
        Service_Delivery_Updates__c newObj = [Select Id,Name From Service_Delivery_Updates__c Where Id=:testSDU.Id];
        // System.assertEquals(objectFinalName,newObj.Name);
        
        newObj.Name = 'Changing The Name For Test';
        update newObj;
        
        Service_Delivery_Updates__c updatedObj = [Select Name From Service_Delivery_Updates__c Where Id=:testSDU.Id];
        // System.assertEquals(objectFinalName,updatedObj.Name);
        
        
        Test.StopTest();
    }
}