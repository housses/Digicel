/**
 * @description       : Batch who call Kaldom get Invoice and upsert all invoice générate this year.
 * @author            : CLEPILLOUER
 * @last modified on  : 10/02/2023
 * @last modified by  : HBOUZINE
**/
global class InvoiceKaldom_BAT implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.stateful {
    public class applicationException extends Exception {}
    public Integer firstNumber;
    public Integer secondNumber;
    private FactureKaldomWrapper repBody;
    private Map<String, List<FactureKaldomWrapper.factures>> mapSirenFactures = new Map<String, List<FactureKaldomWrapper.factures>>();

    public InvoiceKaldom_BAT(Integer firstParam, Integer secondParam) {
        firstNumber = firstParam;
        secondNumber = secondParam;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {    
        DateTime startDate = System.today().addDays(-firstNumber);
        DateTime endDate = System.today().addDays(-secondNumber);
        String startDateStr = startDate.format('yyyy-MM-dd');
        String endDateStr = endDate.format('yyyy-MM-dd');
        Set<String> setAccount = new Set<String>();
        HttpResponse resFacture = new HttpResponse();
        resFacture = KaldomWebService.getFactureByDate(endDateStr,startDateStr);    
        repBody = FactureKaldomWrapper.parse(resFacture.getBody());
        if(repBody.code == 200){
            if(repBody.response.factures.size() > 0){
                for(FactureKaldomWrapper.factures fac : repBody.response.factures){
                    setAccount.add(fac.siren);
                    if(!mapSirenFactures.containsKey(fac.siren)){
                        mapSirenFactures.put(fac.siren, new List<FactureKaldomWrapper.factures>());
                    }
                    mapSirenFactures.get(fac.siren).add(fac);
                }
            }
        }
        else {
            throw new applicationException('InvoiceKaldom_BAT: Error retrive invoice from Kaldom. StatusCode:' + resFacture.getStatusCode() + '; ' + resFacture.getBody());
        }
        return Database.getQueryLocator([SELECT Id, Name, NKaldom__c, Registration_Number__c FROM Account WHERE Registration_Number__c IN :setAccount AND Owner.Digicel_Country__c = 'FWI']);            
    }

    global void execute(Database.BatchableContext bc, List<Account> accountsKaldom){
        List<Invoice__c> lstInvoiceToUpsert = new List<Invoice__c>();
        Set<String> setExternalId = new Set<String>();
        List<Account> lstAccount = new List<Account>();
        if(accountsKaldom.size() > 0){
            for(Account acc : accountsKaldom){
                if(mapSirenFactures.containsKey(acc.Registration_Number__c)){
                    for(FactureKaldomWrapper.factures fac : mapSirenFactures.get(acc.Registration_Number__c)){
                            lstAccount.add(new Account(
                                Id = acc.Id,
                                NKaldom__c = fac.client_id
                            ));
                            Invoice__c inv = new Invoice__c();
                            inv.InvoiceDate__c = fac.date_creation != '' ? Date.valueOf(fac.date_creation) : null;
                            inv.AccountName__c =  acc.Id;   
                            inv.ClientNumber__c = fac.client_id;
                            inv.InvoiceID__c = fac.facture_id + '/' + acc.Id;
                            inv.Invoice_Number__c= fac.numero_facture;
                            inv.Amount__c = fac.montant_ht != null ? decimal.valueOf(fac.montant_ht) : null;
                            inv.TVA__c = fac.montant_tva != null ? decimal.valueOf(fac.montant_tva) : null; 
                            inv.AmountTTC__c = fac.montant_ttc != null ? decimal.valueOf(fac.montant_ttc) : null;
                            inv.DueDate__c = fac.date_echeance != null ? Date.valueOf(fac.date_echeance) : null;
                            inv.PaymentOptions__c = fac.mode_de_paiement;
                            inv.CurrencyIsoCode = fac.devise;
                            inv.Source__c = 'Kaldom';

                            if(inv.InvoiceDate__c > Date.today().addYears(-1)){
                                inv.TechMoreOlderThen12Months__c = true;
                            } else {
                                inv.TechMoreOlderThen12Months__c = false;
                            }
                            //chek if lstInvoiceToUpdate already contain invoice with same externalId
                            if(!setExternalId.contains(inv.InvoiceID__c)){
                                setExternalId.add(inv.InvoiceID__c);
                                lstInvoiceToUpsert.add(inv);
                            }  
                    }
                }
            }
        }
        Map<Id,Set<String>> mapClientAccount = new Map<Id,Set<String>> ();
        for(Account acc : lstAccount){
            if(!mapClientAccount.containsKey(acc.Id)){
                mapClientAccount.put(acc.Id,new Set<String>()); 
            }
            mapClientAccount.get(acc.Id).add(acc.NKaldom__c);
        }

        List<Account> lstAccountToUpsert = new List<Account>();
        for (Id key : mapClientAccount.keySet()) {
            List<String> listClientIds = new list<string>(mapClientAccount.get(key));
            Account account = new Account();
            account.Id = key;
            if(listClientIds.size() == 1){
                account.NKaldom__c = listClientIds[0];
            } else if(listClientIds.size() > 1){
                account.NKaldom__c = String.join(listClientIds, ';');
            }
            lstAccountToUpsert.add(account);
        }


        if(lstInvoiceToUpsert.size() > 0){
            try {
                database.upsert(lstInvoiceToUpsert, Invoice__c.InvoiceID__c, true );      
            } catch(DmlException e) {
                throw new applicationException('InvoiceKaldom_bat: Error upsert invoice: ' + e.getMessage());
            }  
        }  

        if(lstAccountToUpsert.size() > 0){
            try {
                AccountTriggerHandler.triggerDisabled = true;
                database.update(lstAccountToUpsert);  
                AccountTriggerHandler.triggerDisabled = false;
            } catch(DmlException e) {
                throw new applicationException('InvoiceKaldom_bat: Error update account: ' + e.getMessage());
            }  
        }  
       
    }  

    //call again the batch with increment stardate and endDate stop recursivity when we exeded one year
    global void finish(Database.BatchableContext bc){
           if(firstNumber < 365){
            firstNumber += 7;
            secondNumber += 7;
            Id batchJobId = Database.executebatch(new InvoiceKaldom_BAT(firstNumber,secondNumber), 100);   
        }
    }    
}