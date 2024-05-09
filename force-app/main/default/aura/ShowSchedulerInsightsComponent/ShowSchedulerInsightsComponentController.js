({
    parentComponentEvent:function(component ,event ,helper) {
        debugger;
        var MPlist=[];
        var Month = event.getParam("Month");
        var Year = event.getParam("Year"); 
        var refresh = event.getParam("refresh");
        if(refresh){
            component.set('v.refresh', false);
        }
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
                var data = response.getReturnValue();
                if(data !=null && data!=undefined){
                    component.set("v.ShowToCreateMonthlyBeatPlan",false);
                    component.set("v.MonthlyBeatPlanDataList",data.MBPrec);
                    component.set("v.userName",data.MBPrec.Sales_User__r.Name);
                    if(data.approverName != null && data.approverName != undefined){
                        component.set("v.approverName",data.approverName);
                    }else{
                        var unapprovedStr = 'Not Yet Approved';
                        component.set("v.approverName",unapprovedStr);
                    }
                    component.set('v.refresh', true);
                }else{
                    component.set("v.ShowToCreateMonthlyBeatPlan",true);
                }     
            }else{
                component.set("v.ShowToCreateMonthlyBeatPlan",true); 
            }
            
        });
        $A.enqueueAction(action);
        
    }    
    
})