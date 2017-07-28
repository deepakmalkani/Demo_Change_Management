trigger InventoryTrigger on Inventory__c (before insert, before update, after insert, after update) {
    
    Map<ID, Inventory__c> invMap = new Map<ID, Inventory__c>();
    Map<ID, Inventory__c> invOldMap = new Map<ID, Inventory__c>();
    List<AggregateResult> argList = new List<AggregateResult>();
    List<AggregateResult> argListOld = new List<AggregateResult>();
    List<Branch__c> brnchUpList = new List<Branch__c>();
    if(trigger.isBefore){
        if(trigger.isInsert){
        }
        if(trigger.isUpdate){
        }
    }
    if(trigger.isAfter){
        if(trigger.isInsert){
            for(Inventory__c inv : trigger.new)
                invMap.put(inv.Branch_Name__c, inv);
            argList = [SELECT Count(Id) cnt, Branch_Name__c brnch FROM Inventory__c WHERE Branch_Name__c IN : invMap.keySet()
                        GROUP BY Branch_Name__c];
            for(Inventory__c inv : trigger.new)
            {
               for(Integer i=0; i<argList.Size(); i++)
                   if(inv.Branch_Name__c == argList[i].get('brnch'))
                   {
                       Branch__c brObj = new Branch__c (Id = inv.Branch_Name__c);
                       brObj.Total_Inventory__c = (Integer)argList[i].get('cnt');
                       brnchUpList.add(brObj);
                   }    
            }
            
            if(!brnchUpList.isEmpty())
                update brnchUpList;
                
            //clear off collections
            invMap.clear();
            brnchUpList.clear();
        }
        if(trigger.isUpdate){
            for(Inventory__c inv : trigger.new)
                if(inv.Branch_Name__c != trigger.oldMap.get(inv.Id).Branch_Name__c)
                {
                    invMap.put(inv.Branch_Name__c, inv);
                    invOldMap.put(trigger.oldMap.get(inv.Id).Branch_Name__c, trigger.oldMap.values());
                }
            if(!invMap.isEmpty())
                argList = [SELECT Count(Id) cnt, Branch_Name__c brnch FROM Inventory__c WHERE Branch_Name__c IN : invMap.keySet()
                            GROUP BY Branch_Name__c];
            if(!invOldMap.isEmpty())
                argListOld = [SELECT Count(Id) cnt, Branch_Name__c brnch FROM Inventory__c WHERE Branch_Name__c IN : invOldMap.keySet()
                            GROUP BY Branch_Name__c];
            system.debug('----> the value in the old list is '+argListOld);                
            for(Inventory__c inv : trigger.new)
            {
               if(inv.Branch_Name__c != trigger.oldMap.get(inv.Id).Branch_Name__c)
               {
                   for(Integer i=0; i<argList.Size(); i++)
                       if(inv.Branch_Name__c == argList[i].get('brnch'))
                       {
                           Branch__c brObj = new Branch__c (Id = inv.Branch_Name__c);
                           brObj.Total_Inventory__c = (Integer)argList[i].get('cnt');
                           brnchUpList.add(brObj);
                       }
                   if(argList.isEmpty())
                   {     
                       Branch__c brObj = new Branch__c (Id = inv.Branch_Name__c);
                       brObj.Total_Inventory__c = 0;
                       brnchUpList.add(brObj);
                   }
               }
            }
            
            for(Inventory__c inv : trigger.old)
            {
               if(inv.Branch_Name__c != trigger.newMap.get(inv.Id).Branch_Name__c)
               {
                   for(Integer i=0; i<argListOld.Size(); i++)
                       if(inv.Branch_Name__c == argListOld[i].get('brnch'))
                       {
                           Branch__c brObj = new Branch__c (Id = inv.Branch_Name__c);
                           brObj.Total_Inventory__c = (Integer)argListOld[i].get('cnt');
                           brnchUpList.add(brObj);
                       }
                   if(argListOld.isEmpty())
                   {
                        system.debug('---> old list is empty, so the total inventory will be 0');
                        Branch__c brObj = new Branch__c (Id = inv.Branch_Name__c);
                        brObj.Total_Inventory__c = 0;
                        brnchUpList.add(brObj);
                   }
               }
            }
            if(!brnchUpList.isEmpty())
                update brnchUpList;
            
             //clear off collections
            invMap.clear();
            brnchUpList.clear();
        }
    }
    
}