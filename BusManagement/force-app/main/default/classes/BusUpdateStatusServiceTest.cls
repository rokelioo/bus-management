/**
 * Created by RokasL on 6/1/2025.
 */

@IsTest
private class BusUpdateStatusServiceTest
{
    @IsTest
    static void test_BusUpdateStatusService()
    {
        BusUpdateStatusService service = new BusUpdateStatusService();

        Assert.isNotNull(service.oBusUpdateStatusRepository);
        service.oBusUpdateStatusRepository = null;
        Assert.isNotNull(service.oBusUpdateStatusRepository);
    }

    @IsTest
    static void test_updateBusStatus_statusFull()
    {
        Bus__c bus = (Bus__c) new sfab_FabricatedSObject(Bus__c.class)
            .set(Bus__c.Passenger_Count__c, 20)
            .toSObject();

        BusUpdateStatusService oBusUpdateStatusService = new BusUpdateStatusService();
        Test.startTest();
        List<Bus__c> result = oBusUpdateStatusService.updateBusStatus(new List<Bus__c> {bus});
        Test.stopTest();

        Assert.areEqual('Full', result.get(0).Bus_Status__c);
    }

    @IsTest
    static void test_updateBusStatus_statusAvailable()
    {
        Bus__c bus = (Bus__c) new sfab_FabricatedSObject(Bus__c.class)
            .set(Bus__c.Passenger_Count__c, 5)
            .toSObject();

        BusUpdateStatusService oBusUpdateStatusService = new BusUpdateStatusService();
        Test.startTest();
        List<Bus__c> result = oBusUpdateStatusService.updateBusStatus(new List<Bus__c> {bus});
        Test.stopTest();

        Assert.areEqual('Available', result.get(0).Bus_Status__c);
    }

    @IsTest
    static void test_updateBusStatus_statusLimitedSeats()
    {
        Bus__c bus = (Bus__c) new sfab_FabricatedSObject(Bus__c.class)
            .set(Bus__c.Passenger_Count__c, 15)
            .toSObject();

        BusUpdateStatusService oBusUpdateStatusService = new BusUpdateStatusService();
        Test.startTest();
        List<Bus__c> result = oBusUpdateStatusService.updateBusStatus(new List<Bus__c> {bus});
        Test.stopTest();

        Assert.areEqual('Limited Seats', result.get(0).Bus_Status__c);
    }

    @IsTest
    static void test_updateBusStatus_exceedsLimit_statusUnchanged()
    {
        Bus__c bus = (Bus__c) new sfab_FabricatedSObject(Bus__c.class)
            .set(Bus__c.Passenger_Count__c, 25)
            .toSObject();

        BusUpdateStatusService oBusUpdateStatusService = new BusUpdateStatusService();
        Test.startTest();
        List<Bus__c> result = oBusUpdateStatusService.updateBusStatus(new List<Bus__c> {bus});
        Test.stopTest();

        Assert.areEqual(null, result.get(0).Bus_Status__c);
    }

    @IsTest
    static void test_processBuses()
    {
        Id busId = Id.valueOf('a03WU00000PGr3CYAT');

        Bus__c bus = (Bus__c) new sfab_FabricatedSObject(Bus__c.class)
            .set(Bus__c.Id, busId)
            .set(Bus__c.Passenger_Count__c, 20)
            .toSObject();

        Bus__c busUpdated = (Bus__c) new sfab_FabricatedSObject(Bus__c.class)
            .set(Bus__c.Id, busId)
            .set(Bus__c.Passenger_Count__c, 20)
            .set(Bus__c.Bus_Status__c, 'Full')
            .toSObject();

        Amoss_Instance oBusUpdateStatusRepository = new Amoss_Instance(BusUpdateStatusRepository.class);
        oBusUpdateStatusRepository
            .expects('getBusesByIds')
            .withParameterNamed('busIds')
            .setToTheSameValueAs(new List<Id> {busId})
            .willReturn(new List<Bus__c> {bus})
            .then()
            .expects('updateBuses')
            .withParameterNamed('busList')
            .setToTheSameValueAs(new List<Bus__c> {busUpdated});

        BusUpdateStatusService oBusUpdateStatusService = new BusUpdateStatusService();
        oBusUpdateStatusService.oBusUpdateStatusRepository = (BusUpdateStatusRepository) oBusUpdateStatusRepository.generateDouble();

        Test.startTest();
        oBusUpdateStatusService.processBuses(new List<Id> {busId});
        Test.stopTest();

        oBusUpdateStatusRepository.verify();
    }

    @IsTest
    static void test_processBuses_emptyList()
    {
        Id busId = Id.valueOf('a03WU00000PGr3CYAT');

        Amoss_Instance oBusUpdateStatusRepository = new Amoss_Instance(BusUpdateStatusRepository.class);
        oBusUpdateStatusRepository
            .expects('getBusesByIds')
            .withParameterNamed('busIds')
            .setToTheSameValueAs(new List<Id> {busId})
            .willReturn(new List<Bus__c>());

        BusUpdateStatusService oBusUpdateStatusService = new BusUpdateStatusService();
        oBusUpdateStatusService.oBusUpdateStatusRepository = (BusUpdateStatusRepository) oBusUpdateStatusRepository.generateDouble();

        Test.startTest();
        oBusUpdateStatusService.processBuses(new List<Id> {busId});
        Test.stopTest();

        oBusUpdateStatusRepository.verify();
    }
}
