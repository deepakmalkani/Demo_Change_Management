@isTest
public class TestContactController {
	static testMethod void test() {
        
        Contact c = new Contact(firstname='first', lastname='last', Level__c='Primary');
        insert c;
        List<Contact> contacts = ContactController.getContacts();
        List<Contact> primary = ContactController.getPrimary();
        System.assertEquals('first last', contacts[0].name, 'Name does not match');           
        System.assertEquals(1, primary.size(), 'Wrong number of primary contacts');
            
    }
}