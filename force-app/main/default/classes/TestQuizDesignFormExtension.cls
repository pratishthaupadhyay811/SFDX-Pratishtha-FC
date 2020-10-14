@isTest
private class TestQuizDesignFormExtension{
    @TestSetup
    static void testSetup(){
    //added as an attempt to break this out and maybe use a test factory
        List<User> lstSysAdminUsers = [ SELECT Id
                                        FROM User
                                        WHERE Profile.Name ='System Administrator'
                                        AND IsActive = true
                                      ];
        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        account.OwnerId = lstSysAdminUsers[0].Id;
        Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

        Contact contact = TestsObjectProvider.CreateContact('testContact1', 'testContact1', ResultAccount[0].Id, 'test@test1.com');
        Database.SaveResult[] ResultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});

        List<FGM_Portal__Portal_User__c> lstPortalUser = new List<FGM_Portal__Portal_User__c>();
        lstPortalUser.add(TestSObjectProvider.CreateFGMPortalUser(null, 'test@fc-community-developer-edition.na17.force.com', 'Portal LastName', 'test@test1.com', 'test@test1.com', 'test@osf-communities-developer-edition.na17.force.com', 'Test1234', 'Test1234', true));
        lstPortalUser[0].Account__c = account.Id;
        Database.Saveresult[] ResultFGMPortalUser = TestsObjectProvider.InsertListWithAssert(lstPortalUser);

        Map<String,Schema.Recordtypeinfo> newPortalQuizRecordTypeMapByName = FGM_Portal__Quiz__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        FGM_Portal__Quiz__c FGMPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz('PortalQuiz1', 'test@test1.com', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
        FGMPortalQuiz.FGM_Portal__IsCommunityRecord__c = true;
        FGMPortalQuiz.FGM_Portal__Failure_URL__c = '~/apex/CommunitySignupRejected';
        FGMPortalQuiz.RecordTypeId = newPortalQuizRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUIZ_APPLICATION).getRecordTypeId();

         FGM_Portal__Quiz__c FGMPortalQuiz2 = TestsObjectProvider.CreateFGMPortalQuiz('PortalQuiz2', 'test@test1.com', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
        FGMPortalQuiz2.FGM_Portal__IsCommunityRecord__c = true;
        FGMPortalQuiz2.FGM_Portal__Failure_URL__c = '~/apex/CommunitySignupRejected';
        FGMPortalQuiz2.RecordTypeId = newPortalQuizRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUIZ_APPLICATION).getRecordTypeId();
        Database.Saveresult[] ResultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{FGMPortalQuiz,FGMPortalQuiz2});

        Map<String,Schema.Recordtypeinfo> newRelatedListRecordTypeMapByName = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        FGM_Portal__Related_List_Controller__c FGMPortalRelatedListController = TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListNameParent', 'Grantee', 'Dashboard', 'Opportunity', 'Opportunity', 'Opportunity', 'Name,Stage,LastModfied Date', 'Name,StageName,LastModifiedDate', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id);
        FGMPortalRelatedListController.Language__c = 'en_US';
        FGMPortalRelatedListController.FGM_Portal__IsCommunityRecord__c = true;
        FGM_Portal__Related_List_Controller__c FGMPortalRelatedListController2 = TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListName', 'Grantee', 'Dashboard', 'Opportunity', 'Opportunity', 'Opportunity', 'Name,Stage,LastModfied Date', 'Name,StageName,LastModifiedDate', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id);
        FGMPortalRelatedListController2.Language__c = 'en_US';
        FGMPortalRelatedListController2.FGM_Portal__IsCommunityRecord__c = true;
        Database.Saveresult[] ResultFGMPortalRelatedListController = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Related_List_Controller__c>{FGMPortalRelatedListController , FGMPortalRelatedListController2});

        Map<String,Schema.Recordtypeinfo> newRelatedListRecordTypeMapByName1 = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        FGM_Portal__Related_List_Controller__c FGMPortalRelatedListController1 = TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListNameParent2', 'Grantee', 'Dashboard', 'Opportunity', 'Opportunity', 'Opportunity', 'Name,Stage,LastModfied Date', 'Name,StageName,LastModifiedDate', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id);
        FGMPortalRelatedListController1.Language__c = 'en_US';
        FGMPortalRelatedListController1.FGM_Portal__IsCommunityRecord__c = true;
        Database.Saveresult[] ResultFGMPortalRelatedListController1 = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Related_List_Controller__c>{FGMPortalRelatedListController1});


        List<FGM_Portal__Related_List_Controller__c> lstFGMPortalRelatedListController = new List<FGM_Portal__Related_List_Controller__c>();
        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListName', 'Grantee', 'Dashboard', 'Opportunity', 'Opportunity', 'Opportunity', 'Name,Stage,LastModfied Date', 'Name,StageName,LastModifiedDate', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortalRelatedListController[0].Language__c = 'en_US';
        lstFGMPortalRelatedListController[0].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalRelatedListController[0].Parent_RLCTabID__c = ResultFGMPortalRelatedListController[0].Id;
        lstFGMPortalRelatedListController[0].ObjectName__c = 'Opportunity';

        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListName1', 'Reviewer', 'Details', 'Amendment__c', 'Quiz__c', 'Bank_Account__c', 'Field To Be Edited', 'Field_To_Be_Edited__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_GRANTEEBUDGETTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortalRelatedListController[1].Language__c = 'en_US';
        lstFGMPortalRelatedListController[1].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalRelatedListController[1].ObjectName__c = 'Amendment__c';

        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('Test Budget', 'grantee', 'Details', 'FGM_Portal__Grantee_Budget__c', 'Opportunity', 'FGM_Portal__Grantee_Budget__c', 'Field To Be Edited', 'Field_To_Be_Edited__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_GRANTEEBUDGETTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortalRelatedListController[2].Language__c = 'en_US';
        lstFGMPortalRelatedListController[2].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalRelatedListController[2].ObjectName__c = 'FGM_Portal__Grantee_Budget__c';

        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('Benchmark Update', 'Grantee', 'Details', 'FGM_Base__Benchmark_Update__c', 'FGM_Base__Grantee_Report__c', 'FGM_Base__Grantee_Report__c', 'Amount Update', 'FGM_Base__Amount_Update__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_GRANTEEBUDGETUPDATETAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));//PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB
        lstFGMPortalRelatedListController[3].Language__c = 'en_US';
        lstFGMPortalRelatedListController[3].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalRelatedListController[3].ObjectName__c = 'FGM_Base__Benchmark_Update__c';

        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('Benchmark Update', 'Grantee', 'Details', 'FGM_Base__Benchmark_Update__c', 'FGM_Base__Grantee_Report__c', 'FGM_Base__Grantee_Report__c', 'Amount Update', 'FGM_Base__Amount_Update__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_GRANTEEBUDGETUPDATETAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortalRelatedListController[4].Language__c = 'en_US';
        lstFGMPortalRelatedListController[4].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalRelatedListController[4].ObjectName__c = 'FGM_Base__Benchmark_Update__c';

        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('Benchmark Update', 'Grantee', 'Details', 'FGM_Base__Benchmark_Update__c', 'FGM_Base__Grantee_Report__c', 'FGM_Base__Grantee_Report__c', 'Amount Update', 'FGM_Base__Amount_Update__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_CONTACTTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortalRelatedListController[5].Language__c = 'en_US';
        lstFGMPortalRelatedListController[5].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalRelatedListController[5].ObjectName__c = 'FGM_Base__Benchmark_Update__c';

        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('Benchmark Update', 'Grantee', 'Details', 'FGM_Base__Benchmark_Update__c', 'FGM_Base__Grantee_Report__c', 'FGM_Base__Grantee_Report__c', 'Amount Update', 'FGM_Base__Amount_Update__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_ORGANIZATIONTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortalRelatedListController[6].Language__c = 'en_US';
        lstFGMPortalRelatedListController[6].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalRelatedListController[6].ObjectName__c = 'FGM_Base__Benchmark_Update__c';

        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('Benchmark Update', 'Grantee', 'Details', '', null, 'FGM_Base__Grantee_Report__c', 'Amount Update', 'FGM_Base__Amount_Update__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_ORGANIZATIONTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortalRelatedListController[7].Language__c = 'en_US';
        lstFGMPortalRelatedListController[7].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalRelatedListController[7].ObjectName__c = 'FGM_Base__Benchmark_Update__c';

        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('portal Update', 'Grantee', 'Details', '', 'sObject', 'FGM_Base__Grantee_Report__c', 'Amount Update', 'FGM_Base__Amount_Update__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_ORGANIZATIONTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortalRelatedListController[8].Language__c = 'en_US';
        lstFGMPortalRelatedListController[8].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalRelatedListController[8].ObjectName__c = 'FGM_Base__Benchmark_Update__c';

        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('portal Update', 'Grantee', 'Details', '', 'sObject', 'FGM_Base__Grantee_Report__c', 'Amount Update', 'FGM_Base__Amount_Update__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_ORGANIZATIONTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortalRelatedListController[9].Language__c = '';
        lstFGMPortalRelatedListController[9].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalRelatedListController[9].ObjectName__c = 'FGM_Base__Benchmark_Update__c';


        Database.Saveresult[] ResultsFGMPortalRelatedListController = TestsObjectProvider.InsertListWithAssert(lstFGMPortalRelatedListController);

        // Create FGM_Portal__Grantee_Budget_Category__c test data

        FGM_Portal__Grantee_Budget_Category__c categoryAdmin = TestsObjectProvider.CreateGranteeBudgetCategory('Admin');
        categoryAdmin.FGM_Portal__Parent_Category__c = null;
        insert categoryAdmin;
        System.assert(categoryAdmin.Id != null);

        FGM_Portal__Grantee_Budget_Category__c categorySystem = TestsObjectProvider.CreateGranteeBudgetCategory('System Admin');
        categorySystem.FGM_Portal__Parent_Category__c = categoryAdmin.Id;
        insert categorySystem;
        System.assert(categorySystem.Id != null);

        FGM_Portal__Grantee_Budget_Category__c categoryNetwork = TestsObjectProvider.CreateGranteeBudgetCategory('Network Admin');
        categoryNetwork.FGM_Portal__Parent_Category__c = categoryAdmin.Id;
        insert categoryNetwork;
        System.assert(categoryNetwork.Id != null);

        FGM_Portal__Grantee_Budget_Category__c categoryDeveloper = TestsObjectProvider.CreateGranteeBudgetCategory('Developer');
        categoryDeveloper.FGM_Portal__Parent_Category__c = null;
        insert categoryDeveloper;
        System.assert(categoryDeveloper.Id != null);

        FGM_Portal__Grantee_Budget_Category__c categoryDeveloper2 = TestsObjectProvider.CreateGranteeBudgetCategory('Developer2');
        categoryDeveloper2.FGM_Portal__Parent_Category__c = null;
        insert categoryDeveloper2;
        System.assert(categoryDeveloper2.Id != null);

         FGM_Portal__Grantee_Budget_Category__c categoryDeveloper3 = TestsObjectProvider.CreateGranteeBudgetCategory('Developer3');
        categoryDeveloper3.FGM_Portal__Parent_Category__c = null;
        insert categoryDeveloper3;
        System.assert(categoryDeveloper3.Id != null);

        Map<String,Schema.Recordtypeinfo> newPortalQuestionRecordTypeMapByName = FGM_Portal__Questions__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        List<FGM_Portal__Questions__c> lstFGMPortalQuestion = new List<FGM_Portal__Questions__c>();
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Amount', '', '', '', 'Attachment', ResultFGMPortalQuiz[0].Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Amount', '', '', '', 'Attachment', null, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Name', '', '', '', 'Salesforce Data Type', ResultFGMPortalQuiz[0].Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        lstFGMPortalQuestion[2].FGM_Portal__Parent_QuestionID__c=lstFGMPortalQuestion[0].id;
        Database.Saveresult[] ResultsFGMPortalQuestion = TestsObjectProvider.InsertListWithAssert(lstFGMPortalQuestion);


        List<FGM_Portal__Quiz_Questions__c> lstFGMPortalQuizQuestion = new List<FGM_Portal__Quiz_Questions__c>();
        lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(ResultsFGMPortalQuestion[0].Id, 1, '', '', 50, '1', ResultsFGMPortalRelatedListController[1].Id, true, ResultFGMPortalQuiz[0].Id));
        lstFGMPortalQuizQuestion[0].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(ResultsFGMPortalQuestion[0].Id, 1, 'FGM_Portal__Field__c', '', 50, '1', ResultsFGMPortalRelatedListController[1].Id, true, ResultFGMPortalQuiz[0].Id));
        lstFGMPortalQuizQuestion[1].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(ResultsFGMPortalQuestion[2].Id, 1, 'FGM_Base__Comment__c', '', 50, '1', ResultsFGMPortalRelatedListController[0].Id, true, ResultFGMPortalQuiz[0].Id));
        lstFGMPortalQuizQuestion[2].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(ResultsFGMPortalQuestion[2].Id, 1, 'FGM_Base__Comment__c', '', 50, '1', ResultsFGMPortalRelatedListController[0].Id, true, ResultFGMPortalQuiz[0].Id));
        lstFGMPortalQuizQuestion[3].FGM_Portal__IsCommunityRecord__c = true;

        Database.Saveresult[] ResultsFGMPortalQuizQuestion = TestsObjectProvider.InsertListWithAssert(lstFGMPortalQuizQuestion);

        Opportunity opportunity = TestsObjectProvider.CreateOpportunity('testOpp', 'In Progress', Date.today());
        Database.Saveresult[] ResultOpportunity = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunity});

        Map<String,Schema.Recordtypeinfo> newGranteeReportRecordTypeMapByName = FGM_Base__Grantee_Report__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        FGM_Base__Grantee_Report__c FGMBaseGranteeReport = TestsObjectProvider.CreateFGMBaseGranteeReport(null, ResultOpportunity[0].Id, 'Received'); //newGranteeReportRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GRANTEEREPORT_NARRATIVEREPORT).getRecordTypeId()
        Database.Saveresult[] ResultFGMBaseGranteeReport = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Grantee_Report__c>{FGMBaseGranteeReport});

        User user1 = TestsObjectProvider.CreateUser( ResultContact[0].Id, 'test@test2.com', 'testUser2', 'testUser2', 'test@osf-communities-developer-edition.na17.force.com', true, 'Partner Community User', account.Name);
        user1.ProfileType__c = 'individual';
        user1.UserProfile__c = 'Grantee;Reviewer';
        Database.SaveResult[] ResultUser1 = TestsObjectProvider.InsertListWithAssert(new List<User>{user1});

        List<FCPageLayout__c> lstFCPageLayout = new List<FCPageLayout__c>();
        lstFCPageLayout.add(TestsObjectProvider.CreateFCPageLayout('PageLayoutGrantee1', null, 'FGM_Base__Grantee_Report__c', ResultFGMPortalQuiz[0].Id));
        lstFCPageLayout.add(TestsObjectProvider.CreateFCPageLayout('PageLayoutGrantee2', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId(), 'Opportunity', ResultFGMPortalQuiz[0].Id));
        Database.Saveresult[] ResultsFCPageLayout = TestsObjectProvider.InsertListWithAssert(lstFCPageLayout);

         
    }

//This is to test our page initalization to ensure no DML is done on visit to the page. This should help prevent DML from being added in the future to this page.
static testMethod void pageInitShouldNotPerformDML(){
        FGM_Portal__Quiz__c fgmPortalQuiz = [ 
            SELECT Id, Name
            FROM FGM_Portal__Quiz__c
            WHERE Name = 'PortalQuiz2'
            LIMIT 1];
        FGM_Portal__Related_List_Controller__c fgmPortalRelatedListController = [ 
            SELECT Id, Name
            FROM FGM_Portal__Related_List_Controller__c
            WHERE Name = 'RelatedListNameParent'
            LIMIT 1];
                                        
        Test.startTest();
        Pagereference testPageReference = Page.QuizDesignForm;
        Test.setCurrentPageReference(testPageReference);

        ApexPages.currentPage().getParameters().put('id', fgmPortalQuiz.Id);
        ApexPages.currentPage().getParameters().put('tabId', fgmPortalRelatedListController.Id);
        ApexPages.currentPage().getParameters().put('qqId', fgmPortalQuiz.Id);
        ApexPages.Standardcontroller scPortalQuiz = new ApexPages.Standardcontroller(fgmPortalQuiz);
        QuizDesignFormExtension newQuizDesignFormExtension = new QuizDesignFormExtension(scPortalQuiz);

        //Establish current DML use statements (pre initialize)
        Integer preInitDML = Limits.getDmlStatements();
        newQuizDesignFormExtension.initialize();
        //Check to ensure DML was not performed:
        System.assert(preInitDML == Limits.getDmlStatements());

        newQuizDesignFormExtension.quiz=FGMPortalQuiz;
        newQuizDesignFormExtension.initialize();
        //Rerun the assertion after inializing with a different type of quiz. 
        System.assert(preInitDML == Limits.getDmlStatements());
        Test.stopTest();

}

    static testMethod void QuizDesignFormExtension(){
        Map<String,Schema.Recordtypeinfo> newRelatedListRecordTypeMapByName = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        Map<String,Schema.Recordtypeinfo> newRelatedListRecordTypeMapByName1 = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        Map<String,Schema.Recordtypeinfo> newPortalQuestionRecordTypeMapByName = FGM_Portal__Questions__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        Map<String,Schema.Recordtypeinfo> newPortalQuizRecordTypeMapByName = FGM_Portal__Quiz__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        
        //FGMPortal Quiz
        FGM_Portal__Quiz__c fgmPortalQuiz = [SELECT Id, Name
                                            FROM FGM_Portal__Quiz__c
                                            WHERE Name = 'PortalQuiz1'
                                            LIMIT 1];
        //FGMPortal Quiz2
        FGM_Portal__Quiz__c fgmPortalQuiz2 = [SELECT Id, Name
                                            FROM FGM_Portal__Quiz__c
                                            WHERE Name = 'PortalQuiz2'
                                            LIMIT 1];

        List<FGM_Portal__Related_List_Controller__c> lstFGMPortalRelatedListController = new List<FGM_Portal__Related_List_Controller__c>();
        FGM_Portal__Related_List_Controller__c fgmPortalRelatedListController;
        FGM_Portal__Related_List_Controller__c fgmPortalRelatedListController2;
        lstFGMPortalRelatedListController = [SELECT Id, Name, Language__c, FGM_Portal__IsCommunityRecord__c,
                                            Parent_RLCTabID__c, ObjectName__c
                                            FROM FGM_Portal__Related_List_Controller__c
                                            ORDER BY CreatedDate Desc];

        for (Integer i = 0; i < lstFGMPortalRelatedListController.size(); i++) {
            FGM_Portal__Related_List_Controller__c fgmRLC = lstFGMPortalRelatedListController[i];
            if(fgmRLC.Name == 'RelatedListNameParent'){
                fgmPortalRelatedListController = lstFGMPortalRelatedListController.remove(i);
            }else if(fgmRLC.Name == 'RelatedListNameParent2'){
                fgmPortalRelatedListController2 = lstFGMPortalRelatedListController.remove(i);
            }
        }                                                                                                                         
        List<FCPageLayout__c> lstFCPageLayout = new List<FCPageLayout__c>();
        lstFCPageLayout = [SELECT Id, Name, RecordTypeId__c, ObjectName__c, Quiz__c
                            FROM FCPageLayout__c
                            ORDER BY CreatedDate Desc];


        FGM_Portal__Grantee_Budget_Category__c categoryAdmin;
        FGM_Portal__Grantee_Budget_Category__c categorySystem;
        FGM_Portal__Grantee_Budget_Category__c categoryNetwork;
        FGM_Portal__Grantee_Budget_Category__c categoryDeveloper;
        FGM_Portal__Grantee_Budget_Category__c categoryDeveloper2;
        FGM_Portal__Grantee_Budget_Category__c categoryDeveloper3;

        List<FGM_Portal__Grantee_Budget_Category__c> categoryList = new List<FGM_Portal__Grantee_Budget_Category__c>();
        categoryList = [SELECT Id, Name, FGM_Portal__IsActive__c
                        FROM FGM_Portal__Grantee_Budget_Category__c];
        //Kind of hacky loop but I didnt want to change the tests themselves yet:
        for(FGM_Portal__Grantee_Budget_Category__c grntBdgtCat : categoryList){
            switch on grntBdgtCat.Name {
                when 'Admin' {
                    categoryAdmin = grntBdgtCat;
                }
                when 'System Admin' {
                    categorySystem = grntBdgtCat;
                }
                when 'Network Admin' {
                    categoryNetwork = grntBdgtCat;
                }
                when 'Developer' {
                    categoryDeveloper = grntBdgtCat;
                }
                when 'Developer2' {
                    categoryDeveloper2 = grntBdgtCat;
                }
                when 'Developer3' {
                    categoryDeveloper3 = grntBdgtCat;
                }
            }
        }                     

        List<FGM_Portal__Questions__c> lstFGMPortalQuestion = new List<FGM_Portal__Questions__c>();
        lstFGMPortalQuestion = [SELECT Id, Name, FGM_Portal__RichQuestion__c, FGM_Portal__RichPreText__c, 
                                FGM_Portal__RichPostText__c, FGM_Portal__Help_Tip__c, FGM_portal__Type__c,
                                Quiz__c, AttachmentNameFormula__c, RecordTypeId
                                FROM FGM_Portal__Questions__c
                                ORDER BY CreatedDate Desc];

        List<FGM_Portal__Quiz_Questions__c> lstFGMPortalQuizQuestion = new List<FGM_Portal__Quiz_Questions__c>();
        lstFGMPortalQuizQuestion = [SELECT Id, Name, FGM_portal__Question__c, 
                                    FGM_Portal__Sort_Order__c,Field__c,Required__c,Tab__c,FGM_Portal__Quiz__c
                                    FROM FGM_Portal__Quiz_Questions__c
                                    ORDER By CreatedDate Desc];
                                                                                                                              

        Pagereference testPageReference = Page.QuizDesignForm;
        Test.setCurrentPageReference(testPageReference);

        ApexPages.currentPage().getParameters().put('id', fgmPortalQuiz.Id);
        ApexPages.currentPage().getParameters().put('tabId', fgmPortalRelatedListController.Id);
        ApexPages.currentPage().getParameters().put('qqId', fgmPortalQuiz.Id);
        ApexPages.Standardcontroller scPortalQuiz = new ApexPages.Standardcontroller(fgmPortalQuiz);

        QuizDesignFormExtension newQuizDesignFormExtension = new QuizDesignFormExtension(scPortalQuiz);
        newQuizDesignFormExtension.initialize();

        newQuizDesignFormExtension.quiz=FGMPortalQuiz;
        newQuizDesignFormExtension.initialize();

        newQuizDesignFormExtension.portalLanguage = 'es';
        newQuizDesignFormExtension.setPortalLanguage();
        newQuizDesignFormExtension.portalLanguage = 'en_US';
        newQuizDesignFormExtension.selectedQuizId = fgmPortalQuiz.Id;
        newQuizDesignFormExtension.selectQuiz();
        newQuizDesignFormExtension.redirectTo(testPageReference);
        newQuizDesignFormExtension.getSubTitle();
        newQuizDesignFormExtension.initializeQuizQuestionList();
        FGM_Portal__Quiz__c quiz= new FGM_Portal__Quiz__c();
        quiz.Name='';
        newQuizDesignFormExtension.quiz=quiz;
        newQuizDesignFormExtension.insertQuiz();

        //new Changes

        FGM_Portal__Questions__c FGMPortalQuestion = TestsObjectProvider.CreateFGMPortalQuestion('Amount', '', '', '', 'Attachment', fgmPortalQuiz.Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId());
        FGMPortalQuestion.FGM_Portal__Is_Active__c = true;
        Database.Saveresult[] ResultFGMPortalQuestion = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Questions__c>{FGMPortalQuestion});

        newQuizDesignFormExtension.questionInsert = TestsObjectProvider.CreateFGMPortalQuestion('Amount', '', '', '', 'Attachment', fgmPortalQuiz.Id, '', newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId());
        newQuizDesignFormExtension.quiz = TestsObjectProvider.CreateFGMPortalQuiz('PortalQuiz1', 'test@test1.com', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);

        //end here

        FGM_Portal__Quiz__c FGMPortalQuizInsert = TestsObjectProvider.CreateFGMPortalQuiz('PortalQuiz2', 'test@test2.com', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
        FGMPortalQuizInsert.FGM_Portal__IsCommunityRecord__c = true;
        FGMPortalQuizInsert.FGM_Portal__Failure_URL__c = '~/apex/CommunitiesSignupRejected';
        FGMPortalQuizInsert.RecordTypeId = newPortalQuizRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUIZ_APPLICATION).getRecordTypeId();
        Database.Saveresult[] ResultFGMPortalQuiz1 = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{FGMPortalQuizInsert});

        newQuizDesignFormExtension.quiz = FGMPortalQuizInsert;

        newQuizDesignFormExtension.insertQuiz();
        newQuizDesignFormExtension.getAvailableObjects();
        newQuizDesignFormExtension.openCloneQuizPopUp();
        newQuizDesignFormExtension.closeCloneQuizPopUp();
        newQuizDesignFormExtension.openCloneQuizPopUp();
        newQuizDesignFormExtension.newQuizName = 'TestingQuizClone';
        newQuizDesignFormExtension.insertQuizWithClone();
        newQuizDesignFormExtension.questionInsert.FGM_Portal__RichQuestion__c = ResultFGMPortalQuestion[0].Id;

        newQuizDesignFormExtension.insertQuestion();
        newQuizDesignFormExtension.getOtherLanguageConfig();
        newQuizDesignFormExtension.lstLanguageOptions=null;
        newQuizDesignFormExtension.getOtherLanguageConfig();
        FGM_Portal__Questions__c ques = new FGM_Portal__Questions__c();
        ques.RichQuestion__c='';
        newQuizDesignFormExtension.questionInsert=ques;
        newQuizDesignFormExtension.insertQuestion();
         ques.RichQuestion__c=null;
        newQuizDesignFormExtension.questionInsert=ques;
        newQuizDesignFormExtension.insertQuestion();
         newQuizDesignFormExtension.questionInsert=null;
        newQuizDesignFormExtension.insertQuestion();

        newQuizDesignFormExtension.quizQuestionInsert = TestsObjectProvider.CreateFGMPortalQuizQuestion(lstFGMPortalQuizQuestion[0].Id, 1, 'FGM_Base__Comment__c', '', 50, '1', fgmPortalRelatedListController.Id, true, fgmPortalQuiz.Id);
        newQuizDesignFormExtension.quizQuestionInsert.Field__c='FGM_Base__Comment__c';

        newQuizDesignFormExtension.insertQuestion();
        newQuizDesignFormExtension.selectedTab = fgmPortalRelatedListController.Id;
        newQuizDesignFormExtension.insertQuizQuestion();
        newQuizDesignFormExtension.quizQuestionList = lstFGMPortalQuizQuestion;
        newQuizDesignFormExtension.updateClonedQuestion();
        newQuizDesignFormExtension.updateQuizQuestionList();
        newQuizDesignFormExtension.getParentObjectsForExternalReviewer();
        newQuizDesignFormExtension.getParentObjects();
        newQuizDesignFormExtension.addTab();
        newQuizDesignFormExtension.getChildObjects();
        ApexPages.currentPage().getParameters().put('tabId', fgmPortalRelatedListController2.Id);
        newQuizDesignFormExtension.tabsList = lstFGMPortalRelatedListController;
        newQuizDesignFormExtension.editTab();
        newQuizDesignFormExtension.closeRLCPopUp();
        newQuizDesignFormExtension.deleteTab();

        newQuizDesignFormExtension.backTORLCConfiguration();
        newQuizDesignFormExtension.currentRLCRecord = new QuizDesignFormExtension.RelatedListController();

        FGM_Portal__Related_List_Controller__c FGMPortalRelatedListControllerInsert = TestsObjectProvider.CreateFGMPortalRelatedListController('Home Page', 'Grantee', 'Dashboard', 'Opportunity', 'Opportunity', 'Opportunity', 'Name,Stage,LastModfied Date', 'Name,StageName,LastModifiedDate', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB).getRecordTypeId(), fgmPortalQuiz.Id);
        FGMPortalRelatedListControllerInsert.FGM_Portal__IsCommunityRecord__c = true;
        FGMPortalRelatedListControllerInsert.Language__c = 'en_US';
        newQuizDesignFormExtension.currentRLCRecord.currentRelatedListController = FGMPortalRelatedListControllerInsert;
        newQuizDesignFormExtension.currentRLCRecord.recordTypeName = TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB;
        newQuizDesignFormExtension.currentRLCRecord.newColumn = new QuizDesignFormExtension.columnConfiguration();
        newQuizDesignFormExtension.currentRLCRecord.newColumn.colLabel = 'Name';
        newQuizDesignFormExtension.currentRLCRecord.newColumn.colField = 'Name';
        newQuizDesignFormExtension.addColumnInRelatedListTable();
        newQuizDesignFormExtension.saveRelatedListControllerRecord();

        newQuizDesignFormExtension.cloneRLCWithItems();

        //Select Related list Tab
        newQuizDesignFormExtension.selectedObject = 'FGM_Portal__Related_List_Controller__c';
        newQuizDesignFormExtension.getPortalTypes();
        newQuizDesignFormExtension.getRecordType();
        newQuizDesignFormExtension.IsCloneQuiz = true;
        newQuizDesignFormExtension.selectedRecordType = 'Community';
        Map<Id,FGM_Portal__FCPageLayout__c> mapFCPageLayout2 = new Map<Id,FGM_Portal__FCPageLayout__c>(lstFCPageLayout);
        newQuizDesignFormExtension.mapFCPageLayout=mapFCPageLayout2;
        newQuizDesignFormExtension.existPageLayout=lstFCPageLayout[0].Id;
        newQuizDesignFormExtension.selectedObject='Opportunity';
        newQuizDesignFormExtension.PortalType='Grantee';
        newQuizDesignFormExtension.createNewPageLayout();
        newQuizDesignFormExtension.OpenExistingPageLayout();
        newQuizDesignFormExtension.getRecordTypeName('Community');
        newQuizDesignFormExtension.getObjectName('Quiz');

        //To test Grantee Budget Update
        newQuizDesignFormExtension.currentRLCRecord = new QuizDesignFormExtension.RelatedListController();
        FGM_Portal__Related_List_Controller__c FGMPortalRelatedListControllerInsertBudgetUpdate = TestsObjectProvider.CreateFGMPortalRelatedListController('Test Budget Update', 'grantee', 'Details', 'FGM_Portal__Grantee_Budget_Update__c', 'Opportunity', 'FGM_Portal__Grantee_Budget_Update__c', 'Field To Be Edited', 'Field_To_Be_Edited__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_GRANTEEBUDGETUPDATETAB).getRecordTypeId(), fgmPortalQuiz.Id);
        FGMPortalRelatedListControllerInsert.FGM_Portal__IsCommunityRecord__c = true;
        FGMPortalRelatedListControllerInsert.Language__c = 'en_US';
        newQuizDesignFormExtension.currentRLCRecord.currentRelatedListController = FGMPortalRelatedListControllerInsertBudgetUpdate;

        newQuizDesignFormExtension.currentRLCRecord.recordTypeName = 'Grantee Budget Update Tab';
        ApexPages.currentPage().getParameters().put('RCLType', 'Grantee Budget Update Tab');

        newQuizDesignFormExtension.addTab();
        newQuizDesignFormExtension.saveRelatedListControllerRecord();

        //To test Grantee Budget
        newQuizDesignFormExtension.currentRLCRecord = new QuizDesignFormExtension.RelatedListController();

        FGM_Portal__Related_List_Controller__c FGMPortalRelatedListControllerInsertBudget = TestsObjectProvider.CreateFGMPortalRelatedListController('Test Budget', 'grantee', 'Details', 'FGM_Portal__Grantee_Budget__c', 'Opportunity', 'FGM_Portal__Grantee_Budget__c', 'Field To Be Edited', 'Field_To_Be_Edited__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_GRANTEEBUDGETTAB).getRecordTypeId(), fgmPortalQuiz.Id);
        FGMPortalRelatedListControllerInsert.FGM_Portal__IsCommunityRecord__c = true;
        FGMPortalRelatedListControllerInsert.Language__c = 'en_US';
        newQuizDesignFormExtension.currentRLCRecord.currentRelatedListController = FGMPortalRelatedListControllerInsertBudget;
        newQuizDesignFormExtension.currentRLCRecord.recordTypeName = 'Grantee Budget Tab';
        ApexPages.currentPage().getParameters().put('RCLType', 'Grantee Budget Tab');
        newQuizDesignFormExtension.addTab();
        newQuizDesignFormExtension.quiz = FGMPortalQuizInsert;
        newQuizDesignFormExtension.getGranteeBudgetCategories();
        newQuizDesignFormExtension.selectedBudgetCategory = categoryAdmin.Id;
        newQuizDesignFormExtension.budgetSubCategories();
        newQuizDesignFormExtension.addCategory();

        //Add duplicated budget Category
        newQuizDesignFormExtension.selectedBudgetCategory = categoryAdmin.Id;
        newQuizDesignFormExtension.addCategory();

        //Add Sub Category budget Category
        newQuizDesignFormExtension.selectedBudgetCategory = categoryAdmin.Id;
        newQuizDesignFormExtension.budgetSubCategories();
        newQuizDesignFormExtension.selectedBudgetSubCategory = categorySystem.Id;
        newQuizDesignFormExtension.addCategory();

        newQuizDesignFormExtension.categoryId = 0;
        newQuizDesignFormExtension.editCategory();
        newQuizDesignFormExtension.cancelUpdateCategory();

        //Update Category
        newQuizDesignFormExtension.categoryId = 0;
        newQuizDesignFormExtension.editCategory();
        newQuizDesignFormExtension.selectedBudgetCategory = categoryNetwork.Id;
        newQuizDesignFormExtension.updateCategory();

        // Add New Category
        newQuizDesignFormExtension.selectedBudgetCategory = categoryDeveloper.Id;
        //newQuizDesignFormExtension.budgetSubCategories();
        newQuizDesignFormExtension.addCategory();


        //Update Category
        newQuizDesignFormExtension.categoryId = 0;
        newQuizDesignFormExtension.editCategory();
        newQuizDesignFormExtension.selectedBudgetCategory = categorySystem.Id;
        newQuizDesignFormExtension.updateCategory();

        //delete category before creating its configuration record
        newQuizDesignFormExtension.categoryId = 1;
        newQuizDesignFormExtension.deleteCategory();

         newQuizDesignFormExtension.categoryId = -1;
        newQuizDesignFormExtension.deleteCategory();

        // Save and create busget configuration record and Tab record.
        newQuizDesignFormExtension.saveRelatedListControllerRecord();

        LIST<Grantee_Budget_Configuration__c> lstInsertedConfigurations = newQuizDesignFormExtension.lstBudgetConfiguration ;
        FGM_Portal__Related_List_Controller__c RLCRecord = newQuizDesignFormExtension.currentRLCRecord.currentRelatedListController ;
       LIST<Grantee_Budget_Configuration__c> lstInsertedConfigurationsRepeated1 = new  LIST<Grantee_Budget_Configuration__c>();

        //initialize Tabs
        String strTabId = '';
        for(Grantee_Budget_Configuration__c config : lstInsertedConfigurations){
            lstInsertedConfigurationsRepeated1.add(config);
            if(config.FGM_Portal__Related_List_Controller__c != null){
                strTabId =  config.FGM_Portal__Related_List_Controller__c;
            }
        }
        if(String.isNotBlank(strTabId)){
            ApexPages.currentPage().getParameters().put('tabId', strTabId);
            newQuizDesignFormExtension.editTab();
            newQuizDesignFormExtension.showGranteeBudgetCategories(strTabId);

        }


        // Add new Category
        newQuizDesignFormExtension.selectedBudgetCategory = categorySystem.Id;
        newQuizDesignFormExtension.budgetSubCategories();
        newQuizDesignFormExtension.budgetConfiguration.FGM_Portal__Sort_Order__c = 2;
        newQuizDesignFormExtension.addCategory();

        // To test Same category added
        newQuizDesignFormExtension.categoryId = 0;
        newQuizDesignFormExtension.selectedBudgetCategory = categoryAdmin.Id;
        newQuizDesignFormExtension.updateCategory();


        // delete category
        newQuizDesignFormExtension.categoryId = 0;
        newQuizDesignFormExtension.deleteCategory();
        newQuizDesignFormExtension.saveGranteeBudgetConfiguration(null);
        newQuizDesignFormExtension.saveRelatedListControllerRecord();
        newQuizDesignFormExtension.initilizePageLayout();
        LIST<Grantee_Budget_Configuration__c> lstInsertedConfigurationsRepeated = new LIST<Grantee_Budget_Configuration__c>();
        for(Grantee_Budget_Configuration__c config : lstInsertedConfigurations){
           newQuizDesignFormExtension.lstBudgetConfiguration[0].FGM_Portal__Category__c='a22A0000005IpGgIAK';
           newQuizDesignFormExtension.saveGranteeBudgetConfiguration(null);
            newQuizDesignFormExtension.quiz=null;
            newQuizDesignFormExtension.showGranteeBudgetCategories(null);
            lstInsertedConfigurationsRepeated.add(config);
        }
         newQuizDesignFormExtension.selectedBudgetCategory = categoryDeveloper2.Id;
        newQuizDesignFormExtension.addCategory();
          newQuizDesignFormExtension.selectedBudgetCategory = categoryDeveloper3.Id;
        newQuizDesignFormExtension.addCategory();
        LIST<Grantee_Budget_Configuration__c> lstInsertedConfigurations2 = newQuizDesignFormExtension.lstBudgetConfiguration ;
        newQuizDesignFormExtension.saveGranteeBudgetConfiguration(null);
        newQuizDesignFormExtension.deleteCategory();

        // Unit Testing for FCPROD - 1320  - Starts
        // Code Coverage - Class Data Members and Member Functions - Starts
        String selectedPage = newQuizDesignFormExtension.selectedPage;
        Map < String, String > formulaFields = newQuizDesignFormExtension.formulaFields;
        Boolean BlnTestField = newQuizDesignFormExtension.BlnTestField;
        String portalType = newQuizDesignFormExtension.portalType;
        Boolean isExternalReviewer = newQuizDesignFormExtension.isExternalReviewer;
        String selectedPageLayout = newQuizDesignFormExtension.selectedPageLayout;
        String existPageLayout = newQuizDesignFormExtension.existPageLayout;
        FGM_Portal__FCPageLayout__c newPageLayout = newQuizDesignFormExtension.newPageLayout;
        Integer iColumnIndex = newQuizDesignFormExtension.iColumnIndex;
        String SelectedObjectOption = newQuizDesignFormExtension.SelectedObjectOption;
        String SelectedProfileTabOption = newQuizDesignFormExtension.SelectedProfileTabOption;
        newQuizDesignFormExtension.refreshPage();
        newQuizDesignFormExtension.editTab();
        Test.startTest();
        // Code Coverage - For negative testing - Ends

        // Creating two Related List Controller Records - for Profile Section Custom Tabs
        Map<String,Schema.Recordtypeinfo> mapRLCRecordTypeByName = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfosByName();

        FGM_Portal__Related_List_Controller__c RLC_1 = new FGM_Portal__Related_List_Controller__c();
        RLC_1.RecordTypeId = mapRLCRecordTypeByName.get('Related List With Tab').getRecordTypeId();
        RLC_1.Name = 'Account_Profile_Tab';
        RLC_1.FGM_Portal__ParentObject__c = 'Account';
        RLC_1.FGM_Portal__ObjectName__c = 'FGM_Base__Payment__c';
        RLC_1.FGM_Portal__LookupField__c = 'FGM_Base__Payee__c';
        RLC_1.FGM_Portal__Associated_FC_Portal_Type__c = 'Grantee';
        RLC_1.FGM_Portal__Associated_Tab_Type__c = 'Profile';
        RLC_1.FGM_Portal__Language__c = 'es';
        RLC_1.FGM_Portal__RichInstructionalText__c = 'FGM_Portal__RichInstructionalText__c';
        RLC_1.FGM_Portal__FieldNames__c = 'Name,FGM_Base__Amount__c,FGM_Base__Comment__c,FGM_Base__Request__c';
        RLC_1.FGM_Portal__FieldHeaders__c = 'Payment,Amount,Comment,Request';
        RLC_1.FGM_Portal__SortField__c = 'FGM_Portal__SortField__c';
        RLC_1.FGM_Portal__SortFieldOrder__c = 'Ascending';
        RLC_1.FGM_Portal__ShowDeleteLink__c = TRUE;
        RLC_1.FGM_Portal__ShowNewButton__c = TRUE;
        RLC_1.FGM_Portal__SortOrder__c = 3;
        RLC_1.FGM_Portal__Show_Tab_to_Organization_Users__c = TRUE;
        RLC_1.FGM_Portal__Show_Tab_to_Individual_Users__c = TRUE;
        RLC_1.FGM_Portal__Hide_Edit_Link__c = TRUE;
        insert RLC_1;
        system.assertNotEquals(RLC_1.Id, null);

        FGM_Portal__Related_List_Controller__c RLC_2 = new FGM_Portal__Related_List_Controller__c();
        RLC_2.RecordTypeId = mapRLCRecordTypeByName.get('Related List With Tab').getRecordTypeId();
        RLC_2.Name = 'Contact_Profile_Tab';
        RLC_2.FGM_Portal__ParentObject__c = 'Account';
        RLC_2.FGM_Portal__ObjectName__c = 'FGM_Base__Payment__c';
        RLC_2.FGM_Portal__LookupField__c = 'FGM_Base__Payee__c';
        RLC_2.FGM_Portal__Associated_FC_Portal_Type__c = 'Grantee';
        RLC_2.FGM_Portal__Associated_Tab_Type__c = 'Profile';
        RLC_2.FGM_Portal__Language__c = 'es';
        RLC_2.FGM_Portal__RichInstructionalText__c = 'FGM_Portal__RichInstructionalText__c';
        RLC_2.FGM_Portal__FieldNames__c = 'Name,FGM_Base__Amount__c,FGM_Base__Comment__c,FGM_Base__Request__c';
        RLC_2.FGM_Portal__FieldHeaders__c = 'Payment,Amount,Comment,Request';
        RLC_2.FGM_Portal__SortField__c = 'FGM_Portal__SortField__c';
        RLC_2.FGM_Portal__SortFieldOrder__c = 'Ascending';
        RLC_2.FGM_Portal__ShowDeleteLink__c = TRUE;
        RLC_2.FGM_Portal__ShowNewButton__c = TRUE;
        RLC_2.FGM_Portal__SortOrder__c = 3;
        RLC_2.FGM_Portal__Show_Tab_to_Organization_Users__c = TRUE;
        RLC_2.FGM_Portal__Show_Tab_to_Individual_Users__c = TRUE;
        RLC_2.FGM_Portal__Hide_Edit_Link__c = TRUE;
        insert RLC_2;
        system.assertNotEquals(RLC_2.Id, null);

        // Code Coverage - Creating Test Data - Ends

        // Code Coverage - Calling Data Members and Member Functions - Starts
        ApexPages.currentPage().getParameters().put('RCLType', 'Custom Profile Tab');
        newQuizDesignFormExtension = new QuizDesignFormExtension(scPortalQuiz);
        newQuizDesignFormExtension.quiz = FGMPortalQuizInsert;
        newQuizDesignFormExtension.showGranteeBudgetCategories(RLC_1.Id);

        newQuizDesignFormExtension.SelectedObjectOption = 'FGM_Base__Payment__c';
        newQuizDesignFormExtension.GetProfileTabs();

        newQuizDesignFormExtension.SelectedProfileTabOption = 'Contact_Profile_Tab';
        newQuizDesignFormExtension.CloneRLCRecord();

        newQuizDesignFormExtension.selectedObject = 'Opportunity';
        newQuizDesignFormExtension.isApplicationdesigner = true;
        newQuizDesignFormExtension.addTab();
        newQuizDesignFormExtension.SelectedProfileTabOption = 'Contact_Profile_Tab';
        newQuizDesignFormExtension.CloneRLCRecord();

        newQuizDesignFormExtension.SelectedObjectOption = 'FGM_Base__Payment';
        newQuizDesignFormExtension.GetProfileTabs();


        List<FGM_Portal__Related_List_Controller__c> lstRLCRecords = new List<FGM_Portal__Related_List_Controller__c>();
        lstRLCRecords.add(new FGM_Portal__Related_List_Controller__c());
        newQuizDesignFormExtension.MapObjNRlcRecords.put('FGM_Base__Payment__c', lstRLCRecords);
        newQuizDesignFormExtension.SelectedObjectOption = 'FGM_Base__Payment__c';
        newQuizDesignFormExtension.GetProfileTabs();
        // Code Coverage - Calling Data Members and Member Functions - Starts
        // Unit Testing for FCPROD - 1320  - Ends

        // Unit testing for FCProd-768
        newQuizDesignFormExtension.insertQuestion();
        ApexPages.currentPage().getParameters().put('quizQuesId', lstFGMPortalQuizQuestion[0].Id);
        newQuizDesignFormExtension.deleteQuizQuestion();
        ApexPages.currentPage().getParameters().put('quizQuestionId', lstFGMPortalQuizQuestion[1].Id);
        List<FGM_Portal__Quiz_Questions__c> lstQuizQuestiontest = [SELECT Id,Name,Field__c From FGM_Portal__Quiz_Questions__c];
        ApexPages.currentPage().getParameters().put('quizQuestionId', lstQuizQuestiontest[0].Id);
        newQuizDesignFormExtension.selectedTab = fgmPortalRelatedListController.Id;
        newQuizDesignFormExtension.deleteQuizQuestion();
        QuizDesignFormExtension.columnConfiguration colConfig = new QuizDesignFormExtension.columnConfiguration();
        colConfig.isEdit=true;
        colConfig.colFieldLabel='';
        List < Map < String, String >> lstLanguageSpecificFields = new List < Map < String, String >>();
        QuizDesignFormExtension.RelatedListController objRLC= new QuizDesignFormExtension.RelatedListController();
        objRLC.lstLanguageSpecificFields=lstLanguageSpecificFields;

        newQuizDesignFormExtension.getObjectName(null);
        newQuizDesignFormExtension.mapFCPageLayout=new Map < Id, FCPageLayout__c >(lstFCPageLayout);
        newQuizDesignFormExtension.initilizePageLayouts();
        newQuizDesignFormExtension.quiz= FGMPortalQuiz;
        newQuizDesignFormExtension.initilizePageLayout();
        newQuizDesignFormExtension.currentRLCRecord.currentRelatedListController.Name='tab1';
        newQuizDesignFormExtension.currentRLCRecord.recordTypeName = 'Organization Tab';
        newQuizDesignFormExtension.saveRelatedListControllerRecord();
        newQuizDesignFormExtension.currentRLCRecord.recordTypeName = 'Grantee Budget Tab';
        newQuizDesignFormExtension.saveRelatedListControllerRecord();
        newQuizDesignFormExtension.currentRLCRecord.currentRelatedListController.FGM_Portal__ParentObject__c='Opportunity';
        newQuizDesignFormExtension.currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c='Opportunity';
        newQuizDesignFormExtension.SelectedObjectOption='-- Select Object --';
        newQuizDesignFormExtension.currentRLCRecord.recordTypeName = 'IFrame Tab';
        newQuizDesignFormExtension.saveRelatedListControllerRecord();
        newQuizDesignFormExtension.getFieldsList('Contact Tab');
        newQuizDesignFormExtension.getFieldsList('Organization Tab');
        newQuizDesignFormExtension.getFieldsList('Related List With Tab');
        newQuizDesignFormExtension.getFieldsList('IFrame Tab');

        newQuizDesignFormExtension.quizQuestionList=null;
        newQuizDesignFormExtension.updateQuizQuestionList();
        newQuizDesignFormExtension.isApplicationdesigner = false;
        ApexPages.currentPage().getParameters().put('RCLType', 'Custom Profile Tab');
        newQuizDesignFormExtension.addTab();
        newQuizDesignFormExtension.portalTabsList[0]=lstFGMPortalRelatedListController[8];

        newQuizDesignFormExtension.addTab();
        newQuizDesignFormExtension.OpenExistingPageLayout();
        Map<Id,FGM_Portal__FCPageLayout__c> mapFCPageLayout = new Map<Id,FGM_Portal__FCPageLayout__c>(lstFCPageLayout);
        newQuizDesignFormExtension.mapFCPageLayout=mapFCPageLayout;
        newQuizDesignFormExtension.selectedPageLayout=lstFCPageLayout[0].Id;
        newQuizDesignFormExtension.existPageLayout=lstFCPageLayout[0].Id;
        newQuizDesignFormExtension.OpenExistingPageLayout();
        newQuizDesignFormExtension.existPageLayout=lstFCPageLayout[0].Id;
        newQuizDesignFormExtension.isCloneQuiz=false;
        newQuizDesignFormExtension.createNewPageLayout();
        newQuizDesignFormExtension.quiz=null;
        newQuizDesignFormExtension.initilizePageLayout();
        newQuizDesignFormExtension.currentRLCRecord.recordTypeName='Custom Profile Tab';
        newQuizDesignFormExtension.saveRelatedListControllerRecord();
        ApexPages.currentPage().getParameters().put('tabId', 'a1AA000000UOHePMAY');
        newQuizDesignFormExtension.deleteTab();

        FGM_Portal__Quiz__c FGMPortalQuiz3 = TestsObjectProvider.CreateFGMPortalQuiz('PortalQuiz2', 'test@test1.com', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
        FGMPortalQuiz3.FGM_Portal__IsCommunityRecord__c = true;
        FGMPortalQuiz3.FGM_Portal__Failure_URL__c = '~/apex/CommunitySignupRejected';
        QuizDesignFormExtension objQuizDesignFormExtension = new QuizDesignFormExtension(scPortalQuiz);
        objQuizDesignFormExtension.quiz=FGMPortalQuiz3;
        objQuizDesignFormExtension.quizID=FGMPortalQuiz3.Id;
        objQuizDesignFormExtension.insertQuiz();
        objQuizDesignFormExtension.selectedQuizId='111';
        objQuizDesignFormExtension.newQuizName='1111';
        objQuizDesignFormExtension.insertQuizWithClone();
        objQuizDesignFormExtension.selectedQuizId='---';
        objQuizDesignFormExtension.insertQuizWithClone();
        objQuizDesignFormExtension.insertQuizQuestion();
        objQuizDesignFormExtension.questionInsert=lstFGMPortalQuestion[0];
        objQuizDesignFormExtension.selectedTab =fgmPortalRelatedListController.id;
        List<FGM_Portal__Related_List_Controller__c> lstFGMPortalRelatedListController1 = new List<FGM_Portal__Related_List_Controller__c>();
        lstFGMPortalRelatedListController1.add(fgmPortalRelatedListController);
        objQuizDesignFormExtension.tabsList = lstFGMPortalRelatedListController;
        objQuizDesignFormExtension.insertQuestion();
        objQuizDesignFormExtension.updateClonedQuestion();

        objQuizDesignFormExtension.updateQuizQuestionList();

        newQuizDesignFormExtension.selectedTab = fgmPortalRelatedListController2.Id;
        newQuizDesignFormExtension.insertQuestion();
        newQuizDesignFormExtension.getChildObjectFields();

        newQuizDesignFormExtension.addColumnInRelatedListTable();
        newQuizDesignFormExtension.iColumnIndex=0;
        newQuizDesignFormExtension.currentRLCRecord.relatedListColumns.add(newQuizDesignFormExtension.currentRLCRecord.newColumn);

        newQuizDesignFormExtension.saveColumnInRelatedListTable();
        newQuizDesignFormExtension.editColumnInRelatedListTable();
        newQuizDesignFormExtension.removeColumnInRelatedListTable();


        newQuizDesignFormExtension.MapFieldApiNameToLabel= new Map< String, String >();

        newQuizDesignFormExtension.isCloneQuiz=false;
        newQuizDesignFormExtension.selectedRecordType='Application Quiz';
        newQuizDesignFormExtension.createNewPageLayout();
        newQuizDesignFormExtension.MapObjNRlcRecords=null;
        newQuizDesignFormExtension.GetProfileTabs();
        lstFGMPortalQuizQuestion[3].FGM_Portal__Field__c = 'Description';
        newQuizDesignFormExtension.quizQuestionList = lstFGMPortalQuizQuestion;

        //new list of quiz questions with no field
        List<FGM_Portal__Quiz__c> lstQuiz = new List<FGM_Portal__Quiz__c>{FGMPortalQuiz,FGMPortalQuiz2};
        newQuizDesignFormExtension.selectedTab=lstFGMPortalRelatedListController[0].Id;
        newQuizDesignFormExtension.quizQuestionInsert =  TestsObjectProvider.CreateFGMPortalQuizQuestion(lstFGMPortalQuizQuestion[0].Id, 1, 'FGM_Portal__DeliveryInstallationStatus__c', '', 50, '1', fgmPortalRelatedListController.Id, true, fgmPortalQuiz.Id);
        newQuizDesignFormExtension.insertQuestion();
        newQuizDesignFormExtension.updateQuizQuestionList();

       Test.stopTest();


    }
}