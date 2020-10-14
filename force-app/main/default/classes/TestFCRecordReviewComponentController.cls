@isTest
private class TestFCRecordReviewComponentController{
    static testMethod void FCRecordReviewComponentController(){
        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

        Contact contact = TestsObjectProvider.CreateContact('testContact1', 'testContact1', ResultAccount[0].Id, 'test@test1.com');
        Database.SaveResult[] ResultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});

        List<FGM_Portal__Portal_User__c> lstPortalUser = new List<FGM_Portal__Portal_User__c>();
        lstPortalUser.add(TestSObjectProvider.CreateFGMPortalUser(null, 'test@osf-communities-developer-edition.na17.force.com', 'Portal LastName', 'test@test1.com', 'test@test1.com', 'test@osf-communities-developer-edition.na17.force.com', 'Test1234', 'Test1234', true));
        Database.Saveresult[] ResultFGMPortalUser = TestsObjectProvider.InsertListWithAssert(lstPortalUser);

        FGM_Portal__Quiz__c FGMPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz('PortalQuiz1', 'test@test1.com', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
        Database.Saveresult[] ResultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{FGMPortalQuiz});

        Campaign campaign = TestsObjectProvider.CreateCampaign('TestCampaign', 'test@test1.com', Date.today(), Date.today(), ResultFGMPortalQuiz[0].Id,null);
        Database.Saveresult[] Resultcampaign = TestsObjectProvider.InsertListWithAssert(new List<Campaign>{campaign});

        Map<String,Schema.Recordtypeinfo> newRelatedListRecordTypeMapByName = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        List<FGM_Portal__Related_List_Controller__c> lstFGMPortalRelatedListController = new List<FGM_Portal__Related_List_Controller__c>();
        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListName', 'Grantee', 'Details', 'Opportunity', 'Opportunity', 'Opportunity', 'Name,Stage,LastModfied Date', 'Name,StageName,LastModifiedDate', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListName1', 'Reviewer', 'Details', 'Amendment__c', 'Quiz__c', 'Account__c', 'Field To Be Edited', 'Field_To_Be_Edited__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListName1', 'Reviewer', 'Details', 'Amendment__c', 'Lead', 'Account__c', 'Field To Be Edited', 'Field_To_Be_Edited__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        Database.Saveresult[] ResultsFGMPortalRelatedListController = TestsObjectProvider.InsertListWithAssert(lstFGMPortalRelatedListController);

        Map<String,Schema.Recordtypeinfo> newPortalQuestionRecordTypeMapByName = FGM_Portal__Questions__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        FGM_Portal__Questions__c FGMPortalQuestion = TestsObjectProvider.CreateFGMPortalQuestion('Amount', '', '', '', 'Attachment', ResultFGMPortalQuiz[0].Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId());
        Database.Saveresult[] ResultFGMPortalQuestion = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Questions__c>{FGMPortalQuestion});

        List<FGM_Portal__Quiz_Questions__c> lstFGMPortalQuizQuestion = new List<FGM_Portal__Quiz_Questions__c>();
        lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(ResultFGMPortalQuestion[0].Id, 1, 'Name', '', 50, '1', ResultsFGMPortalRelatedListController[0].Id, true, ResultFGMPortalQuiz[0].Id));
        Database.Saveresult[] ResultsFGMPortalQuizQuestion = TestsObjectProvider.InsertListWithAssert(lstFGMPortalQuizQuestion);

        Opportunity opportunity = TestsObjectProvider.CreateOpportunity('testOpp', 'In Progress', Date.today());
        opportunity.CampaignId = Resultcampaign[0].Id;
        Database.Saveresult[] ResultOpportunity = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunity});

        Map<String,Schema.Recordtypeinfo> newGranteeReportRecordTypeMapByName = FGM_Base__Grantee_Report__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        FGM_Base__Grantee_Report__c FGMBaseGranteeReport = TestsObjectProvider.CreateFGMBaseGranteeReport(null, ResultOpportunity[0].Id, 'Received'); //newGranteeReportRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GRANTEEREPORT_NARRATIVEREPORT).getRecordTypeId()
        Database.Saveresult[] ResultFGMBaseGranteeReport = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Grantee_Report__c>{FGMBaseGranteeReport});

        Attachment attachment = TestsObjectProvider.CreateAttachment('Attachment1', ResultFGMPortalQuestion[0].Id);
        Database.Saveresult[] ResultAttachment = TestsObjectProvider.InsertListWithAssert(new List<Attachment>{attachment});

        List<FCPageLayout__c> lstFCPageLayout = new List<FCPageLayout__c>();
        lstFCPageLayout.add(TestsObjectProvider.CreateFCPageLayout('PageLayoutGrantee1', null, 'FGM_Base__Grantee_Report__c', ResultFGMPortalQuiz[0].Id)); //newGranteeReportRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GRANTEEREPORT_NARRATIVEREPORT).getRecordTypeId()
        Database.Saveresult[] ResultsFCPageLayout = TestsObjectProvider.InsertListWithAssert(lstFCPageLayout);

        FCRecordReviewComponentController setFCRecordReviewComponentController = new FCRecordReviewComponentController();
        setFCRecordReviewComponentController.appId = ResultOpportunity[0].Id;

        Question_Attachment__c QuestionAttachment = TestsObjectProvider.CreateQuestionAttachment(ResultFGMPortalQuestion[0].Id, ResultOpportunity[0].Id, null, ResultFGMBaseGranteeReport[0].Id);
        Database.Saveresult[] ResultQuestionAttachment = TestsObjectProvider.InsertListWithAssert(new List<Question_Attachment__c>{QuestionAttachment});

        Attachment attachmentQuestion = TestsObjectProvider.CreateAttachment('Attachment2', ResultQuestionAttachment[0].Id);
        Database.Saveresult[] ResultAttachmentQuestion = TestsObjectProvider.InsertListWithAssert(new List<Attachment>{attachmentQuestion});

        FCRecordReviewComponentController setFCRecordReviewComponentController1 = new FCRecordReviewComponentController();
        setFCRecordReviewComponentController1.appId = ResultOpportunity[0].Id;
    }
}