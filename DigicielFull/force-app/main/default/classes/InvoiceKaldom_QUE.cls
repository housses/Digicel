public with sharing class InvoiceKaldom_QUE implements Queueable, Database.AllowsCallouts  {
    List<Invoice__c> lstInvoiceToUpsert = new List<Invoice__c>();
    
    public InvoiceKaldom_QUE(List<Invoice__c> lstInvoiceForOneAcc) {
        lstInvoiceToUpsert = lstInvoiceForOneAcc;
    }

    public void execute(QueueableContext context) {
        try {
            database.upsert(lstInvoiceToUpsert, Invoice__c.InvoiceID__c, true);      
        } catch(DmlException e) {
            System.debug('Exception sur l\'upsert des factures: ' + e.getMessage());
        }   
    }       
}