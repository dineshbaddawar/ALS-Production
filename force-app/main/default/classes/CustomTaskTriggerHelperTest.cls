@isTest
public class CustomTaskTriggerHelperTest {
    
	 @isTest
    static void testUpdateAuditedField() {
        Lead__c ldRec = UtilityTest.createLeadRec('Test', 'Nano', 'Maruti Suzuki', 'North', 'testnano@gmail.com', 'Food Service');
        
        Task__c testTask = new Task__c(
            Subject__c = 'Mark Audited',
            Status__c = 'Open',
            Lead__c = ldRec.Id
        );
        insert testTask;
        
        testTask.Status__c = 'Completed';
        update testTask;
        
        Task__c testTask1 = new Task__c(
            Subject__c = 'Meeting With Customer',
            Status__c = 'Open',
            Lead__c = ldRec.Id
        );
        insert testTask1;
        
        testTask1.Status__c = 'Completed';
        update testTask1;
        
        
        Map<Id, Task__c> oldTaskMap = new Map<Id, Task__c>();
        oldTaskMap.put(testTask.Id, testTask);
        
        Map<Id, Task__c> oldTaskMap1 = new Map<Id, Task__c>();
        oldTaskMap1.put(testTask1.Id, testTask1);
        
        Test.startTest();
        //CustomTaskTriggerHelper.updateAuditedField(new List<Task__c>{testTask}, oldTaskMap);
       // CustomTaskTriggerHelper.updateCompletedDateTime(new List<Task__c>{testTask});
        //CustomTaskTriggerHelper.updateLeadStageOnTaskCompleted(new List<Task__c>{testTask1}, oldTaskMap1);
        Test.stopTest();
    }

}