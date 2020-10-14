@isTest
public class TestQuestionAttachments
{
    static testMethod void CheckAttachmentUpload()
    {
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'OppOne';
        objOpp.StageName = 'In Progress';
        objOpp.CloseDate = system.today();
        insert objOpp;
        system.assertNotEquals( objOpp.Id, null );

        Lead objLead = new Lead();
        objLead.LastName = 'LeadLastName';
        objLead.Company = 'RoundCorner';
        objLead.Status = 'In Progress';
        insert objLead;
        system.assertNotEquals( objLead.Id, null );

        FGM_Portal__Amendment__c objAmendment = new FGM_Portal__Amendment__c();
        insert objAmendment;
        system.assertNotEquals( objAmendment.Id, null );

        FGM_Base__Benchmark__c objBenchmark = new FGM_Base__Benchmark__c();
        objBenchmark.FGM_Base__Request__c = objOpp.Id;
        insert objBenchmark;
        system.assertNotEquals( objBenchmark.Id, null );

        FGM_Base__Grantee_Report__c objGranteeReport = new FGM_Base__Grantee_Report__c();
        objGranteeReport.FGM_Base__Request__c = objOpp.Id;
        insert objGranteeReport;
        system.assertNotEquals( objGranteeReport.Id, null );

        FGM_Portal__Recommendation__c objRecommendation = new FGM_Portal__Recommendation__c();
        objRecommendation.FGM_Portal__Opportunity__c = objOpp.Id;
        insert objRecommendation;
        system.assertNotEquals( objRecommendation.Id, null );

        FGM_Portal__Questions__c objQuestion = new FGM_Portal__Questions__c();
        objQuestion.FGM_Portal__RichQuestion__c = 'Whats there in name?';
        insert objQuestion;
        system.assertNotEquals( objQuestion.Id, null );

        FGM_Portal__Questions__c objQuestion1 = new FGM_Portal__Questions__c();
        objQuestion1.FGM_Portal__RichQuestion__c = 'Whats there in name?';
        objQuestion1.FGM_Portal__Language__c = 'es';
        objQuestion1.FGM_Portal__Parent_QuestionID__c = objQuestion.Id;
        insert objQuestion1;
        system.assertNotEquals( objQuestion1.Id, null );

        FGM_Portal__Question_Attachment__c objQstnAttchmnt = new FGM_Portal__Question_Attachment__c();
        objQstnAttchmnt.FGM_Portal__Opportunity__c = objOpp.Id;
        objQstnAttchmnt.FGM_Portal__Inquiry__c = objLead.Id;
        objQstnAttchmnt.FGM_Portal__Amendment__c = objAmendment.Id;
        objQstnAttchmnt.FGM_Portal__Benchmark_del__c = objBenchmark.Id;
        objQstnAttchmnt.FGM_Portal__GranteeReport__c = objGranteeReport.Id;
        objQstnAttchmnt.FGM_Portal__Recommendation__c = objRecommendation.Id;
        objQstnAttchmnt.FGM_Portal__Question__c = objQuestion.Id;
        insert objQstnAttchmnt;
        system.assertNotEquals( objQstnAttchmnt.Id, null );

        FGM_Portal__Question_Attachment__c objQstnAttchmnt1 = new FGM_Portal__Question_Attachment__c();
        objQstnAttchmnt1.FGM_Portal__Opportunity__c = objOpp.Id;
        objQstnAttchmnt1.FGM_Portal__Inquiry__c = objLead.Id;
        objQstnAttchmnt1.FGM_Portal__Amendment__c = objAmendment.Id;
        objQstnAttchmnt1.FGM_Portal__Benchmark_del__c = objBenchmark.Id;
        objQstnAttchmnt1.FGM_Portal__GranteeReport__c = objGranteeReport.Id;
        objQstnAttchmnt1.FGM_Portal__Recommendation__c = objRecommendation.Id;
        objQstnAttchmnt1.FGM_Portal__Question__c = objQuestion1.Id;
        insert objQstnAttchmnt1;
        system.assertNotEquals( objQstnAttchmnt1.Id, null );

        Attachment objAttchmnt = new Attachment();
        objAttchmnt.Body = Blob.valueOf('This is my body!');
        objAttchmnt.Name = 'objAttchmnt';
        objAttchmnt.ParentId = objQstnAttchmnt.Id;
        insert objAttchmnt;
        system.assertNotEquals( objAttchmnt.Id, null );

        Attachment objAttchmntTwo = objAttchmnt;
        objAttchmntTwo.Id = null;
        objAttchmntTwo.ParentId=objQstnAttchmnt1.Id;
        insert objAttchmntTwo;
        system.assertNotEquals( objAttchmntTwo.Id, null );

        FeedItem objFeed = new FeedItem();
        objFeed.ParentId = objQstnAttchmnt.Id;
        objFeed.Body = 'This is my body!';
        insert objFeed;
        system.assertNotEquals( objFeed.Id, null );

        FeedItem objFeedTwo = objFeed;
        objFeedTwo.Id = null;
        objFeedTwo.ParentId = objQstnAttchmnt1.Id;
        insert objFeedTwo;
        system.assertNotEquals( objFeedTwo.Id, null );

        PageReference pageRef = Page.QuestionAttachments_Opportunity;
        Test.setCurrentPage(pageRef);
        QuestionAttachmentsController objQAControllerOpp = new QuestionAttachmentsController(new ApexPages.StandardController(objOpp));
        objQAControllerOpp.Reload();
        objQAControllerOpp.varAssignmentId = objFeed.Id;
        objQAControllerOpp.EditPageRedirect();
        //objQAControllerOpp.DeleteFeedAttachment();
        objQAControllerOpp.varAssignmentId = objAttchmnt.Id;
        objQAControllerOpp.DeleteAttachment();

        pageRef = Page.QuestionAttachments_Lead;
        Test.setCurrentPage(pageRef);
        QuestionAttachmentsController objQAControllerLead = new QuestionAttachmentsController(new ApexPages.StandardController(objLead));

        pageRef = Page.QuestionAttachments_Amendment;
        Test.setCurrentPage(pageRef);
        QuestionAttachmentsController objQAControllerAmendment = new QuestionAttachmentsController(new ApexPages.StandardController(objAmendment));

        pageRef = Page.QuestionAttachments_Benchmark;
        Test.setCurrentPage(pageRef);
        QuestionAttachmentsController objQAControllerBenchmark = new QuestionAttachmentsController(new ApexPages.StandardController(objBenchmark));

        pageRef = Page.QuestionAttachments_GranteeReport;
        Test.setCurrentPage(pageRef);
        QuestionAttachmentsController objQAControllerGranteeReport = new QuestionAttachmentsController(new ApexPages.StandardController(objGranteeReport));

        pageRef = Page.QuestionAttachments_Recommendation;
        Test.setCurrentPage(pageRef);
        QuestionAttachmentsController objQAControllerRecommendation = new QuestionAttachmentsController(new ApexPages.StandardController(objRecommendation));

    }
}