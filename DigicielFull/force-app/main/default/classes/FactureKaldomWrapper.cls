public class FactureKaldomWrapper {
	public class Response {
		public List<Factures> factures {get;set;} 

		public Response(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'factures') {
							factures = arrayOfFactures(parser);
						} else {
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public Integer code {get;set;} 
	public Response response {get;set;} 
	public Integer timestamp {get;set;} 

	public FactureKaldomWrapper(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'code') {
						code = parser.getIntegerValue();
					} else if (text == 'response') {
						response = new Response(parser);
					} else if (text == 'timestamp') {
						timestamp = parser.getIntegerValue();
					} else {
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Factures {
		public String facture_id {get;set;} 
		public String client_id {get;set;} 
		public String devise {get;set;} 
		public String date_comptabilisation {get;set;} 
		public String montant_ht {get;set;} 
		public String montant_tva {get;set;} 
		public String montant_ttc {get;set;} 
		public String date_echeance {get;set;} 
		public String mode_de_paiement {get;set;} 
		public String date_creation {get;set;} 
		public String siren {get;set;}
		public String numero_facture {get;set;}
	
		public Factures(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'facture_id') {
							facture_id = parser.getText();
						} else if (text == 'client_id') {
							client_id = parser.getText();
						} else if (text == 'siren') {
							siren = parser.getText();
						} else if (text == 'no_facture') {
							numero_facture = parser.getText();
						} else if (text == 'devise') {
							devise = parser.getText();
						} else if (text == 'date_comptabilisation') {
							date_comptabilisation = parser.getText();
						} else if (text == 'montant_ht') {
							montant_ht = parser.getText();
						} else if (text == 'montant_tva') {
							montant_tva = parser.getText();
						} else if (text == 'montant_ttc') {
							montant_ttc = parser.getText();
						} else if (text == 'date_echeance') {
							date_echeance = parser.getText();
						} else if (text == 'mode_de_paiement') {
							mode_de_paiement = parser.getText();
						} else if (text == 'date_creation') {
							date_creation = parser.getText();
						} else {
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static FactureKaldomWrapper parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new FactureKaldomWrapper(parser);
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
	

    private static List<Factures> arrayOfFactures(System.JSONParser p) {
        List<Factures> res = new List<Factures>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Factures(p));
        }
        return res;
    }


}