global class GetMeeting implements Schedulable{

    global void execute(SchedulableContext SC)
    { 
        List<Task> tl = [Select OwnerId, Mth_Meeting_Target__c from Task Where Type != '-None-' AND Type != NULL AND Type != ''];
        List<Event> el = [Select OwnerId, Mth_Meeting_Target__c from Event];
        
        List<Id> userIds = new List<Id>();
        for(Task t: tl){
            userIds.add(t.OwnerId);
        }
        
        for(Event e: el){
            userIds.add(e.OwnerId);
        }
        
        Map<Id, User> mapUser = new Map<Id, User>([SELECT Id, Mth_Meeting_Target__c FROM User WHERE Id IN :userIds]);    
            
        for(Task t: tl){
            if(mapUser.containsKey(t.OwnerId)){
            	t.Mth_Meeting_Target__c = mapUser.get(t.OwnerId).Mth_Meeting_Target__c;
            }
        }
        
        update tl;    
        
        for(Event e: el){
            if(mapUser.containsKey(e.OwnerId)){
            	e.Mth_Meeting_Target__c = mapUser.get(e.OwnerId).Mth_Meeting_Target__c;
            }
        }
        
        update el;  
    }
}