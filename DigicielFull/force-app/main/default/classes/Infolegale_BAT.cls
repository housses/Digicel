/**
 * @description       : 
 * @author            : JBBARTHELEMY
 * @group             : 
 * @last modified on  : 08/11/2022
 * @last modified by  : JBBARTHELEMY
**/
global class Infolegale_BAT implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.stateful {

    private Set<Id> setIdAccount;

    public Infolegale_BAT(Set<Id> strParam) {
        setIdAccount = strParam;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {  
        // return Database.getQueryLocator([SELECT Id, INFOLEGALERating__c, Registration_Number__c FROM Account WHERE Id IN :setIdAccount]);            
        return Database.getQueryLocator([SELECT Id, INFOLEGALERating__c, Registration_Number__c FROM Account WHERE Id IN :setIdAccount AND Owner.Digicel_Country__c = 'FWI']);            
    }

    global void execute(Database.BatchableContext bc, List<Account> accountsToUpdate){
        for(Account account : accountsToUpdate){
            String siren = account.Registration_Number__c;
            HttpResponse resScore = new HttpResponse();
            resScore = InfolegaleWebService.getDataInfolegale(siren);
            Integer code = resScore.getStatusCode();
            Integer score;
            if(code == 200){
                InfolegaleWrapper repBody = InfolegaleWrapper.parse(resScore.getBody());               
                score = repBody.score;
            } else {
                score = null;
            }
            account.INFOLEGALERating__c = score;
        }
        AccountTriggerHandler.triggerDisabled = true;
        database.update(accountsToUpdate);     
        AccountTriggerHandler.triggerDisabled = false;
    }

    global void finish(Database.BatchableContext bc){}    

}