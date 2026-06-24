public with sharing class AccountController {
    
    
    public static String createNewAccount(String accountName) {
        Account acc = new Account(Name = accountName);
        insert acc;
        return acc.Id;
    }

    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList(Integer recordLimit) {
        return [
            SELECT Id, Name, AnnualRevenue 
            FROM Account 
            LIMIT :recordLimit
        ];
    }
}