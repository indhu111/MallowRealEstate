@isTest
public class MaintenenceRequestTriggerHandlerTest {
    @isTest
    public static void testvendorAssign(){
        List<vendor__c> vList= new List<vendor__c>();
        for (Integer i=1; i<=5; i++){
            vList.add(new vendor__c(Name='Test'+i, Email__c='krishnanshreeya@gmail.com', Maintenance_Requests_Assigned__c=i));
        }
        insert vList;
        Property__c prop= new Property__c(Property_Name__c='Test Property ', Type__c='Residential', status__c='Available', 
            rent__c= 13000, description__c='hi', address__CountryCode__s='IN',
            address__StateCode__s='TN', address__city__s='Chennai', address__PostalCode__s='600001'); 
        insert prop;
        List<Maintenance_Request__c> maintenanceList= new List<Maintenance_Request__c>();
        for (Integer i=1; i<=5; i++){
            maintenanceList.add(new Maintenance_Request__c(Property__c=prop.id, status__c= 'Completed'));
    	}
        List<AggregateResult> aggResult = [Select Vendor__c, COUNT(Id) ReqCount from Maintenance_Request__c
                                           where Vendor__c != null group by Vendor__c order by COUNT(Id) Desc limit 1];
		if (!aggResult.isEmpty()) {
            Integer cnt = Integer.valueOf(aggResult[0].get('ReqCount'));
            Assert.areEqual(5, cnt, 'The minimum workload count should be 5');
        }
	}
}