trigger triggerSummarizeMonthlyTarget on Monthly_ICT_GSM_Targets__c (after insert, after update, after delete) {
    List<Id> targetIds = new List<Id>();
    if(!Trigger.isDelete){
        for(Monthly_ICT_GSM_Targets__c monthlyTarget: Trigger.new){
            if(monthlyTarget.Target_Month_Date__c!=null && monthlyTarget.Target_Month_Date__c.month() == System.today().month()){
                targetIds.add(monthlyTarget.ICT_User_Target_Records__c);
            }
        }
    }
    
    if(Trigger.isUpdate){
        for(Monthly_ICT_GSM_Targets__c monthlyTarget: Trigger.old){
            if(monthlyTarget.Target_Month_Date__c!=null && monthlyTarget.Target_Month_Date__c.month() == System.today().month()){
                targetIds.add(monthlyTarget.ICT_User_Target_Records__c);
            }
        }
    }
    
    if(Trigger.isDelete){
        for(Monthly_ICT_GSM_Targets__c monthlyTarget: Trigger.old){
            if(monthlyTarget.Target_Month_Date__c!=null && monthlyTarget.Target_Month_Date__c.month() == System.today().month()){
                targetIds.add(monthlyTarget.ICT_User_Target_Records__c);
            }
        }
    }
    
    Map<Id,ICT_User_Target_Records__c> mapTargets = new Map<Id,ICT_User_Target_Records__c>(
                                                    [SELECT Id, ICT_Sales_Represenative__c,
                                                    ICT_Sales_Represenative__r.ICT_Monthly_Revenue_Target__c,
                                                    ICT_Sales_Represenative__r.Monthly_Recurring_Target__c,
                                                    ICT_Sales_Represenative__r.Monthly_OTC_Target__c,
                                                    ICT_Sales_Represenative__r.Previous_Month_ICT_Monthly_Revenue__c,
                                                    ICT_Sales_Represenative__r.Previous_Month_Monthly_OTC_Target__c,
                                                    ICT_Sales_Represenative__r.Previous_Month_Monthly_Recurring_Target__c,
                                                    ICT_Sales_Represenative__r.Next_Month_ICT_Monthly_Revenue__c,
                                                    ICT_Sales_Represenative__r.Next_Month_Monthly_OTC_Target__c,
                                                    ICT_Sales_Represenative__r.Next_Month_Monthly_Recurring_Target__c,
                                                    ICT_Sales_Represenative__r.Weekly_OTC_Target__c,
                                                    ICT_Sales_Represenative__r.Weekly_Recurring_Target__c,
                                                    ICT_Sales_Represenative__r.Previous_Month_Weekly_OTC_Target__c,
                                                    ICT_Sales_Represenative__r.Previous_Month_Weekly_Recurring_Target__c,
                                                    ICT_Sales_Represenative__r.Next_Month_Weekly_OTC_Target__c,
                                                    ICT_Sales_Represenative__r.Next_Month_Weekly_Recurring_Target__c
                                                    FROM ICT_User_Target_Records__c
                                                    WHERE Id IN: targetIds
                                                    AND ICT_Sales_Represenative__r.isActive = true]);
            
    Map<Id, User> mapUser = new Map<Id, User>();
    if(!Trigger.isDelete){
        for(Monthly_ICT_GSM_Targets__c monthlyTarget: Trigger.new){
            if(monthlyTarget.Target_Month_Date__c!=null && monthlyTarget.Target_Month_Date__c.month() == System.today().month()){
                Decimal target = 0;
                Decimal monthlyRecurring = 0;
                Decimal monthlyOTC = 0;
                Decimal weeklyRecurring = 0;
                Decimal weeklyOTC = 0;
                
                if(Trigger.isUpdate && Trigger.oldMap.containsKey(monthlyTarget.Id)){
                    target = (monthlyTarget.ICT_Monthly_Revenue_Target__c!=null?monthlyTarget.ICT_Monthly_Revenue_Target__c:0)
                        - (Trigger.oldMap.get(monthlyTarget.Id).ICT_Monthly_Revenue_Target__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c.month() == System.today().month()?Trigger.oldMap.get(monthlyTarget.Id).ICT_Monthly_Revenue_Target__c:0);
                    monthlyRecurring = (monthlyTarget.Monthly_Recurring_Target__c!=null?monthlyTarget.Monthly_Recurring_Target__c:0)
                        - (Trigger.oldMap.get(monthlyTarget.Id).Monthly_Recurring_Target__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c.month() == System.today().month()?Trigger.oldMap.get(monthlyTarget.Id).Monthly_Recurring_Target__c:0);
                    monthlyOTC = (monthlyTarget.Monthly_OCT__c!=null?monthlyTarget.Monthly_OCT__c:0)
                        - (Trigger.oldMap.get(monthlyTarget.Id).Monthly_OCT__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c.month() == System.today().month()?Trigger.oldMap.get(monthlyTarget.Id).Monthly_OCT__c:0);
                    weeklyRecurring = (monthlyTarget.Weekly_Recurring_Target__c!=null?monthlyTarget.Weekly_Recurring_Target__c:0)
                        - (Trigger.oldMap.get(monthlyTarget.Id).Weekly_Recurring_Target__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c.month() == System.today().month()?Trigger.oldMap.get(monthlyTarget.Id).Weekly_Recurring_Target__c:0);
                    weeklyOTC = (monthlyTarget.Weekly_OTC_Target__c!=null?monthlyTarget.Weekly_OTC_Target__c:0)
                        - (Trigger.oldMap.get(monthlyTarget.Id).Weekly_OTC_Target__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c.month() == System.today().month()?Trigger.oldMap.get(monthlyTarget.Id).Weekly_OTC_Target__c:0);
                    
                }else{
                    target = (monthlyTarget.ICT_Monthly_Revenue_Target__c!=null?monthlyTarget.ICT_Monthly_Revenue_Target__c:0);
                    monthlyRecurring = (monthlyTarget.Monthly_Recurring_Target__c!=null?monthlyTarget.Monthly_Recurring_Target__c:0);
                    monthlyOTC = (monthlyTarget.Monthly_OCT__c!=null?monthlyTarget.Monthly_OCT__c:0);
                    weeklyRecurring = (monthlyTarget.Weekly_Recurring_Target__c!=null?monthlyTarget.Weekly_Recurring_Target__c:0);
                    weeklyOTC = (monthlyTarget.Weekly_OTC_Target__c!=null?monthlyTarget.Weekly_OTC_Target__c:0);
                }
                
                if(mapTargets.containsKey(monthlyTarget.ICT_User_Target_Records__c)){
                    ICT_User_Target_Records__c targetRecord = mapTargets.get(monthlyTarget.ICT_User_Target_Records__c);
                    User u;
                    
                    if(mapUser.containsKey(targetRecord.ICT_Sales_Represenative__c)){
                        u = mapUser.get(targetRecord.ICT_Sales_Represenative__c);
                    }else{
                        u = new User(Id = targetRecord.ICT_Sales_Represenative__c,
                                    ICT_Monthly_Revenue_Target__c = targetRecord.ICT_Sales_Represenative__r.ICT_Monthly_Revenue_Target__c,
                                    Monthly_Recurring_Target__c = targetRecord.ICT_Sales_Represenative__r.Monthly_Recurring_Target__c,
                                    Monthly_OTC_Target__c = targetRecord.ICT_Sales_Represenative__r.Monthly_OTC_Target__c,
                                    Weekly_Recurring_Target__c = targetRecord.ICT_Sales_Represenative__r.Weekly_Recurring_Target__c,
                                    Weekly_OTC_Target__c = targetRecord.ICT_Sales_Represenative__r.Weekly_OTC_Target__c);
                    }
                    
                    if(u.ICT_Monthly_Revenue_Target__c==null) u.ICT_Monthly_Revenue_Target__c = 0;
                    if(u.Monthly_Recurring_Target__c==null) u.Monthly_Recurring_Target__c = 0;
                    if(u.Monthly_OTC_Target__c==null) u.Monthly_OTC_Target__c = 0;
                    if(u.Weekly_Recurring_Target__c==null) u.Weekly_Recurring_Target__c = 0;
                    if(u.Weekly_OTC_Target__c==null) u.Weekly_OTC_Target__c = 0;
                    
                    u.ICT_Monthly_Revenue_Target__c += target;
                    u.Monthly_Recurring_Target__c += monthlyRecurring;
                    u.Monthly_OTC_Target__c += monthlyOTC;
                    u.Weekly_Recurring_Target__c += weeklyRecurring;
                    u.Weekly_OTC_Target__c += weeklyOTC;
                    mapUser.put(u.Id, u);
                }
            } else if(monthlyTarget.Target_Month_Date__c!=null && monthlyTarget.Target_Month_Date__c.month() == System.today().addMonths(-1).month()){
                Decimal target = 0;
                Decimal monthlyRecurring = 0;
                Decimal monthlyOTC = 0;
                Decimal weeklyRecurring = 0;
                Decimal weeklyOTC = 0;
                
                if(Trigger.isUpdate && Trigger.oldMap.containsKey(monthlyTarget.Id)){
                    target = (monthlyTarget.ICT_Monthly_Revenue_Target__c!=null?monthlyTarget.ICT_Monthly_Revenue_Target__c:0)
                        - (Trigger.oldMap.get(monthlyTarget.Id).ICT_Monthly_Revenue_Target__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c.month() == System.today().month()?Trigger.oldMap.get(monthlyTarget.Id).ICT_Monthly_Revenue_Target__c:0);
                    monthlyRecurring = (monthlyTarget.Monthly_Recurring_Target__c!=null?monthlyTarget.Monthly_Recurring_Target__c:0)
                        - (Trigger.oldMap.get(monthlyTarget.Id).Monthly_Recurring_Target__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c.month() == System.today().month()?Trigger.oldMap.get(monthlyTarget.Id).Monthly_Recurring_Target__c:0);
                    monthlyOTC = (monthlyTarget.Monthly_OCT__c!=null?monthlyTarget.Monthly_OCT__c:0)
                        - (Trigger.oldMap.get(monthlyTarget.Id).Monthly_OCT__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c.month() == System.today().month()?Trigger.oldMap.get(monthlyTarget.Id).Monthly_OCT__c:0);
                    weeklyRecurring = (monthlyTarget.Weekly_Recurring_Target__c!=null?monthlyTarget.Weekly_Recurring_Target__c:0)
                        - (Trigger.oldMap.get(monthlyTarget.Id).Weekly_Recurring_Target__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c.month() == System.today().month()?Trigger.oldMap.get(monthlyTarget.Id).Weekly_Recurring_Target__c:0);
                    weeklyOTC = (monthlyTarget.Weekly_OTC_Target__c!=null?monthlyTarget.Weekly_OTC_Target__c:0)
                        - (Trigger.oldMap.get(monthlyTarget.Id).Weekly_OTC_Target__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c.month() == System.today().month()?Trigger.oldMap.get(monthlyTarget.Id).Weekly_OTC_Target__c:0);
                    
                }else{
                    target = (monthlyTarget.ICT_Monthly_Revenue_Target__c!=null?monthlyTarget.ICT_Monthly_Revenue_Target__c:0);
                    monthlyRecurring = (monthlyTarget.Monthly_Recurring_Target__c!=null?monthlyTarget.Monthly_Recurring_Target__c:0);
                    monthlyOTC = (monthlyTarget.Monthly_OCT__c!=null?monthlyTarget.Monthly_OCT__c:0);
                    weeklyRecurring = (monthlyTarget.Weekly_Recurring_Target__c!=null?monthlyTarget.Weekly_Recurring_Target__c:0);
                    weeklyOTC = (monthlyTarget.Weekly_OTC_Target__c!=null?monthlyTarget.Weekly_OTC_Target__c:0);
                }
                
                if(mapTargets.containsKey(monthlyTarget.ICT_User_Target_Records__c)){
                    ICT_User_Target_Records__c targetRecord = mapTargets.get(monthlyTarget.ICT_User_Target_Records__c);
                    User u;
                    
                    if(mapUser.containsKey(targetRecord.ICT_Sales_Represenative__c)){
                        u = mapUser.get(targetRecord.ICT_Sales_Represenative__c);
                    }else{
                        u = new User(Id = targetRecord.ICT_Sales_Represenative__c,
                                    Previous_Month_ICT_Monthly_Revenue__c = targetRecord.ICT_Sales_Represenative__r.Previous_Month_ICT_Monthly_Revenue__c,
                                    Previous_Month_Monthly_Recurring_Target__c = targetRecord.ICT_Sales_Represenative__r.Previous_Month_Monthly_Recurring_Target__c,
                                    Previous_Month_Monthly_OTC_Target__c = targetRecord.ICT_Sales_Represenative__r.Previous_Month_Monthly_OTC_Target__c,
                                    Previous_Month_Weekly_Recurring_Target__c = targetRecord.ICT_Sales_Represenative__r.Previous_Month_Weekly_Recurring_Target__c,
                                    Previous_Month_Weekly_OTC_Target__c = targetRecord.ICT_Sales_Represenative__r.Previous_Month_Weekly_OTC_Target__c);
                    }
                    
                    if(u.Previous_Month_ICT_Monthly_Revenue__c==null) u.Previous_Month_ICT_Monthly_Revenue__c = 0;
                    if(u.Previous_Month_Monthly_Recurring_Target__c==null) u.Previous_Month_Monthly_Recurring_Target__c = 0;
                    if(u.Previous_Month_Monthly_OTC_Target__c==null) u.Previous_Month_Monthly_OTC_Target__c = 0;
                    if(u.Previous_Month_Weekly_Recurring_Target__c==null) u.Previous_Month_Weekly_Recurring_Target__c = 0;
                    if(u.Previous_Month_Weekly_OTC_Target__c==null) u.Previous_Month_Weekly_OTC_Target__c = 0;
                    
                    u.Previous_Month_ICT_Monthly_Revenue__c += target;
                    u.Previous_Month_Monthly_Recurring_Target__c += monthlyRecurring;
                    u.Previous_Month_Monthly_OTC_Target__c += monthlyOTC;
                    u.Previous_Month_Weekly_Recurring_Target__c += weeklyRecurring;
                    u.Previous_Month_Weekly_OTC_Target__c += weeklyOTC;
                    mapUser.put(u.Id, u);
                }
            } else if(monthlyTarget.Target_Month_Date__c!=null && monthlyTarget.Target_Month_Date__c.month() == System.today().addMonths(1).month()){
                Decimal target = 0;
                Decimal monthlyRecurring = 0;
                Decimal monthlyOTC = 0;
                Decimal weeklyRecurring = 0;
                Decimal weeklyOTC = 0;
                
                if(Trigger.isUpdate && Trigger.oldMap.containsKey(monthlyTarget.Id)){
                    target = (monthlyTarget.ICT_Monthly_Revenue_Target__c!=null?monthlyTarget.ICT_Monthly_Revenue_Target__c:0)
                        - (Trigger.oldMap.get(monthlyTarget.Id).ICT_Monthly_Revenue_Target__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c.month() == System.today().month()?Trigger.oldMap.get(monthlyTarget.Id).ICT_Monthly_Revenue_Target__c:0);
                    monthlyRecurring = (monthlyTarget.Monthly_Recurring_Target__c!=null?monthlyTarget.Monthly_Recurring_Target__c:0)
                        - (Trigger.oldMap.get(monthlyTarget.Id).Monthly_Recurring_Target__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c.month() == System.today().month()?Trigger.oldMap.get(monthlyTarget.Id).Monthly_Recurring_Target__c:0);
                    monthlyOTC = (monthlyTarget.Monthly_OCT__c!=null?monthlyTarget.Monthly_OCT__c:0)
                        - (Trigger.oldMap.get(monthlyTarget.Id).Monthly_OCT__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c.month() == System.today().month()?Trigger.oldMap.get(monthlyTarget.Id).Monthly_OCT__c:0);
                    weeklyRecurring = (monthlyTarget.Weekly_Recurring_Target__c!=null?monthlyTarget.Weekly_Recurring_Target__c:0)
                        - (Trigger.oldMap.get(monthlyTarget.Id).Weekly_Recurring_Target__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c.month() == System.today().month()?Trigger.oldMap.get(monthlyTarget.Id).Weekly_Recurring_Target__c:0);
                    weeklyOTC = (monthlyTarget.Weekly_OTC_Target__c!=null?monthlyTarget.Weekly_OTC_Target__c:0)
                        - (Trigger.oldMap.get(monthlyTarget.Id).Weekly_OTC_Target__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c !=null && Trigger.oldMap.get(monthlyTarget.Id).Target_Month_Date__c.month() == System.today().month()?Trigger.oldMap.get(monthlyTarget.Id).Weekly_OTC_Target__c:0);
                    
                }else{
                    target = (monthlyTarget.ICT_Monthly_Revenue_Target__c!=null?monthlyTarget.ICT_Monthly_Revenue_Target__c:0);
                    monthlyRecurring = (monthlyTarget.Monthly_Recurring_Target__c!=null?monthlyTarget.Monthly_Recurring_Target__c:0);
                    monthlyOTC = (monthlyTarget.Monthly_OCT__c!=null?monthlyTarget.Monthly_OCT__c:0);
                    weeklyRecurring = (monthlyTarget.Weekly_Recurring_Target__c!=null?monthlyTarget.Weekly_Recurring_Target__c:0);
                    weeklyOTC = (monthlyTarget.Weekly_OTC_Target__c!=null?monthlyTarget.Weekly_OTC_Target__c:0);
                }
                
                if(mapTargets.containsKey(monthlyTarget.ICT_User_Target_Records__c)){
                    ICT_User_Target_Records__c targetRecord = mapTargets.get(monthlyTarget.ICT_User_Target_Records__c);
                    User u;
                    
                    if(mapUser.containsKey(targetRecord.ICT_Sales_Represenative__c)){
                        u = mapUser.get(targetRecord.ICT_Sales_Represenative__c);
                    }else{
                        u = new User(Id = targetRecord.ICT_Sales_Represenative__c,
                                    Next_Month_ICT_Monthly_Revenue__c = targetRecord.ICT_Sales_Represenative__r.Next_Month_ICT_Monthly_Revenue__c,
                                    Next_Month_Monthly_Recurring_Target__c = targetRecord.ICT_Sales_Represenative__r.Next_Month_Monthly_Recurring_Target__c,
                                    Next_Month_Monthly_OTC_Target__c = targetRecord.ICT_Sales_Represenative__r.Next_Month_Monthly_OTC_Target__c,
                                    Next_Month_Weekly_Recurring_Target__c = targetRecord.ICT_Sales_Represenative__r.Next_Month_Weekly_Recurring_Target__c,
                                    Next_Month_Weekly_OTC_Target__c = targetRecord.ICT_Sales_Represenative__r.Next_Month_Weekly_OTC_Target__c);
                    }
                    
                    if(u.Next_Month_ICT_Monthly_Revenue__c==null) u.Next_Month_ICT_Monthly_Revenue__c = 0;
                    if(u.Next_Month_Monthly_Recurring_Target__c==null) u.Next_Month_Monthly_Recurring_Target__c = 0;
                    if(u.Next_Month_Monthly_OTC_Target__c==null) u.Next_Month_Monthly_OTC_Target__c = 0;
                    if(u.Next_Month_Weekly_Recurring_Target__c==null) u.Next_Month_Weekly_Recurring_Target__c = 0;
                    if(u.Next_Month_Weekly_OTC_Target__c==null) u.Next_Month_Weekly_OTC_Target__c = 0;
                    
                    u.Next_Month_ICT_Monthly_Revenue__c += target;
                    u.Next_Month_Monthly_Recurring_Target__c += monthlyRecurring;
                    u.Next_Month_Monthly_OTC_Target__c += monthlyOTC;
                    u.Next_Month_Weekly_Recurring_Target__c += weeklyRecurring;
                    u.Next_Month_Weekly_OTC_Target__c += weeklyOTC;
                    mapUser.put(u.Id, u);
                }
            }
        }
    }
    
    if(Trigger.isDelete){
        for(Monthly_ICT_GSM_Targets__c monthlyTarget: Trigger.old){
            if(mapTargets.containsKey(monthlyTarget.ICT_User_Target_Records__c)){
                ICT_User_Target_Records__c targetRecord = mapTargets.get(monthlyTarget.ICT_User_Target_Records__c);
                
                Decimal target = (monthlyTarget.ICT_Monthly_Revenue_Target__c!=null?monthlyTarget.ICT_Monthly_Revenue_Target__c:0);
                Decimal monthlyRecurring = (monthlyTarget.Monthly_Recurring_Target__c!=null?monthlyTarget.Monthly_Recurring_Target__c:0);
                Decimal monthlyOTC = (monthlyTarget.Monthly_OCT__c!=null?monthlyTarget.Monthly_OCT__c:0);
                
                Decimal weeklyRecurring = (monthlyTarget.Weekly_Recurring_Target__c!=null?monthlyTarget.Weekly_Recurring_Target__c:0);
                Decimal weeklyOTC = (monthlyTarget.Weekly_OTC_Target__c!=null?monthlyTarget.Weekly_OTC_Target__c:0);
                
                if(monthlyTarget.Target_Month_Date__c!=null && monthlyTarget.Target_Month_Date__c.month() == System.today().month()){
                    User u;
                    if(mapUser.containsKey(targetRecord.ICT_Sales_Represenative__c)){
                        u = mapUser.get(targetRecord.ICT_Sales_Represenative__c);
                    }else{
                        u = new User(Id = targetRecord.ICT_Sales_Represenative__c,
                                    ICT_Monthly_Revenue_Target__c = targetRecord.ICT_Sales_Represenative__r.ICT_Monthly_Revenue_Target__c,
                                    Monthly_Recurring_Target__c = targetRecord.ICT_Sales_Represenative__r.Monthly_Recurring_Target__c,
                                    Monthly_OTC_Target__c = targetRecord.ICT_Sales_Represenative__r.Monthly_OTC_Target__c,
                                    Weekly_Recurring_Target__c = targetRecord.ICT_Sales_Represenative__r.Weekly_Recurring_Target__c,
                                    Weekly_OTC_Target__c = targetRecord.ICT_Sales_Represenative__r.Weekly_OTC_Target__c);
                    }
                    
                    u.ICT_Monthly_Revenue_Target__c -= target;
                    u.Monthly_Recurring_Target__c -= monthlyRecurring;
                    u.Monthly_OTC_Target__c -= monthlyOTC;
                    u.Weekly_OTC_Target__c -= weeklyOTC;
                    u.Weekly_Recurring_Target__c -= weeklyRecurring;
                    mapUser.put(u.Id, u);
                } else if(monthlyTarget.Target_Month_Date__c!=null && monthlyTarget.Target_Month_Date__c.month() == System.today().addMonths(1).month()){
                    User u;
                    if(mapUser.containsKey(targetRecord.ICT_Sales_Represenative__c)){
                        u = mapUser.get(targetRecord.ICT_Sales_Represenative__c);
                    }else{
                        u = new User(Id = targetRecord.ICT_Sales_Represenative__c,
                                    Next_Month_ICT_Monthly_Revenue__c = targetRecord.ICT_Sales_Represenative__r.Next_Month_ICT_Monthly_Revenue__c,
                                    Next_Month_Monthly_Recurring_Target__c = targetRecord.ICT_Sales_Represenative__r.Next_Month_Monthly_Recurring_Target__c,
                                    Next_Month_Monthly_OTC_Target__c = targetRecord.ICT_Sales_Represenative__r.Next_Month_Monthly_OTC_Target__c,
                                    Next_Month_Weekly_Recurring_Target__c = targetRecord.ICT_Sales_Represenative__r.Next_Month_Weekly_Recurring_Target__c,
                                    Next_Month_Weekly_OTC_Target__c = targetRecord.ICT_Sales_Represenative__r.Next_Month_Weekly_OTC_Target__c);
                    }
                    
                    u.Next_Month_ICT_Monthly_Revenue__c -= target;
                    u.Next_Month_Monthly_Recurring_Target__c -= monthlyRecurring;
                    u.Next_Month_Monthly_OTC_Target__c -= monthlyOTC;
                    u.Next_Month_Weekly_OTC_Target__c -= weeklyOTC;
                    u.Next_Month_Weekly_Recurring_Target__c -= weeklyRecurring;
                    mapUser.put(u.Id, u);
                } else if(monthlyTarget.Target_Month_Date__c!=null && monthlyTarget.Target_Month_Date__c.month() == System.today().addMonths(-1).month()){
                    User u;
                    if(mapUser.containsKey(targetRecord.ICT_Sales_Represenative__c)){
                        u = mapUser.get(targetRecord.ICT_Sales_Represenative__c);
                    }else{
                        u = new User(Id = targetRecord.ICT_Sales_Represenative__c,
                                    Previous_Month_ICT_Monthly_Revenue__c = targetRecord.ICT_Sales_Represenative__r.Previous_Month_ICT_Monthly_Revenue__c,
                                    Previous_Month_Monthly_Recurring_Target__c = targetRecord.ICT_Sales_Represenative__r.Previous_Month_Monthly_Recurring_Target__c,
                                    Previous_Month_Monthly_OTC_Target__c = targetRecord.ICT_Sales_Represenative__r.Previous_Month_Monthly_OTC_Target__c,
                                    Previous_Month_Weekly_Recurring_Target__c = targetRecord.ICT_Sales_Represenative__r.Previous_Month_Weekly_Recurring_Target__c,
                                    Previous_Month_Weekly_OTC_Target__c = targetRecord.ICT_Sales_Represenative__r.Previous_Month_Weekly_OTC_Target__c);
                    }
                    
                    u.Previous_Month_ICT_Monthly_Revenue__c -= target;
                    u.Previous_Month_Monthly_Recurring_Target__c -= monthlyRecurring;
                    u.Previous_Month_Monthly_OTC_Target__c -= monthlyOTC;
                    u.Previous_Month_Weekly_OTC_Target__c -= weeklyOTC;
                    u.Previous_Month_Weekly_Recurring_Target__c -= weeklyRecurring;
                    mapUser.put(u.Id, u);
                }
            }
        }
    }
    if(mapUser.size()>0) update mapUser.values();
}