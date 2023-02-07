trigger PNG_ContractTrigger on Contract (after insert, after update) {
       
    List<Contract> updatedContracts = new List<contract>();
    for(Contract con : Trigger.New){
        if(Trigger.isInsert){
            if(con.RecordTypeId == Label.PNG_ContractRecordTypeId && con.Status=='PNG_Contract mutually signed'){
               updatedContracts.add(con);
            }
        }else if(Trigger.isUpdate){
            Contract oldCon = Trigger.oldMap.get(con.Id);
            if(con.RecordTypeId == Label.PNG_ContractRecordTypeId && oldCon.status !='PNG_Contract mutually signed' 
               && con.Status=='PNG_Contract mutually signed'){
               updatedContracts.add(con); 
            }
        }
    }
    if(updatedContracts != null && updatedContracts.size()>0){
    	PNG_contractTriggerHelper.createEntitlement(updatedContracts);
    }
}