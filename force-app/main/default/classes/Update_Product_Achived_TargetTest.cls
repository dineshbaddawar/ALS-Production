@isTest
public class Update_Product_Achived_TargetTest {
/*
     @isTest static void Testmy(){
        test.startTest();
        Update_Product_Achived_Target.mytest();
        test.stopTest();
    }
*/
    
    @isTest
    static void testGetclosedOwn_Opportunity() {
      List<Opportunity1__c> testOpportunities = new List<Opportunity1__c>();
        List<OpportunityLineItem1__c> testOpportunityLineItems = new List<OpportunityLineItem1__c>();
        List<Fiscal_Year__c> testFiscalYears = new List<Fiscal_Year__c>();
        List<Product_Achived_Target__c> testPATs = new List<Product_Achived_Target__c>();
            Map<Id,List<OpportunityLineItem1__c>> testMapOpportunityLineItems = new Map<Id,List<OpportunityLineItem1__c>>();
            
         User useRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('Banoj');
        Fiscal_Year__c fy = new Fiscal_Year__c();
        fy.Fiscal_Year_Start_Period__c = system.today();
        fy.Name = 'Testomg';
        insert fy;
        testFiscalYears.add(fy);
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('Anwar',accRec.id,System.today(),useRec.id,'New','South');
        oppRec.Fiscal_Year__c = fy.Id;
        oppRec.StageName__c = 'Closed Won';
        oppRec.PO_Date__c = Date.newInstance(2024, 12, 12);
        oppRec.PO_Number__c = '567890';
        oppRec.Billing_Address__Street__s = 'btm';
        oppRec.Billing_Address__City__s = 'Benguluru';
        oppRec.Billing_Address__StateCode__s = 'KA';
        oppRec.Billing_Address__PostalCode__s = '560076';
        oppRec.Billing_Address__CountryCode__s = 'IN';
        update oppRec;
        testOpportunities.add(oppRec);
        Product1__c pdt = new Product1__c();
        pdt.Name = 'Test Product';
        pdt.Region__c = 'North';
        pdt.ProductCode__c ='7876869';
        pdt.Family__c = 'Certification';
        pdt.Vertical__c = 'Certification';
        pdt.IsActive__c = true;
        insert pdt;
        
        PriceBook1__c pb = new PriceBook1__c();
        pb.Name = 'Standard';
        pb.IsActive__c = true;
        pb.Product1Id__c = pdt.Id;
        Insert pb;
        
        PriceBookEntry1__c pbe = new PriceBookEntry1__c();
        pbe.Pricebook1Id__c = pb.Id;
        pbe.Product1Id__c = pdt.Id;
        pbe.UnitPrice__c = 1000;
        Insert pbe;
        
        Quote_C__c Qt = new Quote_C__c();
        qt.Name = 'Test Quote';
        qt.OpportunityId__c = oppRec.Id;
       	qt.Primary__c = true;
        Insert qt;
        
        QuoteLineItems_c__c qli = new QuoteLineItems_c__c();
        qli.ProductId__c = pdt.id;
        qli.QuoteId__c = qt.Id;
        qli.Quantity__c = 1;
        qli.List_Price__c = 1000;
        qli.Sales_Price__c = 2000;
        qli.Discount__c = 5;
        qli.Subtotal__c = 1000;
        qli.Total_Price__c = 950;
        Insert qli;

        OpportunityLineItem1__c oli = new OpportunityLineItem1__c();
        oli.Opportunity1Id__c = qli.QuoteId__r.OpportunityId__c;
        oli.QuoteLineitemId__c = qli.Id;
        oli.Name = qli.ProductId__r.Name;
        oli.Product1Id__c = qli.ProductId__c;
        oli.ProductCode__c = qli.Product_Code__c;
        oli.Quantity__c = qli.Quantity__c;
        oli.ListPrice__c = qli.Sales_Price__c;
        oli.UnitPrice__c = qli.List_Price__c;
        oli.Discount__c = qli.Discount__c;
        oli.Subtotal__c = qli.Subtotal__c;
        oli.TotalPrice__c = qli.Total_Price__c;
        insert oli;
        testOpportunityLineItems.add(oli);
        testMapOpportunityLineItems.put(oppRec.Id,testOpportunityLineItems);

        Product_Achived_Target__c pat = new Product_Achived_Target__c();
        pat.Fiscal_Year__c = fy.Id;
        pat.IsActive__c = true;
        pat.Product__c = pdt.Id;
        pat.Achived_Target__c = 300;
        pat.Target__c = 500;
        Insert pat;
        testPATs.add(pat);

        Test.startTest();
        Set<Id> opportunityIds = new Set<Id>();       
            opportunityIds.add(oppRec.Id);        
        Update_Product_Achived_Target.getClosedOwn_Opportunity(opportunityIds);
        List<Product_Achived_Target__c> updatedPATs = Update_Product_Achived_Target.PreparedataAsPerFiscalYearValue(testOpportunities, testPATs, testMapOpportunityLineItems);
        Test.stopTest();
    }
    
}