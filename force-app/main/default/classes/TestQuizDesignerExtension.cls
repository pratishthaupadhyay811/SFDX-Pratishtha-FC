@isTest
private class TestQuizDesignerExtension{
    @isTest
    private static void QuizDesignerExtension() {
        List<User> lstSysAdminUsers = [ SELECT Id
                                        FROM User
                                        WHERE Profile.Name ='System Administrator'
                                        AND IsActive = true
                                      ];
        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        account.OwnerId = lstSysAdminUsers[0].Id;
        Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

        Contact contact = TestsObjectProvider.CreateContact('testContact1', 'testContact1', ResultAccount[0].Id, 'test@test1.com');
        Database.SaveResult[] ResultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});

        List<FGM_Portal__Portal_User__c> lstPortalUser = new List<FGM_Portal__Portal_User__c>();
        lstPortalUser.add(TestSObjectProvider.CreateFGMPortalUser(null, 'test@osf-communities-developer-edition.na17.force.com', 'Portal LastName', 'test@test1.com', 'test@test1.com', 'test@osf-communities-developer-edition.na17.force.com', 'Test1234', 'Test1234', true));
        lstPortalUser[0].Account__c = account.Id;
        Database.Saveresult[] ResultFGMPortalUser = TestsObjectProvider.InsertListWithAssert(lstPortalUser);

        Map<String,Schema.Recordtypeinfo> newPortalQuizRecordTypeMapByName = FGM_Portal__Quiz__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        FGM_Portal__Quiz__c FGMPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz('PortalQuiz1', 'test@test1.com', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
        FGMPortalQuiz.FGM_Portal__Failure_URL__c = '~/apex/CommunitiesSignupRejected';
        FGMPortalQuiz.RecordTypeId = newPortalQuizRecordTypeMapByName.get('Quiz').getRecordTypeId();

        ApexPages.StandardController scFGMPortalQuiz = new ApexPages.standardController( FGMPortalQuiz);
        QuizDesignerExtension newQuizDesignerExtension = new QuizDesignerExtension(scFGMPortalQuiz);
        newQuizDesignerExtension.initialize();
        newQuizDesignerExtension.insertQuiz();
        ApexPages.currentPage().getParameters().put('id', newQuizDesignerExtension.quiz.Id);
        newQuizDesignerExtension.quiz = [SELECT Name,Id
                                         FROM FGM_Portal__Quiz__c
                                         WHERE Id =:newQuizDesignerExtension.quiz.Id
                                        ];
        newQuizDesignerExtension.initialize();
        newQuizDesignerExtension.selectedQuizId = newQuizDesignerExtension.quiz.Id;
        newQuizDesignerExtension.selectQuiz();

        Map<String,Schema.Recordtypeinfo> newPortalQuestionRecordTypeMapByName = FGM_Portal__Questions__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        List<FGM_Portal__Questions__c> lstFGMPortalQuestion = new List<FGM_Portal__Questions__c>();
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Amount', '', '', '', 'Attachment', newQuizDesignerExtension.quiz.Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_QUIZ).getRecordTypeId()));
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Instruction', '', '', '', 'Instruction', newQuizDesignerExtension.quiz.Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_QUIZ).getRecordTypeId()));
        lstFGMPortalQuestion[0].FGM_Portal__Is_Active__c = true;

        newQuizDesignerExtension.questionInsert = lstFGMPortalQuestion[0];
        newQuizDesignerExtension.insertQuestion();
        newQuizDesignerExtension.questionInsert = lstFGMPortalQuestion[1];
        newQuizDesignerExtension.insertQuestion();


        lstFGMPortalQuestion[1].FGM_Portal__Is_Active__c = true;
        lstFGMPortalQuestion[1].FGM_Portal__Type__c = 'Attachment';
        upsert lstFGMPortalQuestion;

        newQuizDesignerExtension.initializeQuestionOptions();
        newQuizDesignerExtension.questionInsert = (FGM_Portal__Questions__c)[ SELECT Id, Name
                                                    FROM FGM_Portal__Questions__c
                                                    WHERE FGM_Portal__Questions__c.Quiz__c =:newQuizDesignerExtension.quiz.Id LIMIT 1
                                                  ];

        List<FGM_Portal__Quiz_Questions__c> lstFGMPortalQuizQuestion = new List<FGM_Portal__Quiz_Questions__c>();
        lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(newQuizDesignerExtension.questionInsert.Id, 1, 'FGM_Base__Comment__c', '', 50, '1', null, true, newQuizDesignerExtension.quiz.Id));
        newQuizDesignerExtension.quizQuestionInsert = lstFGMPortalQuizQuestion[0];
        newQuizDesignerExtension.insertQuizQuestion();
        newQuizDesignerExtension.updateQuizQuestionList();

        newQuizDesignerExtension.getParam('id');
        Pagereference testPageReference = Page.QuizDesigner;
        Test.setCurrentPageReference(testPageReference);

        newQuizDesignerExtension.redirectTo(testPageReference);

        QuizDesignerExtension.getQuestionResponseList(new String[] { newQuizDesignerExtension.questionInsert.Id });
    }

    @isTest
    private static void shouldReturnFalseIfTranslationNotFound() {
        Quiz__c quiz =new Quiz__c();
        quiz.Name ='Test Quiz';
        insert quiz;
        
        Test.startTest();
        Boolean translationExist = QuizDesignFormExtension.quizIsTranslatedInLanguage(quiz.Id, 'es');
        Test.stopTesT();

        System.assertEquals(false, translationExist, 'Translations should not be found');
    }

    @isTest
    private static void shouldReturnTrueIfTranslationFound() {
        final String LANGUAGE = 'es';
        Quiz__c quiz = new Quiz__c();
        quiz.Name ='Test Quiz';
        insert quiz;
        
        insert new Related_List_Controller__c(
            Name = 'Translated Related List Controller',
            Quiz__c = quiz.Id,
            Language__c = 'es',
            IsCommunityRecord__c = true,
            LookupField__c = 'Opportunity',
            ObjectName__c = 'Opportunity'
        );

        Test.startTest();
        Boolean translationExist = QuizDesignFormExtension.quizIsTranslatedInLanguage(quiz.Id, 'es');
        Test.stopTesT();

        System.assertEquals(true, translationExist, 'Translation should be found');
    }
}