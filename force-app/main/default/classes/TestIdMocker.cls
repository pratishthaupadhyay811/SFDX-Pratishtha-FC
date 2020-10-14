@isTest
public with sharing class TestIdMocker {
    /**********************************************************************************************************
    * @description Ensures distinct mock Ids in the test transaction
    */
    private static Integer mockIdCounter {
        get {
            if (mockIdCounter == null) {
                mockIdCounter = 0;
            }
            mockIdCounter++;
            return mockIdCounter;
        }
        set;
    }

    /**********************************************************************************************************
    * @description Generates a mock Id for an sObject
    */
    public static Id mockId(SObjectType sObjectType) {
        return mockIds(sObjectType, 1)[0];
    }

    /**********************************************************************************************************
    * @description Generates mock Ids for an sObject
    */
    public static List<Id> mockIds(SObjectType sObjectType, Integer size) {
        String keyPrefix = sObjectType.getDescribe().getKeyPrefix();
        List<Id> ids = new List<Id>();

        for (Integer i = 0; i < size; i++) {
            Integer uniqueCounter = mockIdCounter;
            ids.add(keyPrefix + '0'.repeat(12 - String.valueOf(uniqueCounter).length()) + uniqueCounter);
        }

        return ids;
    }

    /**********************************************************************************************************
    * @description Sets mock Ids for a list of sObjects
    */
    public static void setMockIds(List<SObject> records) {
        for (SObject record : records) {
            record.Id = mockId(record.getSObjectType());
        }
    }
}