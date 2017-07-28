global class AccountTypeBatchUpdate implements Database.Batchable<sObject>, Database.Stateful
{
    global final String query;
    
    global AccountTypeBatchUpdate(String q)
    {
        query = q;
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope)
    {
        List<Account> accntstoUpdate = new List<Account>();
        for(Account a : scope)
            {
                a.Type = 'Customer - Direct';
                accntstoUpdate.add(a);
            }
        update accntstoUpdate;
    }
    
   global void finish(Database.batchableContext BC)
    {
        //do nothing here
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email FROM AsyncApexJob 
                            WHERE Id =:BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Account Field Updates ' + a.Status);
        mail.setPlainTextBody ('The batch Apex job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
          
    }
      
   
}