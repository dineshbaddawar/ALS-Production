@isTest
public class ContactListViewTest {
    
    @isTest
    static void testFetchContactsBasedOnListView() {
        Contact testContact = new Contact( FirstName = 'Test',LastName = 'Contact',Title = 'Test Title',Email = 'testcontact@gmail.com', Phone = '1234567890',MobilePhone = '9876543210',Billing_Address__City__s = 'Test City', Billing_Address__CountryCode__s = 'US');
        insert testContact;
        Account testAccount = new Account(Name = 'Test Account',Industry = 'Technology',Phone = '1234567890',BillingCity = 'Test City',BillingCountryCode = 'US'  );
        insert testAccount;
        Lead__c testLead = new Lead__c( First_Name__c = 'Test',Name = 'Test Lead',  Lead_Source__c = 'Referral', Region__c = 'South', Email__c = 'testcontact@gmail.com', Vertical_Segment__c = 'Pharma',                                       Company__c = 'Test Company', Address__City__s = 'Test City', Address__CountryCode__s = 'US' );
        insert testLead;
        Opportunity1__c testOpportunity = new Opportunity1__c(Amount__c = 10000, Region__c = 'South', StageName__c = 'Negotiation', CloseDate__c = Date.today().addDays(30) );
        insert testOpportunity;
        Visit__c testVisit = new Visit__c( Actual_Visit_Date__c = Date.today(), Visit_Status__c = 'Pending', Visit_Type__c = 'New',City__c = 'Test City',State__c = 'Test State' );
        insert testVisit;
        Quote_C__c testQuote = new Quote_C__c(Name = 'Test Quote',OpportunityId__c = testOpportunity.id,Lab_Location__c = 'Banglore Lab',CurrencyIsoCode = 'USD',Status__c = 'Presented', BillingAddress__City__s = 'Test City' );
        insert testQuote;
        Test.startTest();
        ExportToExcelController.fetchContactsBasedOnListView('My Contacts', 'Contact');
        ExportToExcelController.fetchContactsBasedOnListView('Recently Viewed Contacts', 'Contact');
        ExportToExcelController.fetchContactsBasedOnListView('Today\'s Contact', 'Contact');
        ExportToExcelController.fetchContactsBasedOnListView('All Contacts', 'Contact');
        ExportToExcelController.fetchAccountsBasedOnListView('My Accounts', 'Account');
        ExportToExcelController.fetchAccountsBasedOnListView('Today\'s Account', 'Account');
        ExportToExcelController.fetchAccountsBasedOnListView('All Accounts', 'Account');
        ExportToExcelController.fetchAccountsBasedOnListView('Recently Viewed Accounts', 'Account');
        ExportToExcelController.fetchLeadsBasedOnListView('My Lead', 'Lead__c');
        ExportToExcelController.fetchLeadsBasedOnListView('Today\'s Leads', 'Lead__c');
        ExportToExcelController.fetchLeadsBasedOnListView('All Leads', 'Lead__c');
        ExportToExcelController.fetchLeadsBasedOnListView('Recently Viewed', 'Lead__c');
        ExportToExcelController.getListViewBasedOnObjectName('Lead__c');
        ExportToExcelController.fetchOpportunitiesBasedOnListView('All Opportunities', 'Opportunity1__c');
        ExportToExcelController.fetchOpportunitiesBasedOnListView('Today\'s Opportunity', 'Opportunity1__c');
        ExportToExcelController.fetchOpportunitiesBasedOnListView('Recently Viewed', 'Opportunity1__c');
        ExportToExcelController.fetchOpportunitiesBasedOnListView('Closed Won Opportunity', 'Opportunity1__c');
        ExportToExcelController.fetchOpportunitiesBasedOnListView('Closed Lost Opportunity', 'Opportunity1__c');
        ExportToExcelController.fetchOpportunitiesBasedOnListView('My Opportunities', 'Opportunity1__c');
        ExportToExcelController.fetchVisitsBasedOnListView('My Visits', 'Visit__c');
        ExportToExcelController.fetchVisitsBasedOnListView('Today\'s Visit', 'Visit__c');
        ExportToExcelController.fetchVisitsBasedOnListView('All Visits', 'Visit__c');
        ExportToExcelController.fetchVisitsBasedOnListView('Recently Viewed', 'Visit__c');
        ExportToExcelController.fetchQuotesBasedOnListView('All Quotes', 'Quote_C__c');
        ExportToExcelController.fetchQuotesBasedOnListView('Pharma Quotes', 'Quote_C__c');
        ExportToExcelController.fetchQuotesBasedOnListView('Certification Quotes', 'Quote_C__c');
        ExportToExcelController.fetchQuotesBasedOnListView('Food Service Quotes', 'Quote_C__c');
        ExportToExcelController.fetchQuotesBasedOnListView('Environmental Quotes', 'Quote_C__c');
      //  ExportToExcelController.fetchQuotesBasedOnListView('Recently Viewed', 'Quote_C__c');
        Test.stopTest();
    }
}