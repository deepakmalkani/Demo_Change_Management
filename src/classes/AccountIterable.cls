global class AccountIterable implements iterator<Account>,Database.Stateful
{
	
	Integer i {get; set;}
	global List<Account> accntmergeList;
//	List<Training_Batch_Detail__c> traidetailList{get; set;}
	
	public AccountIterable()
	{
		
	/*	traidetailList = new List<Training_Batch_Detail__c>([SELECT id, userid__c, Status__c 
															  FROM Training_Batch_Detail__c 
															  WHERE Status__c = 'Not Started']);*/
															  
		QueryAccountflds accountQueryhandler = new QueryAccountflds();
        String AccountQuery = accountQueryhandler.getAccountQuery();
        AccountQuery += ' FROM Account';
        List<Account> accntList = Database.query(AccountQuery);
        accntmergeList = new List<Account>();
        
        Integer j=0;
		for(Training_Batch_Detail__c train : [SELECT id, userid__c, Status__c 
															  FROM Training_Batch_Detail__c 
															  WHERE Status__c = 'Not Started'])
		{
			for(Account accnt : accntList)
        	{   
        		Account accntupdated = accnt.clone(false, false, true, true);
        		accntupdated.Id = accnt.Id;      		
        		accntupdated.OwnerId = train.userid__c;
				accntmergeList.add(accntupdated);
				system.debug('----> the accntmergelist contains the following owner '+accntmergeList[j].OwnerId);
			}
			j++;
		}
		i=0;																								 
	}
	
	
	
	global boolean hasNext()
	{
		return accntmergeList!=null && !accntmergeList.isEmpty() && i< accntmergeList.Size();
	}
	
	global Account next()
	{
		i++;
		system.debug('---> the value of counter is '+i + 'and the value in the list passed is '+accntmergeList[i-1]);
		return accntmergeList[i-1];		
	}
}