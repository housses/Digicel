global class TelesoftWebService {
    
    global static HttpResponse getAllAccounts() {  
        Boolean isSandBox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        String URL;
        if(isSandBox) {
            URL = 'https://digicel.preprod-facturationtelecom.fr';
        } else {
            URL = system.Label.Api_Telesoft_Url_Prod;
        }
       
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL + '/ssl/webservices/v2/cus.json');       
        req.setMethod('GET');
        req.setTimeout(120000);
        String username = system.Label.Api_Telesoft_Username;
        String password = system.Label.Api_TeleSoft_Password;
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        Http http = new Http();
        return http.send(req);
    }

    public static HttpResponse apiReturnFacturesByDate(String dateDebut, String dateFin) { 
        Boolean isSandBox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        String URL = system.Label.Api_Telesoft_Url_Prod;
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setEndpoint(URL + '/ssl/webservices/v1/rep/212.json?dat_deb=' + dateDebut + '&dat_fin=' + dateFin );       
        req.setMethod('GET');
        req.setTimeout(120000);
        String username = system.Label.Api_Telesoft_Username;
        String password = system.Label.Api_TeleSoft_Password;
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);   
        return http.send(req);
    }
}