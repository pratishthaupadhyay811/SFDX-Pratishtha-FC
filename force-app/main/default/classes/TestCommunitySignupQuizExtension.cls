@isTest
class TestCommunitySignupQuizExtension{
    @testSetup static void testSetup() {
        try{
            Map<String,Schema.Recordtypeinfo> quizRecordTypeMap = FGM_Portal__Quiz__c.SObjectType.getDescribe().getRecordTypeInfosByName();
            FGM_Portal__Quiz__c objQuiz = TestsObjectProvider.CreateFGMPortalQuiz('quiz', 'test@test1.com', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
            objQuiz.FGM_Portal__Failure_URL__c = '~/apex/CommunitiesSignupRejected';
            objQuiz.FGM_Portal__Success_URL__c = '~/apex/FGM_Portal__CommunitySignin';
            objQuiz.RecordTypeId = quizRecordTypeMap.get('Quiz').getRecordTypeId();
            Database.Saveresult[] quizResult = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{objQuiz});

            Map<String,Schema.Recordtypeinfo> mapQuestionRecordtype = FGM_Portal__Questions__c.SObjectType.getDescribe().getRecordTypeInfosByName();
            List<FGM_Portal__Questions__c> lstQuestion = NEW List<FGM_Portal__Questions__c>();
            lstQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('test1', '', '', '', 'MultiSelect', objQuiz.Id,'', mapQuestionRecordtype.get(TestsObjectProvider.PORTAL_QUIZ_QUIZ).getRecordTypeId()));
            lstQuestion[0].FGM_Portal__Is_Active__c = TRUE;
            lstQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('test2', '', '', '', 'SingleSelect', objQuiz.Id, '',mapQuestionRecordtype.get(TestsObjectProvider.PORTAL_QUIZ_QUIZ).getRecordTypeId()));
            lstQuestion[1].FGM_Portal__Is_Active__c = TRUE;
            lstQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('test3', '', '', '', 'SingleSelect', objQuiz.Id, '',mapQuestionRecordtype.get(TestsObjectProvider.PORTAL_QUIZ_QUIZ).getRecordTypeId()));
            lstQuestion[2].FGM_Portal__Is_Active__c = TRUE;
            Database.saveResult[] questionSaveResult = Database.insert(lstQuestion);

            List<FGM_Portal__Question_Responses__c> lstQuestionResponce = NEW List<FGM_Portal__Question_Responses__c>();
            lstQuestionResponce.add(TestsObjectProvider.CreateFGMPortalQuestionResponse(questionSaveResult[0].Id,true,true));
            lstQuestionResponce[0].FGM_Portal__Response__c ='yes';
            lstQuestionResponce.add(TestsObjectProvider.CreateFGMPortalQuestionResponse(questionSaveResult[0].Id,true,false));
            lstQuestionResponce[1].FGM_Portal__Response__c ='NO';
            lstQuestionResponce.add(TestsObjectProvider.CreateFGMPortalQuestionResponse(questionSaveResult[1].Id,true,true));
            lstQuestionResponce[2].FGM_Portal__Response__c ='yes';
            lstQuestionResponce.add(TestsObjectProvider.CreateFGMPortalQuestionResponse(questionSaveResult[2].Id,true,true));
            lstQuestionResponce[3].FGM_Portal__Response__c ='yes';
            insert lstQuestionResponce;

            Map<String,Schema.Recordtypeinfo> mapRelatedListController = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfosByName();
            List<FGM_Portal__Related_List_Controller__c> objectRLC = new List<FGM_Portal__Related_List_Controller__c>();
            objectRLC.add(TestsObjectProvider.CreateFGMPortalRelatedListController('Bank Accounts', 'Grantee', 'Profile', 'Bank_Account__c', 'Account', 'Organization__c', 'Name,Account Name,Account Number', 'Name,Account_Name__c,Account_Number__c', mapRelatedListController.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB).getRecordTypeId(), quizResult[0].Id));
            Database.saveResult[] objRLCSaveResult = Database.insert(objectRLC) ;
            List<FGM_Portal__Quiz_Questions__c> lstQuizQuestion = new List<FGM_Portal__Quiz_Questions__c>();
            lstQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(questionSaveResult[0].Id, 1, '', '', 50, '', objRLCSaveResult[0].Id, true, quizResult[0].Id));
            lstQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(questionSaveResult[1].Id, 2, '', '', 50, '', objRLCSaveResult[0].Id, true, quizResult[0].Id));
            lstQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(questionSaveResult[2].Id, 3, '', '', 50, '', objRLCSaveResult[0].Id, true, quizResult[0].Id));
            insert lstQuizQuestion;
        }
        catch(Exception ex){
            system.debug('exception'+ex.getMessage() +' '+ex.getStackTraceString());
        }
    }

    static testMethod void getParamTest(){
        ApexPages.currentPage().getParameters().put('test','test');
        FGM_Portal__Quiz__c objQuiz = [SELECT Id,Name,FGM_Portal__Failure_URL__c,FGM_Portal__Success_URL__c,FGM_Portal__Is_Active__c FROM FGM_Portal__Quiz__c LIMIT 1];
        ApexPages.StandardController standardController = NEW ApexPages.standardController( objQuiz);
        CommunitySignupQuizExtension objectSignupQuizExtention = NEW CommunitySignupQuizExtension(standardController);
        System.assert(objectSignupQuizExtention.getParam('test') == 'test');
    }

    static testMethod void initializeTest(){
        FGM_Portal__Quiz__c objQuiz = [SELECT Id,Name,FGM_Portal__Failure_URL__c,FGM_Portal__Success_URL__c,FGM_Portal__Is_Active__c FROM FGM_Portal__Quiz__c LIMIT 1];
        ApexPages.StandardController standardController = NEW ApexPages.standardController( objQuiz);
        CommunitySignupQuizExtension objectSignupQuizExtention = NEW CommunitySignupQuizExtension(standardController);
        system.assert(objectSignupQuizExtention != NULL);
        objectSignupQuizExtention.initialize();
    }

    static testMethod void getImageLogoURLTest(){
        FGM_Portal__Quiz__c objQuiz = [SELECT Id,Name,FGM_Portal__Failure_URL__c,FGM_Portal__Success_URL__c,FGM_Portal__Is_Active__c FROM FGM_Portal__Quiz__c LIMIT 1];
        ApexPages.StandardController standardController = NEW ApexPages.standardController( objQuiz);
        CommunitySignupQuizExtension objectSignupQuizExtention = NEW CommunitySignupQuizExtension(standardController);
        system.assert(objectSignupQuizExtention != NULL);
        system.assertEquals(NULL, objectSignupQuizExtention.getImageLogoUrl());
    }

    static testMethod void initializeQuizTest(){
        FGM_Portal__Quiz__c objQuiz = [SELECT Id,Name,FGM_Portal__Failure_URL__c,FGM_Portal__Success_URL__c,FGM_Portal__Is_Active__c FROM FGM_Portal__Quiz__c LIMIT 1];
        ApexPages.StandardController standardController = NEW ApexPages.standardController( objQuiz);
        CommunitySignupQuizExtension objectSignupQuizExtention = NEW CommunitySignupQuizExtension(standardController);
        system.assert(objectSignupQuizExtention != NULL);
        objectSignupQuizExtention.initializeQuiz();
        system.assertNotEquals(NULL, objectSignupQuizExtention.quizList);
    }

    static testMethod void initializeQuestionResponseListTest(){
        FGM_Portal__Quiz__c objQuiz = [SELECT Id,Name,FGM_Portal__Failure_URL__c,FGM_Portal__Success_URL__c,FGM_Portal__Is_Active__c FROM FGM_Portal__Quiz__c LIMIT 1];
        ApexPages.StandardController standardController = NEW ApexPages.standardController( objQuiz);
        CommunitySignupQuizExtension objectSignupQuizExtention = NEW CommunitySignupQuizExtension(standardController);
        system.assert(objectSignupQuizExtention != NULL);
        objectSignupQuizExtention.initializeQuestionResponseList();
        system.assertNotEquals(NULL, objectSignupQuizExtention.lstResponseOptions);
    }

    static testMethod void nextTest(){
         FGM_Portal__Quiz__c objQuiz = [SELECT Id,Name,FGM_Portal__Failure_URL__c,FGM_Portal__Success_URL__c,FGM_Portal__Is_Active__c FROM FGM_Portal__Quiz__c LIMIT 1];
        ApexPages.StandardController standardController = NEW ApexPages.standardController( objQuiz);
        CommunitySignupQuizExtension objectSignupQuizExtention = NEW CommunitySignupQuizExtension(standardController);
        system.assert(objectSignupQuizExtention != NULL);
        objectSignupQuizExtention.initialize();

        List<FGM_Portal__Question_Responses__c> objResponce = [SELECT Id FROM FGM_Portal__Question_Responses__c WHERE FGM_Portal__Eligibility_Question__r.FGM_Portal__Type__c = 'MultiSelect' and FGM_Portal__Accepted_Response__c = FALSE LIMIT 1];
        objectSignupQuizExtention.questionMultiResponseSelectedId.add(objResponce[0].Id);
        objectSignupQuizExtention.next();

        objectSignupQuizExtention.questionMultiResponseSelectedId.clear();
        objResponce = [SELECT Id FROM FGM_Portal__Question_Responses__c WHERE FGM_Portal__Eligibility_Question__r.FGM_Portal__Type__c = 'MultiSelect' and FGM_Portal__Accepted_Response__c = TRUE LIMIT 1];
        objectSignupQuizExtention.questionMultiResponseSelectedId.add(objResponce[0].Id);
        objectSignupQuizExtention.questionNumber = 2;
        system.assert(objectSignupQuizExtention.next() != NULL) ;

        objectSignupQuizExtention.questionMultiResponseSelectedId.clear();
        objResponce = [SELECT Id FROM FGM_Portal__Question_Responses__c WHERE FGM_Portal__Eligibility_Question__r.FGM_Portal__Type__c = 'MultiSelect' and FGM_Portal__Accepted_Response__c = TRUE LIMIT 1];
        objectSignupQuizExtention.questionMultiResponseSelectedId.add(objResponce[0].Id);
        objectSignupQuizExtention.questionNumber = 1;
        objectSignupQuizExtention.next();
        objectSignupQuizExtention.next();
    }
}