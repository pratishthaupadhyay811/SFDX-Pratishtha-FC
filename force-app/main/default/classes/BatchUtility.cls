global with sharing class BatchUtility implements  Database.Batchable<sObject>
{
    global BatchUtilityHelper batchUtilHelper = new BatchUtilityHelper();
    global BatchUtility(String batchOperationName,Boolean bUpdateAllOrNone)
    {
        batchUtilHelper.operation = batchOperationName;
        batchUtilHelper.bUpdateAllOrNone = bUpdateAllOrNone;
    }
    // Created constructor to take third parameter, parameter is used to specify the where condition for the query
    global BatchUtility(String batchOperationName,Boolean bUpdateAllOrNone,Set<Id> setIdForWhereCondtn)
    {
        batchUtilHelper.operation = batchOperationName;
        batchUtilHelper.bUpdateAllOrNone = bUpdateAllOrNone;
        batchUtilHelper.setIdWhereConditionforQuery.addAll(setIdForWhereCondtn); //passing the opp Id to BatchUtilityHelper to fetch the oportunity where id in the whereConditionforQuery
    }
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return (batchUtilHelper.getQueryLocator());
    }
    global void execute(Database.BatchableContext BC, List<Sobject> scope)
    {
        batchUtilHelper.executeOperation(scope);
    }
    global void finish(Database.BatchableContext BC) {
    }
}