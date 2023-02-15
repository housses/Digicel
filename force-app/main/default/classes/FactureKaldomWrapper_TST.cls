@IsTest
public class FactureKaldomWrapper_TST {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"code\": 200,'+
		'    \"response\": {'+
		'        \"factures\": ['+
		'            {'+
		'                \"facture_id\": \"256255\",'+
		'                \"client_id\": \"2590\",'+
		'                \"devise\": \"EUR\",'+
		'                \"date_comptabilisation\": \"2022-02-14 00:00:00\",'+
		'                \"montant_ht\": \"1465.74\",'+
		'                \"montant_tva\": \"124.59\",'+
		'                \"montant_ttc\": \"1590.33\",'+
		'                \"date_echeance\": \"2022-03-16 00:00:00\",'+
		'                \"mode_de_paiement\": \"Virement\",'+
		'                \"date_creation\": \"2022-02-14 11:37:26\"'+
		'            },'+
		'            {'+
		'                \"facture_id\": \"264049\",'+
		'                \"client_id\": \"2590\",'+
		'                \"devise\": \"EUR\",'+
		'                \"date_comptabilisation\": \"2022-07-01 00:00:00\",'+
		'                \"montant_ht\": \"10.78\",'+
		'                \"montant_tva\": \"0.92\",'+
		'                \"montant_ttc\": \"11.70\",'+
		'                \"date_echeance\": \"2022-07-31 00:00:00\",'+
		'                \"mode_de_paiement\": \"Virement\",'+
		'                \"date_creation\": \"2022-07-05 11:05:54\"'+
		'            }'+
		'        ]'+
		'    },'+
		'    \"timestamp\": 1658414641'+
		'}';
		FactureKaldomWrapper r = FactureKaldomWrapper.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		FactureKaldomWrapper.Response objResponse = new FactureKaldomWrapper.Response(System.JSON.createParser(json));
		System.assert(objResponse != null);
		System.assert(objResponse.factures == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		FactureKaldomWrapper objFactureKaldomWrapper = new FactureKaldomWrapper(System.JSON.createParser(json));
		System.assert(objFactureKaldomWrapper != null);
		System.assert(objFactureKaldomWrapper.code == null);
		System.assert(objFactureKaldomWrapper.response == null);
		System.assert(objFactureKaldomWrapper.timestamp == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		FactureKaldomWrapper.Factures objFactures = new FactureKaldomWrapper.Factures(System.JSON.createParser(json));
		System.assert(objFactures != null);
		System.assert(objFactures.facture_id == null);
		System.assert(objFactures.client_id == null);
		System.assert(objFactures.devise == null);
		System.assert(objFactures.date_comptabilisation == null);
		System.assert(objFactures.montant_ht == null);
		System.assert(objFactures.montant_tva == null);
		System.assert(objFactures.montant_ttc == null);
		System.assert(objFactures.date_echeance == null);
		System.assert(objFactures.mode_de_paiement == null);
		System.assert(objFactures.date_creation == null);
	}
}