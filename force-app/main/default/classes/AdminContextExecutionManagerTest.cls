@IsTest
public class AdminContextExecutionManagerTest {
    @IsTest
    private static void unitTestStripInaccessibleAndInsert() {
        List<Account> records = new List<Account>{new Account(Name='Test Organization')};
        final CrudFlsServiceTest.StripInaccessibleForInsertMethod stripInaccessibleForInsert = new CrudFlsServiceTest.StripInaccessibleForInsertMethod();
        {
            stripInaccessibleForInsert.records = records;
            stripInaccessibleForInsert.returnValue = records;
        }

        final Stub stub = new Stub(new List<Stub.Method>{ stripInaccessibleForInsert });
    
        Test.startTest();
        final AdminContextExecutionManager service = new AdminContextExecutionManager();
        {
            service.securityService = (CrudFlsService) Test.createStub(
                CrudFlsService.class,
                stub
            );

            service.stripInaccessibleAndInsert(records);
        }
        Test.stopTest();

        stub.assertMethodsCalled();
    }


    @IsTest
    private static void unitTestStripInaccessibleAndUpdate() {
        final SObject granteeReport = CrudFlsServiceTest.createAndInsertGranteeReport();
        final Id recordId = (Id) granteeReport.get('Id');

        final SObject record = granteeReport.getSObjectType().newSObject();
        {
            record.put('Id', recordId);
            record.put(CrudFlsServiceTest.BOOLEAN_FIELD.getName(), true);
        }

        // Save record with GRANTEE_REPORT_BOOLEAN as true
        Database.update(record);

        // Change record's GRANTEE_REPORT_BOOLEAN as false to be updated
        record.put(CrudFlsServiceTest.BOOLEAN_FIELD.getName(), false);

        final List<SObject> records = new List<SObject>{ record };

        final CrudFlsServiceTest.StripInaccessibleForUpdateMethod stripInaccessibleForUpdate = new CrudFlsServiceTest.StripInaccessibleForUpdateMethod();
        {
            stripInaccessibleForUpdate.records = records;
            stripInaccessibleForUpdate.returnValue = records;
        }

        final Stub stub = new Stub(new List<Stub.Method>{ stripInaccessibleForUpdate });

        // Assert record's GRANTEE_REPORT_BOOLEAN is true in the database
        System.assertEquals(
            false,
            Database.query(
                    String.format(
                        'SELECT Id FROM {0} WHERE Id = :recordId AND {1} = true LIMIT 1',
                        new List<String>{
                            CrudFlsServiceTest.CUSTOM_OBJECT.getName(),
                            CrudFlsServiceTest.BOOLEAN_FIELD.getName()
                        }
                    )
                )
                .isEmpty(),
            'record\'s BOOLEAN_FIELD should be true in the database'
        );

        Test.startTest();

        final Integer dmlStatementsBefore = Limits.getDmlStatements();

        final AdminContextExecutionManager service = new AdminContextExecutionManager();
        {
            service.securityService = (CrudFlsService) Test.createStub(
                CrudFlsService.class,
                stub
            );

            service.stripInaccessibleAndUpdate(records);
        }

        final Integer dmlStatementsAfter = Limits.getDmlStatements();

        Test.stopTest();

        stub.assertMethodsCalled();

        System.assertEquals(
            dmlStatementsBefore + 1,
            dmlStatementsAfter,
            'One DML Statement should have been called between setting dmlStatementsBefore and dmlStatementsAfter'
        );

        System.assertEquals(
            false,
            Database.query(
                    String.format(
                        'SELECT Id FROM {0} WHERE Id = :recordId AND {1} = false LIMIT 1',
                        new List<String>{
                            CrudFlsServiceTest.CUSTOM_OBJECT.getName(),
                            CrudFlsServiceTest.BOOLEAN_FIELD.getName()
                        }
                    )
                )
                .isEmpty(),
            'record\'s BOOLEAN_FIELD should be false in the database'
        );
    }

    @IsTest
    private static void stripInaccessibleAndUpsertRecord(){
        String updatedOrgName = 'Test Organization Update';

        Account newOrg = new Account(Name='Test Organization');

        Account existingOrg = new Account(Name='Existing Test Organization');
        insert existingOrg;

        existingOrg.Name = updatedOrgName;

        List<Account> orgs = new List<Account>{newOrg, existingOrg};

        Test.startTest();
            AdminContextExecutionManager contextMgr = new AdminContextExecutionManager();
            contextMgr.stripInaccessibleAndUpsert(orgs);
        Test.stopTest();

        System.assertEquals(1, [SELECT COUNT() FROM Account WHERE Name = 'Test Organization'],
            'The account should have been inserted');
        System.assertEquals(1, [SELECT COUNT() FROM Account WHERE Name = :updatedOrgName AND ID = :existingOrg.Id],
            'The existing account should have been updated');
    }

    @IsTest
    private static void stripInaccessibleAndInsert(){
        List<Account> orgs = new List<Account>{new Account(Name='Test Organization')};

        Test.startTest();
            AdminContextExecutionManager contextMgr = new AdminContextExecutionManager();
            contextMgr.stripInaccessibleAndInsert(orgs);
        Test.stopTest();

        System.assertEquals(1, [SELECT COUNT() FROM Account WHERE Name = 'Test Organization'],
            'The account should have been inserted');
    }

    @isTest
    private static void shouldNotCreateDuplicatesOnStripInaccessibleAndInsert(){
        //To ensure our insert method is not creating duplicates when called multiple times in a transaction (due to the fact it inserts clones of records)
        final String accName = 'ShouldBeOnlyOne';
        final String actualException;
        final Account account = new Account(Name = accName);
        List<Account> accounts = new List<Account>  {
            account
        };
        Test.startTest();

        final AdminContextExecutionManager dmlService = new AdminContextExecutionManager();
        dmlService.stripInaccessibleAndInsert(accounts); 
        List<Account> wildAccts = [SELECT Id, Name 
                                    FROM Account 
                                    WHERE Name = :accName];
        System.assertEquals(1, wildAccts.size(), 'Should hve successfully inserted 1 account.');
        //try to insert the account again - should not allow because the id was manually returned inside of stripInaccessibleForInsert
        try {
            dmlService.stripInaccessibleAndInsert(accounts);
        } catch (Exception e) {
            actualException = e.getMessage() + ' | ' + e.getStackTraceString();
        }
        test.stopTest();
        
        System.assertNotEquals(null, actualException, 'Should not have been able to insert the account again because ID was set.');
    }
    @IsTest
    private static void stripInaccessibleAndUpdate(){
        List<Account> orgs = new List<Account>{new Account(Name='Test Organization')};
        insert orgs;
        String updatedOrgName = 'Test Organization Update';

        Test.startTest();
            AdminContextExecutionManager contextMgr = new AdminContextExecutionManager();
            orgs[0].Name = updatedOrgName;
            contextMgr.stripInaccessibleAndUpdate(orgs);
        Test.stopTest();

        Account testOrganization = [SELECT Id, Name FROM Account LIMIT 1];        
        System.assertEquals(updatedOrgName, testOrganization.Name, 'Organization name should be updated to ' + updatedOrgName);
    }

    @IsTest
    private static void stripInaccessibleAndUpdateNoRecords(){
        List<Account> orgs = new List<Account>();

        Test.startTest();
            AdminContextExecutionManager contextMgr = new AdminContextExecutionManager();
            contextMgr.stripInaccessibleAndUpdate(orgs);
        Test.stopTest();

        List<Account> testOrganizations = [SELECT Id, Name FROM Account LIMIT 1];
        System.assert(testOrganizations.isEmpty(), 'No Account records should exist.');
    }

    @IsTest
    private static void stripInaccessibleAndUpdateFailure(){
        List<Account> orgs = new List<Account>{new Account(Name='Test Organization')};
        String updatedOrgName = 'Test Organization Update';

        Test.startTest();
            AdminContextExecutionManager contextMgr = new AdminContextExecutionManager();
            orgs[0].Name = updatedOrgName;
            try{
                contextMgr.stripInaccessibleAndUpdate(orgs);
            }
            catch(Exception e){
                System.debug(e.getMessage());
                System.debug(e.getTypeName());
                System.assert(e.getTypeName() == 'System.DmlException');
            }
        Test.stopTest();

        List<Account> testOrganizations = [SELECT Id, Name FROM Account LIMIT 1];
        System.assert(testOrganizations.isEmpty() ,'No Account records should exist.');
    }
    
    static testMethod void getUserResult() {
        List<User> lstUser = [SELECT name, Id FROM User LIMIT 5];
        List<String> lstUserId = new List<String>();
        for (User user : lstUser)
            lstuserId.add(user.Id);
        List<User> lstUserResult = AdminContextExecutionManager.getUserResult(lstuserId);
        System.assert(!lstUserResult.IsEmpty());
    }
    static testMethod void getRecordTypesByNameWithoutSharing() {
        Map<String, Schema.RecordTypeInfo> mapRecordTypeInfo = AdminContextExecutionManager.getRecordTypesByName(
            'Account'
        );
        System.assertNotEquals(null, mapRecordTypeInfo);
        Map<String, Schema.RecordTypeInfo> mapRecordTypeInfos = AdminContextExecutionManager.getRecordTypesByName(
            ''
        );
        System.assertEquals(null, mapRecordTypeInfos);
    }
    static testMethod void executeInsert() {
        Account[] accounts = new List<Account>();
        for (Integer i = 0; i < 2; i++) {
            Account account = new Account(Name = 'Acme' + i);
            accounts.add(account);
        }
        AdminContextExecutionManager.executeInsert(accounts);
        AdminContextExecutionManager.executeUpsert(accounts);
        List<Account> lstAccount = AdminContextExecutionManager.executeUpdate(accounts);
        System.assert(!lstAccount.IsEmpty());
        AdminContextExecutionManager.executeDelete(lstAccount);
    }
    public without sharing class StripInaccessibleAndUpsertMethod extends Stub.Method {
        public List<SObject> records;

        public StripInaccessibleAndUpsertMethod() {
            super(
                AdminContextExecutionManager.class,
                void.class,
                'stripInaccessibleAndUpsert',
                new List<Stub.Parameter>{
                    new Stub.Parameter(List<SObject>.class, 'records')
                        .setAssertArgumentHasExactEquality(true)
                }
            );
        }

        public override Boolean isInstanceOf(Object instance) {
            return instance instanceof AdminContextExecutionManager;
        }

        public override List<Object> getExpectedArguments() {
            return new List<Object>{ this.records };
        }

        public override Object getReturnValue() {
            return void.class;
        }
    }

    public without sharing class StripInaccessibleAndUpdateMethod extends Stub.Method {
        public List<SObject> records;

        public StripInaccessibleAndUpdateMethod() {
            super(
                AdminContextExecutionManager.class,
                void.class,
                'stripInaccessibleAndUpdate',
                new List<Stub.Parameter>{
                    new Stub.Parameter(List<SObject>.class, 'records')
                        .setAssertArgumentHasExactEquality(true)
                }
            );
        }

        public override Boolean isInstanceOf(Object instance) {
            return instance instanceof AdminContextExecutionManager;
        }

        public override List<Object> getExpectedArguments() {
            return new List<Object>{ this.records };
        }

        public override Object getReturnValue() {
            return void.class;
        }
    }
}