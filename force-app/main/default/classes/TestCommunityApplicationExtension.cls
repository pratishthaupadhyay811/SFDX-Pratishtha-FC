@IsTest
private class TestCommunityApplicationExtension {
    public class TestException extends Exception {
    }

    @IsTest
    private static void saveContactTabNotUpdated() {
        final Id contactId = Stub.generateFakeId(Schema.SObjectType.Contact);
        System.assertNotEquals(
            null,
            contactId,
            'Stub.generateFakeId should never return null'
        );

        // ONE of the following must be TRUE for this scenario where the update doesn't get called:
        //     - bIsContactTab is false
        //     - userContact is null
        //     - userContact is not null but userContact.Id is null
        final Map<Boolean, List<Schema.Contact>> userContactsByIsOrganizationTab = new Map<Boolean, List<Schema.Contact>>{
            false => new List<Schema.Contact>{
                null,
                new Schema.Contact(),
                new Schema.Contact(Id = contactId)
            },
            true => new List<Schema.Contact>{ null, new Schema.Contact() }
        };

        // No Stub.Methods should be called for all scenarios in this unit test.
        final Stub stub = new Stub(new List<Stub.Method>());

        Test.startTest();

        for (Boolean bIsContactTab : userContactsByIsOrganizationTab.keySet()) {
            for (
                Schema.Contact userContact : userContactsByIsOrganizationTab.get(
                    bIsContactTab
                )
            ) {
                final CommunityApplicationExtension controller = new CommunityApplicationExtension();
                {
                    // Set stubs
                    controller.adminContextExecutionManagerInstance = (AdminContextExecutionManager) Test.createStub(
                        AdminContextExecutionManager.class,
                        stub
                    );

                    controller.crudFlsServiceInstance = (CrudFlsService) Test.createStub(
                        CrudFlsService.class,
                        stub
                    );

                    // Set controller attributes for scenario
                    controller.bIsContactTab = bIsContactTab;
                    controller.userContact = userContact;
                }

                Exception actualException;
                PageReference actual;

                try {
                    actual = controller.saveContactTab();
                } catch (Exception e) {
                    actualException = e;
                }

                // It's ok to reuse stub since no Stub.Methods should be called for all scenarios in this unit test.
                stub.assertMethodsCalled();

                System.assertEquals(
                    null,
                    actualException,
                    'should never throw an Exception'
                );

                System.assertEquals(
                    new List<ApexPages.Message>(),
                    ApexPages.getMessages(),
                    'No ApexPages.Messages should have been added, i.e. ApexPages.getMessages() should be empty'
                );

                System.assertEquals(null, actual, 'should always return null');
            }
        }

        Test.stopTest();
    }

    @IsTest
    private static void saveContactTabUpdated() {
        final Id contact = Stub.generateFakeId(Schema.SObjectType.Contact);
        System.assertNotEquals(
            null,
            contact,
            'Stub.generateFakeId should never return null'
        );

        // ALL of the following must be FALSE for this scenario where the update gets called:
        //     - bIsContactTab is false
        //     - userContact is null
        //     - userContact is not null but userContact.Id is null
        final Boolean bIsContactTab = true;
        final Schema.Contact userContact = new Schema.Contact(Id = contact);

        final AdminContextExecutionManagerTest.StripInaccessibleAndUpdateMethod stripInaccessibleAndUpdate = new AdminContextExecutionManagerTest.StripInaccessibleAndUpdateMethod();
        {
            // Update stripInaccessibleAndUpdate argument to use inexact equality (==) since a new List<SObject> is passed as the argument
            stripInaccessibleAndUpdate.getParameters()[0]
                .setAssertArgumentHasExactEquality(false);

            stripInaccessibleAndUpdate.records = new List<SObject>{ userContact };
            // stripInaccessibleAndUpdate returns void
        }

        final Stub stub = new Stub(new List<Stub.Method>{ stripInaccessibleAndUpdate });

        Test.startTest();

        final CommunityApplicationExtension controller = new CommunityApplicationExtension();
        {
            // Set stubs
            controller.adminContextExecutionManagerInstance = (AdminContextExecutionManager) Test.createStub(
                AdminContextExecutionManager.class,
                stub
            );

            controller.crudFlsServiceInstance = (CrudFlsService) Test.createStub(
                CrudFlsService.class,
                stub
            );

            // Set controller attributes for scenario
            controller.bIsContactTab = bIsContactTab;
            controller.userContact = userContact;

            System.assertEquals(
                true,
                controller.bIsContactTab,
                'controller.bIsContactTab should be true'
            );
            System.assertNotEquals(
                null,
                controller.userContact,
                'controller.userContact should NOT be null'
            );
            System.assertNotEquals(
                null,
                controller.userContact.Id,
                'controller.userContact.Id should NOT be null'
            );
        }

        Exception actualException;
        PageReference actual;

        try {
            actual = controller.saveContactTab();
        } catch (Exception e) {
            actualException = e;
        }

        // stripInaccessibleAndUpdate should have been called.
        stub.assertMethodsCalled();

        System.assertEquals(null, actualException, 'should never throw an Exception');

        System.assertEquals(
            true,
            ApexPages.getMessages().isEmpty(),
            'No ApexPages.Messages should have been added, i.e. ApexPages.getMessages() should be empty'
        );

        System.assertEquals(null, actual, 'should always return null');

        Test.stopTest();
    }

    @IsTest
    private static void saveContactTabUpdatedThrowsNonDmlException() {
        final Id contactId = Stub.generateFakeId(Schema.SObjectType.Contact);
        System.assertNotEquals(
            null,
            contactId,
            'Stub.generateFakeId should never return null'
        );

        // ALL of the following must be FALSE for this scenario where the update gets called:
        //     - bIsContactTab is false
        //     - userContact is null
        //     - userContact is not null but userContact.Id is null
        final Boolean bIsContactTab = true;
        final Schema.Contact userContact = new Schema.Contact(Id = contactId);

        final String exceptionMessage = 'message' + Crypto.getRandomInteger();
        final TestException nonDmlException = new TestException(exceptionMessage);

        final ApexPages.Severity expectedApexPagesSeverity = ApexPages.Severity.Error;
        final String expectedApexPagesSummary = '' + nonDmlException.getMessage();

        final AdminContextExecutionManagerTest.StripInaccessibleAndUpdateMethod stripInaccessibleAndUpdate = new AdminContextExecutionManagerTest.StripInaccessibleAndUpdateMethod();
        {
            // Update stripInaccessibleAndUpdate argument to use inexact equality (==) since a new List<SObject> is passed as the argument
            stripInaccessibleAndUpdate.getParameters()[0]
                .setAssertArgumentHasExactEquality(false);

            stripInaccessibleAndUpdate.records = new List<SObject>{ userContact };
            // stripInaccessibleAndUpdate returns void

            stripInaccessibleAndUpdate.setExceptionThrownBeforeReturningValue(
                nonDmlException
            );
        }

        final Stub stub = new Stub(new List<Stub.Method>{ stripInaccessibleAndUpdate });

        Test.startTest();

        final CommunityApplicationExtension controller = new CommunityApplicationExtension();
        {
            // Set stubs
            controller.adminContextExecutionManagerInstance = (AdminContextExecutionManager) Test.createStub(
                AdminContextExecutionManager.class,
                stub
            );

            controller.crudFlsServiceInstance = (CrudFlsService) Test.createStub(
                CrudFlsService.class,
                stub
            );

            // Set controller attributes for scenario
            controller.bIsContactTab = bIsContactTab;
            controller.userContact = userContact;

            System.assertEquals(
                true,
                controller.bIsContactTab,
                'controller.bIsContactTab should be true'
            );
            System.assertNotEquals(
                null,
                controller.userContact,
                'controller.userContact should NOT be null'
            );
            System.assertNotEquals(
                null,
                controller.userContact.Id,
                'controller.userContact.Id should NOT be null'
            );
        }

        Exception actualException;
        PageReference actual;

        try {
            actual = controller.saveContactTab();
        } catch (Exception e) {
            actualException = e;
        }

        // stripInaccessibleAndUpdate should have been called.
        stub.assertMethodsCalled();

        System.assertEquals(null, actualException, 'should never throw an Exception');

        System.assertEquals(
            1,
            ApexPages.getMessages().size(),
            'One (1) pexPages.Messages should have been added'
        );

        System.assertEquals(
            expectedApexPagesSeverity,
            ApexPages.getMessages()[0].getSeverity(),
            'ApexPages first message should have expected getSeverity()'
        );

        System.assertEquals(
            expectedApexPagesSummary,
            ApexPages.getMessages()[0].getSummary(),
            'ApexPages first message should have expected getSummary()'
        );

        System.assertEquals(null, actual, 'should always return null');

        Test.stopTest();
    }

    @IsTest
    private static void saveOrganizationTabOnErrNotUpdated() {
        final Id accountId = Stub.generateFakeId(Schema.SObjectType.Account);
        System.assertNotEquals(
            null,
            accountId,
            'Stub.generateFakeId should never return null'
        );

        // ONE of the following must be TRUE for this scenario where the update doesn't get called:
        //     - bIsOrganizationTab is false
        //     - userAccount is null
        //     - userAccount is not null but userAccount.Id is null
        final Map<Boolean, List<Schema.Account>> userAccountsByIsOrganizationTab = new Map<Boolean, List<Schema.Account>>{
            false => new List<Schema.Account>{
                null,
                new Schema.Account(),
                new Schema.Account(Id = accountId)
            },
            true => new List<Schema.Account>{ null, new Schema.Account() }
        };

        // No Stub.Methods should be called for all scenarios in this unit test.
        final Stub stub = new Stub(new List<Stub.Method>());

        Test.startTest();

        for (Boolean bIsOrganizationTab : userAccountsByIsOrganizationTab.keySet()) {
            for (
                Schema.Account userAccount : userAccountsByIsOrganizationTab.get(
                    bIsOrganizationTab
                )
            ) {
                final CommunityApplicationExtension controller = new CommunityApplicationExtension();
                {
                    // Set stubs
                    controller.adminContextExecutionManagerInstance = (AdminContextExecutionManager) Test.createStub(
                        AdminContextExecutionManager.class,
                        stub
                    );

                    controller.crudFlsServiceInstance = (CrudFlsService) Test.createStub(
                        CrudFlsService.class,
                        stub
                    );

                    // Set controller attributes for scenario
                    controller.bIsOrganizationTab = bIsOrganizationTab;
                    controller.userAccount = userAccount;
                }

                Exception actualException;
                Boolean actual;

                try {
                    actual = controller.saveOrganizationTabOnErr();
                } catch (Exception e) {
                    actualException = e;
                }

                // It's ok to reuse stub since no Stub.Methods should be called for all scenarios in this unit test.
                stub.assertMethodsCalled();

                System.assertEquals(
                    null,
                    actualException,
                    'should never throw an Exception'
                );

                System.assertEquals(
                    true,
                    ApexPages.getMessages().isEmpty(),
                    'No ApexPages.Messages should have been added, i.e. ApexPages.getMessages() should be empty'
                );

                System.assertEquals(
                    false,
                    actual,
                    'should return false if no Exception thrown updating'
                );
            }
        }

        Test.stopTest();
    }

    @IsTest
    private static void saveOrganizationTabOnErrUpdated() {
        final Id accountId = Stub.generateFakeId(Schema.SObjectType.Account);
        System.assertNotEquals(
            null,
            accountId,
            'Stub.generateFakeId should never return null'
        );

        // ALL of the following must be FALSE for this scenario where the update gets called:
        //     - bIsOrganizationTab is false
        //     - userAccount is null
        //     - userAccount is not null but userAccount.Id is null
        final Boolean bIsOrganizationTab = true;
        final Schema.Account userAccount = new Schema.Account(Id = accountId);

        final AdminContextExecutionManagerTest.StripInaccessibleAndUpdateMethod stripInaccessibleAndUpdate = new AdminContextExecutionManagerTest.StripInaccessibleAndUpdateMethod();
        {
            // Update stripInaccessibleAndUpdate argument to use inexact equality (==) since a new List<SObject> is passed as the argument
            stripInaccessibleAndUpdate.getParameters()[0]
                .setAssertArgumentHasExactEquality(false);

            stripInaccessibleAndUpdate.records = new List<SObject>{ userAccount };
            // stripInaccessibleAndUpdate returns void
        }

        final Stub stub = new Stub(new List<Stub.Method>{ stripInaccessibleAndUpdate });

        Test.startTest();

        final CommunityApplicationExtension controller = new CommunityApplicationExtension();
        {
            // Set stubs
            controller.adminContextExecutionManagerInstance = (AdminContextExecutionManager) Test.createStub(
                AdminContextExecutionManager.class,
                stub
            );

            controller.crudFlsServiceInstance = (CrudFlsService) Test.createStub(
                CrudFlsService.class,
                stub
            );

            // Set controller attributes for scenario
            controller.bIsOrganizationTab = bIsOrganizationTab;
            controller.userAccount = userAccount;

            System.assertEquals(
                true,
                controller.bIsOrganizationTab,
                'controller.bIsOrganizationTab should be true'
            );
            System.assertNotEquals(
                null,
                controller.userAccount,
                'controller.userAccount should NOT be null'
            );
            System.assertNotEquals(
                null,
                controller.userAccount.Id,
                'controller.userAccount.Id should NOT be null'
            );
        }

        Exception actualException;
        Boolean actual;

        try {
            actual = controller.saveOrganizationTabOnErr();
        } catch (Exception e) {
            actualException = e;
        }

        // stripInaccessibleAndUpdate should have been called.
        stub.assertMethodsCalled();

        System.assertEquals(null, actualException, 'should never throw an Exception');

        System.assertEquals(
            true,
            ApexPages.getMessages().isEmpty(),
            'No ApexPages.Messages should have been added, i.e. ApexPages.getMessages() should be empty'
        );

        System.assertEquals(
            false,
            actual,
            'should return false if no Exception thrown updating'
        );

        Test.stopTest();
    }

    @IsTest
    private static void saveOrganizationTabOnErrUpdatedThrowsNonDmlException() {
        final Id accountId = Stub.generateFakeId(Schema.SObjectType.Account);
        System.assertNotEquals(
            null,
            accountId,
            'Stub.generateFakeId should never return null'
        );

        // ALL of the following must be FALSE for this scenario where the update gets called:
        //     - bIsOrganizationTab is false
        //     - userAccount is null
        //     - userAccount is not null but userAccount.Id is null
        final Boolean bIsOrganizationTab = true;
        final Schema.Account userAccount = new Schema.Account(Id = accountId);

        final String exceptionMessage = 'message' + Crypto.getRandomInteger();
        final TestException nonDmlException = new TestException(exceptionMessage);

        final ApexPages.Severity expectedApexPagesSeverity = ApexPages.Severity.Error;
        final String expectedApexPagesSummary = '' + nonDmlException.getMessage();

        final AdminContextExecutionManagerTest.StripInaccessibleAndUpdateMethod stripInaccessibleAndUpdate = new AdminContextExecutionManagerTest.StripInaccessibleAndUpdateMethod();
        {
            // Update stripInaccessibleAndUpdate argument to use inexact equality (==) since a new List<SObject> is passed as the argument
            stripInaccessibleAndUpdate.getParameters()[0]
                .setAssertArgumentHasExactEquality(false);

            stripInaccessibleAndUpdate.records = new List<SObject>{ userAccount };
            // stripInaccessibleAndUpdate returns void

            stripInaccessibleAndUpdate.setExceptionThrownBeforeReturningValue(
                nonDmlException
            );
        }

        final Stub stub = new Stub(new List<Stub.Method>{ stripInaccessibleAndUpdate });

        Test.startTest();

        final CommunityApplicationExtension controller = new CommunityApplicationExtension();
        {
            // Set stubs
            controller.adminContextExecutionManagerInstance = (AdminContextExecutionManager) Test.createStub(
                AdminContextExecutionManager.class,
                stub
            );

            controller.crudFlsServiceInstance = (CrudFlsService) Test.createStub(
                CrudFlsService.class,
                stub
            );

            // Set controller attributes for scenario
            controller.bIsOrganizationTab = bIsOrganizationTab;
            controller.userAccount = userAccount;

            System.assertEquals(
                true,
                controller.bIsOrganizationTab,
                'controller.bIsOrganizationTab should be true'
            );
            System.assertNotEquals(
                null,
                controller.userAccount,
                'controller.userAccount should NOT be null'
            );
            System.assertNotEquals(
                null,
                controller.userAccount.Id,
                'controller.userAccount.Id should NOT be null'
            );
        }

        Exception actualException;
        Boolean actual;

        try {
            actual = controller.saveOrganizationTabOnErr();
        } catch (Exception e) {
            actualException = e;
        }

        // stripInaccessibleAndUpdate should have been called.
        stub.assertMethodsCalled();

        System.assertEquals(null, actualException, 'should never throw an Exception');

        System.assertEquals(
            1,
            ApexPages.getMessages().size(),
            'One (1) pexPages.Messages should have been added'
        );

        System.assertEquals(
            expectedApexPagesSeverity,
            ApexPages.getMessages()[0].getSeverity(),
            'ApexPages first message should have expected getSeverity()'
        );

        System.assertEquals(
            expectedApexPagesSummary,
            ApexPages.getMessages()[0].getSummary(),
            'ApexPages first message should have expected getSummary()'
        );

        System.assertEquals(
            true,
            actual,
            'should return true since an Exception was thrown updating'
        );

        Test.stopTest();
    }

    @IsTest
    private static void saveOrganizationTabNotUpdated() {
        final Id accountId = Stub.generateFakeId(Schema.SObjectType.Account);
        System.assertNotEquals(
            null,
            accountId,
            'Stub.generateFakeId should never return null'
        );

        // ONE of the following must be TRUE for this scenario where the update doesn't get called:
        //     - bIsOrganizationTab is false
        //     - userAccount is null
        //     - userAccount is not null but userAccount.Id is null
        final Map<Boolean, List<Schema.Account>> userAccountsByIsOrganizationTab = new Map<Boolean, List<Schema.Account>>{
            false => new List<Schema.Account>{
                null,
                new Schema.Account(),
                new Schema.Account(Id = accountId)
            },
            true => new List<Schema.Account>{ null, new Schema.Account() }
        };

        // No Stub.Methods should be called for all scenarios in this unit test.
        final Stub stub = new Stub(new List<Stub.Method>());

        Test.startTest();

        for (Boolean bIsOrganizationTab : userAccountsByIsOrganizationTab.keySet()) {
            for (
                Schema.Account userAccount : userAccountsByIsOrganizationTab.get(
                    bIsOrganizationTab
                )
            ) {
                final CommunityApplicationExtension controller = new CommunityApplicationExtension();
                {
                    // Set stubs
                    controller.adminContextExecutionManagerInstance = (AdminContextExecutionManager) Test.createStub(
                        AdminContextExecutionManager.class,
                        stub
                    );

                    controller.crudFlsServiceInstance = (CrudFlsService) Test.createStub(
                        CrudFlsService.class,
                        stub
                    );

                    // Set controller attributes for scenario
                    controller.bIsOrganizationTab = bIsOrganizationTab;
                    controller.userAccount = userAccount;
                }

                Exception actualException;
                PageReference actual;

                try {
                    actual = controller.saveOrganizationTab();
                } catch (Exception e) {
                    actualException = e;
                }

                // It's ok to reuse stub since no Stub.Methods should be called for all scenarios in this unit test.
                stub.assertMethodsCalled();

                System.assertEquals(
                    null,
                    actualException,
                    'should never throw an Exception'
                );

                System.assertEquals(
                    true,
                    ApexPages.getMessages().isEmpty(),
                    'No ApexPages.Messages should have been added, i.e. ApexPages.getMessages() should be empty'
                );

                System.assertEquals(null, actual, 'should always return null');
            }
        }

        Test.stopTest();
    }

    @IsTest
    private static void saveOrganizationTabUpdated() {
        final Id accountId = Stub.generateFakeId(Schema.SObjectType.Account);
        System.assertNotEquals(
            null,
            accountId,
            'Stub.generateFakeId should never return null'
        );

        // ALL of the following must be FALSE for this scenario where the update gets called:
        //     - bIsOrganizationTab is false
        //     - userAccount is null
        //     - userAccount is not null but userAccount.Id is null
        final Boolean bIsOrganizationTab = true;
        final Schema.Account userAccount = new Schema.Account(Id = accountId);

        final AdminContextExecutionManagerTest.StripInaccessibleAndUpdateMethod stripInaccessibleAndUpdate = new AdminContextExecutionManagerTest.StripInaccessibleAndUpdateMethod();
        {
            // Update stripInaccessibleAndUpdate argument to use inexact equality (==) since a new List<SObject> is passed as the argument
            stripInaccessibleAndUpdate.getParameters()[0]
                .setAssertArgumentHasExactEquality(false);

            stripInaccessibleAndUpdate.records = new List<SObject>{ userAccount };
            // stripInaccessibleAndUpdate returns void
        }

        final Stub stub = new Stub(new List<Stub.Method>{ stripInaccessibleAndUpdate });

        Test.startTest();

        final CommunityApplicationExtension controller = new CommunityApplicationExtension();
        {
            // Set stubs
            controller.adminContextExecutionManagerInstance = (AdminContextExecutionManager) Test.createStub(
                AdminContextExecutionManager.class,
                stub
            );

            controller.crudFlsServiceInstance = (CrudFlsService) Test.createStub(
                CrudFlsService.class,
                stub
            );

            // Set controller attributes for scenario
            controller.bIsOrganizationTab = bIsOrganizationTab;
            controller.userAccount = userAccount;

            System.assertEquals(
                true,
                controller.bIsOrganizationTab,
                'controller.bIsOrganizationTab should be true'
            );
            System.assertNotEquals(
                null,
                controller.userAccount,
                'controller.userAccount should NOT be null'
            );
            System.assertNotEquals(
                null,
                controller.userAccount.Id,
                'controller.userAccount.Id should NOT be null'
            );
        }

        Exception actualException;
        PageReference actual;

        try {
            actual = controller.saveOrganizationTab();
        } catch (Exception e) {
            actualException = e;
        }

        // stripInaccessibleAndUpdate should have been called.
        stub.assertMethodsCalled();

        System.assertEquals(null, actualException, 'should never throw an Exception');

        System.assertEquals(
            true,
            ApexPages.getMessages().isEmpty(),
            'No ApexPages.Messages should have been added, i.e. ApexPages.getMessages() should be empty'
        );

        System.assertEquals(null, actual, 'should always return null');

        Test.stopTest();
    }

    @IsTest
    private static void saveOrganizationTabUpdatedThrowsNonDmlException() {
        final Id accountId = Stub.generateFakeId(Schema.SObjectType.Account);
        System.assertNotEquals(
            null,
            accountId,
            'Stub.generateFakeId should never return null'
        );

        // ALL of the following must be FALSE for this scenario where the update gets called:
        //     - bIsOrganizationTab is false
        //     - userAccount is null
        //     - userAccount is not null but userAccount.Id is null
        final Boolean bIsOrganizationTab = true;
        final Schema.Account userAccount = new Schema.Account(Id = accountId);

        final String exceptionMessage = 'message' + Crypto.getRandomInteger();
        final TestException nonDmlException = new TestException(exceptionMessage);

        final ApexPages.Severity expectedApexPagesSeverity = ApexPages.Severity.Error;
        final String expectedApexPagesSummary = '' + nonDmlException.getMessage();

        final AdminContextExecutionManagerTest.StripInaccessibleAndUpdateMethod stripInaccessibleAndUpdate = new AdminContextExecutionManagerTest.StripInaccessibleAndUpdateMethod();
        {
            // Update stripInaccessibleAndUpdate argument to use inexact equality (==) since a new List<SObject> is passed as the argument
            stripInaccessibleAndUpdate.getParameters()[0]
                .setAssertArgumentHasExactEquality(false);

            stripInaccessibleAndUpdate.records = new List<SObject>{ userAccount };
            // stripInaccessibleAndUpdate returns void

            stripInaccessibleAndUpdate.setExceptionThrownBeforeReturningValue(
                nonDmlException
            );
        }

        final Stub stub = new Stub(new List<Stub.Method>{ stripInaccessibleAndUpdate });

        Test.startTest();

        final CommunityApplicationExtension controller = new CommunityApplicationExtension();
        {
            // Set stubs
            controller.adminContextExecutionManagerInstance = (AdminContextExecutionManager) Test.createStub(
                AdminContextExecutionManager.class,
                stub
            );

            controller.crudFlsServiceInstance = (CrudFlsService) Test.createStub(
                CrudFlsService.class,
                stub
            );

            // Set controller attributes for scenario
            controller.bIsOrganizationTab = bIsOrganizationTab;
            controller.userAccount = userAccount;

            System.assertEquals(
                true,
                controller.bIsOrganizationTab,
                'controller.bIsOrganizationTab should be true'
            );
            System.assertNotEquals(
                null,
                controller.userAccount,
                'controller.userAccount should NOT be null'
            );
            System.assertNotEquals(
                null,
                controller.userAccount.Id,
                'controller.userAccount.Id should NOT be null'
            );
        }

        Exception actualException;
        PageReference actual;

        try {
            actual = controller.saveOrganizationTab();
        } catch (Exception e) {
            actualException = e;
        }

        // stripInaccessibleAndUpdate should have been called.
        stub.assertMethodsCalled();

        System.assertEquals(null, actualException, 'should never throw an Exception');

        System.assertEquals(
            1,
            ApexPages.getMessages().size(),
            'One (1) pexPages.Messages should have been added'
        );

        System.assertEquals(
            expectedApexPagesSeverity,
            ApexPages.getMessages()[0].getSeverity(),
            'ApexPages first message should have expected getSeverity()'
        );

        System.assertEquals(
            expectedApexPagesSummary,
            ApexPages.getMessages()[0].getSummary(),
            'ApexPages first message should have expected getSummary()'
        );

        System.assertEquals(null, actual, 'should always return null');

        Test.stopTest();
    }

    @IsTest
    private static void saveCstPrflRcrdNullCurrentRecord() {
        final SObject objCurrentCustomObjectRecord = null;

        final Stub stub = new Stub(new List<Stub.Method>()); // No methods called

        Test.startTest();
        Test.setCurrentPage(Page.CommunityApplicationInitialized);

        final CommunityApplicationExtension controller = new CommunityApplicationExtension();
        {
            // Set stubs
            controller.adminContextExecutionManagerInstance = (AdminContextExecutionManager) Test.createStub(
                AdminContextExecutionManager.class,
                stub
            );

            controller.crudFlsServiceInstance = (CrudFlsService) Test.createStub(
                CrudFlsService.class,
                stub
            );

            // Set controller attributes for scenario
            controller.objCurrentCustomObjectRecord = objCurrentCustomObjectRecord;
        }

        final Integer dmlStatementsBefore = Limits.getDmlStatements();

        Exception actualException;

        try {
            controller.saveCstPrflRcrd();
        } catch (Exception e) {
            actualException = e;
        }

        final Integer dmlStatementsAfter = Limits.getDmlStatements();

        Test.stopTest();

        stub.assertMethodsCalled();

        System.assertEquals(null, actualException, 'should never throw an Exception');

        System.assertEquals(
            true,
            ApexPages.getMessages().isEmpty(),
            'No ApexPages.Messages should have been added, i.e. ApexPages.getMessages() should be empty'
        );

        System.assertEquals(
            null,
            controller.objCurrentCustomObjectRecord,
            'controller.objCurrentCustomObjectRecord should still be null'
        );

        System.assertEquals(
            dmlStatementsBefore,
            dmlStatementsAfter,
            'No DML should have been called'
        );
    }

    @IsTest
    private static void saveCstPrflRcrdCurrentRecordNullIdNullLookupField() {
        // Requries Account to be created in @TestSetup
        final Id accountId = [SELECT Id FROM Account LIMIT 1][0].Id;

        final SObject objCurrentCustomObjectRecord = new Contact(LastName = 'LastName');
        final Related_List_Controller__c objCurrentCustomProfileTab = new Related_List_Controller__c(
            LookupField__c = Schema.SObjectType.Contact.fields.AccountId.getName()
        );
        final User user = new User(Contact = new Contact(AccountId = accountId));

        // # 775
        final Stub stub = new Stub(new List<Stub.Method>()); // No methods called

        Test.startTest();
        Test.setCurrentPage(Page.CommunityApplicationInitialized);

        final CommunityApplicationExtension controller = new CommunityApplicationExtension();
        {
            // Set stubs
            controller.adminContextExecutionManagerInstance = (AdminContextExecutionManager) Test.createStub(
                AdminContextExecutionManager.class,
                stub
            );

            controller.crudFlsServiceInstance = (CrudFlsService) Test.createStub(
                CrudFlsService.class,
                stub
            );

            // Set controller attributes for scenario
            controller.objCurrentCustomObjectRecord = objCurrentCustomObjectRecord;
            controller.objCurrentCustomProfileTab = objCurrentCustomProfileTab;
        }

        final Integer dmlStatementsBefore = Limits.getDmlStatements();

        Exception actualException;

        try {
            controller.saveCstPrflRcrd();
        } catch (Exception e) {
            actualException = e;
        }

        final Integer dmlStatementsAfter = Limits.getDmlStatements();

        Test.stopTest();

        stub.assertMethodsCalled();

        System.assertEquals(null, actualException, 'should never throw an Exception');

        System.assertEquals(
            true,
            ApexPages.getMessages().isEmpty(),
            'No ApexPages.Messages should have been added, i.e. ApexPages.getMessages() should be empty'
        );

        System.assertEquals(
            null,
            controller.objCurrentCustomObjectRecord,
            'controller.objCurrentCustomObjectRecord should equal null since controller.cancelViewRecords() should have been called which sets controller.objCurrentCustomObjectRecord as null'
        );

        System.assertNotEquals(
            null,
            objCurrentCustomObjectRecord,
            'objCurrentCustomObjectRecord should NOT equal null'
        );

        System.assertNotEquals(
            null,
            objCurrentCustomObjectRecord.get('Id'),
            'objCurrentCustomObjectRecord should have been inserted since objectCurrentCustomObjectRecord shared the same memory location (===) as controller.objCurrentCustomObjectRecord before controller.objCurrentCustomObjectRecord was set to null in controller.cancelViewRecords()'
        );

        System.assertNotEquals(
            accountId,
            (Id) objCurrentCustomObjectRecord.get(
                objCurrentCustomProfileTab.LookupField__c
            ),
            'objCurrentCustomObjectRecord.get(objCurrentCustomProfileTab.LookupField__c) should have been set as accountId since objectCurrentCustomObjectRecord shared the same memory location (===) as controller.objCurrentCustomObjectRecord before controller.objCurrentCustomObjectRecord was set to null in controller.cancelViewRecords()'
        );

        System.assertEquals(
            dmlStatementsBefore + 1,
            dmlStatementsAfter,
            'One DML should have been called'
        );
    }

    @IsTest
    private static void saveCstPrflRcrdCurrentRecordWithId() {
        final String newFirstCharacter = '!';

        // Requries Contact to be created in @TestSetup
        final Contact objCurrentCustomObjectRecord = [
            SELECT Id, FirstName
            FROM Contact
            WHERE NOT FirstName LIKE :(newFirstCharacter + '%')
            LIMIT 1
        ][0];

        // Set objCurrentCustomObjectRecord Field to be different to prove we updated
        {
            objCurrentCustomObjectRecord.FirstName = (newFirstCharacter +
                objCurrentCustomObjectRecord.FirstName)
                .left(Schema.SObjectType.Contact.fields.FirstName.getLength());
        }

        final CrudFlsServiceTest.StripInaccessibleForUpdateMethod stripInaccessibleForUpdate = new CrudFlsServiceTest.StripInaccessibleForUpdateMethod();
        {
            // Update argument to use inexact equality (==) since saveCstPrflRcrd constructs a new List<SObject> to pass in
            stripInaccessibleForUpdate.getParameters()[0]
                .setAssertArgumentHasExactEquality(false);

            stripInaccessibleForUpdate.records = new List<Contact>{
                objCurrentCustomObjectRecord
            };

            stripInaccessibleForUpdate.returnValue = stripInaccessibleForUpdate.records;
        }

        // # 775
        final Stub stub = new Stub(new List<Stub.Method>{ stripInaccessibleForUpdate });

        Test.startTest();
        Test.setCurrentPage(Page.CommunityApplicationInitialized);

        final CommunityApplicationExtension controller = new CommunityApplicationExtension();
        {
            // Set stubs
            controller.adminContextExecutionManagerInstance = (AdminContextExecutionManager) Test.createStub(
                AdminContextExecutionManager.class,
                stub
            );

            controller.crudFlsServiceInstance = (CrudFlsService) Test.createStub(
                CrudFlsService.class,
                stub
            );

            // Set controller attributes for scenario
            controller.objCurrentCustomObjectRecord = objCurrentCustomObjectRecord;
        }

        final Integer dmlStatementsBefore = Limits.getDmlStatements();

        Exception actualException;

        try {
            controller.saveCstPrflRcrd();
        } catch (Exception e) {
            actualException = e;
        }

        final Integer dmlStatementsAfter = Limits.getDmlStatements();

        Test.stopTest();

        stub.assertMethodsCalled();

        System.assertEquals(null, actualException, 'should never throw an Exception');

        System.assertEquals(
            true,
            ApexPages.getMessages().isEmpty(),
            'No ApexPages.Messages should have been added, i.e. ApexPages.getMessages() should be empty'
        );

        System.assertEquals(
            null,
            controller.objCurrentCustomObjectRecord,
            'controller.objCurrentCustomObjectRecord should equal null since controller.cancelViewRecords() should have been called which sets controller.objCurrentCustomObjectRecord as null'
        );

        System.assertNotEquals(
            null,
            objCurrentCustomObjectRecord,
            'objCurrentCustomObjectRecord should NOT equal null'
        );

        System.assertEquals(
            dmlStatementsBefore + 1,
            dmlStatementsAfter,
            'One DML should have been called'
        );

        System.assertEquals(
            false,
            [
                    SELECT Id
                    FROM Contact
                    WHERE
                        Id = :objCurrentCustomObjectRecord.Id
                        AND FirstName = :objCurrentCustomObjectRecord.FirstName
                    LIMIT 1
                ]
                .isEmpty(),
            'objCurrentCustomObjectRecord should have been updated'
        );
    }

    @IsTest
    private static void CommunityApplicationExtension() {
        List<User> lstSysAdminUsers = [
            SELECT Id
            FROM User
            WHERE Profile.Name = 'System Administrator' AND IsActive = true
        ];

        CommunitySetting__c communitySetting = new CommunitySetting__c();
        communitySetting.Name = 'ShowInquiryAttachmentTabToGrantee';
        communitySetting.IsEnabled__c = true;
        insert communitySetting;

        // Accounts
        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        account.OwnerId = lstSysAdminUsers[0].Id;
        Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(
            new List<Account>{ account }
        );

        // Contacts
        Contact contact = TestsObjectProvider.CreateContact(
            'testContact1',
            'testContact1',
            ResultAccount[0].Id,
            'test@test1.com'
        );
        contact.FGM_Portal__Confirm_Email__c = 'test@test1.com';
        contact.MailingStreet = 'baker';
        contact.MailingCity = 'NY';
        contact.MailingCountry = 'United States';
        contact.MailingState = 'New York';
        //contact.MailingAddress='United States,New York,NY,baker';
        Database.SaveResult[] ResultContact = TestsObjectProvider.InsertListWithAssert(
            new List<Contact>{ contact }
        );
        Contact contact2 = TestsObjectProvider.CreateContact(
            'Contact FN 2',
            'Contact LN 2',
            ResultAccount[0].Id,
            'test@test2.com'
        );
        contact2.FGM_Portal__Confirm_Email__c = 'test@test1.com';
        contact2.MailingStreet = 'baker';
        contact2.MailingCity = 'NY';
        contact2.MailingCountry = 'United States';
        contact2.MailingState = 'New York';
        //contact.MailingAddress='United States,New York,NY,baker';
        Database.SaveResult[] ResultContact2 = TestsObjectProvider.InsertListWithAssert(
            new List<Contact>{ contact2 }
        );

        Opportunity opportunity1 = TestsObjectProvider.CreateOpportunity(
            'Test1',
            'In Progess',
            Date.today()
        );
        Database.SaveResult[] ResultOpportunity1 = TestsObjectProvider.InsertListWithAssert(
            new List<Opportunity>{ opportunity1 }
        );

        OpportunityContactRole OppContactRole = new OpportunityContactRole();
        OppContactRole.ContactId = ResultContact2[0].Id;
        OppContactRole.IsPrimary = false;
        OppContactRole.OpportunityId = ResultOpportunity1[0].Id;
        OppContactRole.Role = 'Business User';
        insert OppContactRole;
        OpportunityContactRole OppContactRole2 = new OpportunityContactRole();
        OppContactRole2.ContactId = ResultContact2[0].Id;
        OppContactRole2.IsPrimary = false;
        OppContactRole2.OpportunityId = ResultOpportunity1[0].Id;
        OppContactRole2.Role = 'Decision Maker';
        insert OppContactRole2;
        OpportunityContactRole OppContactRole3 = new OpportunityContactRole();
        OppContactRole3.ContactId = ResultContact2[0].Id;
        OppContactRole3.IsPrimary = false;
        OppContactRole3.OpportunityId = ResultOpportunity1[0].Id;
        OppContactRole3.Role = 'Economic Buyer';
        insert OppContactRole3;

        List<OpportunityContactRole> lstContactRoles = new List<OpportunityContactRole>();
        lstContactRoles.add(OppContactRole);
        lstContactRoles.add(OppContactRole2);
        lstContactRoles.add(OppContactRole3);

        // Users
        User user1 = TestsObjectProvider.CreateUser(
            ResultContact[0].Id,
            'test@test2.com',
            'testUser2',
            'testUser2',
            'test1@osftest.com',
            true,
            'FC Community Users Profile',
            account.Name
        );
        user1.ProfileType__c = 'individual';
        user1.UserProfile__c = 'Grantee';
        Database.SaveResult[] ResultUser1 = TestsObjectProvider.InsertListWithAssert(
            new List<User>{ user1 }
        );

        User user2 = TestsObjectProvider.CreateUser(
            ResultContact2[0].Id,
            'test@test3.com',
            'testUser3',
            'testUser3',
            'test3@osftest.com',
            true,
            'FC Community Users Profile',
            account.Name
        );
        user2.ProfileType__c = 'individual';
        user2.UserProfile__c = 'Consultant';
        Database.SaveResult[] ResultUser2 = TestsObjectProvider.InsertListWithAssert(
            new List<User>{ user2 }
        );

        User PortalUser = [
            SELECT Id, ContactId, AccountId
            FROM User
            WHERE Id = :user1.Id
            LIMIT 1
        ];

        // Quiz
        FGM_Portal__Quiz__c FGMPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz(
            'PortalQuiz1',
            'test@test1.com',
            'Page1',
            'Page2',
            'Page3',
            'Page4',
            'Page5',
            'Introduction',
            true
        );
        Database.Saveresult[] ResultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(
            new List<FGM_Portal__Quiz__c>{ FGMPortalQuiz }
        );

        // Campaign
        Campaign campaign = TestsObjectProvider.CreateCampaign(
            'TestCampaign',
            'test@test1.com',
            Date.today(),
            Date.today(),
            ResultFGMPortalQuiz[0].Id,
            'StageName:Submitted,FGM_Base__Duration_Months__c:5,FGM_Base__End_Date__c:8/3/2015,FGM_Base__Amount_Requested__c:100.20'
        );
        Database.Saveresult[] Resultcampaign = TestsObjectProvider.InsertListWithAssert(
            new List<Campaign>{ campaign }
        );

        // Fetching record type info maps
        Map<String, Schema.Recordtypeinfo> newRelatedListRecordTypeMapByName = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe()
            .getRecordTypeInfosByName();
        Map<String, Schema.Recordtypeinfo> newPortalQuestionRecordTypeMapByName = FGM_Portal__Questions__c.SObjectType.getDescribe()
            .getRecordTypeInfosByName();

        // Questions
        List<FGM_Portal__Questions__c> lstFGMPortalQuestion = new List<FGM_Portal__Questions__c>();
        lstFGMPortalQuestion.add(
            TestsObjectProvider.CreateFGMPortalQuestion(
                'SF Data Type',
                '',
                '',
                '',
                'Salesforce Data Type',
                ResultFGMPortalQuiz[0].Id,
                '',
                newPortalQuestionRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                    )
                    .getRecordTypeId()
            )
        );
        lstFGMPortalQuestion.add(
            TestsObjectProvider.CreateFGMPortalQuestion(
                'Attachment',
                '',
                '',
                '',
                'Attachment',
                ResultFGMPortalQuiz[0].Id,
                'Name+FileName',
                newPortalQuestionRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                    )
                    .getRecordTypeId()
            )
        );
        lstFGMPortalQuestion.add(
            TestsObjectProvider.CreateFGMPortalQuestion(
                'Amount',
                '',
                '',
                '',
                'Salesforce Data Type',
                ResultFGMPortalQuiz[0].Id,
                '',
                newPortalQuestionRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                    )
                    .getRecordTypeId()
            )
        );
        Database.Saveresult[] ResultFGMPortalQuestion = TestsObjectProvider.InsertListWithAssert(
            lstFGMPortalQuestion
        );

        // Related List Controllers
        List<FGM_Portal__Related_List_Controller__c> lstFGMPortaRelatedListControllerForTab = new List<FGM_Portal__Related_List_Controller__c>();
        lstFGMPortaRelatedListControllerForTab.add(
            TestsObjectProvider.CreateFGMPortalRelatedListController(
                'RelatedListName4',
                'Grantee',
                'Dashboard',
                'Opportunity',
                'Opportunity',
                'Opportunity',
                'Matching or Challenge Support Formula,Duration in Years',
                'Location_of_Sponsorship_Opportunity__c,Duration_in_Years__c',
                newRelatedListRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB
                    )
                    .getRecordTypeId(),
                ResultFGMPortalQuiz[0].Id
            )
        );
        lstFGMPortaRelatedListControllerForTab[0].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortaRelatedListControllerForTab.add(
            TestsObjectProvider.CreateFGMPortalRelatedListController(
                'RelatedListName5',
                'Grantee',
                'Dashboard',
                'OpportunityTeamMember',
                'Opportunity',
                'OpportunityId',
                'Role',
                'TeamMemberRole',
                newRelatedListRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB
                    )
                    .getRecordTypeId(),
                ResultFGMPortalQuiz[0].Id
            )
        );
        lstFGMPortaRelatedListControllerForTab[1].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortaRelatedListControllerForTab.add(
            TestsObjectProvider.CreateFGMPortalRelatedListController(
                'Budget Details',
                'Grantee',
                'Dashboard',
                'FGM_Portal__Grantee_Budget_Configuration',
                'Opportunity',
                'FGM_Portal__Grantee_Budget_Configuration',
                'Matching or Challenge Support Formula,Duration in Years',
                'Location_of_Sponsorship_Opportunity__c,Duration_in_Years__c',
                newRelatedListRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_GRANTEEBUDGETTAB
                    )
                    .getRecordTypeId(),
                ResultFGMPortalQuiz[0].Id
            )
        );
        lstFGMPortaRelatedListControllerForTab[2].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortaRelatedListControllerForTab.add(
            TestsObjectProvider.CreateFGMPortalRelatedListController(
                'iFrame Tab',
                'Grantee',
                'Dashboard',
                'none',
                'Opportunity',
                'none',
                'test, field, headers',
                'test, field, columns',
                newRelatedListRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_IFRAMETAB
                    )
                    .getRecordTypeId(),
                ResultFGMPortalQuiz[0].Id
            )
        );
        lstFGMPortaRelatedListControllerForTab[3].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortaRelatedListControllerForTab[3]
            .FGM_Portal__BaseUrl__c = 'https://test/DynamicIFrameTest?id={Opportunity.ID}&StageName={OPPORTUNITY.StageName1}&NAME={OPPORTUNITY.name}';
        lstFGMPortaRelatedListControllerForTab.add(
            TestsObjectProvider.CreateFGMPortalRelatedListController(
                'Contact Tab',
                'Grantee',
                'Dashboard',
                'none',
                'Opportunity',
                'none',
                'test, field, headers',
                'test, field, columns',
                newRelatedListRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_CONTACTTAB
                    )
                    .getRecordTypeId(),
                ResultFGMPortalQuiz[0].Id
            )
        );
        lstFGMPortaRelatedListControllerForTab[4].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortaRelatedListControllerForTab.add(
            TestsObjectProvider.CreateFGMPortalRelatedListController(
                'Org Tab',
                'Grantee',
                'Dashboard',
                'none',
                'Opportunity',
                'none',
                'test, field, headers',
                'test, field, columns',
                newRelatedListRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_ORGANIZATIONTAB
                    )
                    .getRecordTypeId(),
                ResultFGMPortalQuiz[0].Id
            )
        );
        lstFGMPortaRelatedListControllerForTab[5].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortaRelatedListControllerForTab.add(
            TestsObjectProvider.CreateFGMPortalRelatedListController(
                'Inquiry Attachments',
                'Grantee',
                'Dashboard',
                'none',
                'Opportunity',
                'none',
                'test, field, headers',
                'test, field, columns',
                newRelatedListRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_ORGANIZATIONTAB
                    )
                    .getRecordTypeId(),
                ResultFGMPortalQuiz[0].Id
            )
        );
        lstFGMPortaRelatedListControllerForTab[6].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortaRelatedListControllerForTab.add(
            TestsObjectProvider.CreateFGMPortalRelatedListController(
                'OTM Tab',
                'Grantee',
                'Related List',
                'Opportunity Team Member',
                'opportunity',
                'OpportunityId',
                'Opportunity Id, TeamRole',
                'OpportunityId,TeamMemberRole',
                newRelatedListRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB
                    )
                    .getRecordTypeId(),
                ResultFGMPortalQuiz[0].Id
            )
        );
        lstFGMPortaRelatedListControllerForTab[7].FGM_Portal__IsCommunityRecord__c = true;
        Database.Saveresult[] ResultListControllerForTabs = TestsObjectProvider.InsertListWithAssert(
            lstFGMPortaRelatedListControllerForTab
        );
        Database.Saveresult ResultListControllerForTabId = ResultListControllerForTabs[0];

        // Quiz Questions
        List<FGM_Portal__Quiz_Questions__c> lstFGMPortalQuizQuestion = new List<FGM_Portal__Quiz_Questions__c>();
        FGM_Portal__Quiz_Questions__c quizQuestion = TestsObjectProvider.CreateFGMPortalQuizQuestion(
            ResultFGMPortalQuestion[0].Id,
            1,
            'Name',
            '',
            50,
            '1',
            ResultListControllerForTabId.Id,
            false,
            ResultFGMPortalQuiz[0].Id
        );
        quizQuestion.FGM_Portal__Can_upload_after_submission__c = true;
        lstFGMPortalQuizQuestion.add(quizQuestion);
        lstFGMPortalQuizQuestion.add(
            TestsObjectProvider.CreateFGMPortalQuizQuestion(
                ResultFGMPortalQuestion[1].Id,
                1,
                'Name',
                '',
                50,
                '1',
                ResultListControllerForTabId.Id,
                true,
                ResultFGMPortalQuiz[0].Id
            )
        );
        lstFGMPortalQuizQuestion.add(
            TestsObjectProvider.CreateFGMPortalQuizQuestion(
                ResultFGMPortalQuestion[2].Id,
                1,
                'Name',
                '',
                50,
                '1',
                ResultListControllerForTabId.Id,
                true,
                ResultFGMPortalQuiz[0].Id
            )
        );
        Database.Saveresult[] ResultsFGMPortalQuizQuestion = TestsObjectProvider.InsertListWithAssert(
            lstFGMPortalQuizQuestion
        );
        lstFGMPortaRelatedListControllerForTab[0]
            .Quiz_Questions__r.addAll(lstFGMPortalQuizQuestion);

        // Question Attachments
        FGM_Portal__Question_Attachment__c questionAttachment = new FGM_Portal__Question_Attachment__c();
        questionAttachment.FGM_Portal__Question__c = ResultFGMPortalQuestion[1].Id;
        questionAttachment.FGM_Portal__Description__c = 'Test Description';
        Database.SaveResult svRslt = Database.insert(questionAttachment);

        Attachment attachmentOne = new Attachment();
        attachmentOne.Body = Blob.valueOf('attachmentOne');
        attachmentOne.Name = 'attachmentOne';
        attachmentOne.ParentId = questionAttachment.Id;
        insert attachmentOne;
        system.assertNotEquals(attachmentOne.Id, null);

        FeedItem FeedOne = new FeedItem();
        FeedOne.ParentId = questionAttachment.Id;
        FeedOne.Body = 'FeedattachmentOne';
        FeedOne.Title = 'test';
        insert FeedOne;

        String cstmPrflTbRcrdType = newRelatedListRecordTypeMapByName.get(
                'Custom Profile Tab'
            )
            .getRecordTypeId();
        String stdPrflTbRcrdType = newRelatedListRecordTypeMapByName.get(
                'Related List With Tab'
            )
            .getRecordTypeId();

        FGM_Portal__Related_List_Controller__c rlcRec_1 = new FGM_Portal__Related_List_Controller__c();
        rlcRec_1.RecordTypeId = stdPrflTbRcrdType;
        rlcRec_1.Name = 'Amendments';
        rlcRec_1.FGM_Portal__ObjectName__c = 'FGM_Portal__Amendment__c';
        rlcRec_1.FGM_Portal__ParentObject__c = 'Account';
        rlcRec_1.FGM_Portal__LookupField__c = 'FGM_Portal__Account__c';
        rlcRec_1.FGM_Portal__Associated_FC_Portal_Type__c = 'Grantee';
        rlcRec_1.FGM_Portal__Associated_Tab_Type__c = 'Profile';
        rlcRec_1.FGM_Portal__Language__c = 'en_US';
        rlcRec_1.FGM_Portal__FieldNames__c = 'Name,FGM_Portal__StageName__c,FGM_Portal__Phone__c';
        rlcRec_1.FGM_Portal__FieldHeaders__c = 'Name,Stage,Phone';
        rlcRec_1.FGM_Portal__IsCommunityRecord__c = true;
        rlcRec_1.FGM_Portal__Hide_Edit_Link__c = false;
        rlcRec_1.FGM_Portal__ShowNewButton__c = true;
        rlcRec_1.FGM_Portal__ShowDeleteLink__c = true;
        insert rlcRec_1;
        System.assertNotEquals(rlcRec_1.Id, null);

        FGM_Portal__Related_List_Controller__c rlcRec_2 = new FGM_Portal__Related_List_Controller__c();
        rlcRec_2.RecordTypeId = cstmPrflTbRcrdType;
        rlcRec_2.Name = 'Amendments Custom';
        rlcRec_2.FGM_Portal__ObjectName__c = 'FGM_Portal__Amendment__c';
        rlcRec_2.FGM_Portal__ParentObject__c = 'Account';
        rlcRec_2.FGM_Portal__LookupField__c = 'FGM_Portal__Account__c';
        rlcRec_2.FGM_Portal__Cloned_from__c = rlcRec_1.Id;
        rlcRec_2.FGM_Portal__Language__c = 'en_US';
        rlcRec_2.FGM_Portal__of_records_to_display__c = 500;
        rlcRec_2.FGM_Portal__IsCommunityRecord__c = true;
        rlcRec_2.FGM_Portal__Quiz__c = ResultFGMPortalQuiz[0].Id;
        insert rlcRec_2;
        System.assertNotEquals(rlcRec_2.Id, null);

        FGM_Portal__Grantee_Budget_Category__c FGMGranteeBudgetCategory = TestsObjectProvider.CreateGranteeBudgetCategory(
            'Grantee Budget Category 1'
        );
        Database.Saveresult[] ResultFGMPortalGBCategory = TestsObjectProvider.InsertListWithAssert(
            new List<FGM_Portal__Grantee_Budget_Category__c>{ FGMGranteeBudgetCategory }
        );

        FGM_Portal__Grantee_Budget_Configuration__c objGranteeBudgetConfi = TestsObjectProvider.CreateGranteeBudgetConfig(
            ResultFGMPortalQuiz[0].Id
        );
        objGranteeBudgetConfi.FGM_Portal__Related_List_Controller__c = ResultListControllerForTabs[0]
            .Id;
        objGranteeBudgetConfi.FGM_Portal__Category__c = ResultFGMPortalGBCategory[0].Id;
        objGranteeBudgetConfi.FGM_Portal__Sort_Order__c = 1;
        Database.Saveresult[] ResultFGMPortalGBConf = TestsObjectProvider.InsertListWithAssert(
            new List<FGM_Portal__Grantee_Budget_Configuration__c>{ objGranteeBudgetConfi }
        );

        System.runAs(user1) {
            List<FGM_Portal__Portal_User__c> lstPortalUser = new List<FGM_Portal__Portal_User__c>();
            lstPortalUser.add(
                TestSObjectProvider.CreateFGMPortalUser(
                    null,
                    'test@fc-community-developer-edition.na17.force.com',
                    'Portal LastName',
                    'test@test1.com',
                    'test@test1.com',
                    'test@osf-communities-developer-edition.na17.force.com',
                    'Test1234',
                    'Test1234',
                    true
                )
            );
            lstPortalUser[0].Account__c = PortalUser.AccountId;
            lstPortalUser[0].FGM_Portal__Contact__c = PortalUser.ContactId;
            Database.Saveresult[] ResultFGMPortalUser = TestsObjectProvider.InsertListWithAssert(
                lstPortalUser
            );

            ApexPages.StandardController scCampaign = new ApexPages.standardController(
                campaign
            );

            CommunityApplicationExtension communityAppli = new CommunityApplicationExtension(
                scCampaign
            );
            ApexPages.currentPage().getParameters().put('Id', Resultcampaign[0].Id);
            ApexPages.currentPage()
                .getParameters()
                .put('quizId', ResultFGMPortalQuiz[0].Id);
            communityAppli.initialize();
            communityAppli.SaveRecord();
            communityAppli.application = opportunity1;

            OpportunityContactRole oppConRole = new OpportunityContactRole();
            oppConRole.ContactId = user1.ContactId;
            oppConRole.IsPrimary = false;
            oppConRole.OpportunityId = (Id) communityAppli.application.get('id');
            oppConRole.Role = 'Economic Buyer';
            //insert oppConRole;

            communityAppli.bIsOrganizationTab = true;
            //communityAppli.getOrganizationRecord();
            Boolean isOrgEditable = communityAppli.IsOrgNameEditable;
            communityAppli.SaveOrganizationTab();
            //communityAppli.CancelOrganizationTab();
            communityAppli.SaveOrganizationTabAndNext();

            communityAppli.bIsContactTab = true;
            //communityAppli.getContactRecord();
            Contact newContact = communityAppli.userContact;
            communityAppli.SaveContactTab();
            //communityAppli.CancelContactTab();
            //communityAppli.redirectUsertoLanding();
            //communityAppli.SaveContactTabAndNext();

            Pagereference CommunityAppliPageReference = Page.CommunityApplication;
            Test.setCurrentPageReference(CommunityAppliPageReference);
            ApexPages.currentPage()
                .getParameters()
                .put('tabId', lstFGMPortaRelatedListControllerForTab[0].Id);

            //upload Attachment

            system.assertNotEquals(communityAppli.application.get('id'), null);

            questionAttachment.Opportunity__c = (Id) communityAppli.application.get('id');
            //update questionAttachment;
            CommunityApplicationExtension.ApplicationAttachments applicationAttachments = new CommunityApplicationExtension.ApplicationAttachments();
            Map<String, CommunityApplicationExtension.ApplicationAttachments> mapApplicationAttachments = new Map<String, CommunityApplicationExtension.ApplicationAttachments>();
            ApexPages.currentPage()
                .getParameters()
                .put('attachedQuestionId', lstFGMPortalQuestion[1].Id);
            //communityAppli.initializeAttachment();
            communityAppli.quizQuestionList = new List<Quiz_Questions__c>();
            communityAppli.quizQuestionList.addAll(lstFGMPortalQuizQuestion);
            mapApplicationAttachments.put(
                lstFGMPortalQuestion[1].Id,
                applicationAttachments
            );
            communityAppli.mapApplicationAttachments = mapApplicationAttachments;
            communityAppli.mapApplicationAttachments.put(
                lstFGMPortalQuestion[1].Id,
                applicationAttachments
            );

            //communityAppli.submit();

            ApexPages.currentPage()
                .getParameters()
                .put('tabId', lstFGMPortaRelatedListControllerForTab[0].Id);
            communityAppli.initializeQuizQuestionList();
            //delete Attachment
            if (
                ResultFGMPortalQuestion != null && !ResultFGMPortalQuestion.isEmpty() &&
                communityAppli.mapApplicationAttachments != null &&
                !communityAppli.mapApplicationAttachments.isEmpty()
            ) {
                Map<String, Sobject> mapOldAttachments = communityAppli.mapApplicationAttachments.get(
                        String.valueOf(ResultFGMPortalQuestion[1].Id)
                    )
                    .mapOldAttachments;
                if (mapOldAttachments != null) {
                    List<String> lstAttachmentIdToDelete = new List<String>(
                        mapOldAttachments.keySet()
                    );
                    if (
                        lstAttachmentIdToDelete != null &&
                        lstAttachmentIdToDelete.size() > 0
                    ) {
                        ApexPages.currentPage()
                            .getParameters()
                            .put('attachedQuestionId', svRslt.Id);
                        ApexPages.currentPage()
                            .getParameters()
                            .put('attachedId', lstAttachmentIdToDelete[0]);
                        // communityAppli.deleteAttachment();
                    }
                }
            }
            Attachment scanAttachment = new Attachment();
            scanAttachment.Body = Blob.valueOf('test data');
            scanAttachment.Name = 'test.txt';

            if (
                ResultFGMPortalQuestion != null && !ResultFGMPortalQuestion.isEmpty() &&
                communityAppli.mapApplicationFeedAttachments != null &&
                !communityAppli.mapApplicationFeedAttachments.isEmpty()
            ) {
                Attachment feedAttachment = TestsObjectProvider.CreateAttachment(
                    'TestAttachment',
                    ResultFGMPortalQuestion[1].Id
                );
                communityAppli.mapApplicationFeedAttachments.get(
                        String.valueOf(ResultFGMPortalQuestion[1].Id)
                    )
                    .newAttachment = feedAttachment;
                ApexPages.currentPage()
                    .getParameters()
                    .put('attachedQuestionId', ResultFGMPortalQuestion[1].Id);
                ApexPages.currentPage()
                    .getParameters()
                    .put('attachedId', feedAttachment.Id);
            }

            communityAppli.SaveAndNext();
            communityAppli.tabObject = communityAppli.application;
            ApexPages.currentPage().getParameters().put('id', ResultFGMPortalQuiz[0].Id);
            communityAppli.SaveBeforeReviewSubmit();
            communityAppli.openOpportunityTeamMemberPopup();
            communityAppli.newOpportunityMemberPortalUser.FGM_Portal__Email__c = 'test@abc.com';
            communityAppli.newOpportunityMemberPortalUser.FGM_Portal__LastName__c = 'Test Last Name';
            communityAppli.newOpportunityMemberPortalUser.GrantedPortalAccess__c = true;
            PortalUserRequestTeamMembers__c portalUserMemeber = TestsObjectProvider.CreatePortalUserRequestTeamMembers(
                'All',
                false,
                ResultFGMPortalUser[0].Id,
                communityAppli.application.Id,
                'Business User'
            );
            //TestsObjectProvider.InsertListWithAssert(new List<PortalUserRequestTeamMembers__c>{portalUserMemeber});
            communityAppli.newOpportunityMemberPortalUser.Id = ResultFGMPortalUser[0].Id;
            communityAppli.isConsultant = true;
            communityAppli.saveOpportunityTeamMember();
            communityAppli.newOpportunityMemberPortalUser.Id = null;
            communityAppli.isConsultant = false;
            communityAppli.saveOpportunityTeamMember();
            communityAppli.isConsultant = true;
            communityAppli.saveOpportunityTeamMember();
            ApexPages.currentPage().getParameters().put('recordIndex', '0');
            communityAppli.editOpportunityMember();
            //communityAppli.newOpportunityMemberPortalUser.FGM_Portal__Email__c = 'test@email.com';
            //communityAppli.newOpportunityMemberPortalUser.GrantedPortalAccess__c = true;
            communityAppli.viewOpportunityMember();
            communityAppli.deleteOpportunityMember();
            communityAppli.closeOpportunityTeamMemberPopup();
            // Test For related List record

            communityAppli.backTOrelatedlistView();
            communityAppli.next();
            communityAppli.generateExistingBudget();
            //  communityAppli.setUsrDpndntPrmtrsFrOTM();
            //communityAppli.clearUnsavedChanges();
            communityAppli.getJSONApp();

            // Test methods for Review and Submit Page
            test.StartTest();
            CommunityApplicationExtension communityAppliReview = new CommunityApplicationExtension(
                scCampaign
            );
            Pagereference CommunityAppliReviewPageReference = Page.CommunityApplicationReview;
            Test.setCurrentPageReference(CommunityAppliPageReference);
            ApexPages.currentPage()
                .getParameters()
                .put('quizId', campaign.Application_Quiz__c);
            ApexPages.currentPage()
                .getParameters()
                .put('appID', communityAppli.application.Id);
            FGM_Portal__CustomHTML__c customHtmlForApplicationReview = new FGM_Portal__CustomHTML__c(
                Name = 'GranteeApplicationReview',
                FGM_Portal__Associated_FC_Portal_Type__c = 'Grantee',
                FGM_Portal__Language__c = 'en_US'
            );
            insert customHtmlForApplicationReview;
            // communityAppliReview.initializeReview();
            CustomHTML__c strCustomHtml = communityAppliReview.getCustomHTMLDescription();
            communityAppli.redirectTo(null);
            communityAppli.redirectUser();
            communityAppli.getApplicationAcessLevelOptions();
            communityAppli.initializeQuizQuestionList();
            communityAppli.currentParentObject = 'Opportunity';
            communityAppli.submit();
            communityAppli.relatedListConfiguration = new CommunityApplicationExtension.relatedList();
            communityAppli.relatedListConfiguration.relatedListLookUp = 'Opportunity';
            communityAppli.relatedListConfiguration.strRelatedListObject = 'OpportunityTeamMember';
            communityAppli.relatedListConfiguration.lstRelatedListRecord = lstFGMPortaRelatedListControllerForTab;
            ApexPages.currentPage().getParameters().put('recordIndex', '1');
            communityAppli.selectedTab = lstFGMPortaRelatedListControllerForTab[7].Id;
            communityAppli.initializeQuizQuestionList();
            communityAppli.SaveRelatedListRecord();
            communityAppli.viewRelatedListRecord();
            communityAppli.editRelatedListRecord();
            communityAppli.deleteRelatedListRecord();
            Boolean IsFileDescriptionEnabled = communityAppli.IsFileDescriptionEnabled;
            //communityAppli.saveOnNextTab();
            //communityAppli.cancelOnNextTab();
            communityAppli.isOpportunity = true;
            communityAppli.applicationConsultant = ResultUser2[0].Id;
            communityAppli.assignToConsultant();
            communityAppli.removeConsultant();

            //Test class coverage for Grantee Budget
            Opportunity opportunity = TestsObjectProvider.CreateOpportunity(
                'testGranteeOpp',
                'Submitted',
                Date.today()
            );
            Opportunity opportunity2 = TestsObjectProvider.CreateOpportunity(
                'testGranteeOpp2',
                'Submitted',
                Date.today()
            );
            Database.Saveresult[] ResultOpportunity = TestsObjectProvider.InsertListWithAssert(
                new List<Opportunity>{ opportunity, opportunity2 }
            );

            FGM_Portal__Grantee_Budget__c FGMGranteeBudget = TestsObjectProvider.CreateGranteeBudget(
                '2015'
            );
            FGM_Portal__Grantee_Budget__c FGMGranteeBudget1 = TestsObjectProvider.CreateGranteeBudget(
                '2016'
            );
            FGM_Portal__Grantee_Budget__c FGMGranteeBudget2 = TestsObjectProvider.CreateGranteeBudget(
                '2017'
            );
            Database.Saveresult[] ResultFGMPortalGB = TestsObjectProvider.InsertListWithAssert(
                new List<FGM_Portal__Grantee_Budget__c>{
                    FGMGranteeBudget,
                    FGMGranteeBudget1,
                    FGMGranteeBudget2
                }
            );

            FGM_Portal__Grantee_Budget_Line_Item__c FGMGranteeBudgetLineItem = TestsObjectProvider.CreateGranteeBudgetLineItem(
                ResultOpportunity[0].Id,
                ResultFGMPortalGB[0].Id
            );
            FGMGranteeBudgetLineItem.FGM_Portal__Category__c = ResultFGMPortalGBCategory[0]
                .Id;

            FGM_Portal__Grantee_Budget_Line_Item__c FGMGranteeBudgetLineItem1 = TestsObjectProvider.CreateGranteeBudgetLineItem(
                ResultOpportunity[1].Id,
                ResultFGMPortalGB[0].Id
            );
            FGMGranteeBudgetLineItem1.FGM_Portal__Category__c = ResultFGMPortalGBCategory[0]
                .Id;

            FGM_Portal__Grantee_Budget_Line_Item__c FGMGranteeBudgetLineItem2 = TestsObjectProvider.CreateGranteeBudgetLineItem(
                ResultOpportunity[0].Id,
                ResultFGMPortalGB[0].Id
            );
            FGMGranteeBudgetLineItem2.FGM_Portal__Category__c = ResultFGMPortalGBCategory[0]
                .Id;

            List<FGM_Portal__Grantee_Budget_Line_Item__c> granteeBudgetLineItem = new List<FGM_Portal__Grantee_Budget_Line_Item__c>{
                FGMGranteeBudgetLineItem,
                FGMGranteeBudgetLineItem1,
                FGMGranteeBudgetLineItem2
            };

            Database.Saveresult[] ResultFGMPortalGBLineItem = TestsObjectProvider.InsertListWithAssert(
                granteeBudgetLineItem
            );

            FGM_Portal__Grantee_Budget_Line_Item__c FGMGranteeBudgetLineItem3 = TestsObjectProvider.CreateGranteeBudgetLineItem(
                ResultOpportunity[0].Id,
                ResultFGMPortalGB[1].Id
            );
            FGMGranteeBudgetLineItem3.FGM_Portal__Category__c = ResultFGMPortalGBCategory[0]
                .Id;

            granteeBudgetLineItem.add(FGMGranteeBudgetLineItem3);

            upsert granteeBudgetLineItem;

            //FGMGranteeBudgetLineItem3.FGM_Portal__Note__c='test';
            // upsert FGMGranteeBudgetLineItem3;
            //

            communityAppli.selectedTab = ResultListControllerForTabs[0].Id;
            communityAppli.generateBudget();
            communityAppli.dateFrom = '01/01/2015';
            communityAppli.dateTo = '01/01/2018';
            communityAppli.generateBudget();
            //communityAppli.getBudgets();
            communityAppli.isBudgetExist = true;
            communityAppli.CancelBudget();
            communityAppli.InsertBudgetLineItem();
            communityAppli.UpdateBudgetLineItem();
            communityAppli.CancelBudget();
            communityAppli.getyears();
            //communityAppli.getBudgets();
            communityAppli.getOppTeamMemberTeamRoleOptions();

            communityAppli.getPartnerUsers();

            communityAppli.getApplicationObjectName();
            //communityAppli.showPopup();
            communityAppli.exitOpenApplication();

            Campaign campaign2 = TestsObjectProvider.CreateCampaign(
                'TestCampaign2',
                'test@test2.com',
                Date.today(),
                Date.today(),
                ResultFGMPortalQuiz[0].Id,
                'StageName:Submitted'
            );
            Database.Saveresult[] Resultcampaign2 = TestsObjectProvider.InsertListWithAssert(
                new List<Campaign>{ campaign2 }
            );
            Lead lead = new Lead();
            //lead.LastName='Test';
            //lead.Company='test';
            //lead.Status='In Progress';
            communityAppli.currentParentObject = 'lead';
            communityAppli.tabObject = lead;

            //communityAppli.SaveRecord();

            FGM_Portal__Amendment__c amendment_1 = new FGM_Portal__Amendment__c();
            FGM_Portal__Amendment__c amendment_2 = new FGM_Portal__Amendment__c();
            FGM_Portal__Amendment__c amendment_3 = new FGM_Portal__Amendment__c();

            List<FGM_Portal__Amendment__c> lstAmendments = new List<FGM_Portal__Amendment__c>{
                amendment_1,
                amendment_2,
                amendment_3
            };
            Database.SaveResult[] dbSvrslt = Database.insert(lstAmendments, false);
            for (Database.SaveResult rslt : dbSvrslt)
                System.assertNotEquals(rslt.getId(), null);

            ApexPages.currentPage().getParameters().put('tabId', rlcRec_2.Id);
            ApexPages.currentPage().getParameters().put('recordIndex', '1');
            ApexPages.currentPage()
                .getParameters()
                .put('quizId', ResultFGMPortalQuiz[0].Id);
            ApexPages.currentPage().getParameters().put('Id', Resultcampaign[0].Id);

            scCampaign = new ApexPages.standardController(campaign);
            communityAppli = new CommunityApplicationExtension(scCampaign);
            communityAppli.initialize();
            communityAppli.SaveRecord();
            communityAppli.saveRecordOnTabChange();
            communityAppli.objCurrentCustomProfileTabParent = rlcRec_2;
            if (communityAppli.objCurrentCustomProfileTabParent != null) {
                communityAppli.selectedTab = communityAppli.objCurrentCustomProfileTabParent.Id;
                communityAppli.getRLCRecordFromMap();
                communityAppli.mapTbIdToMapClnIdnObjRcrds.put(
                    communityAppli.objCurrentCustomProfileTabParent.Id,
                    lstAmendments
                );
            }

            communityAppli.CreateNwCstmPrflRcrd();
            communityAppli.SaveCstPrflRcrd();
            communityAppli.ViewRecord();
            communityAppli.SaveCstPrflRcrd();
            communityAppli.getSelectedTabObject();
            communityAppli.DeleteCstPrflRcrd();
            ApexPages.currentPage().getParameters().put('recordIndex', '3');
            communityAppli.DeleteCstPrflRcrd();

            communityAppli.initializeQuizQuestionList(
                lstFGMPortaRelatedListControllerForTab[3].Id
            );

            communityAppli.openNewContact();
            communityAppli.saveNewContact();
            communityAppli.cancelNewContact();
            communityAppli.currentTabType = 'Portal Tab';
            communityAppli.saveRecordOnTabChange();
            communityAppli.strSelectedappId = '';
            communityAppli.CancelOrganizationTab();
            communityAppli.CancelContactTab();
            communityAppli.cancelGenerateBudget();
            CommunityApplicationExtension.FeedAttachment feedAttachment = new CommunityApplicationExtension.FeedAttachment();
            feedAttachment.strQuestionAttachmentId = '';
            feedAttachment.questionAttachment = new FGM_Portal__Question_Attachment__c();
            communityAppli.quizQuestionList = lstFGMPortalQuizQuestion;
            communityAppli.SaveRecord();
            communityAppli.tabObject = new Account();
            communityAppli.SaveBeforeReviewSubmit();
            communityAppli.currentParentObject = 'Opportunity';
            //test.startTest();
            communityAppli.initializeApplication();
            communityAppli.currentParentObject = 'Lead';
            communityAppli.initializeApplication();
            ApexPages.currentPage().getParameters().put('mode', 'edit');
            communityAppli.mode = 'edit';
            FGM_Portal__PortalConfiguration__c portalConfig = new FGM_Portal__PortalConfiguration__c();
            communityAppli.initializeApplication();
            //communityAppli.portalConfigurationFields=null;
            communityAppli.attachment = attachmentOne;
            communityAppli.isErrorInAttachment = null;
            //communityAppli.JSONapplicationSubmissionData=null;
            //communityAppli.lstLanguageOptions=null;
            // communityAppli.StrNewContactViewIntructions=null;
            communityAppli.strDesc = null;
            //communityAppli.strHiddenValue=null;
            communityAppli.strSelectedId = null;
            communityAppli.strLOICampaignField = null;
            //communityAppli.lstLoggedInUsers=null;
            //communityAppli.MapTabIdCstPrflTbFlds=null;
            communityAppli.quiz.Id = null;
            // communityAppli.initializeTabs();
            //communityAppli.deleteAttachment();
            //communityAppli.backToApplication();
            communityAppli.application = opportunity1;

            communityAppli.getExistingContactRoles();
            communityAppli.getAllOppTeamMemberTeamRoleOptions();
            communityAppli.relatedListConfiguration = new CommunityApplicationExtension.relatedList();
            communityAppli.relatedListConfiguration.strRelatedListObject = 'OpportunityTeamMember';
            ApexPages.currentPage().getParameters().put('userId', user1.Id);
            communityAppli.SaveRelatedListRecord();

            communityAppli.setUsrDpndntPrmtrsFrOTM();
            //test.StopTest();
            Boolean IsTeamRoleREq = communityAppli.IsTeamRoleFieldRequired;
            communityAppli.getUserTypeStatus();
            Set<String> setRolesToExclude = new Set<String>();
            setRolesToExclude.add('Sales Manager');
            communityAppli.getContactRolesConfig(setRolesToExclude);
            communityAppli.urlParamFrom = 'ego';
            communityAppli.cancelApplication();
            communityAppli.application = opportunity1;
            communityAppli.initializeReviewPageList();
            communityAppli.getAccountFields();
            communityAppli.getContactFields();
            ApexPages.currentPage().getParameters().put('SelectedUserType', 'user');
            communityAppli.getUserTypeStatus();
            communityAppli.strIquiryTabName = 'Inquiry Attachments';
            communityAppli.initializeQuizQuestionList(
                lstFGMPortaRelatedListControllerForTab[6].id
            );
            Test.stopTest();
            // CommunityApplicationExtension.getAttachmentComponentSettings( true, 'https://ap1.salesforce.com','en_US','42');
        }
    }

    // Our initialize method should never perform DML or cause DML performed in a chained method. This test will help prevent that
    @IsTest
    private static void pageInitShouldNotPerformDML() {
        User PortalUser = [
            SELECT Id, ContactId, AccountId, Username
            FROM User
            WHERE Username = 'community@user1.com'
            LIMIT 1
        ];
        System.assert(PortalUser != null);

        FGM_Portal__Quiz__c FGMPortalQuiz = [
            SELECT Name, Id
            FROM FGM_Portal__Quiz__c
            WHERE Name = 'ApplicationQuiz 1'
            LIMIT 1
        ];
        System.assert(FGMPortalQuiz != null);

        Campaign campaign = [
            SELECT Id, Name
            FROM Campaign
            WHERE Name = 'TestCampaign1'
            LIMIT 1
        ];
        System.assert(campaign != null);

        Test.startTest();
        System.runAs(PortalUser) {
            ApexPages.StandardController scCampaign = new ApexPages.standardController(
                campaign
            );
            CommunityApplicationExtension communityAppli = new CommunityApplicationExtension(
                scCampaign
            );
            ApexPages.currentPage().getParameters().put('Id', campaign.Id);
            ApexPages.currentPage().getParameters().put('quizId', FGMPortalQuiz.Id);

            //Capture current DML statement number
            Integer preInitDML = Limits.getDmlStatements();
            //perform our main initialize method (which calls many other setup methods)
            communityAppli.initialize();
            //The amount of DML statements should equal the original
            System.assert(preInitDML == Limits.getDmlStatements());
        }
        Test.stopTest();
    }

    @isTest
    private static void TestUploadAttachment() {
        Map<String, Schema.Recordtypeinfo> newRelatedListRecordTypeMapByName = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe()
            .getRecordTypeInfosByName();
        Map<String, Schema.Recordtypeinfo> newPortalQuestionRecordTypeMapByName = FGM_Portal__Questions__c.SObjectType.getDescribe()
            .getRecordTypeInfosByName();

        FGM_Portal__Quiz__c FGMPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz(
            'PortalQuiz1',
            'test@test1.com',
            'Page1',
            'Page2',
            'Page3',
            'Page4',
            'Page5',
            'Introduction',
            true
        );
        Database.Saveresult[] ResultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(
            new List<FGM_Portal__Quiz__c>{ FGMPortalQuiz }
        );

        Campaign campaign = TestsObjectProvider.CreateCampaign(
            'TestCampaign',
            'test@test1.com',
            Date.today(),
            Date.today(),
            ResultFGMPortalQuiz[0].Id,
            'StageName:Submitted,FGM_Base__Duration_Months__c:5,FGM_Base__End_Date__c:8/3/2015,FGM_Base__Amount_Requested__c:100.20'
        );
        Database.Saveresult[] Resultcampaign = TestsObjectProvider.InsertListWithAssert(
            new List<Campaign>{ campaign }
        );

        List<FGM_Portal__Questions__c> lstFGMPortalQuestion = new List<FGM_Portal__Questions__c>();
        lstFGMPortalQuestion.add(
            TestsObjectProvider.CreateFGMPortalQuestion(
                'SF Data Type',
                '',
                '',
                '',
                'Salesforce Data Type',
                ResultFGMPortalQuiz[0].Id,
                '',
                newPortalQuestionRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                    )
                    .getRecordTypeId()
            )
        );
        lstFGMPortalQuestion.add(
            TestsObjectProvider.CreateFGMPortalQuestion(
                'Attachment',
                '',
                '',
                '',
                'Attachment',
                ResultFGMPortalQuiz[0].Id,
                'Name+FileName',
                newPortalQuestionRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                    )
                    .getRecordTypeId()
            )
        );
        lstFGMPortalQuestion.add(
            TestsObjectProvider.CreateFGMPortalQuestion(
                'Amount',
                '',
                '',
                '',
                'Salesforce Data Type',
                ResultFGMPortalQuiz[0].Id,
                '',
                newPortalQuestionRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                    )
                    .getRecordTypeId()
            )
        );
        Database.Saveresult[] ResultFGMPortalQuestion = TestsObjectProvider.InsertListWithAssert(
            lstFGMPortalQuestion
        );

        ApexPages.StandardController controller = new ApexPages.StandardController(
            campaign
        );

        CommunityApplicationExtension objCommunityAppliExt = new CommunityApplicationExtension(
            controller
        );
        if (
            ResultFGMPortalQuestion != null && !ResultFGMPortalQuestion.isEmpty() &&
            objCommunityAppliExt.mapApplicationAttachments != null &&
            !objCommunityAppliExt.mapApplicationAttachments.isEmpty()
        )
            objCommunityAppliExt.mapApplicationAttachments.get(
                    String.valueOf(ResultFGMPortalQuestion[1].Id)
                )
                .newAttachment = TestsObjectProvider.CreateAttachment(
                'TestAttachment',
                ResultFGMPortalQuestion[0].Id
            );

        objCommunityAppliExt.attachedQuestionId = ApexPages.currentPage()
            .getParameters()
            .put('attachedQuestionId', ResultFGMPortalQuestion[0].Id);

        objCommunityAppliExt.openNewContact();
        objCommunityAppliExt.saveNewContact();
        objCommunityAppliExt.cancelNewContact();
        //objCommunityAppliExt.getAttachmentName('FileName-\'testing\'');

        CommunitySetting__c communitySetting = new CommunitySetting__c();
        communitySetting.Name = 'ShowInquiryAttachmentTabToGrantee';
        communitySetting.IsEnabled__c = true;

        FGM_Portal__Related_List_Controller__c rlcRec_1 = new FGM_Portal__Related_List_Controller__c();
        rlcRec_1.RecordTypeId = newRelatedListRecordTypeMapByName.get(
                'Related List With Tab'
            )
            .getRecordTypeId();
        rlcRec_1.Name = 'Amendments';
        rlcRec_1.FGM_Portal__ObjectName__c = 'FGM_Portal__Amendment__c';
        rlcRec_1.FGM_Portal__ParentObject__c = 'Account';
        rlcRec_1.FGM_Portal__LookupField__c = 'FGM_Portal__Account__c';
        rlcRec_1.FGM_Portal__Associated_FC_Portal_Type__c = 'Grantee';
        rlcRec_1.FGM_Portal__Associated_Tab_Type__c = 'Profile';
        rlcRec_1.FGM_Portal__Language__c = 'en_US';
        rlcRec_1.FGM_Portal__FieldNames__c = 'Name,FGM_Portal__StageName__c,FGM_Portal__Phone__c';
        rlcRec_1.FGM_Portal__FieldHeaders__c = 'Name,Stage,Phone';
        rlcRec_1.FGM_Portal__IsCommunityRecord__c = true;
        rlcRec_1.FGM_Portal__Hide_Edit_Link__c = false;
        rlcRec_1.FGM_Portal__ShowNewButton__c = true;
        rlcRec_1.FGM_Portal__ShowDeleteLink__c = true;
        insert rlcRec_1;
        System.assertNotEquals(rlcRec_1.Id, null);
        Campaign campaign2 = TestsObjectProvider.CreateCampaign(
            'TestCampaign2',
            'test@test2.com',
            Date.today(),
            Date.today(),
            ResultFGMPortalQuiz[0].Id,
            'StageName:Submitted'
        );
        Database.Saveresult[] Resultcampaign2 = TestsObjectProvider.InsertListWithAssert(
            new List<Campaign>{ campaign2 }
        );
        ApexPages.StandardController scCampaign = new ApexPages.standardController(
            campaign
        );
        CommunityApplicationExtension communityAppli = new CommunityApplicationExtension(
            scCampaign
        );
        ApexPages.currentPage().getParameters().put('tabId', rlcRec_1.Id);
        ApexPages.currentPage().getParameters().put('recordIndex', '1');
        ApexPages.currentPage().getParameters().put('quizId', null);
        ApexPages.currentPage().getParameters().put('Id', Resultcampaign[0].Id);
        scCampaign = new ApexPages.standardController(campaign);
        communityAppli = new CommunityApplicationExtension(scCampaign);
        communityAppli.initializeQuiz();
        communityAppli.initializeQuizQuestionList();
    }

    @IsTest
    private static void testLeadApplication() {
        Lead lead = new Lead();
        lead.LastName = 'Test';
        lead.Company = 'test';
        lead.Status = 'In Progress';
        lead.FGM_Base__Attachments_to_Request_on_Conversion__c = true;
        insert lead;

        Test.startTest();
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.id);
        LeadStatus convertStatus = [
            SELECT Id, MasterLabel
            FROM LeadStatus
            WHERE IsConverted = true
            LIMIT 1
        ];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        Opportunity opportunity1 = [
            SELECT Id
            FROM Opportunity
            WHERE Id IN (SELECT ConvertedOpportunityId FROM Lead WHERE Id = :lead.Id)
        ];
        update lead;
        Test.stopTest();
        Map<String, Schema.Recordtypeinfo> newRelatedListRecordTypeMapByName = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe()
            .getRecordTypeInfosByName();
        Map<String, Schema.Recordtypeinfo> newPortalQuestionRecordTypeMapByName = FGM_Portal__Questions__c.SObjectType.getDescribe()
            .getRecordTypeInfosByName();

        FGM_Portal__Quiz__c FGMPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz(
            'PortalQuiz1',
            'test@test1.com',
            'Page1',
            'Page2',
            'Page3',
            'Page4',
            'Page5',
            'Introduction',
            true
        );
        Database.Saveresult[] ResultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(
            new List<FGM_Portal__Quiz__c>{ FGMPortalQuiz }
        );

        Campaign campaign = TestsObjectProvider.CreateCampaign(
            'TestCampaign',
            'test@test1.com',
            Date.today(),
            Date.today(),
            ResultFGMPortalQuiz[0].Id,
            'StageName:Submitted,FGM_Base__Duration_Months__c:5,FGM_Base__End_Date__c:8/3/2015,FGM_Base__Amount_Requested__c:100.20'
        );
        Database.Saveresult[] Resultcampaign = TestsObjectProvider.InsertListWithAssert(
            new List<Campaign>{ campaign }
        );

        // Questions
        List<FGM_Portal__Questions__c> lstFGMPortalQuestion = new List<FGM_Portal__Questions__c>();
        lstFGMPortalQuestion.add(
            TestsObjectProvider.CreateFGMPortalQuestion(
                'SF Data Type',
                '',
                '',
                '',
                'Salesforce Data Type',
                ResultFGMPortalQuiz[0].Id,
                '',
                newPortalQuestionRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                    )
                    .getRecordTypeId()
            )
        );
        lstFGMPortalQuestion.add(
            TestsObjectProvider.CreateFGMPortalQuestion(
                'Attachment',
                '',
                '',
                '',
                'Attachment',
                ResultFGMPortalQuiz[0].Id,
                'Name+FileName',
                newPortalQuestionRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                    )
                    .getRecordTypeId()
            )
        );
        lstFGMPortalQuestion.add(
            TestsObjectProvider.CreateFGMPortalQuestion(
                'Amount',
                '',
                '',
                '',
                'Salesforce Data Type',
                ResultFGMPortalQuiz[0].Id,
                '',
                newPortalQuestionRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                    )
                    .getRecordTypeId()
            )
        );
        Database.Saveresult[] ResultFGMPortalQuestion = TestsObjectProvider.InsertListWithAssert(
            lstFGMPortalQuestion
        );

        // Related List Controllers
        List<FGM_Portal__Related_List_Controller__c> lstFGMPortaRelatedListControllerForTab = new List<FGM_Portal__Related_List_Controller__c>();
        lstFGMPortaRelatedListControllerForTab.add(
            TestsObjectProvider.CreateFGMPortalRelatedListController(
                'RelatedListName4',
                'Grantee',
                'Dashboard',
                'Opportunity',
                'Opportunity',
                'Opportunity',
                'Matching or Challenge Support Formula,Duration in Years',
                'Location_of_Sponsorship_Opportunity__c,Duration_in_Years__c',
                newRelatedListRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB
                    )
                    .getRecordTypeId(),
                ResultFGMPortalQuiz[0].Id
            )
        );
        lstFGMPortaRelatedListControllerForTab[0].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortaRelatedListControllerForTab.add(
            TestsObjectProvider.CreateFGMPortalRelatedListController(
                'RelatedListName5',
                'Grantee',
                'Dashboard',
                'OpportunityTeamMember',
                'Opportunity',
                'OpportunityId',
                'Role',
                'TeamMemberRole',
                newRelatedListRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB
                    )
                    .getRecordTypeId(),
                ResultFGMPortalQuiz[0].Id
            )
        );
        lstFGMPortaRelatedListControllerForTab[1].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortaRelatedListControllerForTab.add(
            TestsObjectProvider.CreateFGMPortalRelatedListController(
                'Budget Details',
                'Grantee',
                'Dashboard',
                'FGM_Portal__Grantee_Budget_Configuration',
                'Opportunity',
                'FGM_Portal__Grantee_Budget_Configuration',
                'Matching or Challenge Support Formula,Duration in Years',
                'Location_of_Sponsorship_Opportunity__c,Duration_in_Years__c',
                newRelatedListRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_GRANTEEBUDGETTAB
                    )
                    .getRecordTypeId(),
                ResultFGMPortalQuiz[0].Id
            )
        );
        lstFGMPortaRelatedListControllerForTab[2].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortaRelatedListControllerForTab.add(
            TestsObjectProvider.CreateFGMPortalRelatedListController(
                'iFrame Tab',
                'Grantee',
                'Dashboard',
                'none',
                'Opportunity',
                'none',
                'test, field, headers',
                'test, field, columns',
                newRelatedListRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_IFRAMETAB
                    )
                    .getRecordTypeId(),
                ResultFGMPortalQuiz[0].Id
            )
        );
        lstFGMPortaRelatedListControllerForTab[3].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortaRelatedListControllerForTab[3]
            .FGM_Portal__BaseUrl__c = 'https://test/DynamicIFrameTest?id={Opportunity.ID}&StageName={OPPORTUNITY.StageName1}&NAME={OPPORTUNITY.name}';
        lstFGMPortaRelatedListControllerForTab.add(
            TestsObjectProvider.CreateFGMPortalRelatedListController(
                'Contact Tab',
                'Grantee',
                'Dashboard',
                'none',
                'Opportunity',
                'none',
                'test, field, headers',
                'test, field, columns',
                newRelatedListRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_CONTACTTAB
                    )
                    .getRecordTypeId(),
                ResultFGMPortalQuiz[0].Id
            )
        );
        lstFGMPortaRelatedListControllerForTab[4].FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortaRelatedListControllerForTab.add(
            TestsObjectProvider.CreateFGMPortalRelatedListController(
                'Org Tab',
                'Grantee',
                'Dashboard',
                'none',
                'Opportunity',
                'none',
                'test, field, headers',
                'test, field, columns',
                newRelatedListRecordTypeMapByName.get(
                        TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_ORGANIZATIONTAB
                    )
                    .getRecordTypeId(),
                ResultFGMPortalQuiz[0].Id
            )
        );
        lstFGMPortaRelatedListControllerForTab[5].FGM_Portal__IsCommunityRecord__c = true;
        Database.Saveresult[] ResultListControllerForTabs = TestsObjectProvider.InsertListWithAssert(
            lstFGMPortaRelatedListControllerForTab
        );
        Database.Saveresult ResultListControllerForTabId = ResultListControllerForTabs[0];

        // Quiz Questions
        List<FGM_Portal__Quiz_Questions__c> lstFGMPortalQuizQuestion = new List<FGM_Portal__Quiz_Questions__c>();
        FGM_Portal__Quiz_Questions__c quizQuestion = TestsObjectProvider.CreateFGMPortalQuizQuestion(
            ResultFGMPortalQuestion[0].Id,
            1,
            'Name',
            '',
            50,
            '1',
            ResultListControllerForTabId.Id,
            false,
            ResultFGMPortalQuiz[0].Id
        );
        quizQuestion.FGM_Portal__Can_upload_after_submission__c = true;
        lstFGMPortalQuizQuestion.add(quizQuestion);
        lstFGMPortalQuizQuestion.add(
            TestsObjectProvider.CreateFGMPortalQuizQuestion(
                ResultFGMPortalQuestion[1].Id,
                1,
                'Name',
                '',
                50,
                '1',
                ResultListControllerForTabId.Id,
                true,
                ResultFGMPortalQuiz[0].Id
            )
        );
        lstFGMPortalQuizQuestion.add(
            TestsObjectProvider.CreateFGMPortalQuizQuestion(
                ResultFGMPortalQuestion[2].Id,
                1,
                'Name',
                '',
                50,
                '1',
                ResultListControllerForTabId.Id,
                true,
                ResultFGMPortalQuiz[0].Id
            )
        );
        Database.Saveresult[] ResultsFGMPortalQuizQuestion = TestsObjectProvider.InsertListWithAssert(
            lstFGMPortalQuizQuestion
        );
        lstFGMPortaRelatedListControllerForTab[0]
            .Quiz_Questions__r.addAll(lstFGMPortalQuizQuestion);

        // Question Attachments
        FGM_Portal__Question_Attachment__c questionAttachment = new FGM_Portal__Question_Attachment__c();
        questionAttachment.FGM_Portal__Question__c = ResultFGMPortalQuestion[1].Id;
        questionAttachment.FGM_Portal__Description__c = 'Test Description';
        Database.SaveResult svRslt = Database.insert(questionAttachment);

        Attachment attachmentOne = new Attachment();
        attachmentOne.Body = Blob.valueOf('attachmentOne');
        attachmentOne.Name = 'attachmentOne';
        attachmentOne.ParentId = questionAttachment.Id;
        insert attachmentOne;
        system.assertNotEquals(attachmentOne.Id, null);

        FeedItem FeedOne = new FeedItem();
        FeedOne.ParentId = questionAttachment.Id;
        FeedOne.Body = 'FeedattachmentOne';
        FeedOne.Title = 'test';
        insert FeedOne;

        String cstmPrflTbRcrdType = newRelatedListRecordTypeMapByName.get(
                'Custom Profile Tab'
            )
            .getRecordTypeId();
        String stdPrflTbRcrdType = newRelatedListRecordTypeMapByName.get(
                'Related List With Tab'
            )
            .getRecordTypeId();

        FGM_Portal__Related_List_Controller__c rlcRec_1 = new FGM_Portal__Related_List_Controller__c();
        rlcRec_1.RecordTypeId = stdPrflTbRcrdType;
        rlcRec_1.Name = 'Amendments';
        rlcRec_1.FGM_Portal__ObjectName__c = 'FGM_Portal__Amendment__c';
        rlcRec_1.FGM_Portal__ParentObject__c = 'Account';
        rlcRec_1.FGM_Portal__LookupField__c = 'FGM_Portal__Account__c';
        rlcRec_1.FGM_Portal__Associated_FC_Portal_Type__c = 'Grantee';
        rlcRec_1.FGM_Portal__Associated_Tab_Type__c = 'Profile';
        rlcRec_1.FGM_Portal__Language__c = 'en_US';
        rlcRec_1.FGM_Portal__FieldNames__c = 'Name,FGM_Portal__StageName__c,FGM_Portal__Phone__c';
        rlcRec_1.FGM_Portal__FieldHeaders__c = 'Name,Stage,Phone';
        rlcRec_1.FGM_Portal__IsCommunityRecord__c = true;
        rlcRec_1.FGM_Portal__Hide_Edit_Link__c = false;
        rlcRec_1.FGM_Portal__ShowNewButton__c = true;
        rlcRec_1.FGM_Portal__ShowDeleteLink__c = true;
        insert rlcRec_1;
        System.assertNotEquals(rlcRec_1.Id, null);

        FGM_Portal__Related_List_Controller__c rlcRec_2 = new FGM_Portal__Related_List_Controller__c();
        rlcRec_2.RecordTypeId = cstmPrflTbRcrdType;
        rlcRec_2.Name = 'Amendments Custom';
        rlcRec_2.FGM_Portal__ObjectName__c = 'FGM_Portal__Amendment__c';
        rlcRec_2.FGM_Portal__ParentObject__c = 'Account';
        rlcRec_2.FGM_Portal__LookupField__c = 'FGM_Portal__Account__c';
        rlcRec_2.FGM_Portal__Cloned_from__c = rlcRec_1.Id;
        rlcRec_2.FGM_Portal__Language__c = 'en_US';
        rlcRec_2.FGM_Portal__of_records_to_display__c = 500;
        rlcRec_2.FGM_Portal__IsCommunityRecord__c = true;
        rlcRec_2.FGM_Portal__Quiz__c = ResultFGMPortalQuiz[0].Id;
        insert rlcRec_2;
        System.assertNotEquals(rlcRec_2.Id, null);
        ApexPages.currentPage().getParameters().put('tabId', rlcRec_2.Id);
        ApexPages.currentPage().getParameters().put('recordIndex', '1');
        ApexPages.currentPage().getParameters().put('quizId', ResultFGMPortalQuiz[0].Id);
        ApexPages.currentPage().getParameters().put('Id', Resultcampaign[0].Id);
        ApexPages.currentPage().getParameters().put('appId', opportunity1.Id);
        ApexPages.currentPage().getParameters().put('IsInfected', 'true');
        ApexPages.currentPage().getParameters().put('message', '');
        ApexPages.StandardController scCampaign = new ApexPages.standardController(
            campaign
        );
        CommunityApplicationExtension communityAppli = new CommunityApplicationExtension(
            scCampaign
        );

        //communityAppli.ResultFGMPortalQuiz[0].Id= null;
        //communityAppli.initializeTabs();
        //communityAppli.deleteAttachment();
        //communityAppli.backToApplication();
        communityAppli.application = opportunity1;
        communityAppli.initializeTabs();
        //communityAppli.generateScanMessage();
    }

    public final static string PORTAL_RELATEDLISTCONTROLLER_CUSTOMPROFILETAB = 'Custom Profile Tab';
    public final static string PORTAL_QUIZ_PAGELAYOUT = 'Page Layout';
    public final static string PORTAL_PAGELAYOUT_OPPORTUNITYAMENDMENT = 'Opportunity';

    //For Custom profile tab
    public static FGM_Portal__Related_List_Controller__c CreateFGMPortalRelatedListController(
        string strName,
        string strAssociatedPortalType,
        string strAssociatedTabType,
        string strObjectName,
        string strParentObject,
        string strLookupField,
        string strFieldHeaders,
        string strFieldNames,
        string strRecordTypeId
    ) {
        String DefaultLanguageCode = 'en_US';
        FGM_Portal__Related_List_Controller__c portalRelatedListCont = new FGM_Portal__Related_List_Controller__c();
        portalRelatedListCont.Name = strName;
        portalRelatedListCont.FGM_Portal__Associated_FC_Portal_Type__c = strAssociatedPortalType;
        portalRelatedListCont.FGM_Portal__Associated_Tab_Type__c = strAssociatedTabType;
        portalRelatedListCont.FGM_Portal__ObjectName__c = strObjectName;
        portalRelatedListCont.FGM_Portal__ParentObject__c = strParentObject;
        portalRelatedListCont.FGM_Portal__LookupField__c = strLookupField;
        portalRelatedListCont.FGM_Portal__FieldHeaders__c = strFieldHeaders;
        portalRelatedListCont.FGM_Portal__FieldNames__c = strFieldNames;
        portalRelatedListCont.RecordTypeId = strRecordTypeId;
        portalRelatedListCont.FGM_Portal__Language__c = DefaultLanguageCode;
        return PortalRelatedListCont;
    }

    @TestSetup
    private static void testSetup() {
        try {
            Map<String, Schema.Recordtypeinfo> PortalQuizRecordTypeMap = FGM_Portal__Quiz__c.SObjectType.getDescribe()
                .getRecordTypeInfosByName();
            Map<String, Schema.Recordtypeinfo> relatedListControllerRecordTypeMap = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe()
                .getRecordTypeInfosByName();

            Database.Saveresult[] resultFGMPortalQuiz;
            Database.Saveresult[] resultcampaign;

            Database.Saveresult[] resultFGMPortalQuizForLead;
            Database.Saveresult[] resultcampaignForLead;
            List<User> lstSysAdminUsers;
            Account account;
            Contact contact;
            List<FGM_Portal__Portal_User__c> lstPortalUser;
            test.startTest();
            lstSysAdminUsers = [
                SELECT Id
                FROM User
                WHERE Profile.Name = 'System Administrator' AND IsActive = true
            ];
            //Creating Account Record
            account = TestsObjectProvider.CreateAccount('Sun Micro system');
            account.OwnerId = lstSysAdminUsers[0].Id;
            account.BillingCountry = 'India';
            account.BillingPostalCode = '313213';
            account.BillingCity = 'Pune';
            account.BillingStreet = 'teststreet';
            account.BillingState = 'Maharashtra';
            account.ShippingCountry = 'India';
            account.ShippingState = 'Maharashtra';
            account.ShippingStreet = 'testStreet';
            account.ShippingPostalCode = '413739';
            account.BillingGeocodeAccuracy = 'Address';
            account.BillingLatitude = 18.51957;
            account.BillingLongitude = 73.85535;
            Database.SaveResult[] resultAccount = TestsObjectProvider.InsertListWithAssert(
                new List<Account>{ account }
            );

            //Creating Contact Record
            contact = TestsObjectProvider.CreateContact(
                'Scott',
                'McNealy',
                resultAccount[0].Id,
                'test@contact.test'
            );
            Database.SaveResult[] resultContact = TestsObjectProvider.InsertListWithAssert(
                new List<Contact>{ contact }
            );

            //Creating portal user 1
            lstPortalUser = new List<FGM_Portal__Portal_User__c>();
            lstPortalUser.add(
                TestSObjectProvider.CreateFGMPortalUser(
                    null,
                    'TestPortalUser1',
                    'Test',
                    'test1@test.test',
                    'test2@test.test',
                    'TestUser1',
                    'Test1234',
                    'Test1234',
                    true
                )
            );
            lstPortalUser[0].FGM_Portal__Account__c = account.Id;
            lstPortalUser[0].FGM_Portal__User_Profile__c = 'Individual';

            //Creating portal user 2
            User[] userList = [
                SELECT Id, ContactId, AccountId, FGM_Portal__UserProfile__c
                FROM User
                WHERE Id = :UserInfo.getUserId()
                LIMIT 1
            ];
            lstPortalUser.add(
                TestSObjectProvider.CreateFGMPortalUser(
                    null,
                    'TestPortalUser2',
                    'Test',
                    'test2@test.test',
                    'test2@test.test',
                    'TestUser2',
                    'Test1234',
                    'Test1234',
                    true
                )
            );
            lstPortalUser[1].FGM_Portal__Account__c = userList[0].AccountId;
            lstPortalUser[1].FGM_Portal__User_Profile__c = 'Individual';
            lstPortalUser[1].FGM_Portal__Contact__c = userList[0].ContactId;

            Database.Saveresult[] resultFGMPortalUser = TestsObjectProvider.InsertListWithAssert(
                lstPortalUser
            );

            //Creating Quiz
            FGM_Portal__Quiz__c fGMPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz(
                'ApplicationQuiz 1',
                'test@test.com',
                '',
                '',
                '',
                '',
                '',
                'Introduction',
                true
            );
            fGMPortalQuiz.FGM_Portal__IsCommunityRecord__c = true;
            fGMPortalQuiz.FGM_Portal__Failure_URL__c = '~/apex/CommunitySignupRejected';
            fGMPortalQuiz.RecordTypeId = PortalQuizRecordTypeMap.get(
                    TestsObjectProvider.PORTAL_QUIZ_APPLICATION
                )
                .getRecordTypeId();

            resultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(
                new List<FGM_Portal__Quiz__c>{ fGMPortalQuiz }
            );
            // Users
            contact = TestsObjectProvider.CreateContact(
                'testfirstname',
                'testlastname',
                resultAccount[0].Id,
                'test@contact1.test'
            );
            Database.SaveResult[] resultContact2 = TestsObjectProvider.InsertListWithAssert(
                new List<Contact>{ contact }
            );

            User user1 = TestsObjectProvider.CreateUser(
                resultContact2[0].Id,
                'test@test2.com',
                'testUser2',
                'testUser2',
                'community@user1.com',
                true,
                'FC Community Users Profile',
                account.Name
            );
            user1.FGM_Portal__ProfileType__c = 'individual';
            user1.FGM_Portal__UserProfile__c = 'Grantee';
            Database.SaveResult[] resultUser1 = TestsObjectProvider.InsertListWithAssert(
                new List<User>{ user1 }
            );

            contact = TestsObjectProvider.CreateContact(
                'testfirstname',
                'testlastname',
                resultAccount[0].Id,
                'test@contact3.test'
            );
            Database.SaveResult[] resultContact3 = TestsObjectProvider.InsertListWithAssert(
                new List<Contact>{ contact }
            );

            User user2 = TestsObjectProvider.CreateUser(
                resultContact3[0].Id,
                'test@test3.com',
                'testUser3',
                'testUser3',
                'community@user2.com',
                true,
                'FC Community Users Profile',
                account.Name
            );
            user2.FGM_Portal__ProfileType__c = 'individual';
            user2.FGM_Portal__UserProfile__c = 'Grantee';
            Database.SaveResult[] resultUser2 = TestsObjectProvider.InsertListWithAssert(
                new List<User>{ user2 }
            );

            //creating Opportunity
            System.runAs(user1) {
                Opportunity opportunityForUser1 = TestsObjectProvider.CreateOpportunity(
                    'TestOpportunityForUser1',
                    'Prospecting',
                    Date.today()
                );
                opportunityForUser1.AccountId = account.Id;
                Database.SaveResult[] resultUser1Opportunity = TestsObjectProvider.InsertListWithAssert(
                    new List<Opportunity>{ opportunityForUser1 }
                );
            }

            //Creating All Types of Tab

            List<FGM_Portal__Related_List_Controller__c> lstRelatedListController = new List<FGM_Portal__Related_List_Controller__c>();

            lstRelatedListController.add(
                TestsObjectProvider.CreateFGMPortalRelatedListController(
                    'PORTAL TAB',
                    'Grantee',
                    'Dashboard',
                    'Opportunity',
                    'Opportunity',
                    'Opportunity',
                    '',
                    '',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB
                        )
                        .getRecordTypeId(),
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstRelatedListController[0].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[0].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[0].FGM_Portal__SortOrder__c = 1;

            lstRelatedListController.add(
                TestsObjectProvider.CreateFGMPortalRelatedListController(
                    'RelatedListTab-Recommendation',
                    'Grantee',
                    'Dashboard',
                    'FGM_Portal__Recommendation__c',
                    'Opportunity',
                    'FGM_Portal__Opportunity__c',
                    'NAME,EMAIL',
                    'Name,FGM_Portal__Recommender_Email__c',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB
                        )
                        .getRecordTypeId(),
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstRelatedListController[1].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[1].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[1].FGM_Portal__SortOrder__c = 2;
            lstRelatedListController[1].FGM_Portal__ShowDeleteLink__c = true;
            lstRelatedListController[1].FGM_Portal__ShowNewButton__c = true;
            lstRelatedListController[1].FGM_Portal__SortField__c = 'Name';
            lstRelatedListController[1].FGM_Portal__SortFieldOrder__c = 'Ascending';

            lstRelatedListController.add(
                TestsObjectProvider.CreateFGMPortalRelatedListController(
                    'IFRAME TAB',
                    'Grantee',
                    'Dashboard',
                    'none',
                    'Opportunity',
                    'none',
                    '',
                    '',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_IFRAMETAB
                        )
                        .getRecordTypeId(),
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstRelatedListController[2].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[2].FGM_Portal__SortOrder__c = 3;
            lstRelatedListController[2]
                .FGM_Portal__BaseUrl__c = 'https://test/DynamicIFrameTest?id={Opportunity.ID}&StageName={OPPORTUNITY.Name}&NAME={OPPORTUNITY.name}';

            //Grantee Bugdget Categories
            FGM_Portal__Grantee_Budget_Category__c categoryAdmin = TestsObjectProvider.CreateGranteeBudgetCategory(
                'Admin'
            );
            categoryAdmin.FGM_Portal__Parent_Category__c = null;
            insert categoryAdmin;

            FGM_Portal__Grantee_Budget_Category__c categorySystem = TestsObjectProvider.CreateGranteeBudgetCategory(
                'System Admin'
            );
            categorySystem.FGM_Portal__Parent_Category__c = categoryAdmin.Id;
            insert categorySystem;

            FGM_Portal__Grantee_Budget_Category__c categoryNetwork = TestsObjectProvider.CreateGranteeBudgetCategory(
                'Network Admin'
            );
            categoryNetwork.FGM_Portal__Parent_Category__c = categoryAdmin.Id;
            insert categoryNetwork;

            FGM_Portal__Grantee_Budget_Category__c categoryDeveloper = TestsObjectProvider.CreateGranteeBudgetCategory(
                'Developer'
            );
            categoryDeveloper.FGM_Portal__Parent_Category__c = null;
            insert categoryDeveloper;

            lstRelatedListController.add(
                TestsObjectProvider.CreateFGMPortalRelatedListController(
                    'CONTACT TAB',
                    'Grantee',
                    'Dashboard',
                    'none',
                    'Opportunity',
                    'Opportunity',
                    '',
                    '',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_CONTACTTAB
                        )
                        .getRecordTypeId(),
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstRelatedListController[3].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[3].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[3].FGM_Portal__SortOrder__c = 5;

            lstRelatedListController.add(
                TestsObjectProvider.CreateFGMPortalRelatedListController(
                    'ACCOUNT TAB',
                    'Grantee',
                    'Dashboard',
                    'none',
                    'Opportunity',
                    'Opportunity',
                    '',
                    '',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_ORGANIZATIONTAB
                        )
                        .getRecordTypeId(),
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstRelatedListController[4].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[4].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[4].FGM_Portal__SortOrder__c = 6;

            lstRelatedListController.add(
                TestsObjectProvider.CreateFGMPortalRelatedListController(
                    'RelatedListTab-OTM',
                    'Grantee',
                    'Dashboard',
                    'OpportunityTeamMember',
                    'Opportunity',
                    'OpportunityId',
                    'Role,User Id,Opportunity ID',
                    'TeamMemberRole,UserId,OpportunityId',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB
                        )
                        .getRecordTypeId(),
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstRelatedListController[5].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[5].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[5].FGM_Portal__SortOrder__c = 7;
            lstRelatedListController[5].FGM_Portal__ShowDeleteLink__c = true;
            lstRelatedListController[5].FGM_Portal__ShowNewButton__c = true;

            lstRelatedListController.add(
                CreateFGMPortalRelatedListController(
                    'PROFILE TAB',
                    'Grantee',
                    'Profile',
                    'FGM_Base__Payment__c',
                    'Account',
                    'FGM_Base__Payee__c',
                    'Payment,Amount,Phone',
                    'Name,FGM_Base__Amount__c,FGM_Base__Phone__c',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB
                        )
                        .getRecordTypeId()
                )
            );
            lstRelatedListController[6].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[6].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[6].FGM_Portal__SortOrder__c = 3;
            lstRelatedListController[6].FGM_Portal__ShowDeleteLink__c = true;
            lstRelatedListController[6].FGM_Portal__ShowNewButton__c = true;
            lstRelatedListController[6]
                .FGM_Portal__Show_Tab_to_Organization_Users__c = true;
            lstRelatedListController[6]
                .FGM_Portal__Show_Tab_to_Individual_Users__c = true;

            lstRelatedListController.add(
                TestsObjectProvider.CreateFGMPortalRelatedListController(
                    'GRANTEE BUDGET TAB',
                    'Grantee',
                    'Details',
                    'FGM_Portal__Grantee_Budget__c',
                    'Quiz__c',
                    'FGM_Portal__Grantee_Budget__c',
                    'Field To Be Edited',
                    'Field_To_Be_Edited__c',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_GRANTEEBUDGETTAB
                        )
                        .getRecordTypeId(),
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstRelatedListController[7].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[7].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[7].FGM_Portal__ShowDeleteLink__c = true;
            lstRelatedListController[7].FGM_Portal__ShowNewButton__c = true;
            lstRelatedListController[7].FGM_Portal__SortOrder__c = 4;

            Database.Saveresult[] resultsFGMPortalRelatedListController = TestsObjectProvider.InsertListWithAssert(
                lstRelatedListController
            );
            List<FGM_Portal__Grantee_Budget_Configuration__c> objGranteeBudgetConfiguration = new List<FGM_Portal__Grantee_Budget_Configuration__c>();
            List<FGM_Portal__Grantee_Budget_Category__c> lstBudgetCategories = [
                SELECT Id
                FROM FGM_Portal__Grantee_Budget_Category__c
            ];

            // create Grantee Budget Configuration
            objGranteeBudgetConfiguration.add(
                TestsObjectProvider.CreateGranteeBudgetConfig(resultFGMPortalQuiz[0].Id)
            );
            objGranteeBudgetConfiguration[0]
                .FGM_Portal__Related_List_Controller__c = resultsFGMPortalRelatedListController[7]
                .getId();
            objGranteeBudgetConfiguration[0]
                .FGM_Portal__Category__c = lstBudgetCategories[1].Id;

            objGranteeBudgetConfiguration.add(
                TestsObjectProvider.CreateGranteeBudgetConfig(resultFGMPortalQuiz[0].Id)
            );
            objGranteeBudgetConfiguration[1]
                .FGM_Portal__Related_List_Controller__c = resultsFGMPortalRelatedListController[7]
                .getId();
            objGranteeBudgetConfiguration[1]
                .FGM_Portal__Category__c = lstBudgetCategories[2].Id;

            objGranteeBudgetConfiguration.add(
                TestsObjectProvider.CreateGranteeBudgetConfig(resultFGMPortalQuiz[0].Id)
            );
            objGranteeBudgetConfiguration[2]
                .FGM_Portal__Related_List_Controller__c = resultsFGMPortalRelatedListController[7]
                .getId();
            objGranteeBudgetConfiguration[2]
                .FGM_Portal__Category__c = lstBudgetCategories[3].Id;

            Database.Saveresult[] resultGranteeBudgetConfiguration = TestsObjectProvider.InsertListWithAssert(
                objGranteeBudgetConfiguration
            );

            //creating GranteeBudget Record
            List<FGM_Portal__Grantee_Budget__c> lstGranteeBudget = new List<FGM_Portal__Grantee_Budget__c>();
            lstGranteeBudget.add(TestsObjectProvider.CreateGranteeBudget('2018'));
            lstGranteeBudget.add(TestsObjectProvider.CreateGranteeBudget('2019'));
            lstGranteeBudget.add(TestsObjectProvider.CreateGranteeBudget('2020'));

            Database.Saveresult[] resultsGranteeBudget = TestsObjectProvider.InsertListWithAssert(
                lstGranteeBudget
            );

            FGM_Portal__Related_List_Controller__c objRelatedListController;
            objRelatedListController = TestsObjectProvider.CreateFGMPortalRelatedListController(
                'CUSTOM PROFILE TAB-PAYMENT',
                'Grantee',
                'Details',
                'FGM_Base__Payment__c',
                'Account',
                'FGM_Base__Payee__c',
                'Field To Be Edited',
                'Field_To_Be_Edited__c',
                relatedListControllerRecordTypeMap.get(
                        PORTAL_RELATEDLISTCONTROLLER_CUSTOMPROFILETAB
                    )
                    .getRecordTypeId(),
                resultFGMPortalQuiz[0].Id
            );
            objRelatedListController.FGM_Portal__Language__c = 'en_US';
            objRelatedListController.FGM_Portal__IsCommunityRecord__c = true;
            objRelatedListController.FGM_Portal__SortOrder__c = 8;
            objRelatedListController.FGM_Portal__Cloned_from__c = resultsFGMPortalRelatedListController[6]
                .getId();
            insert objRelatedListController;

            //Question

            Map<String, Schema.Recordtypeinfo> newPortalQuestionRecordTypeMapByName = FGM_Portal__Questions__c.SObjectType.getDescribe()
                .getRecordTypeInfosByName();

            List<FGM_Portal__Questions__c> lstFGMPortalQuestion = new List<FGM_Portal__Questions__c>();
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Name',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Instruction',
                    '',
                    '',
                    '',
                    'Instruction',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Attachment',
                    '',
                    '',
                    '',
                    'Attachment',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );

            //Question For Recommendation
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Applicant Name',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Recommender Full Name',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Email',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );

            //Question For Opportunity Team Member
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Name',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Additional role',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Team Role',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Opportunity Access',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );

            //portal tab (dependent & refrence type questions)
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Dependent',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Refrence',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );

            Database.Saveresult[] resultsFGMPortalQuestion = TestsObjectProvider.InsertListWithAssert(
                lstFGMPortalQuestion
            );

            //QuizQuestion
            List<FGM_Portal__Quiz_Questions__c> lstfGMPortalQuizQuestion = new List<FGM_Portal__Quiz_Questions__c>();
            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[0].Id,
                    1,
                    'Name',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[0].Id,
                    true,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion[0].FGM_Portal__IsCommunityRecord__c = true;
            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[1].Id,
                    1,
                    '',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[0].Id,
                    true,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion[1].FGM_Portal__IsCommunityRecord__c = true;
            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[2].Id,
                    1,
                    '',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[0].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion[2].FGM_Portal__IsCommunityRecord__c = true;

            //QuizQuestion For Recommendation
            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[3].Id,
                    1,
                    'Name',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[1].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion[3].FGM_Portal__IsCommunityRecord__c = true;
            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[4].Id,
                    1,
                    'Recommender_s_Full_Name__c',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[1].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion[4].FGM_Portal__IsCommunityRecord__c = true;
            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[5].Id,
                    1,
                    'FGM_Portal__Recommender_Email__c',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[1].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion[5].FGM_Portal__IsCommunityRecord__c = true;

            //QuizQuestion For Opportunity Team Member
            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[6].Id,
                    1,
                    'Name',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[5].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion[6].FGM_Portal__IsCommunityRecord__c = true;
            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[7].Id,
                    1,
                    'FGM_Portal__Additional_Role__c',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[5].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion[7].FGM_Portal__IsCommunityRecord__c = true;
            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[8].Id,
                    1,
                    'TeamMemberRole',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[5].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion[8].FGM_Portal__IsCommunityRecord__c = true;
            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[9].Id,
                    1,
                    'OpportunityAccessLevel',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[5].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion[9].FGM_Portal__IsCommunityRecord__c = true;

            Database.Saveresult[] resultsfGMPortalQuizQuestion = TestsObjectProvider.InsertListWithAssert(
                lstfGMPortalQuizQuestion
            );

            // Question Attachments
            FGM_Portal__Question_Attachment__c questionAttachment1 = new FGM_Portal__Question_Attachment__c();
            questionAttachment1.FGM_Portal__Question__c = resultsFGMPortalQuestion[2].Id;
            questionAttachment1.FGM_Portal__Description__c = 'TestAttachmentForQuiz 1';
            Database.SaveResult svRslt = Database.insert(questionAttachment1);

            Attachment attachmentOne = new Attachment();
            attachmentOne.Body = Blob.valueOf('attachmentOne');
            attachmentOne.Name = 'attachmentOne';
            attachmentOne.ParentId = questionAttachment1.Id;
            insert attachmentOne;
            system.assertNotEquals(attachmentOne.Id, null);

            //creating campaign For Opportunity
            Campaign campaign = TestsObjectProvider.CreateCampaign(
                'TestCampaign1',
                'test@test1.com',
                Date.today(),
                Date.today(),
                resultFGMPortalQuiz[0].Id,
                null
            );
            campaign.FGM_Portal__Visibility__c = 'Public';
            campaign.FGM_Portal__Parameters__c = 'ownerId:' + lstSysAdminUsers[0].Id;
            campaign.FGM_Portal__Application_Type__c = 'Application Quiz';
            resultcampaign = TestsObjectProvider.InsertListWithAssert(
                new List<Campaign>{ campaign }
            );

            //creating Opportunity
            Opportunity opportunity1;
            Database.SaveResult[] ResultOpportunity1;
            System.runAs(user1) {
                opportunity1 = TestsObjectProvider.CreateOpportunity(
                    'TestOpportunity1',
                    'Prospecting',
                    Date.today()
                );
                ResultOpportunity1 = TestsObjectProvider.InsertListWithAssert(
                    new List<Opportunity>{ opportunity1 }
                );
            }

            //creating Portal User
            FGM_Portal__Portal_User__c objPortalUser = new FGM_Portal__Portal_User__c();
            objPortalUser = TestsObjectProvider.CreateFGMPortalUser(
                null,
                'OTMUser',
                'Test',
                'test1@test.test',
                'test2@test.test',
                'TestUser1',
                'Test1234',
                'Test1234',
                true
            );
            objPortalUser.FGM_Portal__Account__c = account.Id;
            objPortalUser.FGM_Portal__User_Profile__c = 'Individual';
            Database.SaveResult[] resultPortalUser = TestsObjectProvider.InsertListWithAssert(
                new List<FGM_Portal__Portal_User__c>{ objPortalUser }
            );

            //Creating PortalUserRequestTeamMembers
            FGM_Portal__PortalUserRequestTeamMembers__c objPortalUserRequestTeamMembers = new FGM_Portal__PortalUserRequestTeamMembers__c();
            objPortalUserRequestTeamMembers = TestsObjectProvider.CreatePortalUserRequestTeamMembers(
                'Read/Write',
                false,
                resultPortalUser[0].Id,
                ResultOpportunity1[0].Id,
                'Account Manager'
            );
            insert objPortalUserRequestTeamMembers;

            //Creating OTM
            OpportunityTeamMember objTeamMember = new OpportunityTeamMember();
            objTeamMember = TestsObjectProvider.CreateOpportunityTeamMember(
                ResultOpportunity1[0].Id,
                'Account Manager',
                resultUser1[0].Id
            );
            TestsObjectProvider.InsertListWithAssert(
                new List<OpportunityTeamMember>{ objTeamMember }
            );

            //creating Opportunity contact role
            List<OpportunityContactRole> lstContactRoles = new List<OpportunityContactRole>();
            OpportunityContactRole OppContactRole1 = new OpportunityContactRole();
            OppContactRole1.ContactId = resultContact2[0].Id;
            OppContactRole1.IsPrimary = false;
            OppContactRole1.OpportunityId = ResultOpportunity1[0].Id;
            OppContactRole1.Role = 'Business User';
            lstContactRoles.add(OppContactRole1);

            OpportunityContactRole OppContactRole2 = new OpportunityContactRole();
            OppContactRole2.ContactId = resultContact2[0].Id;
            OppContactRole2.IsPrimary = false;
            OppContactRole2.OpportunityId = ResultOpportunity1[0].Id;
            OppContactRole2.Role = 'Decision Maker';
            lstContactRoles.add(OppContactRole2);

            OpportunityContactRole OppContactRole3 = new OpportunityContactRole();
            OppContactRole3.ContactId = resultContact2[0].Id;
            OppContactRole3.IsPrimary = false;
            OppContactRole3.OpportunityId = ResultOpportunity1[0].Id;
            OppContactRole3.Role = 'Evaluator';
            lstContactRoles.add(OppContactRole3);

            Database.Saveresult[] resultContactRole = TestsObjectProvider.InsertListWithAssert(
                lstContactRoles
            );

            //creating GranteeBudgetLineItem Record
            List<FGM_Portal__Grantee_Budget_Line_Item__c> lstGranteeBudgetLineItem = new List<FGM_Portal__Grantee_Budget_Line_Item__c>();
            Integer temp = 0;
            for (Integer index = 0; index < 3; index++) {
                for (Integer i = 0; i < 3; i++) {
                    lstGranteeBudgetLineItem.add(
                        TestsObjectProvider.CreateGranteeBudgetLineItem(
                            ResultOpportunity1[0].Id,
                            resultsGranteeBudget[i].Id
                        )
                    );
                    lstGranteeBudgetLineItem[temp++]
                        .FGM_Portal__Category__c = lstBudgetCategories[i].Id;
                }
            }
            Database.Saveresult[] resultGranteeBudgetLineItem = TestsObjectProvider.InsertListWithAssert(
                lstGranteeBudgetLineItem
            );

            //Creating Data For Quiz 2

            FGM_Portal__Quiz__c fGMPortalQuiz2 = TestsObjectProvider.CreateFGMPortalQuiz(
                'ApplicationQuiz 2',
                'test@test.com',
                '',
                '',
                '',
                '',
                '',
                'Introduction',
                true
            );
            fGMPortalQuiz.FGM_Portal__IsCommunityRecord__c = true;
            fGMPortalQuiz.FGM_Portal__Failure_URL__c = '~/apex/CommunitySignupRejected';
            fGMPortalQuiz.RecordTypeId = PortalQuizRecordTypeMap.get(
                    TestsObjectProvider.PORTAL_QUIZ_APPLICATION
                )
                .getRecordTypeId();

            resultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(
                new List<FGM_Portal__Quiz__c>{ fGMPortalQuiz2 }
            );

            lstRelatedListController.clear();

            lstRelatedListController.add(
                TestsObjectProvider.CreateFGMPortalRelatedListController(
                    'CUSTOM PROFILE TAB-PAYMENT',
                    'Grantee',
                    'Details',
                    'FGM_Base__Payment__c',
                    'Account',
                    'FGM_Base__Payee__c',
                    'Field To Be Edited',
                    'Field_To_Be_Edited__c',
                    relatedListControllerRecordTypeMap.get(
                            PORTAL_RELATEDLISTCONTROLLER_CUSTOMPROFILETAB
                        )
                        .getRecordTypeId(),
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstRelatedListController[0].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[0].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[0].FGM_Portal__SortOrder__c = 1;
            lstRelatedListController[0].FGM_Portal__Cloned_from__c = [
                SELECT Id
                FROM FGM_Portal__Related_List_Controller__c
                LIMIT 1
            ]
            .Id;

            lstRelatedListController.add(
                TestsObjectProvider.CreateFGMPortalRelatedListController(
                    'RelatedListTab-Recommendation',
                    'Grantee',
                    'Dashboard',
                    'FGM_Portal__Recommendation__c',
                    'Opportunity',
                    'FGM_Portal__Opportunity__c',
                    'NAME,FULL NAME,EMAIL',
                    'Name,Recommender_s_Full_Name__c,FGM_Portal__Recommender_Email__c',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB
                        )
                        .getRecordTypeId(),
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstRelatedListController[1].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[1].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[1].FGM_Portal__SortOrder__c = 2;
            lstRelatedListController[1].FGM_Portal__ShowDeleteLink__c = true;
            lstRelatedListController[1].FGM_Portal__ShowNewButton__c = true;
            lstRelatedListController[1].FGM_Portal__SortField__c = 'Name';
            lstRelatedListController[1].FGM_Portal__SortFieldOrder__c = 'Ascending';

            lstRelatedListController.add(
                TestsObjectProvider.CreateFGMPortalRelatedListController(
                    'IFRAME TAB',
                    'Grantee',
                    'Dashboard',
                    'none',
                    'Opportunity',
                    'none',
                    '',
                    '',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_IFRAMETAB
                        )
                        .getRecordTypeId(),
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstRelatedListController[2].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[2].FGM_Portal__SortOrder__c = 3;
            lstRelatedListController[2]
                .FGM_Portal__BaseUrl__c = 'https://test/DynamicIFrameTest?id={Opportunity.ID}&StageName={OPPORTUNITY.Name}&NAME={OPPORTUNITY.name}';

            FGM_Portal__Related_List_Controller__c objRelatedListController2 = TestsObjectProvider.CreateFGMPortalRelatedListController(
                'GRANTEE BUDGET TAB',
                'Grantee',
                'Details',
                'FGM_Portal__Grantee_Budget__c',
                'Quiz__c',
                'FGM_Portal__Grantee_Budget__c',
                'Field To Be Edited',
                'Field_To_Be_Edited__c',
                relatedListControllerRecordTypeMap.get(
                        TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_GRANTEEBUDGETTAB
                    )
                    .getRecordTypeId(),
                resultFGMPortalQuiz[0].Id
            );
            objRelatedListController2.FGM_Portal__Language__c = 'en_US';
            objRelatedListController2.FGM_Portal__IsCommunityRecord__c = true;
            objRelatedListController2.FGM_Portal__ShowDeleteLink__c = true;
            objRelatedListController2.FGM_Portal__ShowNewButton__c = true;
            objRelatedListController2.FGM_Portal__SortOrder__c = 4;

            Database.Saveresult[] resultFGMPortalRelatedListController = TestsObjectProvider.InsertListWithAssert(
                new List<FGM_Portal__Related_List_Controller__c>{
                    objRelatedListController2
                }
            );

            // create Grantee Budget Configuration
            objGranteeBudgetConfiguration.clear();
            objGranteeBudgetConfiguration.add(
                TestsObjectProvider.CreateGranteeBudgetConfig(resultFGMPortalQuiz[0].Id)
            );
            objGranteeBudgetConfiguration[0]
                .FGM_Portal__Related_List_Controller__c = resultsFGMPortalRelatedListController[7]
                .getId();
            objGranteeBudgetConfiguration[0]
                .FGM_Portal__Category__c = lstBudgetCategories[0].Id;

            objGranteeBudgetConfiguration.add(
                TestsObjectProvider.CreateGranteeBudgetConfig(resultFGMPortalQuiz[0].Id)
            );
            objGranteeBudgetConfiguration[1]
                .FGM_Portal__Related_List_Controller__c = resultsFGMPortalRelatedListController[7]
                .getId();
            objGranteeBudgetConfiguration[1]
                .FGM_Portal__Category__c = lstBudgetCategories[1].Id;

            objGranteeBudgetConfiguration.add(
                TestsObjectProvider.CreateGranteeBudgetConfig(resultFGMPortalQuiz[0].Id)
            );
            objGranteeBudgetConfiguration[2]
                .FGM_Portal__Related_List_Controller__c = resultsFGMPortalRelatedListController[7]
                .getId();
            objGranteeBudgetConfiguration[2]
                .FGM_Portal__Category__c = lstBudgetCategories[2].Id;

            resultGranteeBudgetConfiguration = TestsObjectProvider.InsertListWithAssert(
                objGranteeBudgetConfiguration
            );

            lstRelatedListController.add(
                TestsObjectProvider.CreateFGMPortalRelatedListController(
                    'CONTACT TAB',
                    'Grantee',
                    'Dashboard',
                    'Opportunity',
                    'Opportunity',
                    'Opportunity',
                    '',
                    '',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_CONTACTTAB
                        )
                        .getRecordTypeId(),
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstRelatedListController[3].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[3].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[3].FGM_Portal__SortOrder__c = 5;

            lstRelatedListController.add(
                TestsObjectProvider.CreateFGMPortalRelatedListController(
                    'ACCOUNT TAB',
                    'Grantee',
                    'Dashboard',
                    'Opportunity',
                    'Opportunity',
                    'Opportunity',
                    '',
                    '',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_ORGANIZATIONTAB
                        )
                        .getRecordTypeId(),
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstRelatedListController[4].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[4].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[4].FGM_Portal__SortOrder__c = 6;

            lstRelatedListController.add(
                TestsObjectProvider.CreateFGMPortalRelatedListController(
                    'RelatedListTab-OTM',
                    'Grantee',
                    'Dashboard',
                    'OpportunityTeamMember',
                    'Opportunity',
                    'OpportunityId',
                    'Role,User Id,Opportunity ID',
                    'TeamMemberRole,UserId,OpportunityId',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB
                        )
                        .getRecordTypeId(),
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstRelatedListController[5].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[5].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[5].FGM_Portal__SortOrder__c = 7;
            lstRelatedListController[5].FGM_Portal__ShowDeleteLink__c = true;
            lstRelatedListController[5].FGM_Portal__ShowNewButton__c = true;

            lstRelatedListController.add(
                CreateFGMPortalRelatedListController(
                    'PROFILE TAB',
                    'Grantee',
                    'Profile',
                    'FGM_Base__Payment__c',
                    'Account',
                    'FGM_Base__Payee__c',
                    'Payment,Amount,Phone',
                    'Name,FGM_Base__Amount__c,FGM_Base__Phone__c',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB
                        )
                        .getRecordTypeId()
                )
            );
            lstRelatedListController[6].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[6].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[6].FGM_Portal__SortOrder__c = 3;
            lstRelatedListController[6].FGM_Portal__ShowDeleteLink__c = true;
            lstRelatedListController[6].FGM_Portal__ShowNewButton__c = true;
            lstRelatedListController[6]
                .FGM_Portal__Show_Tab_to_Organization_Users__c = true;
            lstRelatedListController[6]
                .FGM_Portal__Show_Tab_to_Individual_Users__c = true;

            lstRelatedListController.add(
                TestsObjectProvider.CreateFGMPortalRelatedListController(
                    'PORTAL TAB',
                    'Grantee',
                    'Dashboard',
                    'Opportunity',
                    'Opportunity',
                    'Opportunity',
                    '',
                    '',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB
                        )
                        .getRecordTypeId(),
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstRelatedListController[7].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[7].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[7].FGM_Portal__SortOrder__c = 8;
            Database.Saveresult[] resultsFGMPortalRelatedListController2 = TestsObjectProvider.InsertListWithAssert(
                lstRelatedListController
            );

            //Question

            List<FGM_Portal__Questions__c> lstFGMPortalQuestion2 = new List<FGM_Portal__Questions__c>();
            lstFGMPortalQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Name',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Instruction',
                    '',
                    '',
                    '',
                    'Instruction',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Attachment',
                    '',
                    '',
                    '',
                    'Attachment',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion2[2].FGM_Portal__Parent_QuestionID__c = [
                SELECT Id
                FROM FGM_Portal__Questions__c
                WHERE FGM_Portal__Type__c = 'Attachment'
                LIMIT 1
            ]
            .Id;
            //Question For Recommendation
            lstFGMPortalQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Applicant Name',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Recommender Full Name',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Email',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );

            //Question For Opportunity Team Member
            lstFGMPortalQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Name',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Additional role',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Team Role',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Opportunity Access',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuiz[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );

            Database.Saveresult[] resultsFGMPortalQuestion2 = TestsObjectProvider.InsertListWithAssert(
                lstFGMPortalQuestion2
            );

            //QuizQuestion
            List<FGM_Portal__Quiz_Questions__c> lstfGMPortalQuizQuestion2 = new List<FGM_Portal__Quiz_Questions__c>();
            lstfGMPortalQuizQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion2[0].Id,
                    1,
                    'Name',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController2[0].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion2[0].FGM_Portal__IsCommunityRecord__c = true;
            lstfGMPortalQuizQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion2[1].Id,
                    1,
                    '',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController2[0].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion2[1].FGM_Portal__IsCommunityRecord__c = true;
            lstfGMPortalQuizQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion2[2].Id,
                    1,
                    '',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController2[0].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion2[2].FGM_Portal__IsCommunityRecord__c = true;

            //QuizQuestion For Recommendation
            lstfGMPortalQuizQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion2[3].Id,
                    1,
                    'Name',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController2[1].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion2[3].FGM_Portal__IsCommunityRecord__c = true;
            lstfGMPortalQuizQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion2[4].Id,
                    1,
                    'Recommender_s_Full_Name__c',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController2[1].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion2[4].FGM_Portal__IsCommunityRecord__c = true;
            lstfGMPortalQuizQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion2[5].Id,
                    1,
                    'FGM_Portal__Recommender_Email__c',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController2[1].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion2[5].FGM_Portal__IsCommunityRecord__c = true;

            //QuizQuestion For Opportunity Team Member
            lstfGMPortalQuizQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion2[6].Id,
                    1,
                    'Name',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController2[5].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion2[6].FGM_Portal__IsCommunityRecord__c = true;
            lstfGMPortalQuizQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion2[7].Id,
                    1,
                    'FGM_Portal__Additional_Roles__c',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController2[5].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion2[7].FGM_Portal__IsCommunityRecord__c = true;
            lstfGMPortalQuizQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion2[8].Id,
                    1,
                    'TeamMemberRole',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController2[5].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion2[8].FGM_Portal__IsCommunityRecord__c = true;
            lstfGMPortalQuizQuestion2.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion2[9].Id,
                    1,
                    'OpportunityAccessLevel',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController2[5].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion2[9].FGM_Portal__IsCommunityRecord__c = true;

            Database.Saveresult[] resultsfGMPortalQuizQuestion2 = TestsObjectProvider.InsertListWithAssert(
                lstfGMPortalQuizQuestion2
            );

            //Creating CampaignQuiz For Opportunity
            FGM_Portal__Campaign_Quiz__c objCampaignQuiz = new FGM_Portal__Campaign_Quiz__c();
            objCampaignQuiz.Name = 'CampaignQuizForOpportunity';
            objCampaignQuiz.FGM_Portal__Campaign__c = resultcampaign[0].Id;
            objCampaignQuiz.FGM_Portal__Quiz__c = resultFGMPortalQuiz[0].Id;

            // Question Attachments
            FGM_Portal__Question_Attachment__c questionAttachment2 = new FGM_Portal__Question_Attachment__c();
            questionAttachment2.FGM_Portal__Question__c = resultsFGMPortalQuestion2[2].Id;
            questionAttachment2.FGM_Portal__Description__c = 'TestAttachmentForQuiz 2';
            Database.SaveResult resultQuestionAttachment = Database.insert(
                questionAttachment2
            );

            Attachment attachmentTwo = new Attachment();
            attachmentTwo.Body = Blob.valueOf('attachmentTwo');
            attachmentTwo.Name = 'attachmentOne';
            attachmentTwo.ParentId = questionAttachment2.Id;
            insert attachmentTwo;
            system.assertNotEquals(attachmentTwo.Id, null);

            //creating Opportunity
            Opportunity opportunity2 = TestsObjectProvider.CreateOpportunity(
                'TestOpportunity2',
                'In Progess',
                Date.today()
            );
            Database.SaveResult[] ResultOpportunity2 = TestsObjectProvider.InsertListWithAssert(
                new List<Opportunity>{ opportunity2 }
            );

            //creating Opportunity contact role
            List<OpportunityContactRole> lstContactRoles2 = new List<OpportunityContactRole>();
            OpportunityContactRole OppContactRole01 = new OpportunityContactRole();
            OppContactRole01.ContactId = resultContact[0].Id;
            OppContactRole01.IsPrimary = false;
            OppContactRole01.OpportunityId = ResultOpportunity2[0].Id;
            OppContactRole01.Role = 'Business User';
            lstContactRoles2.add(OppContactRole01);

            OpportunityContactRole OppContactRole02 = new OpportunityContactRole();
            OppContactRole02.ContactId = resultContact[0].Id;
            OppContactRole02.IsPrimary = false;
            OppContactRole02.OpportunityId = ResultOpportunity2[0].Id;
            OppContactRole02.Role = 'Decision Maker';
            lstContactRoles2.add(OppContactRole02);

            OpportunityContactRole OppContactRole03 = new OpportunityContactRole();
            OppContactRole03.ContactId = resultContact[0].Id;
            OppContactRole03.IsPrimary = false;
            OppContactRole03.OpportunityId = ResultOpportunity2[0].Id;
            OppContactRole03.Role = 'Decision Maker';
            lstContactRoles2.add(OppContactRole03);

            Database.Saveresult[] resultContactRole2 = TestsObjectProvider.InsertListWithAssert(
                lstContactRoles2
            );

            //creating GranteeBudgetLineItem Record
            lstGranteeBudgetLineItem.clear();
            for (Integer index = 0; index < 3; index++) {
                for (Integer i = 0; i < 3; i++)
                    lstGranteeBudgetLineItem.add(
                        TestsObjectProvider.CreateGranteeBudgetLineItem(
                            ResultOpportunity2[0].Id,
                            resultsGranteeBudget[i].Id
                        )
                    );
            }
            resultGranteeBudgetLineItem = TestsObjectProvider.InsertListWithAssert(
                lstGranteeBudgetLineItem
            );

            //Creating data for Lead

            FGM_Portal__Quiz__c fGMPortalQuizForLead = TestsObjectProvider.CreateFGMPortalQuiz(
                'QuizForLead 1',
                'fc@enzigma.com12',
                '',
                '',
                '',
                '',
                '',
                'Introduction',
                true
            );
            fGMPortalQuizForLead.FGM_Portal__IsCommunityRecord__c = true;
            fGMPortalQuizForLead.FGM_Portal__Failure_URL__c = '~/apex/CommunitySignupRejected';
            fGMPortalQuizForLead.RecordTypeId = PortalQuizRecordTypeMap.get(
                    TestsObjectProvider.PORTAL_QUIZ_APPLICATION
                )
                .getRecordTypeId();

            resultFGMPortalQuizForLead = TestsObjectProvider.InsertListWithAssert(
                new List<FGM_Portal__Quiz__c>{ fGMPortalQuizForLead }
            );

            lstRelatedListController.clear();
            lstRelatedListController.add(
                TestsObjectProvider.CreateFGMPortalRelatedListController(
                    'PORTAL TAB',
                    'Grantee',
                    'Dashboard',
                    'Lead',
                    'Lead',
                    'Lead',
                    '',
                    '',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_PORTALTAB
                        )
                        .getRecordTypeId(),
                    resultFGMPortalQuizForLead[0].Id
                )
            );
            lstRelatedListController[0].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[0].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[0].FGM_Portal__SortOrder__c = 1;

            lstRelatedListController.add(
                TestsObjectProvider.CreateFGMPortalRelatedListController(
                    'RelatedListTab-OFACMATCH',
                    'Grantee',
                    'Dashboard',
                    'FGM_Base__OFACMatch__c',
                    'Lead',
                    'FGM_Base__Inquiry__c',
                    'OFACMATCH,Account,Contact',
                    'Name,FGM_Base__Account__c,FGM_Base__Contact__c',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB
                        )
                        .getRecordTypeId(),
                    resultFGMPortalQuizForLead[0].Id
                )
            );
            lstRelatedListController[1].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[1].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[1].FGM_Portal__SortOrder__c = 2;
            lstRelatedListController[1].FGM_Portal__ShowDeleteLink__c = true;
            lstRelatedListController[1].FGM_Portal__ShowNewButton__c = true;

            lstRelatedListController.add(
                TestsObjectProvider.CreateFGMPortalRelatedListController(
                    'IFRAME TAB',
                    'Grantee',
                    'Dashboard',
                    'none',
                    'Lead',
                    'none',
                    '',
                    '',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_IFRAMETAB
                        )
                        .getRecordTypeId(),
                    resultFGMPortalQuizForLead[0].Id
                )
            );
            lstRelatedListController[2].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[2].FGM_Portal__SortOrder__c = 3;
            lstRelatedListController[2]
                .FGM_Portal__BaseUrl__c = 'https://test/DynamicIFrameTest?id={Opportunity.ID}&StageName={OPPORTUNITY.Name}&NAME={OPPORTUNITY.name}';

            lstRelatedListController.add(
                TestsObjectProvider.CreateFGMPortalRelatedListController(
                    'CONTACT TAB',
                    'Grantee',
                    'Dashboard',
                    'Lead',
                    'Lead',
                    'Lead',
                    '',
                    '',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_CONTACTTAB
                        )
                        .getRecordTypeId(),
                    resultFGMPortalQuizForLead[0].Id
                )
            );
            lstRelatedListController[3].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[3].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[3].FGM_Portal__SortOrder__c = 4;

            lstRelatedListController.add(
                TestsObjectProvider.CreateFGMPortalRelatedListController(
                    'ACCOUNT TAB',
                    'Grantee',
                    'Dashboard',
                    'Lead',
                    'Lead',
                    'Lead',
                    '',
                    '',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_ORGANIZATIONTAB
                        )
                        .getRecordTypeId(),
                    resultFGMPortalQuizForLead[0].Id
                )
            );
            lstRelatedListController[4].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[4].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[4].FGM_Portal__SortOrder__c = 5;

            lstRelatedListController.add(
                CreateFGMPortalRelatedListController(
                    'PROFILE TAB',
                    'Grantee',
                    'Profile',
                    'FGM_Base__Payment__c',
                    'Account',
                    'FGM_Base__Payee__c',
                    'Payment,Amount,Phone',
                    'Name,FGM_Base__Amount__c,FGM_Base__Phone__c',
                    relatedListControllerRecordTypeMap.get(
                            TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB
                        )
                        .getRecordTypeId()
                )
            );
            lstRelatedListController[5].FGM_Portal__Language__c = 'en_US';
            lstRelatedListController[5].FGM_Portal__IsCommunityRecord__c = true;
            lstRelatedListController[5].FGM_Portal__SortOrder__c = 3;
            lstRelatedListController[5].FGM_Portal__ShowDeleteLink__c = true;
            lstRelatedListController[5].FGM_Portal__ShowNewButton__c = true;
            lstRelatedListController[5]
                .FGM_Portal__Show_Tab_to_Organization_Users__c = true;
            lstRelatedListController[5]
                .FGM_Portal__Show_Tab_to_Individual_Users__c = true;

            resultsFGMPortalRelatedListController = TestsObjectProvider.InsertListWithAssert(
                lstRelatedListController
            );

            objRelatedListController = TestsObjectProvider.CreateFGMPortalRelatedListController(
                'CUSTOM PROFILE TAB-PAYMENT',
                'Grantee',
                'Details',
                'FGM_Base__Payment__c',
                'Account',
                'FGM_Base__Payee__c',
                'Field To Be Edited',
                'Field_To_Be_Edited__c',
                relatedListControllerRecordTypeMap.get(
                        PORTAL_RELATEDLISTCONTROLLER_CUSTOMPROFILETAB
                    )
                    .getRecordTypeId(),
                resultFGMPortalQuizForLead[0].Id
            );
            objRelatedListController.FGM_Portal__Language__c = 'en_US';
            objRelatedListController.FGM_Portal__IsCommunityRecord__c = true;
            objRelatedListController.FGM_Portal__SortOrder__c = 6;
            objRelatedListController.FGM_Portal__Cloned_from__c = resultsFGMPortalRelatedListController[5]
                .getId();
            insert objRelatedListController;

            //Question

            lstFGMPortalQuestion.clear();
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Name',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuizForLead[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Instruction',
                    '',
                    '',
                    '',
                    'Instruction',
                    resultFGMPortalQuizForLead[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Attachment',
                    '',
                    '',
                    '',
                    'Attachment',
                    resultFGMPortalQuizForLead[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );

            //Question For OFACMATCH
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Title',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuizForLead[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Instruction',
                    '',
                    '',
                    '',
                    'Instruction',
                    resultFGMPortalQuizForLead[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Attachment',
                    '',
                    '',
                    '',
                    'Attachment',
                    resultFGMPortalQuizForLead[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );

            //portal tab (dependent & refrence type questions)
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Dependent',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuizForLead[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Refrence',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuizForLead[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );

            //portal tab (dependent & refrence type questions)
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Dependent',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuizForLead[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );
            lstFGMPortalQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuestion(
                    'Refrence',
                    '',
                    '',
                    '',
                    'Salesforce Data Type',
                    resultFGMPortalQuizForLead[0].Id,
                    '',
                    newPortalQuestionRecordTypeMapByName.get(
                            TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD
                        )
                        .getRecordTypeId()
                )
            );

            resultsFGMPortalQuestion = TestsObjectProvider.InsertListWithAssert(
                lstFGMPortalQuestion
            );

            //creating Lead
            Lead objLead;
            Database.SaveResult[] resultLead1;
            System.runAs(user1) {
                objLead = TestsObjectProvider.CreateLead(
                    'LeadFirstName',
                    'LeadLastName',
                    'LeadCompany',
                    'Open - Not Contacted'
                );
                objLead.FGM_Base__Attachments_to_Request_on_Conversion__c = true;
                resultLead1 = TestsObjectProvider.InsertListWithAssert(
                    new List<Lead>{ objLead }
                );
            }

            // Question Attachments
            FGM_Portal__Question_Attachment__c questionAttachment3 = new FGM_Portal__Question_Attachment__c();
            questionAttachment3 = TestsObjectProvider.CreateQuestionAttachment(
                resultsFGMPortalQuestion[2].Id,
                null,
                resultLead1[0].Id,
                null
            );
            questionAttachment3.FGM_Portal__Description__c = 'TestAttachmentForQuiz 2';

            resultQuestionAttachment = Database.insert(questionAttachment3);

            Attachment attachmentThree = new Attachment();
            attachmentThree.Body = Blob.valueOf('attachmentThree');
            attachmentThree.Name = 'attachmentThree';
            attachmentThree.ParentId = questionAttachment3.Id;
            insert attachmentThree;
            system.assertNotEquals(attachmentThree.Id, null);

            //QuizQuestion
            lstfGMPortalQuizQuestion.clear();
            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[0].Id,
                    1,
                    'FirstName',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[0].Id,
                    false,
                    resultFGMPortalQuizForLead[0].Id
                )
            );
            lstfGMPortalQuizQuestion[0].FGM_Portal__IsCommunityRecord__c = true;
            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[1].Id,
                    1,
                    '',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[0].Id,
                    false,
                    resultFGMPortalQuizForLead[0].Id
                )
            );
            lstfGMPortalQuizQuestion[1].FGM_Portal__IsCommunityRecord__c = true;
            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[2].Id,
                    1,
                    '',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[0].Id,
                    false,
                    resultFGMPortalQuizForLead[0].Id
                )
            );
            lstfGMPortalQuizQuestion[2].FGM_Portal__IsCommunityRecord__c = true;

            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[8].Id,
                    1,
                    'dependent_on_stage__c',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[0].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion[2].FGM_Portal__IsCommunityRecord__c = true;
            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[9].Id,
                    1,
                    'FGM_Base__Payee__c',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[0].Id,
                    false,
                    resultFGMPortalQuiz[0].Id
                )
            );
            lstfGMPortalQuizQuestion[2].FGM_Portal__IsCommunityRecord__c = true;

            //QuizQuestion For OFACMATCH
            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[3].Id,
                    1,
                    'FGM_Base__Title__c',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[1].Id,
                    false,
                    resultFGMPortalQuizForLead[0].Id
                )
            );
            lstfGMPortalQuizQuestion[3].FGM_Portal__IsCommunityRecord__c = true;
            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[4].Id,
                    1,
                    '',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[1].Id,
                    false,
                    resultFGMPortalQuizForLead[0].Id
                )
            );
            lstfGMPortalQuizQuestion[4].FGM_Portal__IsCommunityRecord__c = true;
            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[5].Id,
                    1,
                    '',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[1].Id,
                    false,
                    resultFGMPortalQuizForLead[0].Id
                )
            );
            lstfGMPortalQuizQuestion[5].FGM_Portal__IsCommunityRecord__c = true;

            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[6].Id,
                    1,
                    'dependent_on_stage__c',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[0].Id,
                    false,
                    resultFGMPortalQuizForLead[0].Id
                )
            );
            lstfGMPortalQuizQuestion[6].FGM_Portal__IsCommunityRecord__c = true;

            lstfGMPortalQuizQuestion.add(
                TestsObjectProvider.CreateFGMPortalQuizQuestion(
                    resultsFGMPortalQuestion[7].Id,
                    1,
                    'FGM_Base__Payee__c',
                    '',
                    50,
                    '1',
                    resultsFGMPortalRelatedListController[0].Id,
                    false,
                    resultFGMPortalQuizForLead[0].Id
                )
            );
            lstfGMPortalQuizQuestion[7].FGM_Portal__IsCommunityRecord__c = true;
            resultsfGMPortalQuizQuestion = TestsObjectProvider.InsertListWithAssert(
                lstfGMPortalQuizQuestion
            );

            //creating campaign for lead
            campaign = TestsObjectProvider.CreateCampaign(
                'LeadCampaign1',
                'test@test1.com',
                Date.today(),
                Date.today(),
                resultFGMPortalQuizForLead[0].Id,
                null
            );
            campaign.FGM_Portal__Visibility__c = 'Public';
            campaign.FGM_Portal__LOI_Prameters__c = 'ownerId:' + lstSysAdminUsers[0].Id;
            campaign.FGM_Portal__Application_Type__c = 'LOI Quiz';
            resultcampaignForLead = TestsObjectProvider.InsertListWithAssert(
                new List<Campaign>{ campaign }
            );

            //Portal Configuration Record
            FGM_Portal__PortalConfiguration__c portalConfig;
            portalConfig = TestsObjectProvider.CreateFGMPortalPortalConfiguration(
                'Grantee Community - English',
                'Requested;Accepted',
                true,
                false,
                'Amendment',
                'Goals',
                false,
                'Messages',
                'Status Reports',
                'en_US',
                'Submitted',
                'Applications',
                'Prospecting',
                'LOIs',
                'Submitted',
                'Open - Not Contacted'
            );
            insert portalConfig;

            //community setting record
            FGM_Portal__CommunitySetting__c customSetting = new FGM_Portal__CommunitySetting__c();
            customSetting.Name = 'ShowInquiryAttachmentTabToGrantee';
            customSetting.FGM_Portal__IsEnabled__c = true;
            insert customSetting;

            //custom html record
            FGM_Portal__CustomHTML__c objCustomHtml = new FGM_Portal__CustomHTML__c();
            objCustomHtml = TestsObjectProvider.CreateFGMPortalCustomHTML(
                'GranteeApplicationReview',
                'Grantee',
                'en_US',
                'Header',
                '<div style="color:Blue"><strong>Application Review.</strong><br> CustomHTML: GranteeApplicationReview <br/> Please review your application here and Submit.</div>'
            );
            insert objCustomHtml;
            test.stopTest();

            GlobalPortalSettings__c globalSetting = new GlobalPortalSettings__c();
            globalSetting.FGM_Portal__Virus_Scan_URL__c = 'test';
            globalSetting.Is_VirusScan_Enabled__c = true;
            globalSetting.Request_Campaign_Field_Name__c = 'FGM_Portal__Test_Request_Campaign_Field__c';
            globalSetting.LOI_Campaign_Field_Name__c = 'FGM_Portal__Test_LOI_Campaign_Field__c';
            insert globalSetting;
        } catch (Exception e) {
            system.debug(
                'Exception ...:' +
                e.getMessage() +
                ' Line number' +
                e.getLineNumber() +
                ' ' +
                e.getStackTraceString()
            );
        }
    }

    @IsTest
    private static void editOpportunityTeamMemberWithLookupReadOnlyShouldNotFail() {
        Map<String, Schema.Recordtypeinfo> relatedListControllerRecordTypeMap = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe()
            .getRecordTypeInfosByName();
        //user
        //expecting to find a portalUser (from testsetup)
        User portalUser = [
            SELECT Id, ContactId, AccountId, Username
            FROM User
            WHERE Username = 'community@user1.com'
            LIMIT 1
        ];

        //expecting to find the testCampaign (from testsetup)
        //campaign
        Campaign campaign = [
            SELECT Id, Name
            FROM Campaign
            WHERE Name = 'TestCampaign1'
            LIMIT 1
        ];

        //quiz
        FGM_Portal__Quiz__c FGMPortalQuiz = [
            SELECT Name, Id
            FROM FGM_Portal__Quiz__c
            WHERE Name = 'ApplicationQuiz 1'
            LIMIT 1
        ];
        //expecting to find the ApplicationQuiz (from testsetup)

        //opportunity/request
        Opportunity request1 = [
            SELECT Id, Name
            FROM Opportunity
            WHERE Name = 'TestOpportunity1'
            LIMIT 1
        ];

        //List of questions
        List<FGM_Portal__Quiz_Questions__c> quizQuestions = [
            SELECT
                Id,
                FGM_Portal__Question__r.FGM_Portal__Type__c,
                FGM_Portal__Field__c,
                FGM_Portal__Required__c
            FROM FGM_Portal__Quiz_Questions__c
            WHERE FGM_Portal__Quiz__c = :FGMPortalQuiz.Id
        ];
        for (FGM_Portal__Quiz_Questions__c qq : quizQuestions) {
            qq.FGM_Portal__Required__c = false;
        }
        update quizQuestions;

        //controller instance
        PageReference pageRef = Page.FGM_Portal__communityapplication;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('recordIndex', '0');
        ApexPages.StandardController stdController = new ApexPages.standardController(
            campaign
        );
        CommunityApplicationExtension controller = new CommunityApplicationExtension(
            stdController
        );

        controller.application = request1;
        CommunityApplicationExtension.RelatedList portalUserTeamMembersRelatedListConfiguration = new CommunityApplicationExtension.RelatedList();
        portalUserTeamMembersRelatedListConfiguration.strRelatedListObject = '';
        portalUserTeamMembersRelatedListConfiguration.relatedListLookup = '';
        portalUserTeamMembersRelatedListConfiguration.mapColumnFields = new Map<String, String>{
            'Role' => 'FGM_Portal__UserRole__c',
            'Status' => 'FGM_Portal__PortalUser__r.FGM_Portal__Approval_Status__c',
            'Email' => 'FGM_Portal__PortalUser__r.Email__c',
            'Last Name' => 'FGM_Portal__PortalUser__r.LastName__c',
            'First Name' => 'FGM_Portal__PortalUser__r.FirstName__c',
            'Contact' => 'FGM_Portal__PortalUser__r.FGM_Portal__Contact__c',
            'Account' => 'FGM_Portal__PortalUser__r.FGM_Portal__Portal_Account__c'
        };
        portalUserTeamMembersRelatedListConfiguration.isCreatable = true;
        portalUserTeamMembersRelatedListConfiguration.isEditable = true;
        portalUserTeamMembersRelatedListConfiguration.isDeletable = true;
        portalUserTeamMembersRelatedListConfiguration.lstColumnFields = new List<String>{
            'Role',
            'Status',
            'Email',
            'Last Name',
            'First Name',
            'Contact',
            'Account'
        };
        portalUserTeamMembersRelatedListConfiguration.lstRelatedListRecord = controller.getPendingTeamMembersList(
            new Set<String>(
                portalUserTeamMembersRelatedListConfiguration.mapColumnFields.values()
            )
        );

        //stub setup
        final CrudFlsServiceTest.GetReadableFieldsMethod getReadableFields = new CrudFlsServiceTest.GetReadableFieldsMethod();
        {
            getReadableFields.getParameters()[0].setAssertArgumentHasExactEquality(false);
            getReadableFields.objectName = 'FGM_Portal__Portal_User__c';
            getReadableFields.returnValue = new Set<String>{
                'FGM_Portal__Approval_Status__c',
                'LastName__c'
            };
        }

        final Stub stubbedMethods = new Stub(new List<Stub.Method>{ getReadableFields });
        // Set stubs
        controller.crudFlsServiceInstance = (CrudFlsService) Test.createStub(
            CrudFlsService.class,
            stubbedMethods
        );
        //runas our user, grab the permission, and make it read-only
        System.runAs(portalUser) {
            List<FieldPermissions> readOnlyPerms = [
                SELECT
                    SobjectType,
                    Field,
                    PermissionsRead,
                    PermissionsEdit,
                    Parent.ProfileID
                FROM FieldPermissions
                WHERE
                    SobjectType = 'FGM_Portal__Portal_User__c'
                    AND (Field = 'FGM_Portal__Portal_User__c.FGM_Portal__Contact__c'
                    OR Field = 'FGM_Portal__Portal_User__c.FGM_Portal__Portal_Account__c')
                    AND Parent.ProfileId = :UserInfo.getProfileId()
            ];
            //we should have returned permissions for the FGM_Portal__Contact__c and FGM_Portal__Account__c fields on FGM_Portal__Portal_User__c object

            System.assert(
                readOnlyPerms.size() == 2,
                'We should find two field permissions - one for Payment.Amount and one for Payment.Comment on the running users profile: ' +
                UserInfo.getProfileId() +
                'list size: ' +
                readOnlyPerms.size()
            );
            //remove edit access
            for (FieldPermissions perm : readOnlyPerms) {
                if (perm.Field == 'FGM_Portal__Portal_User__c.FGM_Portal__Contact__c') {
                    perm.PermissionsRead = false;
                    perm.PermissionsEdit = false;
                } else {
                    //should be our FGM_Portal__Contact__c field. Want to make sure it's Readable.
                    perm.PermissionsRead = true;
                    perm.PermissionsEdit = false;
                }
            }
            update readOnlyPerms;
            //restart our DML for the user 'page actions'
            Test.startTest();

            controller.portalUserTeamMembersRelatedListConfiguration = portalUserTeamMembersRelatedListConfiguration;

            controller.editOpportunityMember();

            //stub method check
            stubbedMethods.assertMethodsCalled();

            System.assert(
                !ApexPages.hasMessages(ApexPages.Severity.Error),
                'An error should not have occured during save: ' + ApexPages.getMessages()
            );

            Test.stopTest();
        }

    }

    @IsTest
    private static void saveRelatedListTabWithReadOnlyShouldNotFail(){
        Map<String,Schema.Recordtypeinfo> relatedListControllerRecordTypeMap = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        //user
        //expecting to find a portalUser (from testsetup)
        User portalUser = [ 
                SELECT Id, ContactId, AccountId, Username 
                FROM User 
                WHERE Username = 'community@user1.com' 
                LIMIT 1 ];

        //expecting to find the testCampaign (from testsetup)
        //campaign
        Campaign campaign = [ 
            SELECT Id, Name
            FROM Campaign
            WHERE Name = 'TestCampaign1'
            LIMIT 1];
        

        //quiz
        FGM_Portal__Quiz__c FGMPortalQuiz = [ 
            SELECT Name, Id 
            FROM FGM_Portal__Quiz__c
            WHERE Name = 'ApplicationQuiz 1'
            LIMIT 1];
        //expecting to find the ApplicationQuiz (from testsetup)
          
        //opportunity/request
        Opportunity request1 = TestsObjectProvider.CreateOpportunity('Request 1', 'In Progress', (Date.Today() + 30));
        insert request1;
        //List of questions
        List<FGM_Portal__Quiz_Questions__c> quizQuestions = [SELECT Id, FGM_Portal__Question__r.FGM_Portal__Type__c, 
                                                            FGM_Portal__Field__c, FGM_Portal__Required__c 
                                                            FROM FGM_Portal__Quiz_Questions__c
                                                            WHERE FGM_Portal__Quiz__c = :FGMPortalQuiz.Id];
        for(FGM_Portal__Quiz_Questions__c qq :quizQuestions){
            qq.FGM_Portal__Required__c = false;
        }                                      
        update quizQuestions;                  

        //create payment related to it
        FGM_Base__Payment__c payment1 = new FGM_Base__Payment__c(FGM_Base__Amount__c = 100, FGM_Base__Comment__c = 'Starting comment', FGM_Base__Request__c = request1.Id);
        insert payment1;
                
        //using TestsObjectProvider
        FGM_Portal__Related_List_Controller__c paymentRelatedListTab =
            TestsObjectProvider.CreateFGMPortalRelatedListController(
                'Payments',
                'Grantee',
                'Dashboard',
                'FGM_Base__Payment__c',
                'Opportunity',
                'FGM_Base__Request__c',
                'Created Date, Payment',
                'CreatedDate, Name',
                relatedListControllerRecordTypeMap.get(TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId(),
                FGMPortalQuiz.Id
        );
        paymentRelatedListTab.FGM_Portal__Language__c = 'en_US';
        paymentRelatedListTab.FGM_Portal__IsCommunityRecord__c = true;
        paymentRelatedListTab.FGM_Portal__SortOrder__c = 1;
        insert paymentRelatedListTab;        
        SObject tabObject;

        //controller instance
        ApexPages.StandardController stdController = new ApexPages.standardController(campaign);        
        CommunityApplicationExtension controller = new CommunityApplicationExtension(stdController);
        
        CommunityApplicationExtension.RelatedList relatedListConfiguration = new CommunityApplicationExtension.RelatedList();
        relatedListConfiguration.strRelatedListObject = 'FGM_Base__Payment__c';
        relatedListConfiguration.strActionColLabel = 'Action';
        relatedListConfiguration.relatedListLookup = 'FGM_Base__Request__c';
        relatedListConfiguration.mapColumnFields = new Map<String, String>{'Amount' => 'FGM_Base__Amount__c', 'Comment' => 'FGM_Base__Comment__c'};
        relatedListConfiguration.isCreatable = true;
        relatedListConfiguration.isEditable = true;
        relatedListConfiguration.isDeletable = true;
        relatedListConfiguration.lstColumnFields = new List<String>{'Amount', 'Comment'};
        relatedListConfiguration.lstRelatedListRecord = controller.getRelatedListRecords(paymentRelatedListTab, new Set<String>(relatedListConfiguration.mapColumnFields.values()));
        relatedListConfiguration.record = paymentRelatedListTab;
        //cast our tabobject into the selected related object
        tabObject = (sObject) FCGlobal.getNewSobject(relatedListConfiguration.strRelatedListObject);
        tabObject = payment1;
        //stub setup
        final AdminContextExecutionManagerTest.StripInaccessibleAndUpsertMethod stripInaccessibleAndUpsert = new AdminContextExecutionManagerTest.StripInaccessibleAndUpsertMethod();
        {
            // Update stripInaccessibleAndUpdate argument to use inexact equality (==) since a new List<SObject> is passed as the argument
            stripInaccessibleAndUpsert.getParameters()[0].setAssertArgumentHasExactEquality(false);

            stripInaccessibleAndUpsert.records = new List<SObject> {
                tabObject
            };
            // stripInaccessibleAndUpdate returns void
        }

        final Stub stubbedMethods = new Stub(new List<Stub.Method> {
            stripInaccessibleAndUpsert
        });
        // Set stubs
        controller.adminContextExecutionManagerInstance = (AdminContextExecutionManager) Test.createStub(
            AdminContextExecutionManager.class,
            stubbedMethods
        );
        //runas our user, grab the permission, and make it read-only
        System.runAs(portalUser){            
            List<FieldPermissions> paymentTargetFieldPerms = [SELECT SobjectType, Field, PermissionsRead, PermissionsEdit,
                                Parent.ProfileID FROM FieldPermissions
                                WHERE SobjectType = 'FGM_Base__Payment__c' AND (Field = 'FGM_Base__Payment__c.FGM_Base__Amount__c' OR
                                                                                Field = 'FGM_Base__Payment__c.FGM_Base__Comment__c')
                                AND Parent.ProfileId = :UserInfo.getProfileId()];
            //we should have returned permissions for the ammount and comment fields on Payment object
            
            System.assert(paymentTargetFieldPerms.size() == 2, 'We should find two field permissions - one for Payment.Amount and one for Payment.Comment on the running users profile: ' + UserInfo.getProfileId() + 'list size: ' + paymentTargetFieldPerms.size());
            //remove edit access            
            for (FieldPermissions perm : paymentTargetFieldPerms){
                if(perm.Field == 'FGM_Base__Payment__c.FGM_Base__Amount__c'){
                    perm.PermissionsRead = true;
                    perm.PermissionsEdit = false;
                }else{
                    //should be our comment field. Want to make sure it's editable.
                    perm.PermissionsRead = true;
                    perm.PermissionsEdit = true;
                }
            }
            update paymentTargetFieldPerms;
            //restart our DML for the user 'page actions'
            Test.startTest();            
            
            controller.tabObject = tabObject;
            controller.relatedListConfiguration  = relatedListConfiguration;
            controller.quizQuestionList = quizQuestions;                        
            //updating a known field to ensure update is successful            
            controller.tabObject.put(Schema.SobjectType.FGM_Base__Payment__c.fields.FGM_Base__Comment__c.getName(), 'Updated Comment');             
            controller.saveRelatedListRecord();
            
            //stub method check
            stubbedMethods.assertMethodsCalled();
            
            System.assert(!ApexPages.hasMessages(ApexPages.Severity.Error), 'An error should not have occured during save: ' + ApexPages.getMessages());

            Test.stopTest();

        }                               
        
        
        
    }
    @IsTest
    private static void initializeReviewValidDataTestForOpportunity() {
        test.startTest();
        Campaign[] objCampaign = [SELECT Id FROM Campaign WHERE Name = 'TestCampaign1'];
        FGM_Portal__Quiz__c objQuiz = [
            SELECT Id, Name, FGM_Portal__Introduction_Text__c, FGM_Portal__Is_Active__c
            FROM FGM_Portal__Quiz__c
            WHERE Name = 'ApplicationQuiz 1'
        ];
        User communityUser1 = [
            SELECT Id, ContactId, Contact.AccountId
            FROM User
            WHERE Username = :'community@user1.com'
            LIMIT 1
        ];
        User communityUser2 = [
            SELECT Id, ContactId, AccountId
            FROM User
            WHERE Username = :'community@user2.com'
            LIMIT 1
        ];
        Opportunity objOpportunity;
        FGM_Portal__Related_List_Controller__c objRLC = [
            SELECT Id
            FROM FGM_Portal__Related_List_Controller__c
            WHERE FGM_Portal__Quiz__c = :objQuiz.Id
            LIMIT 1
        ];
        System.runAs(communityUser1) {
            objOpportunity = [
                SELECT Id, Name, StageName, CloseDate
                FROM Opportunity
                WHERE Name = 'TestOpportunity1'
                LIMIT 1
            ];
            objOpportunity.FGM_Portal__Quiz__c = objQuiz.Id;
            update objOpportunity;

            ApexPages.StandardController stdController = new ApexPages.standardController(
                objCampaign[0]
            );
            CommunityApplicationExtension objExtention = new CommunityApplicationExtension(
                stdController
            );
            objExtention.application = objOpportunity;
            ApexPages.currentPage().getParameters().put('appID', objOpportunity.Id);
            ApexPages.currentPage().getParameters().put('Id', objOpportunity.Id);
            ApexPages.currentPage().getParameters().put('mode', 'view');
            ApexPages.currentPage().getParameters().put('quizId', objQuiz.Id);
            system.assertEquals(null, objExtention.InitializeReview());
            CommunityApplicationExtension.relatedList objRelatedList = new CommunityApplicationExtension.relatedList();
            objRelatedList.lstRelatedListRecord = [
                SELECT UserId, OpportunityId, TeamMemberRole
                FROM OpportunityTeamMember
                WHERE OpportunityId = :objOpportunity.Id
            ];
            objExtention.relatedListConfiguration = objRelatedList;
            ApexPages.currentPage().getParameters().put('userId', communityUser1.Id);
            objExtention.initializeQuizQuestionList(objRLC.Id);
            objExtention.setUsrDpndntPrmtrsFrOTM();
        }
        test.stopTest();
    }

    @IsTest
    private static void initializeReviewPageListValidDataTest() {
        test.startTest();
        Campaign[] objCampaign = [SELECT Id FROM Campaign WHERE Name = 'TestCampaign1'];
        FGM_Portal__Quiz__c objQuiz = [
            SELECT Id, Name, FGM_Portal__Introduction_Text__c, FGM_Portal__Is_Active__c
            FROM FGM_Portal__Quiz__c
            WHERE Name = 'ApplicationQuiz 1'
        ];
        Opportunity[] objOpportunity = [
            SELECT Id, Name, StageName, CloseDate
            FROM Opportunity
            WHERE Name = 'TestOpportunityForUser1'
            LIMIT 1
        ];
        objOpportunity[0].Quiz__c = objQuiz.Id;
        update objOpportunity[0];

        User communityUser1 = [
            SELECT Id, ContactId, AccountId
            FROM User
            WHERE Username = :'community@user1.com'
            LIMIT 1
        ];

        ApexPages.StandardController stdController = new ApexPages.standardController(
            objCampaign[0]
        );
        CommunityApplicationExtension objExtention = new CommunityApplicationExtension(
            stdController
        );
        objExtention.application = objOpportunity[0];
        ApexPages.currentPage().getParameters().put('appID', objOpportunity[0].Id);
        ApexPages.currentPage().getParameters().put('Id', objOpportunity[0].Id);
        ApexPages.currentPage().getParameters().put('mode', 'edit');
        ApexPages.currentPage().getParameters().put('quizId', objQuiz.Id);
        system.assertEquals(null, objExtention.InitializeReview());
        test.stopTest();
    }

    @IsTest
    private static void initializeReviewConvertedLeadValidDataTest() {
        Campaign[] objCampaign = [SELECT Id FROM Campaign WHERE Name = 'TestCampaign1'];
        FGM_Portal__Quiz__c objQuiz = [
            SELECT Id, Name, FGM_Portal__Introduction_Text__c, FGM_Portal__Is_Active__c
            FROM FGM_Portal__Quiz__c
            WHERE Name = 'ApplicationQuiz 1'
        ];

        ApexPages.StandardController stdController = new ApexPages.standardController(
            objCampaign[0]
        );
        CommunityApplicationExtension objExtention = new CommunityApplicationExtension(
            stdController
        );

        Lead objLead = [SELECT Id FROM Lead WHERE FirstName = :'LeadFirstName'];
        test.startTest();
        database.leadConvert leadConvert = new database.leadConvert();
        leadConvert.setLeadId(objLead.Id);

        leadStatus convertStatus = [
            SELECT Id, MasterLabel
            FROM LeadStatus
            WHERE IsConverted = true
            LIMIT 1
        ];
        leadConvert.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult leadConvertResult = Database.convertLead(leadConvert);
        System.assert(leadConvertResult.isSuccess());
        leadConvert.setOpportunityName('LeadFName LeadLName');

        Opportunity[] objOpportunity = [
            SELECT Id, Name
            FROM Opportunity
            WHERE Id = :leadConvertResult.getOpportunityId()
        ];
        objOpportunity[0].Quiz__c = objQuiz.Id;
        update objOpportunity[0];

        //objExtention.application = objOpportunity[0];
        ApexPages.currentPage().getParameters().put('appID', objOpportunity[0].Id);
        ApexPages.currentPage().getParameters().put('Id', objOpportunity[0].Id);
        ApexPages.currentPage().getParameters().put('mode', 'edit');
        // ApexPages.currentPage().getParameters().put('quizId',objQuiz.Id);

        system.assertEquals(objExtention.InitializeReview(), null);
        test.stopTest();
    }

    @IsTest
    private static void initializeReviewValidDataTestForLead() {
        test.startTest();
        FGM_Portal__Quiz__c objLeadQuiz = [
            SELECT Id, Name, FGM_Portal__Introduction_Text__c, FGM_Portal__Is_Active__c
            FROM FGM_Portal__Quiz__c
            WHERE Name = 'QuizForLead 1'
        ];
        Lead objLead = [
            SELECT Id, FirstName, LastName, Company, Status
            FROM Lead
            WHERE FirstName = 'LeadFirstName'
        ];
        objLead.FGM_Portal__Quiz__c = objLeadQuiz.Id;
        update objLead;
        Campaign objLeadCampaign = [SELECT Id FROM Campaign WHERE Name = 'LeadCampaign1'];
        ApexPages.StandardController stdController = new ApexPages.standardController(
            objLeadCampaign
        );
        CommunityApplicationExtension objExtention = new CommunityApplicationExtension(
            stdController
        );
        ApexPages.currentPage().getParameters().put('appID', objLead.Id);
        ApexPages.currentPage().getParameters().put('Id', objLead.Id);
        ApexPages.currentPage().getParameters().put('mode', 'edit');
        ApexPages.currentPage().getParameters().put('quizId', objLeadQuiz.Id);
        system.assertEquals(null, objExtention.InitializeReview());

        ApexPages.currentPage().getParameters().remove('appID');
        objExtention.application = objLeadQuiz;
        system.assertEquals(null, objExtention.InitializeReview());
        test.stopTest();
    }

    @IsTest
    private static void initializeReviewInValidDataTestForOpportunity() {
        test.startTest();
        //emptyQuizId test
        FGM_Portal__Quiz__c objQuiz = [
            SELECT Id, Name, FGM_Portal__Introduction_Text__c, FGM_Portal__Is_Active__c
            FROM FGM_Portal__Quiz__c
            WHERE Name = 'ApplicationQuiz 1'
        ];
        Campaign[] objCampaign = [SELECT Id FROM Campaign WHERE Name = 'TestCampaign1'];
        objCampaign[0].Application_Quiz__c = objQuiz.Id;
        update objCampaign;

        Opportunity[] objOpportunity = [
            SELECT Id, Name, StageName, CloseDate
            FROM Opportunity
            WHERE Name = 'TestOpportunity1'
            LIMIT 1
        ];
        objOpportunity[0].Quiz__c = objQuiz.Id;
        update objOpportunity[0];
        ApexPages.StandardController stdController = new ApexPages.standardController(
            objCampaign[0]
        );
        CommunityApplicationExtension objExtention = new CommunityApplicationExtension(
            stdController
        );
        system.assertEquals(null, objExtention.InitializeReview());
        test.stopTest();
    }

    @IsTest
    private static void initializeReviewInValidDataTestForLead() {
        //emptyQuizId test
        test.startTest();
        FGM_Portal__Quiz__c objLeadQuiz = [
            SELECT Id, Name, FGM_Portal__Introduction_Text__c, FGM_Portal__Is_Active__c
            FROM FGM_Portal__Quiz__c
            WHERE Name = 'QuizForLead 1'
        ];
        Lead objLead = [
            SELECT Id, FirstName, LastName, Company, Status
            FROM Lead
            WHERE FirstName = 'LeadFirstName'
        ];
        objLead.FGM_Portal__Quiz__c = objLeadQuiz.Id;
        update objLead;

        Campaign objLeadCampaign = [SELECT Id FROM Campaign WHERE Name = 'LeadCampaign1'];
        objLeadCampaign.FGM_Portal__LOI_Quiz__c = objLeadQuiz.Id;
        update objLeadCampaign;

        ApexPages.StandardController stdController = new ApexPages.standardController(
            objLeadCampaign
        );
        CommunityApplicationExtension objExtention = new CommunityApplicationExtension(
            stdController
        );

        system.assertEquals(null, objExtention.InitializeReview());
        test.stopTest();
    }

    @IsTest
    private static void initializeReviewConvertedLeadTest() {
        test.startTest();
        FGM_Portal__Quiz__c objLeadQuiz = [
            SELECT Id, Name, FGM_Portal__Introduction_Text__c, FGM_Portal__Is_Active__c
            FROM FGM_Portal__Quiz__c
            WHERE Name = 'QuizForLead 1'
        ];
        Lead objLead = [
            SELECT Id, FirstName, LastName, Company, Status
            FROM Lead
            WHERE FirstName = 'LeadFirstName'
        ];
        objLead.FGM_Portal__Quiz__c = objLeadQuiz.Id;
        objLead.FGM_Base__Attachments_to_Request_on_Conversion__c = true;
        update objLead;

        Campaign objLeadCampaign = [SELECT Id FROM Campaign WHERE Name = 'LeadCampaign1'];
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objLead.id);
        LeadStatus convertStatus = [
            SELECT Id, MasterLabel
            FROM LeadStatus
            WHERE IsConverted = true
            LIMIT 1
        ];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        Opportunity objOpp = [
            SELECT Id
            FROM Opportunity
            WHERE Id IN (SELECT ConvertedOpportunityId FROM Lead WHERE Id = :objLead.Id)
        ];
        system.assertNotEquals(null, objOpp.Id);

        FGM_Portal__Quiz__c objQuiz = [
            SELECT Id, Name, FGM_Portal__Introduction_Text__c, FGM_Portal__Is_Active__c
            FROM FGM_Portal__Quiz__c
            WHERE Name = 'ApplicationQuiz 1'
        ];
        Campaign[] objCampaign = [SELECT Id FROM Campaign WHERE Name = 'TestCampaign1'];
        objCampaign[0].Application_Quiz__c = objQuiz.Id;
        update objCampaign;

        objOpp.Quiz__c = objQuiz.Id;
        update objOpp;

        ApexPages.StandardController stdController = new ApexPages.standardController(
            objLeadCampaign
        );
        CommunityApplicationExtension objExtention = new CommunityApplicationExtension(
            stdController
        );

        ApexPages.currentPage().getParameters().put('appID', objOpp.Id);
        ApexPages.currentPage().getParameters().put('mode', 'edit');
        ApexPages.currentPage().getParameters().put('quizId', objQuiz.Id);
        system.assertEquals(null, objExtention.InitializeReview());
        test.stopTest();
    }

    @IsTest
    private static void saveRecordValidDataTestForOpportunity() {
        test.startTest();

        User communityUser1 = [
            SELECT Id, ContactId, AccountId
            FROM User
            WHERE Username = :'community@user1.com'
            LIMIT 1
        ];
        FGM_Portal__Quiz__c objQuiz = [
            SELECT Id, Name, FGM_Portal__Introduction_Text__c, FGM_Portal__Is_Active__c
            FROM FGM_Portal__Quiz__c
            WHERE Name = 'ApplicationQuiz 1'
        ];
        Campaign[] objCampaign = [SELECT Id FROM Campaign WHERE Name = 'TestCampaign1'];
        List<Account> lstAccount = [SELECT Id FROM Account WHERE Name = :'testName'];
        Opportunity objOpp = TestsObjectProvider.CreateOpportunity(
            'opp1',
            'Prospecting',
            Date.today()
        );
        objOpp.FGM_Portal__Quiz__c = objQuiz.Id;
        System.runAs(communityUser1) {
            ApexPages.StandardController stdController = new ApexPages.standardController(
                objCampaign[0]
            );
            CommunityApplicationExtension objExtention = new CommunityApplicationExtension(
                stdController
            );

            objExtention.application = objOpp;
            objExtention.tabObject = objOpp;
            objExtention.campaign = objCampaign[0];
            objExtention.quiz = objQuiz;
            objExtention.currentParentObject = 'opportunity';
            objExtention.isSaveAndNext = false;
            objExtention.initialize();
            objExtention.dateFrom = '02/02/2017';
            objExtention.dateTo = '02/02/2019';
            objExtention.selectedTab = [
                SELECT Id
                FROM FGM_Portal__Related_List_Controller__c
                WHERE Name = 'GRANTEE BUDGET TAB'
                LIMIT 1
            ]
            .Id;
            objExtention.strSelectedappId = objOpp.Id;
            objExtention.generateBudget();
            objExtention.InsertBudgetLineItem();
            system.assertEquals(null, objExtention.SaveRecord());
        }
        test.stopTest();
    }

    @IsTest
    private static void saveRecordValidDataTestForLead() {
        test.startTest();
        User communityUser1 = [
            SELECT Id, ContactId, AccountId
            FROM User
            WHERE Username = :'community@user1.com'
            LIMIT 1
        ];
        FGM_Portal__Quiz__c objLeadQuiz = [
            SELECT Id, Name, FGM_Portal__Introduction_Text__c, FGM_Portal__Is_Active__c
            FROM FGM_Portal__Quiz__c
            WHERE Name = 'QuizForLead 1'
        ];
        Lead objLead;
        System.runAs(communityUser1) {
            objLead = TestsObjectProvider.CreateLead(
                'LeadFirstName',
                'LeadLastName',
                'LeadCompany',
                'Open - Not Contacted'
            );
            objLead.FGM_Base__Attachments_to_Request_on_Conversion__c = true;
        }
        Campaign objLeadCampaign = [SELECT Id FROM Campaign WHERE Name = 'LeadCampaign1'];
        ApexPages.StandardController stdController = new ApexPages.standardController(
            objLeadCampaign
        );
        CommunityApplicationExtension objExtention = new CommunityApplicationExtension(
            stdController
        );

        objExtention.application = objLead;
        objExtention.tabObject = objLead;
        objExtention.campaign = objLeadCampaign;
        objExtention.quiz = objLeadQuiz;
        objExtention.currentParentObject = 'Lead';
        objExtention.isSaveAndNext = false;
        objExtention.initialize();
        system.assertEquals(null, objExtention.SaveRecord());

        test.stopTest();
    }

    @IsTest
    private static void getNewRelatedListRecordTest() {
        test.startTest();
        User communityUser1 = [
            SELECT Id, ContactId, AccountId
            FROM User
            WHERE Username = :'community@user1.com'
            LIMIT 1
        ];
        FGM_Portal__Quiz__c objQuiz = [
            SELECT Id, Name, FGM_Portal__Introduction_Text__c, FGM_Portal__Is_Active__c
            FROM FGM_Portal__Quiz__c
            WHERE Name = 'ApplicationQuiz 1'
        ];
        Campaign[] objCampaign = [SELECT Id FROM Campaign WHERE Name = 'TestCampaign1'];
        List<Account> lstAccount = [SELECT Id FROM Account WHERE Name = :'testName'];
        Opportunity objOpp = TestsObjectProvider.CreateOpportunity(
            'opp1',
            'Prospecting',
            Date.today()
        );
        objOpp.FGM_Portal__Quiz__c = objQuiz.Id;
        System.runAs(communityUser1) {
            ApexPages.StandardController stdController = new ApexPages.standardController(
                objCampaign[0]
            );
            CommunityApplicationExtension objExtention = new CommunityApplicationExtension(
                stdController
            );

            objExtention.application = objOpp;
            objExtention.tabObject = objOpp;
            objExtention.campaign = objCampaign[0];
            objExtention.quiz = objQuiz;
            objExtention.currentParentObject = 'opportunity';
            objExtention.isSaveAndNext = false;
            objExtention.initialize();
            system.assertEquals(null, objExtention.SaveRecord());

            objExtention.saveAndNext();
            objExtention.saveAndNext();
            objExtention.saveAndNext();
            objExtention.saveAndNext();
            objExtention.saveAndNext();
            objExtention.saveAndNext();
            objExtention.saveAndNext();
            objExtention.saveAndNext();
            objExtention.getNewRelatedListRecord();
            test.stopTest();
        }
    }

    @IsTest
    private static void setUserDependentForOpportunityTeamMember() {
        User communityUser1 = [
            SELECT Id, ContactId, AccountId
            FROM User
            WHERE Username = :'community@user2.com'
            LIMIT 1
        ];
        FGM_Portal__Quiz__c objQuiz = [
            SELECT Id, Name, FGM_Portal__Introduction_Text__c, FGM_Portal__Is_Active__c
            FROM FGM_Portal__Quiz__c
            WHERE Name = 'ApplicationQuiz 1'
        ];
        System.assert(objQuiz != null);
        Campaign[] objCampaign = [SELECT Id FROM Campaign WHERE Name = 'TestCampaign1'];
        ApexPages.StandardController stdController = new ApexPages.standardController(
            objCampaign[0]
        );
        CommunityApplicationExtension objExtention = new CommunityApplicationExtension(
            stdController
        );
        ApexPages.currentPage().getParameters().put('userId', communityUser1.Id);
        objExtention.setUsrDpndntPrmtrsFrOTM();
    }


    @IsTest
    private static void saveRelatedListRecordTest(){
        Test.startTest();    

        sObject tabObject;
        Map<String, Schema.Recordtypeinfo> newPortalQuestionRecordTypeMapByName = FGM_Portal__Questions__c.SObjectType.getDescribe()
            .getRecordTypeInfosByName();
        Map<String, Schema.Recordtypeinfo> newRelatedListRecordTypeMapByName = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe()
            .getRecordTypeInfosByName();
        Map<String,Schema.Recordtypeinfo> PortalQuizRecordTypeMap = FGM_Portal__Quiz__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        List<User> lstSysAdminUsers;
        Account account;
        Contact contact;
        
        lstSysAdminUsers = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true]; 
        
        //Creating Account Record
        account = TestsObjectProvider.CreateAccount('Enzigma');
        account.OwnerId = lstSysAdminUsers[0].Id;
        account.BillingCountry = 'India';           
        Database.SaveResult[] resultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{ account });
        
        //Creating Contact Record
        contact = TestsObjectProvider.CreateContact('fname','lname',resultAccount[0].Id,'fname@gmail.com');
        Database.SaveResult[] resultContact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{ contact });      
        
        //Creating user Record
        User user1 = TestsObjectProvider.CreateUser( resultContact[0].Id,'test@usertest.com','testuserA','testuserB','GPPortalUser01@user01.com',
                                                    true,'FC Community Users Profile',account.Name);
        user1.FGM_Portal__ProfileType__c = 'individual';
        user1.FGM_Portal__UserProfile__c = 'Grantee';
        Database.SaveResult[] resultUser1 = TestsObjectProvider.InsertListWithAssert(new List<User>{ user1 });
        
        User portalUser = [ SELECT Id, ContactId, AccountId, Username FROM User WHERE Username = 'GPPortalUser01@user01.com' LIMIT 1 ];
        
        //creating quiz
        FGM_Portal__Quiz__c FGMPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz('quizName', 'fc@enzigma.com12', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
        FGMPortalQuiz.FGM_Portal__IsCommunityRecord__c = true;
        FGMPortalQuiz.FGM_Portal__Failure_URL__c = '~/apex/CommunitySignupRejected';
        FGMPortalQuiz.RecordTypeId = PortalQuizRecordTypeMap.get(PORTAL_QUIZ_PAGELAYOUT).getRecordTypeId();
        Database.Saveresult[] ResultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{FGMPortalQuiz});
        
        //creating campaign For Opportunity
        Campaign campaign = TestsObjectProvider.CreateCampaign('TestCampaign','test@test.com',
                                                               Date.today(),Date.today(),
                                                               ResultFGMPortalQuiz[0].Id,
                                                               null
                                                              );
        campaign.FGM_Portal__Visibility__c = 'Public';
        campaign.FGM_Portal__Parameters__c = 'ownerId:' + lstSysAdminUsers[0].Id;
        campaign.FGM_Portal__Application_Type__c = 'Application Quiz';
        Database.Saveresult[] resultcampaign = TestsObjectProvider.InsertListWithAssert(
            new List<Campaign>{ campaign }
        );
        
        // Related List Controllers
        List<FGM_Portal__Related_List_Controller__c> lstFGMPortaRelatedListControllerForTab = new List<FGM_Portal__Related_List_Controller__c>();
        
        lstFGMPortaRelatedListControllerForTab.add(TestsObjectProvider.CreateFGMPortalRelatedListController( 'Collaborators','Grantee','Related List','OpportunityTeamMember','Opportunity','OpportunityId',
                                                                                                            'User Name,Application Role,Access Level','UserId,TeamMemberRole,OpportunityAccessLevel',newRelatedListRecordTypeMapByName.get(
                                                                                                                TestsObjectProvider.PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId(),ResultFGMPortalQuiz[0].Id));
        lstFGMPortaRelatedListControllerForTab[0].FGM_Portal__IsCommunityRecord__c = true;  
        lstFGMPortaRelatedListControllerForTab[0].FGM_Portal__Language__c = 'en_US';
        lstFGMPortaRelatedListControllerForTab[0].FGM_Portal__SortOrder__c = 1;
        lstFGMPortaRelatedListControllerForTab[0].FGM_Portal__SortFieldOrder__c = 'Ascending';
        Database.Saveresult[] ResultListControllerForTabs = TestsObjectProvider.InsertListWithAssert(
            lstFGMPortaRelatedListControllerForTab
        );
        Database.Saveresult ResultListControllerForTabId = ResultListControllerForTabs[0];
        
        // Questions for OTM 
        List<FGM_Portal__Questions__c> lstFGMPortalQuestion = new List<FGM_Portal__Questions__c>();
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('What is the user name?','','','','Salesforce Data Type',ResultFGMPortalQuiz[0].Id,'',
                                                                             newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('What is their role?','','','','Salesforce Data Type',ResultFGMPortalQuiz[0].Id,'',
                                                                             newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Additional Roles?','','','','Salesforce Data Type',ResultFGMPortalQuiz[0].Id,'',
                                                                             newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        
        lstFGMPortalQuestion.add(TestsObjectProvider.CreateFGMPortalQuestion('Opportunity Access Level?','','','','Salesforce Data Type',ResultFGMPortalQuiz[0].Id,'',
                                                                             newPortalQuestionRecordTypeMapByName.get(TestsObjectProvider.PORTAL_QUESTION_RECORDFIELD).getRecordTypeId()));
        Database.Saveresult[] ResultFGMPortalQuestion = TestsObjectProvider.InsertListWithAssert(lstFGMPortalQuestion);
        
        // Quiz Questions for OTM
        List<FGM_Portal__Quiz_Questions__c> lstFGMPortalQuizQuestion = new List<FGM_Portal__Quiz_Questions__c>();
        FGM_Portal__Quiz_Questions__c quizQuestion = TestsObjectProvider.CreateFGMPortalQuizQuestion(ResultFGMPortalQuestion[0].Id,1,'userid','',50,'1',
                                                                                                     ResultListControllerForTabId.Id, false, ResultFGMPortalQuiz[0].Id);
        quizQuestion.FGM_Portal__IsCommunityRecord__c = true;
        lstFGMPortalQuizQuestion.add(quizQuestion);
        
        lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(ResultFGMPortalQuestion[1].Id,2,'teammemberrole','',50,'1',
                                                                                     ResultListControllerForTabId.Id,true, ResultFGMPortalQuiz[0].Id));
        lstFGMPortalQuizQuestion[1].FGM_Portal__IsCommunityRecord__c = true;
        
        lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(ResultFGMPortalQuestion[2].Id,3,'additional_roles__c','',50,'1',
                                                                                     ResultListControllerForTabId.Id,true, ResultFGMPortalQuiz[0].Id));
        lstFGMPortalQuizQuestion[2].FGM_Portal__IsCommunityRecord__c = true;
        
        lstFGMPortalQuizQuestion.add(TestsObjectProvider.CreateFGMPortalQuizQuestion(ResultFGMPortalQuestion[3].Id,4,'OpportunityAccessLevel','',50,'1',
                                                                                     ResultListControllerForTabId.Id,true, ResultFGMPortalQuiz[0].Id));
        lstFGMPortalQuizQuestion[3].FGM_Portal__IsCommunityRecord__c = true;
        
        Database.Saveresult[] ResultsFGMPortalQuizQuestion = TestsObjectProvider.InsertListWithAssert(
            lstFGMPortalQuizQuestion
        );
        //List of questions
        List<FGM_Portal__Quiz_Questions__c> quizQuestions = [SELECT Id, FGM_Portal__Question__r.FGM_Portal__Type__c, 
                                                             FGM_Portal__Field__c, FGM_Portal__Required__c 
                                                             FROM FGM_Portal__Quiz_Questions__c
                                                             WHERE FGM_Portal__Quiz__c = :FGMPortalQuiz.Id];
        for(FGM_Portal__Quiz_Questions__c question :quizQuestions){
            question.FGM_Portal__Required__c = false;
        }                                   
        update quizQuestions;
        
        Opportunity opportunity = TestsObjectProvider.CreateOpportunity('testOpp', 'In Progress', Date.today());
        Database.Saveresult[] ResultOpportunity = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunity});
        //creating Opportunity contact role
        List<OpportunityContactRole> lstContactRoles = new List<OpportunityContactRole>();
        OpportunityContactRole OppContactRole = new OpportunityContactRole();
        OppContactRole.ContactId = portalUser.ContactId;
        OppContactRole.IsPrimary = false;
        OppContactRole.OpportunityId = ResultOpportunity[0].Id;
        OppContactRole.Role = 'Business User';
        lstContactRoles.add(OppContactRole);
        Database.Saveresult[] resultContactRole = TestsObjectProvider.InsertListWithAssert(
            lstContactRoles
        );
        //Creating OTM
        OpportunityTeamMember objTeamMember = new OpportunityTeamMember();
        objTeamMember = TestsObjectProvider.CreateOpportunityTeamMember(ResultOpportunity[0].Id,'Account Manager',resultUser1[0].Id );
        objTeamMember.OpportunityAccessLevel='All';
        objTeamMember.FGM_Portal__ContactRoleID__c= resultContactRole[0].Id; 
        TestsObjectProvider.InsertListWithAssert(new List<OpportunityTeamMember>{ objTeamMember });
        
        OpportunityTeamMember otm= [SELECT UserId, OpportunityId, TeamMemberRole,ContactRoleID__c, User.ContactId FROM OpportunityTeamMember
                                    WHERE OpportunityId = :ResultOpportunity[0].Id];
        
        Map<Id, Set<String>> mapIdSetRoles = new Map<Id, Set<String>>();
        Set<String> setRoles = new Set<String>();
        setRoles.add(OppContactRole.Role);
        mapIdSetRoles.put(OppContactRole.ContactId,setRoles);
        
        CommunityApplicationExtension.OTMOCRWrapper otmOcrWrapper = new CommunityApplicationExtension.OTMOCRWrapper(objTeamMember, OppContactRole, mapIdSetRoles.get(OppContactRole.ContactId), true);
        otmOcrWrapper.ContactId=OppContactRole.ContactId ;
        otmOcrWrapper.OpportunityId = OppContactRole.OpportunityId;
        
        //controller instance
        ApexPages.StandardController stdController = new ApexPages.standardController(campaign);        
        CommunityApplicationExtension controller = new CommunityApplicationExtension(stdController);        
        
        CommunityApplicationExtension.RelatedList relatedListConfiguration = new CommunityApplicationExtension.RelatedList();
        relatedListConfiguration.strRelatedListObject = 'OpportunityTeamMember';
        relatedListConfiguration.strActionColLabel = 'Action';
        relatedListConfiguration.relatedListLookup = 'OpportunityId';
        relatedListConfiguration.mapColumnFields = new Map<String, String>{'Access Level' => 'opportunityaccesslevel', 'Application Role' => 'teammemberrole', 'User Name' => 'userid'};
        relatedListConfiguration.isCreatable = true;
        relatedListConfiguration.isEditable = true;
        relatedListConfiguration.isDeletable = true;
        relatedListConfiguration.lstColumnFields = new List<String>{'User Name', 'Application Role', 'Access Level'};
        relatedListConfiguration.lstRelatedListRecord = controller.getRelatedListRecords( lstFGMPortaRelatedListControllerForTab[0], new Set<String>(relatedListConfiguration.mapColumnFields.values()));
        relatedListConfiguration.record =  lstFGMPortaRelatedListControllerForTab[0];
        
        //cast our tabobject into the selected related object
        tabObject = (sObject) FCGlobal.getNewSobject(relatedListConfiguration.strRelatedListObject);
        tabObject = objTeamMember;
        
        System.runAs(portalUser){  
            List<FieldPermissions> fieldPerms = [
                SELECT
                SobjectType,
                Field,
                PermissionsRead,
                PermissionsEdit,
                Parent.ProfileID
                FROM FieldPermissions
                WHERE
                SobjectType = 'OpportunityTeamMember'
                AND Field = 'OpportunityTeamMember.FGM_Portal__ContactRoleID__c'                    
                AND Parent.ProfileId = :UserInfo.getProfileId()
            ];            
            for (FieldPermissions perm : fieldPerms) {
                if (perm.Field == 'OpportunityTeamMember.FGM_Portal__ContactRoleID__c') {
                    perm.PermissionsRead = true;
                    perm.PermissionsEdit = true;
                } 
            }
            update fieldPerms;

            controller.otmWrapperGlbl =otmOcrWrapper;
            controller.lstSelectedContactRoles = new List<SelectOption>();
            controller.application =opportunity;
            controller.strOtmAccessLevel ='All';
            controller.strRLCObjectName = 'OpportunityTeamMember';
            controller.tabObject = tabObject;
            controller.relatedListConfiguration  = relatedListConfiguration;
            controller.quizQuestionList = quizQuestions;  
            controller.quizQuestionListForOTM =quizQuestions;
            controller.selectedTab= lstFGMPortaRelatedListControllerForTab[0].Id;           
            controller.tabsList = getRLCRecords();
            
            controller.saveRelatedListRecord(); 
            System.assert(!ApexPages.hasMessages(ApexPages.Severity.Error), 'An error should not have occured during save: ' + ApexPages.getMessages());
          
        }      
        Test.stopTest();       
    }

    public static List<Related_List_Controller__c> getRLCRecords(){
        List<Related_List_Controller__c> lstRLC = [
                  SELECT Associated_FC_Portal_Type__c,
                  Associated_Tab_Type__c,
                  BaseUrl__c,
                  FieldHeaders__c,
                  FieldNames__c,
                  Field_Labels_Long__c,
                  Field_Names_Long__c,
                  Hide_Edit_Link__c,
                  RichInstructionalText__c,
                  LookupField__c,
                  Name,
                  ObjectName__c,
                  ParentObject__c,
                  RecordType.Name,
                  RecordTypeId,
                  ShowDeleteLink__c,
                  ShowNewButton__c,
                  SortFieldOrder__c,
                  SortField__c,
                  (
                      SELECT
                      Can_upload_after_submission__c,
                      Field__c,
                      Hide_Post_Text__c,
                      Hide_Pre_Text__c,
                      Question__c,
                      Question__r.AttachmentNameFormula__c,
                      Question__r.Help_Tip__c,
                      Question__r.RichPostText__c,
                      Question__r.RichPreText__c,
                      Question__r.RichQuestion__c,
                      Question__r.Quiz__c,
                      Question__r.Type__c,
                      Quiz__c,
                      Required__c,
                      Sort_Order__c,
                      Tab__c
                      FROM Quiz_Questions__r
                      ORDER BY Sort_Order__c ASC NULLS LAST
                  )
                  FROM Related_List_Controller__c];
          return lstRLC;
          }
    
}