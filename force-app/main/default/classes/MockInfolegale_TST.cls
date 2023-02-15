global class MockInfolegale_TST implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{'+
		'    \"@context\": \"https://wspreprod.infolegale.fr/v2/schema/xsd/company/score.xsd\",'+
		'    \"@type\": \"Score\",'+
		'    \"rating\": null,'+
		'    \"score\": 6,'+
		'    \"previous\": 4,'+
		'    \"creditLimit\": 500,'+
		'    \"delaiReglementFournisseur\": null,'+
		'    \"delaiReglementFournisseurSecteur\": 44.77,'+
		'    \"comments\": {'+
		'        \"FIN_1\": \"Aucun bilan récent ne nous a été remis, permettant d’analyser la situation financière actuelle. Il faut en tenir compte pour toute entrée en relation commerciale et l’octroi d’un éventuel crédit\",'+
		'        \"NAF_13\": \"Son secteur d’activité a un taux de défaillance équivalent à la moyenne des entreprises\",'+
		'        \"REL_2\": \"Un suivi attentif de l’évolution de l’entreprise est recommandé.\"'+
		'    },'+
		'    \"summary\": null,'+
		'    \"history\": ['+
		'        {'+
		'            \"year\": \"2020\",'+
		'            \"month\": \"07\",'+
		'            \"average_score\": \"4.0\",'+
		'            \"average_score_activity\": \"7.3\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2020\",'+
		'            \"month\": \"08\",'+
		'            \"average_score\": \"4.0\",'+
		'            \"average_score_activity\": \"7.4\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2020\",'+
		'            \"month\": \"09\",'+
		'            \"average_score\": \"4.0\",'+
		'            \"average_score_activity\": \"8.3\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2020\",'+
		'            \"month\": \"10\",'+
		'            \"average_score\": \"4.0\",'+
		'            \"average_score_activity\": \"8.4\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2020\",'+
		'            \"month\": \"11\",'+
		'            \"average_score\": \"4.0\",'+
		'            \"average_score_activity\": \"8.4\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2020\",'+
		'            \"month\": \"12\",'+
		'            \"average_score\": \"4.0\",'+
		'            \"average_score_activity\": \"8.4\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2021\",'+
		'            \"month\": \"01\",'+
		'            \"average_score\": \"4.0\",'+
		'            \"average_score_activity\": \"8.4\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2021\",'+
		'            \"month\": \"02\",'+
		'            \"average_score\": \"4.0\",'+
		'            \"average_score_activity\": \"8.4\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2021\",'+
		'            \"month\": \"03\",'+
		'            \"average_score\": \"4.0\",'+
		'            \"average_score_activity\": \"8.4\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2021\",'+
		'            \"month\": \"04\",'+
		'            \"average_score\": \"4.0\",'+
		'            \"average_score_activity\": \"8.5\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2021\",'+
		'            \"month\": \"05\",'+
		'            \"average_score\": \"4.0\",'+
		'            \"average_score_activity\": \"8.4\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2021\",'+
		'            \"month\": \"06\",'+
		'            \"average_score\": \"4.0\",'+
		'            \"average_score_activity\": \"8.3\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2021\",'+
		'            \"month\": \"07\",'+
		'            \"average_score\": \"4.0\",'+
		'            \"average_score_activity\": \"8.3\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2021\",'+
		'            \"month\": \"08\",'+
		'            \"average_score\": \"4.0\",'+
		'            \"average_score_activity\": \"8.3\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2021\",'+
		'            \"month\": \"09\",'+
		'            \"average_score\": \"4.0\",'+
		'            \"average_score_activity\": \"8.3\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2021\",'+
		'            \"month\": \"10\",'+
		'            \"average_score\": \"4.0\",'+
		'            \"average_score_activity\": \"8.3\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2021\",'+
		'            \"month\": \"11\",'+
		'            \"average_score\": \"4.0\",'+
		'            \"average_score_activity\": \"8.4\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2021\",'+
		'            \"month\": \"12\",'+
		'            \"average_score\": \"6.0\",'+
		'            \"average_score_activity\": \"8.5\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2022\",'+
		'            \"month\": \"01\",'+
		'            \"average_score\": \"6.0\",'+
		'            \"average_score_activity\": \"8.5\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2022\",'+
		'            \"month\": \"02\",'+
		'            \"average_score\": \"6.0\",'+
		'            \"average_score_activity\": \"8.5\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2022\",'+
		'            \"month\": \"03\",'+
		'            \"average_score\": \"6.0\",'+
		'            \"average_score_activity\": \"8.5\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2022\",'+
		'            \"month\": \"04\",'+
		'            \"average_score\": \"6.0\",'+
		'            \"average_score_activity\": \"8.5\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2022\",'+
		'            \"month\": \"05\",'+
		'            \"average_score\": \"6.0\",'+
		'            \"average_score_activity\": \"8.5\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2022\",'+
		'            \"month\": \"06\",'+
		'            \"average_score\": \"6.0\",'+
		'            \"average_score_activity\": \"8.5\"'+
		'        },'+
		'        {'+
		'            \"year\": \"2022\",'+
		'            \"month\": \"07\",'+
		'            \"average_score\": \"6.0\",'+
		'            \"average_score_activity\": \"8.6\"'+
		'        }'+
		'    ],'+
		'    \"tendance\": \"=\",'+
		'    \"COVIDImpact\": \"Vigilance modérée\"'+
		'}');
        res.setStatusCode(200);
        return res;
    }

}