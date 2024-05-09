@isTest
public class OpportunityContactRoleValidationTest {
    
    @isTest
    public  static void TestDeleteAccountWithOneOpportunity() {
         User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Service'].Id,
            FirstName = 'Test 1',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuseqwertr@example.com',
            Alias = 'tufser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'
        );
        insert testUser;
        
         Account accRec = UtilityTest.createAccRec('TestAcc');
        Opportunity1__c oppRec = UtilityTest.CreateOppRec('Testopp',accRec.Id, Date.newInstance(2024, 12, 12),testUser.id,'New','North');
        Contact conRec = new Contact();
        conRec.lastname = 'Mukesh';
        conRec.CurrencyIsoCode = 'INR';
        insert conRec;
        Opportunity_Contact_Role1__c oppConRec = new Opportunity_Contact_Role1__c();
        oppConRec.Opportunity1__c = oppRec.id;
        oppConRec.Contact__c = conRec.id;
        oppConRec.IsPrimary__c = true;
        insert oppConRec;
    }
}