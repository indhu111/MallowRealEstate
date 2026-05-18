public class MaintenenceRequestTriggerHandler {
    public static void vendorAssign(List<Maintenance_Request__c> lMain){
        Vendor__c vend=[Select id from vendor__c Order by Maintenance_Requests_Assigned__c asc limit 1];
        for (Maintenance_Request__c req: lMain){
            if (req.vendor__c==Null){
                req.vendor__c=vend.id;
            }
        }
    }
}