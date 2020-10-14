@isTest
public class BatchUtilityHelperTest {
    static testMethod void testFileHandlerBatch() {
        ProcessorControl.isEscapeCDLTrigger = True;
        List<Campaign> lstCampaign = new List<Campaign>();
        List<FGM_Portal__Quiz__c> lstQuizzes = new List<FGM_Portal__Quiz__c>();
        List<FGM_Portal__Campaign_Quiz__c> lstCampaignQuizzes = new List<FGM_Portal__Campaign_Quiz__c>();
        for(Integer index = 1; index<=5; index++){
            Campaign campaign = new Campaign(name='Batch Campaign'+index,FGM_Portal__Visibility__c='Public');
            lstCampaign.add(campaign);
        }
        insert(lstCampaign);
        for(Integer index = 1; index<=5; index++){
            FGM_Portal__Quiz__c objQuiz = TestsObjectProvider.CreateFGMPortalQuiz('Test Quiz - ' + index, '', '', '', '', '', '', 'Test Instruction - ' + index, true);
            lstQuizzes.add(objQuiz);
        }
        insert lstQuizzes;
        for(Integer index = 0; index<=4; index++){
            FGM_Portal__Campaign_Quiz__c objCampaignQuiz = new FGM_Portal__Campaign_Quiz__c();
            objCampaignQuiz.FGM_Portal__Quiz__c = lstQuizzes[index].Id;
            objCampaignQuiz.FGM_Portal__Campaign__c = lstCampaign[index].Id;
            objCampaignQuiz.FGM_Portal__isActive__c = true;
            lstCampaignQuizzes.add(objCampaignQuiz);
        }
        insert lstCampaignQuizzes;
        List<ContentDocumentLink> lstContentDocumentLink = new List<ContentDocumentLink>();
        List<ContentVersion> lstContentVersion = new List<ContentVersion>();
        Set<String> setCampaignId = new Set<String>();
        for(Integer index = 1; index<=250; index++){
            Blob data = Blob.valueOf('Test Version Data');
            ContentVersion contentVersion = new ContentVersion(Title='Test Version',PathOnClient='Test Path',VersionData=data);
            lstContentVersion.add(contentVersion);
        }
        insert(lstContentVersion);
       lstContentVersion = [SELECT ContentDocumentId FROM ContentVersion];
        Integer Count = 0;
        for(integer i=0;i<lstCampaign.size();i++){
            setCampaignId.add(lstCampaign[i].Id);
               ContentDocumentLink contentDoclink = new ContentDocumentLink(ContentDocumentId=lstContentVersion[0].ContentDocumentId,Visibility='InternalUsers',LinkedEntityId=lstCampaign[i].Id,ShareType='V');
               lstContentDocumentLink.add(contentDoclink);
        }
        insert lstContentDocumentLink;
        ProcessorControl.isEscapeCDLTrigger = false;
        system.assertEquals(5,[SELECT count() FROM ContentDocumentLink WHERE LinkedEntityId IN:setCampaignId]);
        Test.startTest();
        BatchUtility batchUtil1 = new BatchUtility('UpdateCampaignQuizInstruction',true);
        Database.executeBatch(batchUtil1);

        BatchUtility batchUtil2 = new BatchUtility('UpdateAttachment',true);
        Database.executeBatch(batchUtil2);

        FGM_Portal__Grantee_Budget_Category__c categoryAdmin = TestsObjectProvider.CreateGranteeBudgetCategory('Admin');
        categoryAdmin.FGM_Portal__Parent_Category__c = null;
        insert categoryAdmin;

        FGM_Portal__Grantee_Budget_Category__c categorySystem = TestsObjectProvider.CreateGranteeBudgetCategory('System Admin');
        categorySystem.FGM_Portal__Parent_Category__c = categoryAdmin.Id;
        insert categorySystem;

        Opportunity opportunity = TestsObjectProvider.CreateOpportunity('testOpp', 'In Progress', Date.today());
        Database.Saveresult[] ResultOpportunity = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunity});

        FGM_Base__Grantee_Report__c FGMBaseGranteeReport11 = TestsObjectProvider.CreateFGMBaseGranteeReport(null, opportunity.Id, 'Received'); //newGranteeReportRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GRANTEEREPORT_NARRATIVEREPORT).getRecordTypeId()
        FGMBaseGranteeReport11.FGM_Base__Display_Benchmark__c = true;
        Database.Saveresult[] ResultFGMBaseGranteeReport11 = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Grantee_Report__c>{FGMBaseGranteeReport11});

        BatchUtility batchUtil3 = new BatchUtility('CreateGBUbyCategory',true);
        Database.executeBatch(batchUtil3);

        Campaign camp = new Campaign();
        camp.Name = 'EnzCamp';
        camp.FGM_Portal__Visibility__c = 'Public';
        insert camp;
        system.assertNotEquals(camp.Id, null);
        List<ContentDocument> cds = [ SELECT Id FROM ContentDocument LIMIT 1 ];
        ContentDocumentLink cdLink = new ContentDocumentLink();
        cdLink.ContentDocumentId = cds[0].Id;
        cdLink.LinkedEntityId = camp.Id;
        cdLink.ShareType = 'V';
        cdLink.Visibility = 'InternalUsers';
        insert cdLInk;
        system.assertNotEquals(cdLInk.Id, null);
        Test.stopTest();
        //system.assertEquals(5,[SELECT count() FROM ContentDocumentLink WHERE LinkedEntityId IN:setCampaignId AND Visibility='AllUsers']);
        BatchUtility batchUtil = new BatchUtility('UpdateCampaign',true);
        Database.executeBatch(batchUtil);
    }
}