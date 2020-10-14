@isTest
public class SchemaEngineTest {
    @testSetup
    static void setupData(){
        Engine engines = new Engine();
        FGM_Portal__GlobalPortalSettings__c globalPortalSettings = new FGM_Portal__GlobalPortalSettings__c();
        globalPortalSettings.FGM_Portal__Request_Campaign_Field_Name__c = 'FGM_Portal__Test_Request_Campaign_Field__c';
        globalPortalSettings.FGM_Portal__LOI_Campaign_Field_Name__c = ' FGM_Portal__Test_LOI_Campaign_Field__c';
        Insert globalPortalSettings;
        Quiz__c quiz =new Quiz__c();
        quiz.Name ='Test Quiz';
        quiz.FGM_Portal__IsCommunityRecord__c = true;
        insert quiz;
        Lead leadObj = new Lead();
        leadObj.lastName = 'testLName';
        leadObj.Company = 'Salesforce';
        insert leadObj;
    }
    public static testMethod void describeSobject(){
        SchemaEngine.DescribeSObjectResultWrapper sObjectResult = null;
        sObjectResult= SchemaEngine.describeSObject('Account', true, true, true, true, true);
        System.assert(sObjectResult != null);
        sObjectResult= SchemaEngine.describeSObject('Opportunity', true, true, true, true, true);
        System.assert(sObjectResult != null);
        sObjectResult = SchemaEngine.describeSObject('Accounts', true, true, true, true, true);
        System.assertEquals(null, sObjectResult);
        sObjectResult = SchemaEngine.describeSObject('Lead', true, true, true, true, true);
        System.assert(sObjectResult != null);
    }
    static testMethod void constructSobject(){
        Lead leadObj = null;
        Sobject obj = null;
        leadObj = [SELECT Id,lastName,Company FROM Lead limit 1];
        JSONGenerator jsonGen = JSON.createGenerator( true );
        jsonGen.writeStartObject();
        jsonGen.writeStringField('Id',  leadObj.Id);
        jsonGen.writeStringField('firstName', 'TestFirstName');
        jsonGen.writeStringField('lastname', 'TestLastName');
        jsonGen.writeStringField('Company', 'Enzigma');
        jsonGen.writeDateTimeField('FGM_Base__Approval_Date__c', System.today());
        jsonGen.writeNumberField('AnnualRevenue', 100.0);
        jsonGen.writeNumberField('NumberOfEmployees', 10);
        jsonGen.writeNumberField('FGM_Base__Project_Budget__c', 100.45);
        jsonGen.writeEndObject();
        obj = SchemaEngine.constructSobject('Lead', jsonGen.getAsString());
        System.assertNotEquals(null, obj);
    }
    static testMethod void getFieldSets(){
        map<string , list<SchemaEngine.FieldInfoWrapper>> mapFieldInfo = null;
        SchemaEngine.FieldInfoWrapper fieldinfo = null;
        mapFieldInfo = SchemaEngine.getFieldSets('Account');
        fieldinfo = new SchemaEngine.FieldInfoWrapper('','','',true,null,true,'','');
        System.assertEquals(0, mapFieldInfo.size());
        mapFieldInfo = SchemaEngine.getFieldSets('Opportunity');
        fieldinfo = new SchemaEngine.FieldInfoWrapper('','','',true,null,true,'','');
        System.assertEquals(0, mapFieldInfo.size());
    }
    static testMethod void getChildObjectData(){
        sObject[] obj = SchemaEngine.getChildObjectData('Lead');
        System.assertNotEquals(null, obj);
    }
    static testMethod void getCampaignLookupField(){
        String strField = null;
        strField = SchemaEngine.getCampaignLookupField('Opportunity');
        if(strField != null)
            System.assertEquals('fgm_portal__test_request_campaign_field__c', strField);
        else
            System.assertEquals(null, strField);
        strField = SchemaEngine.getCampaignLookupField('Lead');
        if(strField != null)
            System.assertEquals('fgm_portal__test_loi_campaign_field__c', strField);
        else
            System.assertEquals(null, strField);
    }
    static testMethod void getDefaultOpportunityContactRole(){
        Schema.PicklistEntry opportunityContactRolePicklistEntry = SchemaEngine.getDefaultOpportunityContactRole();
        System.assertNotEquals(null, opportunityContactRolePicklistEntry);
    }
    static testMethod void getQuestionFields(){
        Quiz__c quiz = [select Id, Name from Quiz__c limit 1];
        list<Schema.SObjectField> lstSobjectField = SchemaEngine.getQuestionFields(quiz.Id, 'Opportunity', 'en_US');
        System.assertEquals(0, lstSobjectField.size());
    }
    static testMethod void getOpportunityTeamMemberPicklistEntries(){
        Map<string,string> mapOpportunityTeamMemberPicklist = SchemaEngine.getOpportunityTeamMemberPicklistEntries();
        System.assertNotEquals(null, mapOpportunityTeamMemberPicklist);
    }
    static testMethod void getOpportunityContactRolePicklistEntries(){
        Map<string,string> mapOpportunityContactRolePicklist = SchemaEngine.getOpportunityContactRolePicklistEntries();
        System.assertNotEquals(null, mapOpportunityContactRolePicklist);
    }
    static testMethod void getFieldsFromFieldSetTest(){
        String objectName = 'Opportunity';
        Map<String, Schema.SObjectType> mapGlobalDescribe = Schema.getGlobalDescribe();
        Schema.SObjectType sObjectTypeObj = mapGlobalDescribe.get(objectName);
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Map<String, Schema.SObjectField> mapFields = describeSObjectResultObj.fields.getMap();
        Map<String,Schema.FieldSet>  mapAllFieldSets = describeSObjectResultObj.FieldSets.getMap();
        list<String> tests = new list<String>();
        tests.addAll(mapAllFieldSets.KeySet());
        System.assertNotEquals(null, SchemaEngine.getFieldsFromFieldSet(objectName ,tests.get(0) ));
    }
    static testMethod void getlstFieldsFromFieldSetTest(){
        String objectName = 'Opportunity';
        Map<String, Schema.SObjectType> mapGlobalDescribe = Schema.getGlobalDescribe();
        Schema.SObjectType sObjectTypeObj = mapGlobalDescribe.get(objectName);
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Map<String, Schema.SObjectField> mapFields = describeSObjectResultObj.fields.getMap();
        Map<String,Schema.FieldSet>  mapAllFieldSets = describeSObjectResultObj.FieldSets.getMap();
        list<String> tests = new list<String>();
        tests.addAll(mapAllFieldSets.KeySet());
        System.assertNotEquals(null, SchemaEngine.getlstFieldsFromFieldSet(objectName ,tests.get(0) ));

    }

}