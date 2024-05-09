({
    doInit: function (component, event, helper) {
        debugger;
        helper.getVisitRecs(component, event, helper); 
        helper.loadCompletedTasks(component, event, helper);
        helper.callMapMethod(component, event, helper); 
        var lat;
        var long;
        var userLocation = navigator.geolocation;
        if (userLocation) {
            userLocation.getCurrentPosition(function (position) {
                lat = position.coords.latitude;
                long = position.coords.longitude;
                if ((lat != null && lat != undefined && lat != '') && (long != null && long != undefined && long != '')) {
                    component.set("v.currentLatitude", lat);
                    component.set("v.currentLongitude", long);
                }
            });
        } 
        var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        var today = new Date;
        var dateYear = today.toLocaleTimeString('en-us', { year: 'numeric' }).split(' ')[0].replaceAll(',', '');
        var dateMonth = today.toLocaleTimeString('en-us', { month: 'long' }).split(' ')[0].replaceAll(',', '');
        var dateDay = today.toLocaleTimeString('en-us', { day: 'numeric' }).split(' ')[0].replaceAll(',', '');
        var options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: false };
        var prnDt = today.toLocaleTimeString('en-us', { weekday: 'long' }).split(' ')[0].replaceAll(',', '');
        var MonthName=monthNames[today.getMonth()].slice(0,3);
        
        component.set('v.dateDay', dateDay);
        component.set('v.dateYear', dateYear);
        component.set('v.dateMonth', dateMonth);
        component.set('v.day', prnDt);
        
        var counter = component.get("v.nextCounter");
        component.set("v.nextCounter",counter);
        let curr = new Date();
        var date = new Date();
        let week = []
        const dates = [];
        const mql = window.matchMedia('(max-width: 820px)');
        let mobileView = mql.matches;

        if(mobileView){
            date.setDate(date.getDate() + (3 * counter));
            curr = date;
            for (let i = 0; i < 3; i++) {
                let first = curr.getDate();
                let weekDate = new Date(curr.setDate(first)).toISOString().slice(0, 10);
                week.push(weekDate);
                const newDate = new Date(weekDate);
                var dateObj = {day:'', fullDate:'', month:''};
                dateObj.fullDate = newDate.toISOString().slice(0, 10);
                dateObj.day = newDate.toISOString().slice(8,10);
                var MonthName=monthNames[newDate.getMonth()].slice(0,3);
                dateObj.month = MonthName;
                dates.push(dateObj);
                curr.setDate(curr.getDate() + 1);
            }
            component.set("v.mobileDates", dates); 
        }else{
            date.setDate(date.getDate() + (7 * counter));
            curr = date;
            for (let i = 1; i <= 7; i++) {
                let first = curr.getDate() - curr.getDay() + i;
                let weekDate = new Date(curr.setDate(first)).toISOString().slice(0, 10);
                week.push(weekDate);
                const newDate = new Date(weekDate);
                var dateObj = {day:'', fullDate:'', month:''};
                dateObj.fullDate = newDate.toISOString().slice(0, 10);
                dateObj.day = newDate.toISOString().slice(8,10);
                var MonthName=monthNames[newDate.getMonth()].slice(0,3);
                dateObj.month = MonthName;
                dates.push(dateObj);
            }
            component.set("v.dates", dates);  
        }
    },
    
    initMap: function(component, event, helper) {
        debugger;
        // Check if the 'google' object is defined
        if (typeof google !== 'undefined') {
            // Your map initialization code goes here
            var geocoder = new google.maps.Geocoder();
            // Additional code for map initialization...
        } else {
            console.error('Google Maps API not loaded');
        }
    },
    
    handleComponentEvent : function (component, event, helper) {
        var showStartVisitComponent = event.getParam("showStartVisitComponent"); 
        var showTodaysTaskComponent = event.getParam("showTodaysTaskComponent");
        component.set('v.showTodaysTaskComponent', showTodaysTaskComponent);
        component.set('v.showStartVisitComponent', showStartVisitComponent);
    },
    
    handleDateSelect: function (component, event, helper) {
        const selectedDate = event.currentTarget.dataset.date;
        component.set("v.selectedDate", selectedDate);
        component.set("v.SelectedVisitDate", selectedDate);
        var dateToPass = selectedDate;
        console.log('first execution::==>'+dateToPass);
        helper.callMapMethodFromController(component, dateToPass, helper); 
        console.log('second execution::==>');
        if(selectedDate != null && selectedDate != undefined){
            var dateNew = new Date();
            if(selectedDate != dateNew.toISOString().slice(0, 10)){
                component.set('v.disableVisitButtons', true);
            }
            dateNew.setFullYear(selectedDate.slice(0,4));
            dateNew.setDate(selectedDate.slice(8,10));
            dateNew.setMonth(selectedDate.slice(5,7)-1);
            var today = dateNew;
        }
        var dateYear = today.toLocaleTimeString('en-us', { year: 'numeric' }).split(' ')[0].replaceAll(',', '');
        var dateMonth = today.toLocaleTimeString('en-us', { month: 'long' }).split(' ')[0].replaceAll(',', '');
        var dateDay = today.toLocaleTimeString('en-us', { day: 'numeric' }).split(' ')[0].replaceAll(',', '');
        var options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: false };
        var prnDt = today.toLocaleTimeString('en-us', { weekday: 'long' }).split(' ')[0].replaceAll(',', '');
        
        component.set('v.dateDay', dateDay);
        component.set('v.dateYear', dateYear);
        component.set('v.dateMonth', dateMonth);
        component.set('v.day', prnDt);
        console.log('third execution::==>'+dateToPass);
        helper.getVisitRecs(component, event, helper); 
        helper.loadCompletedTasks(component, event, helper);
        console.log('forth execution::==>'+event);
        helper.reloadPage(component, event, helper);
        console.log('fivth execution::==>'+event);
    },
    
    handleAmend: function (component, event, helper) {
        debugger;
        var buttonId =event.getSource().get("v.name");
        component.set("v.selectedVisitPlanedId",buttonId);
        component.set("v.ShowAmedVistPop",true);
        var action = component.get('c.getSelectedVisitDetails');
        action.setParams({
            visitId : buttonId
        });
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.visitRec', result);
                component.set('v.visitRecPlannedDate', result.Planned_Visit_Date__c);
            } 
        });
        $A.enqueueAction(action);
    },
    handleStartVisit: function (component, event, helper) {
        debugger;
        var record = event.getSource().get('v.value');
        if(record.Account__c == undefined ||record.Account__c == null){
            var leadId = record.Lead__c;
        }else{
            var recordId = record.Account__c;
        }
        
        component.set('v.visitIDtoStart', record.Id);
        component.set('v.accIdToShow', recordId);
        component.set('v.leadId', leadId);
        component.set('v.showTodaysTaskComponent',false);
        component.set('v.showStartVisitComponent',true);
    },
    
    getActualVistiDateChange : function (component, event, helper) {
        debugger
        var selVisitDate = component.find('auraidActialVisitdate').get('v.value');
        component.set("v.visitPlanedDate",selVisitDate);
        var visitDescription = component.find('visitDescription').get('v.value');
        component.set("v.visitDescription",visitDescription);
    },
    
    StartVisitDay: function (component, event, helper) {
        debugger;
        var lat;
        var long;
                lat =  component.get("v.currentLatitude");
                long = component.get("v.currentLongitude");
                if ((lat != null && lat != undefined && lat != '') && (long != null && long != undefined && long != '')) {
                    var today = new Date();
                    var year = today.getFullYear();
                    var month = String(today.getMonth() + 1).padStart(2, '0');
                    var day = String(today.getDate()).padStart(2, '0');
                    var formattedDate = year + '-' + month + '-' + day;
                    component.set('v.selectedDate', formattedDate);
                    helper.getVisitRecs(component, event, helper);
                    helper.StartVisitDayhelper(component,lat, long);
                }
    },
    
    EndVisitDay : function (component, event, helper) {
        debugger
        var lat;
        var long;

                lat =  component.get("v.currentLatitude");
                long = component.get("v.currentLongitude");
                if ((lat != null && lat != undefined && lat != '') && (long != null && long != undefined && long != '')) {
                    helper.EndVisitDayhelper(component,lat, long);
                    component.set("v.currentLatitude", lat);
                    component.set("v.currentLongitude", long);
                    component.set('v.disableVisitButtons', true);
                    component.set('v.ShowEndDay', true);
                }
    },
    closeModelPop: function (component, event, helper) {
        debugger;
        component.set("v.ShowAmedVistPop",false);
    },

    closeModelPopAmendVisit: function (component, event, helper) { 
        debugger;
        component.set("v.ShowAmedVistPop",false);
    },

    updateVisitHandler: function (component, event, helper) {
        debugger;
        var visitRecord = component.get("v.visitRec");
        var plannedVisitDate = new Date(component.get('v.visitRecPlannedDate'));
        var selectedDate = new Date(component.find("auraidActualVisitDate").get("v.value"));
        if (selectedDate > plannedVisitDate) {
            var action = component.get("c.updateAmendVisitRecord");
            action.setParams({
                visitRec: visitRecord
            });
            action.setCallback(this, function (response) {
                if (response.getState() === "SUCCESS") {
                    var data = response.getReturnValue();
                    if (data != null) {
                        helper.showsuccessMessageForUpdateVisit(component, event, helper);
                    }
                }
            });
            $A.enqueueAction(action);
        } else {
            alert("New selected date cannot be earlier than the planned visit date.");
        }
    },
    
    handleNextClicked : function(component, event, helper){
        debugger
        var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        var counter = component.get("v.nextCounter") + 1;
        component.set("v.nextCounter",counter);
        let curr = new Date();
        var date = new Date();
        let week = []
        const dates = [];
        const mql = window.matchMedia('(max-width: 820px)');
        let mobileView = mql.matches;

        if(mobileView){
            date.setDate(date.getDate() + (3 * counter));
            curr = date;
            for (let i = 0; i < 3; i++) {
                let first = curr.getDate();
                let weekDate = new Date(curr.setDate(first)).toISOString().slice(0, 10);
                week.push(weekDate);

                const newDate = new Date(weekDate);
                var dateObj = {day:'', fullDate:'', month:''};
                dateObj.fullDate = newDate.toISOString().slice(0, 10);
                dateObj.day = newDate.toISOString().slice(8,10);
                var MonthName=monthNames[newDate.getMonth()].slice(0,3);
                dateObj.month = MonthName;
                dates.push(dateObj);
                curr.setDate(curr.getDate() + 1);
            }
            component.set("v.mobileDates", dates); 
        }else{
            date.setDate(date.getDate() + (7 * counter));
            curr = date;
            for (let i = 1; i <= 7; i++) {
                let first = curr.getDate() - curr.getDay() + i;
                let weekDate = new Date(curr.setDate(first)).toISOString().slice(0, 10);
                week.push(weekDate);
                const newDate = new Date(weekDate);
                var dateObj = {day:'', fullDate:'', month:''};
                dateObj.fullDate = newDate.toISOString().slice(0, 10);
                dateObj.day = newDate.toISOString().slice(8,10);
                var MonthName=monthNames[newDate.getMonth()].slice(0,3);
                dateObj.month = MonthName;
                dates.push(dateObj);
            }
            component.set("v.dates", dates);  
        }
        component.set('v.selectedDate',week[0]);
        var selectedDate = component.get('v.selectedDate');
        if(selectedDate != null && selectedDate != undefined){
            var dateNew = new Date();
            dateNew.setFullYear(selectedDate.slice(0,4));
            dateNew.setDate(selectedDate.slice(8,10));
            dateNew.setMonth(selectedDate.slice(5,7)-1);
            var today = dateNew;
        }
        var dateYear = today.toLocaleTimeString('en-us', { year: 'numeric' }).split(' ')[0].replaceAll(',', '');
        var dateMonth = today.toLocaleTimeString('en-us', { month: 'long' }).split(' ')[0].replaceAll(',', '');
        var dateDay = today.toLocaleTimeString('en-us', { day: 'numeric' }).split(' ')[0].replaceAll(',', '');
        var options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: false };
        var prnDt = today.toLocaleTimeString('en-us', { weekday: 'long' }).split(' ')[0].replaceAll(',', '');
        
        component.set('v.dateDay', dateDay);
        component.set('v.dateYear', dateYear);
        component.set('v.dateMonth', dateMonth);
        component.set('v.day', prnDt);
        helper.getVisitRecs(component, event, helper); 
        helper.loadCompletedTasks(component, event, helper);
        helper.reloadPage(component, event, helper);
    },
    
    handlePrevClicked : function(component, event, helper){
        debugger;
        var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        var counter = component.get("v.nextCounter") - 1;
        component.set("v.nextCounter",counter);
        let curr = new Date();
        var date = new Date();
        let week = []
        const dates = [];
        const mql = window.matchMedia('(max-width: 820px)');
        let mobileView = mql.matches;

        if(mobileView){
            date.setDate(date.getDate() + (3 * counter));
            curr = date;
            for (let i = 0; i < 3; i++) {
                let first = curr.getDate();
                let weekDate = new Date(curr.setDate(first)).toISOString().slice(0, 10);
                week.push(weekDate);
                const newDate = new Date(weekDate);
                var dateObj = {day:'', fullDate:'', month:''};
                dateObj.fullDate = newDate.toISOString().slice(0, 10);
                dateObj.day = newDate.toISOString().slice(8,10);
                var MonthName=monthNames[newDate.getMonth()].slice(0,3);
                dateObj.month = MonthName;
                dates.push(dateObj);
                curr.setDate(curr.getDate() + 1);
            }
            component.set("v.mobileDates", dates); 
        }else{
            date.setDate(date.getDate() + (7 * counter));
            curr = date;
            for (let i = 1; i <= 7; i++) {
                let first = curr.getDate() - curr.getDay() + i;
                let weekDate = new Date(curr.setDate(first)).toISOString().slice(0, 10);
                week.push(weekDate);
                const newDate = new Date(weekDate);
                var dateObj = {day:'', fullDate:'', month:''};
                dateObj.fullDate = newDate.toISOString().slice(0, 10);
                dateObj.day = newDate.toISOString().slice(8,10);
                var MonthName=monthNames[newDate.getMonth()].slice(0,3);
                dateObj.month = MonthName;
                dates.push(dateObj);
            }
            component.set("v.dates", dates);  
        }
        component.set('v.selectedDate',week[0]);
        var selectedDate = component.get('v.selectedDate');
        if(selectedDate != null && selectedDate != undefined){
            var dateNew = new Date();
            dateNew.setFullYear(selectedDate.slice(0,4));
            dateNew.setDate(selectedDate.slice(8,10));
            dateNew.setMonth(selectedDate.slice(5,7)-1);
            var today = dateNew;
        }
        var dateYear = today.toLocaleTimeString('en-us', { year: 'numeric' }).split(' ')[0].replaceAll(',', '');
        var dateMonth = today.toLocaleTimeString('en-us', { month: 'long' }).split(' ')[0].replaceAll(',', '');
        var dateDay = today.toLocaleTimeString('en-us', { day: 'numeric' }).split(' ')[0].replaceAll(',', '');
        var options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: false };
        var prnDt = today.toLocaleTimeString('en-us', { weekday: 'long' }).split(' ')[0].replaceAll(',', '');
        
        component.set('v.dateDay', dateDay);
        component.set('v.dateYear', dateYear);
        component.set('v.dateMonth', dateMonth);
        component.set('v.day', prnDt);
        helper.getVisitRecs(component, event, helper); 
        helper.loadCompletedTasks(component, event, helper);
        helper.reloadPage(component, event, helper);
    },
    openMap: function(component, event, helper){
        var myCmp = component.find("myCmp");
        component.set("v.isModalOpen", true); 
    },
    openGoogleMaps: function (component, event, helper) {
        debugger;
        var visitLat = event.currentTarget.dataset.lat;
        var visitLong = event.currentTarget.dataset.long;
        var currentLat = component.get("v.currentLatitude");
        var currentLong = component.get("v.currentLongitude");
        
        var userLocation = navigator.geolocation;
        
        if (userLocation) {
            userLocation.getCurrentPosition(
                function (position) {
                    
                    var userLat = visitLat;
                    var userLong = visitLong;
                    
                    // var userLat = position.coords.latitude;
                    // var userLong = position.coords.longitude;
                    
                    if (userLat === currentLat && userLong === currentLong) {
                        // Handle the case where current location and user location are the same
                        alert("Current location and user location are the same. Please make sure location services are enabled.");
                    } else {
                        var mapsUrl = "https://www.google.com/maps/dir/?api=1&origin=" + currentLat + "," + currentLong + "&destination=" + userLat + "," + userLong + "&travelmode=driving";
                        window.open(mapsUrl, '_blank');
                    }
                },
                function (error) {
                    // Handle geolocation error
                    alert("Geolocation error: " + error.message);
                }
            );
        } else {
            alert("Geolocation is not supported in your browser or device.");
        }
    },
    
    closeModel : function(component, event, helper){
        component.set("v.isModalOpen", false); 
    },
    
    createMultipleMOM: function (component, event, helper) { 
        debugger;
        component.set("v.ShowMOMActivity", true); 
        helper.handleVisitRecords(component, event, helper);
        
    },
    closeModelPop: function (component, event, helper) {
        debugger;
        component.set("v.ShowMOMActivity",false);
    },
    
    
    handleLWCEvent: function(component, event, helper) {
        debugger;
        var userIdFromLWC = event.getParam('value');        
        component.set("v.auraUserId", userIdFromLWC);
    },
    
    OnchageMomSubject : function (component, event, helper) {
        debugger;
        var subject = component.find('logSubject').get('v.value');
        component.set("v.logMomSubject",subject);
    },
    
    OnchageMomEmail: function (component, event, helper) { 
        debugger;
        var stackEmail = component.find('logStackHolderEmail').get('v.value');
        component.set("v.stackEmail",stackEmail);
    },
    
    OnchageMomVisit : function (component, event, helper) {
        debugger;
        var visitRecId = component.find('visitRec').get('v.value');
        component.set("v.selectedVisit",visitRecId);
    },
    
    OnchageMomDescription : function (component, event, helper) {
        debugger;
        var description = component.find('logDescription').get('v.value');
        component.set("v.logMomDescription",description);
    },
    
    createMomActivity: function (component, event, helper) {
        debugger;
        var action = component.get("c.createMomActivityLog");
        
        var logMomDescription = component.get("v.logMomDescription");
        var selectedVisit = component.get("v.selectedVisit");
        var logMomSubject = component.get("v.logMomSubject");
        var auraUserId = component.get("v.auraUserId");
        var stackEmail = component.get("v.stackEmail");
        
        action.setParams({
            "description": logMomDescription,
            "visitId": selectedVisit,
            "subject": logMomSubject,
            "salesUserId": auraUserId,
            "stackholderEmail": stackEmail
        });
        
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS'){
                if(response.getReturnValue() === 'SUCCESS'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'SUCCESS',
                        message: 'Mom Activity Created Successfully',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    component.set("v.ShowMOMActivity",false);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    createLeadHandle: function (component, event, helper) {
        debugger;
        let Fields = ['Salutation__c', 'First_Name__c', 'Name', 'Company__c', 'GenderIdentity__c', 'Company_Type__c', 'Mark_Visit_as_Completed__c', 'Website__c', 'Description__c', 'Industry__c', 'Industry_Verticle__c','Lead_Source__c', 'Lead_Status__c', 'Vertical_Segment__c', 'location_of_test__c', 'Geo_Location__c', 'Address__c', 'Lost_Reason__c', 'Junk_Notes__c', 'Junk_Reason__c' , 'Sub_Stage__c', 'Email__c', 'Phone__c', 'Mobile__c', 'Rating__c', 'CurrencyIsoCode', 'RSM__c', 'Region__c', 'Annual_Revenue__c', 'Campaign__c', 'NoOfEmployees__c', 'Audit_Date__c', 'Audit_Time__c' , 'Audit_Location__c', 'Audit_Notes__c'];
        component.set("v.SobjectApiName", 'Lead__c');
        component.set("v.fields", Fields);
        component.set("v.showLeadPage", true);
    },
    
    handleError : function(component, event, helper) {
        var error = event.getParams();
        var errorMessage = event.getParam("message");
        helper.showErrorDynamic(component, event, helper, errorMessage);                
    },
    
    onCancelLeadPage: function (component, event, helper) {
        component.set("v.showLeadPage", false);
    },
    
    handleLeadCreation: function (component, event, helper) {
        component.set("v.showLeadPage", false);
        helper.showSuccess(component, event, helper);
        var params = event.getParams();
        var recordId = params.response.id;
        console.log('Record Id - ' + recordId);
        var action = component.get("c.createVisitrecord");
            action.setParams({
                leadId: recordId
            });
        action.setCallback(this, function (response) {
                if (response.getState() === "SUCCESS") {
                    var data = response.getReturnValue();
                    if (data != null) {
                        console.log('Record Id - ' +data);
                    }
                }
            });
    
            $A.enqueueAction(action);
        helper.getVisitRecs(component, event, helper);
        
        
    },
    
    handleLeadSubmit: function(component, event, helper) {
        debugger;
        var validateLNameField = helper.validateFields(component, 'leadLastName');
        if(validateLNameField){
            component.find('recordLeadEditForm').submit();
        }
    }, 
    
    OnchageMomSubject : function (component, event, helper) {
        debugger;
        var subject = component.find('logSubject').get('v.value');
        component.set("v.logMomSubject",subject);
    },
    
    OnchageMomEmail: function (component, event, helper) { 
        debugger;
        var stackEmail = component.find('logStackHolderEmail').get('v.value');
        component.set("v.stackEmail",stackEmail);
    },
    
    OnchageMomVisit : function (component, event, helper) {
        debugger;
        var visitRecId = component.find('visitRec').get('v.value');
        component.set("v.selectedVisit",visitRecId);
    },
    
    OnchageMomDescription : function (component, event, helper) {
        debugger;
        var description = component.find('logDescription').get('v.value');
        component.set("v.logMomDescription",description);
    },
    
    createMomActivity: function (component, event, helper) {
        debugger;
        var action = component.get("c.createMomActivityLog");
        
        var logMomDescription = component.get("v.logMomDescription");
        var selectedVisit = component.get("v.selectedVisit");
        var logMomSubject = component.get("v.logMomSubject");
        var auraUserId = component.get("v.auraUserId");
        var stackEmail = component.get("v.stackEmail");
        
        action.setParams({
            "description": logMomDescription,
            "visitId": selectedVisit,
            "subject": logMomSubject,
            "salesUserId": auraUserId,
            "stackholderEmail": stackEmail
        });
        
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS'){
                if(response.getReturnValue() === 'SUCCESS'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'SUCCESS',
                        message: 'Mom Activity Created Successfully',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    component.set("v.ShowMOMActivity",false);
                }
            } 
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
})