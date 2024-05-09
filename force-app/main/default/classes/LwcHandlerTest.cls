@isTest
public class LwcHandlerTest {
/*
     @isTest static void Testmy(){
        test.startTest();
        LwcHandler.mytest();
        test.stopTest();
    }
*/
    @isTest
    Static void testLwcHandler(){
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser403@example.com',
            Alias = 'tuser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'
        );
        insert testUser;
        Monthly_Beat_Plan__c testmbp = UtilityTest.createMBPRec('In Progress', testUser.Id, System.today() + 10, 'January', System.today(), 'Draft');
        
        LwcHandler.getMBPRecordDetails(testmbp.Id);
    }
}