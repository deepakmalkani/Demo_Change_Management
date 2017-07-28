public with sharing class ContactTriggerHandler {
	//default constructor
	public ContactTriggerHandler() {}

	public void chkContactPrimaryChanges(Map<ID, Contact> newConMap, Map<ID, Contact> oldConMap)
	{
		Map<ID, ID> contAccntMap = new Map<ID, ID>();
		for(Contact con : newConMap.values())
		{
			if(con.Primary__c != oldConMap.get(con.Id).Primary__c)
				contAccntMap.put(con.AccountId, con.Id);
		}
		if(!contAccntMap.isEmpty())
			this.setAccntPrimCont(contAccntMap);
	}

	public void setAccntPrimCont(Map<ID, ID> contAccntMap)
	{
		List<Account> accntList = new List<Account>();
		for(Account acnt : [SELECT id FROM Account WHERE id IN : contAccntMap.keySet()])
		{
			Account a = new Account(Id=acnt.Id);
			a.Primary_Contact__c = contAccntMap.get(acnt.Id);
			accntList.add(a);
		}
		if(!accntList.isEmpty())
			update accntList;
	}
}