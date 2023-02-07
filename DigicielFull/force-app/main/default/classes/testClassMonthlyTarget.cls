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
private class testClassMonthlyTarget {

    static testMethod void myUnitTest() {
        ICT_User_Target_Records__c targetRecord = new ICT_User_Target_Records__c(
        		CurrencyIsoCode = UserInfo.getDefaultCurrency(),
        		ICT_Sales_Represenative__c = UserInfo.getUserId());
        
        insert targetRecord;
        
        Monthly_ICT_GSM_Targets__c monthlyTarget1 = new Monthly_ICT_GSM_Targets__c(
        		CurrencyIsoCode = UserInfo.getDefaultCurrency(),
        		ICT_Monthly_Revenue_Target__c = 100.00,
        		ICT_User_Target_Records__c = targetRecord.Id,
        		Target_Month_Date__c = System.today());
        insert monthlyTarget1;
        
        Monthly_ICT_GSM_Targets__c monthlyTarget2 = new Monthly_ICT_GSM_Targets__c(
        		CurrencyIsoCode = UserInfo.getDefaultCurrency(),
        		ICT_Monthly_Revenue_Target__c = 100.00,
        		ICT_User_Target_Records__c = targetRecord.Id,
        		Target_Month_Date__c = System.today().addMonths(1));
        insert monthlyTarget2;
        
        monthlyTarget2.Target_Month_Date__c = System.today();
        update monthlyTarget2;
        
        delete monthlyTarget2;
        
        Vacation_Log__c vacationLog = new Vacation_Log__c(
        		User_Name__c = Userinfo.getUserId(),
        		Vacation_Start_Date__c = System.today().addDays(-2),
        		Vacation_End_Date__c = System.today().addDays(1));
        insert vacationLog;
        
        Test.startTest();
        
        String CRON_EXP = '0 0 0 3 9 ? 2022';
	    String jobid = System.schedule('Prueba_FY', CRON_EXP, new classVerifyMonthlyTargetsFiscalYear());
	    CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
	    // Verify the expressions are the same  
	    System.assertEquals(CRON_EXP, ct.CronExpression);
	
	   	// Verify the job has not run  
	   	    
	    System.assertEquals(0, ct.TimesTriggered);
	    
	    String CRON_EXP_2 = '0 0 0 3 10 ? 2022';
	    String jobid_2 = System.schedule('Prueba_S', CRON_EXP_2, new classSummarizeMonthlyTarget());
	    CronTrigger ct_2 = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId_2];
	    // Verify the expressions are the same  
	    System.assertEquals(CRON_EXP_2, ct_2.CronExpression);
	
	   	// Verify the job has not run  
	   	    
	    System.assertEquals(0, ct_2.TimesTriggered);
	    
	    String CRON_EXP_3 = '0 0 0 3 11 ? 2022';
	    String jobid_3 = System.schedule('Prueba_VA', CRON_EXP_3, new classVacationStatusUpdate());
	    CronTrigger ct_3 = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId_3];
	    // Verify the expressions are the same  
	    System.assertEquals(CRON_EXP_3, ct_3.CronExpression);
	
	   	// Verify the job has not run  
	   	    
	    System.assertEquals(0, ct_3.TimesTriggered);
	    
	    vacationLog.Vacation_End_Date__c = System.today().addDays(-1);
	    update vacationLog;
        
        String CRON_EXP_4 = '0 0 0 3 12 ? 2022';
	    String jobid_4 = System.schedule('Prueba_VI', CRON_EXP_4, new classVacationStatusUpdate());
	    CronTrigger ct_4 = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId_4];
	    // Verify the expressions are the same  
	    System.assertEquals(CRON_EXP_4, ct_4.CronExpression);
	
	   	// Verify the job has not run  
	   	    
	    System.assertEquals(0, ct_4.TimesTriggered);
	    
        Test.stopTest();
    }
}