@IsTest
public with sharing class Test_GlobalResourcesController {

public testmethod static void Test_GetResourceURL(){
    GlobalResourcesController globalResoruces = new GlobalResourcesController();
    FGM_Portal__Community_Static_Resource__c staticResource = new FGM_Portal__Community_Static_Resource__c();
    staticResource.FGM_Portal__File_Relative_Path__c = '/application_css/application.css';
    staticResource.FGM_Portal__Static_Resource_Name__c = 'FCCommonResource';
    staticResource.Name = Label.Community_Static_Resource_Record_Label;
    insert staticResource;
    system.assertNotEquals(null,staticResource);
    globalResoruces = new GlobalResourcesController();
}

}