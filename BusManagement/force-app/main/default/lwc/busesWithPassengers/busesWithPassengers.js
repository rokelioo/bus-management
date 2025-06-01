/**
 * Created by RokasL on 5/31/2025.
 */

import {LightningElement, api, wire} from 'lwc';
import {getRelatedListRecords} from 'lightning/uiRelatedListApi';

const COLUMNS = [
    { label: 'Bus Name', fieldName: 'name', type: 'text'},
    { label: 'Passengers', fieldName: 'passengerCount', type: 'number'}
];

export default class BusesWithPassengers extends LightningElement {
    @api recordId;
    columns = COLUMNS;
    buses = [];
    error;

    @wire(getRelatedListRecords, {
        parentRecordId: '$recordId',
        relatedListId: 'Buses__r',
        fields: ['Bus__c.Name', 'Bus__c.Passenger_Count__c'],
        sortBy: ['Bus__c.Name']
    })
    wiredBuses({error, data}) {
        if (data) {
            this.buses = data.records.map(record => ({
                id: record.id,
                name: record.fields.Name.value,
                passengerCount: record.fields.Passenger_Count__c.value
            }));
            this.error = undefined;
        } else if (error) {
            console.error('Error loading buses:', error);
            this.error = error;
            this.buses = [];
        }
    }
}
