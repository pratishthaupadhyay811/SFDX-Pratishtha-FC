@isTest
public class SyncContactAndUsersTest
{
    @isTest
    private static void setupTestData()
    {
        List<Profile> lstCommProfiles = [ SELECT Id, Name FROM Profile WHERE ( UserLicense.Name LIKE '%Community%' OR UserLicense.Name LIKE '%Grantee%' ) AND Name LIKE '%FC%' ];
        system.assertNotEquals( lstCommProfiles.size(), 0 );

        Account portalAccount = TestsObjectProvider.CreateAccount('portalAccount');
        insert portalAccount;
        system.assertNotEquals( portalAccount.Id, null );

        Contact portalContactOne = TestsObjectProvider.CreateContact( 'one', 'lastName', portalAccount.Id, 'one.lastname@enzigma.com' );
        portalContactOne.Username__c = 'one.lastname@enzigma.com';
        insert portalContactOne;
        system.assertNotEquals( portalContactOne.Id, null );

        Contact portalContactTwo = TestsObjectProvider.CreateContact( 'two', 'lastName', portalAccount.Id, 'two.lastname@enzigma.com' );
        portalContactTwo.Username__c = 'two.lastname@enzigma.com';
        insert portalContactTwo;
        system.assertNotEquals( portalContactTwo.Id, null );

        Contact portalContactThree = TestsObjectProvider.CreateContact( 'three', 'lastName', portalAccount.Id, 'three.lastname@enzigma.com' );
        portalContactThree.Username__c = 'three.lastname@enzigma.com';
        insert portalContactThree;
        system.assertNotEquals( portalContactThree.Id, null );

        Contact portalContactFour = TestsObjectProvider.CreateContact( 'four', 'lastName', portalAccount.Id, 'four.lastname@enzigma.com' );
        portalContactFour.Username__c = 'four.lastname@enzigma.com';
        insert portalContactFour;
        system.assertNotEquals( portalContactFour.Id, null );

        Contact portalContactFive = TestsObjectProvider.CreateContact( 'five', 'lastName', portalAccount.Id, 'five.lastname@enzigma.com' );
        portalContactFive.Username__c = 'five.lastname@enzigma.com';
        insert portalContactFive;
        system.assertNotEquals( portalContactFive.Id, null );

        User userOne = TestsObjectProvider.CreateUser( portalContactOne.Id, 'four.lastname@enzigma.com', 'four', 'one', 'test1.lastname@enzigma.com', true, lstCommProfiles[0].Name , 'Enzigma Software Pvt. Ltd.' );
        insert userOne;
        system.assertNotEquals( userOne.Id, null );

        User userTwo = TestsObjectProvider.CreateUser( portalContactTwo.Id, 'three.lastname@enzigma.com', 'three', 'two', 'test2.lastname@enzigma.com', true, lstCommProfiles[0].Name , 'Enzigma Software Pvt. Ltd.' );
        insert userTwo;
        system.assertNotEquals( userTwo.Id, null );

        User userThree = TestsObjectProvider.CreateUser( portalContactThree.Id, 'two.lastname@enzigma.com', 'two', 'three', 'test3.lastname@enzigma.com', true, lstCommProfiles[0].Name , 'Enzigma Software Pvt. Ltd.' );
        insert userThree;
        system.assertNotEquals( userThree.Id, null );

        User userFour = TestsObjectProvider.CreateUser( portalContactFour.Id, 'one.lastname@enzigma.com', 'one', 'four', 'test4.lastname@enzigma.com', true, lstCommProfiles[0].Name , 'Enzigma Software Pvt. Ltd.' );
        insert userFour;
        system.assertNotEquals( userFour.Id, null );

        List<Triggers__c> lstTriggers = Triggers__c.getall().values();
        if( lstTriggers.size() <= 0 )
        {
            Triggers__c newTrigger = new Triggers__c( Name = 'Test Trigger for Contact' );
            newTrigger.OnContactUpdate__c = true;
            newTrigger.Trigger_OnUser__c = true;
            insert newTrigger;
            system.assertNotEquals( newTrigger.Id, null );
        }

        CommunityConfiguration__c commConfig = new CommunityConfiguration__c( ConfiguationName__c = 'CommunityUserFieldMapping' );
        commConfig.JsonData__c = '{"CommunityUserToContact":[' + JSON.serialize(new JSONWrapper( 'FirstName', 'FirstName'));
        commConfig.JsonData__c += ',' + JSON.serialize(new JSONWrapper( 'LastName', 'LastName'));
        commConfig.JsonData__c += ',' + JSON.serialize(new JSONWrapper( 'Email', 'Email'));
        commConfig.JsonData__c += ',' + JSON.serialize(new JSONWrapper( 'Username__c', 'Username')) + ']}';
        insert commConfig;
        system.assertNotEquals( commConfig.Id, null );

        CommunityConfiguration__c commConfig1 = new CommunityConfiguration__c( ConfiguationName__c = 'PortalUserFieldMapping' );
        commConfig1.JsonData__c = '{"PortalUserToContact":[' + JSON.serialize(new JSONWrapper( 'LastName', 'FGM_Portal__LastName__c'));
        commConfig1.JsonData__c += ',' + JSON.serialize(new JSONWrapper( 'FirstName', 'FGM_Portal__FirstName__c')) + ']}';
        insert commConfig1;
        system.assertNotEquals( commConfig1.Id, null );
    }

   static testMethod void unitTestContactAndUserUpdate()
    {
        setupTestData();

        List<Contact> lstContacts = [ SELECT FirstName, LastName, Email, Username__c FROM Contact ];

        Set<Id> setConIds = new Set<Id>();
        for( Contact contact : lstContacts )
            setConIds.add( contact.Id );
        List<User> lstUsers = [ SELECT FirstName, LastName, Email, Username, ContactId FROM User WHERE ContactId IN: setConIds ];
        List<CommunityConfiguration__c> lstCommConfig = [ SELECT ConfiguationName__c, JsonData__c FROM CommunityConfiguration__c WHERE ConfiguationName__c = 'CommunityUserFieldMapping' ];
        List<CommunityConfiguration__c> lstCommConfig1 = [ SELECT ConfiguationName__c, JsonData__c FROM CommunityConfiguration__c WHERE ConfiguationName__c = 'PortalUserFieldMapping' ];
        String username = 'test@example.com'+DateTime.now().getTime();
        User user = TestsObjectProvider.CreateUser( null, username, 'three', 'two', username, true, 'System Administrator' , 'Enzigma Software Pvt. Ltd.' );
        system.runAs(user)
        {
            update lstContacts;
            update lstUsers;

            lstCommConfig[0].JsonData__c = '{"CommunityUserToContact":[' + JSON.serialize(new JSONWrapper( 'FirstName', 'FirstName'));
            lstCommConfig[0].JsonData__c += ',' + JSON.serialize(new JSONWrapper( 'LastName', 'LastName'));
            lstCommConfig[0].JsonData__c += ',' + JSON.serialize(new JSONWrapper( 'Email', 'Email'));
            lstCommConfig[0].JsonData__c += ',,' + JSON.serialize(new JSONWrapper( 'contactid', 'contactid'));
            lstCommConfig[0].JsonData__c += ',' + JSON.serialize(new JSONWrapper( 'Username__c', 'Username')) + ']}';
            update lstCommConfig;

            update lstContacts;
            update lstUsers;

            lstCommConfig[0].JsonData__c = '{"CommunityUserToContact":[' + JSON.serialize(new JSONWrapper( 'FirstName', 'FirstName'));
            lstCommConfig[0].JsonData__c += ',' + JSON.serialize(new JSONWrapper( 'LastName', 'LastName'));
            lstCommConfig[0].JsonData__c += ',' + JSON.serialize(new JSONWrapper( 'Email', 'Email'));
            lstCommConfig[0].JsonData__c += ',' + JSON.serialize(new JSONWrapper( 'contactid', 'contactid'));
            lstCommConfig[0].JsonData__c += ',' + JSON.serialize(new JSONWrapper( 'Username__c', 'Username')) + ']}';
            update lstCommConfig;

            update lstContacts;
            update lstUsers;

            lstCommConfig[0].JsonData__c = '{"CommunityUserToContact":[' + JSON.serialize(new JSONWrapper( 'FirstName', 'FirstName'));
            lstCommConfig[0].JsonData__c += ',' + JSON.serialize(new JSONWrapper( 'LastName', 'LastName'));
            lstCommConfig[0].JsonData__c += ',' + JSON.serialize(new JSONWrapper( 'Email', 'Email'));
            lstCommConfig[0].JsonData__c += ',' + JSON.serialize(new JSONWrapper( 'Username__c', 'Username')) + ']}';
            update lstCommConfig;


            lstCommConfig1[0].JsonData__c = '{"PortalUserToContact":[' + JSON.serialize(new JSONWrapper( 'LastName', 'FGM_Portal__LastName__c'));
            lstCommConfig1[0].JsonData__c += ',' + JSON.serialize(new JSONWrapper( 'FirstName', 'FGM_Portal__FirstName__c')) + ']}';
            update lstCommConfig1;


            for( User userRec : lstUsers )
            {
                for( Contact contact : lstContacts )
                {
                    if( userRec.ContactId == contact.Id )
                    {
                        system.assertNotEquals( userRec.FirstName , contact.FirstName, 'Firstname did not sync');
                        system.assertNotEquals( userRec.LastName , contact.LastName, 'Lastname did not sync');
                        system.assertNotEquals( userRec.Email , contact.Email, 'Email did not sync');
                        system.assertNotEquals( userRec.Username , contact.Username__c, 'Username did not sync');
                    }
                }
            }

            test.startTest();
            {
                update lstContacts;
                update lstUsers;
            }
            test.stopTest();
            lstUsers = [ SELECT FirstName, LastName, Email, Username, ContactId FROM User WHERE ContactId IN: setConIds ];

            for( User userRec : lstUsers )
            {
                for( Contact contact : lstContacts )
                {
                    if( userRec.ContactId == contact.Id )
                    {
                        system.assertEquals( userRec.FirstName , contact.FirstName, 'Firstname did not sync');
                        system.assertEquals( userRec.LastName , contact.LastName, 'Lastname did not sync');
                        system.assertEquals( userRec.Email , contact.Email, 'Email did not sync');
                        system.assertEquals( userRec.Username , contact.Username__c, 'Username did not sync');
                    }
                }
            }

            List<FGM_Portal__Portal_User__c> lstPortalUsers = [SELECT Id, Name, FGM_Portal__FirstName__c, FGM_Portal__LastName__c,FGM_Portal__Contact__c FROM FGM_Portal__Portal_User__c where FGM_Portal__Contact__c IN: setConIds ];
            for( FGM_Portal__Portal_User__c userRec : lstPortalUsers )
            {
                for( Contact contact : lstContacts )
                {
                    if( userRec.FGM_Portal__Contact__c == contact.Id )
                    {
                        system.assertEquals( userRec.FGM_Portal__FirstName__c , contact.FirstName, 'Firstname did not sync');
                        system.assertEquals( userRec.FGM_Portal__LastName__c , contact.LastName, 'Lastname did not sync');
                    }
                }
            }
            Account account = TestsObjectProvider.CreateAccount('TestAccount1');
            account.OwnerId = user.Id;
            Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

            Contact contact  = TestsObjectProvider.CreateContact('testContact1', 'testContact1', ResultAccount[0].Id, 'test@test1.com');
            contact.FGM_Portal__Confirm_Email__c = 'test@test1.com';
            contact.MailingStreet='baker';
            contact.MailingCity='NY';
            contact.MailingCountry='United States';
            contact.MailingState='New York';
            Database.SaveResult[] ResultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});

            List<FGM_Portal__Portal_User__c> lstPortalUser = new List<FGM_Portal__Portal_User__c>();
            lstPortalUser.add(TestSObjectProvider.CreateFGMPortalUser(null, 'test@fc-community-developer-edition.na17.force.com', 'Portal LastName', 'test@test1.com', 'test@test1.com', 'test@osf-communities-developer-edition.na17.force.com', 'Test1234', 'Test1234', true));

            lstPortalUser[0].FGM_Portal__Contact__c = ResultContact[0].Id;
            Database.Saveresult[] ResultFGMPortalUser = TestsObjectProvider.InsertListWithAssert(lstPortalUser);

            delete contact;
        }
    }

    private class JSONWrapper
    {
        public String Name { get; set; }
        public String Value { get; set; }
        public JSONWrapper( String name, String value )
        {
            this.Name = name;
            this.Value = value;
        }
    }
}