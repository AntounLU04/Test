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


    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountListRating(String filter) {
        if (String.isBlank(filter) || filter == 'All') {
            return [SELECT Id, Name, Industry, Phone, Rating FROM Account  LIMIT 10];
        }
        return [SELECT Id, Name, Industry, Phone, Rating FROM Account WHERE Rating = :filter  LIMIT 10];
    }
}
