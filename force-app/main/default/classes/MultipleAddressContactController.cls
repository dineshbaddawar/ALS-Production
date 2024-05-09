public with sharing class MultipleAddressContactController {
    
    @AuraEnabled
    public static List<String> getFieldSet(){
        List<Schema.FieldSetMember> FieldSetListFromOPp  = SobjectType.Opportunity1__c.FieldSets.Opportunityfieldset.getFields();
        List<String> FieldSet = new List<String>();
        for(Schema.FieldSetMember fieldsToAdd : FieldSetListFromOPp){
            System.debug('Fields === >'+String.valueOf(fieldsToAdd.sobjectfield));
            FieldSet.add(String.valueOf(fieldsToAdd.sobjectfield));
            
        } 
        return FieldSet;
    }
    
    @AuraEnabled
    public static Map<String, Object> getAllCustomerAddress(String custId){
        
        try {
            Map<String, Object> returnWrapperMap = new Map<String, Object>();
            List<CustomerAddressWrapper> customerShippingAddressWrapper = new List<CustomerAddressWrapper>();
            List<CustomerAddressWrapper> customerBillingAddressWrapper = new List<CustomerAddressWrapper>();
            //  System.debug('--- custId'+custId);
            
            if(!String.isBlank(custId)) {
                //Opportunity1__c customerAcc = [SELECT Id, Name, AccountId__r.Id,AccountId__r.BillingState, AccountId__r.BillingStreet, AccountId__r.BillingCountry, AccountId__r.BillingPostalCode, AccountId__r.BillingCity, AccountId__r.ShippingState, AccountId__r.ShippingStreet, AccountId__r.ShippingCountry, AccountId__r.ShippingCity, AccountId__r.ShippingPostalCode, AccountId__r.AccountSource FROM Opportunity1__c WHERE Id = :custId];
                Contact customerAcc = [SELECT Id, Name,Billing_Address__Street__s,Billing_Address__StateCode__s,Billing_Address__CountryCode__s,Billing_Address__City__s,Billing_Address__PostalCode__s,Shipping_Address__Street__s,Shipping_Address__StateCode__s,Shipping_Address__CountryCode__s,Shipping_Address__City__s,Shipping_Address__PostalCode__s, AccountId FROM Contact WHERE Id = :custId];
                
                if(customerAcc != null && !String.isBlank(customerAcc.Billing_Address__CountryCode__s)) {
                    customerBillingAddressWrapper.add(new CustomerAddressWrapper('Billing', customerAcc.Billing_Address__Street__s, customerAcc.Billing_Address__StateCode__s, customerAcc.Billing_Address__CountryCode__s, customerAcc.Billing_Address__City__s, customerAcc.Billing_Address__PostalCode__s, 'Billing', true));
                	returnWrapperMap.put('ship_selected_index', 0);
                }
                
                if(customerAcc != null && !String.isBlank(customerAcc.Shipping_Address__CountryCode__s)) {
                    customerShippingAddressWrapper.add(new CustomerAddressWrapper('Shipping', customerAcc.Shipping_Address__Street__s, customerAcc.Shipping_Address__StateCode__s, customerAcc.Shipping_Address__CountryCode__s, customerAcc.Shipping_Address__City__s, customerAcc.Shipping_Address__PostalCode__s, 'Shipping', true));
                	returnWrapperMap.put('bill_selected_index', 0);
                }
                
                for(Dispatch_Address__c custAddress :[SELECT Id, Address__Street__s, ToLabel(Address__StateCode__s), Address__PostalCode__s, ToLabel(Address__CountryCode__s), Address__City__s, Type__c FROM Dispatch_Address__c WHERE Account__c =:customerAcc.AccountId]) {
                    
                    if(custAddress.Type__c == 'Billing') {
                        customerBillingAddressWrapper.add(new customerAddressWrapper(custAddress.Id, custAddress.Address__Street__s, custAddress.Address__StateCode__s, custAddress.Address__CountryCode__s, custAddress.Address__City__s, custAddress.Address__PostalCode__s, custAddress.Type__c, false));
                    }else {
                        customerShippingAddressWrapper.add(new customerAddressWrapper(custAddress.Id, custAddress.Address__Street__s, custAddress.Address__StateCode__s, custAddress.Address__CountryCode__s, custAddress.Address__City__s, custAddress.Address__PostalCode__s, custAddress.Type__c, false));
                    }
                }
                
                
                //System.debug('--- customerAddressWrapper'+customerAddressWrapper);
                returnWrapperMap.put('account', customerAcc);
                returnWrapperMap.put('customer_ship_addresses', customerShippingAddressWrapper);
                returnWrapperMap.put('customer_bill_addresses', customerBillingAddressWrapper);
                // System.debug('--- response Wrapper '+returnWrapperMap);
                
                // System.debug('--- returnWrapperMap: ' + returnWrapperMap);
            }
            
            return returnWrapperMap;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
   
    @AuraEnabled
    public static string UpdateOpportunityAccountAddresss(String oppId,String shippindId,String billingId){
        system.debug('shippindId'+shippindId);
        system.debug('billingId'+billingId);
        try{
            
            Contact oppRecord = new Contact();
            Dispatch_Address__c shippingAddress = new Dispatch_Address__c();
            Dispatch_Address__c billingAddress = new Dispatch_Address__c();
            Contact oppDetails = new Contact();
            Account accRec = new Account();
            
            if(oppId !=null){
                oppDetails =  [SELECT Id,Name,AccountId FROM Contact WHERE Id=:oppId LIMIT 1];
                if(oppDetails.AccountId !=null){
                    accRec = [SELECT Id,Name,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet FROM Account WHERE Id=:oppDetails.AccountId LIMIT 1];
                    Contact oppToUpdateForDefault = new Contact();
                    oppToUpdateForDefault.id = oppId;
                    if(shippindId == 'Shipping' ){
                        if(accRec.ShippingStreet !=null){
                            oppToUpdateForDefault.Shipping_Address__Street__s = accRec.ShippingStreet;
                        }
                        if(accRec.ShippingCity !=null){
                            oppToUpdateForDefault.Shipping_Address__City__s = accRec.ShippingCity;
                        }
                        if(accRec.ShippingPostalCode !=null){
                            oppToUpdateForDefault.Shipping_Address__PostalCode__s = accRec.ShippingPostalCode;
                        }
                        /*if(accRec.ShippingState !=null){
oppToUpdateForDefault.Shipping_Address__StateCode__s = accRec.ShippingState;
}*/
                        /*if(accRec.ShippingCountry !=null){
oppToUpdateForDefault.Shipping_Address__CountryCode__s = accRec.ShippingCountry;
}*/
                    }
                    if(billingId == 'Billing'){
                        if(accRec.BillingStreet !=null){
                            oppToUpdateForDefault.Billing_Address__Street__s = accRec.BillingStreet;
                        }
                        if(accRec.BillingCity !=null){
                            oppToUpdateForDefault.Billing_Address__City__s = accRec.BillingCity;
                        }
                        if(accRec.BillingPostalCode !=null){
                            oppToUpdateForDefault.Billing_Address__PostalCode__s = accRec.BillingPostalCode;
                        }
                        /*if(accRec.BillingState !=null){
oppToUpdateForDefault.Billing_Address__StateCode__s = accRec.BillingState;
}*/
                        //if(accRec.BillingCountry !=null){
                        //oppToUpdateForDefault.Billing_Address__CountryCode__s = accRec.BillingCountry;
                        // }
                    }
                    update oppToUpdateForDefault;
                    system.debug('by default selected address===>'+oppToUpdateForDefault);
                }
                
            }
            
            if(oppId !=null && shippindId !=null && billingId !=null && shippindId!='Shipping' && billingId!= 'Billing'){
                oppRecord = [SELECT Id,Name,AccountId FROM Contact WHERE Id =:oppId];
                shippingAddress= [SELECT id,Name,Address__Street__s,Address__City__s,Address__PostalCode__s,Address__StateCode__s,Address__CountryCode__s FROM Dispatch_Address__c WHERE Id=:shippindId];
                billingAddress= [SELECT id,Name,Address__Street__s,Address__City__s,Address__PostalCode__s,Address__StateCode__s,Address__CountryCode__s FROM Dispatch_Address__c WHERE Id=:billingId];
                
                System.debug('--- oppRecord: ' + oppRecord);
                
                System.debug('--- shippingAddress: ' + shippingAddress);
                
                System.debug('--- billingAddress: ' + billingAddress);
                
                Contact oppToUpdate = new Contact();
                oppToUpdate.id = oppRecord.id;
                if(billingAddress !=null){
                    if(billingAddress.Address__Street__s !=null){
                        oppToUpdate.Billing_Address__Street__s = billingAddress.Address__Street__s;
                    }
                    if(billingAddress.Address__City__s !=null){
                        oppToUpdate.Billing_Address__City__s = billingAddress.Address__City__s;
                    }
                    if(billingAddress.Address__PostalCode__s !=null){
                        oppToUpdate.Billing_Address__PostalCode__s = billingAddress.Address__PostalCode__s;
                    }
                    if(billingAddress.Address__StateCode__s !=null){
                        oppToUpdate.Billing_Address__StateCode__s = billingAddress.Address__StateCode__s;
                    }
                    if(billingAddress.Address__CountryCode__s !=null){
                        oppToUpdate.Billing_Address__CountryCode__s = billingAddress.Address__CountryCode__s;
                    }
                }
                if(shippingAddress !=null){
                    if(shippingAddress.Address__Street__s !=null){
                        oppToUpdate.Shipping_Address__Street__s = shippingAddress.Address__Street__s;
                    }
                    if(shippingAddress.Address__City__s !=null){
                        oppToUpdate.Shipping_Address__City__s = shippingAddress.Address__City__s;
                    }
                    if(shippingAddress.Address__PostalCode__s !=null){
                        oppToUpdate.Shipping_Address__PostalCode__s = shippingAddress.Address__PostalCode__s;
                    }
                    if(shippingAddress.Address__StateCode__s !=null){
                        oppToUpdate.Shipping_Address__StateCode__s = shippingAddress.Address__StateCode__s;
                    }
                    if(shippingAddress.Address__CountryCode__s !=null){
                        oppToUpdate.Shipping_Address__CountryCode__s = shippingAddress.Address__CountryCode__s;
                    }
                }
                update oppToUpdate;
            }
            
        }catch(Exception e){
            System.debug('Error == >'+e.getMessage() +' && Error Line == >'+e.getLineNumber());
        }
        return 'ERROR';
    }


    // Method for Visit to Get Contact Details to show Address - 1
    @AuraEnabled 
    public static Visit__c getVisitDetails(String recordId){
        Visit__c visitRec = new Visit__c();
        try{
            if(recordId !=null){
              visitRec = [SELECT Id,Name,Contact_Person__c FROM Visit__c WHERE Id=:recordId];
              if(visitRec !=null && visitRec.Contact_Person__c !=null){
                  System.debug('visitRec With Contact === >'+visitRec);
                  return visitRec;
              }else{
                  return null;
              }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
       return null;
    }

     // Method for Visit to Update Visit Address - 2
     @AuraEnabled
    public static string UpdateVisitAccountAddresss(String oppId,String shippindId,String billingId){
        system.debug('shippindId'+shippindId);
        system.debug('billingId'+billingId);
        try{
            
            Visit__c oppRecord = new Visit__c();
            Dispatch_Address__c shippingAddress = new Dispatch_Address__c();
            Dispatch_Address__c billingAddress = new Dispatch_Address__c();
            Visit__c oppDetails = new Visit__c();
            Account accRec = new Account();
            
            if(oppId !=null){
                oppDetails =  [SELECT Id,Name,Account__c FROM Visit__c WHERE Id=:oppId LIMIT 1];
                if(oppDetails.Account__c !=null){
                    accRec = [SELECT Id,Name,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet FROM Account WHERE Id=:oppDetails.Account__c LIMIT 1];
                    Visit__c oppToUpdateForDefault = new Visit__c();
                    oppToUpdateForDefault.id = oppId;
                    if(shippindId == 'Shipping' ){
                        if(accRec.ShippingStreet !=null){
                            oppToUpdateForDefault.Street__c = accRec.ShippingStreet;
                        }
                        if(accRec.ShippingCity !=null){
                            oppToUpdateForDefault.City__c = accRec.ShippingCity;
                        }
                        if(accRec.ShippingPostalCode !=null){
                            oppToUpdateForDefault.Postal_Code__c = accRec.ShippingPostalCode;
                        }
                    }
                    if(billingId == 'Billing'){
                        if(accRec.BillingStreet !=null){
                            oppToUpdateForDefault.Street__c = accRec.BillingStreet;
                        }
                        if(accRec.BillingCity !=null){
                            oppToUpdateForDefault.City__c = accRec.BillingCity;
                        }
                        if(accRec.BillingPostalCode !=null){
                            oppToUpdateForDefault.Postal_Code__c = accRec.BillingPostalCode;
                        }
                    }
                    update oppToUpdateForDefault;
                    system.debug('by default selected address===>'+oppToUpdateForDefault);
                }
                
            }
            
            if(oppId !=null && shippindId !=null && billingId !=null && shippindId!='Shipping' && billingId!= 'Billing'){
                oppRecord = [SELECT Id,Name,Account__c FROM Visit__c WHERE Id =:oppId];
                shippingAddress= [SELECT id,Name,Address__Street__s,Address__City__s,Address__PostalCode__s,Address__StateCode__s,Address__CountryCode__s FROM Dispatch_Address__c WHERE Id=:shippindId];
                billingAddress= [SELECT id,Name,Address__Street__s,Address__City__s,Address__PostalCode__s,Address__StateCode__s,Address__CountryCode__s FROM Dispatch_Address__c WHERE Id=:billingId];
                
                System.debug('--- oppRecord: ' + oppRecord);
                
                System.debug('--- shippingAddress: ' + shippingAddress);
                
                System.debug('--- billingAddress: ' + billingAddress);
                
                Visit__c oppToUpdate = new Visit__c();
                oppToUpdate.id = oppRecord.id;
                if(billingAddress !=null){
                    if(billingAddress.Address__Street__s !=null){
                        oppToUpdate.Street__c = billingAddress.Address__Street__s;
                    }
                    if(billingAddress.Address__City__s !=null){
                        oppToUpdate.City__c = billingAddress.Address__City__s;
                    }
                    if(billingAddress.Address__PostalCode__s !=null){
                        oppToUpdate.Postal_Code__c = billingAddress.Address__PostalCode__s;
                    }
                    if(billingAddress.Address__StateCode__s !=null){
                        oppToUpdate.State__c = billingAddress.Address__StateCode__s;
                    }
                    if(billingAddress.Address__CountryCode__s !=null){
                        oppToUpdate.Country__c = billingAddress.Address__CountryCode__s;
                    }
                }
                if(shippingAddress !=null){
                    if(shippingAddress.Address__Street__s !=null){
                        oppToUpdate.Street__c = shippingAddress.Address__Street__s;
                    }
                    if(shippingAddress.Address__City__s !=null){
                        oppToUpdate.City__c = shippingAddress.Address__City__s;
                    }
                    if(shippingAddress.Address__PostalCode__s !=null){
                        oppToUpdate.Postal_Code__c = shippingAddress.Address__PostalCode__s;
                    }
                    if(shippingAddress.Address__StateCode__s !=null){
                        oppToUpdate.State__c = shippingAddress.Address__StateCode__s;
                    }
                    if(shippingAddress.Address__CountryCode__s !=null){
                        oppToUpdate.Country__c = shippingAddress.Address__CountryCode__s;
                    }
                }
                update oppToUpdate;
            }
            
        }catch(Exception e){
            System.debug('Error == >'+e.getMessage() +' && Error Line == >'+e.getLineNumber());
        }
        return 'ERROR';
    }


      // Method for Visit to Update Visit Address - 3
      @AuraEnabled (cacheable=true)
      public static List<Contact> getVisitRelatedContact(String recordId){
           Visit__c visitRecDetails = new Visit__c();
           List<Contact> getAccountContactList = new List<Contact>();
      try{
            if(recordId !=null){
             visitRecDetails = [SELECT Id,Name,Account__c FROM Visit__c WHERE Id=:recordId];
             if(visitRecDetails !=null && visitRecDetails.Account__c !=null){
               getAccountContactList = [SELECT Id,Name,AccountId FROM Contact WHERE AccountId=: visitRecDetails.Account__c];
               if(getAccountContactList.size()>0){
                   System.debug('Contact Size From Visit Account == >'+getAccountContactList.size());
                   return getAccountContactList;
               }else{
                   return null;
               }
             }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
      }

       // Method for Visit to Update Contact on Visit - 4
       @AuraEnabled 
       public static Visit__c updateVisitContact(String recordId,String contactId){
        Visit__c updateVisitRec = new Visit__c();
        try{
            if(recordId !=null && contactId !=null){
                updateVisitRec = [SELECT Id,Name,Contact_Person__c FROM Visit__c WHERE Id=:recordId];
                if(updateVisitRec !=null){
                    updateVisitRec.Contact_Person__c = contactId;
                    update updateVisitRec;
                    System.debug('Updated Visit with Contact === >'+updateVisitRec);
                    if(updateVisitRec !=null){
                        return updateVisitRec;
                    }else{
                        return null;
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
       }
    
    
    public class CustomerAddressWrapper {
        @auraEnabled
        public String id;
        @auraEnabled
        public String street;
        @auraEnabled
        public String state;
        @auraEnabled
        public String country;
        @auraEnabled
        public String city;
        
        @auraEnabled
        public String type;
        @AuraEnabled
        public String postalCode;
        @AuraEnabled
        public Boolean checked;
        
        public CustomerAddressWrapper(String id, String street, String state, String country, String city, String postalCode, String type, Boolean checked) {
            this.id = id;
            this.street = street;
            this.state = state;
            this.country = country;
            this.city = city;
            
            this.postalCode = postalCode;
            this.type = type;
            this.checked = checked;
        }
        
    }
    
}