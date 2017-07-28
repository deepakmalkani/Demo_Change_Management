/*
 *	Aura Controller class used to search leads  
 * 
*/
public without sharing class LeadSearchController {
	@AuraEnabled
    public static List<Lead> getLeads(String leadSearchText, Integer MaxRows){
        String searchTerm = leadSearchText + '%';
        Integer recordLimit = Integer.valueOf(MaxRows);
        List<Lead> ldList = new List<Lead>();
        if(String.isNotEmpty(searchTerm))
        	ldList = [SELECT id, Name, Industry, Phone 
                      	FROM Lead 
                      	WHERE Name LIKE :searchTerm 
                      	ORDER BY Name 
                      	LIMIT :recordLimit];
        return ldList;
	}
}