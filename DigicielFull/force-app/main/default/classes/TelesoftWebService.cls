global class TelesoftWebService {
    //ajouter une description de cette methode + reprendre la doc pour detailler les differentes methodes
    global static HttpResponse getAllAccounts() {  
        Boolean isSandBox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        String URL;
        if(isSandBox) {
            URL = 'https://digicel.preprod-facturationtelecom.fr'; //faire des custom metadata avec deux enregistrement 1 pour la prod et un pour la pre
        } else {
            URL = system.Label.Api_Telesoft_Url_Prod; 
        }
       
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL + '/ssl/webservices/v2/cus.json');    // a mettre dans le custom metadata ou dans un custom label    
        req.setMethod('GET');
        req.setTimeout(120000);
        String username = system.Label.Api_Telesoft_Username; //a mettre dans le metadata car peux être different en fonction des environnement 
        String password = system.Label.Api_TeleSoft_Password; //pareil
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        Http http = new Http();     //ajouter des test en fonction du retour de statut de TelesoftWebService.getAllAccounts().getStatusCode()
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