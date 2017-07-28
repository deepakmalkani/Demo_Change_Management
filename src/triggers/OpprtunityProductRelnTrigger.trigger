/*
	Author : Deepak Malkani.
*/

trigger OpprtunityProductRelnTrigger on dpklightning__MAM_Product_Relationships__c (after insert) {

	/*Map<String, String> productOpptyMap = new Map<String, String>();
	Map<String, String> opptyRevenueMap = new Map<String, String>(); 
	Set<ID> opptyIds = new Set<ID>();
	Double revenue = 0.0;
	for(dpklightning__MAM_Product_Relationships__c prodReln : trigger.new)
	{
		if(prodReln.dpklightning__Product__c != null && prodReln.dpklightning__Opportunity__c != null)
		{
			productOpptyMap.put(prodReln.dpklightning__Product__c, prodReln.dpklightning__Opportunity__c);
			opptyIds.add(prodReln.dpklightning__Opportunity__c);
		}
	}

	Map<Id, Opportunity> opptyCreatedMap = new Map<Id, Opportunity>([SELECT id, Amount, dpklightning__Commission_Revenue__c, Name
											FROM Opportunity
											WHERE id IN : opptyIds]);

	for(dpklightning__Pricing__c pricing : [SELECT id, dpklightning__Amount__c, dpklightning__Points_Multiplier__c, dpklightning__Product__c, dpklightning__Revenue_Calculation__c
											FROM dpklightning__Pricing__c
											WHERE dpklightning__Product__c IN : productOpptyMap.keySet()])
	{
		if(opptyCreatedMap.containsKey(productOpptyMap.get(pricing.dpklightning__Product__c)))
		{
			if((opptyCreatedMap.get(productOpptyMap.get(pricing.dpklightning__Product__c)).Amount - pricing.dpklightning__Amount__c > pricing.dpklightning__Amount__c) && pricing.dpklightning__Amount__c != null)
			{
				revenue += pricing.dpklightning__Revenue_Calculation__c;
			}
			else if ((opptyCreatedMap.get(productOpptyMap.get(pricing.dpklightning__Product__c)).Amount - pricing.dpklightning__Amount__c < pricing.dpklightning__Amount__c) && pricing.dpklightning__Amount__c != null)
			{
				revenue += (opptyCreatedMap.get(productOpptyMap.get(pricing.dpklightning__Product__c)).Amount - pricing.dpklightning__Amount__c)*(pricing.dpklightning__Points_Multiplier__c/100);
			}
			else if  (pricing.dpklightning__Amount__c == null)
			{
				//do nothing
			}
		}
	}

	system.debug('--> the revenue generated is '+revenue);*/
}