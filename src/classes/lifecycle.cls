public with sharing class lifecycle {

     //Deepak Malkani : Order of execution
    //1) all getter methods and constructors will be instantiated.
    private final Account acct;
    Integer EmpAdd;
    public lifecycle(myController controller) {
        this.acct = (Account)controller.getAccount(); //constructor of the extension -- order 1
    }
    public String getGreeting() {
        return acct.name + ' Current Information'; //getter method of controller extension -- order 1
    }
    public void resetEmp() {
        acct.numberofemployees = 10;
        update acct;
    }
}