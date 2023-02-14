/**
 * @description       : CLASS PLUS UTILISEE Retrieve information for Opportuntiy from Infolegale Webservice.
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
        return Database.getQueryLocator([SELECT Id, AccountId, StageName, Account.Owner.Digicel_Country__c FROM Opportunity WHERE Id IN :setIdOpp AND Account.Owner.Digicel_Country__c = 'FWI' ]);            
    }

    /**
     * method to update the Score_INFOLEGALE__c field on the Opportunity records.
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
        List<Account> listAcc = [SELECT Id, INFOLEGALERating__c, Registration_Number__c,Description FROM Account WHERE Id IN :setIdAccount];


        if(listOpps.size() > 0 && listAcc.size()>0){
            for(Account acc : listAcc){
                if(acc.Registration_Number__c != null){
                    HttpResponse resScore = new HttpResponse();
                    resScore = InfolegaleWebService.getDataInfolegale(acc.Registration_Number__c);
                    Integer code = resScore.getStatusCode();
                    Integer score;
                    if(code == 200){
                        InfolegaleWrapper repBody = InfolegaleWrapper.parse(resScore.getBody());
                        score = repBody.score;
                        acc.INFOLEGALERating__c = score;
                        acc.Description = 'Derière synchro:'  + Datetime.now(); 
                    } else {
                        if(acc.Description == ''){
                            acc.Description = 'Erreur lors de l\'appel à infogreffe le ' + Datetime.now() + ' : ' + resScore.getBody(); 
                        }else {
                            acc.Description = acc.Description + '; Erreur lors de l\'appel à infogreffe le ' + Datetime.now() + ' : ' + resScore.getBody(); 
                        }
                    }
                    accToUpdate.add(acc);
                }  
            }

            if(accToUpdate.size() > 0){
                AccountTriggerHandler.triggerDisabled = true;
                database.update(accToUpdate);   
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