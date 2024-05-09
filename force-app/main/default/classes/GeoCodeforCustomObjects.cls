public class GeoCodeforCustomObjects {
    
    Public Static Void getLeadrecords(List<Lead__c> newLeads){
        Set<Id> leadIdsToUpdate = new Set<Id>();
        for (Lead__c newLead : newLeads) {
            if (newLead.Address__Street__s != null || newLead.Address__City__s != null || newLead.Address__StateCode__s != null|| newLead.Address__CountryCode__s != null) { // Check if Address__c is not null
                leadIdsToUpdate.add(newLead.Id);
            }
        }
        if (!leadIdsToUpdate.isEmpty()) {
            GeoCodeforCustomObjects.getGeolocation(leadIdsToUpdate);
        }
    }
    
    public static void getLeadrecordsUpdate(List<Lead__c> newLeads, Map<Id, Lead__c> oldLeadMap) {
        Set<Id> leadIdsToUpdate = new Set<Id>();
        for (Lead__c newLead : newLeads) {
            Lead__c oldLead = oldLeadMap.get(newLead.Id);
            if (newLead.Address__Street__s != oldLead.Address__Street__s || newLead.Address__City__s != oldLead.Address__City__s || newLead.Address__StateCode__s != oldLead.Address__StateCode__s|| newLead.Address__CountryCode__s != oldLead.Address__CountryCode__s) {
                leadIdsToUpdate.add(newLead.Id);
            }
        }
        if (!leadIdsToUpdate.isEmpty()) {
            GeoCodeforCustomObjects.getGeolocation(leadIdsToUpdate);
        }
    }
    
    @future(callout=true)
    public static void getGeolocation(Set<Id> leadIds) {
        
        String API_KEY = System.Label.GeoCodeAPIKey;
        System.debug('API_KEY ==>' +API_KEY);
        
        List<Lead__c> leadsToUpdate = [SELECT Id, Address__c FROM Lead__c WHERE Id IN :leadIds];
        List<Lead__c> leadsToUpdateWithGeolocation = new List<Lead__c>();
        
        for (Lead__c lead : leadsToUpdate) {
            Address customAddress = lead.Address__c;
            String city = customAddress != null && customAddress.getCity() != null ? customAddress.getCity().deleteWhitespace() : null;
            String street = customAddress != null && customAddress.getStreet() != null ? customAddress.getStreet().deleteWhitespace() : null;
            String stateCode = customAddress != null && customAddress.getStateCode() != null ? customAddress.getStateCode() : null;
            //String countryCode = customAddress != null && customAddress.getCountryCode() != null ? customAddress.getCountryCode() : null;
            String countryCode = customAddress != null && customAddress.getCountry() != null ? customAddress.getCountry() : null;
            
            if (city != null && street != null && stateCode != null && countryCode != null) {
                String address = street + ', ' + city + ', ' + stateCode + ', ' + countryCode;
                string formatted_address = address.replace(' ', '+'); 
                system.debug('address -- ' + address );
                system.debug('formatted_address -- ' + formatted_address );
                Http httpProtocol = new Http();
                HttpRequest request = new HttpRequest();
                
                string address2 = 'White House, Pennsylvania Avenue Northwest, Washington, DC, United States'; 
                string formatted_address2 = address2.replace(' ', '+'); 
                system.debug('address2 -- ' + address2 );
                system.debug('formatted_address2 -- ' + formatted_address2 );
                
                
                //String endpoint = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + EncodingUtil.urlEncode(address, 'UTF-8') + '&key=' + API_KEY;
                String endpoint = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + EncodingUtil.urlEncode(formatted_address, 'UTF-8') + '&key=' + API_KEY;
                request.setEndPoint(endpoint);
                request.setMethod('GET');
                HttpResponse response = httpProtocol.send(request);
                System.debug('response ==>' + response);
                Map<String, Decimal> coordinates = new Map<String, Decimal>();
                if (response.getStatusCode() == 200) {
                    System.debug('Inside 200 ==>');
                    Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    System.debug('jsonResponse ==>'+jsonResponse);
                    if ('OK'.equals(jsonResponse.get('status'))) {
                        List<Object> results = (List<Object>)jsonResponse.get('results');
                        if (!results.isEmpty()) {
                            Map<String, Object> geometry = (Map<String, Object>)((Map<String, Object>)results[0]).get('geometry');
                            Map<String, Object> location = (Map<String, Object>)geometry.get('location');
                            coordinates.put('latitude', (Decimal)location.get('lat'));
                            coordinates.put('longitude', (Decimal)location.get('lng'));
                            System.debug('geometry  ==> ' + geometry);
                            System.debug('geometry.Bounds  ==> ' + geometry.get('bounds'));
                            System.debug('location  ==> ' + location);
                        }
                    }
                    lead.Address__Latitude__s = coordinates.get('latitude') ;
                    lead.Address__Longitude__s = coordinates.get('longitude');
                    lead.Geo_Location__Latitude__s = coordinates.get('latitude') ;
                    lead.Geo_Location__Longitude__s  = coordinates.get('longitude');
                    leadsToUpdateWithGeolocation.add(lead);
                    
                }
            }
        }
        
        if (!leadsToUpdateWithGeolocation.isEmpty()) {
            update leadsToUpdateWithGeolocation;
        }
    }
    
/*    
    public static void mytest(){
        Integer i=0;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
    }
   */ 
}