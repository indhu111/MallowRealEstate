trigger MaintenenceRequestTrigger on Maintenance_Request__c (before insert) {
    if (trigger.isInsert && Trigger.isBefore){
        MaintenenceRequestTriggerHandler.vendorAssign(Trigger.new);
    }
}