@IsTest
public class ClientTelesoftWrapper_TST {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '['+
		'    {'+
		'        \"cus_ide\": 50003,'+
		'        \"swi_ide\": \"swidl\",'+
		'        \"cus_cpt\": null,'+
		'        \"cus_sir\": \"5,39E+139E+130\",'+
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
		'        \"cus_sir_ren\": \"5,39E+130\",'+
		'        \"cus_not_mai\": 0,'+
		'        \"cus_tva_int_com\": null,'+
		'        \"password_token\": null,'+
		'        \"password_token_date\": null,'+
		'        \"password_must_reset\": 1,'+
		'        \"password_last_update\": \"2018-11-27\",'+
		'        \"overloadSwi\": null,'+
		'        \"IdTvaProfile\": null,'+
		'        \"Territorialite\": \"france\"'+
		'    },'+
		'    {'+
		'        \"cus_ide\": 50005,'+
		'        \"swi_ide\": \"swidl\",'+
		'        \"cus_cpt\": \"DBSM3001\",'+
		'        \"cus_sir\": null,'+
		'        \"cus_dat\": \"2014-12-31\",'+
		'        \"cus_soc\": \"IDOM TECHNOLOGIES\",'+
		'        \"cus_con_gen\": \"Monsieur\",'+
		'        \"cus_con_pre\": \"Olivier\",'+
		'        \"cus_con_nom\": \"Merabli\",'+
		'        \"cus_con_fon\": \"responsable informatique\",'+
		'        \"cus_con_ad1\": \"7 rue Henri Cornu\",'+
		'        \"cus_con_ad2\": \"GUADELOUPE\",'+
		'        \"cus_con_ad3\": \"Debut\",'+
		'        \"cus_con_cpo\": \"97400\",'+
		'        \"cus_con_vil\": \"SAINTE CLOTHILDE\",'+
		'        \"cus_con_pay\": \"GUADELOUPE\",'+
		'        \"cus_con_tel\": null,'+
		'        \"cus_con_gsm\": \"690400004\",'+
		'        \"cus_con_fax\": null,'+
		'        \"cus_con_mai\": \"Compta-fournisseurs@idom.fr;nathalie.METTON@digicelgroup.fr\",'+
		'        \"cus_fac_ser\": null,'+
		'        \"cus_fac_ad1\": \"7 rue Henri Cornu\",'+
		'        \"cus_fac_ad2\": null,'+
		'        \"cus_fac_ad3\": null,'+
		'        \"cus_fac_cpo\": \"97400\",'+
		'        \"cus_fac_vil\": \"SAINTE CLOTHILDE\",'+
		'        \"cus_fac_pay\": \"GUADELOUPE\",'+
		'        \"cus_fac_mai\": \"Compta-fournisseurs@idom.fr;nathalie.METTON@digicelgroup.fr;Viniah.Dolcy@digicelgroup.com\",'+
		'        \"cus_fac_det\": 1,'+
		'        \"cus_fac_sta\": 1,'+
		'        \"cus_fac_pre\": 0,'+
		'        \"cus_fac_rib\": null,'+
		'        \"cus_fac_rem_typ\": null,'+
		'        \"cus_fac_rem_mon\": 0,'+
		'        \"cus_fac_tva_tau\": 850,'+
		'        \"cus_use\": \"DBSM3001\",'+
		'        \"cus_pwd\": \"$argon2id$v=19$m=65536,t=31,p=1$r+anskDorKOVu0N5OA/BlA$YiTitPcOMlk3liDIoC5ubExRcoUsLZsMKXCutgrCTqU\",'+
		'        \"acces_compte_autorise\": 1,'+
		'        \"gra_lib\": \"Client\",'+
		'        \"cus_fac_ban\": \"\",'+
		'        \"cus_fac_csv\": 1,'+
		'        \"reg_ide\": \"VIR\",'+
		'        \"reg_swi_ide\": \"swidl\",'+
		'        \"cus_res\": 0,'+
		'        \"cus_per\": 1,'+
		'        \"cus_mar\": \"swidl\",'+
		'        \"cus_fac_rem_typ_cal\": null,'+
		'        \"nap_mas\": 4,'+
		'        \"cus_con_lan\": \"FRA\",'+
		'        \"cus_ape\": null,'+
		'        \"cus_fac_bic\": \"           \",'+
		'        \"cus_fac_ibn\": \"\",'+
		'        \"cus_ban_001\": \"\",'+
		'        \"cus_ban_002\": null,'+
		'        \"cus_ban_003\": null,'+
		'        \"cus_ban_004\": \"\",'+
		'        \"cus_ban_005\": \"\",'+
		'        \"cus_fac_rum\": \"\",'+
		'        \"cus_fac_rum_dat\": \"0000-00-00\",'+
		'        \"cus_sep_pre_rec\": 0,'+
		'        \"cus_sir_ren\": \"442771044\",'+
		'        \"cus_not_mai\": 0,'+
		'        \"cus_tva_int_com\": null,'+
		'        \"password_token\": null,'+
		'        \"password_token_date\": null,'+
		'        \"password_must_reset\": 1,'+
		'        \"password_last_update\": \"2018-11-27\",'+
		'        \"overloadSwi\": null,'+
		'        \"IdTvaProfile\": null,'+
		'        \"Territorialite\": \"france\"'+
		'    },'+
		'    {'+
		'        \"cus_ide\": 50685,'+
		'        \"swi_ide\": \"swidl\",'+
		'        \"cus_cpt\": \"DBSM3226\",'+
		'        \"cus_sir\": \"47853255900018\",'+
		'        \"cus_dat\": \"2022-04-01\",'+
		'        \"cus_soc\": \"DREAM YACHT CARIBBEAN\",'+
		'        \"cus_con_gen\": \"Monsieur\",'+
		'        \"cus_con_pre\": null,'+
		'        \"cus_con_nom\": null,'+
		'        \"cus_con_fon\": null,'+
		'        \"cus_con_ad1\": \"BD ALLEGRE - Port du marin\",'+
		'        \"cus_con_ad2\": \"MARTINIQUE\",'+
		'        \"cus_con_ad3\": \"Debut\",'+
		'        \"cus_con_cpo\": \"97290\",'+
		'        \"cus_con_vil\": \"MARIN\",'+
		'        \"cus_con_pay\": \"MARTINIQUE\",'+
		'        \"cus_con_tel\": \"0596748168\",'+
		'        \"cus_con_gsm\": null,'+
		'        \"cus_con_fax\": null,'+
		'        \"cus_con_mai\": \"jm.hieu@dreamyachtcharter.com\",'+
		'        \"cus_fac_ser\": \"Comptabilité fournisseurs\",'+
		'        \"cus_fac_ad1\": \"BD ALLEGRE\",'+
		'        \"cus_fac_ad2\": \"Port du Marin\",'+
		'        \"cus_fac_ad3\": null,'+
		'        \"cus_fac_cpo\": \"97290\",'+
		'        \"cus_fac_vil\": \"MARIN\",'+
		'        \"cus_fac_pay\": \"MARTINIQUE\",'+
		'        \"cus_fac_mai\": \"jm.hieu@dreamyachtcharter.com\",'+
		'        \"cus_fac_det\": 1,'+
		'        \"cus_fac_sta\": 1,'+
		'        \"cus_fac_pre\": 1,'+
		'        \"cus_fac_rib\": null,'+
		'        \"cus_fac_rem_typ\": null,'+
		'        \"cus_fac_rem_mon\": 0,'+
		'        \"cus_fac_tva_tau\": 850,'+
		'        \"cus_use\": null,'+
		'        \"cus_pwd\": null,'+
		'        \"acces_compte_autorise\": 0,'+
		'        \"gra_lib\": \"Client\",'+
		'        \"cus_fac_ban\": null,'+
		'        \"cus_fac_csv\": 1,'+
		'        \"reg_ide\": \"PRE\",'+
		'        \"reg_swi_ide\": \"swidl\",'+
		'        \"cus_res\": 0,'+
		'        \"cus_per\": 1,'+
		'        \"cus_mar\": \"swidl\",'+
		'        \"cus_fac_rem_typ_cal\": null,'+
		'        \"nap_mas\": 4,'+
		'        \"cus_con_lan\": \"FRA\",'+
		'        \"cus_ape\": \"5010Z\",'+
		'        \"cus_fac_bic\": \"CMCIFRPP\",'+
		'        \"cus_fac_ibn\": \"FR7630066109620002000740189\",'+
		'        \"cus_ban_001\": \"\",'+
		'        \"cus_ban_002\": null,'+
		'        \"cus_ban_003\": null,'+
		'        \"cus_ban_004\": null,'+
		'        \"cus_ban_005\": null,'+
		'        \"cus_fac_rum\": \"MDBSM322620220401092126\",'+
		'        \"cus_fac_rum_dat\": \"2022-02-04\",'+
		'        \"cus_sep_pre_rec\": 0,'+
		'        \"cus_sir_ren\": \"478532559\",'+
		'        \"cus_not_mai\": 0,'+
		'        \"cus_tva_int_com\": \"FR17478532559\",'+
		'        \"password_token\": null,'+
		'        \"password_token_date\": null,'+
		'        \"password_must_reset\": 1,'+
		'        \"password_last_update\": \"0000-00-00\",'+
		'        \"overloadSwi\": null,'+
		'        \"IdTvaProfile\": null,'+
		'        \"Territorialite\": \"france\"'+
		'    },'+
		'    {'+
		'        \"cus_ide\": 50686,'+
		'        \"swi_ide\": \"swidl\",'+
		'        \"cus_cpt\": \"DBSG2231\",'+
		'        \"cus_sir\": \"88233486500020\",'+
		'        \"cus_dat\": \"2022-04-01\",'+
		'        \"cus_soc\": \"GWADEYES INFORMATIQUE\",'+
		'        \"cus_con_gen\": \"Monsieur\",'+
		'        \"cus_con_pre\": null,'+
		'        \"cus_con_nom\": null,'+
		'        \"cus_con_fon\": null,'+
		'        \"cus_con_ad1\": \"RES LES ESSES\",'+
		'        \"cus_con_ad2\": \"GUADELOUPE\",'+
		'        \"cus_con_ad3\": \"Debut\",'+
		'        \"cus_con_cpo\": \"97139\",'+
		'        \"cus_con_vil\": \"LES ABYMES\",'+
		'        \"cus_con_pay\": \"GUADELOUPE\",'+
		'        \"cus_con_tel\": null,'+
		'        \"cus_con_gsm\": \"0690503399\",'+
		'        \"cus_con_fax\": null,'+
		'        \"cus_con_mai\": \"l.rosemond@gwadeyes-informatique.com\",'+
		'        \"cus_fac_ser\": \"Comptabilité fournisseurs\",'+
		'        \"cus_fac_ad1\": \"Résidence LES ESSES\",'+
		'        \"cus_fac_ad2\": \"Duplex Bât J3 N823\",'+
		'        \"cus_fac_ad3\": null,'+
		'        \"cus_fac_cpo\": \"97139\",'+
		'        \"cus_fac_vil\": \"LES ABYMES\",'+
		'        \"cus_fac_pay\": \"GUADELOUPE\",'+
		'        \"cus_fac_mai\": \"l.rosemond@gwadeyes-informatique.com\",'+
		'        \"cus_fac_det\": 1,'+
		'        \"cus_fac_sta\": 1,'+
		'        \"cus_fac_pre\": 0,'+
		'        \"cus_fac_rib\": null,'+
		'        \"cus_fac_rem_typ\": null,'+
		'        \"cus_fac_rem_mon\": 0,'+
		'        \"cus_fac_tva_tau\": 850,'+
		'        \"cus_use\": null,'+
		'        \"cus_pwd\": null,'+
		'        \"acces_compte_autorise\": 0,'+
		'        \"gra_lib\": \"Client\",'+
		'        \"cus_fac_ban\": null,'+
		'        \"cus_fac_csv\": 1,'+
		'        \"reg_ide\": \"VIR\",'+
		'        \"reg_swi_ide\": \"swidl\",'+
		'        \"cus_res\": 0,'+
		'        \"cus_per\": 1,'+
		'        \"cus_mar\": \"swidl\",'+
		'        \"cus_fac_rem_typ_cal\": null,'+
		'        \"nap_mas\": 4,'+
		'        \"cus_con_lan\": \"FRA\",'+
		'        \"cus_ape\": \"6202A\",'+
		'        \"cus_fac_bic\": null,'+
		'        \"cus_fac_ibn\": null,'+
		'        \"cus_ban_001\": \"\",'+
		'        \"cus_ban_002\": null,'+
		'        \"cus_ban_003\": null,'+
		'        \"cus_ban_004\": null,'+
		'        \"cus_ban_005\": null,'+
		'        \"cus_fac_rum\": null,'+
		'        \"cus_fac_rum_dat\": null,'+
		'        \"cus_sep_pre_rec\": 0,'+
		'        \"cus_sir_ren\": \"882334865\",'+
		'        \"cus_not_mai\": 0,'+
		'        \"cus_tva_int_com\": \"FR28882334865\",'+
		'        \"password_token\": null,'+
		'        \"password_token_date\": null,'+
		'        \"password_must_reset\": 1,'+
		'        \"password_last_update\": \"0000-00-00\",'+
		'        \"overloadSwi\": null,'+
		'        \"IdTvaProfile\": null,'+
		'        \"Territorialite\": \"france\"'+
		'    }'+
		']';
		List<ClientTelesoftWrapper> r = ClientTelesoftWrapper.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';

		ClientTelesoftWrapper objClientTelesoftWrapper = new ClientTelesoftWrapper(System.JSON.createParser(json));
		
		System.assert(objClientTelesoftWrapper != null);
		System.assert(objClientTelesoftWrapper.cus_ide == null);
		System.assert(objClientTelesoftWrapper.cus_sir_ren == null);
	}
}