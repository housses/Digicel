/**
 * @description       : 
 * @author            : JBBARTHELEMY
 * @group             : 
 * @last modified on  : 08/11/2022
 * @last modified by  : JBBARTHELEMY
**/
public with sharing class Opportunity_SVE {

	public static void callInfoLegalApi(Map<Id,Opportunity> newItems, Map<Id,Opportunity> oldItems){
        Set<Id> setIdOpp = new Set<Id>();
        for(Opportunity opp : newItems.values()){
            if (oldItems == null || (opp.StageName == 'Commercial Review' && oldItems.get(opp.Id).StageName != opp.StageName)){
                setIdOpp.add(opp.Id);
            }
        }
        if(setIdOpp.size() > 0){
            Database.executeBatch(new InfolegaleOpp_BAT(setIdOpp), 1);
        }
	} 
}