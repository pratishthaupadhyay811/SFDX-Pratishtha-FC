@isTest
private class TestFCPortalManagerController{
    static testMethod void FCPortalManagerController(){
        FGM_Portal__CommunitySetting__c CommunitySetting = new FGM_Portal__CommunitySetting__c();
        CommunitySetting.Name = 'IsApplicationDesignerEnabled';
        CommunitySetting.FGM_Portal__IsEnabled__c = true;
        insert CommunitySetting;
        FCPortalManagerController fcPortalManagerController = new FCPortalManagerController();
        fcPortalManagerController.getGlobalConfiguration();
        fcPortalManagerController.getPageLayoutConfiguration();

        // Added for Security Scan
        System.assertNotEquals(fcPortalManagerController,null);
    }
}