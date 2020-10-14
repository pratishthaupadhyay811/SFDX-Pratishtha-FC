@isTest
public class TestPTWorkbenchController{
    public static testmethod void TestPortalTranslationController (){
        PTWorkbenchController objPTWController = new PTWorkbenchController();
        SObjectType objToken = Schema.getGlobalDescribe().get('FGM_Portal__PortalTranslationWorkbench__c');
        DescribeSObjectResult objDef = objToken.getDescribe();
        objPTWController.strPortalLanguage = 'en';
        objPTWController.LoadLanguage();
        objPTWController.SaveLanguage();
        objPTWController.SortMap();
        objPTWController.PreviousClick();
        objPTWController.CancelClick();
        System.assertEquals(objPTWController.strPortalLanguage, 'en');
    }
}