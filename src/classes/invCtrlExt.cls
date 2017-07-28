public with sharing class invCtrlExt {

    public transient List<Inventory__c> invObjList;
    public String branchVal {get; set; }
    Boolean isFirstTime = true;
    public String catVals {get; set; }
    public String bookTypeVals {get; set; }
    public String videoTypeVals {get; set; }
    public Boolean isBook = true;
    public List<wrapInventory> wrapInvList = new List<wrapInventory>();
    public List<wrapInventory> wrapListckOut = new List<wrapInventory>();
    public Boolean selected {get; set;}
    public String InventoryId {get; set; }
    public String remInvId {get; set; }
    public Set<ID> invIdSet = new Set<ID>();
    public Boolean showCart = true;
    
    public invCtrlExt(ApexPages.StandardController controller) {
        if (isFirstTime)
            branchVal = ApexPages.CurrentPage().getParameters().get('brnchName');
        system.debug('-----> branch value passed is '+branchVal);
        //wrapInvList = new List<wrapInventory>();
        for(Inventory__c invObj : [SELECT Name, RecordType.Name, Author_Name__c, Book_Type__c, Branch_Name__c, Checked_Out__c, Video_Type__c, Title__c 
                                    FROM Inventory__c
                                    WHERE Branch_Name__c = : branchVal AND (RecordType.Name = 'Books' 
                                            AND Book_Type__c = 'Audio') AND Checked_Out__c = false])                                    
            wrapInvList.add(new wrapInventory(invObj));
        
    }
    
    public List<wrapInventory> getWrapList()
    {
        if(isFirstTime)
        {
            isFirstTime = false;
            return wrapInvList;
        }
        else if(catVals == 'Books') 
        {    
            wrapInvList.clear();
            //wrapInvList = new List<wrapInventory>();    
            for(Inventory__c invObj : [SELECT Name, RecordType.Name, Author_Name__c, Book_Type__c, Branch_Name__c,Checked_Out__c, Video_Type__c, Title__c 
                    FROM Inventory__c
                    WHERE Branch_Name__c IN (SELECT id FROM Branch__c WHERE Name = : branchVal ) AND RecordType.Name = : catVals  
                                    AND (Book_Type__c = : bookTypeVals) AND Checked_Out__c = false])
                wrapInvList.add(new wrapInventory(invObj));    
            
            system.debug('----> wrapper invenroty list for books is '+wrapInvList);
            return wrapInvList;
        }
        else
        {
            wrapInvList.clear();
            //wrapInvList = new List<wrapInventory>();
            for(Inventory__c invObj : [SELECT Name, RecordType.Name, Author_Name__c, Book_Type__c, Branch_Name__c,Checked_Out__c, Video_Type__c, Title__c 
                                        FROM Inventory__c
                                        WHERE Branch_Name__c IN (SELECT id FROM Branch__c WHERE Name = : branchVal ) AND RecordType.Name = : catVals  
                                        AND (Video_Type__c = : bookTypeVals) AND Checked_Out__c = false])
                wrapInvList.add(new wrapInventory(invObj));
            
            return wrapInvList;
        }              
    }
    public Boolean getshowCart()
    {
        return showCart;
    }
    public PageReference addCart()
    {
        system.debug('----> value of id is '+InventoryId);
        return null;
    }
    
    public List<Inventory__c> getinvList()
    {
        if(InventoryId != null)
            invIdSet.add(InventoryId);
        if(invIdSet.contains(remInvId))
            invIdSet.remove(remInvId);
        remInvId = null;
        InventoryId = null;
        return [SELECT Name, RecordType.Name, Author_Name__c, Author_Name__r.Name, Book_Type__c, Branch_Name__c,Checked_Out__c, Video_Type__c, Title__c 
                FROM Inventory__c WHERE id IN : invIdSet];
    }
 
    public PageReference placeHold()
    {   
        showCart = false;
        ID ContactId = ApexPages.CurrentPage().getParameters().get('custName');            
        List<CheckOut__c> ckList = new List<Checkout__c>();
        List<Inventory__c> invUpdList = new List<Inventory__c>();
        if(!invIdSet.isEmpty())
        {
            for(Inventory__c inv : [SELECT id, Name FROM Inventory__c WHERE id IN : invIdSet])
            {
                Checkout__c ckObj = new CheckOut__c();
                ckObj.Item_Name__c = inv.Id;
                ckObj.Customer_Name__c = ContactId;
                ckList.add(ckObj);
                Inventory__c invObj = new Inventory__c(Id = inv.Id);
                invObj.On_Hold__c = true;
                invObj.On_Hold_By__c = ContactId;
                invObj.Date_on_Hold__c = system.Now();
                invObj.Checked_Out__c = true;
                invObj.Checkout_By__c = ContactId;
                invUpdList.add(invObj);
            }
        }
        if(!ckList.isEmpty())
            insert ckList;
        if(!invUpdList.isEmpty())
            update invUpdList;
        //clear off the collections
        ckList.clear();
        ContactId = null;
        invUpdList.clear();
        
        return null;
    }   
    public Boolean getBook()
    {
        return isBook;
    }
    
    public List<SelectOption> getbranchValues(){
        List<Branch__c> brObjList = [SELECT Name FROM Branch__c];
        //List<Schema.PicklistEntry> P = F.getPicklistValues();
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('','--All--'));
        for(Integer i = 0; i < brObjList.size(); i++){
            options.add(new SelectOption(brObjList[i].Name, brObjList[i].Name));
        }
        return options;
    }    
  
     public List<SelectOption> getrTypeValues(){
        List<RecordType> rtypeList = [SELECT Name,SobjectType FROM RecordType WHERE SobjectType = : 'Inventory__c'];
        //List<Schema.PicklistEntry> P = F.getPicklistValues();
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('','--All--'));
        for(Integer i = 0; i < rtypeList.size(); i++){
            options.add(new SelectOption(rtypeList[i].Name, rtypeList[i].Name));
        }
        return options;
    }       
   
    public List<SelectOption> getbookTypeValues()
    {
        List<SelectOption> options = new List<SelectOption>();
        if(catVals == 'Books' || catVals == null || catVals == '')
        {
            Schema.DescribeFieldResult F =  Inventory__c.Book_Type__c.getDescribe();
            List<Schema.PicklistEntry> P = F.getPicklistValues();
            
            //options.add(new SelectOption('','--All--'));
            for(Integer i = 0; i < P.size(); i++){
                options.add(new SelectOption(P[i].getValue(), P[i].getLabel()));
            }
        }
        else
        {
            Schema.DescribeFieldResult Fr =  Inventory__c.Video_Type__c.getDescribe();
            List<Schema.PicklistEntry> Pr = Fr.getPicklistValues();
            
            //options.add(new SelectOption('','--All--'));
            for(Integer i = 0; i < Pr.size(); i++){
                options.add(new SelectOption(Pr[i].getValue(), Pr[i].getLabel()));
            }
        }
        return options;
    }
    
    public class wrapInventory
    {
        public transient Inventory__c invent {get; set;}
        public ID InventoryId {get; set; }
        public Boolean selected {get; set; }
                
        public wrapInventory (Inventory__c invObj)
        {
            InventoryId = invObj.Id;
            system.debug('---> object passed is '+invObj);
            invent = invObj;
            selected = false;
        }
    }
                  
}