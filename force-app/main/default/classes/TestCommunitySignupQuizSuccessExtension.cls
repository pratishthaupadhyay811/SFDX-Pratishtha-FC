@isTest
private class TestCommunitySignupQuizSuccessExtension {
     static testMethod void CommunitySignupQuizSuccessExtension() {
        List<User> lstSysAdminUsers = [ SELECT Id
                                        FROM User
                                        WHERE Profile.Name ='System Administrator'
                                        AND IsActive = true
                                      ];

        Map<String,Schema.Recordtypeinfo> newPortalQuizRecordTypeMapByName = FGM_Portal__Quiz__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        FGM_Portal__Quiz__c FGMPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz('PortalQuiz1', 'test@test1.com', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
        FGMPortalQuiz.FGM_Portal__Success_URL__c = '~/apex/FGM_Portal__CommunitySignup';
        FGMPortalQuiz.RecordTypeId = newPortalQuizRecordTypeMapByName.get('Quiz').getRecordTypeId();
        Database.Saveresult[] ResultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{FGMPortalQuiz});

        ApexPages.StandardController scFGMPortalQuiz = new ApexPages.standardController(FGMPortalQuiz);
        CommunitySignupQuizSuccessExtension commSignUpQuizSuccess = new CommunitySignupQuizSuccessExtension(scFGMPortalQuiz);
        commSignUpQuizSuccess.getImageLogoUrl();
        commSignUpQuizSuccess.continueSignUp();
        FGMPortalQuiz.FGM_Portal__Success_URL__c = '';
         update FGMPortalQuiz;
         commSignUpQuizSuccess.continueSignUp();
     }
}