@isTest 
private class TelesoftWebservice_TST {

    @isTest 
	public static void testCalloutGetAllAccount() {
        Test.setMock(HttpCalloutMock.class, new MockFactory_TST('MockClientTelesoft'));
        HttpResponse res = TelesoftWebService.getAllAccounts();
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json', 'testCalloutGetAllAccount() => contentType should be equal to "application/json"');
        String actualValue = res.getBody();
        String expectedValue = JsonFactory.jsonClientTelesoft;
        System.assertEquals(actualValue, expectedValue, 'body should be the same');
        System.assertEquals(200, res.getStatusCode(), 'Status Code should be equal to 200');
    }

    @isTest 
	public static void testCalloutGetFacturesByDate() {
        Test.setMock(HttpCalloutMock.class, new MockInvoiceTelesoft_TST());
        HttpResponse res = TelesoftWebService.apiReturnFacturesByDate('2022-07-02','2022-07-12');
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json', 'testCalloutGetFacturesByDate() => contentType should be equal to "application/json"');
        String actualValue = res.getBody();
        String expectedValue = JsonFactory.jsonInvoiceTelesoft;
        System.assertEquals(actualValue, expectedValue, 'testCalloutGetFacturesByDate() => body should be the same');
        System.assertEquals(200, res.getStatusCode(), 'testCalloutGetFacturesByDate() => Status Code should be equal to 200');
    }
}