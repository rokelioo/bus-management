/**
 * Created by RokasL on 6/1/2025.
 */
@IsTest
public with sharing class BusUpdateStatusBatchTest
{
    @IsTest
    static void testStart()
    {
        Test.startTest();
        BusUpdateStatusBatch batch = new BusUpdateStatusBatch(new List<Id>());
        batch.start(null);
        Test.stopTest();
    }

    @IsTest
    static void testExecute()
    {
        Id busId = Id.valueOf('a03WU00000PGr3CYAT');
        List<Id> busIds = new List<Id> {busId};

        BusUpdateStatusBatch batch = new BusUpdateStatusBatch(busIds);

        Amoss_Instance busUpdateStatusService = new Amoss_Instance(BusUpdateStatusService.class);
        busUpdateStatusService
            .expects('processBuses')
            .withParameterNamed('busIds')
            .setTo(busIds);

        batch.oBusUpdateStatusService = (BusUpdateStatusService) busUpdateStatusService.getDouble();

        Test.startTest();
        batch.execute(null, busIds);
        Test.stopTest();

        busUpdateStatusService.verify();
    }

    @IsTest
    static void testFinish()
    {
        Id busId = Id.valueOf('a03WU00000PGr3CYAT');
        List<Id> busIds = new List<Id> {busId};
        BusUpdateStatusBatch batch = new BusUpdateStatusBatch(busIds);

        Test.startTest();
        batch.finish(null);
        Test.stopTest();

        List<AsyncApexJob> asyncApexJobs = [SELECT Id FROM AsyncApexJob];
        Assert.areEqual(0, asyncApexJobs.size());
    }

    @IsTest
    static void test_BusUpdateStatusBatch()
    {
        BusUpdateStatusBatch service = new BusUpdateStatusBatch(new List<Id>());

        Assert.isNotNull(service.oBusUpdateStatusService);
        service.oBusUpdateStatusService = null;
        Assert.isNotNull(service.oBusUpdateStatusService);
    }
}
