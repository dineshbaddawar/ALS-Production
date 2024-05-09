@isTest
public class OpportunityReminderBatchClassTest {

   public static testMethod void testme(){
        Account acc = new Account();
       acc.name = 'Test';
       acc.CurrencyIsoCode = 'INR';
       acc.OwnerId = UserInfo.getUserId();
       acc.RSM__c = UserInfo.getUserId();
       insert acc;
       Test.startTest();
        OpportunityReminderBatchClass ba= new OpportunityReminderBatchClass();
        Id jobid= Database.executeBatch(ba,5);
        Test.stopTest();
    }
}