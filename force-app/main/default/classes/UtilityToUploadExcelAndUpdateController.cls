public class UtilityToUploadExcelAndUpdateController {

    @AuraEnabled
    Public Static List<Sample_Update_Label_Field_API_Name__mdt>  getSample_update_mdt(){
        return [SELECT Field_API_Name__c,Field_Data_Type__c,Field_Label__c,Sequence__c FROM Sample_Update_Label_Field_API_Name__mdt Order By Sequence__c ]; 
    }

    @AuraEnabled
    Public static String CreateSampleUpdateRecords(List<Sample_Update__c> sampleUpdateList){
        System.debug('sampleUpdateList === >'+sampleUpdateList);

            Set<String> QuoteName                         =new Set<String>();
            Map<String,Quote_C__c> QuoteName_RelatedQuote =new Map<String,Quote_C__c>();
            String message;
            List<Sample_Update__c> sampleListToUpdate     =new List<Sample_Update__c> ();

            try{
           if(!sampleUpdateList.isEmpty()){
                for(Sample_Update__c SM :sampleUpdateList){
                    System.debug('SM value == >'+SM);
                    QuoteName.add(SM.Quote_Name__c);
                }
                 system.debug('QuoteName === >'+QuoteName) ;

                if(!QuoteName.isEmpty()){
                     List<Quote_C__c> quotelist=[Select Id,OpportunityId__c,Name From Quote_C__c Where Name=:QuoteName];
                     system.debug('quotelist Size === >'+quotelist.size()) ;
                    if(!quotelist.isEmpty()){
                       for(Quote_C__c QC:quotelist){
                            QuoteName_RelatedQuote.put(QC.Name,QC);
                       }
                    }
                    System.debug('QuoteName_RelatedQuote === >'+QuoteName_RelatedQuote);
                    if(!QuoteName_RelatedQuote.isEmpty()){
                            for(Sample_Update__c SM :sampleUpdateList){
                            SM.Opportunity1_Name__c=QuoteName_RelatedQuote.containskey(SM.Quote_Name__c) ? QuoteName_RelatedQuote.get(SM.Quote_Name__c).OpportunityId__c:null;
                            }
                    }
                    sampleListToUpdate=sampleUpdateList;
                }else {
                     sampleListToUpdate=sampleUpdateList;
                }
                System.debug('sampleListToUpdate === >'+sampleListToUpdate);
                if(!sampleListToUpdate.isEmpty()){
                    Schema.SObjectField ftoken = Sample_Update__c.Fields.Sample_ID__c;
                    Database.UpsertResult[] results = Database.upsert(sampleListToUpdate, ftoken);
                    System.debug('results == >'+results);
                    //Upsert sampleListToUpdate;
                }
                 message='SUCCESS';
            }
            }catch (Exception e){
                //message
                    System.debug('Exception type caught: ' + e.getTypeName());    
                    System.debug('Message: ' + e.getMessage());    
                    System.debug('Cause: ' + e.getCause());    // returns null
                    System.debug('Line number: ' + e.getLineNumber());    
                    System.debug('Stack trace: ' + e.getStackTraceString()); 
                message=e.getMessage();
            }
            return message;
    }
     public static void mytest(){
        Integer i=0;
        i++;i++;
    
    }

}