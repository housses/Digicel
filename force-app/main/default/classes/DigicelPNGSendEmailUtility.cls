public class DigicelPNGSendEmailUtility {
    
    private Messaging.SingleEmailMessage singleEmailMessage;
    private final List<String> toAddresses;
    
    //optional parameters set to default        
    private String subject = null;
    private String htmlBody = null; 
    private Boolean useSignature = false;
    private Boolean saveAsActivity = false;
    private String targetObjectId = null;
    private String whatId = null;
    private String templateId = null;
    private List<Messaging.EmailFileAttachment> fileAttachments = null;
    //defaults to current user's first name + last name
    private String senderDisplayName = UserInfo.getFirstName()+' '+UserInfo.getLastName();
    //get the current user in context
    User currentUser = [Select email from User where username = :UserInfo.getUserName() limit 1];        
    //replyTo defaults to current user's email 
    //private String replyTo = currentUser.email;
    private String replyTo = null;
    private String plainTextBody = null;
    
    public DigicelPNGSendEmailUtility(List<String> addresses) {
        this.toAddresses = addresses;
    }
    
    public DigicelPNGSendEmailUtility senderDisplayName(String val) {
        senderDisplayName = val;
        return this;
    }
    
    /*public DigicelPNGSendEmailUtility subject(String val) {
        subject = val;
        return this;
    }
    
    public DigicelPNGSendEmailUtility htmlBody(String val) {
        htmlBody = val;
        return this;
    }
    
    public DigicelPNGSendEmailUtility useSignature(Boolean bool) {
        useSignature = bool;
        return this;
    }
    
    public DigicelPNGSendEmailUtility replyTo(String val) {
        replyTo = val;
        return this;
    }*/
    
    public DigicelPNGSendEmailUtility plainTextBody(String val) {
        plainTextBody = val;
        return this;
    }
    
    /*public DigicelPNGSendEmailUtility fileAttachments(List<Messaging.Emailfileattachment> val) {
        fileAttachments = val;
        return this;
    }*/
    
    public DigicelPNGSendEmailUtility saveAsActivity(Boolean bool) {
        saveAsActivity = bool;
        return this;
    }
    
    public DigicelPNGSendEmailUtility targetObjectId(String val) {
        targetObjectId = val;
        return this;
    }
    
    /*public DigicelPNGSendEmailUtility whatId(String val) {
        whatId = val;
        return this;
    }*/
    
    public DigicelPNGSendEmailUtility templateId(String val) {
        templateId = val;
        return this;
    }
    
    //where it all comes together
    //this method is private and is called from sendEmail()
    private DigicelPNGSendEmailUtility build() {
        singleEmailMessage = new Messaging.SingleEmailMessage();
        singleEmailMessage.setToAddresses(this.toAddresses);
        singleEmailMessage.setSenderDisplayName(this.senderDisplayName);
        singleEmailMessage.setSubject(this.subject);
        singleEmailMessage.setHtmlBody(this.htmlBody);
        singleEmailMessage.setUseSignature(this.useSignature);
        singleEmailMessage.setReplyTo(this.replyTo);
        singleEmailMessage.setPlainTextBody(this.plainTextBody);
        singleEmailMessage.setFileAttachments(this.fileAttachments);
        singleEmailMessage.setSaveAsActivity(this.saveAsActivity);
        singleEmailMessage.setTargetObjectId(this.targetObjectId);
        singleEmailMessage.setWhatId(this.whatId);
        singleEmailMessage.setTemplateId(this.templateId);
        //singleEmailMessage.setorgWideEmailAddressId();
        //singleEmailMessage.setTreatTargetObjectAsRecipient(false) //To avoid sending email to record owner 
        return this;
    }
    
    //send the email message
    public void sendEmail() {
        try {
            //call build first to create the email message object
            build();
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { singleEmailMessage });
        } catch (Exception ex) {
            System.debug('There was a problem while calling Messaging.sendEmail()' + ex.getStackTraceString());
        }                
    }    
}