public with sharing class OfferTriggerLogic {
    
    public static void recalculateOfferIdentifiers(List<Offer__c> newList, Map<Id, Offer__c> oldMap) {
        // Map to collect the unique affected Opportunity IDs
        Map<Id, Id> affectedOpportunityIdsMap = new Map<Id, Id>();
        
        // 1. Collect IDs when records are created, updated, or undeleted
        if (newList != null) {
            for (Offer__c offer : newList) {
                // Fresh insert/undelete or the parent Opportunity look-up was changed (Reparented)
                if (oldMap == null || oldMap.get(offer.Id).Opportunity__c != offer.Opportunity__c) {
                    
                    if (offer.Opportunity__c != null) {
                        affectedOpportunityIdsMap.put(offer.Opportunity__c, offer.Opportunity__c);
                    }
                    
                    // If it was reparented, we must also recalculate the old parent to fill the gap
                    if (oldMap != null && oldMap.get(offer.Id).Opportunity__c != null) {
                        Id oldOppId = oldMap.get(offer.Id).Opportunity__c;
                        affectedOpportunityIdsMap.put(oldOppId, oldOppId);
                    }
                }
            }
        } 
        // 2. Collect IDs when records are deleted (newList is null)
        else if (oldMap != null) {
            for (Offer__c oldOffer : oldMap.values()) {
                if (oldOffer.Opportunity__c != null) {
                    affectedOpportunityIdsMap.put(oldOffer.Opportunity__c, oldOffer.Opportunity__c);
                }
            }
        }
        
        // 3. Re-index processing if any Opportunities were impacted
        if (!affectedOpportunityIdsMap.isEmpty()) {
            
            // Map Opportunity IDs to their actual records to grab the 'Identifier__c'
            Map<Id, Opportunity> parentOpportunityMap = new Map<Id, Opportunity>(
                [SELECT Id, Identifier__c FROM Opportunity WHERE Id IN :affectedOpportunityIdsMap.keySet()]
            );
            
            // Map tracking the running incremental integer sequence counter per Opportunity ID
            Map<Id, Integer> oppToCounterMap = new Map<Id, Integer>();
            List<Offer__c> offersToUpdate = new List<Offer__c>();
            
            // Query ALL sibling offers sorted by creation date so the indexing order remains stable
            for (Offer__c siblingOffer : [SELECT Id, Opportunity__c, Identifier__c 
                                          FROM Offer__c 
                                          WHERE Opportunity__c IN :affectedOpportunityIdsMap.keySet() 
                                          ORDER BY CreatedDate ASC, Id ASC]) {
                
                Opportunity parentOpp = parentOpportunityMap.get(siblingOffer.Opportunity__c);
                
                if (parentOpp != null) {
                    String expectedIdentifier = null;

                    // If the parent opportunity has a valid identifier, calculate the incremented value
                    if (String.isNotBlank(parentOpp.Identifier__c)) {
                        // Initialize the counter for this map key if it doesn't exist yet
                        if (!oppToCounterMap.containsKey(siblingOffer.Opportunity__c)) {
                            oppToCounterMap.put(siblingOffer.Opportunity__c, 0);
                        }
                        
                        Integer currentCounter = oppToCounterMap.get(siblingOffer.Opportunity__c);
                        expectedIdentifier = parentOpp.Identifier__c + '-' + String.valueOf(currentCounter).leftPad(3, '0');
                        
                        // Increment map entry counter for the next loop iteration of this Opportunity
                        oppToCounterMap.put(siblingOffer.Opportunity__c, currentCounter + 1);
                    }
                    // NEW LOGIC: If parent Opportunity has NO identifier, expectedIdentifier stays null

                    // Only modify memory and queue for update DML if the code sequence actually changed
                    if (siblingOffer.Identifier__c != expectedIdentifier) {
                        siblingOffer.Identifier__c = expectedIdentifier;
                        offersToUpdate.add(siblingOffer);
                    }
                }
            }
            
            // Fire the update DML safely with allOrNone = false
            if (!offersToUpdate.isEmpty()) {
                Database.update(offersToUpdate, false);
            }
        }
    }
}