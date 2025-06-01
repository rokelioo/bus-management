/**
 * Created by RokasL on 5/31/2025.
 */

public with sharing class BusUpdateStatusService
{
    private static final String BUS_STATUS_FULL = 'Full';
    private static final String BUS_STATUS_AVAILABLE = 'Available';
    private static final String BUS_STATUS_LIMITED_SEATS = 'Limited Seats';
    private static final String BUS_SEATS_EXCEEDED = 'The number of passengers exceeds the bus seat limit';

    @TestVisible
    private BusUpdateStatusRepository oBusUpdateStatusRepository
    {
        get
        {
            if (oBusUpdateStatusRepository == null)
            {
                oBusUpdateStatusRepository = new BusUpdateStatusRepository();
            }
            return oBusUpdateStatusRepository;
        }
        private set;
    }

    public void processBuses(List<Id> busIds)
    {
        List<Bus__c> busList = oBusUpdateStatusRepository.getBusesByIds(busIds);

        if (busList.isEmpty())
        {
            return;
        }

        List<Bus__c> busesToUpdate = updateBusStatus(busList);

        if (!busesToUpdate.isEmpty())
        {
            oBusUpdateStatusRepository.updateBuses(busesToUpdate);
        }
    }

    /**
     * @param busList List of `Bus__c` records to evaluate and update.
     *
     * @return The same list, with **Bus_Status__c** values potentially
     * modified to reflect current capacity.
     *
     * @throws SeatLimitException when `Passenger_Count__c` exceeds the maximum seat limit (> 20).
     */
    @TestVisible
    private List<Bus__c> updateBusStatus(List<Bus__c> busList)
    {
        for (Bus__c bus : busList)
        {
            try
            {
                if (bus.Passenger_Count__c == 20)
                {
                    bus.Bus_Status__c = BUS_STATUS_FULL;
                }
                else if (bus.Passenger_Count__c > 20)
                {
                    throw new SeatLimitException(BUS_SEATS_EXCEEDED);
                }
                else if (bus.Passenger_Count__c < 10)
                {
                    bus.Bus_Status__c = BUS_STATUS_AVAILABLE;
                }
                else if (bus.Passenger_Count__c > 10)
                {
                    bus.Bus_Status__c = BUS_STATUS_LIMITED_SEATS;
                }
            }
            catch (Exception e)
            {
                System.debug('Error updating bus status: ' + e.getMessage());
            }
        }

        return busList;
    }

    public class SeatLimitException extends Exception
    {
    }
}
