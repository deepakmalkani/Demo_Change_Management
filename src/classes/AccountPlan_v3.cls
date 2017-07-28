global class AccountPlan_v3 {

   webservice String area;
   webservice String region;

   //Define an object in apex that is exposed in apex web service

   global class Plan {
      webservice String name;
      webservice Integer planNumber;
      webservice Date planningPeriod;
      webservice Id planId;
   }
   
   global class planList{
     List<Plan> planList = new List<Plan>();
   }
   
   webservice static List<Account> createAccountPlan(List<Plan> vPlan) {
      
       //A plan maps to the Account object in salesforce.com.
       //So need to map the Plan class object to Account standard object
       
       List<Account> accntList = new List<Account>();
       for(Integer i=0; i< vPlan.Size(); i++)
       {
           Account acct = new Account();
           acct.Name = vPlan[i].name;
           acct.AccountNumber = String.valueOf(vPlan[i].planNumber);
           accntList.add(acct);
       }
           
       insert accntList;
       return accntList;
  }
}