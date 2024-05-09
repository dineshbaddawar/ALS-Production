@isTest
public class RouteDuplicateCheckTest {
    
    @isTest
    Public static void TestDeleteAccountWithOneOpportunity() {
        //  User salesUseRec = [SELECT Name, ManagerID, Manager.Name FROM User WHERE profile.Name = 'Sales User'];
        
        User useRec = [SELECT Name, ManagerID, Manager.Name FROM User WHERE ID=:UserInfo.getUserId() LIMIT 1];
        
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Sales User'].Id,
            FirstName = 'Test 1',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuseqwertr@example.com',
            Alias = 'tufser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York',
            ManagerId = UserInfo.getUserId()
        );
        insert testUser;
        
        
        Route__c routeRec = new Route__c();
        routeRec.Predefined_Area__c = 'HSR Layout';
        routeRec.Sales_User__c = testUser.Id;
        insert routeRec;
        
        Account acc =  UtilityTest.createAccRec('Dinesh');
        Contact conRec =  UtilityTest.createConRec('Mukesh','Test data');
        
        Case caseObj = new Case( Status = 'Working', Origin = 'Phone');
        insert caseObj;
    }
}