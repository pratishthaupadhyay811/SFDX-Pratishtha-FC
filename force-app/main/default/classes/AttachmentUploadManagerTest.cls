@isTest
public class AttachmentUploadManagerTest {
    static testMethod void CommunityApplicationExtension()
    {
        Opportunity opportunity1= TestsObjectProvider.CreateOpportunity( 'Test1', 'In Progess', Date.today() );
        Database.SaveResult[] ResultOpportunity1 = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunity1});
        system.debug('ResultOpportunity1' + ResultOpportunity1);

        Blob data = Blob.valueOf('Unit Test Attachment Body');
        // Attachments
        Attachment attachmentToInsert = new Attachment();
        attachmentToInsert.Name = 'TestAttach1' ;
        attachmentToInsert.Body = Blob.valueOf('test data');
        attachmentToInsert.Description = 'TestAttach1 Description';
        attachmentToInsert.ParentId = ResultOpportunity1[0].Id;
        insert attachmentToInsert;
        system.assertNotEquals( attachmentToInsert.Id, null );

        //FeedItem

        FeedItem feeditemToInsert = new FeedItem();
        feeditemToInsert.Body = 'FeedattachmentOne';
        feeditemToInsert.ParentId = ResultOpportunity1[0].Id;
        feeditemToInsert.Title='TestFeeditem1';
        insert feeditemToInsert;
        system.assertNotEquals( feeditemToInsert.Id, null );

        //contentdocument

        ContentVersion contentVersionToInsert = new ContentVersion();
        contentVersionToInsert.title = 'test content trigger';
        contentVersionToInsert.PathOnClient ='test';
        contentVersionToInsert.VersionData = data;
        insert contentVersionToInsert;
        system.assertNotEquals( contentVersionToInsert.Id, null );

        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :contentVersionToInsert.Id];

        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ResultOpportunity1[0].Id;
        contentlink.ShareType= 'I';
        contentlink.ContentDocumentId=testcontent.ContentDocumentId;

        insert contentlink;
        Map<String,Schema.Recordtypeinfo> newRelatedListRecordTypeMapByName = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        Map<String,Schema.Recordtypeinfo> newPortalQuestionRecordTypeMapByName = FGM_Portal__Questions__c.SObjectType.getDescribe().getRecordTypeInfosByName();

        FGM_Portal__Quiz__c FGMPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz('PortalQuiz1', 'test@test1.com', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
        Database.Saveresult[] ResultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{FGMPortalQuiz});

        List<FGM_Portal__Questions__c> lstFGMPortalQuestion = new List<FGM_Portal__Questions__c>();
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('SF Data Type', '', '', '', 'Salesforce Data Type', ResultFGMPortalQuiz[0].Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Attachment', '', '', '', 'Attachment', ResultFGMPortalQuiz[0].Id, 'Name+FileName', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Amount', '', '', '', 'Salesforce Data Type', ResultFGMPortalQuiz[0].Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        Database.Saveresult[] ResultFGMPortalQuestion = TestsObjectProvider.InsertListWithAssert(lstFGMPortalQuestion);

        FGM_Portal__Question_Attachment__c questionAttachment = new FGM_Portal__Question_Attachment__c();
        questionAttachment.FGM_Portal__Opportunity__c = ResultOpportunity1[0].Id;
        questionAttachment.FGM_Portal__Question__c = ResultFGMPortalQuestion[1].Id;
        questionAttachment.FGM_Portal__Description__c = 'Test Description';
        Database.SaveResult svRslt = Database.insert(questionAttachment);

        Attachment attachmentOne = new Attachment();
        attachmentOne.Body = Blob.valueOf('attachmentOne');
        attachmentOne.Name = 'attachmentOne';
        attachmentOne.ParentId = questionAttachment.Id;
        insert attachmentOne;
        List<Id> lst = new List<Id>();
        lst.add(attachmentOne.Id);

        Attachment attachmentOne1 = new Attachment();
        attachmentOne1.Body = Blob.valueOf('attachmentOne');
        attachmentOne1.Name = 'attachmentOne';
        attachmentOne1.ParentId = questionAttachment.Id;
        insert attachmentOne1;
        List<Id> lst2 = new List<Id>();
        lst2.add(attachmentOne1.Id);
        system.assertNotEquals( attachmentOne1.Id, null );

        FeedItem FeedOne = new FeedItem();
        FeedOne.ParentId=questionAttachment.Id;
        FeedOne.Body='FeedattachmentOne';
        FeedOne.Title='test';
        insert FeedOne;




        AttachmentUploadManager.getAttachments(null,'FGM_Portal__Opportunity__c',ResultOpportunity1[0].Id);

        AttachmentUploadManager.getApplicationRecord('FGM_Portal__Opportunity__c',ResultOpportunity1[0].Id);
        AttachmentUploadManager.AttachmentComponentSettingsWrapper  Attachment_component_settings_wrapper = new AttachmentUploadManager.AttachmentComponentSettingsWrapper(true,'','en_Us','42');

        AttachmentUploadManager.deleteAttachments('ContentDocument',lst,questionAttachment.id);
        AttachmentUploadManager.deleteAttachments('Attachment',lst2,questionAttachment.id);
        CommunityApplicationExtension.getAttachmentComponentSettings(true,'','en_Us','42');
        Set<Id> setQuestionIds = new Set<id>();
        setQuestionIds.add(ResultFGMPortalQuestion[0].id);
        AttachmentUploadManager.AttachmentWrapper Attachment_Wrapper_Attachment = new AttachmentUploadManager.AttachmentWrapper(attachmentOne1,setQuestionIds,QuestionAttachment,true);

    }

}