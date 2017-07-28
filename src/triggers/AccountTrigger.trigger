trigger AccountTrigger on Account (before update, after update, before insert, after insert) {

    Set<ID> accntIds = new Set<ID>();
    Map<ID, Account> accntMap = new Map<ID, Account>();
    List<Contact> contList = new List<Contact>();
    List<Opportunity> opptyList = new List<Opportunity>();
    AccountDedup_Handler accntcheckHandler = new AccountDedup_Handler();
    if(trigger.isBefore)
    {
        if(trigger.isInsert)
        {      
            system.debug('---> before insert trigger has list '+trigger.new); 
        }
    }
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {
            system.debug('---> after insert trigger has list '+trigger.new);
            accntcheckHandler.accountdupCheck(trigger.newMap);
            //call the flow 
            Map<String, Object> params = new Map<String, Object>();
            List<Account> accntList = new List<Account>();
            accntList = [SELECT id, Name, OwnerId FROM Account WHERE id IN : trigger.new];
            params.put('sObjAccntColln', accntList);
            Flow.Interview.AccountSharing_Flow AccountShare = new Flow.Interview.AccountSharing_Flow(params);
            AccountShare.start();
            //check outputs
            List<Account> insAccnts= (List<Account>) AccountShare.getVariableValue('sObjAccntColln'); 
            List<AccountShare> shareRecords = (List<AccountShare>) AccountShare.getVariableValue('AccountShareColln');
            system.debug('---> value in share list is '+shareRecords);
            system.debug('---> The share record size is '+shareRecords.Size());         
        }
        if(trigger.isUpdate)
        {
            for(Account acc : trigger.new)
            {
                if(acc.OwnerId != trigger.oldMap.get(acc.Id).OwnerId)
                    accntMap.put(acc.Id, acc);
            }
            
            
            if(!accntMap.isEmpty())
            {
                for(Contact con : [SELECT id, FirstName, LastName, OwnerId, Account.OwnerId, AccountId 
                                    FROM Contact
                                    WHERE AccountId IN : accntMap.keySet()])
                {
                    contList.add(con);             
                }
                
                for(Opportunity opp : [SELECT id, Name, OwnerId, AccountId
                                        FROM Opportunity
                                        WHERE AccountId in : accntMap.keySet()])
                {
                    opptyList.add(opp);
                }
             
             //Call the flow
             Map<String, Object> params = new Map<String, Object>();
             params.put('sObjContactColl', contList);
             params.put('sObjOpportunityColl', opptyList);
             Flow.Interview.AccntOwnerChange accntOwnerFlow = new Flow.Interview.AccntOwnerChange(params);
             accntOwnerFlow.start();
                
             List<Contact> updContacts = (List<Contact>) accntOwnerFlow.getVariableValue('sObjContactColl');   
             }            
        }        
    }
}