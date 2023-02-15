/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class testClassCustomChart {

    static testMethod void myUnitTest_PieChart() {
        Custom_Chart__c customChart = new Custom_Chart__c(Name = 'Test', Type__c = 'Pie Chart',
                Base_Object__c = 'Custom Chart', Base_Object_API_Name__c = 'Custom_Chart__c',
                Code__c = 'test', Height__c = 250, Width__c = 250);
                
        insert customChart;
        
        Custom_Chart_Related_Object__c relatedObject = new Custom_Chart_Related_Object__c(Custom_Chart__c = customChart.Id,
                Name = 'Custom Chart Field', Related_Object_API_Name__c = 'Custom_Chart_Fields__r');
        
        insert relatedObject;
        
        Custom_Chart_Field__c customField1 = new Custom_Chart_Field__c(Chart_Field_Number__c = '000',
                Custom_Chart__c=customChart.Id,Field_Use__c='Condition',Condition_Value__c='TEST',Name='Custom Chart Code',
                Field_API_Name__c = 'Name',Type__c = 'Equals');
        
        Custom_Chart_Field__c customField2 = new Custom_Chart_Field__c(Chart_Field_Number__c = '001',
                Custom_Chart__c=customChart.Id,Field_Use__c='Group By',Name='Base Object',
                Field_API_Name__c = 'Base_Object__c',Display_On_Chart__c=true,Display_Color__c='Red',
                Display_Order_By__c = 1);
        
        Custom_Chart_Field__c customField3 = new Custom_Chart_Field__c(Chart_Field_Number__c = '002',
                Custom_Chart__c=customChart.Id,Field_Use__c='Summary',Name='Maximum Height',
                Field_API_Name__c = 'Height__c',Display_On_Chart__c=true,Display_Color__c='Blue',
                Type__c='Maximum',Display_Order_By__c = 2);
                
        Custom_Chart_Field__c customField4 = new Custom_Chart_Field__c(Chart_Field_Number__c = '003',
                Custom_Chart__c=customChart.Id,Field_Use__c='Summary',Name='Minimum Height',
                Field_API_Name__c = 'Height__c',Display_On_Chart__c=true,Display_Color__c='Yellow',
                Type__c='Minimum',Display_Order_By__c = 3);
                
        Custom_Chart_Field__c customField5 = new Custom_Chart_Field__c(Chart_Field_Number__c = '004',
                Custom_Chart__c=customChart.Id,Field_Use__c='Summary',Name='Average Height',
                Field_API_Name__c = 'Height__c',Display_On_Chart__c=true,Display_Color__c='Orange',
                Type__c='Average',Display_Order_By__c = 4);
                
        Custom_Chart_Field__c customField6 = new Custom_Chart_Field__c(Chart_Field_Number__c = '005',
                Custom_Chart__c=customChart.Id,Field_Use__c='Summary',Name='Count Records',
                Field_API_Name__c = 'Height__c',Display_On_Chart__c=true,Display_Color__c='Pink',
                Type__c='Count',Display_Order_By__c = 5);
                
        Custom_Chart_Field__c customField7 = new Custom_Chart_Field__c(Chart_Field_Number__c = '006',
                Custom_Chart__c=customChart.Id,Field_Use__c='Summary',Name='Sum Records',
                Field_API_Name__c = 'Height__c',Display_On_Chart__c=true,Display_Color__c='Purple',
                Type__c='Sum',Display_Order_By__c = 6);
            
        Custom_Chart_Field__c customField8 = new Custom_Chart_Field__c(Chart_Field_Number__c = '007',
                Custom_Chart__c=customChart.Id,Field_Use__c='Summary',Name='Count Type of Fields',
                Field_API_Name__c = 'Type__c',Display_On_Chart__c=true,Display_Color__c='Cyan',
                Type__c='Count',Custom_Chart_Related_Object__c = relatedObject.Id,Display_Order_By__c = 7);
        
        Custom_Chart_Field__c customField9 = new Custom_Chart_Field__c(Chart_Field_Number__c = '008',
                Custom_Chart__c=customChart.Id,Field_Use__c='Formula',Name='Minimum + Maximum',
                Field_API_Name__c='NA',Display_On_Chart__c=false,Display_Color__c='Dark Green',
                Custom_Chart_Field_Number_A__c='002',Custom_Chart_Field_Number_b__c='003',
                Operator__c='Add',Display_Order_By__c = 8);
                
        Custom_Chart_Field__c customField10 = new Custom_Chart_Field__c(Chart_Field_Number__c = '009',
                Custom_Chart__c=customChart.Id,Field_Use__c='Formula',Name='MinMax Average',
                Field_API_Name__c='NA',Display_On_Chart__c=true,Display_Color__c='Dark Red',
                Custom_Chart_Field_Number_A__c='008',Custom_Chart_Field_Number_b__c='005',
                Operator__c='Divide',Display_Order_By__c = 9);
                
        Custom_Chart_Field__c customField11 = new Custom_Chart_Field__c(Chart_Field_Number__c = '010',
                Custom_Chart__c=customChart.Id,Field_Use__c='Condition',Condition_Value__c='Count',Name='Type equals Count',
                Field_API_Name__c = 'Type__c',Type__c = 'Equals', Custom_Chart_Related_Object__c = relatedObject.Id);
                
        insert customField1;
        insert customField2;
        insert customField3;
        insert customField4;
        insert customField5;
        insert customField6;
        insert customField7;
        insert customField8;
        insert customField9;
        insert customField10;
        insert customField11;
        
        Test.startTest();
            Test.setCurrentPage(Page.vfCustomChart);
            controllerCustomChart controller = new controllerCustomChart();
            
            Test.setCurrentPage(Page.vfCustomChart_FAIL);
            controller = new controllerCustomChart();
            
            Test.setCurrentPage(Page.vfCustomChart_TEST);
            controller = new controllerCustomChart();
            String chartURL = controller.chartURL;
            Boolean canDisplayChart = controller.displayChart;
            String source = controller.getCustomChartSource();
        Test.stopTest();
        
    }
    
    static testMethod void myUnitTest_ColumnChart() {
        Custom_Chart__c customChart = new Custom_Chart__c(Name = 'Test', Type__c = 'Column Chart',
                Base_Object__c = 'Custom Chart', Base_Object_API_Name__c = 'Custom_Chart__c',
                Code__c = 'test', Height__c = 250, Width__c = 250);
                
        insert customChart;
        
        Custom_Chart_Related_Object__c relatedObject = new Custom_Chart_Related_Object__c(Custom_Chart__c = customChart.Id,
                Name = 'Custom Chart Field', Related_Object_API_Name__c = 'Custom_Chart_Fields__r');
        
        insert relatedObject;
        
        Custom_Chart_Field__c customField1 = new Custom_Chart_Field__c(Chart_Field_Number__c = '000',
                Custom_Chart__c=customChart.Id,Field_Use__c='Condition',Condition_Value__c='TEST',Name='Custom Chart Code',
                Field_API_Name__c = 'Name',Type__c = 'Equals');
        
        Custom_Chart_Field__c customField2 = new Custom_Chart_Field__c(Chart_Field_Number__c = '001',
                Custom_Chart__c=customChart.Id,Field_Use__c='Group By',Name='Field Use Grouping',
                Field_API_Name__c = 'Field_Use__c',Display_On_Chart__c=true,Display_Color__c='Red',
                Custom_Chart_Related_Object__c = relatedObject.Id,Display_Order_By__c = 1);
        
        Custom_Chart_Field__c customField11 = new Custom_Chart_Field__c(Chart_Field_Number__c = '010',
                Custom_Chart__c=customChart.Id,Field_Use__c='Condition',Condition_Value__c='Maximum', Name='Type equals Maximum',
                Field_API_Name__c = 'Type__c',Type__c = 'Equals', Custom_Chart_Related_Object__c = relatedObject.Id);
                
        Custom_Chart_Field__c customField12 = new Custom_Chart_Field__c(Chart_Field_Number__c = '011',
                Custom_Chart__c=customChart.Id,Field_Use__c='Summary',Name='Maximum Chart Field Number',
                Field_API_Name__c = 'Chart_Field_Number__c',Display_On_Chart__c=true,Display_Color__c='Dark Green',Type__c='Maximum',
                Custom_Chart_Related_Object__c = relatedObject.Id,Display_Order_By__c = 2);
                
        Custom_Chart_Field__c customField13 = new Custom_Chart_Field__c(Chart_Field_Number__c = '012',
                Custom_Chart__c=customChart.Id,Field_Use__c='Summary',Name='Minimum Chart Field Number',
                Field_API_Name__c = 'Chart_Field_Number__c',Display_On_Chart__c=true,Display_Color__c='Dark Blue',Type__c='Minimum',
                Custom_Chart_Related_Object__c = relatedObject.Id,Display_Order_By__c = 3);
                
        Custom_Chart_Field__c customField14 = new Custom_Chart_Field__c(Chart_Field_Number__c = '013',
                Custom_Chart__c=customChart.Id,Field_Use__c='Summary',Name='Sum Chart Field Number',
                Field_API_Name__c = 'Chart_Field_Number__c',Display_On_Chart__c=true,Display_Color__c='Lime',Type__c='Sum',
                Custom_Chart_Related_Object__c = relatedObject.Id,Display_Order_By__c = 4);
                
        Custom_Chart_Field__c customField15 = new Custom_Chart_Field__c(Chart_Field_Number__c = '014',
                Custom_Chart__c=customChart.Id,Field_Use__c='Summary',Name='Average Chart Field Number',
                Field_API_Name__c = 'Chart_Field_Number__c',Display_On_Chart__c=true,Display_Color__c='Grey',Type__c='Average',
                Custom_Chart_Related_Object__c = relatedObject.Id,Display_Order_By__c = 5);
                
        insert customField1;
        insert customField2;
        insert customField11;
        insert customField12;
        insert customField13;
        insert customField14;
        insert customField15;
        
        Test.startTest();
            Test.setCurrentPage(Page.vfCustomChart_TEST);
            controllerCustomChart controller = new controllerCustomChart();
            String chartURL = controller.chartURL;
            Boolean canDisplayChart = controller.displayChart;
            String source = controller.getCustomChartSource();
        Test.stopTest();
        
    }
}