@isTest
private class CustomLookupControllerTest {
   /* 
    @isTest static void Testmy(){
        test.startTest();
        CustomLookupController.mytest();
        test.stopTest();
    }
    */
    
    @isTest
    static void testFetchRecords() {
        User userRec = UtilityTest.createUserCustomService();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        Route__c  route = new Route__c();
        route.City__c = 'Hyderabad';
        route.State__c = 'Telangana';
        //route.Sales_User__c = userRec.Id;
        Insert route;
        List<CustomLookupController.RecordsData> result = CustomLookupController.fetchRecords('Account', 'Name', 'Test', null);
         List<CustomLookupController.RecordsData> result1 = CustomLookupController.fetchRecords('Contact', 'Name', 'Test', 'a');
        CustomLookupController.fetchSalesUsers('User', 'Name', 'Name', userRec.id, 'Customer Service', '');
        CustomLookupController.fetchUsersRoute('Route__c','City__c', 'City__c', 'Hyderabad', 'Telangana');
        Exception exception1 = new System.MathException();
        exception1.setMessage('my message');
    }

}