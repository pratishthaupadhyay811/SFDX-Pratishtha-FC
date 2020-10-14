public virtual with sharing class CrudFlsService {
    @TestVisible
    private static CrudFlsService instance;

    public static CrudFlsService getInstance() {
        if (instance == null) {
            instance = new CrudFlsService();
        }

        return instance;
    }

    /**
     * Empty constructor so this class can be stubbable.
     */
    public CrudFlsService() {
    }

    public List<SObject> stripInaccessibleForRead(List<SObject> records) {
        return this.stripInaccessible(records, System.AccessType.READABLE);
    }

    public List<SObject> stripInaccessibleForInsert(List<SObject> records) {
        return this.stripInaccessible(records, System.AccessType.CREATABLE);
    }

    public List<SObject> stripInaccessibleForUpdate(List<SObject> records) {
        return this.stripInaccessible(records, System.AccessType.UPDATABLE);
    }

    public SObject stripInaccessibleForUpdate(SObject record) {
        return this.stripInaccessible(record, System.AccessType.UPDATABLE);
    }

    public SObject stripInaccessibleForRead(SObject record) {
        return this.stripInaccessible(record, System.AccessType.READABLE);
    }

    public SObject stripInaccessible(SObject record, System.AccessType accessType) {
        if (record == null) {
            return null;
        }
        return this.stripInaccessible(new List<SObject>{ record }, accessType)[0];
    }

    private List<SObject> stripInaccessible(
        List<SObject> records,
        System.AccessType accessType
    ) {
        if (records == null) {
            return new List<SObject>();
        } else if (records.isEmpty()) {
            return records;
        }

        records = Security.stripInaccessible(accessType, records).getRecords();

        if (accessType == System.AccessType.READABLE) {
            return records;
        }

        Schema.DescribeSObjectResult describeSObjectResult = records[0]
            .getSObjectType()
            .getDescribe();

        List<SObject> strippedRecords = new List<SObject>();

        Map<String, Set<Schema.SObjectField>> mapPopulatedFieldsByObjectType = new Map<String, Set<Schema.SObjectField>>();
        for (SObject record : records) {
            String recordObjectType = String.valueOf(record.getSObjectType());
            // Get the populated fields for the record's sobjecttype
            Set<Schema.SObjectField> populatedFields;
            if (!mapPopulatedFieldsByObjectType.containsKey(recordObjectType)) {
                mapPopulatedFieldsByObjectType.put(
                    recordObjectType,
                    getPopulatedFields(new List<sObject>{ record })
                );
            }
            populatedFields = mapPopulatedFieldsByObjectType.get(recordObjectType);

            SObject strippedRecord;
            //if we are attempting to insert vs update we have to handle the records differently. Creatable on a field vs updateable
            strippedRecord = record.getSObjectType().newSObject();

            if (record.Id != null) {
                strippedRecord.Id = record.Id;
            }

            for (Schema.SObjectField field : populatedFields) {
                Schema.DescribeFieldResult dfr = field.getDescribe();
                if (dfr.isUpdateable() && accessType == System.AccessType.UPDATABLE) {
                    strippedRecord.put(field, record.get(field));
                } else if (
                    dfr.isCreateable() && accessType == System.AccessType.CREATABLE
                ) {
                    strippedRecord.put(field, record.get(field));
                }
            }
            strippedRecords.add(strippedRecord);
        }

        return strippedRecords;
    }

    public Set<String> getReadableFields(String objectName) {
        final Set<String> fields = new Set<String>{};
        if (
            String.isNotBlank(objectName) &&
            Schema.getGlobalDescribe().containsKey(objectName)
        ) {
            if (
                !Schema.getGlobalDescribe().get(objectName).getDescribe().isAccessible()
            ) {
                throw new System.NoAccessException();
            }
            for (
                Schema.SObjectField field : Schema.getGlobalDescribe()
                    .get(objectName)
                    .getDescribe()
                    .fields.getMap()
                    .values()
            ) {
                final Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                if (fieldDescribe.isAccessible()) {
                    fields.add(fieldDescribe.getName());
                }
            }
        }
        return fields;
    }

    public virtual void assertDeletable(sObject so) {
        assertDeletable(new List<sObject>{ so });
    }

    public virtual void assertDeletable(List<sObject> objects) {
        for (sObject so : objects) {
            Schema.DescribeSObjectResult dsor = so.getSObjectType().getDescribe();
            validateDeleteable(dsor);
        }
    }

    public virtual void assertDeletable(List<String> objectIds) {
        for (String i : objectIds) {
            Schema.DescribeSObjectResult dsor = Id.valueOf(i)
                .getSObjectType()
                .getDescribe();
            validateDeleteable(dsor);
        }
    }

    private void validateDeleteable(Schema.DescribeSObjectResult dsor) {
        if (!dsor.isDeletable()) {
            throw new CrudFlsException(
                String.format(
                    'Cannot delete object of type {0}',
                    new List<String>{ String.valueOf(dsor.getName()) }
                )
            );
        }
    }

    public virtual void assertCreateable(sObject so) {
        assertCreateable(new List<sObject>{ so });
    }

    public virtual void assertCreateable(List<sObject> objects) {
        for (Schema.SObjectField f : getPopulatedFields(objects)) {
            Schema.DescribeFieldResult dfr = f.getDescribe();
            if (dfr.isPermissionable() && !dfr.isCalculated() && !dfr.isCreateable()) {
                throw new CrudFlsException(
                    String.format(
                        'Cannot create field {0}.{1}',
                        new List<String>{
                            String.valueOf(objects[0].getSObjectType()),
                            dfr.getName()
                        }
                    )
                );
            }
        }
    }

    public virtual void assertUpdateable(sObject so) {
        assertUpdateable(new List<sObject>{ so });
    }

    public virtual void assertUpdateable(List<sObject> objects) {
        for (Schema.SObjectField f : getPopulatedFields(objects)) {
            Schema.DescribeFieldResult dfr = f.getDescribe();
            if (dfr.isPermissionable() && !dfr.isCalculated() && !dfr.isUpdateable()) {
                throw new CrudFlsException(
                    String.format(
                        'Cannot update field {0}.{1}',
                        new List<String>{
                            String.valueOf(objects[0].getSObjectType()),
                            dfr.getName()
                        }
                    )
                );
            }
        }
    }

    @TestVisible
    private Set<Schema.SObjectField> getPopulatedFields(List<sObject> objects) {
        Set<Schema.SObjectField> allPopulatedFields = new Set<Schema.SObjectField>();

        for (sObject so : objects) {
            Map<String, Schema.SObjectField> fieldMap = so.getSObjectType()
                .getDescribe()
                .fields.getMap();
            for (String field : so.getPopulatedFieldsAsMap().keySet()) {
                if (fieldMap.containsKey(field)) {
                    allPopulatedFields.add(fieldMap.get(field));
                }
            }
        }

        return allPopulatedFields;
    }

    public class CrudFlsException extends Exception {
    }
}