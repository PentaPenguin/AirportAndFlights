public with sharing class FlightOperations{
	
    /*
    *********************************************************
    @Method Name    : setFlightDistance
    @author         : Guillermo Moreno
    @description    : Fill the FLI_NUM_FlightDistance__c field given a list of Flight__c records in a trigger context
    @param          : List<Flight__c> newFlightList -> List of Flight__c records to update
    ********************************************************
    */
    public static void setFlightDistance(List<Flight__c> newFlightList){
        
        if(!hasRequiredPermissions()){
            System.debug('User has not the required permissions to update the Flight Distance'); // Instead of just debugging the error, I'd use a Logging framework to save it
            return;
        }
        
        Set<Id> airportsToretrieve = new Set<Id>();
        
        for(Flight__c newFlight : newFlightList){
            // Get the airports to retrieve
            airportsToretrieve.add(newFlight.FLI_LOO_DepartureAirport__c);
            airportsToretrieve.add(newFlight.FLI_LOO_ArrivalAirport__c);
        }
        
        // Retrieve the aiport records and fill the map
        Map<Id,Airport__c> flightAirports = new Map<Id,Airport__c>([SELECT Id, AIR_TXT_IATACode__c, AIR_NUM_Latitude__c, AIR_NUM_Longitude__c
                                                                    FROM Airport__c
                                                                    WHERE Id IN: airportsToretrieve]);
        
        for(Flight__c newFlight : newFlightList){
            // Update the flights with the route distance
            newFlight.FLI_NUM_FlightDistance__c = MathUtils.calculateDistance(	flightAirports.get(newFlight.FLI_LOO_DepartureAirport__c).AIR_NUM_Latitude__c,
                                                                                flightAirports.get(newFlight.FLI_LOO_DepartureAirport__c).AIR_NUM_Longitude__c,
                                                                                flightAirports.get(newFlight.FLI_LOO_ArrivalAirport__c).AIR_NUM_Latitude__c,
                                                                                flightAirports.get(newFlight.FLI_LOO_ArrivalAirport__c).AIR_NUM_Longitude__c
            																	) / 1000.0;
        }
    }
    
    /*
    *********************************************************
    @Method Name    : setFlightDistance
    @author         : Guillermo Moreno
    @description    : Aux method to enforce FLS and object permissions
    ********************************************************
    */
    private static Boolean hasRequiredPermissions(){
        // Instead of just debugging the errors, I'd use a Logging framework to save it
        if(!Schema.sObjectType.Airport__c.isAccessible()){
            System.debug('User has not the airport object');
            return false;
        }
        if(!Schema.sObjectType.Flight__c.fields.FLI_NUM_FlightDistance__c.isUpdateable()){
            System.debug('User has not the airport object');
            return false;
        }
        return true;
    }
    
}