@isTest(seeAllData= true)
public class PreSalesRequestController_TestClass{

    public static testmethod void PreSalesRequestController_Positivetest()
    {
        RecordType rt = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Pre_Sales_Request__c' LIMIT 1];
        
        //Create new Pre_Sales_Request
        Pre_Sales_Request__c testPSR = new Pre_Sales_Request__c();
        testPSR.RecordTypeId = rt.Id;
        
        //Create new Opportunity
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
        PageReference pagetest = new PageReference('/apex/PreSalesRequestCreation');
        pagetest.getParameters().put('currentPageURL','https://example.com/apex/PreSalesRequestCreation?retUrl=/'+opp.Id+'%3Fisdtp%3Dmn');
        Test.setCurrentPageReference(pagetest); 
        
        //Create an instance of the controller 
        redirectPreSalesRequestController testController = new redirectPreSalesRequestController(
        new ApexPages.StandardController(testPSR));
        
        //Calling method
        testController.getOpportunityLandingPage();
        testController.redirectPreSalesRequest();
        
        Test.StopTest();
    }
}