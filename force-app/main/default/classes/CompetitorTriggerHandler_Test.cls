@isTest
public with sharing class CompetitorTriggerHandler_Test {

    @testSetup
    static void makeData(){
        // 1. Create a Test Account
        Account acc = new Account(Name = 'Test Competitor Account');
        insert acc;

        // 2. Create a Test Opportunity
        Opportunity opp = new Opportunity(
            Name = 'Test Opp 1',
            StageName = 'Prospecting',
            CloseDate = System.today().addDays(30),
            AccountId = acc.Id
        );
        insert opp;

        // Note: Standard Quotes require a Pricebook ID. 
        // We fetch the Standard Pricebook ID to associate with our Quote.
        Id pricebookId = Test.getStandardPricebookId();

        // 3. Create a Test Quote linked to the Opportunity
        Quote q = new Quote(
            Name = 'Test Quote 1',
            OpportunityId = opp.Id,
            Pricebook2Id = pricebookId
        );
        insert q;
    }

    @isTest
    public static void testQuestion1_ValidationLogic(){
        // Fetch test data setup records
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Quote q = [SELECT Id FROM Quote LIMIT 1];

        // Create an existing competitor record for the Account/Quote link
        Competitor__c existingQuoteComp = new Competitor__c(
            Account__c = acc.Id,
            Quote__c = q.Id
        );
        insert existingQuoteComp;

        // Create an existing competitor record for the Account/Opp link
        Competitor__c existingOppComp = new Competitor__c(
            Account__c = acc.Id,
            Opportunity__c = opp.Id
        );
        insert existingOppComp;

        // Test Case A: Attempting to insert a duplicate Quote competitor should fail
        Competitor__c duplicateQuoteComp = new Competitor__c(
            Account__c = acc.Id,
            Quote__c = q.Id
        );

        Test.startTest();
        try {
            insert duplicateQuoteComp;
            System.assert(false, 'The code should have thrown a DMLException for duplicate Quote link.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('This account is already related to a quote through a competitor'), 
                'Expected validation message not received. Actual: ' + e.getMessage());
        }

        // Test Case B: Attempting to insert a duplicate Opportunity competitor should fail
        Competitor__c duplicateOppComp = new Competitor__c(
            Account__c = acc.Id,
            Opportunity__c = opp.Id
        );

        try {
            insert duplicateOppComp;
            System.assert(false, 'The code should have thrown a DMLException for duplicate Opportunity link.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('This account is already related to an opportunity through a competitor'), 
                'Expected validation message not received. Actual: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    public static void testQuestion2_AutomationLogic(){
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Quote q = [SELECT Id FROM Quote LIMIT 1];
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        // Create a competitor linked only to the Quote.
        Competitor__c newQuoteComp = new Competitor__c(
            Account__c = acc.Id,
            Quote__c = q.Id
        );

        Test.startTest();
        // This insert should trigger the automated creation method
        insert newQuoteComp;
        Test.stopTest();

        // Query the database to verify if an Opportunity competitor was created automatically
        List<Competitor__c> automatedOppComps = [
            SELECT Id, Account__c, Opportunity__c 
            FROM Competitor__c 
            WHERE Account__c = :acc.Id AND Opportunity__c = :opp.Id
        ];

        // Assertions to verify the second method successfully ran
        System.assertEquals(1, automatedOppComps.size(), 'An automated Opportunity competitor should have been generated.');
        System.assertEquals(opp.Id, automatedOppComps[0].Opportunity__c, 'The automated competitor should point to the correct related Opportunity.');
    }
}