@isTest
global class MockFactory_TST implements HttpCalloutMock {
   
    public String nameMock;

    public MockFactory_TST(String param) {
        nameMock = param;
    }

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);

        switch on nameMock {
            when 'MockClientTelesoft' { res.setBody(JsonFactory.jsonClientTelesoft);}	
            when 'MockInfolegale' { res.setBody(JsonFactory.jsonInfolegale);}
            when 'MockInvoiceKaldom' { res.setBody(JsonFactory.jsonInvoiceKaldom);}
            when 'MockInvoiceTelesoft' { res.setBody(JsonFactory.jsonInvoiceTelesoft);}
            when 'MockLoginKaldom' { res.setBody(JsonFactory.jsonLoginKaldom);}
            when else {	
                System.debug('error MockFactory');
            }
        }

        return res;
    }

}