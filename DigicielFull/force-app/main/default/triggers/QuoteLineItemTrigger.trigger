/*This trigger will only affect SP users*/

trigger QuoteLineItemTrigger on QuoteLineItem (after insert, after update, after delete) {
  
  //SP Opportunity Record Type
  String[] recordTypeIds = new String[]{
        '012d0000000tMdA','012d0000000sds8','012d0000000tMdF',
        '012d0000000tMcq','012d0000000sdru','012d0000000tMd5',
        '012d0000000tMdU','012d0000000sdsF','012d0000000tMdZ',
        '012d0000000tMdK','012d0000000sds9','012d0000000tMdP',
        '012d0000000tMde','012d0000000sdsI','012d0000000tMdj',
        '012d0000000sds4'};
    
    // Limit to a set of record types
    List<Id> idsQuotes = new List<Id>();
    List<Id> idsQLI = new List<Id>();
    if(trigger.isDelete){
        for(QuoteLineItem ql:trigger.old){
        	idsQuotes.add(ql.QuoteId);
            idsQLI.add(ql.Id);
        }
    }
    else{
        for(QuoteLineItem ql:trigger.new){
        	idsQuotes.add(ql.QuoteId);
            idsQLI.add(ql.Id);
        }
    }
    
    // Filter the QuoteLineItems by Opportunity.RecordTypeId
    List<QuoteLineItem> qliList = [Select Id, QuoteId From QuoteLineItem Where Id in:idsQLI AND QuoteId in:idsQuotes AND Quote.Opportunity.RecordTypeId in:recordTypeIds];
    
    // Set Quote totsals (Deposit, Monthly Fee, Additional Fees)
    QuoteUpdate.setQuoteTotals(qliList);
}