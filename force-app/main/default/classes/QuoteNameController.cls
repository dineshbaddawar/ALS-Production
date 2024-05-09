public class QuoteNameController {

    Public Static Void createQuoteName(List<Quote_C__c> quoteList){
        system.debug('Before Insert == >'+quoteList);
        if(!quoteList.isEmpty()){
            for(Quote_C__c qt :quoteList){
                 system.debug('Before Lab Location == >'+qt.Lab_Location1__c);
                Date currentDate = Date.today();
                String yearMonth = String.valueOf(currentDate.year()) + String.valueOf(currentDate.month()).leftPad(2, '0');
                //Integer nextQuoteNumber = getNextQuoteNumber();
                //String quoteNumber = String.valueOf(nextQuoteNumber).leftPad(5, '0');
                if(qt.Lab_Location1__c =='Banglore Lab'){
                    Integer nextQuoteNumber = getNextQuoteNumber();
                	String quoteNumber = String.valueOf(nextQuoteNumber).leftPad(5, '0');
                    qt.Name = 'QUO-BNL-' + yearMonth + '/' + quoteNumber;
                }
                else if(qt.Lab_Location1__c == 'Mumbai Lab'){
                    Integer nextQuoteNumber = getNextMumQuoteNumber();
                	String quoteNumber = String.valueOf(nextQuoteNumber).leftPad(5, '0');
                    qt.Name = 'QUO-MUM-' + yearMonth + '/' + quoteNumber;
                }
            }
        }
    }
    
    Public Static Integer getNextQuoteNumber(){
        List<Quote_C__c> existingQuotes = [SELECT Name FROM Quote_C__c WHERE Name LIKE 'QUO-BNL-%' ORDER BY CreatedDate DESC LIMIT 1];
        Integer nextQuoteNumber = 1;
        if (existingQuotes.size() > 0) {
            String lastQuoteName = existingQuotes[0].Name;
            String[] parts = lastQuoteName.split('/');
            Integer lastQuoteNumber = Integer.valueOf(parts[1]);
            nextQuoteNumber = lastQuoteNumber + 1;
        }
        
        return nextQuoteNumber;
    }
    
     Public Static Integer getNextMumQuoteNumber(){
        List<Quote_C__c> existingQuotes = [SELECT Name FROM Quote_C__c WHERE Name LIKE 'QUO-MUM-%' ORDER BY CreatedDate DESC LIMIT 1];
        Integer nextQuoteNumber = 1;
        if (existingQuotes.size() > 0) {
            String lastQuoteName = existingQuotes[0].Name;
            String[] parts = lastQuoteName.split('/');
            Integer lastQuoteNumber = Integer.valueOf(parts[1]);
            nextQuoteNumber = lastQuoteNumber + 1;
        }
        
        return nextQuoteNumber;
    }
}