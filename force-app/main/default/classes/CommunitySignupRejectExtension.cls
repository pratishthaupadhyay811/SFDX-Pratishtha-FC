public with sharing class CommunitySignupRejectExtension
{
    private FGM_Portal__Questions__c objQuestion;
    public String portalLanguage {get; set;}
    public SFDCEncoder ESAPI = new SFDCEncoder();

    public FGM_Portal__Questions__c getQuestion()
    {
        return objQuestion;
    }

    public CommunitySignupRejectExtension(ApexPages.StandardController controller)
    {
        objQuestion = (FGM_Portal__Questions__c) controller.getRecord();
        portalLanguage = System.currentPageReference().getParameters().get('ln');
        portalLanguage = ESAPI.SFDC_HTMLENCODE(portalLanguage);
        portalLanguage = String.isBlank(portalLanguage)?'en_US':portalLanguage;
    }
    public String getImageLogoUrl()
    {
        CommunitySigninController objectSigninController = NEW CommunitySigninController();
        return objectSigninController.getImageLogoUrl();
    }
}