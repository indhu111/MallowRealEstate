public class LeaseAgreementEmailingScheduler implements Schedulable {
    public void execute(SchedulableContext stx){
        Database.executeBatch(new LeaseAgreementEmailing(), 300);
    }
}