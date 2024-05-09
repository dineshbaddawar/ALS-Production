@isTest
public class OpportunityTriggerHandlerTest {
  @isTest static void Testmy(){
        test.startTest();
        OpportunityTriggerHandler.mytest();
        test.stopTest();
    }
    
    @isTest
    Static Void OpportunityTriggerHandlerTestMethod(){
        
        Map<Id,Opportunity1__c> oppMap =new Map<Id,Opportunity1__c>();
        User userRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('TestAcc');
        String accReccreatedId = [Select id, CreatedById from Account where id =:accRec.Id].CreatedById;
        System.deBug('accReccreatedId::'+accReccreatedId);
        
        Incentive_Plan__c ipRec = UtilityTest.createIpRec('Test Incentive Plan',userRec.Id,5);
        Fiscal_Year__c fyRec= UtilityTest.createfyRec('test FyRecord', ipRec.Id ,Date.newInstance(2024, 12, 12) );
        //Yearly_Goal__c ygRec = UtilityTest.createYgRec('Test Ygrecord', userRec.Id, fyRec.Id);
        Yearly_Goal__c Yy = new Yearly_Goal__c();
        Yy.Yearly_Goal_Start_Period__c = Date.newInstance(2024, 12, 11);
        Yy.Name = 'Testomg';
        Yy.User__c=UserInfo.getUserId();
        Yy.Fiscal_Year__c = fyRec.Id;
        Yy.Yearly_Target__c = 250000;
        Yy.Yearly_Goal_End_Period__c = Date.newInstance(2024, 12, 30);
        insert Yy; 
        Quarterly_Goal__c qgRec = UtilityTest.createQuaRec('Test Quarter', userRec.Id,Yy.Id ,fyRec.Id);
        Quarterly_Goal__c qgRec2 = UtilityTest.createQuaRec('Test Quarter2', userRec.Id,Yy.Id ,fyRec.Id);
        //Opportunity1__c oppRec = UtilityTest.CreateOppRec('Testoppty',accRec.Id, Date.newInstance(2024, 12, 12),userRec.Id,'New','West');
        Opportunity1__c oppRec = new Opportunity1__c();
       	oppRec.Name = 'Testoppty';
        oppRec.AccountId__c = accRec.Id;
        oppRec.CloseDate__c= system.today().addDays(2);
        oppRec.Customer_Success__c = userRec.Id;
        oppRec.StageName__c = 'New';
        oppRec.Region__c = 'WEST';
        oppRec.Amount__c = 1000;
        oppRec.PO_Date__c = Date.newInstance(2024, 12, 12);
        oppRec.PO_Number__c = '123';
        oppRec.Billing_Address__Street__s ='Appollo Hospital';
        oppRec.Billing_Address__City__s = 'Bengaluru';
        oppRec.Billing_Address__StateCode__s = 'KA';
        oppRec.Billing_Address__PostalCode__s = '560076';
        oppRec.Billing_Address__CountryCode__s = 'IN';
        oppRec.Quarterly_Goal__c = qgRec.Id;
        oppRec.Fiscal_Year__c = fyRec.Id;
        Insert oppRec;
        
        Opportunity1__c oppRec1 = new Opportunity1__c();
       	oppRec1.Name = 'Testoppty';
        oppRec1.AccountId__c = accRec.Id;
        oppRec1.CloseDate__c= system.today().addDays(2);
        oppRec1.Customer_Success__c = userRec.Id;
        oppRec1.StageName__c = 'Closed Won';
        oppRec1.Region__c = 'WEST';
        oppRec1.Amount__c = 1000;
        oppRec1.PO_Date__c = Date.newInstance(2024, 12, 12);
        oppRec1.PO_Number__c = '123';
        oppRec1.Billing_Address__Street__s ='Appollo Hospital';
        oppRec1.Billing_Address__City__s = 'Bengaluru';
        oppRec1.Billing_Address__StateCode__s = 'KA';
        oppRec1.Billing_Address__PostalCode__s = '560076';
        oppRec1.Billing_Address__CountryCode__s = 'IN';
        oppRec1.Quarterly_Goal__c = qgRec.Id;
        oppRec1.Fiscal_Year__c = fyRec.Id;
        Insert oppRec1;
        oppMap.put(oppRec1.Id,oppRec1);
        Product1__c prodRec = UtilityTest.createProdRec('Test Product','TP','Food','Food','TESTMETHOD','Chemistry',true);
        OpportunityLineItem1__c oliRec = UtilityTest.createOliRec(oppRec.Id,prodRec.Id,10,100,90,900,900,'TP');
        OpportunityLineItem1__c oliRec1 = UtilityTest.createOliRec(oppRec1.Id,prodRec.Id,10,100,90,900,900,'TP');
        String oliOwnerId = [Select id, CreatedById from OpportunityLineItem1__c where id =:oliRec.Id].CreatedById;
        System.deBug('olicreatedbyId::'+oliOwnerId);
        
        Product_Fixed_Price__c pfp = new Product_Fixed_Price__c();
        pfp.Account__c = accRec.Id;
        pfp.Product__c = prodRec.Id;
        pfp.Selling_Price__c = 600;
        Insert pfp;
        
        Opportunity1__c oli = new Opportunity1__c();
        oli.Id = oppRec.Id;
        oli.StageName__c = 'Closed Won';
        oli.Amount__c = 1000;
        oli.PO_Date__c = Date.newInstance(2024, 12, 12);
        oli.PO_Number__c = '123';
        oli.Billing_Address__Street__s ='Appollo Hospital';
        oli.Billing_Address__City__s = 'Bengaluru';
        oli.Billing_Address__StateCode__s = 'KA';
        oli.Billing_Address__PostalCode__s = '560076';
        oli.Billing_Address__CountryCode__s = 'IN';
        oli.Quarterly_Goal__c = qgRec.Id;
        oli.Fiscal_Year__c = fyRec.Id;
        update oli;

        Quarterly_Goal__c qg = new Quarterly_Goal__c();
        qg.Id = qgRec.id;
        qg.Total_Target_Achieved__c = 2000;
        update qg;
        
        
        OpportunityTriggerHandler.insertNewProductFixedPriceRecord(oppMap);
     
    }

}