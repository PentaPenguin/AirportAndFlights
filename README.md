# AirportAndFlights Salesforce DX Project

Deploy this project using SFDX and the provided manifest (manifest/package.xml) by setting the target org in the project you downloaded and running the following SF command:

> sf project deploy start --manifest manifest/package.xml

## Test Airport data

In order to test the application, there's a CSV containing airports records to be inserted in the target org (data/Import_Airport__c.csv).

## Permissions

The Permission Set *FlightExercisePermission* has all the required permissions needed. Just assign it to a Salesforce user to test the app.

## App

There's a SF app added named *Airports & Flights* that contains the tabs to access the Airports and Flights records used in this exercise. The tab *Flight Creation* holds the LWC with the creation utility using the IATA codes.