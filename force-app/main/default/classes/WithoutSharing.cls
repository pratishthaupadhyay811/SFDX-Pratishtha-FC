public without sharing class WithoutSharing {
    public void doUpdate(SObject record) {
        doUpdate(new List<SObject>{ record });
    }

    public void doUpdate(List<SObject> records) {
        update records;
    }

    public List<SObject> doQuery(String queryString) {
        return Database.query(queryString);
    }

    public Integer doCountQuery(String queryString) {
        return Database.countQuery(queryString);
    }

    /*************************************************************************************************************  
    Note:
    This Methods executeUpdate() and executeInsert() is used to bypass CRUD and FLS check for Guest User. 
    The Grantee Portal Registration flow will be execute in super Admin context
    As of the Salesforce Guest User Security Restrictions , Guest Users are no longer allowed 
    edit access on objects and so required to bypass this restriction during registration.
***********************************************************************************************************
*/
    public static List<Sobject> executeUpdate(List<Sobject> lstRecords) {
        update lstRecords;
        return lstRecords;
    }

    public static void executeInsert(List<Sobject> lstRecords) {
        Database.insert(lstRecords);
    }
}