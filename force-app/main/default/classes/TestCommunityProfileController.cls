@isTest
private class TestCommunityProfileController{
    @testSetup static void testSetup() {
        try{
            Map<String,Schema.Recordtypeinfo> mapPortalQuizRecordType = FGM_Portal__Quiz__c.SObjectType.getDescribe().getRecordTypeInfosByName();
            Map<String,Schema.Recordtypeinfo> mapRelatedListControllerRecordType = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfosByName();
            Map<String,Schema.Recordtypeinfo> mapAmendmentRecordType = FGM_Portal__Amendment__c.SObjectType.getDescribe().getRecordTypeInfosByName();
            Map<String,Schema.Recordtypeinfo> mapPortalQuestionRecordType = FGM_Portal__Questions__c.SObjectType.getDescribe().getRecordTypeInfosByName();

            List<User> lstSysAdminUsers = [ SELECT Id FROM User WHERE Profile.Name ='System Administrator' AND IsActive = true ];
            //Creating Account Record
            Account account = TestsObjectProvider.CreateAccount('Sun Micro System');
            account.OwnerId = lstSysAdminUsers[0].Id;
            Database.SaveResult[] resultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

            //Creating Contact Record
            List<Contact> lstContact = NEW  List<Contact>();
            lstContact.add(TestsObjectProvider.CreateContact('testContact', 'test', resultAccount[0].Id, 'test@contact.test'));
            lstContact.add(TestsObjectProvider.CreateContact('testContact', 'test', resultAccount[0].Id, 'test@contact.test'));
            lstContact.add(TestsObjectProvider.CreateContact('testContact', 'test', resultAccount[0].Id, 'test@contact.test'));
            lstContact.add(TestsObjectProvider.CreateContact('testContact', 'test', resultAccount[0].Id, 'test@contact.test'));
            lstContact.add(TestsObjectProvider.CreateContact('testContact', 'test', resultAccount[0].Id, 'test@contact.test'));
            Database.SaveResult[] resultContact = TestsObjectProvider.InsertListWithAssert(lstContact);
            //1)Grantee & organization
            List<User> lstUser = NEW List<User>();
            lstUser.add(TestsObjectProvider.CreateUser( resultContact[0].Id, 'test@test2.com', 'testUser2', 'testUser2', 'community@user1.com', true, 'FC Community Users Profile', account.Name));
            lstUser[0].FGM_Portal__ProfileType__c = 'Organization';
            lstUser[0].FGM_Portal__UserProfile__c = 'Grantee';
            lstUser[0].LanguageLocaleKey = 'en_US';
            //2)Grantee & Individual
            lstUser.add(TestsObjectProvider.CreateUser( resultContact[1].Id, 'test@test2.com', 'testUser2', 'testUser2', 'community@user2.com', true, 'FC Community Users Profile', account.Name));
            lstUser[1].FGM_Portal__ProfileType__c = 'Individual';
            lstUser[1].FGM_Portal__UserProfile__c = 'Grantee';
            lstUser[1].LanguageLocaleKey = 'en_US';
            //3)Reviewer & organization
            lstUser.add(TestsObjectProvider.CreateUser( resultContact[2].Id, 'test@test2.com', 'testUser2', 'testUser2', 'community@user3.com', true, 'FC Community Users Profile', account.Name));
            lstUser[2].FGM_Portal__ProfileType__c = 'organization';
            lstUser[2].FGM_Portal__UserProfile__c = 'Reviewer';
            lstUser[2].LanguageLocaleKey = 'en_US';
            //3)Reviewer & Individual
            lstUser.add(TestsObjectProvider.CreateUser( resultContact[3].Id, 'test@test2.com', 'testUser2', 'testUser2', 'community@user4.com', true, 'FC Community Users Profile', account.Name));
            lstUser[3].FGM_Portal__ProfileType__c = 'Individual';
            lstUser[3].FGM_Portal__UserProfile__c = 'Reviewer';
            lstUser[3].LanguageLocaleKey = 'en_US';
            //4)Consultant & organization
            lstUser.add(TestsObjectProvider.CreateUser( resultContact[4].Id, 'test@test2.com', 'testUser2', 'testUser2', 'community@user5.com', true, 'FC Community Users Profile', account.Name));
            lstUser[4].FGM_Portal__ProfileType__c = 'organization';
            lstUser[4].FGM_Portal__UserProfile__c = 'Consultant';
            lstUser[4].LanguageLocaleKey = 'en_US';
            Database.SaveResult[] resultUser = TestsObjectProvider.InsertListWithAssert(lstUser);
            FGM_Portal__Quiz__c fGMPortalQuiz = TestsObjectProvider.createFGMPortalQuiz('OrganizationPageLayout', 'test@test.com', '', '', '', '', '', 'Introduction', true);
            fGMPortalQuiz.FGM_Portal__IsCommunityRecord__c = true;
            fGMPortalQuiz.RecordTypeId = mapPortalQuizRecordType.get('Page Layout').getRecordTypeId();

            Database.Saveresult[] resultFGMPortalQuiz = TestsObjectProvider.insertListWithAssert(new List<FGM_Portal__Quiz__c>{fGMPortalQuiz});

            List<FGM_Portal__FCPageLayout__c> lstFCPageLayout = new List<FGM_Portal__FCPageLayout__c>();
            lstFCPageLayout.add(TestsObjectProvider.createFCPageLayout('Organization',mapAmendmentRecordType.get('Organization').getRecordTypeId(),'FGM_Portal__Amendment__c',resultFGMPortalQuiz[0].Id));

            lstFCPageLayout.add(TestsObjectProvider.createFCPageLayout('Contact',mapAmendmentRecordType.get('Contact').getRecordTypeId(),'FGM_Portal__Amendment__c',resultFGMPortalQuiz[0].Id));
            Database.Saveresult[] resultFGMPortalFCPageLayout = TestsObjectProvider.insertListWithAssert(lstFCPageLayout);


            List<FGM_Portal__Related_List_Controller__c> lstRelatedListController = new  List<FGM_Portal__Related_List_Controller__c>();

            lstRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('Amendment', 'FGM_Portal__Amendment__c', 'Dashboard', 'FGM_Portal__Amendment__c', 'FGM_Portal__Amendment__c', 'FGM_Portal__Amendment__c', '', '', mapRelatedListControllerRecordType.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB).getRecordTypeId(), resultFGMPortalQuiz[0].Id));
            lstRelatedListController[0].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[0].FGM_Portal__IsCommunityRecord__c = TRUE;
            lstRelatedListController[0].FGM_Portal__SortOrder__c= 0;
            lstRelatedListController[0].FGM_Portal__ShowDeleteLink__c = TRUE;
            lstRelatedListController[0].FGM_Portal__ShowNewButton__c = TRUE;
            lstRelatedListController[0].FGM_Portal__SortField__c ='Name';
            lstRelatedListController[0].FGM_Portal__SortFieldOrder__c ='Ascending';

            Database.Saveresult[] resultsFGMPortalRelatedListController = TestsObjectProvider.insertListWithAssert(lstRelatedListController);

            List<FGM_Portal__Questions__c> lstFGMPortalQuestion = new List<FGM_Portal__Questions__c>();

            //Question For Amendment
            lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Name', '', '', '', 'Salesforce Data Type', resultFGMPortalQuiz[0].Id, '', mapPortalQuestionRecordType.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
            lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('FGM_Portal__Description__c', '', '', '', 'Salesforce Data Type', resultFGMPortalQuiz[0].Id, '', mapPortalQuestionRecordType.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
            lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('FGM_Portal__Phone__c', '', '', '', 'Salesforce Data Type', resultFGMPortalQuiz[0].Id, '', mapPortalQuestionRecordType.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
            lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Attachment', '', '', '', 'Attachment', resultFGMPortalQuiz[0].Id, '', mapPortalQuestionRecordType.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
            Database.Saveresult[] resultsFGMPortalQuestion = TestsObjectProvider.insertListWithAssert(lstFGMPortalQuestion);

            //QuizQuestion For Amendment
            List<FGM_Portal__Quiz_Questions__c> lstFGMPortalQuizQuestion = new List<FGM_Portal__Quiz_Questions__c>();
            lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(resultsFGMPortalQuestion[0].Id, 1, 'Name', '', 50, '1', resultsFGMPortalRelatedListController[0].Id, true, resultFGMPortalQuiz[0].Id));
            lstFGMPortalQuizQuestion[0].FGM_Portal__IsCommunityRecord__c = true;
            lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(resultsFGMPortalQuestion[1].Id, 1, 'FGM_Portal__Description__c', '', 50, '1', resultsFGMPortalRelatedListController[0].Id, false, resultFGMPortalQuiz[0].Id));
            lstFGMPortalQuizQuestion[1].FGM_Portal__IsCommunityRecord__c = true;
            lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(resultsFGMPortalQuestion[2].Id, 1, 'FGM_Portal__Phone__c', '', 50, '1', resultsFGMPortalRelatedListController[0].Id, false, resultFGMPortalQuiz[0].Id));
            lstFGMPortalQuizQuestion[2].FGM_Portal__IsCommunityRecord__c = true;
            lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(resultsFGMPortalQuestion[3].Id, 1, '', '', 50, '1', resultsFGMPortalRelatedListController[0].Id, true, resultFGMPortalQuiz[0].Id));
            lstFGMPortalQuizQuestion[3].FGM_Portal__IsCommunityRecord__c = true;
            Database.Saveresult[] resultsfGMPortalQuizQuestion = TestsObjectProvider.insertListWithAssert(lstFGMPortalQuizQuestion);

            List<FGM_Portal__CommunitySetting__c> lstCommunitySetting = new  List<FGM_Portal__CommunitySetting__c>();
            lstCommunitySetting.add(new FGM_Portal__CommunitySetting__c(Name = 'ShowOrganizationTabToGranteeOrg',FGM_Portal__IsEnabled__c = true));
            lstCommunitySetting.add(new FGM_Portal__CommunitySetting__c(Name = 'ShowContactTabToGranteeOrg',FGM_Portal__IsEnabled__c = true));
            lstCommunitySetting.add(new FGM_Portal__CommunitySetting__c(Name = 'ShowOrganizationTabToGranteeInd',FGM_Portal__IsEnabled__c = false));
            lstCommunitySetting.add(new FGM_Portal__CommunitySetting__c(Name = 'ShowContactTabToGranteeInd',FGM_Portal__IsEnabled__c = true));
            lstCommunitySetting.add(new FGM_Portal__CommunitySetting__c(Name = 'ShowOrganizationTabToReviwerOrg',FGM_Portal__IsEnabled__c = true));
            lstCommunitySetting.add(new FGM_Portal__CommunitySetting__c(Name = 'ShowContactTabToReviwerOrg',FGM_Portal__IsEnabled__c = true));
            lstCommunitySetting.add(new FGM_Portal__CommunitySetting__c(Name = 'ShowOrganizationTabToReviwerInd',FGM_Portal__IsEnabled__c = true));
            lstCommunitySetting.add(new FGM_Portal__CommunitySetting__c(Name = 'ShowContactTabToReviwerInd',FGM_Portal__IsEnabled__c = true));
            lstCommunitySetting.add(new FGM_Portal__CommunitySetting__c(Name = 'ShowOrganizationTabToConsultantOrg',FGM_Portal__IsEnabled__c = true));
            lstCommunitySetting.add(new FGM_Portal__CommunitySetting__c(Name = 'ShowContactTabToConsultantOrg',FGM_Portal__IsEnabled__c = true));
            lstCommunitySetting.add(new FGM_Portal__CommunitySetting__c(Name = 'IsOrgNameEditable',FGM_Portal__IsEnabled__c = true));
            insert lstCommunitySetting ;

            List<FGM_Portal__CustomHTML__c> lstCustomHtml = NEW List<FGM_Portal__CustomHTML__c>();
            lstCustomHtml.add(TestsObjectProvider.createFGMPortalCustomHTML('GranteeApplicationReview','Grantee','en_US','Header','test'));
            lstCustomHtml.add(TestsObjectProvider.createFGMPortalCustomHTML('GranteeApplicationReview','Reviewer','en_US','Header','test'));
            insert lstCustomHtml;

            FGM_Portal__Amendment__c objectAmendment = NEW FGM_Portal__Amendment__c();
            objectAmendment.FGM_Portal__Account__c = resultAccount[0].Id;
            insert objectAmendment;

            String customProfileRecordTypeId = mapRelatedListControllerRecordType.get('Custom Profile Tab').getRecordTypeId();
            FGM_Portal__Related_List_Controller__c customProfile = new FGM_Portal__Related_List_Controller__c();
            customProfile.RecordTypeId = customProfileRecordTypeId;
            customProfile.Name = 'Amendment Dashboard Fields';
            customProfile.FGM_Portal__ObjectName__c = 'FGM_Portal__Amendment__c';
            customProfile.FGM_Portal__ParentObject__c = 'Account';
            customProfile.FGM_Portal__LookupField__c = 'FGM_Portal__Account__c';
            customProfile.FGM_Portal__Associated_FC_Portal_Type__c = 'Grantee';
            customProfile.FGM_Portal__Associated_Tab_Type__c = 'Profile';
            customProfile.FGM_Portal__Language__c = 'en_US';
            customProfile.FGM_Portal__FieldNames__c = 'Name,FGM_Portal__StageName__c,FGM_Portal__Phone__c';
            customProfile.FGM_Portal__FieldHeaders__c = 'Name,Stage,Phone';
            customProfile.FGM_Portal__Cloned_from__c = lstRelatedListController[0].Id;
            customProfile.FGM_Portal__RichInstructionalText__c = 'Test';
            customProfile.FGM_Portal__Hide_Edit_Link__c = false;
            customProfile.FGM_Portal__ShowNewButton__c = true;
            customProfile.FGM_Portal__EnableAmendment__c = TRUE;
            customProfile.FGM_Portal__ShowDeleteLink__c = true;
            insert customProfile;

        }catch(Exception ex){
            system.debug('Exception..:'+ex.getMessage());
        }
    }

    static testMethod void getApplicationObjectNameTest(){
        sObject testObject = NEW Account();
        CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
        System.assertEquals(NULL,objectCommunityProfileController.getApplicationObjectName());
        objectCommunityProfileController.tabObject = testObject;
        System.assertNotEquals(NULL,objectCommunityProfileController.getApplicationObjectName());
    }

     static testMethod void getAccountFieldsTest(){
        CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
        System.assertNotEquals(NULL,objectCommunityProfileController.getAccountFields());
        objectCommunityProfileController.profileType = 'Individual';
        System.assertNotEquals(NULL,objectCommunityProfileController.getAccountFields());
        Boolean isEditable = objectCommunityProfileController.isOrgNameEditable;
        system.assert(isEditable);
    }

     static testMethod void getContactFieldsTest(){
        CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
        System.assertNotEquals(NULL,objectCommunityProfileController.getContactFields());
        objectCommunityProfileController.profileType = 'Individual';
        System.assertNotEquals(NULL,objectCommunityProfileController.getContactFields());
    }

    static testMethod void checkForAccountContactEditableTest(){
        CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
        objectCommunityProfileController.checkForAccountContactEditable();
        System.assert(objectCommunityProfileController.isAccountEditable);
        System.assert(objectCommunityProfileController.iscontactEditable);
    }

    static testMethod void getCustomHTMLDescriptionTest(){
        CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
        objectCommunityProfileController.mapCustomHtml = NEW  Map<id,CustomHTML__c>([SELECT Id,Name,RichDescription__c,Language__c FROM CustomHTML__c]);
        System.assertNotEquals(NULL,objectCommunityProfileController.getCustomHTMLDescription());
    }

    static testMethod void initializeTestForGranteeOrganization(){
        User ObjectUser = [SELECT Id,FGM_Portal__ProfileType__c,FGM_Portal__UserProfile__c,LanguageLocaleKey FROM User WHERE UserName = 'community@user1.com'];
        System.assert(ObjectUser != NULL);
        System.runAs(ObjectUser){
             CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
             objectCommunityProfileController.isSCPLEnable = TRUE;
             objectCommunityProfileController.selectedTab = 'contact';
             objectCommunityProfileController.initialize();
        }
    }

     static testMethod void initializeTestForGranteeIndividual(){
        User ObjectUser = [SELECT Id,FGM_Portal__ProfileType__c,FGM_Portal__UserProfile__c,LanguageLocaleKey FROM User WHERE UserName = 'community@user2.com'];
        FGM_Portal__Amendment__c objectAmendment = [SELECT Id FROM FGM_Portal__Amendment__c LIMIT 1];
        System.assert(objectAmendment != NULL);
        System.assert(ObjectUser != NULL);
        System.runAs(ObjectUser){
             CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
             ApexPages.currentPage().getParameters().put('amendment',objectAmendment.Id);
             objectCommunityProfileController.initialize();
        }
    }

     static testMethod void initializeTestForReviewerOrganization(){
        User ObjectUser = [SELECT Id,FGM_Portal__ProfileType__c,FGM_Portal__UserProfile__c,LanguageLocaleKey FROM User WHERE UserName = 'community@user3.com'];
        System.assert(ObjectUser != NULL);
        System.runAs(ObjectUser){
             CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
             objectCommunityProfileController.initialize();
        }
    }

     static testMethod void initializeTestForReviewerIndividual(){
        User ObjectUser = [SELECT Id,FGM_Portal__ProfileType__c,FGM_Portal__UserProfile__c,LanguageLocaleKey FROM User WHERE UserName = 'community@user4.com'];
        System.assert(ObjectUser != NULL);
        System.runAs(ObjectUser){
             CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
             objectCommunityProfileController.initialize();
        }
    }

     static testMethod void initializeTestForConsultantOrganization(){
        User ObjectUser = [SELECT Id,FGM_Portal__ProfileType__c,FGM_Portal__UserProfile__c,LanguageLocaleKey FROM User WHERE UserName = 'community@user5.com'];
        System.assert(ObjectUser != NULL);
        System.runAs(ObjectUser){
             CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
             objectCommunityProfileController.initialize();
        }
    }

      static testMethod void initializeCharCountTest(){
           CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
           objectCommunityProfileController.lstTabs = [SELECT Id,ObjectName__c FROM FGM_Portal__Related_List_Controller__c LIMIT 1];
           system.assert(objectCommunityProfileController.lstTabs != NULL);
           objectCommunityProfileController.selectedTab = objectCommunityProfileController.lstTabs[0].Id;
           objectCommunityProfileController.initializeCharCount();
      }

     static testMethod void getObjectRecordAsPerUserProfileTest(){
         User ObjectUser = [SELECT Id,FGM_Portal__ProfileType__c,FGM_Portal__UserProfile__c,LanguageLocaleKey FROM User WHERE UserName = 'community@user1.com'];
         System.assert(ObjectUser != NULL);
         System.runAs(ObjectUser){
             CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
             objectCommunityProfileController.tabName ='Account';
             objectCommunityProfileController.getObjectRecordAsPerUserProfile(TRUE,TRUE);

             objectCommunityProfileController.tabName ='Test';
             objectCommunityProfileController.getObjectRecordAsPerUserProfile(TRUE,TRUE);

             objectCommunityProfileController.tabName = NULL;
             objectCommunityProfileController.getObjectRecordAsPerUserProfile(TRUE,TRUE);

             objectCommunityProfileController.getObjectRecordAsPerUserProfile(TRUE,FALSE);

             objectCommunityProfileController.getObjectRecordAsPerUserProfile(TRUE,FALSE);

             objectCommunityProfileController.lstTabs = [SELECT Id,ObjectName__c FROM FGM_Portal__Related_List_Controller__c LIMIT 1];
             objectCommunityProfileController.getObjectRecordAsPerUserProfile(FALSE,FALSE);

         }
     }

     static testMethod void initializeRelatedListTabTest(){
         User ObjectUser = [SELECT Id,FGM_Portal__ProfileType__c,FGM_Portal__UserProfile__c,LanguageLocaleKey FROM User WHERE UserName = 'community@user1.com'];
         System.assert(ObjectUser != NULL);
         Set<String> setCustomSetting = NEW Set<String>();
         setCustomSetting.add('ShowOrganizationTabToGranteeOrg');
         setCustomSetting.add('ShowContactTabToGranteeOrg');
         List<FGM_Portal__CommunitySetting__c> lstCustomSetting = [SELECT Id,Name FROM FGM_Portal__CommunitySetting__c WHERE Name IN:setCustomSetting];
         delete lstCustomSetting;
         CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
         objectCommunityProfileController.lstTabs = [SELECT Id,Name,FGM_Portal__FieldHeaders__c,FGM_Portal__FieldNames__c,FGM_Portal__EnableAmendment__c,FGM_Portal__LookupField__c,FGM_Portal__ShowNewButton__c,FGM_Portal__ObjectName__c,FGM_Portal__Hide_Edit_Link__c,FGM_Portal__ShowDeleteLink__c,FGM_Portal__RichInstructionalText__c FROM FGM_Portal__Related_List_Controller__c WHERE Name = 'Amendment Dashboard Fields' LIMIT 1];
         System.runAs(ObjectUser){
            ApexPages.currentPage().getParameters().put('tabId',objectCommunityProfileController.lstTabs[0].Id);
            objectCommunityProfileController.initializeRelatedListTab();
         }
     }
     static testMethod void getRelatedListRecordsTest(){
          User ObjectUser = [SELECT Id,FGM_Portal__ProfileType__c,FGM_Portal__UserProfile__c,LanguageLocaleKey FROM User WHERE UserName = 'community@user1.com'];
          System.assert(ObjectUser != NULL);
          FGM_Portal__Related_List_Controller__c objectRelatedListController =[SELECT Id,Name,FGM_Portal__FieldHeaders__c,FGM_Portal__FieldNames__c,FGM_Portal__EnableAmendment__c,FGM_Portal__LookupField__c,FGM_Portal__ParentObject__c,FGM_Portal__ShowNewButton__c,FGM_Portal__ObjectName__c,FGM_Portal__Hide_Edit_Link__c,FGM_Portal__ShowDeleteLink__c,FGM_Portal__RichInstructionalText__c FROM FGM_Portal__Related_List_Controller__c WHERE Name = 'Amendment Dashboard Fields' LIMIT 1];
           System.runAs(ObjectUser){
                CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
                Set<String> setFields = NEW Set<String>{'Name','FGM_Portal__StageName__c','FGM_Portal__Phone__c'};
                objectCommunityProfileController.getRelatedListRecords(objectRelatedListController,setFields);
           }
     }

    static testMethod void createAmendmentRecordTest(){
         User ObjectUser = [SELECT Id,AccountId,ContactId,FGM_Portal__ProfileType__c,FGM_Portal__UserProfile__c,LanguageLocaleKey FROM User WHERE UserName = 'community@user1.com'];
          System.assert(ObjectUser != NULL);
          FGM_Portal__Related_List_Controller__c objectRelatedListController =[SELECT Id,Name,FGM_Portal__FieldHeaders__c,FGM_Portal__FieldNames__c,FGM_Portal__EnableAmendment__c,FGM_Portal__LookupField__c,FGM_Portal__ParentObject__c,FGM_Portal__ShowNewButton__c,FGM_Portal__ObjectName__c,FGM_Portal__Hide_Edit_Link__c,FGM_Portal__ShowDeleteLink__c,FGM_Portal__RichInstructionalText__c FROM FGM_Portal__Related_List_Controller__c WHERE Name = 'Amendment Dashboard Fields' LIMIT 1];
           System.runAs(ObjectUser){
                CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
                objectCommunityProfileController.selectedTab = 'organization';
                objectCommunityProfileController.strAccountId = ObjectUser.AccountId;
                objectCommunityProfileController.createAmendmentRecord();
                objectCommunityProfileController.selectedTab = 'contact';
                objectCommunityProfileController.strContactId = ObjectUser.ContactId;
                objectCommunityProfileController.createAmendmentRecord();
           }
    }

    static testMethod void getNewRelatedListRecordTest(){
        User ObjectUser = [SELECT Id,AccountId,ContactId,FGM_Portal__ProfileType__c,FGM_Portal__UserProfile__c,LanguageLocaleKey FROM User WHERE UserName = 'community@user1.com'];
        System.assert(ObjectUser != NULL);
        CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
        objectCommunityProfileController.lstTabs = [SELECT Id,Name,FGM_Portal__FieldHeaders__c,FGM_Portal__FieldNames__c,FGM_Portal__EnableAmendment__c,FGM_Portal__LookupField__c,FGM_Portal__ParentObject__c,FGM_Portal__ShowNewButton__c,FGM_Portal__ObjectName__c,FGM_Portal__Hide_Edit_Link__c,FGM_Portal__ShowDeleteLink__c,FGM_Portal__RichInstructionalText__c FROM FGM_Portal__Related_List_Controller__c WHERE Name = 'Amendment Dashboard Fields' LIMIT 1];
        objectCommunityProfileController.selectedTab =  objectCommunityProfileController.lstTabs[0].Id;
        objectCommunityProfileController.strAccountId = ObjectUser.AccountId;
        objectCommunityProfileController.relatedListConfiguration = NEW CommunityProfileController.relatedList();
        objectCommunityProfileController.relatedListConfiguration.strRelatedListObject = 'FGM_Portal__Amendment__c';
        objectCommunityProfileController.relatedListConfiguration.relatedListLookUp = 'FGM_Portal__Account__c';
        System.runAs(ObjectUser){
             objectCommunityProfileController.getNewRelatedListRecord();
        }
    }

    static testMethod void removeRecordsFromMapTest(){
        CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
        List<sObject> objectRelatedListController =[SELECT Id,Name,FGM_Portal__FieldHeaders__c,FGM_Portal__FieldNames__c,FGM_Portal__EnableAmendment__c,FGM_Portal__LookupField__c,FGM_Portal__ParentObject__c,FGM_Portal__ShowNewButton__c,FGM_Portal__ObjectName__c,FGM_Portal__Hide_Edit_Link__c,FGM_Portal__ShowDeleteLink__c,FGM_Portal__RichInstructionalText__c FROM FGM_Portal__Related_List_Controller__c WHERE Name = 'Amendment Dashboard Fields' LIMIT 1];
        System.assert(objectRelatedListController != NULL);
        objectCommunityProfileController.mapRelatedListRecordByTab.put(objectRelatedListController[0].Id,objectRelatedListController);
        objectCommunityProfileController.removeRecordsFromMap(objectRelatedListController[0].Id);
        system.assert((objectCommunityProfileController.mapRelatedListRecordByTab).Size() == 0);
    }

    static testMethod void deleteTabRecordTest(){
        CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
        ApexPages.currentPage().getParameters().put('recordIndex','0');
        List<FGM_Portal__Related_List_Controller__c> objectRelatedListController =[SELECT Id,Name,FGM_Portal__FieldHeaders__c,FGM_Portal__FieldNames__c,FGM_Portal__EnableAmendment__c,FGM_Portal__LookupField__c,FGM_Portal__ParentObject__c,FGM_Portal__ShowNewButton__c,FGM_Portal__ObjectName__c,FGM_Portal__Hide_Edit_Link__c,FGM_Portal__ShowDeleteLink__c,FGM_Portal__RichInstructionalText__c FROM FGM_Portal__Related_List_Controller__c  LIMIT 2];
        System.assert(objectRelatedListController != NULL);
        objectCommunityProfileController.selectedTab = objectRelatedListController[1].Id;
        objectCommunityProfileController.lstTabs = NEW List<FGM_Portal__Related_List_Controller__c>();
        objectCommunityProfileController.lstTabs.addAll(NEW List<FGM_Portal__Related_List_Controller__c>{objectRelatedListController[0],objectRelatedListController[1]});
        objectCommunityProfileController.relatedListConfiguration = NEW CommunityProfileController.relatedList();
        objectCommunityProfileController.relatedListConfiguration.strRelatedListObject = 'FGM_Portal__Amendment__c';
        objectCommunityProfileController.relatedListConfiguration.lstRelatedListRecord.addAll(NEW List<object>{objectRelatedListController[0],objectRelatedListController[1]});
        objectCommunityProfileController.deleteTabRecord();
    }

    static testMethod void viewTabRecordTest(){
        CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
        ApexPages.currentPage().getParameters().put('recordIndex','0');
        List<FGM_Portal__Related_List_Controller__c> objectRelatedListController =[SELECT Id,Name,FGM_Portal__FieldHeaders__c,FGM_Portal__FieldNames__c,FGM_Portal__EnableAmendment__c,FGM_Portal__LookupField__c,FGM_Portal__ParentObject__c,FGM_Portal__ShowNewButton__c,FGM_Portal__ObjectName__c,FGM_Portal__Hide_Edit_Link__c,FGM_Portal__ShowDeleteLink__c,FGM_Portal__RichInstructionalText__c FROM FGM_Portal__Related_List_Controller__c  LIMIT 2];
        system.assert(objectRelatedListController != NULL);
        objectCommunityProfileController.selectedTab = objectRelatedListController[1].Id;
        objectCommunityProfileController.lstTabs = NEW List<FGM_Portal__Related_List_Controller__c>();
        objectCommunityProfileController.lstTabs.addAll(NEW List<FGM_Portal__Related_List_Controller__c>{objectRelatedListController[0],objectRelatedListController[1]});
        objectCommunityProfileController.relatedListConfiguration = NEW CommunityProfileController.relatedList();
        objectCommunityProfileController.relatedListConfiguration.strRelatedListObject = 'FGM_Portal__Amendment__c';
        objectCommunityProfileController.relatedListConfiguration.lstRelatedListRecord.addAll(NEW List<object>{objectRelatedListController[0],objectRelatedListController[1]});
        objectCommunityProfileController.viewTabRecord();
    }

    static testMethod void editTabRecordTest(){
        CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
        ApexPages.currentPage().getParameters().put('recordIndex','0');
        List<FGM_Portal__Related_List_Controller__c> objectRelatedListController =[SELECT Id,Name,FGM_Portal__FieldHeaders__c,FGM_Portal__FieldNames__c,FGM_Portal__EnableAmendment__c,FGM_Portal__LookupField__c,FGM_Portal__ParentObject__c,FGM_Portal__ShowNewButton__c,FGM_Portal__ObjectName__c,FGM_Portal__Hide_Edit_Link__c,FGM_Portal__ShowDeleteLink__c,FGM_Portal__RichInstructionalText__c FROM FGM_Portal__Related_List_Controller__c  LIMIT 2];
        system.assert(objectRelatedListController != NULL);
        objectCommunityProfileController.selectedTab = objectRelatedListController[1].Id;
        objectCommunityProfileController.lstTabs = NEW List<FGM_Portal__Related_List_Controller__c>();
        objectCommunityProfileController.lstTabs.addAll(NEW List<FGM_Portal__Related_List_Controller__c>{objectRelatedListController[0],objectRelatedListController[1]});
        objectCommunityProfileController.relatedListConfiguration = NEW CommunityProfileController.relatedList();
        objectCommunityProfileController.relatedListConfiguration.strRelatedListObject = 'FGM_Portal__Amendment__c';
        objectCommunityProfileController.relatedListConfiguration.lstRelatedListRecord.addAll(NEW List<object>{objectRelatedListController[0],objectRelatedListController[1]});
        objectCommunityProfileController.editTabRecord();
    }
    static testMethod void saveAmendmentRecordTest(){
        User ObjectUser = [SELECT Id,AccountId,ContactId,FGM_Portal__ProfileType__c,FGM_Portal__UserProfile__c,LanguageLocaleKey FROM User WHERE UserName = 'community@user1.com'];
        System.assert(ObjectUser != NULL);
        CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
          ApexPages.currentPage().getParameters().put('ParentId',ObjectUser.ContactId);
        System.runAs(ObjectUser){
             objectCommunityProfileController.saveamendmentRecord();
        }
    }

    //test for save of contact record with update field
    @isTest static void saveContactWithReadOnlyField(){
        //this user has the base FC Community Users profile. I copied a lot of the save test already at play but modified to make sure a contact field gets updated with data
        User ObjectUser; 
        List<User> testUsers= [SELECT Id,AccountId,ContactId,FGM_Portal__ProfileType__c,FGM_Portal__UserProfile__c,LanguageLocaleKey FROM User WHERE Username = 'community@user1.com'];        
        //to help prevent test data issues:
        System.assertEquals(1, testUsers.size(), 'There should be one test user queried.');
        ObjectUser = testUsers[0];

        CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();        
        System.runAs(ObjectUser){
            Id contactId = [SELECT contactid FROM User WHERE id =: Userinfo.getUserid()].contactId;            
            List<Schema.FieldSetMember> lstFields = objectCommunityProfileController.getContactFields();            
            List<String> contactFields = new List<String>();
            for(Schema.FieldSetMember field:lstFields){
                contactFields.add(field.getFieldPath());
            }
            //Adding the standard fields 'Phone' and 'Description' to the contact query.
            if(!contactFields.contains('Phone')){
                contactFields.add('Phone');
            }
            if(!contactFields.contains('Description')){
                contactFields.add('Description');
            }
            
            //get our contact with fieldset fields
            String query = 'SELECT Id,';
            query += String.join(contactFields,',');
            query +=',AccountId FROM Contact WHERE Id =:contactId';
            Contact contact =  Database.query(query);
            //make sure the phone has a value            
            contact.Phone = '2105555555';
            contact.Description = 'Before updating through the save method!';
            update contact;            
            //ok get the field permission on phone and remove the edit access

            List<FieldPermissions> contactPhoneFieldPerms = [SELECT SobjectType, Field, PermissionsRead, PermissionsEdit, 
                                 Parent.ProfileID FROM FieldPermissions 
                                 WHERE SobjectType = 'Contact' AND (Field = 'Contact.Phone' OR Field = 'Contact.Description')
                                 AND Parent.ProfileId = :UserInfo.getProfileId()];
            //we should have returned permissions for the phone field on contact
            System.assert(contactPhoneFieldPerms.isEmpty() != true, 'We are not finding any field permission for Contact.Phone on the running users profile: ' + UserInfo.getProfileId());
            //remove edit access
            for (FieldPermissions perm : contactPhoneFieldPerms){                
                if(perm.Field == 'Phone'){
                    perm.PermissionsRead = true;
                    perm.PermissionsEdit = false;
                }else{
                    //should be the Description field.
                    perm.PermissionsRead = true;
                    perm.PermissionsEdit = true;
                }
                

            }                        
            update contactPhoneFieldPerms;                                    

            Test.startTest();            
            objectCommunityProfileController.selectedTab ='contact';
            objectCommunityProfileController.userContact = contact;
            //update a known field to ensure update occurs
            contact.Description = 'This is what it should be after we update it!';                                
            try{
                objectCommunityProfileController.save();
                
            } catch(Exception e){
                System.assert(false, 'An error should not have been thrown on save: ' +  e.getMessage() + '|| Type: ' + e.getTypeName());                                                
            }            
            Test.stopTest();        

            //query to ensure save not only succeeded but updated
            Contact contactAfterSave =  Database.query(query);                               
            //assert that it was updated
            System.assertEquals('This is what it should be after we update it!', contactAfterSave.Description, 'The contact description did not successfully update: ' + contactAfterSave.Description);
            

        }
        
    }
    //test for save of contact record with update field
    @isTest static void saveAccountWithReadOnlyField(){
        //this user has the base FC Community Users profile. I copied a lot of the save test already at play but modified to make sure a contact field gets updated with data
        User ObjectUser; 
        List<User> testUsers= [SELECT Id,AccountId,ContactId,FGM_Portal__ProfileType__c,FGM_Portal__UserProfile__c,LanguageLocaleKey FROM User WHERE Username = 'community@user1.com'];        
        //to help prevent test data issues:
        System.assertEquals(1, testUsers.size(), 'There should be one test user queried.');
        ObjectUser = testUsers[0];

        CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();        
        System.runAs(ObjectUser){
            Id contactId = [SELECT contactid FROM User WHERE id =: Userinfo.getUserid()].contactId;   
            Id accountId  = [SELECT accountID FROM Contact WHERE id =: contactId].AccountId;         
            List<Schema.FieldSetMember> lstAccountFields = objectCommunityProfileController.getAccountFields();
            List<String> accountFields = new List<String>();
            for(Schema.FieldSetMember field:lstAccountFields){
                accountFields.add(field.getFieldPath());
            }
            
            //add our standard fields to the account query (if they arent in the fieldset)
            if(!accountFields.contains('Phone')){
                accountFields.add('Phone');
            }
            if(!accountFields.contains('Description')){
                accountFields.add('Description');
            }
            
            //get the account with fieldset plus standard fields
            String accountQuery  = 'SELECT Id,';
            accountQuery += String.join(accountFields,',');
            accountQuery +=' FROM Account WHERE Id =:AccountId';
            Account account =  Database.query(accountQuery);
            //make sure the phone and description have values
            account.Phone = '2105555555';
            account.Description = 'Before updating through the save method!';
            update account;
            //get the field permissions for phone and description
            List<FieldPermissions> accountPhoneFieldPerms = [SELECT SobjectType, Field, PermissionsRead, PermissionsEdit, 
                                 Parent.ProfileID FROM FieldPermissions 
                                 WHERE SobjectType = 'Account' AND (Field = 'Account.Phone' OR Field = 'Account.Description')
                                 AND Parent.ProfileId = :UserInfo.getProfileId()];
     
            //we should have returned permissions for the phone field on account
            System.assert(accountPhoneFieldPerms.isEmpty() != true, 'We are not finding any field permission for Account.Phone or Account.Description on the running users profile: ' + UserInfo.getProfileId());
            //remove edit access
            for (FieldPermissions perm : accountPhoneFieldPerms){                
                if(perm.Field == 'Phone'){
                    perm.PermissionsRead = true;
                    perm.PermissionsEdit = false;
                }else{
                    //should be the Description field.
                    perm.PermissionsRead = true;
                    perm.PermissionsEdit = true;
                }                
            }                        
            update accountPhoneFieldPerms;                                    

            Test.startTest();            
            objectCommunityProfileController.selectedTab ='organization';
            objectCommunityProfileController.userAccount = account;
            //update a known field to ensure update occurs
            account.Description = 'This is what it should be after we update it!';                                
            try{
                objectCommunityProfileController.save();
                
            } catch(Exception e){
                System.assert(false, 'An error should not have been thrown on save: ' +  e.getMessage() + '|| Type: ' + e.getTypeName());                                                
            }            
            Test.stopTest();        

            //query to ensure save not only succeeded but updated
            Account accountAfterSave =  Database.query(accountQuery);                               
            //assert that it was updated
            System.assertEquals('This is what it should be after we update it!', accountAfterSave.Description, 'The account description did not successfully update: ' + accountAfterSave.Description);
            

        }
        
    }

    static testMethod void saveTest(){
        User ObjectUser = [SELECT Id,AccountId,ContactId,FGM_Portal__ProfileType__c,FGM_Portal__UserProfile__c,LanguageLocaleKey FROM User WHERE Username = 'community@user1.com'];
        System.assert(ObjectUser != NULL);
        CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
        System.runAs(ObjectUser){
            Id contactId = [Select contactid from User where id =: Userinfo.getUserid()].contactId;
            Id AccountId  = [Select AccountID from Contact where id =: contactId].AccountId;
            List<Schema.FieldSetMember> lstFields = objectCommunityProfileController.getContactFields();
            List<String> lstContactField = NEW List<String>();
            for(Schema.FieldSetMember field:lstFields){
               lstContactField.add(field.getFieldPath());
            }
            String query = 'SELECT Id,';
            query += String.join(lstContactField,',');
            query+=',AccountId FROM Contact WHERE Id =:contactId';
            Contact contact =  Database.query(query);
            objectCommunityProfileController.selectedTab ='contact';
            objectCommunityProfileController.userContact = contact;
            objectCommunityProfileController.userContact = contact;
            objectCommunityProfileController.save();

            objectCommunityProfileController.userContact =contact;
            objectCommunityProfileController.save();

            List<Schema.FieldSetMember> lstAccountFields = objectCommunityProfileController.getAccountFields();
            List<String> lstAccountField = NEW List<String>();
            for(Schema.FieldSetMember field:lstAccountFields){
               lstAccountField.add(field.getFieldPath());
            }
            String accountQuery  = 'SELECT Id,';
            accountQuery += String.join(lstAccountField,',');
            accountQuery+=' FROM Account WHERE Id =:AccountId';
            Account account =  Database.query(accountQuery);
            objectCommunityProfileController.selectedTab ='organization';
            objectCommunityProfileController.userAccount = account;
            objectCommunityProfileController.save();

            objectCommunityProfileController.userAccount = account;
            objectCommunityProfileController.save();
        }
    }

    static testMethod void cancelTest(){
          CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
          system.assert(objectCommunityProfileController!=NULL);
          objectCommunityProfileController.selectedTab ='contact';
          objectCommunityProfileController.cancel();
          objectCommunityProfileController.selectedTab ='organization';
          objectCommunityProfileController.cancel();
          objectCommunityProfileController.userManagementTab();
    }

    static testMethod void updateUsers(){
       Map<Id,User> mapUser =NEW Map<Id,User>([SELECT Id,Name FROM User WHERE Id =:UserInfo.getUserId()]);
       system.assert(mapUser != NULL);
       CommunityProfileController.updateUsers(mapUser);
    }

    static testMethod void getUsersTest(){
        User ObjectUser = [SELECT Id,AccountId,ContactId,FGM_Portal__ProfileType__c,FGM_Portal__UserProfile__c,LanguageLocaleKey FROM User WHERE Username = 'community@user1.com'];
        system.runAs(ObjectUser){
            CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
            objectCommunityProfileController.currentUser = [SELECT Id,Name,AccountId FROM User WHERE Id =:UserInfo.getUserId()];
            system.assert(objectCommunityProfileController.currentUser!=NULL);
            objectCommunityProfileController.getUsers();
        }
    }
    static testMethod void initializeMapRequiredFieldsTest(){
          CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
          objectCommunityProfileController.isSCPLEnable = TRUE;
          objectCommunityProfileController.selectedTab = 'contact';
          objectCommunityProfileController.initializeMapRequiredFields();
          objectCommunityProfileController.selectedTab = 'organization';
          objectCommunityProfileController.initializeMapRequiredFields();
          system.assert(objectCommunityProfileController.mapRequiredField != NULL);
          objectCommunityProfileController.getJSONmapRequiredField();
    }

    static testMethod void getOrganizationInformationTest(){
         User ObjectUser = [SELECT Id,AccountId,ContactId,FGM_Portal__ProfileType__c,FGM_Portal__UserProfile__c,LanguageLocaleKey FROM User WHERE Username = 'community@user1.com'];
        system.runAs(ObjectUser){
            CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
            objectCommunityProfileController.getOrganizationInformation();
            system.assert(objectCommunityProfileController.userAccount != NULL);
        }
    }
      static testMethod void getContcatInformationTest(){
         User ObjectUser = [SELECT Id,AccountId,ContactId,FGM_Portal__ProfileType__c,FGM_Portal__UserProfile__c,LanguageLocaleKey FROM User WHERE Username = 'community@user1.com'];
        system.runAs(ObjectUser){
            CommunityProfileController objectCommunityProfileController = NEW CommunityProfileController();
            objectCommunityProfileController.getContcatInformation();
            system.assert(objectCommunityProfileController.userContact != NULL);
            objectCommunityProfileController.getEditMode();
        }
    }
}