//comment1
global class accntIterable implements iterable<Account>
{
	global Iterator<Account> Iterator()
	{
		return new AccountIterable();
	}
}