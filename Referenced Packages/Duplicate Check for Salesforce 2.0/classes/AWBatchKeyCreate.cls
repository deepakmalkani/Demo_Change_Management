/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AWBatchKeyCreate implements Database.Batchable<SObject> {
    global List<awduplicate2__awDuplicateFieldSettings__c> FieldConfig;
    global List<awduplicate2__awDuplicateFieldSettings__c> FieldConfigQuery;
    global Boolean isKeyCreatable;
    global Boolean isKeyDeletable;
    global Boolean isPersonAccount;
    global Boolean isRecType;
    global Boolean isRecTypeAllowed;
    global awduplicate2.AWKeyCreate KeyCreate;
    global Map<String,List<awduplicate2__awDuplicateFieldSettings__c>> MapFieldConfigByRecTypeId;
    global String ObjectName;
    global Map<String,String> StorageFields;
    global Boolean storeObject;
    global AWBatchKeyCreate(String O, List<awduplicate2__awDuplicateFieldSettings__c> F) {

    }
    global void execute(Database.BatchableContext BC, List<SObject> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}