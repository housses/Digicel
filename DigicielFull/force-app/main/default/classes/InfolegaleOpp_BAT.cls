/**
 * @description       : 
 * @author            : JBBARTHELEMY
 * @group             : 
 * @last modified on  : 08/11/2022
 * @last modified by  : JBBARTHELEMY
**/
global class InfolegaleOpp_BAT implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.stateful {

    private Set<Id> setIdOpp;

    public InfolegaleOpp_BAT(Set<Id> strParam) {
        setIdOpp = strParam;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {    
        return Database.getQueryLocator([SELECT Id, INFOLEGALERating__c, Score_INFOLEGALE__c, AccountId, StageName, Account.Owner.Digicel_Country__c FROM Opportunity WHERE Id IN :setIdOpp AND Account.Owner.Digicel_Country__c = 'FWI' ]);            
    }

    global void execute(Database.BatchableContext bc, List<Opportunity> listOpps){
        List<Opportunity> listOppToUpdate = new List<Opportunity>();
        List<Account> accToUpdate = new List<Account>();
        Set<Id> setIdAccount = new Set<Id>();
        for(Opportunity opp : listOpps){
            setIdAccount.add(opp.AccountId);
        }
        Map<Id,Account> mapAcc = new Map<Id,Account>([SELECT Id, INFOLEGALERating__c, Registration_Number__c FROM Account WHERE Id IN :setIdAccount]);


        if(listOpps.size() > 0 && mapAcc.size()>0){
            for(Opportunity opp : listOpps){
                Account acc = mapAcc.get(opp.AccountId);
                if(acc.Registration_Number__c != null){
                    HttpResponse resScore = new HttpResponse();
                    resScore = InfolegaleWebService.getDataInfolegale(acc.Registration_Number__c);
                    Integer code = resScore.getStatusCode();
                    Integer score;
                    if(code == 200){
                        InfolegaleWrapper repBody = InfolegaleWrapper.parse(resScore.getBody());
                        score = repBody.score;
                    } else {
                        score = null;
                    }
                    opp.INFOLEGALERating__c = score;
                    opp.Score_INFOLEGALE__c = score;
                    acc.INFOLEGALERating__c = score;
                    accToUpdate.add(acc);
                    listOppToUpdate.add(opp);
                }  
            }

            if(accToUpdate.size() > 0){
                AccountTriggerHandler.triggerDisabled = true;
                database.update(accToUpdate);   
            }
            if(listOppToUpdate.size() > 0){
                OpportunityTriggerHandler.triggerDisabled = true;
                database.update(listOppToUpdate);     
            }
        }
    }
    
    global void finish(Database.BatchableContext bc){   
        AccountTriggerHandler.triggerDisabled = false;
        OpportunityTriggerHandler.triggerDisabled = false;
        system.debug('Traitement Batch terminé');
    }    

}