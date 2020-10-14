@isTest
public class TestQuestionAttachmentsAccountExtension {
    static testMethod void CheckAttachmentUpload()
    {
        Lead objLead = new Lead();
        objLead.LastName = 'LeadLastName';
        objLead.Company = 'RoundCorner';
        objLead.Status = 'In Progress';
        insert objLead;
        system.assertNotEquals( objLead.Id, null );

        Account objAcc = new Account();
        objAcc.Name = 'TestAcc';
        insert objAcc;
        system.assertNotEquals( objAcc.Id, null );

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(objLead.id);
        lc.setAccountId(objAcc.Id);
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        update objLead;

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
        objQstnAttchmnt.FGM_Portal__Inquiry__c = objLead.Id;
        objQstnAttchmnt.FGM_Portal__Question__c = objQuestion.Id;
        insert objQstnAttchmnt;
        system.assertNotEquals( objQstnAttchmnt.Id, null );

        FGM_Portal__Question_Attachment__c objQstnAttchmnt1 = new FGM_Portal__Question_Attachment__c();
        objQstnAttchmnt1.FGM_Portal__Inquiry__c = objLead.Id;
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

        PageReference pageRef = Page.QuestionAttachmentsAccount;
        Test.setCurrentPage(pageRef);
        QuestionAttachmentsAccountExtension objQAControllerAccount = new QuestionAttachmentsAccountExtension(new ApexPages.StandardController(objAcc));
        objQAControllerAccount.Reload();
        objQAControllerAccount.varAssignmentId = objFeed.Id;
        objQAControllerAccount.EditPageRedirect();
        //objQAControllerAccount.DeleteFeedAttachment();
        objQAControllerAccount.varAssignmentId = objAttchmnt.Id;
        objQAControllerAccount.DeleteAttachment();
    }
}