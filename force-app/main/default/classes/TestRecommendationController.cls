@isTest
private class TestRecommendationController {

    @testSetup static void testSetup() {

        Map<String,Schema.Recordtypeinfo> mapPortalQuizRecordType = FGM_Portal__Quiz__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        Map<String,Schema.Recordtypeinfo> mapRelatedListControllerRecordType = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfosByName();

        FGM_Portal__Quiz__c fGMPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz('ApplicationQuiz 1', 'test@test.com', '', '', '', '', '', 'Introduction', true);
        fGMPortalQuiz.FGM_Portal__IsCommunityRecord__c = true;
        fGMPortalQuiz.RecordTypeId = mapPortalQuizRecordType.get(TestsObjectProvider.PORTAL_QUIZ_APPLICATION).getRecordTypeId();

        Database.Saveresult[] resultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{fGMPortalQuiz});

        Map<String,Schema.Recordtypeinfo> recommendationRecordTypeMapByName = FGM_Portal__Recommendation__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        List<FGM_Portal__FCPageLayout__c> lstFCPageLayout = new List<FGM_Portal__FCPageLayout__c>();
        lstFCPageLayout.add(TestsObjectProvider.CreateFCPageLayout('Organization',recommendationRecordTypeMapByName.get('Recommendation').getRecordTypeId(),'FGM_Portal__Amendment__c',resultFGMPortalQuiz[0].Id));
        Database.Saveresult[] resultFGMPortalFCPageLayout = TestsObjectProvider.InsertListWithAssert(lstFCPageLayout);

        List<FGM_Portal__Related_List_Controller__c> lstRelatedListController = new  List<FGM_Portal__Related_List_Controller__c>();

        lstRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('Recommendation', 'FGM_Portal__Recommendation__c', 'Dashboard', 'FGM_Portal__Recommendation__c', 'FGM_Portal__Recommendation__c', 'FGM_Portal__Recommendation__c', '', '', mapRelatedListControllerRecordType.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB).getRecordTypeId(), resultFGMPortalQuiz[0].Id));
        lstRelatedListController[0].FGM_Portal__Language__c = 'en_US';
        lstRelatedListController[0].FGM_Portal__IsCommunityRecord__c = TRUE;
        lstRelatedListController[0].FGM_Portal__SortOrder__c= 0;
        lstRelatedListController[0].FGM_Portal__ShowDeleteLink__c = TRUE;
        lstRelatedListController[0].FGM_Portal__ShowNewButton__c = TRUE;
        lstRelatedListController[0].FGM_Portal__SortField__c ='Name';
        lstRelatedListController[0].FGM_Portal__SortFieldOrder__c ='Ascending';

        Database.Saveresult[] resultsFGMPortalRelatedListController = TestsObjectProvider.InsertListWithAssert(lstRelatedListController);

        Map<String,Schema.Recordtypeinfo> newPortalQuestionRecordTypeMapByName = FGM_Portal__Questions__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        List<FGM_Portal__Questions__c> lstFGMPortalQuestion = new List<FGM_Portal__Questions__c>();

        //Question For Recommendation
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Applicant Name', '', '', '', 'Salesforce Data Type', resultFGMPortalQuiz[0].Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Recommender Full Name', '', '', '', 'Salesforce Data Type', resultFGMPortalQuiz[0].Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Email', '', '', '', 'Salesforce Data Type', resultFGMPortalQuiz[0].Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Attachment', '', '', '', 'Attachment', resultFGMPortalQuiz[0].Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        lstFGMPortalQuestion[3].FGM_Portal__AttachmentNameFormula__c  = 'FileName';
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Attachment', '', '', '', 'Attachment', resultFGMPortalQuiz[0].Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        // lstFGMPortalQuestion[4].FGM_Portal__AttachmentNameFormula__c  = 'FileName';
        Database.Saveresult[] resultsFGMPortalQuestion = TestsObjectProvider.InsertListWithAssert(lstFGMPortalQuestion);

        //QuizQuestion For Recommendation
        List<FGM_Portal__Quiz_Questions__c> lstfGMPortalQuizQuestion = new List<FGM_Portal__Quiz_Questions__c>();
        lstfGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(resultsFGMPortalQuestion[0].Id, 1, 'Name', '', 50, '1', resultsFGMPortalRelatedListController[0].Id, true, resultFGMPortalQuiz[0].Id));
        lstfGMPortalQuizQuestion[0].FGM_Portal__IsCommunityRecord__c = true;
        lstfGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(resultsFGMPortalQuestion[1].Id, 1, 'Recommender_s_Full_Name__c', '', 50, '1', resultsFGMPortalRelatedListController[0].Id, false, resultFGMPortalQuiz[0].Id));
        lstfGMPortalQuizQuestion[1].FGM_Portal__IsCommunityRecord__c = true;
        lstfGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(resultsFGMPortalQuestion[2].Id, 1, 'FGM_Portal__Recommender_Email__c', '', 50, '1', resultsFGMPortalRelatedListController[0].Id, false, resultFGMPortalQuiz[0].Id));
        lstfGMPortalQuizQuestion[2].FGM_Portal__IsCommunityRecord__c = true;
        lstfGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(resultsFGMPortalQuestion[3].Id, 1, '', '', 50, '1', resultsFGMPortalRelatedListController[0].Id, true, resultFGMPortalQuiz[0].Id));
        lstfGMPortalQuizQuestion[3].FGM_Portal__IsCommunityRecord__c = true;
        lstfGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(resultsFGMPortalQuestion[4].Id, 1, '', '', 50, '1', resultsFGMPortalRelatedListController[0].Id, false, resultFGMPortalQuiz[0].Id));
        lstfGMPortalQuizQuestion[3].FGM_Portal__IsCommunityRecord__c = true;

        Database.Saveresult[] resultsfGMPortalQuizQuestion = TestsObjectProvider.InsertListWithAssert(lstfGMPortalQuizQuestion);

        Opportunity opportunity = TestsObjectProvider.CreateOpportunity('testOpp', 'In Progress', Date.today());
        Database.Saveresult[] resultOpportunity = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunity});

        FGM_Portal__Recommendation__c objRcommendation = TestSObjectProvider.CreateRecommendation('testRecommendation', 'recom@test.com', resultOpportunity[0].Id, true);
        Database.Saveresult[] resultRecommendation = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Recommendation__c>{objRcommendation});

        FGM_Portal__Question_Attachment__c questionAttachmentOne = new FGM_Portal__Question_Attachment__c();
        questionAttachmentOne.FGM_Portal__Question__c = resultsFGMPortalQuestion[3].Id;
        questionAttachmentOne.FGM_Portal__Description__c = 'TestAttachmentForQuiz 1';
        questionAttachmentOne.FGM_Portal__Recommendation__c = resultRecommendation[0].Id;
        Database.insert(questionAttachmentOne);

        Attachment attachmentOne = new Attachment();
        attachmentOne.Body = Blob.valueOf('attachmentOne');
        attachmentOne.Name = 'attachmentOne';
        attachmentOne.ParentId = questionAttachmentOne.Id;
        insert attachmentOne;
        system.assertNotEquals( attachmentOne.Id, null );

        FGM_Portal__Question_Attachment__c questionAttachmentTwo = new FGM_Portal__Question_Attachment__c();
        questionAttachmentTwo.FGM_Portal__Question__c = resultsFGMPortalQuestion[4].Id;
        questionAttachmentTwo.FGM_Portal__Description__c = 'TestAttachmentForQuiz 1';
        Database.insert(questionAttachmentTwo);

        Attachment attachmentTwo = new Attachment();
        attachmentTwo.Body = Blob.valueOf('attachmentOne');
        attachmentTwo.Name = 'attachmentOne';
        attachmentTwo.ParentId = questionAttachmentTwo.Id;
        insert attachmentTwo;
        system.assertNotEquals( attachmentTwo.Id, null );
    }

    static testMethod void initializationTest(){
        FGM_Portal__Recommendation__c objRecommendation = [SELECT Id FROM FGM_Portal__Recommendation__c LIMIT 1];
        system.assertNotEquals(NULL, objRecommendation.Id);
        ApexPages.currentPage().getParameters().put('id', objRecommendation.Id);
        RecommendationController objRecommendationController = new RecommendationController();
        objRecommendationController.initialize();
        objRecommendationController.saveRecord();
    }

    static testMethod void initializationNegativeTest(){
        RecommendationController objRecommendationController = new RecommendationController();
        FGM_Portal__Quiz__c objQuiz = [SELECT Id FROM FGM_Portal__Quiz__c LIMIT 1];
        system.assertNotEquals(NULL, objQuiz.Id);
        objRecommendationController.initialize();
        objRecommendationController.quiz = objQuiz;
        objRecommendationController.initialize();
    }

    static testMethod void initializeReviewTest(){
        FGM_Portal__Recommendation__c objRecommendation = [SELECT Id FROM FGM_Portal__Recommendation__c LIMIT 1];
        FGM_Portal__Quiz__c objQuiz = [SELECT Id FROM FGM_Portal__Quiz__c LIMIT 1];
        system.assertNotEquals(NULL, objRecommendation.Id);
        ApexPages.currentPage().getParameters().put('quizId',objQuiz.Id);
        ApexPages.currentPage().getParameters().put('id',objRecommendation.Id);

        RecommendationController objRecommendationController = new RecommendationController();
        objRecommendationController.initializeReview();
        objRecommendationController.initializeQuizQuestionList();
    }

    static testMethod void submitApplicationTest(){
        FGM_Portal__Questions__c objQuestion = [SELECT Id FROM FGM_Portal__Questions__c WHERE FGM_Portal__Type__c ='Attachment' limit 1];
        RecommendationController objRecommendationController = new RecommendationController();

        FGM_Portal__Recommendation__c objRecommendation = [SELECT Id FROM FGM_Portal__Recommendation__c LIMIT 1];
        system.assertNotEquals(NULL, objRecommendation.Id);
        ApexPages.currentPage().getParameters().put('id', objRecommendation.Id);

        objRecommendationController.initialize();
        objRecommendationController.getApplicationObjectName();
        system.assertEquals(NULL,objRecommendationController.submit());
        objRecommendationController.cancel();
    }

    static testMethod void checkFileDescriptionEnableTest(){
        RecommendationController objRecommendationController = new RecommendationController();
        Boolean value = objRecommendationController.IsFileDescriptionEnabled;
        system.assertNotEquals(NULL, value);
    }

    static testMethod void uploadAttachmentTest(){
        List<FGM_Portal__Quiz_Questions__c> lstfGMPortalQuizQuestion = [SELECT Id,name,FGM_Portal__Question__r.FGM_Portal__RichQuestion__c,FGM_Portal__Question__r.FGM_Portal__AttachmentNameFormula__c,FGM_Portal__Question__r.FGM_Portal__Type__c FROM FGM_Portal__Quiz_Questions__c limit 5];
        FGM_Portal__Recommendation__c objRecommendation = [SELECT Id FROM FGM_Portal__Recommendation__c LIMIT 1];
        FGM_Portal__Questions__c objQuestion = [SELECT Id,FGM_Portal__Type__c,FGM_Portal__AttachmentNameFormula__c FROM FGM_Portal__Questions__c WHERE FGM_Portal__Type__c ='Attachment' limit 1];
        FGM_Portal__GlobalPortalSettings__c objGlobalPortalSetting = new FGM_Portal__GlobalPortalSettings__c();
        objGlobalPortalSetting.FGM_Portal__Is_VirusScan_Enabled__c = TRUE;
        insert objGlobalPortalSetting;
        system.assertNotEquals(NULL, objGlobalPortalSetting.Id);
        RecommendationController objRecommendationController = new RecommendationController();
        objRecommendationController.quizQuestionList = lstfGMPortalQuizQuestion;
        objRecommendationController.application = objRecommendation;

        objRecommendationController.mapApplicationAttachments = new Map<string,RecommendationController.ApplicationAttachments>();
        Question_Attachment__c QuestionAttachment = TestsObjectProvider.CreateQuestionAttachment(objQuestion.Id,null, null,null);
        attachment objAttachment = [SELECT Id FROM Attachment LIMIT 1];
        Database.Saveresult[] resultQuestionAttachment = TestsObjectProvider.InsertListWithAssert(new List<Question_Attachment__c>{QuestionAttachment});
        Attachment attachment = TestsObjectProvider.CreateAttachment('attachmentTest', resultQuestionAttachment[0].Id);
        RecommendationController.ApplicationAttachments appAttachment = new RecommendationController.ApplicationAttachments();

        Map<String,Attachment> mapOldAttachments =NEW Map<String,Attachment>();
        mapOldAttachments.put(objAttachment.Id,objAttachment);
        objRecommendationController.quizQuestionList = lstfGMPortalQuizQuestion;
        appAttachment.strQuestionAttachmentId = resultQuestionAttachment[0].Id;
        appAttachment.newAttachment = attachment;
        appAttachment.mapOldAttachments = mapOldAttachments;
        appAttachment.questionAttachment = QuestionAttachment;
        ApexPages.currentPage().getParameters().put('attachedQuestionId', objQuestion.Id);
        ApexPages.currentPage().getParameters().put('attachedId', objAttachment.Id);
        objRecommendationController.mapApplicationAttachments.put(objQuestion.Id, appAttachment);
        system.assertEquals(NULL,objRecommendationController.uploadAttachment());
        objRecommendationController.deleteAttachment();
    }

    static testMethod void saveBeforeReviewSubmitTest(){
        Map<String,Schema.Recordtypeinfo> PortalQuizRecordTypeMap = FGM_Portal__Quiz__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        FGM_Portal__Quiz__c objQuiz = TestsObjectProvider.CreateFGMPortalQuiz('ApplicationQuiz 1', 'test@test.com', '', '', '', '', '', 'Introduction', true);
        objQuiz.FGM_Portal__IsCommunityRecord__c = true;
        objQuiz.RecordTypeId = PortalQuizRecordTypeMap.get(TestsObjectProvider.PORTAL_QUIZ_APPLICATION).getRecordTypeId();
        TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{objQuiz});
        system.assert(objQuiz.Id != null);

        FGM_Portal__Recommendation__c objRecommendation = NEW FGM_Portal__Recommendation__c();
        objRecommendation.name ='TestRecommendation';
        objRecommendation.FGM_Portal__Is_Community_Record__c =TRUE;
        objRecommendation.FGM_Portal__Recommender_Email__c ='test@test.com';
        objRecommendation.FGM_Portal__Status__c = 'New';
        insert objRecommendation;
        system.assertNotEquals(null, objRecommendation.Id);

        SObject objSobject = objRecommendation;
        RecommendationController objRecommendationController = NEW  RecommendationController();
        ApexPages.currentPage().getParameters().put('quizId',objQuiz.Id);
        ApexPages.currentPage().getParameters().put('appID',objQuiz.Id);
        objRecommendationController.quiz = objQuiz;
        objRecommendationController.application = objSobject;
        objRecommendationController.saveBeforeReviewSubmit();
    }

    static testMethod void initializeQuizNegativeTest(){
        RecommendationController objRecommendationController = NEW  RecommendationController();
        String strString = '';
        objRecommendationController.initializeQuiz(strString);
        FGM_Portal__FCPageLayout__c objPageLayout1 = [SELECT Id FROM FGM_Portal__FCPageLayout__c limit 1];
        delete objPageLayout1;
        List<FGM_Portal__FCPageLayout__c> objPageLayout2 = [SELECT Id FROM FGM_Portal__FCPageLayout__c  WHERE Id =:objPageLayout1.Id limit 1];
        system.assertEquals(0, objPageLayout2.size());
        String  recordTypeId = String.valueOf(Schema.SObjectType.FGM_Portal__Recommendation__c.getRecordTypeInfosByName().get('Recommendation').getRecordTypeId());
        objRecommendationController.initializeQuiz(recordTypeId);
    }

    static testMethod void saveRecordNegativeTest(){
        Sobject tabObject = [SELECT Id,Name FROM FGM_Portal__Related_List_Controller__c LIMIT 1];
        system.assertNotEquals(NULL, tabObject);
        RecommendationController objRecommendationController = NEW  RecommendationController();
        objRecommendationController.tabObject = tabObject;
        objRecommendationController.saveRecord();
    }

    static testMethod void saveBeforeReviewSubmitNegativeTest(){
        RecommendationController objRecommendationController = NEW  RecommendationController();
        FGM_Portal__Recommendation__c objRecommendation = NEW FGM_Portal__Recommendation__c();
        objRecommendation.name ='TestRecommendation';
        SObject objSobject = objRecommendation;
        objRecommendationController.application = objSobject;
        system.assertEquals(NULL,objRecommendationController.saveBeforeReviewSubmit());
    }
    static testMethod void beforeSaveTest(){
        RecommendationController1 recommendationController = NEW RecommendationController1();
         FGM_Portal__Recommendation__c objRecommendation = NEW FGM_Portal__Recommendation__c();
         objRecommendation.name ='Test';
         Database.SaveResult insertResult = Database.insert(objRecommendation);
         FGM_Portal__Recommendation_Review__c recommendationReview= NEW FGM_Portal__Recommendation_Review__c();
           recommendationController.tabObject =recommendationReview;
          recommendationReview.FGM_Portal__Recommendation__c= objRecommendation.Id;
         system.assertEquals(recommendationReview,recommendationController.beforeSave());
        
        
    }
}