public with sharing class AccountHandler {

    Public static Boolean runTrigger = True; 

    public static void afterInsert(Map<Id,Account> accountMap ) {
        if(!runTrigger) return;
        runTrigger = false;

        System.debug('Hello Worl');
        List<Contact> contactsToInsert = new List<Contact>();
        for(Account acc : accountMap.values()){
            Contact con = new Contact(
                lastName = 'Test Contact',
                AccountId = acc.Id
                 );

                 contactsToInsert.add(con);

         }

         if(!contactsToInsert.isEmpty()) Insert contactsToInsert;
    }
}