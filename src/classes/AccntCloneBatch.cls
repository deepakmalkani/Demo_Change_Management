/*
    Author : Deepak Malkani
    Created Date : Feb 13 2015
    Purpose : Testing GIT /Version Controlling.
*/

//made a small change
//er2er2dqwdqwd
//one more change

global class AccntCloneBatch implements Database.batchable<Account>,Database.Stateful
{
  //  global List<Account> accntmergeList = new List<Account>();
    global List<Training_Batch_Detail__c> traidetailList;
    global List<Account> accntmergeList; 
    
    global Iterable<Account> start (Database.BatchableContext BC)
    {
        
        //returns a mixed list of Account with Owners set to the ones for training refresh
        traidetailList = new List<Training_Batch_Detail__c>([SELECT id, userid__c, Status__c,IteratorId__c 
                                                            FROM Training_Batch_Detail__c  
                                                            WHERE Status__c = 'Not Started']);
        //actually this list will store all baseline accounts 
        //this list will eventually be a dynamic soql call and then we fire database.query and store results in the list.
        //also in the same list you will have a where clause querying for only baseline accounts.
        
        QueryAccountflds accountQueryhandler = new QueryAccountflds();
        String AccountQuery = accountQueryhandler.getAccountQuery();
        AccountQuery += ' FROM Account';
        
        List<Account> accntList = new List<Account>();
        accntList = Database.query(AccountQuery);
        
        //now we merge the two lists together.
        accntmergeList = new List<Account>();  
        Integer j=0;
        
        for(Training_Batch_Detail__c train : [SELECT id, userid__c, Status__c,IteratorId__c 
                                                            FROM Training_Batch_Detail__c  
                                                            WHERE Status__c = 'Not Started'])
        {   
            for(Account accnt : accntList)
            {   
                Account cloneAccnt = accnt.clone(false, false, true, true);                                              
                cloneAccnt.OwnerId = train.userid__c;
                cloneAccnt.Id = accnt.Id;
                accntmergeList.add(cloneAccnt);
                system.debug('---> account merge list owner '+cloneAccnt.OwnerId);
            }
        }   
        
       
        return accntmergeList;
        
    //    return new accntIterable();
    }
    
    
    global void execute(Database.BatchableContext BC, List<Account> scope)
    {
        List<Account> accntcloneList = new List<Account>();
        List<Contact> contcloneList;
        Map<Id, Account> accntMap = new Map<Id, Account>();
        Map<Id, Id> accntownerMap = new Map<Id, Id>();
        
        for(Account a : scope)
        {   
        
            //this is a shallow clone, simply cloning the list and insert accounts.
            //during this timw you will create a map of id and object which will store original Id, a.Id and cloned object
            //also for this cloned account baseline id will be set to a.Id.
            
            Account cloneAccnt = a.Clone(false);
            cloneAccnt.OwnerId = a.OwnerId;
            cloneAccnt.BaselineId__c = a.Id;
            accntMap.put(a.Id, cloneAccnt);
            accntownerMap.put(a.Id, a.OwnerId);
            cloneAccnt.isClonedObject__c = true;
            accntcloneList.add(cloneAccnt);
        }
        
        if(!accntcloneList.isEmpty())
        {
            try
            {
                insert accntcloneList;
                List<Training_Batch_Detail__c> detailList = new List<Training_Batch_Detail__c>();
                if(!traidetailList.isEmpty())
                {   
                    for(Training_Batch_Detail__c trbatchdetail : traidetailList)
                    {
                        trbatchdetail.Status__c = 'Completed';
                        trbatchdetail.Error_Details__c = null;
                        detailList.add(trbatchdetail);
                    }                   
                    update detailList;
                }                
                detailList.clear();                             
            }
            catch(DMLException e)
            {
                List<Training_Batch_Detail__c> detailList = new List<Training_Batch_Detail__c>();
                if(!traidetailList.isEmpty())
                {
                    for(Training_Batch_Detail__c trbatchdetail : traidetailList)
                    {
                        trbatchdetail.Status__c = 'Error';
                        trbatchdetail.Error_Details__c = 'The Batch Errored out with the following error details : '+e.getMessage() +'and errored at the following line '+e.getLineNumber();
                        
                        detailList.add(trbatchdetail);
                    }                   
                    update detailList;                  
                }
                detailList.clear();
            }
        }
        
        List<Opportunity> opptyrel = new List<Opportunity>();
        
        //Now we need to work on relationships..
        //Opportunity being a lookup will be data intensive..
        //maybe you have 200 opportunity which will multiply by 20 = 4000 records..DML = 10000 rows.
        //so only deal with master detail who dont have an ownerid
        
      /*  for(Account accnt : [SELECT id, name, OwnerId, (SELECT id, name, AccountId, Amount, CloseDate, LeadSource, StageName, Type, OwnerId FROM Opportunities)
                            FROM Account WHERE ID IN : scope])
            {
                for(Opportunity oppty : accnt.Opportunities)
                {
                    
        
                        Opportunity newOpty = oppty.clone(false, false, true, true);
                        newOpty.BaselineId__c = oppty.Id;
                        newOpty.isConedObject__c = true;               
                        system.debug('----> Opportunity Name '+newOpty.Name + 'Account Id '+accntMap.get(accnt.Id).Id + 'OwnerId '+train.userid__c);                
                        newOpty.AccountId = accntMap.get(accnt.Id).Id;
                        newOpty.OwnerId = train.userid__c;
                        //newOpty.OwnerId = accnt.OwnerId;                
                        opptyrel.add(newOpty);
                    
                }
            }   */
            
            for(Account accnt: scope)
            {
                for(Opportunity oppty : accnt.Opportunities)
                {
                    
                        Opportunity newOpty = oppty.clone(false, false, true, true);
                        newOpty.BaselineId__c = oppty.Id;
                        newOpty.isConedObject__c = true;               
                        system.debug('----> Opportunity Name '+oppty.Name + 'Account Id '+accntMap.get(accnt.Id).Id + 'OwnerId '+accnt.OwnerId);                
                        newOpty.AccountId = accntMap.get(accnt.Id).Id;
                        newOpty.OwnerId = accnt.OwnerId;
                        //newOpty.OwnerId = accnt.OwnerId;                
                        opptyrel.add(newOpty);
                
                }
            } 
        insert opptyrel;
    
    }
    
    global void finish(Database.BatchableContext BC)
    {
        //need to write some code here..
        traidetailList.clear();
        accntmergeList.clear();
    }       
}