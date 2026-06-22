trigger ResourceReservationTrigger on Resource_Reservation__c (before insert,before update,before delete ,after insert,after update , after delete) {

    new ResourceReservationTriggerHandler().run();

}