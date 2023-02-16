@isTest
public class InfolegaleWebService_TST {
   
    @isTest 
	public static void testCalloutGetLogin() {
        Test.setMock(HttpCalloutMock.class, new MockFactory_TST('MockInfolegale'));
        HttpResponse res = InfolegaleWebService.apiLogin();
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json', 'testCalloutGetLogin => contentType should be equal to "application/json"');
        String actualValue = res.getBody();
        String expectedValue = JsonFactory.jsonInfolegale;
        System.assertEquals(actualValue, expectedValue, 'testCalloutGetLogin => getBody should be the same' );
        System.assertEquals(200, res.getStatusCode(), 'testCalloutGetLogin => getStatusCode should be equal to 200');
    }

    @isTest 
	public static void testCalloutGetToken() {
        Test.setMock(HttpCalloutMock.class, new MockFactory_TST('MockInfolegale')); 
        String token = InfolegaleWebService.returnToken();
    }

    @isTest 
	public static void testCalloutGetData() {
        Test.setMock(HttpCalloutMock.class, new MockFactory_TST('MockInfolegale'));
        HttpResponse res = InfolegaleWebService.getDataInfolegale('26451248');
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json', 'testCalloutGetData =>contentType should be equal to "application/json"');
        String actualValue = res.getBody();
        String expectedValue = JsonFactory.jsonInfolegale;
        System.assertEquals(actualValue, expectedValue, 'testCalloutGetData => getBody should be the same' );
        System.assertEquals(200, res.getStatusCode(), 'testCalloutGetData => getStatusCode should be equal to 200');
    }
}