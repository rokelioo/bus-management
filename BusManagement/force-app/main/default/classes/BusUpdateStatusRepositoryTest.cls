/**
 * Created by RokasL on 6/1/2025.
 */

@IsTest
private class BusUpdateStatusRepositoryTest
{
    @IsTest
    static void test_getBusesByIds()
    {
        BusUpdateStatusRepository oBusUpdateStatusRepository = new BusUpdateStatusRepository();
        Test.startTest();
        List<Bus__c> busList = oBusUpdateStatusRepository.getBusesByIds(new List<Id>());
        Test.stopTest();
    }

    @IsTest
    static void test_updateBuses()
    {
        BusUpdateStatusRepository oBusUpdateStatusRepository = new BusUpdateStatusRepository();
        Test.startTest();
        oBusUpdateStatusRepository.updateBuses(new List<Bus__c>());
        Test.stopTest();
    }

}
