public with sharing class FCRecordController
{
    public Boolean initialized {get; set;} {initialized = false;}
    public  String applicationId {get;set;}
    public String mode {get;set;}
    public String defaultMode {get;set;}
    public String strApplicationMode {get;set;}
    public String strParentApplicationMode {get;set;}
    public String strParentApplicationStage {get;set;}
    public SObject portalConfigurationFields{get;set;}
    private Set<string>setRequestEditableStatus{get;set;}
    private List<PortalConfiguration__c>lstPortalConfigurationFields;
    public Quiz__c quiz { set; get; }
    public StateCountryConfig__c objStateCountryConfig { set; get; }
    public List<StateCountryConfig__c> lstStateCountryConfig {get; set;}
    public Quiz_Questions__c[] quizQuestionList { set; get; }
    public Set<String> setAttachmentQuestionList;
    public sobject application { set; get; }
    public String appStage {get; set;}
    public Boolean isApplicationSubmitted {get; set;}
    public Boolean isShowHidePrePostText {get; set;}
    //public Set<String> requiredQuestions;
    public List<Related_List_Controller__c> tabsList { get; set; }    // To get Tab records from RLC
    private Set<Id> portalTabIds;
    private Set<Id> granteeBudgetUpdateTabIds;
    private Set<Id> relatedListTabIds;
    public String selectedTab { set; get; }
    public Attachment attachment { set; get; }
    public Boolean isFeedAttachmentEnabled{get;set;}
    public Map<String,Map<String,String>> mapFormulaFieldsByObject;
    public Map<String,String> mapFormulaFields { get; set; }
    public Map<String,ApplicationAttachments> mapApplicationAttachments {get; set;}
    public Question_Attachment__c questionAttachment{ get; set;}
    public String pageTitle { get; set;} //Title attribute for page FCPROD-1179
    public String date_time { get; set; }
    public Boolean displayBenchmark;
    public String currentParentObject{get;set;}
    public sobject tabObject { get; set; }
    public sObject currentChildObject;
    public String currentTabType { get; set; }
    public Boolean isErrorInAttachment { get; set; }
    public relatedList relatedListConfiguration { get; set; }
    public Boolean isRelatedListView { get; set; }
    public object relatedListRecordObject;
    public String JSONapplicationFieldData { get; set; }
    public String JSONapplicationSubmissionData { get; set; }  // used to get submission data
    public String  tabRecordId;
    public String nextTabID { get; set; }            // To get the Id of record which is open in current tab.
    public Boolean isLastTab { get; set;}
    public String portalLanguage{ get; set;}
    public ReviewPage[] reviewPageList { set; get; }
    public string reviewApplicationCampaignId;
    public string reviewApplicationId { get; set; }
    private Boolean isReviewSubmitPage;
    private String reviewerApplicationId;
    public Boolean isApplicationViewTab { get; set; }
    public Boolean isViewRecordLink { get; set;}
    public boolean displayPopup {get; set;}    // Purpose: Dialouge Box to check already exist application record
    public string strFields{get;set;}
    public String strHiddenValue {get; set;}
    public Boolean isSaveAndNext ;
    public Boolean bHideGRBudgetUpdateTab {get; set;}
    public User[] userList;
    public string applicationRecordType {get; set;}
    public String StrIFrameUrl { get; set; }
    public List<FGM_Base__Benchmark__c> lstBenchmarkRecords {get; set;}
    public Map<String,List<String>> mapBenchmarkUpdateFields {get;set;}
    public Boolean bIsBUpdateTabSelected {get; set;}
    public Boolean bIsEditBenchmarkUpdate {get; set;}
    public Boolean bIsViewBenchmarkUpdate {get; set;}
    public FGM_Base__Benchmark_Update__c benchmarkUpdateToBeUpsert {get; set;}
    public SFDCEncoder ESAPI = new SFDCEncoder();
    public Map < String, sObject > MapObjNameObjDetails ;   //Purpose : Used for Dynamic iframe
    public String JSONApplication {get;set;}
    public String virusScanURL { set; get; }
    public Boolean virusEnabled { set; get; }
    public String urlParamFrom {get;set;}
    public List<BenchmarkUpdateRecords> lstBenchmarkUpdateRecords {get;set;}
    public String urlParamParentId {get;set;}
    public boolean isIExplorer {get; set;}
    public List<Questions__c> requiredQuestionErrors { get; set; } {requiredQuestionErrors = new List<Questions__c>();}
    public String attachedQuestionId {
        get;
        set {
            attachedQuestionId = value;
        }
    }
    @RemoteAction
    public static List<AttachmentUploadManager.AttachmentWrapper> getAttachments(String recordId, String lookupFieldApiName, String lookupFieldValue)
    {
        return AttachmentUploadManager.getAttachments( recordId, lookupFieldApiName, lookupFieldValue );
    }
    @RemoteAction
    public static Engine.UserInfoWrapper getUserInfo()
    {
        return new Engine.UserInfoWrapper();
    }
    @RemoteAction
    public static List<Database.DeleteResult> deleteAttachments(String strAPIName, List<String> lstJSONObject, String questionAttachmentId)
    {
        return AttachmentUploadManager.deleteAttachments(strAPIName, lstJSONObject, questionAttachmentId);
    }
    @RemoteAction
    public static AttachmentUploadManager.AttachmentComponentSettingsWrapper getAttachmentComponentSettings( Boolean isEditable, String baseUrl, String locale, String apiVersion )
    {
        return new AttachmentUploadManager.AttachmentComponentSettingsWrapper( isEditable, baseUrl, locale, apiVersion );
    }

    @RemoteAction
    public static List<sObject> getCustomSettingRecords( String customSettingName, String instanceKey )
    {
        return Engine.getCustomSettingRecords(customSettingName, instanceKey);
    }
    @RemoteAction
    public static Database.SaveResult insertAndUpdateContentDocumentLink( String recordId, String contentDocumentId, String cntntDcmntDscrptn, String shareType )
    {
        return AttachmentUploadManager.insertAndUpdateContentDocumentLink(recordId,contentDocumentId,cntntDcmntDscrptn,shareType);
    }
    @RemoteAction
    public static AttachmentUploadManager.ApplicationQuestionWrapper getApplicationRecord( String lookupFieldApiName, String lookupFieldValue )
    {
        return AttachmentUploadManager.getApplicationRecord(lookupFieldApiName, lookupFieldValue);
    }

    //To open Benchmark Update records in edit mode
    public FGM_Base__Benchmark_Update__c selectedRecord{get;set;}
    public BenchmarkUpdateRecords objBURecord {get;set;}


    public void showPopup()
    {
        displayPopup = true;
    }

    public void existOpenApplication()
    {
        displayPopup = false;
    }

    public void clearUnsavedChanges()
    {
        initializeApplication();
        initializeQuizQuestionList();
    }

    public String getApplicationObjectName()
    {
        if(tabObject != null)
            return  String.valueOf(tabObject.getsObjectType());

        return null;
    }

    public PageReference redirectUser()
    {
        displayPopup = false;
        PageReference ref = System.Page.CommunityDashboard;
        ref.getParameters().put('tab', 'request');
        ref.setRedirect(true);
        return ref;
    }

    public PageReference backToApplication()
    {
        PageReference ref = System.Page.CommunityDashboard;
        ref.getParameters().put('tab', 'request');
        ref.setRedirect(true);
        return ref;
    }

    // To Show Attachment Description
    public Boolean IsFileDescriptionEnabled
    {
        get{
            CommunitySetting__c communitySetting = CommunitySetting__c.getInstance('IsAttachmentDescriptionEnabled');
            if(communitySetting == null || communitySetting.IsEnabled__c == false)
                return false;
            else
                return true;
        }
    }
    //Dynamic Iframe
    // To submit the Application.
    public PageReference submit()
    {
        map<Id,Integer> mapAttachmentCount = new map<Id,Integer>();
        mapAttachmentCount = getAttachmentCount();
        if(application != null && application.Id != null)
        {
            //Logic to check required field must not be blank before review and submit the application.
            if(tabsList != null && !tabsList.isEmpty())
            {
                Map<id,Related_List_Controller__c> mapTabIdsToName = new Map<id,Related_List_Controller__c>(tabsList);
                if(quizQuestionList != null && !quizQuestionList.isEmpty())
                {
                    requiredQuestionErrors = new List<Questions__c>();
                    for(Quiz_Questions__c quizQuestion: quizQuestionList)
                    {
                        if(quizQuestion.Required__c && quizQuestion.Question__r.Type__c == 'Salesforce Data Type' )
                        {
                            if(String.isBlank(String.valueOf(application.get(quizQuestion.Field__c)))){                                   
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, System.Label.FC_Required_Field_Label + ' ' + mapTabIdsToName.get(quizQuestion.Tab__c).Name+' : '+quizQuestion.Question__r.RichQuestion__c ));
                            }
                                
                        }
                        else if(quizQuestion.Required__c &&  quizQuestion.Question__r.Type__c == 'Attachment' )
                        {
                            if(mapApplicationAttachments.get(quizQuestion.Question__c) != null && mapAttachmentCount.get(quizQuestion.Question__c) <= 0){                                
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, System.Label.FC_Required_Field_Label + ' ' + mapTabIdsToName.get(quizQuestion.Tab__c).Name+' : '+quizQuestion.Question__r.RichQuestion__c ));                                                                
                            }
                                
                        }//end of if
                    }//end of for loop
                }
            }
        }
        
        if(ApexPages.hasMessages())
            return null;
        else
        {
            if(String.isNotBlank(currentParentObject) && 'FGM_Base__Grantee_Report__c'.equalsIgnoreCase(currentParentObject))
            {
                application.put('FGM_Base__Status__c','Submitted');
                application.put('FGM_Base__Submission_Date__c' , Date.today());

                if(userList[0].ContactId != null)
                    application.put('FGM_Base__Submitted_By__c',userList[0].ContactId);
                isShowHidePrePostText = true;
            }
            else if(String.isNotBlank(currentParentObject) && 'FGM_Base__Benchmark__c'.equalsIgnoreCase(currentParentObject))
            {
                application.put('FGM_Base__Status__c','Proposed');
                isShowHidePrePostText = true;
            }
            else if(String.isNotBlank(currentParentObject) && ('Amendment__c'.equalsIgnoreCase(currentParentObject) || 'FGM_Portal__Amendment__c'.equalsIgnoreCase(currentParentObject)))
            {
                application.put('StageName__c','Submitted');
                application.put('Submission_Date__c',Date.today());
                application.put('Submitted_By__c',userList[0].ContactId);
                isShowHidePrePostText = true;
            }

            try
            {
                application = CrudFlsService.getInstance().stripInaccessibleForUpdate(application);
                Database.saveResult saveResult =  Database.update(application);
                if(saveResult != null && saveResult.isSuccess())
                {

                    isApplicationSubmitted = true;
                    return System.Page.CommunityDashboard;
                }
            }
            catch(Exception ex)
            {
                System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error,ex.getMessage()));
            }
        }

        return null;
    }

    public FCRecordController()
    {
        lstPortalConfigurationFields = new List<PortalConfiguration__c>();
        setRequestEditableStatus= new Set<string>();
        isReviewSubmitPage = false;
        questionAttachment = new Question_Attachment__c();
        urlParamFrom = ApexPages.currentPage().getParameters().get('from');
        urlParamParentId = ApexPages.currentPage().getParameters().get('ParentId');
        if(!Test.isRunningTest())
        {
            if(ApexPages.currentPage().getHeaders().get('USER-AGENT').indexOf('Trident')>=0)
            {
                if(ApexPages.currentPage().getHeaders().get('USER-AGENT').indexOf('rv:11')>=0 || ApexPages.currentPage().getHeaders().get('USER-AGENT').indexOf('MSIE 10.0')>=0)
                    isIExplorer = true;
            }
            else
                isIExplorer = false;
        }
    }

    // To get Query Parameter.
    public String getParam(String name)
    {
        String strParamValue = ESAPI.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get(name));

        if(strParamValue != null && String.isNotBlank(strParamValue))
            return String.escapeSingleQuotes(strParamValue);

        return strParamValue;
    }

    public PageReference redirectTo(PageReference pageReference)
    {
        if (pageReference != null)
            pageReference.setRedirect(true);

        return pageReference;
    }

    public PageReference rollbackWithError(String message, System.Savepoint savepoint)
    {
        if (savepoint != null)
            Database.rollback(savepoint);

        if (message != null)
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, message));

        return null;
    }

    // To initilize the Components.
    public PageReference initialize()
    {
        initialized = true;
        try
        {
            isSaveAndNext = false;
            FCGlobal.UserSession currentUserSession = FCGlobal.getUserSession(String.escapeSingleQuotes(UserInfo.getUserId()));
            portalLanguage = (currentUserSession != null) ? currentUserSession.UserLanguage : 'en_US';
            FCGlobal.setUserLanguage(String.escapeSingleQuotes(UserInfo.getUserId()),String.escapeSingleQuotes(portalLanguage));
            isFeedAttachmentEnabled = false;
            InitalizePortalFeedAttachment(String.escapeSingleQuotes(portalLanguage));

            // To get Multilanguage DateTime format
            Map<String, String> mappedValues = new Map<String, String>(); //map for holding locale to datetime format
            mappedValues = FCGlobal.getDateFormat();

            if (mappedValues.containsKey(String.escapeSingleQuotes(portalLanguage))) //if the map contains the correct datetime format
                date_time = mappedValues.get(String.escapeSingleQuotes(portalLanguage)); //grab the datetime format for the locale

            isApplicationSubmitted = false;
            isShowHidePrePostText = false;
            strApplicationMode = getParam('mode');
            strApplicationMode = (strApplicationMode != null && String.isNotBlank(strApplicationMode)) ? strApplicationMode : 'view';
            if(String.isNotBlank(strApplicationMode) && 'view'.equalsIgnoreCase(strApplicationMode))
            {
                isApplicationSubmitted = true;
                isShowHidePrePostText = false;
            }

            GlobalPortalSettings__c globalSetting = GlobalPortalSettings__c.getOrgDefaults();
            virusScanURL = globalSetting.Virus_Scan_URL__c;
            virusEnabled = globalSetting.Is_VirusScan_Enabled__c;

            isViewRecordLink = false;
            //requiredQuestions  = new Set<String>();
            setAttachmentQuestionList = new Set<String>();
            mapApplicationAttachments = new Map<String,ApplicationAttachments>();
            mapFormulaFieldsByObject = new Map<String,Map<String,String>>();
            initializeApplication();

            if(quiz == null || application == null)
                return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_FCRecord_Processing_ErrorMsg),null);


            initializeTabs();
            initializeQuizQuestionList('');
            initializeAttachment();
            InitializeCharCount();

        }
        catch( Exception ex )
        {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() ) );
        }
        return null;
    }

    public void InitializeCharCount()
    {
        try
        {
            String strObjectName = '';
            if(tabsList != null && String.isNotBlank(selectedTab))
            {
                for(Related_List_Controller__c tabRecord : tabsList)
                {
                    if(selectedTab == String.valueOf(tabRecord.Id))
                        strObjectName = tabRecord.ObjectName__c;
                }
            }
            strFields=JSON.serialize(FCGlobal.getFieldLengthMap(strObjectName));
        }
        catch( Exception ex )
        {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() ) );
        }
    }

    public void initializeReview()
    {
        initialized = true;
        // Force all pages to display
        isReviewSubmitPage = true;
        // Run the normal process
        initialize();
        // Convert to a review list
        initializeReviewPageList();
        return;
    }

    //FCPROD-1060: To Hide Grantee Budget Update Tab if No line Items are with associate Request
    public void hideGRBudgetUpdateTab(List<Related_List_Controller__c> tablist)
    {
        try
        {
            String strGRId = getParam('id');
            String strApplicationId = '';
            Boolean bIsGranteeBudgetUpdateTab = false;
            if(!String.isBlank(strGRId))
            {
                for(Related_List_Controller__c tab : tablist)
                {
                    if(tab.RecordType.Name == 'Grantee Budget Update Tab')
                    {
                        bIsGranteeBudgetUpdateTab = true;
                        break;
                    }
                }

                if('lead'.equalsIgnoreCase(application.getSObjectType().getDescribe().getName()) && application.get('FGM_Base__Request__c') != null)
                    strApplicationId = String.valueOf(application.get('FGM_Base__Request__c'));

                if(String.isNotBlank(strApplicationId))
                {
                    String strQuery = ''
                        +'SELECT (SELECT Name'
                        +',Id'
                        +' FROM Grantee_Budget_Line_Items__r)'
                        +' FROM Opportunity'
                        +' Where Id = :strApplicationId'
                        +' WITH SECURITY_ENFORCED';

                    List<Opportunity> lstOpportunityHasLineItems = (List<Opportunity>)Database.Query(strQuery);

                    for(Opportunity record: lstOpportunityHasLineItems)
                    {
                        List<Grantee_Budget_Line_Item__c> lineItems = record.Grantee_Budget_Line_Items__r;
                        if(lineItems.size() < 1 )
                        {
                            bHideGRBudgetUpdateTab = true;
                            break;
                        }
                    }
                }
            }
        }
        catch (DMLException DMLex)
        {
            system.debug( 'DMLException : ' + DMLex);
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + DMLex.getDmlMessage(0) ) );
        }
        catch( Exception ex )
        {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() ) );
        }
    }
    // To get Quiz Questions and Tab Records.
    public void initializeTabs()
    {
        try
        {
            String excludeObject = '';
            bHideGRBudgetUpdateTab = false;

            if(String.isNotBlank(reviewApplicationId))
            {
                String applicationObjectName = FCGlobal.getObjectNameById(reviewApplicationId);
                if(String.isNotBlank(applicationObjectName))
                {
                    if('opportunity'.equalsIgnoreCase(applicationObjectName))
                        excludeObject = String.escapeSingleQuotes('Lead');
                    else if('lead'.equalsIgnoreCase(applicationObjectName))
                        excludeObject = String.escapeSingleQuotes('Opportunity');
                }
            }

            String strRLCLang = String.escapeSingleQuotes(portalLanguage);

            Integer countLanguage = [
                SELECT COUNT()
                FROM Related_List_Controller__c
                WHERE Quiz__c = :quiz.Id
                AND IsCommunityRecord__c = TRUE
                AND Language__c = :portalLanguage
                WITH SECURITY_ENFORCED
            ];

            if(0 == countLanguage)
                strRLCLang = 'en_US';

            tabsList = [
                SELECT
                    Associated_FC_Portal_Type__c,
                    Associated_Tab_Type__c,
                    BaseUrl__c,
                    FieldHeaders__c,
                    FieldNames__c,
                    Field_Labels_Long__c,
                    Field_Names_Long__c,
                    Hide_Edit_Link__c,
                    RichInstructionalText__c,
                    LookupField__c,
                    Name,
                    ObjectName__c,
                    ParentObject__c,
                    RecordType.Name,
                    RecordTypeId,
                    ShowDeleteLink__c,
                    ShowNewButton__c,
                    SortFieldOrder__c,
                    SortField__c,
                    (
                        SELECT
                            Can_upload_after_submission__c,
                            Field__c,
                            Hide_Post_Text__c,
                            Hide_Pre_Text__c,
                            Question__c,
                            Question__r.AttachmentNameFormula__c,
                            Question__r.Help_Tip__c,
                            Question__r.RichPostText__c,
                            Question__r.RichPreText__c,
                            Question__r.RichQuestion__c,
                            Question__r.Quiz__c,
                            Question__r.Type__c,
                            Quiz__c,
                            Required__c,
                            Sort_Order__c,
                            Tab__c
                        FROM Quiz_Questions__r
                        ORDER BY Sort_Order__c ASC NULLS LAST
                        LIMIT 10000
                    )
                FROM Related_List_Controller__c
                WHERE Quiz__c = :quiz.Id
                AND IsCommunityRecord__c = TRUE
                AND Language__c = :strRLCLang
                AND ParentObject__c != :excludeObject
                WITH SECURITY_ENFORCED
                ORDER BY SortOrder__c ASC NULLS LAST
                LIMIT 10000
            ];

            if(tabsList != null && tabsList.size() > 0 && !String.isNotBlank(selectedTab))
            {
                Integer index = 0;
                for(Related_List_Controller__c tab : tabsList)
                {
                    if(String.isNotBlank(tab.ObjectName__c) && String.isNotBlank(tab.ParentObject__c) && String.isNotBlank(tab.LookupField__c))
                    {
                        if(!displayBenchmark && tab.ObjectName__c == 'FGM_Base__Benchmark_Update__c' && tab.ParentObject__c == 'FGM_Base__Grantee_Report__c' && tab.LookupField__c == 'FGM_Base__Grantee_Report__c')
                        {
                            tabsList.remove(index);
                            break;
                        }
                    }
                    index++;
                }

                selectedTab = String.valueOf(tabsList[0].Id);

                if(!tabsList[0].ParentObject__c.equalsIgnoreCase('sObject'))
                    currentParentObject = tabsList[0].ParentObject__c;
                else if(tabsList.size() > 1)
                    currentParentObject = tabsList[1].ParentObject__c;

                hideGRBudgetUpdateTab(tabsList);
            }
            // To show the application sObject recordtype name

            RecordType sobjectApplicationRecordType = [
                SELECT Name
                FROM RecordType
                WHERE Id = :((Id) application.get('RecordTypeId'))
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            applicationRecordType = sobjectApplicationRecordType.Name ;
            initializeStateCountryPicklist();

        }
        catch (DMLException DMLex)
        {
            system.debug( 'DMLException : ' + DMLex);
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + DMLex.getDmlMessage(0) ) );
        }
        catch( Exception ex )
        {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() ) );
        }
    }

    //State country Picklist for Contact
    public Contact contact {get; set;}
    public Account account {get; set;}
    public Boolean isSCPLEnabled {get; set;}
    public Boolean isSCPLCountryError {get; set;}
    public Map<String,String> mapStateCountryFieldVal ;

    public String countryByName(String country)
    {
        if(String.isNotBlank(country))
        {
            Map<String,String> mapCountryVal = new Map<String,String>();
            SObjectType accountType = Schema.getGlobalDescribe().get('User');
            Map<String,Schema.SObjectField> mfields = accountType.getDescribe().fields.getMap();
            List<Schema.PicklistEntry> values;

            for( Schema.SObjectField field : mfields.values() )
            {
                if( field.getDescribe().getName() == 'CountryCode' )
                    values = field.getDescribe().getPicklistValues();
            }

            // Add these values to the selectoption list.
            for (Schema.PicklistEntry con : values)
            {
                mapCountryVal.put(con.getLabel(),con.getValue());
            }
            if(mapCountryVal.containsKey(country))
                return mapCountryVal.get(country);

        }
        return '';
    }

    public String countryByCode(String country)
    {
        if(String.isNotBlank(country))
        {
            Map<String,String> mapCountryVal = new Map<String,String>();
            SObjectType accountType = Schema.getGlobalDescribe().get('User');
            Map<String,Schema.SObjectField> mfields = accountType.getDescribe().fields.getMap();
            List<Schema.PicklistEntry> values;

            for( Schema.SObjectField field : mfields.values() )
            {
                if( field.getDescribe().getName() == 'CountryCode' )
                    values = field.getDescribe().getPicklistValues();
            }

            // Add these values to the selectoption list.
            for (Schema.PicklistEntry con : values)
            {
                mapCountryVal.put(con.getValue(),con.getLabel());
            }

            if(mapCountryVal.containsKey(country))
                return mapCountryVal.get(country);
        }
        return '';
    }

    public String stateByName(String stateCode)
    {
        if(String.isNotBlank(stateCode))
        {
            Map<String,String> mapStateVal = new Map<String,String>();
            SObjectType accountType = Schema.getGlobalDescribe().get('User');
            Map<String,Schema.SObjectField> mfields = accountType.getDescribe().fields.getMap();
            List<Schema.PicklistEntry> values;

            for( Schema.SObjectField field : mfields.values() )
            {
                if( field.getDescribe().getName() == 'StateCode' )
                    values = field.getDescribe().getPicklistValues();
            }

            for (Schema.PicklistEntry con : values)
            {
                mapStateVal.put(con.getLabel(),con.getValue());
            }
            if(mapStateVal.containsKey(stateCode))
            {
                return mapStateVal.get(stateCode);
            }

        }
        return '';
    }

    public String stateByCode(String stateCode,String countryCode)
    {

        lstStateCountryConfig = [
            SELECT
                CountryCode__c,
                Name,
                PicklistValues__c
            FROM StateCountryConfig__c
            WHERE CountryCode__c = :countryCode
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

        if(lstStateCountryConfig!=null && !lstStateCountryConfig.isEmpty())
        {
            Map<String, Object> mapStateCode = (Map<String, Object>)JSON.deserializeUntyped(lstStateCountryConfig[0].PicklistValues__c);
            if(mapStateCode!=null)
                return (String)mapStateCode.get(stateCode);
        }
        return '';
    }

    public void initializeStateCountryPicklist()
    {
        isSCPLEnabled = false;
        isSCPLEnabled = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().keySet().contains('billingcountrycode');
        if(isSCPLEnabled && String.isNotBlank(applicationRecordType))
        {

            if(applicationRecordType == 'Contact')
            {
                contact = new Contact();
                if(!mapStateCountryFieldVal.isEmpty())
                {

                    if(mapStateCountryFieldVal.containsKey('Billing_Mailing_Country__c'))
                        contact.put('MailingCountryCode',countryByName(mapStateCountryFieldVal.get('Billing_Mailing_Country__c'))) ;

                    if(mapStateCountryFieldVal.containsKey('Billing_Mailing_State__c'))
                        contact.put('MailingStateCode',stateByName(mapStateCountryFieldVal.get('Billing_Mailing_State__c'))) ;

                    if(mapStateCountryFieldVal.containsKey('Shipping_Other_Country__c'))
                        contact.put('OtherCountryCode',countryByName(mapStateCountryFieldVal.get('Shipping_Other_Country__c')));

                    if(mapStateCountryFieldVal.containsKey('Shipping_Other_State__c'))
                        contact.put('OtherStateCode',stateByName(mapStateCountryFieldVal.get('Shipping_Other_State__c')));
                }
            }
            else if (applicationRecordType == 'Organization')
            {
                account = new Account();
                if(!mapStateCountryFieldVal.isEmpty())
                {
                    if(mapStateCountryFieldVal.containsKey('Billing_Mailing_Country__c'))
                        account.put('BillingCountryCode',countryByName(mapStateCountryFieldVal.get('Billing_Mailing_Country__c'))) ;

                    if(mapStateCountryFieldVal.containsKey('Billing_Mailing_State__c'))
                        account.put('BillingStateCode',stateByName(mapStateCountryFieldVal.get('Billing_Mailing_State__c'))) ;

                    if(mapStateCountryFieldVal.containsKey('Shipping_Other_Country__c'))
                        account.put('ShippingCountryCode',countryByName(mapStateCountryFieldVal.get('Shipping_Other_Country__c'))) ;

                    if(mapStateCountryFieldVal.containsKey('Shipping_Other_State__c'))
                        account.put('ShippingStateCode',stateByName(mapStateCountryFieldVal.get('Shipping_Other_State__c'))) ;

                }

            }
        }
    }
    public map<Id,Integer> getAttachmentCount()
    {
        String questionAttachmentRelationField = FCGlobal.getRelationalField(currentParentObject, Question_Attachment__c.sObjectType);
        String query = 'SELECT Id,FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c, (SELECT Name,Id FROM Attachments),FGM_Portal__Question__c, FGM_Portal__Description__c FROM FGM_Portal__Question_Attachment__c Where ' + questionAttachmentRelationField + ' =: applicationId WITH SECURITY_ENFORCED ORDER BY CreatedDate ASC LIMIT 10000' ;
        List<FGM_Portal__Question_Attachment__c> lstAttachmentRecords = Database.query(query);
        map<Id,Integer> mapAttachmentCount = new map<Id,Integer>();
        map<Id,Id> mapQuestionAttachToQuestion = new map<Id,Id>();
        set<Id> queAttachIds = new set<Id>();
        if(!lstAttachmentRecords.isEmpty())
        {
            for(FGM_Portal__Question_Attachment__c queAttach : lstAttachmentRecords)
            {
                queAttachIds.add(queAttach.Id);
                Integer attachCount = 0;
                mapQuestionAttachToQuestion.put(queAttach.Id,queAttach.FGM_Portal__Question__c);
                if(queAttach.FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c==null)
                {
                    if(mapAttachmentCount.get(queAttach.FGM_Portal__Question__c)!=null)
                        attachCount = mapAttachmentCount.get(queAttach.FGM_Portal__Question__c);
                    attachCount = queAttach.Attachments.size() + queAttach.Feeds.size();
                    mapAttachmentCount.put(queAttach.FGM_Portal__Question__c,attachCount);
                }
                else
                {
                    if(mapAttachmentCount.get(queAttach.FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c)!=null)
                        attachCount = mapAttachmentCount.get(queAttach.FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c);
                    attachCount = attachCount + queAttach.Attachments.size() + queAttach.Feeds.size();
                    mapAttachmentCount.put(queAttach.FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c,attachCount);
                    mapAttachmentCount.put(queAttach.FGM_Portal__Question__c,attachCount);
                }
            }
            if(!queAttachIds.isEmpty())
            {

                List<ContentDocumentLink> lstCDL = [
                    SELECT LinkedEntityId
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId IN :queAttachIds
                    WITH SECURITY_ENFORCED
                ];

                Integer count = 0;
                for(ContentDocumentLink cntDoc : lstCDL)
                {
                    count = mapAttachmentCount.get(mapQuestionAttachToQuestion.get(cntDoc.LinkedEntityId));
                    count = count + 1;
                    mapAttachmentCount.put(mapQuestionAttachToQuestion.get(cntDoc.LinkedEntityId),count);
                }
            }
        }
        return mapAttachmentCount;
    }


    public void initializeQuizQuestionList()
    {
        try
        {
            String strSelectedTabId = ESAPI.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('tabId'));
            initializeQuizQuestionList(strSelectedTabId);
        }
        catch( Exception ex )
        {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() ) );
        }
    }

    //initialize Quize Question Records
    public void initializeQuizQuestionList(String strSelectedTabId)
    {
        try
        {
            isApplicationViewTab = false;
            isSCPLCountryError = false;
            if(isReviewSubmitPage)
            {
                if(tabsList != null)
                {
                    quizQuestionList = new List<Quiz_Questions__c>();
                    portalTabIds = new Set<Id>();
                    relatedListTabIds = new Set<Id>();
                    granteebudgetUpdateTabIds = new Set<Id>();

                    for(Related_List_Controller__c tabRecord : tabsList)
                    {
                        Map<Id,Schema.RecordTypeInfo> recordTypeInfo = Schema.Sobjecttype.Related_List_Controller__c.getRecordTypeInfosById();
                        Schema.RecordTypeInfo requiredRecordtType = recordTypeInfo.get(tabRecord.RecordTypeId);
                        String strRLCRecordTypeName = '';

                        if(requiredRecordtType != null)
                            strRLCRecordTypeName = requiredRecordtType.getName();  // Get record Type Name

                        if(String.isNotBlank(strRLCRecordTypeName) && 'Related List With Tab'.equalsIgnoreCase(strRLCRecordTypeName))
                            relatedListTabIds.add(tabRecord.Id);

                        if(String.isNotBlank(strRLCRecordTypeName) && 'Grantee Budget Update Tab'.equalsIgnoreCase(strRLCRecordTypeName))
                        {
                            granteeBudgetUpdateTabIds.add(tabRecord.Id);

                            lstGranteeBudgetUpdate = [
                                SELECT
                                    Approved_Budget_New__c,
                                    Available_Budget__c,
                                    Comment__c,
                                    Current_Period_Expenses__c,
                                    Expenditures_to_Date__c,
                                    Grantee_Budget_Category__c,
                                    Grantee_Budget_Category__r.Parent_Category__c,
                                    Grantee_Budget_Line_Item__c,
                                    Grantee_Report__c,
                                    Percentage_Used__c
                                FROM Grantee_Budget_Update__c
                                WHERE Grantee_Report__c = :application.id
                                WITH SECURITY_ENFORCED
                                LIMIT 1000
                            ];

                        }
                        else if(String.isNotBlank(strRLCRecordTypeName) && 'Portal Tab'.equalsIgnoreCase(strRLCRecordTypeName))
                        {
                            portalTabIds.add(tabRecord.Id);
                            currentTabType = 'Portal Tab';
                            if(tabRecord.Quiz_Questions__r != null)
                                quizQuestionList.addAll(tabRecord.Quiz_Questions__r);
                        }
                        else if( String.isNotBlank(strRLCRecordTypeName) && 'IFrame Tab'.equalsIgnoreCase(strRLCRecordTypeName) )
                        {
                            currentTabType = 'IFrame Tab';
                            StrIFrameUrl = tabRecord.BaseUrl__c;
                        }
                    }
                }
                return;
            }
            else
            {
                currentTabType = '';
                isViewRecordLink = false;
                isErrorInAttachment = false;
                isRelatedListView = false;
                relatedListConfiguration = null;
                relatedListRecordObject = null;
                tabObject = null;
                tabRecordId = '';
                mapFormulaFields = new Map<String,String>();
                bIsBUpdateTabSelected = false;
                bIsEditBenchmarkUpdate = false;
                bIsViewBenchmarkUpdate = false;
                JSONapplicationFieldData = JSON.serialize(new List<Map<String, Object>>());

                if(String.isNotBlank(strSelectedTabId))
                    selectedTab = strSelectedTabId;

                nextTabID = getNextTab();
                if(tabsList != null && String.isNotBlank(selectedTab))
                {
                    quizQuestionList = new List<Quiz_Questions__c>();
                    for(Related_List_Controller__c tabRecord : tabsList)
                    {
                        if(selectedTab == String.valueOf(tabRecord.Id))
                        {
                            if(!String.isNotBlank(currentParentObject) && !tabRecord.ParentObject__c.equalsIgnoreCase('sObject'))
                                currentParentObject = String.escapeSingleQuotes(tabRecord.ParentObject__c);
                            else if(!String.isNotBlank(currentParentObject) && tabRecord.ParentObject__c.equalsIgnoreCase('sObject'))
                                currentParentObject = String.escapeSingleQuotes(tabRecord.ObjectName__c);

                            if(tabRecord.Quiz_Questions__r != null){
                                Set<String> setStates = new Set<String>();
                                for(Quiz_Questions__c field :tabRecord.Quiz_Questions__r)
                                {
                                    setStates.add(field.Field__c);
                                }
                                if(setStates.contains('Billing_Mailing_State__c') && !setStates.contains('Billing_Mailing_Country__c'))
                                {
                                    isSCPLCountryError = true;
                                    ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Warning, System.Label.FC_SCPL_Configuration_Error_Message) );
                                    return ;
                                }
                                if(setStates.contains('Shipping_Other_State__c') && !setStates.contains('Shipping_Other_Country__c'))
                                {
                                    isSCPLCountryError = true;
                                    ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Warning, System.Label.FC_SCPL_Configuration_Error_Message) );
                                    return;
                                }
                                quizQuestionList = tabRecord.Quiz_Questions__r;
                                isSCPLCountryError = false;
                            }
                            Map<Id,Schema.RecordTypeInfo> recordTypeInfo = Schema.Sobjecttype.Related_List_Controller__c.getRecordTypeInfosById();
                            Schema.RecordTypeInfo requiredRecordtType = recordTypeInfo.get(tabRecord.RecordTypeId);
                            String strRLCRecordTypeName = '';

                            if(requiredRecordtType != null)
                                strRLCRecordTypeName = requiredRecordtType.getName();  // Get record Type Name

                            if(String.isNotBlank(strRLCRecordTypeName) && 'Related List With Tab'.equalsIgnoreCase(strRLCRecordTypeName) && String.isNotBlank(tabRecord.LookupField__c) && (tabRecord.ParentObject__c != tabRecord.ObjectName__c))
                            {
                                defaultMode = 'view';
                                if(recordTypeInfo != null && !recordTypeInfo.isEmpty())
                                {
                                    if((String.isNotBlank(tabRecord.FieldHeaders__c)||String.isNotBlank(tabRecord.Field_Labels_Long__c)) &&(String.isNotBlank(tabRecord.Field_Names_Long__c) || String.isNotBlank(tabRecord.FieldNames__c)))
                                    {

                                        currentTabType = 'Related List With Tab';
                                        isRelatedListView = true;

                                        if(application != null && application.id != null){

                                            if(relatedListConfiguration == null)
                                            {
                                                relatedListConfiguration = new relatedList();
                                                relatedListConfiguration.record = tabRecord;
                                                relatedListConfiguration.strRelatedListObject = tabRecord.ObjectName__c;
                                                relatedListConfiguration.isCreatable = tabRecord.ShowNewButton__c;
                                                relatedListConfiguration.isEditable = !tabRecord.Hide_Edit_Link__c;
                                                relatedListConfiguration.isDeletable = tabRecord.ShowDeleteLink__c;
                                                relatedListConfiguration.listColumnFields =  getrelatedListColumnList(tabRecord);
                                                relatedListConfiguration.mapColumnFields =  getrelatedListColumn(tabRecord);
                                                relatedListConfiguration.relatedListLookUp =  tabRecord.LookupField__c;

                                                if(!relatedListConfiguration.mapColumnFields.isEmpty())
                                                {
                                                    //FCPROD-32: Update benchmarks on progress reports
                                                    if(tabRecord.ParentObject__c == 'FGM_Base__Grantee_Report__c' && tabRecord.ObjectName__c == 'FGM_Base__Benchmark_Update__c' && application.get('FGM_Base__Request__c') != null )
                                                    {
                                                        bIsBUpdateTabSelected = true;
                                                        relatedListConfiguration.lstRelatedListRecord = getBenchmarkUpdateRecords(tabRecord,new Set<String>(relatedListConfiguration.mapColumnFields.values()));
                                                    }//END-FCPROD-32
                                                    else
                                                        relatedListConfiguration.lstRelatedListRecord = getRelatedListRecords(tabRecord,new Set<String>(relatedListConfiguration.mapColumnFields.values()));
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        rollbackWithError(System.Label.FC_ConfigurationProcess_ErrorMsg,null);
                                        return;
                                    }
                                    mapFormulaFields = InitializeReadonlyFields();
                                }
                            }
                            else if(String.isNotBlank(strRLCRecordTypeName) && 'Portal Tab'.equalsIgnoreCase(strRLCRecordTypeName))
                            {
                                defaultMode = 'edit';
                                currentTabType = 'Portal Tab';
                                initilizeSubmissionList();
                                mapFormulaFields = InitializeReadonlyFields();
                            }
                            else if(String.isNotBlank(strRLCRecordTypeName) && 'Grantee Budget Update Tab'.equalsIgnoreCase(strRLCRecordTypeName))
                            {
                                currentTabType = 'Grantee Budget Update Tab';
                                defaultMode = 'view';
                                isEditGranteeBudgetUpdate=false;

                                lstGranteeBudgetUpdate = [
                                    SELECT
                                        Approved_Budget_New__c,
                                        Available_Budget__c,
                                        Comment__c,
                                        Current_Period_Expenses__c,
                                        Expenditures_to_Date__c,
                                        Grantee_Budget_Category__c,
                                        Grantee_Budget_Category__r.Parent_Category__c,
                                        Grantee_Budget_Line_Item__c,
                                        Grantee_Report__c,
                                        Percentage_Used__c
                                    FROM Grantee_Budget_Update__c
                                    WHERE Grantee_Report__c = :application.Id
                                    WITH SECURITY_ENFORCED
                                    LIMIT 1000
                                ];

                                if(relatedListConfiguration == null && application != null && application.id != null)
                                {
                                    relatedListConfiguration = new relatedList();
                                    relatedListConfiguration.record = tabRecord;
                                }
                            }
                            else if( String.isNotBlank(strRLCRecordTypeName) && 'IFrame Tab'.equalsIgnoreCase(strRLCRecordTypeName) )
                            {
                                currentTabType = 'IFrame Tab';
                                defaultMode = 'view';
                                PageReference pageRef;
                                String strParamKeyTemp;
                                try
                                {
                                    String strIFrameUrl = tabRecord.BaseUrl__c.remove('{');
                                    strIFrameUrl = strIFrameUrl.remove('}').tolowercase();
                                    pageRef = new PageReference(strIFrameUrl);
                                    Map< String, String > mapOldURLParams = new Map< String, String >();
                                    mapOldURLParams = pageRef.getParameters();
                                    if( mapOldURLParams.values().size() > 0 )
                                    {
                                        for( String strParamKey : mapOldURLParams.keySet() )
                                        {
                                            strParamKeyTemp = strParamKey;
                                            String strParamVal = mapOldURLParams.get(strParamKey);
                                            if( strParamVal.countMatches('.') == 1  )
                                            {
                                                String strObjName = strParamVal.substring( 0, strParamVal.indexOf('.') );
                                                String strFieldName = strParamVal.subString( strParamVal.indexOf('.') + 1, strParamVal.length() );
                                                sObject sObj = MapObjNameObjDetails.get(strObjName.tolowercase());
                                                if( sObj != null )
                                                {
                                                    try
                                                    {
                                                        if( sObj.get( strFieldName ) != null )
                                                            pageRef.getParameters().put( strParamKey, string.valueOf(sObj.get( strFieldName )) );
                                                        else
                                                            pageRef.getParameters().put( strParamKey, 'null' );
                                                    }
                                                    catch( SObjectException sObjEx )
                                                    {
                                                        system.debug( 'Exception: ' + sObjEx +'at Line: '+sObjEx.getLineNumber()+' stackTrace: '+sObjEx.getStackTraceString());
                                                        pageRef.getParameters().put( strParamKey, 'null' );
                                                    }
                                                }
                                            }

                                        }
                                    }

                                }
                                catch( Exception ex )
                                {
                                    system.debug( 'Exception: ' + ex +'at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
                                    ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex +'at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString()) );
                                }
                                StrIFrameUrl = pageRef.getUrl();
                            }

                            initializeAttachment();

                            break;
                        }
                    }
                }
            }
        }
        catch( Exception ex )
        {
            system.debug( 'Exception : ' + ex + '; @ line number : ' + ex.getLineNumber() );
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() + '; @ line number : ' + ex.getLineNumber()) );
        }
    }
    public PageReference goToDashboard()
    {
        PageReference ref;
        string dashboardTab = '';
        if(String.isNotBlank(currentParentObject) && ('Grantee_Report__c'.equalsIgnoreCase(currentParentObject) || 'FGM_Base__Grantee_Report__c'.equalsIgnoreCase(currentParentObject)))
        {
            dashboardTab = 'granteeReport';
        }
        else if(String.isNotBlank(currentParentObject) && ('Benchmark__c'.equalsIgnoreCase(currentParentObject) || 'FGM_Base__Benchmark__c'.equalsIgnoreCase(currentParentObject)))
        {
            dashboardTab = 'Benchmarks';
        }
        else if(String.isNotBlank(currentParentObject) && ('Amendment__c'.equalsIgnoreCase(currentParentObject) || 'FGM_Portal__Amendment__c'.equalsIgnoreCase(currentParentObject)))
        {
            dashboardTab = 'Amendment';
        }
        ref = new PageReference('/apex/CommunityDashboard');
        ref.getParameters().put('tab', dashboardTab);
        return ref;
    }

    public PageReference cancelApplication()
    {
        try
        {
            PageReference ref;
            string dashboardTab = '';

            if(String.isNotBlank(currentParentObject) && ('Grantee_Report__c'.equalsIgnoreCase(currentParentObject) || 'FGM_Base__Grantee_Report__c'.equalsIgnoreCase(currentParentObject)))
            {
                dashboardTab = 'granteeReport';
            }
            else if(String.isNotBlank(currentParentObject) && ('Benchmark__c'.equalsIgnoreCase(currentParentObject) || 'FGM_Base__Benchmark__c'.equalsIgnoreCase(currentParentObject)))
            {
                dashboardTab = 'Benchmarks';
            }
            else if(String.isNotBlank(currentParentObject) && ('Amendment__c'.equalsIgnoreCase(currentParentObject) || 'FGM_Portal__Amendment__c'.equalsIgnoreCase(currentParentObject)))
            {
                dashboardTab = 'Amendment';
            }
            if(String.isNotBlank(urlParamFrom) && urlParamFrom!=null)
            {
                if(urlParamFrom=='profile')
                {
                    ref = new PageReference('/FGM_Portal__CommunityProfile');
                    ref.getParameters().put('amendment',urlParamParentId);
                    return ref;
                }
            }
            urlParamFrom ='dashboard';
            ref = new PageReference('/apex/CommunityDashboard');
            ref.getParameters().put('tab', dashboardTab);
            return ref;
        }
        catch(Exception ex)
        {
            system.debug( 'Exception: ' + ex +'at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
            return null;
        }
    }

    public List<Grantee_Budget_Update__c> lstGranteeBudgetUpdate  {get;set;}
    public String selectedGranteeBudgetUpdateID  {get;set;}
    public Grantee_Budget_Update__c selectedGranteeBudgetUpdate  {get;set;}
    public boolean isEditGranteeBudgetUpdate {get;set;}

    public void editGranteeBudgetUpdate()
    {
        Schema.DisplayType FldType;
        String strGRDateField;
        FGM_Portal__GlobalPortalSettings__c globalSetting = FGM_Portal__GlobalPortalSettings__c.getOrgDefaults();
        Boolean isValidField = false;
        if(globalSetting != null )
        {
            if( String.isNotBlank(globalSetting.FGM_Portal__Grantee_Report_Order_by_Date__c))
            {
                strGRDateField = globalSetting.FGM_Portal__Grantee_Report_Order_by_Date__c;
                Map<String, Schema.SObjectField> mapSobjectFields = Schema.SObjectType.FGM_Base__Grantee_Report__c.fields.getMap();
                Schema.SObjectField field = mapSobjectFields.get(strGRDateField);
                if(field!=null)
                {
                    FldType = field.getDescribe().getType();
                    if((String.valueOf(FldType)=='Date' || String.valueOf(FldType)=='DateTime'))
                        isValidField = true;
                }
                else
                    isValidField = false;
            }
            else
            {
                isValidField = false;
            }
        }
        if(isValidField)
        {

            selectedGranteeBudgetUpdate = [
                SELECT
                    Approved_Budget_New__c,
                    Available_Budget__c,
                    Comment__c,
                    Current_Period_Expenses__c,
                    Expenditures_to_Date__c,
                    Grantee_Budget_Category__c,
                    Grantee_Budget_Line_Item__c,
                    Grantee_Report__c,
                    Percentage_Used__c
                FROM Grantee_Budget_Update__c
                WHERE Id = :selectedGranteeBudgetUpdateID
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            tabObject=selectedGranteeBudgetUpdate;
            isEditGranteeBudgetUpdate=true;
        }
        else
        {
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + System.Label.FC_Valid_Grantee_Report_Order_by_Date ) );
        }
    }

    public void saveGranteeBudgetUpdate()
    {
        try
        {
            defaultMode = 'view';
            CrudFlsService.getInstance().assertUpdateable(selectedGranteeBudgetUpdate);
            update selectedGranteeBudgetUpdate;

            lstGranteeBudgetUpdate = [
                SELECT
                    Approved_Budget_New__c,
                    Available_Budget__c,
                    Comment__c,
                    Current_Period_Expenses__c,
                    Expenditures_to_Date__c,
                    Grantee_Budget_Category__c,
                    Grantee_Budget_Category__r.Parent_Category__c,
                    Grantee_Budget_Line_Item__c,
                    Grantee_Report__c,
                    Percentage_Used__c
                FROM Grantee_Budget_Update__c
                WHERE Grantee_Report__c = :application.id
                WITH SECURITY_ENFORCED
                LIMIT 1000
            ];

            isEditGranteeBudgetUpdate=false;
        }
        catch(DMLException dmlex)
        {
            rollbackWithError(dmlex.getDmlMessage(0) ,null);
        }
        catch(Exception ex)
        {
            rollbackWithError(ex.getMessage() ,null);
        }
    }

    public void cancelGranteeBudgetUpdate()
    {
        defaultMode = 'view';
        isEditGranteeBudgetUpdate=false;
    }

    public String getJSONApp()
    {
        if( application != null )
            return JSON.serialize(application);
        return null;
    }

    // To initialize the Submission List of Application.
    private void initilizeSubmissionList()
    {
        tabObject = application;
        if(application != null && application.Id != null)
            tabRecordId = String.escapeSingleQuotes(application.Id);
    }

    public LIST<String> getrelatedListColumnList(Related_List_Controller__c relatedListController)
    {
        LIST<String> lstColumnFields=new  LIST<String>();
        if(relatedListController != null)
        {
            if(relatedListController.ObjectName__c == 'FGM_Base__Benchmark_Update__c' && application.get('FGM_Base__Request__c') != null)
            {
                if(relatedListController.Field_Labels_Long__c!=null && String.isNotBlank(relatedListController.Field_Labels_Long__c))
                    lstColumnFields = new LIST<String>(relatedListController.Field_Labels_Long__c.split(','));
            }
            else
            {
                if(relatedListController.FieldHeaders__c!=null && String.isNotBlank(relatedListController.FieldHeaders__c))
                    lstColumnFields = new LIST<String>(relatedListController.FieldHeaders__c.split(','));
            }
            return lstColumnFields;
        }
        return lstColumnFields;
    }

    // To get Related List Column for related List.
    @TestVisible private Map<String,String> getrelatedListColumn(Related_List_Controller__c relatedListController)
    {
        Map<String,String> mapColumns = new Map<String,String>();

        String[] lstColumnLabels ;
        String[] lstColumnFields ;
        if(relatedListController != null)
        {
            if(relatedListController.FieldHeaders__c==null && relatedListController.FieldNames__c==null)
            {
                lstColumnLabels= relatedListController.Field_Labels_Long__c.split(',');
                lstColumnFields= relatedListController.Field_Names_Long__c.split(',');
            }
            else
            {
                lstColumnLabels = relatedListController.FieldHeaders__c.split(',');
                lstColumnFields = relatedListController.FieldNames__c.split(',');
            }
            if(lstColumnLabels != null && lstColumnFields != null)
            {
                integer index = 0;
                for(String columnLabel : lstColumnLabels)
                {
                    if(lstColumnFields[index] != null && String.isNotBlank(lstColumnFields[index]))
                    {
                        String strFieldName =   lstColumnFields[index];
                        mapColumns.put(columnLabel, strFieldName);
                        index++;
                    }
                }
            }
            return mapColumns;
        }
        return mapColumns;
    }

    // To get Related List Records for related List.
    private List<Object> getRelatedListRecords(Related_List_Controller__c relatedListController, Set<String> setFields)
    {
        try
        {
            List<Object> lstSobject = new List<Object>();
            if(quizQuestionList != null && !quizQuestionList.isEmpty() && !isReviewSubmitPage)
            {
                for(Quiz_Questions__c quizQuestion : quizQuestionList)
                {
                    if(String.isNotBlank(quizQuestion.Field__c) && !setFields.contains(quizQuestion.Field__c))
                        setFields.add(quizQuestion.Field__c.toLowerCase());
                }
            }
            String order;
            String sortOredrField  = relatedListController.FGM_Portal__SortField__c;
            if(relatedListController.FGM_Portal__SortFieldOrder__c != null)
                order = relatedListController.FGM_Portal__SortFieldOrder__c == 'Ascending' ? 'ASC' : 'DESC';
            if(String.isNotBlank(relatedListController.ParentObject__c) && String.isNotBlank(relatedListController.ObjectName__c) && String.isNotBlank(relatedListController.LookupField__c))
            {
                if(setFields != null && !setFields.isEmpty() && application != null && application.Id != null)
                {
                    Object[] childObject ;
                    String applicationId = application.Id;
                    List<String> sanitizedFields = new List<String>();

                    for (String f : setFields) {
                        sanitizedFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                    }

                    String sanitizedObjectName = relatedListController.ObjectName__c.replaceAll('[^0-9a-zA-Z_.]', '');
                    String sanitizedLookupField = relatedListController.LookupField__c.replaceAll('[^0-9a-zA-Z_.]', '');

                    String query = 'SELECT Id, '+ String.join(new List<String>(sanitizedFields), ', ')
                        + '  FROM  '+ sanitizedObjectName
                        + ' WHERE  '+ sanitizedLookupField +' = :applicationId ';


                    if(sortOredrField != null && !String.isBlank(sortOredrField)){
                        String sanitizedOredrField = sortOredrField.replaceAll('[^0-9a-zA-Z_.]', '');
                        query = query + ' ORDER BY '+sanitizedOredrField;
                        if(order != null )
                            query = query +' '+ order;
                    }
                    query =   query + ' LIMIT 1000';
                    List<sObject> childSObjects = Database.query(query);

				    childObject = CrudFlsService.getInstance().stripInaccessibleForRead(childSObjects);

                    if(childObject != null && childObject.size() > 0)
                        lstSobject.addAll(childObject);
                }
            }
            return lstSobject;
        }
        catch (DMLException DMLex)
        {
            system.debug( 'DMLException : ' + DMLex);
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + DMLex.getDmlMessage(0) ) );
        }
        catch( Exception ex )
        {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() ) );
        }
        return null;
    }

    private List<Object> getBenchmarkUpdateRecords(Related_List_Controller__c relatedListController, Set<String> setFields)
    {
        try
        {
            String order;
            String strQueryBenchmark;
            List<String> lstBenchmarkUpdateTypeFields = new List<String>();
            List<FGM_Base__Benchmark_Update__c> lstBecharkUpdate = new List<FGM_Base__Benchmark_Update__c>();
            set<String> setBenchmarkFields = new set<String>(); //For Benchmark Fields
            set<String> setBUFields = new set<String>(); //For benchmarkUpdate Fields

            for(String strFields : setFields)
            {
                if(strFields.startsWith('FGM_Base__Benchmark__r.'))
                {
                    setBenchmarkFields.add(strFields.removeStart('FGM_Base__Benchmark__r.'));
                    setFields.remove(strFields);
                }
            }
            if(!setBenchmarkFields.contains('FGM_Base__Request__c'))
            {
                setBenchmarkFields.add('FGM_Base__Request__c');
            }
            lstBenchmarkUpdateRecords = new  List<BenchmarkUpdateRecords>();
            lstBenchmarkRecords = new List<FGM_Base__Benchmark__c>();
            mapBenchmarkUpdateFields = new Map<String,List<String>>();

            setBUFields.add('FGM_Base__Amount_Update__c');
            setBUFields.add('FGM_Base__Benchmark__c');
            setBUFields.add('FGM_Base__Completed__c');
            setBUFields.add('FGM_Base__Date_Updated__c');
            setBUFields.add('FGM_Base__Grantee_Report__c');
            setBUFields.add('FGM_Base__Long_Narrative__c');
            setBUFields.add('FGM_Base__Number_Completed__c');
            setBUFields.add('FGM_Base__Number_Update__c');
            setBUFields.add('FGM_Base__Percentage_Completed__c');
            setBUFields.add('FGM_Base__Percentage_Update__c');

            if(setFields!=null)
            {
                setBUFields.addAll(setFields);
            }
            String strOppId = String.valueOf(application.get('FGM_Base__Request__c'));

            if(String.isNotBlank(strOppId))
            {
                String sortOredrField  = relatedListController.FGM_Portal__SortField__c;

                if(relatedListController.FGM_Portal__SortFieldOrder__c !=null)
                    order = relatedListController.FGM_Portal__SortFieldOrder__c == 'Ascending' ? 'ASC' : 'DESC';
                strQueryBenchmark = 'SELECT Id, ';
                if(setBenchmarkFields!=null && !setBenchmarkFields.isEmpty())
                {
                    List<String> sanitizedBenchmarkFields = new List<String>();

                    for (String f : setBenchmarkFields) {
                        sanitizedBenchmarkFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                    }

                    strQueryBenchmark += String.join(sanitizedBenchmarkFields, ', ') + ' , ';

                }

                List<String> sanitizedBUFields = new List<String>();

                for (String f : setBUFields) {
                    sanitizedBUFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                }

                String sanitizedParentObject = relatedListController.ParentObject__c.replaceAll('[^0-9a-zA-Z_.]', '');
                String applicationId = application.id;

                strQueryBenchmark += '(SELECT Id ,' + String.join(new List<String>(sanitizedBUFields), ', ')
                    + ' FROM FGM_Base__Benchmark_Updates__r WHERE '+ sanitizedParentObject +' = :applicationId ';
                if(sortOredrField !=null && !String.isBlank(sortOredrField)){
                    String sanitizedOredrField = sortOredrField.replaceAll('[^0-9a-zA-Z_.]', '');
                    strQueryBenchmark = strQueryBenchmark + ' ORDER BY '+sanitizedOredrField+' ';
                    if(order !=null )
                        strQueryBenchmark = strQueryBenchmark +' '+ order ;
                }
                strQueryBenchmark = strQueryBenchmark +')';
                strQueryBenchmark += ' FROM FGM_Base__Benchmark__c WHERE FGM_Base__Request__c = :strOppId'
                    + ' AND FGM_Base__Status__c = \'Accepted\' AND FGM_Base__Request_Update_on_Report__c = true ';

                if(relatedListController.FGM_Portal__ParentObject__c == 'FGM_Base__Benchmark__c')
                {
                    strQueryBenchmark += 'AND Id = :applicationId';
                }
                lstBenchmarkRecords = DataBase.query(strQueryBenchmark);

				lstBenchmarkRecords = CrudFlsService.getInstance().stripInaccessibleForRead(lstBenchmarkRecords);

                if(lstBenchmarkRecords != null && lstBenchmarkRecords.size() > 0)
                {
                    BenchmarkUpdateRecords objBenchmarkUpdateRecords;
                    for(FGM_Base__Benchmark__c record: lstBenchmarkRecords)
                    {
                        lstBenchmarkUpdateTypeFields = new List<String>();
                        objBenchmarkUpdateRecords = new BenchmarkUpdateRecords();
                        objBenchmarkUpdateRecords.objBenchmark = record;

                        if(record.FGM_Base__Benchmark_Updates__r != null && record.FGM_Base__Benchmark_Updates__r.size() > 0)
                        {
                            for(FGM_Base__Benchmark_Update__c benchmarkUpdateRecord: record.FGM_Base__Benchmark_Updates__r)
                            {
                                if(application.id != null && (benchmarkUpdateRecord.FGM_Base__Benchmark__c != null || benchmarkUpdateRecord.FGM_Base__Grantee_Report__c != null))
                                {
                                    objBenchmarkUpdateRecords = new BenchmarkUpdateRecords(String.valueOf(benchmarkUpdateRecord.get(sortOredrField)),order);
                                    benchmarkUpdateRecord.FGM_Base__Benchmark__c = record.Id;
                                    lstBecharkUpdate.add(benchmarkUpdateRecord);
                                    objBenchmarkUpdateRecords.objBenchmark = record;
                                    objBenchmarkUpdateRecords.objBU = benchmarkUpdateRecord;
                                    lstBenchmarkUpdateRecords.add(objBenchmarkUpdateRecords);
                                }
                            }

                        }
                        else
                        {
                            FGM_Base__Benchmark_Update__c benchmarkUpdate = new FGM_Base__Benchmark_Update__c();
                            objBenchmarkUpdateRecords = new BenchmarkUpdateRecords(String.valueOf(benchmarkUpdate.get(sortOredrField)),order);
                            benchmarkUpdate.FGM_Base__Benchmark__c = record.Id;
                            benchmarkUpdate.FGM_Base__Amount_Update__c = null;
                            benchmarkUpdate.FGM_Base__Grantee_Report__c = application.id;
                            benchmarkUpdate.FGM_Base__Number_Update__c = null;
                            benchmarkUpdate.FGM_Base__Long_Narrative__c = '';
                            benchmarkUpdate.FGM_Base__Percentage_Update__c = null;
                            objBenchmarkUpdateRecords.objBenchmark = record;
                            objBenchmarkUpdateRecords.objBU = benchmarkUpdate;
                            lstBecharkUpdate.add(benchmarkUpdate);
                            lstBenchmarkUpdateRecords.add(objBenchmarkUpdateRecords);
                        }
                    }
                    if( order != 'ASC'){
                        List<BenchmarkUpdateRecords> lstRevBenchmarkUpdateRecords = new  List<BenchmarkUpdateRecords>();
                        for(Integer i = lstBenchmarkUpdateRecords.size() - 1; i >= 0; i--){
                            lstRevBenchmarkUpdateRecords.add(lstBenchmarkUpdateRecords[i]);
                        }
                        lstBenchmarkUpdateRecords.clear();
                        lstBenchmarkUpdateRecords = lstRevBenchmarkUpdateRecords;
                    }

                }
                return lstBenchmarkUpdateRecords;
            }
        }
        catch(Exception ex)
        {
            system.debug( 'Exception : ' + ex + '; @ line number : ' + ex.getLineNumber() );
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() ) );
        }
        return null;
    }
    // To get Related List new Record for related List.
    public void getNewRelatedListRecord()
    {
        try
        {
            defaultMode = 'edit';
            relatedListRecordObject = null;
            mapFormulaFields = new Map<String,String>();

            if(relatedListConfiguration != null && String.isNotBlank(relatedListConfiguration.strRelatedListObject))
            {
                list<Quiz_Questions__c> lstquizquestion = new list<Quiz_Questions__c>();
                for(Quiz_Questions__c quizquestion : quizQuestionList)
                {
                    if(quizquestion.Question__r.Type__c != 'Attachment')
                        lstquizquestion.add(quizquestion);
                }
                if(lstquizquestion!=null && !lstquizquestion.IsEmpty())
                {
                    quizQuestionList = new list<Quiz_Questions__c>();
                    quizQuestionList.addAll(lstquizquestion);
                }
                else
                {
                    quizQuestionList = new list<Quiz_Questions__c>();
                }
                object newRelatedListRecord = FCGlobal.getNewSobject(relatedListConfiguration.strRelatedListObject);
                if(newRelatedListRecord != null)
                {
                    isRelatedListView = false;
                    tabRecordId = '';
                    tabObject = (sobject) newRelatedListRecord;
                    Schema.SObjectType sObjectType = tabObject.getSObjectType();
                    List<Schema.RecordTypeInfo> infos = sObjectType.getDescribe().getRecordTypeInfos();
                    String strRecordTypeId = null;
                    String strRecordTypeName =  null;

                    for (Schema.RecordTypeInfo info : infos)
                    {
                        if(info.isDefaultRecordTypeMapping() && info.isAvailable() && !info.isMaster() )
                        {
                            strRecordTypeId = info.RecordTypeId;
                            strRecordTypeName = info.getName();
                            break;
                        }
                    }

                    SObject objSObject ;
                    if(String.isNotBlank( strRecordTypeId) && String.isNotBlank(strRecordTypeName) && strRecordTypeName.toLowerCase() != 'master' )
                        objSObject= sObjectType.newSObject(strRecordTypeId, true);
                    else
                        objSObject= sObjectType.newSObject(null,true);

                    Schema.DescribeSObjectResult resSchema = sObjectType.getDescribe();
                    Map <String, Schema.SObjectField> sObjectFields = resSchema.fields.getMap();

                    if(sObjectFields != null && !sObjectFields.isEmpty())
                    {
                        for(Schema.SObjectField sfield : sObjectFields.Values())
                        {
                            schema.describefieldresult dfield = sfield.getDescribe();
                            if(dfield.isUpdateable())
                                tabObject.put(dfield.getName(), objSObject.get(dfield.getName()));
                        }
                    }
                    mapFormulaFields = InitializeReadonlyFields();
                }
            }
        }
        catch( Exception ex )
        {
            system.debug( 'Exception : ' + ex + '; @ line number : ' + ex.getLineNumber() );
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() ) );
        }
    }
    // Back to related List View.
    public void backTOrelatedlistView()
    {
        defaultMode = 'view';
        relatedListRecordObject = null;
        isRelatedListView = true;
        JSONapplicationFieldData = JSON.serialize(new List<Map<String, Object>>());
    }

    // To delete Related List Records.
    public void deleteRelatedListRecord()
    {
        String strRecordIndex = getParam('recordIndex');
        if(relatedListConfiguration != null && String.isNotBlank(relatedListConfiguration.strRelatedListObject) && String.isNotBlank(strRecordIndex))
        {
            integer recordIndex = integer.valueOf(strRecordIndex);
            if(recordIndex != null && string.isNotBlank(relatedListConfiguration.strRelatedListObject) && recordIndex < relatedListConfiguration.lstRelatedListRecord.size())
            {
                object OldrelatedlistRecord = relatedListConfiguration.lstRelatedListRecord[recordIndex];
                if(OldrelatedlistRecord != null)
                {
                    sobject record = (sobject)OldrelatedlistRecord;
                    if(record != null)
                    {
                        String sObjectName = record.Id.getSObjectType().getDescribe().getName();
                        CrudFlsService.getInstance().assertDeletable(record);
                        delete record;
                        relatedListConfiguration.lstRelatedListRecord.remove(recordIndex);
                    }
                }
            }
        }
    }

    // To open Related List Records in edit mode.
    public void editRelatedListRecord()
    {
        isViewRecordLink = false;
        String strRecordIndex = getParam('recordIndex');
        mapFormulaFields = new Map<String,String>();
        if(relatedListConfiguration != null && String.isNotBlank(relatedListConfiguration.strRelatedListObject) && String.isNotBlank(strRecordIndex))
        {
            list<Quiz_Questions__c> lstquizquestion = new list<Quiz_Questions__c>();
            for(Quiz_Questions__c quizquestion : quizQuestionList)
            {
                if(quizquestion.Question__r.Type__c != 'Attachment')
                    lstquizquestion.add(quizquestion);
            }
            if(lstquizquestion!=null && !lstquizquestion.IsEmpty())
            {
                quizQuestionList = new list<Quiz_Questions__c>();
                quizQuestionList.addAll(lstquizquestion);
            }
            else
            {
                quizQuestionList = new list<Quiz_Questions__c>();
            }
            integer recordIndex = integer.valueOf(strRecordIndex);
            if(recordIndex != null && recordIndex < relatedListConfiguration.lstRelatedListRecord.size())
            {
                object OldrelatedlistRecord = relatedListConfiguration.lstRelatedListRecord[recordIndex];
                if(OldrelatedlistRecord != null)
                {
                    sobject record = (sobject)OldrelatedlistRecord;
                    if(record == null)
                        return;

                    tabObject = record;
                    mapFormulaFields = InitializeReadonlyFields();
                    isRelatedListView = false;
                }
            }
        }
    }


    public void deleteBenchmarkUpdateRecord()
    {
        String strRecordIndex = getParam('recordIndex');
        if(relatedListConfiguration != null && String.isNotBlank(relatedListConfiguration.strRelatedListObject) && String.isNotBlank(strRecordIndex))
        {
            integer recordIndex = integer.valueOf(strRecordIndex);
            if(recordIndex != null && string.isNotBlank(relatedListConfiguration.strRelatedListObject) && recordIndex < relatedListConfiguration.lstRelatedListRecord.size())
            {
                objBURecord = (BenchmarkUpdateRecords)relatedListConfiguration.lstRelatedListRecord[recordIndex];
                selectedRecord = objBURecord.objBU;
                if(selectedRecord != null && selectedRecord.Id != null )
                {
                    String sObjectName = selectedRecord.Id.getSObjectType().getDescribe().getName();
                    CrudFlsService.getInstance().assertDeletable(selectedRecord);
                    delete selectedRecord;
                    relatedListConfiguration.lstRelatedListRecord.remove(recordIndex);
                    initializeQuizQuestionList();
                }
            }
        }
    }
    public void viewBenchmarkUpdateRecord()
    {
        bIsEditBenchmarkUpdate = false;
        bIsViewBenchmarkUpdate = true;
        isViewRecordLink = false;
        isRelatedListView = false;
        String strRecordIndex = getParam('recordIndex');
        integer recordIndex = integer.valueOf(strRecordIndex);
        benchmarkUpdateToBeUpsert = new FGM_Base__Benchmark_Update__c();
        objBURecord = (BenchmarkUpdateRecords)relatedListConfiguration.lstRelatedListRecord[recordIndex];
        selectedRecord = objBURecord.objBU;

        if(selectedRecord.FGM_Base__Benchmark__c != null)
        {
            if(selectedRecord.Id != null)
                benchmarkUpdateToBeUpsert.Id = selectedRecord.Id;
            else
                benchmarkUpdateToBeUpsert.Id= null;

            getBenchMarkFields();
        }
    }

    public void editBenchmarkUpdateRecord()
    {
        bIsEditBenchmarkUpdate = true;
        bIsViewBenchmarkUpdate = false;
        isViewRecordLink = false;
        isRelatedListView = false;
        String strRecordIndex = getParam('recordIndex');
        integer recordIndex = integer.valueOf(strRecordIndex);
        benchmarkUpdateToBeUpsert = new FGM_Base__Benchmark_Update__c();
        BenchmarkUpdateRecords
            objBURecord = (BenchmarkUpdateRecords)relatedListConfiguration.lstRelatedListRecord[recordIndex];
        selectedRecord = objBURecord.objBU;
        if(selectedRecord.FGM_Base__Benchmark__c != null)
        {
            if(selectedRecord.Id != null)
                benchmarkUpdateToBeUpsert.Id = selectedRecord.Id;
            else
                benchmarkUpdateToBeUpsert.Id= null;

            getBenchMarkFields();
        }
    }

    public void saveBenchMarkUpdate()
    {
        selectedRecord = (FGM_Base__Benchmark_Update__c)CrudFlsService.getInstance().stripInaccessibleForUpdate(selectedRecord);
        upsert selectedRecord;
        defaultMode = 'view';
        bIsEditBenchmarkUpdate = false;
        bIsViewBenchmarkUpdate = false;
        isViewRecordLink = false;
        bIsBUpdateTabSelected = true;
        isRelatedListView = true;
    }

    public List<string> lstBenchmarkUpdateTypeFields {get;set;}

    public void getBenchMarkFields ()
    {
        lstBenchmarkUpdateTypeFields = new List<string>();

        FGM_Base__Benchmark__c currentBenchMarkRecord = [
            SELECT FGM_Base__Benchmark_Type__c
            FROM FGM_Base__Benchmark__c
            WHERE Id = :selectedRecord.FGM_Base__Benchmark__c
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

        String strBenchmarkType = currentBenchMarkRecord.FGM_Base__Benchmark_Type__c ;

        if(String.isNotBlank(strBenchmarkType))
        {
            for(String type: strBenchmarkType.split(';'))
            {
                if(type.equalsIgnoreCase('Amount'))
                    lstBenchmarkUpdateTypeFields.add('FGM_Base__Amount_Update__c');
                else if(type.equalsIgnoreCase('Number'))
                    lstBenchmarkUpdateTypeFields.add('FGM_Base__Number_Update__c');
                else if(type.equalsIgnoreCase('Percentage'))
                    lstBenchmarkUpdateTypeFields.add('FGM_Base__Percentage_Update__c');
                else if(type.equalsIgnoreCase('Text'))
                    lstBenchmarkUpdateTypeFields.add('FGM_Base__Long_Narrative__c');
            }
        }
    }

    // To Open Related List Records in View mode
    public void viewRelatedListRecord()
    {
        isViewRecordLink = true;
        String strRecordIndex = getParam('recordIndex');
        mapFormulaFields = new Map<String,String>();

        if(relatedListConfiguration != null && String.isNotBlank(relatedListConfiguration.strRelatedListObject) && String.isNotBlank(strRecordIndex))
        {
            list<Quiz_Questions__c> lstquizquestion = new list<Quiz_Questions__c>();
            for(Quiz_Questions__c quizquestion : quizQuestionList)
            {
                if(quizquestion.Question__r.Type__c != 'Attachment')
                    lstquizquestion.add(quizquestion);
            }
            if(lstquizquestion!=null && !lstquizquestion.IsEmpty())
            {
                quizQuestionList = new list<Quiz_Questions__c>();
                quizQuestionList.addAll(lstquizquestion);
            }
            else
            {
                quizQuestionList = new list<Quiz_Questions__c>();
            }
            integer recordIndex = integer.valueOf(strRecordIndex);
            if(recordIndex != null && string.isNotBlank(relatedListConfiguration.strRelatedListObject) && recordIndex < relatedListConfiguration.lstRelatedListRecord.size())
            {
                object OldrelatedlistRecord = relatedListConfiguration.lstRelatedListRecord[recordIndex];
                if(OldrelatedlistRecord != null)
                {
                    sobject record = (sobject)OldrelatedlistRecord;
                    if(record == null)
                        return;

                    tabObject = record;
                    mapFormulaFields = InitializeReadonlyFields();
                    isRelatedListView = false;
                }
            }
        }
    }

    public Map<String,String> InitializeReadonlyFields()
    {
        Map<String,String> mapReadOnlyFields = new Map<String,String>();
        if(tabObject != null)
        {
            String strObjectName = tabObject.getsObjectType().getDescribe().name;
            if(String.isNotBlank(strObjectName))
            {
                if(!mapFormulaFieldsByObject.containsKey(strObjectName))
                {
                    Map<String,String> mapReadOnlyField = new Map<String,String>();
                    Map<String,Schema.SObjectField> objectFields =  FCGLobal.getMapsObjectFields(strObjectName);

                    if(objectFields != null)
                    {
                        for(Schema.SObjectField field : objectFields.values())
                        {
                            Schema.DescribeFieldResult fieldResult = field.getDescribe();
                            if(fieldResult.isCalculated())
                                mapReadOnlyField.put(fieldResult.getName(),'FORMULA');
                            else
                                mapReadOnlyField.put(fieldResult.getName(),String.valueOf(fieldResult.getType()));
                        }
                        mapFormulaFieldsByObject.put(strObjectName,mapReadOnlyField);
                        return mapReadOnlyField;
                    }
                }
                else
                    return mapFormulaFieldsByObject.get(strObjectName);
            }
        }
        return mapReadOnlyFields;
    }

    // initialize Application Record.
    public void initializeApplication()
    {
        try
        {
            reviewApplicationId = '';
            reviewApplicationCampaignId = '';
            Set<String> fieldSet = new Set<String> {};
                String appID = getParam('id');
            String RecordTypeId = getParam('RecordTypeId');
            String applicationCondition =  '';
            String applicationRecordTypeId = '';
            displayBenchmark = false;
            sObject[] applicationList = null;
            mode = (strApplicationMode != null && String.isNotBlank(strApplicationMode)) ? strApplicationMode : 'view';
            strApplicationMode = mode;
            if(String.isNotBlank(appID))
            {
                applicationCondition = 'Id= : appID';
                reviewerApplicationId = appID ;
            }
            else if(String.isNotBlank(RecordTypeId))
                applicationRecordTypeId = RecordTypeId;

            userList = [
                SELECT
                    CompanyName,
                    Contact.AccountId,
                    ContactId,
                    Email,
                    LastName
                FROM User
                WHERE Id = :UserInfo.getUserId()
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            if(String.isNotBlank(applicationCondition))
            {
                currentParentObject = FCGlobal.getObjectNameById(appID);
                Map<String,String> mapApplicationFields = FCGLobal.getsObjectFields(currentParentObject,null);

                if(String.isBlank(applicationRecordTypeId))
                {
                    String sanitizedCurrentParentObject = currentParentObject.replaceAll('[^0-9a-zA-Z_.]', '');
                    string strQuery = 'SELECT Id, RecordTypeId FROM ' + sanitizedCurrentParentObject + ' WHERE id = :appID WITH SECURITY_ENFORCED LIMIT 1';
                    list<sObject> sObjectQuizID = DataBase.query(strQuery);

                    if(sObjectQuizID[0].get('RecordTypeId') != null)
                        applicationRecordTypeId = String.valueOf(sObjectQuizID[0].get('RecordTypeId'));

                }
                initializeQuiz(applicationRecordTypeId);

                for( Schema.SObjectField field :  SchemaEngine.getQuestionFields(quiz.ID,currentParentObject.tolowercase(),portalLanguage) )
                {
                    fieldSet.add( field.getDescribe().getName() );
                }
                if('FGM_Base__Grantee_Report__c'.equalsIgnoreCase(currentParentObject))
                {
                    if(!fieldSet.contains('Name'))
                    {
                        fieldSet.add('Name');
                    }
                    if(!fieldSet.contains('FGM_Base__Status__c'))
                    {
                        fieldSet.add('FGM_Base__Status__c');
                    }
                    if(!fieldSet.contains('FGM_Base__Display_Benchmark__c'))
                    {
                        fieldSet.add('FGM_Base__Display_Benchmark__c');
                    }
                    if(!fieldSet.contains('FGM_Base__Request__c'))
                    {
                        fieldSet.add('FGM_Base__Request__c');
                    }
                }

                if('FGM_Base__Benchmark__c'.equalsIgnoreCase(currentParentObject))
                {
                    if(!fieldSet.contains('Name'))
                    {
                        fieldSet.add('Name');
                    }
                    if(!fieldSet.contains('FGM_Base__Status__c'))
                    {
                        fieldSet.add('FGM_Base__Status__c');
                    }
                    if(!fieldSet.contains('FGM_Base__Request__c'))
                    {
                        fieldSet.add('FGM_Base__Request__c');
                    }
                }

                if('Amendment__c'.equalsIgnoreCase(currentParentObject) || 'FGM_Portal__Amendment__c'.equalsIgnoreCase(currentParentObject))
                {
                    if(!fieldSet.contains('Name'))
                    {
                        fieldSet.add('Name');
                    }
                    if(!fieldSet.contains('StageName__c') && !fieldSet.contains('FGM_Portal__StageName__c'))
                    {
                        fieldSet.add('StageName__c');
                    }
                    if(Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().keySet().contains('billingcountrycode'))
                    {
                        if(!fieldSet.contains('Billing_Mailing_Country__c') && !fieldSet.contains('FGM_Portal__Billing_Mailing_Country__c'))
                        {
                            fieldSet.add('Billing_Mailing_Country__c');
                        }
                        if(!fieldSet.contains('Billing_Mailing_State__c') && !fieldSet.contains('FGM_Portal__Billing_Mailing_State__c'))
                        {
                            fieldSet.add('Billing_Mailing_State__c');
                        }
                        if(!fieldSet.contains('Shipping_Other_Country__c') && !fieldSet.contains('FGM_Portal__Shipping_Other_Country__c'))
                        {
                            fieldSet.add('Shipping_Other_Country__c');
                        }
                        if(!fieldSet.contains('Shipping_Other_State__c') && !fieldSet.contains('FGM_Portal__Shipping_Other_State__c'))
                        {
                            fieldSet.add('Shipping_Other_State__c');
                        }
                    }

                }

                List<String> sanitizedFieldSet = new List<String>();

                for (String f : fieldSet) {
                    sanitizedFieldSet.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                }

                String sanitizedCurrentParentObject = currentParentObject.replaceAll('[^0-9a-zA-Z_.]', '');

                String strQuery = ''
                    + 'SELECT ' + String.join(sanitizedFieldSet, ', ')
                    + '  FROM ' + sanitizedCurrentParentObject
                    + ' WHERE ' + applicationCondition
                    + ' LIMIT 1';
                applicationList = (sObject[]) Database.query(strQuery);

				applicationList = CrudFlsService.getInstance().stripInaccessibleForRead(applicationList);
            }

            if (applicationList != null && !applicationList.isEmpty() && String.isNotBlank(applicationCondition))
            {
                application = applicationList[0];
                pageTitle = String.valueOf(application.get('Name'));


                if(!('Amendment__c'.equalsIgnoreCase(currentParentObject) || 'FGM_Portal__Amendment__c'.equalsIgnoreCase(currentParentObject)))
                {
                    string requestId = String.valueOf(application.get('FGM_Base__Request__c'));
                    if(requestId != null )
                    {
                        String userId = UserInfo.getUserId();
                        string strOTMQuery = 'SELECT Id, OpportunityAccessLevel, Opportunity.stagename FROM OpportunityTeamMember WHERE OpportunityId = :requestId AND UserId = :userId WITH SECURITY_ENFORCED LIMIT 1';
                        List<opportunityTeamMember> lstOpportunityTeamMember = (List<opportunityTeamMember>)Database.Query(strOTMQuery);
                        strParentApplicationMode = (lstOpportunityTeamMember[0].OpportunityAccessLevel == 'Read') ? 'view': 'edit';
                        strParentApplicationStage = lstOpportunityTeamMember[0].Opportunity.stagename;
                    }
                }
                //To maintain SCPL field values in Map for Edit Layout
                Boolean bIsSCPLEnabled = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().keySet().contains('billingcountrycode');

                if(bIsSCPLEnabled && ('Amendment__c'.equalsIgnoreCase(currentParentObject) || 'FGM_Portal__Amendment__c'.equalsIgnoreCase(currentParentObject)))
                {
                    mapStateCountryFieldVal = new Map<String,String>();
                    mapStateCountryFieldVal.put('Billing_Mailing_Country__c',String.valueOf(application.get('Billing_Mailing_Country__c')));
                    mapStateCountryFieldVal.put('Billing_Mailing_State__c',String.valueOf(application.get('Billing_Mailing_State__c')));
                    mapStateCountryFieldVal.put('Shipping_Other_Country__c',String.valueOf(application.get('Shipping_Other_Country__c')));
                    mapStateCountryFieldVal.put('Shipping_Other_State__c',String.valueOf(application.get('Shipping_Other_State__c')));

                }

                if('FGM_Base__Grantee_Report__c'.equalsIgnoreCase(currentParentObject) && String.isNotBlank(String.valueOf(application.get('FGM_Base__Status__c'))) &&  'Submitted'.equalsIgnoreCase(String.valueOf(application.get('FGM_Base__Status__c'))))
                {
                    appStage = 'Submitted';
                    isApplicationSubmitted = true;
                    isShowHidePrePostText = true;
                }
                else if('FGM_Base__Benchmark__c'.equalsIgnoreCase(currentParentObject) && String.isNotBlank(String.valueOf(application.get('FGM_Base__Status__c'))) &&  'Proposed'.equalsIgnoreCase(String.valueOf(application.get('FGM_Base__Status__c'))))
                {
                    appStage = 'Submitted';
                    isApplicationSubmitted = true;
                    isShowHidePrePostText = true;
                }
                else if(('Amendment__c'.equalsIgnoreCase(currentParentObject) || 'FGM_Portal__Amendment__c'.equalsIgnoreCase(currentParentObject)) && String.isNotBlank(String.valueOf(application.get('StageName__c'))) &&  'Submitted'.equalsIgnoreCase(String.valueOf(application.get('StageName__c'))))
                {
                    appStage = 'Submitted';
                    isApplicationSubmitted = true;
                    isShowHidePrePostText = true;
                }
            }
            else if(String.isNotBlank(applicationRecordTypeId))
            {
                try
                {
                    Id IdRecordType = applicationRecordTypeId;
                    applicationRecordTypeId = String.valueOf(IdRecordType);
                    appStage = 'NotSubmitted';
                }
                catch(Exception ex)
                {
                    applicationRecordTypeId = '';
                }

                if(quiz==null)
                    initializeQuiz(applicationRecordTypeId);
                application = FCGlobal.getNewSobject(currentParentObject);

                if(application == null)
                    return;

                if(String.isNotBlank(applicationRecordTypeId))
                {
                    application.put('RecordTypeId',applicationRecordTypeId);
                    String parentId = getParam('ParentId');
                    if(String.isNotBlank(parentId))
                    {
                        String parentObjectName = FCGlobal.getObjectNameById(parentId);
                        if(String.isNotBlank(parentObjectName))
                        {
                            String relationShipField = FCGlobal.getRelationalField(Id.valueOf(parentId).getSObjectType(), currentParentObject);
                            if(String.isNotBlank(relationShipField))
                                application.put(relationShipField,parentId);
                        }
                    }
                }
            }
            if('FGM_Base__Grantee_Report__c'.equalsIgnoreCase(currentParentObject)){
                appStage = String.valueof(application.get('FGM_Base__Status__c'));
                displayBenchmark = Boolean.valueOf(application.get('FGM_Base__Display_Benchmark__c')) ;
            }

            if('Amendment__c'.equalsIgnoreCase(currentParentObject) || 'FGM_Portal__Amendment__c'.equalsIgnoreCase(currentParentObject))
                appStage = String.valueof(application.get('StageName__c'));

            if('FGM_Base__Benchmark__c'.equalsIgnoreCase(currentParentObject))
                appStage = String.valueof(application.get('FGM_Base__Status__c'));

            if(mode.equalsIgnoreCase('edit'))
            {
                List<PortalConfiguration__c> lstPortalConfRecord = PortalConfiguration__c.getall().values();
                if(lstPortalConfRecord != null && !lstPortalConfRecord.isEmpty())
                {
                    for(PortalConfiguration__c portalConfiguration :lstPortalConfRecord)
                    {
                        if(portalConfiguration.LanguageSelection__c == String.escapeSingleQuotes(portalLanguage))
                            lstPortalConfigurationFields.add(portalConfiguration);
                    }

                    if( lstPortalConfigurationFields != null && !lstPortalConfigurationFields.isEmpty())
                    {
                        if('FGM_Base__Grantee_Report__c'.equalsIgnoreCase(currentParentObject) && string.isNotBlank(lstPortalConfigurationFields[0].GranteeReportEditableStatus__c) && (lstPortalConfigurationFields[0].GranteeReportEditableStatus__c).contains(appStage) && strParentApplicationMode.equalsIgnoreCase('edit'))
                        {
                            mode='edit';
                            strApplicationMode='edit';
                            isApplicationSubmitted = false;
                            isViewRecordLink = false;
                            isRelatedListView = false;
                        }
                        else
                        {
                            mode='view';
                            strApplicationMode='view';
                            isViewRecordLink = true;
                            isApplicationSubmitted = true;
                            isRelatedListView = true;
                        }

                        if('Amendment__c'.equalsIgnoreCase(currentParentObject) || 'FGM_Portal__Amendment__c'.equalsIgnoreCase(currentParentObject))
                        {
                            if(string.isNotBlank(lstPortalConfigurationFields[0].AmendmentEditableStatus__c))
                            {
                                if((lstPortalConfigurationFields[0].AmendmentEditableStatus__c).contains(appStage))
                                {
                                    mode='edit';
                                    strApplicationMode='edit';
                                    isViewRecordLink = false;
                                    isRelatedListView = false;
                                    isApplicationSubmitted = false;
                                }
                                else
                                {
                                    isViewRecordLink = true;
                                    mode='view';
                                    strApplicationMode='view';
                                    isApplicationSubmitted = true;
                                    isRelatedListView = true;
                                }
                            }
                        }

                        if('FGM_Base__Benchmark__c'.equalsIgnoreCase(currentParentObject))
                        {
                            if(string.isNotBlank(lstPortalConfigurationFields[0].BenchmarkEditableStatus__c))
                            {
                                if((lstPortalConfigurationFields[0].BenchmarkEditableStatus__c).contains(appStage) && strParentApplicationMode.equalsIgnoreCase('edit'))
                                {
                                    mode='edit';
                                    strApplicationMode='edit';
                                    isViewRecordLink = false;
                                    isApplicationSubmitted = false;
                                    isRelatedListView = false;

                                }
                                else
                                {
                                    isViewRecordLink = true;
                                    strApplicationMode='view';
                                    mode='view';
                                    isApplicationSubmitted = true;
                                    isRelatedListView = true;
                                }
                            }
                        }
                    }
                }
            }
            //Dynamic iframe begin
            if( MapObjNameObjDetails == null )
                MapObjNameObjDetails = new Map< String, sObject >();
            if( 'FGM_Base__Grantee_Report__c'.equalsIgnoreCase(currentParentObject) )
                MapObjNameObjDetails.put( 'FGM_Base__Grantee_Report__c'.tolowercase(), application );
            else if( 'Amendment__c'.equalsIgnoreCase(currentParentObject) || 'FGM_Portal__Amendment__c'.equalsIgnoreCase(currentParentObject))
                MapObjNameObjDetails.put( 'Amendment__c'.tolowercase(), application );
            else if( 'FGM_Base__Benchmark__c'.equalsIgnoreCase(currentParentObject) )
                MapObjNameObjDetails.put( 'FGM_Base__Benchmark__c'.tolowercase(), application );

            //Dynamic iframe end
        }
        catch (DMLException DMLex)
        {
            system.debug( 'DMLException : ' + DMLex);
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + DMLex.getDmlMessage(0) ) );
        }
        catch( Exception ex )
        {
            system.debug( 'Exception : ' + ex + ' ;   @ line :  ' + ex.getLineNumber() + ' ;   stackTrace: '+ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() ) );
        }
    }

    // initialize the Quiz
    private void initializeQuiz(String RecordTypeId)
    {
        try
        {
            if(String.isNotBlank(RecordTypeId))
            {

                List<FCPageLayout__c> lstPageLayout = [
                    SELECT
                        ObjectName__c,
                        Quiz__c,
                        Quiz__r.Id,
                        Quiz__r.Is_Active__c
                    FROM FCPageLayout__c
                    WHERE RecordTypeId__c = :RecordTypeId
                    AND Quiz__c != null
                    WITH SECURITY_ENFORCED
                    LIMIT 1
                ];

                if(lstPageLayout != null && lstPageLayout.size() > 0)
                {
                    quiz = lstPageLayout[0].Quiz__r;
                    if(currentParentObject == null)
                        currentParentObject = lstPageLayout[0].ObjectName__c;
                }
                else
                    rollbackWithError(System.Label.FC_FCRecord_PageLayoutProcessing_ErrorMsg,null);
            }
            else
                rollbackWithError(System.Label.FC_FCRecord_PageLayoutProcessing_ErrorMsg,null);
        }
        catch( Exception ex )
        {
            system.debug( 'Exception : ' + ex
                         + '; @ line number : ' + ex.getLineNumber() );
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() ) );
        }
    }


    // Initialize the Attachments
    public void initializeAttachment()
    {
        try
        {
            mapApplicationAttachments = new Map<String,ApplicationAttachments>();
            setAttachmentQuestionList = new Set<String>();
            if(quizQuestionList != null)
            {
                for(Quiz_Questions__c quizQuestion : quizQuestionList)
                {
                    if(String.isNotBlank(quizQuestion.Question__r.Type__c) && quizQuestion.Question__r.Type__c == 'Attachment')
                        setAttachmentQuestionList.add(quizQuestion.Question__c);
                    ApplicationAttachments tempApplicationAttachments = new ApplicationAttachments();
                    mapApplicationAttachments.put(String.valueOf(quizQuestion.Question__r.Id),tempApplicationAttachments);
                }
            }

            String questionAttachmentRelationField = FCGlobal.getRelationalField(currentParentObject, Question_Attachment__c.sObjectType);
            if(setAttachmentQuestionList != null && !setAttachmentQuestionList.isEmpty() && application != null && application.Id != null)
            {
                if(!String.isNotBlank(questionAttachmentRelationField))
                {
                    isErrorInAttachment = true;
                    return;
                }

                applicationId = application.Id;
                String strQuery = ''
                    +'SELECT (SELECT Name'
                    +',Id'
                    +', ContentType'
                    +', BodyLength'
                    +',CreatedDate'
                    +',Description'
                    +' FROM Attachments)'
                    +', Question__c'
                    +', Description__c'
                    +' FROM Question_Attachment__c'
                    +' Where ' + questionAttachmentRelationField + ' = :applicationId'
                    +' WITH SECURITY_ENFORCED'
                    +' ORDER BY CreatedDate ASC'
                    +' LIMIT 10000';
                List<Question_Attachment__c> lstQuestionAttachment = (List<Question_Attachment__c>)Database.Query(strQuery);

                Set<String> setQuestionIds = new Set<String>();

                for (Questions__c question: [
                    SELECT Parent_QuestionID__c
                    FROM Questions__c
                    WHERE Id IN :setAttachmentQuestionList
                    WITH SECURITY_ENFORCED
                ]) {
                    if (question.Parent_QuestionID__c != null) {
                        setAttachmentQuestionList.add(
                            question.Parent_QuestionID__c
                        );
                    }
                }

                if(lstQuestionAttachment != null && !lstQuestionAttachment.isEmpty())
                {
                    Set<Id> setQuestionAttachment = new Set<Id>((new Map<Id,sObject>(lstQuestionAttachment)).keySet());
                    List<FeedItem> lstFeedItems = new FCGlobal.WithoutSharing().getFeedAttachments(setQuestionAttachment);

                    for(Question_Attachment__c questionAttachment : lstQuestionAttachment)
                    {
                        setAttachmentQuestionList.remove(questionAttachment.Question__c);
                        ApplicationAttachments applicationAttachment = new ApplicationAttachments();
                        applicationAttachment.strQuestionAttachmentId = questionAttachment.Id;
                        applicationAttachment.questionAttachment = questionAttachment;


                        for(Attachment attachment: questionAttachment.Attachments)
                        {
                            applicationAttachment.oldMapSize = applicationAttachment.mapOldAttachments.size() == 0 ? 1 : applicationAttachment.mapOldAttachments.size();
                            applicationAttachment.mapOldAttachments.put(String.valueOf(attachment.Id),(sObject)attachment);
                            applicationAttachment.mapAttachType.put(String.valueOf(attachment.Id),'Attachment');
                        }

                        for(FeedItem feedItem :lstFeedItems)
                        {
                            if(feedItem.ParentId == questionAttachment.Id && feedItem.RelatedRecordId != null)
                            {
                                applicationAttachment.oldMapSize = applicationAttachment.mapOldAttachments.size() == 0 ? 1 : applicationAttachment.mapOldAttachments.size();
                                applicationAttachment.mapOldAttachments.put(String.valueOf(feedItem.Id),(sObject)feedItem);
                                applicationAttachment.mapAttachType.put(String.valueOf(feedItem.Id),'File');
                            }
                        }
                        mapApplicationAttachments.put(String.valueOf(questionAttachment.Question__c),applicationAttachment);
                    }
                }


                if(!setAttachmentQuestionList.isEmpty() && application != null && application.Id != null)
                {
                    List<Question_Attachment__c> lstUpsertQuestionAttachment = new List<Question_Attachment__c>();
                    if(String.isNotBlank(questionAttachmentRelationField))
                    {
                        for(String questionId : setAttachmentQuestionList)
                        {
                            Question_Attachment__c questionAttachment = new Question_Attachment__c();
                            questionAttachment.put('Question__c',questionId);
                            questionAttachment.put(questionAttachmentRelationField,application.Id);

                            if( currentTabType=='Portal Tab')
                                lstUpsertQuestionAttachment.add(questionAttachment);
                        }
                    }
                    else
                        isErrorInAttachment = true;

                    // Upsert the attachment placeholders
                    if(lstUpsertQuestionAttachment != null && !lstUpsertQuestionAttachment.isEmpty())
                    {
                        CrudFlsService.getInstance().assertUpdateable(lstUpsertQuestionAttachment);
                        upsert lstUpsertQuestionAttachment;
                        for(Question_Attachment__c questionAttachment : lstUpsertQuestionAttachment)
                        {
                            ApplicationAttachments applicationAttachment = new ApplicationAttachments();
                            applicationAttachment.strQuestionAttachmentId = questionAttachment.Id;

                            for(Attachment attachment: questionAttachment.Attachments)
                            {
                                applicationAttachment.mapOldAttachments.put(String.valueOf(attachment.Id),(sObject)attachment);
                                applicationAttachment.mapAttachType.put(String.valueOf(attachment.Id),'Attachment');
                            }
                            for(Question_Attachment__Feed feedAttachment: questionAttachment.Feeds)
                            {
                                applicationAttachment.mapOldAttachments.put(String.valueOf(feedAttachment.Id),(Sobject)feedAttachment);
                                applicationAttachment.mapAttachType.put(String.valueOf(feedAttachment.Id),'File');
                            }
                            applicationAttachment.oldMapSize = applicationAttachment.mapOldAttachments.size();
                            mapApplicationAttachments.put(String.valueOf(questionAttachment.Question__c),applicationAttachment);
                        }
                    }
                    if(lstUpsertQuestionAttachment!=null)
                        lstQuestionAttachment.addAll(lstUpsertQuestionAttachment);
                }

                if(lstQuestionAttachment != null && !lstQuestionAttachment.isEmpty())
                    for(FGM_Portal__Question_Attachment__c questionAttachment : lstQuestionAttachment)
                    setQuestionIds.add((String) questionAttachment.FGM_Portal__Question__c);
                Map<String,Set<String>> mapParentChildQuestion = FCGlobal.getClonedQuestionsParent(setQuestionIds);

                if(mapParentChildQuestion != null && mapApplicationAttachments != null)
                {
                    for(FGM_Portal__Question_Attachment__c questionAttachment : lstQuestionAttachment)
                    {
                        if(mapParentChildQuestion.containsKey((String)questionAttachment.FGM_Portal__Question__c))
                        {
                            ApplicationAttachments applicationAttachment = new ApplicationAttachments();
                            applicationAttachment.strQuestionAttachmentId = questionAttachment.Id;

                            Set<String> setOfClonedQuestion =  mapParentChildQuestion.get((String)questionAttachment.FGM_Portal__Question__c);

                            if(!setOfClonedQuestion.isEmpty() && setOfClonedQuestion!=null)
                            {   ApplicationAttachments objApplicationAttachmentParent;
                             for(String clonedQuestionId : setOfClonedQuestion)
                             {
                                 ApplicationAttachments objApplicationAttachmentCloned = mapApplicationAttachments.get(clonedQuestionId);
                                 objApplicationAttachmentParent = mapApplicationAttachments.get(questionAttachment.FGM_Portal__Question__c);
                                 if(objApplicationAttachmentCloned != null && objApplicationAttachmentParent != null)
                                 {
                                     objApplicationAttachmentParent.mapAttachType.putAll(objApplicationAttachmentCloned.mapAttachType);
                                     objApplicationAttachmentParent.mapOldAttachments.putAll(objApplicationAttachmentCloned.mapOldAttachments);
                                     objApplicationAttachmentParent.oldMapSize = objApplicationAttachmentParent.mapOldAttachments.size();
                                 }
                             }
                             if(objApplicationAttachmentParent!=null && objApplicationAttachmentParent.mapOldAttachments!=null)
                             {
                                 for(String clonedQuestionId : setOfClonedQuestion)
                                 {
                                     ApplicationAttachments objApplicationAttachmentCloned = mapApplicationAttachments.get(clonedQuestionId);
                                     if(objApplicationAttachmentCloned!=null)
                                         if(objApplicationAttachmentParent.mapOldAttachments.size() > objApplicationAttachmentCloned.mapOldAttachments.size())
                                     {
                                         objApplicationAttachmentCloned.mapAttachType.putAll(objApplicationAttachmentParent.mapAttachType);
                                         objApplicationAttachmentCloned.mapOldAttachments.putAll(objApplicationAttachmentParent.mapOldAttachments);
                                         objApplicationAttachmentCloned.oldMapSize = objApplicationAttachmentCloned.mapOldAttachments.size();
                                     }
                                 }

                             }
                            }
                        }
                    }
                }
            }

        }
        catch (DMLException DMLex)
        {
            system.debug( 'DMLException : ' + DMLex);
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + DMLex.getDmlMessage(0) ) );
        }
        catch( Exception ex )
        {
            system.debug( 'Exception : ' + ex + '; @ line number : ' + ex.getLineNumber() );
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() ) );
        }
    }

    public void generateScanMessage()
    {
        Boolean IsInfected = Boolean.valueOf(Apexpages.currentPage().getParameters().get('IsInfected'));
        String strMessage = Apexpages.currentPage().getParameters().get('message');

        if(string.isBlank(strMessage))
        {
            if(IsInfected == true)
            {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.FC_Infected_File_Error_Message));
            }
            else if(!IsInfected)
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,System.Label.FC_File_Upload_Success_Message));
        }
        else
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,strMessage));
    }

    // Initialize the Feed Attachments
    public void InitalizePortalFeedAttachment(String portalLanguage)
    {
        for(PortalConfiguration__c portalConfig: PortalConfiguration__c.getall().values())
        {
            if(portalConfig != null && portalConfig.Post_attachments_to_chatter_feeds__c == true && portalConfig.LanguageSelection__c.trim().toLowerCase().equals(portalLanguage.trim().toLowerCase()))
            {
                isFeedAttachmentEnabled = true;
                break;
            }
        }
        mapApplicationAttachments = new  Map<String,ApplicationAttachments>();
    }

    //To show record in Review Page.
    public void initializeReviewPageList()
    {
        // Setup the review list
        reviewPageList = new ReviewPage[] {};
            if (application.Id == null || tabsList == null || tabsList.isEmpty())
            return;

        if(relatedListTabIds != null && portalTabIds != null)
        {
            ReviewPage reviewPage = null;
            for(Related_List_Controller__c tabRecord : tabsList)
            {
                reviewPage = null;
                if(portalTabIds.contains(tabRecord.Id))
                {
                    reviewPage = new ReviewPage();
                    reviewPage.name = tabRecord.Name;
                    reviewPage.TabType = 'Portal Tab';
                    reviewPage.reviewQuestionList = new ReviewQuestion[] {};

                        if(tabRecord.Quiz_Questions__r == null)
                        continue;

                    for(Quiz_Questions__c quizQuestion : tabRecord.Quiz_Questions__r)
                    {
                        // Missing field types can  be skipped
                        if (quizQuestion.Question__r.Type__c == null)
                            continue;
                        if (quizQuestion.Question__r.Type__c == 'Instruction')
                            continue;
                        // Basic response
                        ReviewQuestion reviewQuestion = new ReviewQuestion();
                        reviewQuestion.question = quizQuestion.Question__r;

                        // For fields mapped directly to the application
                        if (quizQuestion.Field__c != null && application.get(quizQuestion.Field__c) != null)
                        {
                            reviewQuestion.response = '' + application.get(quizQuestion.Field__c);
                            reviewQuestion.field =  quizQuestion.Field__c;
                        }
                        reviewQuestion.questionType = quizQuestion.Question__r.Type__c;
                        reviewQuestion.questionId  = quizQuestion.Question__c;

                        if(quizQuestion.Question__r.Type__c == 'Salesforce Data Type')
                        {
                            if(String.isNotBlank(tabRecord.ObjectName__c) && String.isNotBlank(quizQuestion.Field__c))
                            {
                                Schema.DescribeFieldResult FieldInstance = Schema.getGlobalDescribe().get(String.valueOf(tabRecord.ObjectName__c).toLowerCase()).getDescribe().fields.getMap().get(String.valueOf(quizQuestion.Field__c).toLowerCase()).getDescribe();
                                reviewQuestion.strFieldType = String.valueOf(FieldInstance.getType());
                                reviewQuestion.isHTMLenabled = FieldInstance.isHtmlFormatted();
                            }
                        }
                        // Add to reviewPage list
                        reviewPage.reviewQuestionList.add(reviewQuestion);
                        // Add if it required and Empty
                        //if(quizQuestion.Required__c && String.isEmpty(reviewQuestion.response))
                        //    requiredQuestions.add(quizQuestion.Question__r.Question__c);
                    }
                    // Only add the reviewPage to the list if there are matched questions
                    if (reviewPage.reviewQuestionList.isEmpty() == false)
                        reviewPageList.add(reviewPage);
                }
                else if(relatedListTabIds.contains(tabRecord.Id) && String.isNotBlank(tabRecord.ObjectName__c) && String.isNotBlank(tabRecord.LookupField__c))
                {
                    reviewPage = new ReviewPage();
                    reviewPage.name = tabRecord.Name;
                    reviewPage.TabType = 'Related List With Tab';
                    reviewPage.relatedListConfiguration = new relatedList();
                    reviewPage.relatedListConfiguration.record = tabRecord;
                    reviewPage.relatedListConfiguration.strRelatedListObject = tabRecord.ObjectName__c;
                    reviewPage.relatedListConfiguration.mapColumnFields =  getrelatedListColumn(tabRecord);
                    reviewPage.relatedListConfiguration.listColumnFields =  getrelatedListColumnList(tabRecord);
                    reviewPage.relatedListConfiguration.relatedListLookUp =  tabRecord.LookupField__c;

                    if(!reviewPage.relatedListConfiguration.mapColumnFields.isEmpty())
                    {
                        if(reviewPage.relatedListConfiguration.strRelatedListObject == 'FGM_Base__Benchmark_Update__c')
                        {
                            reviewPage.relatedListConfiguration.lstRelatedListRecord = getBenchmarkUpdateRecords(tabRecord,new Set<String>(reviewPage.relatedListConfiguration.mapColumnFields.values()));
                        }
                        else
                        {
                            reviewPage.relatedListConfiguration.lstRelatedListRecord = getRelatedListRecords(tabRecord,new Set<String>(reviewPage.relatedListConfiguration.mapColumnFields.values()));
                            reviewPage.relatedListConfiguration.mapFieldDescribe = getDescribeRelatedListField(reviewPage.relatedListConfiguration.mapColumnFields.values() , tabRecord.ObjectName__c);
                        }
                    }

                    reviewPageList.add(reviewPage);
                }
                else if(granteeBudgetUpdateTabIds.contains(tabRecord.Id) && String.isNotBlank(tabRecord.ObjectName__c) && String.isNotBlank(tabRecord.LookupField__c))
                {
                    reviewPage = new ReviewPage();
                    reviewPage.name = tabRecord.Name;
                    reviewPage.TabType = 'Grantee Budget Update Tab';
                    reviewPage.relatedListConfiguration = new relatedList();
                    reviewPage.relatedListConfiguration.record = tabRecord;
                    reviewPage.relatedListConfiguration.strRelatedListObject = tabRecord.ObjectName__c;
                    reviewPageList.add(reviewPage);
                }
            }
        }

    }

    public Map<String , String> getDescribeRelatedListField (List<String> listRelatedListFields , String strSobject)
    {
        Map<String , String> mapFieldDescribe = new Map<String , String>();
        for(String strField : listRelatedListFields)
        {
            Schema.DescribeFieldResult FieldInstance = Schema.getGlobalDescribe().get(strSobject.toLowerCase()).getDescribe().fields.getMap().get(strField.toLowerCase()).getDescribe();
            mapFieldDescribe.put(strField , String.valueOf(FieldInstance.getType()));
        }
        return mapFieldDescribe;
    }

    // Save relatedList Record
    public void SaveRelatedListRecord()
    {
        Savepoint sp = Database.setSavepoint();
        defaultMode = 'view';
        if(application == null && application.Id == null && application.Id != tabObject.Id)
            return;

        if(relatedListConfiguration != null && String.isNotBlank(relatedListConfiguration.relatedListLookUp))
        {
            object customObject = FCGlobal.getNewSobject(relatedListConfiguration.strRelatedListObject);
            if(customObject != null)
            {
                sobject sobjectInstance = (sobject)customObject;
                sobjectInstance = tabObject;
                if(sobjectInstance.id == null)
                    sobjectInstance.put(relatedListConfiguration.relatedListLookUp,application.Id);

                try
                {
                    Boolean isRequiredFieldMissing = false;
                    requiredQuestionErrors = new List<Questions__c>();
                    for(Quiz_Questions__c quizQuestion: quizQuestionList)
                    {
                        if(quizQuestion.Tab__c == selectedTab)
                        {
                            if(quizQuestion.Question__r.Type__c == 'Salesforce Data Type' )
                            {
                                Schema.DescribeFieldResult FieldInstance = Schema.getGlobalDescribe().get(String.valueOf(relatedListConfiguration.strRelatedListObject).toLowerCase()).getDescribe().fields.getMap().get(String.valueOf(quizQuestion.Field__c).toLowerCase()).getDescribe();
                                if(FieldInstance.getType() == Schema.Displaytype.TextArea && FieldInstance.isHtmlFormatted())
                                    sobjectInstance.put(quizQuestion.Field__c , strHiddenValue);

                                if(quizQuestion.Required__c && ((!(FieldInstance.getType() == Schema.Displaytype.TextArea && FieldInstance.isHtmlFormatted()) && (String.valueOf(sobjectInstance.get(quizQuestion.Field__c)) == NULL || String.valueOf(sobjectInstance.get(quizQuestion.Field__c)).length() == 0)) || (FieldInstance.getType() == Schema.Displaytype.TextArea && FieldInstance.isHtmlFormatted() && strHiddenValue.length() == 0)))
                                {
                                    isRequiredFieldMissing = true;
                                    requiredQuestionErrors.add(quizQuestion.Question__r);
                                }
                            }
                            else if(quizQuestion.Question__r.Type__c == 'Attachment')
                            {
                                if(mapApplicationAttachments.get(quizQuestion.Question__c) != null && mapApplicationAttachments.get(quizQuestion.Question__c).oldMapSize <= 0)
                                {
                                    isRequiredFieldMissing = true;
                                    requiredQuestionErrors.add(quizQuestion.Question__r);
                                }
                            }//end of Attachment
                        }
                    }
                    /*---------------------------------------------------------------------------------*/
                    if(!(isRequiredFieldMissing))
                    {
                        if(sobjectInstance.Id != null){
                            sobjectInstance = CrudFlsService.getInstance().stripInaccessibleForUpdate(new List<Sobject>{sobjectInstance})[0];
                        }else{
                            sobjectInstance = CrudFlsService.getInstance().stripInaccessibleForInsert(new List<Sobject>{sobjectInstance})[0];
                        }
                        upsert sobjectInstance;
                        if(relatedListConfiguration != null)
                        {
                            Related_List_Controller__c tabRecord = null;
                            if(tabsList != null && String.isNotBlank(selectedTab))
                            {
                                for(Related_List_Controller__c tab : tabsList)
                                {
                                    if(selectedTab == String.valueOf(tab.Id))
                                    {
                                        tabRecord = tab;
                                        break;
                                    }
                                }
                            }

                            if(tabRecord != null)
                                relatedListConfiguration.lstRelatedListRecord = getRelatedListRecords(tabRecord,new Set<String>(relatedListConfiguration.mapColumnFields.values()));

                            backTOrelatedlistView();
                        }
                    }
                }
                catch(DMLException ex)
                {
                    String errorMessage = ex.getMessage();
                    Integer occurence;
                    if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
                    {
                        occurence = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
                        errorMessage = errorMessage.mid(occurence, errorMessage.length());
                        occurence = errorMessage.lastIndexOf(':');
                        errorMessage = errorMessage.mid(0, occurence);
                        System.debug('Exception : ' + errorMessage + ' @Line number ' + ex.getLineNumber());
                    }
                    else {
                        System.debug('Exception : ' +errorMessage + ' @Line number ' + ex.getLineNumber());
                    }
                    if(sp != Null){
                         Database.rollback(sp);
                    }
                }
                catch(Exception ex)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
                }
            }
        }
    }

    //To get the next tab Id
    @TestVisible
    private String getNextTab()
    {
        try
        {
            isLastTab = false;
            String nextTabID = '';
            if(String.isNotBlank(selectedTab) && tabsList != null)
            {
                for(integer index = 0; index < tabsList.size(); index++)
                {
                    isLastTab = false;
                    if(selectedTab.equalsIgnoreCase(String.valueOf(tabsList[index].Id)))
                    {
                        if(index + 1 < tabsList.size())
                            nextTabID = String.valueOf(tabsList[index + 1].Id);
                        else
                            isLastTab = true;
                    }
                }
            }
            if(getParam('mode') == null)
            {
                PageReference ref = System.Page.FCRecord;
                ref.getParameters().put('mode', mode);
            }
            return nextTabID;
        }
        catch( Exception ex )
        {
            system.debug( 'Exception : ' + ex + '; @ line number : ' + ex.getLineNumber() );
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() ) );
        }
        return null;
    }

    //unsaved changes are committed before moving to another tab
    public void saveRecordOnTabChange()
    {
        try
        {
            String strSelectedTabId = getParam('tabId');

            if(!currentTabType.Equals('Related List With Tab') && !currentTabType.Equals('Grantee Budget Update Tab'))
            {
                isSaveAndNext = true;
                if(strApplicationMode != null && strApplicationMode != 'view')
                    SaveRecord();
                if(String.isNotBlank(strSelectedTabId))
                    initializeQuizQuestionList(strSelectedTabId);

                isSaveAndNext= false;
            }
            else
            {
                if(String.isNotBlank(strSelectedTabId))
                    initializeQuizQuestionList(strSelectedTabId);
            }
        }
        catch( Exception ex )
        {
            system.debug( 'Exception : ' + ex + '; @ line number : ' + ex.getLineNumber() );
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() ) );
        }
    }
    //Save and Move to Next Tab
    public void SaveAndNext()
    {
        isSaveAndNext = true;
        SaveRecord();
        if(String.isNotBlank(nextTabID))
            initializeQuizQuestionList(nextTabID);

        isSaveAndNext= false;
    }
    public void next()
    {
        if(String.isNotBlank(nextTabID))
            initializeQuizQuestionList(nextTabID);
    }
    public PageReference backToRecord(){
        try{
            String strRecordId = ESAPI.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('id'));
            if(String.isNotBlank(strRecordId))
            {
                PageReference ref = System.Page.FCRecord;
                ref.getParameters().put('id', strRecordId);
                ref.getParameters().put('mode', mode);
                ref.getParameters().put('ParentId', urlParamParentId);
                ref.getParameters().put('from', urlParamFrom);
                ref.setRedirect(true);
                return ref;
            }
        }
        catch(Exception ex){
            System.debug('Exception : ' + ex.getMessage() + ' @Line number ' + ex.getLineNumber());
        }
        return null;

    }
    // Review submit
    public PageReference reviewSubmit(){
        try{
            String applicationId = String.escapeSingleQuotes(application.id);
            String quizId = String.escapeSingleQuotes(quiz.Id);
            if(String.isNotBlank(applicationId) && String.isNotBlank(quizId))
            {
                PageReference ref = System.Page.FCRecordReview;
                ref.getParameters().put('id', applicationId);
                ref.getParameters().put('mode', mode);
                ref.getParameters().put('quizId', quizId);
                ref.getParameters().put('ParentId', urlParamParentId);
                ref.getParameters().put('from', urlParamFrom);
                ref.setRedirect(true);
                return ref;
            }
        }
        catch(Exception ex){
            System.debug('Exception : ' + ex.getMessage() + ' @Line number ' + ex.getLineNumber());
        }
        return null;

    }



    //FCPROD-322: Save Before Review and Submit
    public PageReference SaveBeforeReviewSubmit()
    {
        Savepoint sp = Database.setSavepoint();
        if(currentTabType=='Grantee Budget Update Tab')
        {
            String applicationId = String.escapeSingleQuotes(application.id);
            String quizId = String.escapeSingleQuotes(quiz.Id);
            if(String.isNotBlank(applicationId) && String.isNotBlank(quizId))
            {
                PageReference ref = System.Page.FCRecordReview;
                ref.getParameters().put('id', applicationId);
                ref.getParameters().put('mode', mode);
                ref.getParameters().put('quizId', quizId);
                ref.setRedirect(true);
                return ref;
            }
        }
        if( currentTabType == 'IFrame Tab' )
        {
            PageReference ref = System.Page.FCRecordReview;
            ref.getParameters().put('id',  application.id);
            ref.getParameters().put('mode', mode);
            ref.getParameters().put('quizId', quiz.Id);
            ref.setRedirect(true);
            return ref;
        }
        else if( tabObject == null )
            return null;
        try
        {
            currentParentObject = tabObject.getSObjectType().getDescribe().getName();
            if(String.isNotBlank(currentParentObject) && ('Amendment__c'.equalsIgnoreCase(currentParentObject) || 'FGM_Portal__Amendment__c'.equalsIgnoreCase(currentParentObject)))
            {
                if(tabObject.get('StageName__c') == null || tabObject.get('FGM_Portal__StageName__c') == null)
                    tabObject.put('StageName__c','In Progress');
            }
            
            tabObject = CrudFlsService.getInstance().stripInaccessibleForUpdate(tabObject);
            upsert tabObject;
            String applicationId = application.id;
            String quizId = quiz.Id;

            if(String.isNotBlank(applicationId) && String.isNotBlank(quizId))
            {
                PageReference ref = System.Page.FCRecordReview;
                ref.getParameters().put('id', applicationId);
                ref.getParameters().put('quizId', quizId);
                ref.getParameters().put('from', urlParamFrom);
                ref.getParameters().put('ParentId', urlParamParentId);
                ref.getParameters().put('mode', mode);
                ref.setRedirect(true);
                return ref;
            }
        }
        catch(DMLException ex)
        {
            String errorMessage = ex.getMessage();
            Integer occurence;

            if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
            {
                occurence = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
                errorMessage = errorMessage.mid(occurence, errorMessage.length());
                occurence = errorMessage.lastIndexOf(':');
                errorMessage = errorMessage.mid(0, occurence);
                if(apexPages.getMessages().size() == 0){
                    rollbackWithError(errorMessage,sp);
                }
                else{
                    if (sp != null)
                    {
                        Database.rollback(sp);
                    }
                }
                System.debug('Exception : ' + errorMessage + ' @Line number ' + ex.getLineNumber());
            }
            else {
                System.debug('Exception : ' + errorMessage + ' @Line number ' + ex.getLineNumber());
                if (sp != null)
                    Database.rollback(sp);
            }
        }
        catch(Exception ex)
        {
            rollbackWithError(ex.getMessage(),sp);
        }
        return null;
    }

    // Save parent Record of Application
    public void SaveRecord()
    {
        Savepoint sp = Database.setSavepoint();
        sobject upsertObject = null;
        map<Id,Integer> mapAttachmentCount = new map<Id,Integer>();
        mapAttachmentCount = getAttachmentCount();
        try
        {
            // Set save point to rollback on error
            if(tabObject == null)
                return;
            if (userList.isEmpty())
                return;

            if(tabObject.Id == null && !String.isNotBlank(userList[0].CompanyName))
                userList[0].CompanyName = userList[0].Email;

              upsertObject = tabObject;
          
            //For State Coutry Picklist

            String strObjectName = String.valueOf(upsertObject.getsObjectType());
            if(isSCPLEnabled && String.isNotBlank(strObjectName) && (strObjectName == 'Amendment__c' || strObjectName == 'FGM_Portal__Amendment__c') && String.isNotBlank(applicationRecordType))
            {
                if(applicationRecordType == 'Contact')
                {
                    upsertObject.put('Billing_Mailing_Country__c',countryByCode(String.ValueOf(contact.get('MailingCountryCode'))));
                    upsertObject.put('Shipping_Other_Country__c',countryByCode(String.ValueOf(contact.get('OtherCountryCode'))));
                    upsertObject.put('Billing_Mailing_State__c',stateByCode(String.ValueOf(contact.get('MailingStateCode')),String.ValueOf(contact.get('MailingCountryCode'))));
                    upsertObject.put('Shipping_Other_State__c',stateByCode(String.ValueOf(contact.get('OtherStateCode')),String.ValueOf(contact.get('OtherCountryCode'))));

                }
                else if (applicationRecordType == 'Organization')
                {
                    upsertObject.put('Billing_Mailing_Country__c',countryByCode(String.ValueOf(account.get('BillingCountryCode'))));
                    upsertObject.put('Shipping_Other_Country__c',countryByCode(String.ValueOf(account.get('ShippingCountryCode'))));
                    upsertObject.put('Billing_Mailing_State__c',stateByCode(String.ValueOf(account.get('BillingStateCode')),String.ValueOf(account.get('BillingCountryCode'))));
                    upsertObject.put('Shipping_Other_State__c',stateByCode(String.ValueOf(account.get('ShippingStateCode')),String.ValueOf(account.get('ShippingCountryCode'))));
                }
            }
            //logic to check required field must not be blank before save the application.

            if(!isSaveAndNext)
            {
                requiredQuestionErrors = new List<Questions__c>();
                for(Quiz_Questions__c quizQuestion: quizQuestionList)
                {
                    if(quizQuestion.Required__c && quizQuestion.Tab__c == selectedTab)
                    {
                        if(quizQuestion.Question__r.Type__c == 'Salesforce Data Type' )
                        {
                            if(String.isBlank(String.valueOf(upsertObject.get(quizQuestion.Field__c))))
                                requiredQuestionErrors.add(quizQuestion.Question__r);
                        }
                        else if(quizQuestion.Question__r.Type__c == 'Attachment')
                        {
                            if(mapApplicationAttachments.get(quizQuestion.Question__c) != null && mapAttachmentCount.get(quizQuestion.Question__c)<= 0)
                                requiredQuestionErrors.add(quizQuestion.Question__r);
                        }
                    }
                }//end of for
            }

           if(tabObject.Id == null){
              tabObject = CrudFlsService.getInstance().stripInaccessibleForInsert(new List<Sobject>{upsertObject})[0];
           }
           else{
              tabObject = CrudFlsService.getInstance().stripInaccessibleForUpdate(upsertObject);
           }

           upsert tabObject;
           application = tabObject;

            if(application != null )
            {
                List<String> lstApplicationObjectFields = new List<String>(application.getsObjectType().getDescribe().fields.getMap().keySet());
                String applicationObjectName = String.valueOf(application.getsObjectType());
                String applicationRecordId = application.Id;
                String strQuery = ''
                    + 'SELECT ' + String.join(lstApplicationObjectFields, ', ')
                    +' FROM '+ applicationObjectName
                    +' WHERE Id=:applicationRecordId'
                    +' LIMIT 1';

                List<Sobject> lstApplicationRecords = Database.query(strQuery);

				lstApplicationRecords = CrudFlsService.getInstance().stripInaccessibleForRead(lstApplicationRecords);

                if(lstApplicationRecords!= null && lstApplicationRecords.size() > 0)
                {
                    application = lstApplicationRecords[0];
                    tabObject = application;
                }
            }
            if(getParam('mode') == null)
            {
                PageReference ref = System.Page.FCRecord;
                ref.getParameters().put('mode', mode);
            }
        }
        catch( DMLException ex )
        {
            String errorMessage = ex.getMessage();
            Integer occurence;
            if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
            {
                occurence = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
                errorMessage = errorMessage.mid(occurence, errorMessage.length());
                occurence = errorMessage.lastIndexOf(':');
                errorMessage = errorMessage.mid(0, occurence);
                if(apexPages.getMessages().size() == 0){
                    rollbackWithError(errorMessage,sp);
                }
                System.debug('Exception : ' + errorMessage + ' @Line number ' + ex.getLineNumber());
            }
            else{
                System.debug('Exception : ' + errorMessage + ' @Line number ' + ex.getLineNumber());
                if (sp != null)
                {
                    Database.rollback(sp);
                }
            }
        }
        catch( Exception ex )
        {
            rollbackWithError(ex.getMessage(),sp);
            system.debug( 'Exception : ' + ex + '; @ line number : ' + ex.getLineNumber() );
        }
    }

    //Class for both Attachment and FeedAttachment
    public with sharing class ApplicationAttachments
    {
        public String strQuestionAttachmentId {get; set;}
        public Attachment newAttachment {get;set;}
        public Map<String,sObject> mapOldAttachments {get;set;}
        public Map<String,String> mapAttachType {get;set;}
        public integer oldMapSize {get; set;}
        public Question_Attachment__c questionAttachment{ get; set; }

        public ApplicationAttachments()
        {
            newAttachment = new Attachment();
            mapOldAttachments = new Map<String,sObject>();
            mapAttachType = new Map<String,String>();
            oldMapSize = 0;
        }
    }

    // class for showing related list records for custom object
    public with sharing class relatedList
    {
        public Map<String,String> mapColumnFields { get; set; }
        public Map<String , String> mapFieldDescribe {get; set;}
        public List<String> listColumnFields { get; set; }
        public List<Object> lstRelatedListRecord { get; set; }
        public String strActionColLabel  { get; set; }
        public String strRelatedListObject { get; set; }
        public String relatedListLookUp { get; set; }
        public Boolean isCreatable { get; set; }
        public Boolean isEditable { get; set; }
        public Boolean isDeletable { get; set; }
        public Related_List_Controller__c record { get; set; }

        public relatedList()
        {
            lstRelatedListRecord = new List<Object>();
            strActionColLabel = 'Action';
        }
    }

    public class ReviewPage
    {
        public String name { set; get; }
        public String TabType { set; get; }
        public relatedList relatedListConfiguration { get; set; }
        public ReviewQuestion[] reviewQuestionList { set; get; }
    }

    public class ReviewQuestion
    {
        public Questions__c question { set; get; }
        public String response { set; get; }
        public String questionType {set; get;}
        public string questionId {get; set;}
        public string field{get;set;}
        public String strFieldType {get; set;}
        public Boolean isHTMLenabled {get; set;}
    }
    public class BenchmarkUpdateRecords implements Comparable
    {
        public FGM_Base__Benchmark_Update__c objBU {get;set;}
        public FGM_Base__Benchmark__c objBenchmark {get;set;}
        public String comparableField {get;set;}
        public String sortOrder {get;set;}
        BenchmarkUpdateRecords(String comparableField, String sortOrder){
            this.comparableField = comparableField;
            this.sortOrder = sortOrder;
        }
        public BenchmarkUpdateRecords(){ }
        public Integer compareTo(Object compareTo) {
            if(comparableField != NULL){
                BenchmarkUpdateRecords compareToBudget = (BenchmarkUpdateRecords)compareTo;

                if (objBU.get(comparableField) == compareToBudget.objBU.get(comparableField))
                {
                    if(sortOrder == 'ASC'){
                        if(this.comparableField == null || compareToBudget.comparableField == null)
                            return -1;

                        if(this.comparableField == compareToBudget.comparableField )
                            return (this.comparableField.compareTo(compareToBudget.comparableField));

                        return (this.comparableField.compareTo(compareToBudget.comparableField));
                    }
                    else{
                        if(this.comparableField == null || compareToBudget.comparableField == null)
                            return 1;

                        if(this.comparableField == compareToBudget.comparableField )
                            return (this.comparableField.compareTo(compareToBudget.comparableField));

                        return (this.comparableField.compareTo(compareToBudget.comparableField));

                    }


                }

                if (sortOrder > compareToBudget.sortOrder) return 1;
                return -1;
            }
            return -1;

        }
    }
}