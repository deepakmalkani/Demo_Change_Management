public with sharing class ContactDedup_Handler {
	public ContactDedup_Handler() {}

	public void contactdupCheck(Map<ID, Contact> newContMap)
	{
		
		Set<String> cntctPhoneSet = new Set<String>();
		Map<String, Contact> dupoldcntctMap = new Map<String, Contact>();
		List<Contact> cntctUpList = new List<Contact>();
		Map<ID, Contact> contLstContDateMap;
		Boolean firstRec = true;
		Boolean pickMaster = true;

		//Step 1 : Prepare a set of all contact Phone Numbers for the newly arrived contacts
		for(Contact con : newContMap.values())
			if(con.Phone != null)
				cntctPhoneSet.add(con.Phone);

		//Step 2 : Prepare a Map of all existing contacts with same phone number
		for(Contact oldContacts : [SELECT id, LastName, FirstName, Phone, Dupe_Tracker__c,Last_Contact_Date__c
									FROM Contact
									WHERE Phone IN : cntctPhoneSet AND id NOT IN : newContMap.values()])
			dupoldcntctMap.put(oldContacts.Phone, oldContacts);

		for(Contact newcontwtDate : [SELECT id, LastName, FirstName, Phone, Dupe_Tracker__c, Last_Contact_Date__c,CreatedDate
										FROM Contact
										WHERE Phone IN : cntctPhoneSet AND Last_Contact_Date__c != null
										ORDER BY Last_Contact_Date__c DESC, CreatedDate
										LIMIT 1])
			contLstContDateMap.put(newcontwtDate.Phone, newcontwtDate);

		//Step 3 : Loop Through Contacts to find the Master and Deuplicate
		for(Contact c : newContMap.values())
		{
			//No existing contacts in the database with same phone number
			if(dupoldcntctMap.isEmpty())
			{
				system.debug('---> there are no existing contacts with this phone #');
				//Is there any contact with Last Contact Date, make this contact as the master, clear winner
				if(!contLstContDateMap.isEmpty())
				{
					if(contLstContDateMap.containsKey(c.Phone))
					{
					system.debug('---> newly created contact has a last contact date, so its the master');
					Contact conObj = new Contact(Id = c.Id);
					conObj.Dupe_Tracker__c = 'Master';
					cntctUpList.add(conObj);
					}
				}
				//If no contact with date, then the first contact which gets inserted is our Master, rest all Duplicates.
				else if(firstRec)
				{
					system.debug('---> inside the loop where the first contact becomes master');
					Contact conObj = new Contact(Id = c.Id);
					conObj.Dupe_Tracker__c = 'Master';
					cntctUpList.add(conObj);
					firstRec = false;	
				}
				else
				{
					system.debug('---> inside the loop where all other contact becomes Dups');
					Contact conObj = new Contact(Id = c.Id);
					conObj.Dupe_Tracker__c = 'Duplicate';
					cntctUpList.add(conObj);
				}
			}
			//There are existing records in the database with same phone numbers,
			else
			{
				//Complex Situation : Is any newly created contact having Last Contact Date > existing old contacts
				//if yes, this new contact becomes master. We will deal with the already existing mater later.
				if(dupoldcntctMap.containsKey(c.Phone) && dupoldcntctMap.get(c.Phone).Last_Contact_Date__c <= c.Last_Contact_Date__c)
				{
					Contact conObj = new Contact(Id = c.Id);
					conObj.Dupe_Tracker__c = 'Master';
					cntctUpList.add(conObj);	
				}
				//If not in any case, then all contacts which arrive become duplicates.
				else
				{
					Contact conObj = new Contact(Id = c.Id);
					conObj.Dupe_Tracker__c = 'Duplicate';
					cntctUpList.add(conObj);
				}
			}
		}

		if(!cntctUpList.isEmpty())
			update cntctUpList;
		cntctUpList.clear();
		//This scenario, uncovers the complex scenario explained above
		//First we query on all contacts with the Phone Number specified in the set and who are set as Masters.
		//Dont need to process this every time, only process, when complex scenario occurs.
		//Dont want heap limits to grow, so limiting to 2 only.
		List<Contact> masterContacts = [SELECT id, FirstName, LastName, CreatedDate, Last_Contact_Date__c, Phone, Dupe_Tracker__c
										FROM Contact
										WHERE Phone IN : cntctPhoneSet AND Dupe_Tracker__c = 'Master'
										ORDER BY Last_Contact_Date__c DESC, CreatedDate LIMIT 2];
		if(masterContacts.size() > 1)
		{
			//SOQL For Loop will take care of Heap Limits
			for(Contact updConts : [SELECT id, FirstName, LastName, CreatedDate, Last_Contact_Date__c, Phone, Dupe_Tracker__c
									FROM Contact
									WHERE Phone IN : cntctPhoneSet AND Dupe_Tracker__c = 'Master'
									ORDER BY Last_Contact_Date__c DESC, CreatedDate])
			{
				//Pick the first contact, make it Master, rest all Master Contacts become Dups.
				if(pickMaster)
				{
					Contact conObj = new Contact(Id = updConts.Id);
					conObj.Dupe_Tracker__c = 'Master';
					cntctUpList.add(conObj);
					pickMaster = false;	
				}
				else
				{
					Contact conObj = new Contact(Id = updConts.Id);
					conObj.Dupe_Tracker__c = 'Duplicate';
					cntctUpList.add(conObj);
				}
			} 
		}

		if(!cntctUpList.isEmpty())
			update cntctUpList;
	}

}