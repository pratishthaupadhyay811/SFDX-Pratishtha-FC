@isTest
public without sharing class CrudFlsServiceTest {
    static final String MOCK_CONTACT_ID =
        Contact.sObjectType.getDescribe().getKeyPrefix() + '000000000000001';

    // A Profile without any CRUD or FLS to Custom Objects
    public static final String READ_ONLY_PROFILE_NAME = 'Read Only';

    // Unique name of new Permission Set that should not grant and permissions to anything by default.
    public static final String EMPTY_PERMISSION_SET_NAME = 'FGM_Portal_CrudFlsServiceTest_EmptyPermSet';

    // Grantee Report schema

    /*
        Idea:
        - Specify an SObject that has enough fields that represent the Field Types we want to test
        - 

    */

    public static final Schema.DescribeSObjectResult CUSTOM_OBJECT = Schema.SObjectType.FGM_Base__Grantee_Report__c;
    public static final Schema.DescribeSObjectResult STANDARD_OBJECT = Schema.SObjectType.Opportunity;
    public static final Schema.DescribeFieldResult ID_FIELD = Schema.SObjectType.FGM_Base__Grantee_Report__c.fields.Id;
    public static final Schema.DescribeFieldResult UNEDITABLE_MASTER_DETAIL_FIELD = Schema.SObjectType.FGM_Base__Grantee_Report__c.fields.FGM_Base__Request__c;
    public static final Schema.DescribeFieldResult LOOKUP_FIELD = Schema.SObjectType.FGM_Base__Grantee_Report__c.fields.FGM_Base__Report_Contact__c;
    public static final Schema.DescribeFieldResult BOOLEAN_FIELD = Schema.SObjectType.FGM_Base__Grantee_Report__c.fields.FGM_Base__Display_Benchmark__c;
    public static final Schema.DescribeFieldResult DATE_FIELD = Schema.SObjectType.FGM_Base__Grantee_Report__c.fields.FGM_Base__Due_Date__c;
    public static final Schema.DescribeFieldResult PICKLIST_FIELD = Schema.SObjectType.FGM_Base__Grantee_Report__c.fields.FGM_Base__Impact__c;
    public static final Schema.DescribeFieldResult TEXTAREA_FIELD = Schema.SObjectType.FGM_Base__Grantee_Report__c.fields.FGM_Base__Comment__c;
    public static final Schema.DescribeFieldResult RECORD_TYPE_ID_FIELD = Schema.SObjectType.FGM_Base__Grantee_Report__c.fields.RecordTypeId;
    public static final Schema.DescribeFieldResult STRING_FORMULA_FIELD = Schema.SObjectType.FGM_Base__Grantee_Report__c.fields.FGM_Base__Address__c;

    public static final Map<Schema.SObjectField, Schema.DescribeFieldResult> DESCRIBES_BY_FIELD = new Map<Schema.SObjectField, Schema.DescribeFieldResult>{
        CrudFlsServiceTest.ID_FIELD.getSObjectField() => CrudFlsServiceTest.ID_FIELD,
        CrudFlsServiceTest.UNEDITABLE_MASTER_DETAIL_FIELD.getSObjectField() => CrudFlsServiceTest.UNEDITABLE_MASTER_DETAIL_FIELD,
        CrudFlsServiceTest.LOOKUP_FIELD.getSObjectField() => CrudFlsServiceTest.LOOKUP_FIELD,
        CrudFlsServiceTest.BOOLEAN_FIELD.getSObjectField() => CrudFlsServiceTest.BOOLEAN_FIELD,
        CrudFlsServiceTest.DATE_FIELD.getSObjectField() => CrudFlsServiceTest.DATE_FIELD,
        CrudFlsServiceTest.PICKLIST_FIELD.getSObjectField() => CrudFlsServiceTest.PICKLIST_FIELD,
        CrudFlsServiceTest.TEXTAREA_FIELD.getSObjectField() => CrudFlsServiceTest.TEXTAREA_FIELD,
        CrudFlsServiceTest.RECORD_TYPE_ID_FIELD.getSObjectField() => CrudFlsServiceTest.RECORD_TYPE_ID_FIELD,
        CrudFlsServiceTest.STRING_FORMULA_FIELD.getSObjectField() => CrudFlsServiceTest.STRING_FORMULA_FIELD
    };

    // As a developer, these are the fields we expect to be permissionable
    public static final Set<Schema.SObjectField> PERMISSIONABLE_FIELDS = new Set<Schema.SObjectField>{
        CrudFlsServiceTest.LOOKUP_FIELD.getSObjectField(),
        CrudFlsServiceTest.BOOLEAN_FIELD.getSObjectField(),
        CrudFlsServiceTest.DATE_FIELD.getSObjectField(),
        CrudFlsServiceTest.PICKLIST_FIELD.getSObjectField(),
        CrudFlsServiceTest.TEXTAREA_FIELD.getSObjectField(),
        CrudFlsServiceTest.STRING_FORMULA_FIELD.getSObjectField() // Calculated Fields can have PermissionsRead but not PermissionsEdit
    };

    public static final Set<Schema.SObjectField> READABLE_FIELDS = new Set<Schema.SObjectField>{
        CrudFlsServiceTest.ID_FIELD.getSObjectField(),
        CrudFlsServiceTest.UNEDITABLE_MASTER_DETAIL_FIELD.getSObjectField(),
        CrudFlsServiceTest.LOOKUP_FIELD.getSObjectField(),
        CrudFlsServiceTest.BOOLEAN_FIELD.getSObjectField(),
        CrudFlsServiceTest.DATE_FIELD.getSObjectField(),
        CrudFlsServiceTest.PICKLIST_FIELD.getSObjectField(),
        CrudFlsServiceTest.TEXTAREA_FIELD.getSObjectField(),
        CrudFlsServiceTest.RECORD_TYPE_ID_FIELD.getSObjectField(),
        CrudFlsServiceTest.STRING_FORMULA_FIELD.getSObjectField()
    };

    public static final Set<Schema.SObjectField> READABLE_BUT_NOT_PERMISSIONABLE_FIELDS = new Set<Schema.SObjectField>{
        CrudFlsServiceTest.ID_FIELD.getSObjectField(),
        CrudFlsServiceTest.UNEDITABLE_MASTER_DETAIL_FIELD.getSObjectField(),
        CrudFlsServiceTest.RECORD_TYPE_ID_FIELD.getSObjectField()        
    };

    public static final Set<Schema.SObjectField> CREATEABLE_FIELDS = new Set<Schema.SObjectField>{
        CrudFlsServiceTest.UNEDITABLE_MASTER_DETAIL_FIELD.getSObjectField(),
        CrudFlsServiceTest.LOOKUP_FIELD.getSObjectField(),        
        CrudFlsServiceTest.BOOLEAN_FIELD.getSObjectField(),
        CrudFlsServiceTest.DATE_FIELD.getSObjectField(),
        CrudFlsServiceTest.PICKLIST_FIELD.getSObjectField(),
        CrudFlsServiceTest.TEXTAREA_FIELD.getSObjectField(),
        CrudFlsServiceTest.RECORD_TYPE_ID_FIELD.getSObjectField()
    };

    public static final Set<Schema.SObjectField> CREATEABLE_BUT_NOT_PERMISSIONABLE_FIELDS = new Set<Schema.SObjectField>{
        CrudFlsServiceTest.UNEDITABLE_MASTER_DETAIL_FIELD.getSObjectField(),
        CrudFlsServiceTest.RECORD_TYPE_ID_FIELD.getSObjectField()
    };

    public static final Set<Schema.SObjectField> UPDATEABLE_FIELDS = new Set<Schema.SObjectField>{
        CrudFlsServiceTest.LOOKUP_FIELD.getSObjectField(),
        CrudFlsServiceTest.BOOLEAN_FIELD.getSObjectField(),
        CrudFlsServiceTest.DATE_FIELD.getSObjectField(),
        CrudFlsServiceTest.PICKLIST_FIELD.getSObjectField(),
        CrudFlsServiceTest.TEXTAREA_FIELD.getSObjectField(),
        CrudFlsServiceTest.RECORD_TYPE_ID_FIELD.getSObjectField()
    };
    
    public static final Set<Schema.SObjectField> UPDATEABLE_BUT_NOT_PERMISSIONABLE_FIELDS = new Set<Schema.SObjectField>{
        CrudFlsServiceTest.RECORD_TYPE_ID_FIELD.getSObjectField()
    };

    static {
        // Assert UNEDITABLE_MASTER_DETAIL_FIELD is a non-parentable Master-Detail Relationship
        System.assertEquals(
            true,
            PermissionSetManager.isMasterDetail(
                CrudFlsServiceTest.UNEDITABLE_MASTER_DETAIL_FIELD
            ),
            String.format(
                'CrudFlsServiceTest.UNEDITABLE_MASTER_DETAIL_FIELD "{0}" should be a Master-Detail Relationship',
                new List<String>{
                    CrudFlsServiceTest.UNEDITABLE_MASTER_DETAIL_FIELD.getName()
                }
            )
        );
        System.assertEquals(
            false,
            CrudFlsServiceTest.UNEDITABLE_MASTER_DETAIL_FIELD.isUpdateable(),
            String.format(
                'CrudFlsServiceTest.UNEDITABLE_MASTER_DETAIL_FIELD "{0}" should NOT be Updateable, i.e. NOT a re-parentable Master-Detail Relationship',
                new List<String>{
                    CrudFlsServiceTest.UNEDITABLE_MASTER_DETAIL_FIELD.getName()
                }
            )
        );

        // Assert hard-coded Fields match their permissions, e.g. UPDATEABLE_FIELDS are all isUpdateable().
        final Set<String> permissionableGranteeReportFields = new Set<String>();
        
        // Determine which fields allow us to set permissions:
        for (Schema.FieldPermissions fieldPermissions : [
            SELECT Id, Field
            FROM FieldPermissions
            WHERE
                SobjectType = :CrudFlsServiceTest.CUSTOM_OBJECT.getName()
                AND (PermissionsEdit = true OR PermissionsRead = true)
                AND ParentId IN (
                    SELECT PermissionSetId
                    FROM PermissionSetAssignment
                    WHERE AssigneeId = :UserInfo.getUserId()
                )
        ]) {
            permissionableGranteeReportFields.add(
                fieldPermissions.Field.substringAfter('.')
            );
        }

        final Set<Schema.SobjectField> permissionableFields = new Set<Schema.SObjectField>();
        
        final Set<Schema.SobjectField> readableFields = new Set<Schema.SObjectField>();
        final Set<Schema.SobjectField> readableButNotPermissionableFields = new Set<SObjectField>();

        final Set<Schema.SobjectField> createableFields = new Set<Schema.SObjectField>();
        final Set<Schema.SobjectField> createableButNotPermissionableFields = new Set<SObjectField>();
        
        final Set<Schema.SobjectField> updateableFields = new Set<Schema.SObjectField>();
        final Set<Schema.SobjectField> updateableButNotPermissionableFields = new Set<SObjectField>();

        for (
            Schema.DescribeFieldResult fieldDescribe : CrudFlsServiceTest.DESCRIBES_BY_FIELD.values()
        ) {
            final SObjectField sObjectField = fieldDescribe.getSObjectField();

            // Assert the running user has FieldPermissions for all permissionable fields.
            if (fieldDescribe.isPermissionable()) {
                System.assertEquals(
                    true,
                    permissionableGranteeReportFields.contains(fieldDescribe.getName()),
                    String.format(
                        'Field "{0}.{1}" is permissionable and should be editable or readable by the running User with Username "{2}"',
                        new List<String>{
                            CrudFlsServiceTest.CUSTOM_OBJECT.getName(),
                            fieldDescribe.getName(),
                            UserInfo.getUserName()
                        }
                    )
                );

                permissionableFields.add(sObjectField);
            }

            if (fieldDescribe.isAccessible()) {
                // Includes non-permissionable Fields, e.g. RecordTypeId
                readableFields.add(sObjectField);
                
                if (!fieldDescribe.isPermissionable()) {
                    readableButNotPermissionableFields.add(sObjectField);
                }
            }

            if (fieldDescribe.isCreateable()) {
                // Includes non-permissionable Fields, e.g. RecordTypeId
                createableFields.add(sObjectField);

                if (!fieldDescribe.isPermissionable()) {
                    createableButNotPermissionableFields.add(sObjectField);
                }
            }

            if (fieldDescribe.isUpdateable()) {
                // Includes non-permissionable Fields, e.g. RecordTypeId
                updateableFields.add(sObjectField);

                if (!fieldDescribe.isPermissionable()) {
                    updateableButNotPermissionableFields.add(sObjectField);
                }
            }
        }

        System.assertEquals(
            permissionableFields,
            CrudFlsServiceTest.PERMISSIONABLE_FIELDS,
            'CrudFlsServiceTest.PERMISSIONABLE_FIELDS should equal expected'
        );
    
        System.assertEquals(
            readableFields,
            CrudFlsServiceTest.READABLE_FIELDS,
            'CrudFlsServiceTest.READABLE_FIELDS should equal expected'
        );

        System.assertEquals(
            readableButNotPermissionableFields,
            CrudFlsServiceTest.READABLE_BUT_NOT_PERMISSIONABLE_FIELDS,
            'CrudFlsServiceTest.READABLE_BUT_NOT_PERMISSIONABLE_FIELDS should equal expected'
        );

        System.assertEquals(
            createableFields,
            CrudFlsServiceTest.CREATEABLE_FIELDS,
            'CrudFlsServiceTest.CREATEABLE_FIELDS should equal expected'
        );

        System.assertEquals(
            createableButNotPermissionableFields,
            CrudFlsServiceTest.CREATEABLE_BUT_NOT_PERMISSIONABLE_FIELDS,
            'CrudFlsServiceTest.CREATEABLE_BUT_NOT_PERMISSIONABLE_FIELDS should equal expected'
        );
    
        System.assertEquals(
            updateableFields,
            CrudFlsServiceTest.UPDATEABLE_FIELDS,
            'CrudFlsServiceTest.UPDATEABLE_FIELDS should equal expected'
        );

        System.assertEquals(
            updateableButNotPermissionableFields,
            CrudFlsServiceTest.UPDATEABLE_BUT_NOT_PERMISSIONABLE_FIELDS,
            'CrudFlsServiceTest.UPDATEABLE_BUT_NOT_PERMISSIONABLE_FIELDS should equal expected'
        );
    }

    @TestSetup
    public static void testSetup() {
        CrudFlsServiceTest.createAndInsertGranteeReport();

        PermissionSetManager.createAndInsertUserWithoutAnyProfilePermissions(
            CrudFlsServiceTest.READ_ONLY_PROFILE_NAME,
            CrudFlsServiceTest.EMPTY_PERMISSION_SET_NAME,
            new List<Schema.DescribeSObjectResult>{ CUSTOM_OBJECT }
        );
    }

    public static SObject createAndInsertGranteeReport() {
        // We are hard-coding the knowledge that UNEDITABLE_MASTER_DETAIL_FIELD looks up to Opportunity
        final Opportunity masterDetail = TestsObjectProvider.createOpportunity(
            'createAndInsertGranteeReport Master-Detail',
            'Closed',
            Date.today()
        );
        insert masterDetail;

        // We are hard-coding the knowledge that LOOKUP_FIELD looks up to Contact
        final Contact lookup = TestsObjectProvider.createContact(
            'createAndInsertGranteeReport',
            'Lookup',
            (Id) null, // AccountID
            UserInfo.getUserEmail()
        );
        insert lookup;

        final FGM_Base__Grantee_Report__c customRecord = (FGM_Base__Grantee_Report__c) CUSTOM_OBJECT.getSObjectType()
            .newSObject();
        {
            customRecord.put(
                CrudFlsServiceTest.UNEDITABLE_MASTER_DETAIL_FIELD.getName(),
                masterDetail.Id
            );
            customRecord.put(
                CrudFlsServiceTest.LOOKUP_FIELD.getName(),
                lookup.Id
            );
            customRecord.put(CrudFlsServiceTest.BOOLEAN_FIELD.getName(), true);
            customRecord.put(
                CrudFlsServiceTest.DATE_FIELD.getName(),
                Date.today()
            );
            customRecord.put(
                CrudFlsServiceTest.PICKLIST_FIELD.getName(),
                CrudFlsServiceTest.PICKLIST_FIELD.getPicklistValues()[0]
                    .getValue()
            );
            customRecord.put(
                CrudFlsServiceTest.TEXTAREA_FIELD.getName(),
                'text\narea'
            );
            customRecord.put(
                CrudFlsServiceTest.RECORD_TYPE_ID_FIELD.getName(),
                CrudFlsServiceTest.CUSTOM_OBJECT.getRecordTypeInfos()[0]
                    .getRecordTypeId()
            );
        }
        insert customRecord;

        return customRecord;
    }

    public static SObject getCustomObjectRecord() {
        final List<String> fields = new List<String>();
        final List<String> filters = new List<String>();
        for (
            Schema.DescribeFieldResult fieldDescribe : CrudFlsServiceTest.DESCRIBES_BY_FIELD.values()
        ) {
            fields.add(fieldDescribe.getName());
            filters.add(fieldDescribe.getName() + ' != null');
        }

        final String query = String.format(
            'SELECT {0} FROM {1} WHERE {2} LIMIT 1',
            new List<String>{
                String.join(fields, ','),
                CrudFlsServiceTest.CUSTOM_OBJECT.getName(),
                String.join(filters, ' AND ')
            }
        );

        final List<SObject> customRecords = Database.query(query);

        System.assertEquals(
            false,
            customRecords.isEmpty(),
            'query should not return an empty List.  query: ' + query
        );
        return customRecords[0];
    }

    /**
        Only queries fields expected after stripping
     */
    private static SObject getExpectedStrippedRecord(SObject record, Set<Schema.SObjectField> nonPermissionableFields) {
        final Set<String> fields = new Set<String> {
            ID_FIELD.getName()
        };
        for (Schema.SObjectField field : nonPermissionableFields) {
            fields.add(DESCRIBES_BY_FIELD.get(field).getName());
        }

        final Id recordId = (Id) record.get('Id');

        final String query = String.format(
            'SELECT {0} FROM {1} WHERE Id = :recordId LIMIT 1',
            new List<String>{
                String.join(new List<String>(fields), ','),
                CrudFlsServiceTest.CUSTOM_OBJECT.getName()
            }
        );

        final List<SObject> customRecords = Database.query(query);

        System.assertEquals(
            false,
            customRecords.isEmpty(),
            'query should not return an empty List.  query: ' + query
        );
        return customRecords[0];
    }
    /**
        Only queries fields expected after stripping
     */
    private static Set<String> getExpectedReadableFields(String objectName) {
        final Set<String> fields = new Set<String>();
        for (
            Schema.SObjectField field : Schema.getGlobalDescribe()
                .get(objectName)
                .getDescribe()
                .fields.getMap()
                .values()
        ) {
            final Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            fields.add(fieldDescribe.getName());
        }

        System.assertEquals(
            false,
            fields.isEmpty(),
            'should not return an empty set.  query: ' + fields
        );
        return fields;
    }

    @IsTest
    private static void stripInaccessibleForReadNullRecords() {
        final PermissionSetManager permissions = new PermissionSetManager(
            CrudFlsServiceTest.READ_ONLY_PROFILE_NAME,
            CrudFlsServiceTest.EMPTY_PERMISSION_SET_NAME
        );

        final List<SObject> records = null;

        final List<Boolean> objectIsReadables = new List<Boolean>{ true, false };

        System.runAs(permissions.getUser()) {
            Test.startTest();
            //for the lookup field
            permissions.getObjectPermission(Opportunity.sObjectType.getDescribe())
            .setRead(true)
            .save();
            for (Boolean objectIsReadable : objectIsReadables) {
                permissions.getObjectPermission(CUSTOM_OBJECT)
                    .setRead(objectIsReadable)
                    .save();

                List<SObject> actual;
                Exception actualException;

                try {
                    actual = new CrudFlsService().stripInaccessibleForRead(records);
                } catch (Exception e) {
                    actualException = e;
                }

                System.assertEquals(
                    null,
                    actualException,
                    'should never throw an Exception if records is null or empty'
                );
                System.assertNotEquals(
                    null,
                    actual,
                    'should never return null if an Exception is not thrown'
                );
                System.assertEquals(
                    true,
                    actual.isEmpty(),
                    'should return an empty list of SObjects since records is null'
                );
            }

            Test.stopTest();
        }
    }

    @IsTest
    private static void stripInaccessibleForReadEmptyRecords() {
        final PermissionSetManager permissions = new PermissionSetManager(
            CrudFlsServiceTest.READ_ONLY_PROFILE_NAME,
            CrudFlsServiceTest.EMPTY_PERMISSION_SET_NAME
        );

        final List<SObject> records = new List<Account>();
        final List<SObject> expected = records;

        final List<Boolean> objectIsReadables = new List<Boolean>{ true, false };

        System.runAs(permissions.getUser()) {
            Test.startTest();
            //for of the lookup field
            permissions.getObjectPermission(Opportunity.sObjectType.getDescribe())
            .setRead(true)
            .save();
            for (Boolean objectIsReadable : objectIsReadables) {
                permissions.getObjectPermission(CUSTOM_OBJECT)
                    .setRead(objectIsReadable)
                    .save();

                List<SObject> actual;
                Exception actualException;

                try {
                    actual = new CrudFlsService().stripInaccessibleForRead(records);
                } catch (Exception e) {
                    actualException = e;
                }

                System.assertEquals(
                    null,
                    actualException,
                    'should never throw an Exception if records is null or empty'
                );
                System.assertNotEquals(
                    null,
                    actual,
                    'should never return null if an Exception is not thrown'
                );
                System.assertEquals(
                    true,
                    expected === actual,
                    'should return exactly (===) the argument passed in since the argument is non-null and empty'
                );
            }

            Test.stopTest();
        }
    }

    @IsTest
    private static void stripInaccessibleForReadObjectNotReadable() {
        final PermissionSetManager permissions = new PermissionSetManager(
            CrudFlsServiceTest.READ_ONLY_PROFILE_NAME,
            CrudFlsServiceTest.EMPTY_PERMISSION_SET_NAME
        );

        final SObject record = getCustomObjectRecord();
        final List<SObject> records = new List<SObject>{ record };

        final List<SObject> expected = null;

        final List<Boolean> fieldIsReadables = new List<Boolean>{ true, false };

        System.runAs(permissions.getUser()) {
            permissions.getObjectPermission(CUSTOM_OBJECT)
                .setRead(false)
                .setCreate(false)
                .setEdit(false)
                .setDelete(false)
                .setViewAllRecords(false)
                .setModifyAllRecords(false);

            Test.startTest();

            for (Boolean fieldIsReadable : fieldIsReadables) {
                for (
                    Schema.SObjectField field : PERMISSIONABLE_FIELDS
                ) {
                    permissions
                        .getObjectPermission(CUSTOM_OBJECT)
                        .getFieldPermission(
                            CrudFlsServiceTest.DESCRIBES_BY_FIELD.get(field)
                        )
                        .setRead(fieldIsReadable);
                }
                permissions.save();

                List<SObject> actual;
                Exception actualException;

                try {
                    actual = new CrudFlsService().stripInaccessibleForRead(records);
                } catch (Exception e) {
                    actualException = e;
                }

                System.assertEquals(
                    true,
                    actualException instanceof System.NoAccessException,
                    'should throw System.NoAccessException since Object is not Readable.   Actual Exception Type: ' +
                    (actualException == null ? 'null' : actualException.getTypeName())
                );
                System.assertEquals(
                    expected,
                    actual,
                    'should not return anything since Exception was thrown'
                );
            }

            Test.stopTest();
        }
    }

    @IsTest
    private static void stripInaccessibleForReadObjectReadableAllFieldsReadable() {
        final PermissionSetManager permissions = new PermissionSetManager(
            CrudFlsServiceTest.READ_ONLY_PROFILE_NAME,
            CrudFlsServiceTest.EMPTY_PERMISSION_SET_NAME
        );
        //have to have permission to opportunity for the lookup field
        permissions.getObjectPermission(Opportunity.sObjectType.getDescribe())
        .setRead(true)
        .save();

        permissions.getObjectPermission(CUSTOM_OBJECT)
            .setRead(true);

        for (
            Schema.SObjectField field : CrudFlsServiceTest.PERMISSIONABLE_FIELDS
        ) {
            permissions
                .getObjectPermission(CUSTOM_OBJECT)
                .getFieldPermission(CrudFlsServiceTest.DESCRIBES_BY_FIELD.get(field))
                .setRead(true);
        }
        permissions.save();

        final SObject record = getCustomObjectRecord();
        final List<SObject> records = new List<SObject>{
            record,
            record
        };

        final SObject expectedRecord = getExpectedStrippedRecord(record, READABLE_FIELDS);

        final List<SObject> expected = new List<SObject>{
            expectedRecord,
            expectedRecord
        };

        System.runAs(permissions.getUser()) {
            Test.startTest();

            List<SObject> actual;
            Exception actualException;

            try {
                actual = new CrudFlsService().stripInaccessibleForRead(records);
            } catch (Exception e) {
                actualException = e;
            }

            Test.stopTest();

            System.assertEquals(
                null,
                actualException,
                'should not throw Exception since Object is Readable'
            );
            System.assertNotEquals(
                null,
                actual,
                'should never return null if an Exception is not thrown'
            );
            System.assertEquals(
                expected.getSObjectType(),
                actual.getSObjectType(),
                'should return a list with the same getSObjectType()'
            );
            System.assertEquals(
                false,
                expected === actual,
                'should return a deep-cloned List, i.e. should not return a List with the same memory location as the argument (===)'
            );

            final Integer size = expected.size();
            System.assertEquals(
                size,
                actual.size(),
                'should return a List with the same size()'
            );

            for (Integer i = 0; i < size; i++) {
                System.assertNotEquals(
                    null,
                    actual[i],
                    'should never return a List with null members.  index: ' + i
                );

                for (
                    Schema.SObjectField field : CrudFlsServiceTest.CREATEABLE_FIELDS
                ) {
                    final Schema.DescribeFieldResult fieldDescribe = CrudFlsServiceTest.DESCRIBES_BY_FIELD.get(
                        field
                    );
                    System.assertEquals(
                        true,
                        actual[i].isSet(fieldDescribe.getName()),
                        String.format(
                            '{0} of Type "{1}" is readable and should be set, i.e. NOT stripped.  index: ' +
                            i,
                            new List<String>{
                                fieldDescribe.getName(),
                                fieldDescribe.getType().name()
                            }
                        )
                    );
                }
                System.assertEquals(
                    false,
                    expected[i] === actual[i],
                    'should return a List of deep-clones, i.e. should not return a List whose members have the same memory location as the argument members (===).  index: ' +
                    i
                );
                System.assertEquals(
                    expected[i].getPopulatedFieldsAsMap(),
                    actual[i].getPopulatedFieldsAsMap(),
                    'should have the same getPopulatedFieldsAsMap().  index: ' + i
                );
            }
        }
    }

    @IsTest
    private static void stripInaccessibleForInsertNullRecords() {
        final PermissionSetManager permissions = new PermissionSetManager(
            CrudFlsServiceTest.READ_ONLY_PROFILE_NAME,
            CrudFlsServiceTest.EMPTY_PERMISSION_SET_NAME
        );

        final List<SObject> records = null;

        final List<Boolean> objectIsCreatables = new List<Boolean>{ true, false };

        System.runAs(permissions.getUser()) {
            Test.startTest();
            permissions.getObjectPermission(STANDARD_OBJECT)
                    .setRead(true)
                    .save();
            for (Boolean objectIsCreatable : objectIsCreatables) {
                permissions.getObjectPermission(CUSTOM_OBJECT)
                    .setEdit(objectIsCreatable)
                    .save();

                List<SObject> actual;
                Exception actualException;

                try {
                    actual = new CrudFlsService().stripInaccessibleForInsert(records);
                } catch (Exception e) {
                    actualException = e;
                }

                System.assertEquals(
                    null,
                    actualException,
                    'should not throw Exception since Object is Creatable'
                );
                System.assertNotEquals(
                    null,
                    actual,
                    'should never return null if an Exception is not thrown'
                );
                System.assertEquals(
                    true,
                    actual.isEmpty(),
                    'should return an empty list of SObjects since records is null'
                );
            }

            Test.stopTest();
        }
    }

    @IsTest
    private static void stripInaccessibleForInsertEmptyRecords() {
        final PermissionSetManager permissions = new PermissionSetManager(
            CrudFlsServiceTest.READ_ONLY_PROFILE_NAME,
            CrudFlsServiceTest.EMPTY_PERMISSION_SET_NAME
        );

        final List<SObject> records = new List<Account>();
        final List<SObject> expected = records;

        final List<Boolean> objectIsCreatables = new List<Boolean>{ true, false };

        System.runAs(permissions.getUser()) {
            Test.startTest();
            permissions.getObjectPermission(STANDARD_OBJECT)
                 .setRead(true)
                 .save();
            for (Boolean objectIsCreatable : objectIsCreatables) {
                permissions.getObjectPermission(CUSTOM_OBJECT)
                    .setEdit(objectIsCreatable)
                    .save();

                List<SObject> actual;
                Exception actualException;

                try {
                    actual = new CrudFlsService().stripInaccessibleForInsert(records);
                } catch (Exception e) {
                    actualException = e;
                }

                System.assertEquals(
                    null,
                    actualException,
                    'should not throw Exception since Object is Creatable'
                );
                System.assertNotEquals(
                    null,
                    actual,
                    'should never return null if an Exception is not thrown'
                );
                System.assertEquals(
                    true,
                    expected === actual,
                    'should return exactly (===) the argument passed in since the argument is non-null and empty'
                );
            }

            Test.stopTest();
        }
    }

    @IsTest
    private static void stripInaccessibleForInsertObjectNotCreatable() {
        final PermissionSetManager permissions = new PermissionSetManager(
            CrudFlsServiceTest.READ_ONLY_PROFILE_NAME,
            CrudFlsServiceTest.EMPTY_PERMISSION_SET_NAME
        );

        final SObject record = getCustomObjectRecord();
        final List<SObject> records = new List<SObject>{ record };

        final List<SObject> expected = null;

        final List<Boolean> fieldIsReadables = new List<Boolean>{ true, false };
        final List<Boolean> fieldIsEditables = new List<Boolean>{ true, false };

        System.runAs(permissions.getUser()) {
            permissions.getObjectPermission(CUSTOM_OBJECT)
                .setRead(false)
                .setCreate(false)
                .setEdit(false)
                .setDelete(false)
                .setViewAllRecords(false)
                .setModifyAllRecords(false);

            Test.startTest();

            for (Boolean fieldIsReadable : fieldIsReadables) {
                for (Boolean fieldIsEditable : fieldIsEditables) {
                    for (
                        Schema.SObjectField field : PERMISSIONABLE_FIELDS
                    ) {
                        permissions
                            .getObjectPermission(CUSTOM_OBJECT)
                            .getFieldPermission(
                                CrudFlsServiceTest.DESCRIBES_BY_FIELD.get(field)
                            )
                            .setRead(fieldIsReadable)
                            .setEdit(fieldIsEditable);
                    }
                    permissions.save();

                    List<SObject> actual;
                    Exception actualException;

                    try {
                        actual = new CrudFlsService().stripInaccessibleForInsert(records);
                    } catch (Exception e) {
                        actualException = e;
                    }

                    System.assertEquals(
                        true,
                        actualException instanceof System.NoAccessException,
                        'should throw System.NoAccessException since Object is not Creatable.   Actual Exception Type: ' +
                        (actualException == null ? 'null' : actualException.getTypeName())
                    );
                    System.assertEquals(
                        expected,
                        actual,
                        'should not return anything since Exception was thrown'
                    );
                }
            }

            Test.stopTest();
        }
    }

    @IsTest
    private static void stripInaccessibleForInsertObjectCreatableAllFieldsEditable() {
        final PermissionSetManager permissions = new PermissionSetManager(
            CrudFlsServiceTest.READ_ONLY_PROFILE_NAME,
            CrudFlsServiceTest.EMPTY_PERMISSION_SET_NAME
        );

        permissions.getObjectPermission(STANDARD_OBJECT)
            .setRead(true)
            .save();

        permissions.getObjectPermission(CUSTOM_OBJECT)
            .setCreate(true)
            .setRead(true);

        for (
            Schema.SObjectField field : CrudFlsServiceTest.PERMISSIONABLE_FIELDS
        ) {
            permissions
                .getObjectPermission(CUSTOM_OBJECT)
                .getFieldPermission(CrudFlsServiceTest.DESCRIBES_BY_FIELD.get(field))
                .setRead(true)
                .setEdit(true);
        }
        permissions.save();

        final SObject record = getCustomObjectRecord();
        record.Id = null;

        final List<SObject> records = new List<SObject>{ record };

        final SObject expectedRecord = record.getSObjectType().newSObject();
        {
            
            for (Schema.SObjectField field : CREATEABLE_FIELDS) {
                final Schema.DescribeFieldResult fieldDescribe = CrudFlsServiceTest.DESCRIBES_BY_FIELD.get(
                    field
                );
                expectedRecord.put(
                    fieldDescribe.getName(),
                    record.get(fieldDescribe.getName())
                );
            }
        }

        final List<SObject> expected = new List<SObject>{ expectedRecord };

        System.runAs(permissions.getUser()) {
            Test.startTest();

            List<SObject> actual;
            Exception actualException;

            try {
                actual = new CrudFlsService().stripInaccessibleForInsert(records);
            } catch (Exception e) {
                actualException = e;                
            }

            Test.stopTest();

            System.assertEquals(
                null,
                actualException,
                'should not throw Exception since Object is Creatable'
            );
            System.assertNotEquals(
                null,
                actual,
                'should never return null if an Exception is not thrown'
            );
            System.assertEquals(
                expected.getSObjectType(),
                actual.getSObjectType(),
                'should return a list with the same getSObjectType()'
            );
            System.assertEquals(
                false,
                expected === actual,
                'should return a deep-cloned List, i.e. should not return a List with the same memory location as the argument (===)'
            );

            final Integer size = expected.size();
            System.assertEquals(
                size,
                actual.size(),
                'should return a List with the same size()'
            );

            for (Integer i = 0; i < size; i++) {
                System.assertNotEquals(
                    null,
                    actual[i],
                    'should never return a List with null members.  index: ' + i
                );

                for (
                    Schema.SObjectField field : CrudFlsServiceTest.CREATEABLE_FIELDS
                ) {
                    final Schema.DescribeFieldResult fieldDescribe = CrudFlsServiceTest.DESCRIBES_BY_FIELD.get(
                        field
                    );
                    System.assertEquals(
                        true,
                        actual[i].isSet(fieldDescribe.getName()),
                        String.format(
                            '{0} of Type "{1}" is creatable and should be set, i.e. NOT stripped.  index: ' +
                            i,
                            new List<String>{
                                fieldDescribe.getName(),
                                fieldDescribe.getType().name()
                            }
                        )
                    );
                }
                System.assertEquals(
                    false,
                    expected[i] === actual[i],
                    'should return a List of deep-clones, i.e. should not return a List whose members have the same memory location as the argument members (===).  index: ' +
                    i
                );
                System.assertEquals(
                    expected[i].getPopulatedFieldsAsMap(),
                    actual[i].getPopulatedFieldsAsMap(),
                    'should have the same getPopulatedFieldsAsMap().  index: ' + i
                );
            }
        }
    }

    
    @IsTest
    private static void stripInaccessibleForUpdateNullRecords() {
        final PermissionSetManager permissions = new PermissionSetManager(
            CrudFlsServiceTest.READ_ONLY_PROFILE_NAME,
            CrudFlsServiceTest.EMPTY_PERMISSION_SET_NAME
        );

        final List<SObject> records = null;

        final List<Boolean> objectIsUpdateables = new List<Boolean>{ true, false };

        System.runAs(permissions.getUser()) {
            Test.startTest();

            for (Boolean objectIsUpdateable : objectIsUpdateables) {
                permissions.getObjectPermission(CUSTOM_OBJECT)
                    .setEdit(objectIsUpdateable)
                    .save();

                List<SObject> actual;
                Exception actualException;

                try {
                    actual = new CrudFlsService().stripInaccessibleForUpdate(records);
                } catch (Exception e) {
                    actualException = e;
                }

                System.assertEquals(
                    null,
                    actualException,
                    'should not throw Exception since Object is Updateable'
                );
                System.assertNotEquals(
                    null,
                    actual,
                    'should never return null if an Exception is not thrown'
                );
                System.assertEquals(
                    true,
                    actual.isEmpty(),
                    'should return an empty list of SObjects since records is null'
                );
            }

            Test.stopTest();
        }
    }

    @IsTest
    private static void stripInaccessibleForUpdateEmptyRecords() {
        final PermissionSetManager permissions = new PermissionSetManager(
            CrudFlsServiceTest.READ_ONLY_PROFILE_NAME,
            CrudFlsServiceTest.EMPTY_PERMISSION_SET_NAME
        );

        final List<SObject> records = new List<Account>();
        final List<SObject> expected = records;

        final List<Boolean> objectIsUpdateables = new List<Boolean>{ true, false };

        System.runAs(permissions.getUser()) {
            Test.startTest();

            for (Boolean objectIsUpdateable : objectIsUpdateables) {
                permissions.getObjectPermission(CUSTOM_OBJECT)
                    .setEdit(objectIsUpdateable)
                    .save();

                List<SObject> actual;
                Exception actualException;

                try {
                    actual = new CrudFlsService().stripInaccessibleForUpdate(records);
                } catch (Exception e) {
                    actualException = e;
                }

                System.assertEquals(
                    null,
                    actualException,
                    'should not throw Exception since Object is Updateable'
                );
                System.assertNotEquals(
                    null,
                    actual,
                    'should never return null if an Exception is not thrown'
                );
                System.assertEquals(
                    true,
                    expected === actual,
                    'should return exactly (===) the argument passed in since the argument is non-null and empty'
                );
            }

            Test.stopTest();
        }
    }

    @IsTest
    private static void stripInaccessibleForUpdateObjectNotUpdateable() {
        final PermissionSetManager permissions = new PermissionSetManager(
            CrudFlsServiceTest.READ_ONLY_PROFILE_NAME,
            CrudFlsServiceTest.EMPTY_PERMISSION_SET_NAME
        );

        final SObject record = getCustomObjectRecord();
        final List<SObject> records = new List<SObject>{ record };

        final List<SObject> expected = null;

        final List<Boolean> fieldIsReadables = new List<Boolean>{ true, false };
        final List<Boolean> fieldIsEditables = new List<Boolean>{ true, false };

        System.runAs(permissions.getUser()) {
            permissions.getObjectPermission(CUSTOM_OBJECT)
                .setRead(false)
                .setCreate(false)
                .setEdit(false)
                .setDelete(false)
                .setViewAllRecords(false)
                .setModifyAllRecords(false);

            Test.startTest();

            for (Boolean fieldIsReadable : fieldIsReadables) {
                for (Boolean fieldIsEditable : fieldIsEditables) {
                    for (
                        Schema.SObjectField field : PERMISSIONABLE_FIELDS
                    ) {
                        permissions
                            .getObjectPermission(CUSTOM_OBJECT)
                            .getFieldPermission(
                                CrudFlsServiceTest.DESCRIBES_BY_FIELD.get(field)
                            )
                            .setRead(fieldIsReadable)
                            .setEdit(fieldIsEditable);
                    }
                    permissions.save();

                    List<SObject> actual;
                    Exception actualException;

                    try {
                        actual = new CrudFlsService().stripInaccessibleForUpdate(records);
                    } catch (Exception e) {
                        actualException = e;
                    }

                    System.assertEquals(
                        true,
                        actualException instanceof System.NoAccessException,
                        'should throw System.NoAccessException since Object is not Editable.   Actual Exception Type: ' +
                        (actualException == null ? 'null' : actualException.getTypeName())
                    );
                    System.assertEquals(
                        expected,
                        actual,
                        'should not return anything since Exception was thrown'
                    );
                }
            }

            Test.stopTest();
        }
    }

    @IsTest
    private static void stripInaccessibleForUpdateObjectUpdateableAllFieldsEditable() {
        final PermissionSetManager permissions = new PermissionSetManager(
            CrudFlsServiceTest.READ_ONLY_PROFILE_NAME,
            CrudFlsServiceTest.EMPTY_PERMISSION_SET_NAME
        );

        permissions.getObjectPermission(CUSTOM_OBJECT).setEdit(true);

        for (
            Schema.SObjectField field : CrudFlsServiceTest.PERMISSIONABLE_FIELDS
        ) {
            permissions
                .getObjectPermission(CUSTOM_OBJECT)
                .getFieldPermission(CrudFlsServiceTest.DESCRIBES_BY_FIELD.get(field))
                .setEdit(true);
        }
        permissions.save();

        final SObject record = getCustomObjectRecord();
        final List<SObject> records = new List<SObject>{ record };

        final SObject expectedRecord = record.getSObjectType().newSObject();
        {
            expectedRecord.put('Id', record.get('Id')); // Id should never be stripped
            for (Schema.SObjectField field : UPDATEABLE_FIELDS) {
                final Schema.DescribeFieldResult fieldDescribe = CrudFlsServiceTest.DESCRIBES_BY_FIELD.get(
                    field
                );
                expectedRecord.put(
                    fieldDescribe.getName(),
                    record.get(fieldDescribe.getName())
                );
            }
        }

        final List<SObject> expected = new List<SObject>{ expectedRecord };

        System.runAs(permissions.getUser()) {
            Test.startTest();

            List<SObject> actual;
            Exception actualException;

            try {
                actual = new CrudFlsService().stripInaccessibleForUpdate(records);
            } catch (Exception e) {
                actualException = e;
            }

            Test.stopTest();

            System.assertEquals(
                null,
                actualException,
                'should not throw Exception since Object is Updateable'
            );
            System.assertNotEquals(
                null,
                actual,
                'should never return null if an Exception is not thrown'
            );
            System.assertEquals(
                expected.getSObjectType(),
                actual.getSObjectType(),
                'should return a list with the same getSObjectType()'
            );
            System.assertEquals(
                false,
                expected === actual,
                'should return a deep-cloned List, i.e. should not return a List with the same memory location as the argument (===)'
            );

            final Integer size = expected.size();
            System.assertEquals(
                size,
                actual.size(),
                'should return a List with the same size()'
            );

            for (Integer i = 0; i < size; i++) {
                System.assertNotEquals(
                    null,
                    actual[i],
                    'should never return a List with null members.  index: ' + i
                );
                System.assertEquals(
                    true,
                    actual[i].isSet('Id'),
                    '"Id" field should be set, i.e. NOT stripped, since Object is Editable.  index: ' +
                    i
                );
                for (
                    Schema.SObjectField field : CrudFlsServiceTest.UPDATEABLE_FIELDS
                ) {
                    final Schema.DescribeFieldResult fieldDescribe = CrudFlsServiceTest.DESCRIBES_BY_FIELD.get(
                        field
                    );
                    System.assertEquals(
                        true,
                        actual[i].isSet(fieldDescribe.getName()),
                        String.format(
                            '{0} of Type "{1}" is updateable and should be set, i.e. NOT stripped.  index: ' +
                            i,
                            new List<String>{
                                fieldDescribe.getName(),
                                fieldDescribe.getType().name()
                            }
                        )
                    );
                }
                System.assertEquals(
                    false,
                    expected[i] === actual[i],
                    'should return a List of deep-clones, i.e. should not return a List whose members have the same memory location as the argument members (===).  index: ' +
                    i
                );
                System.assertEquals(
                    expected[i].getPopulatedFieldsAsMap(),
                    actual[i].getPopulatedFieldsAsMap(),
                    'should have the same getPopulatedFieldsAsMap().  index: ' + i
                );
            }
        }
    }

    @IsTest
    private static void stripInaccessibleForUpdateObjectUpdateableNoFieldsEditable() {
        final PermissionSetManager permissions = new PermissionSetManager(
            CrudFlsServiceTest.READ_ONLY_PROFILE_NAME,
            CrudFlsServiceTest.EMPTY_PERMISSION_SET_NAME
        );

        final SObject record = getCustomObjectRecord();
        final List<SObject> records = new List<SObject>{ record };

        final SObject expectedRecord = record.getSObjectType().newSObject();
        {
            expectedRecord.put('Id', record.get('Id'));
            // All DESCRIBES_BY_FIELD should be stripped.
            for (
                Schema.SObjectField field : CrudFlsServiceTest.UPDATEABLE_BUT_NOT_PERMISSIONABLE_FIELDS
            ) {
                final Schema.DescribeFieldResult fieldDescribe = CrudFlsServiceTest.DESCRIBES_BY_FIELD.get(
                    field
                );
                expectedRecord.put(
                    fieldDescribe.getName(),
                    record.get(fieldDescribe.getName())
                );
            }
        }

        final List<SObject> expected = new List<SObject>{ expectedRecord };

        permissions.getObjectPermission(CUSTOM_OBJECT)
            .setEdit(true)
            .save()
            .deleteAllFieldPermissions();

        System.runAs(permissions.getUser()) {
            Test.startTest();

            List<SObject> actual;
            Exception actualException;

            try {
                actual = new CrudFlsService().stripInaccessibleForUpdate(records);
            } catch (Exception e) {
                actualException = e;
            }

            Test.stopTest();

            System.assertEquals(
                null,
                actualException,
                'should not throw Exception since Object is Updateable'
            );
            System.assertNotEquals(
                null,
                actual,
                'should never return null if an Exception is not thrown'
            );
            System.assertEquals(
                expected.getSObjectType(),
                actual.getSObjectType(),
                'should return a list with the same getSObjectType()'
            );
            System.assertEquals(
                false,
                expected === actual,
                'should return a deep-cloned List, i.e. should not return a List with the same memory location as the argument (===)'
            );

            final Integer size = expected.size();
            System.assertEquals(
                size,
                actual.size(),
                'should return a List with the same size()'
            );

            for (Integer i = 0; i < size; i++) {
                System.assertNotEquals(
                    null,
                    actual[i],
                    'should never return a List with null members.  index: ' + i
                );
                System.assertEquals(
                    true,
                    actual[i].isSet('Id'),
                    '"Id" field should be set, i.e. NOT stripped, since Object is Editable.  index: ' +
                    i
                );
                for (
                    Schema.SObjectField field : CrudFlsServiceTest.UPDATEABLE_FIELDS
                ) {
                    final Schema.DescribeFieldResult fieldDescribe = CrudFlsServiceTest.DESCRIBES_BY_FIELD.get(
                        field
                    );

                    if (
                        CrudFlsServiceTest.PERMISSIONABLE_FIELDS.contains(
                            field
                        )
                    ) {
                        System.assertEquals(
                            false,
                            actual[i].isSet(fieldDescribe.getName()),
                            String.format(
                                '{0} of Type "{1}" is permissionable and should NOT be set, i.e. stripped.  index: ' +
                                i,
                                new List<String>{
                                    fieldDescribe.getName(),
                                    fieldDescribe.getType().name()
                                }
                            )
                        );
                    } else {
                        System.assertEquals(
                            true,
                            actual[i].isSet(fieldDescribe.getName()),
                            String.format(
                                '{0} of Type "{1}" is NOT permissionable should be set, i.e. NOT stripped.  index: ' +
                                i,
                                new List<String>{
                                    fieldDescribe.getName(),
                                    fieldDescribe.getType().name()
                                }
                            )
                        );
                    }
                }
                System.assertEquals(
                    false,
                    expected[i] === actual[i],
                    'should return a List of deep-clones, i.e. should not return a List whose members have the same memory location as the argument members (===).  index: ' +
                    i
                );
                System.assertEquals(
                    expected[i].getPopulatedFieldsAsMap(),
                    actual[i].getPopulatedFieldsAsMap(),
                    'should have the same getPopulatedFieldsAsMap().  index: ' + i
                );
            }
        }
    }
    
    // Legacy tests
    @isTest
    private static void testGetPopulatedFields() {
        Account a = new Account(Name = 'Test Account');
        Contact c = new Contact(FirstName = 'Test Contact', Account = a);
        List<Contact> contacts = new List<Contact>{ c };

        CrudFlsService cfs = CrudFlsService.getInstance();

        Set<Schema.SObjectField> actual = cfs.getPopulatedFields(contacts);
        Set<Schema.SObjectField> expected = new Set<Schema.SObjectField>{
            Contact.FirstName
        };

        System.assertEquals(expected, actual);
    }

    private static void createSampleGranteeBudgetUpdate() {
        Opportunity opportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Closed',
            CloseDate = Date.today()
        );
        insert opportunity;

        FGM_Base__Grantee_Report__c granteeReport = new FGM_Base__Grantee_Report__c(
            FGM_Base__Request__c = opportunity.Id
        );

        insert granteeReport;

        insert new Grantee_Budget_Update__c(Grantee_Report__c = granteeReport.Id);
    }

    @isTest
    private static void testFormulaFieldDoesNotThrowFlsUpdateFailure() {
        // if a Grantee_Budget_Update__c record has the Approved_Budget_New__c
        // rollup field set in memory, it should not fail an FLS check on that
        // record because that field will never be inserted or updated as part
        // of DML.

        createSampleGranteeBudgetUpdate();

        Boolean exceptionThrown = false;

        try {
            Grantee_Budget_Update__c gbr = [
                SELECT Approved_Budget_New__c
                FROM Grantee_Budget_Update__c
                LIMIT 1
            ];

            CrudFlsService.getInstance().assertUpdateable(gbr);
        } catch (CrudFlsService.CrudFlsException e) {
            exceptionThrown = true;
        }

        System.assertEquals(false, exceptionThrown);
    }

    @isTest
    private static void testFormualFieldDoesNotThrowFlsCreateFailure() {
        // if a Grantee_Budget_Update__c record has the Approved_Budget_New__c
        // rollup field set in memory, it should not fail an FLS check on that
        // record because that field will never be inserted or updated as part
        // of DML.

        createSampleGranteeBudgetUpdate();

        Boolean exceptionThrown = false;

        try {
            Grantee_Budget_Update__c gbr = [
                SELECT Approved_Budget_New__c
                FROM Grantee_Budget_Update__c
                LIMIT 1
            ];

            CrudFlsService.getInstance().assertCreateable(gbr);
        } catch (CrudFlsService.CrudFlsException e) {
            exceptionThrown = true;
        }

        System.assertEquals(false, exceptionThrown);
    }

    @isTest
    private static void shouldThrowExceptionIfUserCannotDeleteObject() {
        User readOnlyUser = createReadOnlyUser();

        CrudFlsService.CrudFlsException expectedException;

        System.runAs(readOnlyUser) {
            try {
                CrudFlsService.getInstance().assertDeletable(new Contact());
            } catch (CrudFlsService.CrudFlsException e) {
                expectedException = e;
            }
        }

        System.assertNotEquals(
            null,
            expectedException,
            'A CrudFlsService.CrudFlsException should be thrown'
        );
        System.assertEquals(
            'Cannot delete object of type Contact',
            expectedException.getMessage(),
            'The exception should have the correct error message'
        );
    }

    @isTest
    private static void shouldThrowExceptionIfUserCannotDeleteObjectById() {
        User readOnlyUser = createReadOnlyUser();

        CrudFlsService.CrudFlsException expectedException;

        System.runAs(readOnlyUser) {
            try {
                CrudFlsService.getInstance()
                    .assertDeletable(new List<String>{ MOCK_CONTACT_ID });
            } catch (CrudFlsService.CrudFlsException e) {
                expectedException = e;
            }
        }

        System.assertNotEquals(
            null,
            expectedException,
            'A CrudFlsService.CrudFlsException should be thrown'
        );
        System.assertEquals(
            'Cannot delete object of type Contact',
            expectedException.getMessage(),
            'The exception should have the correct error message'
        );
    }

    @isTest
    private static void shouldNotThrowExceptionIfUserCanDeleteObject() {
        User sysAdmin = createSysAdminUser();

        CrudFlsService.CrudFlsException unexpectedException;

        System.runAs(sysAdmin) {
            try {
                CrudFlsService.getInstance().assertDeletable(new Contact());
            } catch (CrudFlsService.CrudFlsException e) {
                unexpectedException = e;
            }
        }

        System.assertEquals(
            null,
            unexpectedException,
            'A CrudFlsService.CrudFlsException should not be thrown'
        );
    }

    @isTest
    private static void shouldNotThrowExceptionIfUserCanDeleteObjectById() {
        User sysAdmin = createSysAdminUser();

        CrudFlsService.CrudFlsException unexpectedException;

        System.runAs(sysAdmin) {
            try {
                CrudFlsService.getInstance()
                    .assertDeletable(new List<String>{ MOCK_CONTACT_ID });
            } catch (CrudFlsService.CrudFlsException e) {
                unexpectedException = e;
            }
        }

        System.assertEquals(
            null,
            unexpectedException,
            'A CrudFlsService.CrudFlsException should not be thrown'
        );
    }

    @isTest
    private static void shouldThrowExceptionIfUserCannotCreateField() {
        User readOnlyUser = createReadOnlyUser();

        CrudFlsService.CrudFlsException expectedException;

        System.runAs(readOnlyUser) {
            try {
                CrudFlsService.getInstance()
                    .assertCreateable(new Contact(DoNotCall = true));
            } catch (CrudFlsService.CrudFlsException e) {
                expectedException = e;
            }
        }

        System.assertNotEquals(
            null,
            expectedException,
            'A CrudFlsService.CrudFlsException should be thrown'
        );
        System.assertEquals(
            'Cannot create field Contact.DoNotCall',
            expectedException.getMessage(),
            'The exception should have the correct error message'
        );
    }

    @isTest
    private static void shouldNotThrowExceptionIfUserCanCreateField() {
        User sysAdmin = createSysAdminUser();

        CrudFlsService.CrudFlsException unexpectedException;

        System.runAs(sysAdmin) {
            try {
                CrudFlsService.getInstance()
                    .assertCreateable(new Contact(DoNotCall = true));
            } catch (CrudFlsService.CrudFlsException e) {
                unexpectedException = e;
            }
        }

        System.assertEquals(
            null,
            unexpectedException,
            'A CrudFlsService.CrudFlsException should not be thrown'
        );
    }

    @isTest
    private static void shouldThrowExceptionIfUserCannotUpdateField() {
        User readOnlyUser = createReadOnlyUser();

        CrudFlsService.CrudFlsException expectedException;

        System.runAs(readOnlyUser) {
            try {
                CrudFlsService.getInstance()
                    .assertUpdateable(new Contact(DoNotCall = true));
            } catch (CrudFlsService.CrudFlsException e) {
                expectedException = e;
            }
        }

        System.assertNotEquals(
            null,
            expectedException,
            'A CrudFlsService.CrudFlsException should be thrown'
        );
        System.assertEquals(
            'Cannot update field Contact.DoNotCall',
            expectedException.getMessage(),
            'The exception should have the correct error message'
        );
    }

    @isTest
    private static void shouldNotThrowExceptionIfUserCanUpdateField() {
        User sysAdmin = createSysAdminUser();

        CrudFlsService.CrudFlsException unexpectedException;

        System.runAs(sysAdmin) {
            try {
                CrudFlsService.getInstance()
                    .assertUpdateable(new Contact(DoNotCall = true));
            } catch (CrudFlsService.CrudFlsException e) {
                unexpectedException = e;
            }
        }

        System.assertEquals(
            null,
            unexpectedException,
            'A CrudFlsService.CrudFlsException should not be thrown'
        );
    }

    private static User createReadOnlyUser() {
        return TestSObjectProvider.createUserWithProfile('Read Only');
    }

    private static User createSysAdminUser() {
        return TestSObjectProvider.createUserWithProfile('System Administrator');
    }
    @IsTest
    private static void unitTestStripInaccessibleForUpdate() {

        // Set arguments
        final List<SObject> records = new List<SObject>();

        // Set stub methods with expected arugments and return values
        final CrudFlsServiceTest.StripInaccessibleForUpdateMethod stripInaccessibleForUpdate = new CrudFlsServiceTest.StripInaccessibleForUpdateMethod();
        {
            stripInaccessibleForUpdate.records = records;            
            stripInaccessibleForUpdate.returnValue = new List<SObject>();
        }

        // Set stub with the stub methods in the order we expected the methods to be called
        final Stub stub = new Stub(new List<Stub.Method> {
            stripInaccessibleForUpdate
        });

        // Set expected
        final List<SObject> expected = stripInaccessibleForUpdate.returnValue;

        Test.startTest();

        // Create service instance + set stubs for all services
        final CrudFlsService crudFlsService = (CrudFlsService) Test.createStub(
            CrudFlsService.class,
            stub
        );        
        // Run the test: Set actual (execute the stubbed method)
        final List<SObject> actual = crudFlsService.stripInaccessibleForUpdate(records);

        Test.stopTest();

        // Assert all the expected Stub methods were called
        stub.assertMethodsCalled();

        // Assert expected equals actual
        System.assertEquals(
            true,
            expected === actual
        );
    }
        @IsTest
    private static void unitTestStripInaccessibleForUpdateSingle() {

        // Set arguments
        final SObject record = new Account();

        // Set stub methods with expected arugments and return values
        final CrudFlsServiceTest.StripInaccessibleForUpdateSingleMethod stripInaccessibleForUpdate = new CrudFlsServiceTest.StripInaccessibleForUpdateSingleMethod();
        {
            stripInaccessibleForUpdate.record = record;                
            stripInaccessibleForUpdate.returnValue = new Account();
        }

        // Set stub with the stub methods in the order we expected the methods to be called
        final Stub stub = new Stub(new List<Stub.Method> {
            stripInaccessibleForUpdate
        });

        // Set expected
        final SObject expected = stripInaccessibleForUpdate.returnValue;

        Test.startTest();

        // Create service instance + set stubs for all services
        final CrudFlsService crudFlsService = (CrudFlsService) Test.createStub(
            CrudFlsService.class,
            stub
        );
        
        

        // Run the test: Set actual (execute the stubbed method)
        final SObject actual = crudFlsService.stripInaccessibleForUpdate(record);

        Test.stopTest();

        // Assert all the expected Stub methods were called
        stub.assertMethodsCalled();

        // Assert expected equals actual
        System.assertEquals(true, expected === actual);
    }

    @IsTest
    private static void getReadableFieldsBlankObjectName() {
        final PermissionSetManager permissions = new PermissionSetManager(
            CrudFlsServiceTest.READ_ONLY_PROFILE_NAME,
            CrudFlsServiceTest.EMPTY_PERMISSION_SET_NAME
        );

        final String objectName;

        System.runAs(permissions.getUser()) {
            Test.startTest();

            Set<String> actual;
            Exception actualException;

            try {
                actual = new CrudFlsService().getReadableFields(objectName);
            } catch (Exception e) {
                actualException = e;
            }

            System.assertEquals(
                null,
                actualException,
                'should never throw an Exception if records is null or empty'
            );
            System.assertNotEquals(
                null,
                actual,
                'should never return null if an Exception is not thrown'
            );
            System.assertEquals(
                true,
                actual.isEmpty(),
                'should return an empty list of SObjects since records is null'
            );

            Test.stopTest();
        }
    }

    @IsTest
    private static void getReadableFieldsNonExistingObjectName() {
        final PermissionSetManager permissions = new PermissionSetManager(
            CrudFlsServiceTest.READ_ONLY_PROFILE_NAME,
            CrudFlsServiceTest.EMPTY_PERMISSION_SET_NAME
        );

        final String objectName = 'GarbageObjectName';

        System.runAs(permissions.getUser()) {
            Test.startTest();

            Set<String> actual;
            Exception actualException;

            try {
                actual = new CrudFlsService().getReadableFields(objectName);
            } catch (Exception e) {
                actualException = e;
            }

            System.assertEquals(
                null,
                actualException,
                'should never throw an Exception if records is null or empty'
            );
            System.assertNotEquals(
                null,
                actual,
                'should never return null if an Exception is not thrown'
            );
            System.assertEquals(
                true,
                actual.isEmpty(),
                'should return an empty list of SObjects since records is null'
            );

            Test.stopTest();
        }
    }

    @IsTest
    private static void getReadableFieldsObjectNotReadable() {
        final PermissionSetManager permissions = new PermissionSetManager(
            CrudFlsServiceTest.READ_ONLY_PROFILE_NAME,
            CrudFlsServiceTest.EMPTY_PERMISSION_SET_NAME
        );

        final String objectName = CUSTOM_OBJECT.getName();

        final Set<String> expected = null;

        final List<Boolean> fieldIsReadables = new List<Boolean>{ true, false };

        System.runAs(permissions.getUser()) {
            permissions.getObjectPermission(CUSTOM_OBJECT)
                .setRead(false)
                .setCreate(false)
                .setEdit(false)
                .setDelete(false)
                .setViewAllRecords(false)
                .setModifyAllRecords(false);

            Test.startTest();

            for (Boolean fieldIsReadable : fieldIsReadables) {
                for (Schema.SObjectField field : PERMISSIONABLE_FIELDS) {
                    permissions
                        .getObjectPermission(CUSTOM_OBJECT)
                        .getFieldPermission(
                            CrudFlsServiceTest.DESCRIBES_BY_FIELD.get(field)
                        )
                        .setRead(fieldIsReadable);
                }
                permissions.save();

                Set<String> actual;
                Exception actualException;

                try {
                    actual = new CrudFlsService().getReadableFields(objectName);
                } catch (Exception e) {
                    actualException = e;
                }

                System.assertEquals(
                    true,
                    actualException instanceof System.NoAccessException,
                    'should throw System.NoAccessException since Object is not Readable.   Actual Exception Type: ' +
                    (actualException == null ? 'null' : actualException.getTypeName())
                );
                System.assertEquals(
                    expected,
                    actual,
                    'should not return anything since Exception was thrown'
                );
            }

            Test.stopTest();
        }
    }

    ////////////////////////////
    //Begin stub method classes
    ////////////////////////////
    public class StripInaccessibleForUpdateMethod extends Stub.Method {
        public List<SObject> records;

        public List<SObject> returnValue;

        public StripInaccessibleForUpdateMethod() {
            super(
                CrudFlsService.class,
                List<SObject>.class,
                'stripInaccessibleForUpdate',
                new List<Stub.Parameter>{
                    new Stub.Parameter(List<SObject>.class, 'records')
                        .setAssertArgumentHasExactEquality(true)
                }
            );
        }

        public override Boolean isInstanceOf(Object instance) {
            return instance instanceof CrudFlsService;
        }

        public override List<Object> getExpectedArguments() {
            return new List<Object>{ this.records };
        }

        public override Object getReturnValue() {
            return this.returnValue;
        }
    }

    public class StripInaccessibleForInsertMethod extends Stub.Method {
        public List<SObject> records;

        public List<SObject> returnValue;

        public StripInaccessibleForInsertMethod() {
            super(
                CrudFlsService.class,
                List<SObject>.class,
                'stripInaccessibleForInsert',
                new List<Stub.Parameter>{
                    new Stub.Parameter(List<SObject>.class, 'records')
                        .setAssertArgumentHasExactEquality(true)
                }
            );
        }

        public override Boolean isInstanceOf(Object instance) {
            return instance instanceof CrudFlsService;
        }

        public override List<Object> getExpectedArguments() {
            return new List<Object>{ this.records };
        }

        public override Object getReturnValue() {
            return this.returnValue;
        }
    }

    public class StripInaccessibleForReadMethod extends Stub.Method {
        public List<SObject> records;

        public List<SObject> returnValue;

        public StripInaccessibleForReadMethod() {
            super(
                CrudFlsService.class,
                List<SObject>.class,
                'stripInaccessibleForRead',
                new List<Stub.Parameter>{
                    new Stub.Parameter(List<SObject>.class, 'records')
                        .setAssertArgumentHasExactEquality(true)
                }
            );
        }

        public override Boolean isInstanceOf(Object instance) {
            return instance instanceof CrudFlsService;
        }

        public override List<Object> getExpectedArguments() {
            return new List<Object>{ this.records };
        }

        public override Object getReturnValue() {
            return this.returnValue;
        }
    }

    public class GetReadableFieldsMethod extends Stub.Method {
        public String objectName;

        public Set<String> returnValue;

        public GetReadableFieldsMethod() {
            super(
                CrudFlsService.class,
                Set<String>.class,
                'getReadableFields',
                new List<Stub.Parameter>{
                    new Stub.Parameter(String.class, 'objectName')
                    //.setAssertArgumentHasExactEquality(true)
                }
            );
        }

        public override Boolean isInstanceOf(Object instance) {
            return instance instanceof CrudFlsService;
        }

        public override List<Object> getExpectedArguments() {
            return new List<Object>{ this.objectName };
        }

        public override Object getReturnValue() {
            return this.returnValue;
        }
    }

    public class StripInaccessibleForUpdateSingleMethod extends Stub.Method {
        public SObject record;

        public SObject returnValue;

        public StripInaccessibleForUpdateSingleMethod() {
            super(
                CrudFlsService.class,
                SObject.class,
                'stripInaccessibleForUpdate',
                new List<Stub.Parameter>{
                    new Stub.Parameter(SObject.class, 'record')
                        .setAssertArgumentHasExactEquality(true)
                }
            );
        }

        public override Boolean isInstanceOf(Object instance) {
            return instance instanceof CrudFlsService;
        }

        public override List<Object> getExpectedArguments() {
            return new List<Object>{ this.record };
        }

        public override Object getReturnValue() {
            return this.returnValue;
        }
    }

}