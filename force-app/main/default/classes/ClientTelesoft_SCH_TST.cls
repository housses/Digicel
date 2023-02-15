@isTest
public class ClientTelesoft_SCH_TST {
    @isTest
    public static void testScheduleClientTelesoft(){
        
        Test.setMock(HttpCalloutMock.class, new MockClientTelesoft_TST());
        
        Test.startTest();
        String CRON_EXP = '0 0 0 3 9 ? 2025';
        String jobId = System.schedule('Test schedule client telesoft', CRON_EXP, new ClientTelesoft_SCH());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
        
        // Verify the expressions are the same
        System.assertEquals('0 0 0 3 9 ? 2025', ct.CronExpression);
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        // Verify the next time the job will run
        System.assertEquals('2025-09-03 00:00:00', String.valueOf(ct.NextFireTime));

        Test.stopTest();
       }
}