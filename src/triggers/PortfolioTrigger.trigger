trigger PortfolioTrigger on Portfolio__c (before update, after update, before insert, after insert) {
    
    if(trigger.isBefore)
    {
        if(trigger.isInsert)
        {       
        }
    }
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {        
            //call the flow 
            Map<String, Object> params = new Map<String, Object>();
            List<Portfolio__c> portList = new List<Portfolio__c>();        
            params.put('portfolioColl', trigger.new);
            Flow.Interview.PortfolioShareTrigger PortfolioShare = new Flow.Interview.PortfolioShareTrigger(params);
            PortfolioShare.start();
            
        }
        if(trigger.isUpdate)
        {
           
        }        
    }
}