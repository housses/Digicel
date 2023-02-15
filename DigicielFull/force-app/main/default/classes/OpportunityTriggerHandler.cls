/**
 * @description       : 
 * @author            : JBBARTHELEMY
 * @group             : 
 * @last modified on  : 08/11/2022
 * @last modified by  : JBBARTHELEMY
**/
public with sharing class OpportunityTriggerHandler implements ITriggerHandler {
    
    public static Boolean triggerDisabled = false;
    
    public Boolean isDisabled() {
        return triggerDisabled;
    }

    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}
    
    public void afterInsert(Map<Id, SObject> newItems) {
        Opportunity_SVE.callInfoLegalApi((Map<Id,Opportunity>)newItems, null);
    }
    
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        System.debug('Opp afterUpdate');
        Opportunity_SVE.callInfoLegalApi((Map<Id,Opportunity>)newItems, (Map<Id,Opportunity>)oldItems);
    }
    
    public void afterDelete(Map<Id, SObject> oldItems) {}
    
    public void afterUndelete(Map<Id, SObject> oldItems) {}

    public void beforeInsert(List<SObject> newItems) {}
   
    public void beforeDelete(Map<Id, SObject> oldItems) {}
    
    public String getTriggerName() {
        return 'OpportunityTrigger';
    }
}