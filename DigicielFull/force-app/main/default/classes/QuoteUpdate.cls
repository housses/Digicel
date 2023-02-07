public with sharing class QuoteUpdate{

    private static Decimal deposit = 0;
    private static Decimal monthlyFee = 0;
    private static List<Quote> quoteList = new List<Quote>();
    private static List<Quote> quotesToBeUpdated = new List<Quote>();
    private static List<QuoteLineItem> oppLineItemsList = new List<QuoteLineItem>();
    private static Set<Id> finalQuoteIdsToUpdate = new Set<Id>();
    
    public static void setQuoteTotals(List<QuoteLineItem> quoteLineItems){
    
    //Get the Quote Ids
    Set<Id> quoteIds = new Set<Id>();
    for(QuoteLineItem qli: quoteLineItems){
        quoteIds.add(qli.QuoteId);
    }
    
    //Get a list of Quotes and their Line Items
    quoteList = [Select q.Id, q.Customer_Deposit_Waived__c From Quote q Where q.Id in: quoteIds];
    oppLineItemsList = [Select q.Id, q.QuoteId, q.FORMULA_Monthly_Fee__c, q.FORMULA_Deposit__c, q.Quantity
                        From QuoteLineItem q Where q.QuoteId in: quoteList];
                        
    //Get the vaues from the Line Items and sum them up to the Opportunity
    for(Quote oneQuote: quoteList){
        for(QuoteLineItem oneQLI: oppLineItemsList){
            if(oneQLI.QuoteId == oneQuote.Id){
              //Monthly Fee
              if(oneQLI.FORMULA_Monthly_Fee__c != null){
                system.debug('### monthlyFee  = ' + oneQLI.FORMULA_Monthly_Fee__c);
                system.debug('### Quantity = ' + oneQLI.Quantity);
                Decimal tmpMonthlyFee = (oneQLI.FORMULA_Monthly_Fee__c * oneQLI.Quantity) * 12;
                monthlyFee += tmpMonthlyFee;
                system.debug('### Total monthlyFee = ' + tmpMonthlyFee);  
              }
              
              //Deposit
              if(oneQLI.FORMULA_Deposit__c != null){
                system.debug('### Deposit  = ' + oneQLI.FORMULA_Deposit__c);  
                system.debug('### Quantity = ' + oneQLI.Quantity);
                Decimal tmpDeposit = oneQLI.FORMULA_Deposit__c * oneQLI.Quantity;
                deposit += tmpDeposit;
                system.debug('### Total Deposit = ' + deposit);
              }
            }
        }
        //Check if deposit is waived for this customer and then set all totals
        if(oneQuote.Customer_Deposit_Waived__c == 'No'){
            oneQuote.Total_Deposit__c = deposit;
        }
        else{
            oneQuote.Total_Deposit__c = 0;
        }
        
        oneQuote.Total_Recurring_Revenue__c = monthlyFee;
        
        /*Add Quote to the list for update - 
          we need to put a check in place to make sure we are not adding the same Id twice*/
        if(!finalQuoteIdsToUpdate.contains(oneQuote.Id)){
          finalQuoteIdsToUpdate.add(oneQuote.Id);  
          quotesToBeUpdated.add(oneQuote);
        }
    }
    //Update Quotes
    if(quotesToBeUpdated.size()>0){
      upsert quotesToBeUpdated;
    }
    
    }
}