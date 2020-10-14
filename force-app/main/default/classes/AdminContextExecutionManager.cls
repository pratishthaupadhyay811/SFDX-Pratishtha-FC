// To Excute operations without permission.
public without sharing class AdminContextExecutionManager {
    @TestVisible
    private CrudFlsService securityService = CrudFlsService.getInstance();

    /**
     * Empty constructor so this class can be stubbable.
     */
    public AdminContextExecutionManager() {
    }

    // Method to strip inaccessible fields from list of sobject
    public void stripInaccessibleAndUpdate(List<SObject> records) {
        update this.securityService.stripInaccessibleForUpdate(records);
    }

    // Method to strip inaccessible fields from list of sobject for upsert
    // instead of navigating the murky UPSERTABLE enum, 
    // we go ahead and split the records for the individual insert vs updates
    public void stripInaccessibleAndUpsert(List<SObject> records) {
        List<SObject> updates = new List<SObject>();
        List<SObject> inserts = new List<SObject>();
        for (SObject record :records) {
            if (record.get('Id') == null) {
                inserts.add(record);
            } else { 
                updates.add(record);
            }
        }
        if (!inserts.isEmpty()) {
            this.stripInaccessibleAndInsert(inserts);
        }
        if (!updates.isEmpty()) {
            this.stripInaccessibleAndUpdate(updates);
        }
    }

    public void stripInaccessibleAndInsert(List<SObject> records) {                
        List<SObject> strippedRecords = this.securityService.stripInaccessibleForInsert(records);
        Database.insert(strippedRecords);        
        //since we are stripping the fields from the deepcloned records, we need to ensure the records passed in get their Ids to prevent duplication
        final Integer size = strippedRecords.size();
        for (Integer i = 0; i < size; i ++){
            records[i].Id = strippedRecords[i].Id;
        }        
    }

    public static void executeInsert(List<Sobject> lstRecords) {
        CrudFlsService.getInstance().assertCreateable(lstRecords);
        Database.insert(lstRecords);
    }
    public static void executeDelete(List<sObject> recordList) {
        CrudFlsService.getInstance().assertDeletable(recordList);
        Database.delete(recordList);
    }
    public static void executeUpsert(List<Sobject> lstRecords) {
        CrudFlsService.getInstance().assertUpdateable(lstRecords);
        Database.upsert(lstRecords);
    }
    public static List<Sobject> executeUpdate(List<Sobject> lstRecords) {
        CrudFlsService.getInstance().assertUpdateable(lstRecords);
        update lstRecords;
        return lstRecords;
    }
    public static list<Sobject> getUserResult(List<String> lstUserId) {
        List<User> userList = [
            SELECT Id, Email, Name, ContactId, Contact.AccountId
            FROM User
            WHERE Id IN :lstUserId
            WITH SECURITY_ENFORCED
        ];
        return userList;
    }
    public static Map<String, Schema.RecordTypeInfo> getRecordTypesByName(
        String SobjectName
    ) {
        if (String.isNotBlank(SobjectName)) {
            Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe();
            Schema.SObjectType s = sObjectMap.get(SobjectName);
            Schema.DescribeSObjectResult resSchema = s.getDescribe();
            Map<String, Schema.RecordTypeInfo> recordTypeInfo = resSchema.getRecordTypeInfosByName();
            return recordTypeInfo;
        }
        return null;
    }
}