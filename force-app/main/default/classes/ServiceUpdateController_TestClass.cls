@isTest(seeAllData= true)
public class ServiceUpdateController_TestClass{
    public static testmethod void ServiceUpdateController_Positivetest()
    {
        //Create new Pre-Sales Update
        Service_Delivery_Updates__c testSDU = new Service_Delivery_Updates__c();
        
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
        
        //Create new Pre-Sales Request
        Service_Request__c testSR = new Service_Request__c();
        testSR.RecordTypeId = rt.Id;
        testSR.Opportunity__c = opp.Id;
        testSR.Name = rt.Name + ' - ' + opp.Name;
        insert testSR;
        
        Test.StartTest();
        PageReference pagetest = new PageReference('/apex/ServiceUpdateCreation');
        pagetest.getParameters().put('currentPageURL','https://example.com/apex/PreSalesUpdateCreation?retUrl=/'+testSR.Id+'%3Fisdtp%3Dmn');
        Test.setCurrentPageReference(pagetest);
        
        //Create an instance of the controller 
        redirectServiceUpdateController testController = new redirectServiceUpdateController(
        new ApexPages.StandardController(testSDU));
        
        //Calling method
        testController.getServiceRequestLandingPage();
        testController.redirectServiceUpdate();
        
        Test.StopTest();
    }
}