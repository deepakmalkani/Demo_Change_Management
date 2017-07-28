/*
	Author : Deepak Malkani.
	Created Date : Jan 29 2015
	Purpose : Contains Utility Methods which will be used by all Test Classes
	
*/
@isTest(SeeAllData=false)
public with sharing class TestUtilities {
	
	
	public static List<Case> createMultiCases(Integer i){
		List<Case> caseinsList = new List<Case>();
		for(Integer j=0; j< i; j++)
		{
			Case csObj = new Case();
			csObj.Status = 'New';
			csObj.Priority = 'Medium';
			csObj.Origin = 'Web';
			csObj.Due_Date__c = system.today() + 10;
			caseinsList.add(csObj);
		}
		if(!caseinsList.isEmpty())
			insert caseinsList;
		return caseinsList;
	}
	
	public static Task createsingleCaseTasks(Case csObj){
		Task tskObj = new Task();
		tskObj.WhatId = csObj.Id;
		tskObj.Status = 'In Progress';
		tskObj.ActivityDate = null;
		tskObj.OwnerId = UserInfo.getUserId();
		insert tskObj;
		return tskObj;
	}
	
	public static List<Task> createmultiCaseTasks(List<Case> csObjList, Integer i){
		List<Task> tskinsList = new List<Task>();
		for(Integer j=0; j<csObjList.Size(); j++)
		{
			for(Integer p=0; p<i; p++)
			{
				Task tskObj = new Task();
				tskObj.WhatId = csObjList[j].Id;
				tskObj.Status = 'In Progress';
				tskObj.ActivityDate = null;
				tskObj.OwnerId = UserInfo.getUserId();
				tskinsList.add(tskObj);
			}
		}
		if(!tskinsList.isEmpty())
			insert tskinsList;
		return tskinsList;
	}
}