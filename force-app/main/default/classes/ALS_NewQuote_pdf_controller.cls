public class ALS_NewQuote_pdf_controller {

    public Quote_C__c quote { get; set; }
    public List<QuoteLineItems_c__c> quoteLineItems { get; set; }
    public Decimal totalAmount { get; set; }
    public String totalAmountWords { get; set; }
    public String totalAmountWordswithoutGst { get; set; }
    Public String quotationDate { get; set; }
    Public String validityDate { get; set; }
    Public String countryFullName { get; set; }
    public Decimal discountPercentage { get; set; }
    private static final Decimal FIXED_GST_PERCENTAGE = 18;
    public Decimal gstPercentage { get; set; }
    public Decimal discountAmount { get; set; }
    public Decimal gstAmount { get; set; }
    public Decimal grandTotal { get; set; }
    public Decimal grandTotalWithouGSTAndDiscount { get; set; }
    public Decimal grandTotalwithoutdiscount { get; set; }
    public static Information__mdt information { get; set; }
    Public Static ALS_Analytical_Mumbai_Information__mdt mumbaiInfo { get; set; }
    Public Static ALS_Analytical_Terms_and_Condition__mdt mumbaiTermsandCons {get; set; }
    public static CountryFullForm__mdt countryFullForm { get; set; }
    public static Integer pdfCount {get;set;}
    public static String pdfVersion {get;set;} 
    
    public ALS_NewQuote_pdf_controller(ApexPages.StandardController controller) {
        if(controller.getId()!=null){
            quote = [SELECT Id, Quote_Name__c,Subject__c,Subtotal__c,Total_Price1__c, Include_GST__c, Sample_Requirement__c,OpportunityId__c, OpportunityId__r.CreatedBy.Name,OpportunityId__r.CreatedBy.MobilePhone,OpportunityId__r.Billing_Address__Street__s,
                     OpportunityId__r.Billing_Address__City__s,OpportunityId__r.Billing_Address__PostalCode__s,OpportunityId__r.Billing_Address__StateCode__s,
                     OpportunityId__r.Billing_Address__CountryCode__s,AccountId__r.Name, Include_Discount__c, CreatedDate,LastModifiedDate,CurrencyIsoCode, Quote_Validity__c,Quote_Validity1__c, Discount__c, Sample_Quantity__c, 
                     TAT__c, Note__c, Comment__c, Name, Email__c, ContactId__r.Name, ContactId__r.Phone, ContactId__r.Email, ContactId__r.Owner.Name,ContactId__r.Owner.MobilePhone,
                     (SELECT Quantity__c, Name, List_Price__c,Sales_Price__c,Subtotal__c, Total_Price__c, ProductId__r.Name,ProductId__r.ProductCode__c,Test_Method__c,Product_Code__c FROM QuoteLineItems__r) 
                     FROM Quote_C__c 
                     WHERE Id = :controller.getId()];
            system.debug('quote === >'+quote);
            pdfCount = [SELECT count() FROM Attachment WHERE ParentId=:controller.getId()];
            if(pdfCount !=0){
                pdfVersion = '-'+String.valueOf(pdfCount).leftPad(2, '0');
                system.debug('pdfVersion === >'+pdfVersion);
            }
            Decimal total = 0;
            if (quote != null) {
                quoteLineItems = quote.QuoteLineItems__r;
                System.debug('quote.Subtotal__c === >'+quote.Subtotal__c);
                total += quote.Subtotal__c;
            }
            
            List<CountryFullForm__mdt> countryMetadata = [SELECT Label, Short_Name__c FROM CountryFullForm__mdt];
            for (CountryFullForm__mdt country : countryMetadata) {
            if (country.Short_Name__c == quote.OpportunityId__r.Billing_Address__CountryCode__s) {
                countryFullName = country.Label;
                System.debug('countryFullName==>'+countryFullName);
            }
        }
   
            totalAmount = total;
            System.debug('totalAmount == >'+totalAmount);
            
          //  quotationDate  = quote.CreatedDate.format('dd/MM/yyyy');
          if(quote.Quote_Validity1__c !=null){
            Date validityDateObject = quote.Quote_Validity1__c;
            Integer day = validityDateObject.day();
            Integer month = validityDateObject.month();
            Integer year = validityDateObject.year();
            validityDate  = String.valueOf(day) + '/' + String.valueOf(month) + '/' + String.valueOf(year);
          }
            
            information = [select Information_1__c, Information_2__c, Information_3__c, Information_4__c, Sample_pick_up_service__c, A_Sample_material_logistics__c, B_Analytical_Investigations_OOS_Devi__c, Health_Safety_and_Environment_Hazardo__c, Documentation__c, Turnaround_time__c, Notes__c from Information__mdt limit 1];

            mumbaiInfo = [Select Analytical_Investigation__c, Bank_Account_Number__c, Bank_Account_Type__c, Bank_Name__c, Documentation__c, General_Terms_and_Con1__c, General_Terms_and_Con2__c, General_Terms_and_Con3__c, General_Terms_and_Con4__c, GST_Number__c, Health_Safety_and_Environment__c, IFSC_Code__c, Information1__c, Information2__c, Name_of_Beneficiary__c, Notes__c, Payment1__c, Payment2__c, Sample_material_1__c, Sample_Material_2__c, Turnaround_time__c from ALS_Analytical_Mumbai_Information__mdt Limit 1];
            
            mumbaiTermsandCons = [Select Term_1__c,Term_2__c,Term_3__c, Term_4__c, Term_5__c, Term_6__c, Term_7__c, Term_8__c, Term_9__c, Term_10__c, Term_11__c, Term_12__c, Term_13__c, Term_14__c, Term_15__c, Term_15_1__c, Term_15_2__c, Term_15_3__c, Term_16__c, Term_17__c, Term_18__c, Term_18_1__c, Term_18_2__c from ALS_Analytical_Terms_and_Condition__mdt Limit 1];
            
            gstPercentage = FIXED_GST_PERCENTAGE;
            
            // Fetch Discount and GST values from Quote
            discountPercentage = quote.Discount__c != null ? quote.Discount__c : 0;
            
            // Calculate Discount Amount and GST Amount
            discountAmount = (discountPercentage / 100) * totalAmount;
            Decimal discountedPrice;
            gstAmount = (FIXED_GST_PERCENTAGE / 100) * totalAmount;
            
            // Calculate Grand Total based on conditions
            if (quote.Include_GST__c && quote.Include_Discount__c) {
                //grandTotal = totalAmount + gstAmount - discountAmount;
                discountedPrice = totalAmount-discountAmount;
                gstAmount = (FIXED_GST_PERCENTAGE / 100) * discountedPrice;
                grandTotal = discountedPrice + gstAmount;
            } else if (quote.Include_GST__c) {
                grandTotal = totalAmount + gstAmount;
            } else if (quote.Include_Discount__c) {
                grandTotal = totalAmount - discountAmount;
            } else {
                grandTotal = totalAmount;
            }
            totalAmountWords = NumberToText.convert(Integer.valueOf(grandTotal));
            
          if(totalAmount !=null){
            String stringValue = String.valueOf(totalAmount);
            Integer decimalIndex = stringValue.indexOf('.');
            if (decimalIndex != -1 && (stringValue.length() - decimalIndex - 1) > 2) {
                totalAmount = totalAmount.setScale(2);
            }
            System.debug('totalAmount new == >'+totalAmount);
          }
          if(discountAmount !=null){
            String stringValue = String.valueOf(discountAmount);
            Integer decimalIndex = stringValue.indexOf('.');
            if (decimalIndex != -1 && (stringValue.length() - decimalIndex - 1) > 2) {
                discountAmount = discountAmount.setScale(2);
            }
            System.debug('discountAmount new == >'+discountAmount);
          }
          if(gstAmount !=null){
            String stringValue = String.valueOf(gstAmount);
            Integer decimalIndex = stringValue.indexOf('.');
            if (decimalIndex != -1 && (stringValue.length() - decimalIndex - 1) > 2) {
                gstAmount = gstAmount.setScale(2);
            }
            System.debug('gstAmount new == >'+gstAmount);
          }
          if(grandTotal !=null){
            String stringValue = String.valueOf(grandTotal);
            Integer decimalIndex = stringValue.indexOf('.');
            if (decimalIndex != -1 && (stringValue.length() - decimalIndex - 1) > 2) {
                grandTotal = grandTotal.setScale(2);
            }
             totalAmountWords = AmountInNumberToWords.convert(grandTotal);
            System.debug('grandTotal new == >'+grandTotal);
          }
        } 
        
        
    }
}