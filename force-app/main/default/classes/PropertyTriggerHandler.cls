public class PropertyTriggerHandler {
    
    public static void handleAfterInsert(List<Property__c> props){
        List<Task> taskList = new List<Task>();
        for (Property__c p : props){
            if (p.Tenant__c != null){
                taskList.add(new Task(
                    OwnerId = p.OwnerId,
                    WhatId = p.Id,
                    Subject = 'Create a lease agreement',
                    WhoId = p.Tenant__c,
                    Status = 'Not Started'));
            }
        }
        Database.insert(taskList, false);
    }
    
    public static void handleAfterUpdate(Map<Id, Property__c> oldPropMap, List<Property__c> newProps){
        List<Task> taskList = new List<Task>();
        for(Property__c p : newProps){
            if((p.Tenant__c != null && oldPropMap.get(p.Id).Tenant__c == null) || 
                (p.Tenant__c != oldPropMap.get(p.Id).Tenant__c))
            {
                taskList.add(new Task(
                    OwnerId = p.OwnerId,
                    WhatId = p.Id,
                    Subject = 'Create a lease agreement',
                    WhoId = p.Tenant__c,
                    Status = 'Not Started'));
            }
        }
        Database.insert(taskList, false);
    }
}