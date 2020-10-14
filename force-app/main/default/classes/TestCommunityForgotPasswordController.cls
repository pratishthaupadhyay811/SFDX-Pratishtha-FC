@isTest
private class TestCommunityForgotPasswordController{
    @testSetup static void testSetup() {
        List<User> lstAdminUsers = [ SELECT Id FROM User WHERE Profile.Name ='System Administrator' AND IsActive = TRUE ];
        System.assert(lstAdminUsers != NULL);

        Account account = TestsObjectProvider.CreateAccount('Enzigma');
        account.OwnerId = lstAdminUsers[0].Id;
        Database.SaveResult[] resultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});
        System.assert(resultAccount != NULL);

        Contact contact = TestsObjectProvider.CreateContact('test', 'test',resultAccount[0].Id, 'test@contact.test');
        Database.SaveResult[] resultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});
        system.assert(resultContact != NULL);

        String userName = 'enzi@test.com@'+Site.getDomain();
        User portalUser = TestsObjectProvider.CreateUser(resultContact[0].Id,'test@test1.com', 'testUser1', 'testUser1', userName, true, 'FC Community Users Profile','Enzigma');
        portalUser.FGM_Portal__ProfileType__c = 'Individual';
        portalUser.FGM_Portal__UserProfile__c = 'Grantee';
        Database.SaveResult[] saveResult = TestsObjectProvider.insertListWithAssert(new List<User>{portalUser});
        System.assert(saveResult != NULL);
        Document document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'my_document';
        document.IsPublic = TRUE;
        document.Name = system.Label.FC_Logo_Name;
        document.FolderId = [select id from folder LIMIT 1].id;
        insert document;
        system.assert(document.id != NULL);
    }
    static testMethod void initialize(){
        CommunityForgotPasswordController objectForgotPassword = NEW CommunityForgotPasswordController();
        PageReference pageRefrence = objectForgotPassword.initialize();
        System.assert(pageRefrence != NULL);

        ApexPages.currentPage().getParameters().put('ln','en_US');
        objectForgotPassword = NEW CommunityForgotPasswordController();
        objectForgotPassword.isSessionFound = FALSE;
        pageRefrence = objectForgotPassword.initialize();
        System.assert(pageRefrence == NULL);
    }

    static testMethod void getImageLogoUrl(){
         CommunityForgotPasswordController objectForgotPassword = NEW CommunityForgotPasswordController();
         string result = objectForgotPassword.getImageLogoUrl();
         System.assert(String.isNotBlank(result));

         Document objectDocument = [SELECT Id FROM Document LIMIT 1];
         delete objectDocument;
         result = objectForgotPassword.getImageLogoUrl();
         System.assert(String.isBlank(result));
    }

    static testMethod void forgotPassword(){
        CommunityForgotPasswordController objectForgotPassword = NEW CommunityForgotPasswordController();
        PageReference pageRefrence = objectForgotPassword.forgotPassword();
        system.assert(pageRefrence == NULL);

        objectForgotPassword.userName ='enzi@test.com';
        pageRefrence = objectForgotPassword.forgotPassword();
        system.assert(pageRefrence == NULL);
    }
}