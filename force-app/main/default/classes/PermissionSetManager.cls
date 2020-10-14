@IsTest
public without sharing class PermissionSetManager {
    public enum FLS {READ, EDIT, NONE}

    private final User user;
    private final String permissionSetName;
    private final Id permissionSetId;
    private final Map<String, PermissionSetManager.ObjectPermission> objectPermissionsBySObjectType;

    public PermissionSetManager(String profileName, String permissionSetName) {
        List<PermissionSet> permissionSets = [
            SELECT
                Id,
                Name,
                (
                    SELECT
                        Id,
                        ParentId,
                        SobjectType,
                        PermissionsRead,
                        PermissionsCreate,
                        PermissionsEdit,
                        PermissionsDelete,
                        PermissionsViewAllRecords,
                        PermissionsModifyAllRecords
                    FROM ObjectPerms // API Name: ObjectPermissions
                    ORDER BY SobjectType
                ),
                (
                    SELECT
                        Id,
                        ParentId,
                        SobjectType,
                        Field,
                        PermissionsRead,
                        PermissionsEdit
                    FROM FieldPerms // API Name: FieldPermissions
                    ORDER BY Field
                ),
                (
                    SELECT
                        Id,
                        AssigneeId,
                        Assignee.Username,
                        Assignee.ProfileId,
                        Assignee.Profile.Name
                    FROM Assignments // API Name: PermissionSetAssignment
                    WHERE
                        Assignee.IsActive = true
                        AND Assignee.Profile.Name = :profileName
                    LIMIT 1
                )
            FROM PermissionSet
            WHERE Name = :permissionSetName
            LIMIT 1
        ];
        System.assertEquals(
            false,
            permissionSets.isEmpty(),
            'No PermissionSet found with Name "' +
            permissionSetName +
            '"'
        );
        final PermissionSet permissionSet = permissionSets[0];

        System.assertEquals(
            false,
            permissionSet.Assignments.isEmpty(),
            String.format(
                'There should be at least one active User with Profile Name "{0}" and assigned to Permission Set with Name "{1}"',
                new List<String>{ profileName, permissionSet.Name }
            )
        );
        this.user = (User) permissionSet.Assignments[0]
            .getSObject(
                Schema.SObjectType.PermissionSetAssignment.fields.AssigneeId.getRelationshipName()
            );

        this.permissionSetName = permissionSet.Name;
        this.permissionSetId = permissionSet.Id;

        Map<String, Schema.DescribeSObjectResult> objectDescribesBySObjectType = new Map<String, Schema.DescribeSObjectResult>();
        Map<String, Map<String, Schema.SObjectField>> sObjectFieldsByNameBySObjectType = new Map<String, Map<String, Schema.SObjectField>>();
        Map<String, List<PermissionSetManager.FieldPermission>> fieldPermissionsBySObjectType = new Map<String, List<PermissionSetManager.FieldPermission>>();

        for (Schema.FieldPermissions permission : permissionSet.FieldPerms) {
            Map<String, Schema.SObjectField> sObjectFieldsByName = sObjectFieldsByNameBySObjectType.get(
                permission.SobjectType
            );
            if (sObjectFieldsByName == null) {
                final Schema.DescribeSObjectResult objectDescribe = PermissionSetManager.getSObjectType(
                        permission.SobjectType
                    )
                    .getDescribe();
                objectDescribesBySObjectType.put(permission.SobjectType, objectDescribe);

                sObjectFieldsByName = objectDescribe.fields.getMap();
                sObjectFieldsByNameBySObjectType.put(
                    permission.SobjectType,
                    sObjectFieldsByName
                );
            }

            final PermissionSetManager.FieldPermission fieldPermission = new PermissionSetManager.FieldPermission(
                sObjectFieldsByName.get(permission.Field.substringAfter('.'))
                    .getDescribe(),
                permission
            );
            List<PermissionSetManager.FieldPermission> fieldPermissions = fieldPermissionsBySObjectType.get(
                fieldPermission.getSObjectType()
            );
            if (fieldPermissions == null) {
                fieldPermissions = new List<PermissionSetManager.FieldPermission>();
                fieldPermissionsBySObjectType.put(
                    fieldPermission.getSObjectType(),
                    fieldPermissions
                );
            }
            fieldPermissions.add(fieldPermission);
        }

        this.objectPermissionsBySObjectType = new Map<String, PermissionSetManager.ObjectPermission>();
        for (Schema.ObjectPermissions permission : permissionSet.ObjectPerms) {
            final PermissionSetManager.ObjectPermission objectPermission = new PermissionSetManager.ObjectPermission(
                objectDescribesBySObjectType.get(permission.SobjectType) == null
                    ? PermissionSetManager.getSObjectType(permission.SobjectType)
                            .getDescribe()
                    : objectDescribesBySObjectType.get(permission.SobjectType),
                permission,
                fieldPermissionsBySObjectType.get(permission.SobjectType)
            );
            this.objectPermissionsBySObjectType.put(
                objectPermission.getSObjectType(),
                objectPermission
            );
        }
    }

    public User getUser() {
        return this.user;
    }

    public String getPermissionSetName() {
        return this.permissionSetName;
    }

    public Id getPermissionSetId() {
        return this.permissionSetId;
    }

    public String getProfileName() {
        return this.getUser().Profile.Name;
    }

    public Id getProfileId() {
        return this.getUser().ProfileId;
    }

    public PermissionSetManager.ObjectPermission getObjectPermission(
        Schema.DescribeSObjectResult objectDescribe
    ) {
        System.assertNotEquals(null, objectDescribe, 'objectDescribe should not be null');
        if (this.objectPermissionsBySObjectType.get(objectDescribe.getName()) == null) {
            final PermissionSetManager.ObjectPermission objectPermission = new PermissionSetManager.ObjectPermission(
                objectDescribe,
                new Schema.ObjectPermissions(
                    ParentId = this.getPermissionSetId(),
                    SobjectType = objectDescribe.getName()
                )
            );
            this.objectPermissionsBySObjectType.put(
                objectPermission.getSObjectType(),
                objectPermission
            );
        }
        return this.objectPermissionsBySObjectType.get(objectDescribe.getName());
    }

    public PermissionSetManager save() {
        List<Permission> allPermissions = new List<Permission>();
        for (
            PermissionSetManager.ObjectPermission objectPermission : this.objectPermissionsBySObjectType.values()
        ) {
            allPermissions.addAll(objectPermission.allPermissions);
        }
        PermissionSetManager.save(allPermissions);
        return this;
    }

    public abstract class Permission {
        private final SObject permission;
        protected Boolean isChanged = false;

        protected Permission() {
            // Empty, protected constructor to prevent extensions outside of PermissionsTest
        }

        /**
         * @return   If any permission is true
         */
        protected abstract Boolean isAnyPermission();

        public Id getId() {
            return (Id) this.permission.get('Id');
        }

        protected Boolean getPermission(Schema.DescribeFieldResult fieldDescribe) {
            return (Boolean) this.permission.get(fieldDescribe.getName());
        }

        protected void setPermission(
            Schema.DescribeFieldResult fieldDescribe,
            Boolean value
        ) {
            final Boolean oldValue = this.getPermission(fieldDescribe);
            final Boolean newValue = value == true;
            //final Boolean oldValue = (Boolean) this.permission.put(fieldDescribe.getName(), newValue);
            this.permission.put(fieldDescribe.getName(), newValue);
            this.isChanged = this.isChanged || newValue != oldValue;
        }

        public Boolean getIsChanged() {
            return this.isChanged;
        }

        private Object getSaveRequest() {
            if (this.getIsChanged()) {
                // If at least one permission is true, update permission.
                // Else if Nno permissions are true, we can't update a Permission SObject with no permissions.
                // Rather, we need to delete the permission.  Return the ID to delete, and clear out permission's Id.
                //return this.isAnyPermission() ? this.permission : this.permission.put('Id', null); // Calling put returns the old value
                if (this.isAnyPermission()) {
                    return this.permission;
                } else {
                    Object permissionIdToDelete = this.permission.get('Id');
                    this.permission.put('Id', null);
                    return permissionIdToDelete;
                }
            }
            return null;
        }
    }

    public without sharing class FieldPermission extends Permission {
        final String field;
        final Schema.DescribeFieldResult fieldDescribe;

        private FieldPermission(
            final Schema.DescribeFieldResult fieldDescribe,
            final Schema.FieldPermissions fieldPermissions
        ) {
            super();
            System.assertNotEquals(
                null,
                fieldDescribe,
                'fieldDescribe should not be null'
            );
            System.assertNotEquals(
                null,
                fieldPermissions,
                'fieldPermissions should not be null'
            );
            System.assertNotEquals(
                null,
                fieldPermissions.ParentId,
                'fieldPermissions.ParentId should not be null'
            );
            System.assertNotEquals(
                null,
                fieldPermissions.SobjectType,
                'fieldPermissions.SobjectType should not be null'
            );
            System.assertNotEquals(
                null,
                fieldPermissions.Field,
                'fieldPermissions.Field should not be null'
            );
            this.fieldDescribe = fieldDescribe;
            this.permission = fieldPermissions.clone(true, true, false, false);
            this.field = fieldPermissions.Field.substringAfter('.');

            // Intialize permissions so values are not null.
            this.setRead(fieldPermissions.PermissionsRead);
            this.setEdit(fieldPermissions.PermissionsEdit);

            this.isChanged = false;
        }

        public Schema.DescribeFieldResult getFieldDescribe() {
            return this.fieldDescribe;
        }

        private Schema.FieldPermissions getFieldPermissions() {
            return (Schema.FieldPermissions) this.permission;
        }

        public Id getPermissionSetId() {
            return this.getFieldPermissions().ParentId;
        }

        public String getSObjectType() {
            return this.getFieldPermissions().SobjectType;
        }

        /**
         * @return   Part of Schema.FieldPermissions.Field corresponding to Field's API Name.
         */
        public String getField() {
            return this.field;
        }

        public Boolean getRead() {
            // Schema.FieldPermissions.PermissionsRead may null, i.e. not set.
            return this.getPermission(
                    Schema.SObjectType.FieldPermissions.fields.PermissionsRead
                ) == true;
        }

        public Boolean getEdit() {
            // Schema.FieldPermissions.PermissionsEdit may null, i.e. not set.
            return this.getPermission(
                    Schema.SObjectType.FieldPermissions.fields.PermissionsEdit
                ) == true;
        }

        public override Boolean isAnyPermission() {
            return this.getRead() || this.getEdit();
        }

        /**
         * Sets Schema.FieldPermissions.PermissionsRead as permissionsRead if getFieldDescribe() is permissionable.
         * @param  permissionsRead Value to set on Schema.FieldPermissions.PermissionsRead
         * @return                 this
         */
        public PermissionSetManager.FieldPermission setRead(Boolean permissionsRead) {
            if (this.getFieldDescribe().isPermissionable()) {
                this.setPermission(
                    Schema.SObjectType.FieldPermissions.fields.PermissionsRead,
                    permissionsRead
                );
            }
            return this;
        }

        /**
         * Sets Schema.FieldPermissions.PermissionsEdit as permissionsEdit if getFieldDescribe() is permissionable and NOT calculated.
         * If Schema.FieldPermissions.PermissionsEdit is set and is true, calls setRead(true)
         * @param  permissionsEdit Value to set on Schema.FieldPermissions.PermissionsEdit
         * @return                 this
         */
        public PermissionSetManager.FieldPermission setEdit(Boolean permissionsEdit) {
            final Boolean permission = permissionsEdit == true;
            if (
                this.getFieldDescribe().isPermissionable() &&
                !this.getFieldDescribe().isCalculated()
            ) {
                this.setPermission(
                    Schema.SObjectType.FieldPermissions.fields.PermissionsEdit,
                    permission
                );
            }

            // Edit requires Read
            if (permission) {
                this.setRead(true);
            }

            return this;
        }

        public void save() {
            PermissionSetManager.save(new List<Permission>{ this });
        }
        /*
        public List<String> debug() {
            return new List<String> {
                'PermissionSetManager.FieldPermission:',
                '    getId(): ' + this.getId(),
                '    getPermissionSetId(): ' + this.getPermissionSetId(),
                '    getSObjectType(): ' + this.getSObjectType(),
                '    getField(): ' + this.getField(),
                '    getRead(): ' + this.getRead(),
                '    getEdit(): ' + this.getEdit(),
                '    isAnyPermission(): ' + this.isAnyPermission(),
                ''
            };
        }
        */
    }

    public without sharing class ObjectPermission extends Permission {
        private final Schema.DescribeSObjectResult objectDescribe;
        private final Map<String, PermissionSetManager.FieldPermission> fieldPermissionsByField;
        private final List<Permission> allPermissions;

        private ObjectPermission(
            final Schema.DescribeSObjectResult objectDescribe,
            final Schema.ObjectPermissions permission
        ) {
            super();
            System.assertNotEquals(
                null,
                permission,
                'Schema.DescribeSObjectResult should not be null'
            );
            System.assertNotEquals(
                null,
                permission,
                'Schema.ObjectPermissions should not be null'
            );
            System.assertNotEquals(
                null,
                permission.ParentId,
                'Schema.ObjectPermissions.ParentId should not be null'
            );
            System.assertNotEquals(
                null,
                permission.SobjectType,
                'Schema.ObjectPermissions.SobjectType should not be null'
            );
            this.objectDescribe = objectDescribe;
            this.permission = permission;

            // Intialize permissions so values are not null.
            this.setRead(permission.PermissionsRead);
            this.setCreate(permission.PermissionsCreate);
            this.setEdit(permission.PermissionsEdit);
            this.setDelete(permission.PermissionsDelete);
            this.setViewAllRecords(permission.PermissionsViewAllRecords);
            this.setModifyAllRecords(permission.PermissionsModifyAllRecords);

            this.isChanged = false;

            this.allPermissions = new List<Permission>{ this };
            this.fieldPermissionsByField = new Map<String, PermissionSetManager.FieldPermission>();
        }

        private ObjectPermission(
            final Schema.DescribeSObjectResult objectDescribe,
            final Schema.ObjectPermissions permission,
            final List<PermissionSetManager.FieldPermission> fieldPermissions
        ) {
            this(objectDescribe, permission);

            if (fieldPermissions != null) {
                for (
                    PermissionSetManager.FieldPermission fieldPermission : fieldPermissions
                ) {
                    System.assertEquals(
                        this.getPermissionSetId(),
                        fieldPermission.getPermissionSetId(),
                        'fieldPermission.getPermissionSetId() should equal getPermissionSetId()'
                    );
                    System.assertEquals(
                        this.getSObjectType(),
                        fieldPermission.getSObjectType(),
                        'fieldPermission.getSObjectType() should equal getSObjectType()'
                    );
                    this.fieldPermissionsByField.put(
                        fieldPermission.getField(),
                        fieldPermission
                    );
                    this.allPermissions.add(fieldPermission);
                }
            }
        }

        public Schema.DescribeSObjectResult getObjectDescribe() {
            return this.objectDescribe;
        }

        private Schema.ObjectPermissions getObjectPermissions() {
            return (Schema.ObjectPermissions) this.permission;
        }

        public Id getPermissionSetId() {
            return this.getObjectPermissions().ParentId;
        }

        public String getSObjectType() {
            return this.getObjectPermissions().SobjectType;
        }

        public Boolean getRead() {
            return this.getPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsRead
            );
        }

        public Boolean getCreate() {
            return this.getPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsCreate
            );
        }

        public Boolean getEdit() {
            return this.getPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsEdit
            );
        }

        public Boolean getDelete() {
            return this.getPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsDelete
            );
        }

        public Boolean getViewAllRecords() {
            return this.getPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsViewAllRecords
            );
        }

        public Boolean getModifyAllRecords() {
            return this.getPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsModifyAllRecords
            );
        }

        public override Boolean isAnyPermission() {
            return this.getRead() ||
                this.getCreate() ||
                this.getEdit() ||
                this.getDelete() ||
                this.getViewAllRecords() ||
                this.getModifyAllRecords();
        }

        public PermissionSetManager.ObjectPermission setRead(Boolean permissionsRead) {
            this.setPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsRead,
                permissionsRead
            );
            return this;
        }

        public PermissionSetManager.ObjectPermission setCreate(
            Boolean permissionsCreate
        ) {
            this.setPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsCreate,
                permissionsCreate
            );
            return this;
        }

        public PermissionSetManager.ObjectPermission setEdit(Boolean permissionsEdit) {
            this.setPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsEdit,
                permissionsEdit
            );

            // Edit requires Read
            if (this.getEdit()) {
                this.setRead(true);
            }
            return this;
        }

        public PermissionSetManager.ObjectPermission setDelete(
            Boolean permissionsDelete
        ) {
            this.setPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsDelete,
                permissionsDelete
            );
            return this;
        }

        public PermissionSetManager.ObjectPermission setViewAllRecords(
            Boolean permissionsViewAllRecords
        ) {
            this.setPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsViewAllRecords,
                permissionsViewAllRecords
            );

            // View All requires Read
            if (this.getViewAllRecords()) {
                this.setRead(true);
            }
            return this;
        }

        public PermissionSetManager.ObjectPermission setModifyAllRecords(
            Boolean permissionsModifyAllRecords
        ) {
            this.setPermission(
                Schema.SObjectType.ObjectPermissions.fields.PermissionsModifyAllRecords,
                permissionsModifyAllRecords
            );

            // Modify All requires Read, Edit, Delete, View All
            if (this.getModifyAllRecords()) {
                this.setRead(true);
                this.setEdit(true);
                this.setDelete(true);
                this.setViewAllRecords(true);
            }
            return this;
        }

        public PermissionSetManager.ObjectPermission save() {
            PermissionSetManager.save(this.allPermissions);
            return this;
        }

        public PermissionSetManager.FieldPermission getFieldPermission(
            Schema.DescribeFieldResult fieldDescribe
        ) {
            System.assertNotEquals(null, 'fieldDescribe should not be null');
            if (this.fieldPermissionsByField.get(fieldDescribe.getName()) == null) {
                final PermissionSetManager.FieldPermission fieldPermission = new PermissionSetManager.FieldPermission(
                    fieldDescribe,
                    new Schema.FieldPermissions(
                        ParentId = this.getPermissionSetId(),
                        SobjectType = this.getSObjectType(),
                        Field = this.getSObjectType() + '.' + fieldDescribe.getName()
                    )
                );
                this.fieldPermissionsByField.put(
                    fieldPermission.getField(),
                    fieldPermission
                );
                this.allPermissions.add(fieldPermission);
            }
            return this.fieldPermissionsByField.get(fieldDescribe.getName());
        }

        public PermissionSetManager.ObjectPermission deleteAllFieldPermissions() {
            for (
                PermissionSetManager.FieldPermission fieldPermission : this.fieldPermissionsByField.values()
            ) {
                fieldPermission.setRead(false);
                fieldPermission.setEdit(false);
                fieldPermission.permission.put('Id', null);
                fieldPermission.isChanged = false;
            }
            Database.delete(
                [
                    SELECT Id
                    FROM FieldPermissions
                    WHERE
                        ParentId = :this.getPermissionSetId()
                        AND SobjectType = :this.getSObjectType()
                ]
            );
            return this;
        }

        public PermissionSetManager.ObjectPermission setFieldPermissions(
            Map<Schema.SObjectField, Set<FLS>> flsByField
        ) {
            for (
                Schema.SObjectField field : flsByField.keySet()
            ) {

                PermissionSetManager.FieldPermission fieldPermission =
                    this.getFieldPermission(field.getDescribe());

                Set<FLS> fieldFLS = flsByField.get(field);

                if (fieldFLS.contains(FLS.NONE)) {
                    fieldPermission.setRead(false);
                    fieldPermission.setEdit(false);

                } else {
                    for (FLS access : fieldFLS) {
                        switch on access {
                            when READ {
                                fieldPermission.setRead(true);
                            } when EDIT {
                                fieldPermission.setEdit(true);
                            } when else {
                                system.assert(false, 'UNSUPPORTED FLS ENUM: ' + access.name());
                            }
                        }
                    }
                }
            }

            return this;
        }
    }

    private static void save(List<Permission> permissions) {
        final Set<Id> idsToDelete = new Set<Id>();
        final Map<SObjectType, List<SObject>> permissionsToInsertBySObjectType = new Map<SObjectType, List<SObject>>();
        final Map<SObjectType, List<SObject>> permissionsToUpdateBySObjectType = new Map<SObjectType, List<SObject>>();

        for (Permission permission : permissions) {
            final Object saveRequest = permission.getSaveRequest();
            if (saveRequest instanceof Id) {
                idsToDelete.add((Id) saveRequest);
            } else if (saveRequest instanceof SObject) {
                final SObject record = (SObject) saveRequest;

                Map<SObjectType, List<SObject>> permissionsMap = record.get('Id') == null
                    ? permissionsToInsertBySObjectType
                    : permissionsToUpdateBySObjectType;

                if (permissionsMap.get(record.getSObjectType()) == null) {
                    permissionsMap.put(record.getSObjectType(), new List<SObject>());
                }
                permissionsMap.get(record.getSObjectType()).add(record);
            }
        }

        Database.delete(new List<Id>(idsToDelete));
        for (
            List<SObject> permissionsToInsert : permissionsToInsertBySObjectType.values()
        ) {
            Database.insert(permissionsToInsert);
        }
        for (
            List<SObject> permissionsToUpdate : permissionsToUpdateBySObjectType.values()
        ) {
            Database.update(permissionsToUpdate);
        }
    }

    public static User createUser(String profileName) {
        final Integer randomInteger = Crypto.getRandomInteger();
        String username = String.format(
            '{0}@FGM-Portal.PermissionSetManager.example.com',
            new List<String>{
                (profileName.replaceAll(' ', '_') + randomInteger)
                    .left(
                        Schema.SObjectType.User.fields.Username.getLength() -
                        '@FGM-Portal.PermissionSetManager.example.com'.length()
                    )
            }
        );

        final User user = new User(
            Alias = String.valueOf(randomInteger).left(8),
            Email = UserInfo.getUserEmail(),
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LastName = 'FGM-Portal.PermissionSetManager',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = :profileName][0]
            .Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = username,
            IsActive = true
        );

        insert user;
        return user;
    }

    public static User createAndInsertUserWithoutAnyProfilePermissions(
        final String profileName,
        final String emptyPermissionSetName,
        final List<Schema.DescribeSObjectResult> objectDescribesWithoutPermission
    ) {
        // Creating a reusable Read Only User for all tests.
        User user;

        // Using System.runAs since it ignores user license limits.
        System.runAs([SELECT Id FROM User WHERE Id = :UserInfo.getUserId()][0]) {
            user = PermissionSetManager.createUser(profileName);

            // Delete any ObjectPermissions and FieldPermissions for User to CUSTOM_OBJECT inherited from .
            {
                Set<String> sObjectTypes = new Set<String>();
                for (
                    Schema.DescribeSObjectResult objectDescribe : objectDescribesWithoutPermission
                ) {
                    sObjectTypes.add(objectDescribe.getName());
                }
                List<Id> profilePermissionsToDelete = new List<Id>();
                profilePermissionsToDelete.addAll(
                    new Map<Id, SObject>(
                            [
                                SELECT Id
                                FROM ObjectPermissions
                                WHERE
                                    SobjectType IN :sObjectTypes
                                    AND ParentId IN (
                                        SELECT PermissionSetId
                                        FROM PermissionSetAssignment
                                        WHERE AssigneeId = :user.Id
                                    )
                            ]
                        )
                        .keySet()
                );
                profilePermissionsToDelete.addAll(
                    new Map<Id, SObject>(
                            [
                                SELECT Id
                                FROM FieldPermissions
                                WHERE
                                    SobjectType IN :sObjectTypes
                                    AND ParentId IN (
                                        SELECT PermissionSetId
                                        FROM PermissionSetAssignment
                                        WHERE AssigneeId = :user.Id
                                    )
                            ]
                        )
                        .keySet()
                );
                Database.delete(profilePermissionsToDelete);
            }

            // Creating an empty Permission Set to test CRUD and FLS.
            final PermissionSet permissionSet = new PermissionSet(
                Name = emptyPermissionSetName,
                Label = emptyPermissionSetName
            );

            insert permissionSet;

            // Assign empty Permission Set to user.
            insert new PermissionSetAssignment(
                AssigneeId = user.Id,
                PermissionSetId = permissionSet.Id
            );
        }
        /*
        // Assert new user does not have permissions to CUSTOM_OBJECT or CUSTOM_FIELDS
        System.runAs(user) {
            for (Schema.DescribeSObjectResult objectDescribeWithoutPermission : objectDescribesWithoutPermission) {

                // Assert user does not have CRUD permissiosn to CUSTOM_OBJECT.
                final Schema.DescribeSObjectResult objectDescribe = objectDescribeWithoutPermission.getSObjectType().getDescribe(); // Getting fresh describe for running user

                final String CUSTOM_OBJECT_ASSERT_MESSAGE = String.format(
                    'For user, Object "{0}" should not be ',
                    new List<String>{
                        objectDescribe.getName()
                    }
                );
                
                System.assertEquals(
                    false,
                    objectDescribe.isAccessible(),
                    CUSTOM_OBJECT_ASSERT_MESSAGE + 'isAccessible()'
                );

                System.assertEquals(
                    false,
                    objectDescribe.isCreateable(),
                    CUSTOM_OBJECT_ASSERT_MESSAGE + 'isCreateable()'
                );

                System.assertEquals(
                    false,
                    objectDescribe.isUpdateable(),
                    CUSTOM_OBJECT_ASSERT_MESSAGE + 'isUpdateable()'
                );

                System.assertEquals(
                    false,
                    objectDescribe.isDeletable(),
                    CUSTOM_OBJECT_ASSERT_MESSAGE + 'isDeletable())'
                );

                for (Schema.DescribeFieldResult customField : PermissionsTest.CUSTOM_FIELDS) {
                    final Schema.DescribeFieldResult fieldDescribe = customField.getSObjectField().getDescribe(); // Getting fresh describe for running user

                    final String CUSTOM_FIELD_ASSERT_MESSAGE = String.format(
                        'For user, Field "{0}.{1}" should not be ',
                        new List<String>{
                            objectDescribe.getName(),
                            fieldDescribe.getName()
                        }
                    );

                    // Assert User does not have FLS permissions to customField.
                    System.assertEquals(
                        false,
                        fieldDescribe.isAccessible(),
                        CUSTOM_FIELD_ASSERT_MESSAGE + 'isAccessible()'
                    );

                    System.assertEquals(
                        false,
                        fieldDescribe.isCreateable(),
                        CUSTOM_FIELD_ASSERT_MESSAGE + 'isCreateable()'
                    );

                    System.assertEquals(
                        false,
                        fieldDescribe.isUpdateable(),
                        CUSTOM_FIELD_ASSERT_MESSAGE + 'isUpdateable()'
                    );
                }
            }
        }
        */

        return user;
    }

    public static Boolean isRelationship(Schema.DescribeFieldResult fieldDescribe) {
        return fieldDescribe != null &&
            fieldDescribe.getType() == Schema.DisplayType.REFERENCE;
    }

    public static Boolean isMasterDetail(Schema.DescribeFieldResult fieldDescribe) {
        return PermissionSetManager.isRelationship(fieldDescribe) &&
            fieldDescribe.getRelationshipOrder() != null;
    }

    public static Boolean isLookup(Schema.DescribeFieldResult fieldDescribe) {
        return PermissionSetManager.isRelationship(fieldDescribe) &&
            !PermissionSetManager.isMasterDetail(fieldDescribe);
    }

    private static Map<String, SObjectType> GLOBAL_DESCRIBE;
    public static SObjectType getSObjectType(String sObjectType) {
        if (PermissionSetManager.GLOBAL_DESCRIBE == null) {
            PermissionSetManager.GLOBAL_DESCRIBE = Schema.getGlobalDescribe();
        }
        return PermissionSetManager.GLOBAL_DESCRIBE.get(sObjectType);
    }
}