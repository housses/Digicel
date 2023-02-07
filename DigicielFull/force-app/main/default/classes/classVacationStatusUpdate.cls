global class classVacationStatusUpdate implements Schedulable{
	global void execute(SchedulableContext SC) {
		List<User> listUsers = [SELECT Id, Vacation_Status__c FROM User
								WHERE Id IN (SELECT User_Name__c 
											FROM Vacation_Log__c
											WHERE (Vacation_Start_Date__c >= TODAY
											AND Vacation_End_Date__c <= TODAY
											AND User_Name__r.Vacation_Status__c = 'Not On Vacation')
											OR (((Vacation_Start_Date__c < TODAY
											AND Vacation_End_Date__c < TODAY)
											OR Vacation_Start_Date__c > TODAY)
											AND User_Name__r.Vacation_Status__c = 'On Vacation')
											)
								];
								
		for(User u: listUsers){
			if(u.Vacation_Status__c == 'On Vacation'){
				u.Vacation_Status__c = 'Not On Vacation';
			}else{
				u.Vacation_Status__c = 'On Vacation';
			}
		}
		if(listUsers.size()>0) update listUsers;
	}
}