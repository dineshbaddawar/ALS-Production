@IsTest(SeeAllData=true)
public class CreateProductByPassingCurrencyTest {
    
    @isTest
    Public Static Void testMethodToCurrency(){
        List<PriceBookEntry1__c> defaultPriceBookEntries = new List<PriceBookEntry1__c>();
        User useRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('accTest');
        Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('oppTest',accRec.id,System.today(),useRec.id,'New','South');
        
        Product1__c pdt = new Product1__c();
        pdt.Name = 'Test Product';
        pdt.Region__c = 'North';
        pdt.ProductCode__c ='7876869';
        pdt.Family__c = 'Certification';
        pdt.Vertical__c = 'Environmental';
        pdt.IsActive__c = true;
        insert pdt;
        
        PriceBook1__c pb = new PriceBook1__c();
        pb.Name = 'INR';
        pb.IsActive__c = true;
        pb.Product1Id__c = pdt.Id;
        Insert pb;
        
        /*
        PriceBookEntry1__c pbe = new PriceBookEntry1__c();
        pbe.Pricebook1Id__c = pb.Id;
        pbe.Product1Id__c = pdt.Id;
        pbe.UnitPrice__c = 1000;
        pbe.List_Price__c = 2000;
        pbe.CurrencyIsoCode = 'INR';  
        //  Insert pbe; */
        
        PriceBookEntry1__c pbe =  [SELECT Id,CurrencyIsoCode,Product1Id__c,List_Price__c,UnitPrice__c From PriceBookEntry1__c WHERE CurrencyIsoCode = 'INR' LIMIT 1];
        
        defaultPriceBookEntries.add(pbe);
        test.StartTest();
        CreateProductByPassingCurrency.generateProductPriceBasedOnCurrencyType('INR', 1.5);
        test.stopTest();
    }
}