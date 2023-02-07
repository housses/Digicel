@isTest
global class MockLoginKaldom implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"code":200,"response":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJLQUxET00iLCJpYXQiOjE2NTk0NDMxNzcsIm5iZiI6MTY1OTQ0MzE3NywiZXhwIjoxNjU5NDQ2Nzc3LCJhdWQiOiJpbnRlcm5hbCIsImRhdGEiOnsiaWQiOiI3OTAiLCJlbWFpbCI6Im1sZXF1ZXV4QHJlZWotY29uc3VsdGluZy5jb20ifX0.xTs9wXI8vn7PFK1GwTM2ivYXOHZdX7svfYAKP6HfcK8r_nnefM8TR7Sq5zpfVEkS454xQbe3kr4W34buPwbmfA","timestamp":1659443177}');
        res.setStatusCode(200);
        return res;
    }
   
}