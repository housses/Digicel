/**
 * @description       : 
 * @author            : JBBARTHELEMY
 * @group             : 
 * @last modified on  : 08/11/2022
 * @last modified by  : JBBARTHELEMY
**/
public class AccountTriggerHandler implements ITriggerHandler {
    
    public static Boolean triggerDisabled = false;
    
    public Boolean isDisabled() {
        return triggerDisabled;
    }

    public void beforeInsert(List<SObject> newItems) {}

    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        Account_SVE.invokeInfoLegalBat((Map<Id, Account>)newItems, (Map<Id, Account>)oldItems);   
    }
    
    public void beforeDelete(Map<Id, SObject> oldItems) {}
    
    public void afterInsert(Map<Id, SObject> newItems) {
        Account_SVE.invokeInfoLegalBat((Map<Id, Account>)newItems, null);   
    }
    
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        Account_SVE.resetExternalIdAndDeleteInvoice((Map<Id, Account>)newItems, (Map<Id, Account>)oldItems);
    }
    
    public void afterDelete(Map<Id, SObject> oldItems) {}
    
    public void afterUndelete(Map<Id, SObject> oldItems) {}
   
    public String getTriggerName() {
        return 'AccountTrigger';
    }
}