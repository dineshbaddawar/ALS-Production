trigger TriggerOnCustomOpp on Opportunity1__c (before insert,after insert,after update,before update) {
    
    if(trigger.isBefore && trigger.isInsert){
        OpportunityTriggerHandler.tagQuarterlyGoal(Trigger.new);
        OpportunityTriggerHandler.updateOppOwner(Trigger.new);
        TriggerOpportunityHandler.provideOppnameWithAcc(trigger.new);
        TriggerOpportunityHandler.updateProbabilityonCreation(trigger.new);
        TriggerOpportunityHandler.oncreationHandleCreateFlag(trigger.new);
        TriggerOpportunityHandler.OppRSMAssignment(trigger.new);
        TriggerOpportunityHandler.updateClosedDateOnOpp(trigger.new);
    }
    
    if(trigger.isAfter && trigger.isInsert){
        OpportunityTriggerHandler.UpdateMonthlyIncentiveAchievement(trigger.new,trigger.oldmap);
        OpportunityTriggerHandler.updateFiscalYearByClosedDate(trigger.new);
    }
    
    if(trigger.isAfter && trigger.IsUpdate){
        
        OpportunityTriggerHandler.updateQuoteStage(trigger.new,trigger.oldmap);
        TriggerOpportunityHandler.get_closedown_opportunity(trigger.new);
        OpportunityTriggerHandler.UpdateFiscalYearAndQuarterlyGoalsBasedOnStage(trigger.newmap,trigger.oldmap);
        // ProductAchievedTargetBifurcation.CreateProductTargetBifurcation(trigger.new,trigger.newmap);
        //OpportunityTriggerHandler.insertNewProductFixedPriceRecord(trigger.newMap);
        
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        TriggerOpportunityHandler.updateProbability(Trigger.new, Trigger.oldMap);        
        OpportunityTriggerHandler.tagQuarterlyGoalAfterFYIsUpdated(Trigger.new, Trigger.oldmap);
       // OpportunityTriggerHandler.updateFiscalYearAndQuarterlyGoalOnClosedDateChange(Trigger.new, Trigger.oldmap);                
    }
    
}