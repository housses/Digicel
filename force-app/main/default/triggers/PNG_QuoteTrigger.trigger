trigger PNG_QuoteTrigger on Quote (after update) {
	if(Trigger.isAfter){
        if(Trigger.isUpdate){
            PNG_QuoteTriggerHelper.createContractRecord(Trigger.newMap, Trigger.oldMap);
        }
    }
}