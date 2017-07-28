public with sharing class AccountInsertHandler {
	
	//default constructor
	public AccountInsertHandler() {}

	public void getOwners(List<Account> accntInsertList){
		Map<ID, User> userMap = new Map<ID, USer>();
		Set<ID> ownerIds = new Set<ID>();
		for(Account a : accntInsertList){
			ownerIds.add(a.OwnerId);
		}
		this.getUserGrps(ownerIds, accntInsertList);
	}

	private void getUserGrps (Set<ID> userIds, List<Account> accntList){
		Map<String, String> userGrpNameMap = new Map<String, String>();
		Map<String, String> userOwnerGroupMap = new Map<String, String>();

		AccountSharesHandler sharesHandler = new AccountSharesHandler();

		for(User u : [SELECT id, dpklightning__Group_Name__c FROM User WHERE id IN : userIds])
		{
			userGrpNameMap.put(u.dpklightning__Group_Name__c, u.Id);
		}

		for(Group g : [SELECT id, Name FROM Group WHERE Name IN : userGrpNameMap.keySet()])
		{
			if(userGrpNameMap.containsKey(g.Name))
			{
				userOwnerGroupMap.put(userGrpNameMap.get(g.Name), g.Id);
			}
		}
		sharesHandler.insertAccntShares(accntList, userOwnerGroupMap);
	}


}