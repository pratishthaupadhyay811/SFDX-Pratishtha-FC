@isTest
private class TestOnAccountDelete {

    private static testMethod void onAccountDeleteTest(){
        test.startTest();
        Account objAccount = NEW Account();
        objAccount.Name = 'TestAccount';
        insert objAccount;
        FGM_Portal__Portal_Account__c objPortalAccount = NEW FGM_Portal__Portal_Account__c();
        objPortalAccount.FGM_Portal__Account__c = objAccount.Id;
        insert objPortalAccount;
        system.assertNotEquals(objPortalAccount.Id, NULL);

        FGM_Portal__Portal_Permission__c objPortalPermission = NEW FGM_Portal__Portal_Permission__c();
        objPortalPermission.FGM_Portal__Portal_Account__c = objPortalAccount.Id;
        insert objPortalPermission;
        system.assertNotEquals(objPortalPermission.Id, NULL);

        delete objAccount;
        test.stopTest();
    }
}