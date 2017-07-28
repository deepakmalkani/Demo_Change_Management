/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=false)
private class CaseTriggerHandlerTest {

	
    static testMethod void UnitTest1() {
        //Prepare Test Data
        //Creating single Case
        List<Case> csList = TestUtilities.createMultiCases(200);
        List<Task> tkList = TestUtilities.createmultiCaseTasks(csList, 5);
        List<Case> caseList = new List<Case>();
        
        Test.startTest();
        //Lets update the Case now
        for(Integer i=0; i<csList.Size(); i++)
        {
        	Case cObj = new Case(Id = csList[i].Id);
        	cObj.Due_Date__c = system.Today() + 15;
        	caseList.add(cObj);
        }
        if(!caseList.isEmpty())
        	update caseList;
        Test.stopTest();
        //Make Assertions
        for(Task tk : [SELECT id, ActivityDate FROM Task WHERE WhatId IN : caseList])
        	system.assertEquals(system.Today() + 15, tk.ActivityDate);
    }
}