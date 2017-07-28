trigger opportunityTrigger on Opportunity (after update) {


   // OpportunityTriggerHandler handler = new OpportunityTriggerHandler();
    OpportunityTriggerHandler.getOpportunityProdRelns(trigger.newMap);
    //List<Opportunity> opptyList = new List<Opportunity>();

     // Call the Flow
    //Map<String, Object> params = new Map<String, Object>();
    //params.put('sObjOpptyColl', trigger.new);
    //Flow.Interview.OpportunityFlow opptyFlow = new Flow.Interview.OpportunityFlow(params);
    //opptyFlow.start();

  /*  system.debug('the flow has'+opptyFlow.getVariableValue('sObjOpptyColl'));
    List<Opportunity> updatedOppty =(List<Opportunity>) opptyFlow.getVariableValue('sobjOpptyUpdate');
    for(Opportunity o : updatedOppty)
        System.debug('----->' +o.Name + ' ' + o.Description);*/
}