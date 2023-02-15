@isTest
private class testClassGetMeeting{
    static testMethod void myUnitTest() {
        
        RecordType recordType_JamaicaTask = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_Business_Task_Reminder' AND SobjectType = 'Task'];
        RecordType recordType_JamaicaEvent = [SELECT Id FROM RecordType WHERE DeveloperName = 'Digicel_Business_Event' AND SobjectType = 'Event'];
        
        Task t = new Task();
        t.ActivityDate = System.today();
        t.RecordTypeId = recordType_JamaicaTask.Id;
        t.Subject = 'Call';
        t.Type = 'Follow Up';
        t.Status = 'Not Started';
        t.CurrencyIsoCode = 'USD';
        t.Priority = 'Normal';
        
        insert t;
        
        Event e = new Event();
        e.StartDateTime = System.now();
        e.EndDateTime = system.now().addHours(1);
        e.RecordTypeId = recordType_JamaicaEvent.Id;
        e.Subject = 'Call';
        e.Type = 'Follow Up';
        e.CurrencyIsoCode = 'USD';
        
        insert e;
        
        Test.startTest();
        
        String CRON_EXP_4 = '0 0 0 3 12 ? 2022';
        String jobid_4 = System.schedule('Prueba_V', CRON_EXP_4, new GetMeeting());
        CronTrigger ct_4 = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId_4];
        // Verify the expressions are the same  
        System.assertEquals(CRON_EXP_4, ct_4.CronExpression);
    
        // Verify the job has not run  
            
        System.assertEquals(0, ct_4.TimesTriggered);
        
        Test.stopTest();
    }
}