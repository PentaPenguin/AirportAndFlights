trigger FlightTrigger on Flight__c (before insert, before update){
    FlightTriggerHandler triggerHandler = new FlightTriggerHandler();
    
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            triggerHandler.beforeInsert(Trigger.new);
        }
        when BEFORE_UPDATE {
            triggerHandler.beforeUpdate(Trigger.old, Trigger.newMap);
        }
    }
}