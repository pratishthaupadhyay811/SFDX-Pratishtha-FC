@isTest
public class AttachmentUploadIframeTest {

    static testmethod void TestAttachmentUploadIframe()
    {
        Opportunity opportunity1= TestsObjectProvider.CreateOpportunity( 'Test1', 'In Progess', Date.today() );
        Database.SaveResult[] ResultOpportunity1 = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunity1});

        AttachmentUploadIframeController objattach = new AttachmentUploadIframeController();
        ApexPages.currentPage().getParameters().put('appId', ResultOpportunity1[0].Id);
        ApexPages.currentPage().getParameters().put('mode', 'view');
        objattach.initialize();
        objattach.getQueryString();

        Lead lead = new Lead();
        lead.LastName='Test';
        lead.Company='test';
        lead.Status='In Progress';
        lead.FGM_Base__Attachments_to_Request_on_Conversion__c = true;
        insert lead;

        AttachmentUploadIframeController objattach1 = new AttachmentUploadIframeController();
        ApexPages.currentPage().getParameters().put('appId', lead.Id);
        ApexPages.currentPage().getParameters().put('mode', 'view');
        objattach1.initialize();

        FGM_Base__Grantee_Report__c FGMBaseGranteeReport11 = new FGM_Base__Grantee_Report__c();
        FGMBaseGranteeReport11.FGM_Base__Display_Benchmark__c = true;
        FGMBaseGranteeReport11.FGM_Base__Request__c = opportunity1.Id;
        insert FGMBaseGranteeReport11;

        AttachmentUploadIframeController objattach4 = new AttachmentUploadIframeController();
        ApexPages.currentPage().getParameters().put('appId', FGMBaseGranteeReport11.Id);
        ApexPages.currentPage().getParameters().put('mode', 'view');
        objattach4.initialize();

        FGM_Base__Benchmark__c benchmark = new FGM_Base__Benchmark__c();
        benchmark.FGM_Base__Request__c = opportunity1.Id;
        insert benchmark;

        AttachmentUploadIframeController objattach2 = new AttachmentUploadIframeController();
        ApexPages.currentPage().getParameters().put('appId', benchmark.Id);
        ApexPages.currentPage().getParameters().put('mode', 'view');
        objattach2.initialize();

        FGM_Portal__Amendment__c contactAmendment = new FGM_Portal__Amendment__c();
        insert contactAmendment;

        AttachmentUploadIframeController objattach3 = new AttachmentUploadIframeController();
        ApexPages.currentPage().getParameters().put('appId', contactAmendment.Id);
        ApexPages.currentPage().getParameters().put('mode', 'view');
        objattach3.initialize();

        AttachmentUploadIframeController objattach5 = new AttachmentUploadIframeController();
        objattach5.LookupApiName = null;
        objattach5.appId = null;
        objattach.initialize();
    }
}