public class InvoiceTelesoft_SVE {

    public static Double calculAmountTVA(String amountHT, String tauxTVA){
        Double montantHT = Double.valueOf(amountHT.replaceAll(',', '.').replaceAll(' ', ''));
        Double tva = Double.valueOf(tauxTVA.replaceAll(',', '.').replaceAll(' ', ''));
        return (montantHT*(tva/100));
    }

    public static Double calculAmountTTC(String amountHT, String tauxTVA){
        Double montantHT = Double.valueOf(amountHT.replaceAll(',', '.').replaceAll(' ', ''));
        Double tva = Double.valueOf(tauxTVA.replaceAll(',', '.').replaceAll(' ', ''));
        return (montantHT + (montantHT*(tva/100)));
    }

}