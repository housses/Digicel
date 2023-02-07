@isTest
private class GuestFormControllerTest {
	static testMethod void validate() {
        
        Account a = new Account(Name='Test');
        insert a;
        Opportunity o = new Opportunity(Name='Test', Accountid = a.id, StageName='Prospecting & Qualification', CloseDate=date.TODAY());
        insert o;
        PageReference pr = new PageReference('/fileupload/guestsite?showbtn=false&hidebtn=true&desc=Please%20Attach%20File&oppid='+o.Id);
        
        Test.startTest();
        Test.setCurrentPage(pr);
        //All fields filled out, file attached
        GuestFormController gfc = new GuestFormController();
        gfc.subject = 'subject';
        gfc.description = 'description';
        gfc.filebody = Blob.valueof('blah');
        gfc.filename = 'text.csv';
        gfc.oppid = o.id; 
        gfc.doSubmit();
        gfc.addanother();

        //File not attached
        GuestFormController gfc2 = new GuestFormController();
        gfc2.subject = 'subject';
        gfc2.description = 'description';
        gfc2.oppid = o.id; 
        gfc2.doSubmit();
        
        //No opportunity
        GuestFormController gfc3 = new GuestFormController();
        gfc3.subject = 'subject';
        gfc3.description = 'description';
        gfc3.doSubmit();
        gfc3.addanother();
        Test.stopTest();
    }
}