global class MyWebService {

  webservice static String makeerrorlog(String Name, String ObjectName, String ObjectId){

    String returnMessage;
    
    Batch_Error_Log__c b = new Batch_Error_Log__c();
    b.Name__c = Name;
    b.Object_Id__c = ObjectId;
    b.Object_Name__c = ObjectName;
    insert b;
    
    if(b.Id != null)
        returnMessage = 'Record Successfully Inserted';
    else
        returnMessage = 'Failure';
    
    return returnMessage;
    
  }

}