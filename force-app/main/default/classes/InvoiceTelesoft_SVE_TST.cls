@isTest
public class InvoiceTelesoft_SVE_TST {


    @isTest
    public static void checkCalculAmountTVA(){
        Double actualResult = InvoiceTelesoft_SVE.calculAmountTVA('1000', '8,5');
        Double expectedResult = 85;
        system.assertEquals(expectedResult, actualResult);
    }

    @isTest
    public static void checkCalculAmountTTC(){
        Double actualResult = InvoiceTelesoft_SVE.calculAmountTTC('1000', '8,5');
        Double expectedResult = 1085;
        system.assertEquals(expectedResult, actualResult);
    }



}