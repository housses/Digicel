/**
 * @description       : Retrieve information for Account from Telesoft Webservice.
 * @author            : CLEPILLOUER
 * @last modified on  : 09/02/2023
 * @last modified by  : CLEPILLOUER
**/
global class ClientTelesoft_BAT implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.stateful {
    
    public class ServerException extends Exception {}

    private List<ClientTelesoftWrapper> repBody;
    

    /**
     * This method calls Telesoft Webservice and returns all the clients of their database, then query Salesforce Database to match and get the associated Accounts
     * @param bc Database.BatchableContext the start date of the range
     * @return Database.QueryLocator SOQL query that retrieves records from the Account where the Registration_Number__c field is in the setIdAccount set and the Owner.Digicel_Country__c field is equal to 'FWI'.
     */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        HttpResponse resAccounts = new HttpResponse();
        Set<String> setIdAccount = new Set<String>();

        if(TelesoftWebService.getAllAccounts().getStatusCode() == 200){
            resAccounts = TelesoftWebService.getAllAccounts();
            repBody = ClientTelesoftWrapper.parse(resAccounts.getBody());
        } else {
            throw new ServerException('ClientTelesoft_BAT ------- Exception Server : Status code : ' + TelesoftWebService.getAllAccounts().getStatusCode() );
        }
      
        if(repBody.size() > 0){
            for(ClientTelesoftWrapper client : repBody){
                if (client.cus_sir_ren != null && client.cus_sir_ren != '') {
                    setIdAccount.add(client.cus_sir_ren);
                }
            }
        }
        return Database.getQueryLocator([SELECT Id, Name, TelesoftNumber__c , Registration_Number__c FROM Account WHERE Registration_Number__c IN :setIdAccount AND Owner.Digicel_Country__c = 'FWI']);            
    }

    /**
     * This method takes in a list of accounts and updates their TelesoftNumber__c field with information obtained from the Telesoft Web Service.
     * @param Database.BatchableContext
     * @param accountsToCheck List<Account> - A list of accounts to update with information from the Telesoft Web Service.
     * @return none
     */
    global void execute(Database.BatchableContext bc, List<Account> accountsToCheck){
        
        List<Account> accountToUpdate = new List<Account>();

        Map<string,List<Account>> mapSirenLstAccounts = new Map<string,List<Account>>();
        for(Account acc : accountsToCheck){
            if(!mapSirenLstAccounts.containsKey(acc.Registration_Number__c)){
                mapSirenLstAccounts.put(acc.Registration_Number__c, new List<Account>());
            }
            mapSirenLstAccounts.get(acc.Registration_Number__c).add(acc);
        }

        Map<string, Set<string>> clientIdsByAccountId = new Map<string, Set<string>>();
        for(ClientTelesoftWrapper client : repBody){
            if (!clientIdsByAccountId.containsKey(client.cus_sir_ren)) {
                clientIdsByAccountId.put(client.cus_sir_ren, new Set<string>());
            }
            clientIdsByAccountId.get(client.cus_sir_ren).add(client.cus_cpt);
        }

        Map<String, Account> toSave = new Map<String, Account>();
        for(String siren : clientIdsByAccountId.keySet()){
            Set<String> numClients = clientIdsByAccountId.get(siren);
            if(mapSirenLstAccounts.containsKey(siren)){
                List<Account> listAccount = mapSirenLstAccounts.get(siren);
                for(Account account : listAccount){
                    if(numClients.size() == 1){
                        account.TelesoftNumber__c = (new List<string>(numClients)).get(0);
                    }
                    else if(numClients.size() > 1){
                        account.TelesoftNumber__c = String.join((Iterable<String>)(numClients), ';');
                    }
                    accountToUpdate.add(account);
                }
            }
        }
        if(accountToUpdate.size() > 0){
            try {
                AccountTriggerHandler.triggerDisabled = true;
                database.upsert(accountToUpdate);            
                AccountTriggerHandler.triggerDisabled = false;
            } catch(DmlException e) {
                throw new ServerException('ClientTelesoft_BAT ------- Exception on upsert Telesoft Accounts : ' + e.getMessage());
            }  
        }     
    }

    /**
     * End of the Batch class
     * @param bc atabase.BatchableContext
     * @return none
     */
    global void finish(Database.BatchableContext bc){      
        system.debug('ClientTelesoft_BAT ------- FINISH -------------');         
    }    

}