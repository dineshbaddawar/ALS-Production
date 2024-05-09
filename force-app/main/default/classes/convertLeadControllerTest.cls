@isTest
public class convertLeadControllerTest {
    /*
    @isTest static void Testmy(){
        test.startTest();
        convertLeadController.mytest();
        test.stopTest();
    }
    */
    @isTest
    static void testGetLeads() {
        
         User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Service'].Id,
            FirstName = 'Test 1',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuseqwertr345@example.com',
            Alias = 'tufser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'
        );
        insert testUser;
        
        Lead__c ldRec = UtilityTest.createLeadRec('Test', 'Nano', 'Maruti Suzuki', 'North', 'testnano@gmail.com', 'Food Service');
        
        Lead ldtest = new Lead();
        ldtest.LastName = 'test Lead';
        ldtest.Company = 'Test Technology Pvt Ltd';
        ldtest.Status = 'Close Converted';
        insert ldtest;
        
        Account accRec = new Account();
        accRec.Name = 'Test Account';
        Insert accRec;
        Contact conRec = new Contact();
        conRec.FirstName = 'TestName';
        conRec.LastName = 'TQwerty';
        conRec.Salutation = 'Mr';
        insert conRec;
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('Anwar',accRec.id,System.today(),testUser.id,'New','South');
        Opportunity opp = new Opportunity();
        opp.Name = 'test opp';
        opp.AccountId = accRec.Id;
        opp.CloseDate = system.today().addDays(2);
        opp.StageName = 'New';
        Insert opp;
        List<Lead> resultLeads = convertLeadController.getLeads(ldRec.Id);        
        convertLeadController.UpdateleadStatus(ldtest.id);
        convertLeadController.createAccount('Test Account');
        convertLeadController.createContact(conRec.Salutation,conRec.FirstName,conRec.LastName);
        convertLeadController.createRecords(accRec.Name,conRec.Salutation,conRec.FirstName,conRec.LastName,oppRec.Name,testUser.Id);
        convertLeadController.createopportunity(oppRec.Name);
        convertLeadController.getopportunityData(accRec.Id);
    }
    

}