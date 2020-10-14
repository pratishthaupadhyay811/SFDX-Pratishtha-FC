@isTest
private with sharing class CommunityCampaignExtentionTest {
    @isTest
    private static void shouldGetCampaignQuizzesForLOICampaign() {
        final Integer NUM_QUIZZES = 3;
        List<Quiz__c> childLOIQuizzes = buildQuizzes(NUM_QUIZZES);
        Quiz__c parentLOIQuiz = buildQuizzes(1)[0];

        insert childLOIQuizzes;
        insert parentLOIQuiz;

        Campaign loiCampaign = new Campaign(
            Name = 'LOI Campaign',
            LOI_Quiz__c = parentLOIQuiz.Id,
            Application_Type__c = 'LOI Quiz',
            EndDate = Date.today().addMonths(1)
        );

        insert loiCampaign;

        List<Campaign_Quiz__c> campaignQuizzes = buildCampaignQuizzes(loiCampaign, childLOIQuizzes);
        insert campaignQuizzes;

        Test.startTest();
        CommunityCampaignExtension extension = new CommunityCampaignExtension(new ApexPages.standardController(loiCampaign));
        Test.stopTest();

        assertOnPageMessages();

        System.assertEquals(NUM_QUIZZES + 1, extension.lstCampaignQuizzes.size(),
            'The child campaign quizzes and the parent quiz related to the campaign should be wrapped as QuizCampaignWrapper objects');

        CommunityCampaignExtension.QuizCampaignWrapper parentQuizWrapper;
        List<CommunityCampaignExtension.QuizCampaignWrapper> childQuizWrappers =
            new List<CommunityCampaignExtension.QuizCampaignWrapper>();

        for (CommunityCampaignExtension.QuizCampaignWrapper wrapper : extension.lstCampaignQuizzes) {
            if (wrapper.quiz != null) {
                parentQuizWrapper = wrapper;
            } else if (wrapper.campaignQuiz != null) {
                childQuizWrappers.add(wrapper);
            }
        }

        System.assertNotEquals(null, parentQuizWrapper.quiz, 'The parent quiz should be wrapped');
        System.assertEquals(parentLOIQuiz.Id, parentQuizWrapper.quiz.Id,
         'The parent quiz should be wrapped with a reference to the Quiz__c record');

        Set<Id> wrappedChildQuizIds = new Set<Id>();
        System.assertEquals(NUM_QUIZZES, childQuizWrappers.size(), 'The correct number of child quizzes should be wrapped');
        for (CommunityCampaignExtension.QuizCampaignWrapper wrapper : childQuizWrappers) {
            wrappedChildQuizIds.add(wrapper.campaignQuiz.Id);
        }

        System.assertEquals(new Map<Id, Campaign_Quiz__c>(campaignQuizzes).keySet(), wrappedChildQuizIds,
            'All of the child quizzes should have been wrapped correctly'
        );
    }

    @isTest
    private static void shouldGetCampaignQuizzesForApplicationCampaign() {
        Quiz__c parentApplicationQuiz = buildQuizzes(1)[0];

        insert parentApplicationQuiz;

        Campaign applicationCampaign = new Campaign(
            Name = 'Application Campaign',
            Application_Quiz__c = parentApplicationQuiz.Id,
            Application_Type__c = 'Application Quiz',
            EndDate = Date.today().addMonths(1)
        );

        insert applicationCampaign;

        Test.startTest();
        CommunityCampaignExtension extension = new CommunityCampaignExtension(new ApexPages.standardController(applicationCampaign));
        Test.stopTest();

        assertOnPageMessages();

        System.assertEquals(1, extension.lstCampaignQuizzes.size(),
            'The parent quiz should be wrapped as a QuizCampaignWrapper object');

        CommunityCampaignExtension.QuizCampaignWrapper parentQuizWrapper = extension.lstCampaignQuizzes[0];

        System.assertNotEquals(null, parentQuizWrapper.quiz, 'The parent quiz should be wrapped');
        System.assertEquals(parentApplicationQuiz.Id, parentQuizWrapper.quiz.Id,
         'The parent quiz should be wrapped with a reference to the Quiz__c record');
    }

    @isTest
    private static void shouldGetTranslationsForCampaign() {
        final String NAME_TRANSLATION = 'Prenom';
        final String INSTRUCTIONS_TRANSLATION = 'Les instructions';
        final String DESCRIPTION_TRANSLATION = 'La description';

        Quiz__c quiz = buildQuizzes(1)[0];

        insert quiz;

        Campaign aCampaign = new Campaign(
            Name = 'Test Campaign',
            Application_Quiz__c = quiz.Id,
            Application_Type__c = 'Application Quiz',
            EndDate = Date.today().addMonths(1)
        );

        insert aCampaign;

        Campaign_Quiz__c campaignQuiz = buildCampaignQuizzes(aCampaign, new List<Quiz__c>{ quiz })[0];
        insert campaignQuiz;

        FieldValueTranslationRepository_TEST.Stub translationRepoStub =
            new FieldValueTranslationRepository_TEST.Stub()
                .withReturnValue(
                    'getFieldTranslationsByTranslatedRecordId',
                    new Map<String, Map<String, Field_Value_Translation__c>> {
                        aCampaign.Id =>
                            new Map<String, Field_Value_Translation__c> {
                                'Name' => new Field_Value_Translation__c(Translation_Value__c = NAME_TRANSLATION),
                                'FGM_Portal__Description__c' => new Field_Value_Translation__c(Translation_Value__c= INSTRUCTIONS_TRANSLATION),
                                'Description' => new Field_Value_Translation__c(Translation_Value__c= DESCRIPTION_TRANSLATION)
                            }
                    }
                );

        CommunityCampaignExtension extension = new CommunityCampaignExtension(new ApexPages.standardController(aCampaign));
        extension.translationRepository =
            (FieldValueTranslationRepository) Test.createStub(FieldValueTranslationRepository.class, translationRepoStub);

        Test.startTest();
        extension.initializeTranslations();
        Test.stopTest();

        assertOnPageMessages();

        System.assert(extension.campaigntranslations.containsKey('Name'), 'There should be a translation for Name');
        System.assertEquals(NAME_TRANSLATION, extension.campaigntranslations.get('Name').Translation_Value__c,
            'There should be the correct translation for Name');

        System.assert(extension.campaigntranslations.containsKey('FGM_Portal__Description__c'),
            'There should be a translation for FGM_Portal__Description__c');
        System.assertEquals(INSTRUCTIONS_TRANSLATION, extension.campaigntranslations.get('FGM_Portal__Description__c').Translation_Value__c,
            'There should be the correct translation for FGM_Portal__Description__c');

        System.assert(extension.campaigntranslations.containsKey('Description'),
            'There should be a translation for Description');
        System.assertEquals(DESCRIPTION_TRANSLATION, extension.campaigntranslations.get('Description').Translation_Value__c,
            'There should be the correct translation for Description');
    }

    @isTest
    private static void shouldGetTranslationsForQuizzes() {
        final String NAME_TRANSLATION = 'Prenom';
        final String INSTRUCTIONS_TRANSLATION = 'Les instructions';

        Quiz__c quiz = buildQuizzes(1)[0];

        insert quiz;

        Campaign aCampaign = new Campaign(
            Name = 'Test Campaign',
            Application_Quiz__c = quiz.Id,
            Application_Type__c = 'Application Quiz',
            EndDate = Date.today().addMonths(1)
        );

        insert aCampaign;

        Campaign_Quiz__c campaignQuiz = buildCampaignQuizzes(aCampaign, new List<Quiz__c>{ quiz })[0];
        insert campaignQuiz;

        FieldValueTranslationRepository_TEST.Stub translationRepoStub =
            new FieldValueTranslationRepository_TEST.Stub()
                .withReturnValue(
                    'getFieldTranslationsByTranslatedRecordId',
                    new Map<String, Map<String, Field_Value_Translation__c>> {
                        campaignQuiz.Id =>
                            new Map<String, Field_Value_Translation__c> {
                                'Name' => new Field_Value_Translation__c(Translation_Value__c = NAME_TRANSLATION),
                                'FGM_Portal__Rich_Instructional_Text__c' => new Field_Value_Translation__c(Translation_Value__c= INSTRUCTIONS_TRANSLATION)
                            }
                    }
                );

        CommunityCampaignExtension extension = new CommunityCampaignExtension(new ApexPages.standardController(aCampaign));
        extension.translationRepository =
            (FieldValueTranslationRepository) Test.createStub(FieldValueTranslationRepository.class, translationRepoStub);

        Test.startTest();
            extension.initializeTranslations();
        Test.stopTest();

        assertOnPageMessages();

        System.assertEquals(1, extension.lstCampaignQuizzes.size(), 'The campaign quiz should be wrapped');
        CommunityCampaignExtension.QuizCampaignWrapper wrapper = extension.lstCampaignQuizzes[0];
        Map<String, Field_Value_Translation__c> translations = wrapper.translations;

        System.assertNotEquals(null, wrapper.translations, 'There should be translations');
        System.assert(wrapper.translations.containsKey('Name'), 'There should be a translation for Name');
        System.assertEquals(NAME_TRANSLATION, wrapper.translations.get('Name').Translation_Value__c,
            'There should be the correct translation for Name');

        System.assert(wrapper.translations.containsKey('FGM_Portal__Rich_Instructional_Text__c'),
            'There should be a translation for FGM_Portal__Rich_Instructional_Text__c');
        System.assertEquals(INSTRUCTIONS_TRANSLATION, wrapper.translations.get('FGM_Portal__Rich_Instructional_Text__c').Translation_Value__c,
            'There should be the correct translation for FGM_Portal__Rich_Instructional_Text__c');
    }

    @isTest
    private static void shouldMarkEndedCampaignAsExpired() {
        Quiz__c quiz = buildQuizzes(1)[0];
        insert quiz;

        Campaign aCampaign = new Campaign(
            Name = 'Test Campaign',
            Application_Quiz__c = quiz.Id,
            Application_Type__c = 'Application Quiz',
            EndDate = Date.today().addMonths(-1)
        );

        insert aCampaign;

        Test.startTest();
        CommunityCampaignExtension extension = new CommunityCampaignExtension(new ApexPages.standardController(aCampaign));
        Test.stopTest();

        System.assert(extension.isCampaignExpired, 'The campaign should be marked as expired');
    }

    @isTest
    private static void shouldNotMarkOngoingCampaignAsExpired() {
        Quiz__c quiz = buildQuizzes(1)[0];
        insert quiz;

        Campaign aCampaign = new Campaign(
            Name = 'Test Campaign',
            Application_Quiz__c = quiz.Id,
            Application_Type__c = 'Application Quiz',
            EndDate = Date.today().addMonths(1)
        );

        insert aCampaign;

        Test.startTest();
        CommunityCampaignExtension extension = new CommunityCampaignExtension(new ApexPages.standardController(aCampaign));
        Test.stopTest();

        System.assertEquals(false, extension.isCampaignExpired, 'The campaign should not be marked as expired');
    }

    private static List<Quiz__c> buildQuizzes(Integer numQuizzes) {
        List<Quiz__c> quizzes = new List<Quiz__c>();
        for (Integer i = 0; i < numQuizzes; i++) {
            quizzes.add(
                new Quiz__c(
                    Name = 'Test Quiz ' + i,
                    FGM_Portal__Introduction_Text__c = 'Introduction Text ' + i
                )
            );
        }

        return quizzes;
    }

    private static List<Campaign_Quiz__c> buildCampaignQuizzes(Campaign aCampaign, List<Quiz__c> quizzes) {
        List<Campaign_Quiz__c> campaignQuizzes = new List<Campaign_Quiz__c>();

        for (Quiz__c quiz : quizzes) {
            campaignQuizzes.add(
                new Campaign_Quiz__c(
                    Name = quiz.Name,
                    Quiz__c = quiz.Id,
                    Campaign__c = aCampaign.Id,
                    isActive__c = true
                )
            );
        }

        return campaignQuizzes;
    }

    private static void assertOnPageMessages() {
        System.assertEquals(false, ApexPages.hasMessages(),
            'There should be not be an error on the page: '
            + (ApexPages.getMessages().isEmpty() ? '' : ApexPages.getMessages()[0].getDetail()));
    }
}