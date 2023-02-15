/*This class is a controller of PreSalesRequestCreation visualforce page.
 Functionality: The Name field of Pre_Sales_Request object must be populated with the Record Type Name 
 chosen to create the record plus the Opportunity name related to Pre_Sales_Request.*/

public class redirectPreSalesRequestController {
     private Apexpages.Standardcontroller stdController; 
     private Id idRecordType;
     public redirectPreSalesRequestController(Apexpages.Standardcontroller stdController){
         this.stdController = stdController;
         this.idRecordType  = ((Pre_Sales_Request__c)stdController.getRecord()).RecordTypeId;
     }
    
     public String getOpportunityLandingPage()
     {
         Schema.DescribeSObjectResult result = Opportunity.SObjectType.getDescribe();
         return '/' + result.getKeyPrefix() + '/o';
     }
     
     //Retrieve RecordType Name and Redirect to Pre_Sales_Request Name of Standard Page Layout
     public PageReference redirectPreSalesRequest(){
         PageReference currPage = new PageReference(Apexpages.currentPage().getParameters().get('currentPageURL'));
        // causing an error: RecordType rt = [SELECT Id, Name FROM RecordType WHERE Id =: this.idRecordType LIMIT 1];  
         
         String url = '/'+Schema.getGlobalDescribe().get('Pre_Sales_Request__c').getDescribe().getKeyPrefix()+'/e?';
         System.debug(currPage.getParameters());
         for(String mapKey : currPage.getParameters().keySet()){
             if(mapKey!='save_new'){
                 String mapValue = (mapKey!='sfdc.override'?currPage.getParameters().get(mapKey):'0');
                 mapValue = mapValue.replace(' ', '+');
                 mapValue = mapValue.replace('/', '%2F');
                 mapValue = mapValue.replace('&', '%26');
                 url += (url.contains('=')?'&':'') + mapKey +'='+mapValue;
             }
         }
         //Retrieve Opportunity Name, redirect and concatenate to Pre_Sales_Request Name of Standard Page Layout
         String opportunityId = currPage.getParameters().get('retUrl').replace('/','');
         if (opportunityId.contains('?')) opportunityId = opportunityId.subString(0,opportunityId.indexOf('?'));
         String opportunityName = [Select Name From Opportunity Where Id=:opportunityId].Name;
         url += '&nooverride=1';
         String name = 'This will be auto-filled';
         if(name.length() > 80) name = name.substring(0,80);
         name = name.replace(' ', '+');
         name = name.replace('/', '%2F');
         name = name.replace('&', '%26');
         url += '&Name=' + name;
         PageReference redirectPage = new Pagereference(url);
         redirectPage.setRedirect(true);
         System.debug(redirectPage.getParameters());
         System.debug('URL: ' + url);
         return redirectPage;
     }
}