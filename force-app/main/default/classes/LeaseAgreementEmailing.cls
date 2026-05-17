public class LeaseAgreementEmailing implements Database.Batchable<Sobject>, Database.Stateful{
    public List<Messaging.singleEmailMessage> emailList= new List<Messaging.singleEmailMessage>();
    public static Date todayDate=Date.today();
    public static String oneMonthAdded= String.valueOf(todayDate.addMonths(1));
    public Database.QueryLocator start(Database.BatchableContext btx){
        String query='Select Tenant__r.Firstname, Tenant__r.email, Property__r.Property_name__c, end_date__c, ';
        query+='agreed_monthly_rent__c from Lease_Agreement__c where end_date__c= ';
        query+=oneMonthAdded;
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext btx, List<Lease_Agreement__c> agreements){
        for (Lease_Agreement__c ag:agreements){
            Messaging.SingleEmailMessage mg= new Messaging.SingleEmailMessage();
            List<String> recipientAddresses= new List<String>{ag.Tenant__r.email};
            mg.setToAddresses(recipientAddresses);
            mg.setSubject('Lease Agreement about to expire');
            String body= 'Dear <b/>'+ag.Tenant__r.Firstname+'<b/>,<br>';
            body+= 'We hope you are doing well. <br> This is a reminder that your lease agreement is scheduled to end on<b> ';
            body+= oneMonthAdded+ '<b/>.<br> Property Details:'+'<br> <b>Name: <b/>'+ag.Tenant__r.Firstname+ '<br> <b>Property Name:<b/> ';
            body+= ag.Property__r.Property_name__c+ '<br> <b>Agreed monthly rent: <b/>'+ ag.Agreed_monthly_rent__c;
            body+= '<br> If you would like to renew the agreement or discuss moving-out formalities, please contact us before the agreement expiry date.<br>';
            body+= 'Please feel free to reach out for any clarification or assistance.<br> Thank you for choosing us.<br>';
            body+='Regards,<br>Team Mallow';
            mg.setHTMLBody(body);
            emailList.add(mg);
        }
    }
    public void finish(Database.BatchableContext btx){
        Messaging.sendEmail(emailList);
    }
}