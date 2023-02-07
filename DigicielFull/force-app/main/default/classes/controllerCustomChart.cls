public with sharing class controllerCustomChart {
    private Custom_Chart__c customChart = new Custom_Chart__c();
    
    public controllerCustomChart(){
        displayChart = false;
        init();
    } 
    
    public void init(){
        String customChartCode = '';
        if(ApexPages.currentPage().getUrl().contains('_')){
            customChartCode = ApexPages.currentPage().getUrl().substring(ApexPages.currentPage().getUrl().indexOf('_')+1, ApexPages.currentPage().getUrl().indexOf('_')+5);
        }
        System.debug('Custom Chart Code: '+customChartCode);
        if(customChartCode.length() > 0){
            try{
                this.customChart = [Select c.Type__c, c.Source_Report__c, c.Name, c.Id, 
                                    c.Base_Object__c, c.Base_Object_API_Name__c, Width__c, Height__c,
                                    CurrencyIsoCode,
                                    (Select Id, Name, Related_Object_API_Name__c, Custom_Chart__c 
                                    From Custom_Chart_Related_Objects__r), 
                                    (Select Id, Name, Field_API_Name__c, Type__c, Field_Use__c, 
                                    Custom_Chart_Related_Object__c, Custom_Chart__c, Condition_Value__c, 
                                    Custom_Chart_Related_Object__r.Related_Object_API_Name__c, Display_Color__c, 
                                    Display_Color_Hex_Code__c, Display_On_Chart__c, Chart_Field_Number__c,
                                    Custom_Chart_Field_Number_A__c, Custom_Chart_Field_Number_B__c, Operator__c,
                                    In_Not_In_Values__c, Is_Date_Field__c, Display_Order_By__c
                                    From Custom_Chart_Fields__r Order By Chart_Field_Number__c asc) 
                                    From Custom_Chart__c c Where Code__c =: customChartCode limit 1];
            }catch(System.Exception e){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'The custom chart code ('+ customChartCode +') does not exist, please contact your admin.'));
            }
        }else{
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'No custom chart code was recovered, please contact your admin.'));
        }
        
        if(customChart.Id != null){ 
            chartURL = classCustomChart.buildImageURL(customChart);
            if(chartURL.length() > 0 ) displayChart = true;
        }
        //return null;
    }
    
    public String getCustomChartSource(){
        return this.customChart.Source_Report__c;
    }
    // The URL that renders the Google Chart
    public String chartURL { get; set; }  
    
    // Indicates whether the chart should be displayed 
    public Boolean displayChart { get; set; }
    
}