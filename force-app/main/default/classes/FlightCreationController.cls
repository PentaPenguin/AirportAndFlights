public with sharing class FlightCreationController{
    
    /*
    *********************************************************
    @Method Name    : getAirportCodesMap
    @author         : Guillermo Moreno
    @description    : Gets the Airport__c records and map it to list of ComboWrapper records to be shown in the LWC
    ********************************************************
    */
	@AuraEnabled(cacheable=true)
    public static List<ComboWrapper> getAirportCodesMap(){
        List<ComboWrapper> airportCodesWrapperList = new List<ComboWrapper>();
        
        // Add the values to the return List
        for(Airport__c airport : [SELECT Id, AIR_TXT_IATACode__c
                                        FROM Airport__c
                                        ORDER BY AIR_TXT_IATACode__c ASC
                                       ]){
            airportCodesWrapperList.add(
                new ComboWrapper(airport.AIR_TXT_IATACode__c, airport.Id)
            );
        }
        
        return airportCodesWrapperList;
    }
    
    /*
    *********************************************************
    @Method Name    : insertFlightRecord
    @author         : Guillermo Moreno
    @description    : Inserts and returns the flight record with the given values
    @param          : 	Id departureAirportId -> Id of the Departure aiport to be mapped to the field FLI_LOO_DepartureAirport__c
    					Id arrivalAirportId -> Id of the Arrival aiport to be mapped to the field FLI_LOO_ArrivalAirport__c
    ********************************************************
    */
    @AuraEnabled
    public static Flight__c insertFlightRecord(Id departureAirportId, Id arrivalAirportId){
        
        Flight__c newFlight = new Flight__c(
        	FLI_LOO_DepartureAirport__c = departureAirportId,
            FLI_LOO_ArrivalAirport__c = arrivalAirportId
        );
        
        insert newFlight;
        
        newFlight = [SELECT Id, Name, FLI_LOO_DepartureAirport__r.AIR_TXT_IATACode__c, FLI_LOO_ArrivalAirport__r.AIR_TXT_IATACode__c, FLI_NUM_FlightDistance__c FROM Flight__c WHERE Id =: newFlight.Id LIMIT 1];
        
        return newFlight;
    }
    
    // Wrapper to replicate the JS object used by the LWC combobox component
    class ComboWrapper{
        @AuraEnabled
        public String label{ get; set; }
        
        @AuraEnabled
        public String value{ get; set; }
        
        public ComboWrapper(String label, String value){
            this.label = label;
            this.value = value;
        }
        
    }
    
}