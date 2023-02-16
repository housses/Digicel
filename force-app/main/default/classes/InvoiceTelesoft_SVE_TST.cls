@isTest
public class InvoiceTelesoft_SVE_TST {

    @isTest
    public static void checkCalculAmountTVA(){
        Double actualResult = InvoiceTelesoft_SVE.calculAmountTVA('1000', '8,5');
        Double expectedResult = 85;
        System.assertEquals(expectedResult, actualResult, 'checkCalculAmountTVA => should be equal to 85');
    }

    @isTest
    public static void checkCalculAmountTTC(){
        Double actualResult = InvoiceTelesoft_SVE.calculAmountTTC('1000', '8,5');
        Double expectedResult = 1085;
        system.assertEquals(expectedResult, actualResult, 'checkCalculAmountTTC => should be equal to 1085');
    }

}