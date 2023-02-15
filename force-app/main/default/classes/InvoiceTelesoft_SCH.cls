global  class InvoiceTelesoft_SCH implements Schedulable {

    global void execute(SchedulableContext SC) {
        Id batchJobId = Database.executebatch( new InvoiceTelesoft_BAT(0,1), 100);
    }
}