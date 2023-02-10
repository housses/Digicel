global class TelesoftWebService {

    /*
    * Method to retrieve the name of the named credential based on organization's sandbox status.
    * @return String wth the value of the named credential
    */
    global static String getNamedCredentialBasedOnOrg(){
        Boolean isSandBox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        String response;
        if(isSandBox) {
            // response = 'Telesoft_Dev';
            response = 'Telesoft_Prod';
        } else {
            response = 'Telesoft_Prod';
        }
        return response;
    }

    /*
    * Method to retrieve all accounts of Telesoft database.
    * @return HttpResponse with all Telesoft accounts information.
    */
    global static HttpResponse getAllAccounts() {  
        String namedCredential = TelesoftWebService.getNamedCredentialBasedOnOrg();

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:' + namedCredential + '/ssl/webservices/v2/cus.json');
        req.setMethod('GET');
        req.setTimeout(120000);
        Http http = new Http();     //ajouter des test en fonction du retour de statut de TelesoftWebService.getAllAccounts().getStatusCode()
        HttpResponse response = new HttpResponse();

        try {
            response = http.send(req);
            if (response.getStatusCode() != 200){
                throw new MyException('Error Telesoft server : status code : ' + response.getStatusCode() );
            } 
        } catch(Exception e){
            throw new MyException('Error from TelesoftWebService.getAllAccounts() Method => ' + e.getMessage() );
        }  
        return response;
    }

    /**
     * This method returns the invoices data from Telesoft web service by given date range.
     * 
     * @param dateDebut String the start date of the range
     * @param dateFin String  the end date of the range
     * @return HttpResponse the response from Telesoft web service
     */
    public static HttpResponse apiReturnFacturesByDate(String dateDebut, String dateFin) { 
        String namedCredential = TelesoftWebService.getNamedCredentialBasedOnOrg();

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:' + namedCredential + '/ssl/webservices/v1/rep/212.json?dat_deb=' + dateDebut + '&dat_fin=' + dateFin );
        req.setMethod('GET');
        req.setTimeout(120000);
        Http http = new Http(); 
        HttpResponse response = new HttpResponse();

        try {
            response = http.send(req);
            if (response.getStatusCode() != 200){
                throw new MyException('Error Telesoft server : status code : ' + response.getStatusCode() );
            } 
        } catch(Exception e){
            throw new MyException('Error from TelesoftWebService.apiReturnFacturesByDate() Method => ' + e.getMessage());
        }  
        return response;
    }
}