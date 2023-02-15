global class MockInvoiceKaldom implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{'+
		'    "code": 200,'+
		'    "response": {'+
		'        "factures": ['+
		'            {'+
		'                "facture_id": "256255",'+
		'                "client_id": "2590",'+
		'                "devise": "EUR",'+
		'                "date_comptabilisation": "2021-02-14 00:00:00",'+
		'                "montant_ht": "1465.74",'+
		'                "montant_tva": "124.59",'+
		'                "montant_ttc": "1590.33",'+
		'                "date_echeance": "2021-03-16 00:00:00",'+
		'                "mode_de_paiement": "Virement",'+
		'                "siren": "510464001",'+
		'                "date_creation": "2021-02-14 11:37:26"'+
		'            },'+
		'            {'+
		'                "facture_id": "264049",'+
		'                "client_id": "2590",'+
		'                "devise": "EUR",'+
		'                "date_comptabilisation": "2022-07-01 00:00:00",'+
		'                "montant_ht": "10.78",'+
		'                "montant_tva": "0.92",'+
		'                "montant_ttc": "11.70",'+
		'                "date_echeance": "2022-07-31 00:00:00",'+
		'                "mode_de_paiement": "Virement",'+
		'                "siren": "510464001",'+
		'                "date_creation": "2022-07-05 11:05:54"'+
		'            }'+
		'        ]'+
		'    },'+
		'    "timestamp": 1658414641'+
		'}');
        res.setStatusCode(200);
        return res;
    }
}