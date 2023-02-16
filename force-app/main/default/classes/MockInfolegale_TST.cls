global class MockInfolegale_TST implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        // res.setHeader('Content-Type', 'application/json');
        // res.setBody(JsonFactory.jsonInfolegale);
        // res.setStatusCode(200);
        return res;
    }

}