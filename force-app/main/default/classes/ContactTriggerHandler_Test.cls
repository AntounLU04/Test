@isTest
public with sharing class ContactTriggerHandler_Test {
    @TestSetup
    static void makeData(){
        Account acc=new Account(Name='joe jhson');
        insert acc;
        List<Contact> contacts = new List<Contact>() ;
        Contact con = New Contact(AccountId= acc.Id , LastName='Smith');
        Contact con1 = New Contact(AccountId= acc.Id , FirstName='Jo' , LastName='johns');
        Contact con2 = New Contact(AccountId= acc.Id , LastName='Johns');
        contacts.add(con);
        contacts.add(con1);
        contacts.add(con2);
        insert contacts;
        
    }
    @isTest
    public Static void testCountContact() {
         Account acc = [SELECT Smith_Count__c FROM Account LIMIT 1 ];
         Assert.areEqual(2, acc.Smith_Count__c);


        

    }
}