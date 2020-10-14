public with sharing class CommunityDashboardController {
    public static string strRequestCampaignField {get;set;}
    @TestVisible private static string strLOICampaignField;
    //@TestVisible private string dashboardAlerts; //not used
    @TestVisible private static String opportunityEndDate;
    @TestVisible private static String communityApplicationPageUrl;
    @TestVisible private static String fcRecordPageUrl;
    // @TestVisible private static set<String> setOppIds; //not used
    public static Map<String,List<FGM_Portal__PortalConfiguration__c>> mapLanguageToPortalConfiguration;
    public static String portalLanguage {get;set;}
    @TestVisible private static Map<string,List<DashboardRecordColor>> mapDashboardAlertSettings;
    @TestVisible private static List<FGM_Portal__PortalAlertSettings__c> lstPortalAlertSettings;
    @TestVisible private static List<Record> lstDashboardRequestOpenRecord ;
    //@TestVisible private Static Boolean isRequest ; // not used
    @TestVisible private static Integer unreadCount ;
    // @TestVisible private static Boolean display ; //not used
    @TestVisible private static ID currentUserId ;
    @TestVisible private static string currentObject ;
    @TestVisible private static List<User> lstUser;
    @TestVisible private static List<Contact> lstContact;
    @TestVisible private static List<ActivityHistory> lstActivity ;
    @TestVisible private static map<String,ActivityHistory> mapActivity ;
    @TestVisible private static List<SubClassActivityHistory> activities;
    public Boolean showProfileOptions {get;set;}
    public List<SelectOption> lstUserProfiles {get;set;}
    public User currentUser;
    public FGM_Portal__CommunitySetting__c communitySettingForDashBoard{get;set;}
    public String localDateFormat {get;set;}
    public String fCDashboardStaticResourceName { get; set; }
    public String fCDashboardStyleSheet     { get; set; }
    public CustomHTML__c dashboardInstructionalTextHtml {get; set;}

    public Boolean enhancedStylingEnabled {
        get {
            if (enhancedStylingEnabled == null) {
                FGM_Portal__CommunitySetting__c sldsSetting = FGM_Portal__CommunitySetting__c.getInstance('UseEnhancedStyling');
                enhancedStylingEnabled = sldsSetting == null ? false : sldsSetting.IsEnabled__c;
            }
            return enhancedStylingEnabled;
        }
        private set;
    }

    static
    {
            communityApplicationPageUrl = Page.communityApplication.getUrl();
            fcRecordPageUrl = Page.FCRecord.getUrl();

            lstUser = [
                SELECT
                    ContactId,
                    Email,
                    Name,
                    SmallPhotoUrl
                FROM User
                WHERE Id = :Userinfo.getUserid()
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            lstContact = new List<Contact>();
            lstActivity = new List<ActivityHistory>();
            mapActivity = getmapActivityHistories();
            activities  = new List<SubClassActivityHistory>();
            currentUserId = Userinfo.getUserid();
            lstDashboardRequestOpenRecord = new List<Record>();
            opportunityEndDate = 'Campaign.EndDate';
            strRequestCampaignField = 'CampaignId';
            FGM_Portal__GlobalPortalSettings__c globalSetting = FGM_Portal__GlobalPortalSettings__c.getOrgDefaults();

            if(globalSetting != null )
            {
                if( String.isNotBlank(globalSetting.FGM_Portal__Request_Campaign_Field_Name__c))
                {
                    strRequestCampaignField = globalSetting.FGM_Portal__Request_Campaign_Field_Name__c;
                    opportunityEndDate = strRequestCampaignField.removeEnd('c')+'r.EndDate';
                }
                if( String.isNotBlank(globalSetting.FGM_Portal__LOI_Campaign_Field_Name__c))
                    strLOICampaignField = globalSetting.FGM_Portal__LOI_Campaign_Field_Name__c;
            }
            mapLanguageToPortalConfiguration = new Map<String,List<FGM_Portal__PortalConfiguration__c>>();
            for(FGM_Portal__PortalConfiguration__c objPortalConfig : FGM_Portal__PortalConfiguration__c.getAll().values())
            {
                if(objPortalConfig.FGM_Portal__LanguageSelection__c!=null)
                    if(mapLanguageToPortalConfiguration.containsKey(objPortalConfig.FGM_Portal__LanguageSelection__c))
                {
                    list<FGM_Portal__PortalConfiguration__c> lstPortalConfig = mapLanguageToPortalConfiguration.get(objPortalConfig.FGM_Portal__LanguageSelection__c);
                    lstPortalConfig.add(objPortalConfig);
                    mapLanguageToPortalConfiguration.put(objPortalConfig.FGM_Portal__LanguageSelection__c, lstPortalConfig);
                }
                else
                    mapLanguageToPortalConfiguration.put(objPortalConfig.FGM_Portal__LanguageSelection__c, new List<FGM_Portal__PortalConfiguration__c>{objPortalConfig});
            }
            lstPortalAlertSettings = FGM_Portal__PortalAlertSettings__c.getall().values();
            mapDashboardAlertSettings = new Map<string,List<DashboardRecordColor>>();

            if(lstPortalAlertSettings != null && !lstPortalAlertSettings.isEmpty())
            {
                list<DashboardRecordColor> opportunityAlertSetting = new list<DashboardRecordColor>();
                list<DashboardRecordColor> leadAlertSetting = new list<DashboardRecordColor>();
                list<DashboardRecordColor> gRAlertSetting = new list<DashboardRecordColor>();

                for(FGM_Portal__PortalAlertSettings__c setting : lstPortalAlertSettings)
                {
                    DashboardRecordColor recordColor = new DashboardRecordColor();
                    recordColor.StrColor = setting.FGM_Portal__Color__c;
                    recordColor.strStatus = setting.FGM_Portal__Status__c;

                    if(setting.FGM_Portal__Time_Trigger__c != null)
                        recordColor.intTimeTrigger = Integer.valueOf(setting.FGM_Portal__Time_Trigger__c);

                    if(setting.FGM_Portal__Time_Trigger__c == null)
                        recordColor.intTimeTrigger = null;

                    String strObjectName = setting.FGM_Portal__Object__c.toLowerCase();

                    if(strObjectName != null)
                    {
                        if( 'opportunity' == strObjectName )
                        {
                            opportunityAlertSetting.add(recordColor);
                            mapDashboardAlertSettings.put('opportunity', opportunityAlertSetting);
                        }
                        if( 'lead' == strObjectName)
                        {
                            leadAlertSetting.add(recordColor);
                            mapDashboardAlertSettings.put('lead', leadAlertSetting);
                        }
                        if( 'fgm_base__grantee_report__c' == strObjectName )
                        {
                            gRAlertSetting.add(recordColor);
                            mapDashboardAlertSettings.put('fgm_base__grantee_report__c', gRAlertSetting);
                        }
                    }
                }
            }
    }

    public CommunityDashboardController()
    {
        try{
            communitySettingForDashBoard = FGM_Portal__CommunitySetting__c.getInstance('GP_DashboardInstructionalTextEnabled');
        FCGlobal.UserSession userSession = FCGlobal.getUserSession(currentUserId);
        if(userSession!=null)
        {
            portalLanguage = userSession.Userlanguage;
            showProfileOptions = false;
            FCGlobal.setUserLanguage(userInfo.getUserId(),portalLanguage);
            if(String.isBlank(portalLanguage))
            {
                portalLanguage = 'en_US';
            }
            localDateFormat = FCGlobal.getDateFormat().get(portalLanguage);

            currentUser = [
                SELECT
                    UserProfile__c,
                    Username
                FROM User
                WHERE Id = :currentUserId
                WITH SECURITY_ENFORCED
            ];

            FGM_Portal__CommunitySetting__c communitySetting = FGM_Portal__CommunitySetting__c.getInstance('IsCommunitySwitchingEnabled');
            if(currentUser != null && currentUser.FGM_Portal__UserProfile__c != null)
            {
                if('Grantee;Reviewer'.equalsIgnoreCase(currentUser.FGM_Portal__UserProfile__c) || 'Reviewer;Grantee'.equalsIgnoreCase(currentUser.FGM_Portal__UserProfile__c))
                {
                    if(communitySetting!=null)
                        showProfileOptions = communitySetting.FGM_Portal__IsEnabled__c;
                }
            }
        }

        try {
            String portalLanguageForCustomHTML = 'en_US';

            if (!String.isBlank(portalLanguage)) {
                portalLanguageForCustomHTML = portalLanguage;
            }

            dashboardInstructionalTextHtml = [
                SELECT RichDescription__c
                FROM CustomHTML__c
                WHERE Name = 'GP_DashboardInstructionalText'
                AND Associated_FC_Portal_Type__c = 'Grantee'
                AND Language__c = :portalLanguageForCustomHTML
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];
        } catch (QueryException e) {
            // no CustomHTML record found, probably, but thats ok.
        }

        Community_Static_Resource__c staticResourceSetting = Community_Static_Resource__c.getInstance(Label.FC_Community_Dashboard_Static_Resource_Record_Label);

        if (staticResourceSetting != null && !String.isBlank(staticResourceSetting.Static_Resource_Name__c)  && !String.isBlank(staticResourceSetting.File_Relative_Path__c)) {
            fCDashboardStaticResourceName =  staticResourceSetting.Static_Resource_Name__c;
            String fileName = staticResourceSetting.File_Relative_Path__c;
            if (fileName.contains('.css')) {
                fCDashboardStyleSheet = fileName;
            } else {
                fCDashboardStyleSheet = fileName +'.css';
            }
        } else {
            fCDashboardStaticResourceName =  'GPApplicationDesigner';
            fCDashboardStyleSheet     =  'application_css/community-dashboard.css';
        }
        fCDashboardStaticResourceName = GetResourceURL(fCDashboardStaticResourceName);
        if(showProfileOptions)
            initializeProfileListForSwitching();
        }

        catch(exception ex){
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() ) );
        }
    }

    private String GetResourceURL(String resourceName) {

        List<StaticResource> resourceList = [
            SELECT
                Name,
                NamespacePrefix,
                SystemModStamp
            FROM StaticResource
            WHERE Name = :resourceName
        ];

        string resourceUrl = '';
        if (resourceList.size() == 1) {
           String namespace = resourceList[0].NamespacePrefix;
           resourceUrl = '/resource/'
              + resourceList[0].SystemModStamp.getTime() + '/'
              + (namespace != null && namespace != '' ? namespace + '__' : '')
              + resourceName;
        }

        return resourceUrl;
    }

    /**********************************************************************************************
Purpose: Check current logged in user profile inorder to show swith to reviewer functionality or not
**********************************************************************************************/
    public void initializeProfileListForSwitching()
    {
        lstUserProfiles = new List<SelectOption>();

        List<User> currentUser = [
            SELECT
                ContactId,
                Email,
                Name,
                SmallPhotoUrl,
                UserProfile__c
            FROM User
            WHERE Id = :currentUserId
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

        FGM_Portal__GlobalPortalSettings__c globalSetting = FGM_Portal__GlobalPortalSettings__c.getOrgDefaults();
        set<String> setPrefixes = new set<String>();

/*
        String strSiteType = Site.getSiteType();

        for (Site site : [
            SELECT
                SiteType,
                Status,
                Subdomain,
                UrlPathPrefix
            FROM Site
            WHERE Status = 'Active'
            AND Subdomain != null
            WITH SECURITY_ENFORCED
        ]) {
            if(site.siteType == strSiteType) {
                setPrefixes.add(site.UrlPathPrefix);
            }
        }
*/
        for (Network n : [
            SELECT UrlPathPrefix
            FROM Network
            WHERE Status = 'Live'
            WITH SECURITY_ENFORCED
        ]) {
            setPrefixes.add(n.UrlPathPrefix);
        }

        if(String.isNotBlank(currentUser[0].FGM_Portal__UserProfile__c))
        {
            if(showProfileOptions!=null && showProfileOptions)
            {
                String granteeCommunityUrl = 'https://' + Site.getDomain();
                String reviewerCommunityUrl = 'https://' + Site.getDomain();
                if(globalSetting.FGM_Portal__Grantee_Portal_Prefix__c!=null && globalSetting.FGM_Portal__Grantee_Portal_Prefix__c!='')
                {
                    if(UserInfo.getUiThemeDisplayed().equalsIgnoreCase('Theme4d'))
                    {
                        granteeCommunityUrl = 'https://' + Site.getDomain() + '/' + globalSetting.FGM_Portal__Grantee_Portal_Prefix__c + '/s/fCCommunityDashboard';

                    }
                    else
                        granteeCommunityUrl = 'https://' + Site.getDomain() + '/' + globalSetting.FGM_Portal__Grantee_Portal_Prefix__c;
                }
                if(globalSetting.FGM_Portal__Reviewer_Portal_Prefix__c!=null && globalSetting.FGM_Portal__Reviewer_Portal_Prefix__c != '' && setPrefixes.contains(globalSetting.FGM_Portal__Reviewer_Portal_Prefix__c ) )
                {
                    if(UserInfo.getUiThemeDisplayed().equalsIgnoreCase('Theme4d'))
                    {
                        reviewerCommunityUrl = 'https://' + Site.getDomain() + '/' + globalSetting.FGM_Portal__Reviewer_Portal_Prefix__c + '/s/RPCommunityDashboard';
                    }
                    else
                        reviewerCommunityUrl = 'https://' + Site.getDomain() + '/' + globalSetting.FGM_Portal__Reviewer_Portal_Prefix__c;
                }
                if(setPrefixes.contains(globalSetting.FGM_Portal__Grantee_Portal_Prefix__c))
                    lstUserProfiles.add(new SelectOption( granteeCommunityUrl ,System.Label.FC_Switch_to_Grantee_Label ));
                if(setPrefixes.contains(globalSetting.FGM_Portal__Reviewer_Portal_Prefix__c))
                    lstUserProfiles.add(new SelectOption( reviewerCommunityUrl,System.Label.FC_Switch_to_Reviewer_Label));
            }
        }
    }


    /*********************************************************************************
Purpose: get RecordAccess for the records displayed on dashboard page for current user
*********************************************************************************/
    public static RecordAccess getRecordAccessForUser(string sobjectType)
    {
        RecordAccess recordAccess = new RecordAccess();
        SchemaEngine.DescribeSObjectResultWrapper sObjectAccess = SchemaEngine.describeSobject(sobjectType, true, true, true, true, true);
        recordAccess.isCreatable = sObjectAccess.objectAccess.isCreatable;
        recordAccess.isDeletable = sObjectAccess.objectAccess.isDeletable;
        recordAccess.isEditable = sObjectAccess.objectAccess.isEditable;
        recordAccess.isReadable = sObjectAccess.objectAccess.isReadable;
        recordAccess.isAmendable = communityAmendmentSetting.IsEnabled__c;

        return recordAccess;
    }
    /*********************************************************************************
Purpose: get OpportunityTeamMembers  records for current user to display on dashboard
page
*********************************************************************************/
    @RemoteAction
    public static Map<Id,String> getOpportunityTeamMembers()
    {
        try{
            Map<Id,String> mapOppAndAccessLevel = new Map<Id,String>();

            for (OpportunityShare oppShare : [
                SELECT
                    Opportunity.Campaign.EndDate,
                    OpportunityAccessLevel,
                    OpportunityId,
                    RowCause,
                    UserOrGroupId
                FROM OpportunityShare
                WHERE UserOrGroupId = :currentUserId
                AND RowCause = 'Team'
                WITH SECURITY_ENFORCED
                LIMIT 5000
            ]) {
                mapOppAndAccessLevel.put(
                    oppShare.OpportunityId,
                    oppShare.OpportunityAccessLevel
                );
            }

            return mapOppAndAccessLevel;
        }
        catch(exception ex){
            handleException(ex);
        }
        return null;
    }
    /*********************************************************************************
Purpose: property to check if Ammendment for request is enable for community
*/
    public static FGM_Portal__CommunitySetting__c communityAmendmentSetting
    {
        get{
            try{
                if(communityAmendmentSetting == null)
                {
                    communityAmendmentSetting = FGM_Portal__CommunitySetting__c.getInstance('IsAmendmentRequestEnabled');
                    if(communityAmendmentSetting == null)
                        communityAmendmentSetting = new FGM_Portal__CommunitySetting__c(IsEnabled__c = true);
                    return  communityAmendmentSetting;
                }
            }
            catch(exception ex)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, System.Label.FC_Dashboard_Initialization_Error_Message));

            }
            return  communityAmendmentSetting;
        }
        set{}
    }
    /*********************************************************************************
Purpose: Insert Ammendment record
*********************************************************************************/
    @RemoteAction
    public static String saveAmendmentRecord(Id requestIdForAmendment){
        try{
            String pageUrl;
            String objectName = FCGlobal.getObjectNameById(requestIdForAmendment);
            String recordTypeId = FCGlobal.getRecordTypeId(String.valueOf(Amendment__c.getsObjectType()),objectName);
            FGM_Portal__Amendment__c amendment = new FGM_Portal__Amendment__c();
            amendment.FGM_Portal__ParentRequest__c = requestIdForAmendment;
            amendment.RecordTypeId = recordTypeId;
            CrudFlsService.getInstance().assertCreateable(amendment);
            insert amendment;
            pageUrl = Site.getPathPrefix() + '/apex/FGM_Portal__FCRecord?Id=' + amendment.Id + '&ParentId=' + requestIdForAmendment + '&RecordTypeId' + recordTypeId + '&mode=edit';

            return pageUrl;

        }
        catch(Exception ex) {
            String errorMessage = ex.getMessage();
            Integer occurence;
            if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                occurence = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
                errorMessage = errorMessage.mid(occurence, errorMessage.length());
                occurence = errorMessage.lastIndexOf(':');
                errorMessage = errorMessage.mid(0, occurence);
            }
            throw new CustomException (JSON.serialize(new CustomExceptionWrapper(ex.getLineNumber(),errorMessage,ex.getStackTraceString(),errorMessage,'error','Error')));
        }
    }
    /*********************************************************************************
Purpose: set the content of selected email from the activity history record of the current user
*********************************************************************************/

    @RemoteAction
    public static SubClassActivityHistory setEmailContent(String selectedActivityId, String mailStatus)
    {
        SubClassActivityHistory activity = new SubClassActivityHistory();
        try
        {
            if(selectedActivityId != null && mapActivity != null && mapActivity.get(selectedActivityId) != null)
            {
                ActivityHistory selectActivityHistory = mapActivity.get(selectedActivityId);
                if(selectActivityHistory  != null)
                {
                    String strDesciption = (selectActivityHistory.Description != null )? selectActivityHistory.Description : '';
                    if(strDesciption != null && strDesciption != '' && String.isNotBlank(strDesciption))
                    {
                        if(strDesciption.contains('Body:'))
                            activity.strBody = strDesciption.substringAfter('Body:');
                        else
                            activity.strBody = strDesciption;
                    }
                    else
                        activity.strBody = '';

                    if(selectActivityHistory.FGM_Portal__ResponseBy__c != null)
                    {
                        activity.profileImageUrl = selectActivityHistory.FGM_Portal__ResponseBy__r.SmallPhotoUrl ;
                        activity.userName = selectActivityHistory.FGM_Portal__ResponseBy__r.FirstName + ' ' + selectActivityHistory.FGM_Portal__ResponseBy__r.LastName;
                        activity.userEmailId = selectActivityHistory.FGM_Portal__ResponseBy__r.Email;
                    }
                    else
                    {
                        if(strDesciption.contains('Respondent:') && strDesciption.contains('Respondent Email:'))
                        {
                            activity.userName = strDesciption.substringBefore('Respondent Email:');
                            activity.userName = (activity.userName.substringAfter('Respondent:')).trim();
                            activity.userEmailId = strDesciption.substringBefore('Body:');
                            activity.userEmailId = (activity.userEmailId.substringAfter('Respondent Email:')).trim();
                            activity.profileImageUrl = '/profilephoto/005/T';
                        }
                        else if(!lstUser.isEmpty())
                        {
                            activity.userName = lstUser[0].Name;
                            activity.userEmailId = lstUser[0].Email;
                            activity.profileImageUrl = lstUser[0].SmallPhotoUrl;
                        }
                    }
                    if(selectActivityHistory.Subject != null && String.isNotBlank(selectActivityHistory.Subject))
                    {
                        String sub = (selectActivityHistory.Subject.contains('Email:')?selectActivityHistory.Subject.substringAfter('Email:'):selectActivityHistory.Subject);
                        activity.subject = (sub!=null && String.isNotBlank(sub))?sub:'(no subject)';
                    }
                    else
                        activity.subject = '(no subject)';

                    List<Secure_Message__c> lstRefId = [
                        SELECT RefId__c
                        FROM Secure_Message__c
                        WHERE RefId__c = :selectActivityHistory.Id
                        WITH SECURITY_ENFORCED
                        LIMIT 1
                    ];

                    if(lstRefId == null || lstRefId.isEmpty())
                    {
                        Secure_Message__c secureMessage = new Secure_Message__c();
                        secureMessage.Recipient__c = selectActivityHistory.OwnerId;
                        secureMessage.RefId__c = selectActivityHistory.Id;
                        secureMessage.Body__c = activity.strBody;
                        CrudFlsService.getInstance().assertCreateable(secureMessage);
                        insert secureMessage;
                        activity.mailStatus = 'Read';
                    }
                    else
                        activity.mailStatus = mailStatus;
                }
                activity.activity = selectActivityHistory;
            }
            return activity;

        }
        catch(Exception ex)
        {
            System.debug('Exception Details: ' + ex.getMessage() + '; Error at line no: ' + ex.getLineNumber());String errorMessage = ex.getMessage();
            String inboxErrorMessage = ex.getMessage();
            Integer occurence;
            if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
            {
                occurence = inboxErrorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
                inboxErrorMessage = inboxErrorMessage.mid(occurence, inboxErrorMessage.length());
                occurence = inboxErrorMessage.lastIndexOf(':');
                inboxErrorMessage = inboxErrorMessage.mid(0, occurence);
            }
            throw new CustomException (JSON.serialize(new CustomExceptionWrapper(ex.getLineNumber(),errorMessage,ex.getStackTraceString(),inboxErrorMessage,'error','Error')));
        }
    }

    /*********************************************************************************
Purpose: navigate to community secure message page after clicking on Compose mail button
*********************************************************************************/

    @RemoteAction
    public static string ComposeMail()
    {
        return 'https://' + Site.getDomain() + '/' + ((Site.getPathPrefix()!=null && String.isNotBlank(Site.getPathPrefix()) ?  Site.getPathPrefix() + '/' :'' )) + 'apex/FGM_Portal__CommunitySecureMessage';
    }
    /*********************************************************************************
Purpose: delete the mail from dashboard page
*********************************************************************************/
    @RemoteAction
    public static void delMessage(String activityId)
    {
        try
        {
            Jsonparser CurrentJsonparser = Json.createParser(activityId);
            List<String> lstDeleteActivityId = (List<String>)CurrentJsonparser.readValueAs(List<String>.class);
            if(lstDeleteActivityId != null && lstDeleteActivityId.size() > 0) {
                List<Task> lstActivity = new List<Task>();
                for(String taskID : lstDeleteActivityId){
                    Task activityHistory = new Task();
                    activityHistory.Id = taskID;
                    lstActivity.add(activityHistory);
                }
                if(lstActivity != null && !lstActivity.isEmpty()){
                    CrudFlsService.getInstance().assertDeletable(lstActivity);
                    delete lstActivity;
                }
            }
        }
        catch(Exception ex)
        {
            System.debug('Exception Details: ' + ex.getMessage() + '; Error at line no: ' + ex.getLineNumber());
            String deleteErrorMessage = ex.getMessage();
            Integer occurence;
            if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
            {
                occurence = deleteErrorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
                deleteErrorMessage = deleteErrorMessage.mid(occurence, deleteErrorMessage.length());
                occurence = deleteErrorMessage.lastIndexOf(':');
                deleteErrorMessage = deleteErrorMessage.mid(0, occurence);
            }
            throw new CustomException (JSON.serialize(new CustomExceptionWrapper(ex.getLineNumber(),deleteErrorMessage,ex.getStackTraceString(),deleteErrorMessage,'error','Error')));

        }
    }
    /*********************************************************************************
Purpose: fetch the data of specified object
*********************************************************************************/
    @RemoteAction
    public static List<TabWrapper> getData( String sobjectName, Map<Id,String> mapRelatedRecord, list<Id> setOppOwnrId, String portalLanguage)
    {
        try
        {
            currentObject = sobjectName;
            String queryString;
            List<String> queryFields = new List<String>();
            List<String> queryFieldLabel = new List<String>();
            ID userId = userInfo.getUserId(); // remove not used
            Set<string> editableStatuses = new set<String>();
            Set<string> deletableStatuses = new set<String>();
            Set<string> hiddenStatuses = new set<String>();
            Set<string> historyStatuses = new set<String>();
            RecordAccess recordAccess = getRecordAccessForUser(sobjectName);
            String statusField = '';
            Date currentday = new DateUtility().getOrgToday();
            Boolean isCampaignExpire = false;
            List<Record> lstOpenRecords = new List<Record>();
            List<Record> lstCloseRecords = new List<Record>();
            List<Id> lstRelatedRecordIds = new List<Id>(mapRelatedRecord.keyset());
            //lstRelatedRecordIds.addAll(mapRelatedRecord.keyset());
            Set <String> queryAdditionalFields ;
            map<Id,List<Record>> mapRequestToOpenReports;
            map<Id,List<Record>> mapRequestToCloseReports;
            List<FGM_Portal__PortalConfiguration__c> lstPortalConfigRecord = new List<FGM_Portal__PortalConfiguration__c>(mapLanguageToPortalConfiguration.get(portalLanguage));
            //lstPortalConfigRecord = mapLanguageToPortalConfiguration.get(portalLanguage);
            FGM_Portal__PortalConfiguration__c objPortalConfigRecord = new FGM_Portal__PortalConfiguration__c();
            objPortalConfigRecord = lstPortalConfigRecord[0];

            //SObjectType objType = Schema.getGlobalDescribe().get(sobjectName);
            // Map<String,Schema.SObjectField> objFields = Schema.getGlobalDescribe().containsKey(sobjectName) ?Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap() : null;
            SchemaEngine.DescribeSObjectResultWrapper childSchema =  SchemaEngine.describeSobject('FGM_Base__Grantee_Report__c', true, true, true, true, true);
            if(sobjectName.equalsIgnoreCase('Opportunity'))
            {
                set<Id> setCampaignIds = new set<Id>();
                mapRequestToOpenReports = new map<Id,List<Record>>();
                mapRequestToCloseReports = new map<Id,List<Record>>();

                if(String.isBlank(objPortalConfigRecord.FGM_Portal__RequestStatusField__c))
                    statusField = 'StageName';
                else
                    statusField = objPortalConfigRecord.FGM_Portal__RequestStatusField__c;

                if(objPortalConfigRecord.FGM_Portal__RequestEditableStatus__c!=null || String.isNotBlank(objPortalConfigRecord.FGM_Portal__RequestEditableStatus__c))
                    editableStatuses.addAll(objPortalConfigRecord.FGM_Portal__RequestEditableStatus__c.split(';'));
                if(objPortalConfigRecord.FGM_Portal__RequestDeletableStatus__c!=null || String.isNotBlank(objPortalConfigRecord.FGM_Portal__RequestDeletableStatus__c))
                    deletableStatuses.addAll(objPortalConfigRecord.FGM_Portal__RequestDeletableStatus__c.split(';'));
                if(objPortalConfigRecord.FGM_Portal__RequestHistoryTab__c!=null || String.isNotBlank(objPortalConfigRecord.FGM_Portal__RequestHistoryTab__c))
                    historyStatuses.addAll(objPortalConfigRecord.FGM_Portal__RequestHistoryTab__c.split(';'));
                if(objPortalConfigRecord.FGM_Portal__RequestHiddenStatus__c!=null || String.isNotBlank(objPortalConfigRecord.FGM_Portal__RequestHiddenStatus__c))
                    hiddenStatuses.addAll(objPortalConfigRecord.FGM_Portal__RequestHiddenStatus__c.split(';'));

                List<Opportunity> lstOpportunity = new List<Opportunity>();

                queryAdditionalFields = new Set<String>();
                queryAdditionalFields.add('StageName');
                queryAdditionalFields.add('OwnerId');
                queryAdditionalFields.add('FGM_Base__Submitted_By__c');
                queryAdditionalFields.add('CampaignId');
                queryAdditionalFields.add(strRequestCampaignField);
                queryAdditionalFields.add('Quiz__c');
                queryAdditionalFields.add(statusField);

                for(Schema.FieldSetMember field : SObjectType.Opportunity.FieldSets.FGM_Portal__RequestDashboardFields.getFields()){
                    if(String.valueOf(field.getType()) == 'REFERENCE')
                    {
                        if(String.valueOf(field.getFieldPath()).endsWith('__c'))
                            queryAdditionalFields.add(String.valueOf(field.getFieldPath()).replace('__c','__r.Name'));
                        else
                            queryAdditionalFields.add(String.valueOf(field.getFieldPath()).replace('Id','.Name'));
                    }
                    if(queryFields.indexOf(field.getFieldPath())<0 )
                    {
                        queryAdditionalFields.add(field.getFieldPath());
                        queryFields.add(field.getFieldPath());
                    }
                    queryFieldLabel.add(field.getLabel());
                }

                List<String> sanitizedQueryAdditionalFields = new List<String>();

                for (String f : queryAdditionalFields) {
                    sanitizedQueryAdditionalFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                }

                String sanitizedRequestCampaignField = strRequestCampaignField.replaceAll('[^0-9a-zA-Z_.]', '');

                queryString = 'SELECT ' + String.join(new List<String>(sanitizedQueryAdditionalFields), ', ') + ' FROM Opportunity WHERE Id In : lstRelatedRecordIds AND StageName Not In : hiddenStatuses AND ' + sanitizedRequestCampaignField + ' != NULL WITH SECURITY_ENFORCED Order By LastmodifiedDate DESC LIMIT 5000';
                lstOpportunity = database.query(queryString);

                if(!lstOpportunity.isEmpty()){
                    for(Opportunity opp : lstOpportunity) {
                        setCampaignIds.add((ID)opp.get(strRequestCampaignField));
                    }
                }
                map<Id,Campaign> mapCampaign;
                if(setCampaignIds !=null && !setCampaignIds.isEmpty()){

                    mapCampaign = new Map<Id, Campaign>([
                        SELECT
                            Application_Quiz__c,
                            Application_Type__c,
                            EndDate,
                            IsActive,
                            LOI_Quiz__c,
                            Name,
                            RecordType.Name,
                            StartDate
                        FROM Campaign
                        WHERE Id IN :setCampaignIds
                        WITH SECURITY_ENFORCED
                    ]);

                }
                if(!lstOpportunity.isEmpty()){
                    for(Opportunity objRecord : lstOpportunity)
                    {
                        Record record = new Record();
                        record.record = objRecord;
                        record.recordAccess = new RecordAccess();
                        mapRequestToOpenReports.put(String.valueOf(objRecord.get('OwnerId')),new List<Record>{record});
                        Campaign campaign = mapCampaign.get((ID)objRecord.get(strRequestCampaignField));
                        Date campaignEndDate = campaign.EndDate;
                        list<DashboardRecordColor> oppAlerts = new list<DashboardRecordColor>();
                        if(!mapDashboardAlertSettings.isEmpty())
                            oppAlerts = mapDashboardAlertSettings.get('opportunity');
                        if( oppAlerts != null && !oppAlerts.isEmpty())
                        {
                            oppAlerts.sort();
                            for(DashboardRecordColor oppSetting : oppAlerts)
                            {
                                if(campaignEndDate != null)
                                {
                                    record.color = 'Black';
                                    string strOppStatus = (string)objRecord.get(statusField);
                                    set<string> setStrStatus = new set<string>(oppSetting.strStatus.toLowerCase().split(','));
                                    if(!setStrStatus.isEmpty() && string.isNotBlank(strOppStatus) && setStrStatus.contains(strOppStatus.toLowerCase()))
                                    {
                                        if( oppSetting.intTimeTrigger == null &&  currentday < campaignEndDate )
                                            record.color = oppSetting.strColor;
                                        else if( oppSetting.intTimeTrigger  != null )
                                        {
                                            if(currentday >= Date.valueOf(campaignEndDate).addDays((oppSetting.intTimeTrigger *(-1))) && currentday <=campaignEndDate)
                                            {
                                                record.color = oppSetting.strColor;
                                                break;
                                            }
                                            if(currentday<=campaignEndDate.addDays((oppSetting.intTimeTrigger *(-1))) && currentday>campaignEndDate)
                                            {
                                                record.color = oppSetting.strColor;
                                                break;
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        if(Site.getPathPrefix()!=null)
                        {
                            record.editUrl = Site.getPathPrefix() + communityApplicationPageUrl+'?Id=' + objRecord.get(strRequestCampaignField) + '&appId=' + objRecord.get('Id') + '&mode=edit&from=dashboard';
                            record.viewUrl = Site.getPathPrefix() + communityApplicationPageUrl+'?Id=' + objRecord.get(strRequestCampaignField) + '&appId=' + objRecord.get('Id') + '&mode=view&from=dashboard';
                        }
                        else
                        {
                            record.editUrl = communityApplicationPageUrl+'?Id=' + objRecord.get(strRequestCampaignField) + '&appId=' + objRecord.get('Id') + '&mode=edit&from=dashboard';
                            record.viewUrl = communityApplicationPageUrl+'?Id=' + objRecord.get(strRequestCampaignField) + '&appId=' + objRecord.get('Id') + '&mode=view&from=dashboard';
                        }
                        if(historyStatuses.contains(objRecord.StageName))
                        {
                            record.recordAccess.isEditable = false;
                            record.recordAccess.isDeletable = false;
                            lstCloseRecords.add(record);
                        }
                        else if(editableStatuses.contains(objRecord.StageName))
                        {
                            if(mapRelatedRecord.get(objRecord.Id) =='Edit' || mapRelatedRecord.get(objRecord.Id) =='All')
                            {
                                if(campaignEndDate != null && campaignEndDate >= currentday){
                                    if(objRecord.FGM_Base__Submitted_By__c != null && String.valueOf(objRecord.get(statusField)).equalsIgnoreCase('submitted'))
                                        record.recordAccess.isEditable = false;
                                    else
                                        record.recordAccess.isEditable = true;
                                }
                                else if(campaignEndDate != null ){
                                    if(campaignEndDate < currentday && objRecord.FGM_Base__Submitted_By__c != null && !String.valueOf(objRecord.get(statusField)).equalsIgnoreCase('submitted'))
                                        record.recordAccess.isEditable = true;
                                    else
                                        record.recordAccess.isEditable = false;
                                    if(communityAmendmentSetting.IsEnabled__c && !record.recordAccess.isEditable && campaignEndDate < currentday)
                                        record.recordAccess.isAmendable = false;
                                }
                                else
                                    record.recordAccess.isEditable = true;
                                record.recordAccess.isAmendable = false;
                            }
                            else
                            {
                                record.recordAccess.isEditable = false;
                                record.recordAccess.isAmendable = false;
                            }
                            if(deletableStatuses.contains(objRecord.StageName) && String.valueOf(objRecord.OwnerId).equals(currentUserId) && record.recordAccess.isEditable)
                                record.recordAccess.isDeletable = true;
                            else
                                record.recordAccess.isDeletable = false;
                            lstOpenRecords.add(record);
                        }
                        else
                        {
                            record.recordAccess.isEditable = false;
                            record.recordAccess.isDeletable = false;
                            if(communityAmendmentSetting.IsEnabled__c && objRecord.FGM_Base__Submitted_By__c != null && !String.valueOf(objRecord.get(statusField)).equalsIgnoreCase('submitted'))
                                record.recordAccess.isAmendable = true;
                            else
                                record.recordAccess.isAmendable = false;

                            lstOpenRecords.add(record);
                        }
                    }}
            }
            if(sobjectName == 'FGM_Base__Benchmark__c')
            {
                mapRequestToOpenReports = new map<Id,List<Record>>();
                mapRequestToCloseReports = new map<Id,List<Record>>();
                List<FGM_Base__Benchmark__c> lstBenchmark = new List<FGM_Base__Benchmark__c>();
                statusField = 'FGM_Base__Status__c';
                if(objPortalConfigRecord.FGM_Portal__BenchmarkEditableStatus__c!=null || String.isNotBlank(objPortalConfigRecord.FGM_Portal__BenchmarkEditableStatus__c))
                    editableStatuses.addAll(objPortalConfigRecord.FGM_Portal__BenchmarkEditableStatus__c.split(';'));
                if(objPortalConfigRecord.FGM_Portal__BenchmarkDeletableStatus__c!=null || String.isNotBlank(objPortalConfigRecord.FGM_Portal__BenchmarkDeletableStatus__c))
                    deletableStatuses.addAll(objPortalConfigRecord.FGM_Portal__BenchmarkDeletableStatus__c.split(';'));
                if(objPortalConfigRecord.FGM_Portal__RequestHistoryTab__c!=null || String.isNotBlank(objPortalConfigRecord.FGM_Portal__RequestHistoryTab__c))
                    historyStatuses.addAll(objPortalConfigRecord.FGM_Portal__RequestHistoryTab__c.split(';'));
                       queryAdditionalFields = new Set<String>();
                       queryAdditionalFields.add('FGM_Base__Status__c');
                       queryAdditionalFields.add('FGM_Base__Request__c');
                       queryAdditionalFields.add('FGM_Base__Request__r.StageName');

                       for(Schema.FieldSetMember field : SObjectType.FGM_Base__Benchmark__c.FieldSets.FGM_Portal__BenchmarkDashboardFields.getFields())
                       {
                           if(String.valueOf(field.getType()) == 'REFERENCE')
                           {
                               if(String.valueOf(field.getFieldPath()).endsWith('__c'))
                                   queryAdditionalFields.add(String.valueOf(field.getFieldPath()).replace('__c','__r.Name'));
                               else
                                   queryAdditionalFields.add(String.valueOf(field.getFieldPath()).replace('Id','.Name'));
                           }
                           if(queryFields.indexOf(field.getFieldPath())<0)
                           {
                               queryFields.add(field.getFieldPath());
                               queryAdditionalFields.add(field.getFieldPath());
                           }
                           queryFieldLabel.add(field.getLabel());
                       }

                        List<String> sanitizedQueryAdditionalFields = new List<String>();

                        for (String f : queryAdditionalFields) {
                            sanitizedQueryAdditionalFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                        }

                        String sanitizedSObjectName = sobjectName.replaceAll('[^0-9a-zA-Z_.]', '');

                       queryString = 'SELECT ' + String.join(new List<String>(sanitizedQueryAdditionalFields), ', ') + ' FROM ' + sanitizedSObjectName + ' WHERE FGM_Base__Request__c In : lstRelatedRecordIds WITH SECURITY_ENFORCED Order By LastmodifiedDate DESC LIMIT 5000';
                       lstBenchmark = database.query(queryString);
                if(!lstBenchmark.isEmpty()){
                    for(FGM_Base__Benchmark__c  objRecord : lstBenchmark )
                    {
                        Record record = new Record();
                        record.record = objRecord;
                        record.recordAccess = new RecordAccess();
                        if(Site.getPathPrefix()!=null)
                        {
                            record.editUrl = Site.getPathPrefix() + fcRecordPageUrl +'?Id=' + objRecord.get('Id') + '&mode=edit';
                            record.viewUrl = Site.getPathPrefix() + fcRecordPageUrl +'?Id='  +  objRecord.get('Id') + '&mode=view';
                        }
                        else
                        {
                            record.editUrl = fcRecordPageUrl +'?Id='  + objRecord.get('Id') + '&mode=edit';
                            record.viewUrl = fcRecordPageUrl +'?Id='  +  objRecord.get('Id') + '&mode=view';
                        }
                        if(historyStatuses.contains(objRecord.FGM_Base__Request__r.StageName))
                        {
                            record.recordAccess.isEditable = false;
                            record.recordAccess.isDeletable = false;
                            lstCloseRecords.add(record);
                        }
                        else if(editableStatuses.contains(String.valueOf(objRecord.get(statusField))))
                        {
                            if(mapRelatedRecord.get(String.valueOf(objRecord.get('FGM_Base__Request__c'))) =='Edit' || mapRelatedRecord.get(String.valueOf(objRecord.get('FGM_Base__Request__c')))=='All')
                            {
                                record.recordAccess.isEditable = true;
                                if(!deletableStatuses.contains(String.valueOf(objRecord.get(statusField))))
                                    record.recordAccess.isDeletable = false;
                            }
                            else
                            {
                                record.recordAccess.isEditable = false;
                                record.recordAccess.isDeletable = false;
                            }
                            lstOpenRecords.add(record);
                        }
                        else
                        {
                            record.recordAccess.isEditable = false;
                            record.recordAccess.isDeletable = false;
                            lstOpenRecords.add(record);
                        }
                    }}
            }
            else if(sobjectName == 'Lead')
            {
                mapRequestToOpenReports = new map<Id,List<Record>>();
                mapRequestToCloseReports = new map<Id,List<Record>>();
                List<Lead> lstLead = new List<Lead>();
                if( string.isNotBlank(objPortalConfigRecord.FGM_Portal__InquiryStatusField__c))
                    statusField = objPortalConfigRecord.FGM_Portal__InquiryStatusField__c;
                else
                    statusField = 'Status';

                if(objPortalConfigRecord.FGM_Portal__InquiryEditableStatus__c!=null || String.isNotBlank(objPortalConfigRecord.FGM_Portal__InquiryEditableStatus__c))
                    editableStatuses.addAll(objPortalConfigRecord.FGM_Portal__InquiryEditableStatus__c.split(';'));
                if(objPortalConfigRecord.FGM_Portal__InquiryDeletableStatus__c!=null || String.isNotBlank(objPortalConfigRecord.FGM_Portal__InquiryDeletableStatus__c))
                    deletableStatuses.addAll(objPortalConfigRecord.FGM_Portal__InquiryDeletableStatus__c.split(';'));
                if(objPortalConfigRecord.FGM_Portal__InquiryHistoryTab__c!=null || String.isNotBlank(objPortalConfigRecord.FGM_Portal__InquiryHistoryTab__c))
                    historyStatuses.addAll(objPortalConfigRecord.FGM_Portal__InquiryHistoryTab__c.split(';'));
                if(objPortalConfigRecord.FGM_Portal__InquiryHiddenStatus__c!=null || String.isNotBlank(objPortalConfigRecord.FGM_Portal__InquiryHiddenStatus__c))
                    hiddenStatuses.addAll(objPortalConfigRecord.FGM_Portal__InquiryHiddenStatus__c.split(';'));

                       queryAdditionalFields = new Set<String>();
                       queryAdditionalFields.add('Status');
                       queryAdditionalFields.add('OwnerId');
                       queryAdditionalFields.add('FGM_Base__Submitted_By__c');
                       queryAdditionalFields.add('Quiz__c');
                       queryAdditionalFields.add(statusField);

                       for(Schema.FieldSetMember field :SObjectType.Lead.FieldSets.FGM_Portal__InquiryDashboardFields.getFields())
                       {
                           if(String.valueOf(field.getType()) == 'REFERENCE')
                           {
                               if(String.valueOf(field.getFieldPath()).endsWith('__c'))
                                   queryAdditionalFields.add(String.valueOf(field.getFieldPath()).replace('__c','__r.Name'));
                               else
                                   queryAdditionalFields.add(String.valueOf(field.getFieldPath()).replace('Id','.Name'));
                           }
                           if(queryFields.indexOf(field.getFieldPath())<0)
                           {
                               queryFields.add(field.getFieldPath());
                               queryAdditionalFields.add(field.getFieldPath());
                           }
                           queryFieldLabel.add(field.getLabel());
                       }
                       String usrContId = lstUser[0].ContactId ;
                       List<String> sanitizedQueryAdditionalFields = new List<String>();
                       for (String f : queryAdditionalFields) {
                        sanitizedQueryAdditionalFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                       }
                       queryString = '';
                       queryString += 'SELECT ';
                       queryString += (queryAdditionalFields != null && queryAdditionalFields.size() > 0) ? (String.join(new List<String>(sanitizedQueryAdditionalFields), ', ') ) : '' ;
                       queryString += ', (SELECT CampaignId,Campaign.EndDate FROM CampaignMembers )' ;
                       queryString += ' FROM Lead';
                       if(Schema.getGlobalDescribe().get('FC_Reviewer__External_Review__c') != null) {
                          queryString += ' WHERE Id IN (SELECT LeadId FROM CampaignMember) AND Status Not In : hiddenStatuses';
                           queryString += ' AND Id NOT IN (SELECT FC_Reviewer__Lead__c FROM FC_Reviewer__External_Review__c WHERE FC_Reviewer__Contact__c =: usrContId And FC_Reviewer__Lead__c != null) WITH SECURITY_ENFORCED Order By LastmodifiedDate DESC LIMIT 5000';
                      }
                       else
                           queryString += ' WHERE Id IN (SELECT LeadId FROM CampaignMember) AND Status Not In : hiddenStatuses WITH SECURITY_ENFORCED Order By LastmodifiedDate DESC LIMIT 5000';
                       lstLead = database.query(queryString);
                Date campaignEndDate;
                Id campaignId;
                if(!lstLead.isEmpty()){
                    for(Lead objRecord : lstLead)
                    {
                        Record record = new Record();
                        record.record = objRecord;
                        record.recordAccess = new RecordAccess();

                        if(objRecord.CampaignMembers!= null && !objRecord.CampaignMembers.isEmpty() )
                        {
                            for( CampaignMember campaign : objRecord.CampaignMembers )
                            {
                                campaignEndDate = Date.valueOf(campaign.Campaign.EndDate) ;
                                campaignId = campaign.Campaign.Id;
                                Date currentDate = new DateUtility().getOrgToday();
                                if((campaign.Campaign.EndDate != null) && (campaign.Campaign.EndDate < currentDate))
                                {
                                    isCampaignExpire = true;
                                }
                                else if( objRecord.FGM_Base__Submitted_By__c == null)
                                    record.recordAccess.isEditable = true;
                                else
                                    record.recordAccess.isEditable = false;
                            }
                        }
                        if(Site.getPathPrefix()!=null)
                        {
                            record.editUrl = Site.getPathPrefix() + communityApplicationPageUrl+'?Id=' + campaignId + '&appId=' + objRecord.get('Id') + '&mode=edit&from=dashboard';
                            record.viewUrl = Site.getPathPrefix() + communityApplicationPageUrl+'?Id=' + campaignId + '&appId=' + objRecord.get('Id') + '&mode=view&from=dashboard';
                        }
                        else
                        {
                            record.editUrl = communityApplicationPageUrl+'?Id=' + campaignId + '&appId=' + objRecord.get('Id') + '&mode=edit&from=dashboard';
                            record.viewUrl = communityApplicationPageUrl+'?Id=' + campaignId + '&appId=' + objRecord.get('Id') + '&mode=view&from=dashboard';
                        }
                        list<DashboardRecordColor> leadAlerts = new list<DashboardRecordColor>();
                        if(!mapDashboardAlertSettings.isEmpty())
                            leadAlerts = mapDashboardAlertSettings.get('lead');
                        if( leadAlerts != null && !leadAlerts.isEmpty())
                        {
                            leadAlerts.sort();
                            for( DashboardRecordColor leadSetting : leadAlerts )
                            {
                                record.color = 'Black';
                                if( campaignEndDate != null )
                                {
                                    set<string> setLeadStatuses = new set<string> (leadSetting.strStatus.toLowerCase().split(','));
                                    if(!setLeadStatuses.isEmpty() && string.isNotBlank(statusField) && setLeadStatuses.contains(statusField.toLowerCase()))
                                    {
                                        if(leadSetting.intTimeTrigger == null &&  currentday < campaignEndDate)
                                            record.color = leadSetting.strColor;
                                        else if( leadSetting.intTimeTrigger != null )
                                        {
                                            if(currentday >= campaignEndDate.addDays((leadSetting.intTimeTrigger *(-1))) && currentday <= campaignEndDate)
                                            {
                                                record.color = leadSetting.strColor;
                                                break;
                                            }
                                            if(currentday<=campaignEndDate.addDays((leadSetting.intTimeTrigger *(-1))) && currentday>campaignEndDate)
                                            {
                                                record.color = leadSetting.strColor;
                                                break;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if(historyStatuses.contains(String.valueOf(objRecord.Status)))
                        {
                            record.recordAccess.isEditable = false;
                            record.recordAccess.isDeletable = false;
                            lstCloseRecords.add(record);
                        }
                        else if(editableStatuses.contains(String.valueOf(objRecord.Status)))
                        {
                            record.recordAccess.isEditable = true;
                            if(!deletableStatuses.contains(String.valueOf(objRecord.Status)) && objRecord.OwnerId == currentUserId)
                                record.recordAccess.isDeletable = false;
                            lstOpenRecords.add(record);
                        }
                        else
                        {
                            record.recordAccess.isEditable = false;
                            record.recordAccess.isDeletable = false;
                            lstOpenRecords.add(record);
                        }
                    }
                }
            }
            else if(sobjectName == 'FGM_Base__Grantee_Report__c')
            {
                mapRequestToOpenReports = new map<Id,List<Record>>();
                mapRequestToCloseReports = new map<Id,List<Record>>();
                List<FGM_Base__Grantee_Report__c> lstGranteeReports = new List<FGM_Base__Grantee_Report__c>();
                if( string.isNotBlank(objPortalConfigRecord.FGM_Portal__GranteeReportStatusField__c))
                    statusField = objPortalConfigRecord.FGM_Portal__GranteeReportStatusField__c;
                else
                    statusField = 'FGM_Base__Status__c';

                if(objPortalConfigRecord.FGM_Portal__GranteeReportEditableStatus__c!=null || String.isNotBlank(objPortalConfigRecord.FGM_Portal__GranteeReportEditableStatus__c))
                    editableStatuses.addAll(objPortalConfigRecord.FGM_Portal__GranteeReportEditableStatus__c.split(';'));
                if(objPortalConfigRecord.FGM_Portal__GranteeReportDeletableStatus__c!=null || String.isNotBlank(objPortalConfigRecord.FGM_Portal__GranteeReportDeletableStatus__c))
                    deletableStatuses.addAll(objPortalConfigRecord.FGM_Portal__GranteeReportDeletableStatus__c.split(';'));
                if(objPortalConfigRecord.FGM_Portal__GranteeReportHistoryTab__c!=null || String.isNotBlank(objPortalConfigRecord.FGM_Portal__GranteeReportHistoryTab__c))
                    historyStatuses.addAll(objPortalConfigRecord.FGM_Portal__GranteeReportHistoryTab__c.split(';'));
                if(objPortalConfigRecord.FGM_Portal__GranteeReportHiddenStatus__c!=null || String.isNotBlank(objPortalConfigRecord.FGM_Portal__GranteeReportHiddenStatus__c))
                    hiddenStatuses.addAll(objPortalConfigRecord.FGM_Portal__GranteeReportHiddenStatus__c.split(';'));

                    queryAdditionalFields = new Set<String>();
                    queryAdditionalFields.add('FGM_Base__Status__c');
                    queryAdditionalFields.add('FGM_Base__Due_Date__c');
                    queryAdditionalFields.add('FGM_Base__Request__c');
                    queryAdditionalFields.add(statusField);

                    for(Schema.FieldSetMember field : SObjectType.FGM_Base__Grantee_Report__c.FieldSets.FGM_Portal__GranteeReportDashboardFields.getFields())
                    {
                        if(String.valueOf(field.getType()) == 'REFERENCE')
                        {
                            if(String.valueOf(field.getFieldPath()).endsWith('__c'))
                                queryAdditionalFields.add(String.valueOf(field.getFieldPath()).replace('__c','__r.Name'));
                            else
                                queryAdditionalFields.add(String.valueOf(field.getFieldPath()).replace('Id','.Name'));
                        }
                        if(queryFields.indexOf(field.getFieldPath())<0)
                        {
                            queryFields.add(field.getFieldPath());
                            queryAdditionalFields.add(field.getFieldPath());
                        }
                        queryFieldLabel.add(field.getLabel());
                    }
                    List<String> sanitizedQueryAdditionalFields = new List<String>();
                    for (String f : queryAdditionalFields) {
                        sanitizedQueryAdditionalFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                    }
                    queryString  = 'SELECT ' + String.join(new List<String>(sanitizedQueryAdditionalFields), ', ') + ' FROM FGM_Base__Grantee_Report__c WHERE FGM_Base__Request__c  IN : lstRelatedRecordIds AND FGM_Base__Status__c Not In : hiddenStatuses WITH SECURITY_ENFORCED Order By LastmodifiedDate DESC LIMIT 5000';
                    lstGranteeReports = database.query(queryString);
                if(!lstGranteeReports.isEmpty()){
                    for(FGM_Base__Grantee_Report__c objRecord : lstGranteeReports)
                    {
                        Record record = new Record();
                        record.record = objRecord;
                        record.recordAccess = new RecordAccess();

                        if(Site.getPathPrefix()!=null)
                        {
                            record.editUrl = Site.getPathPrefix() + fcRecordPageUrl +'?Id='  + objRecord.get('Id') + '&mode=edit';
                            record.viewUrl = Site.getPathPrefix() + fcRecordPageUrl +'?Id='  +  objRecord.get('Id') + '&mode=view';
                        }
                        else
                        {
                            record.editUrl = fcRecordPageUrl +'?Id='  + objRecord.get('Id') + '&mode=edit';
                            record.viewUrl = fcRecordPageUrl +'?Id='  +  objRecord.get('Id') + '&mode=view';
                        }
                        list<DashboardRecordColor> gRAlerts = new list<DashboardRecordColor>();
                        if(!mapDashboardAlertSettings.isEmpty())
                            gRAlerts = mapDashboardAlertSettings.get('fgm_base__grantee_report__c');

                        if(gRAlerts != null && !gRAlerts.isEmpty())
                        {
                            gRAlerts.sort();
                            for(DashboardRecordColor gRSetting : gRAlerts)
                            {
                                record.color = 'Black';
                                if(objRecord.FGM_Base__Due_Date__c!= null)
                                {
                                    string strGRStatus = String.valueOf(objRecord.get(statusField));
                                    set<string> setStrStatus = new set<string> (gRSetting.strStatus.toLowerCase().split(','));
                                    if(!setStrStatus.isEmpty() && string.isNotBlank(strGRStatus) && setStrStatus.contains(strGRStatus.toLowerCase()))
                                    {
                                        if( gRSetting.intTimeTrigger == null &&  currentday < Date.valueOf(objRecord.get('FGM_Base__Due_Date__c')) )
                                            record.color = gRSetting.strColor;
                                        else if( gRSetting.intTimeTrigger != null )
                                        {
                                            if(currentday >=  Date.valueOf(objRecord.get('FGM_Base__Due_Date__c')).addDays((gRSetting.intTimeTrigger*(-1))) && currentday <=  Date.valueOf(objRecord.get('FGM_Base__Due_Date__c')))
                                            {
                                                record.color = gRSetting.strColor;
                                                break;
                                            }

                                            if(currentday <=  Date.valueOf(objRecord.get('FGM_Base__Due_Date__c')).addDays((gRSetting.intTimeTrigger*(-1))) && currentday> Date.valueOf(objRecord.get('FGM_Base__Due_Date__c')))
                                            {
                                                record.color = gRSetting.strColor;
                                                break;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if(historyStatuses.contains(objRecord.FGM_Base__Status__c))
                        {
                            record.recordAccess.isEditable = false;
                            record.recordAccess.isDeletable = false;
                            lstCloseRecords.add(record);

                        }
                        else if(editableStatuses.contains(String.valueOf(objRecord.FGM_Base__Status__c)))
                        {
                            if(mapRelatedRecord.get(String.valueOf(objRecord.FGM_Base__Request__c))=='Edit' || mapRelatedRecord.get(String.valueOf(objRecord.FGM_Base__Request__c)) =='All')
                            {
                                record.recordAccess.isEditable = true;
                                if(!deletableStatuses.contains(objRecord.FGM_Base__Status__c))
                                    record.recordAccess.isDeletable = false;
                            }
                            else
                            {
                                record.recordAccess.isEditable = false;
                                record.recordAccess.isDeletable = false;
                            }
                            lstOpenRecords.add(record);
                        }
                        else
                        {
                            record.recordAccess.isEditable = false;
                            record.recordAccess.isDeletable = false;
                            lstOpenRecords.add(record);
                        }
                        if(mapRequestToCloseReports!=null && mapRequestToCloseReports.get(String.valueOf(objRecord.get('FGM_Base__Request__c')))!=null)
                        {
                            List<Record> closeReportRecords = mapRequestToCloseReports.get(String.valueOf(objRecord.get('FGM_Base__Request__c')));
                            closeReportRecords.add(record);
                            mapRequestToCloseReports.put(String.valueOf(objRecord.get('FGM_Base__Request__c')),closeReportRecords);
                        }
                        else
                        {
                            mapRequestToCloseReports.put(String.valueOf(objRecord.get('FGM_Base__Request__c')),new List<Record>{record});
                        }

                        if(mapRequestToOpenReports!=null && mapRequestToOpenReports.get(String.valueOf(objRecord.FGM_Base__Request__c))!=null)
                        {
                            List<Record> openReportRecords = mapRequestToOpenReports.get(String.valueOf(objRecord.get('FGM_Base__Request__c')));
                            openReportRecords.add(record);
                            mapRequestToOpenReports.put(String.valueOf(objRecord.get('FGM_Base__Request__c')),openReportRecords);
                        }
                        else
                        {
                            mapRequestToOpenReports.put(String.valueOf(objRecord.get('FGM_Base__Request__c')),new List<Record>{record});
                        }
                    }
                }
            }
            else if(sobjectName == 'FGM_Portal__Amendment__c')
            {
                statusField = 'FGM_Portal__StageName__c';
                String contctRecordTypeId = FCGlobal.getRecordTypeId(String.valueOf(Amendment__c.getsObjectType()),'Contact');
                String oppRecordTypeId = FCGlobal.getRecordTypeId(String.valueOf(Amendment__c.getsObjectType()),'Opportunity');
                List<FGM_Portal__Amendment__c> lstAmendment = new List<FGM_Portal__Amendment__c>();
                if(objPortalConfigRecord.FGM_Portal__AmendmentEditableStatus__c!=null || String.isNotBlank(objPortalConfigRecord.FGM_Portal__AmendmentEditableStatus__c))
                    editableStatuses.addAll(objPortalConfigRecord.FGM_Portal__AmendmentEditableStatus__c.split(';'));
                if(objPortalConfigRecord.FGM_Portal__AmendmentDeletableStatus__c!=null || String.isNotBlank(objPortalConfigRecord.FGM_Portal__AmendmentDeletableStatus__c))
                    deletableStatuses.addAll(objPortalConfigRecord.FGM_Portal__AmendmentDeletableStatus__c.split(';'));
                if(objPortalConfigRecord.FGM_Portal__AmendmentHistoryTab__c!=null || String.isNotBlank(objPortalConfigRecord.FGM_Portal__AmendmentHistoryTab__c))
                    historyStatuses.addAll(objPortalConfigRecord.FGM_Portal__AmendmentHistoryTab__c.split(';'));
                if(objPortalConfigRecord.FGM_Portal__AmendmentHiddenStatus__c!=null || String.isNotBlank(objPortalConfigRecord.FGM_Portal__AmendmentHiddenStatus__c))
                    hiddenStatuses.addAll(objPortalConfigRecord.FGM_Portal__AmendmentHiddenStatus__c.split(';'));

                    queryAdditionalFields = new Set<String>();
                    queryAdditionalFields.add('FGM_Portal__StageName__c');
                    queryAdditionalFields.add('RecordTypeId');
                    queryAdditionalFields.add('FGM_Portal__ParentRequest__c');
                    queryAdditionalFields.add('OwnerId');
                    for(Schema.FieldSetMember field :SObjectType.FGM_Portal__Amendment__c.FieldSets.FGM_Portal__AmendmentDashboardFields.getFields())
                    {
                        if(String.valueOf(field.getType()) == 'REFERENCE')
                        {
                            if(String.valueOf(field.getFieldPath()).endsWith('__c'))
                                queryAdditionalFields.add(String.valueOf(field.getFieldPath()).replace('__c','__r.Name'));
                            else
                                queryAdditionalFields.add(String.valueOf(field.getFieldPath()).replace('Id','.Name'));
                        }
                        if(queryFields.indexOf(field.getFieldPath())<0)
                        {
                            queryFields.add(field.getFieldPath());
                            queryAdditionalFields.add(field.getFieldPath());
                        }
                        queryFieldLabel.add(field.getLabel());
                    }
                    List<String> sanitizedQueryAdditionalFields = new List<String>();
                    for (String f : queryAdditionalFields) {
                        sanitizedQueryAdditionalFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                    }
                    queryString = '';
                    queryString += 'SELECT ';
                    queryString += (queryAdditionalFields != null && queryAdditionalFields.size() > 0) ? (String.join(new List<String>(sanitizedQueryAdditionalFields), ', ') ) : '' ;
                    queryString += ' FROM FGM_Portal__Amendment__c WHERE FGM_Portal__StageName__c Not In : hiddenStatuses AND (OwnerId =: currentUserId OR (OwnerId IN : setOppOwnrId AND RecordTypeId != : contctRecordTypeId AND RecordTypeId != : oppRecordTypeId) OR (RecordTypeId =: oppRecordTypeId AND FGM_Portal__ParentRequest__c IN : lstRelatedRecordIds)) WITH SECURITY_ENFORCED Order By LastmodifiedDate DESC LIMIT 5000';
                    lstAmendment = database.query(queryString);
                if(!lstAmendment.isEmpty()){
                    for(FGM_Portal__Amendment__c objRecord : lstAmendment )
                    {
                        Record record = new Record();
                        record.record = objRecord;
                        record.recordAccess = new RecordAccess();

                        if(Site.getPathPrefix()!=null)
                        {
                            record.editUrl = Site.getPathPrefix() + fcRecordPageUrl +'?Id='  + objRecord.get('Id') + '&mode=edit';
                            record.viewUrl = Site.getPathPrefix() + fcRecordPageUrl +'?Id='  +  objRecord.get('Id') + '&mode=view';
                        }
                        else
                        {
                            record.editUrl = fcRecordPageUrl +'?Id='  + objRecord.get('Id') + '&mode=edit';
                            record.viewUrl = fcRecordPageUrl +'?Id='  +  objRecord.get('Id') + '&mode=view';
                        }

                        if(historyStatuses.contains(objRecord.FGM_Portal__StageName__c))
                        {
                            record.recordAccess.isEditable = false;
                            record.recordAccess.isDeletable = false;
                            lstCloseRecords.add(record);
                        }
                        else if(editableStatuses.contains(objRecord.FGM_Portal__StageName__c))
                        {
                            if(oppRecordTypeId == objRecord.RecordTypeId)
                            {
                                if(mapRelatedRecord.get(String.valueOf(objRecord.get('FGM_Portal__ParentRequest__c'))) =='Edit' || mapRelatedRecord.get(String.valueOf(objRecord.get('FGM_Portal__ParentRequest__c'))) =='All')
                                {
                                    record.recordAccess.isEditable = true;
                                    if(!deletableStatuses.contains(objRecord.FGM_Portal__StageName__c))
                                        record.recordAccess.isDeletable = false;
                                }
                                else
                                {
                                    record.recordAccess.isEditable = false;
                                    record.recordAccess.isDeletable = false;
                                }
                            }
                            else
                            {
                                record.recordAccess.isEditable = true;
                                if(!deletableStatuses.contains(objRecord.FGM_Portal__StageName__c))
                                    record.recordAccess.isDeletable = false;
                            }
                            lstOpenRecords.add(record);
                        }
                        else
                        {
                            record.recordAccess.isEditable = false;
                            record.recordAccess.isDeletable = false;
                            lstOpenRecords.add(record);
                        }
                    }
                }
            }
            DataWrapper dataWrapperOpen = new DataWrapper();
            dataWrapperOpen.records = lstOpenRecords;
            dataWrapperOpen.mapRelatedRecords = mapRequestToOpenReports;

            DataWrapper dataWrapperClose = new DataWrapper();
            dataWrapperClose.records = lstCloseRecords;
            dataWrapperClose.mapRelatedRecords = mapRequestToCloseReports;

            TabWrapper tabWrapperOpen = new  TabWrapper(sobjectName);
            tabWrapperOpen.childSchema = childSchema;
            tabWrapperOpen.lstFieldNames = queryFields;
            tabWrapperOpen.lstFieldLabels = queryFieldLabel;
            tabWrapperOpen.tabName = sobjectName;
            tabWrapperOpen.tabLabel = 'Open Tab';
            tabWrapperOpen.data = dataWrapperOpen;
            tabWrapperOpen.mapActions.put('NEXT',System.Label.FGM_Portal.FC_Next_ButtonLabel);
            tabWrapperOpen.mapActions.put('SAVEANDNEXT',System.Label.FGM_Portal.FC_Save_Next_ButtonLabel);
            tabWrapperOpen.mapActions.put('SAVE',System.Label.FGM_Portal.FC_Save_ButtonLabel);
            tabWrapperOpen.mapActions.put('CLEARCHANGES',System.Label.FGM_Portal.FC_Clear_Unsaved_Changes_Button);
            tabWrapperOpen.mapActions.put('INVITETEAMMEMBER',System.Label.FGM_Portal.FC_InviteNewMember_ButtonLabel);
            tabWrapperOpen.mapActions.put('SEARCHANDADDMEMBER',System.Label.FGM_Portal.FC_Search_Add_Member_ButtonLabel);
            tabWrapperOpen.mapActions.put('EDIT',System.Label.FGM_Portal.fc_edit_buttonlabel);
            tabWrapperOpen.mapActions.put('VIEW',System.Label.FGM_Portal.fc_view_buttonlabel);
            tabWrapperOpen.mapActions.put('DELETE',System.Label.FGM_Portal.fc_delete_buttonlabel);
            tabWrapperOpen.mapActions.put('AMEND', 'Amend');
            tabWrapperOpen.mapActions.put('CHILDRECORDS','DROP-DOWN-ICON');

            TabWrapper tabWrapperClose = new  TabWrapper(sobjectName);
            tabWrapperClose.childSchema = childSchema;
            tabWrapperClose.lstFieldNames = queryFields;
            tabWrapperClose.lstFieldLabels = queryFieldLabel;
            tabWrapperClose.data = dataWrapperClose;
            tabWrapperClose.tabName =sobjectName;
            tabWrapperClose.tabLabel = 'Close Tab';
            tabWrapperClose.mapActions.put('NEXT',System.Label.FGM_Portal.FC_Next_ButtonLabel);
            tabWrapperClose.mapActions.put('SAVEANDNEXT',System.Label.FGM_Portal.FC_Save_Next_ButtonLabel);
            tabWrapperClose.mapActions.put('SAVE',System.Label.FGM_Portal.FC_Save_ButtonLabel);
            tabWrapperClose.mapActions.put('CLEARCHANGES',System.Label.FGM_Portal.FC_Clear_Unsaved_Changes_Button);
            tabWrapperClose.mapActions.put('INVITETEAMMEMBER',System.Label.FGM_Portal.FC_InviteNewMember_ButtonLabel);
            tabWrapperClose.mapActions.put('SEARCHANDADDMEMBER',System.Label.FGM_Portal.FC_Search_Add_Member_ButtonLabel);
            tabWrapperClose.mapActions.put('EDIT',System.Label.FGM_Portal.fc_edit_buttonlabel);
            tabWrapperClose.mapActions.put('VIEW',System.Label.FGM_Portal.fc_view_buttonlabel);
            tabWrapperClose.mapActions.put('DELETE',System.Label.FGM_Portal.fc_delete_buttonlabel);
            tabWrapperClose.mapActions.put('AMEND','Amend');
            tabWrapperClose.mapActions.put('CHILDRECORDS','DROP-DOWN-ICON');

            List<TabWrapper> lstRequestTab = new List<TabWrapper>();
            lstRequestTab.add(tabWrapperOpen);
            lstRequestTab.add(tabWrapperClose);
            return lstRequestTab;
        }
        catch(Exception ex)
        {
              handleException(ex);
        }
        return null;
    }

    @RemoteAction
    public static Boolean deleteRecord(Id application)
    {
        try
        {
            CrudFlsService.getInstance().assertDeletable(new List<String>{application});
            Database.DeleteResult[] deleteResultList = Database.delete(new List<Id>{application});
            if(!deleteResultList.isEmpty()){
                for(Database.DeleteResult result : deleteResultList)
                {
                    if (result.isSuccess())
                    {
                        return true;
                    }
                }
            }
        }
        catch(Exception ex)
        {
            handleException(ex);
        }
        return false;
    }
    public static TabWrapper getActionsOfTab(String tabLabel, Boolean isDisabled, Boolean isSelected, Integer badgeCount, String tabName, FGM_Portal__Related_List_Controller__c tabDetails, List<FGM_Portal__Quiz_Questions__c> quizQuestions, List<String> rlcFlds){
        TabWrapper objTabWrapper = new TabWrapper(tabLabel,isDisabled,isSelected,badgeCount,tabName,tabDetails,quizQuestions,rlcFlds);
        objTabWrapper.mapActions.put('NEXT',System.Label.FGM_Portal.FC_Next_ButtonLabel);
        objTabWrapper.mapActions.put('SAVEANDNEXT',System.Label.FGM_Portal.FC_Save_Next_ButtonLabel);
        objTabWrapper.mapActions.put('SAVE',System.Label.FGM_Portal.FC_Save_ButtonLabel);
        objTabWrapper.mapActions.put('CLEARCHANGES',System.Label.FGM_Portal.FC_Clear_Unsaved_Changes_Button);
        objTabWrapper.mapActions.put('INVITETEAMMEMBER',System.Label.FGM_Portal.FC_InviteNewMember_ButtonLabel);
        objTabWrapper.mapActions.put('SEARCHANDADDMEMBER',System.Label.FGM_Portal.FC_Search_Add_Member_ButtonLabel);
        objTabWrapper.mapActions.put('EDIT',System.Label.FGM_Portal.fc_edit_buttonlabel);
        objTabWrapper.mapActions.put('VIEW',System.Label.FGM_Portal.fc_view_buttonlabel);
        objTabWrapper.mapActions.put('DELETE',System.Label.FGM_Portal.fc_delete_buttonlabel);
        objTabWrapper.mapActions.put('AMEND','Amend');
        objTabWrapper.mapActions.put('CHILDRECORDS','dropDown');
        return  objTabWrapper;
    }
    /****************************************************************************************************
Purpose: These method retun the portalconfiguration coustom setting in order to initilize the dashboard
****************************************************************************************************/
    @RemoteAction
    public static ApplicationTabWrapper initializeDashboard(String portalLanguage)
    {
        ApplicationTabWrapper appWrapper = new ApplicationTabWrapper();
        FGM_Portal__PortalConfiguration__c objPortalConfigRecord = new FGM_Portal__PortalConfiguration__c();
        List<FGM_Portal__PortalConfiguration__c> lstPortalConfiguration = mapLanguageToPortalConfiguration.get(portalLanguage);
        if(lstPortalConfiguration==null || lstPortalConfiguration.size() > 1 || lstPortalConfiguration.size() == 0)
            throw new CustomException (JSON.serialize(new CustomExceptionWrapper(null,System.label.FC_Dashboard_Initialization_Error_Message,null,System.label.FC_Dashboard_Initialization_Error_Message,'warning','Warning')));

        objPortalConfigRecord = lstPortalConfiguration[0];
        try
        {
            List<TabWrapper> lstTabWrapper = new List<TabWrapper>();
            if(String.isNotBlank(objPortalConfigRecord.FGM_Portal__GranteeInboxTabLabel__c))
            {
                lstTabWrapper.add(getActionsOfTab(objPortalConfigRecord.FGM_Portal__GranteeInboxTabLabel__c,true,true,0,'Contact',null,null,null));
            }
            if(String.isNotBlank(objPortalConfigRecord.FGM_Portal__RequestName__c))
            {
                lstTabWrapper.add(getActionsOfTab(objPortalConfigRecord.FGM_Portal__RequestName__c,true,true,0,'Opportunity',null,null,null));
            }
            if(String.isNotBlank(objPortalConfigRecord.FGM_Portal__InquiryName__c))
            {
                lstTabWrapper.add(getActionsOfTab(objPortalConfigRecord.FGM_Portal__InquiryName__c,true,true,0,'Lead',null,null,null));
            }
            if(String.isNotBlank(objPortalConfigRecord.FGM_Portal__GranteeReportName__c))
            {
                lstTabWrapper.add(getActionsOfTab(objPortalConfigRecord.FGM_Portal__GranteeReportName__c,true,true,0,'FGM_Base__Grantee_Report__c',null,null,null));
            }
            if(String.isNotBlank(objPortalConfigRecord.FGM_Portal__BenchmarkName__c))
            {
                lstTabWrapper.add(getActionsOfTab(objPortalConfigRecord.FGM_Portal__BenchmarkName__c,true,true,0,'FGM_Base__Benchmark__c',null,null,null));
            }
            if(String.isNotBlank(objPortalConfigRecord.FGM_Portal__AmendmentName__c))
            {
                lstTabWrapper.add(getActionsOfTab(objPortalConfigRecord.FGM_Portal__AmendmentName__c,true,true,0,'FGM_Portal__Amendment__c',null,null,null));
            }
            appWrapper.lstTabs = lstTabWrapper;
            return appWrapper;
        }
        catch(Exception ex)
        {
            System.debug('Exception Details: ' + ex.getMessage() + '; Error at line no: ' + ex.getLineNumber());
            throw new CustomException (JSON.serialize(new CustomExceptionWrapper(ex.getLineNumber(),ex.getMessage(),ex.getStackTraceString(),System.label.FC_Dashboard_Initialization_Error_Message,'error','Error')));

        }
    }
    /****************************************************************************************************
Purpose: These method retun ActivityHistory record for contact and opportunity related to login user
*/
    @RemoteAction
    public static map<String,ActivityHistory> getmapActivityHistories()
    {
        try
        {
            lstContact = new WithoutSharing().getSObjectResults(lstUser[0]);
            map<String,ActivityHistory> mapActivities = new map<String,ActivityHistory>();
            if(lstContact != null && lstContact.size() > 0)
            {
                for(ActivityHistory activityHistory : lstContact[0].ActivityHistories)
                {
                    if(String.valueOf((activityHistory.WhatId).getSobjectType())=='Opportunity')
                    {
                        mapActivities.put(activityHistory.Id,activityHistory);
                    }
                }
            }
            return mapActivities;
        }
        catch(Exception ex)
        {
            throw new CustomException (JSON.serialize(new CustomExceptionWrapper(ex.getLineNumber(),ex.getMessage(),ex.getStackTraceString(),System.label.FC_Dashboard_Initialization_Error_Message,'error','Error')));
        }

    }
    /****************************************************************************************************
Purpose: These method retun emails (activity) and mailstaus from Secure_Message__c custom object from
the ActivityHistory related to the current user.
*/
    @RemoteAction
    public static List<SubClassActivityHistory> getActivityHistoryData()
    {
        try
        {
            CommunityDashboardController.unreadCount = 0;
            if(mapActivity != null && mapActivity.keySet() != null)
            {

                List<Secure_Message__c>  lstRefId = [
                    SELECT RefId__c
                    FROM Secure_Message__c
                    WHERE RefId__c = :mapActivity.keySet()
                    WITH SECURITY_ENFORCED
                    LIMIT 1000
                ];

                for(ActivityHistory activityHistory : mapActivity.values())
                {
                    String mailstatus = 'unread';
                    for(Secure_Message__c  securemsg : lstRefId )
                    {
                        if(activityHistory.Id == securemsg.RefId__c)
                            mailstatus = 'read';
                    }
                    if(mailstatus == 'unread')
                        CommunityDashboardController.unreadCount++;

                    SubClassActivityHistory newActivity = new SubClassActivityHistory(activityHistory, mailstatus);
                    if(newActivity.Activity.Subject != null && String.isNotBlank(newActivity.Activity.Subject))
                    {
                        String sub = (newActivity.Activity.Subject.contains('Email:')?newActivity.Activity.Subject.substringAfter('Email:'):newActivity.Activity.Subject);
                        newActivity.subject = (sub!=null && String.isNotBlank(sub))?sub:'(no subject)';
                    }
                    else
                        newActivity.subject = '(no subject)';
                    activities.add(newActivity);
                }
            }
            return activities;
        }
        catch(Exception ex)
        {
            throw new CustomException (JSON.serialize(new CustomExceptionWrapper(ex.getLineNumber(),ex.getMessage(),ex.getStackTraceString(),System.label.FC_Dashboard_Initialization_Error_Message,'error','Error')));
        }

    }
    /****************************************************************************************************
Purpose: These method used to handle commanly genarated exceptions
*/
    public static void handleException(Exception ex){
        System.debug('Exception Details: ' + ex.getMessage() + '; Error at line no: ' + ex.getLineNumber());
        String deleteErrorMessage = ex.getMessage();
        Integer occurence;
        if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
        {
            occurence = deleteErrorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
            deleteErrorMessage = deleteErrorMessage.mid(occurence, deleteErrorMessage.length());
            occurence = deleteErrorMessage.lastIndexOf(':');
            deleteErrorMessage = deleteErrorMessage.mid(0, occurence);
        }
        throw new CustomException (JSON.serialize(new CustomExceptionWrapper(ex.getLineNumber(),deleteErrorMessage,ex.getStackTraceString(),deleteErrorMessage,'error','Error')));

    }
    public class DataWrapper
    {
        public string sobjectType {get;set;}
        public string tabSobjectId {get;set;}
        public List<Record> records {get;set;}
        public map<Id,List<Record>> mapRelatedRecords {get;set;}
        public String iFrameURL {get;set;}
        public string query {get;set;}
        public DataWrapper()
        {
            sobjectType = null;
            tabSobjectId = null;
            records = new List<Record>();
            mapRelatedRecords = new map<Id,List<Record>>();
        }
    }
    public class Record
    {
        public sObject record {get;set;}
        public RecordAccess recordAccess {get;set;}
        public list<Record> relatedRecords {get;set;}
        public string color {get;set;}
        public string editUrl {get;set;}
        public string viewUrl {get;set;}
        public Record()
        {
            record = null;
            recordAccess = new RecordAccess();
            relatedRecords = new list<Record>();
            editUrl = '';
            viewUrl = '';
        }
    }
    public class RecordAccess
    {
        public Id sobjectId {get;set;}
        public boolean isCreatable {get;set;}
        public boolean isDeletable {get;set;}
        public boolean isEditable {get;set;}
        public boolean isReadable {get;set;}
        public boolean isAmendable {get;set;}
        public RecordAccess(){
            isCreatable = true;
            isDeletable = true;
            isEditable = true;
            isReadable = true;
            isAmendable = true;
        }

    }
    public class Actions
    {
        public string label {get;set;}
        public string name {get;set;}

        public Actions()
        {}
        public Actions(string label, string name)
        {
            this.label = label;
            this.name = name;
        }
    }
    public class TabWrapper                                // structural info of tab
    {
        public string tabLabel {get;set;}
        public boolean isDisabled {get;set;}
        public boolean isSelected {get;set;}
        public Integer badgeCount {get;set;}
        public string tabName {get;set;}
        public FGM_Portal__Related_List_Controller__c tabDetails {get;set;}
        public List<FGM_Portal__Quiz_Questions__c> quizQuestions {get;set;}
        public DataWrapper data {get;set;}
        public SchemaEngine.DescribeSObjectResultWrapper schema {get;set;}
        public SchemaEngine.DescribeSObjectResultWrapper childSchema {get;set;}
        public boolean isProcessing {get;set;}
        public List<TabWrapper> lstInternalTabs {get;set;}
        public List<String> lstFieldNames = new List <String>();
        public List<String> lstFieldLabels = new List <String>();
        public map<String,String> mapActions = new map<String, String>();
        public TabWrapper()
        {
        }
        public TabWrapper(String tabName)
        {
            this.schema = SchemaEngine.describeSobject(tabName, true, true, true, true, true);
        }
        public TabWrapper(String tabLabel, Boolean isDisabled, Boolean isSelected, Integer badgeCount, String tabName, FGM_Portal__Related_List_Controller__c tabDetails, List<FGM_Portal__Quiz_Questions__c> quizQuestions, List<String> rlcFlds)
        {
            this.tabLabel = tabLabel;
            this.isDisabled = isDisabled;
            this.isSelected = isSelected;
            this.badgeCount = badgeCount;
            this.tabName = tabName;
            this.tabDetails = tabDetails;
            this.quizQuestions = quizQuestions;
            this.schema = SchemaEngine.describeSobject(tabName, true, true, true, true, true);
            this.isProcessing = false;
            lstInternalTabs = new List<TabWrapper> ();
        }
    }
    /****************************************************************************************************
Purpose: all information about Tab and tab object
****************************************************************************************************/
    public class ApplicationTabWrapper
    {
        public string mode {get;set;}
        public List<TabWrapper> lstTabs {get;set;}
        public boolean isVertical {get;set;}
        public List<Actions> actions {get;set;}
        public Double userTimeOffset {get;set;}
        public ApplicationTabWrapper()
        {
            mode=null;
            lstTabs = new List<TabWrapper>();
            this.isVertical = true;
            actions = new List<Actions> ();
            userTimeOffset = (double)UserInfo.getTimeZone().getOffset(Datetime.now())/(1000*60*60); // get offset using any date

        }
    }

    public class DashboardRecordColor implements Comparable
    {
        public Date endDate { get; set; }
        public String strColor { get; set; }
        public String strStatus { get; set; }
        public Date timeTriggerDate { get; set; }
        public integer intTimeTrigger { get; set; }

        public DashboardRecordColor(){}

        public Integer compareTo(Object compareTo)
        {
            DashboardRecordColor compareTosetting = (DashboardRecordColor)compareTo;
            if (intTimeTrigger == compareTosetting.intTimeTrigger) return 0;
            if (intTimeTrigger > compareTosetting.intTimeTrigger) return 1;
            return -1;
        }
    }

    // inner class
    public with sharing class SubClassActivityHistory
    {
        public ActivityHistory activity;
        public String mailStatus ;
        public Boolean selected ;
        public String subject ;
        public String respondentName ;
        public String strBody ;
        public String userName ;
        public String userEmailId ;
        public String profileImageUrl;
        public SubClassActivityHistory()
        {
            this.activity = new ActivityHistory();
            this.mailStatus = '' ;
            this.selected = false ;
            this.subject = '' ;
            this.respondentName = '' ;
            this.strBody = '' ;
            this.userName = '' ;
            this.userEmailId = '' ;
            this.profileImageUrl = '' ;
        }
        public SubClassActivityHistory(ActivityHistory act, String status)
        {
            activity = act;
            mailStatus = status;
            if(!Test.isRunningTest())
            {
                subject = act.Subject;
                if(act.FGM_Portal__ResponseBy__c != null)
                    respondentName = act.FGM_Portal__ResponseBy__r.FirstName + ' ' + act.FGM_Portal__ResponseBy__r.LastName;
                else
                {
                    if(act.Description != null && String.isNotBlank(act.Description) && act.Description.contains('Respondent:') && act.Description.contains('Respondent Email:')){
                        respondentName = act.Description.substringBefore('Respondent Email:');
                        respondentName = (respondentName.substringAfter('Respondent:')).trim();
                    }
                    else
                        respondentName = act.Owner.Name;
                }
            }
        }
    }

    public without sharing class WithoutSharing
    {
        public List<Sobject> getSObjectResults(User usr)
        {
            try
            {

                List<Contact> lstContactActHist = [
                    SELECT
                        (
                            SELECT
                                ActivityDate,
                                Description,
                                LastModifiedDate,
                                Owner.Name,
                                OwnerId,
                                ResponseBy__c,
                                ResponseBy__r.Email,
                                ResponseBy__r.FirstName,
                                ResponseBy__r.LastName,
                                ResponseBy__r.SmallPhotoUrl,
                                Subject,
                                WhatId,
                                WhoId
                            FROM ActivityHistories
                            WHERE OwnerId = :usr.Id
                            AND WhatId != null
                            ORDER BY ActivityDate DESC, LastModifiedDate DESC
                            LIMIT 5000
                        )
                    FROM Contact
                    WHERE Id = :usr.ContactId
                    WITH SECURITY_ENFORCED
                    LIMIT 1
                ];

                return lstContactActHist;
            }
            catch(Exception ex)
            {
                throw new CustomException (ex.getMessage());

            }
        }
    }
    public class CustomException extends Exception {}
    public class CustomExceptionWrapper
    {
        public Integer lineNumber {get;set;}
        public String exceptionMessage {get;set;}
        public String stackTraceString {get;set;}
        public String userMessage {get;set;}
        public string messageType {get;set;}
        public string messageTitle {get;set;}

        public CustomExceptionWrapper(Integer lineNumber, String exceptionMessage, String stackTraceString, String userMessage,string messageType,string messageTitle)
        {
            this.lineNumber = lineNumber;
            this.exceptionMessage= exceptionMessage;
            this.stackTraceString = stackTraceString;
            this.userMessage = userMessage;
            this.messageType = messageType;
            this.messageTitle = messageTitle;
        }
    }
}