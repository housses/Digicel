/**
 * @description       : Class contain all http methode call Kaldom.
 * @author            : CLEPILLOUER
 * @last modified on  : 10/02/2023
 * @last modified by  : HBOUZINE
**/
public class KaldomWebService {

    public class applicationException extends Exception {}

    //Check if we are in sandbox
    public static Boolean isSandbox(){
        String sandboxName = DomainParser.parse(DomainCreator.getOrgMyDomainHostname()).getSandboxName();
        boolean isSandbox = false;
        if(!String.isEmpty(sandboxName)){
            isSandbox = true;
        }
        return isSandbox;
    }

    //Génetate Token authentification Kaldom
    public static HttpResponse apiLogin() { 
        HttpRequest req = new HttpRequest();
        if (isSandbox()) {
            req.setEndpoint('callout:Kaldom/authenticate'); //informations connexion presente in name credential 
        }else{
            req.setEndpoint('callout:Kaldom/authenticate');
        }
        Http http = new Http();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody('{"_email" : "' + '{!$Credential.UserName}' + '","_password": "' + '{!$Credential.Password}' + '"}');
        return http.send(req);
    }


    //Parse authentification to get token string
    public static String returnToken(){
        HttpResponse hs = new HttpResponse();	
        hs = KaldomWebService.apiLogin();
        if (hs.getStatusCode() != 200) {
            throw new applicationException('KaldomWebService: Error call authentification, codeStatus:'+ hs.getStatusCode()+'; '+ hs.getBody());
        }
        Map<String, Object> bodyJson = (Map<String, Object>)JSON.deserializeUntyped(hs.getBody());
        String token = (String)bodyJson.get('response');
        return token;
    }

    

    //get all invoice present in Kaldom between startDate and endDate
    public static HttpResponse getFactureByDate(String startDate, String endDate) {    
        String token = KaldomWebService.returnToken();
        String body = '{"jwt": "'+token+'"}';
        if(Test.isRunningTest()){
            Test.setMock(HttpCalloutMock.class, new MockInvoiceKaldom());
        }
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        if (isSandbox()) {
            req.setEndpoint('callout:Kaldom/invoice/'+ startDate+'/' + endDate + '.json');
        }else{
            req.setEndpoint('callout:Kaldom/invoice/'+ startDate+'/' + endDate + '.json');
        }
        
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(body);  	
        return http.send(req);
    }
}