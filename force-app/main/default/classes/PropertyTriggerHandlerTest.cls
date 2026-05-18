@isTest
public class PropertyTriggerHandlerTest {
    @isTest
    static void makeInsert1(){
        List<Property__c> propList= new List<Property__c>();
        for(Integer i=1;i<=3;i++){
            propList.add(new Property__c(Property_Name__c='Test Property '+i, Type__c='Residential', status__c='Available', 
            rent__c= 13000, description__c='hi', address__CountryCode__s='IN',
            address__StateCode__s='TN', address__city__s='Chennai', address__PostalCode__s='600001'));
        }
        Test.startTest();
        insert propList;
        Test.stopTest();
        List<Task> propList1=[Select id from task];
        Assert.areEqual(0, propList1.size());
    }
    @isTest
    static void makeInsert2(){
        List<Property__c> propList= new List<Property__c>();
        Contact con = new Contact(LastName = 'Test Tenant', FirstName='ABCD', email='hi@gmail.com');
        insert con;
        Contact ten= [select id from Contact limit 1];
        for(Integer i=1;i<=3;i++){
            propList.add(new Property__c(Property_Name__c='Test Property '+i, Type__c='Residential', status__c='Occupied',
            rent__c= 13000, description__c='hi', address__CountryCode__s='IN',
            address__StateCode__s='TN', address__city__s='Chennai', address__PostalCode__s='600001', Tenant__c=ten.id ));
        }
        Test.startTest();
        insert propList;
        Test.stopTest();
        List<Task> propList1=[Select id from task];
        Assert.areEqual(3, propList1.size());
    }
    @isTest
    static void makeUpdate1(){
        List<Property__c> propList= new List<Property__c>();
        for(Integer i=1;i<=3;i++){
            propList.add(new Property__c(Property_Name__c='Test Property '+i, Type__c='Residential', status__c='Available',
            rent__c= 13000, description__c='hi', address__CountryCode__s='IN',
            address__StateCode__s='TN', address__city__s='Chennai', address__PostalCode__s='600001' ));
        }
        Test.startTest();
        insert propList;
        Test.stopTest();
        Property__c propList2=[Select id, rent__c from Property__c limit 1];
        propList2.rent__c = 19000;
        update propList2;
        List<Task> propList1=[Select id from task];
        Assert.areEqual(0, propList1.size());
    }
    @isTest
    static void makeUpdate2(){
        List<Property__c> propList= new List<Property__c>();
        Contact con = new Contact(LastName = 'Test Tenant', FirstName='ABCD', email='hi@gmail.com');
        insert con;
        Contact ten= [select id from Contact limit 1];
        for(Integer i=1;i<=3;i++){
            propList.add(new Property__c(Property_Name__c='Test Property '+i, Type__c='Residential', status__c='Available',
            rent__c= 13000, description__c='hi', address__CountryCode__s='IN',
            address__StateCode__s='TN', address__city__s='Chennai', address__PostalCode__s='600001'));
        }
        Test.startTest();
        insert propList;
        Test.stopTest();
        Property__c propList2=[Select id, tenant__c, status__c from Property__c limit 1];
        propList2.tenant__c = ten.id;
        PropList2.status__c='Occupied';
        update propList2;
        List<Task> propList1=[Select id from task];
        Assert.areEqual(1, propList1.size());
    }
}