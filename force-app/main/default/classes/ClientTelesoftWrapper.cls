public class ClientTelesoftWrapper {

	public Integer cus_ide {get;set;} 
	public String cus_cpt {get;set;} 
	public String cus_sir_ren {get;set;} 

	public ClientTelesoftWrapper(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'cus_ide') {
						cus_ide = parser.getIntegerValue();
					} else if (text == 'cus_cpt') {
						cus_cpt = parser.getText();
					} else if (text == 'cus_sir_ren') {
						cus_sir_ren = parser.getText();
					} else {
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static List<ClientTelesoftWrapper> parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return arrayOfClientTelesoftWrapper(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}

    private static List<ClientTelesoftWrapper> arrayOfClientTelesoftWrapper(System.JSONParser p) {
        List<ClientTelesoftWrapper> res = new List<ClientTelesoftWrapper>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ClientTelesoftWrapper(p));
        }
        return res;
    }



}