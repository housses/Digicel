global class DigicelPNGEmailServiceProductInventory implements Messaging.InboundEmailHandler{
    
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
                System.debug('DildarLog: EmailService-Inventory - totalCSVRows: ' + totalCSVRows);
                System.debug('DildarLog: EmailService-Inventory - totalCSVRows.size(): ' + totalCSVRows.size());
                System.debug('DildarLog: EmailService-Inventory - allCSVColumns: ' + allCSVColumns);
                
                List<Product2> product2Recs = new List<Product2>();
                
                If(totalCSVRows.size() > 0){
                    for(Integer i = 1 ; i < totalCSVRows.size() ; i++){
                        
                        Product2 product2Rec = new Product2();
                        if(allCSVColumns[i][0] != null){
                            product2Rec.PNG_SKU__c = allCSVColumns[i][0];
                        }
                        if(allCSVColumns[i][1] != null){
                            product2Rec.PNG_SKUType__c = allCSVColumns[i][1];
                        }
                        if(allCSVColumns[i][2] != null){
                            product2Rec.PNG_SKUGroup__c = allCSVColumns[i][2];
                        }
                        if(allCSVColumns[i][3] != null){
                            product2Rec.PNG_Description__c = allCSVColumns[i][3];
                        }
                        if(allCSVColumns[i][4] != null){
                            product2Rec.PNG_TotalQty__c = Integer.valueOf(allCSVColumns[i][4]);
                    	}
                        if(allCSVColumns[i][5] != null){
                            product2Rec.PNG_QTYUnAllocated__c = Integer.valueOf(allCSVColumns[i][5]);
                    	}
                        if(allCSVColumns[i][6] != null){
                            product2Rec.PNG_QTYAllocated__c = Integer.valueOf(allCSVColumns[i][6]);
                    	}
                        if(allCSVColumns[i][7] != null){
                            product2Rec.PNG_QTYPicked__c = Integer.valueOf(allCSVColumns[i][7]);
                    	}
                        if(allCSVColumns[i][8] != null){
                            product2Rec.PNG_QTYOnHold__c = Integer.valueOf(allCSVColumns[i][8]);
                    	}
                        if(allCSVColumns[i][9] != null){
                            product2Rec.PNG_QTYAvailable__c = Integer.valueOf(allCSVColumns[i][9].trim());
                    	}
                    	product2Recs.add(product2Rec);
					}
                }
                System.debug('DildarLog: EmailService-Inventory - rows: ' + product2Recs);
                
                System.debug('DildarLog: EmailService-Inventory - externalIdFieldOnProduct: ' + Label.DigicelPNGInventoryProductExternalId);
                
                Schema.SobjectField externalIdField = Schema.getGlobalDescribe().get('Product2').getDescribe().fields.getMap().get(Label.DigicelPNGInventoryProductExternalId);
    
                if(product2Recs.size() > 0){
                    //TBD
					//Database.UpsertResult[] upserResult =  Database.upsert(accountRecs,externalIdField,false);
					
                   	Database.upsert(product2Recs,externalIdField,true);
                    
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
            System.debug('DildarLog: Exception@DigicelPNGEmailServiceProductInventory - '+ ex.getMessage());
            
            List<String> toEmailAddresses = Label.DigicelPNGInventoryEmailServiceExceptionEmailRecipient.split(';');
            if(toEmailAddresses.Size() > 0){
                DigicelPNGSendEmailUtility sendEmailUtil = new DigicelPNGSendEmailUtility(toEmailAddresses);
                try{
                    EmailTemplate exceptionEmailTemp =  [select id, name, Body, DeveloperName, Subject from EmailTemplate where developerName =: Label.DigicelPNGEmailServiceExceptionEmailTemplate];
                    String plainBody = exceptionEmailTemp.Body;
                    plainBody = plainBody.replace('{!Contact.Description}', ex.getStackTraceString());
                    sendEmailUtil.senderDisplayName('PNG Admin').targetObjectId(Label.DigicelPNGInventoryEmailServiceExceptionEmailSender).templateId(exceptionEmailTemp.id).saveAsActivity(false).plainTextBody(plainBody).sendEmail();
                }catch(Exception emailEx){
                    System.debug('Exception: '+ emailEx.getMessage());
                }
            }              
        }
        return result;
    }
}