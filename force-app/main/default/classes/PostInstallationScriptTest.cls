@isTest
public class PostInstallationScriptTest {
    private static Map<String, String> rawHtmlToRichText = new Map<String, String>{
        '<style>.userType {display: none !important;} a.guidestar_btn{display:none !important;}</style><p>Please fill out all required fields, including the EIN for your organization.</p>' =>
        '.userType {display: none !important;} a.guidestar_btn{display:none !important;}<p>Please fill out all required fields, including the EIN for your organization.</p>',

        '<h3>Welcome to the Wilbur Potato Foundation Portal</h3><p>Please login in if you are an existing portal user or create a new user account to apply.</p>' =>
        '<h3>Welcome to the Wilbur Potato Foundation Portal</h3><p>Please login in if you are an existing portal user or create a new user account to apply.</p>',

        '<style>.userType {display: none !important;}</style>' =>
        '.userType {display: none !important;}',

        '<style>.userType {display: none !important;}</style><p>Enter a username and a password. Your password must be:</p><ul><li>Between 8 and 20 characters</li><li>Must mix uppercase, lowercase, and numbers</li></ul>' =>
        '.userType {display: none !important;}<p>Enter a username and a password. Your password must be:</p><ul><li>Between 8 and 20 characters</li><li>Must mix uppercase, lowercase, and numbers</li></ul>'
    };

    @isTest
    private static void testMigrateCustomHTMLOnlyRunsOnUpgradeTo1128() {
        insert new CustomHTML__c(
            Associated_FC_Portal_Type__c = 'Grantee',
            Name = 'Communities Sign Up - Step 1',
            Language__c = 'en_US',
            Location__c = 'Header',
            Description__c = 'This is the old value',
            RichDescription__c = 'This is a different new value'
        );

        Test.startTest();

        Test.testInstall(new PostInstallationScript(), new Version(11, 28));

        Test.stopTest();

        CustomHTML__c updatedRecord = [
            SELECT
                Description__c,
                RichDescription__c
            FROM CustomHTML__c
            LIMIT 1
        ];

        System.assertEquals('This is the old value', updatedRecord.Description__c);
        System.assertEquals('This is a different new value', updatedRecord.RichDescription__c);
    }

    @isTest
    private static void testMigrateCustomHTMLCopiesDataOnUpgrade() {
        for (String rawHtmlDescription : rawHtmlToRichText.keySet()) {
            insert new CustomHTML__c(
                Name = 'Communities Sign Up - Step ' + String.valueOf(Math.random()),
                Description__c = rawHtmlDescription
            );
        }

        Test.startTest();
        Test.testInstall(new PostInstallationScript(), new Version(11, 27));
        Test.stopTest();

        List<CustomHTML__c> updatedRecords = [
            SELECT
                Description__c,
                RichDescription__c
            FROM CustomHTML__c
        ];

        for (CustomHTML__c updatedRecord : updatedRecords) {
            System.assertEquals(
                rawHtmlToRichText.get(updatedRecord.Description__c),
                updatedRecord.RichDescription__c
            );
        }
    }

    @isTest
    private static void shouldMigrateQuestionsText() {
        List<Questions__c> questions = new List<Questions__c>();
        for (String rawHtmlDescription : rawHtmlToRichText.keySet()) {
            questions.add(
            new Questions__c(
                    Question__c = rawHtmlDescription,
                    Pre_Text__c = rawHtmlDescription,
                    Post_Text__c = rawHtmlDescription
                )
            );
        }

        insert questions;

        Test.startTest();
        Test.testInstall(new PostInstallationScript(), new Version(11, 27));
        Test.stopTest();

        List<Questions__c> updatedRecords = [
            SELECT
                Question__c,
                RichQuestion__c,
                Pre_Text__c,
                RichPreText__c,
                Post_Text__c,
                RichPostText__c
            FROM Questions__c
        ];

        for (Questions__c updatedRecord : updatedRecords) {
            System.assertEquals(
                rawHtmlToRichText.get(updatedRecord.Question__c),
                updatedRecord.RichQuestion__c
            );

            System.assertEquals(
                rawHtmlToRichText.get(updatedRecord.Pre_Text__c),
                updatedRecord.RichPreText__c
            );
            
            System.assertEquals(
                rawHtmlToRichText.get(updatedRecord.Post_Text__c),
                updatedRecord.RichPostText__c
            );
        }
    }

    @isTest
    private static void shouldMigrateCampaignQuizText() {
        List<Quiz__c> quizzes = new List<Quiz__c>();
        for (Integer i = 0; i < 10; i++) {
            quizzes.add(
                new Quiz__c(
                    Name = 'Test Quiz ' + i,
                    FGM_Portal__Introduction_Text__c = 'Introduction Text ' + i
                )
            );
        }

        insert quizzes;

        Campaign loiCampaign = new Campaign(
            Name = 'LOI Campaign',
            LOI_Quiz__c = quizzes[0].Id,
            Application_Type__c = 'LOI Quiz'
        );

        insert loiCampaign;

        List<Campaign_Quiz__c> campaignQuizzes = new List<Campaign_Quiz__c>();
        for (Quiz__c quiz : quizzes) {
            campaignQuizzes.add(
                new Campaign_Quiz__c(
                    Name = quiz.Name,
                    Quiz__c = quiz.Id,
                    Campaign__c = loiCampaign.Id,
                    Instructional_Text__c = '<b>instructions</b>',
                    isActive__c = true
                )
            );
        }

        insert campaignQuizzes;

        Test.startTest();
        Test.testInstall(new PostInstallationScript(), new Version(11, 27));
        Test.stopTest();

        List<Campaign_Quiz__c> updatedRecords = [
            SELECT
                Instructional_Text__c,
                Rich_Instructional_Text__c
            FROM Campaign_Quiz__c
        ];

        for (Campaign_Quiz__c updatedRecord : updatedRecords) {
            System.assertNotEquals(null, updatedRecord.Rich_Instructional_Text__c,
                'Rich_Instructional_Text__c should be populated');
            System.assertEquals(updatedRecord.Instructional_Text__c, updatedRecord.Rich_Instructional_Text__c,
                'Instructional_Text__c should have been migrated to Rich_Instructional_Text__c');
        }
    }

    @isTest
    private static void shouldMigrateRelatedListControllerInstructionalText() {
        List<Related_List_Controller__c> relatedListControllers = new List<Related_List_Controller__c>();
        for (String rawHtmlDescription : rawHtmlToRichText.keySet()) {
            relatedListControllers.add(
                new Related_List_Controller__c(
                    Name = 'Instructional Text ' + String.valueOf(Math.random()),
                    InstructionalText__c = rawHtmlDescription,
                    LookupField__c = 'Opportunity',
                    ObjectName__c = 'Opportunity'
                )
            );
        }
        
        insert relatedListControllers;

        Test.startTest();
        Test.testInstall(new PostInstallationScript(), new Version(11, 27));
        Test.stopTest();

        List<Related_List_Controller__c> updatedRecords = [
            SELECT
                InstructionalText__c,
                RichInstructionalText__c
            FROM Related_List_Controller__c
        ];

        for (Related_List_Controller__c updatedRecord : updatedRecords) {
            System.assertEquals(
                rawHtmlToRichText.get(updatedRecord.InstructionalText__c),
                updatedRecord.RichInstructionalText__c
            );
        }
    }

    @isTest
    private static void shouldMigrateCampaignQuizInstructionalTextTranslations() {
        final Integer NUM_TRANSLATIONS = 10;
        Map<String, Field_Value_Translation__c> instructionalTextTranslationsByRecordId = new Map<String, Field_Value_Translation__c>();
        for (Integer i = 0; i < NUM_TRANSLATIONS; i++) {
            String mockId = TestIdMocker.mockId(Campaign_Quiz__c.SObjectType);
            instructionalTextTranslationsByRecordId.put(
                mockId,
                new Field_Value_Translation__c(
                    RecordID__c = mockId,
                    Field_Name__c = 'FGM_Portal__Instructional_Text__c',
                    Translation_Value__c = 'Instructional Translation ' + i,
                    Name = 'Instructional Translation ' + i,
                    Language__c = 'fr'
                )
            );
        }
        
        insert instructionalTextTranslationsByRecordId.values();

        List<Field_Value_Translation__c> otherTranslations = new List<Field_Value_Translation__c>();
        for (Integer i = 0; i < 10; i++) {
            otherTranslations.add(
                new Field_Value_Translation__c(
                    RecordID__c = TestIdMocker.mockId(Campaign_Quiz__c.SObjectType),
                    Field_Name__c = 'Name',
                    Translation_Value__c = 'Name Translation ' + i,
                    Name = 'Name Translation ' + i,
                    Language__c = 'fr'
                )
            );
        }

        insert otherTranslations;

        Test.startTest();
        Test.testInstall(new PostInstallationScript(), new Version(11, 27));
        Test.stopTest();

        List<Field_Value_Translation__c> originalTranslations = [
            SELECT RecordID__c, Translation_Value__c
            FROM Field_Value_Translation__c
            WHERE Field_Name__c = 'FGM_Portal__Instructional_Text__c'
        ];

        System.assertEquals(NUM_TRANSLATIONS, originalTranslations.size(),
            'The original translations should still exist');

        List<Field_Value_Translation__c> newTranslations = [
            SELECT RecordID__c, Translation_Value__c
            FROM Field_Value_Translation__c
            WHERE Field_Name__c = 'FGM_Portal__Rich_Instructional_Text__c'
        ];

        System.assertEquals(NUM_TRANSLATIONS, newTranslations.size(),
            'The correct number of translations should have been created for FGM_Portal__Rich_Instructional_Text__c');

        for (Field_Value_Translation__c translation : newTranslations) {
            Field_Value_Translation__c originalTranslation =
                instructionalTextTranslationsByRecordId.get(translation.RecordId__c);

            System.assertEquals(
                originalTranslation.Translation_Value__c,
                instructionalTextTranslationsByRecordId.get(translation.RecordId__c).Translation_Value__c,
                'The FGM_Portal__Instructional_Text__c translation should be cloned to a FGM_Portal__Rich_Instructional_Text__c translation'
            );
        }
    }

}