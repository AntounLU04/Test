@isTest
private class OfferTriggerHandler_Test {

    private static Opportunity createOpportunity(String identifier) {
        Opportunity opp = new Opportunity(
            Name = 'Opp ' + identifier,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Identifier__c = identifier
        );
        insert opp;
        return opp;
    }

    private static Offer__c createOffer(Id oppId) {
        Offer__c o = new Offer__c(Opportunity__c = oppId);
        insert o;
        return o;
    }

    // -----------------------------------------------------------------------
    // TEST 1: A single inserted Offer gets sequence 000
    // -----------------------------------------------------------------------
    @isTest
    static void testSingleInsertAssignsZero() {
        Opportunity opp = createOpportunity('ABC');
        Offer__c offer = createOffer(opp.Id);

        OfferTriggerLogic.recalculateOfferIdentifiers(new List<Offer__c>{ offer }, null);

        Offer__c result = [SELECT Identifier__c FROM Offer__c WHERE Id = :offer.Id];
        System.assertEquals('ABC-000', result.Identifier__c, 'First offer should be ABC-000.');
    }

    // -----------------------------------------------------------------------
    // TEST 2: Multiple Offers on the same Opportunity sequence in creation order
    // -----------------------------------------------------------------------
    @isTest
    static void testMultipleOffersSequenceInCreationOrder() {
        Opportunity opp = createOpportunity('SEQ');

        Offer__c o1 = createOffer(opp.Id);
        Offer__c o2 = createOffer(opp.Id);
        Offer__c o3 = createOffer(opp.Id);

        OfferTriggerLogic.recalculateOfferIdentifiers(new List<Offer__c>{ o3 }, null);

        List<Offer__c> results = [SELECT Id, Identifier__c FROM Offer__c WHERE Opportunity__c = :opp.Id ORDER BY CreatedDate ASC, Id ASC];
        System.assertEquals(3, results.size());
        System.assertEquals('SEQ-000', results[0].Identifier__c);
        System.assertEquals('SEQ-001', results[1].Identifier__c);
        System.assertEquals('SEQ-002', results[2].Identifier__c);
    }

    // -----------------------------------------------------------------------
    // TEST 3: Deleting an Offer in the middle re-indexes the remaining
    // siblings, closing the gap left behind
    // -----------------------------------------------------------------------
    @isTest
    static void testDeleteReindexesRemainingSiblings() {
        Opportunity opp = createOpportunity('GAP');

        Offer__c o1 = createOffer(opp.Id);
        Offer__c o2 = createOffer(opp.Id);
        Offer__c o3 = createOffer(opp.Id);

        OfferTriggerLogic.recalculateOfferIdentifiers(new List<Offer__c>{ o1, o2, o3 }, null);

        List<Offer__c> before = [SELECT Id, Identifier__c FROM Offer__c WHERE Opportunity__c = :opp.Id ORDER BY CreatedDate ASC, Id ASC];
        System.assertEquals('GAP-000', before[0].Identifier__c);
        System.assertEquals('GAP-001', before[1].Identifier__c);
        System.assertEquals('GAP-002', before[2].Identifier__c);

        Map<Id, Offer__c> oldMapForDelete = new Map<Id, Offer__c>{ o2.Id => o2 };
        delete o2;

        OfferTriggerLogic.recalculateOfferIdentifiers(null, oldMapForDelete);

        List<Offer__c> afterDeleteResults = [SELECT Id, Identifier__c FROM Offer__c WHERE Opportunity__c = :opp.Id ORDER BY CreatedDate ASC, Id ASC];
        System.assertEquals(2, afterDeleteResults.size());
        System.assertEquals('GAP-000', afterDeleteResults[0].Identifier__c, 'First remaining offer keeps 000.');
        System.assertEquals('GAP-001', afterDeleteResults[1].Identifier__c, 'Third offer shifts down to fill the gap left by the deleted one.');
    }

    // -----------------------------------------------------------------------
    // TEST 4: Reparenting an Offer recalculates BOTH the old and new
    // Opportunity's sequences
    // -----------------------------------------------------------------------
    @isTest
    static void testReparentingRecalculatesBothOpportunities() {
        Opportunity oppOld = createOpportunity('OLD');
        Opportunity oppNew = createOpportunity('NEW');

        Offer__c o1 = createOffer(oppOld.Id);
        Offer__c o2 = createOffer(oppOld.Id);
        Offer__c n1 = createOffer(oppNew.Id);

        OfferTriggerLogic.recalculateOfferIdentifiers(new List<Offer__c>{ o1, o2, n1 }, null);

        Map<Id, Offer__c> oldMapForUpdate = new Map<Id, Offer__c>{
            o2.Id => new Offer__c(Id = o2.Id, Opportunity__c = oppOld.Id)
        };

        o2.Opportunity__c = oppNew.Id;
        update o2;

        OfferTriggerLogic.recalculateOfferIdentifiers(new List<Offer__c>{ o2 }, oldMapForUpdate);

        // Old Opportunity's gap should be filled — only o1 remains, becomes OLD-000
        List<Offer__c> oldResults = [SELECT Identifier__c FROM Offer__c WHERE Opportunity__c = :oppOld.Id ORDER BY CreatedDate ASC, Id ASC];
        System.assertEquals(1, oldResults.size());
        System.assertEquals('OLD-000', oldResults[0].Identifier__c);

        // New Opportunity now has 2 offers, ordered by CreatedDate (n1 was created first)
        List<Offer__c> newResults = [SELECT Id, Identifier__c FROM Offer__c WHERE Opportunity__c = :oppNew.Id ORDER BY CreatedDate ASC, Id ASC];
        System.assertEquals(2, newResults.size());
        System.assertEquals('NEW-000', newResults[0].Identifier__c);
        System.assertEquals('NEW-001', newResults[1].Identifier__c);
    }

    // -----------------------------------------------------------------------
    // TEST 5: Bulk recalculation across multiple distinct Opportunities at once
    // -----------------------------------------------------------------------
    @isTest
    static void testBulkRecalculationAcrossMultipleOpportunities() {
        Opportunity opp1 = createOpportunity('AAA');
        Opportunity opp2 = createOpportunity('BBB');

        List<Offer__c> allOffers = new List<Offer__c>();
        for (Integer i = 0; i < 3; i++) allOffers.add(new Offer__c(Opportunity__c = opp1.Id));
        for (Integer i = 0; i < 3; i++) allOffers.add(new Offer__c(Opportunity__c = opp2.Id));
        insert allOffers;

        Test.startTest();
        OfferTriggerLogic.recalculateOfferIdentifiers(allOffers, null);
        Test.stopTest();

        List<Offer__c> opp1Results = [SELECT Identifier__c FROM Offer__c WHERE Opportunity__c = :opp1.Id ORDER BY CreatedDate ASC, Id ASC];
        List<Offer__c> opp2Results = [SELECT Identifier__c FROM Offer__c WHERE Opportunity__c = :opp2.Id ORDER BY CreatedDate ASC, Id ASC];

        System.assertEquals('AAA-000', opp1Results[0].Identifier__c);
        System.assertEquals('AAA-002', opp1Results[2].Identifier__c);
        System.assertEquals('BBB-000', opp2Results[0].Identifier__c);
        System.assertEquals('BBB-002', opp2Results[2].Identifier__c);
    }
}