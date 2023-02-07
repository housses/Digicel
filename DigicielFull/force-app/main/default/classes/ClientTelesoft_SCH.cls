global class ClientTelesoft_SCH implements Schedulable {  
    global void execute(SchedulableContext SC) {
        Id batchJobId = Database.executebatch(new ClientTelesoft_BAT(),100);   
     }
}