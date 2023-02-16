@IsTest
public class FactureKaldomWrapper_TST {
	
	@isTest
	public static void testParse() {
		String json = JsonFactory.jsonInvoiceKaldom;
		FactureKaldomWrapper r = FactureKaldomWrapper.parse(json);
		System.assert(r != null, 'r should not be null');

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		FactureKaldomWrapper.Response objResponse = new FactureKaldomWrapper.Response(System.JSON.createParser(json));
		System.assert(objResponse != null, 'objResponse should not be null');
		System.assert(objResponse.factures == null, 'bjResponse.factures should not be null');

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		FactureKaldomWrapper objFactureKaldomWrapper = new FactureKaldomWrapper(System.JSON.createParser(json));
		System.assert(objFactureKaldomWrapper != null, 'objClientTelesoftWrapper should not be null');
		System.assert(objFactureKaldomWrapper.code == null, 'objFactureKaldomWrapper.code should be null');
		System.assert(objFactureKaldomWrapper.response == null, 'objFactureKaldomWrapper.response should be null');
		System.assert(objFactureKaldomWrapper.timestamp == null, 'objFactureKaldomWrapper.timestamp should be null');

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		FactureKaldomWrapper.Factures objFactures = new FactureKaldomWrapper.Factures(System.JSON.createParser(json));
		System.assert(objFactures != null, 'objFactures should not be null');
		System.assert(objFactures.facture_id == null, 'objFactures.facture_id should be null');
		System.assert(objFactures.client_id == null, 'objFactures.client_id should be null');
		System.assert(objFactures.devise == null, 'objFactures.devise should be null');
		System.assert(objFactures.date_comptabilisation == null, 'objFactures.date_comptabilisation should be null');
		System.assert(objFactures.montant_ht == null, 'objFactures.montant_ht should be null');
		System.assert(objFactures.montant_tva == null, 'objFactures.montant_tva should be null');
		System.assert(objFactures.montant_ttc == null, 'objFactures.montant_ttc should be null');
		System.assert(objFactures.date_echeance == null, 'objFactures.date_echeance should be null');
		System.assert(objFactures.mode_de_paiement == null, 'objFactures.mode_de_paiement should be null');
		System.assert(objFactures.date_creation == null, 'objFactures.date_cation should be null');
	}
}