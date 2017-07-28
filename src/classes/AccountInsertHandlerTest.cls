@isTest(SeeAllData=false)
private class AccountInsertHandlerTest
{
	
	@testSetUp(SeeAllData = false) 
	private static void setup()
	{
		List<Account> accntList = new List<Account>();
		for(Integer i=0; i< 200; i++){
			Account accnt = new Account();
			accnt.Name = 'TestAccnt'+i;
			accnt.Industry = 'Agriculture';	
			accntList.add(accnt);	
		}
		if(!accntList.isEmpty())
			insert accntList;
		system.debug('--> Account List Size is '+accntList.size());
	}

	@isTest
	private static void UnitTest_1_multipleAccntInsert(){

		List<Account> accntList = [SELECT id, NAME FROM Account WHERE NAME LIKE 'TestAccnt%'];
		AccountShare [] shares = [SELECT id, AccountId FROM AccountShare WHERE AccountId IN : accntList
									AND RowCause = 'Manual'];
		system.assertEquals(200, shares.size());
	} 

	@istest 
	private static void UnitTest_2_singleAccntInsert(){
		List<Account> accntList = [SELECT id, NAME FROM Account WHERE NAME LIKE 'TestAccnt%' LIMIT 1];
		AccountShare [] shares = [SELECT id, AccountId FROM AccountShare WHERE AccountId IN : accntList
									AND RowCause = 'Manual'];
		system.assertEquals(1, shares.size());
	}

	@istest 
	private static void UnitTest_3_NegativeTestingAccounts(){

		List<Account> accntList = new List<Account>();
		test.startTest();
		system.runAs(new User(Id = UserInfo.getUserId())){
			Account a = new Account();
			accntList.add(a);
			try{
				insert a;
			}
			catch(Exception e)
			{
				//Asserting the exception
				system.assert(e.getMessage().contains('REQUIRED')==true);
				AccountShare [] shares = [SELECT id, AccountId FROM AccountShare WHERE AccountId IN : accntList
											AND RowCause = 'Manual'];
				system.assertEquals(0, shares.size());
			}
		}
		test.stopTest();
	}

	@isTest
	private static void UnitTest_4_NegativeTestingAccntShares(){
		
		test.startTest();
		system.runAs(new User (Id = UserInfo.getUserId())){

			List<Account> accntList = [SELECT id, NAME FROM Account WHERE NAME LIKE 'TestAccnt%'];
			AccountShare [] shares = [SELECT id, AccountId FROM AccountShare WHERE AccountId IN : accntList
									AND RowCause = 'Manual'];

			//Lets add a hypothetical account share
			AccountShare accShares = new AccountShare();
			try{
				insert accShares;
			}
			catch(Exception e){
				system.assert(e.getMessage().contains('REQUIRED_FIELD_MISSING')==true);
			}
		}
		test.stopTest();
	}
}