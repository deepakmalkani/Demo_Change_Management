public class ContactController {
	@AuraEnabled
    // Retrieve all contacts
    public static List<Contact> getContacts() {
        // Use myNamespace__Level__c if you're using a namespace
        List<Contact> contacts =
        [SELECT Id, Name, MailingStreet, Phone, Email, Level__c FROM Contact];
        return contacts;
    }
    @AuraEnabled
    // Retrieve all primary contacts
    public static List<Contact> getPrimary() {
        // Use myNamespace__Level__c if you're using a namespace
        List<Contact> primaryContacts =
        [SELECT Id, Name, MailingStreet, Phone, Email, Level__c FROM
        Contact WHERE Level__c = 'Primary'];
        return primaryContacts;
	}
}