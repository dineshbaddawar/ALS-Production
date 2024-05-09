@isTest
public class BeatPlannerHelperTest {
  
    @isTest
    static void testCreateDocumentCategories() { 
        
        Approval_Process_Requirement__c setting = new Approval_Process_Requirement__c(
            Name = 'Field Visit',
            isApprovalRequired__c = false
        );
        insert setting;
        
         String month = 'January';
        String year = '2024';
        
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
        
        Account accRec = UtilityTest.createAccRec('TestName');
       	Visit__c testVisit = UtilityTest.createVisitRec(System.today(),accRec.Id);
        
        Monthly_Beat_Plan__c testmbp = UtilityTest.createMBPRec('In Progress', testUser.Id, System.today() + 10, 'January', System.today(), 'Draft');
        
        List<Monthly_Beat_Plan__c> testDealList = new List<Monthly_Beat_Plan__c>{testmbp};
            
       
        
        Test.startTest();        
        BeatPlannerHelper.updateMonthname(testDealList);
        BeatPlannerHelper.docCategories(testDealList);
        BeatPlannerHelper.CreateDocumentCategories(testDealList);
        BeatPlannerHelper.getTaskdetails(accRec.Id);
        BeatPlannerHelper.BeetplannerDatareturn(month, year);
        Test.stopTest();    
    }
  
}