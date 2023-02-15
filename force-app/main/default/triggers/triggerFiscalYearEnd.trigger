trigger triggerFiscalYearEnd on Opportunity (before insert, before update) {
    FiscalYearSettings fiscalYear = [SELECT EndDate FROM FiscalYearSettings WHERE EndDate = THIS_YEAR limit 1];
    
    for(Opportunity opp: Trigger.new){
        if(opp.CloseDate != null){
            if(opp.CloseDate.month() > fiscalYear.EndDate.month()){
                opp.Fiscal_Year_End__c = Date.newInstance(opp.CloseDate.year()+1, fiscalYear.EndDate.month(), fiscalYear.EndDate.day());
            }else{
                opp.Fiscal_Year_End__c = Date.newInstance(opp.CloseDate.year(), fiscalYear.EndDate.month(), fiscalYear.EndDate.day());
            }
        }
    }
}