@isTest
public class TestCommunitySignupRejectExtension {
static testMethod void CommunitySignupRejectExtension(){
        Map<String,Schema.Recordtypeinfo> newPortalQuizRecordTypeMapByName = FGM_Portal__Quiz__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        FGM_Portal__Quiz__c FGMPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz('PortalQuiz1', 'test@test1.com', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
        FGMPortalQuiz.FGM_Portal__Failure_URL__c = '~/apex/CommunitiesSignupRejected';
        FGMPortalQuiz.FGM_Portal__Success_URL__c = '~/apex/FGM_Portal__CommunitySignin';
        FGMPortalQuiz.RecordTypeId = newPortalQuizRecordTypeMapByName.get('Quiz').getRecordTypeId();
        Database.Saveresult[] ResultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{FGMPortalQuiz});

        Map<String,Schema.Recordtypeinfo> newPortalQuestionRecordTypeMapByName = FGM_Portal__Questions__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        List<FGM_Portal__Questions__c> lstFGMPortalQuestion = new List<FGM_Portal__Questions__c>();
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Amount', '', '', '', 'Attachment', ResultFGMPortalQuiz[0].Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));

        Database.Saveresult[] ResultsFGMPortalQuestion = TestsObjectProvider.InsertListWithAssert(lstFGMPortalQuestion);
        ApexPages.StandardController sc = new ApexPages.standardController(lstFGMPortalQuestion[0]);
        CommunitySignupRejectExtension obj=new CommunitySignupRejectExtension(sc);
        obj.getQuestion();
        obj.getImageLogoUrl();

    }
}