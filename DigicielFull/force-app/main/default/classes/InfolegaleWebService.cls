global class InfolegaleWebService {
 
    public static HttpResponse apiLogin() { 
        Boolean isSandBox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        String url;
        String username;
        String password;
        if(isSandBox) {
            url = system.Label.Api_Infolegale_Url;
            username = system.Label.Infolegale_API_email;
            password = system.Label.Infolegale_API_password;
        } else {
            url = system.Label.Api_Infolegale_Url_Prod;
            username = system.Label.Api_Infolegale_Username_Prod;
            password = system.Label.Api_Infolegale_Password_Prod;
        }

        String urlFInal = url + '/v2/login_json';
        String body = ' {"_username" : "' + username + '","_password": "' + password + '"}';

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(urlFInal);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(body); 
        return http.send(req);
    }

    public static String returnToken(){
        HttpResponse hs = new HttpResponse();	
        hs = InfolegaleWebService.apiLogin();
        Map<String, Object> bodyJson = (Map<String, Object>)JSON.deserializeUntyped(hs.getBody());
        String token = (String)bodyJson.get('token');
        return token;
    }

    public static HttpResponse getDataInfolegale(String siren) { 
        String token = InfolegaleWebService.returnToken();

        Boolean isSandBox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        String url;
        if(isSandBox) {
            url = system.Label.Api_Infolegale_Url;
        } else {
            url = system.Label.Api_Infolegale_Url_Prod;
        }

        String urlFinal = url + '/v2/companies/FR/' + siren + '/score';
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        String bearer = 'Bearer ' + token;

        req.setEndpoint(urlFinal);
        req.setMethod('GET');
        req.setHeader('Authorization', bearer);
        return http.send(req);
    }    

}