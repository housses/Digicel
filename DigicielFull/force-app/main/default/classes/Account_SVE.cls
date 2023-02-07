/**
 * @description       : 
 * @author            : JBBARTHELEMY
 * @group             : 
 * @last modified on  : 08/11/2022
 * @last modified by  : JBBARTHELEMY
**/
public with sharing class Account_SVE {

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

	public static void resetExternalIdAndDeleteInvoice(Map<Id,Account> newItems, Map<Id,Account> oldItems){
        Set<String> setAccountId = new Set<String>();
        List<Account> lstAccToUpdate = new List<Account>();

        for(Account acc : newItems.values()){
            System.debug('acc.Registration_Number__c'+acc.Registration_Number__c);
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
            // database.delete([SELECT Id FROM Invoice__c WHERE AccountName__c IN :setAccountId]);
        }
	} 
}