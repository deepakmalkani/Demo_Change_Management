public class ExpenseController {
	@AuraEnabled
    public static List<Expense__c> getExpense() {
        // Perform isAccessible() check here
        return [SELECT Id, Name, dpklightning__Amount__c, dpklightning__Client__c, dpklightning__Date__c,
        		dpklightning__Reimbursed__c, CreatedDate FROM dpklightning__Expense__c];
    }
    @AuraEnabled
	public static Expense__c saveExpense(dpklightning__Expense__c expense) {

    	// Perform isUpdateable() check here
    	system.debug('the exp is '+expense);
        upsert expense;        
    	return expense;
    }
}