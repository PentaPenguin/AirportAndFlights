public with sharing class FlightTriggerHandler{

    /*
    *********************************************************
    @Method Name    : beforeInsert
    @author         : Guillermo Moreno
    @description    : Handler of the before insert context in the FlightTrigger trigger
    @param          : List<Flight__c> newFlightList -> List of Flight__c records to be inserted
    ********************************************************
    */
    public void beforeInsert(List<Flight__c> newFlightList){
        
        // Operations
        FlightOperations.setFlightDistance(newFlightList);
    }
    
    /*
    *********************************************************
    @Method Name    : beforeUpdate
    @author         : Guillermo Moreno
    @description    : Handler of the before insert context in the FlightTrigger trigger
    @param          : 	List<Flight__c> oldFlightList -> List of the old Flight__c records to be updated
    					Map<Id,Flight__c> newFlightMap -> Map of the Id Flight__c records to be updated to the new records
    ********************************************************
    */
    public void beforeUpdate(List<Flight__c> oldFlightList, Map<Id,Flight__c> newFlightMap){
        List<Flight__c> flightsToUpdate = new List<Flight__c>();
        
        Flight__c newFlight;
        for(Flight__c oldFlight : oldFlightList){
            newFlight = newFlightMap.get(oldFlight.Id);
            
            // Set the new distance if either of the airports are changed
            if(
                oldFlight.FLI_LOO_DepartureAirport__c != newFlight.FLI_LOO_DepartureAirport__c ||
            	oldFlight.FLI_LOO_ArrivalAirport__c != newFlight.FLI_LOO_ArrivalAirport__c){
                	flightsToUpdate.add(newFlight);
            }
            
        }
        
        // Operations
        FlightOperations.setFlightDistance(flightsToUpdate);
    }
    
}