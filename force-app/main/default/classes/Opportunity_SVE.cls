public with sharing class Opportunity_SVE {

    /**
    * Description : This method call the class Infolegale_BAT 
    * if insert Opportunity or Update Opportuntiy and StageName = 'Commercial Rebview'
    * @param newItems  Map<Id,Opportunity> 
    * @param oldItems  Map<Id,Opportunity>
    */
	public static void callInfoLegalApi(Map<Id,Opportunity> newItems, Map<Id,Opportunity> oldItems){
        Set<Id> setIdOpp = new Set<Id>();
        Set<Id> setIdAcc = new Set<Id>();

        for(Opportunity opp : newItems.values()){
            if (oldItems == null || (opp.StageName == 'Commercial Review' && oldItems.get(opp.Id).StageName != opp.StageName)){
                setIdOpp.add(opp.Id);
            }
        }

        for(Opportunity oppy : [SELECT Id, AccountId from Opportunity WHERE Id in: setIdOpp]) {
            setIdAcc.add(oppy.AccountId);
        }

        if(setIdAcc.size() > 0){
            Database.executeBatch(new Infolegale_BAT(setIdAcc), 1);
        }
	} 
}