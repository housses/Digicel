public with sharing class Account_SVE {

    /**
     * @description :  This method checks the conditions on the account records and if met, adds the account ID to a set of IDs 
     * and then the method executes a batch job (Infolegale_BAT).
     * @param newItems Map<Id,Account>
     * @param oldItems Map<Id,Account>
    **/
	public static void invokeInfoLegalBat(Map<Id,Account> newItems, Map<Id,Account> oldItems){
        Set<Id> setIdAccount = new Set<Id>();
        for(Account acc : newItems.values()){
            if(oldItems == null && acc.Registration_Number__c != null){
                setIdAccount.add(acc.Id);
            }
            else if(oldItems != null && acc.Digicel_Country__c != 'PNG' && 
            acc.Registration_Number__c != null &&
                oldItems.get(acc.Id).Registration_Number__c != acc.Registration_Number__c){
                    setIdAccount.add(acc.Id);
            }
        }  
        if(!system.isBatch() && setIdAccount.size() > 0  ){
            Database.executeBatch(new Infolegale_BAT(setIdAccount), 1);
        }
	} 

    /**
     * @description :  This method checks if the Registration Number field has changed on the account records and if so, updates the related fields and adds the account ID to a set of IDs. 
     * If there is at least one account ID in the set, the method executes a batch job (DeleteInvoiceByAccountId_BAT) to delete all invoices for the account.
     * @param newItems Map<Id,Account>
     * @param oldItems Map<Id,Account>
    **/
	public static void resetExternalIdAndDeleteInvoice(Map<Id,Account> newItems, Map<Id,Account> oldItems){
        Set<String> setAccountId = new Set<String>();
        List<Account> lstAccToUpdate = new List<Account>();

        for(Account acc : newItems.values()){
            if(oldItems.get(acc.Id).Registration_Number__c != acc.Registration_Number__c ){
                setAccountId.add(acc.Id);
                if(acc.Registration_Number__c != null){
                    lstAccToUpdate.add(new Account (
                        Id = acc.Id,
                        NMasterCRM__c = '',
                        NKaldom__c = '',
                        TelesoftNumber__c = ''
                    ));
                } else if(acc.Registration_Number__c == null){
                    lstAccToUpdate.add(new Account (
                        Id = acc.Id,
                        INFOLEGALERating__c = null,
                        NMasterCRM__c = '',
                        NKaldom__c = '',
                        TelesoftNumber__c = ''
                    ));
                }
            }
        }

        if(lstAccToUpdate.size()>0){
            AccountTriggerHandler.triggerDisabled = true;
            database.update(lstAccToUpdate);
            AccountTriggerHandler.triggerDisabled = false;
        }  

        if(setAccountId.size() > 0){
            Id batchJobId = Database.executebatch(new DeleteInvoiceByAccountId_BAT(setAccountId), 200);   
        }
	} 
}