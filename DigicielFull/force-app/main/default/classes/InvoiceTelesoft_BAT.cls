/**
 * @description       : 
 * @author            : JBBARTHELEMY
 * @group             : 
 * @last modified on  : 08/11/2022
 * @last modified by  : JBBARTHELEMY
**/
global class InvoiceTelesoft_BAT implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.stateful {

    public Integer firstNumber;
    public Integer secondNumber;
    private List<FactureTelesoftWrapper> repBody;
    private Map<String, List<FactureTelesoftWrapper>> mapTelesoftNumberFac = new Map<String, List<FactureTelesoftWrapper>>();

    public InvoiceTelesoft_BAT(Integer firstParam, Integer secondParam) {
        firstNumber = firstParam;
        secondNumber = secondParam;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        DateTime todaysDate = System.today().addMonths(-firstNumber);
        DateTime lastMonthDate = System.today().addMonths(-secondNumber);
        String todaysDateStr = todaysDate.format('yyyy-MM-dd');
        String lstMonthDateStr = lastMonthDate.format('yyyy-MM-dd');

        HttpResponse resFacture = new HttpResponse();
        resFacture = TelesoftWebService.apiReturnFacturesByDate(lstMonthDateStr,todaysDateStr);
        repBody = FactureTelesoftWrapper.parse(resFacture.getBody());
        List<String> lstTelesoftNumber = new List<String>();
        for(FactureTelesoftWrapper fac : repBody){
            if(!mapTelesoftNumberFac.containsKey(fac.Compte_client)){
                mapTelesoftNumberFac.put(fac.Compte_client, new List<FactureTelesoftWrapper>());
            }
            mapTelesoftNumberFac.get(fac.Compte_client).add(fac); 
        }
        for(String numeroClients : mapTelesoftNumberFac.keySet() ){
            lstTelesoftNumber.add('%' + numeroClients +'%');
        }
        return Database.getQueryLocator([SELECT Id, Name, TelesoftNumber__c, Registration_Number__c FROM Account WHERE TelesoftNumber__c LIKE :lstTelesoftNumber AND Owner.Digicel_Country__c = 'FWI']);            
    }

    global void execute(Database.BatchableContext bc, List<Account> accountsTelesoft){

            List<Invoice__c> lstInvoiceToUpsert = new List<Invoice__c>();

            for(Account acc : accountsTelesoft){
             
                List<String> telesoftIds = new List<String>();
                if(acc.TelesoftNumber__c.contains(';')){
                    telesoftIds = acc.TelesoftNumber__c.split(';');
                }  else {
                    telesoftIds.add(acc.TelesoftNumber__c);
                }
                for(String telesoftId : telesoftIds){
                    if(mapTelesoftNumberFac.get(telesoftId) != null){
                        for(FactureTelesoftWrapper fac : mapTelesoftNumberFac.get(telesoftId)){  
                   
                            if(telesoftId == fac.Compte_client){
                                Invoice__c inv = new Invoice__c();
                                //inv.InvoiceDate__c = Date.parse(fac.Date_facture);11/02/2023
                                if(fac.Date_facture != null ){
                                    string[] RFQdate = String.valueOf(fac.Date_facture.trim()).split('/');
                                    inv.InvoiceDate__c = date.valueOf(RFQdate[2] + '-' + RFQdate[1] + '-' + RFQdate[0]);
                                }
                                inv.ClientNumber__c = fac.Compte_client;
                                inv.AccountName__c = acc.Id;   
                                inv.Invoice_Number__c = fac.Id_facture;
                                inv.InvoiceID__c = fac.Id_facture + '/' + fac.Id_produit + '/' + acc.Id;
                                inv.Amount__c = Double.valueOf((fac.Prix_HT).replaceAll(',', '.').replaceAll(' ', ''));
                                inv.Source__c = 'Telesoft';
                                inv.AmountTTC__c = InvoiceTelesoft_SVE.calculAmountTTC(fac.Prix_HT, fac.Taux_TVA);
                                inv.TVA__c = InvoiceTelesoft_SVE.calculAmountTVA(fac.Prix_HT, fac.Taux_TVA);
                                inv.CurrencyIsoCode = 'EUR';
    
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

            Map<String, Map<String, Invoice__c>> mapInvoiceToInsert = new Map<String, Map<String, Invoice__c>>();
            if(lstInvoiceToUpsert.size() > 0) {
                for(Invoice__c inv : lstInvoiceToUpsert){

                    if (!mapInvoiceToInsert.containsKey(inv.AccountName__c)) {
                        mapInvoiceToInsert.put(inv.AccountName__c, new Map<String, Invoice__c>());
                    }

                    if(mapInvoiceToInsert.get(inv.AccountName__c).get(inv.Invoice_Number__c) == null){
                        mapInvoiceToInsert.get(inv.AccountName__c).put(inv.Invoice_Number__c, inv);
                    } else {
                        mapInvoiceToInsert.get(inv.AccountName__c).get(inv.Invoice_Number__c).Amount__c += inv.Amount__c ;
                        mapInvoiceToInsert.get(inv.AccountName__c).get(inv.Invoice_Number__c).TVA__c += inv.TVA__c ;
                        mapInvoiceToInsert.get(inv.AccountName__c).get(inv.Invoice_Number__c).AmountTTC__c += inv.AmountTTC__c ;              
                    }
                }
            }


            List<Invoice__c> lstInvoice = new List<Invoice__c>();
            if(mapInvoiceToInsert != null && mapInvoiceToInsert.size() > 0) {
                for(String idAccount : mapInvoiceToInsert.keySet() ){
                    for(String invId : mapInvoiceToInsert.get(idAccount).keyset()) {
                        lstInvoice.add(mapInvoiceToInsert.get(idAccount).get(invId));
                    }
                }
              
            }
        
            if(lstInvoice.size() > 0){
                try {
                    database.upsert(lstInvoice, Invoice__c.InvoiceID__c);
                } catch(DmlException e) {
                    System.debug('Exception sur l\'upsert des factures: ' + e.getMessage());
                }  
            }     
    }

    global void finish(Database.BatchableContext bc){  
        if(firstNumber < 13){
            firstNumber += 1;
            secondNumber += 1;
            Id batchJobId = Database.executebatch( new InvoiceTelesoft_BAT(firstNumber,secondNumber), 100);
        }
        system.debug('Traitement Batch terminé');
    }    

}