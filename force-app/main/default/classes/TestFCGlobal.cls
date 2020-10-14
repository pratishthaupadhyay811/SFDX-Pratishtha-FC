@isTest
public class TestFCGlobal {

    public final static string RELATEDLISTCONTROLLER_PORTALTAB = 'Portal Tab';
    public final static string RELATEDLISTCONTROLLER_RELATEDLISTTAB = 'Related List With Tab';
    public final static string RELATEDLISTCONTROLLER_GRANTEEBUDGETTAB = 'Grantee Budget Tab';
    public final static string RELATEDLISTCONTROLLER_IFRAMETAB = 'IFrame Tab';
    public final static string RELATEDLISTCONTROLLER_CONTACTTAB = 'Contact Tab';
    public final static string RELATEDLISTCONTROLLER_ORGANIZATIONTAB = 'Organization Tab';
    public final static string RELATEDLISTCONTROLLER_CUSTOMPROFILETAB= 'Custom Profile Tab';
    public final static string QUESTION_RECORDFIELD = 'Record Field';

    public static List<FGM_Portal__Related_List_Controller__c> lstRelatedListController;
    public final static Map<String,Schema.Recordtypeinfo> relatedListControllerRecordTypeMap = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfosByName();
    public final static Map<String,Schema.Recordtypeinfo> newPortalQuestionRecordTypeMapByName = FGM_Portal__Questions__c.SObjectType.getDescribe().getRecordTypeInfosByName();


    static testMethod void FCGlobal()
    {
        Map<String,Schema.Recordtypeinfo> newRelatedListRecordTypeMapByName = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        Map<String,Schema.Recordtypeinfo> newPortalQuestionRecordTypeMapByName = FGM_Portal__Questions__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        account.FGM_Base__EIN__c = '123';
        Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

        Contact contact  = TestsObjectProvider.CreateContact('testContact1', 'testContact1', ResultAccount[0].Id, 'test@test1.com');
        contact.FGM_Portal__Confirm_Email__c = 'test@test1.com';
        contact.MailingStreet='baker';
        contact.MailingCity='NY';
        contact.MailingCountry='United States';
        contact.MailingState='New York';
        Database.SaveResult[] ResultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});
        User user1 = TestsObjectProvider.CreateUser( ResultContact[0].Id, 'test@test2.com', 'testUser2', 'testUser2', 'test1@osftest.com', true, 'Partner Community User', account.Name);
        user1.ProfileType__c = 'individual';
        user1.UserProfile__c = 'Grantee';
        Database.SaveResult[] ResultUser1 = TestsObjectProvider.InsertListWithAssert(new List<User>{user1});

        FGM_Portal__Quiz__c FGMPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz('PortalQuiz1', 'test@test1.com', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
        FGMPortalQuiz.FGM_Portal__IsCommunityRecord__c = true;
        Database.Saveresult[] ResultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{FGMPortalQuiz});

        List<FGM_Portal__Related_List_Controller__c> lstFGMPortaRelatedListControllerForTab = new List<FGM_Portal__Related_List_Controller__c>();
        lstFGMPortaRelatedListControllerForTab.add(TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListName4', 'Grantee', 'Dashboard', 'Opportunity', 'Opportunity', 'Opportunity', 'Matching or Challenge Support Formula,Duration in Years', 'Location_of_Sponsorship_Opportunity__c,Duration_in_Years__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortaRelatedListControllerForTab[0].FGM_Portal__IsCommunityRecord__c = true;
        Database.Saveresult[] ResultListControllerForTabs = TestsObjectProvider.InsertListWithAssert(lstFGMPortaRelatedListControllerForTab);

        FCGlobal.getPortalTriggerRecords();
        FCGlobal.getNewSobject('Opportunity');
        FCGlobal.getVFPageName('/_ui/common/apex/debug/ApexCSIPage');
        FCGlobal.getObjectNameById(account.Id);
        FCGlobal.getObjectLabelById(account.Id);
        FCGlobal.hasChildObject('Opportunity');
        FCGlobal.getRelationalField('Opportunity','Account');
        FCGlobal.assignPermissionSetToUser(Userinfo.getUserid());
        FCGlobal.checkSession();
        FCGlobal.getDateFormat();
        FCGlobal.getOrgLanguageMap();
        FCGlobal.getOrgLanguages();
        FCGlobal.NewGuid();
        FCGlobal.setUserLanguage(Userinfo.getUserid(), 'en_US');
        FCGlobal.validateUrl();
        Set<String> excludeFieldTypes = new Set<String>();
        excludeFieldTypes.add('FORMULA');
        excludeFieldTypes.add('REFERENCE');
        excludeFieldTypes.add('CURRENCY');
        excludeFieldTypes.add('DataCategoryGroupReference');
        excludeFieldTypes.add('Date');
        excludeFieldTypes.add('DateTime');
        excludeFieldTypes.add('Percent');
        excludeFieldTypes.add('Phone');
        excludeFieldTypes.add('BOOLEAN');
        FCGlobal.getsObjectFields('Opportunity',excludeFieldTypes);
        FCGlobal.getMapsObjectFields('Opportunity');
        FCGlobal.getRecordTypesById('Opportunity');
        FCGlobal.getrelatedListColumn(lstFGMPortaRelatedListControllerForTab[0]);
        FCGlobal.getCorrectHTML('< / ');
        ObjectDataTranslationController.getallTextFields('Opportunity');
        ObjectDataTranslationController.getallTextFieldDescribe('Opportunity');
        ObjectDataTranslationController.getLookUpRecords('Opportunity');
        ObjectDataTranslationController.getPortalLanguage();

        Campaign campaign = TestsObjectProvider.CreateCampaign('TestCampaign', 'test@test1.com', Date.today(), Date.today(), ResultFGMPortalQuiz[0].Id,'StageName:Submitted,FGM_Base__Duration_Months__c:5,FGM_Base__End_Date__c:8/3/2015,FGM_Base__Amount_Requested__c:100.20');
        Database.Saveresult[] Resultcampaign = TestsObjectProvider.InsertListWithAssert(new List<Campaign>{campaign});

        Opportunity opportunity = TestsObjectProvider.CreateOpportunity('testGranteeOpp', 'In Progress', Date.today());
        opportunity.OwnerId = user1.Id;
        opportunity.CampaignId = Resultcampaign[0].Id;
        opportunity.AccountId = ResultAccount[0].Id;
        insert opportunity;

        CommunityApplicationExtension.getAttachments(null,'FGM_Portal__Opportunity__c',opportunity.Id);
        CommunityApplicationExtension.getAttachmentComponentSettings(true,'','en_Us','42');
        CommunityApplicationExtension.getApplicationRecord('FGM_Portal__Opportunity__c',opportunity.Id);

        ContentVersion contentVersionToInsert = new ContentVersion();
        contentVersionToInsert.title = 'test content trigger';
        contentVersionToInsert.PathOnClient ='test';
        contentVersionToInsert.VersionData = Blob.valueOf('attachmentOne');
        insert contentVersionToInsert;
        system.assertNotEquals( contentVersionToInsert.Id, null );

        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :contentVersionToInsert.Id];

        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=opportunity.Id;
        contentlink.ShareType= 'I';
        contentlink.ContentDocumentId=testcontent.ContentDocumentId;

        ContentVersion contentVersionToInsert2 = new ContentVersion();
        contentVersionToInsert2.title = 'test content trigger';
        contentVersionToInsert2.PathOnClient ='test';
        contentVersionToInsert2.VersionData = Blob.valueOf('attachmentOne');
        insert contentVersionToInsert2;
        system.assertNotEquals( contentVersionToInsert2.Id, null );

        ContentVersion testContent1 = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :contentVersionToInsert2.Id];

        ContentDocumentLink contentlink2=new ContentDocumentLink();
        contentlink2.LinkedEntityId=opportunity.Id;
        contentlink2.ShareType= 'I';
        contentlink2.ContentDocumentId=testContent1.ContentDocumentId;

        List<FGM_Portal__Questions__c> lstFGMPortalQuestion = new List<FGM_Portal__Questions__c>();
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('SF Data Type', '', '', '', 'Salesforce Data Type', ResultFGMPortalQuiz[0].Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Attachment', '', '', '', 'Attachment', ResultFGMPortalQuiz[0].Id, 'Name+FileName', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Amount', '', '', '', 'Salesforce Data Type', ResultFGMPortalQuiz[0].Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        Database.Saveresult[] ResultFGMPortalQuestion = TestsObjectProvider.InsertListWithAssert(lstFGMPortalQuestion);

        FGM_Portal__Question_Attachment__c questionAttachment = new FGM_Portal__Question_Attachment__c();
        questionAttachment.FGM_Portal__Opportunity__c = opportunity.Id;
        questionAttachment.FGM_Portal__Question__c = ResultFGMPortalQuestion[1].Id;
        questionAttachment.FGM_Portal__Description__c = 'Test Description';
        Database.SaveResult svRslt = Database.insert(questionAttachment);

        FGM_Base__Grantee_Report__c FGMBaseGranteeReport = TestsObjectProvider.CreateFGMBaseGranteeReport(null, opportunity.Id, 'Received'); //newGranteeReportRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GRANTEEREPORT_NARRATIVEREPORT).getRecordTypeId()
        FGMBaseGranteeReport.FGM_Base__Display_Benchmark__c = true;
        Database.Saveresult[] ResultFGMBaseGranteeReport = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Grantee_Report__c>{FGMBaseGranteeReport});

        Attachment attachmentOne1 = new Attachment();
        attachmentOne1.Body = Blob.valueOf('attachmentOne');
        attachmentOne1.Name = 'attachmentOne';
        attachmentOne1.ParentId = questionAttachment.Id;
        insert attachmentOne1;
        List<Id> lst2 = new List<Id>();
        lst2.add(attachmentOne1.Id);
        system.assertNotEquals( attachmentOne1.Id, null );

        FeedItem FeedOne = new FeedItem();
        FeedOne.ParentId=questionAttachment.Id;
        FeedOne.Body='FeedattachmentOne';
        FeedOne.Title='test';
        insert FeedOne;


        Attachment attachmentOne2 = new Attachment();
        attachmentOne2.Body = Blob.valueOf('attachmentOne');
        attachmentOne2.Name = 'attachmentOne';
        attachmentOne2.ParentId = questionAttachment.Id;
        insert attachmentOne2;
        List<Id> lst3 = new List<Id>();
        lst3.add(attachmentOne2.Id);
        system.assertNotEquals( attachmentOne2.Id, null );

        FeedItem FeedOne1 = new FeedItem();
        FeedOne1.ParentId=questionAttachment.Id;
        FeedOne1.Body='FeedattachmentOne';
        FeedOne1.Title='test';
        insert FeedOne1;
        List<Id> lst4 = new List<Id>();
        lst4.add(FeedOne1.Id);

        FCRecordController.getAttachments(null,'FGM_Portal__GranteeReport__c',ResultFGMBaseGranteeReport[0].Id);
        FCRecordController.getAttachmentComponentSettings(true,'','en_Us','42');
        FCRecordController.getApplicationRecord('FGM_Portal__GranteeReport__c',ResultFGMBaseGranteeReport[0].Id);
        FCRecordController.insertAndUpdateContentDocumentLink(questionAttachment.Id, testContent1.ContentDocumentId, '', 'V');
        FCRecordController.deleteAttachments('ContentDocument',lst4 ,questionAttachment.id);

        CommunityApplicationExtension.getAttachments(null,'FGM_Portal__Opportunity__c',opportunity.Id);
        CommunityApplicationExtension.getAttachmentComponentSettings(true,'','en_Us','42');
        CommunityApplicationExtension.getApplicationRecord('FGM_Portal__Opportunity__c',opportunity.Id);
        CommunityApplicationExtension.insertAndUpdateContentDocumentLink(questionAttachment.Id, testcontent.ContentDocumentId, '', 'V');
        CommunityApplicationExtension.deleteAttachments('ContentDocument',lst2 ,questionAttachment.id);
        Set<String> setString = new Set<String>();
        setString.add('element');
        setString.add('element1');
        Set<Id> setIds =  new Set<Id>();
        setIds.add(opportunity.Id);
        List<String> lstString = new List<String>();
        lstString.addAll(setString);
        List<Id> lstId = new List<Id>();
        lstId.addAll(setIds);
        Engine.setToString(setString,true);
        Engine.setToString(setIds,true);
        Engine.listToString(lstString,true);
        Engine.listToString(lstId,true);
        Engine.getQuestionFields(FGMPortalQuiz.Id, 'Opportunity', 'en_US');
        Engine.getMapFromParameters('a,b', ',', ',');
        Engine.getContainsIgnoreCase( 'String', 'ring' );
        Engine.getCampaignLookupField( 'Opportunity' );
        Engine.constructSobject('[{"name":"Test"}]', 'Account');
        List<sObject> lstSObjects = new List<sObject>();
        Account acc1 = new Account ();
        acc1.Name= 'test1';
        Account acc2 = new Account ();
        acc2.Name= 'test2';
        lstSObjects.add(acc1);
        lstSObjects.add(acc2);
        Engine.insertListSObjects( lstSObjects );
        Engine.upsertListSObjects( lstSObjects, 'Account' );
        Engine.deleteListSObjects( lstSObjects );
        Engine.getDefaultOCR();
        Engine.getOTMPicklistEntries();
        Engine.getOCRPicklistEntries();


        FGM_Portal__Field_Value_Translation__c trnasData = new FGM_Portal__Field_Value_Translation__c();
        trnasData.FGM_Portal__RecordID__c = Resultcampaign[0].id;
        trnasData.FGM_Portal__Field_Name__c ='Name';
        trnasData.Name = 'Name';
        trnasData.FGM_Portal__Language__c='es';
        insert trnasData;
        ObjectDataTranslationController objtrans = new ObjectDataTranslationController();
        ObjectDataTranslationController.getOrgLanguageMap();
        ObjectDataTranslationController.getallTextFields( 'Campaign' );
        ObjectDataTranslationController.saveTranslationRecords('Campaign' ,trnasData.Id ,'[{"name":"Test"}]');
        ObjectDataTranslationController.getAllTranslations(Resultcampaign[0].id , 'Campaign');
        ObjectDataTranslationController.deleteTranslationRecord(trnasData.Id);
        Map<String,Schema.Recordtypeinfo> recordTypeName = FGM_Portal__GuidestarFieldMapping__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        FGM_Portal__GuidestarFieldMapping__c objGuidstarMapping = TestsObjectProvider.CreateFGMPortalGuidestarFieldMapping(recordTypeName.get(TestsObjectProvider.PORTAL_GUIDESTAR_GUIDECONTACT).getRecordTypeId(), 'strRegisteredName', 'strOrganization');
        Database.Saveresult[] ResultFGMPortalGuidstar = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__GuidestarFieldMapping__c>{objGuidstarMapping});
        FCGlobal.getGuideStarMappingMap(new List<String>{'Guidestar Contact','Guidestar Organization'});
        FCGlobal.getRecordTypeId('FGM_Portal__GuidestarFieldMapping__c', 'Guidestar Contact');
        FCGlobal.getRecordTypeName('FGM_Portal__GuidestarFieldMapping__c',recordTypeName.get(TestsObjectProvider.PORTAL_GUIDESTAR_GUIDECONTACT).getRecordTypeId());

        FGM_Portal__PortalConfiguration__c objePortalConfig = new FGM_Portal__PortalConfiguration__c();
        objePortalConfig.Name = 'Portal Configuration';
        objePortalConfig.FGM_Portal__LanguageSelection__c = 'en_US';
        insert objePortalConfig;
        FCGlobal.getPortalLanguage();

        Set<String> setFieldName = new Set<String>();
        setFieldName.add('Name');
        setFieldName.add('StageName');
        FCGlobal.getLanguageFields('Opportunity',setFieldName);
        FCGlobal.initilizeSession(UserInfo.getUserId());
        FCGlobal.getFieldLengthMap('Opportunity');
        FCGlobal.getApplicationOwnerRoleSet('TestRole1,TestRole2');

        FGM_Portal__GlobalPortalSettings__c globalSetting = new FGM_Portal__GlobalPortalSettings__c();
        globalSetting.FGM_Portal__Redirect_URL__c = 'profile1:/apex/Test;profile2:/apex/Test1';
        globalSetting.FGM_Portal__Grantee_Portal_Prefix__c = 'fcgrantee';
        globalSetting.FGM_Portal__Reviewer_Portal_Prefix__c = 'grantee';
        insert globalSetting;

        FCGlobal.getRedirectURL();
        List<Id> lstsObjectID = new List<Id>();
        lstsObjectID.add(Resultcampaign[0].id);
        Set<String> setFields = new Set<String>();
        setFields.add('Name');
        FCGlobal.getObjectTranslationMap(lstsObjectID,'es',setFields);
        FCGlobal.getUserSession(UserInfo.getUserId());
        FCGlobal.setUserPortalProfile(UserInfo.getUserId(),'Test Profile');
        FCGlobal.validateUrl();


        // Fetching record type info maps
        Map<String,Schema.Recordtypeinfo> newRelatedListRecordTypeMapByName2 = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        Map<String,Schema.Recordtypeinfo> newPortalQuestionRecordTypeMapByName2 = FGM_Portal__Questions__c.SObjectType.getDescribe().getRecordTypeInfosByName();

        // Questions
        List<FGM_Portal__Questions__c> lstFGMPortalQuestion1 = new List<FGM_Portal__Questions__c>();
        lstFGMPortalQuestion1.add(TestsObjectProvider.CreateFGMPortalQuestion('SF Data Type', '', '', '', 'Salesforce Data Type', ResultFGMPortalQuiz[0].Id, '', newPortalQuestionRecordTypeMapByName2.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        lstFGMPortalQuestion1.add(TestsObjectProvider.CreateFGMPortalQuestion('Attachment', '', '', '', 'Attachment', ResultFGMPortalQuiz[0].Id, 'Name+FileName', newPortalQuestionRecordTypeMapByName2.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        lstFGMPortalQuestion1.add(TestsObjectProvider.CreateFGMPortalQuestion('Amount', '', '', '', 'Salesforce Data Type', ResultFGMPortalQuiz[0].Id, '', newPortalQuestionRecordTypeMapByName2.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        Database.Saveresult[] ResultFGMPortalQuestion1 = TestsObjectProvider.InsertListWithAssert(lstFGMPortalQuestion1);

        // Related List Controllers
        List<FGM_Portal__Related_List_Controller__c> lstFGMPortaRelatedListControllerForTab1 = new List<FGM_Portal__Related_List_Controller__c>();
        lstFGMPortaRelatedListControllerForTab1.add(TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListName4', 'Grantee', 'Dashboard', 'Opportunity', 'Opportunity', 'Opportunity', 'Matching or Challenge Support Formula,Duration in Years', 'Location_of_Sponsorship_Opportunity__c,Duration_in_Years__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortaRelatedListControllerForTab1[0].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortaRelatedListControllerForTab1.add(TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListName5', 'Grantee', 'Dashboard', 'OpportunityTeamMember', 'Opportunity', 'OpportunityId', 'Role', 'TeamMemberRole', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortaRelatedListControllerForTab1[1].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortaRelatedListControllerForTab1.add(TestsObjectProvider.CreateFGMPortalRelatedListController('Budget Details', 'Grantee', 'Dashboard', 'FGM_Portal__Grantee_Budget_Configuration', 'Opportunity', 'FGM_Portal__Grantee_Budget_Configuration', 'Matching or Challenge Support Formula,Duration in Years', 'Location_of_Sponsorship_Opportunity__c,Duration_in_Years__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_GRANTEEBUDGETTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortaRelatedListControllerForTab1[2].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortaRelatedListControllerForTab1.add(TestsObjectProvider.CreateFGMPortalRelatedListController('iFrame Tab', 'Grantee', 'Dashboard', 'none', 'Opportunity', 'none', 'test, field, headers', 'test, field, columns', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_IFRAMETAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortaRelatedListControllerForTab1[3].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortaRelatedListControllerForTab1[3].FGM_Portal__BaseUrl__c = 'https://test/DynamicIFrameTest?id={Opportunity.ID}&StageName={OPPORTUNITY.StageName1}&NAME={OPPORTUNITY.name}';
        lstFGMPortaRelatedListControllerForTab1.add(TestsObjectProvider.CreateFGMPortalRelatedListController('Contact Tab', 'Grantee', 'Dashboard', 'none', 'Opportunity', 'none', 'test, field, headers', 'test, field, columns', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_CONTACTTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortaRelatedListControllerForTab1[4].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortaRelatedListControllerForTab1.add(TestsObjectProvider.CreateFGMPortalRelatedListController('Org Tab', 'Grantee', 'Dashboard', 'none', 'Opportunity', 'none', 'test, field, headers', 'test, field, columns', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_ORGANIZATIONTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortaRelatedListControllerForTab1[5].FGM_Portal__IsCommunityRecord__c = true;
        Database.Saveresult[] ResultListControllerForTabs1 = TestsObjectProvider.InsertListWithAssert(lstFGMPortaRelatedListControllerForTab1);
        Database.Saveresult ResultListControllerForTabId1 = ResultListControllerForTabs1[0];

        List<FGM_Portal__Quiz_Questions__c> lstFGMPortalQuizQuestion = new List<FGM_Portal__Quiz_Questions__c>();
        FGM_Portal__Quiz_Questions__c quizQuestion = TestsObjectProvider.CreateFGMPortalQuizQuestion(ResultFGMPortalQuestion1[0].Id, 1, 'Name', '', 50, '1', ResultListControllerForTabId1.Id, false, ResultFGMPortalQuiz[0].Id);
        quizQuestion.FGM_Portal__Can_upload_after_submission__c = true;
        lstFGMPortalQuizQuestion.add(quizQuestion);
        lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(ResultFGMPortalQuestion1[1].Id, 1, 'Name', '', 50, '1', ResultListControllerForTabId1.Id, true, ResultFGMPortalQuiz[0].Id));
        lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(ResultFGMPortalQuestion1[2].Id, 1, 'Name', '', 50, '1', ResultListControllerForTabId1.Id, true, ResultFGMPortalQuiz[0].Id));
        Database.Saveresult[] ResultsFGMPortalQuizQuestion = TestsObjectProvider.InsertListWithAssert(lstFGMPortalQuizQuestion);
        lstFGMPortaRelatedListControllerForTab[0].Quiz_Questions__r.addAll(lstFGMPortalQuizQuestion);

        List<FGM_Portal__Quiz_Questions__c> lstQues = [SELECT Id, Name, FGM_Portal__Question__c, FGM_Portal__Quiz__c, FGM_Portal__Tab__c FROM FGM_Portal__Quiz_Questions__c];
        FCGlobal.getQuestionAndTabID(lstQues);


        FCGlobal.CloneQuestion(lstFGMPortalQuestion1,ResultFGMPortalQuiz[0].Id,'fr');
        FCGlobal.CloneTabRecord(lstFGMPortaRelatedListControllerForTab1,ResultFGMPortalQuiz[0].Id,'fr');

        FCGlobal.WithoutSharing objFCGlobal = new FCGlobal.WithoutSharing();
        objFCGlobal.getUserResult(new List<String>{UserInfo.getUserName()});
        Account acc = new Account();
        acc.Name = 'Test Account';
        Account account4 = new Account();
        account4.Name = 'Test Account12';
        List<SObject> lstAc1 = new List<SObject>();
        lstAc1.add(account4);
        objFCGlobal.executeInsert(lstAc1);
        FCGlobal.getCampaign (campaign.Id);

        TestsObjectProvider.CreateTask(account4.Id, 'strSubject', System.today(), 'progress');
        TestsObjectProvider.CreateFGMPortalAccount(account4.Id,'Portal Account Name');
        TestsObjectProvider.CreateFGMPortalUser(account4.Id, 'strName', 'strLastName', 'test@gmail.com', 'test@gmail.com', 'test@gmail.com', 'strPassword', 'strPassword', true);
        FCGlobal.cloneQuiz(ResultFGMPortalQuiz[0].Id,'Cloned Quiz');
        objFCGlobal.getRegContacts('TestAccount1','123','test@test1.com');

        TestsObjectProvider.CreateDocument('Test');
        TestsObjectProvider.CreateLead('strFirstName', 'strLastName', 'strCompany', 'In Progress');
        TestsObjectProvider.CreateFGMPortalTriggers();
        TestsObjectProvider.CreateFGMPortalPortalConfiguration('strName', 'strGranteeReportEditable', true, true, 'strAmendmentName', 'strBenchmarkName', true, 'strGranteeInboxTab', 'strGranteeReportName', 'en_us', 'strRequestHistoryTab', 'strRequestName', 'strRequestEditableStatus', 'strInquiryName', 'strInquiryHistoryTab', 'strInquiryEditableStatus');
        TestsObjectProvider.CreateFGMPortalCustomHTML('strName', 'strPortalType', 'en_Us', 'strPortalLocation', 'strDescription');
    }
    @testSetup static void testSetup() {
        try{
            FGM_Portal__Quiz__c PortalQuiz = new FGM_Portal__Quiz__c();
            PortalQuiz.Name = 'TestQuiz 1';
            PortalQuiz.FGM_Portal__Introduction_Text__c ='testQuiz 1';
            PortalQuiz.FGM_Portal__Is_Active__c = TRUE;
            PortalQuiz.FGM_Portal__IsCommunityRecord__c = TRUE;

            insert PortalQuiz;

            List<FGM_Portal__Related_List_Controller__c>  lstRelatedListController= new  List<FGM_Portal__Related_List_Controller__c>();
            FGM_Portal__Related_List_Controller__c PortalTab =new FGM_Portal__Related_List_Controller__c();
            PortalTab.Name = 'Portal Tab';
            PortalTab.FGM_Portal__Language__c = 'en_US';
            PortalTab.FGM_Portal__IsCommunityRecord__c = true;
            PortalTab.FGM_Portal__Quiz__c = PortalQuiz.Id;
            PortalTab.FGM_Portal__ObjectName__c = 'Opportunity';
            PortalTab.FGM_Portal__ParentObject__c ='Opportunity';
            PortalTab.FGM_Portal__LookupField__c ='Opportunity';
            PortalTab.FGM_Portal__SortOrder__c = 1;
            PortalTab.RecordTypeId = relatedListControllerRecordTypeMap.get(RELATEDLISTCONTROLLER_PORTALTAB).getRecordTypeId();
            lstRelatedListController.add(PortalTab);

            FGM_Portal__Related_List_Controller__c RelatedListTab =new FGM_Portal__Related_List_Controller__c();
            RelatedListTab.Name = 'Related List Tab';
            RelatedListTab.FGM_Portal__Language__c = 'en_US';
            RelatedListTab.FGM_Portal__IsCommunityRecord__c = true;
            RelatedListTab.FGM_Portal__Quiz__c = PortalQuiz.Id;
            RelatedListTab.FGM_Portal__ObjectName__c = 'Opportunity';
            RelatedListTab.FGM_Portal__ParentObject__c ='Opportunity';
            RelatedListTab.FGM_Portal__LookupField__c ='Opportunity';
            RelatedListTab.FGM_Portal__SortOrder__c = 2;
            RelatedListTab.RecordTypeId = relatedListControllerRecordTypeMap.get(RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId();
            lstRelatedListController.add(RelatedListTab);

            FGM_Portal__Related_List_Controller__c iFrameTab =new FGM_Portal__Related_List_Controller__c();
            iFrameTab.Name = 'IFrame';
            iFrameTab.FGM_Portal__Language__c = 'en_US';
            iFrameTab.FGM_Portal__IsCommunityRecord__c = true;
            iFrameTab.FGM_Portal__Quiz__c = PortalQuiz.Id;
            iFrameTab.FGM_Portal__ParentObject__c ='Opportunity';
            iFrameTab.FGM_Portal__BaseUrl__c = '';
            iFrameTab.FGM_Portal__SortOrder__c = 3;
            iFrameTab.RecordTypeId = relatedListControllerRecordTypeMap.get(RELATEDLISTCONTROLLER_IFRAMETAB).getRecordTypeId();
            lstRelatedListController.add(iFrameTab);

            FGM_Portal__Related_List_Controller__c contactTab =new FGM_Portal__Related_List_Controller__c();
            contactTab.Name = 'Contact Tab';
            contactTab.FGM_Portal__Language__c = 'en_US';
            contactTab.FGM_Portal__IsCommunityRecord__c = true;
            contactTab.FGM_Portal__Quiz__c = PortalQuiz.Id;
            contactTab.FGM_Portal__ObjectName__c = 'Opportunity';
            contactTab.FGM_Portal__ParentObject__c ='Opportunity';
            contactTab.FGM_Portal__LookupField__c ='Opportunity';
            contactTab.FGM_Portal__SortOrder__c = 4;
            contactTab.RecordTypeId = relatedListControllerRecordTypeMap.get(RELATEDLISTCONTROLLER_CONTACTTAB).getRecordTypeId();
            lstRelatedListController.add(contactTab);

            FGM_Portal__Related_List_Controller__c organizationTab =new FGM_Portal__Related_List_Controller__c();
            organizationTab.Name = 'organization Tab';
            organizationTab.FGM_Portal__Language__c = 'en_US';
            organizationTab.FGM_Portal__IsCommunityRecord__c = true;
            organizationTab.FGM_Portal__Quiz__c = PortalQuiz.Id;
            organizationTab.FGM_Portal__ObjectName__c = 'Opportunity';
            organizationTab.FGM_Portal__ParentObject__c ='Opportunity';
            organizationTab.FGM_Portal__LookupField__c ='Opportunity';
            organizationTab.FGM_Portal__SortOrder__c = 5;
            organizationTab.RecordTypeId = relatedListControllerRecordTypeMap.get(RELATEDLISTCONTROLLER_ORGANIZATIONTAB).getRecordTypeId();
            lstRelatedListController.add(organizationTab);

            FGM_Portal__Related_List_Controller__c granteeBudgetTab =new FGM_Portal__Related_List_Controller__c();
            granteeBudgetTab.Name = 'Grantee Budget Tab';
            granteeBudgetTab.FGM_Portal__Language__c = 'en_US';
            granteeBudgetTab.FGM_Portal__IsCommunityRecord__c = true;
            granteeBudgetTab.FGM_Portal__Quiz__c = PortalQuiz.Id;
            granteeBudgetTab.FGM_Portal__ObjectName__c = 'FGM_Portal__Grantee_Budget__c';
            granteeBudgetTab.FGM_Portal__ParentObject__c ='Quiz__c';
            granteeBudgetTab.FGM_Portal__LookupField__c ='FGM_Portal__Grantee_Budget__c';
            granteeBudgetTab.FGM_Portal__SortOrder__c = 6;
            granteeBudgetTab.RecordTypeId = relatedListControllerRecordTypeMap.get(RELATEDLISTCONTROLLER_GRANTEEBUDGETTAB).getRecordTypeId();
            lstRelatedListController.add(granteeBudgetTab);

            FGM_Portal__Related_List_Controller__c profileTab =new FGM_Portal__Related_List_Controller__c();
            profileTab.Name = 'Profile Tab';
            profileTab.FGM_Portal__Language__c = 'en_US';
            profileTab.FGM_Portal__IsCommunityRecord__c = true;
            profileTab.FGM_Portal__Quiz__c = PortalQuiz.Id;
            profileTab.FGM_Portal__ObjectName__c = 'FGM_Base__Payment__c';
            profileTab.FGM_Portal__ParentObject__c ='Account';
            profileTab.FGM_Portal__LookupField__c ='FGM_Base__Payee__c';
            profileTab.FGM_Portal__FieldHeaders__c = 'Payment,Amount,Phone';
            profileTab.FGM_Portal__FieldNames__c ='Name,FGM_Base__Amount__c,FGM_Base__Phone__c';
            profileTab.FGM_Portal__SortOrder__c = 7;
            profileTab.RecordTypeId = relatedListControllerRecordTypeMap.get(RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId();
            lstRelatedListController.add(profileTab);

            Database.Saveresult[] resultsFGMPortalRelatedListController =  Database.insert(lstRelatedListController,false);

            List<FGM_Portal__Grantee_Budget_Category__c> lstCategory = new List<FGM_Portal__Grantee_Budget_Category__c>();
            FGM_Portal__Grantee_Budget_Category__c category1 = new FGM_Portal__Grantee_Budget_Category__c();
            category1.Name ='Admin';
            category1.FGM_Portal__Parent_Category__c = null;
            category1.FGM_Portal__IsActive__c=true;
            lstCategory.add(category1);

            FGM_Portal__Grantee_Budget_Category__c category2 = new FGM_Portal__Grantee_Budget_Category__c();
            category2.Name ='System Admin';
            category2.FGM_Portal__Parent_Category__c =  category1.Id;
            category2.FGM_Portal__IsActive__c=true;
            lstCategory.add(category2);

            FGM_Portal__Grantee_Budget_Category__c category3 = new FGM_Portal__Grantee_Budget_Category__c();
            category3.Name = 'Network Admin';
            category3.FGM_Portal__Parent_Category__c =  category1.Id;
            category3.FGM_Portal__IsActive__c=true;
            lstCategory.add(category3);

            FGM_Portal__Grantee_Budget_Category__c category4 = new FGM_Portal__Grantee_Budget_Category__c();
            category4.Name = 'Developer1';
            category4.FGM_Portal__Parent_Category__c = null;
            category4.FGM_Portal__IsActive__c=true;
            lstCategory.add(category4);

            FGM_Portal__Grantee_Budget_Category__c category5 = new FGM_Portal__Grantee_Budget_Category__c();
            category5.Name ='Developer2';
            category5.FGM_Portal__Parent_Category__c = null;
            category5.FGM_Portal__IsActive__c=true;
            lstCategory.add(category5);

            FGM_Portal__Grantee_Budget_Category__c category6 = new FGM_Portal__Grantee_Budget_Category__c();
            category6.Name ='Developer3';
            category6.FGM_Portal__Parent_Category__c = null;
            category6.FGM_Portal__IsActive__c=true;
            lstCategory.add(category6);

            Database.Saveresult[] resultLstCategory = Database.insert(lstCategory);

            List <FGM_Portal__Grantee_Budget_Configuration__c> objGranteeBudgetConfiguration = new List <FGM_Portal__Grantee_Budget_Configuration__c>();
            List <FGM_Portal__Grantee_Budget_Category__c> lstBudgetCategories = [SELECT Id FROM FGM_Portal__Grantee_Budget_Category__c];
            for(integer index = 0;index < lstBudgetCategories.size(); index++)
            {
                FGM_Portal__Grantee_Budget_Configuration__c GranteeBudgetConfiguration =new FGM_Portal__Grantee_Budget_Configuration__c();
                objGranteeBudgetConfiguration.add(GranteeBudgetConfiguration);
                objGranteeBudgetConfiguration[index].FGM_Portal__Quiz__c = PortalQuiz.Id;
                objGranteeBudgetConfiguration[index].FGM_Portal__Related_List_Controller__c = resultsFGMPortalRelatedListController[5].getId();
                objGranteeBudgetConfiguration[index].FGM_Portal__Category__c =lstBudgetCategories[index].Id;
            }
            insert objGranteeBudgetConfiguration;
            FGM_Portal__Related_List_Controller__c objRelatedListController = new   FGM_Portal__Related_List_Controller__c();
            objRelatedListController.Name='CUSTOM PROFILE TAB-PAYMENT';
            objRelatedListController.FGM_Portal__Language__c = 'en_US';
            objRelatedListController.FGM_Portal__IsCommunityRecord__c = true;
            objRelatedListController.FGM_Portal__Quiz__c = PortalQuiz.Id;
            objRelatedListController.FGM_Portal__ObjectName__c = 'FGM_Base__Payment__c';
            objRelatedListController.FGM_Portal__ParentObject__c ='Account';
            objRelatedListController.FGM_Portal__LookupField__c ='FGM_Base__Payee__c';
            objRelatedListController.FGM_Portal__Cloned_from__c = resultsFGMPortalRelatedListController[6].getId();
            objRelatedListController.RecordTypeId = relatedListControllerRecordTypeMap.get(RELATEDLISTCONTROLLER_CUSTOMPROFILETAB).getRecordTypeId();

            List<FGM_Portal__Questions__c> lstPortalQuestion = new  List<FGM_Portal__Questions__c>();
            FGM_Portal__Questions__c portalQuestion1 = NEW FGM_Portal__Questions__c();
            portalQuestion1.FGM_Portal__RichQuestion__c = 'Name';
            portalQuestion1.FGM_Portal__RichPreText__c = 'strPreText';
            portalQuestion1.FGM_Portal__RichPostText__c = 'strPostText';
            portalQuestion1.FGM_Portal__Help_Tip__c = 'strHelpTip';
            portalQuestion1.FGM_Portal__Type__c = 'Salesforce Data Type';
            portalQuestion1.FGM_Portal__Quiz__c = PortalQuiz.Id;
            portalQuestion1.RecordTypeId = newPortalQuestionRecordTypeMapByName.get(QUESTION_RECORDFIELD).getRecordTypeId();
            lstPortalQuestion.add(portalQuestion1);

            FGM_Portal__Questions__c portalQuestion2 = NEW FGM_Portal__Questions__c();
            portalQuestion2.FGM_Portal__RichQuestion__c = 'Instruction';
            portalQuestion2.FGM_Portal__RichPreText__c = 'strPreText';
            portalQuestion2.FGM_Portal__RichPostText__c = 'strPostText';
            portalQuestion2.FGM_Portal__Help_Tip__c = 'strHelpTip';
            portalQuestion2.FGM_Portal__Type__c = 'Instruction';
            portalQuestion2.FGM_Portal__Quiz__c = PortalQuiz.Id;
            portalQuestion2.RecordTypeId = newPortalQuestionRecordTypeMapByName.get(QUESTION_RECORDFIELD).getRecordTypeId();
            lstPortalQuestion.add(portalQuestion2) ;

            FGM_Portal__Questions__c portalQuestion3 = NEW FGM_Portal__Questions__c();
            portalQuestion3.FGM_Portal__RichQuestion__c = 'Attachment';
            portalQuestion3.FGM_Portal__RichPreText__c = 'strPreText';
            portalQuestion3.FGM_Portal__RichPostText__c = 'strPostText';
            portalQuestion3.FGM_Portal__Help_Tip__c = 'strHelpTip';
            portalQuestion3.FGM_Portal__Type__c = 'Attachment';
            portalQuestion3.FGM_Portal__Quiz__c = PortalQuiz.Id;
            portalQuestion3.RecordTypeId = newPortalQuestionRecordTypeMapByName.get(QUESTION_RECORDFIELD).getRecordTypeId();
            lstPortalQuestion.add(portalQuestion3);
            Database.Saveresult[] resultsFGMPortalQuestion = Database.insert(lstPortalQuestion);

            List<FGM_Portal__Quiz_Questions__c> lstfGMPortalQuizQuestion = new List<FGM_Portal__Quiz_Questions__c>();
            FGM_Portal__Quiz_Questions__c objQuizQuestion1 = NEW FGM_Portal__Quiz_Questions__c();
            objQuizQuestion1.FGM_Portal__Question__c = resultsFGMPortalQuestion[0].Id;
            objQuizQuestion1.FGM_Portal__Sort_Order__c = 1;
            objQuizQuestion1.FGM_Portal__Field__c = 'Name';
            objQuizQuestion1.FGM_Portal__Required__c = false;
            objQuizQuestion1.FGM_Portal__Tab__c = resultsFGMPortalRelatedListController[0].Id;
            objQuizQuestion1.FGM_Portal__Quiz__c = PortalQuiz.Id;
            lstfGMPortalQuizQuestion.add(objQuizQuestion1);

            FGM_Portal__Quiz_Questions__c objQuizQuestion2 = NEW FGM_Portal__Quiz_Questions__c();
            objQuizQuestion2.FGM_Portal__Question__c = resultsFGMPortalQuestion[1].Id;
            objQuizQuestion2.FGM_Portal__Sort_Order__c = 1;
            objQuizQuestion2.FGM_Portal__Required__c = false;
            objQuizQuestion2.FGM_Portal__Tab__c = resultsFGMPortalRelatedListController[0].Id;
            objQuizQuestion2.FGM_Portal__Quiz__c = PortalQuiz.Id;
            lstfGMPortalQuizQuestion.add(objQuizQuestion2);

            FGM_Portal__Quiz_Questions__c objQuizQuestion3 = NEW FGM_Portal__Quiz_Questions__c();
            objQuizQuestion3.FGM_Portal__Question__c = resultsFGMPortalQuestion[2].Id;
            objQuizQuestion3.FGM_Portal__Sort_Order__c = 1;
            objQuizQuestion3.FGM_Portal__Required__c = false;
            objQuizQuestion3.FGM_Portal__Tab__c = resultsFGMPortalRelatedListController[0].Id;
            objQuizQuestion3.FGM_Portal__Quiz__c = PortalQuiz.Id;
            lstfGMPortalQuizQuestion.add(objQuizQuestion3);
            Database.Saveresult[] portalQuizQuestion = Database.insert(lstfGMPortalQuizQuestion);

            List<FGM_Portal__Quiz__c> quiz = new List<FGM_Portal__Quiz__c>();
            FGM_Portal__Quiz__c quiz1 = new FGM_Portal__Quiz__c();
            quiz1.Name='test quiz1';
            quiz1.FGM_Portal__IsCommunityRecord__c=true;
            quiz1.FGM_Portal__Is_Active__c=true;
            quiz.add(quiz1);
            FGM_Portal__Quiz__c quiz2 = new FGM_Portal__Quiz__c();
            quiz2.Name='test quiz2';
            quiz2.FGM_Portal__IsCommunityRecord__c=true;
            quiz2.FGM_Portal__Is_Active__c=true;
            quiz.add(quiz2);
            Engine.create(quiz);
            Engine.remove(quiz[0]);

        }
        catch(Exception e)
        {
            system.debug('exception ...:::'+e.getMessage()+' '+e.getLineNumber());
        }
    }

    @isTest static void addTranslationFoValidDataTest() {
        FGM_Portal__Quiz__c  quiz =[SELECT Id,Name FROM FGM_Portal__Quiz__c limit 1];
        string result = FCGlobal.addTranslation('en_US',quiz.Id,quiz.Name,FALSE);
        System.assertEquals('en_US',result);
    }
    @isTest static void insertQuizTest(){
        Id id = FCGlobal.insertQuiz('New Quiz');
        System.assertNotEquals(id, null);
    }

    @isTest
    private static void testGetRelationalFieldWorksWithSObjectTypeTokens() {
        // The Question_Attachment__c object has a lookup to the Amendment__c object via the Amendment__c field.

        String relationalField = FCGlobal.getRelationalField(
            Amendment__c.sObjectType,
            Question_Attachment__c.sObjectType
        );

        System.assertEquals('FGM_Portal__Amendment__c', relationalField);
    }

    @isTest
    private static void testGetRelationalFieldWorksWithStringChildObject() {
        // The Question_Attachment__c object has a lookup to the Amendment__c object via the Amendment__c field.

        String relationalField = FCGlobal.getRelationalField(
            Amendment__c.sObjectType,
            String.valueOf(Question_Attachment__c.sObjectType)
        );

        System.assertEquals('FGM_Portal__Amendment__c', relationalField);
    }

    @isTest
    private static void testGetRelationalFieldWorksWithStringParentObject() {
        // The Question_Attachment__c object has a lookup to the Amendment__c object via the Amendment__c field.

        String relationalField = FCGlobal.getRelationalField(
            String.valueOf(Amendment__c.sObjectType),
            Question_Attachment__c.sObjectType
        );

        System.assertEquals('FGM_Portal__Amendment__c', relationalField);
    }

    @isTest
    private static void testGetRelationalFieldWorksWithStringNamespacePrefixedChildObject() {
        // The Question_Attachment__c object has a lookup to the Amendment__c object via the Amendment__c field.

        // note this adds reliance on namespace prefix, and this test will begin to fail if run in environments without the FGM_Portal namespace prefix
        String relationalField = FCGlobal.getRelationalField(
            Amendment__c.sObjectType,
            'FGM_Portal__Question_Attachment__c'
        );

        System.assertEquals('FGM_Portal__Amendment__c', relationalField);
    }

    @isTest
    private static void testGetRelationalFieldWorksWithStringNamespacePrefixedParentObject() {
        // The Question_Attachment__c object has a lookup to the Amendment__c object via the Amendment__c field.

        // note this adds reliance on namespace prefix, and this test will begin to fail if run in environments without the FGM_Portal namespace prefix
        String relationalField = FCGlobal.getRelationalField(
            'FGM_Portal__Amendment__c',
            Question_Attachment__c.sObjectType
        );

        System.assertEquals('FGM_Portal__Amendment__c', relationalField);
    }
}