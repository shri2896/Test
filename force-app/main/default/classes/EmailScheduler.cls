global class EmailScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {       
        UpdateStatusInContact btc = new UpdateStatusInContact ();
        Database.executeBatch(btc);
    }
}