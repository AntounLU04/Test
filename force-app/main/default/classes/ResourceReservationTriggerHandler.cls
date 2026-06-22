public with sharing class ResourceReservationTriggerHandler extends TriggerHandler implements ITriggerHandler{

    private Map<Id, Resource_Reservation__c> newMap;
    private Map<Id, Resource_Reservation__c> oldMap;
    private List<Resource_Reservation__c> TriggerNew;
    private List<Resource_Reservation__c> TriggerOld;
    
    public ResourceReservationTriggerHandler(){
        this.newMap = (Map<Id, Resource_Reservation__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Resource_Reservation__c>) Trigger.oldMap;
        this.TriggerNew= (List<Resource_Reservation__c>) Trigger.New;
        this.TriggerOld= (List<Resource_Reservation__c>) Trigger.Old;
    }
    
    
    //Use this variable to disable this trigger from transaction
    public static Boolean TriggerDisabled = false;
    
    //check if the trigger is disabled from transaction
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
    
    public override void beforeInsert() {
        ResourceReservationTriggerLogic.CheckReservation(TriggerNew, oldMap);
        

    }
    public override void afterInsert() {
        
       
    }
    public  override void beforeUpdate() {
        ResourceReservationTriggerLogic.CheckReservation(TriggerNew, oldMap);
        
        
    }
    public override void afterUpdate() {
        
        
    }
    
    public override void beforeDelete() {
        ResourceReservationTriggerLogic.CheckReservation(TriggerNew, oldMap);
        
    }
    
    public override void afterDelete() {
         
        
    }
    
    public override void afterUnDelete() {
        
    }
}