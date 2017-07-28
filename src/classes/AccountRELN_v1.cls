global class AccountRELN_v1 {

   webservice String area;
   webservice String region;

   //Define an object in apex that is exposed in apex web service
  
   global class Cont{
     webservice String LstName;
     webservice String FstName;
     webservice String AccntId;
   }
   
    global class AccountParent{
      webservice String name;
      webservice String baseline;
      webservice String AccountNo;
      webservice String Rating;
      webservice List<Cont> contacts;
   }
   
   webservice static List<List<sObject>> createAccountPlan(AccountParent Accnt) {
      
       //A plan maps to the Account object in salesforce.com.
       //So need to map the Plan class object to Account standard object
       
       //List<Account> accntList = new List<Account>();
       List<Contact> cntList = new List<Contact>();
       List<List<sObject>> objList = new List<List<sObject>>();
       Account acct = new Account(BaselineId__c = Accnt.baseline, Name = Accnt.Name, AccountNumber = Accnt.AccountNo, Rating = Accnt.Rating);
       //insert acct;
       for(Integer i=0; i< Accnt.contacts.Size() ;i++)
       {
           Contact con = new Contact(FirstName = Accnt.contacts[i].FstName, LastName = Accnt.contacts[i].LstName, Account = new Account(BaselineId__c = Accnt.baseline));
           insert new List<Sobject>{acct, con};
           objList.add(new List<sObject>{acct, con});
       }   
       //insert objList;
       return objList;
  }
}