@isTest
private class TestTabGenratorExtension{
    static testMethod void TabGenratorExtension(){
        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

        Contact contact = TestsObjectProvider.CreateContact('testContact1', 'testContact1', ResultAccount[0].Id, 'test@test1.com');
        Database.SaveResult[] ResultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});

        List<FGM_Portal__Portal_User__c> lstPortalUser = new List<FGM_Portal__Portal_User__c>();
        lstPortalUser.add(TestSObjectProvider.CreateFGMPortalUser(null, 'test@osf-communities-developer-edition.na17.force.com', 'Portal LastName', 'test@test1.com', 'test@test1.com', 'test@osf-communities-developer-edition.na17.force.com', 'Test1234', 'Test1234', true));
        Database.Saveresult[] ResultFGMPortalUser = TestsObjectProvider.InsertListWithAssert(lstPortalUser);

        FGM_Portal__Quiz__c FGMPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz('PortalQuiz1', 'test@test1.com', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
        Database.Saveresult[] ResultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{FGMPortalQuiz});

        Map<String,Schema.Recordtypeinfo> newRelatedListRecordTypeMapByName = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfosByName();

        List<FGM_Portal__Related_List_Controller__c> lstFGMPortalRelatedListController = new List<FGM_Portal__Related_List_Controller__c>();
        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListName', 'Grantee', 'Dashboard', 'Opportunity', 'Opportunity', 'Opportunity', 'Name,Stage,LastModfiedDate', 'Name,StageName,LastModifiedDate', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        lstFGMPortalRelatedListController.add(TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListName1', 'Reviewer', 'Details', 'Amendment__c', 'Quiz__c', 'Bank_Account__c', 'Field To Be Edited', 'Field_To_Be_Edited__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id));
        Database.Saveresult[] ResultsFGMPortalRelatedListController = TestsObjectProvider.InsertListWithAssert(lstFGMPortalRelatedListController);

        ApexPages.Standardcontroller scRelatedList = new ApexPages.Standardcontroller(lstFGMPortalRelatedListController[0]);
        TabGenratorExtension newTabGenratorExtension = new TabGenratorExtension(scRelatedList);


        newTabGenratorExtension.getTabType();
        newTabGenratorExtension.getPortalType();
        newTabGenratorExtension.AssoiciatedTab = 'Dashboard';
        newTabGenratorExtension.AssociatedPortal = 'Grantee';
        newTabGenratorExtension.existingTabRecord = ResultsFGMPortalRelatedListController[0].Id;
        newTabGenratorExtension.showassociatedTab();
        newTabGenratorExtension.getExistingTabs();
        newTabGenratorExtension.OpenExistingTabRecord();
        newTabGenratorExtension.getObjectFields('Opportunity');

        FGM_Portal__Related_List_Controller__c FGMPortalRelatedListController = TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListName5', 'Grantee', 'Dashboard', 'Opportunity', 'Opportunity', 'Opportunity', 'Matching or Challenge Support Formula,Duration in Years', 'Location_of_Sponsorship_Opportunity__c,Duration_in_Years__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id);
        ApexPages.Standardcontroller scRelatedList1 = new ApexPages.Standardcontroller(FGMPortalRelatedListController);
        TabGenratorExtension newTabGenratorExtension1 = new TabGenratorExtension(scRelatedList1);
        newTabGenratorExtension1.AssoiciatedTab = 'Profile';
        newTabGenratorExtension1.AssociatedPortal = 'Grantee';
        newTabGenratorExtension1.newTabName = 'RelatedListName5';

        //New changes starts here

        FGM_Portal__Related_List_Controller__c FGMPortalRelatedListControllerToNullAssociatedPortal = TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListName5', 'Grantee', 'Dashboard', 'Opportunity', 'Opportunity', 'Opportunity', 'Matching or Challenge Support Formula,Duration in Years', 'Location_of_Sponsorship_Opportunity__c,Duration_in_Years__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id);
        ApexPages.Standardcontroller scRelatedListToNullAssociatedPortal = new ApexPages.Standardcontroller(FGMPortalRelatedListControllerToNullAssociatedPortal);
        TabGenratorExtension newTabGenratorExtensionToNullAssociatedPortal = new TabGenratorExtension(scRelatedListToNullAssociatedPortal);
        newTabGenratorExtensionToNullAssociatedPortal.AssoiciatedTab = 'Dashboard';
        newTabGenratorExtensionToNullAssociatedPortal.AssociatedPortal = '';
        newTabGenratorExtensionToNullAssociatedPortal.newTabName = 'RelatedListName5';
        newTabGenratorExtensionToNullAssociatedPortal.existingTabRecord = ResultsFGMPortalRelatedListController[0].Id;
        newTabGenratorExtensionToNullAssociatedPortal.showassociatedTab();
        newTabGenratorExtensionToNullAssociatedPortal.getExistingTabs();
        newTabGenratorExtensionToNullAssociatedPortal.OpenExistingTabRecord();
        newTabGenratorExtensionToNullAssociatedPortal.DeleteExistingTabRecord();

        TabGenratorExtension newTabGenratorExtensionForRollbackWithError = new TabGenratorExtension(scRelatedList);
        newTabGenratorExtensionForRollbackWithError.rollbackWithError('Error Message', null);


        FGM_Portal__Related_List_Controller__c FGMPRLController = TestsObjectProvider.CreateFGMPortalRelatedListController('RelatedListName5', 'Grantee', 'Dashboard', 'Opportunity', 'Opportunity', 'Opportunity', 'Matching or Challenge Support Formula,Duration in Years', 'Location_of_Sponsorship_Opportunity__c,Duration_in_Years__c', newRelatedListRecordTypeMapByName.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId(), ResultFGMPortalQuiz[0].Id);
        ApexPages.Standardcontroller SCRelatedList2 = new ApexPages.Standardcontroller(FGMPRLController);
        TabGenratorExtension newTGEController = new TabGenratorExtension(SCRelatedList2);
        newTGEController.AssoiciatedTab = 'Dashboard';
        newTGEController.AssociatedPortal = 'Grantee';
        newTGEController.newTabName = 'RelatedListName5';
        newTGEController.getAvailableObjects();

        //Ends here

        newTabGenratorExtension1.createNewTab();
        newTabGenratorExtension1.addColumnInRelatedListTable();
        newTabGenratorExtension1.addTab();

        newTabGenratorExtension1.currentRLCRecord.currentRelatedListController.FGM_Portal__LookupField__c = 'Opportunity';
        newTabGenratorExtension1.currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c = 'Opportunity';

        newTabGenratorExtension1.getAvailableObjects();

        Pagereference testPageReference = Page.TabGenerator;
        Test.setCurrentPageReference(testPageReference);
        ApexPages.currentPage().getParameters().put('columnIndex', '1');

        newTabGenratorExtension1.removeColumnFromRelatedListTable();
        newTabGenratorExtension1.saveRelatedListControllerRecord();
        newTabGenratorExtension1.getFieldLabel('Name');
        newTabGenratorExtension1.closeRLCPopUp();

    }
}