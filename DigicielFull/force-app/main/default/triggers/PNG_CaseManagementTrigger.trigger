trigger PNG_CaseManagementTrigger on Case (after update,before update, before insert) {
    if(Trigger.isUpdate && Trigger.isAfter){
        PNG_CaseTriggerHelper.closeAllLevelOneChildCases(Trigger.new, Trigger.oldMap);
    }
    if(Trigger.isBefore && Trigger.isInsert){
        List<Case> updatedCase = new List<Case>();
        for(Case c : Trigger.new){
            if(c.RecordTypeId == Label.PNG_CaseSupportRecordType){
                updatedCase.add(c);
            }
        }
        PNG_CaseTriggerHelper.selectEntitlementForSupportCase(updatedCase);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
         List<Case> updatedCase = new List<Case>();
        for(Case c : Trigger.new){
            if(c.RecordTypeId == Label.PNG_CaseSupportRecordType && 
               (c.AccountId != Trigger.oldMap.get(c.id).AccountId || c.PNG_CaseType__c != Trigger.oldMap.get(c.id).PNG_CaseType__c)){
                updatedCase.add(c);
            }
        }
        PNG_CaseTriggerHelper.selectEntitlementForSupportCase(updatedCase);
    }
}