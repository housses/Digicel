public without sharing class PNG_CaseTriggerHelper {
    /**
     * This method will search for all level one child cases for the
     * current parent and mark the status closed and also update the Root Cause
     */
    public static void closeAllLevelOneChildCases(List<Case> newCases, Map<Id, Case> oldCases){
        Boolean stopTrigger = Boolean.valueOf(Label.PNG_StopCaseManagementTrigger);        
        try{
            if(!stopTrigger){
                List<Case> childCasesToUpdate = new List<Case>();        
                Set<Id> setParentClosedCases = getAllClosedCasesInCurrentContext(newCases, oldCases);
                
                if(!setParentClosedCases.isEmpty()){
                    for(Case childCase : [SELECT Id, Status, Parent.Id, Parent.Status, Parent.PNG_RootCause__c FROM Case WHERE Parent.Id IN :setParentClosedCases]){
                        childCase.Status = childCase.Parent.status;
                        childCase.PNG_RootCause__c = childCase.Parent.PNG_RootCause__c;
                        childCasesToUpdate.add(childCase);
                    }
                }
                if(childCasesToUpdate.size()>0){
                    update childCasesToUpdate;
                }
            }
        }catch(Exception ex){
            System.debug('DildarLog: Exception @closeAllLevelOneChildCases - '+ex.getMessage());
        }
    }
    
    private static Set<Id> getAllClosedCasesInCurrentContext(List<Case> newCases, Map<Id, Case> oldCases){
        Set<Id> setProcessedParentClosedCases = new Set<Id>();
        for(Case parentCaseRec:newCases) {
                if(parentCaseRec.status != oldCases.get(parentCaseRec.id).status &&
                   parentCaseRec.IsClosed &&
                   parentCaseRec.RecordTypeId == Label.PNG_CaseSupportRecordType){
                   
                       setProcessedParentClosedCases.add(parentCaseRec.Id);
			}
		}
        return setProcessedParentClosedCases;
    }
    public static void selectEntitlementForSupportCase(List<Case> newCases){
        
        List<Case> casesToUpdate =  new List<Case>();
        Set<id> accountsOfCases = new Set<id>();
        for(Case c : newCases){
            if(c.AccountId != null){
            	accountsOfCases.add(c.AccountId);
            }
        }
        Map<Id, Account> accountsWithEntitlements = new Map<Id, Account>([Select id, PNG_EntitlementLevel__c,
                                                                    (select id, StartDate, EndDate, PNG_EntitlementType__c from Entitlements Where Status='Active' 
                                                                     Order By createdDate desc)
                                                                    from Account where Id IN: accountsOfCases]);
        
        for(Case cas : newCases){
            if(cas.AccountId != null && accountsWithEntitlements != null && accountsWithEntitlements.containsKey(cas.AccountId)){
                Account acc = accountsWithEntitlements.get(cas.AccountId);
                if(acc.Entitlements != null && acc.Entitlements.size()>0){
                    cas.EntitlementId = null;
                    for(Entitlement ent : acc.Entitlements){
                       if((cas.PNG_CaseType__c == 'ICT' || cas.PNG_CaseType__c == 'ICT & GSM') && ent.PNG_EntitlementType__c =='Connectivity & Enterprise Services'){
                            cas.EntitlementId = ent.id;
                        }else if(cas.PNG_CaseType__c == 'GSM' && ent.PNG_EntitlementType__c =='Mobile Services'){
                            cas.EntitlementId = ent.id;
                        }
                        casesToUpdate.add(cas);
                    }
                }
            }
        }
        
    }
}