@isTest
public class CollectionUtilitiesTest {
    @testSetup
    static void setupData(){
        List<Lead> lstLead = new List<Lead>();
        for(Integer i = 0 ; i<20 ; i++) {
            lstLead.add(new Lead(lastName = 'testLName'+i , Company = 'Salesforce'));
        }
        insert lstLead;
    }
    static testmethod void setToString(){
        List<Lead> lstLead = null;
        String stringValue = null;
        lstLead = [SELECT Id, Name, Company FROM Lead limit 15];
        Set<String> setValues = new Set<String>();
        for(Lead leadRecord : lstLead)
            setValues.add(leadRecord.Name);
        stringValue = CollectionUtilities.setToString(setValues, true);
        stringValue = CollectionUtilities.setToString(setValues, false);
        System.assertEquals(false,String.isBlank(stringValue));
        stringValue = CollectionUtilities.setToString(setValues, null);
        System.assertEquals(null,stringValue);
        Set<Id> setIdValues = new Set<Id>();
        for(Lead leadRecord : lstLead)
            setIdValues.add(leadRecord.Id);
        stringValue = CollectionUtilities.setToString(setIdValues, true);
        stringValue = CollectionUtilities.setToString(setIdValues, false);
        System.assertEquals(false,String.isBlank(stringValue));
        stringValue = CollectionUtilities.setToString(setIdValues, null);
        System.assertEquals(null,stringValue);

    }
    static testmethod void listToString(){
        List<Lead> lstLead = null;
        String stringValue = null;
        lstLead = [SELECT Id, Name, Company FROM Lead limit 15];
        List<String> lstValues = new List<String>();
        for(Lead leadRecord : lstLead)
            lstValues.add(leadRecord.Name);
        stringValue = CollectionUtilities.listToString(lstValues, true);
        stringValue = CollectionUtilities.listToString(lstValues, false);
        System.assertEquals(false,String.isBlank(stringValue));
        stringValue = CollectionUtilities.listToString(lstValues, null);
        System.assertEquals(null,stringValue);
        List<Id> lstIdValues = new List<Id>();
        for(Lead leadRecord : lstLead)
            lstIdValues.add(leadRecord.Id);
        stringValue = CollectionUtilities.listToString(lstIdValues, true);
        stringValue = CollectionUtilities.listToString(lstIdValues, false);
        System.assertEquals(false,String.isBlank(stringValue));
        stringValue = CollectionUtilities.listToString(lstIdValues, null);
        System.assertEquals(null,stringValue);
    }
    static testMethod void getContainsIgnoreCase(){
        Boolean bValue = false;
        bValue = CollectionUtilities.getContainsIgnoreCase('Please enter your name', 'your');
        System.assertEquals(true, bValue);
        bValue = CollectionUtilities.getContainsIgnoreCase('Please enter your name', null);
        System.assertEquals(null, bValue);
    }
    static testMethod void getMapFromParameters(){
        Map<String,String> mapFromParameters = CollectionUtilities.getMapFromParameters('a,b', ',', ',');
        System.assertEquals(null, mapFromParameters);
    }
}