@isTest
public class MultipleAdddressContactControllerTest {
    
    @isTest
    static void testUpdateOpportunityAccountAddress1() {
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
        
        Account accRec = UtilityTest.createAccRec('TestName');
        accRec.ShippingStreet = 'Near Uday Nagar Nit garden';
        accRec.ShippingCity = 'Nagpur';
        accRec.ShippingPostalCode = '440024';
        accRec.BillingStreet = 'Shri Krishna Nagar';
        accRec.BillingCity = 'Nagpur';
        accRec.BillingPostalCode = '440024';
        update accRec;
        
       
        
        
        Contact conRec = UtilityTest.createConRec('TestContact', 'Dummy');
        conRec.AccountId = accRec.id;
        update conRec;
        
         Visit__c vsRec = new Visit__c();
         vsRec.Account__c = accRec.id;
        vsRec.Contact_Person__c = conRec.id;
       // vsRec.Visit_Name__c = 'Testing ';
        insert vsRec;
        
        Opportunity1__c oppRec = UtilityTest.CreateOppRec('Testopp',accRec.Id, Date.newInstance(2024, 12, 12),testUser.id,'New','North');
        
        Dispatch_Address__c disAdd = new Dispatch_Address__c();
        disAdd.Account__c= accRec.Id;
        disAdd.Type__c = 'Billing';
        disAdd.Address__City__s ='Banglore';
        disAdd.Address__CountryCode__s = 'IN';
        disAdd.Address__PostalCode__s = '560076';
        disAdd.Address__StateCode__s = 'KA';
        disAdd.Address__Street__s = 'Panduranga Nagar';
        Insert disAdd;
        
        Dispatch_Address__c disAdd1 = new Dispatch_Address__c();
        disAdd1.Account__c= accRec.Id;
        disAdd1.Type__c = 'Shipping';
        disAdd1.Address__City__s ='Banglore';
        disAdd1.Address__CountryCode__s = 'IN';
        disAdd1.Address__PostalCode__s = '560076';
        disAdd1.Address__StateCode__s = 'KA';
        disAdd1.Address__Street__s = 'Yashwanthpur';
        Insert disAdd1;
        
        Visit__c vstRec = new Visit__c();
        vstRec.City__c = 'Hyderabad';
        vstRec.State__c = 'telangana';
        vstRec.Account__c = accRec.Id;
        vstRec.Contact_Person__c = conRec.Id;
        Insert vstRec;
        
        MultipleAddressContactController.UpdateOpportunityAccountAddresss(conRec.Id,'Shipping','Billing');
        MultipleAddressContactController.getAllCustomerAddress(conRec.Id);
        MultipleAddressContactController.UpdateOpportunityAccountAddresss(null, 'Shipping', 'Billing');
        //MultipleAddressContactController.UpdateOpportunityAccountAddresss(conRec.Id, 'OtherShipping', 'OtherBilling');
        MultipleAddressContactController.UpdateOpportunityAccountAddresss(conRec.Id, disAdd1.Id, disAdd.Id);
        MultipleAddressContactController.getFieldSet();
        MultipleAddressContactController.getVisitDetails(vstRec.Id);
        MultipleAddressContactController.getVisitRelatedContact(vstRec.Id);
        MultipleAddressContactController.UpdateVisitAccountAddresss(vstRec.Id, 'Shipping', 'Billing');
        MultipleAddressContactController.updateVisitContact(vstRec.Id, conRec.Id);

    }
    
    
   
}