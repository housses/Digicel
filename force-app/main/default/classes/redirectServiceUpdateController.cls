/*This class is a controller of ServiceUpdateCreation Visualforce Page.
 Functionality: The Name field of Service_Delivery_Updates object must be populated with the Service_Request Name 
 plus the Current Date.*/

public class redirectServiceUpdateController{

    private Apexpages.Standardcontroller stdController; 
    
    public redirectServiceUpdateController(Apexpages.Standardcontroller stdController){
        this.stdController = stdController;
    }
    
    public String getServiceRequestLandingPage()
    {
         Schema.DescribeSObjectResult result = Service_Request__c.SObjectType.getDescribe();
         return '/' + result.getKeyPrefix() + '/o';
    }
    
    //Retrieve Service_Request Name and Redirect to Service_Delivery_Updates Name Standard Page Layout
    public PageReference redirectServiceUpdate(){
        PageReference currPage = new PageReference(Apexpages.currentPage().getParameters().get('currentPageURL'));
        String url = '/'+Schema.getGlobalDescribe().get('Service_Delivery_Updates__c').getDescribe().getKeyPrefix()+'/e?';
         for(String mapKey : currPage.getParameters().keySet()){
             if(mapKey!='save_new'){
                 String mapValue = (mapKey!='sfdc.override'?currPage.getParameters().get(mapKey):'0');
                 mapValue = mapValue.replace(' ', '%2B');
                 mapValue = mapValue.replace('/', '%2F');
                 mapValue = mapValue.replace('&', '%2526');
                 url += (url.contains('=')?'&':'') + mapKey +'='+mapValue;
             }
         }
         //Retrieve Current Date, redirect and concatenate to Service_Delivery_Updates Name of Page Layout
         String srId = currPage.getParameters().get('retUrl').replace('/','');
         if (srId.contains('?')) srId = srId.subString(0,srId.indexOf('?'));
         String srName = [Select Name From Service_Request__c Where Id=:srId].Name;
         Datetime currentDate = Datetime.now();
         String currentDateStr = currentDate.format('dd-MM-yyyy');
         url += '&nooverride=1';
         String name = srName + ' - ' + currentDateStr;
         if(name.length() > 80) name = srName.substring(0,67) + ' - ' + currentDateStr;
         url += '&Name=' + name;
         PageReference redirectPage = new Pagereference(url);
         redirectPage.setRedirect(true);
         return redirectPage;
      }
}