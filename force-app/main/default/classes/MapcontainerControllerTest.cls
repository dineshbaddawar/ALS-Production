@isTest
public class MapcontainerControllerTest {
    
     private class MockHttpResponseGenerator implements HttpCalloutMock {
        
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('{"results": [{"formatted_address": "Expected Address"}]}');
            return response;
        }
    }
    
    @isTest
    static void getAccountDetails(){
        
        List<Lead__c> testLeads = new List<Lead__c>{
            new Lead__c(Name='lead1',Region__c='North', Company__c='util', Email__c='test@gmail.com', Vertical_Segment__c='Pharma', First_Name__c='test',Address__Street__s = 'BTM', Address__City__s = 'Bengaluru', Address__StateCode__s = 'KA', Address__CountryCode__s = 'IN')            
        };
        insert testLeads;
        Account accRec = UtilityTest.createAccRec('TestName');
        Account acc = new Account();
        acc.id = accRec.Id;
        acc.BillingStreet='Panduranga Nagar';
        acc.BillingCity ='Banglore';
        acc.BillingState = 'KA';
        acc.BillingPostalCode = '560076';
        acc.BillingCountry = 'IN';
        update acc;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        MapcontainerController.getAccountDetails(acc.Id);
        MapcontainerController.getLeadDetail(testLeads[0].id);
        Test.stopTest();
    }
    
    @isTest
    static void testGoogleMapReverseGeocodeCallout(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        String testlat = '37.7749';
        String testlng = '-122.4194';
        MapcontainerController.GoogleMapReverseGeocodeCallout(testLat, testLng);       
        String result = MapcontainerController.GoogleMapReverseGeocodeCallout(testlat, testlng);        
        Test.stopTest();
    }
    
}