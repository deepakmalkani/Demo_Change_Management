public with sharing class AccountSharesHandler {
	public AccountSharesHandler() {}

	public void insertAccntShares(List<Account> accntList, Map<String, String> userGrpMap){

		List<AccountShare> aShareList = new List<AccountShare>();
		for(Account a : accntList){
			if(userGrpMap.containsKey(a.OwnerId)){

				AccountShare aSh = new AccountShare();
				aSh.AccountAccessLevel = 'Edit';
				aSh.AccountId = a.Id;
				aSh.CaseAccessLevel = 'Read';
				aSh.OpportunityAccessLevel = 'Read';
			//	aSh.ContactAccessLevel = 'Read';
				aSh.AccountId = a.Id;
				aSh.UserorGroupId = userGrpMap.get(a.OwnerId);
				aShareList.add(aSh);
			}
		}
		if(!aShareList.isEmpty()){
			try{
				insert aShareList;
			}
			catch(Exception e){
				system.debug('Account Shares could not be done '+e.getMessage());
			}
			finally{
				aShareList.clear();
			}
		}
	}
}