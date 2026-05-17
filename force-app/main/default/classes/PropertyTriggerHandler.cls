public class PropertyTriggerHandler {
    public static void validateImageField(List<Property__c> properties) {
        List<String> rawExtensions = Label.Image_supported_file_extensions.split('\n');
        for (Property__c prop : properties) {
            String textCheck= (prop.image__c == null) ? '' : prop.image__c.toLowerCase();
            Boolean foundExtension = false;
            for (String ext : rawExtensions) {
                String cleanExt = ext.trim(); 
                if (String.isNotBlank(cleanExt) && textCheck.contains(cleanExt)) {
                    foundExtension = true;
                    break;
                }
            }
            String plainText = textCheck.replaceAll('<[^>]+>', '').replaceAll('&nbsp;', '').trim();
            if (!textCheck.contains('<img')) {
                prop.image__c.addError('The Image field is required. Please upload a file.');
            } 
            else if (!foundExtension) {
                prop.image__c.addError('Unsupported image format. Please use one of: ' + Label.Image_supported_file_extensions.replace('\n', ', '));
            }
            else if (String.isNotBlank(plainText)) {
                // This catches people who upload an image but also type words
                prop.image__c.addError('Only images are allowed. Please remove the text: "' + plainText + '"');
            }
        }
	}
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