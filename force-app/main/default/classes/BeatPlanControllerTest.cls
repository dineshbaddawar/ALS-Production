@isTest
public class BeatPlanControllerTest {
 
    @isTest
    static void testBeatPlanController() {
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser72@example.com',
            Alias = 'tuser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'
        );
        insert testUser;
        
        Roles_and_KPI__c testRKP = new Roles_and_KPI__c(
            Name = 'Test Role',
            Sales_User__c = testUser.Id
        );
        insert testRKP;
        
        
        String startDate = '2024-03-01';
        String lastDate = '2024-03-31';
        List<Monthly_Beat_Plan__c> existingMonthlyBeatPlans = new List<Monthly_Beat_Plan__c>();
        Monthly_Beat_Plan__c existingMBP = new Monthly_Beat_Plan__c(
            Start_Date__c = Date.valueOf(startDate),
            End_Date__c = Date.valueOf(lastDate),
            Sales_User__c = testUser.Id,
            Month_Name__c = 'March'
        );
        existingMonthlyBeatPlans.add(existingMBP);
        insert existingMonthlyBeatPlans;
        
        List<BeatPlanController.WrapperClass> wrapperRecList = new List<BeatPlanController.WrapperClass>();
        BeatPlanController.WrapperClass wrapperRec = new BeatPlanController.WrapperClass();
        wrapperRec.Id = testRKP.Id;
        wrapperRec.Name = 'TestName';
        wrapperRec.targetvalue = '10';
        wrapperRecList.add(wrapperRec);
        
        Test.startTest();
        List<Roles_and_KPI__c> firstresult = BeatPlanController.AllRolesXKPICurrentUser();
        String result = BeatPlanController.GetAllMonthlyBeatPlanner(startDate, lastDate, wrapperRecList);
        Test.stopTest();
    }
        
        
}