@isTest
public class TestingUtils {
    
     public static List<Contact> createContacts( Integer numOfContacts, Id accountId, Boolean doInsert ){
        List<Contact> contactList = new List<Contact>();
        for( Integer index = 0; index < numOfContacts; index++ ){
            Contact contact = new Contact();
            contact.LastName = 'TestLast' + index;
            contact.AccountId = accountId;
            contact.Email = 'test' + index + '@test.com';
            contactList.add( contact );
        }

        if( doInsert ){
            insert contactList;
        }

        return contactList;
    }


}