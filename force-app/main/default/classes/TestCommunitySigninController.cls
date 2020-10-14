@isTest
private class TestCommunitySigninController{
    static testMethod void communitySigninController()    {
        User sysAdminUsers = [ SELECT Id,IsActive,UserProfile__c,Return_URL__c FROM User WHERE Profile.Name ='System Administrator'  AND IsActive = true LIMIT 1];
        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        account.OwnerId = sysAdminUsers.Id;
        Database.SaveResult[] resultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});
        Contact contact = TestsObjectProvider.CreateContact('testContact1', 'testContact1', resultAccount[0].Id, 'test@test1.com');
        Database.SaveResult[] resultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});
        FGM_Portal__Quiz__c fGMPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz('PortalQuiz1', 'test@test1.com', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
        Database.Saveresult[] resultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{fGMPortalQuiz});
        List<FGM_Portal__Portal_User__c> lstPortalUser = new List<FGM_Portal__Portal_User__c>();
        lstPortalUser.add(TestSObjectProvider.CreateFGMPortalUser(null, 'test@fc-community-developer-edition.na17.force.com', 'Portal LastName', 'test@test1.com', 'test@test1.com', 'test@fc-communities-developer-edition.na17.force.com', 'Test1234', 'Test1234', true));
        lstPortalUser[0].Account__c = account.Id;
        Database.Saveresult[] resultFGMPortalUser = TestsObjectProvider.InsertListWithAssert(lstPortalUser);
        List<FGM_Portal__CustomHTML__c> lstFGMPortalCustomHTML = new List<FGM_Portal__CustomHTML__c>();
        lstFGMPortalCustomHTML.add(TestsObjectProvider.CreateFGMPortalCustomHTML('Grantee Sign In', 'Grantee', 'en_US', 'Header', 'Description1'));
        lstFGMPortalCustomHTML.add(TestsObjectProvider.CreateFGMPortalCustomHTML('Communities Sign Up - Step 1', 'Grantee', 'en', 'Header', 'Description1'));
        lstFGMPortalCustomHTML.add(TestsObjectProvider.CreateFGMPortalCustomHTML('Communities Sign Up - Step 1', 'Grantee', 'en_US', 'Header', 'Description2'));
        Database.Saveresult[] resultsFGMPortalCustomHTML = TestsObjectProvider.InsertListWithAssert(lstFGMPortalCustomHTML);
        System.runAs(sysAdminUsers) {
                Profile profile = [SELECT Id FROM Profile WHERE UserType ='PowerPartner' LIMIT 1];

                User user1 = new User(Alias = 'test01', Title = 'TEST',ContactId = resultContact[0].Id, Email = 'communitiesupdateduser@test.com', EmailEncodingKey = 'ISO-8859-1', FirstName = 'Demo2', IsActive = true, LanguageLocaleKey = 'en_US', LastName = 'User1', LocaleSidKey = 'en_US', MobilePhone = '(303) 555-0000', Phone = '(303) 555-2222', ProfileId = profile.Id, TimeZoneSidKey = 'America/New_York', Username = 'test@fc-community-developer-edition.na7.force.com');
                user1.ProfileType__c = 'Individual';
                user1.UserProfile__c = 'Grantee;Reviewer';
                user1.Return_URL__c = 'retUrl=null';
                insert user1;
                system.assertNotEquals(user1.Id,null);
                Pagereference testPageReference = Page.CommunitySignin;
                Test.setCurrentPageReference(testPageReference);
                ApexPages.currentPage().getParameters().put('un', 'test');
                ApexPages.currentPage().getParameters().put('UType', 'Individual');
                ApexPages.currentPage().getParameters().put('quizId',resultFGMPortalQuiz[0].Id);
                ApexPages.currentPage().getParameters().put('retUrl', '/apex/CommunityApplication');
                CommunitySigninController newCommunitySignin = new CommunitySigninController();
                newCommunitySignin.portalLanguage = null;
                newCommunitySignin.domainName = 'fc-community-developer-edition.na7.force.com';
                string strUsername = user1.Username;

                newCommunitySignin.username = 'strUsername'+strUsername.Split('@')[0];
                newCommunitySignin.getCustomHTMLDescription();
                newCommunitySignin.reference = new Pagereference('/apex/CommunityDashboard?sfdc.tabName=01ro000000013U6');
                newCommunitySignin.getImageLogoUrl();
                newCommunitySignin.save();
                newCommunitySignin.isSessionFound=true;

                newCommunitySignin.initialize();
                newCommunitySignin.isSessionFound=false;
                newCommunitySignin.initialize();
                newCommunitySignin.password='';
                newCommunitySignin.userProfile=null;

                //Check for retURL
                Pagereference testPageReference1 = Page.CommunitySignin;
                Test.setCurrentPageReference(testPageReference1);
                ApexPages.currentPage().getParameters().put('un', 'test');
                ApexPages.currentPage().getParameters().put('UType', '');
                ApexPages.currentPage().getParameters().put('retUrl', null);
                ApexPages.currentPage().getParameters().put('quizId',resultFGMPortalQuiz[0].Id);

                CommunitySigninController newCommunitySignin1 = new CommunitySigninController();
                newCommunitySignin1.portalLanguage = null;
                newCommunitySignin1.domainName = 'fc-community-developer-edition.na7.force.com';
                string strUser = user1.Username;
                newCommunitySignin1.username = strUser.Split('@')[0];
                newCommunitySignin1.getCustomHTMLDescription();
                newCommunitySignin1.reference = new Pagereference('/apex/CommunityDashboard?sfdc.tabName=01ro000000013U6');
                newCommunitySignin1.getImageLogoUrl();

                newCommunitySignin1.save();
                newCommunitySignin.isSessionFound=true;

                newCommunitySignin.initialize();
                newCommunitySignin.isSessionFound=false;
                newCommunitySignin.initialize();
                newCommunitySignin1.domainName=null;
                newCommunitySignin1.save();

                //Check for retURL 2
                Pagereference testPageReference2 = Page.CommunitySignin;
                Test.setCurrentPageReference(testPageReference2);
                ApexPages.currentPage().getParameters().put('un', 'test');
                ApexPages.currentPage().getParameters().put('UType', 'Individual');
                ApexPages.currentPage().getParameters().put('retUrl', '/apex/CommunityApplication');

                CommunitySigninController newCommunitySignin2 = new CommunitySigninController();
                newCommunitySignin2.portalLanguage = null;
                newCommunitySignin2.domainName = ':;^.)(,';
                newCommunitySignin2.username = ':;^,,';
                newCommunitySignin2.invalidCredential = true;
                newCommunitySignin2.getCustomHTMLDescription();
                newCommunitySignin2.reference = new Pagereference('/apex/CommunityDashboard?sfdc.tabName=01ro000000013U6');
                newCommunitySignin2.getImageLogoUrl();
                newCommunitySignin2.save();

                //Check for Inactive User
                Pagereference testPageReference3 = Page.CommunitySignin;
                Test.setCurrentPageReference(testPageReference3);
                ApexPages.currentPage().getParameters().put('un', 'test');
                ApexPages.currentPage().getParameters().put('UType', 'Individual');
                ApexPages.currentPage().getParameters().put('retUrl', '/apex/CommunityApplication');
                ApexPages.currentPage().getParameters().put('quizId',resultFGMPortalQuiz[0].Id);

                user1.IsActive = False;
                Database.SaveResult[] resultUser3 = TestsObjectProvider.UpdateListWithAssert(new List<User>{user1});
                CommunitySigninController objCommunitySignin= new CommunitySigninController();
                objCommunitySignin.portalLanguage = null;
                objCommunitySignin.domainName = 'fc-community-developer-edition.na7.force.com';
                string strUsernames = user1.Username;
                objCommunitySignin.username = strUsernames.Split('@')[0];
                CustomHTML__c strCustomHTML = objCommunitySignin.getCustomHTMLDescription();
                System.assert(strCustomHTML != null);
                objCommunitySignin.reference = new Pagereference('/apex/CommunityDashboard?sfdc.tabName=01ro000000013U6');
                objCommunitySignin.getImageLogoUrl();
                objCommunitySignin.save();
                objCommunitySignin.cannotAccessAccount();
                objCommunitySignin.newUser();
        }
    }
}