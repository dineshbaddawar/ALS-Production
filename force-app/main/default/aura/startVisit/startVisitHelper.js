({
    getVisitRecord : function(component, event, helper){
        debugger;
        var visitRecId = component.get('v.visitId'); 
        var baseURL = $A.get("$Label.c.orgBaseURLforVFPages");
        baseURL = baseURL + 'apex/docCategories?id='+visitRecId;
        component.set("v.siteURL",baseURL);
        var action = component.get('c.getSelectedVisitDetails');
        action.setParams({
            visitId :  visitRecId
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.visitRec', result);
                if(result.Account__c != null && result.Account__c != undefined){
                    component.set('v.accID', result.Account__c);
                    var street = result.Account__r.BillingStreet;
                    var city = result.Account__r.BillingCity;
                    var state = result.Account__r.BillingState;
                    var zipCode = result.Account__r.BillingPostalCode;  
                    var country = result.Account__r.BillingCountry;  
                    
                    var shipStreet = result.Account__r.ShippingStreet;
                    var shipCity = result.Account__r.ShippingCity;
                    var shipState = result.Account__r.ShippingState;
                    var shipZipCode = result.Account__r.ShippingPostalCode;  
                    var shipCountry = result.Account__r.ShippingCountry;  
                    
                    component.set("v.oppName", result.Account__r.Name);
                    
                    component.set("v.billCity", city);
                    component.set("v.billState", state);
                    component.set("v.billCountry", country);
                    component.set("v.billPostalCode", zipCode);
                    component.set("v.billStreet", street);
                    
                    component.set("v.shipCity", shipCity);
                    component.set("v.shipState", shipState);
                    component.set("v.shipCountry", shipCountry);
                    component.set("v.shipPostalCode", shipZipCode);
                    component.set("v.shipStreet", shipStreet);
                    
                }
                else{
                    component.set('v.leadID', result.Lead__c);
                    component.set("v.oppName", result.Lead__r.Name);
                    if(result.Lead__r.Address__Street__s != undefined && result.Lead__r.Address__City__s != undefined && result.Lead__r.Address__StateCode__s != undefined && result.Lead__r.Address__PostalCode__s != undefined){
                        var street = result.Lead__r.Address__Street__s;
                        var city = result.Lead__r.Address__City__s;
                        var state = result.Lead__r.Address__StateCode__s;
                        var zipCode = result.Lead__r.Address__PostalCode__s;   
                        var country = result.Lead__r.Address__CountryCode__s; 
                        
                        component.set("v.billCity", city);
                        component.set("v.billState", state);
                        component.set("v.billCountry", country);
                        component.set("v.billPostalCode", zipCode);
                        component.set("v.billStreet", street);
                    }   
                }
                var fullAddress = street + ', ' + city + ', ' + state+ '- ' + zipCode;
                component.set('v.accountAddress', fullAddress);
                if(result.Check_Out__Latitude__s != null && result.Check_Out__Latitude__s != undefined && result.Check_Out__Latitude__s != ''){
                    component.set("v.ShowCheckInButton",true);
                    component.set("v.ShowCheckOutButton",true);
                }
                if((result.CheckIn__Latitude__s != null && result.CheckIn__Latitude__s != undefined && result.CheckIn__Latitude__s != '')&&(result.Check_Out__Latitude__s == null || result.Check_Out__Latitude__s == undefined || result.Check_Out__Latitude__s == '')){
                    component.set("v.ShowCheckInButton",true);
                    component.set("v.ShowCheckOutButton",false);
                }
                component.set("v.spinner",false);
                
                this.getRelatedActivityList(component, event, helper);
            } 
            component.set("v.spinner",false);
        });
        $A.enqueueAction(action);
    },
    
    getPastVisitRecord : function(component, event, helper){
        debugger;
        var accountId = component.get('v.accID');
        var leadId = component.get('v.leadID');
        var passingId;

        if (accountId != null && accountId != undefined) {
            component.set("v.AccountIdForLWC", accountId);
        }

        if(accountId !== undefined && accountId !== null) {
            passingId = accountId;
        } else if(leadId !== undefined && leadId !== null) {
            passingId = leadId;
        }
        var action = component.get('c.getPastVisitDetails');
        action.setParams({
            accId : passingId 
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.pastVisitList', result);
                component.set("v.spinner",false);
            } 
            component.set("v.spinner",false);
        });
        $A.enqueueAction(action);
    },
    
    getAccRelatedOppList : function(component, event, helper){
        debugger;
        var accountId = component.get('v.accID');
        var action = component.get('c.getRelOppList');
        action.setParams({
            accId : accountId
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.relOppList', result);
            } 
        });
        $A.enqueueAction(action);
    },
    
    getRelatedActivityList : function(component, event, helper){
        debugger;
        var accountId = component.get('v.accID');
        var leadId = component.get('v.leadID');
        var passingId;

        if(accountId !== undefined && accountId !== null) {
            passingId = accountId;
        } else if(leadId !== undefined && leadId !== null) {
            passingId = leadId;
        }
        var action = component.get('c.getRelTaskList');
        action.setParams({
            accId : passingId
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.relActivityList', result);
                component.set("v.spinner",false);
            } 
        });
        $A.enqueueAction(action);
    },
    
    getRelatedInvoiceList : function(component, event, helper){
        debugger;
        var accountId = component.get('v.accID');
        var action = component.get('c.getRelInvoiceList');
        action.setParams({
            accId : accountId
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.relInvoicesList', result);
            } 
        });
        $A.enqueueAction(action);
    },
    
    getRelatedCaseList : function(component, event, helper){
        debugger;
        var accountId = component.get('v.accID');
        var action = component.get('c.getRelCaseList');
        action.setParams({
            accId : accountId
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.relCaseList', result);
            } 
        });
        $A.enqueueAction(action);
    },
    
    CheckInVisithelper : function(component,lat,long){
        debugger;
        var toastEvent = $A.get("e.force:showToast");
        var visitRecId = component.get('v.visitId');
        var action = component.get("c.checkInUpdateVisit");
        action.setParams({
            checkInLat: lat,
            checkInLang: long,
            recId: visitRecId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.spinner', false);
                var data = response.getReturnValue(); 
                if(data !=null){
                    component.set("v.ShowCheckInButton",true);
                    component.set("v.ShowCheckOutButton",false);
                }
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Checked In Successfully',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
            } else if (state === "ERROR") {
                component.set('v.spinner', false);
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            } else if (state === "INCOMPLETE") {
                component.set('v.spinner', false);
                alert('No response from server or client is offline.');
            }
            component.set('v.spinner', false);
            toastEvent.fire();
        })
        $A.enqueueAction(action);
    },
    
    CheckOutVisithelper: function(component, lat, long) {
        debugger;
        var toastEvent = $A.get("e.force:showToast");
        var visitRecId = component.get('v.visitId');
        var action = component.get("c.checkOutUpdateVisit");
        action.setParams({
            checkOutLat: lat,
            checkOutLong: long,
            recId: visitRecId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if (data != null) {
                    component.set("v.ShowCheckInButton", true);
                    component.set("v.ShowCheckOutButton", true);
                }
                toastEvent.setParams({
                    title: 'Success',
                    message: 'Checked Out Successfully',
                    duration: '5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                
                // Callback function to reload the page and navigate to the child component
                var reloadCallback = $A.getCallback(function() {
                    var navigateToChildEvent = $A.get("e.force:navigateToComponent");
                    navigateToChildEvent.setParams({
                        componentDef: "c:DashboardComponent", 
                        componentAttributes: {
                            showtabOne:false,
                            showtabTwo:true
                        } 
                    });
                    navigateToChildEvent.fire();
                    $A.get('e.force:refreshView').fire(); 
                });
                
                // Invoke the callback function after a slight delay
                setTimeout(reloadCallback, 1000);
            } else if (state === "ERROR") {
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            } else if (state === "INCOMPLETE") {
                alert('No response from server or client is offline.');
            }
        });
        $A.enqueueAction(action);
    },
    
    callNavigation:function(component,event,helper,accId){
        debugger;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": accId,
            "slideDevName": "related"
        });
        navEvt.fire();
    },
    
    showSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Record Saved Successfully',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    
    showErrorOpp : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message: 'Please fill all the required fields',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    
    showError : function(component, event, helper, errorMessage) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message: errorMessage,
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    
    validateFields: function(component, auraId) {
        debugger;
        var customerSuccessValue = component.find(auraId).get('v.value');
        if ($A.util.isEmpty(customerSuccessValue)) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                message: "Please fill all Mandatory fields.",
                type: "error"
            });
            toastEvent.fire();
            return false;
        } 
        else {
            return true;
        }
    }
    
});