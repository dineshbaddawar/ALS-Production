@isTest
public class SendListEmailTest {
/*
     @isTest static void Testmy(){
        test.startTest();
        SendListEmail.mytest();
        test.stopTest();
    }
*/
    
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
    static void testSendListEmail() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        List<Lead__c> testLeads = new List<Lead__c>{
            new Lead__c(Name='lead1',Region__c='North', Company__c='util', Email__c='test@gmail.com', Vertical_Segment__c='Pharma', First_Name__c='test',Address__Street__s = 'BTM', Address__City__s = 'Bengaluru', Address__StateCode__s = 'KA', Address__CountryCode__s = 'IN',Geo_Location__Latitude__s = 12.951845,Geo_Location__Longitude__s = 77.699577),            
        	new Lead__c(Name='lead2',Region__c='North', Company__c='util2', Email__c='test2@gmail.com', Vertical_Segment__c='Pharma', First_Name__c='test2',Address__Street__s = 'BTM', Address__City__s = 'Bengaluru', Address__StateCode__s = 'KA', Address__CountryCode__s = 'IN',Geo_Location__Latitude__s = 12.951845,Geo_Location__Longitude__s = 77.699577)
                };
        insert testLeads;

        ApexPages.StandardSetController controller = new ApexPages.StandardSetController(testLeads);
        SendListEmail sendListEmailController = new SendListEmail(controller);

        
        PageReference pageRef = sendListEmailController.redirectToLComp();

        
        String expectedUrl = '/lightning/cmp/c__SendListEmailComp?c__listofContacts=' + testLeads[0].Id + ',' + testLeads[1].Id;
    }
    
     @isTest
    static void testLeadsToSendEmail() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        List<Lead__c> testLeads = new List<Lead__c>{
            new Lead__c(Name='lead1',Region__c='North', Company__c='util', Email__c='test@gmail.com', Vertical_Segment__c='Pharma', First_Name__c='test',Address__Street__s = 'BTM', Address__City__s = 'Bengaluru', Address__StateCode__s = 'KA', Address__CountryCode__s = 'IN',Geo_Location__Latitude__s = 12.951845,Geo_Location__Longitude__s = 77.699577),            
        	new Lead__c(Name='lead2',Region__c='North', Company__c='util2', Email__c='test2@gmail.com', Vertical_Segment__c='Pharma', First_Name__c='test2',Address__Street__s = 'BTM', Address__City__s = 'Bengaluru', Address__StateCode__s = 'KA', Address__CountryCode__s = 'IN',Geo_Location__Latitude__s = 12.951845,Geo_Location__Longitude__s = 77.699577)
                };
        insert testLeads;

       List<String> leadIds = new List<String>{testLeads[0].Id, testLeads[1].Id};
           Test.startTest();
        List<Lead__c> resultLeads = SendListEmail.LeadsToSendEmail(leadIds);
        Test.stopTest();

    }
}