@isTest
private class TestCommunityLandingController{
    @testSetup static void testSetup() {
        try{
            Map<String,Schema.Recordtypeinfo> portalQuizRecordTypeMap = FGM_Portal__Quiz__c.SObjectType.getDescribe().getRecordTypeInfosByName();

            List<User> lstSysAdminUsers = [ SELECT Id FROM User WHERE Profile.Name ='System Administrator' AND IsActive = true ];
            //Creating Account Record
            Account account = TestsObjectProvider.CreateAccount('Sun Micro System');
            account.OwnerId = lstSysAdminUsers[0].Id;
            Database.SaveResult[] resultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

            //Creating Contact Record
            Contact objectContact = TestsObjectProvider.CreateContact('testContact', 'test', resultAccount[0].Id, 'test@contact.test');
            Database.SaveResult[] resultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{objectContact});

            User objectUser = TestsObjectProvider.CreateUser( resultContact[0].Id, 'test@test2.com', 'testUser2', 'testUser2', 'community@user1.com', true, 'FC Community Users Profile', account.Name);
            objectUser.FGM_Portal__ProfileType__c = 'individual';
            objectUser.FGM_Portal__UserProfile__c = 'Grantee';
            objectUser.LanguageLocaleKey = 'es';
            Database.SaveResult[] resultUser1 = TestsObjectProvider.InsertListWithAssert(new List<User>{objectUser});

            //creating Quiz
            FGM_Portal__Quiz__c portalQuiz = TestsObjectProvider.CreateFGMPortalQuiz('ApplicationQuiz 1', 'test@test.com', '', '', '', '', '', 'Introduction', true);
            portalQuiz.FGM_Portal__IsCommunityRecord__c = true;
            portalQuiz.RecordTypeId = portalQuizRecordTypeMap.get(TestsObjectProvider.PORTAL_QUIZ_APPLICATION).getRecordTypeId();
            Database.SaveResult[] resultPortalQuiz = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{portalQuiz});

            List<Campaign> lstCampaign = NEW List<Campaign>();
            Campaign campaign = TestsObjectProvider.CreateCampaign('TestCampaign1', 'test@test1.com', Date.today(), Date.today(), resultPortalQuiz[0].Id,NULL);
            campaign.FGM_Portal__Visibility__c = 'Public';
            campaign.FGM_Portal__Application_Type__c ='Application Quiz';
            campaign.Description ='Description';
            campaign.Type = 'Individual';
            lstCampaign.add(campaign);

            campaign = TestsObjectProvider.CreateCampaign('TestCampaign2', 'test@test1.com', Date.today(), Date.today(), resultPortalQuiz[0].Id,NULL);
            campaign.FGM_Portal__Visibility__c = 'Public';
            campaign.FGM_Portal__Application_Type__c ='Application Quiz';
            lstCampaign.add(campaign);
            TestsObjectProvider.InsertListWithAssert(lstCampaign);

            //creating custom setting record
            FGM_Portal__CommunitySetting__c communitySetting = NEW FGM_Portal__CommunitySetting__c();
            communitySetting.Name = 'ShowExploreGrantOpportunitySearch';
            communitySetting.FGM_Portal__IsEnabled__c = TRUE;
            insert communitySetting;

            FGM_Portal__Community_Static_Resource__c staticResourceSetting = NEW FGM_Portal__Community_Static_Resource__c();
            staticResourceSetting.Name = 'FCCommonResource';
            staticResourceSetting.FGM_Portal__Static_Resource_Name__c = 'FCCommonResource';
            staticResourceSetting.FGM_Portal__File_Relative_Path__c = 'test';
            insert staticResourceSetting;

        }
        catch(Exception ex){
            system.debug('exception :'+ex.getMessage());
        }
    }

    static testMethod void initialize(){
        CommunityLandingController objectCommunityLandingController = NEW CommunityLandingController();
        PageReference objectPageRefrence = objectCommunityLandingController.initialize();
        System.assert(objectPageRefrence == NULL);
    }

    static testMethod void initializeForMultiLingual(){
        User testUser = [SELECT Id FROM User WHERE Email =:'test@test2.com'];
        System.assert(testUser != NULL);

        System.runAs(testUser){
            CommunityLandingController objectCommunityLandingController = NEW CommunityLandingController();
            PageReference objectPageRefrence = objectCommunityLandingController.initialize();
            System.assert(objectPageRefrence == NULL);
        }
    }

    static testMethod void getFieldAndTranslationsMap(){
        Campaign objectCampaign =[SELECT Id,Name,Description FROM Campaign LIMIT 1];
        CommunityLandingController objectCommunityLandingController = NEW CommunityLandingController();
        System.assert(objectCommunityLandingController.getFieldAndTranslationsMap(objectCampaign) != NULL);
    }

    static testMethod void search(){
        FGM_Portal__CommunitySetting__c  communitySetting = FGM_Portal__CommunitySetting__c.getInstance('ShowExploreGrantOpportunitySearch');
        System.assert(CommunitySetting != NULL);
        delete CommunitySetting;

        Community_Static_Resource__c staticResourceSetting = Community_Static_Resource__c.getInstance('FCCommonResource');
        System.assert(staticResourceSetting != NULL);
        delete staticResourceSetting;

        CommunityLandingController objectCommunityLandingController = NEW CommunityLandingController();
        ApexPages.currentPage().getParameters().put('find', 'TestCampaign1');
        ApexPages.currentPage().getParameters().put('type', 'Individual');
        objectCommunityLandingController.initializeFilter();
        objectCommunityLandingController.initializeCampaignList();
        System.assert(objectCommunityLandingController.search() != NULL);
    }
}