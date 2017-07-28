trigger ContactTrigger on Contact (after insert, after delete, after update) {
    
    //initatialise all handlers here
    ContactDedup_Handler contDupeHandler = new ContactDedup_Handler();
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {
            contDupeHandler.contactdupCheck(trigger.newMap);
            Set<ID> accntIds = new Set<ID>();
            for(Contact c : trigger.new)
                if(c.accountId != null)
                    accntIds.add(c.AccountId);
            if(!accntIds.isEmpty())
            {
                List<Account> accntList = new List<Account>();
                accntList = [SELECT id, Primary_Contact__c, Name, Industry FROM Account WHERE id IN : accntIds];
                system.debug('----> the value in accntList is '+accntList);
                //call the flow
                Map<String, Object> params = new Map<String, Object>();
                params.put('sObjAccntColl', accntList);
                Flow.Interview.AccntPrimaryContact accntFlow = new Flow.Interview.AccntPrimaryContact(params);
                accntFlow.start();
            }
        }
    }
    if(trigger.isDelete)
    {
        Set<ID> accntIds = new Set<ID>();
        for(Contact c : trigger.old)
            if(c.AccountId != null)
                accntIds.add(c.AccountId);
        if(!accntIds.isEmpty())
        {
            List<Account> accntList = new List<Account>();
            accntList = [SELECT id, Primary_Contact__c, Name, Industry FROM Account WHERE id IN : accntIds];
            system.debug('----> the value in accntList is '+accntList);
            //call the flow
            Map<String, Object> params = new Map<String, Object>();
            params.put('sObjAccntColl', accntList);
            Flow.Interview.AccntPrimaryContact accntFlow = new Flow.Interview.AccntPrimaryContact(params);
            accntFlow.start();
    
            // Obtain results
            List<Account> updatedAccounts = (List<Account>) accntFlow.getVariableValue('sObjAccntColl');
    
            system.debug('-----> updated list is '+updatedAccounts);
         }
    }
    if(trigger.isUpdate)
    {
        ContactTriggerHandler handler = new ContactTriggerHandler();
        handler.chkContactPrimaryChanges(trigger.newMap, trigger.oldMap);
    }
}