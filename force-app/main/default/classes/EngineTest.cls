@isTest
public class EngineTest
{
    @testSetup public static void setupData(){
        Account acc = new Account( Name = 'Enzigma' );
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Enzigma', StageName = 'Submitted', CloseDate = System.today());
        insert opp;
    }
    public static testMethod void describeSobject(){
        Engine.DescribeSObjectResultWrapper sObjectResult = null;
        sObjectResult= Engine.describeSObject('Account', true, true, true, true, true);
        System.assert(sObjectResult != null);
        sObjectResult = Engine.describeSObject('Accounts', true, true, true, true, true);
        System.assertEquals(null, sObjectResult);
    }
    public static testMethod void getCustomSettingRecords(){
        String customSettingName = 'FGM_Portal__AddressCopy__c';
        List<sObject> lstSobject;
        lstSobject =  Engine.getCustomSettingRecords( customSettingName, null );
        System.assertEquals(0, lstSobject.size());
        customSettingName = 'FGM_Portal__CommunitySetting__c';
        lstSobject = Engine.getCustomSettingRecords( customSettingName, null );
        System.assertEquals(0, lstSobject.size());
        customSettingName = 'FGM_Portal__Community_Static_Resource__c';
        lstSobject = Engine.getCustomSettingRecords( customSettingName, null );
        System.assertEquals(0, lstSobject.size());
        customSettingName = 'FGM_Portal__CustomValidation__c';
        lstSobject = Engine.getCustomSettingRecords( customSettingName, null );
        System.assertEquals(0, lstSobject.size());
        customSettingName = 'FGM_Base__GRAlertSettings__c';
        lstSobject = Engine.getCustomSettingRecords( customSettingName, null );
        System.assertEquals(0, lstSobject.size());
        customSettingName = 'FGM_Portal__PortalAlertSettings__c';
        lstSobject = Engine.getCustomSettingRecords( customSettingName, null );
        System.assertEquals(0, lstSobject.size());
        customSettingName = 'FGM_Portal__PortalConfiguration__c';
        lstSobject = Engine.getCustomSettingRecords( customSettingName, null );
        System.assertEquals(0, lstSobject.size());
        customSettingName = 'FGM_Portal__PortalDashboardConfiguration__c';
        lstSobject = Engine.getCustomSettingRecords( customSettingName, null );
        System.assertEquals(0, lstSobject.size());
        customSettingName = 'FGM_Portal__Portal_Instance_User__c';
        lstSobject = Engine.getCustomSettingRecords( customSettingName, null );
        System.assertEquals(0, lstSobject.size());
        customSettingName = 'FGM_Portal__RecommendationPortalConfiguration__c';
        lstSobject = Engine.getCustomSettingRecords( customSettingName, null );
        System.assertEquals(0, lstSobject.size());
        customSettingName = 'FGM_Portal__Triggers__c';
        lstSobject = Engine.getCustomSettingRecords( customSettingName, null );
        System.assertEquals(0, lstSobject.size());
        customSettingName = 'FGM_Portal__GlobalPortalSettings__c';
        lstSobject = Engine.getCustomSettingRecords( customSettingName, null );
        lstSobject = Engine.getCustomSettingRecords( customSettingName, UserInfo.getProfileId() );
        System.assert(lstSobject.size() > 0);
    }
    public static testMethod void insertRecords(){
        JSONGenerator jsonGen = JSON.createGenerator( true );
        jsonGen.writeStartObject();
        jsonGen.writeStringField('Name','Enzigma');
        DateTime objDateTime = System.now();
        jsonGen.writeStringField('FGM_Portal__SLAExpirationDate__c', String.valueOfGmt( objDateTime ));
        jsonGen.writeEndObject();
        String jSonString = jsonGen.getAsString();
        List<String> lstJSONString = new List<String>();
        lstJSONString.add(jSonString);
        List<Database.SaveResult> lstResult = Engine.insertRecords( 'Account', lstJSONString );
        System.assert(lstResult[0].isSuccess());
    }
    public static testMethod void updateRecords(){
        Account acc = [SELECT id, Name FROM Account LIMIT 1];
        JSONGenerator jsonGen = JSON.createGenerator( true );
        jsonGen.writeStartObject();
        jsonGen.writeStringField( 'Id', acc.Id );
        jsonGen.writeStringField( 'Name', 'Enzigma' );
        jsonGen.writeEndObject();
        String jSonString = jsonGen.getAsString();
        List<String> lstJSONString = new List<String>();
        lstJSONString.add(jSonString);
        List<Database.SaveResult> lstResult = Engine.updateRecords( 'Account', lstJSONString );
        System.assert(lstResult[0].isSuccess());
    }
    public static testMethod void deleteRecords(){
        Opportunity opp =[SELECT id, Name,StageName,CloseDate FROM Opportunity LIMIT 1];
        JSONGenerator jsonGen = JSON.createGenerator( true );
        jsonGen.writeStartObject();
        jsonGen.writeStringField( 'Id', opp.Id );
        jsonGen.writeStringField( 'Name', 'Enzigma' );
        jsonGen.writeEndObject();
        String jSonString = jsonGen.getAsString();
        List<String> lstJSONString = new List<String>();
        lstJSONString.add(jSonString);
        List<Database.DeleteResult> lstResult = Engine.deleteRecords( 'Opportunity', lstJSONString );
        System.assert(lstResult[0].isSuccess());
        Engine.FieldInfoWrapper fieldinfo = new Engine.FieldInfoWrapper('','','',true,null,true,'','');
        Engine.UserInfoWrapper userInfoWrapper = new Engine.UserInfoWrapper();
    }
    static testMethod void databaseOperationsTest(){

        Engine engines = new Engine();
        List<sObject> lstSobject;
        List<Database.SaveResult> lstResult ;
        List<FGM_Portal__Related_List_Controller__c> quizTabs = TestQuizHandlerFactory.getValidQuizData();
        List<String> tabId = new List<String>();
        for(FGM_Portal__Related_List_Controller__c tab :quizTabs)
        tabId.add(tab.Id);
        Test.startTest();
        lstResult = Engine.save(quizTabs);
        System.assert(lstResult.size()> 0);
        lstResult = Engine.updateQuizTabsInfo(tabId);
        Engine.getFieldsets('FGM_Portal__Quiz__c');
        Engine.getChildObjectData('FGM_Portal__Quiz__c');
        List<Schema.PicklistEntry> lstOCRPicklist = Schema.getGlobalDescribe().get('OpportunityContactRole').newSObject().getSObjectType().getDescribe().fields.getMap().get('Role').getDescribe().getPickListValues();
        Schema.PicklistEntry strDefaultOCR = lstOCRPicklist[0];
        Schema.PicklistEntry strDefaultOCRTest = Engine.getDefaultOCR();
        Engine.removeItems(quizTabs);
        System.assert(lstResult.size()> 0);
        Test.stopTest();
    }
}