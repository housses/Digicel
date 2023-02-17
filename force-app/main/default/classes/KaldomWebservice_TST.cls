@isTest
public class KaldomWebservice_TST {

    @isTest 
    static void testCalloutApiLogin() {
        Test.setMock(HttpCalloutMock.class, new MockFactory_TST('MockLoginKaldom'));
        HttpResponse res = KaldomWebService.apiLogin();
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json', 'contentType should be equal to "application/json"');
        String actualValue = res.getBody();
        String expectedValue = JsonFactory.jsonLoginKaldom;
        System.assertEquals(actualValue, expectedValue, 'testCalloutApiLogin => getBody should be the same' );
        System.assertEquals(200, res.getStatusCode(), 'testCalloutApiLogin => getStatusCode should be equal to 200');
    }

    @isTest 
    static void getFactureByDate() {

        Test.setMock(HttpCalloutMock.class, new MockFactory_TST('MockLoginKaldom')); 

        Test.startTest();
        HttpResponse res = KaldomWebService.getFactureByDate('2022-01-01', '2022-08-01');
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json' , 'getFactureByDate => contentType should be equal to "application/json"');
        String actualValue = res.getBody();
        String expectedValue = JsonFactory.jsonInvoiceKaldom;
        Test.stopTest();
        System.assertEquals(actualValue, expectedValue, 'getFactureByDate => getBody should be the same');
        System.assertEquals(200, res.getStatusCode(), 'getFactureByDate => getStatusCode should be equal to 200');
    }
   
    @isTest 
    static void testCalloutGetToken() {
        Test.setMock(HttpCalloutMock.class, new MockFactory_TST('MockLoginKaldom'));
        String token = KaldomWebService.returnToken();
    }
}