public class CreateProductByPassingCurrency {
    
    Public Static void generateProductPriceBasedOnCurrencyType(String currencyIsoCode,Decimal currencyRate){
        try{
            system.debug('currencyIsoCode == >'+currencyIsoCode+' && currencyRate == >'+currencyRate);
            List<PriceBookEntry1__c> defaultPriceBookEntries = new List<PriceBookEntry1__c>();
            List<PriceBookEntry1__c> priceBookEntriesTobeUpdateList = new List<PriceBookEntry1__c>();
            List<CurrencyType> currencies = new List<CurrencyType>();
            Map<String,String> mapOfIsoCodePricBookId = new Map<String,String>();
            Map<Id,Id> mapOfProductIdByExistingAmount = new Map<Id,Id>();
            // defaultPriceBookEntries = [SELECT Id,CurrencyIsoCode,Product1Id__c,List_Price__c,UnitPrice__c From PriceBookEntry1__c WHERE CurrencyIsoCode = 'INR' AND Id= 'a050T000005CQ5lQAG']; 
               defaultPriceBookEntries = [SELECT Id,CurrencyIsoCode,Product1Id__c,List_Price__c,UnitPrice__c From PriceBookEntry1__c WHERE CurrencyIsoCode = 'INR'];            
            
            priceBookEntriesTobeUpdateList = [SELECT Id,CurrencyIsoCode,Product1Id__c,List_Price__c,UnitPrice__c From PriceBookEntry1__c WHERE CurrencyIsoCode =: currencyIsoCode];
            system.debug('priceBookEntriesTobeUpdateList === >'+priceBookEntriesTobeUpdateList);
            currencies = [SELECT Id,IsoCode FROM CurrencyType where IsoCode =: currencyIsoCode];
            system.debug('currencies === >'+currencies);
            for(PriceBookEntry1__c pbe : priceBookEntriesTobeUpdateList){
                mapOfProductIdByExistingAmount.put(pbe.Product1Id__c,pbe.Id);
            } 
            List<PriceBook1__c> priceBookList = [SELECT Id,CurrencyIsoCode,Name FROM PriceBook1__c];
            if(priceBookList.size()>0){
                for(PriceBook1__c pro : priceBookList){
                    mapOfIsoCodePricBookId.put(pro.Name,pro.id);
                }
            }
            system.debug('mapOfIsoCodePricBookId === >'+mapOfIsoCodePricBookId);
            system.debug('mapOfProductIdByExistingAmount::'+mapOfProductIdByExistingAmount);
            system.debug('defaultPriceBookEntries::'+defaultPriceBookEntries);
            List<PriceBookEntry1__c> pbeListTobeUpdate = new List<PriceBookEntry1__c>();
            for(PriceBookEntry1__c pbe : defaultPriceBookEntries){
                PriceBookEntry1__c pbeRec = new PriceBookEntry1__c();
                system.debug('mapOfProductIdByExistingAmount.containsKey(pbe.Product1Id__c):'+mapOfProductIdByExistingAmount.containsKey(pbe.Product1Id__c));
                if(!mapOfProductIdByExistingAmount.isEmpty() && mapOfProductIdByExistingAmount.containsKey(pbe.Product1Id__c)){
                    pbeRec.id = mapOfProductIdByExistingAmount.get(pbe.Product1Id__c);
                }else{
                    pbeRec.Product1Id__c = pbe.Product1Id__c;
                    pbeRec.Pricebook1Id__c = mapOfIsoCodePricBookId.get(pbe.CurrencyIsoCode);
                }
                pbeRec.Active__c = true;
                pbeRec.CurrencyIsoCode = currencies[0].IsoCode; 
                if(pbe.UnitPrice__c != null){
                    pbeRec.UnitPrice__c = pbe.UnitPrice__c/currencyRate;
                }
                if(pbe.List_Price__c !=null){
                    pbeRec.List_Price__c = pbe.List_Price__c/currencyRate;   
                }
                pbeListTobeUpdate.add(pbeRec);
            }
            system.debug('pbeListTobeUpdate Before upsert::'+pbeListTobeUpdate);
            upsert pbeListTobeUpdate;
            system.debug('pbeListTobeUpdate After upsert::'+pbeListTobeUpdate);
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
    
}