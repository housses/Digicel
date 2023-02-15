@isTest(seeAllData= true)
public class PreSalesUpdateController_TestClass{
    public static testmethod void PreSalesUpdateController_Positivetest()
    {
        //Create new Pre-Sales Update
        Pre_Sales_Update__c testPSU = new Pre_Sales_Update__c();
        
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
        testPSR.Name = rt.Name + ' - ' + opp.Name;
        insert testPSR;
        
        Test.StartTest();
        PageReference pagetest = new PageReference('/apex/PreSalesUpdateCreation');
        pagetest.getParameters().put('currentPageURL','https://example.com/apex/PreSalesUpdateCreation?retUrl=/'+testPSR.Id+'%3Fisdtp%3Dmn');
        Test.setCurrentPageReference(pagetest);
        
        //Create an instance of the controller 
        redirectPreSalesUpdateController testController = new redirectPreSalesUpdateController(
        new ApexPages.StandardController(testPSU));
        
        //Calling method
        testController.getPreSalesRequestLandingPage();
        testController.redirectPreSalesUpdate();
        
        Test.StopTest();
    }
}