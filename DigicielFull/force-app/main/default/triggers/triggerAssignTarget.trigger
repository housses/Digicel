trigger triggerAssignTarget on Opportunity (before insert, before update) {
    List<Id> ownerIds = new List<Id>();
    List<Date> queryDates = new List<Date>();
    List<Date> endDates = new List<Date>();
    
    for(Opportunity o: trigger.new){
        ownerIds.add(o.OwnerId);
        if(o.CloseDate != null){
            for(Integer i=o.CloseDate.toStartOfMonth().day(); i<= Date.daysInMonth(o.CloseDate.year(), o.CloseDate.month()); i++){
                queryDates.add(Date.newInstance(o.CloseDate.year(), o.CloseDate.month(), i));
            }
        }
    }
    
    Map<Id, Map<Date, Monthly_ICT_GSM_Targets__c>> mapMonthlyTargets = new Map<Id, Map<Date, Monthly_ICT_GSM_Targets__c>>();
    List<Monthly_ICT_GSM_Targets__c> listMonthlyTargers = [SELECT Id, Target_Month_Date__c, 
            ICT_User_Target_Records__r.ICT_Sales_Represenative__c
            FROM Monthly_ICT_GSM_Targets__c 
            WHERE ICT_User_Target_Records__r.ICT_Sales_Represenative__c IN: ownerIds
            AND Target_Month_Date__c IN :queryDates];
    
    for(Monthly_ICT_GSM_Targets__c monthlyTarget: listMonthlyTargers){
        Map<Date, Monthly_ICT_GSM_Targets__c> mapTargetByDate = new Map<Date, Monthly_ICT_GSM_Targets__c>();
        if(mapMonthlyTargets.containsKey(monthlyTarget.ICT_User_Target_Records__r.ICT_Sales_Represenative__c)){
            mapTargetByDate = mapMonthlyTargets.get(monthlyTarget.ICT_User_Target_Records__r.ICT_Sales_Represenative__c);
        }
        mapTargetByDate.put(monthlyTarget.Target_Month_Date__c, monthlyTarget);
        mapMonthlyTargets.put(monthlyTarget.ICT_User_Target_Records__r.ICT_Sales_Represenative__c, mapTargetByDate);
    } 
    
    for(Opportunity o: trigger.new){
        o.Monthly_Target__c = null;
        if(mapMonthlyTargets.containsKey(o.OwnerId)){
            Monthly_ICT_GSM_Targets__c monthlyTarget;
            Map<Date, Monthly_ICT_GSM_Targets__c> mapTargetByDate = mapMonthlyTargets.get(o.OwnerId);
            for(Integer i=o.CloseDate.toStartOfMonth().day(); i<= Date.daysInMonth(o.CloseDate.year(), o.CloseDate.month()); i++){
                if(mapTargetByDate.containsKey(Date.newInstance(o.CloseDate.year(), o.CloseDate.month(), i))){
                    monthlyTarget = mapTargetByDate.get(Date.newInstance(o.CloseDate.year(), o.CloseDate.month(), i));
                }
            }
            if(monthlyTarget!=null && monthlyTarget.Id != null){
                o.Monthly_Target__c = monthlyTarget.Id;
            }
        }
    }
}