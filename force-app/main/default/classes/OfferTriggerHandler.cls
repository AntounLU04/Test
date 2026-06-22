public with sharing class OfferTriggerHandler extends TriggerHandler implements ITriggerHandler {
   private Map<Id, Offer__c> newMap;
    private Map<Id, Offer__c> oldMap;
    private List<Offer__c> TriggerNew;
    private List<Offer__c> TriggerOld;
    
    public OfferTriggerHandler(){
        this.newMap = (Map<Id, Offer__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Offer__c>) Trigger.oldMap;
        this.TriggerNew= (List<Offer__c>) Trigger.New;
        this.TriggerOld= (List<Offer__c>) Trigger.Old;
    }
    
    
    //Use this variable to disable this trigger from transaction
    public static Boolean TriggerDisabled = false;
    
    //check if the trigger is disabled from transaction
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
    
    public override void beforeInsert() {
       

    }
    public override void afterInsert() {
        OfferTriggerLogic.recalculateOfferIdentifiers(TriggerNew, oldMap);
        
       
    }
    public  override void beforeUpdate() {
       
        
    }
    public override void afterUpdate() {
        OfferTriggerLogic.recalculateOfferIdentifiers(TriggerNew, oldMap);
        
        
    }
    
    public override void beforeDelete() {
        
    }
    
    public override void afterDelete() {
        OfferTriggerLogic.recalculateOfferIdentifiers(TriggerNew, oldMap);
         
        
    }
    
    public override void afterUnDelete() {

        OfferTriggerLogic.recalculateOfferIdentifiers(TriggerNew, oldMap);
        
    }
}