@IsTest
public class TodayTaskAuraControllerTest {
    
    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example": "response"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest
    Static Void TodayTaskAuraControllerTestMethod(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        List<Visit__c> visitList = new List<Visit__c>();
        List<Visit__c> visitListtwo = new List<Visit__c>();
        
        List<Lead__c> testLeads = new List<Lead__c>{
            new Lead__c(Name='lead1',Region__c='North', Company__c='util', Email__c='test@gmail.com', Vertical_Segment__c='Pharma', First_Name__c='test',Address__Street__s = 'BTM', Address__City__s = 'Bengaluru', Address__StateCode__s = 'KA', Address__CountryCode__s = 'IN',Geo_Location__Latitude__s = 12.951845,Geo_Location__Longitude__s = 77.699577)            
                };
                    insert testLeads;
        User userRec = UtilityTest.createUserCustomService();
        Account accRec = UtilityTest.createAccRec('TestName');
        Account acc = new Account();
        acc.Id = accrec.Id;
        acc.BillingStreet = 'btm';
        acc.BillingCity = 'Banglore';
        acc.BillingState = 'KA';
        acc.BillingPostalCode = '560076';
        acc.BillingCountry = 'IN';
        acc.Geo_Location__Latitude__s = 12.9296628;
        acc.Geo_Location__Longitude__s = 77.5915664;
        update acc;
        Contact conRec = UtilityTest.createConRec('Test','Name');
        conRec.Email = 'testcon@gmai.com';
        Update conRec;
        //Opportunity1__c oppRec = UtilityTest.CreateOppRecCustomerService('TestOpportunity', accRec.Id, Date.newInstance(2024,12,12), userRec.Id, 'New','North');
        Opportunity1__c oppRec = UtilityTest.CreateOppRec('TestOpportunity', accRec.Id, Date.newInstance(2024,12,12), userRec.Id, 'New', 'North');
        System.debug('Opportunity Id from test Class ==>'+oppRec.Id);
        /*
Opportunity1__c oppRec = new Opportunity1__c();
oppRec.Name = '';
oppRec.AccountId__c = '';
oppRec.CloseDate__c = ;
system.debug('Opportunity Id from test Class ==>'+opp.Id);
*/
        Case caseRec = UtilityTest.createCsRec(accRec.Id, conRec.Id, 'On Hold', 'Phone', 'Test Reason', 'High', 'Problem', 'Test Subject', 'Test Description');
        Monthly_Beat_Plan__c mbpRec = UtilityTest.createMBPRec('In Progress',userRec.Id,Date.newInstance(2024,5,31) , 'January', Date.newInstance(2024,5,1), 'Draft');
        Weekly_Beat_Plan__c wbpRec = UtilityTest.createWBPRec(Date.newInstance(2024,5,26), Date.newInstance(2024,5,20), 'W3', 'Week 3', mbpRec.Id);
        Monthly_Travel_Expense__c mteRec = UtilityTest.createMTERec('Test','In Progress',Date.newInstance(2024,12,12),Date.newInstance(2024,12,31),Date.newInstance(2024,12,20),UserInfo.getUserId());
        Day_Visit_Plan__c dvpRec = UtilityTest.createDVPRec(UserInfo.getUserId(), Date.newInstance(2024,12,12), 'January', '2024', Date.newInstance(2024,12,12), Date.newInstance(2024,12,31), mteRec.Id);
        Visit__c vRec = UtilityTest.createVisitRec(Date.newInstance(2024,12,12), accRec.Id);
        Visit__c vst = new Visit__c();
        vst.Id = vRec.Id;
        vst.Planned_Visit_Date__c = Date.newInstance(2024,12,12);
        vst.Monthly_Beat_Plan__c = mbpRec.Id;
        vst.Assigned_User__c = userRec.Id;
        vst.RSM__c = userRec.Id;
        vst.Weekly_Beat_Plan__c = wbpRec.Id;
        update vst;
        visitList.add(vst);
        
        Visit__c vstRec = new Visit__c();
        vstRec.Lead__c = testLeads[0].Id;
        vstRec.Planned_Visit_Date__c = Date.newInstance(2024,12,12);
        vstRec.Monthly_Beat_Plan__c = mbpRec.Id;
        vstRec.Assigned_User__c = userRec.Id;
        vstRec.Weekly_Beat_Plan__c = wbpRec.Id;
        Insert vstRec;
        visitListtwo.add(vstRec);
        Task testTask = new Task();
        testTask.Subject = 'Test Mom Activity Task';
        testTask.Visit__c = vRec.Id;
        testTask.Is_Mom_Activity__c = true;
        testTask.WhoId = conRec.Id;
        testTask.WhatId = accRec.Id;
        insert testTask; 
        
        Route_Master__c rmRec = new Route_Master__c();
        rmRec.City__c = 'Hyderabad';
        rmRec.State__c = 'Telangana';
        Insert rmRec;
        
        Route__c route = new Route__c();
        String controllingField = 'State__c';
        String dependentField = 'City__c';
        route.City__c = 'Hyderabad';
        route.State__c = 'Telangana';
        Insert route;
        
        Test.startTest();
        TodayTaskAuraController.createVisitActivity(oppRec.Id, vst.Id);
        TodayTaskAuraController.createVisitrecord(testLeads[0].Id);
        TodayTaskAuraController.getAllVisitTodays('12-12-2024'); //Date.today().format()
        TodayTaskAuraController.GetCompletedVisitRecords(Date.today().format());
        TodayTaskAuraController.getSelectedVisitDetails(vst.Id);
        TodayTaskAuraController.StartDayVisitForVistitRecord('12.9296628', '77.5915664', visitList);
        TodayTaskAuraController.updateEndDayVisitRecord('37.531319', '-82.100868');
        TodayTaskAuraController.updateAmendVisitRecord(vst);
        TodayTaskAuraController.saveTask(testTask);
        TodayTaskAuraController.LogCall(testTask);
        TodayTaskAuraController.LogCall(testTask);
        TodayTaskAuraController.saveOpportunity(oppRec);
        TodayTaskAuraController.saveCase(caseRec);
        TodayTaskAuraController.checkInUpdateVisit('12.9296628', '77.5915664',vst.Id);
        TodayTaskAuraController.checkOutUpdateVisit('12.9296628', '77.5915664',vst.Id);
        TodayTaskAuraController.getPastVisitDetails(acc.Id);
        TodayTaskAuraController.getRelOppList(acc.Id);
        TodayTaskAuraController.getRelInvoiceList(acc.Id);
        TodayTaskAuraController.getRelCaseList(acc.Id);
        TodayTaskAuraController.getRelTaskList(acc.Id);
        TodayTaskAuraController.getTodayVisitRecordListNew();
        TodayTaskAuraController.createMomActivityLog('Test Description', vst.Id, 'Test Subject', userRec.Id, 'util@gmail.com');
        TodayTaskAuraController.createMomActivityLog('Test Description', vstRec.Id, 'Test Subject', userRec.Id, 'util@gmail.com');
        TodayTaskAuraController.getSelectedContactEmail(conRec.Id);
        TodayTaskAuraController.checkMomActivityBeforeCheckOutVisit(vst.Id);
        TodayTaskAuraController.getCaseList(vst.Id);
        TodayTaskAuraController.getDependentPicklist(route, controllingField, dependentField);
        TodayTaskAuraController.decimalToBinary(50);
        TodayTaskAuraController.base64ToBits('base');
        TodayTaskAuraController.populateRoute('Hyderabad', 'Telangana');
        TodayTaskAuraController.getSalesUser();
        TodayTaskAuraController.saveRoute('Hyderabad', 'Telangana', rmRec.Id,userRec.Id);
        TodayTaskAuraController.createRouteMaster('Test Route', 'Test city', 'Test State');
        //TodayTaskAuraController.mytest();
        Test.stopTest();
    }
    
}