/**
 * Created by RokasL on 5/31/2025.
 */

public with sharing class BusUpdateStatusBatch implements Database.Batchable<Id>
{
    private List<Id> busIds;

    public BusUpdateStatusBatch(List<Id> busIds)
    {
        this.busIds = busIds;
    }

    @TestVisible
    private BusUpdateStatusService oBusUpdateStatusService
    {
        get
        {
            if (oBusUpdateStatusService == null)
            {
                oBusUpdateStatusService = new BusUpdateStatusService();
            }
            return oBusUpdateStatusService;
        }
        private set;
    }

    public Iterable<Id> start(Database.BatchableContext context)
    {
        return busIds;
    }

    public void execute(Database.BatchableContext context, List<Id> records)
    {
        oBusUpdateStatusService.processBuses(records);
    }

    public void finish(Database.BatchableContext context)
    {

    }
}
