@isTest
private class Test_OverrideViewExtension
{
    @testSetup static void setup()
    {
        Profile prof = [SELECT Id FROM Profile WHERE name='System Administrator'];

        FGM_Portal__GlobalPortalSettings__c globalPortalSettings =  FGM_Portal__GlobalPortalSettings__c.getOrgDefaults();
        if(globalPortalSettings != null && prof != null)
        {
            if(String.isNotBlank(globalPortalSettings.FGM_Portal__Redirect_URL__c))
                update globalPortalSettings ;
            else
            {
                globalPortalSettings.FGM_Portal__Redirect_URL__c = string.valueof(prof.Id).substring(0, 15)+':/FGM_Portal__CommunityDashboard';
                globalPortalSettings.FGM_Portal__Redirect_URL__c = prof.Id+':/FGM_Portal__CommunityDashboard';
                globalPortalSettings.FGM_Portal__Grantee_Portal_Prefix__c = 'fcgrantee';
                globalPortalSettings.FGM_Portal__Reviewer_Portal_Prefix__c = 'grantee';
                insert globalPortalSettings ;
            }
            system.assertNotEquals(null,globalPortalSettings);
        }

         //common test user
         List<User> lstSysAdminUsers = [ SELECT Id  FROM User WHERE Profile.Name ='System Administrator'  AND IsActive = true ];

         // common test accounts
         Account account = TestsObjectProvider.CreateAccount('TestAccount1');
         account.OwnerId = lstSysAdminUsers[0].Id;
         Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});
         system.assertNotEquals(null,ResultAccount);

         // common test contact
         Contact contact  = TestsObjectProvider.CreateContact('testContact1', 'testContact1', ResultAccount[0].Id, 'test@test1.com');
         Database.SaveResult[] ResultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});
         system.assertNotEquals(null,ResultContact);

         List<FGM_Portal__Portal_User__c> lstPortalUser = new List<FGM_Portal__Portal_User__c>();
         lstPortalUser.add(TestSObjectProvider.CreateFGMPortalUser(null, 'test@fc-community-developer-edition.na17.force.com', 'Portal LastName', 'test@test1.com', 'test@test1.com', 'test@osf-communities-developer-edition.na17.force.com', 'Test1234', 'Test1234', true));
         Database.Saveresult[] ResultFGMPortalUser = TestsObjectProvider.InsertListWithAssert(lstPortalUser);
         system.assertNotEquals(null,ResultFGMPortalUser);

         // common test Opportunity
         Opportunity opportunity = TestsObjectProvider.CreateOpportunity('testOpp', 'In Progress', Date.today());
         opportunity.AccountId = ResultAccount[0].Id;
         Database.Saveresult[] ResultOpportunity = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunity});
         system.assertNotEquals(null,ResultOpportunity);

         Lead lead = TestsObjectProvider.CreateLead('Test Lead FirstName', 'Test Lead LastName', 'Test Company', 'Open - Not Contacted');
         Database.Saveresult[] ResultLead = TestsObjectProvider.InsertListWithAssert(new List<Lead>{lead});
         system.assertNotEquals(null,ResultLead);

         FGM_Portal__Amendment__c amendment = TestsObjectProvider.CreateAmendment(ResultAccount[0].Id, 'In Progress', null, ResultOpportunity[0].Id, Date.today(), Date.today());
         Database.Saveresult[] ResultAmendment = TestsObjectProvider.InsertListWithAssert(new List<Amendment__c>{amendment});
         system.assertNotEquals(null,ResultAmendment);

         FGM_Base__Grantee_Report__c granteeReport = TestsObjectProvider.CreateFGMBaseGranteeReport(null, ResultOpportunity[0].Id, 'Received');
         Database.Saveresult[] ResultGranteeReport = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Grantee_Report__c>{granteeReport});
         system.assertNotEquals(null,ResultGranteeReport);

         FGM_Portal__Quiz__c appQuiz = TestsObjectProvider.CreateFGMPortalQuiz('PortalQuiz1', 'test@test1.com', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
         Database.Saveresult[] ResultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{appQuiz});
         system.assertNotEquals(null,ResultFGMPortalQuiz);

         FGM_Base__Review__c appReview = new FGM_Base__Review__c(OwnerId=lstSysAdminUsers[0].Id);
         insert appReview;
         system.assertNotEquals(null,appReview);

         Campaign campaign = TestsObjectProvider.CreateCampaign('TestCampaign', 'test@test1.com', Date.today(), Date.today(), ResultFGMPortalQuiz[0].Id,null);
         Database.Saveresult[] Resultcampaign = TestsObjectProvider.InsertListWithAssert(new List<Campaign>{campaign});
         system.assertNotEquals(null,Resultcampaign);

         FGM_Base__Benchmark__c FGMBaseBenchmark = TestsObjectProvider.CreateFGMBaseBenchmark(ResultOpportunity[0].Id, 'Proposed', true, true, Date.today(), true);
         Database.Saveresult[] ResultFGMBaseBenchmark = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Benchmark__c>{FGMBaseBenchmark});
         system.assertNotEquals(null,ResultFGMBaseBenchmark);
    }

    static testMethod void OverrideViewExtension()
    {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        system.assertNotEquals(null,acc);
        ApexPages.StandardController accSC = new ApexPages.StandardController(acc);
        OverrideViewExtension accView = new OverrideViewExtension(accSC);

        Contact cont = [SELECT Id FROM Contact LIMIT 1];
        system.assertNotEquals(null,cont);
        ApexPages.StandardController contSC = new ApexPages.StandardController(cont);
        OverrideViewExtension contView = new OverrideViewExtension(contSC);

        FGM_Portal__Amendment__c amend = [SELECT Id FROM FGM_Portal__Amendment__c LIMIT 1];
        system.assertNotEquals(null,amend);
        ApexPages.StandardController amendmentSC = new ApexPages.StandardController(amend);
        OverrideViewExtension amendmentView = new OverrideViewExtension(amendmentSC);

        FGM_Base__Grantee_Report__c granteeRprt = [SELECT Id FROM FGM_Base__Grantee_Report__c LIMIT 1];
        system.assertNotEquals(null,granteeRprt);
        ApexPages.StandardController granteeReportSC = new ApexPages.StandardController(granteeRprt);
        OverrideViewExtension granteeReportView = new OverrideViewExtension(granteeReportSC);

        FGM_Portal__Quiz__c quiz = [SELECT Id FROM FGM_Portal__Quiz__c LIMIT 1];
        system.assertNotEquals(null,quiz);
        ApexPages.StandardController quizSC = new ApexPages.StandardController(quiz);
        OverrideViewExtension quizView = new OverrideViewExtension(quizSC);

        FGM_Base__Review__c review = [SELECT Id FROM FGM_Base__Review__c LIMIT 1];
        system.assertNotEquals(null,review);
        ApexPages.StandardController reviewSC = new ApexPages.StandardController(review);
        OverrideViewExtension reviewView = new OverrideViewExtension(reviewSC);

        Campaign campn = [SELECT Id FROM Campaign LIMIT 1];
        system.assertNotEquals(null,campn);
        ApexPages.StandardController campnSC = new ApexPages.StandardController(campn);
        OverrideViewExtension campnView = new OverrideViewExtension(campnSC);

        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        system.assertNotEquals(null,opp);
        ApexPages.StandardController oppSC = new ApexPages.StandardController(opp);
        OverrideViewExtension oppView = new OverrideViewExtension(oppSC);

        Lead lead = [SELECT Id FROM Lead LIMIT 1];
        system.assertNotEquals(null,lead);
        ApexPages.StandardController leadSC = new ApexPages.StandardController(lead);
        OverrideViewExtension leadView = new OverrideViewExtension(leadSC);

        FGM_Portal__Portal_User__c portalUser = [SELECT Id FROM FGM_Portal__Portal_User__c LIMIT 1];
        system.assertNotEquals(null,portalUser);
        ApexPages.StandardController portalUserSC = new ApexPages.StandardController(portalUser);
        OverrideViewExtension portalUserView = new OverrideViewExtension(portalUserSC);

        FGM_Base__Benchmark__c benchmark = [SELECT Id FROM FGM_Base__Benchmark__c LIMIT 1];
        system.assertNotEquals(null,benchmark);
        ApexPages.StandardController benchmarkSC = new ApexPages.StandardController(benchmark);
        OverrideViewExtension benchmarkView = new OverrideViewExtension(benchmarkSC);
    }
}