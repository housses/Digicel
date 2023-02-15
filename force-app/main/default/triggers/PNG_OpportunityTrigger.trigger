trigger PNG_OpportunityTrigger on Opportunity (after update) {
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            PNG_OpportunityTriggerHelper.createAssetRecords(Trigger.newMap, Trigger.oldMap);
        }
    }
}