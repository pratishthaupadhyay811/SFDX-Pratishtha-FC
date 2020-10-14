@isTest
private class TestTriggerOnPortalApplication{
    static testMethod void OnPortalApplication(){
        List<User> lstSysAdminUsers = [ SELECT Id
                                        FROM User
                                        WHERE Profile.Name ='System Administrator'
                                        AND IsActive = true
                                      ];

        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        account.OwnerId = lstSysAdminUsers[0].Id;
        account.FGM_Base__EIN__c = '2345';
        Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

        Contact contact = TestsObjectProvider.CreateContact('testContact1', 'testContact1', ResultAccount[0].Id, 'test@test1.com');
        Database.SaveResult[] ResultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});

        List<FGM_Portal__Portal_User__c> lstPortalUser = new List<FGM_Portal__Portal_User__c>();
        lstPortalUser.add(TestSObjectProvider.CreateFGMPortalUser(null, 'TestAccount1', 'Portal LastName', 'test@test1.com', 'test@test1.com', 'testuser@osf-communities-developer-edition.na17.force.com', 'Test1234', 'Test1234', true));
        lstPortalUser[0].IsCreatedByOpportunityTeamMember__c = true;
        lstPortalUser[0].FGM_Portal__EIN__c = account.FGM_Base__EIN__c;
        lstPortalUser[0].Account__c = ResultAccount[0].Id;
        lstPortalUser[0].Contact__c = ResultContact[0].Id;
        lstPortalUser.add(TestSObjectProvider.CreateFGMPortalUser(null, 'TestAccount2', 'Portal LastName', 'test@test2.com', 'test@test2.com', 'testuser@osf-communities-developer-edition.na17.force.com', 'Test1234', 'Test1234', true));
        lstPortalUser[1].IsCreatedByOpportunityTeamMember__c = true;
        lstPortalUser[1].FGM_Portal__EIN__c = account.FGM_Base__EIN__c;
        lstPortalUser[1].Account__c = ResultAccount[0].Id;
        lstPortalUser[1].Contact__c = null;
        Database.Saveresult[] ResultFGMPortalUser = TestsObjectProvider.InsertListWithAssert(lstPortalUser);

        FGM_Portal__Triggers__c FGMPortalTriggersToDelete = TestsObjectProvider.CreateFGMPortalTriggers();
        Database.Saveresult[] ResultFGMPortalTriggersToDelete = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Triggers__c>{FGMPortalTriggersToDelete});

        Database.Deleteresult[] DeleteFGMPortalTriggers = TestsObjectProvider.DeleteListWithAssert(new List<FGM_Portal__Triggers__c>{FGMPortalTriggersToDelete});

        FGM_Portal__Triggers__c FGMPortalTriggers = TestsObjectProvider.CreateFGMPortalTriggers();
        Database.Saveresult[] ResultFGMPortalTriggers = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Triggers__c>{FGMPortalTriggers});

        Map<Id,FGM_Portal__Portal_User__c> mapPortaluser = new Map<Id,FGM_Portal__Portal_User__c>();
        mapPortaluser.put(ResultFGMPortalUser[0].Id,lstPortalUser[0]);

        lstPortalUser[0].FGM_Portal__Contact__c = ResultContact[0].Id;
        ResultFGMPortalUser = TestsObjectProvider.UpdateListWithAssert(lstPortalUser);

        FGM_Portal__Quiz__c FGMPortalQuizDelete = TestsObjectProvider.CreateFGMPortalQuiz('PortalQuiz1', 'TestAccount1', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
        FGMPortalQuizDelete.FGM_Portal__IsCommunityRecord__c = true;
        Database.Saveresult[] ResultFGMPortalQuizDelete = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{FGMPortalQuizDelete});

        Database.Deleteresult[] DeleteFGMPortalQuiz = TestsObjectProvider.DeleteListWithAssert(new List<FGM_Portal__Quiz__c>{FGMPortalQuizDelete});

        FGM_Portal__Quiz__c FGMPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz('PortalQuiz1', 'TestAccount1', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
        FGMPortalQuiz.FGM_Portal__IsCommunityRecord__c = true;
        Database.Saveresult[] ResultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{FGMPortalQuiz});

        Map<String,Schema.Recordtypeinfo> newPortalQuestionRecordTypeMapByName = FGM_Portal__Questions__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        FGM_Portal__Questions__c FGMPortalQuestion = TestsObjectProvider.CreateFGMPortalQuestion('Amount', '', '', '', 'Attachment', ResultFGMPortalQuiz[0].Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId());
        Database.Saveresult[] ResultFGMPortalQuestion = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Questions__c>{FGMPortalQuestion});

        Opportunity newOpportunity = TestsObjectProvider.CreateOpportunity('TestOppTriggerPortal1', 'In Progress', Date.today());
        Database.Saveresult[] ResultOpportunity = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{newOpportunity});

        List<Opportunity> newOpp = new List<Opportunity>();
        newOpp.add(TestsObjectProvider.CreateOpportunity('TestOppTriggerPortal1', 'In Progress', Date.today()));
        newOpp.add(TestsObjectProvider.CreateOpportunity('TestOppTriggerPortal2', 'Removed', Date.today()));
        Database.Saveresult[] resultListOpp = TestsObjectProvider.InsertListWithAssert(newOpp);


        FGM_Portal__PortalUserRequestTeamMembers__c PortalUserRequestTeamMembers = TestsObjectProvider.CreatePortalUserRequestTeamMembers('Read/Write', false, ResultFGMPortalUser[0].Id, ResultOpportunity[0].Id , 'owner');
        PortalUserRequestTeamMembers.FGM_Portal__IsShared__c = false;
        Database.SaveResult[] ResultPortalUserRequestTeamMembers = TestsObjectProvider.InsertListWithAssert(new List<PortalUserRequestTeamMembers__c>{PortalUserRequestTeamMembers});

        Map<Id,Opportunity> mapOpportunity = new Map<Id,Opportunity>();
        mapOpportunity.put(ResultOpportunity[0].Id,newOpportunity);

        Opportunity newOpportunityDelete = TestsObjectProvider.CreateOpportunity('TestOppTriggerPortal1', 'In Progress', Date.today());
        Database.Saveresult[] ResultOpportunityDelete = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{newOpportunityDelete});

        Database.Deleteresult[] DeleteOpportunity = TestsObjectProvider.DeleteListWithAssert(new List<Opportunity>{newOpportunityDelete});

        Question_Attachment__c QuestionAttachment = TestsObjectProvider.CreateQuestionAttachment(ResultFGMPortalQuestion[0].Id, ResultOpportunity[0].Id, null, null);
        Database.Saveresult[] ResultQuestionAttachment = TestsObjectProvider.InsertListWithAssert(new List<Question_Attachment__c>{QuestionAttachment});

        Lead newLeadDelete = TestsObjectProvider.CreateLead('Test Lead Trigger First', 'Test Lead Trigger Last', 'strCompany', 'Open - Not Contacted');
        Database.Saveresult[] ResultLead = TestsObjectProvider.InsertListWithAssert(new List<Lead>{newLeadDelete});

        Database.Deleteresult[] DeleteResultLead = TestsObjectProvider.DeleteListWithAssert(new List<Lead>{newLeadDelete});

        Lead newLead = TestsObjectProvider.CreateLead('Test Lead Trigger First', 'Test Lead Trigger Last', 'strCompany', 'Open - Not Contacted');
        ResultLead = TestsObjectProvider.InsertListWithAssert(new List<Lead>{newLead});

        Map<String,Schema.Recordtypeinfo> newGranteeReportRecordTypeMapByName = FGM_Base__Grantee_Report__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        FGM_Base__Grantee_Report__c FGMBaseGranteeReportDelete = TestsObjectProvider.CreateFGMBaseGranteeReport(null, ResultOpportunity[0].Id, 'Received');
        Database.Saveresult[] ResultFGMBaseGranteeReport = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Grantee_Report__c>{FGMBaseGranteeReportDelete});

        Database.Deleteresult[] ResultFGMBaseGranteeReportDelete = TestsObjectProvider.DeleteListWithAssert(new List<FGM_Base__Grantee_Report__c>{FGMBaseGranteeReportDelete});

        FGM_Base__Grantee_Report__c FGMBaseGranteeReport = TestsObjectProvider.CreateFGMBaseGranteeReport(null, ResultOpportunity[0].Id, 'Received');
        ResultFGMBaseGranteeReport = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Grantee_Report__c>{FGMBaseGranteeReport});

        List<Question_Attachment__c> lstQuestionAttachmentLead = new List<Question_Attachment__c>();
        lstQuestionAttachmentLead.add(TestsObjectProvider.CreateQuestionAttachment(ResultFGMPortalQuestion[0].Id, null, ResultLead[0].Id, ResultFGMBaseGranteeReport[0].Id));
        lstQuestionAttachmentLead.add(TestsObjectProvider.CreateQuestionAttachment(ResultFGMPortalQuestion[0].Id, null, null, ResultFGMBaseGranteeReport[0].Id));
        Database.Saveresult[] ResultsQuestionAttachmentLead = TestsObjectProvider.InsertListWithAssert(lstQuestionAttachmentLead);

        Map<String,Schema.Recordtypeinfo> newRelatedListRecordTypeMapByName = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        List<FGM_Portal__Related_List_Controller__c> lstFGMPortalRelatedListController = new List<FGM_Portal__Related_List_Controller__c>();
        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListName', 'Grantee', 'Details', 'FGM_Base__Grantee_Report__c', 'FGM_Base__Grantee_Report__c', 'FGM_Base__Grantee_Report__c', 'Name', 'Name', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortalRelatedListController[0].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListName1', 'Reviewer', 'Details', 'Amendment__c', 'Opportunity', 'ParentRequest__c', 'Field To Be Edited', 'Field_To_Be_Edited__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortalRelatedListController[1].FGM_Portal__IsCommunityRecord__c = true;
        Database.Saveresult[] ResultsFGMPortalRelatedListController = TestsObjectProvider.InsertListWithAssert(lstFGMPortalRelatedListController);

        List<FGM_Portal__Quiz_Questions__c> lstFGMPortalQuizQuestion = new List<FGM_Portal__Quiz_Questions__c>();
        lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(ResultFGMPortalQuestion[0].Id, 1, 'FGM_Base__Comment__c', '', 50, '1', ResultsFGMPortalRelatedListController[0].Id, true, ResultFGMPortalQuiz[0].Id));
        lstFGMPortalQuizQuestion[0].FGM_Portal__IsCommunityRecord__c = true;
        Database.Saveresult[] ResultsFGMPortalQuizQuestion = TestsObjectProvider.InsertListWithAssert(lstFGMPortalQuizQuestion);

        User user1 = TestsObjectProvider.CreateUser( ResultContact[0].Id, 'test@test1.com', 'testUser2', 'testUser2', 'testuser@osf-communities-developer-edition.na17.force.com', true, 'Partner Community User', account.Name);
        Database.SaveResult[] ResultUser1 = TestsObjectProvider.InsertListWithAssert(new List<User>{user1});

        List<Secure_Message__c> lstSecureMsg = new List<Secure_Message__c>();
        lstSecureMsg.add(TestsObjectProvider.CreateSecureMessage('TestBody', ResultOpportunity[0].Id, ResultUser1[0].Id, lstSysAdminUsers[0].Id, 'Test Mail', '1234'));
        Database.Saveresult[] ResultslstSecureMsg = TestsObjectProvider.InsertListWithAssert(lstSecureMsg);

        //new Custom Setting starts here
        Profile prof = [SELECT Id FROM Profile WHERE name='System Administrator'];
        FGM_Portal__GlobalPortalSettings__c newGlobalSettings = new FGM_Portal__GlobalPortalSettings__c();
        newGlobalSettings.FGM_Portal__Application_Ownership_Role__c = 'owner';
        newGlobalSettings.FGM_Portal__Enable_Attachments_for_Submitted_Appl__c = false;
        newGlobalSettings.FGM_Portal__StatusofwithdrawConsultantAccess__c = 'closed won;In Progress';
        newGlobalSettings.FGM_Portal__GranteeSiteContactID__c = null;
        newGlobalSettings.FGM_Portal__GranteeCommunityProfileID__c =  prof.Id;
        newGlobalSettings.FGM_Portal__Grantee_Portal_Prefix__c = 'fcgrantee';
        newGlobalSettings.FGM_Portal__Reviewer_Portal_Prefix__c = 'grantee';
        Database.SaveResult saveResult = Database.insert(newGlobalSettings);

        // Ends here

        //Test For Grantee Budget
        FGM_Portal__Grantee_Budget_Category__c categoryAdmin = TestsObjectProvider.CreateGranteeBudgetCategory('Admin');
        categoryAdmin.FGM_Portal__Parent_Category__c = null;
        categoryAdmin.FGM_Portal__IsActive__c = true;
        insert categoryAdmin;
        System.assert(categoryAdmin.Id != null);

        FGM_Portal__Grantee_Budget_Category__c categoryDeveloper = TestsObjectProvider.CreateGranteeBudgetCategory('Developer');
        categoryDeveloper.FGM_Portal__Parent_Category__c = null;
        categoryDeveloper.FGM_Portal__IsActive__c = true;
        insert categoryDeveloper;
        System.assert(categoryDeveloper.Id != null);

        Grantee_Budget_Configuration__c configuration = new Grantee_Budget_Configuration__c() ;
        configuration.FGM_Portal__Quiz__c = ResultFGMPortalQuiz[0].Id;
        configuration.FGM_Portal__Category__c = categoryAdmin.Id;
        insert configuration;
        System.assert(configuration.Id != null);

        FGM_Portal__Grantee_Budget__c budget = new FGM_Portal__Grantee_Budget__c();
        budget.name = '2015';
        insert budget;
        System.assert(budget.Id != null);

        FGM_Portal__Grantee_Budget_Line_Item__c lineItem = new FGM_Portal__Grantee_Budget_Line_Item__c();
        lineItem.FGM_Portal__Budget_Configuration__c = configuration.Id;
        lineItem.FGM_Portal__Grantee_Budget__c = budget.Id;
        lineItem.FGM_Portal__Opportunity__c = ResultOpportunity[0].Id;
        lineItem.FGM_Portal__Category__c = categoryAdmin.Id;
        insert lineItem;
        System.assert(budget.Id != null);

        configuration.FGM_Portal__Category__c = categoryDeveloper.Id;
        try{
            update configuration;
        }catch (DmlException e) {
            //Assert Status Code
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , e.getDmlStatusCode(0) );
        }
        try{
            delete configuration;
        }catch (DmlException e) {
            //Assert Status Code
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , e.getDmlStatusCode(0) );
        }

        try{
            delete categoryAdmin;
        }catch (DmlException e) {
            //Assert Status Code
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , e.getDmlStatusCode(0) );
        }
        OnPortalApplication.createOppotunityTeamMember(lstPortalUser, mapPortaluser,new List<User>{user1});
        OnPortalApplication.changeOwnerFromConsultant(mapOpportunity);
        OnPortalApplication.getQuestionAttachmentForDelete(newOpp);
        OnPortalApplication.questionAttachmentForDeleteBeforeLead(new List<Lead> { newLead });
        OnPortalApplication.questionAttachmentForDeleteBeforeGranteeReport(new List<FGM_Base__Grantee_Report__c> { FGMBaseGranteeReport });
        OnPortalApplication.getRLCTabForDelete(lstFGMPortalRelatedListController);
        OnPortalApplication.getQuizQuestionForDelete(lstFGMPortalQuizQuestion);
        OnPortalApplication.getSecureMessageBeforeInsert(lstSecureMsg);
        OnPortalApplication.assignExistingAccount(lstPortalUser);
        OnPortalApplication.deleteTabs(new List<FGM_Portal__Quiz__c> { FGMPortalQuiz } );
        OnPortalApplication.deleteQuizQuestion(lstFGMPortalRelatedListController);
        FGM_Portal__Portal_User__c portalUser = [SELECT Id
                                                 , Account__c
                                                 , Approval_Status__c
                                                 , FGM_Portal__Contact__c
                                                 , FGM_Portal__Email__c
                                                 FROM FGM_Portal__Portal_User__c
                                                 LIMIT 1];

        List<User> portalUserRecord = [SELECT Id ,AccountId
                                       From User
                                       Where ContactId =:portalUser.FGM_Portal__Contact__c
                                       AND AccountId =: portalUser.FGM_Portal__Account__c
                                       AND Email =: portalUser.FGM_Portal__Email__c];

        List<FGM_Portal__PortalUserRequestTeamMembers__c> lstPortalUserRequestTeamMembers = [ SELECT Id,FGM_Portal__SharedRequest__c,FGM_Portal__UserRole__c
                                                                                             FROM FGM_Portal__PortalUserRequestTeamMembers__c
                                                                                             ];

          List<OpportunityTeamMember> lstOpportunityMembers = new List<OpportunityTeamMember>();
        if(lstPortalUserRequestTeamMembers != null && lstPortalUserRequestTeamMembers.size() > 0){

            OpportunityTeamMember newOpportunityTeamMembers = new OpportunityTeamMember();
            newOpportunityTeamMembers.OpportunityId = lstPortalUserRequestTeamMembers[0].SharedRequest__c;
            newOpportunityTeamMembers.UserId = portalUserRecord [0].Id;
            newOpportunityTeamMembers.TeamMemberRole = lstPortalUserRequestTeamMembers[0].UserRole__c;
            lstPortalUserRequestTeamMembers[0].IsShared__c = true;
            lstOpportunityMembers.add(newOpportunityTeamMembers);
            Database.insert(lstOpportunityMembers);
            system.assert(newOpportunityTeamMembers.Id != null);
            Database.DeleteResult saverslt = Database.delete(newOpportunityTeamMembers);


        }


        OnPortalApplication.removeContactRoles(lstOpportunityMembers);
        FGM_Portal__PortalUserRequestTeamMembers__c objePUer = new FGM_Portal__PortalUserRequestTeamMembers__c();


        OnPortalApplication.getQuestionAttachmentForDelete(newOpp);

        List<String> str = new List<String>();
        str.add('Test');
        str.add('Test12');
        str.add('Test123');
        Engine.listToString(str,true);

        List<Id> str1 = new List<Id>();
        str1.add(budget.Id);
        Engine.listToString(str1,true);
        Engine.getCampaignLookupField('Opportunity');
        map<id,Opportunity> mapOppToUpdate = new map<id,Opportunity>([Select id From opportunity where Name = 'TestOppTriggerPortal1']);
        OnPortalApplication.changeOwnerFromConsultant(mapOppToUpdate);
    }
}