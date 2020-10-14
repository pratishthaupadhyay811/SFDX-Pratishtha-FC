@isTest
public with sharing class Test_CommunitySettingsController {
    static testMethod void test_UpsertRecord(){
    FGM_Portal__CommunityConfiguration__c communityConfiguration = new FGM_Portal__CommunityConfiguration__c();
        communityConfiguration.FGM_Portal__JsonData__c = '{}';
        communityConfiguration.FGM_Portal__ConfiguationName__c = 'CommunitySettings';
        FCGlobal.Error error = (FCGlobal.Error)PortalUserFieldMappingController.UpsertRecord( new list<FGM_Portal__CommunityConfiguration__c>{communityConfiguration});
        System.assertNotEquals(error,null);
        System.assert(error.IsSuccess);
        System.assertNotEquals(error.data,null);
        System.assertNotEquals(communityConfiguration.Id,null);

    }
}