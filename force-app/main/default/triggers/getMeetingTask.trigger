trigger getMeetingTask on Task (before insert, before update) {
    
    List<Id> userIds = new List<Id>();
    for(Task t: Trigger.new){
        userIds.add(t.OwnerId);
    }
    
    Map<Id, User> mapUser = new Map<Id, User>([Select Mth_Meeting_Target__c from User where ID IN :userIds]);
    
	for(Task t: Trigger.new){
        if(mapUser.containsKey(t.OwnerId)){
        	t.Mth_Meeting_Target__c = mapUser.get(t.OwnerId).Mth_Meeting_Target__c;
        }
    }
}