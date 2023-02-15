@isTest 
private class TelesoftWebservice_TST {

    @isTest static void testCalloutGetAllAccount() {
        Test.setMock(HttpCalloutMock.class, new MockClientTelesoft_TST());
        HttpResponse res = TelesoftWebService.getAllAccounts();
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '['+
		'    {'+
		'        \"cus_ide\": 50003,'+
		'        \"swi_ide\": \"swidl\",'+
		'        \"cus_cpt\": "50003",'+
		'        \"cus_sir\": \"509124798\",'+
		'        \"cus_dat\": \"2014-03-01\",'+
		'        \"cus_soc\": \"SAMAC Aéroport TEST\",'+
		'        \"cus_con_gen\": \"Monsieur\",'+
		'        \"cus_con_pre\": \"Jean-Luc\",'+
		'        \"cus_con_nom\": \"NESTORET\",'+
		'        \"cus_con_fon\": \"Responsable Informatique & Telecoms\",'+
		'        \"cus_con_ad1\": \"Aéroport Aimé Césaire BP 279\",'+
		'        \"cus_con_ad2\": \"MARTINIQUE\",'+
		'        \"cus_con_ad3\": \"Debut\",'+
		'        \"cus_con_cpo\": \"97285\",'+
		'        \"cus_con_vil\": \"Lamentin Cedex 2\",'+
		'        \"cus_con_pay\": \"Martinique\",'+
		'        \"cus_con_tel\": \"0596 55 28 69\",'+
		'        \"cus_con_gsm\": null,'+
		'        \"cus_con_fax\": null,'+
		'        \"cus_con_mai\": \"jl.nestoret@martinique.aeroport.fr\",'+
		'        \"cus_fac_ser\": null,'+
		'        \"cus_fac_ad1\": \"Aéroport Aimé Césaire BP 279\",'+
		'        \"cus_fac_ad2\": null,'+
		'        \"cus_fac_ad3\": null,'+
		'        \"cus_fac_cpo\": \"97285\",'+
		'        \"cus_fac_vil\": \"Lamentin Cedex 2\",'+
		'        \"cus_fac_pay\": \"Martinique\",'+
		'        \"cus_fac_mai\": \"jl.nestoret@martinique.aeroport.fr\",'+
		'        \"cus_fac_det\": 1,'+
		'        \"cus_fac_sta\": 1,'+
		'        \"cus_fac_pre\": 1,'+
		'        \"cus_fac_rib\": null,'+
		'        \"cus_fac_rem_typ\": null,'+
		'        \"cus_fac_rem_mon\": 0,'+
		'        \"cus_fac_tva_tau\": 850,'+
		'        \"cus_use\": \"SAMAC\",'+
		'        \"cus_pwd\": \"Digicel*\",'+
		'        \"acces_compte_autorise\": 1,'+
		'        \"gra_lib\": \"Client\",'+
		'        \"cus_fac_ban\": \"\",'+
		'        \"cus_fac_csv\": 0,'+
		'        \"reg_ide\": \"PRE\",'+
		'        \"reg_swi_ide\": \"swidl\",'+
		'        \"cus_res\": 1,'+
		'        \"cus_per\": 1,'+
		'        \"cus_mar\": \"swidl\",'+
		'        \"cus_fac_rem_typ_cal\": null,'+
		'        \"nap_mas\": 4,'+
		'        \"cus_con_lan\": \"FRA\",'+
		'        \"cus_ape\": null,'+
		'        \"cus_fac_bic\": \"BNPAMQMXXXX\",'+
		'        \"cus_fac_ibn\": \"FR7613088090900071700008344\",'+
		'        \"cus_ban_001\": \"\",'+
		'        \"cus_ban_002\": null,'+
		'        \"cus_ban_003\": null,'+
		'        \"cus_ban_004\": \"\",'+
		'        \"cus_ban_005\": \"\",'+
		'        \"cus_fac_rum\": \"123654789\",'+
		'        \"cus_fac_rum_dat\": \"2014-01-31\",'+
		'        \"cus_sep_pre_rec\": 0,'+
		'        \"cus_sir_ren\": \"510464001\",'+
		'        \"cus_not_mai\": 0,'+
		'        \"cus_tva_int_com\": null,'+
		'        \"password_token\": null,'+
		'        \"password_token_date\": null,'+
		'        \"password_must_reset\": 1,'+
		'        \"password_last_update\": \"2018-11-27\",'+
		'        \"overloadSwi\": null,'+
		'        \"IdTvaProfile\": null,'+
		'        \"Territorialite\": \"france\"'+
		'    }]';
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