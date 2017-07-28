/*
	Author : Deepak Malkani.
	Created Date : Jan 29 2015
	Purpose : Performs all Business Operations related to Case Object only.
*/
public with sharing class CaseTriggerHandler {

	//Method used to validate case specific due date changes
	public void validateDueDateChange(Map<ID, Case> newMap, Map<ID, Case> oldMap){
		
		Set<ID> caseIds = new Set<ID>();
		for(Case caseObj : newMap.values())
		{
			if(caseObj.Status != 'Closed' && caseObj.Due_Date__c != oldMap.get(caseObj.Id).Due_Date__c)
			{
				//perform changes op Open Activities related to Cases
				caseIds.add(caseObj.Id);
			}
		}
		if(!caseIds.isEmpty())
			this.changeOpenActDates(caseIds);
	}
	//Method used to change Task Due Date, if Case Due date has changed
	public void changeOpenActDates(Set<ID> caseIds)
	{
		List<Task> taskUpdLst = new List<Task>();
		for(Case caseObjNew : [SELECT id, Due_Date__c, (SELECT id, whatId, ActivityDate, Status FROM Tasks WHERE Status != 'Closed')
								FROM Case WHERE id IN : caseIds])
		{
			for(Task tkObj : caseObjNew.tasks)
			{
				Task tskObj = new Task(Id = tkObj.Id);
				tskObj.ActivityDate = caseObjNew.Due_Date__c;
				taskUpdLst.add(tskObj);
			}
		}
		
		if(!taskUpdLst.isEmpty())
			update taskUpdLst;
	}
}