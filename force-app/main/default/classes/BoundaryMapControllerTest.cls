@isTest
public class BoundaryMapControllerTest {
   /* 
    @isTest static void Testmy(){
        test.startTest();
        BoundaryMapController.mytest();
        test.stopTest();
    }
   */ 
   
    static User createTestUser() {
        String uniqueUsername = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile prof = [SELECT Id FROM Profile WHERE Name='Standard User'];
        return new User(
            Alias = 'standt', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = prof.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName= uniqueUsername
        );
    }
     
    @isTest
    public static void getBoundaryMap(){  
        User testUser = createTestUser();
        System.debug('Test User: ' + testUser);
        
        List<Route__c> mockRoutes = new List<Route__c>{
            new Route__c(City__c='',State__c='', Route_Name_del__c = 'Sarjapur', Sales_User__c = testUser.Id),
            new Route__c(City__c='',State__c='', Route_Name_del__c = 'Sarjapur', Sales_User__c = testUser.Id)
        };
        insert mockRoutes;
        
        List<Account> mockAccounts = new List<Account>{
            new Account(Name = 'Account 1', BillingStreet = '123 Route 1'),
            new Account(Name = 'Account 2', BillingStreet = '456 Route 2')
        };
        insert mockAccounts;
        System.runAs(testUser) {
            Test.startTest();
            List<Route__c> routes = [SELECT Id, Name, Route_Name_del__c FROM Route__c WHERE Sales_User__c = :testUser.Id];
            if (routes.isEmpty()) {
                System.debug('No routes found for current user.');
                Map<String, List<Object>> result = BoundaryMapController.getBoundaryMap();
            BoundaryMapController.getRouteNameFilters(mockRoutes);
            }
            else {
            Map<String, List<Object>> result = BoundaryMapController.getBoundaryMap();
            BoundaryMapController.getRouteNameFilters(mockRoutes);
            }
            Test.stopTest();
        }
    }
}