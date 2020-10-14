@isTest
public class TestInboxEmailHandler{
    static testMethod void InboxEmailHandler(){
       InboxEmailHandler objEmailHandler = new InboxEmailHandler();
       objEmailHandler.decrypt('refId');

       List<User> lstSysAdminUsers = [ SELECT Id FROM User WHERE Profile.Name ='System Administrator'  AND IsActive = true ];

       Account account = TestsObjectProvider.CreateAccount('TestAccount1');
       account.OwnerId = lstSysAdminUsers[0].Id;
       Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

       Contact contact = TestsObjectProvider.CreateContact('Portal User', 'Contact One', ResultAccount[0].Id, 'portal.user@test.com' );
       contact.Confirm_Email__c = 'portal.user@test.com';
       Database.SaveResult[] ResultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{ contact});

       User portalUser = TestsObjectProvider.CreateUser( ResultContact[0].Id, 'portal.user@test.com', 'portal.user.1', 'portal.user.1', 'portal.user@test.com', true, 'FC Community Users Profile', account.Name );
       portalUser.ProfileType__c = 'Organization';
       portalUser.UserProfile__c = 'Grantee';
       Database.SaveResult[] ResultUser = TestsObjectProvider.InsertListWithAssert(new List<User>{ portalUser });

       Opportunity opportunity = TestsObjectProvider.CreateOpportunity('testOpp', 'In Progress', Date.today());
       opportunity.AccountId = ResultAccount[0].Id;
       Database.Saveresult[] ResultOpportunity = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunity});

       List<OpportunityTeamMember> lstOppTeamMemeber = new List<OpportunityTeamMember>();
       lstOppTeamMemeber.add(TestsObjectProvider.CreateOpportunityTeamMember(ResultOpportunity[0].Id, 'Applicant', ResultUser[0].Id));
       Database.Saveresult[] ResultsOppTeamMember = TestsObjectProvider.InsertListWithAssert(lstOppTeamMemeber);

       Blob cryptoKey = Blob.valueOf('380db410e8b11fa9');
       Blob relatedToId = Blob.valueOf(ResultsOppTeamMember[0].Id);
       Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey , relatedToId);
       String encryptedRefId =  EncodingUtil.base64Encode(encryptedData);

       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();

       List<string> lstEmailId = new List<string>();
       lstEmailId.add('user@test.com');

       email.toAddresses = lstEmailId;
       email.ccAddresses = null;
       email.subject = 'test Subject';
       email.plainTextBody = 'Body: test body ref:::' + encryptedRefId + ':::';
       email.htmlBody = 'Body: test body ref:::' + encryptedRefId + ':::';
       email.fromAddress = 'portal.user@test.com';
       email.fromName = 'portal.user.1 portal.user.1';
       email.references = new List<string>{'test@test.com'};
       env.fromAddress = 'portal2.user@test.com';

       InboxEmailHandler emailHandler = new InboxEmailHandler();
       emailHandler.handleInboundEmail(email, env );

       email.fromAddress = 'portal2.user@test.com';
       email.ccAddresses = lstEmailId;
       emailHandler.handleInboundEmail(email, env );

    }
}