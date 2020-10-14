@isTest
public with sharing class TestCommunityUserFieldMappingController {
    static testMethod void test_GetObjectFields(){
        String sObjectName = 'invalidTestObjectName';
        FCGlobal.Error error = (FCGlobal.Error)CommunityUserFieldMappingController.GetObjectFields(sObjectName, new List<String>(),new List<String>(),false);
        System.assertEquals(error.IsSuccess,false);
        System.assertEquals(error.data,null);
        sObjectName = '';
        error = (FCGlobal.Error)CommunityUserFieldMappingController.GetObjectFields(sObjectName, new List<String>(),new List<String>(),false);
        System.assertEquals(error.IsSuccess,false);
        System.assertEquals(error.data,null);

        sObjectName = 'Contact';
        error = (FCGlobal.Error)CommunityUserFieldMappingController.GetObjectFields(sObjectName, new List<String>(),new List<String>(),false);
        System.assert(error.IsSuccess);
        System.assertNotEquals(error.data,null);

        error = (FCGlobal.Error)CommunityUserFieldMappingController.GetObjectFields(sObjectName, new List<String>(),new List<String>(),true);
        System.assert(error.IsSuccess);
        System.assertNotEquals(error.data,null);

    }
    static testMethod void test_UpsertRecord(){
        FGM_Portal__CommunityConfiguration__c communityConfiguration = new FGM_Portal__CommunityConfiguration__c();
        communityConfiguration.FGM_Portal__JsonData__c = '{"CommunityUserToContact":[{"Name":"OtherCountry","Value":"Country"},{"Name":"LastName","Value":"LastName"},{"Name":"Title","Value":"Title"},{"Name":"MobilePhone","Value":"Phone"},{"Name":"OtherState","Value":"State"},{"Name":"FirstName","Value":"FirstName"},{"Name":"OtherCity","Value":"City"},{"Name":"OtherPostalCode","Value":"PostalCode"},{"Name":"OtherStreet","Value":"Street"},{"Name":"MailingPostalCode","Value":"PostalCode"},{"Name":"OtherPhone","Value":"Phone"},{"Name":"HomePhone","Value":"Phone"},{"Name":"AssistantPhone","Value":"Phone"},{"Name":"Phone","Value":"Phone"},{"Name":"MailingStreet","Value":"Street"},{"Name":"MailingCity","Value":"City"},{"Name":"MailingState","Value":"State"},{"Name":"MailingCountry","Value":"Country"},{"Name":"Email","Value":"Email"}]}';
        communityConfiguration.FGM_Portal__ConfiguationName__c = 'CommunityUserFieldMapping';
        FCGlobal.Error error = (FCGlobal.Error)CommunityUserFieldMappingController.UpsertRecord( new list<FGM_Portal__CommunityConfiguration__c>{communityConfiguration});
        System.assertNotEquals(error,null);
        //System.assert(error.IsSuccess);
        System.assertNotEquals(error.data,null);
        System.assertNotEquals(communityConfiguration.Id,null);

        communityConfiguration = new  FGM_Portal__CommunityConfiguration__c();
        communityConfiguration.FGM_Portal__JsonData__c = '{"CommunityUserToContact":[{"Name":"OtherCountry","Value":"Country"}]}';
        communityConfiguration.FGM_Portal__ConfiguationName__c = 'CommunityUserFieldMapping';

        error = (FCGlobal.Error)CommunityUserFieldMappingController.UpsertRecord(new list<FGM_Portal__CommunityConfiguration__c>{communityConfiguration});
        System.assertNotEquals(error,null);
        System.assertEquals(error.IsSuccess,false);
        System.assertNotEquals(error.data,null);
        System.assertEquals(communityConfiguration.Id,null);
    }
    static testMethod void test_GetPortalUserMappingData(){
        FCGlobal.Error error = (FCGlobal.Error)CommunityUserFieldMappingController.GetPortalUserMappingData();
        System.assertNotEquals(error,null);
        System.assertEquals(error.IsSuccess,false);
        System.assertEquals(error.data,null);

        FGM_Portal__CommunityConfiguration__c communityConfiguration = new FGM_Portal__CommunityConfiguration__c();
        communityConfiguration.FGM_Portal__JsonData__c = '{"CommunityUserToContact":[{"Name":"OtherCountry","Value":"Country"},{"Name":"MailingStreet","Value":"Street"}]}';
        communityConfiguration.FGM_Portal__ConfiguationName__c = 'CommunityUserFieldMapping';
        error = (FCGlobal.Error)CommunityUserFieldMappingController.UpsertRecord(new list<FGM_Portal__CommunityConfiguration__c>{communityConfiguration});
        System.assertNotEquals(error,null);
        System.assert(error.IsSuccess);
        System.assertNotEquals(error.data,null);
        System.assertNotEquals(communityConfiguration.Id,null);

        error = (FCGlobal.Error)CommunityUserFieldMappingController.GetPortalUserMappingData();
        System.assertNotEquals(error,null);
        System.assert(error.IsSuccess);
        System.assertNotEquals(error.data,null);
    }

}