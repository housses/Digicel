global class InfolegaleWebService {

    private static Boolean isSandbox = true;

    /*
    * Method to update global variable isSandbox 
    */
    private static void updateBoolOrg(){
        isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox; 
    }

    /*
    * Method to retrieve the name of the named credential based on organization's sandbox status.
    * @return String wth the value of the named credential
    */
    global static String getNamedCredentialBasedOnOrg(){
        String response;
        if(isSandBox) {
            response = 'Infolegale_Dev';
        } else {
            response = 'Infolegale_Prod';
        }
        return response;
    }

    /*
    * Method to retrieve the name of the custom label based on organization's sandbox status.
    * @return String wth the value of the custom label
    */
    global static String getNamedCustomLabelBasedOnOrg(){
        String url;
        if(isSandBox) {
            url = system.Label.Api_Infolegale_Url;
        } else {
            url = system.Label.Api_Infolegale_Url_Prod;
        }
        return url;
    }
 
    /*
    * Method to retrieve response with token for authentification.
    * @return HttpResponse with the token 
    */
    public static HttpResponse apiLogin() { 
        InfolegaleWebService.updateBoolOrg();
        String namedCredential = InfolegaleWebService.getNamedCredentialBasedOnOrg();
    
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:' + namedCredential + '/v2/login_json');
        req.setMethod('POST');
        Http http = new Http();
        req.setHeader('Content-Type', 'application/json');
        req.setBody('{"_username" : "' + '{!$Credential.UserName}' + '","_password": "' + '{!$Credential.Password}' + '"}'); 
        HttpResponse response = new HttpResponse();

        try {
            response = http.send(req);
            if (response.getStatusCode() != 200){
                throw new MyException('Error Infolegale server : status code : ' + response.getStatusCode() );
            } 
        } catch(Exception e){
            throw new MyException('Error from InfolegaleWebService.apiLogin() Method => ' + e.getMessage());
        }  
        return response;
    }

    /*
    * Method to parse the response and get the token
    * @return HttpResponse with the token 
    */
    public static String returnToken(){
        HttpResponse hs = new HttpResponse();	
        hs = InfolegaleWebService.apiLogin();
        String token;
        if(hs != null){
            Map<String, Object> bodyJson = (Map<String, Object>)JSON.deserializeUntyped(hs.getBody());
            token = (String)bodyJson.get('token');
        }
        return token;
    }

    /*
    * Method returns the score of a company based on its SIREN code using Infolegale API.
    * @param siren String : SIREN code of the company 
    * @return HttpResponse : response from Infolegale API
    */
    public static HttpResponse getDataInfolegale(String siren) { 
        String token = InfolegaleWebService.returnToken();
        String url = InfolegaleWebService.getNamedCustomLabelBasedOnOrg();

        HttpRequest req = new HttpRequest();
        Http http = new Http();
        String bearer = 'Bearer ' + token;

        req.setEndpoint(url + '/v2/companies/FR/' + siren + '/score');
        req.setMethod('GET');
        req.setHeader('Authorization', bearer);
        HttpResponse response = new HttpResponse();

        try {
            response = http.send(req);
            if (response.getStatusCode() != 200){
                throw new MyException('Error Infolegale server : status code : ' + response.getStatusCode() );
            } 
        } catch(Exception e){
            throw new MyException('Error from InfolegaleWebService.getDataInfolegale() Method => ' + e.getMessage());
        }  
        return response;
    }    

}