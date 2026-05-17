public class LeaseAgreementEmailing implements Database.Batchable<Sobject>, Database.Stateful{
    public Database.QueryLocator start(Database.BatchableContext btx){
        Date todayDate=Date.today();
    	String oneMonthAdded= String.valueOf(todayDate.addMonths(1));
        String query='Select Id, Tenant__c, Tenant__r.Firstname, Tenant__r.email, Property__r.Property_name__c, end_date__c, ';
        query+='agreed_monthly_rent__c from Lease_Agreement__c where end_date__c= ';
        query+=oneMonthAdded;
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext btx, List<Lease_Agreement__c> agreements){
        List<Messaging.singleEmailMessage> emailList= new List<Messaging.singleEmailMessage>();
        for (Lease_Agreement__c ag:agreements){
            Messaging.SingleEmailMessage mg= new Messaging.SingleEmailMessage();
            List<String> recipientAddresses= new List<String>{ag.Tenant__r.email};
            mg.setToAddresses(recipientAddresses);
            mg.setTargetObjectId(ag.Tenant__c); 
            mg.setWhatId(ag.Id);
            mg.setSaveAsActivity(true);
            mg.setSubject('Lease Agreement about to expire');
            String body= 'Dear '+ag.Tenant__r.Firstname+',<br>';
            body+= 'We hope you are doing well. <br> This is a reminder that your lease agreement is scheduled to end on ';
            body+= String.valueOf(ag.end_date__c)+ '.<br> Property Details:'+'<br> Name: '+ag.Tenant__r.Firstname+ '<br> Property Name: ';
            body+= ag.Property__r.Property_name__c+ '<br> Agreed monthly rent: '+ ag.Agreed_monthly_rent__c;
            body+= '<br> If you would like to renew the agreement or discuss moving-out formalities, please contact us before the agreement expiry date.<br>';
            body+= 'Please feel free to reach out for any clarification or assistance.<br> Thank you for choosing us.<br>';
            body+='Regards,<br>Team Mallow';
            mg.setHTMLBody(body);
            emailList.add(mg);
        }
        Messaging.sendEmail(emailList);
    }
    public void finish(Database.BatchableContext btx){}
}