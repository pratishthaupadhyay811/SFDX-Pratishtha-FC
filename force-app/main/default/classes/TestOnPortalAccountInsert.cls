@isTest
private class TestOnPortalAccountInsert {

    public static testmethod void TestCreateAccount()
    {
        test.startTest();
        FGM_Portal__Portal_Account__c fgmAcc1 = new FGM_Portal__Portal_Account__c(Name = 'Test1');
        FGM_Portal__Portal_Account__c fgmAcc2 = new FGM_Portal__Portal_Account__c(Name = 'Test2');
        insert new list<FGM_Portal__Portal_Account__c> { fgmAcc1, fgmAcc2};
        System.assertNotEquals(fgmAcc1.id, null);
        System.assertNotEquals(fgmAcc2.id, null);
        test.stopTest();
    }
}