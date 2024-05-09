@isTest
public class BanglorePharmaPDFControllerTest {

    /*
   @isTest static void Testmy(){
        test.startTest();
        BanglorePharmaPDFController.mytest();
        test.stopTest();
    }
*/
    
    @isTest static void testBanglorePharmaPDFController() {
         
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
        
        ApexPages.StandardController sc = new ApexPages.StandardController(quoRec);
        PageReference pageRef = Page.ALS_Mumbai_In_Vitro;
        pageRef.getParameters().put('id', String.valueOf(quoRec.Id));
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
         
          BanglorePharmaPDFController pdf1 = new BanglorePharmaPDFController(sc);
               
        Test.stopTest();
    }
}