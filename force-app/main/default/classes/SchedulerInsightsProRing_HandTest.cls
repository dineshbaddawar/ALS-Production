@isTest
public class SchedulerInsightsProRing_HandTest {
   /* 
    @isTest static void Testmy(){
        test.startTest();
        SchedulerInsightsProgressRing_Handler.mytest();
        test.stopTest();
    }
    
  */  
	@isTest
    static void testGetRoleAndKPI() {
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser87@example.com',
            Alias = 'tuser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'
        );
        insert testUser;
        Monthly_Beat_Plan__c  mbpRec = UtilityTest.createMBPRec('In Progress', userInfo.getUserId(), System.today(),'March',System.today(),'Approved');
        Weekly_Beat_Plan__c wbp = UtilityTest.createWBPRec(Date.newInstance(2024, 12, 30), Date.newInstance(2024, 12, 10), 'W1', 'Week 1', mbpRec.Id);
        List<Roles_and_KPI__c> testData = new List<Roles_and_KPI__c>();
       for (Integer i = 0; i < 5; i++) {
            Roles_and_KPI__c rak = new Roles_and_KPI__c(Name = 'Test Role ' + i);
            testData.add(rak);
        }
        insert testData;

        KPI_Target__c kpiRec = new  KPI_Target__c();
        kpiRec.Monthly_Beat_Plan__c = mbpRec.Id;
        kpiRec.Achieved_Count__c = 5;
        kpiRec.Target_Count__c = 10;
        kpiRec.Roles_and_KPI__c = testData[0].Id;
        kpiRec.Sales_User__c = testUser.Id;
        insert kpiRec;
        
               
         List<Roles_and_KPI__c> result = SchedulerInsightsProgressRing_Handler.getRoleAndKPI();
        SchedulerInsightsProgressRing_Handler.getCountOfVisitsForDifferentKPIs('March', '2024');
        

    }

    
    
}