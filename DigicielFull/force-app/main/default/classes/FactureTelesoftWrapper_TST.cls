@IsTest
public class FactureTelesoftWrapper_TST {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '['+
		'    {'+
		'        \"Type\": \"Abonnement/Charge sur client\",'+
		'        \"Id. facture\": \"DBS20220624185\",'+
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
		'        \"Début période facturée\": \"00/00/0000\",'+
		'        \"Fin période facturée\": \"00/00/0000\",'+
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
		'        \"Compte client\": \"TEST\",'+
		'        \"Id .Marque\": \"swidl\",'+
		'        \"Libellé Marque\": \"DIGICEL Business AFG\",'+
		'        \"Affiché sur facture\": \"Oui\",'+
		'        \"Numéro de marché\": \"\",'+
		'        \"Régime fiscal\": \"MARTINIQUE\",'+
		'        \"Facturation\": \"Debut\"'+
		'    },'+
		'    {'+
		'        \"Type\": \"Abonnement/Charge sur client\",'+
		'        \"Id. facture\": \"DBS20220624185\",'+
		'        \"Compte de facturation : Id.\": null,'+
		'        \"Compte de facturation : libellé\": null,'+
		'        \"Date facture\": \"27/06/2022\",'+
		'        \"Désignation\": \"Digicel Business Housing 1/4Baie\",'+
		'        \"Prix unitaire HT\": \"-569,0000\",'+
		'        \"Quantité\": \"1,0000\",'+
		'        \"Volume [nombre appels]\": null,'+
		'        \"Volume [durée appels]\": null,'+
		'        \"Unité\": null,'+
		'        \"Id. produit\": \"DBH_Digicel Business Housing 1/4Baie\",'+
		'        \"Libellé produit\": \"Digicel Business Housing 1/4Baie\",'+
		'        \"Code comptable\": \"706400 -FW-1010-96006-94\",'+
		'        \"Éligible empreinte carbone\": \"Non\",'+
		'        \"Id. opérateur\": \"Digicel 20220614\",'+
		'        \"Libellé opérateur\": \"Digicel 20220614\",'+
		'        \"Id. offre opérateur\": \"Cloud and Datacenter\",'+
		'        \"Libellé offre opérateur\": \"Cloud and Datacenter\",'+
		'        \"Id. famille\": \"Digicel Business Housing\",'+
		'        \"Libellé famille\": \"Digicel Business Housing\",'+
		'        \"Type achat / vente\": \"vente,achat\",'+
		'        \"Début période facturée\": \"00/00/0000\",'+
		'        \"Fin période facturée\": \"00/00/0000\",'+
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
		'        \"Prix de vente HT\": \"-569,0000\",'+
		'        \"Prix d\'achat HT\": \"0,0000\",'+
		'        \"Marge\": \"-569,0000\",'+
		'        \"Compte client\": \"TEST\",'+
		'        \"Id .Marque\": \"swidl\",'+
		'        \"Libellé Marque\": \"DIGICEL Business AFG\",'+
		'        \"Affiché sur facture\": \"Oui\",'+
		'        \"Numéro de marché\": \"\",'+
		'        \"Régime fiscal\": \"MARTINIQUE\",'+
		'        \"Facturation\": \"Debut\"'+
		'    },'+
		'    {'+
		'        \"Type\": \"Abonnement/Charge sur site\",'+
		'        \"Id. facture\": \"DBS20220624186\",'+
		'        \"Compte de facturation : Id.\": null,'+
		'        \"Compte de facturation : libellé\": null,'+
		'        \"Date facture\": \"27/06/2022\",'+
		'        \"Désignation\": \"Frais d\'installation Fibre Optique > 10Mbps\",'+
		'        \"Prix unitaire HT\": \"6 526,0000\",'+
		'        \"Quantité\": \"1,0000\",'+
		'        \"Volume [nombre appels]\": null,'+
		'        \"Volume [durée appels]\": null,'+
		'        \"Unité\": null,'+
		'        \"Id. produit\": \"DBI_FAS Fibre Optique > 10Mbps\",'+
		'        \"Libellé produit\": \"Frais d\'installation Fibre Optique > 10Mbps\",'+
		'        \"Code comptable\": \"706401 -FW-1010-96000-95\",'+
		'        \"Éligible empreinte carbone\": \"Non\",'+
		'        \"Id. opérateur\": \"Digicel 20220614\",'+
		'        \"Libellé opérateur\": \"Digicel 20220614\",'+
		'        \"Id. offre opérateur\": \"OTC\",'+
		'        \"Libellé offre opérateur\": \"OTC\",'+
		'        \"Id. famille\": \"Vos abonnements [Digicel]\",'+
		'        \"Libellé famille\": \"Vos abonnements [Digicel]\",'+
		'        \"Type achat / vente\": \"vente,achat\",'+
		'        \"Début période facturée\": \"00/00/0000\",'+
		'        \"Fin période facturée\": \"00/00/0000\",'+
		'        \"Ressource appelante\": null,'+
		'        \"Libellé ressource appelante\": null,'+
		'        \"Zone appelante\": null,'+
		'        \"Zone appelé\": null,'+
		'        \"Direction\": null,'+
		'        \"Unité oeuvre\": null,'+
		'        \"Id. groupement\": \"site-20220628172738\",'+
		'        \"Libellé groupement\": \"Piscine Intercommunale - Natation - BAIMBRIDGE\",'+
		'        \"Type groupement\": \"site\",'+
		'        \"Id. client\": \"50709\",'+
		'        \"Raison sociale\": \"COMITE REGIONAL OLYMPIQUE SPORT GPE\",'+
		'        \"Référent interne\": \" [SAROTTE Lionel] \",'+
		'        \"Référent externe\": \"\",'+
		'        \"Début facturabilité abonnement\": \"01/01/2000\",'+
		'        \"Périodicité\": \"Mensuelle\",'+
		'        \"Terme\": \"Sans prorata\",'+
		'        \"Prorata\": \"100,0000\",'+
		'        \"Taux de TVA\": \"8,5000\",'+
		'        \"Prix de vente HT\": \"6 526,0000\",'+
		'        \"Prix d\'achat HT\": \"0,0000\",'+
		'        \"Marge\": \"6 526,0000\",'+
		'        \"Compte client\": \"DBSG1238\",'+
		'        \"Id .Marque\": \"swidl\",'+
		'        \"Libellé Marque\": \"DIGICEL Business AFG\",'+
		'        \"Affiché sur facture\": \"Oui\",'+
		'        \"Numéro de marché\": \"\",'+
		'        \"Régime fiscal\": \"GUADELOUPE\",'+
		'        \"Facturation\": \"Debut\"'+
		'    },'+
		'    {'+
		'        \"Type\": \"Abonnement/Charge sur site\",'+
		'        \"Id. facture\": \"DBS20220624186\",'+
		'        \"Compte de facturation : Id.\": null,'+
		'        \"Compte de facturation : libellé\": null,'+
		'        \"Date facture\": \"27/06/2022\",'+
		'        \"Désignation\": \"Frais d\'installation Fibre Optique > 10Mbps\",'+
		'        \"Prix unitaire HT\": \"757,0000\",'+
		'        \"Quantité\": \"1,0000\",'+
		'        \"Volume [nombre appels]\": null,'+
		'        \"Volume [durée appels]\": null,'+
		'        \"Unité\": null,'+
		'        \"Id. produit\": \"DBI_FAS Fibre Optique > 10Mbps\",'+
		'        \"Libellé produit\": \"Frais d\'installation Fibre Optique > 10Mbps\",'+
		'        \"Code comptable\": \"706401 -FW-1010-96000-95\",'+
		'        \"Éligible empreinte carbone\": \"Non\",'+
		'        \"Id. opérateur\": \"Digicel 20220614\",'+
		'        \"Libellé opérateur\": \"Digicel 20220614\",'+
		'        \"Id. offre opérateur\": \"OTC\",'+
		'        \"Libellé offre opérateur\": \"OTC\",'+
		'        \"Id. famille\": \"Vos abonnements [Digicel]\",'+
		'        \"Libellé famille\": \"Vos abonnements [Digicel]\",'+
		'        \"Type achat / vente\": \"vente,achat\",'+
		'        \"Début période facturée\": \"00/00/0000\",'+
		'        \"Fin période facturée\": \"00/00/0000\",'+
		'        \"Ressource appelante\": null,'+
		'        \"Libellé ressource appelante\": null,'+
		'        \"Zone appelante\": null,'+
		'        \"Zone appelé\": null,'+
		'        \"Direction\": null,'+
		'        \"Unité oeuvre\": null,'+
		'        \"Id. groupement\": \"site-20220628172738\",'+
		'        \"Libellé groupement\": \"Piscine Intercommunale - Natation - BAIMBRIDGE\",'+
		'        \"Type groupement\": \"site\",'+
		'        \"Id. client\": \"50709\",'+
		'        \"Raison sociale\": \"COMITE REGIONAL OLYMPIQUE SPORT GPE\",'+
		'        \"Référent interne\": \" [SAROTTE Lionel] \",'+
		'        \"Référent externe\": \"\",'+
		'        \"Début facturabilité abonnement\": \"02/01/2000\",'+
		'        \"Périodicité\": \"Mensuelle\",'+
		'        \"Terme\": \"Sans prorata\",'+
		'        \"Prorata\": \"100,0000\",'+
		'        \"Taux de TVA\": \"8,5000\",'+
		'        \"Prix de vente HT\": \"757,0000\",'+
		'        \"Prix d\'achat HT\": \"0,0000\",'+
		'        \"Marge\": \"757,0000\",'+
		'        \"Compte client\": \"DBSG1238\",'+
		'        \"Id .Marque\": \"swidl\",'+
		'        \"Libellé Marque\": \"DIGICEL Business AFG\",'+
		'        \"Affiché sur facture\": \"Oui\",'+
		'        \"Numéro de marché\": \"\",'+
		'        \"Régime fiscal\": \"GUADELOUPE\",'+
		'        \"Facturation\": \"Debut\"'+
		'    }'+
		']';
		List<FactureTelesoftWrapper> r = FactureTelesoftWrapper.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		FactureTelesoftWrapper objFactureTelesoftWrapper = new FactureTelesoftWrapper(System.JSON.createParser(json));
		System.assert(objFactureTelesoftWrapper != null);
		System.assert(objFactureTelesoftWrapper.Type == null);
		System.assert(objFactureTelesoftWrapper.Id_facture == null);
		System.assert(objFactureTelesoftWrapper.Date_facture == null);
		System.assert(objFactureTelesoftWrapper.Debut_periode_facturee == null);
		System.assert(objFactureTelesoftWrapper.Fin_periode_facturee == null);
		System.assert(objFactureTelesoftWrapper.Id_client == null);
		System.assert(objFactureTelesoftWrapper.Taux_TVA == null);
		System.assert(objFactureTelesoftWrapper.Prix_HT == null);
	}
}