/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AWBatchDeduplication implements Database.Batchable<SObject>, Database.Stateful {
    global List<awduplicate2__awDuplicateCrossObject__c> CrossObjectList;
    global Integer DuplicateCounter;
    global Integer Edition;
    global List<awduplicate2__awDuplicateFieldSettings__c> FieldConfig;
    global Map<String,List<awduplicate2__awDuplicateFieldSettings__c>> FieldConfigByRecType;
    global List<awduplicate2__awDuplicateFieldSettings__c> fromFieldConfig;
    global String fromObject;
    global String fromRecordType;
    global Integer GroupCounter;
    global Boolean isCrossOBject;
    global Boolean isRecType;
    global awduplicate2__awDCJob__c Job;
    global awduplicate2.AWKeyCreate KeyCreator;
    global awduplicate2.AWKeyFind KeyFinder;
    global awduplicate2.AWKeySearch KeySearcher;
    global awduplicate2.AWFindMatch Matcher;
    global Map<String,awduplicate2.AWFindMatch> MatcherByRecType;
    global SObject MatchObject;
    global String ObjectName;
    global Id recTypePaccount;
    global awduplicate2.AWFindSimple SimpleFinder;
    global Map<String,String> StorageFields;
    global List<awduplicate2__awDuplicateFieldSettings__c> toFieldConfig;
    global String toObject;
    global String toRecordType;
    global Boolean useAdvanced;
    global Boolean useSOSL;
    global AWBatchDeduplication(awduplicate2__awDCJob__c J) {

    }
    global void execute(Database.BatchableContext BC, List<SObject> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
