@isTest
public class GeoCodeforCustomObjectsTest {
/*
     @isTest static void Testmy(){
        test.startTest();
        GeoCodeforCustomObjects.mytest();
        test.stopTest();
    }

    
    @isTest
    Static Void testGeoCodeforCustomObject(){
        Lead__c ldRec= new Lead__c();
        ldRec.name='test';
        ldRec.First_Name__c = 'lead';
        ldRec.Company__c = 'util';
        ldRec.Company_Type__c = 'Manufacturer';
        ldRec.Region__c ='North';
        ldRec.Vertical_Segment__c = 'Pharma';
        ldRec.Email__c = 'util@gmail.com';
        ldRec.Address__Street__s = 'Btm';
        ldRec.Address__City__s = 'Bengaluru';
        ldRec.Address__StateCode__s = 'KA';
        ldRec.Address__PostalCode__s = '560076';
        ldRec.Address__CountryCode__s = 'IN';
        
        Test.startTest();
        insert ldRec;
        Test.stopTest();

    }
 */   
    
    @isTest
    static void testGetGeolocation() {
        // Test data setup
        // Create test Lead records
        List<Lead__c> testLeads = new List<Lead__c>{
            new Lead__c(Name='lead1',Region__c='North', Company__c='util', Email__c='test@gmail.com', Vertical_Segment__c='Pharma', First_Name__c='test',Address__Street__s = 'BTM', Address__City__s = 'Bengaluru', Address__StateCode__s = 'KA', Address__CountryCode__s = 'IN'),
            new Lead__c(Name='lead2',Region__c='North', Company__c='util', Email__c='test@gmail.com', Vertical_Segment__c='Pharma', First_Name__c='test',Address__Street__s = 'Marathally', Address__City__s = 'Bengaluru', Address__StateCode__s = 'KA', Address__CountryCode__s = 'IN')
            // Add more test Lead records as needed
        };
        insert testLeads;

        // Create a mock HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the method to test
        Test.startTest();
        GeoCodeforCustomObjects.getGeolocation(new Set<Id>{testLeads[0].Id, testLeads[1].Id});
        Test.stopTest();

        // Verify that the geolocation fields are populated
        for (Lead__c lead : [SELECT Id, Address__Latitude__s, Address__Longitude__s, Geo_Location__Latitude__s, Geo_Location__Longitude__s FROM Lead__c WHERE Id IN :testLeads]) {
            System.assertNotEquals(null, lead.Address__Latitude__s);
            System.assertNotEquals(null, lead.Address__Longitude__s);
            System.assertNotEquals(null, lead.Geo_Location__Latitude__s);
            System.assertNotEquals(null, lead.Geo_Location__Longitude__s);
        }
    }
    
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status": "OK", "results": [{"geometry": {"location": {"lat": 12.9154846, "lng": 77.6056969}}}]}');
            res.setStatusCode(200);
            return res;
        }
    }
}