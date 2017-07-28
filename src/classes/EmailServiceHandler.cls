global class EmailServiceHandler implements Messaging.InboundEmailHandler   
{  
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope)   
     {  
        if (email.plainTextBody== 'start second batch')  
               {  
                  // create the instance of second batch class  
                  AccountTypeBatchUpdate obj = new AccountTypeBatchUpdate('SELECT id, Name FROM Account');  
                  Database.executeBatch(obj);  
               }   
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();  
        return result;  
     }  
}