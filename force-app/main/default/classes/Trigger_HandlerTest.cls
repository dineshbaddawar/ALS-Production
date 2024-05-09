@isTest
public class Trigger_HandlerTest {
    @isTest static void FirstMethod(){
        List<Fiscal_Year__c> fList = new List<Fiscal_Year__c>();
        Fiscal_Year__c fy = new Fiscal_Year__c();
        fy.Fiscal_Year_Start_Period__c = system.today();
        fy.Name = 'Testomg';
        insert fy;
        fList.add(fy);
        Trigger_Handler.CreateQuarterPeriodsRec(fList);
    }
    @isTest static void secondMethod(){
        Fiscal_Year__c fy = new Fiscal_Year__c();
        fy.Fiscal_Year_Start_Period__c = system.today();
        fy.Name = 'Testomg';
        insert fy;
        List<Yearly_Goal__c> yList = new List<Yearly_Goal__c>();
        Yearly_Goal__c Yy = new Yearly_Goal__c();
        Yy.Yearly_Goal_Start_Period__c = system.today();
        Yy.Name = 'Testomg';
        Yy.Fiscal_Year__c = fy.Id;
        Yy.Yearly_Target__c = 250000;
        Yy.Yearly_Goal_End_Period__c = system.today()+10;
        insert Yy; 
        yList.add(Yy);
       Trigger_Handler.CreateQuarterlyGoalRec(yList);
    }
    
    @isTest static void thirdMethod(){
        
        User userRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('TestAcc');
        
        Incentive_Plan__c ipRec = UtilityTest.createIpRec('Test Incentive Plan',userRec.Id,5);
        Fiscal_Year__c fyRec= UtilityTest.createfyRec('test FyRecord', ipRec.Id ,Date.newInstance(2024, 12, 12) );
        Fiscal_Year__c fyRec1 = new Fiscal_Year__c();
        fyRec1.Id = fyRec.Id;
        fyRec1.Fiscal_Year_End_Period__c = Date.newInstance(2024, 12, 12);
        update fyRec1;
        Map<Id, date> startDate = new Map<Id, Date>();
        startDate.put(fyRec1.Id,fyRec1.Fiscal_Year_Start_Period__c);
        Map<Id, date> endDate = new Map<Id, Date>();
        endDate.put(fyRec1.Id,fyRec1.Fiscal_Year_End_Period__c);
        Yearly_Goal__c Yy = new Yearly_Goal__c();
        Yy.Yearly_Goal_Start_Period__c = Date.newInstance(2024, 12, 11);
        Yy.Name = 'Testomg';
        Yy.User__c=UserInfo.getUserId();
        Yy.Fiscal_Year__c = fyRec.Id;
        Yy.Yearly_Target__c = 250000;
        Yy.Yearly_Goal_End_Period__c = Date.newInstance(2024, 12, 30);
        insert Yy; 
        List<Quarterly_Goal__c> qgList = new List<Quarterly_Goal__c>();
        Quarterly_Goal__c qgRec = UtilityTest.createQuaRec('Test Quarter', userRec.Id,Yy.Id ,fyRec.Id);
        qgList.add(qgRec);
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
        
        Trigger_Handler.updateExistingOpportunityWithQuarterlyGoal(qgList);
        Trigger_Handler.getFiscalYearIdForCloseDate(system.today(),startDate,endDate);
    }

}