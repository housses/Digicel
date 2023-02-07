global class classVerifyMonthlyTargetsFiscalYear implements Schedulable{
	global void execute(SchedulableContext SC) {
		List<Monthly_ICT_GSM_Targets__c> listMonthlyTargets = [SELECT Id, Target_Month_Date__c,
												Is_Current_Fiscal_Year__c
												FROM Monthly_ICT_GSM_Targets__c
												WHERE (Target_Month_Date__c = THIS_FISCAL_YEAR
												AND Is_Current_Fiscal_Year__c = false)
												OR (Target_Month_Date__c != THIS_FISCAL_YEAR
												AND Is_Current_Fiscal_Year__c = true)];
		
		for(Monthly_ICT_GSM_Targets__c monthlyTarget: listMonthlyTargets){
			monthlyTarget.Is_Current_Fiscal_Year__c = !monthlyTarget.Is_Current_Fiscal_Year__c;
		}
		
		update listMonthlyTargets;
	}
}