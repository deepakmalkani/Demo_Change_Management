public with sharing class CheckoutContExt {

    public Contact conObj;
    String lcNumber;
    Boolean showAccntSummBlock = false;
    public transient Library_Card__c lcObj;    
    
    public CheckoutContExt(ApexPages.StandardController controller) {
        conObj = [SELECT id, FirstName, LastName, Email, Phone,Library_Card__c FROM Contact WHERE Library_Card__c =: lcNumber LIMIT 1];
    }
    
    public String getlcNumber(){
        return lcNumber;
    }
    
    public void setlcNumber(String lcNo){
        this.lcNumber = lcNo;
    }
    
    public Boolean getAccntSummBlock(){
        return showAccntSummBlock;
    }
    
    public Contact getContact()
    {
        return conObj;
    }
    
    public PageReference AccountChk()
    {
        conObj = [SELECT id, FirstName, LastName, Email, Phone,Library_Card__c FROM Contact WHERE Library_Card__c =: lcNumber LIMIT 1];
        this.showAccntSummBlock = true;
        return null;       
    }
    
    public PageReference srchInventory()
    {
        lcObj = [SELECT id, Name, Issued_by_Branch__c FROM Library_Card__c WHERE Name = : conObj.Library_Card__c LIMIT 1];
        PageReference pg = Page.checkoutProcess_Pg2;
        pg.getParameters().put('brnchName', lcObj.Issued_by_Branch__c);
        pg.getParameters().put('custName', conObj.Id);
        pg.SetRedirect(true);
        return pg; 
    }
  
}