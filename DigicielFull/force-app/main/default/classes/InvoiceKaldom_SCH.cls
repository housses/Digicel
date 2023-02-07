global class InvoiceKaldom_SCH implements Schedulable {

    global void execute(SchedulableContext SC) {
        if(Test.isRunningTest()) {
            Id batchJobId = Database.executebatch(new InvoiceKaldom_BAT(13,14), 100);   
         } else 
        Id batchJobId = Database.executebatch(new InvoiceKaldom_BAT(0,1), 100);   
    }

}