/**
 * @description       : 
 * @author            : JBBARTHELEMY
 * @group             : 
 * @last modified on  : 08/11/2022
 * @last modified by  : JBBARTHELEMY
**/
global class ClientTelesoft_BAT implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.stateful {

    private List<ClientTelesoftWrapper> repBody;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        HttpResponse resAccounts = new HttpResponse();
        resAccounts = TelesoftWebService.getAllAccounts();
        repBody = ClientTelesoftWrapper.parse(resAccounts.getBody());
        Set<String> setIdAccount = new Set<String>();
        for(ClientTelesoftWrapper client : repBody){
            if (client.cus_sir_ren != null && client.cus_sir_ren != '') {
                setIdAccount.add(client.cus_sir_ren);
            }
        }
        return Database.getQueryLocator([SELECT Id, Name, TelesoftNumber__c , Registration_Number__c FROM Account WHERE Registration_Number__c IN :setIdAccount AND Owner.Digicel_Country__c = 'FWI']);            
    }

    global void execute(Database.BatchableContext bc, List<Account> accountsToCheck){
        
        List<Account> accountToUpdate = new List<Account>();

        Map<string,List<Account>> mapSirenLstAccounts = new Map<string,List<Account>>();
        for(Account acc : accountsToCheck){
            if(!mapSirenLstAccounts.containsKey(acc.Registration_Number__c)){
                mapSirenLstAccounts.put(acc.Registration_Number__c, new List<Account>());
            }
            mapSirenLstAccounts.get(acc.Registration_Number__c).add(acc);
        }

        Map<string, Set<string>> client_ids_by_account_id = new Map<string, Set<string>>();
        for(ClientTelesoftWrapper client : repBody){
            if (!client_ids_by_account_id.containsKey(client.cus_sir_ren)) {
                client_ids_by_account_id.put(client.cus_sir_ren, new Set<string>());
            }
            client_ids_by_account_id.get(client.cus_sir_ren).add(client.cus_cpt);
        }

        Map<String, Account> toSave = new Map<String, Account>();
        for(String siren : client_ids_by_account_id.keySet()){
            Set<String> numClients = client_ids_by_account_id.get(siren);
            List<String> numeroClients = new list<string>(numClients);
            if(mapSirenLstAccounts.containsKey(siren)){
                List<Account> listAccount = mapSirenLstAccounts.get(siren);
                for(Account account : listAccount){
                    if(numeroClients.size() == 1){
                        account.TelesoftNumber__c = numeroClients[0];
                    } 
                    else if(numeroClients.size() > 1){
                        account.TelesoftNumber__c = String.join(numeroClients, ';');
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
                System.debug('Exception sur l\'upsert des accounts Telesoft: ' + e.getMessage());
            }  
        }     
    }

    global void finish(Database.BatchableContext bc){      
        system.debug('END-------------');         
    }    

}