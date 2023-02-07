trigger triggerValidateVacationLog on Vacation_Log__c (before insert, before update) {
    List<Id> idUsers = new List<Id>();
    for(Vacation_Log__c vacationLog : Trigger.new){
        idUsers.add(vacationLog.User_Name__c);
    }
    
    List<Vacation_Log__c> listVacationLog = [SELECT Id, Vacation_Start_Date__c,
                                            Vacation_End_Date__c, User_Name__c
                                            FROM Vacation_Log__c
                                            WHERE User_Name__c IN :idUsers];
    
    for(Vacation_Log__c vacationLog: Trigger.new){
        for(Vacation_Log__c vacationLogVerify: listVacationLog){
            if(vacationLog.User_Name__c == vacationLogVerify.User_Name__c && vacationLog.Id != vacationLogVerify.Id){
                if((vacationLog.Vacation_Start_Date__c >= vacationLogVerify.Vacation_Start_Date__c
                    && vacationLog.Vacation_Start_Date__c <= vacationLogVerify.Vacation_End_Date__c)
                    || (vacationLog.Vacation_End_Date__c >= vacationLogVerify.Vacation_Start_Date__c
                    && vacationLog.Vacation_End_Date__c <= vacationLogVerify.Vacation_End_Date__c)){
                        vacationLog.addError('The vacation Start Date or End Date is overlapping with another vacation log for the same user. Please verify the dates.');
                }
            }
        }
    }
}