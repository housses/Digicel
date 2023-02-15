public without sharing class GuestFormController {
    
    public String subject {get; set;}
    public String description {get; set;}
    public String filename {get; set;}
    public Blob filebody {get; set;}
    public String oppid{get;set;}
    public Boolean showbtn{get;set;}
    public Boolean hidebtn{get;set;}
    
    public GuestFormController(){
        showbtn=Boolean.valueof(apexpages.currentpage().getparameters().get('showbtn'));
        hidebtn=Boolean.valueof(apexpages.currentpage().getparameters().get('hidebtn'));
        oppid = apexpages.currentpage().getparameters().get('oppid');
        description = apexpages.currentpage().getparameters().get('desc');
    }

    public PageReference doSubmit() {
        //create a new case. This is done since the guest user only has access to the case object
        try{
        Case basket = new Case(Subject = subject, Description = oppid, RecordTypeId='0120W000001USs6'); //production
        //Case basket = new Case(Subject = subject, Description = oppid, RecordTypeId='0125C000000cZfW'); //Salescloud sandbox
        insert basket;
        //Case c = [SELECT Id from Case where Id= :basket.Id];
        //delete c; 
            
		//FILE 
        ContentVersion file = new ContentVersion(
            title = subject + ' - ' + FileName ,
            description = description,
            versionData = filebody,
            pathOnClient = '/' + FileName
        );
        insert file; 
        file = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :file.Id];
        //Link to opp
        ContentDocumentLink cdl2 = new ContentDocumentLink(
            ContentDocumentId=file.ContentDocumentId,
            LinkedEntityId= oppId);
        insert cdl2;
            
       	// ATTACHMENT
        Attachment attachment = new Attachment();
  		attachment.Body = filebody;
  		attachment.Name = subject + ' - ' + FileName;
  		attachment.ParentId = oppId; 
  		insert attachment;
  
        return new PageReference('/fileupload/guestsite?showbtn=true&hidebtn=false&desc=SUBMITTED&oppid='+oppId);
            
        } catch (Exception e) {
                ApexPages.addMessages(e);
            	hidebtn=false;
            	showbtn=true;
                description = 'ERROR PLEASE TRY AGAIN: Fill in all required fields';
            	return null;
            }        
    }
    
   
    public PageReference addanother() 
    {
        PageReference pageRef = new PageReference('/fileupload/guestsite?showbtn=false&hidebtn=true&desc=Please%20Attach%20File&oppid='+oppId);
        return pageRef;
    }
    
}