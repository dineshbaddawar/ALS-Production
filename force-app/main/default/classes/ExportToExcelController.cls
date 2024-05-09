/**
* @author [Dinesh Baddawar]
* @email dinesh.b@utilitarianLab.com
* @create date 2024-04-22 15:48:49
* @modify date 2024-04-22 15:48:49
* @desc [Method for Exporting Record based on Object Name & ListviewFilter]
*/

public with sharing class ExportToExcelController {
    
    // Controller For get Contact Record based ListView
    @AuraEnabled 
    public static List<Object> fetchContactsBasedOnListView(String listvieFilter,String objectApiName){
        List<Contact> conList = new List<Contact>();
        List<RecentlyViewed> recentlyViewedContacts = new List<RecentlyViewed>(); 
        List<Contact> contactsWithDetails = new List<Contact>();
        Set<Id> contactIds = new Set<Id>();
        try{
            if(listvieFilter !=null && objectApiName !=null){
                if(objectApiName == 'Contact'){
                    if(listvieFilter == 'My Contacts'){
                        conList =  [SELECT Name,AccountName__c, Title,Email, Phone, MobilePhone,Billing_Address__City__s,Billing_Address__CountryCode__s,Created_Date__c,OwnerName__c FROM Contact WHERE OwnerId =:UserInfo.getUserId()];
                        if(conList.size()>0){
                            System.debug('conList My Contacts Size == >'+conList.size());
                            return conList;
                        }
                    }
                    if(listvieFilter == 'Today\'s Contact'){
                        conList =  [SELECT Name,AccountName__c, Title,Email, Phone, MobilePhone,Billing_Address__City__s,Billing_Address__CountryCode__s,Created_Date__c,OwnerName__c FROM Contact WHERE CreatedDate =Today];
                        if(conList.size()>0){
                            System.debug('conList Today\'s Contact Size == >'+conList.size());
                            return conList;
                        }
                    }
                    if(listvieFilter == 'All Contacts'){
                        conList =  [SELECT Name,AccountName__c, Title,Email, Phone, MobilePhone,Billing_Address__City__s,Billing_Address__CountryCode__s,Created_Date__c,OwnerName__c FROM Contact];
                        if(conList.size()>0){
                            System.debug('All Contacts == >'+conList.size());
                            return conList;
                        }
                    }
                    if(listvieFilter == 'Recently Viewed Contacts'){
                        recentlyViewedContacts = [SELECT Id, Name, LastViewedDate FROM RecentlyViewed WHERE Type = 'Contact' ORDER BY LastViewedDate DESC];
                        for (RecentlyViewed rv : recentlyViewedContacts) {
                            contactIds.add(rv.Id);
                        }
                        System.debug('contactIds=====>'+contactIds);
                        if(!contactIds.isEmpty()){
                            contactsWithDetails = [SELECT Name,AccountName__c, Title,Email, Phone, MobilePhone,Billing_Address__City__s,Billing_Address__CountryCode__s,Created_Date__c,OwnerName__c FROM Contact WHERE Id IN : contactIds];
                            if(contactsWithDetails.size()>0){
                                System.debug('contact size====>'+contactsWithDetails.size());
                                return contactsWithDetails;  
                            } 
                        }
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    // =============================================================================================================================================================================================================
    // Controller For get Account Record based ListView    
    @AuraEnabled 
    public static List<Object> fetchAccountsBasedOnListView(String listvieFilter,String objectApiName){
        List<Account> accList = new List<Account>();
        List<RecentlyViewed> recentlyViewedAccounts = new List<RecentlyViewed>();
        List<Account> accountsWithDetails = new List<Account>();
        Set<Id> AccountIds = new Set<Id>();
        try{
            if(listvieFilter !=null && objectApiName !=null){
                if(objectApiName == 'Account'){
                    if(listvieFilter == 'My Accounts'){
                        accList =  [SELECT Name,BillingCity,BillingState,BillingCountry,RSMName__c ,Phone,Created_Date__c,OwnerName__c FROM Account WHERE OwnerId =:UserInfo.getUserId()];
                        if(accList.size()>0){
                            System.debug('accList My Accounts Size == >'+accList.size());
                            return accList;
                        }
                    }
                    if(listvieFilter == 'Today\'s Account'){
                        accList =  [SELECT Name,BillingCity,BillingState,BillingCountry,RSMName__c ,Phone,Created_Date__c,OwnerName__c FROM Account WHERE CreatedDate =Today];
                        if(accList.size()>0){
                            System.debug('accList Today\'s Account Size == >'+accList.size());
                            return accList;
                        }
                    }
                    if(listvieFilter == 'All Accounts'){
                        accList =  [ SELECT Name,BillingCity,BillingState,BillingCountry,RSMName__c ,Phone,Created_Date__c,OwnerName__c FROM Account ];
                        if(accList.size()>0){
                            System.debug('All Accounts == >'+accList.size());
                            return accList;
                        }
                    }
                    if(listvieFilter == 'Recently Viewed Accounts'){
                        recentlyViewedAccounts = [SELECT Id, Name, LastViewedDate FROM RecentlyViewed WHERE Type = 'Account' ORDER BY LastViewedDate DESC];
                        for (RecentlyViewed rv : recentlyViewedAccounts) {
                            AccountIds.add(rv.Id);
                        }
                        System.debug('AccountIds=====>'+AccountIds);
                        if(!AccountIds.isEmpty()){
                            accountsWithDetails = [SELECT Name,BillingCity,BillingState,BillingCountry,RSMName__c ,Phone,Created_Date__c,OwnerName__c FROM Account WHERE Id IN : AccountIds];
                            if(accountsWithDetails.size()>0){
                                System.debug('Account size====>'+accountsWithDetails.size());
                                return accountsWithDetails;
                            }
                        }
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    // =============================================================================================================================================================================================================
    // Controller For get Lead Record based ListView  
    @AuraEnabled 
    public static List<Object> fetchLeadsBasedOnListView(String listvieFilter,String objectApiName){
        List<Lead__c> leadList = new List<Lead__c>();      
        List<RecentlyViewed> recentlyViewedLeads = new List<RecentlyViewed>();
        List<Lead__C> leadsWithDetails = new  List<Lead__C>();
        Set<Id> LeadIds = new Set<Id>(); 
        try{
            if(listvieFilter !=null && objectApiName !=null){
                if(objectApiName == 'Lead__c'){
                    if(listvieFilter == 'My Lead'){
                        leadList =  [SELECT First_Name__c,Name,Lead_Source__c,Company__c,Region__c,Vertical_Segment__c,Address__City__s,Address__CountryCode__s,Created_Date__c,CreatedByName__c FROM Lead__c WHERE OwnerId =:UserInfo.getUserId()];
                        if(leadList.size()>0){
                            System.debug('leadList My lead Size == >'+leadList.size());
                            return leadList;
                        }
                    }
                    if(listvieFilter == 'Today\'s Leads'){
                        leadList =  [SELECT First_Name__c,Name,Lead_Source__c,Company__c,Region__c,Vertical_Segment__c,Address__City__s,Address__CountryCode__s,Created_Date__c,CreatedByName__c FROM Lead__c WHERE CreatedDate =Today];
                        if(leadList.size()>0){
                            System.debug('leadList Today\'s Leads Size == >'+leadList.size());
                            return leadList;
                        }
                    }
                    if(listvieFilter == 'All Leads'){
                        leadList =  [SELECT First_Name__c,Name,Lead_Source__c,Company__c,Region__c,Vertical_Segment__c,Address__City__s,Address__CountryCode__s,Created_Date__c,CreatedByName__c FROM Lead__c];
                        if(leadList.size()>0){
                            System.debug('All leads == >'+leadList.size());
                            return leadList;
                        }
                    }
                    if(listvieFilter == 'Recently Viewed'){
                        recentlyViewedLeads = [SELECT Id, Name, LastViewedDate FROM RecentlyViewed WHERE Type = 'Lead__c' ORDER BY LastViewedDate DESC];
                        for (RecentlyViewed rv : recentlyViewedLeads) {
                            LeadIds.add(rv.Id);
                        }
                        System.debug('LeadIds=====>'+LeadIds);
                        if(!LeadIds.isEmpty()){
                            leadsWithDetails = [SELECT First_Name__c,Name,Lead_Source__c,Company__c,Region__c,Vertical_Segment__c,Address__City__s,Address__CountryCode__s,Created_Date__c,CreatedByName__c FROM Lead__c  WHERE Id IN : LeadIds];
                            if(leadsWithDetails.size()>0){
                                System.debug('leadsWithDetails Size=====>'+leadsWithDetails.size());
                                return leadsWithDetails;
                            }
                        }
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    // =============================================================================================================================================================================================================
    // Controller For get Visit Record based ListView  
    @AuraEnabled 
    public static List<Object> fetchVisitsBasedOnListView(String listvieFilter,String objectApiName){
        List<Visit__c> visitList = new List<Visit__c>();
        List<RecentlyViewed> recentlyViewedVisits = new List<RecentlyViewed>();
        List<Visit__c> visitsWithDetails = new  List<Visit__c>();
        Set<Id> VisistIds = new Set<Id>();
        try{
            if(listvieFilter !=null && objectApiName !=null){
                if(objectApiName == 'Visit__c'){
                    if(listvieFilter == 'My Visits'){
                        visitList =  [SELECT Name,AccountName__c,ContactPerson_Name__c,Actual_Visit_Date__c,Visit_Status__c,Visit_Type__c,Visit_Notes__c,City__c,State__c,Created_Date__c,CreatedByName__c FROM Visit__c WHERE OwnerId =:UserInfo.getUserId()];
                        if(visitList.size()>0){
                            System.debug('visitList My visits Size == >'+visitList.size());
                            return visitList;
                        }
                    }
                    if(listvieFilter == 'Today\'s Visit'){
                        visitList =  [SELECT Name,AccountName__c,ContactPerson_Name__c,Actual_Visit_Date__c,Visit_Status__c,Visit_Type__c,Visit_Notes__c,City__c,State__c,Created_Date__c,CreatedByName__c FROM Visit__c WHERE CreatedDate =Today];
                        if(visitList.size()>0){
                            System.debug('visitList Today\'s visits Size == >'+visitList.size());
                            return visitList;
                        }
                    }
                    if(listvieFilter == 'All Visits'){
                        visitList =  [SELECT Name,AccountName__c,ContactPerson_Name__c,Actual_Visit_Date__c,Visit_Status__c,Visit_Type__c,Visit_Notes__c,City__c,State__c,Created_Date__c,CreatedByName__c FROM Visit__c];
                        if(visitList.size()>0){
                            System.debug('All visits == >'+visitList.size());
                            return visitList;
                        }
                    }
                    if(listvieFilter == 'Recently Viewed'){
                        recentlyViewedVisits = [SELECT Id, Name, LastViewedDate FROM RecentlyViewed WHERE Type = 'Visit__c' ORDER BY LastViewedDate DESC];
                        for (RecentlyViewed rv : recentlyViewedVisits) {  
                            VisistIds.add(rv.Id);
                        }
                        System.debug('VisistIds=====>'+VisistIds);
                        if(!VisistIds.isEmpty()){
                            visitsWithDetails = [SELECT Name,AccountName__c,ContactPerson_Name__c,Actual_Visit_Date__c,Visit_Status__c,Visit_Type__c,Visit_Notes__c,City__c,State__c,Created_Date__c,CreatedByName__c FROM Visit__c WHERE Id IN : VisistIds];
                            if(visitsWithDetails.size()>0){
                                System.debug('Visit size====>'+visitsWithDetails.size());
                                return visitsWithDetails;
                            }   
                        }
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    // =============================================================================================================================================================================================================
    // Controller For get Quote Record based ListView  
    @AuraEnabled 
    public static List<Object> fetchQuotesBasedOnListView(String listvieFilter,String objectApiName){
        List<Quote_C__c> quoteList = new List<Quote_C__c>();
        List<RecentlyViewed> recentlyViewedQuotes = new  List<RecentlyViewed>();
        List<Quote_C__c> quotesWithDetails = new List<Quote_C__c>();
        Set<Id> QUoteIds = new Set<Id>();
        try{
            if(listvieFilter !=null && objectApiName !=null){
                if(objectApiName == 'Quote_C__c'){
                    if(listvieFilter == 'All Quotes'){
                        quoteList =  [SELECT Name,Opportunity_Nmae__c,AccountName__c,ContactName__c,Lab_Location__c,CurrencyIsoCode,Status__c,BillingAddress__City__s,Created_Date__c,CreatedByName__c FROM Quote_C__c];
                        if(quoteList.size()>0){
                            System.debug('quoteList My Quote Size == >'+quoteList.size());
                            return quoteList;
                        }
                    }
                    if(listvieFilter == 'Recently Viewed'){
                        recentlyViewedQuotes = [SELECT Id, Name, LastViewedDate FROM RecentlyViewed WHERE Type = 'Quote_C__c' ORDER BY LastViewedDate DESC];
                        for (RecentlyViewed rv : recentlyViewedQuotes) {  
                            QUoteIds.add(rv.Id);
                        }
                        System.debug('QUoteIds=====>'+QUoteIds);
                        if(!QUoteIds.isEmpty()){
                            quotesWithDetails = [ SELECT Name,Opportunity_Nmae__c,AccountName__c,ContactName__c,Lab_Location__c,CurrencyIsoCode,Status__c,BillingAddress__City__s,Created_Date__c,CreatedByName__c FROM Quote_C__c WHERE Id IN : QUoteIds];
                            if(quotesWithDetails.size()>0){
                                System.debug('Quotes size====>'+quotesWithDetails.size());
                                return quotesWithDetails;
                            }
                        }
                    }
                    if(listvieFilter == 'Pharma Quotes'){ 
                        quotesWithDetails = [ SELECT Name,Opportunity_Nmae__c,AccountName__c,ContactName__c,Lab_Location__c,CurrencyIsoCode,Status__c,BillingAddress__City__s,Created_Date__c,CreatedByName__c FROM Quote_C__c WHERE Vertical_Segment__c ='Pharma'];
                        if(quotesWithDetails.size()>0){
                            System.debug('Quotes size====>'+quotesWithDetails.size());
                            return quotesWithDetails;
                        }
                    }
                    if(listvieFilter == 'Certification Quotes'){
                        quotesWithDetails = [ SELECT Name,Opportunity_Nmae__c,AccountName__c,ContactName__c,Lab_Location__c,CurrencyIsoCode,Status__c,BillingAddress__City__s,Created_Date__c,CreatedByName__c FROM Quote_C__c WHERE Vertical_Segment__c ='Certification'];
                        if(quotesWithDetails.size()>0){
                            System.debug('Quotes size====>'+quotesWithDetails.size());
                            return quotesWithDetails;
                        }
                    }
                    if(listvieFilter == 'Food Service Quotes'){
                        quotesWithDetails = [ SELECT Name,Opportunity_Nmae__c,AccountName__c,ContactName__c,Lab_Location__c,CurrencyIsoCode,Status__c,BillingAddress__City__s,Created_Date__c,CreatedByName__c FROM Quote_C__c WHERE Vertical_Segment__c ='Food Service'];
                        if(quotesWithDetails.size()>0){
                            System.debug('Quotes size====>'+quotesWithDetails.size());
                            return quotesWithDetails;
                        }
                    }
                    if(listvieFilter == 'Environmental Quotes'){
                        quotesWithDetails = [ SELECT Name,Opportunity_Nmae__c,AccountName__c,ContactName__c,Lab_Location__c,CurrencyIsoCode,Status__c,BillingAddress__City__s,Created_Date__c,CreatedByName__c FROM Quote_C__c WHERE Vertical_Segment__c ='Environmental'];
                        if(quotesWithDetails.size()>0){
                            System.debug('Quotes size====>'+quotesWithDetails.size());
                            return quotesWithDetails;
                        }
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    // =============================================================================================================================================================================================================
    // Controller For get Opportunity Record based ListView  
    @AuraEnabled 
    public static List<Object> fetchOpportunitiesBasedOnListView(String listvieFilter,String objectApiName){
        List<Opportunity1__c> oppList = new List<Opportunity1__c>();
        List<RecentlyViewed> recentlyViewedopportunity = new  List<RecentlyViewed>();
        List<Opportunity1__c> oppssWithDetails = new List<Opportunity1__c>();
        Set<Id> OppIds = new Set<Id>();
        try{
            if(listvieFilter !=null && objectApiName !=null){
                if(objectApiName == 'Opportunity1__c'){
                    if(listvieFilter == 'All Opportunities'){
                        oppList =  [SELECT Name,AccountName__c,ContactName__c,CustomerService__c,Amount__c,Vertical_Segment__c,CurrencyIsoCode,Billing_Address__City__s,Billing_Address__StateCode__s,Billing_Address__CountryCode__s,Region__c,RSMName__c,StageName__c,Created_Date__c,CloseDate__c,Owner_Name__c FROM Opportunity1__c];
                        if(oppList.size()>0){
                            System.debug('All opportunity Size == >'+oppList.size());
                            return oppList;
                        }
                    }
                    if(listvieFilter == 'Today\'s Opportunity'){
                        oppList =  [SELECT Name,AccountName__c,ContactName__c,CustomerService__c,Amount__c,Vertical_Segment__c,CurrencyIsoCode,Billing_Address__City__s,Billing_Address__StateCode__s,Billing_Address__CountryCode__s,Region__c,RSMName__c,StageName__c,Created_Date__c,CloseDate__c,Owner_Name__c FROM Opportunity1__c WHERE CreatedDate =Today];
                        if(oppList.size()>0){
                            System.debug('oppList Today\'s opportunity Size == >'+oppList.size());
                            return oppList;
                        }
                    }
                    if(listvieFilter == 'Recently Viewed'){
                        recentlyViewedopportunity = [SELECT Id, Name, LastViewedDate FROM RecentlyViewed WHERE Type = 'Opportunity1__c' ORDER BY LastViewedDate DESC];
                        for (RecentlyViewed rv : recentlyViewedopportunity) {  
                            OppIds.add(rv.Id);
                        }
                        System.debug('OppIds=====>'+OppIds);
                        if(!OppIds.isEmpty()){
                            oppssWithDetails = [SELECT Name,AccountName__c,ContactName__c,CustomerService__c,Amount__c,Vertical_Segment__c,CurrencyIsoCode,Billing_Address__City__s,Billing_Address__StateCode__s,Billing_Address__CountryCode__s,Region__c,RSMName__c,StageName__c,
                                                Created_Date__c,CloseDate__c,Owner_Name__c FROM Opportunity1__c WHERE Id IN : OppIds];
                            if(oppssWithDetails.size()>0){
                                System.debug('opps size====>'+oppssWithDetails.size());
                                return oppssWithDetails;
                            }
                        }
                    }
                    if(listvieFilter == 'Closed Won Opportunity'){
                        oppList =  [SELECT Name,AccountName__c,ContactName__c,CustomerService__c,Amount__c,Vertical_Segment__c,CurrencyIsoCode,Billing_Address__City__s,Billing_Address__StateCode__s,Billing_Address__CountryCode__s,Region__c,RSMName__c,StageName__c,Created_Date__c,CloseDate__c,Owner_Name__c FROM Opportunity1__c WHERE StageName__c = 	'Closed Won'];
                        if(oppList.size()>0){
                            System.debug('Closed Won Opportunity Size == >'+oppList.size());
                            return oppList;
                        }
                    }
                    if(listvieFilter == 'Closed Lost Opportunity'){
                        oppList =  [SELECT Name,AccountName__c,ContactName__c,CustomerService__c,Amount__c,Vertical_Segment__c,CurrencyIsoCode,Billing_Address__City__s,Billing_Address__StateCode__s,Billing_Address__CountryCode__s,Region__c,RSMName__c,StageName__c,Created_Date__c,CloseDate__c,Owner_Name__c FROM Opportunity1__c WHERE StageName__c = 	'Closed Lost'];
                        if(oppList.size()>0){
                            System.debug('Closed Lost Opportunity Size == >'+oppList.size());
                            return oppList;
                        }
                    }
                    if(listvieFilter == 'My Opportunities'){
                        oppList =  [SELECT Name,AccountName__c,ContactName__c,CustomerService__c,Amount__c,Vertical_Segment__c,CurrencyIsoCode,Billing_Address__City__s,Billing_Address__StateCode__s,Billing_Address__CountryCode__s,Region__c,RSMName__c,StageName__c,Created_Date__c,CloseDate__c,Owner_Name__c FROM Opportunity1__c WHERE OwnerId =:UserInfo.getUserId()];
                        if(oppList.size()>0){
                            System.debug(' My Opportunities Size == >'+oppList.size());
                            return oppList;
                        }
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    // =============================================================================================================================================================================================================
    // Controller For get ListView Record based Object  Name  
    @AuraEnabled
    public static List<String> getListViewBasedOnObjectName(String objectApiName){
        System.debug('Object Name == >'+objectApiName);
        List<String> getlistViewList = new List<String> ();
        try {
            List<ListView> listViewList = [SELECT Id, Name, DeveloperName, SobjectType FROM ListView WHERE SobjectType=:objectApiName ];
            if(listViewList.size()>0){
                for(ListView view : listViewList){
                    if(objectApiName == 'Lead__c'){
                        if(view.Name =='My Lead' || view.Name =='Today\'s Leads' || view.Name == 'All Leads' || view.Name == 'Recently Viewed'){
                            getlistViewList.add(view.Name);
                        }
                    }
                    else if(objectApiName == 'Account'){
                        if(view.Name == 'My Accounts' || view.Name == 'Today\'s Account' || view.Name == 'All Accounts' || view.Name == 'Recently Viewed Accounts'){
                            getlistViewList.add(view.Name);
                        }
                    }
                    else if(objectApiName == 'Contact'){
                        if(view.Name == 'My Contacts' || view.Name == 'Today\'s Contact' || view.Name == 'All Contacts' || view.Name == 'Recently Viewed Contacts'){
                            getlistViewList.add(view.Name);
                        }
                    }
                    else if(objectApiName == 'Visit__c'){
                        if(view.Name == 'My Visits' || view.Name == 'Today\'s Visit' || view.Name == 'All Visits' || view.Name == 'Recently Viewed'){
                            getlistViewList.add(view.Name);
                        }
                    }
                    else if(objectApiName == 'Opportunity1__c'){
                        if(view.Name == 'All Opportunities' || view.Name == 'Today\'s Opportunity' ||  view.Name == 'Recently Viewed' || view.Name == 'Closed Won Opportunity' || view.Name == 'Closed Lost Opportunity' || view.Name == 'My Opportunities' ){
                            getlistViewList.add(view.Name);
                        }
                    }
                    else if(objectApiName == 'Quote_C__c'){
                        if(view.Name == 'All Quotes' || view.Name == 'Recently Viewed' || view.Name == 'Pharma Quotes' || view.Name == 'Certification Quotes' || view.Name == 'Food Service Quotes' || view.Name == 'Environmental Quotes' ){
                            getlistViewList.add(view.Name);
                        }
                    }
                    else{
                        getlistViewList.add(view.Name);
                    }
                }
                if(getlistViewList.size()>0){
                    System.debug('getlistViewList == >'+getlistViewList);
                    return getlistViewList;
                }
            }
        } catch (Exception e) {
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    
}