public class mycustomcontroller2 
{

    private final Account account;

    public mycustomcontroller2() 
    {
     //   account = [SELECT Id, Name, Site FROM Account 
     //              WHERE Id = :ApexPages.currentPage().getParameters().get('id')][0];
    }

    public Account getAccount() {
        return account;
    }

    public PageReference save() {
    //    update account;
        return null;
    }
}