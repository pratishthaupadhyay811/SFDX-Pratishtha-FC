@isTest
public class ProcessRelatedListRecordsTest
{
    public static testMethod void callTrigger()
    {
        List<FGM_Portal__Related_List_Controller__c> lsRlc = [ SELECT Id FROM FGM_Portal__Related_List_Controller__c LIMIT 1 ];
        delete lsRlc[0];
    }

    @testsetup
    public static void createTestData()
    {
        FGM_Portal__Related_List_Controller__c objRLC = new FGM_Portal__Related_List_Controller__c();
        objRLC.FGM_Portal__LookupField__c = 'OpportunityId';
        objRLC.FGM_Portal__ObjectName__c = 'Opportunity';
        insert objRLC;
    }
}