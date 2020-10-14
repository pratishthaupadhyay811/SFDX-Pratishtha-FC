@istest
public class InstanceRefreshSchedulableTest {
    static testmethod void testInstanceRefreshSchedulable() {

        List<User> lstSysAdminUsers = [ SELECT Id FROM User WHERE Profile.Name ='System Administrator' AND IsActive = true ];

        // Accounts
        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        account.OwnerId = lstSysAdminUsers[0].Id;
        Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

        // Contacts
        Contact contact  = TestsObjectProvider.CreateContact('testContact1', 'testContact1', ResultAccount[0].Id, 'test@test1.com');
        contact.FGM_Portal__Confirm_Email__c = 'test@test1.com';
        contact.MailingStreet='baker';
        contact.MailingCity='NY';
        contact.MailingCountry='United States';
        contact.MailingState='New York';
        Database.SaveResult[] ResultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});

        Contact contact2  = TestsObjectProvider.CreateContact('Contact FN 1', 'Contact LN 1', ResultAccount[0].Id, 'test@test2.com');
        contact2.FGM_Portal__Confirm_Email__c = 'test@test1.com';
        contact2.MailingStreet='baker';
        contact2.MailingCity='NY';
        contact2.MailingCountry='United States';
        contact2.MailingState='New York';
        Database.SaveResult[] ResultContact2 = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact2});

        //communityuser
        User user1 = TestsObjectProvider.CreateUser( ResultContact[0].Id, 'test@test2.com', 'testUser2', 'testUser2', 'test1@osftest.com', true, 'Partner Community User', account.Name);
        user1.ProfileType__c = 'individual';
        user1.UserProfile__c = 'Grantee';
        Database.SaveResult[] ResultUser1 = TestsObjectProvider.InsertListWithAssert(new List<User>{user1});

        User user2 = TestsObjectProvider.CreateUser( ResultContact2[0].Id, 'test@test3.com', 'testUser3', 'testUser3', 'test3@osftest.com', true, 'Partner Community User', account.Name);
        user2.ProfileType__c = 'individual';
        user2.UserProfile__c = 'Grantee';
        Database.SaveResult[] ResultUser2 = TestsObjectProvider.InsertListWithAssert(new List<User>{user2});

        //portal user
        List<FGM_Portal__Portal_User__c> lstPortalUser = new List<FGM_Portal__Portal_User__c>();
        lstPortalUser.add(TestSObjectProvider.CreateFGMPortalUser(null, 'test@fc-community-developer-edition.na17.force.com', 'Portal LastName', 'test@test1.com', 'test@test1.com', 'test@osf-communities-developer-edition.na17.force.com', 'Test1234', 'Test1234', true));
        lstPortalUser[0].Account__c = ResultAccount[0].Id;
        lstPortalUser[0].FGM_Portal__Contact__c = ResultContact[0].Id;

        lstPortalUser.add(TestSObjectProvider.CreateFGMPortalUser(null, 'test@fc-community-developer-edition.na17.force.com', 'Portal LastName', 'test@test1.com', 'test@test1.com', 'test@osf-communities-developer-edition.na17.force.com', 'Test1234', 'Test1234', true));
        lstPortalUser[1].Account__c = ResultAccount[0].Id;
        lstPortalUser[1].FGM_Portal__Contact__c = ResultContact2[0].Id;
        Database.Saveresult[] ResultFGMPortalUser = TestsObjectProvider.InsertListWithAssert(lstPortalUser);

        Test.startTest();
        InstanceRefreshSchedulable  obj = new InstanceRefreshSchedulable();
        obj.execute(null);
        Test.stopTest();
    }
}