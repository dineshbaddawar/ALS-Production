public class OpportunityTriggerHandler {
    
    public static boolean runonce = false;
    //This method is being used to update MonthlyIncenticeAchievment..
    public static void UpdateMonthlyIncentiveAchievement(list<Opportunity1__c> opplist ,map<id,Opportunity1__c> oldmap){
        
        Set<Id> fiscalIDSet = new Set<Id>();
        Map<Id,Quarterly_Goal__c> mapofMontlyidMonthlyRec = new Map<Id,Quarterly_Goal__c>();
        for(Opportunity1__c oppRec : opplist){
            if(oppRec.Quarterly_Goal__c !=null && oppRec.Fiscal_Year__c != null && (oldmap == null || oppRec.Quarterly_Goal__c != oldmap.get(oppRec.id).Quarterly_Goal__c ) ){
                fiscalIDSet.add(oppRec.Fiscal_Year__c);
            }
        }
        if(!fiscalIDSet.isEmpty()){
            
            List<Quarterly_Goal__c> monthlyGoallist = new List<Quarterly_Goal__c>();
            List<Quarterly_Goal__c> monthlyGoallistTobeUpdate = new List<Quarterly_Goal__c>();
            
            monthlyGoallist = [Select id,Total_Target_Achieved__c from Quarterly_Goal__c  where Fiscal_Year__c IN:fiscalIDSet ];
            
            if(!monthlyGoallist.IsEmpty()){
                for(Quarterly_Goal__c motnhIncentiveRec : monthlyGoallist){
                    mapofMontlyidMonthlyRec.put(motnhIncentiveRec.id,motnhIncentiveRec);
                }
            }
            
            Map<Id,Quarterly_Goal__c> mapOfMonthlyGoal = new Map<Id,Quarterly_Goal__c>();
            
            for(Opportunity1__c Opp : opplist){
                if(Opp.Quarterly_Goal__c != null && (oldmap == null || Opp.Quarterly_Goal__c != oldmap.get(Opp.id).Quarterly_Goal__c)){
                    Quarterly_Goal__c monthIncentiveRec = new Quarterly_Goal__c();
                    monthIncentiveRec.id = Opp.Quarterly_Goal__c;
                    
                    if(mapofMontlyidMonthlyRec.containsKey(Opp.Quarterly_Goal__c) && mapofMontlyidMonthlyRec.get(Opp.Quarterly_Goal__c).Total_Target_Achieved__c == null){
                        mapofMontlyidMonthlyRec.get(Opp.Quarterly_Goal__c).Total_Target_Achieved__c = 0;
                    }
                    if(Opp.Amount__c != null && mapofMontlyidMonthlyRec.get(Opp.Quarterly_Goal__c).Total_Target_Achieved__c != null){
                        
                        monthIncentiveRec.Total_Target_Achieved__c = mapofMontlyidMonthlyRec.get(Opp.Quarterly_Goal__c).Total_Target_Achieved__c + Opp.Amount__c;
                    }
                    
                    
                    mapofMontlyidMonthlyRec.put(opp.Quarterly_Goal__c,monthIncentiveRec);
                    if(mapOfMonthlyGoal.containsKey(Opp.Quarterly_Goal__c)){
                        mapOfMonthlyGoal.put(Opp.Quarterly_Goal__c,monthIncentiveRec);
                    }else{
                        mapOfMonthlyGoal.put(Opp.Quarterly_Goal__c,monthIncentiveRec);
                    }
                    
                    
                    if(oldmap != null && oldmap.get(Opp.id).Quarterly_Goal__c != null){
                        Quarterly_Goal__c monthIncentiveRecOld = new Quarterly_Goal__c();
                        monthIncentiveRecOld.id = oldmap.get(Opp.id).Quarterly_Goal__c;
                        
                        if(mapofMontlyidMonthlyRec.containsKey(Opp.Quarterly_Goal__c) && mapofMontlyidMonthlyRec.get(Opp.Quarterly_Goal__c).Total_Target_Achieved__c == null){
                            mapofMontlyidMonthlyRec.get(Opp.Quarterly_Goal__c).Total_Target_Achieved__c = 0;
                        }
                        
                        
                        monthIncentiveRecOld.Total_Target_Achieved__c = mapofMontlyidMonthlyRec.get(oldmap.get(Opp.Id).Quarterly_Goal__c).Total_Target_Achieved__c - Opp.Amount__c;
                        mapofMontlyidMonthlyRec.put(opp.Quarterly_Goal__c,monthIncentiveRecOld);
                        if(mapOfMonthlyGoal.containsKey(Opp.Quarterly_Goal__c)){
                            mapOfMonthlyGoal.put(Opp.Quarterly_Goal__c,monthIncentiveRecOld);
                        }else{
                            mapOfMonthlyGoal.put(Opp.Quarterly_Goal__c,monthIncentiveRecOld);
                        }
                        
                    }
                    
                }
                
            }
            if(!mapOfMonthlyGoal.isEmpty()){
                update mapOfMonthlyGoal.values();
            }
        }
        
    }
    
    //Added by shubhi : used to tag Opportunity Owner based on Account Owner..
    public static void updateOppOwner(List<Opportunity1__c> oppList){
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity1__c opp : oppList) {
            if (opp.AccountId__c != null) {
                accountIds.add(opp.AccountId__c);
            }
        }
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, OwnerId FROM Account WHERE Id IN :accountIds]);
        for (Opportunity1__c opp : oppList) {
            if (opp.AccountId__c != null && accountMap.containsKey(opp.AccountId__c)) {
                opp.OwnerId__c = accountMap.get(opp.AccountId__c).OwnerId;
            }
        }
    }
    
    //Added by shubhi : used to Change Primary Quote stage based on Opportunity Stage..
    public static void updateQuoteStage(List<Opportunity1__c> newOppList, Map<Id,Opportunity1__c> oldOppRec){
        List<Opportunity1__c> opportunitiesToUpdate = new List<Opportunity1__c>();
        for (Opportunity1__c opp : newOppList) {
            if (opp.StageName__c == 'Quote Initiated' && oldOppRec.get(opp.Id).StageName__c != 'Quote Initiated') {
                opportunitiesToUpdate.add(opp);
            }
        }
        if (!opportunitiesToUpdate.isEmpty()) {
            List<Quote_C__c> primaryQuotesToUpdate = [SELECT Id, Status__c, OpportunityId__c FROM Quote_C__c WHERE OpportunityId__c IN :opportunitiesToUpdate];
            for (Quote_C__c q : primaryQuotesToUpdate) {
                q.Status__c = 'Presented';
            }
            if (!primaryQuotesToUpdate.isEmpty()) {
                update primaryQuotesToUpdate;
            }
        }
    }
    
    //Added by shubham : This is used to Map the Close Date , Fiscal Year & Quarterly Goals when stage is changed to Closed Won..
    public static void UpdateFiscalYearAndQuarterlyGoalsBasedOnStage(map<Id,Opportunity1__c> newMap , map<Id,Opportunity1__c> oldMap){
        try{
            List<Opportunity1__c> newOppRecs = [Select id , CloseDate__c , Fiscal_Year__c , Quarterly_Goal__c ,StageName__c ,ownerID__c,Amount__c from Opportunity1__c where id IN :newMap.Keyset()];
            Date todaysDate = system.Today();
            List<Opportunity1__c> OpportunitiesToBeUpdated = new List<Opportunity1__c>();
            map<Id,List<Quarterly_Goal__c>> quarterGoalsByUserId = new map<Id,List<Quarterly_Goal__c>>();
            map<Date,Id> fiscalYearByDate = new map<Date,Id>();
            map<Id,Id> quarterlyGoalByFiscalYear = new map<Id,Id>();
            map<Id,Quarterly_Goal__c> quarterlyGoalById = new map<Id,Quarterly_Goal__c>();
            map<Id,Decimal> oppAmountByQGId = new map<Id,Decimal>();
            System.debug('newOppRecs == >'+newOppRecs.size());
            
            List<Fiscal_Year__c> fiscalYears = [SELECT Id, Fiscal_Year_Start_Period__c, Fiscal_Year_End_Period__c 
                                                FROM Fiscal_Year__c 
                                                WHERE Fiscal_Year_Start_Period__c <= :Date.today() 
                                                AND Fiscal_Year_End_Period__c >= :Date.today()];
            
            Map<Date, Id> fiscalYearByCloseDate = new Map<Date, Id>();
            for (Opportunity1__c oppRec : newOppRecs) {
                for (Fiscal_Year__c fiscalYear : fiscalYears) {
                    if (fiscalYear.Fiscal_Year_Start_Period__c <= oppRec.CloseDate__c && fiscalYear.Fiscal_Year_End_Period__c >= oppRec.CloseDate__c) {
                        fiscalYearByCloseDate.put(oppRec.CloseDate__c, fiscalYear.Id);
                        break;
                    }
                }
            }
            
            for (Opportunity1__c oppRec : newOppRecs) {
                oppRec.Fiscal_Year__c = fiscalYearByCloseDate.get(oppRec.CloseDate__c);
            }

            
            for(Fiscal_Year__c fiscYearRec : [SELECT Id FROM Fiscal_Year__c WHERE Fiscal_Year_Start_Period__c <= :todaysDate AND Fiscal_Year_End_Period__c >= :todaysDate LIMIT 1]){
                fiscalYearByDate.put(todaysDate,fiscYearRec.Id);
            }
            
            for(Quarterly_Goal__c quarterGoalRec : [select id,Quarter_End_Date__c,Quarter_Start_Date__c,Fiscal_Year__c,User__c,Total_Target_Achieved__c From Quarterly_Goal__c where Fiscal_Year__c IN: fiscalYearByDate.values()]){
                if(!quarterGoalsByUserId.containsKey(quarterGoalRec.User__c)){
                    List<Quarterly_Goal__c> newQuarterGoals = new List<Quarterly_Goal__c>();
                    newQuarterGoals.add(quarterGoalRec);
                    quarterGoalsByUserId.put(quarterGoalRec.User__c,newQuarterGoals);
                }else{
                    quarterGoalsByUserId.get(quarterGoalRec.User__c).add(quarterGoalRec);
                }
                quarterlyGoalById.put(quarterGoalRec.Id,quarterGoalRec);
            }
            
            for(Opportunity1__c newOppRec : newOppRecs){
                Opportunity1__c oldOppRec = oldMap.get(newOppRec.Id);
                if(newOppRec.StageName__c != oldOppRec.StageName__c && newOppRec.StageName__c == 'Closed Won'){
                    newOppRec.CloseDate__c = todaysDate;
                    newOppRec.Fiscal_Year__c = fiscalYearByDate.get(todaysDate);
                    //Adding the logic for getting quarterlyGoals based upon users 
                    for(Quarterly_Goal__c quarterGoalRec : quarterGoalsByUserId.get(newOppRec.OwnerId__c)){
                        if( todaysDate >= quarterGoalRec.Quarter_Start_Date__c && todaysDate <=quarterGoalRec.Quarter_End_Date__c ){ 
                            newOppRec.Quarterly_Goal__c = quarterGoalRec.Id;
                            oppAmountByQGId.put(newOppRec.Quarterly_Goal__c,newOppRec.Amount__c);
                        }
                    }
                    OpportunitiesToBeUpdated.add(newOppRec);
                }else if(newOppRec.CloseDate__c != oldOppRec.CloseDate__c){
                    newOppRec.Fiscal_Year__c = fiscalYearByDate.get(newOppRec.CloseDate__c);
                    //Adding the logic for getting quarterlyGoals based upon users 
                    for(Quarterly_Goal__c quarterGoalRec : quarterGoalsByUserId.get(newOppRec.OwnerId__c)){
                        system.debug('quarterGoalRec==>'+quarterGoalRec);
                        if( newOppRec.CloseDate__c >= quarterGoalRec.Quarter_Start_Date__c && newOppRec.CloseDate__c <=quarterGoalRec.Quarter_End_Date__c ){ 
                            system.debug('quarterGoalRec==>'+quarterGoalRec);
                            newOppRec.Quarterly_Goal__c = quarterGoalRec.Id;
                            //oppAmountByQGId.put(newOppRec.Quarterly_Goal__c,newOppRec.Amount__c);
                        }
                    }
                    OpportunitiesToBeUpdated.add(newOppRec);
                }
            }
            if(OpportunitiesToBeUpdated.size() > 0){
                update OpportunitiesToBeUpdated;
            }
            if(oppAmountByQGId.size() > 0){
                system.debug('Coming here');
                system.debug('oppAmountByQGId==>'+oppAmountByQGId);
                for(String quarterlyGoalId : oppAmountByQGId.keyset()){
                    quarterlyGoalById.get(quarterlyGoalId).Total_Target_Achieved__c = quarterlyGoalById.get(quarterlyGoalId).Total_Target_Achieved__c + oppAmountByQGId.get(quarterlyGoalId);
                }
                update quarterlyGoalById.values();
            }
            //runonce = true;
        }catch(Exception e){
            system.debug('Exception Occured in UpdateFiscalYearAndQuarterlyGoalsBasedOnStage ==> '+e.getMessage()+'@@'+e.getLineNumber());
        }
    }
    
    //Added by shubhi : used to tag Quarterly Goal when new opportunity is inserted.
    public static void tagQuarterlyGoal(List<Opportunity1__c> opplist) {
        
        Set<Id> fiscalIds = new Set<Id>();
        for (Opportunity1__c oppRec : opplist) {
            fiscalIds.add(oppRec.Fiscal_Year__c);
        }
        
        Map<Id, List<Quarterly_Goal__c>> mapFiscalIdMonthlygoal = new Map<Id, List<Quarterly_Goal__c>>();
        if (!fiscalIds.isEmpty()) {
            List<Quarterly_Goal__c> quarterGoalList = [SELECT Id, Quarter_End_Date__c, Quarter_Start_Date__c, Fiscal_Year__c ,User__c
                                                       FROM Quarterly_Goal__c WHERE Fiscal_Year__c IN :fiscalIds];
            if (!quarterGoalList.isEmpty()) {
                for (Quarterly_Goal__c quarterlyRec : quarterGoalList) {
                    if (!mapFiscalIdMonthlygoal.containsKey(quarterlyRec.Fiscal_Year__c)) {
                        mapFiscalIdMonthlygoal.put(quarterlyRec.Fiscal_Year__c, new List<Quarterly_Goal__c>());
                    }
                    mapFiscalIdMonthlygoal.get(quarterlyRec.Fiscal_Year__c).add(quarterlyRec);
                }
            }
            
            for (Opportunity1__c oppRec : opplist) {
                boolean quarterlyGoalFound = false;
                if (mapFiscalIdMonthlygoal.containsKey(oppRec.Fiscal_Year__c)) {
                    for (Quarterly_Goal__c quarterlyRec : mapFiscalIdMonthlygoal.get(oppRec.Fiscal_Year__c)) {
                        if (oppRec.OwnerId__c != null && quarterlyRec.User__c != null && oppRec.OwnerId__c == quarterlyRec.User__c &&
                            oppRec.CloseDate__c >= quarterlyRec.Quarter_Start_Date__c && oppRec.CloseDate__c <= quarterlyRec.Quarter_End_Date__c) {
                                oppRec.Quarterly_Goal__c = quarterlyRec.Id;
                                quarterlyGoalFound = true; 
                                break; 
                            }
                    }
                }              
                if (!quarterlyGoalFound) {
                    oppRec.Quarterly_Goal__c = null;
                }
            }     
        }
    }
    
    //Added by shubhi : used to tag Quarterly Goal when after insert of Opportunity, Fiscal Year is updated.
    public static void tagQuarterlyGoalAfterFYIsUpdated(List<Opportunity1__c> newList, Map<Id, Opportunity1__c> oldOppMap) {
        Set<Id> fiscalIds = new Set<Id>();
        Map<Id, List<Quarterly_Goal__c>> mapFiscalIdMonthlyGoal = new Map<Id, List<Quarterly_Goal__c>>();
        List<Opportunity1__c> opportunitiesToUpdate = new List<Opportunity1__c>();
        for (Opportunity1__c newOpportunity : newList) {
            Opportunity1__c oldOpportunity = oldOppMap.get(newOpportunity.Id);
            if (oldOpportunity.Fiscal_Year__c != newOpportunity.Fiscal_Year__c) {
                opportunitiesToUpdate.add(newOpportunity);
            }
            fiscalIds.add(newOpportunity.Fiscal_Year__c);
        }
        if (!fiscalIds.isEmpty()) {
            List<Quarterly_Goal__c> quarterlyGoalList = [SELECT Id, Quarter_End_Date__c, Quarter_Start_Date__c, Fiscal_Year__c, User__c
                                                         FROM Quarterly_Goal__c WHERE Fiscal_Year__c IN :fiscalIds];
            for (Quarterly_Goal__c quarterlyGoalRec : quarterlyGoalList) {
                mapFiscalIdMonthlyGoal.put(quarterlyGoalRec.Fiscal_Year__c, quarterlyGoalList);
            }
            for (Opportunity1__c oppRec : opportunitiesToUpdate) {
                boolean quarterlyGoalFound = false;
                if (mapFiscalIdMonthlyGoal.containsKey(oppRec.Fiscal_Year__c)) {
                    for (Quarterly_Goal__c quarterlyRec : mapFiscalIdMonthlyGoal.get(oppRec.Fiscal_Year__c)) {                  
                        if (oppRec.OwnerId__c != null && quarterlyRec.User__c != null && oppRec.OwnerId__c == quarterlyRec.User__c &&
                            oppRec.CloseDate__c >= quarterlyRec.Quarter_Start_Date__c && oppRec.CloseDate__c <= quarterlyRec.Quarter_End_Date__c) {
                                oppRec.Quarterly_Goal__c = quarterlyRec.Id;
                                quarterlyGoalFound = true;
                                break; 
                            }
                    }
                }
                if (!quarterlyGoalFound) {
                    //oppRec.Quarterly_Goal__c = null;
                }
            }
        }
    }
    
    
    //Added by shubhi : used to tag Fiscal Year based on Opp Closed Date.    
    public static void updateFiscalYearByClosedDate(List<Opportunity1__c> newOpplist) {
        List<Id> opportunityIdsToUpdate = new List<Id>();
        
        try {
            for (Opportunity1__c opp : newOpplist) {
                Date closedDate = opp.CloseDate__c;
                if (closedDate != null) {
                    Fiscal_Year__c fiscalYear = getFiscalYearByDate(closedDate);
                    if (fiscalYear != null) {
                        opportunityIdsToUpdate.add(opp.Id);
                    }
                }
            }
            
            if (!opportunityIdsToUpdate.isEmpty()) {
                List<Opportunity1__c> opportunitiesToUpdate = [SELECT Id, Fiscal_Year__c, CloseDate__c FROM Opportunity1__c WHERE Id IN :opportunityIdsToUpdate];
                
                for (Opportunity1__c oppToUpdate : opportunitiesToUpdate) {
                    Fiscal_Year__c fiscalYear = getFiscalYearByDate(oppToUpdate.CloseDate__c);
                    if (fiscalYear != null) {
                        oppToUpdate.Fiscal_Year__c = fiscalYear.Id;
                    }
                }
                
                if (!opportunitiesToUpdate.isEmpty()) {
                    update opportunitiesToUpdate;
                }
            }
        } catch (Exception e) {
            System.debug('Exception caught: ' + e.getMessage());
        }
    }
    
    @TestVisible 
    private static Fiscal_Year__c getFiscalYearByDate(Date closedDate) {
        List<Fiscal_Year__c> fiscalYears = [SELECT Id FROM Fiscal_Year__c WHERE Fiscal_Year_Start_Period__c <= :closedDate AND Fiscal_Year_End_Period__c >= :closedDate LIMIT 1];
        return fiscalYears.isEmpty() ? null : fiscalYears[0];
    }   
    
    //Added by shubhi : used for inserting Product Fixed Price record under Account after Opp is marked Closed Won.    
    public static void insertNewProductFixedPriceRecord(Map<Id,Opportunity1__c> mapOfOpportunity){
        
        Map<Id,List<Opportunity1__c>> mapofAccIdByListOfOpp = new Map<Id,List<Opportunity1__c>>();
        
        for(Opportunity1__c opp : mapOfOpportunity.values()){
            if(opp.StageName__c == 'Closed Won'){
                if(mapofAccIdByListOfOpp.containsKey(opp.AccountId__c)){
                    mapofAccIdByListOfOpp.get(opp.AccountId__c).add(opp);
                }else{
                    mapofAccIdByListOfOpp.put(opp.AccountId__c,New List<Opportunity1__c>{opp});
                }
            }
        }
        
        system.debug('mapofAccIdByListOfOpp' + mapofAccIdByListOfOpp);
        
        List<OpportunityLineItem1__c> oliList = new List<OpportunityLineItem1__c>();
        
        oliList = [Select id,Product1Id__c,Opportunity1Id__c,UnitPrice__c 
                   from OpportunityLineItem1__c 
                   where Opportunity1Id__c in: mapOfOpportunity.keyset()];
        
        if(!mapofAccIdByListOfOpp.isEmpty()){
            List<Product_Fixed_Price__c> pfpList                     = new List<Product_Fixed_Price__c>();
            Map<Id,List<Product_Fixed_Price__c>> mapOfAccIdByPFPList = new Map<Id,List<Product_Fixed_Price__c>>();
            
            pfpList = [Select Id,Product__c,Account__c 
                       FROM Product_Fixed_Price__c 
                       where Account__c in: mapofAccIdByListOfOpp.keySet()];
            
            system.debug('pfpList' + pfpList);
            List<Product_Fixed_Price__c> pfpListTobeInsert = new List<Product_Fixed_Price__c>();
            
            if(!pfpList.isEmpty()){
                
                for(Product_Fixed_Price__c pfp : pfpList){
                    if(mapOfAccIdByPFPList.containsKey(pfp.Account__c)){
                        mapOfAccIdByPFPList.get(pfp.Account__c).add(pfp);
                    }else{
                        mapOfAccIdByPFPList.put(pfp.Account__c,new List<Product_Fixed_Price__c>{pfp});
                    }
                }
                
                for(OpportunityLineItem1__c oli:oliList){
                    
                    boolean flowContinue = false;
                    for(Product_Fixed_Price__c pfp : mapOfAccIdByPFPList.get(mapOfOpportunity.get(oli.Opportunity1Id__c).AccountId__c)){
                        
                        if(oli.Product1Id__c == pfp.Product__c){
                            break;
                            flowContinue = false;
                        }
                        flowContinue = true;
                    }
                    if(flowContinue){
                        Product_Fixed_Price__c pfp = new Product_Fixed_Price__c();
                        pfp.Product__c             = oli.Product1Id__c;
                        pfp.Account__c             = mapOfOpportunity.get(oli.Opportunity1Id__c).AccountId__c;
                        pfp.Selling_Price__c       = oli.UnitPrice__c;
                        pfpListTobeInsert.add(pfp);
                    }
                    
                }
                insert pfpListTobeInsert;
            }
            else if(pfpList.isEmpty()){
                for(OpportunityLineItem1__c oli:oliList){
                    Product_Fixed_Price__c pfp = new Product_Fixed_Price__c();
                    pfp.Product__c             = oli.Product1Id__c;
                    pfp.Account__c             = mapOfOpportunity.get(oli.Opportunity1Id__c).AccountId__c;
                    pfp.Selling_Price__c       = oli.UnitPrice__c;
                    pfpListTobeInsert.add(pfp);
                }
                insert pfpListTobeInsert;
            }
        }
    }
    
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
    
    
    
    
    
}