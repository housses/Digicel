@isTest
public class PNG_EmailServiceProductInventoryTest {
    static testMethod void TestinBoundEmail(){
        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // setup the data for the email
        email.subject = 'Create Contact';
        email.fromAddress = 'prm_login@persistent.com';
        //email.plainTextBody = 'email body\n2225256325\nTitle';
        
        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.fileName = 'TestData.csv';
        attachment.body = blob.valueOf('SKU \\ SKU Type \\ SKU Group \\ Description \\ Total QTY \\ QTY Unallocated \\ QTY Allocated \\ QTY Picked \\ QTY On-Hold \\ QTY Available \n 02120731,	STD,TECHNICAL,DC Power Distribtion Unit,1,0,0,0,0,1');
        attachment.mimeTypeSubType = 'text/csv';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
            
            Test.startTest();
        
        // call the email service class and test it with the data in the testMethod
        DigicelPNGEmailServiceProductInventory  testInbound = new  DigicelPNGEmailServiceProductInventory();
        testInbound.handleInboundEmail(email, env);
        
        Test.stopTest();
    }
}