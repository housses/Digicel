public class KaldomWebService {
 
    public static HttpResponse apiLogin() { 
        String url = system.Label.Api_Kaldom_url;
        String urlFinal = url +'/portail/apis/authenticate';
        String email = system.Label.Api_Kaldom_email;
        String password = system.Label.Api_Kaldom_Password;
        String body = ' {"_email" : "' + email + '","_password": "' + password + '"}';
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(urlFinal);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(body);     
        return http.send(req);
    }

    public static String returnToken(){
        HttpResponse hs = new HttpResponse();	
        hs = KaldomWebService.apiLogin();
        Map<String, Object> bodyJson = (Map<String, Object>)JSON.deserializeUntyped(hs.getBody());
        String token = (String)bodyJson.get('response');
        return token;
    }

    public static HttpResponse getFactureByDate(String dateDebut, String dateFin) {    
        String url = system.Label.Api_Kaldom_url;
        String token = KaldomWebService.returnToken();
        String body = '{"jwt": "'+token+'"}';
        if(Test.isRunningTest()){
            Test.setMock(HttpCalloutMock.class, new MockInvoiceKaldom());
        }
        String urlFinal = url + '/portail/apis/invoice/' + dateDebut+'/' + dateFin + '.json';
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setEndpoint(urlFinal);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(body);  	
        return http.send(req);
    }
}