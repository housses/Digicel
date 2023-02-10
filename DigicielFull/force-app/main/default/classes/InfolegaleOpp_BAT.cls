/**
 * @description       : Retrieve information for Opportuntiy from Infolegale Webservice.
 * @author            : CLEPILLOUER
 * @last modified on  : 09/02/2023
 * @last modified by  : CLEPILLOUER
**/
global class InfolegaleOpp_BAT implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.stateful {

    private Set<Id> setIdOpp;

    public InfolegaleOpp_BAT(Set<Id> strParam) {
        setIdOpp = strParam;
    }

    /**
     * Method to retrieve opportunties from database if present on the setIdOpp
     * @param bc  BatchableContext object for executing batch job
     * @return query locator for retrieved opportunties
     */
    global Database.QueryLocator start(Database.BatchableContext bc) {    
        return Database.getQueryLocator([SELECT Id, INFOLEGALERating__c, Score_INFOLEGALE__c, AccountId, StageName, Account.Owner.Digicel_Country__c FROM Opportunity WHERE Id IN :setIdOpp AND Account.Owner.Digicel_Country__c = 'FWI' ]);            
    }

    /**
     * method to update the INFOLEGALERating__c and Score_INFOLEGALE__c field on the Opportunity records.
     * @param bc Database.BatchableContext - context of the batch job
     * @param listOpps List<Opportunity> - list of opportunties to be updated
     */
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

                        // à modifier avec champs formule => voir si on peut directement travailler avec un set accIds et mettre a jour que l'acc et modifier les champs sur opp pour les passer en champs formule.
                        opp.INFOLEGALERating__c = score;
                        opp.Score_INFOLEGALE__c = score;
                        listOppToUpdate.add(opp);
                        // à modifier

                        if(acc.INFOLEGALERating__c != score){
                            acc.INFOLEGALERating__c = score;
                            accToUpdate.add(acc);
                        }

                    } else {
                        throw new MyException('InfolegaleOpp_BAT => Error');
                    }
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
    
    /**
     * End of the Batch class and Enabled the Account and opportunity trigger
     * @param bc Database.BatchableContext
     * @return none
     */
    global void finish(Database.BatchableContext bc){   
        AccountTriggerHandler.triggerDisabled = false;
        OpportunityTriggerHandler.triggerDisabled = false;
        system.debug('InfolegaleOpp_BAT ------- FINISH -------------');      
    }    

}