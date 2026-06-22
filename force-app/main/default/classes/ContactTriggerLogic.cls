public with sharing class ContactTriggerLogic {

    public static void countContactOccurences(List<Contact> contacts, Map<Id, Contact> oldMap) {

        Set<Id> accountIds = new Set<Id>();
        for (Contact c : contacts) {
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
        }

        List<Contact> matchingContacts = [SELECT AccountId, FirstName, LastName 
                                           FROM Contact 
                                           WHERE AccountId IN :accountIds 
                                           AND (LastName = 'Smith' OR FirstName = null)];

        Map<Id, Integer> counts = new Map<Id, Integer>();

        for (Contact c : matchingContacts) {
            if (counts.containsKey(c.AccountId)) {
                Integer current = counts.get(c.AccountId);
                counts.put(c.AccountId, current + 1);
            } else {
                counts.put(c.AccountId, 1);
            }
        }

        List<Account> accountsToUpdate = new List<Account>();

        for (Id accId : accountIds) {
            Integer countVal = counts.containsKey(accId) ? counts.get(accId) : 0;
            accountsToUpdate.add(new Account(Id = accId, Smith_Count__c = countVal));
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}