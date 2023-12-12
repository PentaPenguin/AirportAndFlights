import { LightningElement, wire } from "lwc";
import getAirportCodesMap from "@salesforce/apex/FlightCreationController.getAirportCodesMap";
import insertFlightRecord from "@salesforce/apex/FlightCreationController.insertFlightRecord";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class FlightCreation extends LightningElement {
    departureId;
    arrivalId;
    airportOptions;
    wireError;
    createdRecord;

    @wire(getAirportCodesMap)
    wiredAirportCodes({error, data}){
        if(data){
            this.airportOptions = data;
            this.departureId = data[0]?.value;
            this.arrivalId = data[0]?.value;
            this.wireError = undefined;
        }else if(error){
            this.wireError = error.body.message;
            this.airportOptions = undefined;
        }
    }

    handleDepartureChange(event) {
        this.departureId = event.detail.value;
    }

    handleArrivalChange(event) {
        this.arrivalId = event.detail.value;
    }

    handleCreateFlight(event) {
        insertFlightRecord({ departureAirportId: this.departureId, arrivalAirportId: this.arrivalId })
        .then((result) => {
            this.createdRecord = result;
            console.log(this.createdRecord);
            this.showToast( "Success!",
                            "success",
                            "Flight record {0} from {1} to {2} with a route distance of {3} km was created successfully",
                            [
                                {
                                    url: '/' + this.createdRecord.Id,
                                    label: this.createdRecord.Name
                                },
                                this.createdRecord.FLI_LOO_DepartureAirport__r.AIR_TXT_IATACode__c,
                                this.createdRecord.FLI_LOO_ArrivalAirport__r.AIR_TXT_IATACode__c,
                                this.createdRecord.FLI_NUM_FlightDistance__c
                            ]

            );
        })
        .catch((error) => {
            this.showToast( "Error creating the flight record",
                            "error",
                            error.body.message,
                            undefined

            );
        });
    }

    showToast(title, variant, message, messageData){
        const toastEvent = new ShowToastEvent({
            "title": title,
            "message": message,
            "variant": variant,
            "messageData": messageData
        });

        this.dispatchEvent(toastEvent);
    }
}