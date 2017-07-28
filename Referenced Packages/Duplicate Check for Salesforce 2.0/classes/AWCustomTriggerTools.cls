/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AWCustomTriggerTools {
    global AWCustomTriggerTools() {

    }
    global Map<String,Set<String>> CreateKeys(SObject ObjectData, String ObjectType) {
        return null;
    }
    global Map<String,Set<String>> CreateKeys(SObject ObjectData, String ObjectType, String RecordTypeId) {
        return null;
    }
    global Map<String,List<awduplicate2.AWFindResult>> Find(SObject obj, String ObjectName, Integer ThresholdScore, String Method) {
        return null;
    }
    global Map<String,List<awduplicate2.AWFindResult>> Find(SObject obj, String ObjectName, Integer ThresholdScore, String Method, String RecordTypeId) {
        return null;
    }
    global Map<String,List<awduplicate2.AWFindResult>> Find(SObject obj, String ObjectName, Integer ThresholdScore, String Method, String RecordTypeId, String Function) {
        return null;
    }
    global Boolean InsertJob(String Type, String JobName, String JobId, String ObjectName, Datetime start) {
        return null;
    }
    global Map<String,String> SplitKeys(Set<String> Keys) {
        return null;
    }
    global void deleteSearchKeysByIds(Set<String> toDelete, String ObjectName) {

    }
    global Map<String,Set<String>> getAllFieldConfigByGroupCombi(String O, String F, String R) {
        return null;
    }
    global Boolean getConfigBoolean(String Setting) {
        return null;
    }
    global Map<String,List<awduplicate2__awDuplicateFieldSettings__c>> getFieldConfigByRecordTypeId(String ObjectName) {
        return null;
    }
    global Map<String,List<awduplicate2__awDuplicateFieldSettings__c>> getFieldConfigByRecordTypeId(String ObjectName, String Function) {
        return null;
    }
    global List<awduplicate2__awDuplicateFieldSettings__c> getFieldConfigSearchKey(String ObjectName) {
        return null;
    }
    global List<awduplicate2__awDuplicateFieldSettings__c> getFieldConfig(String ObjectName) {
        return null;
    }
    global List<awduplicate2__awDuplicateFieldSettings__c> getFieldConfig(String ObjectName, String RecType) {
        return null;
    }
    global List<awduplicate2__awDuplicateFieldSettings__c> getFieldConfig(String ObjectName, String RecType, String Function) {
        return null;
    }
    global Set<String> getFieldsByObject(String ObjectName, String Function, String RecType) {
        return null;
    }
    global String getHTMLDuplicateMessage(Map<String,List<awduplicate2.AWFindResult>> Duplicates) {
        return null;
    }
    global Integer getLiceneEdition() {
        return null;
    }
    global Map<String,List<String>> getListFieldsMapByObjects(Set<String> ObjectList) {
        return null;
    }
    global Map<String,String> getSearchKeyStorage(String ObjectName) {
        return null;
    }
    global Integer getThresholdByObjectFeature(String O, String F, String R) {
        return null;
    }
    global Boolean isLicensed() {
        return null;
    }
    global Boolean isLicensed(String O) {
        return null;
    }
    global Boolean isObjectDifferentDelta(SObject oldObject, SObject newObject, String ObjectName) {
        return null;
    }
    global Boolean isObjectDifferent(SObject oldObject, SObject newObject, String ObjectName, List<awduplicate2__awDuplicateFieldSettings__c> FieldConfig) {
        return null;
    }
    global Boolean isRecordTypeAvailable(String O) {
        return null;
    }
    global Boolean isUserDisableDuplicateCheck(Id UserId) {
        return null;
    }
    global Map<String,String> reloadViewListFieldsObject(Map<String,List<String>> ViewListFields) {
        return null;
    }
}
