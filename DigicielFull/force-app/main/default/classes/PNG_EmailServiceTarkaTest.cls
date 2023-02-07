@isTest
public class PNG_EmailServiceTarkaTest {
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
        attachment.body = blob.valueOf('Service Month \\ Tarka ID \\ Customer Name \\ Service Name \\ Account Manager \\ Account Status \\ Contact Person \\ Contact Number \\ Total Charge(K) \\ Total Payment(K) \\ Available Balance(K) \n Nov-19,0635482,Remington Technologies,Internet/Branch Network,Marica Davida,Active,Asanka Dias,76340709,60695.00,60695.00,0');
        attachment.mimeTypeSubType = 'text/csv';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
            
            Test.startTest();
        
        // call the email service class and test it with the data in the testMethod
        DigicelPNGEmailServiceTarka  testInbound = new  DigicelPNGEmailServiceTarka();
        testInbound.handleInboundEmail(email, env);
        
        Test.stopTest();
    }
}