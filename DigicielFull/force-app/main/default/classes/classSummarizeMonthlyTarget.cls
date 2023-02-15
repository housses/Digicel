global class classSummarizeMonthlyTarget implements Schedulable{
	global void execute(SchedulableContext SC) {
		List<User> listUser = [SELECT Id, ICT_Monthly_Revenue_Target__c,
								Monthly_Recurring_Target__c, Monthly_OTC_Target__c,
								Previous_Month_ICT_Monthly_Revenue__c,
								Previous_Month_Monthly_OTC_Target__c,
								Previous_Month_Monthly_Recurring_Target__c,
								Next_Month_ICT_Monthly_Revenue__c,
								Next_Month_Monthly_OTC_Target__c,
								Next_Month_Monthly_Recurring_Target__c,
								Weekly_OTC_Target__c,
								Weekly_Recurring_Target__c,
								Previous_Month_Weekly_OTC_Target__c,
								Previous_Month_Weekly_Recurring_Target__c,
								Next_Month_Weekly_OTC_Target__c,
								Next_Month_Weekly_Recurring_Target__c,
								Digicel_Country__c
								FROM User
								WHERE isActive = true];
		
		List<Monthly_ICT_GSM_Targets__c> listMonthlyTarget = [SELECT Id, Target_Month_Date__c,
															ICT_Monthly_Revenue_Target__c,
															Monthly_OCT__c,
															Monthly_Recurring_Target__c,
															Weekly_Recurring_Target__c,
															Weekly_OTC_Target__c,
															ICT_User_Target_Records__c,
															ICT_User_Target_Records__r.ICT_Sales_Represenative__c,
															ICT_User_Target_Records__r.ICT_Sales_Represenative__r.ICT_Monthly_Revenue_Target__c,
															ICT_User_Target_Records__r.ICT_Sales_Represenative__r.Monthly_Recurring_Target__c,
															ICT_User_Target_Records__r.ICT_Sales_Represenative__r.Monthly_OTC_Target__c,
															ICT_User_Target_Records__r.ICT_Sales_Represenative__r.Previous_Month_ICT_Monthly_Revenue__c,
															ICT_User_Target_Records__r.ICT_Sales_Represenative__r.Previous_Month_Monthly_OTC_Target__c,
															ICT_User_Target_Records__r.ICT_Sales_Represenative__r.Previous_Month_Monthly_Recurring_Target__c,
															ICT_User_Target_Records__r.ICT_Sales_Represenative__r.Next_Month_ICT_Monthly_Revenue__c,
															ICT_User_Target_Records__r.ICT_Sales_Represenative__r.Next_Month_Monthly_OTC_Target__c,
															ICT_User_Target_Records__r.ICT_Sales_Represenative__r.Next_Month_Monthly_Recurring_Target__c,
															ICT_User_Target_Records__r.ICT_Sales_Represenative__r.Weekly_OTC_Target__c,
															ICT_User_Target_Records__r.ICT_Sales_Represenative__r.Weekly_Recurring_Target__c,
															ICT_User_Target_Records__r.ICT_Sales_Represenative__r.Previous_Month_Weekly_OTC_Target__c,
															ICT_User_Target_Records__r.ICT_Sales_Represenative__r.Previous_Month_Weekly_Recurring_Target__c,
															ICT_User_Target_Records__r.ICT_Sales_Represenative__r.Next_Month_Weekly_OTC_Target__c,
															ICT_User_Target_Records__r.ICT_Sales_Represenative__r.Next_Month_Weekly_Recurring_Target__c
															FROM Monthly_ICT_GSM_Targets__c
															WHERE ICT_User_Target_Records__r.ICT_Sales_Represenative__r.isActive = true
															AND (Target_Month_Date__c = THIS_MONTH
															OR Target_Month_Date__c = LAST_MONTH
															OR Target_Month_Date__c = NEXT_MONTH)];
		
		Map<Id, User> mapUser = new Map<Id, User>();
		for(User u: listUser){
			if(u.Digicel_Country__c != null && u.Digicel_Country__c.length()>0){
				u.ICT_Monthly_Revenue_Target__c = 0;
				u.Monthly_Recurring_Target__c = 0;
				u.Monthly_OTC_Target__c = 0;
				u.Previous_Month_ICT_Monthly_Revenue__c = 0;
				u.Previous_Month_Monthly_OTC_Target__c = 0;
				u.Previous_Month_Monthly_Recurring_Target__c = 0;
				u.Next_Month_ICT_Monthly_Revenue__c = 0;
				u.Next_Month_Monthly_OTC_Target__c = 0;
				u.Next_Month_Monthly_Recurring_Target__c = 0;
				
				u.Weekly_OTC_Target__c = 0;
				u.Weekly_Recurring_Target__c = 0;
				u.Previous_Month_Weekly_OTC_Target__c = 0;
				u.Previous_Month_Weekly_Recurring_Target__c = 0;
				u.Next_Month_Weekly_OTC_Target__c = 0;
				u.Next_Month_Weekly_Recurring_Target__c = 0;
				
				mapUser.put(u.Id, u);
			}
		}
		
		for(Monthly_ICT_GSM_Targets__c monthlyTarget: listMonthlyTarget){
			if(mapUser.containsKey(monthlyTarget.ICT_User_Target_Records__r.ICT_Sales_Represenative__c)){
				User u = mapUser.get(monthlyTarget.ICT_User_Target_Records__r.ICT_Sales_Represenative__c);
				
				if(monthlyTarget.Target_Month_Date__c!=null && monthlyTarget.Target_Month_Date__c.month() == System.today().month()){
					u.ICT_Monthly_Revenue_Target__c += (monthlyTarget.ICT_Monthly_Revenue_Target__c!=null?monthlyTarget.ICT_Monthly_Revenue_Target__c:0);
					u.Monthly_Recurring_Target__c += (monthlyTarget.Monthly_Recurring_Target__c!=null?monthlyTarget.Monthly_Recurring_Target__c:0);
					u.Monthly_OTC_Target__c += (monthlyTarget.Monthly_OCT__c!=null?monthlyTarget.Monthly_OCT__c:0);
					
					u.Weekly_Recurring_Target__c += (monthlyTarget.Weekly_Recurring_Target__c!=null?monthlyTarget.Weekly_Recurring_Target__c:0);
					u.Weekly_OTC_Target__c += (monthlyTarget.Weekly_OTC_Target__c!=null?monthlyTarget.Weekly_OTC_Target__c:0);
					
				}else if(monthlyTarget.Target_Month_Date__c!=null && monthlyTarget.Target_Month_Date__c.month() == System.today().addMonths(-1).month()){
					u.Previous_Month_ICT_Monthly_Revenue__c += (monthlyTarget.ICT_Monthly_Revenue_Target__c!=null?monthlyTarget.ICT_Monthly_Revenue_Target__c:0);
					u.Previous_Month_Monthly_Recurring_Target__c += (monthlyTarget.Monthly_Recurring_Target__c!=null?monthlyTarget.Monthly_Recurring_Target__c:0);
					u.Previous_Month_Monthly_OTC_Target__c += (monthlyTarget.Monthly_OCT__c!=null?monthlyTarget.Monthly_OCT__c:0);
					
					u.Previous_Month_Weekly_Recurring_Target__c += (monthlyTarget.Weekly_Recurring_Target__c!=null?monthlyTarget.Weekly_Recurring_Target__c:0);
					u.Previous_Month_Weekly_OTC_Target__c += (monthlyTarget.Weekly_OTC_Target__c!=null?monthlyTarget.Weekly_OTC_Target__c:0);
					
				} else if(monthlyTarget.Target_Month_Date__c!=null && monthlyTarget.Target_Month_Date__c.month() == System.today().addMonths(1).month()){
					u.Next_Month_ICT_Monthly_Revenue__c += (monthlyTarget.ICT_Monthly_Revenue_Target__c!=null?monthlyTarget.ICT_Monthly_Revenue_Target__c:0);
					u.Next_Month_Monthly_Recurring_Target__c += (monthlyTarget.Monthly_Recurring_Target__c!=null?monthlyTarget.Monthly_Recurring_Target__c:0);
					u.Next_Month_Monthly_OTC_Target__c += (monthlyTarget.Monthly_OCT__c!=null?monthlyTarget.Monthly_OCT__c:0);
					
					u.Next_Month_Weekly_Recurring_Target__c += (monthlyTarget.Weekly_Recurring_Target__c!=null?monthlyTarget.Weekly_Recurring_Target__c:0);
					u.Next_Month_Weekly_OTC_Target__c += (monthlyTarget.Weekly_OTC_Target__c!=null?monthlyTarget.Weekly_OTC_Target__c:0);
					
				}
				mapUser.put(u.Id, u);
			}
		}
		
		if(mapUser.size()>0) update mapUser.values();
	}
}