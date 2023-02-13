// It is used to delete records of a custom object called "Invoice__c" from the Salesforce database. 
// The class accepts a set of account IDs as a parameter and retrieves the invoices associated with those accounts. 
// In the execute method, the retrieved invoices are deleted from the database if there are any. 
global class DeleteInvoiceByAccountId_BAT implements Database.Batchable<sObject>, Database.stateful {
   
    private Set<String> setAccountId;

    public DeleteInvoiceByAccountId_BAT(Set<String> strParam) {
        setAccountId = strParam;
    }

    /**
     * @description :  This method gets all Invoices from set of Account Id 
     * @param bc Database.BatchableContext
    **/
    global Database.QueryLocator start(Database.BatchableContext bc) {    
        return Database.getQueryLocator([SELECT Id FROM Invoice__c WHERE AccountName__c IN :setAccountId]);            
    }  

    /**
     * @description :  This method deletes list of Invoices__c 
     * @param bc Database.BatchableContext
     * @param invoicesToDelete List<Invoice__c>
    **/
    global void execute(Database.BatchableContext bc, List<Invoice__c> invoicesToDelete){
        if(invoicesToDelete.size() > 0){
            database.delete(invoicesToDelete);
        }
    }

    global void finish(Database.BatchableContext bc){
        System.debug('DeleteInvoiceByAccountId_BAT => ------------- END BATCH ------------------' );
    }    
}