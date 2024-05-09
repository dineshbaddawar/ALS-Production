@IsTest(SeeAllData=true)
public class ClientSummary_HandlerTest {
    /*
    @isTest static void Testmy(){
        test.startTest();
        ClientSummary_Handler.mytest();
        test.stopTest();
    }
*/
    
    
	@isTest
    static void testGetAllAccountCount(){
        List<Lead__c> testLeads = new List<Lead__c>{
            new Lead__c(Name='lead1',First_Name__c='test',Lead_Status__c = 'New',Region__c='WEST',Company__c='testcomp1',Email__c='testemail@gmail.com',Vertical_Segment__c='Pharma', OwnerId = UserInfo.getUserId()),
            new Lead__c(Name='lead2',First_Name__c='testing',Lead_Status__c = 'New',Region__c='WEST',Company__c='testcomp1',Email__c='testemail@gmail.com',Vertical_Segment__c='Pharma', OwnerId = UserInfo.getUserId())
        };
        insert testLeads;
        
        List<Account> testAccounts = new List<Account>{
            new Account(Name='acc1',Account_Stage__c = 'Sales complete', OwnerId = UserInfo.getUserId()),
            new Account(Name='acc2',Account_Stage__c = 'New', OwnerId = UserInfo.getUserId()),
            new Account(Name='acc3',Account_Stage__c = 'Onboarding', OwnerId = UserInfo.getUserId())
        };
        insert testAccounts;
        
        Test.startTest();
        ClientSummary_Handler.getAllAccountCount();
        //ClientSummary_Handler.ClientSummaryWrapper wrp = ClientSummary_Handler.ClientSummaryWrapper();
        //ClientSummary_Handler.ClientSummaryWrapper result = ClientSummary_Handler.getAllAccountCount();
        Test.stopTest();
    }


}