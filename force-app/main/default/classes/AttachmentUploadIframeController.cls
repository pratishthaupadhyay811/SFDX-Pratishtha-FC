public with sharing class AttachmentUploadIframeController
{
    public string appWrapper {get;set;}
    public string initializationSetting {get;set;}
    public string query {get;set;}
    public String lookupApiName;
    public Id appId;
    public string currentPage {get;set;}

    public AttachmentUploadIframeController()
    {
        query = getQueryString();
    }

    public void initialize()
    {
        try
        {
            AttachmentUploadManager.ApplicationQuestionWrapper appQuestionWrapper = AttachmentUploadManager.getApplicationRecord(lookupApiName,appId);
            appWrapper = Json.serialize(appQuestionWrapper);
            Boolean isEditable = (ApexPages.currentPage().getParameters().get('mode')=='view') ? false:true;
            AttachmentUploadManager.AttachmentComponentSettingsWrapper componentInitialization = new  AttachmentUploadManager.AttachmentComponentSettingsWrapper(isEditable,'https://' + ApexPages.currentPage().getHeaders().get('Host'),ApexPages.currentPage().getParameters().get('ln'),'42.0');
            initializationSetting = Json.serialize(componentInitialization);
            query = getQueryString();
        }
        catch(Exception ex)
        {
            system.debug('Exception : - ' + ex.getMessage() + ' At ' + ex.getStackTraceString() + 'Line' + ex.getLineNumber());
        }
    }

    public string getQueryString()
    {
        try
        {
            String queryString = '';
            currentPage = ApexPages.currentPage().getParameters().get('page');
            if(ApexPages.currentPage().getParameters().get('appId')!=null)
                appId = Id.valueOf(String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('appId')));

            if(appId.getSObjectType().getDescribe().getName()=='Opportunity')
                lookupApiName = 'FGM_Portal__Opportunity__c';
            else if (appId.getSObjectType().getDescribe().getName()=='Lead')
                lookupApiName = 'FGM_Portal__Inquiry__c';
            else if (appId.getSObjectType().getDescribe().getName()=='FGM_Base__Grantee_Report__c')
                lookupApiName = 'FGM_Portal__GranteeReport__c';
            else if (appId.getSObjectType().getDescribe().getName()=='FGM_Portal__Amendment__c')
                lookupApiName = 'FGM_Portal__Amendment__c';
            else if (appId.getSObjectType().getDescribe().getName()=='FGM_Base__Benchmark__c')
                lookupApiName = 'FGM_Portal__Benchmark_del__c';

                queryString = 'SELECT Id, Name, FGM_Portal__Question__c, FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c, FGM_Portal__Question__r.FGM_Portal__AttachmentNameFormula__c';
                if( lookupApiName != null )
                    queryString += ', ' + lookupApiName.replaceAll('[^0-9a-zA-Z_.]', '');
                queryString += ' FROM FGM_Portal__Question_Attachment__c';
                if( lookupApiName != null && appId != null )
                {
                    String sanitizedLookupApiName = lookupApiName.replaceAll('[^0-9a-zA-Z_.]', '');
                    queryString += ' WHERE ' + sanitizedLookupApiName + ' =: appId AND FGM_Portal__Question__c != null WITH SECURITY_ENFORCED  LIMIT 1000';
                } else {
                    queryString +=' WITH SECURITY_ENFORCED LIMIT 200';
                }
                return queryString;
        }
        catch(Exception ex)
        {
            system.debug('Exception : - ' + ex.getMessage() + ' At ' + ex.getStackTraceString() + 'Line' + ex.getLineNumber());
        }
        return '';
    }
}