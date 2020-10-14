@isTest
private class TestOnContactCreated
{
    static testMethod void TestOnContactCreatedtest()
    {
        Test.startTest();
            //BEGIN: some setup items
            FGM_Portal__Triggers__c portalTrigger = new FGM_Portal__Triggers__c();
            portalTrigger.Name = 'AllTriggers';
            portalTrigger.FGM_Portal__Trigger_OnUser__c = true;
            portalTrigger.FGM_Portal__OnContactUpdate__c = true;
            insert portalTrigger;
            system.assertNotEquals(portalTrigger.Id,null);

            Contact newContact2 = new Contact();
            newContact2.FGM_Portal__Organization_Legal_Name__c = 'Test2 Org Name';
            newContact2.FirstName = 'Test2 First Name';
            newContact2.LastName = 'Test2 Last Name';
            newContact2.FGM_Portal__Username__c = 'test2@enzigma.com';
            newContact2.FGM_Portal__Type__c = 'Grantee';
            newContact2.FGM_Portal__EIN__c = 'Test1232';
            newContact2.Fax = '113123';
            newContact2.MailingStreet = 'Test2 Mailing Street';
            newContact2.MailingCity = 'Test2 Mailing City';
            newContact2.MailingState = 'Assam';
            newContact2.MailingCountry = 'India';
            newContact2.MailingPostalCode = 'Test2 Postal Code';
            newContact2.Phone = '25464165';
            Database.SaveResult resultContactinsert = Database.Insert(newContact2,false);
            system.assertNotEquals(resultContactinsert.Id,null);

            OnContactCreated.CheckDuplicateAndAssignAccount(new List<Contact>{newContact2});

        Test.stopTest();
    }
}