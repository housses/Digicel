/*This class is a controller of ServiceRequestCreation Visualforce Page.
 Functionality: The Name field of Service_Request object must be populated with the Record Type Name 
 chosen to create the record plus the Opportunity name related to Service_Request.*/
 
public class redirectServiceRequestController{

     private Apexpages.Standardcontroller stdController; 
     private Id idRecordType;  
     public redirectServiceRequestController(Apexpages.Standardcontroller stdController){
         this.stdController = stdController;
         this.idRecordType  = ((Service_Request__c)stdController.getRecord()).RecordTypeId;
     }
    
     public String getOpportunityLandingPage()
     {
         Schema.DescribeSObjectResult result = Opportunity.SObjectType.getDescribe();
         return '/' + result.getKeyPrefix() + '/o';
     }
     
     //Retrieve RecordType Name and Redirect to Service_Request Name of Standard Page Layout.
     public PageReference redirectServiceRequest(){
         PageReference currPage = new PageReference(Apexpages.currentPage().getParameters().get('currentPageURL'));
         RecordType rt = [SELECT Id, Name FROM RecordType WHERE Id =: this.idRecordType LIMIT 1];  
         
         String url = '/'+Schema.getGlobalDescribe().get('Service_Request__c').getDescribe().getKeyPrefix()+'/e?'; 
         for(String mapKey : currPage.getParameters().keySet()){
             if(mapKey!='save_new'){
                 String mapValue = (mapKey!='sfdc.override'?currPage.getParameters().get(mapKey):'0');
                 mapValue = mapValue.replace(' ', '%2B');
                 mapValue = mapValue.replace('/', '%2F');
                 mapValue = mapValue.replace('&', '%2526');
                 url += (url.contains('=')?'&':'') + mapKey +'='+mapValue;
             }
         }
          //Retrieve Opportunity Name, redirect and concatenate to Service_Request Name of Standard Page Layout
         String opportunityId = currPage.getParameters().get('retUrl').replace('/','');
         if (opportunityId.contains('?')) opportunityId = opportunityId.subString(0,opportunityId.indexOf('?'));
         String opportunityName = [Select Name From Opportunity Where Id=:opportunityId].Name;
         url += '&nooverride=1';
         String name = rt.Name + ' - ' + opportunityName;
         if(name.length() > 80) name = name.substring(0,80);
         url += '&Name=' + name;
         
         PageReference redirectPage = new Pagereference(url);
         redirectPage.setRedirect(true);
         return redirectPage;
     
     }
}