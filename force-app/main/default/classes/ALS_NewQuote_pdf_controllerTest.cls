@isTest
public class ALS_NewQuote_pdf_controllerTest {

    @isTest static void testALSNewQuotePdfController() {
         
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
               
        Opportunity1__c opp1 = new Opportunity1__c();
        opp1.Name = 'Test';
        opp1.StageName__c = 'New';
        opp1.CloseDate__c = system.today();
        opp1.Region__c = 'West';
        Opp1.AccountId__c = acc.Id;
        Insert opp1;
                
      Quote_C__c quoRec = new Quote_C__c();
        quoRec.Name = 'Test';
         quoRec.OpportunityId__c = opp1.Id;
         quoRec.Quote_Validity1__c = system.today().addDays(2);
        insert quoRec;
         
          Quote_C__c quoRec1 = new Quote_C__c();
        quoRec1.Name = 'Test';
         quoRec1.OpportunityId__c = opp1.Id;
         quoRec1.Quote_Validity1__c = system.today().addDays(2);
         quoRec1.Include_Discount__c = true;
         quoRec1.Include_GST__c = true;
        insert quoRec1;
         
        ApexPages.StandardController sc = new ApexPages.StandardController(quoRec);
        PageReference pageRef = Page.ALS_Banglore_Pharma; // Add your VF page Name here
        pageRef.getParameters().put('id', String.valueOf(quoRec.Id));
        Test.setCurrentPage(pageRef);
         
         ApexPages.StandardController sca = new ApexPages.StandardController(quoRec1);
        PageReference pageRefe = Page.ALS_Banglore_Pharma; // Add your VF page Name here
        pageRefe.getParameters().put('id', String.valueOf(quoRec1.Id));
        Test.setCurrentPage(pageRefe);
         
        Test.startTest();
         
          ALS_NewQuote_pdf_controller pdf1 = new ALS_NewQuote_pdf_controller(sc);
         ALS_NewQuote_pdf_controller pdf2 = new ALS_NewQuote_pdf_controller(sca);
         
        Test.stopTest();

     }
}