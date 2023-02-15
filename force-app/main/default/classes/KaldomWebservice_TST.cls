@isTest
public class KaldomWebservice_TST {
    @isTest 
    static void testCalloutApiLogin() {
        Test.setMock(HttpCalloutMock.class, new MockInvoiceKaldom());
        HttpResponse res = KaldomWebService.apiLogin();
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{'+
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
		'}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }

    @isTest 
    static void getFactureByDate() {

        Test.setMock(HttpCalloutMock.class, new MockLoginKaldom()); 
        // Test.setMock(HttpCalloutMock.class, new MockInvoiceKaldom());

        Test.startTest();
        HttpResponse res = KaldomWebService.getFactureByDate('2022-01-01', '2022-08-01');
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{'+
		'    "code": 200,'+
		'    "response": {'+
		'        "factures": ['+
		'            {'+
		'                "facture_id": "256255",'+
		'                "client_id": "2590",'+
		'                "devise": "EUR",'+
		'                "date_comptabilisation": "2022-02-14 00:00:00",'+
		'                "montant_ht": "1465.74",'+
		'                "montant_tva": "124.59",'+
		'                "montant_ttc": "1590.33",'+
		'                "date_echeance": "2022-03-16 00:00:00",'+
		'                "mode_de_paiement": "Virement",'+
		'                "date_creation": "2022-02-14 11:37:26"'+
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
		'                "date_creation": "2022-07-05 11:05:54"'+
		'            }'+
		'        ]'+
		'    },'+
		'    "timestamp": 1658414641'+
		'}';
        Test.stopTest();

        // System.assertEquals(actualValue, expectedValue);
        // System.assertEquals(200, res.getStatusCode());
    }
   
    @isTest 
    static void testCalloutGetToken() {
        Test.setMock(HttpCalloutMock.class, new MockLoginKaldom());
        String token = KaldomWebService.returnToken();
    }
}