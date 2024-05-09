({
	parentComponentEvent:function(component ,event ,helper) {
        debugger;
        var MPlist=[];
        var Month = event.getParam("Month");
        var Year = event.getParam("Year"); 
        component.set("v.selectedMonth",Month);
        component.set("v.selectedYear",Year);
        
        let monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        let date=new Date();
        let year=date.getFullYear();
        let month=date.getMonth();
        let MonthName=monthNames[date.getMonth()];
        var action = component.get('c.getMonthBeatPlan');
        action.setParams({ 
            month:Month,
            year:Year
        });
         action.setCallback(this, function(response) {
             if(response.getState() === "SUCCESS"){
                 helper.helperMethod(component ,event ,helper,Month,year);
                 var data = response.getReturnValue();
                 if(data !=null && data!=undefined){
                     component.set("v.ShowToCreateMonthlyBeatPlan",false);
                     component.set("v.MonthlyBeatPlanDataList",data.MBPrec);
                      component.set("v.userName",data.MBPrec.Sales_User__r.Name);
                     helper.getMTEId(component, event, helper);
                 }else{
                     component.set("v.ShowToCreateMonthlyBeatPlan",true);
                 } 
                 
             }else{
                 component.set("v.ShowToCreateMonthlyBeatPlan",true); 
             }
        });
           $A.enqueueAction(action);

    },

handleUploadFinished: function (cmp, event) {
        var uploadedFiles = event.getParam("files");
        //alert("Files uploaded : " + uploadedFiles.length);
        //uploadedFiles.forEach(file => console.log(file.name));
    var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Documents Successfully Uploaded',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    }    
     
})