public with sharing class GlobalResourcesController {
    private static final String LOGIN_STATIC_RESOURCE_NAME = 'LoginAndRegistrationStylesheet';

    public String commonResourceName {get; set;}
    public String commonRelativePath {get; set;}
    public String loginStylesheetResourceName {get; set;}
    public String loginStylesheetRelativePath {get; set;}

    public GlobalResourcesController(ApexPages.StandardController sc) {
        this();
    }

    public GlobalResourcesController(CommunitySigninController csc) {
        this();
    }

    public GlobalResourcesController() {
        Community_Static_Resource__c commonResourceSetting = Community_Static_Resource__c.getInstance(
            Label.Community_Static_Resource_Record_Label
        );

        commonResourceName = 'FGM_Portal__FCCommonResource';
        commonRelativePath = 'application_css/application.css';

        if (commonResourceSetting != null) {
            commonResourceName = commonResourceSetting.Static_Resource_Name__c;
            commonRelativePath = commonResourceSetting.File_Relative_Path__c;

            if (!commonRelativePath.endsWith('.css')) {
                commonRelativePath += '.css';
            }
        }

        Community_Static_Resource__c loginStylesheetResourceSetting = Community_Static_Resource__c.getInstance(
            LOGIN_STATIC_RESOURCE_NAME
        );

        if (loginStylesheetResourceSetting != null) {
            loginStylesheetResourceName = loginStylesheetResourceSetting.Static_Resource_Name__c;
            loginStylesheetRelativePath = loginStylesheetResourceSetting.File_Relative_Path__c;
        }
    }
}