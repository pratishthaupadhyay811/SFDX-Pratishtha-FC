@isTest
private class TestCommunitySecureMessageController{

    static testMethod void communitySecureMessageController(){
        List<User> lstSysAdminUsers = [SELECT Id FROM User WHERE Profile.Name ='System Administrator' AND IsActive = true LIMIT 1];
        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        account.OwnerId = lstSysAdminUsers[0].Id;
        Database.SaveResult[] resultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

        Contact contact = TestsObjectProvider.CreateContact('testContact1', 'testContact1', resultAccount[0].Id, 'test@test1.com');
        Database.SaveResult[] resultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});

        FGM_Portal__Portal_User__c portalUser = TestsObjectProvider.CreateFGMPortalUser(null, 'test1@fc-community-developer-edition.na17.force.com', 'Portal LastName1', 'test@test.com', 'test@test.com', 'test1@osf-communities-developer-edition.na17.force.com', 'Test1234', 'Test1234', true);
        portalUser.Confirmation_Code__c = '123456';
        portalUser.FGM_Portal__FirstName__c = 'test Protal FirstName';
        portalUser.ProfileType__c = 'Individual';
        portalUser.OwnerId = lstSysAdminUsers[0].Id;
        Database.SaveResult[] ResultPortalUser = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Portal_User__c>{PortalUser});

        User user = TestsObjectProvider.CreateUser( resultContact[0].Id, 'test@test2.com', 'testUser2', 'testUser2', 'test1@osftest.com', true, 'FC Community Users Profile', account.Name );
        user.ProfileType__c = 'Organization';
        user.UserProfile__c = 'Grantee';
        Database.SaveResult[] resultUser = TestsObjectProvider.InsertListWithAssert(new List<User>{ user });

        FGM_Portal__Quiz__c fGMPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz('PortalQuiz1', 'test@test1.com', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
        Database.Saveresult[] ResultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{fGMPortalQuiz});

        List<Campaign> lstCampaign = new List<Campaign>();
        lstCampaign.add(TestsObjectProvider.CreateCampaign('TestCampaign', 'test@test1.com', Date.today(), Date.today(), ResultFGMPortalQuiz[0].Id, null));
        lstCampaign.add(TestsObjectProvider.CreateCampaign('TestCampaign', '', Date.today(), Date.today(), ResultFGMPortalQuiz[0].Id, null));
        Database.Saveresult[] resultscampaign = TestsObjectProvider.InsertListWithAssert(lstCampaign);

        Task task = TestsObjectProvider.CreateTask(resultAccount[0].Id, 'TestSubject', Date.today(), 'Completed');
        Database.SaveResult[] resultTask = TestsObjectProvider.InsertListWithAssert(new List<Task>{task});

        Opportunity opportunity = TestsObjectProvider.CreateOpportunity('testOpp', 'In Progress', Date.today());
        opportunity.CampaignId = resultscampaign[0].Id;
        Database.Saveresult[] resultOpportunity = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunity});

        List<OpportunityTeamMember> lstOppTeamMemeber = new List<OpportunityTeamMember>();
        lstOppTeamMemeber.add(TestsObjectProvider.CreateOpportunityTeamMember(resultOpportunity[0].Id, 'Applicant', resultUser[0].Id));
        Database.Saveresult[] resultsOppTeamMember = TestsObjectProvider.InsertListWithAssert(lstOppTeamMemeber);

        Secure_Message__c secureMessage = TestsObjectProvider.CreateSecureMessage('TestBody', resultOpportunity[0].Id, resultUser[0].Id, lstSysAdminUsers[0].Id, 'Test Mail', '1234');
        Database.SaveResult[] resultSecureMessage = TestsObjectProvider.InsertListWithAssert(new List<Secure_Message__c>{secureMessage});

        CommunitySecureMessageController communitySecureMessage = new CommunitySecureMessageController();
        communitySecureMessage.selCampaign = resultscampaign[0].Id;
        List<SelectOption> lstSelectionOptions = communitySecureMessage.getCampaignList();
        System.assert(lstSelectionOptions != null);
        communitySecureMessage.selOpportunity = resultOpportunity[0].Id;
        communitySecureMessage.getOppList();
        communitySecureMessage.lstOpportunityTeamMember = new List<String>{ resultsOppTeamMember[0].Id };
        communitySecureMessage.getOppTeamMember();
        communitySecureMessage.secureMessage.Subject__c = null;
        communitySecureMessage.secureMessage.Body__c = null;
        communitySecureMessage.sendEmail();
        communitySecureMessage.secureMessage = secureMessage;
        PageReference pageReference = communitySecureMessage.sendEmail();
        System.assert(pageReference != null);
        communitySecureMessage.selCampaign = '0';
        communitySecureMessage.getCampaignList();
        communitySecureMessage.selOpportunity = '0';
        communitySecureMessage.getOppList();
        communitySecureMessage.sendEmail();
        String strEncrypt = communitySecureMessage.encrypt(null);
    }
}