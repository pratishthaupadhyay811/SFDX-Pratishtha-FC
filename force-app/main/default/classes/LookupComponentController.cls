public with sharing class LookupComponentController{
public String componentValue;
    public void setComponentValue(String strID){
        String queryString;
        ID objectID=ID.valueOf(strID);
        Schema.SObjectType token = objectID.getSObjectType();
        Schema.DescribeSObjectResult describeResult = token.getDescribe();
        queryString = 'SELECT Name FROM ' + describeResult.getName() + ' WHERE Id = :objectID WITH SECURITY_ENFORCED';
        LIST<sObject> lstRecords = Database.Query(queryString);
        if(lstRecords.size()>0)
            componentValue = String.ValueOf(lstRecords[0].get('Name'));
    }
    public String getComponentValue(){
        return componentValue;
    }
}