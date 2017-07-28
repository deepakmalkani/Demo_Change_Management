public with sharing class AccountController {

    public Account accnt;
    public Account getAccount() {
        String AccountId= ApexPages.CurrentPage().getParameters().get('id');
        accnt = [SELECT Name from Account WHERE id = : AccountId];
        return accnt;
    }

}