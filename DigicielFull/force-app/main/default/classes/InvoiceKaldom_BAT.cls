/**
 * @description       : 
 * @author            : JBBARTHELEMY
 * @group             : 
 * @last modified on  : 08/11/2022
 * @last modified by  : JBBARTHELEMY
**/
global class InvoiceKaldom_BAT implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.stateful {

    public Integer firstNumber;
    public Integer secondNumber;
    private FactureKaldomWrapper repBody;
    private Map<String, List<FactureKaldomWrapper.factures>> mapSirenFactures = new Map<String, List<FactureKaldomWrapper.factures>>();

    public InvoiceKaldom_BAT(Integer firstParam, Integer secondParam) {
        firstNumber = firstParam;
        secondNumber = secondParam;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {    
        DateTime todaysDate = System.today().addDays(-firstNumber);
        DateTime lastMonthDate = System.today().addDays(-secondNumber);
        String todaysDateStr = todaysDate.format('yyyy-MM-dd');
        String lstMonthDateStr = lastMonthDate.format('yyyy-MM-dd');
        Set<String> setAccount = new Set<String>();
        HttpResponse resFacture = new HttpResponse();
        resFacture = KaldomWebService.getFactureByDate(lstMonthDateStr,todaysDateStr);    
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
        else if(repBody.code == 404){
            system.debug('PAS DE CLIENT AVEC CE SIREN TROUVE');
        }
        return Database.getQueryLocator([SELECT Id, Name, NKaldom__c, Registration_Number__c FROM Account WHERE Registration_Number__c IN :setAccount AND Owner.Digicel_Country__c = 'FWI']);            
    }

    global void execute(Database.BatchableContext bc, List<Account> accountsKaldom){

        List<Invoice__c> lstInvoiceToUpsert = new List<Invoice__c>();
        List<Account> lstAccount = new List<Account>();
        if(accountsKaldom.size() > 0){
            for(Integer i = 0; i < accountsKaldom.size(); i++){   
                for(Account acc : accountsKaldom){
                    if(mapSirenFactures.containsKey(acc.Registration_Number__c)){
                        for(FactureKaldomWrapper.factures fac : mapSirenFactures.get(acc.Registration_Number__c)){
                                lstAccount.add(new Account(
                                    Id = acc.Id,
                                    NKaldom__c = fac.client_id
                                ));

                                Invoice__c inv = new Invoice__c();
                                inv.InvoiceDate__c = Date.valueOf(fac.date_creation);
                                inv.AccountName__c =  acc.Id;   
                                inv.ClientNumber__c = fac.client_id;
                                inv.InvoiceID__c = fac.facture_id + '/' + acc.Id;
                                inv.Invoice_Number__c= fac.numero_facture;
                                inv.Amount__c = decimal.valueOf(fac.montant_ht);
                                inv.TVA__c = decimal.valueOf(fac.montant_tva);
                                inv.AmountTTC__c = decimal.valueOf(fac.montant_ttc);
                                inv.DueDate__c = Date.valueOf(fac.date_echeance);
                                inv.PaymentOptions__c = fac.mode_de_paiement;
                                inv.CurrencyIsoCode = fac.devise;
                                inv.Source__c = 'Kaldom';
    
                                if(inv.InvoiceDate__c > Date.today().addYears(-1)){
                                    inv.TechMoreOlderThen12Months__c = true;
                                } else {
                                    inv.TechMoreOlderThen12Months__c = false;
                                }
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
            List<String> list_client_ids = new list<string>(mapClientAccount.get(key));
            Account account = new Account();
            account.Id = key;
            if(list_client_ids.size() == 1){
                account.NKaldom__c = list_client_ids[0];
            } else if(list_client_ids.size() > 1){
                account.NKaldom__c = String.join(list_client_ids, ';');
            }
            lstAccountToUpsert.add(account);
        }


        if(lstInvoiceToUpsert.size() > 0){
            try {
                //limit size for list DML can't exceed 10 000 record 
                List<Invoice__c> lstInvoiceToUpsertPartToDelete = new List<Invoice__c>();
                while (lstInvoiceToUpsert.size() < 10000) {
                    Integer sizeList = lstInvoiceToUpsert.size();
                    for (Integer i = sizeList - 10000; i < sizeList; i++) {
                        lstInvoiceToUpsertPartToDelete.add(lstInvoiceToUpsert[10000]);
                    }
                    System.enqueueJob(new InvoiceKaldom_QUE(lstInvoiceToUpsertPartToDelete));
                }
                
                //database.upsert(lstInvoiceToUpsert, Invoice__c.InvoiceID__c, true );      
            } catch(DmlException e) {
                System.debug('Exception sur l\'upsert des factures: ' + e.getMessage());
            }  
        }  

        if(lstAccountToUpsert.size() > 0){
            try {
                AccountTriggerHandler.triggerDisabled = true;
                database.upsert(lstAccountToUpsert);  
                AccountTriggerHandler.triggerDisabled = false;
            } catch(DmlException e) {
                System.debug('Exception sur l\'upsert des accounts: ' + e.getMessage());
            }  
        }  
       
    }  

    global void finish(Database.BatchableContext bc){
           if(firstNumber < 13){
            firstNumber += 1;
            secondNumber += 1;
            Id batchJobId = Database.executebatch(new InvoiceKaldom_BAT(firstNumber,secondNumber), 100);   
        }
    }    
}