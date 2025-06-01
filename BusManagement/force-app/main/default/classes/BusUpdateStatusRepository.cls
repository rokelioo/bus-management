/**
 * Created by RokasL on 5/31/2025.
 */

public with sharing class BusUpdateStatusRepository
{
    public List<Bus__c> getBusesByIds(List<Id> busIds)
    {
        return [
            SELECT
                Id,
                Bus_Status__c,
                Passenger_Count__c
            FROM
                Bus__c
            WHERE
                Id IN :busIds
        ];
    }

    public void updateBuses(List<Bus__c> busList)
    {
        update busList;
    }
}
