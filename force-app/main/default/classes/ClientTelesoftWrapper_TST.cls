@IsTest
public class ClientTelesoftWrapper_TST {
	
	@isTest
	public static void testParse() {
		String json = JsonFactory.jsonClientTelesoft;
		List<ClientTelesoftWrapper> r = ClientTelesoftWrapper.parse(json);
		System.assert(r != null, 'r should not be null');

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';

		ClientTelesoftWrapper objClientTelesoftWrapper = new ClientTelesoftWrapper(System.JSON.createParser(json));
		
		System.assert(objClientTelesoftWrapper != null, 'objClientTelesoftWrapper should not be null');
		System.assert(objClientTelesoftWrapper.cus_ide == null, 'objClientTelesoftWrapper.cus_ide should be null');
		System.assert(objClientTelesoftWrapper.cus_sir_ren == null, 'objClientTelesoftWrapper.cus_sir_ren should be null');
	}
}