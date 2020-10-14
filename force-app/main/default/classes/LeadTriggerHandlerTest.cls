@isTest
public class LeadTriggerHandlerTest
{
    static testMethod void LeadTriggerHandler()
    {
        list<Triggers__c> lstTriggerSetting = Triggers__c.getAll().Values();
        if(!lstTriggerSetting.isEmpty())
        {
            lstTriggerSetting[0].name = 'Triggers';
            lstTriggerSetting[0].OnContactInsert__c = false;
            lstTriggerSetting[0].OnAccountUpdate__c = false;
            lstTriggerSetting[0].OnContactUpdate__c = false;
            upsert lstTriggerSetting;
        }
        else
        {
            lstTriggerSetting  = new list<Triggers__c>();
            Triggers__c triggerSetting = new Triggers__c();
            triggerSetting.name = 'Triggers';
            triggerSetting.OnContactInsert__c = false;
            triggerSetting.OnAccountUpdate__c = false;
            triggerSetting.OnContactUpdate__c = false;
            lstTriggerSetting.add(triggerSetting);
            insert lstTriggerSetting;
        }

        List<User> lstSysAdminUsers = [ SELECT Id FROM User WHERE Profile.Name ='System Administrator' AND IsActive = true ];
        // Accounts
        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        account.OwnerId = lstSysAdminUsers[0].Id;
        Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

        // Campaign
        Campaign campaign = TestsObjectProvider.CreateCampaign('TestCampaign', 'test@test1.com', Date.today(), Date.today(), null,'FGM_Base__Duration_Months__c:8');
        Campaign campaign2 = TestsObjectProvider.CreateCampaign('TestCampaign2', 'test@test2.com', Date.today(), Date.today(), null,'FGM_Base__Duration_Months__c:20');
        Database.Saveresult[] Resultcampaign = TestsObjectProvider.InsertListWithAssert(new List<Campaign>{campaign, campaign2});
        // Contacts
        Contact contact  = TestsObjectProvider.CreateContact('testContact', 'testContact', ResultAccount[0].Id, 'test@test.com');
        contact.FGM_Portal__Confirm_Email__c = 'test@test.com';
        Database.SaveResult[] ResultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});
        // Users
        User user1 = TestsObjectProvider.CreateUser( ResultContact[0].Id, 'test@test2.com', 'testUser2', 'testUser2', 'test1@osftest.com', true, 'Partner Community User', account.Name);
        user1.ProfileType__c = 'individual';
        user1.UserProfile__c = 'Grantee';
        Database.SaveResult[] ResultUser = TestsObjectProvider.InsertListWithAssert(new List<User>{user1});
        Lead newLead1 = new Lead();
        newLead1.Company = 'Enzigma Softwares Pvt. Ltd.';
        newLead1.LastName = 'Lead to Convert 001';
        newLead1.FGM_Base__Docket__c = Resultcampaign[0].Id;
        newLead1.FGM_Base__Submitted_By__c = ResultContact[0].Id;
        newLead1.OwnerID = ResultUser[0].id;
        newLead1.Status = 'In Progress';
        insert newLead1;

        Lead newLead3 = new Lead();
        newLead3.Company = 'Enzigma Softwares Pvt. Ltd.';
        newLead3.LastName = 'Lead to Convert 003';
        newLead3.FGM_Base__Docket__c = Resultcampaign[0].Id;
        newLead3.FGM_Base__Submitted_By__c = ResultContact[0].Id;
        newLead3.OwnerID = ResultUser[0].id;
        newLead3.Status = 'In Progress';
        insert newLead3;

        FGM_Portal__Portal_Permission__c portalPermissionForLead = new FGM_Portal__Portal_Permission__c();
        portalPermissionForLead.FGM_Portal__Lead__c = newLead3.Id;
        insert portalPermissionForLead;

        System.runAs(lstSysAdminUsers[0])
        {
            //Creates new campaign memeber
            CampaignMember newMember =  new CampaignMember();
            newMember.CampaignID = Resultcampaign[0].Id;
            newMember.ContactID = ResultContact[0].Id;
            insert newMember;

            CampaignMember newMember1 =  new CampaignMember();
            newMember1.CampaignID = Resultcampaign[1].Id;
            newMember1.ContactID = ResultContact[0].Id;
            insert newMember1;
        }
        Lead newLead2 = new Lead();
        newLead2.Company = 'Enzigma Softwares Pvt. Ltd.';
        newLead2.LastName = 'Lead to Convert 002';
        newLead2.FGM_Base__Docket__c = Resultcampaign[0].Id;
        newLead2.FGM_Base__Submitted_By__c = ResultContact[0].Id;
        newLead2.OwnerID = ResultUser[0].id;
        newLead2.Status = 'In Progress';
        insert newLead2;

        list<Lead> lstNewLead  = [SELECT ID FROM LEAD WHERE LastName = 'Lead to Convert 001'];
        Database.LeadConvert leadConverted1 = new Database.LeadConvert();
        leadConverted1.setLeadId(lstNewLead[0].id);
        list<Lead> lstNewLead3  = [SELECT ID FROM LEAD WHERE LastName = 'Lead to Convert 003'];
        Database.LeadConvert leadConverted3 = new Database.LeadConvert();
        leadConverted1.setLeadId(lstNewLead3[0].id);
        LeadStatus convertStatus1 = [Select Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        leadConverted1.setConvertedStatus(convertStatus1.MasterLabel);
        Database.LeadConvertResult leadConvertedResult1 = Database.convertLead(leadConverted1);
        System.assert(leadConvertedResult1.isSuccess());
    }
    static testMethod void leadConvertWithGPS()
    {
        list<Triggers__c> lstTriggerSetting = Triggers__c.getAll().Values();
        if(!lstTriggerSetting.isEmpty())
        {
            lstTriggerSetting[0].name = 'Triggers';
            lstTriggerSetting[0].OnContactInsert__c = false;
            lstTriggerSetting[0].OnAccountUpdate__c = false;
            lstTriggerSetting[0].OnContactUpdate__c = false;
            upsert lstTriggerSetting;
        }
        else
        {
            lstTriggerSetting  = new list<Triggers__c>();
            Triggers__c triggerSetting = new Triggers__c();
            triggerSetting.name = 'Triggers';
            triggerSetting.OnContactInsert__c = false;
            triggerSetting.OnAccountUpdate__c = false;
            triggerSetting.OnContactUpdate__c = false;
            lstTriggerSetting.add(triggerSetting);
            insert lstTriggerSetting;
        }
        List<User> lstSysAdminUsers = [ SELECT Id FROM User WHERE Profile.Name ='System Administrator' AND IsActive = true ];
        // Accounts
        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        account.OwnerId = lstSysAdminUsers[0].Id;
        Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});
        // Campaign
        Campaign campaign = TestsObjectProvider.CreateCampaign('TestCampaign', 'test@test1.com', Date.today(), Date.today(), null,'FGM_Base__Duration_Months__c:8');
        Campaign campaign2 = TestsObjectProvider.CreateCampaign('TestCampaign2', 'test@test2.com', Date.today(), Date.today(), null,'FGM_Base__Duration_Months__c:20');
        Database.Saveresult[] Resultcampaign = TestsObjectProvider.InsertListWithAssert(new List<Campaign>{campaign, campaign2});
        // Contacts
        Contact contact  = TestsObjectProvider.CreateContact('testContact', 'testContact', ResultAccount[0].Id, 'test@test.com');
        contact.FGM_Portal__Confirm_Email__c = 'test@test.com';
        Database.SaveResult[] ResultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});
        // Users
        User user1 = TestsObjectProvider.CreateUser( ResultContact[0].Id, 'test@test2.com', 'testUser2', 'testUser2', 'test1@osftest.com', true, 'Partner Community User', account.Name);
        user1.ProfileType__c = 'individual';
        user1.UserProfile__c = 'Grantee';
        Database.SaveResult[] ResultUser = TestsObjectProvider.InsertListWithAssert(new List<User>{user1});
        Lead newLead1 = new Lead();
        newLead1.Company = 'Enzigma Softwares Pvt. Ltd.';
        newLead1.LastName = 'Lead to Convert 001';
        newLead1.FGM_Base__Docket__c = Resultcampaign[0].Id;
        newLead1.FGM_Base__Submitted_By__c = ResultContact[0].Id;
        newLead1.OwnerID = ResultUser[0].id;
        newLead1.Status = 'In Progress';
        insert newLead1;

        Lead newLead3 = new Lead();
        newLead3.Company = 'Enzigma Softwares Pvt. Ltd.';
        newLead3.LastName = 'Lead to Convert 003';
        newLead3.FGM_Base__Docket__c = Resultcampaign[0].Id;
        newLead3.FGM_Base__Submitted_By__c = ResultContact[0].Id;
        newLead3.OwnerID = ResultUser[0].id;
        newLead3.Status = 'In Progress';
        insert newLead3;

        FGM_Portal__Portal_Permission__c portalPermissionForLead = new FGM_Portal__Portal_Permission__c();
        portalPermissionForLead.FGM_Portal__Lead__c = newLead3.Id;
        insert portalPermissionForLead;

        System.runAs(lstSysAdminUsers[0])
        {
            //Creates new campaign memeber
            CampaignMember newMember =  new CampaignMember();
            newMember.CampaignID = Resultcampaign[0].Id;
            newMember.ContactID = ResultContact[0].Id;
            insert newMember;

            CampaignMember newMember1 =  new CampaignMember();
            newMember1.CampaignID = Resultcampaign[1].Id;
            newMember1.ContactID = ResultContact[0].Id;
            insert newMember1;
        }
        Lead newLead2 = new Lead();
            newLead2.Company = 'Enzigma Softwares Pvt. Ltd.';
            newLead2.LastName = 'Lead to Convert 002';
            newLead2.FGM_Base__Docket__c = Resultcampaign[0].Id;
            newLead2.FGM_Base__Submitted_By__c = ResultContact[0].Id;
            newLead2.OwnerID = ResultUser[0].id;
            newLead2.Status = 'In Progress';
            insert newLead2;
        FGM_Portal__GlobalPortalSettings__c globalPortalSettings = GlobalPortalSettings__c.getInstance();
            globalPortalSettings.FGM_Portal__Request_Campaign_Field_Name__c = 'Test_Request_Campaign_Field__c';
            globalPortalSettings.FGM_Portal__LOI_Campaign_Field_Name__c  = 'FGM_Base__Docket__c';
            globalPortalSettings.FGM_Portal__Grantee_Portal_Prefix__c = 'fcgrantee';
            globalPortalSettings.FGM_Portal__Reviewer_Portal_Prefix__c = 'grantee';
            upsert globalPortalSettings;
        list<Lead> lstNewLead2  = [SELECT ID FROM LEAD WHERE LastName = 'Lead to Convert 002'];
        Database.LeadConvert leadConverted1 = new Database.LeadConvert();
        leadConverted1.setLeadId(lstNewLead2[0].id);
        LeadStatus convertStatus1 = [Select Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        leadConverted1.setConvertedStatus(convertStatus1.MasterLabel);
        Database.LeadConvertResult leadConvertedResult1 = Database.convertLead(leadConverted1);
        System.assert(leadConvertedResult1.isSuccess());

    }


}