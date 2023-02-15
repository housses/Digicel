/*This class is a controller of PreSalesUpdateCreation Visualforce Page.
 Function: The Name field of Pre_Sales_Update object must be populated with the Pre_Sales_Request Name 
 plus the Current Date.*/
 
public class redirectPreSalesUpdateController{

    private Apexpages.Standardcontroller stdController; 
    
    public redirectPreSalesUpdateController(Apexpages.Standardcontroller stdController){
        this.stdController = stdController;
    }
    
    public String getPreSalesRequestLandingPage()
    {
         Schema.DescribeSObjectResult result = Pre_Sales_Request__c.SObjectType.getDescribe();
         return '/' + result.getKeyPrefix() + '/o';
    }
    
    //Retrieve Pre_Sales_Request Name and Redirect to Pre_Sales_Update Name Standard Page Layout
    public PageReference redirectPreSalesUpdate(){
        PageReference currPage = new PageReference(Apexpages.currentPage().getParameters().get('currentPageURL'));
        String url = '/'+Schema.getGlobalDescribe().get('Pre_Sales_Update__c').getDescribe().getKeyPrefix()+'/e?';
        for(String mapKey : currPage.getParameters().keySet()){
            if(mapKey!='save_new'){
                String mapValue = (mapKey!='sfdc.override'?currPage.getParameters().get(mapKey):'0');
                mapValue = mapValue.replace(' ', '%2B');
                 mapValue = mapValue.replace('/', '%2F');
                 mapValue = mapValue.replace('&', '%2526');
                url += (url.contains('=')?'&':'') + mapKey +'='+mapValue;
            }
         }
         //Retrieve Current Date, redirect and concatenate to Pre_Sales_Update Name of Page Layout
         String psrId = currPage.getParameters().get('retUrl').replace('/','');
         if (psrId.contains('?')) psrId = psrId.subString(0,psrId.indexOf('?'));
         String psrName = [Select Name From Pre_Sales_Request__c Where Id=:psrId].Name;
         Datetime currentDate = Datetime.now();
         String currentDateStr = currentDate.format('dd-MM-yyyy');
         url += '&nooverride=1';
         String name = psrName + ' - ' + currentDateStr;
         if(name.length() > 80) name = psrName.substring(0,67) + ' - ' + currentDateStr;
         url += '&Name=' + name;    
         PageReference redirectPage = new Pagereference(url);
         redirectPage.setRedirect(true);
         return redirectPage;
      }
}