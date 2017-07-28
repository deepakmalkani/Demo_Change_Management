public class EmailHandler  
{  
   public static void sendEmail(string body)  
   {  
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
       String[] toAddresses = new String[] {'myinboundemail@2mfkupm6mt8v94f4pk3ztuu2yuikicq3flcbbbs3rgvnub8oge.d-fdhqeam.na14.apex.salesforce.com'};  
       mail.setToAddresses(toAddresses);  
       mail.setSubject('Test Batch' );  
       mail.setPlainTextBody(body);  
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
   }  
          
}