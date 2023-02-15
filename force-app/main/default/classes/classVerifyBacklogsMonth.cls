global class classVerifyBacklogsMonth implements Schedulable{
	global void execute(SchedulableContext SC) {
		List<Backlog__c> listBacklogUpdate = [SELECT Id, Current_Month__c
												FROM Backlog__c
												WHERE (Date__c = THIS_MONTH
												AND Current_Month__c = false)
												OR (Date__c != THIS_MONTH
												AND Current_Month__c = true)];
		
		for(Backlog__c backlog: listBacklogUpdate){
			backlog.Current_Month__c = !backlog.Current_Month__c;
		}
		
		update listBacklogUpdate;
	}
}