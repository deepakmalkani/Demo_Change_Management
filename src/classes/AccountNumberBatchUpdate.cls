/*
    Author : Deepak Malkani
    Created Date : Feb 13 2015
    Purpose : Test ...
*/

global class AccountNumberBatchUpdate implements Database.Batchable<sObject>, Database.Stateful
{
    global final String query;
    global Boolean chckJobStatus;
    
    global AccountNumberBatchUpdate(String q)
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
                a.AccountNumber = '2243';
                accntstoUpdate.add(a);
            }
        try
        {
        update accntstoUpdate;
        }
        
        catch(Exception e)
        {
        //In case there are any errors in the run we need to register it in Error Log Table
        List<Batch_Error_Log__c> batchErrorList = new List<Batch_Error_Log__c>();
        for(Account acc : scope)
            {
                Batch_Error_Log__c batchError = new Batch_Error_Log__c();
                batchError.Name__c = acc.Name;
                batchError.Object_Id__c =  acc.Id;
                batchError.Object_Name__c = 'Account';
                batchError.Error_Message__c = e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString();
                batchErrorList.add(batchError);
                chckJobStatus = true;
            }
        insert batchErrorList;
        }    
    }
    
   global void finish(Database.batchableContext BC)
    {
        //will send an email only if the job fails, else will execute the next batch job
        //commenting out the bwlo code for R&D purpose
        /*AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                                TotalJobItems, CreatedBy.Email FROM AsyncApexJob 
                                WHERE Id =:BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Account Number Updates ' + a.Status);
        mail.setPlainTextBody ('The batch Apex job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures and the second batch will not start. To refer to the detailed log, please check batch error log table by logging into your Salesforce Application.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/        
        
      /*  if(chckJobStatus == true)
        {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        }
        else
        {
            EmailHandler.sendEmail('start second batch');    
        }*/
        if(chckJobStatus == true)
        {
            System.debug('Cant fire the second batch job, since the first one failed with errors');
        }
        else
        {
            Database.executeBatch(new AccountTypeBatchUpdate('SELECT id, Name, AccountNumber FROM Account'), 200);
        }
    }  
}