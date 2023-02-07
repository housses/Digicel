global class DigicelPNGEmailServiceTarka implements Messaging.InboundEmailHandler{
    
    list<list<String>> allCSVColumns = new list<list<String>>(); // list of columns in CSV
    list<String> totalCSVRows = new list<String>(); // list of Rows in CSV
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        Messaging.InboundEmail.BinaryAttachment[] bAttachments = email.binaryAttachments;
        
        System.debug('bAttachments----'+bAttachments);
        
        try{
            if(bAttachments != null){
                for(Messaging.InboundEmail.BinaryAttachment btt : bAttachments){
                    if(btt.Filename.endsWith('.csv')){
                        String csvBody = btt.body.toString();
                        List<String> lines = csvBody.split('\n');
                        for(String line : lines){
                            allCSVColumns.add(line.split('\\,', -1));
                            totalCSVRows.add(line);
                        }
                    }
                }
                System.debug('DildarLog: EmailService-Tarka - totalCSVRows: ' + totalCSVRows);
                System.debug('DildarLog: EmailService-Tarka - totalCSVRows.size(): ' + totalCSVRows.size());
                System.debug('DildarLog: EmailService-Tarka - allCSVColumns: ' + allCSVColumns);
                
                List<PNG_TarkaInvoicePayment__c> tarkaInvoiceRecs = new List<PNG_TarkaInvoicePayment__c>();
                
                If(totalCSVRows.size() > 0){
                    for(Integer i = 1 ; i < totalCSVRows.size() ; i++){
                        PNG_TarkaInvoicePayment__c tarkaInvoice= new PNG_TarkaInvoicePayment__c();
                        if(allCSVColumns[i][0] != null){
                            tarkaInvoice.PNG_ServiceMonth__c = allCSVColumns[i][0];
                        }
                        if(allCSVColumns[i][1] != null){
                            tarkaInvoice.PNG_TarkaId__c=allCSVColumns[i][1];
                            tarkaInvoice.Tarka_Customer_ID__r = new BAN__c(AccountNumber__c=allCSVColumns[i][1]);
                        }
                        if(allCSVColumns[i][2] != null){
                            tarkaInvoice.PNG_CustomerName__c = allCSVColumns[i][2];
                        }
                        if(allCSVColumns[i][3] != null){
                            tarkaInvoice.PNG_ServiceName__c = allCSVColumns[i][3];
                        }
                        if(allCSVColumns[i][4] != null){
                            tarkaInvoice.PNG_AccountManager__c = allCSVColumns[i][4];
                        }
                        if(allCSVColumns[i][5] != null){
                            tarkaInvoice.PNG_AccountStatus__c = allCSVColumns[i][5];
                        }
                        if(allCSVColumns[i][6] != null){
                            tarkaInvoice.PNG_ContactPerson__c = allCSVColumns[i][6];
                        }
                        if(allCSVColumns[i][7] !=  null){
                            tarkaInvoice.PNG_ContactNumber_text__c = allCSVColumns[i][7];
                        }
                        if(allCSVColumns[i][8] != ''){
                            tarkaInvoice.PNG_TotalChargeK__c = decimal.valueOf(allCSVColumns[i][8]);
                        }
                        if(allCSVColumns[i][9] != ''){
                            tarkaInvoice.PNG_TotalPaymentK__c = decimal.valueOf(allCSVColumns[i][9]);
                        }
                        if(allCSVColumns[i][10] != ''){
                            tarkaInvoice.PNG_AvailableBalanceK__c = decimal.valueOf(allCSVColumns[i][10].trim());
                        }
                        tarkaInvoiceRecs.add(tarkaInvoice);
                        
                    }
                }
                System.debug('DildarLog: EmailService-Tarka - rows: ' + tarkaInvoiceRecs);
                
                //System.debug('DildarLog: EmailService-Tarka - externalIdFieldOnTarkaInvoice: ' + Label.DigicelPNGTarkaRevenueMovementExternalId);
                
                
                //Schema.SobjectField externalIdField = Schema.getGlobalDescribe().get('BAN__c').getDescribe().fields.getMap().get(Label.DigicelPNGTarkaRevenueMovementExternalId);            //create a new label
                
                if(tarkaInvoiceRecs.size() > 0){
                    //TBD
                    //Database.UpsertResult[] upserResult =  Database.upsert(accountRecs,externalIdField,false);
                    Database.upsert(tarkaInvoiceRecs);
                    
                    //TBD
                    //Iterate through each returned result
                    /*for(Database.UpsertResult sr : upserResult){
if(!sr.isSuccess()){
//Operation failed, so get all errors               
for(Database.Error err : sr.getErrors()){
System.debug(err.getStatusCode() + ': ' + err.getMessage());
System.debug('fields that affected this error: ' + err.getFields());
}
}
}*/
                }
                result.success = true;
            }
        }catch(Exception ex){
            result.success = false;
            System.debug('DildarLog: Exception@DigicelPNGEmailServiceTarka - '+ ex.getMessage());
            
            List<String> toEmailAddresses = Label.DigicelPNGTarkaEmailServiceExceptionEmailRecipient.split(';');
            if(toEmailAddresses.Size() > 0){
                DigicelPNGSendEmailUtility sendEmailUtil = new DigicelPNGSendEmailUtility(toEmailAddresses);
                try{
                    EmailTemplate exceptionEmailTemp =  [select id, name, Body, DeveloperName, Subject from EmailTemplate where developerName =: Label.DigicelPNGEmailServiceExceptionEmailTemplate];
                    String plainBody = exceptionEmailTemp.Body;
                    plainBody = plainBody.replace('{!Contact.Description}', ex.getStackTraceString());
                    sendEmailUtil.senderDisplayName('PNG Admin').targetObjectId(Label.DigicelPNGTarkaEmailServiceExceptionEmailSender).templateId(exceptionEmailTemp.id).saveAsActivity(false).plainTextBody(plainBody).sendEmail();
                }catch(Exception emailEx){
                    System.debug('Exception: '+ emailEx.getMessage());
                }
            }              
        }
        return result;
    }
}