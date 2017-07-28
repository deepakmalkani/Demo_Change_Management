trigger LibraryCardTrigger on Library_Card__c (before insert, before update, after insert, after update, after delete, after undelete) {
    
    Map<ID, Library_Card__c> lcMap = new Map<ID, Library_Card__c>();
    Map<ID, Library_Card__c> lcMap2 = new Map<ID, Library_Card__c>();
    List<Contact> updContList = new List<Contact>();
    if(trigger.isAfter){
        if(trigger.isInsert)
        {
            for(Library_Card__c lcObj : trigger.new)
            {
                if(lcObj.Active__c == true && lcObj.Name != null && lcObj.Customer_Name__c != null)
                    lcMap.put(lcObj.Customer_Name__c, lcObj);
            }
            if(!lcMap.isEmpty())
            {
                for(Contact custCon : [SELECT id, Name, Library_Card__c FROM Contact WHERE id IN : lcMap.keySet()])
                {
                    Contact con = new Contact(Id = custCon.Id);
                    con.Library_Card__c = lcMap.get(custCon.Id).Name;
                    updContList.add(con);
                }
            }
            if(!updContList.isEmpty())
                update updContList;
            
            //clearing off all the collections
            updContList.clear();
            lcMap.clear();
        }
        if(trigger.isUpdate)
        {
            for(Library_Card__c lcObj : trigger.new)
            {
                if(lcObj.Name != null && lcObj.Customer_Name__c != null)
                    lcMap.put(lcObj.Customer_Name__c, lcObj);               
            }
            if(!lcMap.isEmpty())
            {
                for(Contact custCon : [SELECT id, Name, Library_Card__c FROM Contact WHERE id IN : lcMap.keySet()])
                {
                    Contact con = new Contact(Id = custCon.Id);
                    if(lcMap.get(custCon.Id).Active__c == true)
                        con.Library_Card__c = lcMap.get(custCon.Id).Name;
                    else
                        con.Library_Card__c = null;
                    updContList.add(con);
                }
            }
            if(!updContList.isEmpty())
                update updContList;
            
            //clearing off all the collections
            updContList.clear();
            lcMap.clear();
        }
        if(trigger.isDelete)
        {
            for(Library_Card__c lcObj : trigger.old)
            {
                if(lcObj.Active__c == true && lcObj.Name != null && lcObj.Customer_Name__c != null)
                    lcMap.put(lcObj.Customer_Name__c, lcObj);               
            }
            for(Contact custCon : [SELECT id, Name, Library_Card__c FROM Contact WHERE id IN : lcMap.keySet()])
            {
                Contact con = new Contact(Id = custCon.Id);
                con.Library_Card__c = null;    
                updContList.add(con);
            }
            if(!updContList.isEmpty())
                update updContList;
                
             //clearing off all the collections
            updContList.clear();
            lcMap.clear();
        }
        if(trigger.isUndelete)
        {
            for(Library_Card__c lcObj : trigger.new)
            {
                if(lcObj.Active__c == true && lcObj.Name != null && lcObj.Customer_Name__c != null)
                    lcMap.put(lcObj.Customer_Name__c, lcObj);               
            }
            for(Contact custCon : [SELECT id, Name, Library_Card__c FROM Contact WHERE id IN : lcMap.keySet()])
            {
                Contact con = new Contact(Id = custCon.Id);
                con.Library_Card__c = lcMap.get(custCon.Id).Name;    
                updContList.add(con);
            }
            if(!updContList.isEmpty())
                update updContList;
                
             //clearing off all the collections
            updContList.clear();
            lcMap.clear();   
        }
    }
    if(trigger.isBefore){
        if(trigger.isInsert){
            for(Library_Card__c lcObj : trigger.new)
            {
                lcMap.put(lcObj.Customer_Name__c, lcObj);
            }
            for(Library_Card__c lc : [SELECT id, name, Customer_Name__c,Active__c FROM Library_Card__c WHERE Customer_Name__c IN : lcMap.keySet() AND Active__c = true])
            {
                lcMap2.put(lc.Customer_Name__c,lc);
            }
            for(Library_Card__c lc : trigger.new)
            {
                if (lcMap2.containsKey(lc.Customer_Name__c) && lcMap2.get(lc.Customer_Name__c).Active__c == true && lc.Active__c == true)
                    lc.addError('You cannot have multiple active library cards');
            }
            
            //clearing off all maps
            lcMap.clear();
            lcMap2.clear();
        }
        if(trigger.isUpdate)
        {
            for(Library_Card__c lcObj : trigger.new)
            {
                lcMap.put(lcObj.Customer_Name__c, lcObj);
            }
            for(Library_Card__c lc : [SELECT id, name, Customer_Name__c,Active__c FROM Library_Card__c WHERE Customer_Name__c IN : lcMap.keySet() AND Active__c = true])
            {
                lcMap2.put(lc.Customer_Name__c,lc);
            }
            for(Library_Card__c lc : trigger.new)
            {
                if(!lcMap2.isEmpty())
                    if(lc.Active__c != trigger.oldMap.get(lc.Id).Active__c && lc.Active__c == true && lcMap2.get(lc.Customer_Name__c).Active__c == true)
                        lc.addError('Before you active this Library Card, make sure all other Library cards assigned to the customer is deactivated');                
            }
            
            //clearing off all maps
            lcMap.clear();
            lcMap2.clear();
        }
    }

}