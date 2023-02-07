trigger triggerUserVacationStatus on Vacation_Log__c (after insert, after undelete, 
after update) {
    
    List<Id> idsUsers = new List<Id>();
    for(Vacation_Log__c vl: Trigger.new){
        idsUsers.add(vl.User_Name__c);
    }
    
    Map<Id, User> mapUsers = new Map<Id,User> ([SELECT Id, Vacation_Status__c FROM User WHERE Id IN: idsUsers]);
    
    Map<Id, User> mapUserUpdate = new Map<Id, User>();
    for(Vacation_Log__c vl: Trigger.new){
        User u = mapUsers.get(vl.User_Name__c);
        if(vl.Vacation_Start_Date__c <= System.today() && vl.Vacation_End_Date__c >= System.today() && u.Vacation_Status__c != 'On Vacation'){
            u.Vacation_Status__c = 'On Vacation';
            mapUserUpdate.put(u.Id, u);
        }
    }
    
    if(mapUserUpdate.size()>0) update mapUserUpdate.values();
}