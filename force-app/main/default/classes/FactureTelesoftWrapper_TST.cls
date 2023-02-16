@IsTest
public class FactureTelesoftWrapper_TST {
	
	// This test method should give 100% coverage
	@isTest
	public static void testParse() {
		String json = JsonFactory.jsonInvoiceTelesoft;
		List<FactureTelesoftWrapper> r = FactureTelesoftWrapper.parse(json);
		System.assert(r != null, 'r should not be null');

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		FactureTelesoftWrapper objFactureTelesoftWrapper = new FactureTelesoftWrapper(System.JSON.createParser(json));
		System.assert(objFactureTelesoftWrapper != null, 'objFactureTelesoftWrapper should not be null');
		System.assert(objFactureTelesoftWrapper.Type == null, 'objFactureTelesoftWrapper.Type should be null');
		System.assert(objFactureTelesoftWrapper.Id_facture == null, 'objFactureTelesoftWrapper.Id_Facture should be null');
		System.assert(objFactureTelesoftWrapper.Date_facture == null, 'objFactureTelesoftWrapper.Date_Facture should be null');
		System.assert(objFactureTelesoftWrapper.Debut_periode_facturee == null, 'objFactureTelesoftWrapper.Debut_periode_facturee should be null');
		System.assert(objFactureTelesoftWrapper.Fin_periode_facturee == null, 'objFactureTelesoftWrapper.Fin_periode_facturee should be null');
		System.assert(objFactureTelesoftWrapper.Id_client == null, 'objFactureTelesoftWrapper.Id_client should be null');
		System.assert(objFactureTelesoftWrapper.Taux_TVA == null, 'objFactureTelesoftWrapper.Taux_TVA should be null');
		System.assert(objFactureTelesoftWrapper.Prix_HT == null, 'objFactureTelesoftWrapper.Prix_HT should be null');
	}
}