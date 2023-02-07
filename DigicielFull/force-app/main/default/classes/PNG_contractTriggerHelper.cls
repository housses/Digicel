public without sharing class PNG_contractTriggerHelper {
    static List<Entitlement> newEmtitlements = new List<entitlement>();
    static List<account> accountsToUpdate = new List<Account>();
    static Map<String, SlaProcess> slaProcessMap;
    static Account parentAcc;
    
    Public static void createEntitlement(List<contract>updatedContracts){  
        
        List<Contract> contracts=[select id,StartDate,EndDate, AccountID, Account.Type, Account.PNG_EntitlementLevel__c,Account.Name,
                                  Account.PNG_Account_Level__c, Opportunity__c, Opportunity__r.PNG_OpportunityType__c 
                                  from Contract 
                                  where id IN: updatedContracts AND AccountID!=null AND Opportunity__c!=null AND Account.Type='Customer'];
        Set<Id>accIds = new Set<ID>();
        for(Contract con: contracts){
            accIds.add(con.AccountId);
        }
        System.debug('--accIds--'+accIds);
        Map<Id, Account> accountsOfContract = new Map<Id, Account>([Select id, PNG_EntitlementLevel__c,
                                                                    (select id, StartDate,EndDate,PNG_EntitlementType__c from Entitlements Where Status='Active' 
                                                                     Order By createdDate desc)
                                                                    from Account where Id IN: accIds]);
        System.debug('--contracts--'+contracts);
        
        List<SlaProcess> slaProcesses = [Select id, Name,isActive from SlaProcess where isActive=true];
        slaProcessMap = new Map<String, SlaProcess>();
        for(SlaProcess sla:slaProcesses){
            slaProcessMap.put(sla.Name, sla);
            System.debug('sla...'+sla);
        }
        System.debug('slaProcessMap...'+slaProcessMap);
        for(Contract con: contracts){
            if(con.Account.PNG_Account_Level__c != null && con.Opportunity__r.PNG_OpportunityType__c != null){
                
                System.debug('--inside account and opp If --');
                if(accountsOfContract!=null && accountsOfContract.containsKey(con.AccountID)){
                    parentAcc = accountsOfContract.get(con.AccountID);
                }
                System.debug('--parentAcc  --'+parentAcc );
                if(con.Account.PNG_EntitlementLevel__c ==''){
                    System.debug('--inside create entitlement  --'+con);
                    createNewEntitlement(con);
                } else 
                    if(con.Account.PNG_EntitlementLevel__c != con.Account.PNG_Account_Level__c){ 
                        //Deactivate existing Entitlements
                        if(accountsOfContract!=null && accountsOfContract.containsKey(con.AccountID)){
                            for(Entitlement ent :  accountsOfContract.get(con.AccountID).Entitlements){
                                if(System.today()-1 > ent.StartDate){
                                    ent.EndDate = System.today()-1;
                                }else{
                                    ent.EndDate = System.today();
                                }
                                
                                newEmtitlements.add(ent);
                            }
                        }
                        createNewEntitlement(con);
                    } else //Account does not have any active entitlement
                        if(parentAcc.Entitlements.size()==0){
                            createNewEntitlement(con);
                        }else //Account have active entitlements
                            if(parentAcc.Entitlements.size()>0)
                        {
                            Boolean entitlementExist = false;
                            for(Entitlement ent :parentAcc.Entitlements){
                                if(con.Opportunity__r.PNG_OpportunityType__c == 'GSM' && ent.PNG_EntitlementType__c == 'Mobile Services'){
                                    if(con.EndDate!=null && con.EndDate > ent.EndDate)
                                    {
                                        ent.EndDate = con.EndDate;
                                        newEmtitlements.add(ent);
                                    }
                                    entitlementExist = true;
                                    
                                }else if((con.Opportunity__r.PNG_OpportunityType__c == 'ICT'||con.Opportunity__r.PNG_OpportunityType__c == 'ICT & GSM')&& ent.PNG_EntitlementType__c == 'Connectivity & Enterprise'){
                                    if(con.EndDate!=null && con.EndDate > ent.EndDate)
                                    {
                                        ent.EndDate = con.EndDate;
                                        newEmtitlements.add(ent);
                                    }
                                    entitlementExist = true;
                                }   
                            }
                            if(!entitlementExist){
                                createNewEntitlement(con);   
                            }
                        }
            }
        }
        
        if(newEmtitlements!=null && newEmtitlements.size()>0){
            upsert newEmtitlements;
        }
        if(accountsToUpdate!=null && accountsToUpdate.size()>0){
            update accountsToUpdate;
        }
    }
    
    public static void createNewEntitlement(Contract con){
        //create new Entitlement
        
        Entitlement ent=new Entitlement();
        ent.AccountId = con.accountId;
        ent.StartDate = con.StartDate;
        ent.EndDate = con.EndDate;
        ent.BusinessHoursId = Label.PNG_BusinessHoursId;
        
        if(con.Opportunity__r.PNG_OpportunityType__c == 'GSM'){
            String slaProcessName = con.Account.PNG_Account_Level__c+' '+Label.PNG_Service1;
            ent.Name = con.Account.Name+' - '+slaProcessName;
            ent.PNG_EntitlementType__c = Label.PNG_Service1; 
            System.debug('slaProcessName:'+slaProcessName);
            System.debug('2nd slaProcessMap:'+slaProcessMap);
            if(slaProcessMap!=null && slaProcessMap.containsKey(slaProcessName)){
                ent.SlaProcessId = slaProcessMap.get(slaProcessName).Id;
            }
        }
        else if(con.Opportunity__r.PNG_OpportunityType__c == 'ICT' || con.Opportunity__r.PNG_OpportunityType__c == 'ICT & GSM'){
                    String slaProcessName = con.Account.PNG_Account_Level__c+' '+Label.PNG_Service2;
                    ent.Name = con.Account.Name+' - '+slaProcessName;
                    ent.PNG_EntitlementType__c = Label.PNG_Service2;
                    if(slaProcessMap!=null && slaProcessMap.containsKey(slaProcessName)){
                        ent.SlaProcessId = slaProcessMap.get(slaProcessName).Id;
                    }
                }
      
        parentAcc.PNG_EntitlementLevel__c = con.Account.PNG_Account_Level__c;
        newEmtitlements.add(ent);
        accountsToUpdate.add(parentAcc); 
    }
}