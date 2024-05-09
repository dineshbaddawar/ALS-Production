@isTest
public class BulkAccountRevenueUploadControllerTest {
    
    @isTest static void BulkAccountRevenueTest() {
        Account acc = new Account(Name = 'Testing data');
        insert acc;
        List<Bulk_Account_Revenue_Upload_Mapping__mdt	> gsrCSVFileFormatList = [SELECT Field_API_Name__c,Id,Label FROM Bulk_Account_Revenue_Upload_Mapping__mdt];
        
        String salesData = 'Date,Particulars,Voucher Type,Voucher No.,CC,Voucher Ref. No.,GSTIN/UIN,GST Code,Revenue,State,AM,Zone,Remarks,Sales Manager\n' +
            '13-03-2024,Testing data,Sales,BNL240100000313,PHARMA,8007175,29AAACH0383A1Z1,25,20000,Delhi,Operational,South Zone,0050T0000042PzeQAE';
        String mainString = 'Date,Particulars,Voucher Type,Voucher No.,CC,Voucher Ref. No.,GSTIN/UIN,GST Code,Revenue,State,AM,Zone,Remarks,Sales Manager';
        List<String> stringTobePass = mainString.split(',');
        BulkAccountRevenueUploadController.processData(salesData,'Account_Revenue__c',stringTobePass);
         BulkAccountRevenueUploadController.mytest();

    }
}