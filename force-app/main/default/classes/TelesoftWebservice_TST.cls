@isTest 
private class TelesoftWebservice_TST {

    @isTest static void testCalloutGetAllAccount() {
        Test.setMock(HttpCalloutMock.class, new MockFactory_TST('MockClientTelesoft'));
        HttpResponse res = TelesoftWebService.getAllAccounts();
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = JsonFactory.jsonClientTelesoft;
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }

    @isTest static void testCalloutGetFacturesByDate() {
        Test.setMock(HttpCalloutMock.class, new MockInvoiceTelesoft_TST());
        HttpResponse res = TelesoftWebService.apiReturnFacturesByDate('2022-07-02','2022-07-12');
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '['+
		'    {'+
		'        \"Type\": \"Abonnement/Charge sur client\",'+
		'        \"Id. facture\": \"DBS20220624185\",'+
		'        \"Compte de facturation : Id.\": null,'+
		'        \"Compte de facturation : libellé\": null,'+
		'        \"Date facture\": \"27/06/2021\",'+
		'        \"Désignation\": \"Microsoft 365 PME Business Basic\",'+
		'        \"Prix unitaire HT\": \"-4,2000\",'+
		'        \"Quantité\": \"1,0000\",'+
		'        \"Volume [nombre appels]\": null,'+
		'        \"Volume [durée appels]\": null,'+
		'        \"Unité\": null,'+
		'        \"Id. produit\": \"MS365_PME _ Business Basic\",'+
		'        \"Libellé produit\": \"Microsoft 365 PME Business Basic\",'+
		'        \"Code comptable\": \"706401 -FW-1010-96015-95\",'+
		'        \"Éligible empreinte carbone\": \"Non\",'+
		'        \"Id. opérateur\": \"Digicel 20220614\",'+
		'        \"Libellé opérateur\": \"Digicel 20220614\",'+
		'        \"Id. offre opérateur\": \"Cloud and Collaboration\",'+
		'        \"Libellé offre opérateur\": \"Cloud and Collaboration\",'+
		'        \"Id. famille\": \"Microsoft 365 - PME\",'+
		'        \"Libellé famille\": \"Microsoft 365 - PME\",'+
		'        \"Type achat / vente\": \"vente,achat\",'+
		'        \"Début période facturée\": \"01/01/2020\",'+
		'        \"Fin période facturée\": \"01/01/2020\",'+
		'        \"Ressource appelante\": null,'+
		'        \"Libellé ressource appelante\": null,'+
		'        \"Zone appelante\": null,'+
		'        \"Zone appelé\": null,'+
		'        \"Direction\": null,'+
		'        \"Unité oeuvre\": null,'+
		'        \"Id. groupement\": null,'+
		'        \"Libellé groupement\": null,'+
		'        \"Type groupement\": null,'+
		'        \"Id. client\": \"50092\",'+
		'        \"Raison sociale\": \"DIGICEL\",'+
		'        \"Référent interne\": null,'+
		'        \"Référent externe\": null,'+
		'        \"Début facturabilité abonnement\": \"01/01/2000\",'+
		'        \"Périodicité\": \"Mensuelle\",'+
		'        \"Terme\": \"Sans prorata\",'+
		'        \"Prorata\": \"100,0000\",'+
		'        \"Taux de TVA\": \"8,5000\",'+
		'        \"Prix de vente HT\": \"-4,2000\",'+
		'        \"Prix d\'achat HT\": \"0,0000\",'+
		'        \"Marge\": \"-4,2000\",'+
		'        \"Compte client\": \"50092\",'+
		'        \"Id .Marque\": \"swidl\",'+
		'        \"Libellé Marque\": \"DIGICEL Business AFG\",'+
		'        \"Affiché sur facture\": \"Oui\",'+
		'        \"Numéro de marché\": \"\",'+
		'        \"Régime fiscal\": \"MARTINIQUE\",'+
		'        \"Facturation\": \"Debut\"'+
		'    },'+
		'    {'+
		'        \"Type\": \"A\",'+
		'        \"Id. facture\": \"DBS20220624185\",'+
		'        \"Compte de facturation : Id.\": null,'+
		'        \"Compte de facturation : libellé\": null,'+
		'        \"Date facture\": \"27/06/2021\",'+
		'        \"Désignation\": \"Microsoft 365 PME Business Basic\",'+
		'        \"Prix unitaire HT\": \"-4,2000\",'+
		'        \"Quantité\": \"1,0000\",'+
		'        \"Volume [nombre appels]\": null,'+
		'        \"Volume [durée appels]\": null,'+
		'        \"Unité\": null,'+
		'        \"Id. produit\": \"MS365_PME _ Business Basic\",'+
		'        \"Libellé produit\": \"Microsoft 365 PME Business Basic\",'+
		'        \"Code comptable\": \"706401 -FW-1010-96015-95\",'+
		'        \"Éligible empreinte carbone\": \"Non\",'+
		'        \"Id. opérateur\": \"Digicel 20220614\",'+
		'        \"Libellé opérateur\": \"Digicel qddqsd\",'+
		'        \"Id. offre opérateur\": \"Cloud and Collaqsdqddsdqdqsdboration\",'+
		'        \"Libellé offre opérateur\": \"Cloud and Collaboration\",'+
		'        \"Id. famille\": \"Microsoft 365 - PME\",'+
		'        \"Libellé famille\": \"Microsoft 365 - PME\",'+
		'        \"Type achat / vente\": \"vente,achat\",'+
		'        \"Début période facturée\": \"01/01/2021\",'+
		'        \"Fin période facturée\": \"01/01/2021\",'+
		'        \"Ressource appelante\": null,'+
		'        \"Libellé ressource appelante\": null,'+
		'        \"Zone appelante\": null,'+
		'        \"Zone appelé\": null,'+
		'        \"Direction\": null,'+
		'        \"Unité oeuvre\": null,'+
		'        \"Id. groupement\": null,'+
		'        \"Libellé groupement\": null,'+
		'        \"Type groupement\": null,'+
		'        \"Id. client\": \"50092\",'+
		'        \"Raison sociale\": \"DIGICEL\",'+
		'        \"Référent interne\": null,'+
		'        \"Référent externe\": null,'+
		'        \"Début facturabilité abonnement\": \"01/01/2000\",'+
		'        \"Périodicité\": \"Mensuelle\",'+
		'        \"Terme\": \"Sans prorata\",'+
		'        \"Prorata\": \"100,0000\",'+
		'        \"Taux de TVA\": \"8,5000\",'+
		'        \"Prix de vente HT\": \"-4,2000\",'+
		'        \"Prix d\'achat HT\": \"0,0000\",'+
		'        \"Marge\": \"-4,2000\",'+
		'        \"Compte client\": \"50092\",'+
		'        \"Id .Marque\": \"swidl\",'+
		'        \"Libellé Marque\": \"DIGICEL Business AFG\",'+
		'        \"Affiché sur facture\": \"Oui\",'+
		'        \"Numéro de marché\": \"\",'+
		'        \"Régime fiscal\": \"MARTINIQUE\",'+
		'        \"Facturation\": \"Debut\"'+
		'    },'+
		'    {'+
		'        \"Type\": \"Abonnement/Charge sur client\",'+
		'        \"Id. facture\": \"DBS20220624183\",'+
		'        \"Compte de facturation : Id.\": null,'+
		'        \"Compte de facturation : libellé\": null,'+
		'        \"Date facture\": \"27/06/2022\",'+
		'        \"Désignation\": \"Microsoft 365 PME Business Basic\",'+
		'        \"Prix unitaire HT\": \"-4,2000\",'+
		'        \"Quantité\": \"1,0000\",'+
		'        \"Volume [nombre appels]\": null,'+
		'        \"Volume [durée appels]\": null,'+
		'        \"Unité\": null,'+
		'        \"Id. produit\": \"MS365_PME _ Business Basic\",'+
		'        \"Libellé produit\": \"Microsoft 365 PME Business Basic\",'+
		'        \"Code comptable\": \"706401 -FW-1010-96015-95\",'+
		'        \"Éligible empreinte carbone\": \"Non\",'+
		'        \"Id. opérateur\": \"Digicel 20220614\",'+
		'        \"Libellé opérateur\": \"Digicel 20220614\",'+
		'        \"Id. offre opérateur\": \"Cloud and Collaboration\",'+
		'        \"Libellé offre opérateur\": \"Cloud and Collaboration\",'+
		'        \"Id. famille\": \"Microsoft 365 - PME\",'+
		'        \"Libellé famille\": \"Microsoft 365 - PME\",'+
		'        \"Type achat / vente\": \"vente,achat\",'+
		'        \"Début période facturée\": \"01/01/2022\",'+
		'        \"Fin période facturée\": \"01/01/2022\",'+
		'        \"Ressource appelante\": null,'+
		'        \"Libellé ressource appelante\": null,'+
		'        \"Zone appelante\": null,'+
		'        \"Zone appelé\": null,'+
		'        \"Direction\": null,'+
		'        \"Unité oeuvre\": null,'+
		'        \"Id. groupement\": null,'+
		'        \"Libellé groupement\": null,'+
		'        \"Type groupement\": null,'+
		'        \"Id. client\": \"50092\",'+
		'        \"Raison sociale\": \"DIGICEL\",'+
		'        \"Référent interne\": null,'+
		'        \"Référent externe\": null,'+
		'        \"Début facturabilité abonnement\": \"01/01/2000\",'+
		'        \"Périodicité\": \"Mensuelle\",'+
		'        \"Terme\": \"Sans prorata\",'+
		'        \"Prorata\": \"100,0000\",'+
		'        \"Taux de TVA\": \"8,5000\",'+
		'        \"Prix de vente HT\": \"-4,2000\",'+
		'        \"Prix d\'achat HT\": \"0,0000\",'+
		'        \"Marge\": \"-4,2000\",'+
		'        \"Compte client\": \"50092\",'+
		'        \"Id .Marque\": \"swidl\",'+
		'        \"Libellé Marque\": \"DIGICEL Business AFG\",'+
		'        \"Affiché sur facture\": \"Oui\",'+
		'        \"Numéro de marché\": \"\",'+
		'        \"Régime fiscal\": \"MARTINIQUE\",'+
		'        \"Facturation\": \"Debut\"'+
		'    }'+
		']';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
}