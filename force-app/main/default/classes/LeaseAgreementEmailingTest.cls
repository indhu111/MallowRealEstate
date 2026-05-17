@isTest
public class LeaseAgreementEmailingTest {
    @TestSetup
    public static void loadData(){
        List<Contact> conList= new List<contact>();
        List<Property__c> propList= new List<Property__c>();
        List<lease_Agreement__c> leaseList= new List<lease_agreement__c>();
        contact ca= new contact(FirstName='ababa', lastName='bababa', email='krishnanshreeya@gmail.com');
        insert ca;
        for (integer i=1; i<=3; i++){
            conList.add(new contact(FirstName='Test', lastName='Name'+i, email='krishnanshreeya@gmail.com'));
            propList.add(new Property__c(Property_Name__c='Test Property '+i, Type__c='Residential', status__c='Occupied', 
            rent__c= 13000, description__c='hi', address__CountryCode__s='IN', tenant__c=ca.id,
            address__StateCode__s='TN', address__city__s='Chennai', address__PostalCode__s='600001'));
        }
        insert conList;
        insert propList;
        contact c= [Select id from contact limit 1];
        property__c p= [Select id from property__c limit 1];
        for (integer i=1; i<=3; i++){
            if (i==1 || i==2){
                 leaseList.add(new lease_Agreement__c(agreed_monthly_rent__c=15000, 
                                                     end_date__c= Date.today().addmonths(1), tenant__c=c.Id,
                                                     property__c=p.Id));
            }
            else{
                leaseList.add(new lease_Agreement__c(agreed_monthly_rent__c=16000, 
                                                     end_date__c= Date.today().addmonths(3), tenant__c=c.Id,
                                                     property__c=p.Id));
            }
        }
        insert leaseList;
    }
    @isTest
    public static void Testbatch(){
        Test.startTest();
        Database.ExecuteBatch(new LeaseAgreementEmailing(),10);
        Test.stopTest();
        List<EmailMessage> e=[Select subject from EmailMessage where subject='Lease Agreement about to expire'];
        assert.areEqual(2, e.size(),'Error');
    }
}