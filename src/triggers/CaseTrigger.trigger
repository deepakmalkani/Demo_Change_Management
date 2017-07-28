/*
    Author : Deepak Malkani.
    Created Date : Jan 29 2015
    Purpose : Trigger on Case to perform all Business logic processing related to Cases.
              ALWAYS HAVE ONE TRIGGER PER OBJECT--this is a MUST to avoid Business Logic from firing
              across various triggers on the Same Object and making sure Order of Execution is Maintained
*/


trigger CaseTrigger on Case (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

    //Register all the handlers here
    //CaseTriggerHandler caseHandler = new CaseTriggerHandler();
    //Establishing a Common Trigger Framework
    if(trigger.isBefore){
        if(trigger.isInsert){
            
          
            
        }
        if(trigger.isUpdate){
            
        }
        if(trigger.isDelete){
            
        }       
    }
    if(trigger.isAfter){
        if(trigger.isInsert){
            
               //call the flow 
            Map<String, Object> params = new Map<String, Object>();
            //List<Case> cList = [SELECT id, CaseNumber, OwnerId FROM Case WHERE id IN : trigger.new];
            params.put('caseColl', trigger.new);
            Flow.Interview.Case_TaskCreationFlow caseTaskCreation = new Flow.Interview.Case_TaskCreationFlow(params);
            caseTaskCreation.start();
            //check outputs
            List<Case> insCase= (List<Case>) caseTaskCreation.getVariableValue('caseColl');
            system.debug('---> Cases inserted are  '+insCase);
             
            List<Task> tkList = (List<Task>) caseTaskCreation.getVariableValue('sObjTaskColl');
            system.debug('---> Tasks Inserted are   '+tkList);            
        }
        if(trigger.isUpdate){
        //    caseHandler.validateDueDateChange(trigger.newMap, trigger.oldMap);
        }
        if(trigger.isDelete){
            
        }
        if(trigger.isUndelete){
            
        }
    }
    
}