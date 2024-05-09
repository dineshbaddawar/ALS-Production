global class OpportunityReminderBatchClass implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query accounts where no related opportunities have been created in the last 6 months
        return Database.getQueryLocator([SELECT Id, Name, OwnerId, Batch_Executed__c,RSM__c,Owner.Email FROM Account 
                                         WHERE Batch_Executed__c = false 
                                         AND Id NOT IN (SELECT AccountId__c FROM Opportunity1__c WHERE createdDate <= :System.today().addMonths(-6))]);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(Account acc : scope) {
            if (acc.RSM__c != null) {
                User rsmUser = [SELECT Id, Email FROM User WHERE Id = :acc.RSM__c LIMIT 1];
                
                // Create an email message
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>{acc.Owner.Email, rsmUser.Email}); // Send email to account owner and RSM
                mail.setSubject('Opportunity Reminder');
                mail.setPlainTextBody('No opportunities have been created for account ' + acc.Name + ' in the last 6 months.Kindly look into it and do the needful.');
                emails.add(mail);
            } else {
                // Create an email message only for the account owner
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>{acc.Owner.Email});
                mail.setSubject('Opportunity Reminder');
                mail.setPlainTextBody('No opportunities have been created for account ' + acc.Name + ' in the last 6 months.');
                emails.add(mail);
            }
            
            // Update the Batch_Executed__c field to true
            acc.Batch_Executed__c = true;
        }
        
        // Send all emails
        Messaging.sendEmail(emails);
        
        // Update accounts
        update scope;
    }
    
    global void finish(Database.BatchableContext BC) {
        // Nothing to do in finish method
    }
}