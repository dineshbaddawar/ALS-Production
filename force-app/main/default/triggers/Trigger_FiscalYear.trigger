trigger Trigger_FiscalYear on Fiscal_Year__c (after insert) {
    if(Trigger.isInsert && Trigger.IsAfter){
        Trigger_Handler.CreateQuarterPeriodsRec(Trigger.New); 
        Trigger_Handler.tagFiscalYearOnExistingOpportunities(Trigger.New); 
    }
}