({
    onchange: function(component, event, helper) {
        debugger;
        event.stopPropagation();
        event.preventDefault();
        debugger;
        var fileName = 'No File Selected.';
        if (event.getSource().get("v.files").length > 0) { 
            fileName = event.getSource().get("v.files")[0];//['name'];
        }
        component.set("v.FileNameRecord", fileName['name']);
        helper.readFile(component,helper,fileName);
    },
    processFileContent : function(component,event,helper){
        debugger;
        helper.saveRecords(component,event);
    },
    cancel : function(component,event,helper){
        component.set("v.showFirstScreen",true);
        component.set("v.showMain",false);
    },
    
     handleClickOutOfStock : function(component,event,helper){
        debugger;
     //   var tempName = 'OutOfStock';
     //   component.set("v.tempNameToDownload",tempName); 
        component.set("v.showScondScreen",true);
        component.set("v.showFirstScreen",false);
    },
    
})