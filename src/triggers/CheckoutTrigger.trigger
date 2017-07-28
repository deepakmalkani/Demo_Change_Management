trigger CheckoutTrigger on Checkout__c (before insert, after insert) {

    Map<ID, Checkout__c> ckMap = new Map<ID, Checkout__c>();
    List<Inventory__c> invList = new List<Inventory__c>();
    if(trigger.isBefore)
    {
        if(trigger.isInsert){
        }
    }
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {
            for(Checkout__c ckObj : trigger.new)
                ckMap.put(ckObj.Item_Name__c, ckObj);
            for(Inventory__c inv : [SELECT id, Checked_Out__c, Checkout_By__c FROM Inventory__c WHERE id IN : ckMap.keySet()])
            {
                Inventory__c i = new Inventory__c(id = inv.Id);
                i.Checked_Out__c = true;
                i.Checkout_By__c = ckMap.get(inv.Id).Customer_Name__c;
                invList.add(i);
            }
            if(!invList.isEmpty())
                update invList;
        }
    }
}