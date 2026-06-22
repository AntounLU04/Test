public with sharing class ResourceReservationTriggerLogic {
    public Static Void CheckReservation(List<Resource_Reservation__c> newList, Map<Id,Resource_Reservation__c> oldMap) {
        Set<String> Resources = new Set<String>();
        Datetime MinStartDate;
        Datetime MaxEndDate;

        for(Resource_Reservation__c res : newList){

             if(oldMap == null || oldMap.get(res.Id).Reserved_Resource__c != res.Reserved_Resource__c || oldMap.get(res.Id).Start_date_of_use__c != res.Start_date_of_use__c || oldMap.get(res.Id).End_date_of_use__c != res.End_date_of_use__c){

                if(MinStartDate == Null || MinStartDate > res.Start_date_of_use__c ){

                    MinStartDate = res.Start_date_of_use__c;
                    
                }

                if(MaxEndDate == Null || MaxEndDate < res.End_date_of_use__c){
                    MaxEndDate=res.End_date_of_use__c;
                }
            
                Resources.add(res.Reserved_Resource__c);

                
             }
            }

             // 1. Query the reservations that match your criteria
            List<Resource_Reservation__c> reservations = [
            SELECT Reserved_Resource__c, Start_date_of_use__c, End_date_of_use__c 
            FROM Resource_Reservation__c 
            WHERE Reserved_Resource__c IN :Resources 
            AND Start_date_of_use__c <= :MaxEndDate 
            AND End_date_of_use__c >= :MinStartDate
                ];

// 2. Initialize the Map
        Map<String, List<Resource_Reservation__c>> ResourceToReservations = new Map<String, List<Resource_Reservation__c>>();

// 3. Loop through records to group them by the Resource Id/String
        // for (Resource_Reservation__c res : reservations) {
        //     if (!ResourceToReservations.containsKey(res.Reserved_Resource__c)) {
        //         ResourceToReservations.put(res.Reserved_Resource__c, new List<Resource_Reservation__c>());
        //             }
        // ResourceToReservations.get(res.Reserved_Resource__c).add(res);
        // }
        for(Resource_Reservation__c res : newList){
                for(Resource_Reservation__c existing:reservations){
                    if(res.Reserved_Resource__c == existing.Reserved_Resource__c){
                        if((res.Start_date_of_use__c < existing.End_date_of_use__c && res.Start_date_of_use__c > existing.Start_date_of_use__c) ||( res.End_date_of_use__c > existing.End_date_of_use__c && res.End_date_of_use__c < existing.End_date_of_use__c)){
                            res.addError('resource is taken');
                        }
                            else {
                              continue; 

                            
            
                  }
                          
                     
                                
                                
                            }
                        }
                    }
                }

             }
            
                  

       
    