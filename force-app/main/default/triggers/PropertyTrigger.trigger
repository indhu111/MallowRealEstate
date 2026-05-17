trigger PropertyTrigger on Property__c (before insert, before update, after insert, after update) {
    if (Trigger.isAfter && Trigger.isInsert) {
        PropertyTriggerHandler.handleAfterInsert(Trigger.new);
    }
    else if (Trigger.isAfter && Trigger.isUpdate) {
        PropertyTriggerHandler.handleAfterUpdate(Trigger.oldMap, Trigger.new);
    }
    else if (Trigger.isBefore){
        PropertyTriggerHandler.validateImageField(Trigger.new);
    }
}