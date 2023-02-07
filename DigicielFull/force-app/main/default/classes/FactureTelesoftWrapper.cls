public class FactureTelesoftWrapper {

	public String Type {get;set;} 
	public String Id_facture {get;set;}
	public String Date_facture {get;set;} 	
	public String Debut_periode_facturee {get;set;} 
	public String Fin_periode_facturee {get;set;} 
	public String Id_client {get;set;} 
	public String Id_produit {get;set;}
	public String Taux_TVA {get;set;} 
	public String Prix_HT {get;set;} 
	public String Compte_client {get;set;} 

	public FactureTelesoftWrapper(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'Type') {
						Type = parser.getText();
					} else if (text == 'Id. facture') {
						Id_facture = parser.getText();
					} else if (text == 'Id. produit') {
						Id_produit = parser.getText();
					} else if (text == 'Date facture') {
						Date_facture = parser.getText();		
					} else if (text == 'Compte client') {
						Compte_client = parser.getText();					
					} else if (text == 'Début période facturée') {
						Debut_periode_facturee = parser.getText();
					} else if (text == 'Fin période facturée') {
						Fin_periode_facturee = parser.getText();
					} else if (text == 'Id. client') {
						Id_client = parser.getText();
					} else if (text == 'Taux de TVA') {
						Taux_TVA = parser.getText();
					} else if (text == 'Prix de vente HT') {
						Prix_HT = parser.getText();
					} else {
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static List<FactureTelesoftWrapper> parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return arrayOfFactureTelesoftWrapper(parser);
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
	


    private static List<FactureTelesoftWrapper> arrayOfFactureTelesoftWrapper(System.JSONParser p) {
        List<FactureTelesoftWrapper> res = new List<FactureTelesoftWrapper>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new FactureTelesoftWrapper(p));
        }
        return res;
    }


}