/**
 * @description       : Retrieve information for Account from Infolegale Webservice.
 * @author            : CLEPILLOUER
 * @last modified on  : 09/02/2023
 * @last modified by  : CLEPILLOUER
**/
global class Infolegale_BAT implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.stateful {

    private Set<Id> setIdAccount;

    public Infolegale_BAT(Set<Id> strParam) {
        setIdAccount = strParam;
    }

    /**
     * Method to retrieve accounts from database if present on the setIdAccount
     * @param bc  BatchableContext object for executing batch job
     * @return query locator for retrieved accounts
     */
    global Database.QueryLocator start(Database.BatchableContext bc) {        
        return Database.getQueryLocator([SELECT Id, INFOLEGALERating__c, Registration_Number__c, Description FROM Account WHERE Id IN :setIdAccount AND Owner.Digicel_Country__c = 'FWI']);            
    }

    /**
     * method to update the INFOLEGALERating__c field on the Account records.
     * @param bc Database.BatchableContext - context of the batch job
     * @param accountsToCheck List<Account> - list of accounts to be updated
     */
    global void execute(Database.BatchableContext bc, List<Account> accountsToCheck){
        List<Account> accToUpdate = new List<Account>();
        for(Account account : accountsToCheck){
            String siren = account.Registration_Number__c;
            HttpResponse resScore = new HttpResponse();
            resScore = InfolegaleWebService.getDataInfolegale(siren);
            Integer code = resScore.getStatusCode();
            Integer score;
            if(code == 200){
                InfolegaleWrapper repBody = InfolegaleWrapper.parse(resScore.getBody());               
                score = repBody.score;
                account.INFOLEGALERating__c = score;
                account.Description = 'Derière synchro:' + + Datetime.now(); 
            } else {
                if(account.Description == ''){
                    account.Description = 'Infolegale_BAT : Error Infologale : Status Code : ' + code;  
                }else {
                    account.Description = account.Description + '; Infolegale_BAT : Error Infologale : Status Code : ' + code; 
                }
                
            }
            accToUpdate.add(account);
        }

        if(accToUpdate.size() > 0){
            AccountTriggerHandler.triggerDisabled = true;
            database.update(accToUpdate);     
            AccountTriggerHandler.triggerDisabled = false;
        }
    }

    /**
     * End of the Batch class
     * @param bc Database.BatchableContext
     * @return none
     */
    global void finish(Database.BatchableContext bc){
        system.debug('Infolegale_BAT ------- FINISH -------------');      
    }    

}