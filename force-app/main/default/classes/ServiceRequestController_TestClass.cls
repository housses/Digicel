@isTest(seeAllData= true)
public class ServiceRequestController_TestClass{

    public static testmethod void ServiceRequestController_Positivetest()
    {
        RecordType rt = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Service_Request__c' LIMIT 1];
        
        //Create new Service Request
        Service_Request__c testSR = new Service_Request__c();
        testSR.RecordTypeId = rt.Id;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'JM-Abc';
        opp.StageName = 'Proposal';
        Date tomorrow = date.today();
        tomorrow.addDays(1);
        opp.CloseDate = tomorrow;
        opp.Go_Live_Date__c = date.today();
        opp.Go_Live_Date_Approved__c = TRUE;
        insert opp;
        
        Test.StartTest();
        PageReference pagetest = new PageReference('/apex/ServiceRequestCreation');
        pagetest.getParameters().put('currentPageURL','https://example.com/apex/PreSalesRequestCreation?retUrl=/'+opp.Id+'%3Fisdtp%3Dmn');
        Test.setCurrentPageReference(pagetest); 
        
        //Create an instance of the controller 
        redirectServiceRequestController testController = new redirectServiceRequestController(
        new ApexPages.StandardController(testSR));
        
        //Calling method
        testController.getOpportunityLandingPage();
        testController.redirectServiceRequest();
        
        Test.StopTest();
    }
}