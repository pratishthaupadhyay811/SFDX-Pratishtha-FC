@isTest
private with sharing class TestCommunitySignupConfirmExtension {
    private final static String CONFIRMATION_CODE = '123123.213123';

    @TestSetup
    private static void setup(){
        FGM_Portal__CommunityConfiguration__c communityConfiguration = new FGM_Portal__CommunityConfiguration__c();
        communityConfiguration.FGM_Portal__JsonData__c =
            '{'
            + '    "PortalUserToContact": ['
            + '        { "Name": "Title", "Value": "FGM_Portal__Title__c" }'
            + '    ],'
            + '    "PortalUserToAccount": ['
            + '        { "Name": "BillingCity", "Value": "FGM_Portal__City__c" }'
            + '    ]'
            + '}';

        communityConfiguration.FGM_Portal__ConfiguationName__c = 'PortalUserFieldMapping';

        insert communityConfiguration;
    }

    @isTest
    private static void CommunitySignupConfirmExtension()
    {
        FGM_Portal__Triggers__c portalTrigger = new FGM_Portal__Triggers__c();
        portalTrigger.Name = 'AllTriggers_Record';
        portalTrigger.FGM_Portal__OnAccountUpdate__c = true;
        portalTrigger.FGM_Portal__OnContactUpdate__c = true;
        insert portalTrigger;
        system.assertNotEquals(portalTrigger.Id,null);

        List<User> lstSysAdminUsers = [SELECT Id FROM User WHERE Profile.Name ='System Administrator' AND IsActive = true];

        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        account.OwnerId = lstSysAdminUsers[0].Id;
        Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

        FGM_Portal__Portal_Account__c PortalAccount = TestsObjectProvider.CreateFGMPortalAccount(ResultAccount[0].Id, 'PortalAccountName');
        PortalAccount.OwnerId = UserInfo.getUserId();
        Database.SaveResult[] ResultPortalAccount = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Portal_Account__c>{PortalAccount});

        Contact contact = TestsObjectProvider.CreateContact('TestFirstName', 'TestLastName', ResultAccount[0].Id, 'test@test.com');
        Database.SaveResult[] Resultcontact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});

        List<FGM_Portal__CustomHTML__c> lstFGMPortalCustomHTML = new List<FGM_Portal__CustomHTML__c>();
        lstFGMPortalCustomHTML.add(TestsObjectProvider.CreateFGMPortalCustomHTML('Opportunity Team Member Registration Fields', 'Grantee', 'en_US', 'Header', 'Description1'));
        lstFGMPortalCustomHTML.add(TestsObjectProvider.CreateFGMPortalCustomHTML('Opportunity Team Member Registration Fields', 'Grantee', '', 'Header', 'Description1'));
        lstFGMPortalCustomHTML.add(TestsObjectProvider.CreateFGMPortalCustomHTML('RPCommunities Sign Up - Step 1', 'Reviewer', 'en_US', 'Header', 'Description2'));
        Database.Saveresult[] ResultsFGMPortalCustomHTML = TestsObjectProvider.InsertListWithAssert(lstFGMPortalCustomHTML);

        Map<String,Schema.Recordtypeinfo> newPortalUserRecordTypeMapByName = FGM_Portal__Portal_User__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        FGM_Portal__Portal_User__c PortalUser = TestsObjectProvider.CreateFGMPortalUser(null, 'test1@fc-community-developer-edition.na17.force.com', 'Portal LastName1', 'test@test.com', 'test@test.com', 'test1@osf-communities-developer-edition.na17.force.com', 'Test1234', 'Test1234', true);
        PortalUser.RecordTypeId = newPortalUserRecordTypeMapByName.get(TestsObjectProvider.PORTAL_USER_OPPTEAMMEMBER).getRecordTypeId();
        PortalUser.Confirmation_Code__c = '123456';
        PortalUser.FGM_Portal__FirstName__c = 'test Protal FirstName';
        PortalUser.ProfileType__c = 'Individual';
        PortalUser.OwnerId = lstSysAdminUsers[0].Id;
        PortalUser.FGM_Portal__City__c = 'pune';
        Database.SaveResult[] ResultPortalUser = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Portal_User__c>{PortalUser});

        User user1 = TestsObjectProvider.CreateUser( ResultContact[0].Id, 'test@test2.com', 'testUser2', 'testUser2', 'test1@osftest.com', true, 'Partner Community User', account.Name);
        Database.SaveResult[] ResultUser1 = TestsObjectProvider.InsertListWithAssert(new List<User>{user1});

        Map<String,Schema.Recordtypeinfo> newGuidestarFieldRecordTypeMapByName = FGM_Portal__GuidestarFieldMapping__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        List<FGM_Portal__GuidestarFieldMapping__c> lstFGMPortalGuidestarFieldMapping = new List<FGM_Portal__GuidestarFieldMapping__c>();
        lstFGMPortalGuidestarFieldMapping.add( TestsObjectProvider.CreateFGMPortalGuidestarFieldMapping(newGuidestarFieldRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GUIDESTAR_GUIDEPORTALUSER).getRecordTypeId(), 'testRegistered', ResultAccount[0].Id));
        lstFGMPortalGuidestarFieldMapping.add( TestsObjectProvider.CreateFGMPortalGuidestarFieldMapping(newGuidestarFieldRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GUIDESTAR_GUIDECONTACT).getRecordTypeId(), 'testRegistered1', ResultAccount[0].Id));
        lstFGMPortalGuidestarFieldMapping.add( TestsObjectProvider.CreateFGMPortalGuidestarFieldMapping(newGuidestarFieldRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GUIDESTAR_GUIDEORGANIZATION).getRecordTypeId(), 'testRegistered2', ResultAccount[0].Id));
        Database.Saveresult[] ResultsFGMPortalGuidestarFieldMapping = TestsObjectProvider.InsertListWithAssert(lstFGMPortalGuidestarFieldMapping);

        Pagereference testPageReference = Page.CommunitySignupConfirm;
        Test.setCurrentPageReference(testPageReference);
        ApexPages.currentPage().getParameters().put('code', '123456');
        ApexPages.currentPage().getParameters().put('retUrl', '/apex/FGM_Portal__CommunityDashboard?');
        ApexPages.currentPage().getParameters().put('quizId', '/apex/FGM_Portal__CommunityDashboard?');

        ApexPages.Standardcontroller scSignUp = new ApexPages.Standardcontroller(PortalUser);
        CommunitySignupConfirmExtension newCommunitySignupConfirm = new CommunitySignupConfirmExtension(scSignUp);
        newCommunitySignupConfirm.getImageLogoUrl();
        newCommunitySignupConfirm.initialize();
        newCommunitySignupConfirm.UserAdminId  = lstSysAdminUsers[0].Id;
        newCommunitySignupConfirm.register();
        newCommunitySignupConfirm.userId = ResultUser1[0].Id;
        newCommunitySignupConfirm.activate();

        FGM_Portal__Portal_User__c PortalUser1 = TestsObjectProvider.CreateFGMPortalUser(null, null, 'Portal LastName1', 'test@test1.com', 'test@test1.com', 'test2', 'Test1234', 'Test1234', true);
        PortalUser1.Confirmation_Code__c = '123456';
        PortalUser1.FGM_Portal__FirstName__c = 'test FirstName1';

        FGM_Portal__Portal_User__c PortalUser2 = TestsObjectProvider.CreateFGMPortalUser(null, null, 'Portal LastName2', 'test@test2.com', 'test@test2.com', 'test3', 'Test12343', 'Test12343', true);
        PortalUser2.Confirmation_Code__c = '1234562';
        PortalUser2.FGM_Portal__FirstName__c = 'test FirstName2';

        ResultPortalUser = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Portal_User__c>{PortalUser1});

        ApexPages.StandardController scPortalUser1 = new ApexPages.standardController( PortalUser1);
        CommunitySignupConfirmExtension CommunitySignupConfirm1 = new CommunitySignupConfirmExtension(scPortalUser1);
        CommunitySignupConfirm1.initialize();
        CommunitySignupConfirm1.UserAdminId  = lstSysAdminUsers[0].Id;
        CommunitySignupConfirm1.IsOpportunityTeamMemberPortalUser = true;
        CommunitySignupConfirm1.register();
        CommunitySignupConfirm1.userId = ResultUser1[0].Id;
        CommunitySignupConfirm1.portalUser.Name = PortalUser.Name + '@fc-community-developer-edition.na17.force.com';
        CommunitySignupConfirm1.activate();
        CommunitySignupConfirm1.userId = ResultUser1[0].Id;
        CommunitySignupConfirm1.activate();
        //To Test invalid User and Portal User
        ApexPages.StandardController scPortalUser2 = new ApexPages.standardController( PortalUser2);
        CommunitySignupConfirmExtension CommunitySignupConfirm2 = new CommunitySignupConfirmExtension(scPortalUser2);
        CommunitySignupConfirm2.IsSessionFound=false;
        CommunitySignupConfirm2.initialize();
        CommunitySignupConfirm2.register();
    }
    static testmethod void testAssignPermssionSetToUser()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Partner Community User'];
        System.assertNotEquals(p,null);
        User communityUser = new User(
            Alias = 'standt',
            Email='standardusera_bcdef@testorg.com',
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='stand_duser1dddddddd_io_re_2433_1_dee_ae@testorg.com');

        Account userAccount = new Account(Name = 'Test portal _User Account_');
        insert userAccount;
        system.assertNotEquals(userAccount.Id,null);

        Contact userContact = new Contact(LastName = 'TestUser_portal_User_', Email = 'testUserddddr_dafdddde@bigCo.com', AccountId = userAccount.Id);
        insert userContact;
        system.assertNotEquals(userContact.Id,null);

        communityUser.ContactId = userContact.Id;
        String userId = Site.createPortalUser(communityUser,userAccount.Id,'afdsafsf1234@d');

        System.runAs(communityUser)
        {
            Test.startTest();
            User createdPortalUser = [SELECT Id FROM User WHERE UserName =: communityUser.Username LIMIT 1 ];
            if(createdPortalUser != null && createdPortalUser.Id != null)
                FCGlobal.assignPermissionSetToUser(createdPortalUser.Id);

            Test.stopTest();
        }
    }

    @isTest
    private static void shouldCreateAnAccountForOrganizationPortalUser() {
        Portal_User__c orgUser = createOrganizationPortalUser();

        setCurrentPage();
        CommunitySignupConfirmExtensionWithMockSite extension =
            new CommunitySignupConfirmExtensionWithMockSite(new ApexPages.Standardcontroller(orgUser));
        extension.initialize();

        Test.startTest();
            extension.activate();
        Test.stopTest();

        assertOnErrorMessages();

        Portal_User__c updatedPortalUser = [
            SELECT Account__r.Name, Account__r.FGM_Base__EIN__c, Account__c
            FROM Portal_User__c
            WHERE Id = :orgUser.Id
        ];

        System.assertNotEquals(null, updatedPortalUser.Account__c, 'The Portal User should have an Account');

        System.assertEquals(orgUser.Organization_Legal_Name__c, updatedPortalUser.Account__r.Name,
            'The account name should be set with the Organization_Legal_Name__c from the Portal User'
        );

        System.assertEquals(orgUser.EIN__c, updatedPortalUser.Account__r.FGM_Base__EIN__c,
            'The account name should be set with the EIN__c from the Portal User'
        );
    }

    @isTest
    private static void shouldNotCreateAnAccountForOrganizationPortalUserIfAccountExists() {
        Account existingAccount = new Account(Name = 'Existing Account');
        insert existingAccount;

        Portal_User__c orgUser = createOrganizationPortalUser();
        orgUser.Account__c = existingAccount.Id;
        update orgUser;

        setCurrentPage();
        CommunitySignupConfirmExtensionWithMockSite extension =
            new CommunitySignupConfirmExtensionWithMockSite(new ApexPages.Standardcontroller(orgUser));
        extension.initialize();

        Test.startTest();
            extension.activate();
        Test.stopTest();

        assertOnErrorMessages();

        System.assertEquals(0, [SELECT COUNT() FROM Account WHERE Id != :existingAccount.Id],
            'Another account should be be created if one exists already for the portal user');
    }

    @isTest
    private static void shouldCreateAnAccountForAnIndividual() {
        Portal_User__c individual = createIndividualPortalUser();

        setCurrentPage();
        CommunitySignupConfirmExtensionWithMockSite extension =
            new CommunitySignupConfirmExtensionWithMockSite(new ApexPages.Standardcontroller(individual));
        extension.initialize();

        Test.startTest();
            extension.activate();
        Test.stopTest();

        assertOnErrorMessages();

        Portal_User__c updatedPortalUser = [
            SELECT Account__r.Name, Account__c
            FROM Portal_User__c
            WHERE Id = :individual.Id
        ];

        System.assertNotEquals(null, updatedPortalUser.Account__c, 'The Portal User should have an Account');

        System.assertEquals(individual.FirstName__c + ' ' + individual.LastName__c, updatedPortalUser.Account__r.Name,
            'The account name should be set with the Organization_Legal_Name__c from the Portal User'
        );
    }

    @isTest
    private static void shouldCreateAUserForOrganizationPortalUser() {
        Portal_User__c orgUser = createOrganizationPortalUser();

        setCurrentPage();
        CommunitySignupConfirmExtensionWithMockSite extension =
            new CommunitySignupConfirmExtensionWithMockSite(new ApexPages.Standardcontroller(orgUser));
        extension.initialize();

        Test.startTest();
            extension.activate();
        Test.stopTest();

        assertOnErrorMessages();

        User newUser = [
            SELECT
                Username, Email, FirstName, LastName, FGM_Portal__Return_URL__c,
                ProfileType__c, CompanyName
            FROM User
            WHERE Username = :orgUser.Name
        ];

        System.assertEquals(orgUser.Name, newUser.Username,
            'The Username on User should be set with the Name value from Portal User');
        System.assertEquals(orgUser.Email__c, newUser.Email,
            'The Email on User should be set with the Email__c value from Portal User');
        System.assertEquals(orgUser.FirstName__c, newUser.FirstName,
            'The FirstName on User should be set with the FirstName__c value from Portal User');
        System.assertEquals(orgUser.LastName__c, newUser.LastName,
            'The LastName on User should be set with the LastName__c value from Portal User');
        System.assertEquals(orgUser.Return_URL__c, newUser.Return_URL__c,
            'The Return_URL__c on User should be set with the Return_URL__c value from Portal User');
        System.assertEquals(orgUser.Organization_Legal_Name__c, newUser.CompanyName,
            'The CompanyName on User should be set with the Organization_Legal_Name__c value from Portal User');
        System.assertEquals(orgUser.ProfileType__c, newUser.ProfileType__c,
            'The ProfileType__c on User should be set with the ProfileType__c value from Portal User');
    }

    @isTest
    private static void shouldCreateAUserForIndividualPortalUser() {
        Portal_User__c individual = createIndividualPortalUser();

        setCurrentPage();
        CommunitySignupConfirmExtensionWithMockSite extension =
            new CommunitySignupConfirmExtensionWithMockSite(new ApexPages.Standardcontroller(individual));
        extension.initialize();

        Test.startTest();
            extension.activate();
        Test.stopTest();

        assertOnErrorMessages();

        User newUser = [
            SELECT
                ProfileType__c, CompanyName
            FROM User
            WHERE Username = :individual.Name
        ];

        System.assertEquals(individual.Organization_Legal_Name__c, newUser.CompanyName,
            'The CompanyName on User should be set with the Organization_Legal_Name__c value from Portal User');
        System.assertEquals(individual.ProfileType__c, newUser.ProfileType__c,
            'The ProfileType__c on User should be set with the ProfileType__c value from Portal User');
    }


    @isTest
    private static void shouldAssignPermissionSetToUser() {
        Portal_User__c orgUser = createOrganizationPortalUser();

        setCurrentPage();
        CommunitySignupConfirmExtensionWithMockSite extension =
            new CommunitySignupConfirmExtensionWithMockSite(new ApexPages.Standardcontroller(orgUser));
        extension.initialize();

        Test.startTest();
            extension.activate();
        Test.stopTest();

        assertOnErrorMessages();

        User newUser = [SELECT Id FROM User WHERE Username = :orgUser.Name];

        PermissionSet portalPermissionSet = [
            SELECT Id
            FROM PermissionSet
            WHERE Name = 'Community_Grantee_Permission_set_User_Login_Licence'
        ];

        System.assertEquals(
            1,
            [SELECT COUNT() FROM PermissionSetAssignment WHERE AssigneeId = :newUser.Id AND PermissionSetId = :portalPermissionSet.Id],
            'The permissions set shoudl assigned to the user'
        );
    }

    @isTest
    private static void shouldLinkUserContactToPortalUser() {
        Portal_User__c individual = createIndividualPortalUser();

        setCurrentPage();
        CommunitySignupConfirmExtensionWithMockSite extension =
            new CommunitySignupConfirmExtensionWithMockSite(new ApexPages.Standardcontroller(individual));
        extension.initialize();

        Test.startTest();
            extension.activate();
        Test.stopTest();

        assertOnErrorMessages();

        User newUser = [SELECT ContactId FROM User WHERE Username = :individual.Name];
        System.assertNotEquals(null, newUser.ContactId, 'The user should have a contact ID');

        Portal_User__c updatedPortalUser = [
            SELECT Contact__c, Approval_Status__c
            FROM Portal_User__c
            WHERE Id = :individual.Id
        ];

        System.assertEquals(newUser.ContactId, updatedPortalUser.Contact__c,
            'The Portal User should be linked to the User ContactID');
        System.assertEquals('Converted', updatedPortalUser.Approval_Status__c,
            'The Portal User should be marked as Converted after successfully creating user and linking contact');
    }

    @isTest
    private static void shouldMapPortalUserFieldsToAccountAndContact() {
        Portal_User__c individual = createIndividualPortalUser();

        setCurrentPage();
        CommunitySignupConfirmExtensionWithMockSite extension =
            new CommunitySignupConfirmExtensionWithMockSite(new ApexPages.Standardcontroller(individual));
        extension.initialize();

        Test.startTest();
            extension.activate();
        Test.stopTest();

        assertOnErrorMessages();

        Portal_User__c updatedPortalUser = [
            SELECT
                Title__c, Contact__r.Title,
                City__c, Account__r.BillingCity
            FROM Portal_User__c
            WHERE Id = :individual.Id
        ];

        System.assertEquals(updatedPortalUser.Title__c, updatedPortalUser.Contact__r.Title,
            'Portal user fields should be mapped to the Contact correctly');
        System.assertEquals(updatedPortalUser.City__c, updatedPortalUser.Account__r.BillingCity,
            'Portal user fields should be mapped to the Account1 correctly');
    }

    private static Portal_User__c createOrganizationPortalUser() {
        FGM_Portal__Portal_User__c portalUser = buildPortalUser();
        portalUser.Organization_Legal_Name__c = 'My Organization';

        insert portalUser;
        return portalUser;
    }

    private static Portal_User__c createIndividualPortalUser() {
        FGM_Portal__Portal_User__c portalUser = buildPortalUser();
        portalUser.FGM_Portal__ProfileType__c = 'Individual';
        portalUser.Organization_Legal_Name__c = portalUser.FirstName__c + ' ' + portalUser.LastName__c;

        insert portalUser;
        return portalUser;
    }

    private static Portal_User__c buildPortalUser() {
        FGM_Portal__Portal_User__c portalUser = new FGM_Portal__Portal_User__c(
            FirstName__c = 'Portal',
            LastName__c = 'TestLast',
            Email__c = 'test@example.com',
            Confirm_Email__c = 'test@example.com',
            EIN__c = '10-8675309',
            Name = 'username@somedummydomain.com' + Datetime.now().getTime(),
            Title__c = 'My Title',
            City__c = 'Metropolis',
            Return_URL__c = '/apex/CommunityApplication',
            Confirmation_Code__c = CONFIRMATION_CODE
        );

        return portalUser;
    }

    private static void setCurrentPage() {
        Test.setCurrentPageReference(Page.CommunitySignupConfirm);
        ApexPages.currentPage().getParameters().put('code', CONFIRMATION_CODE);
    }

    private static void assertOnErrorMessages() {
        System.assert(ApexPages.getMessages().isEmpty(),
            'There should be no error messages: '
                + (ApexPages.getMessages().size() == 0 ? '' : ApexPages.getMessages()[0].getDetail()));
    }

    /**
     * Allows us to override the createPortalUser method so we can mock Site.createPortalUser since it won't return
     * an ID in Tests.
     */
    private class CommunitySignupConfirmExtensionWithMockSite extends CommunitySignupConfirmExtension {
        public CommunitySignupConfirmExtensionWithMockSite(ApexPages.StandardController controller) {
            super(controller);
            this.UserAdminId = UserInfo.getUserId();
        }

        private override Id createPortalUser(User aUser, String accountId, String password) {
            Contact portalContact = new Contact(
                AccountId = accountId,
                LastName = aUser.LastName,
                Email = aUser.Email
            );
            insert portalContact;
            
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Partner Community User'];

            aUser.ProfileId = p.Id;
            aUser.ContactId = portalContact.Id;
            aUser.Alias = 'fcalias';
            aUser.EmailEncodingKey='UTF-8';
            aUser.LanguageLocaleKey='en_US';
            aUser.LocaleSidKey='en_US';
            aUser.TimeZoneSidKey='America/Los_Angeles';

            insert aUser;
            return aUser.Id;
        }
    }
}