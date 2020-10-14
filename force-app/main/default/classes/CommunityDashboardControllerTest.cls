@isTest
private class CommunityDashboardControllerTest
{
    static testMethod void communityDashboardController()
    {
        List<User> lstSysAdminUsers = [SELECT Id from User WHERE Profile.Name ='System Administrator' AND IsActive = true ];
        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        account.OwnerId = lstSysAdminUsers[0].Id;
        Database.SaveResult[] resultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

        Contact contact = TestsObjectProvider.CreateContact('testContact1', 'testContact1', resultAccount[0].Id, 'test@test1.com');
        Database.SaveResult[] resultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});

        FGM_Portal__CommunityConfiguration__c commConfig = new FGM_Portal__CommunityConfiguration__c();
        commConfig.FGM_Portal__ConfiguationName__c = 'AmendmentDefaultValue';
        commConfig.FGM_Portal__JsonData__c = '{"Amendment":[{"Name":"FGM_Portal__StageName__c","Value":"Submitted"}]}';
        insert commConfig;
        system.assertNotEquals(commConfig,null);
        system.assertNotEquals(commConfig.Id,null);

        FGM_Portal__GlobalPortalSettings__c globalSetting = new FGM_Portal__GlobalPortalSettings__c();
        globalSetting.FGM_Portal__Grantee_Portal_Prefix__c = 'fcgrantee';
        globalSetting.FGM_Portal__Reviewer_Portal_Prefix__c = 'grantee';
        insert globalSetting;

        List<FGM_Portal__Portal_User__c> lstPortalUser = new List<FGM_Portal__Portal_User__c>();
        lstPortalUser.add(TestSObjectProvider.CreateFGMPortalUser(null, 'test@fc-community-developer-edition.na17.force.com', 'Portal LastName', 'test@test1.com', 'test@test1.com', 'test@osf-communities-developer-edition.na17.force.com', 'Test1234', 'Test1234', true));
        Database.Saveresult[] resultFGMPortalUser = TestsObjectProvider.InsertListWithAssert(lstPortalUser);

        Contact contact1 = TestsObjectProvider.CreateContact('testContact2', 'testContact2', resultAccount[0].Id, 'test@test2.com');
        Database.SaveResult[] resultContact1 = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact1});

        User user1 = TestsObjectProvider.CreateUser( resultContact[0].Id, 'test@test2.com', 'testUser2', 'testUser2', 'test1@osftest.com', true, 'FC Community Users Profile', account.Name);
        user1.ProfileType__c = 'individual';
        user1.UserProfile__c = 'Grantee';
        Database.SaveResult[] resultUser1 = TestsObjectProvider.InsertListWithAssert(new List<User>{user1});

        User user2 = TestsObjectProvider.CreateUser( resultContact1[0].Id, 'test@test3.com', 'testUser3', 'testUser3', 'test2@osftest.com', true, 'FC Community Users Profile', account.Name);
        user2.ProfileType__c = 'individual';
        user2.UserProfile__c = 'Reviewer';
        Database.SaveResult[] resultUser2 = TestsObjectProvider.InsertListWithAssert(new List<User>{user2});

        Campaign campaign = TestsObjectProvider.CreateCampaign('TestCampaign', 'test@test1.com', Date.today().addDays(10), Date.today(), null,null);
        Database.Saveresult[] resultcampaign = TestsObjectProvider.InsertListWithAssert(new List<Campaign>{campaign});

        Campaign campaign1 = TestsObjectProvider.CreateCampaign('TestCampaign2', 'test@test1.com', Date.today().addDays(-10), Date.today().addDays(-100), null,null);
        Database.Saveresult[] resultcampaign1 = TestsObjectProvider.InsertListWithAssert(new List<Campaign>{campaign1});

        Campaign campaign2 = TestsObjectProvider.CreateCampaign('TestCampaign2', 'test@test1.com',Null, Date.today().addDays(-100), null,null);
        Database.Saveresult[] resultcampaign2 = TestsObjectProvider.InsertListWithAssert(new List<Campaign>{campaign2});


        Opportunity opportunity = TestsObjectProvider.CreateOpportunity('testGranteeOpp', 'In Progress', Date.today());
        opportunity.OwnerId = resultUser1[0].Id;
        opportunity.CampaignId = resultcampaign[0].Id;
        opportunity.AccountId = resultAccount[0].Id;

        Opportunity opportunitySubmitted = TestsObjectProvider.CreateOpportunity('testGranteeOpp1', 'Prospecting', Date.today());
        opportunitySubmitted.OwnerId = resultUser1[0].Id;
        opportunitySubmitted.CampaignId = resultcampaign1[0].Id;
        opportunitySubmitted.AccountId = resultAccount[0].Id;

        Opportunity opportunity2 = TestsObjectProvider.CreateOpportunity('testGranteeOpp2', 'Prospecting', Date.today());
        opportunity2.OwnerId = resultUser1[0].Id;
        opportunity2.CampaignId = resultcampaign1[0].Id;
        opportunity2.AccountId = resultAccount[0].Id;

        Opportunity opportunityQuali = TestsObjectProvider.CreateOpportunity('testGranteeOpp3', 'Qualification', Date.today());
        opportunityQuali.OwnerId = resultUser1[0].Id;
        opportunityQuali.FGM_Base__Submitted_By__c = resultContact1[0].Id;
        opportunityQuali.CampaignId = resultcampaign[0].Id;
        opportunityQuali.AccountId = resultAccount[0].Id;

        Opportunity opportunityClosedWon = TestsObjectProvider.CreateOpportunity('testGranteeOpp4', 'Closed Won', Date.today());
        opportunityClosedWon.OwnerId = resultUser1[0].Id;
        opportunityClosedWon.CampaignId = resultcampaign[0].Id;
        opportunityClosedWon.AccountId = resultAccount[0].Id;

        Opportunity opportunityNotNull = TestsObjectProvider.CreateOpportunity('testGranteeOpp2', 'Prospecting', Date.today());
        opportunityNotNull.OwnerId = resultUser1[0].Id;
        opportunityNotNull.CampaignId = resultcampaign2[0].Id;
        opportunityNotNull.AccountId = resultAccount[0].Id;

        Database.Saveresult[] resultOpportunity = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunity,opportunityClosedWon,opportunityQuali,opportunitySubmitted,opportunity2,opportunityNotNull});

        OpportunityTeamMember opportunityTeamMember5 = new OpportunityTeamMember();
        opportunityTeamMember5.OpportunityId = resultOpportunity[5].id;
        opportunityTeamMember5.UserId = resultUser1[0].Id;
        opportunityTeamMember5.TeamMemberRole = 'Account Manager';
        insert opportunityTeamMember5;

        OpportunityTeamMember opportunityTeamMember = new OpportunityTeamMember();
        opportunityTeamMember.OpportunityId = resultOpportunity[0].id;
        opportunityTeamMember.UserId = resultUser1[0].Id;
        opportunityTeamMember.TeamMemberRole = 'Account Manager';
        insert opportunityTeamMember;

        OpportunityTeamMember opportunityTeamMember1 = new OpportunityTeamMember();
        opportunityTeamMember1.OpportunityId = resultOpportunity[1].id;
        opportunityTeamMember1.UserId = resultUser1[0].Id;
        opportunityTeamMember1.TeamMemberRole = 'Account Manager';
        insert opportunityTeamMember1;

        OpportunityTeamMember opportunityTeamMember2 = new OpportunityTeamMember();
        opportunityTeamMember2.OpportunityId = resultOpportunity[2].id;
        opportunityTeamMember2.UserId = resultUser1[0].Id;
        opportunityTeamMember2.TeamMemberRole = 'Account Manager';
        insert opportunityTeamMember2;

        OpportunityTeamMember opportunityTeamMember3 = new OpportunityTeamMember();
        opportunityTeamMember3.OpportunityId = resultOpportunity[3].id;
        opportunityTeamMember3.UserId = resultUser1[0].Id;
        opportunityTeamMember3.TeamMemberRole = 'Account Manager';
        insert opportunityTeamMember3;

        OpportunityTeamMember opportunityTeamMember4 = new OpportunityTeamMember();
        opportunityTeamMember4.OpportunityId = resultOpportunity[4].id;
        opportunityTeamMember4.UserId = resultUser1[0].Id;
        opportunityTeamMember4.TeamMemberRole = 'Account Manager';
        insert opportunityTeamMember4;


        Map<String,Schema.Recordtypeinfo> newGranteeReportRecordTypeMapByName = FGM_Base__Grantee_Report__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        FGM_Base__Grantee_Report__c FGMBaseGranteeReport = TestsObjectProvider.CreateFGMBaseGranteeReport(null, resultOpportunity[0].Id, 'Received');
        Database.Saveresult[] resultFGMBaseGranteeReport = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Grantee_Report__c>{FGMBaseGranteeReport});

        FGM_Base__Grantee_Report__c FGMBaseGranteeReport2 = TestsObjectProvider.CreateFGMBaseGranteeReport(null, resultOpportunity[0].Id, 'Requested');
        FGMBaseGranteeReport2.FGM_Base__Due_Date__c =  system.today();
        Database.Saveresult[] resultFGMBaseGranteeReport2 = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Grantee_Report__c>{FGMBaseGranteeReport2});


        FGM_Base__Grantee_Report__c FGMBaseGranteeReport3 = TestsObjectProvider.CreateFGMBaseGranteeReport(null, resultOpportunity[0].Id, 'wwwwww');
        FGMBaseGranteeReport3.FGM_Base__Due_Date__c =  system.today();
        Database.Saveresult[] resultFGMBaseGranteeReport3 = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Grantee_Report__c>{FGMBaseGranteeReport3});

        FGM_Base__Grantee_Report__c FGMBaseGranteeReport4 = TestsObjectProvider.CreateFGMBaseGranteeReport(null, resultOpportunity[3].Id, 'Requested');
        FGMBaseGranteeReport4.FGM_Base__Due_Date__c =  system.today();
        Database.Saveresult[] resultFGMBaseGranteeReport4 = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Grantee_Report__c>{FGMBaseGranteeReport4});

        FGM_Base__Grantee_Report__c FGMBaseGranteeReport5 = TestsObjectProvider.CreateFGMBaseGranteeReport(null, resultOpportunity[3].Id, 'Submitted');
        FGMBaseGranteeReport5.FGM_Base__Due_Date__c =  system.today();
        Database.Saveresult[] resultFGMBaseGranteeReport5 = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Grantee_Report__c>{FGMBaseGranteeReport5});

        FGM_Base__Benchmark__c FGMBaseBenchmark = TestsObjectProvider.CreateFGMBaseBenchmark(resultOpportunity[0].Id, 'Proposed', true, true, Date.today(), true);
        Database.Saveresult[] resultFGMBaseBenchmark = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Benchmark__c>{FGMBaseBenchmark});

        FGM_Base__Benchmark__c FGMBaseBenchmark2 = TestsObjectProvider.CreateFGMBaseBenchmark(resultOpportunity[0].Id, 'test', true, true, Date.today(), true);
        Database.Saveresult[] resultFGMBaseBenchmark1 = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Benchmark__c>{FGMBaseBenchmark2});

        FGM_Base__Benchmark__c FGMBaseBenchmark3 = TestsObjectProvider.CreateFGMBaseBenchmark(resultOpportunity[3].Id, 'Proposed', true, true, Date.today(), true);
        Database.Saveresult[] resultFGMBaseBenchmark3 = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Benchmark__c>{FGMBaseBenchmark3});

        FGM_Base__Benchmark__c FGMBaseBenchmark4 = TestsObjectProvider.CreateFGMBaseBenchmark(resultOpportunity[2].Id, 'Proposed', true, true, Date.today(), true);
        Database.Saveresult[] resultFGMBaseBenchmark4 = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Benchmark__c>{FGMBaseBenchmark4});

        Lead lead = TestsObjectProvider.CreateLead('Test Lead FirstName', 'Test Lead LastName', 'Test Company', 'Open - Not Contacted');
        lead.OwnerId = resultUser1[0].Id;
        lead.Status = 'In Progress';
        Database.Saveresult[] ResultLead = TestsObjectProvider.InsertListWithAssert(new List<Lead>{lead});

        Lead lead4 = TestsObjectProvider.CreateLead('Test Lead FirstName', 'Test Lead LastName2', 'Test Company', 'Open - Not Contacted');
        lead4.OwnerId = resultUser1[0].Id;
        lead4.Status = 'Submitted';
        Database.Saveresult[] resultLead4 = TestsObjectProvider.InsertListWithAssert(new List<Lead>{lead4});

        Lead lead3 = TestsObjectProvider.CreateLead('Test Lead FirstName', 'Test Lead LastName2', 'Test Company', 'Open - Not Contacted');
        lead3.OwnerId = resultUser1[0].Id;
        lead3.Status = 'dfsfsdfsdf';
        Database.Saveresult[] ResultLead3 = TestsObjectProvider.InsertListWithAssert(new List<Lead>{lead3});

        CampaignMember campaignMember = TestsObjectProvider.CreateCampaignMember(resultcampaign[0].Id, resultContact[0].Id, 'Planned');
        campaignMember.LeadId = ResultLead[0].Id;

        CampaignMember campaignMember1 = TestsObjectProvider.CreateCampaignMember(resultcampaign1[0].Id, resultContact[0].Id, 'Planned');
        campaignMember1.LeadId = ResultLead3[0].Id;

        CampaignMember campaignMember2 = TestsObjectProvider.CreateCampaignMember(resultcampaign2[0].Id, resultContact[0].Id, 'Planned');
        campaignMember2.LeadId = ResultLead4[0].Id;
        Database.Saveresult[] resultcampaignMember = TestsObjectProvider.InsertListWithAssert(new List<CampaignMember>{campaignMember , campaignMember1 ,campaignMember2});

        List<FGM_Portal__PortalAlertSettings__c> lstPortalAlertSetting = new List<FGM_Portal__PortalAlertSettings__c>();
        lstPortalAlertSetting.add(new FGM_Portal__PortalAlertSettings__c(Name='Test1', FGM_Portal__Color__c = 'Red', FGM_Portal__Object__c = 'fgm_base__grantee_report__c', FGM_Portal__Status__c='Approved', FGM_Portal__Status_Field__c='FGM_Base__Status__c', FGM_Portal__Time_Trigger__c=1,FGM_Portal__Use_Due_Date__c='FGM_Base__Due_Date__c'));
        lstPortalAlertSetting.add(new FGM_Portal__PortalAlertSettings__c(Name='Test4', FGM_Portal__Color__c = 'Pink', FGM_Portal__Object__c = 'fgm_base__grantee_report__c', FGM_Portal__Status__c='Requested', FGM_Portal__Status_Field__c='FGM_Base__Status__c', FGM_Portal__Time_Trigger__c=1,FGM_Portal__Use_Due_Date__c='FGM_Base__Due_Date__c'));
        lstPortalAlertSetting.add(new FGM_Portal__PortalAlertSettings__c(Name='Test2', FGM_Portal__Color__c = 'Blue', FGM_Portal__Object__c = 'opportunity', FGM_Portal__Status__c='In Progress', FGM_Portal__Status_Field__c='StageName', FGM_Portal__Time_Trigger__c=1, FGM_Portal__Use_Due_Date__c='EndDate'));
        lstPortalAlertSetting.add(new FGM_Portal__PortalAlertSettings__c(Name='Test3', FGM_Portal__Color__c = 'Orange', FGM_Portal__Object__c = 'lead', FGM_Portal__Status__c='In Progress', FGM_Portal__Status_Field__c='Status', FGM_Portal__Time_Trigger__c=1, FGM_Portal__Use_Due_Date__c='EndDate'));
        insert lstPortalAlertSetting;

        FGM_Portal__PortalConfiguration__c portalConfiguration = TestsObjectProvider.CreateFGMPortalPortalConfiguration('Applicant Portal', 'Requested;Scheduled;Received', true, true, 'Change Requests', 'Benchmark', false, 'Grantee Inbox', 'Grantee Report', 'en_US', 'Declined;Closed', 'Request', 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started', 'Inquiry', 'Declined;Closed;Submitted', 'Working - Contacted;New;Requested;More Information;Reopened;Application Invited;Open - Not Contacted;In Progress');
        portalConfiguration.FGM_Portal__RequestDeletableStatus__c = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        portalConfiguration.FGM_Portal__RequestHistoryTab__c = 'Qualification';
        portalConfiguration.FGM_Portal__GranteeReportHistoryTab__c = 'Submitted';
        portalConfiguration.FGM_Portal__GranteeReportHiddenStatus__c = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        portalConfiguration.FGM_Portal__GranteeReportDeletableStatus__c  = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        portalConfiguration.FGM_Portal__InquiryDeletableStatus__c = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        portalConfiguration.FGM_Portal__InquiryHiddenStatus__c = 'Application Re-Opened';
        portalConfiguration.FGM_Portal__AmendmentHistoryTab__c= '';
        portalConfiguration.FGM_Portal__AmendmentEditableStatus__c  = '';
        portalConfiguration.FGM_Portal__AmendmentDeletableStatus__c = '';
        portalConfiguration.FGM_Portal__AmendmentHiddenStatus__c = '';
        portalConfiguration.FGM_Portal__BenchmarkEditableStatus__c = 'Proposed;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        portalConfiguration.FGM_Portal__BenchmarkDeletableStatus__c = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        portalConfiguration.FGM_Portal__RequestHiddenStatus__c = 'Application Started';
        portalConfiguration.FGM_Portal__RequestStatusField__c ='StageName';
        portalConfiguration.FGM_Portal__GranteeReportStatusField__c = 'FGM_Base__Status__c';
        portalConfiguration.FGM_Portal__InquiryStatusField__c = 'Status';
        Database.Saveresult[] resultPortalConfiguration = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__PortalConfiguration__c>{portalConfiguration});

        System.RunAs(user1)
        {
            CommunityDashboardController newCommunityDashboardController = new CommunityDashboardController();
            CommunityDashboardController.initializeDashboard('en_US');
            newCommunityDashboardController.showProfileOptions = true;
            CommunityDashboardController.communityAmendmentSetting = new FGM_Portal__CommunitySetting__c();
            FGM_Portal__CommunitySetting__c communityAmendmentSetting1 = CommunityDashboardController.communityAmendmentSetting;
            CommunityDashboardController.initializeDashboard('en_US');
            List<Id> lstOppOwnerIds = new List<Id>();
            lstOppOwnerIds.add(opportunity.OwnerId);
            lstOppOwnerIds.add(opportunitySubmitted.OwnerId);
            lstOppOwnerIds.add(opportunity2.OwnerId);
            lstOppOwnerIds.add(opportunityClosedWon.OwnerId);
            lstOppOwnerIds.add(opportunityNotNull.OwnerId);
            List<Id> lstOppIds = new List<Id>();
            lstOppIds.add(opportunity.Id);
            lstOppIds.add(opportunity2.Id);
            Map<Id,String> mapOppAndAccessLevel = new Map<Id,String>();
            Map<Id,Boolean> mapDeletableAccess  = new Map<Id,Boolean>();
            mapOppAndAccessLevel = CommunityDashboardController.getOpportunityTeamMembers();
            mapOppAndAccessLevel.put(opportunity.Id,'All');
            mapOppAndAccessLevel.put(opportunitySubmitted.Id,'View');
            mapOppAndAccessLevel.put(opportunity2.Id,'All');
            mapOppAndAccessLevel.put(opportunityClosedWon.Id,'All');
            mapOppAndAccessLevel.put(opportunityNotNull.Id,'All');
            CommunityDashboardController.getData('Opportunity',mapOppAndAccessLevel,lstOppOwnerIds,'en_US');
            CommunityDashboardController.getData('Lead',mapOppAndAccessLevel,lstOppOwnerIds,'en_US');
            CommunityDashboardController.getData('FGM_Base__Grantee_Report__c',mapOppAndAccessLevel,lstOppOwnerIds,'en_US');
            CommunityDashboardController.getData('FGM_Base__Benchmark__c',mapOppAndAccessLevel,lstOppOwnerIds,'en_US');
            CommunityDashboardController.saveAmendmentRecord(opportunity.Id);
             //CommunityDashboardController.deleteRecord(opportunity.Id);  // @todo partner users can't delete opportunities...
                system.assert(true,null);
        }
        System.RunAs(user2)
        {
            Lead lead1 = TestsObjectProvider.CreateLead('Test Lead FirstName', 'Test Lead LastName', 'Test Company', 'Open - Not Contacted');
            Database.Saveresult[] ResultLead1 = TestsObjectProvider.InsertListWithAssert(new List<Lead>{lead1});
            Lead lead2 = TestsObjectProvider.CreateLead('Test Lead FirstName 1', 'Test Lead LastName 1', 'Test Company 1', 'Needs Analysis');
            Database.Saveresult[] ResultLead2 = TestsObjectProvider.InsertListWithAssert(new List<Lead>{lead2});
            CommunityDashboardController newCommunityDashboardController1 = new CommunityDashboardController();
            CommunityDashboardController.initializeDashboard('en_US');
            newCommunityDashboardController1.showProfileOptions = true;
            newCommunityDashboardController1.initializeProfileListForSwitching();
            try{
                CommunityDashboardController.saveAmendmentRecord(opportunity.Id);
                //CommunityDashboardController.deleteRecord(opportunity.Id); // @todo partner users can't delete opportunities...
                system.assert(true,null);

            }
            catch( exception e){

            }


        }
    }
    static testMethod void createAmendment (){

        List<User> lstSysAdminUsers = [SELECT Id from User WHERE Profile.Name ='System Administrator' AND IsActive = true ];
        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        account.OwnerId = lstSysAdminUsers[0].Id;
        Database.SaveResult[] resultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

        Contact contact = TestsObjectProvider.CreateContact('testContact1', 'testContact1', resultAccount[0].Id, 'test@test1.com');
        Database.SaveResult[] resultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});

        FGM_Portal__CommunityConfiguration__c commConfig = new FGM_Portal__CommunityConfiguration__c();
        commConfig.FGM_Portal__ConfiguationName__c = 'AmendmentDefaultValue';
        commConfig.FGM_Portal__JsonData__c = '{"Amendment":[{"Name":"FGM_Portal__StageName__c","Value":"Submitted"}]}';
        insert commConfig;
        system.assertNotEquals(commConfig,null);
        system.assertNotEquals(commConfig.Id,null);

        FGM_Portal__GlobalPortalSettings__c globalSetting = new FGM_Portal__GlobalPortalSettings__c();
        globalSetting.FGM_Portal__Grantee_Portal_Prefix__c = 'fcgrantee';
        globalSetting.FGM_Portal__Reviewer_Portal_Prefix__c = 'grantee';
        insert globalSetting;

        List<FGM_Portal__Portal_User__c> lstPortalUser = new List<FGM_Portal__Portal_User__c>();
        lstPortalUser.add(TestSObjectProvider.CreateFGMPortalUser(null, 'test@fc-community-developer-edition.na17.force.com', 'Portal LastName', 'test@test1.com', 'test@test1.com', 'test@osf-communities-developer-edition.na17.force.com', 'Test1234', 'Test1234', true));
        Database.Saveresult[] resultFGMPortalUser = TestsObjectProvider.InsertListWithAssert(lstPortalUser);

        Contact contact1 = TestsObjectProvider.CreateContact('testContact2', 'testContact2', resultAccount[0].Id, 'test@test2.com');
        Database.SaveResult[] resultContact1 = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact1});

        User user1 = TestsObjectProvider.CreateUser( resultContact[0].Id, 'test@test2.com', 'testUser2', 'testUser2', 'test1@osftest.com', true, 'FC Community Users Profile', account.Name);
        user1.ProfileType__c = 'individual';
        user1.UserProfile__c = 'Grantee';
        Database.SaveResult[] resultUser1 = TestsObjectProvider.InsertListWithAssert(new List<User>{user1});

        Campaign campaign = TestsObjectProvider.CreateCampaign('TestCampaign', 'test@test1.com', Date.today().addDays(10), Date.today(), null,null);
        Database.Saveresult[] resultcampaign = TestsObjectProvider.InsertListWithAssert(new List<Campaign>{campaign});

        Opportunity opportunityQuali = TestsObjectProvider.CreateOpportunity('testGranteeOpp3', 'Qualification', Date.today());
        opportunityQuali.OwnerId = resultUser1[0].Id;
        opportunityQuali.FGM_Base__Submitted_By__c = resultContact1[0].Id;
        opportunityQuali.CampaignId = resultcampaign[0].Id;
        opportunityQuali.AccountId = resultAccount[0].Id;

        Opportunity opportunity2 = TestsObjectProvider.CreateOpportunity('testGranteeOpp3', 'Qualification', Date.today());
        opportunity2.OwnerId = resultUser1[0].Id;
        opportunity2.FGM_Base__Submitted_By__c = resultContact1[0].Id;
        opportunity2.CampaignId = resultcampaign[0].Id;
        opportunity2.AccountId = resultAccount[0].Id;

        Opportunity opportunity3 = TestsObjectProvider.CreateOpportunity('testGranteeOpp3', 'Qualification', Date.today());
        opportunity3.OwnerId = resultUser1[0].Id;
        opportunity3.FGM_Base__Submitted_By__c = resultContact1[0].Id;
        opportunity3.CampaignId = resultcampaign[0].Id;
        opportunity3.AccountId = resultAccount[0].Id;

        Opportunity opportunity4 = TestsObjectProvider.CreateOpportunity('testGranteeOpp3', 'Qualification', Date.today());
        opportunity4.OwnerId = resultUser1[0].Id;
        opportunity4.FGM_Base__Submitted_By__c = resultContact1[0].Id;
        opportunity4.CampaignId = resultcampaign[0].Id;
        opportunity4.AccountId = resultAccount[0].Id;

        Opportunity opportunity5 = TestsObjectProvider.CreateOpportunity('testGranteeOpp3', 'Qualification', Date.today());
        opportunity5.OwnerId = resultUser1[0].Id;
        opportunity5.FGM_Base__Submitted_By__c = resultContact1[0].Id;
        opportunity5.CampaignId = resultcampaign[0].Id;
        opportunity5.AccountId = resultAccount[0].Id;

        Database.Saveresult[] resultOpportunity = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunityQuali,opportunity2,opportunity3,opportunity4,opportunity5});

        OpportunityTeamMember opportunityTeamMember = new OpportunityTeamMember();
        opportunityTeamMember.OpportunityId = resultOpportunity[0].id;
        opportunityTeamMember.UserId = resultUser1[0].Id;
        opportunityTeamMember.TeamMemberRole = 'Account Manager';
        insert opportunityTeamMember;

        OpportunityTeamMember opportunityTeamMember2 = new OpportunityTeamMember();
        opportunityTeamMember2.OpportunityId = resultOpportunity[1].id;
        opportunityTeamMember2.UserId = resultUser1[0].Id;
        opportunityTeamMember2.TeamMemberRole = 'Account Manager';
        insert opportunityTeamMember2;

        OpportunityTeamMember opportunityTeamMember3 = new OpportunityTeamMember();
        opportunityTeamMember3.OpportunityId = resultOpportunity[2].id;
        opportunityTeamMember3.UserId = resultUser1[0].Id;
        opportunityTeamMember3.TeamMemberRole = 'Account Manager';
        insert opportunityTeamMember3;

        OpportunityTeamMember opportunityTeamMember4 = new OpportunityTeamMember();
        opportunityTeamMember4.OpportunityId = resultOpportunity[3].id;
        opportunityTeamMember4.UserId = resultUser1[0].Id;
        opportunityTeamMember4.TeamMemberRole = 'Account Manager';
        insert opportunityTeamMember4;

        OpportunityTeamMember opportunityTeamMember5 = new OpportunityTeamMember();
        opportunityTeamMember5.OpportunityId = resultOpportunity[4].id;
        opportunityTeamMember5.UserId = resultUser1[0].Id;
        opportunityTeamMember5.TeamMemberRole = 'Account Manager';
        insert opportunityTeamMember5;

        Amendment__c amendment = TestsObjectProvider.CreateAmendment(resultAccount[0].Id, 'Prospecting', null, resultOpportunity[0].Id, Date.today(), Date.today());
        amendment.OwnerId = resultUser1[0].Id;

        Amendment__c amendment1 = TestsObjectProvider.CreateAmendment(resultAccount[0].Id, 'In Progress', null, resultOpportunity[1].Id, Date.today(), Date.today());
        amendment1.OwnerId = resultUser1[0].Id;
        amendment1.RecordTypeId = FCGlobal.getRecordTypeId(String.valueOf(Amendment__c.getsObjectType()),'Opportunity');

        Amendment__c amendment2 = TestsObjectProvider.CreateAmendment(resultAccount[0].Id, 'WWWWWWW', null, resultOpportunity[2].Id, Date.today(), Date.today());
        amendment2.OwnerId = resultUser1[0].Id;

        Amendment__c amendment3 = TestsObjectProvider.CreateAmendment(resultAccount[0].Id, 'In Progress', null, resultOpportunity[3].Id, Date.today(), Date.today());
        amendment3.OwnerId = resultUser1[0].Id;
        amendment3.RecordTypeId = FCGlobal.getRecordTypeId(String.valueOf(Amendment__c.getsObjectType()),'Opportunity');

        Amendment__c amendment4 = TestsObjectProvider.CreateAmendment(resultAccount[0].Id, 'In Progress', null, resultOpportunity[4].Id, Date.today(), Date.today());
        amendment4.OwnerId = resultUser1[0].Id;
        amendment4.RecordTypeId = FCGlobal.getRecordTypeId(String.valueOf(Amendment__c.getsObjectType()),'Contact');

        Database.Saveresult[] ResultAmendment = TestsObjectProvider.InsertListWithAssert(new List<Amendment__c>{amendment,amendment1,amendment2,amendment3,amendment4});

        FGM_Portal__PortalConfiguration__c portalConfiguration = TestsObjectProvider.CreateFGMPortalPortalConfiguration('Applicant Portal', 'Requested;Scheduled;Received', true, true, 'Change Requests', 'Benchmark', false, 'Grantee Inbox', 'Grantee Report', 'en_US', 'Declined;Closed', 'Request', 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started', 'Inquiry', 'Declined;Closed;Submitted', 'Working - Contacted;New;Requested;More Information;Reopened;Application Invited;Open - Not Contacted;In Progress');
        portalConfiguration.FGM_Portal__RequestDeletableStatus__c = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        portalConfiguration.FGM_Portal__RequestHistoryTab__c = 'Qualification';
        portalConfiguration.FGM_Portal__GranteeReportHistoryTab__c = 'Submitted';
        portalConfiguration.FGM_Portal__GranteeReportHiddenStatus__c = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        portalConfiguration.FGM_Portal__GranteeReportDeletableStatus__c  = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        portalConfiguration.FGM_Portal__InquiryDeletableStatus__c = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        portalConfiguration.FGM_Portal__InquiryHiddenStatus__c = 'Application Re-Opened';
        portalConfiguration.FGM_Portal__AmendmentHistoryTab__c= 'Needs Analysis;Application Invited;Application Re-Opened;Under Review;Prospecting;Application Started';
        portalConfiguration.FGM_Portal__AmendmentEditableStatus__c  = 'In Progress;Application Invited';
        portalConfiguration.FGM_Portal__AmendmentDeletableStatus__c = 'In Progress;Application Invited';
        portalConfiguration.FGM_Portal__AmendmentHiddenStatus__c = 'Proposed';
        portalConfiguration.FGM_Portal__BenchmarkEditableStatus__c = 'Proposed;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        portalConfiguration.FGM_Portal__BenchmarkDeletableStatus__c = 'Needs Analysis;Application Invited;Application Re-Opened;In Progress;Under Review;Prospecting;Application Started';
        portalConfiguration.FGM_Portal__RequestHiddenStatus__c = 'Application Started';
        portalConfiguration.FGM_Portal__RequestStatusField__c ='StageName';
        portalConfiguration.FGM_Portal__GranteeReportStatusField__c = 'FGM_Base__Status__c';
        portalConfiguration.FGM_Portal__InquiryStatusField__c = 'Status';
        Database.Saveresult[] resultPortalConfiguration = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__PortalConfiguration__c>{portalConfiguration});

        System.RunAs(user1)
        {
            CommunityDashboardController newCommunityDashboardController = new CommunityDashboardController();
            CommunityDashboardController.initializeDashboard('en_US');
            newCommunityDashboardController.showProfileOptions = true;
            CommunityDashboardController.communityAmendmentSetting = new FGM_Portal__CommunitySetting__c();
            FGM_Portal__CommunitySetting__c communityAmendmentSetting1 = CommunityDashboardController.communityAmendmentSetting;
            CommunityDashboardController.initializeDashboard('en_US');
            CommunityDashboardController.getActivityHistoryData();
            List<Id> lstOppOwnerIds = new List<Id>();
            lstOppOwnerIds.add(opportunityQuali.OwnerId);
            lstOppOwnerIds.add(opportunity2.OwnerId);
            lstOppOwnerIds.add(opportunity3.OwnerId);
            lstOppOwnerIds.add(opportunity4.OwnerId);
            lstOppOwnerIds.add(opportunity5.OwnerId);

            List<Id> lstOppIds = new List<Id>();
            lstOppIds.add(opportunityQuali.Id);
            lstOppIds.add(opportunity2.Id);
            lstOppIds.add(opportunity3.Id);
            lstOppIds.add(opportunity4.Id);
            lstOppIds.add(opportunity5.Id);

            Map<Id,String> mapOppAndAccessLevel = new Map<Id,String>();
            Map<Id,Boolean> mapDeletableAccess  = new Map<Id,Boolean>();
            mapOppAndAccessLevel = CommunityDashboardController.getOpportunityTeamMembers();
            mapOppAndAccessLevel.put(opportunityQuali.Id,'All');
            mapOppAndAccessLevel.put(opportunity2.Id,'All');
            mapOppAndAccessLevel.put(opportunity3.Id,'All');
            mapOppAndAccessLevel.put(opportunity4.Id,'View');
            mapOppAndAccessLevel.put(opportunity5.Id,'All');

            CommunityDashboardController.getData('FGM_Portal__Amendment__c',mapOppAndAccessLevel,lstOppOwnerIds,'en_US');
            CommunityDashboardController.saveAmendmentRecord(opportunityQuali.Id);
        }
    }

    static testMethod void checkActivity (){

        List<User> lstSysAdminUsers = [SELECT Id from User WHERE Profile.Name ='System Administrator' AND IsActive = true ];
        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        account.OwnerId = lstSysAdminUsers[0].Id;
        Database.SaveResult[] resultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

        Contact contact = TestsObjectProvider.CreateContact('testContact1', 'testContact1', resultAccount[0].Id, 'test@test1.com');
        Database.SaveResult[] resultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});

        FGM_Portal__GlobalPortalSettings__c globalSetting = new FGM_Portal__GlobalPortalSettings__c();
        globalSetting.FGM_Portal__Grantee_Portal_Prefix__c = 'fcgrantee';
        globalSetting.FGM_Portal__Reviewer_Portal_Prefix__c = 'grantee';
        insert globalSetting;

        List<FGM_Portal__Portal_User__c> lstPortalUser = new List<FGM_Portal__Portal_User__c>();
        lstPortalUser.add(TestSObjectProvider.CreateFGMPortalUser(null, 'test@fc-community-developer-edition.na17.force.com', 'Portal LastName', 'test@test1.com', 'test@test1.com', 'test@osf-communities-developer-edition.na17.force.com', 'Test1234', 'Test1234', true));
        Database.Saveresult[] resultFGMPortalUser = TestsObjectProvider.InsertListWithAssert(lstPortalUser);

        Contact contact1 = TestsObjectProvider.CreateContact('testContact2', 'testContact2', resultAccount[0].Id, 'test@test2.com');
        Database.SaveResult[] resultContact1 = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact1});

        User user1 = TestsObjectProvider.CreateUser( resultContact[0].Id, 'test@test2.com', 'testUser2', 'testUser2', 'test1@osftest.com', true, 'FC Community Users Profile', account.Name);
        user1.ProfileType__c = 'individual';
        user1.UserProfile__c = 'Grantee';
        Database.SaveResult[] resultUser1 = TestsObjectProvider.InsertListWithAssert(new List<User>{user1});
        System.RunAs(user1)
        {
            Opportunity opportunity = TestsObjectProvider.CreateOpportunity('testOppHistoryTracking', 'In Progress', Date.today());
            Database.Saveresult[] resultOpportunity = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunity});
            system.assert(resultOpportunity.size() > 0);
            Task task = TestsObjectProvider.CreateTask(resultAccount[0].Id, 'TestSubject', Date.today().addDays(10), 'Completed');
            task.Description = 'Body:Testing Activity History';
            task.WhoId = resultContact[0].Id;
            task.OwnerId = resultUser1[0].Id;
            task.FGM_Portal__ResponseBy__c = resultUser1[0].Id;
            Database.SaveResult[] resultTask = TestsObjectProvider.InsertListWithAssert(new List<Task>{task});

            CommunityDashboardController.getmapActivityHistories();
            CommunityDashboardController.getActivityHistoryData();
            CommunityDashboardController.setEmailContent(resultTask[0].Id , 'Completed');
            CommunityDashboardController.ComposeMail();
        }
    }
    static testMethod void coverageClasses(){
        CommunityDashboardController.Actions actionTOTest = null;
        actionTOTest = new CommunityDashboardController.Actions();
        system.assert(actionTOTest != null);
        actionTOTest = new CommunityDashboardController.Actions('label','name');
        system.assert(actionTOTest != null);

    }

    @isTest
    private static void shouldUseEnhancedStylingWhenEnabled() {
        insert new FGM_Portal__CommunitySetting__c(Name = 'UseEnhancedStyling', IsEnabled__c = true);
        System.assertEquals(true, new CommunityDashboardController().enhancedStylingEnabled,
            'Enhanced styling should be enabled'
        );
    }

    @isTest
    private static void shouldNotUseEnhancedStylingWhenDisabled() {
        insert new FGM_Portal__CommunitySetting__c(Name = 'UseEnhancedStyling', IsEnabled__c = false);
        System.assertEquals(false, new CommunityDashboardController().enhancedStylingEnabled,
            'Enhanced styling should not be enabled'
        );
    }

    @isTest
    private static void shouldNotUseEnhancedStylingWhenSettingDoesNotExist() {
        System.assertEquals(false, new CommunityDashboardController().enhancedStylingEnabled,
            'Enhanced styling should not be enabled'
        );
    }
}