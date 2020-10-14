/*
<summary>
    <createdBy>Prakash Nawale</createdBy>
    <createdDate>30/01/2015</createdDate>
    <modifiedyBy></modifiedyBy>
    <modifiedDate></modifiedDate>
    <comment> Jira Issue No: FCPROD-141 </comment>
</summary>
 */
@IsTest
public with sharing class Test_PortalUserFieldMappingController {

    static testMethod void test_GetObjectFields(){
        String sObjectName = 'invalidObjectName';
        FCGlobal.Error error = (FCGlobal.Error)PortalUserFieldMappingController.GetObjectFields(sObjectName, new List<String>(),new List<String>(),false);
        System.assertEquals(error.IsSuccess,false);
        System.assertEquals(error.data,null);
        sObjectName = '';
        error = (FCGlobal.Error)PortalUserFieldMappingController.GetObjectFields(sObjectName, new List<String>(),new List<String>(),false);
        System.assertEquals(error.IsSuccess,false);
        System.assertEquals(error.data,null);

        sObjectName = 'Account';
        error = (FCGlobal.Error)PortalUserFieldMappingController.GetObjectFields(sObjectName, new List<String>(),new List<String>(),false);
        System.assert(error.IsSuccess);
        System.assertNotEquals(error.data,null);

        error = (FCGlobal.Error)PortalUserFieldMappingController.GetObjectFields(sObjectName, new List<String>(),new List<String>(),true);
        System.assert(error.IsSuccess);
        System.assertNotEquals(error.data,null);



    }
    static testMethod void test_UpsertRecord(){
        FGM_Portal__CommunityConfiguration__c communityConfiguration = new FGM_Portal__CommunityConfiguration__c();
        communityConfiguration.FGM_Portal__JsonData__c = '{"PortalUserToContact":[{"Name":"FGM_Portal__IsActive__c","Value":"IsDeleted"},{"Name":"MailingStreet","Value":"FGM_Portal__Street_New__c"}],"PortalUserToAccount":[{"Name":"FGM_Portal__Active__c","Value":"IsDeleted"},{"Name":"BillingCountry","Value":"FGM_Portal__Country__c"},{"Name":"ShippingState","Value":"FGM_Portal__State__c"},{"Name":"FGM_Base__EIN__c","Value":"FGM_Portal__EIN__c"}]}';
        communityConfiguration.FGM_Portal__ConfiguationName__c = 'PortalUserFieldMapping';
        FCGlobal.Error error = (FCGlobal.Error)PortalUserFieldMappingController.UpsertRecord( new list<FGM_Portal__CommunityConfiguration__c>{communityConfiguration});
        System.assertNotEquals(error,null);
        //System.assert(error.IsSuccess);
        System.assertNotEquals(error.data,null);
        System.assertNotEquals(communityConfiguration.Id,null);

        communityConfiguration = new  FGM_Portal__CommunityConfiguration__c();
        communityConfiguration.FGM_Portal__JsonData__c = '{"PortalUserToContact":[{"Name":"FGM_Portal__IsActive__c","Value":"IsDeleted"},{"Name":"MailingStreet","Value":"FGM_Portal__Street_New__c"}],"PortalUserToAccount":[{"Name":"FGM_Portal__Active__c","Value":"IsDeleted"},{"Name":"BillingCountry","Value":"FGM_Portal__Country__c"},{"Name":"ShippingState","Value":"FGM_Portal__State__c"},{"Name":"FGM_Base__EIN__c","Value":"FGM_Portal__EIN__c"}]}';
        communityConfiguration.FGM_Portal__ConfiguationName__c = 'PortalUserFieldMapping';

        error = (FCGlobal.Error)PortalUserFieldMappingController.UpsertRecord(new list<FGM_Portal__CommunityConfiguration__c>{communityConfiguration});
        System.assertNotEquals(error,null);
        System.assertEquals(error.IsSuccess,false);
        //System.assertEquals(error.data,null);
        System.assertEquals(communityConfiguration.Id,null);

        communityConfiguration = new  FGM_Portal__CommunityConfiguration__c();
        communityConfiguration.FGM_Portal__JsonData__c = '{"PortalUserToContact":[{"Name":"Email","Value":"FGM_Portal__Email__c"}],"PortalUserToAccount":[{"Name":"FGM_Portal__Active__c","Value":"IsDeleted"},{"Name":"BillingCountry","Value":"FGM_Portal__Country__c"},{"Name":"ShippingState","Value":"FGM_Portal__State__c"},{"Name":"FGM_Base__EIN__c","Value":"FGM_Portal__EIN__c"}]}';
        communityConfiguration.FGM_Portal__ConfiguationName__c = 'PortalUserFieldMapping';

        error = (FCGlobal.Error)PortalUserFieldMappingController.UpsertRecord(new list<FGM_Portal__CommunityConfiguration__c>{communityConfiguration});
        System.assertNotEquals(error,null);
        System.assertEquals(error.IsSuccess,false);
        //System.assertEquals(error.data,null);
        System.assertEquals(communityConfiguration.Id,null);

        communityConfiguration = new  FGM_Portal__CommunityConfiguration__c();
        communityConfiguration.FGM_Portal__JsonData__c = '{"PortalUserToContact":[{"Name":"Email","Value":"FGM_Portal__Email__c"}],"PortalUserToAccount":[{"Name":"Name","Value":"FGM_Portal__Organization_Legal_Name__c"}]}';
        communityConfiguration.FGM_Portal__ConfiguationName__c = 'PortalUserFieldMapping';

        error = (FCGlobal.Error)PortalUserFieldMappingController.UpsertRecord(new list<FGM_Portal__CommunityConfiguration__c>{communityConfiguration});
        System.assertNotEquals(error,null);
        System.assertEquals(error.IsSuccess,false);
        //System.assertEquals(error.data,null);
        System.assertEquals(communityConfiguration.Id,null);

        communityConfiguration = new  FGM_Portal__CommunityConfiguration__c();
        communityConfiguration.FGM_Portal__JsonData__c = '{}';
        communityConfiguration.FGM_Portal__ConfiguationName__c = 'PortalUserFieldMapping';

        error = (FCGlobal.Error)PortalUserFieldMappingController.UpsertRecord(new list<FGM_Portal__CommunityConfiguration__c>{communityConfiguration});
        System.assertNotEquals(error,null);
        System.assertEquals(error.IsSuccess,false);
        //System.assertEquals(error.data,null);
        System.assertEquals(communityConfiguration.Id,null);


    }
    static testMethod void test_GetPortalUserMappingData(){

        FCGlobal.Error error = (FCGlobal.Error)PortalUserFieldMappingController.GetPortalUserMappingData();
        System.assertNotEquals(error,null);
        System.assertEquals(error.IsSuccess,false);
        System.assertEquals(error.data,null);

        FGM_Portal__CommunityConfiguration__c communityConfiguration = new FGM_Portal__CommunityConfiguration__c();
        communityConfiguration.FGM_Portal__JsonData__c = '{"PortalUserToContact":[{"Name":"FGM_Portal__IsActive__c","Value":"IsDeleted"},{"Name":"MailingStreet","Value":"FGM_Portal__Street_New__c"}],"PortalUserToAccount":[{"Name":"FGM_Portal__Active__c","Value":"IsDeleted"},{"Name":"BillingCountry","Value":"FGM_Portal__Country__c"},{"Name":"ShippingState","Value":"FGM_Portal__State__c"}]}';
        communityConfiguration.FGM_Portal__ConfiguationName__c = 'PortalUserFieldMapping';
         error = (FCGlobal.Error)PortalUserFieldMappingController.UpsertRecord(new list<FGM_Portal__CommunityConfiguration__c>{communityConfiguration});
        System.assertNotEquals(error,null);
        //System.assert(error.IsSuccess);
        System.assertNotEquals(error.data,null);
        System.assertNotEquals(communityConfiguration.Id,null);

        error = (FCGlobal.Error)PortalUserFieldMappingController.GetPortalUserMappingData();
        System.assertNotEquals(error,null);
        System.assert(error.IsSuccess);
        System.assertNotEquals(error.data,null);

    }


}