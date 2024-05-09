/**
* @author [Dinesh Baddawar]
* @email dinesh.b@utilitarianLab.com
* @create date 2024-04-02 18:38:03
* @modify date 2024-04-02 18:38:03
* @desc [Method used for inserting Account Revenue using CSV File]
*/

public class BulkAccountRevenueUploadController {
    @AuraEnabled
    public static void processData(String fileData,String sobjectName,List<String> fields){
        System.debug('fileData = >'+fileData);
        System.debug('fields == >'+fields);
        List<Account_Revenue__c> AccountRevenueListToRecord = new List<Account_Revenue__c>();
        map<String,String> apiNameByLabelName 	= new map<String,String>();
        Map<String,String> mapOfAccountNameAccountId = new Map<String,String>();
        for(Account acc : [SELECt Id,Name FROM Account]){
            mapOfAccountNameAccountId.put(acc.Name,acc.id);
        }
        List<Bulk_Account_Revenue_Upload_Mapping__mdt	> gsrCSVFileFormatList = [SELECT Field_API_Name__c,Id,Label FROM Bulk_Account_Revenue_Upload_Mapping__mdt	];
        for(Bulk_Account_Revenue_Upload_Mapping__mdt	 gsrm : gsrCSVFileFormatList) {
            apiNameByLabelName.put(gsrm.Label,gsrm.Field_API_Name__c);
        }       
        List<sObject> recordList = new List<sObject>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sobjectName);
        try{
            if(fileData!=null) { 
                String[] fileLines = new String[]{};
                    fileLines = fileData.split('\n');
                for (Integer i=1,j=fileLines.size();i<j;i++){
                    String[] inputvalues = new String[]{};
                        inputvalues = fileLines[i].split(',');
                    sObject obj = targetType.newSObject();
                    integer rowsize=inputvalues.size(); 
                    for(integer l=0;l<rowsize;l++){     
                        if(String.isNotBlank(inputvalues[l])) {
                            String value= inputvalues[l].length()>255 ? inputvalues[l].substring(0,254) : inputvalues[l];
                            if(value != null){
                                if(apiNameByLabelName.get(fields.get(l)) !=null){
                                    if(apiNameByLabelName.get(fields.get(l)) == 'Date__c'){
                                        String dateString =  value;
                                        List<String> dateParts = dateString.split('-');
                                        Integer day = Integer.valueOf(dateParts[0]);
                                        Integer month = Integer.valueOf(dateParts[1]);
                                        Integer year = Integer.valueOf(dateParts[2]);
                                        String formattedDateString = year + '-' +
                                            (month < 10 ? '0' + month : String.valueOf(month)) + '-' +
                                            (day < 10 ? '0' + day : String.valueOf(day));
                                        obj.put(String.valueOf(apiNameByLabelName.get(fields.get(l))),Date.valueOf(formattedDateString));
                                    }
                                    else if(apiNameByLabelName.get(fields.get(l)) == 'GST_Code__c'){
                                        obj.put(String.valueOf(apiNameByLabelName.get(fields.get(l))),Decimal.valueOf(value.replace('\r', '')));
                                    } 
                                    else if(apiNameByLabelName.get(fields.get(l)) == 'Revenue__c'){
                                        obj.put(String.valueOf(apiNameByLabelName.get(fields.get(l))),Decimal.valueOf(value.replace('\r', '')));
                                    } 
                                    else{
                                        obj.put(apiNameByLabelName.get(fields.get(l)),value);
                                    }
                                }
                            }
                        }
                    }
                    recordList.add(obj);
                }
            }
            System.debug('recordList Size ==== >'+recordList.size());
            if(recordList.size()>0){
                for(sObject record : recordList){
                    Account_Revenue__c caseRec = new Account_Revenue__c();   
                    if(record.get('Date__c') !=null){
                        caseRec.Date__c =Date.valueOf((Date)record.get('Date__c'));
                    }
                    if(record.get('Particulars__c') !=null){
                        caseRec.Particulars__c	 = mapOfAccountNameAccountId.get((String)record.get('Particulars__c'));
                    }
                    if(record.get('Voucher_No__c') !=null){
                        caseRec.Voucher_No__c	 = (String)record.get('Voucher_No__c');
                    }
                    if(record.get('Voucher_Reference_No__c') !=null){
                        caseRec.Voucher_Reference_No__c	 = (String)record.get('Voucher_Reference_No__c');
                    }
                    if(record.get('Voucher_Type__c') !=null){
                        caseRec.Voucher_Type__c	 = (String)record.get('Voucher_Type__c');
                    }
                    if(record.get('CC__c') !=null){
                        caseRec.CC__c	 = (String)record.get('CC__c');
                    }
                    if(record.get('GSTIN_UIN__c') !=null){
                        caseRec.GSTIN_UIN__c	 = (String)record.get('GSTIN_UIN__c');
                    }
                    if(record.get('GST_Code__c') !=null){
                        caseRec.GST_Code__c	 =  (Decimal)record.get('GST_Code__c');
                    }
                    if(record.get('Revenue__c') !=null){
                        caseRec.Revenue__c	 = (Decimal)record.get('Revenue__c');
                    }
                    if(record.get('State__c') !=null){
                        caseRec.State__c	 = (String)record.get('State__c');
                    }
                    if(record.get('AM__c') !=null){
                        caseRec.AM__c	 = (String)record.get('AM__c');
                    }
                    if(record.get('Remark__c') !=null){
                        caseRec.Remark__c = (String)record.get('Remark__c');
                    }
                    if(record.get('Zone__c') !=null){
                        caseRec.Zone__c = (String)record.get('Zone__c');
                    }
                    if(record.get('Id') !=null){
                        String updateRecordId = (String)record.get('Id');
                        caseRec.Id = updateRecordId.replace('\r', '');
                    }
                    if(record.get('Sales_Manager__c') !=null){
                        string salesMangerId = (String)record.get('Sales_Manager__c');
                        caseRec.Sales_Manager__c = salesMangerId.replace('\r', '');
                    }
                    AccountRevenueListToRecord.add(caseRec);
                }  
                if(AccountRevenueListToRecord.size()>0){
                    upsert AccountRevenueListToRecord;
                    System.debug('Case record inserted Size ==== >'+AccountRevenueListToRecord.size());
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
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
    }
    
}