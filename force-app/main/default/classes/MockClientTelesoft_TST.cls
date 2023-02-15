global class MockClientTelesoft_TST implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('['+
		'    {'+
		'        \"cus_ide\": 50003,'+
		'        \"swi_ide\": \"swidl\",'+
		'        \"cus_cpt\": "50003",'+
		'        \"cus_sir\": \"509124798\",'+
		'        \"cus_dat\": \"2014-03-01\",'+
		'        \"cus_soc\": \"SAMAC Aéroport TEST\",'+
		'        \"cus_con_gen\": \"Monsieur\",'+
		'        \"cus_con_pre\": \"Jean-Luc\",'+
		'        \"cus_con_nom\": \"NESTORET\",'+
		'        \"cus_con_fon\": \"Responsable Informatique & Telecoms\",'+
		'        \"cus_con_ad1\": \"Aéroport Aimé Césaire BP 279\",'+
		'        \"cus_con_ad2\": \"MARTINIQUE\",'+
		'        \"cus_con_ad3\": \"Debut\",'+
		'        \"cus_con_cpo\": \"97285\",'+
		'        \"cus_con_vil\": \"Lamentin Cedex 2\",'+
		'        \"cus_con_pay\": \"Martinique\",'+
		'        \"cus_con_tel\": \"0596 55 28 69\",'+
		'        \"cus_con_gsm\": null,'+
		'        \"cus_con_fax\": null,'+
		'        \"cus_con_mai\": \"jl.nestoret@martinique.aeroport.fr\",'+
		'        \"cus_fac_ser\": null,'+
		'        \"cus_fac_ad1\": \"Aéroport Aimé Césaire BP 279\",'+
		'        \"cus_fac_ad2\": null,'+
		'        \"cus_fac_ad3\": null,'+
		'        \"cus_fac_cpo\": \"97285\",'+
		'        \"cus_fac_vil\": \"Lamentin Cedex 2\",'+
		'        \"cus_fac_pay\": \"Martinique\",'+
		'        \"cus_fac_mai\": \"jl.nestoret@martinique.aeroport.fr\",'+
		'        \"cus_fac_det\": 1,'+
		'        \"cus_fac_sta\": 1,'+
		'        \"cus_fac_pre\": 1,'+
		'        \"cus_fac_rib\": null,'+
		'        \"cus_fac_rem_typ\": null,'+
		'        \"cus_fac_rem_mon\": 0,'+
		'        \"cus_fac_tva_tau\": 850,'+
		'        \"cus_use\": \"SAMAC\",'+
		'        \"cus_pwd\": \"Digicel*\",'+
		'        \"acces_compte_autorise\": 1,'+
		'        \"gra_lib\": \"Client\",'+
		'        \"cus_fac_ban\": \"\",'+
		'        \"cus_fac_csv\": 0,'+
		'        \"reg_ide\": \"PRE\",'+
		'        \"reg_swi_ide\": \"swidl\",'+
		'        \"cus_res\": 1,'+
		'        \"cus_per\": 1,'+
		'        \"cus_mar\": \"swidl\",'+
		'        \"cus_fac_rem_typ_cal\": null,'+
		'        \"nap_mas\": 4,'+
		'        \"cus_con_lan\": \"FRA\",'+
		'        \"cus_ape\": null,'+
		'        \"cus_fac_bic\": \"BNPAMQMXXXX\",'+
		'        \"cus_fac_ibn\": \"FR7613088090900071700008344\",'+
		'        \"cus_ban_001\": \"\",'+
		'        \"cus_ban_002\": null,'+
		'        \"cus_ban_003\": null,'+
		'        \"cus_ban_004\": \"\",'+
		'        \"cus_ban_005\": \"\",'+
		'        \"cus_fac_rum\": \"123654789\",'+
		'        \"cus_fac_rum_dat\": \"2014-01-31\",'+
		'        \"cus_sep_pre_rec\": 0,'+
		'        \"cus_sir_ren\": \"510464001\",'+
		'        \"cus_not_mai\": 0,'+
		'        \"cus_tva_int_com\": null,'+
		'        \"password_token\": null,'+
		'        \"password_token_date\": null,'+
		'        \"password_must_reset\": 1,'+
		'        \"password_last_update\": \"2018-11-27\",'+
		'        \"overloadSwi\": null,'+
		'        \"IdTvaProfile\": null,'+
		'        \"Territorialite\": \"france\"'+
		'    }]');
        res.setStatusCode(200);
        return res;
    }
}