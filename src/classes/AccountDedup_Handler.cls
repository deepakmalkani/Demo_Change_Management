public with sharing class AccountDedup_Handler {
	public AccountDedup_Handler() {}

	public void accountdupCheck(Map<ID, Account> newAccntMap)
	{
		Set<String> accntPhoneSet = new Set<String>();
		Map<String, Account> dupAccntMap = new Map<String, Account>();
		List<Account> accntUpList = new List<Account>();
		Boolean firstRec = true;

		//Step 1 : get a Set of all Phone Numbers for newly created Account
		for(Account acc : newAccntMap.values())
			if(acc.Phone != null)
				accntPhoneSet.add(acc.Phone);
		//Step 2: Search in Accounts if any Phone Numbers are the same
		for(Account oldAccnts : [SELECT id, Phone, Name, Dupe_Tracker__c
									FROM Account
									WHERE Phone IN : accntPhoneSet AND id NOT IN : newAccntMap.values()])
			dupAccntMap.put(oldAccnts.Phone, oldAccnts);
		system.debug('-->Size is duplicate map is '+dupAccntMap.size());
		for(Account newAccnts : newAccntMap.values())
		{
			//There is already a record which exists in the database, with same phone number
			if(!dupAccntMap.isEmpty() && dupAccntMap.containsKey(newAccnts.Phone))
			{
				system.debug('---> records already there, will be marked for Duplication');
				Account a = new Account(Id = newAccnts.Id);
				a.Dupe_Tracker__c = 'Duplicate';
				accntUpList.add(a);
			}
			//There is no record in the database with same Phone Number.
			//Mark first arrived record as Master and all others as Duplicates
			else if(dupAccntMap.isEmpty())
			{
				if(firstRec)
				{
					system.debug('---> First entered account, will be marked for Master');
					Account a = new Account(Id = newAccnts.Id);
					a.Dupe_Tracker__c = 'Master';
					accntUpList.add(a);
					firstRec = false;
				}
				else
				{
					system.debug('---> other entered account, will be marked for Dups');
					Account a = new Account(Id = newAccnts.Id);
					a.Dupe_Tracker__c = 'Duplicate';
					accntUpList.add(a);
				}
			}
		}
		if(!accntUpList.isEmpty())
			update accntUpList;
	}
}