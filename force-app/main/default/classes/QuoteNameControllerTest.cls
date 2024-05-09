@isTest
public class QuoteNameControllerTest {

    @isTest
    Public Static Void QuoteNameTest(){
        
        User useRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('Test');
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('Test',accRec.id,System.today(),useRec.id,'New','South');
        
        List<Quote_C__c> quotList = new List<Quote_C__c>();
        Quote_C__c Qt1 = new Quote_C__c();
        Qt1.Name = 'QUO-BNL-202403/00001';
        Qt1.OpportunityId__c = oppRec.Id;
        Qt1.Primary__c = true;
        Qt1.Lab_Location__c = 'Banglore Lab';
        quotList.add(Qt1);
        Insert quotList;
        
        
        List<Quote_C__c> quotList2 = new List<Quote_C__c>();
        Quote_C__c Qt2 = new Quote_C__c();
        Qt2.Name = 'QUO-MUM-202403/00001';
        Qt2.OpportunityId__c = oppRec.Id;
        Qt2.Primary__c = true;
        Qt2.Lab_Location__c = 'Mumbai Lab';
        quotList2.add(Qt2);
        Insert quotList2;
        
        
        QuoteNameController.createQuoteName(quotList);
        QuoteNameController.createQuoteName(quotList2);
        QuoteNameController.getNextQuoteNumber();
        QuoteNameController.getNextMumQuoteNumber();
    }
}