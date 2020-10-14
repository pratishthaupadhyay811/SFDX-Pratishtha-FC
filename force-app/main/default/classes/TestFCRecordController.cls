@isTest
private class TestFCRecordController{
    static testMethod void FCRecordController(){
        List<User> lstSysAdminUsers = [SELECT Id from User WHERE Profile.Name ='System Administrator' AND IsActive = true ];

        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

        Contact contact = TestsObjectProvider.CreateContact('testContact1', 'testContact1', ResultAccount[0].Id, 'test@test1.com');
        contact.MailingCountry='United States';
        contact.MailingState='New York';
        contact.MailingCity='NY';
        contact.MailingStreet='Baker';
        Database.SaveResult[] ResultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});

        FGM_Portal__PortalConfiguration__c PortalConfiguration = TestsObjectProvider.CreateFGMPortalPortalConfiguration('Applicant Portal', 'Requested;Scheduled;Received', true, true, 'Change Requests', 'Benchmark', false, 'Grantee Inbox', 'Grantee Report', 'en_US', 'Declined;Closed', 'Request', 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started', 'Inquiry', 'Declined;Closed;Submitted', 'Working - Contacted;New;Requested;More Information;Reopened;Application Invited;Open - Not Contacted;In Progress');
        PortalConfiguration.FGM_Portal__RequestDeletableStatus__c = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        PortalConfiguration.FGM_Portal__GranteeReportHiddenStatus__c = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        PortalConfiguration.FGM_Portal__GranteeReportDeletableStatus__c  = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        PortalConfiguration.FGM_Portal__InquiryDeletableStatus__c = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        PortalConfiguration.FGM_Portal__InquiryHiddenStatus__c = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        PortalConfiguration.FGM_Portal__AmendmentHistoryTab__c= 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        PortalConfiguration.FGM_Portal__AmendmentEditableStatus__c  = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        PortalConfiguration.FGM_Portal__AmendmentDeletableStatus__c = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        PortalConfiguration.FGM_Portal__AmendmentHiddenStatus__c = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        PortalConfiguration.FGM_Portal__BenchmarkEditableStatus__c = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        PortalConfiguration.FGM_Portal__BenchmarkDeletableStatus__c = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        PortalConfiguration.FGM_Portal__RequestHiddenStatus__c = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        PortalConfiguration.FGM_Portal__Post_attachments_to_chatter_feeds__c = True;
        Database.Saveresult[] ResultPortalConfiguration = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__PortalConfiguration__c>{PortalConfiguration});

        List<FGM_Portal__Portal_User__c> lstPortalUser = new List<FGM_Portal__Portal_User__c>();
        lstPortalUser.add(TestSObjectProvider.CreateFGMPortalUser(null, 'test@osf-communities-developer-edition.na17.force.com', 'Portal LastName', 'test@test1.com', 'test@test1.com', 'test@osf-communities-developer-edition.na17.force.com', 'Test1234', 'Test1234', true));
        Database.Saveresult[] ResultFGMPortalUser = TestsObjectProvider.InsertListWithAssert(lstPortalUser);

        FGM_Portal__Quiz__c FGMPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz('PortalQuiz1', 'test@test1.com', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
        FGMPortalQuiz.FGM_Portal__IsCommunityRecord__c = true;
        FGM_Portal__Quiz__c FGMAmendmentQuiz = TestsObjectProvider.CreateFGMPortalQuiz('Amendment Contact Quiz', '', '', '', '', '', '', 'Amendment Instruction', true );
        FGMAmendmentQuiz.FGM_Portal__IsCommunityRecord__c = true;
        FGM_Portal__Quiz__c FGMAccountAmendmentQuiz = TestsObjectProvider.CreateFGMPortalQuiz('Amendment Account Quiz', '', '', '', '', '', '', 'Amendment Instruction', true );
        FGMAccountAmendmentQuiz.FGM_Portal__IsCommunityRecord__c = true;
        Database.Saveresult[] ResultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{FGMPortalQuiz,FGMAmendmentQuiz,FGMAccountAmendmentQuiz});

        Campaign campaign = TestsObjectProvider.CreateCampaign('TestCampaign', 'test@test1.com', Date.today(), Date.today(), ResultFGMPortalQuiz[0].Id,null);
        Database.Saveresult[] Resultcampaign = TestsObjectProvider.InsertListWithAssert(new List<Campaign>{campaign});

        Map<String,Schema.Recordtypeinfo> newRelatedListRecordTypeMapByName = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        List<FGM_Portal__Related_List_Controller__c> lstFGMPortalRelatedListController = new List<FGM_Portal__Related_List_Controller__c>();
        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListName', 'Grantee', 'Details', 'FGM_Portal__Amendment__c', 'FGM_Base__Grantee_Report__c', 'FGM_Base__Grantee_Report__c', 'Name', 'Name', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortalRelatedListController[0].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListName1', 'Reviewer', 'Details', 'FGM_Portal__Amendment__c', 'Opportunity', 'FGM_Portal__ParentRequest__c', 'Field To Be Edited', 'FGM_Portal__Field_To_Be_Edited__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortalRelatedListController[1].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('Budget Update', 'Grantee', 'Details', 'FGM_Portal__Grantee_Budget_Update__c', 'FGM_Base__Grantee_Report__c', 'FGM_Portal__Grantee_Budget_Update__c', 'Field To Be Edited', 'FGM_Portal__Field_To_Be_Edited__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_GRANTEEBUDGETUPDATETAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortalRelatedListController[2].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('Benchmark Update', 'Grantee', 'Details', 'FGM_Base__Benchmark_Update__c', 'FGM_Base__Grantee_Report__c', 'FGM_Base__Grantee_Report__c', 'Amount Update,Description', 'FGM_Base__Amount_Update__c,FGM_Base__Benchmark__r.FGM_Base__Description__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortalRelatedListController[3].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('Contact Amendment', 'Grantee', 'Details', 'FGM_Portal__Amendment__c', 'FGM_Portal__Amendment__c', 'FGM_Portal__Amendment__c', 'Amount Update', 'FGM_Base__Amount_Update__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB).getRecordTypeId(), ResultFGMPortalQuiz[1].Id));
        lstFGMPortalRelatedListController[4].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('Account Amendment', 'Grantee', 'Details', 'FGM_Portal__Amendment__c', 'FGM_Portal__Amendment__c', 'FGM_Portal__Amendment__c', 'Amount Update', 'FGM_Base__Amount_Update__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB).getRecordTypeId(), ResultFGMPortalQuiz[2].Id));
        lstFGMPortalRelatedListController[5].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('IFrame Tab', 'Grantee', 'Details', 'FGM_Base__Grantee_Report__c', 'FGM_Base__Grantee_Report__c', 'FGM_Base__Grantee_Report__c', '', '', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_IFRAMETAB).getRecordTypeId(), ResultFGMPortalQuiz[2].Id));
        lstFGMPortalRelatedListController[6].FGM_Portal__BaseUrl__c='https://fgm-portal.na7.visual.force.com/apex/DynamicIFrameTest?id={FGM_Base__Grantee_Report__c.id}';
        //PORTAL_RELATEDLISTCONTROLLER_IFRAMETAB
        Database.Saveresult[] ResultsFGMPortalRelatedListController = TestsObjectProvider.InsertListWithAssert(lstFGMPortalRelatedListController);

        Map<String,Schema.Recordtypeinfo> newPortalQuestionRecordTypeMapByName = FGM_Portal__Questions__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        List<FGM_Portal__Questions__c> FGMPortalQuestion = new List<FGM_Portal__Questions__c>();
        FGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Amount', '', '', '', 'Attachment', ResultFGMPortalQuiz[0].Id, '\'test_fileName\'+FileName', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        FGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Salesforce Data Type Question', '', null, '', 'Salesforce Data Type', ResultFGMPortalQuiz[0].Id,'', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        Database.Saveresult[] ResultFGMPortalQuestion = TestsObjectProvider.InsertListWithAssert(FGMPortalQuestion);

        List<FGM_Portal__Quiz_Questions__c> lstFGMPortalQuizQuestion = new List<FGM_Portal__Quiz_Questions__c>();
        lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(ResultFGMPortalQuestion[0].Id, 1, '', '', 50, '1', ResultsFGMPortalRelatedListController[0].Id, false, ResultFGMPortalQuiz[0].Id));
        lstFGMPortalQuizQuestion[0].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalQuizQuestion[0].FGM_Portal__Required__c = true;
        lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(ResultFGMPortalQuestion[1].Id, 2, 'FGM_Portal__Description__c', '', 50, '1', ResultsFGMPortalRelatedListController[1].Id, true, ResultFGMPortalQuiz[0].Id));
        lstFGMPortalQuizQuestion[0].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalQuizQuestion[0].FGM_Portal__Required__c = true;
        Database.Saveresult[] ResultsFGMPortalQuizQuestion = TestsObjectProvider.InsertListWithAssert(lstFGMPortalQuizQuestion);

        Opportunity opportunity = TestsObjectProvider.CreateOpportunity('testOpp', 'In Progress', Date.today());
        Database.Saveresult[] ResultOpportunity = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunity});

        Lead lead = TestsObjectProvider.CreateLead('TestLeadFName', 'TestLeadLName', 'TestCompany', 'In Progress');
        Database.Saveresult[] ResultLead = TestsObjectProvider.InsertListWithAssert(new List<Lead>{lead});

        Map<String,Schema.Recordtypeinfo> newGranteeReportRecordTypeMapByName = FGM_Base__Grantee_Report__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        FGM_Base__Grantee_Report__c FGMBaseGranteeReport = TestsObjectProvider.CreateFGMBaseGranteeReport(null, ResultOpportunity[0].Id, 'Received');
        FGMBaseGranteeReport.FGM_Base__Display_Benchmark__c = true;
        Database.Saveresult[] ResultFGMBaseGranteeReport = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Grantee_Report__c>{FGMBaseGranteeReport});

        Attachment attachment = TestsObjectProvider.CreateAttachment('Attachment1', ResultFGMPortalQuestion[0].Id);
        attachment.IsPrivate = true;
        attachment.OwnerId = lstSysAdminUsers[0].Id;
        Database.Saveresult[] ResultAttachment = TestsObjectProvider.InsertListWithAssert(new List<Attachment>{attachment});


        FCRecordController objFCRecord = new FCRecordController();
        objFCRecord.portalLanguage='en_US';
        objFCRecord.portalConfigurationFields=PortalConfiguration;
        objFCRecord.attachment=attachment;
        objFCRecord.JSONapplicationSubmissionData='';
        objFCRecord.strHiddenValue='';
        objFCRecord.rollbackWithError('',Database.setSavepoint());
        objFCRecord.application=lead;
        objFCRecord.application.put('FGM_Base__Request__c','');
        objFCRecord.hideGRBudgetUpdateTab(lstFGMPortalRelatedListController);
        objFCRecord.initializeQuizQuestionList('IFrame Tab');

        Question_Attachment__c QuestionAttachment = TestsObjectProvider.CreateQuestionAttachment(ResultFGMPortalQuestion[0].Id, ResultOpportunity[0].Id, null, ResultFGMBaseGranteeReport[0].Id);
        Database.Saveresult[] ResultQuestionAttachment = TestsObjectProvider.InsertListWithAssert(new List<Question_Attachment__c>{QuestionAttachment});
        Question_Attachment__c QuestionAttachment1 = TestsObjectProvider.CreateQuestionAttachment(ResultFGMPortalQuestion[0].Id, ResultOpportunity[0].Id, null, ResultFGMBaseGranteeReport[0].Id);
        Database.Saveresult[] ResultQuestionAttachment1 = TestsObjectProvider.InsertListWithAssert(new List<Question_Attachment__c>{QuestionAttachment1});

        Attachment attachmentQuestion = TestsObjectProvider.CreateAttachment('Attachment3', ResultQuestionAttachment[0].Id);
        Database.Saveresult[] ResultAttachmentQuestion = TestsObjectProvider.InsertListWithAssert(new List<Attachment>{attachmentQuestion});

        Attachment attachmentQuestion1 = TestsObjectProvider.CreateAttachment('Attachment2', ResultQuestionAttachment[0].Id);

        //Get Record Type for Amendment on PageLayout
        Map<String,Schema.Recordtypeinfo> newAmendmentRecordTypeMapByName = FGM_Portal__Amendment__c.SObjectType.getDescribe().getRecordTypeInfosByName();

        List<FCPageLayout__c> lstFCPageLayout = new List<FCPageLayout__c>();
        lstFCPageLayout.add(TestsObjectProvider.CreateFCPageLayout('PageLayoutGrantee1', null, 'FGM_Base__Grantee_Report__c', ResultFGMPortalQuiz[0].Id)); //newGranteeReportRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GRANTEEREPORT_NARRATIVEREPORT).getRecordTypeId()
        lstFCPageLayout.add(TestsObjectProvider.CreateFCPageLayout('PageLayoutContactAmendment', newAmendmentRecordTypeMapByName.get(TestsObjectProvider.PORTAL_PAGELAYOUT_CONTACTAMENDMENT).getRecordTypeId(), 'FGM_Portal__Amendment__c', ResultFGMPortalQuiz[1].Id));
        lstFCPageLayout.add(TestsObjectProvider.CreateFCPageLayout('PageLayoutAccountAmendment', newAmendmentRecordTypeMapByName.get(TestsObjectProvider.PORTAL_PAGELAYOUT_ACCOUNTAMENDMENT).getRecordTypeId(), 'FGM_Portal__Amendment__c', ResultFGMPortalQuiz[2].Id));
        Database.Saveresult[] ResultsFCPageLayout = TestsObjectProvider.InsertListWithAssert(lstFCPageLayout);

        //Amendment for Contact
        FGM_Portal__Amendment__c contactAmendment = new FGM_Portal__Amendment__c();
        contactAmendment.FGM_Portal__Contact__c = contact.Id;
        contactAmendment.RecordTypeId = newAmendmentRecordTypeMapByName.get(TestsObjectProvider.PORTAL_PAGELAYOUT_CONTACTAMENDMENT).getRecordTypeId();
        insert contactAmendment;
        System.assertNotEquals(contactAmendment.Id, null);

         //Amendment for Organization
        FGM_Portal__Amendment__c orgAmendment = new FGM_Portal__Amendment__c();
        orgAmendment.FGM_Portal__Account__c = account.Id;
        orgAmendment.RecordTypeId = newAmendmentRecordTypeMapByName.get(TestsObjectProvider.PORTAL_PAGELAYOUT_ACCOUNTAMENDMENT).getRecordTypeId();
        insert orgAmendment;
        System.assertNotEquals(orgAmendment.Id, null);

        FCRecordController fcRecordApp1 = new FCRecordController();

        fcRecordApp1.portalLanguage='en_US';
        Pagereference fcPageReference1 = Page.FCRecord;
        Test.setCurrentPageReference(fcPageReference1);
        ApexPages.currentPage().getParameters().put('id', ResultFGMBaseGranteeReport[0].Id);
        ApexPages.currentPage().getParameters().put('tabId', ResultsFGMPortalRelatedListController[3].Id);
        ApexPages.currentPage().getParameters().put('mode', 'edit');

        fcRecordApp1.initialize();
        fcRecordApp1.initializeApplication();

        //lstFGMPortalRelatedListController[6]
        fcRecordApp1.tabsList=lstFGMPortalRelatedListController;
        fcRecordApp1.quiz = FGMPortalQuiz ;
        fcRecordApp1.initializeTabs();
        fcRecordApp1.tabsList=null;
        fcRecordApp1.getApplicationObjectName();
        FGM_Portal__CommunitySetting__c CommSetting = new FGM_Portal__CommunitySetting__c();
        CommSetting.Name='IsAttachmentDescriptionEnabled';
        CommSetting.FGM_Portal__IsEnabled__c=true;
        Boolean bIsIsFileDescriptionEnabled=fcRecordApp1.IsFileDescriptionEnabled;

        //Benchmark Update Test Cases
        FGM_Base__Benchmark__c benchmark = new FGM_Base__Benchmark__c();
        benchmark.FGM_Base__Request__c = opportunity.Id;
        benchmark.FGM_Base__Status__c = 'Accepted';
        benchmark.FGM_Base__Benchmark_Type__c = 'Percentage; Amount; Number';
        benchmark.FGM_Base__Request_Update_on_Report__c = true;
        insert benchmark;
        System.assertNotEquals(benchmark.Id, null);

        FGM_Base__Benchmark__c benchmark1 = new FGM_Base__Benchmark__c();
        benchmark1.FGM_Base__Request__c = opportunity.Id;
        benchmark1.FGM_Base__Status__c = 'Accepted';
        benchmark1.FGM_Base__Benchmark_Type__c = 'Percentage;Amount';
        benchmark1.FGM_Base__Request_Update_on_Report__c = true;
        insert benchmark1;
        System.assertNotEquals(benchmark1.Id, null);

        FGM_Base__Benchmark_Update__c benchmarkUpdates = new FGM_Base__Benchmark_Update__c();
        benchmarkUpdates.FGM_Base__Amount_Update__c=2999;
        benchmarkUpdates.FGM_Base__Grantee_Report__c=FGMBaseGranteeReport.id;
        benchmarkUpdates.FGM_Base__Benchmark__c=benchmark.id;

        FGM_Base__Benchmark_Update__c benchmarkUpdates1 = new FGM_Base__Benchmark_Update__c();
        benchmarkUpdates1.FGM_Base__Amount_Update__c=2999;
        benchmarkUpdates1.FGM_Base__Grantee_Report__c=FGMBaseGranteeReport.id;
        benchmarkUpdates1.FGM_Base__Benchmark__c=benchmark1.id;

        FCRecordController.BenchmarkUpdateRecords objBURecord1 = new FCRecordController.BenchmarkUpdateRecords();
        objBURecord1.objBenchmark = benchmark;
        objBURecord1.objBU = benchmarkUpdates;

        FCRecordController.BenchmarkUpdateRecords objBURecord2 = new FCRecordController.BenchmarkUpdateRecords();
        objBURecord2.objBenchmark = benchmark1;
        objBURecord2.objBU = benchmarkUpdates1;

        list<FCRecordController.BenchmarkUpdateRecords> lstBURecords = new list<FCRecordController.BenchmarkUpdateRecords>{objBURecord1,objBURecord2};

        Pagereference fcPageReference = Page.FCRecord;
        Test.setCurrentPageReference(fcPageReference);
        ApexPages.currentPage().getParameters().put('id', ResultFGMBaseGranteeReport[0].Id);
        ApexPages.currentPage().getParameters().put('tabId', ResultsFGMPortalRelatedListController[3].Id);
        ApexPages.currentPage().getParameters().put('mode', 'view');

        FCRecordController fcRecordApp = new FCRecordController();
        fcRecordApp.portalLanguage='en_US';
        fcRecordApp.quiz = FGMPortalQuiz ;
        fcRecordApp.initialize();
        fcRecordApp.tabObject = lstFGMPortalRelatedListController[3];
        fcRecordApp.initializeQuizQuestionList();
        fcRecordApp.application=FGMPortalQuestion[0];
        fcRecordApp.submit();
        fcRecordApp.application= FGMBaseGranteeReport;
        FGM_Portal__Related_List_Controller__c FGMPortalRelatedListController1 = TestsObjectProvider.CreateFGMPortalRelatedListController('Benchmark Update', 'Grantee', 'Details', 'FGM_Base__Benchmark_Update__c', 'FGM_Base__Grantee_Report__c', 'FGM_Base__Grantee_Report__c', 'Amount Update', 'FGM_Base__Amount_Update__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id);
        FGMPortalRelatedListController1.FGM_Portal__IsCommunityRecord__c = true;
        Database.Saveresult[] ResultFGMPortalRelatedListController1 = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Related_List_Controller__c>{FGMPortalRelatedListController1});

        List<FGM_Portal__Related_List_Controller__c> lst = new List<FGM_Portal__Related_List_Controller__c> { FGMPortalRelatedListController1 };
        fcRecordApp.relatedListConfiguration = new FCRecordController.relatedList();
        fcRecordApp.relatedListConfiguration.strRelatedListObject = 'FGM_Base__Benchmark_Update__c';
        fcRecordApp.relatedListConfiguration.lstRelatedListRecord = lstBURecords;
        Test.startTest();
        ApexPages.currentPage().getParameters().put('recordIndex', '0');
        fcRecordApp.editBenchmarkUpdateRecord();
        fcRecordApp.saveBenchMarkUpdate();
        fcRecordApp.viewBenchmarkUpdateRecord();

        ApexPages.currentPage().getParameters().put('recordIndex', '1');
        fcRecordApp.editBenchmarkUpdateRecord();
        fcRecordApp.saveBenchMarkUpdate();
        fcRecordApp.deleteBenchmarkUpdateRecord();

        //End Benchmark Update
        FGM_Portal__StateCountryConfig__c objStateCountryConfig = new FGM_Portal__StateCountryConfig__c();
        objStateCountryConfig.Name = 'India';
        objStateCountryConfig.FGM_Portal__CountryCode__c ='IN';
        objStateCountryConfig.FGM_Portal__PicklistValues__c = '{"MH":"Maharashtra","ML":"Meghalaya","MN":"Manipur","MP":"Madhya Pradesh"}';

        Database.upsert(new List<FGM_Portal__StateCountryConfig__c> {objStateCountryConfig});
        Pagereference testPageReference = Page.FCRecord;
        Test.setCurrentPageReference(testPageReference);
        ApexPages.currentPage().getParameters().put('id', ResultFGMBaseGranteeReport[0].Id);
        ApexPages.currentPage().getParameters().put('tabId', ResultsFGMPortalRelatedListController[0].Id);
        ApexPages.currentPage().getParameters().put('attachedQuestionId', ResultFGMPortalQuestion[0].Id);
        ApexPages.currentPage().getParameters().put('attachedId', ResultAttachment[0].Id);
        ApexPages.currentPage().getParameters().put('mode', 'edit');

        Amendment__c amendment = TestsObjectProvider.CreateAmendment(ResultAccount[0].Id, 'In Progress', null, ResultOpportunity[0].Id, Date.today(), Date.today());
        Database.Saveresult[] ResultAmendment = TestsObjectProvider.InsertListWithAssert(new List<Amendment__c>{amendment});


        FCRecordController communitiesApp = new FCRecordController();
        communitiesApp.portalLanguage='en_US';
        Boolean IsFileDescriptionEnabled = communitiesApp.IsFileDescriptionEnabled ;
        communitiesApp.quiz = FGMPortalQuiz;
        communitiesApp.mapApplicationAttachments = new Map<string,FCRecordController.ApplicationAttachments>();
        FCRecordController.ApplicationAttachments appAttachment = new FCRecordController.ApplicationAttachments();
        appAttachment.strQuestionAttachmentId = ResultFGMPortalQuestion[0].Id;
        appAttachment.newAttachment = attachment;
        communitiesApp.mapApplicationAttachments.put(ResultFGMPortalQuestion[0].Id, appAttachment);

        communitiesApp.initializeQuizQuestionList();
        communitiesApp.saveRecordOnTabChange();
        communitiesApp.initializeReview();

        FGM_Portal__GlobalPortalSettings__c PortalSetting = FGM_Portal__GlobalPortalSettings__c.getInstance();
        if( PortalSetting.SetupOwnerId != null){
            PortalSetting = new FGM_Portal__GlobalPortalSettings__c( Name = 'Global Portal Settings');
            PortalSetting.FGM_Portal__Virus_Scan_URL__c = 'http://54.175.69.46/ScanManager/ScanFileManager.asmx';
            PortalSetting.FGM_Portal__Is_VirusScan_Enabled__c = True;
            PortalSetting.FGM_Portal__Grantee_Report_Order_by_Date__c = 'FGM_Base__Due_Date__c';
            PortalSetting.FGM_Portal__Grantee_Portal_Prefix__c = 'fcgrantee';
            PortalSetting.FGM_Portal__Reviewer_Portal_Prefix__c = 'grantee';
            insert PortalSetting;
            System.assertNotEquals( PortalSetting.Id, null);
        }

        communitiesApp.mapApplicationAttachments = new Map<string,FCRecordController.ApplicationAttachments>();
        FCRecordController.ApplicationAttachments feedAttachment = new FCRecordController.ApplicationAttachments();
        feedAttachment.strQuestionAttachmentId = ResultFGMPortalQuestion[0].Id;
        feedAttachment.newAttachment = attachment;
        communitiesApp.mapApplicationAttachments.put(ResultFGMPortalQuestion[0].Id, feedAttachment);
        communitiesApp.initializeQuizQuestionList();
        communitiesApp.currentParentObject=null;
        communitiesApp.initializeQuizQuestionList();

        Attachment scanAttachment = new Attachment();
        scanAttachment.Body = Blob.valueOf('test data');
        scanAttachment.Name = 'test.txt';

        FCGlobal.NewGuid();

        communitiesApp.showPopup();
        communitiesApp.getNewRelatedListRecord();
        communitiesApp.SaveRelatedListRecord();
        communitiesApp.currentParentObject = 'FGM_Base__Grantee_Report__c';
        communitiesApp.tabObject = lstFGMPortalRelatedListController[0];
        communitiesApp.SaveBeforeReviewSubmit();
        communitiesApp.redirectUser();
        communitiesApp.getNextTab();
        communitiesApp.currentParentObject = 'FGM_Base__Grantee_Report__c';

        communitiesApp.showPopup();
        communitiesApp.getNewRelatedListRecord();
        communitiesApp.SaveRelatedListRecord();
        communitiesApp.tabObject = lstFGMPortalRelatedListController[1];
        communitiesApp.SaveBeforeReviewSubmit();
        communitiesApp.redirectUser();
        communitiesApp.getNextTab();
        communitiesApp.currentParentObject = 'FGM_Base__Grantee_Report__c';
        communitiesApp.existOpenApplication();
        Pagereference testPageReference1 = Page.FCRecord;
        Test.setCurrentPageReference(testPageReference1);
        FCRecordController communitiesApp1 = new FCRecordController();
        communitiesApp1.portalLanguage='en_US';
        ApexPages.currentPage().getParameters().put('Id', benchmark1.Id);
        ApexPages.currentPage().getParameters().put('tabId', ResultsFGMPortalRelatedListController[0].Id);
        ApexPages.currentPage().getParameters().put('attachedQuestionId', ResultFGMPortalQuestion[0].Id);
        ApexPages.currentPage().getParameters().put('mode', 'edit');
        if(newGranteeReportRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GRANTEEREPORT_NARRATIVEREPORT)!=null)
            ApexPages.currentPage().getParameters().put('RecordTypeId', newGranteeReportRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GRANTEEREPORT_NARRATIVEREPORT).getRecordTypeId());
        communitiesApp1.quiz = FGMPortalQuiz;
        communitiesApp1.initialize();
        communitiesApp1.initializeQuizQuestionList();
        communitiesApp1.saveRecordOnTabChange();
        communitiesApp1.currentParentObject='FGM_Portal__Amendment__c';
        Map < String, sObject > MapObjNameObjDetails = new Map < String, sObject >();
        MapObjNameObjDetails.put( 'FGM_Portal__Amendment__c'.tolowercase(), contactAmendment );
        communitiesApp1.MapObjNameObjDetails=MapObjNameObjDetails;
        communitiesApp1.initializeApplication();
        communitiesApp1.reviewApplicationId = lead.Id;
        communitiesApp1.initializeTabs();
        communitiesApp1.reviewApplicationId = opportunity.Id;
        communitiesApp1.initializeTabs();
        communitiesApp1.showPopup();
        communitiesApp1.redirectTo(testPageReference1);
        communitiesApp1.tabObject = lstFGMPortalRelatedListController[0];
        communitiesApp1.SaveRelatedListRecord();
        communitiesApp1.getNewRelatedListRecord();
        communitiesApp1.backTOrelatedlistView();
        communitiesApp1.tabObject = lstFGMPortalRelatedListController[0];
        communitiesApp1.SaveBeforeReviewSubmit();
        communitiesApp1.next();
        communitiesApp1.showPopup();
        communitiesApp1.redirectUser();
        communitiesApp1.relatedListConfiguration = new FCRecordController.relatedList();
        communitiesApp1.relatedListConfiguration.strRelatedListObject = 'FGM_Portal__Related_List_Controller__c';
        communitiesApp1.relatedListConfiguration.lstRelatedListRecord = lstFGMPortalRelatedListController;
        ApexPages.currentPage().getParameters().put('recordIndex', '0');
        communitiesApp1.editRelatedListRecord();
        communitiesApp1.SaveRelatedListRecord();
        communitiesApp1.viewRelatedListRecord();

        communitiesApp1.relatedListConfiguration = new FCRecordController.relatedList();
        FGM_Portal__Related_List_Controller__c FGMPortalRelatedListController = TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListNameDelete', 'Grantee', 'Details', 'FGM_Base__Grantee_Report__c', 'FGM_Base__Grantee_Report__c', 'FGM_Base__Grantee_Report__c', 'Name', 'Name', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id);
        FGMPortalRelatedListController.FGM_Portal__IsCommunityRecord__c = true;
        Database.Saveresult[] ResultFGMPortalRelatedListController = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Related_List_Controller__c>{FGMPortalRelatedListController});
        communitiesApp1.relatedListConfiguration.strRelatedListObject = 'FGM_Portal__Related_List_Controller__c';
        communitiesApp1.relatedListConfiguration.lstRelatedListRecord = new List<FGM_Portal__Related_List_Controller__c> { FGMPortalRelatedListController };
        communitiesApp1.getNewRelatedListRecord();
        communitiesApp1.SaveRelatedListRecord();
        communitiesApp1.deleteRelatedListRecord();
        communitiesApp1.getApplicationObjectName();
        communitiesApp1.application = New opportunity();
        communitiesApp1.tabObject = lstFGMPortalRelatedListController[1];
        communitiesApp1.currentParentObject =  String.valueOf(communitiesApp1.tabObject.get('FGM_Portal__ParentObject__c'));
        communitiesApp1.mapApplicationAttachments = new Map<string,FCRecordController.ApplicationAttachments>();
        FCRecordController.ApplicationAttachments feedAttachment1 = new FCRecordController.ApplicationAttachments();
        feedAttachment1.strQuestionAttachmentId = ResultFGMPortalQuestion[0].Id;
        feedAttachment1.newAttachment = scanAttachment;

        communitiesApp1.currentTabType = 'IFrame Tab';
        ApexPages.currentPage().getParameters().put('id', orgAmendment.Id);
        ApexPages.currentPage().getParameters().put('tabId', ResultsFGMPortalRelatedListController[6].id);
        communitiesApp1.tabObject = lstFGMPortalRelatedListController[6];

        communitiesApp1.initializeQuizQuestionList(ResultsFGMPortalRelatedListController[6].id);
        communitiesApp1.initializeReviewPageList();
        communitiesApp1.saveRecordOnTabChange();
        communitiesApp1.initializeReviewPageList();
        communitiesApp1.SaveBeforeReviewSubmit();
        communitiesApp1.relatedListConfiguration =null;
        communitiesApp1.application = FGMBaseGranteeReport;
        communitiesApp1.initializeQuizQuestionList(ResultsFGMPortalRelatedListController[2].id);
        communitiesApp1.initializeQuizQuestionList(ResultsFGMPortalRelatedListController[6].id);
        communitiesApp1.initializeQuizQuestionList(ResultsFGMPortalRelatedListController[5].id);
        communitiesApp1.initializeReviewPageList();
        communitiesApp1.saveRecordOnTabChange();
        communitiesApp1.initializeReviewPageList();
        communitiesApp1.SaveBeforeReviewSubmit();

        communitiesApp1.currentTabType = 'IFrame Tab';
        communitiesApp1.SaveBeforeReviewSubmit();
        ApexPages.currentPage().getParameters().put('id', orgAmendment.Id);
        ApexPages.currentPage().getParameters().put('tabId', ResultsFGMPortalRelatedListController[6].id);
        communitiesApp1.getJSONApp();
        communitiesApp1.application = lead;
        communitiesApp1.application.put('FGM_Base__Request__c','opportunity');
        communitiesApp1.hideGRBudgetUpdateTab(lstFGMPortalRelatedListController);
        //communitiesApp1.SaveAndNext();
        ApexPages.currentPage().getParameters().put('IsInfected', 'true');
        ApexPages.currentPage().getParameters().put('message', 'Infected');
        communitiesApp1.generateScanMessage();
        Account account1 = TestsObjectProvider.CreateAccount('TestAccount1');
         Database.SaveResult[] ResultAccount1 = TestsObjectProvider.InsertListWithAssert(new List<Account>{account1});

         Contact contact1  = TestsObjectProvider.CreateContact('testContact12', 'testContact12', ResultAccount1[0].Id, 'test@test12.com');
         contact1.FGM_Portal__Confirm_Email__c = 'test@test12.com';
         contact1.MailingStreet='baker1';
         contact1.MailingCity='NY1';
         contact1.MailingCountry='United States';
         contact1.MailingState='New York';
         Database.SaveResult[] ResultContact1 = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact1});

         User user1 = TestsObjectProvider.CreateUser( ResultContact[0].Id, 'test@test2.com', 'testUser2', 'testUser2', 'test1@osftest.com', true, 'FC Community Users Profile', account1.Name);
         user1.ProfileType__c = 'individual';
         user1.UserProfile__c = 'Grantee';
         Database.SaveResult[] ResultUser1 = TestsObjectProvider.InsertListWithAssert(new List<User>{user1});
        Campaign campaign1 = TestsObjectProvider.CreateCampaign('TestCampaign', 'test@test1.com', Date.today(), Date.today(), ResultFGMPortalQuiz[0].Id,'StageName:Submitted,FGM_Base__Duration_Months__c:5,FGM_Base__End_Date__c:8/3/2015,FGM_Base__Amount_Requested__c:100.20');
         Database.Saveresult[] Resultcampaign1 = TestsObjectProvider.InsertListWithAssert(new List<Campaign>{campaign1});

         Opportunity opportunity1 = TestsObjectProvider.CreateOpportunity('testGranteeOpp', 'In Progress', Date.today());
         opportunity1.OwnerId = user1.Id;
         opportunity1.CampaignId = Resultcampaign1[0].Id;
         opportunity1.AccountId = ResultAccount1[0].Id;
         insert opportunity1;

         CommunityApplicationExtension.getAttachments(null,'FGM_Portal__Opportunity__c',opportunity1.Id);
         CommunityApplicationExtension.getAttachmentComponentSettings(true,'','en_Us','42');
         CommunityApplicationExtension.getApplicationRecord('FGM_Portal__Opportunity__c',opportunity1.Id);

         ContentVersion contentVersionToInsert = new ContentVersion();
         contentVersionToInsert.title = 'test content trigger';
         contentVersionToInsert.PathOnClient ='test';
         contentVersionToInsert.VersionData = Blob.valueOf('attachmentOne');
         insert contentVersionToInsert;
         system.assertNotEquals( contentVersionToInsert.Id, null );

         ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :contentVersionToInsert.Id];

         ContentDocumentLink contentlink=new ContentDocumentLink();
         contentlink.LinkedEntityId=opportunity1.Id;
         contentlink.ShareType= 'I';
         contentlink.ContentDocumentId=testcontent.ContentDocumentId;

         ContentVersion contentVersionToInsert2 = new ContentVersion();
         contentVersionToInsert2.title = 'test content trigger';
         contentVersionToInsert2.PathOnClient ='test';
         contentVersionToInsert2.VersionData = Blob.valueOf('attachmentOne');
         insert contentVersionToInsert2;
         system.assertNotEquals( contentVersionToInsert2.Id, null );

         ContentVersion testContent1 = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :contentVersionToInsert2.Id];

         ContentDocumentLink contentlink2=new ContentDocumentLink();
         contentlink2.LinkedEntityId=opportunity1.Id;
         contentlink2.ShareType= 'I';
         contentlink2.ContentDocumentId=testContent1.ContentDocumentId;

         List<FGM_Portal__Questions__c> lstFGMPortalQuestion = new List<FGM_Portal__Questions__c>();
         lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('SF Data Type', '', '', '', 'Salesforce Data Type', ResultFGMPortalQuiz[0].Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
         lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Attachment', '', '', '', 'Attachment', ResultFGMPortalQuiz[0].Id, 'Name+FileName', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
         lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Amount', '', '', '', 'Salesforce Data Type', ResultFGMPortalQuiz[0].Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
         Database.Saveresult[] ResultFGMPortalQuestion1 = TestsObjectProvider.InsertListWithAssert(lstFGMPortalQuestion);

         FGM_Portal__Question_Attachment__c questionAttachment12 = new FGM_Portal__Question_Attachment__c();
         questionAttachment12.FGM_Portal__Opportunity__c = opportunity.Id;
         questionAttachment12.FGM_Portal__Question__c = ResultFGMPortalQuestion1[1].Id;
         questionAttachment12.FGM_Portal__Description__c = 'Test Description';
         Database.SaveResult svRslt = Database.insert(questionAttachment12);

         FGM_Base__Grantee_Report__c FGMBaseGranteeReport11 = TestsObjectProvider.CreateFGMBaseGranteeReport(null, opportunity.Id, 'Received'); //newGranteeReportRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GRANTEEREPORT_NARRATIVEREPORT).getRecordTypeId()
         FGMBaseGranteeReport11.FGM_Base__Display_Benchmark__c = true;
         Database.Saveresult[] ResultFGMBaseGranteeReport11 = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Grantee_Report__c>{FGMBaseGranteeReport11});

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


         Attachment attachmentOne2 = new Attachment();
         attachmentOne2.Body = Blob.valueOf('attachmentOne');
         attachmentOne2.Name = 'attachmentOne';
         attachmentOne2.ParentId = questionAttachment.Id;
         insert attachmentOne2;
         List<Id> lst3 = new List<Id>();
         lst3.add(attachmentOne2.Id);
         system.assertNotEquals( attachmentOne2.Id, null );

         FeedItem FeedOne1 = new FeedItem();
         FeedOne1.ParentId=questionAttachment.Id;
         FeedOne1.Body='FeedattachmentOne';
         FeedOne1.Title='test';
         insert FeedOne1;
         List<Id> lst4 = new List<Id>();
         lst4.add(FeedOne1.Id);

         FCRecordController.getAttachments(null,'FGM_Portal__GranteeReport__c',ResultFGMBaseGranteeReport11[0].Id);
         FCRecordController.getAttachmentComponentSettings(true,'','en_Us','42');
         FCRecordController.getApplicationRecord('FGM_Portal__GranteeReport__c',ResultFGMBaseGranteeReport11[0].Id);
         FCRecordController.insertAndUpdateContentDocumentLink(questionAttachment12.Id, testContent1.ContentDocumentId, '', 'V');
         FCRecordController.deleteAttachments('ContentDocument',lst4 ,questionAttachment12.id);
         communitiesApp1.initializeQuizQuestionList(ResultsFGMPortalRelatedListController[4].id);
         communitiesApp1.initializeReviewPageList();
         communitiesApp1.currentParentObject = 'Opportunity';

        //manish
        FCRecordController communitiesApp2 = new FCRecordController();
        communitiesApp2.currentTabType = 'IFrame Tab';
        ApexPages.currentPage().getParameters().put('id', orgAmendment.Id);
        ApexPages.currentPage().getParameters().put('tabId', ResultsFGMPortalRelatedListController[6].id);
        communitiesApp2.tabObject = lstFGMPortalRelatedListController[6];
        communitiesApp2.initializeApplication();

        communitiesApp2.initializeQuizQuestionList(ResultsFGMPortalRelatedListController[6].id);
        communitiesApp2.initializeReviewPageList();
        communitiesApp2.saveRecordOnTabChange();
        communitiesApp2.initializeReviewPageList();
        communitiesApp2.SaveBeforeReviewSubmit();

        FCRecordController.ApplicationAttachments normalAttachment = new FCRecordController.ApplicationAttachments();
        normalAttachment.strQuestionAttachmentId = ResultFGMPortalQuestion[0].Id;
        Attachment SampleAttachment = new Attachment();
        SampleAttachment.Body = Blob.valueOf('test data');
        SampleAttachment.Name = 'test.txt';
        normalAttachment.newAttachment = SampleAttachment;
        communitiesApp1.mapApplicationAttachments.put(ResultFGMPortalQuestion[0].Id, normalAttachment);

        communitiesApp1.isSaveAndNext=True;
        communitiesApp1.cancelApplication();

        FGM_Portal__Grantee_Budget__c objGranteeBudget=new FGM_Portal__Grantee_Budget__c();
        objGranteeBudget.Name='2015';
        TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Grantee_Budget__c>{objGranteeBudget});

        FGM_Portal__Grantee_Budget_Line_Item__c objBudgetLineItem=new FGM_Portal__Grantee_Budget_Line_Item__c();
        objBudgetLineItem.FGM_Portal__Grantee_Budget__c=objGranteeBudget.ID;
        objBudgetLineItem.FGM_Portal__Opportunity__c=ResultOpportunity[0].Id;
        TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Grantee_Budget_Line_Item__c>{objBudgetLineItem});

        FGM_Portal__Grantee_Budget_Update__c objGranteeBudgetUpdate=new FGM_Portal__Grantee_Budget_Update__c();
        objGranteeBudgetUpdate.FGM_Portal__Grantee_Budget_Line_Item__c = objBudgetLineItem.ID;
        objGranteeBudgetUpdate.FGM_Portal__Grantee_Report__c =ResultFGMBaseGranteeReport[0].Id;
        TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Grantee_Budget_Update__c>{objGranteeBudgetUpdate});

        communitiesApp1.currentTabType = 'Grantee Budget Update Tab';
        communitiesApp1.application = FGMBaseGranteeReport;
        communitiesApp1.selectedGranteeBudgetUpdateID=objGranteeBudgetUpdate.ID;
        communitiesApp1.editGranteeBudgetUpdate();
        communitiesApp1.saveGranteeBudgetUpdate();
        communitiesApp1.cancelGranteeBudgetUpdate();
        communitiesApp1.SaveBeforeReviewSubmit();
        AttachmentUploadManager.AttachmentComponentSettingsWrapper attachmentComponentSettings = FCRecordController.getAttachmentComponentSettings(true, 'https://na7.salesforce.com', 'en_US', '41.0' );
        FCRecordController.getUserInfo();
        communitiesApp1.backToApplication();
        FCRecordController.getCustomSettingRecords('customSettingName',  'instanceKey');
        Pagereference contactPageReference = Page.FCRecord;
        Test.setCurrentPageReference(contactPageReference);
        ApexPages.currentPage().getParameters().put('id', contactAmendment.Id);
        ApexPages.currentPage().getParameters().put('tabId', ResultsFGMPortalRelatedListController[4].Id);
        ApexPages.currentPage().getParameters().put('mode', 'edit');

        FCRecordController FCAmendmentContact = new FCRecordController();
        FCAmendmentContact.currentParentObject='FGM_Portal__Amendment__c';
        FCAmendmentContact.isSCPLEnabled = true;
        FCAmendmentContact.portalLanguage='en_US';
        FCAmendmentContact.quiz = FGMPortalQuiz ;
        Test.stopTest();
        FCAmendmentContact.initialize();
        FCAmendmentContact.initializeTabs();
        FCAmendmentContact.applicationRecordType = 'Contact';
        FCAmendmentContact.isSCPLEnabled=true;
        FCAmendmentContact.initializeStateCountryPicklist();
        FCAmendmentContact.tabObject = lstFGMPortalRelatedListController[4];
        FCAmendmentContact.initializeQuizQuestionList();
        if(User.getSobjectType().getDescribe().fields.getMap().keySet().contains('countryCode')){
        FCAmendmentContact.countryByCode('IN');
        FCAmendmentContact.countryByName('India');
        FCAmendmentContact.stateByCode('MH','IN');
        FCAmendmentContact.stateByName('Bihar');
        }
        FCAmendmentContact.isSaveAndNext = false;

        //For Account Amendment
        Pagereference accountPageReference = Page.FCRecord;
        Test.setCurrentPageReference(accountPageReference);
        ApexPages.currentPage().getParameters().put('id', orgAmendment.Id);
        ApexPages.currentPage().getParameters().put('tabId', ResultsFGMPortalRelatedListController[5].Id);
        ApexPages.currentPage().getParameters().put('mode', 'edit');
        ApexPages.currentPage().getParameters().put('from', 'profile');

        FCRecordController FCAmendmentAccount = new FCRecordController();
        FCAmendmentContact.portalLanguage='en_US';
        FCAmendmentAccount.quiz = FGMPortalQuiz ;
        FCAmendmentAccount.initialize();
        FCAmendmentAccount.initializeTabs();
        FCAmendmentAccount.isSCPLEnabled=true;
        FCAmendmentAccount.applicationRecordType = 'Organization';
        FCAmendmentAccount.initializeStateCountryPicklist();
        FCAmendmentAccount.tabObject = lstFGMPortalRelatedListController[5];
        FCAmendmentAccount.initializeQuizQuestionList();
        if(User.getSobjectType().getDescribe().fields.getMap().keySet().contains('countryCode')){
        FCAmendmentAccount.countryByCode('IN');
        FCAmendmentAccount.countryByName('India');
        FCAmendmentAccount.stateByCode('MH','IN');
        FCAmendmentAccount.stateByName('Bihar');
        }
        FCAmendmentAccount.SaveAndNext();
        FCAmendmentAccount.currentTabType='Related List With Tab';
        FCAmendmentAccount.saveRecordOnTabChange();
        FCAmendmentAccount.currentParentObject='FGM_Portal__Amendment__c';
    }
    static testmethod void TestcurrentParentObjectSubmit()
    {
        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

        Contact contact = TestsObjectProvider.CreateContact('testContact1', 'testContact1', ResultAccount[0].Id, 'test@test1.com');
        contact.MailingCountry='United States';
        contact.MailingState='New York';
        contact.MailingCity='NY';
        contact.MailingStreet='Baker';
        Database.SaveResult[] ResultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});
        User userInfo= new User();
        userInfo= TestsObjectProvider.CreateUser( contact.id, contact.Email, contact.FirstName, contact.LastName, 'UserName', true,'FC Community Users Profile', 'Test');
        List<User> lstUser = new List<User>();
        lstUser.add(userInfo);
        Opportunity opportunity = TestsObjectProvider.CreateOpportunity('testOpp', 'In Progress', Date.today());
        Database.Saveresult[] ResultOpportunity = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunity});
        FCRecordController FCRecObj = new FCRecordController();
        FCRecObj.portalLanguage='en_US';

        //for Benchmark
        ApexPages.currentPage().getParameters().put('mode', null);
        FGM_Base__Benchmark__c benchmark = new FGM_Base__Benchmark__c();
        benchmark.FGM_Base__Request__c = opportunity.Id;
        benchmark.FGM_Base__Status__c = 'Accepted';
        benchmark.FGM_Base__Benchmark_Type__c = 'Percentage; Amount';
        insert benchmark;

        FCRecObj.application=benchmark;
        FCRecObj.currentParentObject='FGM_Base__Benchmark__c';
        FCRecObj.application.put('FGM_Base__Status__c','Proposed');
        FCRecObj.initializeApplication();

        FCRecObj.currentParentObject='FGM_Portal__Amendment__c';
        FCRecObj.initializeApplication();
        FCRecObj.application=null;
        FCRecObj.quiz=null;
        FCRecObj.initialize();

        FGM_Base__Grantee_Report__c FGMBaseGranteeReport = TestsObjectProvider.CreateFGMBaseGranteeReport(null, ResultOpportunity[0].Id, 'Submitted'); //newGranteeReportRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GRANTEEREPORT_NARRATIVEREPORT).getRecordTypeId()
        Database.Saveresult[] ResultFGMBaseGranteeReport = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Grantee_Report__c>{FGMBaseGranteeReport});

        FCRecordController FCRecObj1 = new FCRecordController();
        FCRecObj1.portalLanguage='en_US';
        FCRecObj1.application=FGMBaseGranteeReport;
        FCRecObj1.application.put('FGM_Base__Display_Benchmark__c',true);
        FCRecObj1.application.put('FGM_Base__Status__c','Submitted');
        FCRecObj1.userList=lstUser;
        FCRecObj1.currentParentObject='FGM_Base__Grantee_Report__c';
        FCRecObj1.initializeApplication();
        FCRecObj1.clearUnsavedChanges();
        FCRecObj1.cancelApplication();

        //for Amendment
        FCRecordController FCRecObj3 = new FCRecordController();
        FCRecObj3.portalLanguage='en_US';
        FGM_Portal__Amendment__c contactAmendment = new FGM_Portal__Amendment__c();
        contactAmendment.FGM_Portal__Contact__c = contact.Id;
        insert contactAmendment;
        FCRecObj3.userList=lstUser;
        FCRecObj3.application=contactAmendment;
        FCRecObj3.currentParentObject='FGM_Portal__Amendment__c';
        FCRecObj3.applicationRecordType = 'Contact';
        FCRecObj3.application.put('FGM_Portal__StageName__c','Submitted');
        FCRecObj3.initializeApplication();
        FCRecObj3.clearUnsavedChanges();
        FCRecObj3.goToDashboard();

        FCRecordController.ReviewPage revPage= new FCRecordController.ReviewPage();
        revPage.reviewQuestionList =null;

        FCRecordController.ReviewQuestion revQuestion = new FCRecordController.ReviewQuestion();
        revQuestion.question = null;
        revQuestion.response  = '';
        revQuestion.questionType = '';
        revQuestion.questionId = '';
        FCRecordController.ReviewQuestion reviewQuestion = new FCRecordController.ReviewQuestion();
        reviewQuestion.field='';
        reviewQuestion.strFieldType='';
        reviewQuestion.isHTMLenabled=false;

        FCRecordController.relatedList relatedList = new FCRecordController.relatedList();
        relatedList.listColumnFields= new List<string>();
    }

    public final static Map<String,Schema.Recordtypeinfo> PortalQuizRecordTypeMap = FGM_Portal__Quiz__c.SObjectType.getDescribe().getRecordTypeInfosByName();
    public final static Map<String,Schema.Recordtypeinfo> RelatedListControllerRecordTypeMap = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfosByName();
    public final static string PORTAL_QUIZ_PAGELAYOUT = 'Page Layout';
    
    static testMethod void saveRelatedListRecordTest(){
        try{
            FGM_Portal__Quiz__c FGMPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz('quizName', 'fc@enzigma.com12', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
            FGMPortalQuiz.FGM_Portal__IsCommunityRecord__c = true;
            FGMPortalQuiz.FGM_Portal__Failure_URL__c = '~/apex/CommunitySignupRejected';
            FGMPortalQuiz.RecordTypeId = PortalQuizRecordTypeMap.get(PORTAL_QUIZ_PAGELAYOUT).getRecordTypeId();
            Database.Saveresult[] FGMPoratlQuizResultForGrantee = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{FGMPortalQuiz});
            system.assertNotEquals(null, FGMPoratlQuizResultForGrantee);
            //Tabs for Graantee Report pageLayout
            List<FGM_Portal__Related_List_Controller__c> lstRelatedListController = new  List<FGM_Portal__Related_List_Controller__c>();   
            lstRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('GR-PORTAL TAB', '', '', 'FGM_Base__Grantee_Report__c', 'FGM_Base__Grantee_Report__c', 'FGM_Base__Grantee_Report__c', 'null', 'null', RelatedListControllerRecordTypeMap.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB).getRecordTypeId(), FGMPoratlQuizResultForGrantee[0].Id));
            lstRelatedListController[0].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[0].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[0].FGM_Portal__SortOrder__c = 1;
            
            lstRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('GR-GRANTEE BUDGET UPDATE TAB', '', '', 'FGM_Portal__Grantee_Budget_Update__c', 'FGM_Base__Grantee_Report__c', 'FGM_Portal__Grantee_Budget_Update__c', 'null', 'null', RelatedListControllerRecordTypeMap.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_GRANTEEBUDGETUPDATETAB).getRecordTypeId(), FGMPoratlQuizResultForGrantee[0].Id));
            lstRelatedListController[1].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[1].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[1].FGM_Portal__SortOrder__c = 2;
            
            lstRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('GR-BENCHMARK UPDATE', '', '', 'FGM_Base__Benchmark_Update__c', 'FGM_Base__Grantee_Report__c', 'FGM_Base__Grantee_Report__c', 'BENCHMARK,AMOUNT UPDATED,PERCENTAGE UPDATED', 'FGM_Base__Benchmark__c,FGM_Base__Amount_Update__c,FGM_Base__Percentage_Update__c', RelatedListControllerRecordTypeMap.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId(), FGMPoratlQuizResultForGrantee[0].Id));
            lstRelatedListController[2].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[2].FGM_Portal__IsCommunityRecord__c = TRUE;
            lstRelatedListController[2].FGM_Portal__SortOrder__c= 3;
            lstRelatedListController[2].FGM_Portal__ShowDeleteLink__c = TRUE;
            
            lstRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('IFRAME TAB', '', '', 'none', 'FGM_Base__Grantee_Report__c', 'none', '', '', RelatedListControllerRecordTypeMap.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_IFRAMETAB).getRecordTypeId(), FGMPoratlQuizResultForGrantee[0].Id));
            lstRelatedListController[3].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[3].FGM_Portal__SortOrder__c= 4;
            lstRelatedListController[3].FGM_Portal__BaseUrl__c = 'https://test/DynamicIFrameTest?id={Opportunity.ID}&StageName={OPPORTUNITY.StageName1}&NAME={OPPORTUNITY.name}'; 
            
            Database.Saveresult[] GranteeReportRLCResult = TestsObjectProvider.InsertListWithAssert(lstRelatedListController);
            
            //Questions For GranteeReport PageLayout
            Map<String,Schema.Recordtypeinfo> newPortalQuestionRecordTypeMapByName = FGM_Portal__Questions__c.SObjectType.getDescribe().getRecordTypeInfosByName();
            List<FGM_Portal__Questions__c> lstFGMPortalQuestion = new List<FGM_Portal__Questions__c>();
            
            lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Comment', '', '', '', 'Salesforce Data Type',FGMPoratlQuizResultForGrantee[0].Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
            lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Instruction', '', '', '', 'Instruction',FGMPoratlQuizResultForGrantee[0].Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
            lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Attachment', '', '', '', 'Attachment',FGMPoratlQuizResultForGrantee[0].Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
            
            Database.Saveresult[] GranteeReportQuestionResult = TestsObjectProvider.InsertListWithAssert(lstFGMPortalQuestion);
            
            //QuizQuestions For GranteeReport pageLayout
            
            List<FGM_Portal__Quiz_Questions__c> lstFGMPortalQuizQuestion = new List<FGM_Portal__Quiz_Questions__c>();
            
            lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(GranteeReportQuestionResult[0].Id, 1, 'FGM_Base__Number_Update__c', '', 50, '1', GranteeReportRLCResult[2].Id, false, FGMPoratlQuizResultForGrantee[0].Id));
            lstFGMPortalQuizQuestion[0].FGM_Portal__IsCommunityRecord__c = true;
            lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(GranteeReportQuestionResult[1].Id, 2, '', '', 50, '1', GranteeReportRLCResult[2].Id, true, FGMPoratlQuizResultForGrantee[0].Id));
            lstFGMPortalQuizQuestion[1].FGM_Portal__IsCommunityRecord__c = true;
            lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(GranteeReportQuestionResult[2].Id, 3, '', '', 50, '1', GranteeReportRLCResult[2].Id, true, FGMPoratlQuizResultForGrantee[0].Id));
            lstFGMPortalQuizQuestion[2].FGM_Portal__IsCommunityRecord__c = true;
            Insert lstFGMPortalQuizQuestion;
            // Database.Saveresult[] GranteeReportQuizQuestionResult = TestsObjectProvider.InsertListWithAssert(lstFGMPortalQuizQuestion); 
            
            Opportunity opportunity = TestsObjectProvider.CreateOpportunity('testOpp', 'In Progress', Date.today());
            Database.Saveresult[] oppResult = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunity});
            
            FGM_Base__Grantee_Report__c granteeReport = TestsObjectProvider.CreateGranteeReport(oppResult[0].Id);
            insert granteeReport;
            
            FGM_Base__Benchmark_Update__c bupdate = new FGM_Base__Benchmark_Update__c();
            bupdate.FGM_Base__Grantee_Report__c = granteeReport.Id;
            
            
            FCRecordController fcController = new FCRecordController();
            fcController.relatedListConfiguration = new FCRecordController.relatedList();
            fcController.relatedListConfiguration.relatedListLookUp = 'FGM_Base__Grantee_Report__c';
            fcController.relatedListConfiguration.strRelatedListObject ='FGM_Base__Benchmark_Update__c';
            fcController.tabObject = bupdate;
            fcController.relatedListConfiguration.mapColumnFields = fcController.getrelatedListColumn(lstRelatedListController[2]);
            fcController.application = granteeReport;
            
            fcController.mapApplicationAttachments = new Map<String,FCRecordController.ApplicationAttachments>();
            FCRecordController.ApplicationAttachments tempApplicationAttachments = new FCRecordController.ApplicationAttachments();
            fcController.mapApplicationAttachments.put(lstFGMPortalQuizQuestion[2].Id,tempApplicationAttachments);  
            
            fcController.selectedTab = GranteeReportRLCResult[2].Id;
            List<FGM_Portal__Quiz_Questions__c> quizQuestions = [select Id,Name,FGM_Portal__Required__c,FGM_Portal__Field__c,FGM_Portal__Tab__c,FGM_Portal__Question__r.FGM_Portal__Type__c FROM FGM_Portal__Quiz_Questions__c WHERE FGM_Portal__Quiz__c =: FGMPoratlQuizResultForGrantee[0].Id];
            fcController.quizQuestionList = new List<FGM_Portal__Quiz_Questions__c>();
            fcController.quizQuestionList.addAll(quizQuestions);
            fcController.tabsList = [
                SELECT Associated_FC_Portal_Type__c,
                Associated_Tab_Type__c,
                BaseUrl__c,
                FieldHeaders__c,
                FieldNames__c,
                Field_Labels_Long__c,
                Field_Names_Long__c,
                Hide_Edit_Link__c,
                RichInstructionalText__c,
                LookupField__c,
                Name,
                ObjectName__c,
                ParentObject__c,
                RecordType.Name,
                RecordTypeId,
                ShowDeleteLink__c,
                ShowNewButton__c,
                SortFieldOrder__c,
                SortField__c,
                (
                    SELECT
                    Can_upload_after_submission__c,
                    Field__c,
                    Hide_Post_Text__c,
                    Hide_Pre_Text__c,
                    Question__c,
                    Question__r.AttachmentNameFormula__c,
                    Question__r.Help_Tip__c,
                    Question__r.RichPostText__c,
                    Question__r.RichPreText__c,
                    Question__r.RichQuestion__c,
                    Question__r.Quiz__c,
                    Question__r.Type__c,
                    Quiz__c,
                    Required__c,
                    Sort_Order__c,
                    Tab__c
                    FROM Quiz_Questions__r
                    ORDER BY Sort_Order__c ASC NULLS LAST
                )
                FROM Related_List_Controller__c];
            fcController.SaveRelatedListRecord();
            system.assertEquals(fcController.relatedListConfiguration.lstRelatedListRecord.size(), 1, 'Record size should be one');
        }catch(Exception e){
            system.debug('exception :'+e.getStackTraceString()+ ' message :'+e.getMessage());
        }
    }
}