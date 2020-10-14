public with sharing class CommunityApplicationExtension {
    private Boolean isReviewSubmitPage;
    private List<Question_Attachment__c> lstAttachmentRecords { get; set; }
    private List<User> lstLoggedInUsers { get; set; }
    private Map<String, Integer> mapTabIdRecordLimit;
    private Map<String,String> mapOCRPicklistEntries { get; set; }
    private Map<String,String> mapOTMPicklistEntries { get; set; }
    private Set<Id> granteeBudgetTabIds;
    private Set<Id> portalTabIds;
    private Set<Id> relatedListTabIds;
    public Account userAccount { get; set; }
    public ApexPages.StandardController controller { set; get; }
    public Attachment attachment { set; get; }
    public Boolean bIsContactTab { get; set; }
    public Boolean bIsCstObjRecordEditable { get; set; }
    public Boolean bIsCstPrflTab { get; set; }
    public Boolean bIsOrganizationTab { get; set; }
    public Boolean bIsSCPLEnable { get; set; }
    public Boolean bIsSubmittedAndExpiredCampaign { get; set; }
    public Boolean bisFirstPortalTab = false;
    public Boolean cancelDisplayPopup { get; set; }
    public Boolean displayPopup { get; set; }
    public Boolean flagshowpopup { get; set; }
    public Boolean initialized { get; set; } {initialized = false;}
    public Boolean isAppOrLeadUnsubmitted = true;
    public Boolean isApplicationSubmitted { get; set; }
    public Boolean isAssignedTOConsultant { get; set; }
    public Boolean isCampaignExpired { get; set; }
    public Boolean isConsultant { get; set; }
    public Boolean isContact { get; set; }
    public Boolean isDuplicateUserFound { get; set; }
    public Boolean isError = false;
    public Boolean isErrorInAttachment { get; set; }
    public Boolean isFeedAttachmentEnabled { get; set; }
    public Boolean isIExplorer { get; set; }
    public Boolean isIFrame { get; set; }
    public Boolean isInvalidAppl { get; set; }
    public Boolean isLastTab{ get; set;}
    public Boolean isNewContactView { get; set; }
    public Boolean isNewOpportunityTeamMemberView { get; set; }
    public Boolean isOpenThroughLink { get; set; }
    public Boolean isOpportunity { get; set; }
    public Boolean isRecommendationTab { get; set; }
    public Boolean isRelatedListView { get; set; }
    public Boolean isReviewPrint { get; set; }
    public Boolean isSaveAndNext;
    public Boolean isShowHidePrePostText { get; set; }
    public Boolean isUser { get; set; }
    public Boolean isViewRecordLink { get; set; }
    public Boolean showPendingOpportunityTeamMembers { get; set; }
    public Campaign campaign { set; get; }
    public Contact newContact { get; set; }
    public Contact userContact { get; set; }
    public Id applicationConsultant;
    public List<Account> lstAccounts { get; set; }
    public List<Questions__c> lstQuestions { get; set; }
    public List<Questions__c> requiredQuestionErrors { get; set; } {requiredQuestionErrors = new List<Questions__c>();}
    public List<Quiz_Questions__c> quizQuestionList { set; get; }
    public List<Quiz_Questions__c> quizQuestionListForOTM { set; get; }
    public List<Related_List_Controller__c> tabsList { get; set; }
    public List<ReviewPage> reviewPageList { set; get; }
    public List<Schema.FieldSetMember> lstFieldSetMember { get; set; }
    public List<SelectOption> lstAvailableContactRoles { get; set; }
    public List<SelectOption> lstOpportunityAccessLevels { get; set; }
    public List<SelectOption> lstSelectedContactRoles { get; set; }
    public List<SelectOption> lstUsersPicklistValues { get; set; }
    public List<SelectOption> remainingOptions { get; set; }
    public List<SelectOption> selectedContactRoles { get; set; }
    public List<String> additionalContacRoles { get; set; }
    public List<String> lstCstObjFields { get; set; }
    public List<String> lstFieldLabels { get; set; }
    public List<User> lstUser;
    public Map<Id, CustomHTML__c> mapCustomHtml { get; set; }
    public Map<Id, List<AttachmentsWrapper>> mapQuestionAttachments { get; set; }
    public Map<Id, String> mapUserOppAccessLevel { get; set; }
    public Map<Questions__c, Id> mapQueToQueAttachment { get; set; }
    public Map<String , Map<String,String>> mapSobjectIdToMapFieldTranslations { get; set; }
    public Map<String, ApplicationAttachments> mapApplicationAttachments { get; set; }
    public Map<String, FeedAttachment> mapApplicationFeedAttachments { get; set; }
    public Map<String, List<String>> mapTabIdLstCstPrflFldLbls { get; set; }
    public Map<String, List<sObject>> mapTabIdAndLstCstmPrflTbRcrds { get; set; }
    public Map<String, List<sObject>> mapTbIdToMapClnIdnObjRcrds { get; set; }
    public Map<String, Map< String, String>> mapTabIdLstCstPrflFldLblsAndAPINames { get; set; }
    public Map<String, Set<String>> mapObjNameLstFields { get; set; }
    public Map<String, String> mapOTMolePicklistEnrties { get; set; }
    public Map<String, sObject> mapObjNameObjDetails { get; set; }
    public Map<String,String> mapCstObjFldsLblsAndNames { get; set; }
    public Map<String,String> mapFieldLabelsAndNames { get; set; }
    public Map<String,String> mapRequiredField { get; set; }
    public OTMOCRWrapper otmWrapperGlbl { get; set; }
    public Object objUser { get; set; }
    public Object relatedListRecordObject  { get; set; }
    public OpportunityTeamMember newOpportunityMember { get; set; }
    public PortalUserRequestTeamMembers__c portalUserRequestTeamMember { get; set; }
    public Portal_User__c inviteOppTeamMember { get; set; }
    public Portal_User__c newOpportunityMemberPortalUser { get; set; }
    public Question_Attachment__c questionAttachment { get; set; }
    public Quiz__c quiz { set; get; }
    public RelatedList portalUserTeamMembersRelatedListConfiguration { get; set; }
    public RelatedList relatedListConfiguration { get; set; }
    public Related_List_Controller__c objCurrentCustomProfileTab { get; set; }
    public Related_List_Controller__c objCurrentCustomProfileTabParent { get; set; }
    public SFDCEncoder objSFDCEncoder = new SFDCEncoder();
    public SObject application { set; get; }
    public SObject tabObject { get; set; }
    //public Set<String> requiredQuestions;
    public Set<String> setApplicationFields;
    public Set<String> setAttachmentQuestionList { set; get; }
    public String appStage { get; set; }
    public String applicationAccessLevel;
    public String applicationId { get; set; }
    public String attachedQuestionId { get; set; }
    public String campaignRecordTypeName { get; set; }
    public String convertedLeadId { get; set; }
    public String currentParentObject { get; set; }
    public String currentTabType { get; set; }
    public String iFrameURL { get; set; }
    public String mode { get; set; }
    public String nameAttachment { get; set; }
    public String nextTabID { get; set; }
    public String objectType { get; set; }
    public String portalLanguage { get; set; }
    public String selectedTab { set; get; }
    public String strApplicationMode { get; set; }
    public String strBudgetEndDate { get; set; }
    public String strBudgetStartDate { get; set; }
    public String strDateTime { get; set; }
    public String strDesc { get; set; }
    public String strDuplicateUserFoundErrorMessage { get; set; }
    public String strFields { get; set; }
    public String strIquiryTabName { get; set; }
    public String strLOICampaignField { get; set; }
    public String strOtmAccessLevel { get; set; }
    public String strRLCObjectName { get; set; }
    public String strRequestCampaignField { get; set; }
    public String strSelectedId { get; set; }
    public String strSelectedTabId { get; set; }
    public String strSelectedappId { get; set; }
    public String tabName { get; set; }
    public String tabRecordId;
    public String teamMemberRole;
    public String teamRole { get; set; }
    public String urlParamFrom { get; set; }
    public User objLOISubmittedBy { get; set; }
    public User user { get; set; }
    public sObject applicationOnReview { get; set; }
    public sObject objCurrentCustomObjectRecord { get; set; }

    public static ApplicationAttachments applicationAttachment { get; set; }
    public static Boolean isAdditionalRoleInQuizQuestion = false;
    public static Boolean isTeamRoleInQuizQuestion = false;
    public static final STRING APPLICANT = 'Applicant';
    public static final STRING CONVERTED_STATUS_VALUE = 'Converted';
    public static final STRING NOTSUBMITTED = 'NotSubmitted';
    public static final STRING SUBMITTED_STATUS_VALUE = 'Submitted';

    public Boolean isIndividual { get; set; }
    public Boolean isOrganizationEditable { get; set; }
    public Boolean isContactEditable { get; set; }
    public Related_List_Controller__c organizationTabInstructions { get; set; }
    public Related_List_Controller__c contactTabInstructions { get; set; }

    //For Grantee Budget
    public Boolean isBudgetExist { get; set; }
    public Boolean isBudgetGenerated { get; set; }
    public Boolean isGranteeBudget { get; set; }
    public String dateFrom { get; set; }
    public String dateTo { get; set; }
    private List<Budget> lstBudgets;
    private List<String> lstYears;

    @TestVisible
    private transient AdminContextExecutionManager adminContextExecutionManagerInstance;

    /** 
     * Use this method to access an instance of the AdminContextExecutionManager service.
     * The instance is stored in transient AdminContextExecutionManager adminContextExecutionManagerInstance,
     * so adminContextExecutionManagerInstance isn't stored in the View State.
     * 
     * In unit tests, set adminContextExecutionManagerInstance as a stub before testing getAdminContextExecutionManager().
     * @return instance of AdminContextExecutionManager service
     */
    @TestVisible
    private AdminContextExecutionManager getAdminContextExecutionManager() {
        if (this.adminContextExecutionManagerInstance == null) {
            this.adminContextExecutionManagerInstance = new AdminContextExecutionManager();
        }
        return this.adminContextExecutionManagerInstance;
    }

    @TestVisible
    private transient CrudFlsService crudFlsServiceInstance;

    /** 
     * Use this method to access an instance of the CrudFlsService service.
     * The instance is stored in transient CrudFlsService crudFlsServiceInstance,
     * so crudFlsServiceInstance isn't stored in the View State.
     * 
     * In unit tests, set crudFlsServiceInstance as a stub before testing getCrudFlsService().
     * @return instance of CrudFlsService service
     */
    @TestVisible
    private CrudFlsService getCrudFlsService() {
        if (this.crudFlsServiceInstance == null) {
            this.crudFlsServiceInstance = new CrudFlsService();
        }
        return this.crudFlsServiceInstance;
    }

    /**
     * @description This is a getter setter to check if file discription is
     * enabled in community setting record.
     */
    public Boolean isFileDescriptionEnabled {
        get {
            return isCommunitySettingEnabled('IsAttachmentDescriptionEnabled');
        }
    }

    /**
     * @description This is a getter setter to check if org name is editable is
     * enabled in community setting record.
     */
    public Boolean isOrgNameEditable {
        get {
            return isCommunitySettingEnabled('IsOrgNameEditable');
        }
    }

    /**
     * @description This is a getter setter to check if team role value for
     * invite otm pop-up is required.
     */
    public Boolean isTeamRoleFieldRequired {
        get {
            return isCommunitySettingEnabled('IsTeamRoleRequired');
        }
    }

    private Boolean isCommunitySettingEnabled(String settingName) {
        CommunitySetting__c communitySetting = CommunitySetting__c.getInstance(
            settingName
        );

        return (communitySetting != null && communitySetting.IsEnabled__c);
    }

    /**
     * @description Picklist for opportunity Team Member TeamRole
     */
    public String selectedTeamRoleVal { get; set; }

    
    /**
     * @description cached Global Describe sObjectType map.
     */
    Transient Map<String, Schema.SObjectType> objectTypeMap {
        private get {
            if (objectTypeMap == null) {
              objectTypeMap = Schema.getGlobalDescribe();
            }
            return objectTypeMap;
        }
        private set;
    }


    @RemoteAction
    public static List<AttachmentUploadManager.AttachmentWrapper> getAttachments(String recordId, String lookupFieldApiName, String lookupFieldValue) {
        return AttachmentUploadManager.getAttachments(
            recordId,
            lookupFieldApiName,
            lookupFieldValue);
    }

    @RemoteAction
    public static Database.SaveResult insertAndUpdateContentDocumentLink(String recordId, String contentDocumentId, String cntntDcmntDscrptn, String shareType) {
        return AttachmentUploadManager.insertAndUpdateContentDocumentLink(
            recordId,
            contentDocumentId,
            cntntDcmntDscrptn,
            shareType);
    }

    @RemoteAction
    public static List<Database.DeleteResult> deleteAttachments(String strAPIName, List<String> lstJSONObject, string questionAttachmentId) {
        return AttachmentUploadManager.deleteAttachments(
            strAPIName,
            lstJSONObject,
            questionAttachmentId
        );
    }

    @RemoteAction
    public static AttachmentUploadManager.AttachmentComponentSettingsWrapper getAttachmentComponentSettings(Boolean isEditable, String baseUrl, String locale, String apiVersion) {
        return new AttachmentUploadManager.AttachmentComponentSettingsWrapper(
            isEditable,
            baseUrl,
            locale,
            apiVersion
        );
    }

    @RemoteAction
    public static AttachmentUploadManager.ApplicationQuestionWrapper getApplicationRecord(String lookupFieldApiName, String lookupFieldValue) {
        return AttachmentUploadManager.getApplicationRecord(
            lookupFieldApiName,
            lookupFieldValue
        );
    }

    /**
     * Private, empty constructor to use in unit tests.   All variables must be set manually.
     */
    @TestVisible
    private CommunityApplicationExtension() {
    }

    /**
     * @description This is a constructor to fetch the campaign record from
     * controller.getId() and initialize the properties.
     */
    public CommunityApplicationExtension(ApexPages.StandardController controller) {
        additionalContacRoles = new List<String>();
        isNewContactView = false;
        isUser = false;
        isContact = false;
        setApplicationFields = new Set<String>();
        objLOISubmittedBy = new User();
        isOpenThroughLink = false;
        selectedContactRoles = new List<SelectOption>();
        urlParamFrom = Apexpages.currentPage().getParameters().get('from');
        mapRequiredField = new Map<String, String>();
        mapOTMolePicklistEnrties = SchemaEngine.getOpportunityTeamMemberPicklistEntries();
        List<ObjectPermissions> lstObjectPermissions;
        List<Campaign> lstobjCampaign;
        List<RecordTypeLocalization> lstRecordTypeLocalization;
        mapSobjectIdToMapFieldTranslations = new Map<String , Map<String,String>>();

        try {
            if (!Test.isRunningTest()) {
                if (ApexPages.currentPage().getHeaders().get('USER-AGENT').indexOf('Trident') >= 0) {
                    if (ApexPages.currentPage().getHeaders().get('USER-AGENT').indexOf('rv:11') >= 0 || ApexPages.currentPage().getHeaders().get('USER-AGENT').indexOf('MSIE 10.0') >= 0) {
                        isIExplorer = true;
                    }
                } else {
                    isIExplorer = false;
                }
            }

            bIsSCPLEnable = Account.getSobjectType().getDescribe().fields.getMap().keySet().contains('billingcountrycode');
            isOrganizationEditable = false;
            isContactEditable = false;

            lstObjectPermissions = [
                SELECT
                    PermissionsEdit,
                    PermissionsRead,
                    SObjectType
                FROM ObjectPermissions
                WHERE ParentId IN (
                    SELECT Id
                    FROM PermissionSet
                    WHERE ProfileId = :UserInfo.getProfileId()
                )
                AND (
                    SObjectType = 'Account'
                    OR SObjectType = 'Contact'
                )
            ];

            if (lstObjectPermissions != null && lstObjectPermissions.size() > 0) {
                for (ObjectPermissions objPermission : lstObjectPermissions) {
                    if (objPermission.SObjectType == 'Account') {
                        isOrganizationEditable = (objPermission.PermissionsRead && objPermission.PermissionsEdit);
                    }
                    if (objPermission.SObjectType == 'Contact') {
                        isContactEditable = (objPermission.PermissionsRead && objPermission.PermissionsEdit);
                    }
                }
            }

            isInvalidAppl = false;

            if (ApexPages.currentPage().getParameters().get('Id') == null) {
                isInvalidAppl = true;
            }

            this.controller = controller;
            strBudgetStartDate = '';
            strBudgetEndDate = '';
            isReviewSubmitPage = false;
            isConsultant = false;
            isIFrame  = false;
            questionAttachment = new Question_Attachment__c();

            user = [
                SELECT
                    Contact.Account.Name,
                    Contact.AccountId,
                    ContactId,
                    ProfileType__c
                FROM User
                WHERE Id = :UserInfo.getUserId()
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            if (user != null && user.ProfileType__c != null) {
                if (user.ProfileType__c.equalsIgnoreCase('Organization')) {
                    isIndividual = false;
                } else {
                    isIndividual = true;
                }
            } else {
                isIndividual = true;
            }

            FCGlobal.UserSession userSession = FCGlobal.getUserSession(UserInfo.getUserId());
            portalLanguage = userSession.UserLanguage;
            FCGlobal.setUserLanguage(UserInfo.getUserId(), portalLanguage);
            isFeedAttachmentEnabled = false;

            if (!String.isBlank(getparam('appID'))) {
                strSelectedappId = getparam('appID');
            }

            // Change starts. By - Pranav Sanvatsarkar. Issue # FCPROD-321/1198. Record Types are not converted using translation workbench. They need to be fetched from localization records.
            if (controller.getId() != null) {
                lstobjCampaign = [
                    SELECT
                        RecordType.Id,
                        RecordType.Name
                    FROM Campaign
                    WHERE Id = :controller.getId()
                    WITH SECURITY_ENFORCED
                    LIMIT 1
                ];

                lstRecordTypeLocalization = [
                    SELECT Value
                    FROM RecordTypeLocalization
                    WHERE Parent.Id = :lstobjCampaign[0].RecordType.Id
                    AND Language = :portalLanguage
                    WITH SECURITY_ENFORCED
                ];

                if (lstRecordTypeLocalization != null && !lstRecordTypeLocalization.isEmpty()) {
                    campaignRecordTypeName = lstRecordTypeLocalization[0].Value;
                } else {
                    campaignRecordTypeName = lstobjCampaign[0].RecordType.Name;
                }
            }
            // Change ends

            initalizePortalFeedAttachment(portalLanguage);

            mapOCRPicklistEntries = SchemaEngine.getOpportunityContactRolePicklistEntries();
            mapOTMPicklistEntries = SchemaEngine.getOpportunityTeamMemberPicklistEntries();
        } catch (Exception ex) {
            System.debug('Exception: ' + ex + 'at Line: ' + ex.getLineNumber() + ' stackTrace: ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, '' + ex.getMessage()));
        }
    }

    /**
     * @description This function will return url list of OTM records to be
     * shown on OTM RLC
     */
    public List<Object> fetchListOTMWrapper(List<object> childObject, String applicationId) {
        Map<Id, OTMOCRWrapper> mapUserOrContactIdWthWrppr = new Map<Id, OTMOCRWrapper>();

        List<OpportunityContactRole> lstContactRoles = [
            SELECT
                ContactId,
                OpportunityId,
                Role
            FROM OpportunityContactRole
            WHERE OpportunityId = :applicationId
            AND Role != null
            WITH SECURITY_ENFORCED
        ];

        Map<Id, Set<String>> mapIdSetRoles = new Map<Id, Set<String>>();
        Map<Id, Id> mapContactToContactRoleId = new Map<Id, Id>();
        Map<Id, OpportunityTeamMember> mapUserIdWthTeamMember = new Map<Id, OpportunityTeamMember>();

        if (!childObject.isEmpty()) {
            for (OpportunityTeamMember otm : (List<OpportunityTeamMember>) childObject) {
                if (otm.ContactRoleID__c != null) {
                    mapContactToContactRoleId.put(otm.User.ContactId, otm.ContactRoleID__c);
                }
            }
        }

        if (!lstContactRoles.isEmpty()) {
            Set<Id> ocrkeyset = new Set<Id>();
            List<Id> ocrvalues = new List<Id>();
            ocrvalues = mapContactToContactRoleId.values();
            ocrkeyset.addAll(ocrvalues);

            for (OpportunityContactRole ocr : lstContactRoles) {
                Set<String> setRoles = new Set<String>();

                if (!mapIdSetRoles.isEmpty() && mapIdSetRoles.get(ocr.ContactId) != null) {
                    setRoles = mapIdSetRoles.get(ocr.ContactId);
                }

                if (!ocrkeyset.contains(ocr.id) && strRLCObjectName == 'OpportunityTeamMember') {
                    setRoles.add(ocr.Role);
                }

                mapIdSetRoles.put(ocr.ContactId, setRoles);
            }
        }

        Map<Id, Id> mapContactIdWthUserId = new Map<Id, Id>();

        if (!childObject.isEmpty()) {
            if (mapUserOppAccessLevel == null) {
                mapUserOppAccessLevel = new Map<Id, String>();
            }

            for (OpportunityTeamMember otm : (List<OpportunityTeamMember>) childObject) {
                mapUserIdWthTeamMember.put(otm.UserId, otm);

                if (otm.User.ContactId != null) {
                    mapContactIdWthUserId.put(otm.User.ContactId, otm.UserId);
                }

                mapUserOppAccessLevel.put(otm.UserId, otm.OpportunityAccessLevel);
            }
        } else {
            mapUserOppAccessLevel = null;
        }

        if (!lstContactRoles.isEmpty()) {
            for (OpportunityContactRole ocr : lstContactRoles) {
                OTMOCRWrapper otmOcrWrapper;
                String referenceId;

                if (!mapContactIdWthUserId.isEmpty() && mapContactIdWthUserId.get(ocr.ContactId) != null) {
                    referenceId = mapContactIdWthUserId.get(ocr.ContactId);
                    OpportunityTeamMember otm = mapUserIdWthTeamMember.get(referenceId);
                    otmOcrWrapper = new OTMOCRWrapper(otm, ocr, mapIdSetRoles.get(ocr.ContactId), true);
                    otmOcrWrapper.UserId = otm.UserId;
                    otmOcrWrapper.ContactId = ocr.ContactId;
                    otmOcrWrapper.OpportunityId = otm.OpportunityId;
                    mapUserOrContactIdWthWrppr.put(referenceId, otmOcrWrapper);
                } else {
                    referenceId = ocr.ContactId;
                    otmOcrWrapper = new OTMOCRWrapper(null, ocr, mapIdSetRoles.get(ocr.ContactId), false);
                    otmOcrWrapper.ContactId = ocr.ContactId;
                    otmOcrWrapper.OpportunityId = ocr.OpportunityId;
                    mapUserOrContactIdWthWrppr.put(referenceId, otmOcrWrapper);
                }
            }
        }

        if (!childObject.isEmpty()) {
            for (OpportunityTeamMember otm : (List<OpportunityTeamMember>) childObject) {
                String referenceId = otm.UserId;

                if (mapUserOrContactIdWthWrppr.get(referenceId) == null) {
                    OTMOCRWrapper otmOcrWrapper = new OTMOCRWrapper(otm, null, null, (otm.User.ContactId != null));
                    otmOcrWrapper.UserId = otm.UserId;
                    otmOcrWrapper.ContactId = otm.User.ContactId;
                    otmOcrWrapper.OpportunityId = otm.OpportunityId;
                    if (otm.User.ContactId != null) {
                        // adding if condition so internal user will not shown on OTM list
                        mapUserOrContactIdWthWrppr.put(referenceId, otmOcrWrapper);
                    }
                }
            }
        }

        return mapUserOrContactIdWthWrppr.values();
    }

    /**
     * @description This function will set the value of Team role and
     * additional Role values based on the user selected in search and Add
     */
    public void setUsrDpndntPrmtrsFrOTM() {
        try {
            Id currUserId = null;
            String opportunityId = null;
            Id strUserId = getParam('userId');
            List<User> lstUsers;
            List<OpportunityTeamMember> lstOpportunityTeamMembers;
            List<OpportunityContactRole> lstContactRoles;
            String strQuery = 'SELECT Id, ContactId FROM User WHERE Id = :strUserId WITH SECURITY_ENFORCED';
            lstUsers = (List<User>) Database.query(strQuery);

            currUserId = lstUsers[0].Id;
            opportunityId = (String) application.get('id');

            otmWrapperGlbl = null;
            tabObject = (sObject) FCGlobal.getNewSobject(relatedListConfiguration.strRelatedListObject);

            if (strUserId != null) {
                tabObject.put('UserId', strUserId);
            }

            if (lstSelectedContactRoles != null) {
                lstSelectedContactRoles.clear();
            } else {
                lstSelectedContactRoles = new List<SelectOption>();
            }

            if (lstAvailableContactRoles != null) {
                lstAvailableContactRoles.clear();
            } else {
                lstAvailableContactRoles = new List<SelectOption>();
            }

            if (lstUsers != null && !lstUsers.isEmpty()) {
                // @todo jbury why is this a dynamic query?
                strQuery = 'Select Id, TeamMemberRole, OpportunityAccessLevel, FGM_Portal__ContactRoleID__c , UserId, OpportunityId, User.ContactId ';
                strQuery += ' FROM OpportunityTeamMember WHERE UserId = :currUserId AND OpportunityId = :opportunityId WITH SECURITY_ENFORCED' ;

                lstOpportunityTeamMembers = (List<OpportunityTeamMember>) Database.Query(strQuery);

                Set<String> setTeamRoles = new Set<String>();
                OpportunityTeamMember opportunityTeamMember;

                if (lstOpportunityTeamMembers != null && !lstOpportunityTeamMembers.isEmpty()) {
                    opportunityTeamMember = lstOpportunityTeamMembers[0];

                    for (OpportunityTeamMember opptm : lstOpportunityTeamMembers) {
                        setTeamRoles.add(opptm.TeamMemberRole);
                    }
                }

                if (opportunityTeamMember != null) {
                    opportunityTeamMember.Id = null;
                    tabObject = (sObject) opportunityTeamMember;
                    strOtmAccessLevel = opportunityTeamMember.OpportunityAccessLevel;
                }

                if (lstUsers[0].ContactId != null) {

                    lstContactRoles = [
                        SELECT Role
                        FROM OpportunityContactRole
                        WHERE ContactId = :lstUsers[0].ContactId
                        AND OpportunityId = :application.Id
                        WITH SECURITY_ENFORCED
                    ];

                    Set<String> setSelectedRoles = new Set<String>();
                    Map<String, String> mapOCRolePicklistEnrties = SchemaEngine.getOpportunityContactRolePicklistEntries();

                    for (OpportunityContactRole ocr : lstContactRoles) {
                        if (!setTeamRoles.contains(ocr.Role)) {
                            lstSelectedContactRoles.add(new SelectOption(ocr.Role, mapOCRolePicklistEnrties.get(ocr.Role)));
                            setSelectedRoles.add(ocr.Role);
                        }
                    }

                    otmWrapperGlbl = new OTMOCRWrapper(null, null, null, true);

                    otmWrapperGlbl.OCR = (!lstContactRoles.isEmpty()) ? lstContactRoles[0] : null;
                    lstAvailableContactRoles = getContactRolesConfig(setSelectedRoles);
                    otmWrapperGlbl.ContactId = lstUsers[0].ContactId;
                } else {
                    otmWrapperGlbl = new OTMOCRWrapper(null, null, null, false);
                }

                otmWrapperGlbl.UserId = lstUsers[0].Id;
            }
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ' ' + ex.getMessage()));
        }
    }

    /**
     * @description This function will set the value of Flags to cancel the
     * view operation and show the table again
     */
    public void cancelViewRecord() {
        bIsCstObjRecordEditable = false;
        objCurrentCustomObjectRecord = null;
        isNewContactView = false;
        newContact = null;
    }

    /**
     * @description This function will create set the Sobject type record of
     * type mentioned in custom profile's object name.
     */
    public void createNwCstmPrflRcrd() {
        try{
            Related_List_Controller__c tabrecord = getTabRecord();
            
            Schema.SObjectType sObjTp = objectTypeMap.get(tabrecord.ObjectName__c);
            objCurrentCustomObjectRecord = sObjTp.newSobject();
            mapCstObjFldsLblsAndNames = SchemaEngine.getFieldsFromFieldSet(tabrecord.ObjectName__c, tabrecord.Cloned_from__r.Name);
            lstFieldSetMember = SchemaEngine.getlstFieldsFromFieldSet(tabrecord.ObjectName__c, tabrecord.Cloned_from__r.Name);
            tabName = tabrecord.ObjectName__c;

            if (mapCstObjFldsLblsAndNames != null) {
                lstCstObjFields = new List<String>();
                for (String strField : mapCstObjFldsLblsAndNames.keySet()) {
                    lstCstObjFields.add(strField);
                }
            }

            bIsCstObjRecordEditable = null;
        } catch (Exception ex) {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ' ' + ex.getMessage() ));
        }
    }

    /**
     * @description This function will be called in case of edit and view
     * operation on Related list tab.
     */
    public void viewRecord() {
        try {
            sObject selectedRecord = getSelectedTabObject();
            Related_List_Controller__c tabrecord = getTabRecord();

            if (selectedRecord != null && tabrecord != null) {
                tabObject = selectedRecord;
                mapCstObjFldsLblsAndNames = SchemaEngine.getFieldsFromFieldSet(tabrecord.ObjectName__c, tabrecord.Cloned_from__r.Name);
                lstFieldSetMember = SchemaEngine.getlstFieldsFromFieldSet(tabrecord.ObjectName__c, tabrecord.Cloned_from__r.Name);

                Schema.SObjectType sot = objectTypeMap.get(
                    tabrecord.ObjectName__c
                );

                if (sot == null) {
                    return;
                }

                List<String> fieldPaths = new List<String>();

                for (Schema.FieldSet fs : sot.getDescribe().fieldSets.getMap().values()) {
                    if (!fs.getLabel().equalsIgnoreCase(tabrecord.Cloned_from__r.Name)) {
                        continue;
                    }
                    for (Schema.FieldSetMember fsm : fs.getFields()) {
                        fieldPaths.add(fsm.getFieldPath());
                    }
                }

                Id selectedRecordId = selectedRecord.Id;
                if (!fieldPaths.isEmpty()) {
                    String strQuery = String.format(
                        'SELECT {0} FROM {1} WHERE Id = :selectedRecordId WITH SECURITY_ENFORCED',
                        new List<String>{
                            String.join(fieldPaths, ', '),
                            sot.getDescribe().getName()
                        }
                    );

                    objCurrentCustomObjectRecord = Database.query(strQuery)[0];

                    tabName = tabrecord.FGM_Portal__ObjectName__c;
                }
            }
        } catch (Exception ex) {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ' ' + ex.getMessage() ));
        }
    }

    /**
     * @description This function will be called in case of update and insert
     * of custom profile tab record.
     */
    public void saveCstPrflRcrd() {
        try {
            if (this.objCurrentCustomObjectRecord != null) {
                Database.SaveResult saveResult;
                Boolean bIsUpdate = false;

                if (this.objCurrentCustomObjectRecord.Id != null) {                    
                    final SObject strippedCurrentCustomObjectRecord = this.getCrudFlsService().stripInaccessibleForUpdate(new List<SObject> {
                        this.objCurrentCustomObjectRecord
                    })[0];
                    saveResult = Database.update(strippedCurrentCustomObjectRecord, true);
                    bIsUpdate = true;
                } else {
                    if (this.objCurrentCustomObjectRecord.get(this.objCurrentCustomProfileTab.LookupField__c ) == null) {
                        this.objCurrentCustomObjectRecord.put(
                            this.objCurrentCustomProfileTab.LookupField__c, 
                            this.user.Contact.AccountId
                        );
                    }

                    CrudFlsService.getInstance().assertCreateable(this.objCurrentCustomObjectRecord);
                    saveResult = Database.insert(this.objCurrentCustomObjectRecord, true);
                }

                if (saveResult.isSuccess()) {
                    this.cancelViewRecord();
                } else {
                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.Error, 
                        ' ' + saveResult.getErrors()
                    ));
                }
            }
        } catch (Exception ex) {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.Error, 
                ' ' + ex.getMessage()
            ));
        }
    }

    /**
     * @description This function will be called in case of delete of custom
     * profile tab record.
     */
    public void deleteCstPrflRcrd() {
        try {
            sObject selectedRecord = getSelectedTabObject();
            if ( selectedRecord != null) {
                CrudFlsService.getInstance().assertDeletable(selectedRecord);
                Database.DeleteResult dltRslt = Database.delete(selectedRecord, true);
                if (dltRslt.isSuccess()) {
                    cancelViewRecord();
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ' ' + dltRslt.getErrors()));
                }
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, System.Label.FC_ConfigurationProcess_ErrorMsg));
            }
        } catch (Exception ex) {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ' ' + ex.getMessage() ));
        }
    }

    /**
     * @description This function will be called to get the RLC record with the
     * index value in case of edit and view record.
     */
    public sObject getSelectedTabObject() {
        try {
            String strRecordIndex = getParam('recordIndex');
            if (strRecordIndex != null && mapTbIdToMapClnIdnObjRcrds != null) {
                List<sObject> lstSObjects = mapTbIdToMapClnIdnObjRcrds.get(selectedTab);
                if (lstSObjects != null && !lstSObjects.isEmpty()) {
                    Integer recordIndex = Integer.valueOf(strRecordIndex);
                    if (recordIndex != null && recordIndex < lstSObjects.size()) {
                        Object oldrelatedlistRecord = mapTbIdToMapClnIdnObjRcrds.get(selectedTab)[recordIndex];
                        if (oldrelatedlistRecord != null) {
                            sObject record = (sObject) oldrelatedlistRecord;
                            if (record != null) {
                                return record;
                            }
                        }
                    }
                }
            }
        } catch (Exception ex) {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ' ' + ex.getMessage() ));
        }

        return null;
    }

    /**
     * @description This function is to set the tabrecord value of current tab
     * by iterating on tablist.
     */
    public Related_List_Controller__c getTabRecord() {
        try {
            if (String.isNotBlank(selectedTab) && tabsList != null && !tabsList.isEmpty()) {
                for (Related_List_Controller__c tabRecord : tabsList) {
                    if (selectedTab.equalsIgnoreCase(String.valueOf(tabRecord.Id))) {
                        return tabRecord;
                    }
                }
            }
        } catch (Exception ex) {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ' ' + ex.getMessage() ));
        }

        return null;
    }

    public void fetchClndCstmPrflRcrds() {
        try {
            if (objCurrentCustomProfileTabParent != null && objCurrentCustomProfileTabParent.objectName__c != null) {
                Related_List_Controller__c lstRelatedCstmProfileTab = new Related_List_Controller__c();
                mapTbIdToMapClnIdnObjRcrds = new Map<String, List<sObject>>();
                mapFieldLabelsAndNames = getrelatedListColumn(objCurrentCustomProfileTab);
                lstFieldLabels = new List<String>();

                List<User> lstLoggedInUser = [
                    SELECT Contact.AccountId
                    FROM User
                    WHERE Id = :UserInfo.getUserId()
                    WITH SECURITY_ENFORCED
                ];

                for (String strLabel : mapFieldLabelsAndNames.keySet()) {
                    if (!strLabel.equalsIgnoreCase('id')) {
                        lstFieldLabels.add(strLabel);
                    }
                }

                List<String> lstFldApiNms = new List<String>();
                lstFldApiNms = mapFieldLabelsAndNames.values();

                if (!lstLoggedInUser.isEmpty()) {
                    lstRelatedCstmProfileTab = [
                        SELECT
                            SortField__c,
                            SortFieldOrder__c
                        FROM Related_List_Controller__c
                        WHERE Id = :objCurrentCustomProfileTabParent.Cloned_from__c
                        WITH SECURITY_ENFORCED
                        LIMIT 1
                    ];

                    String order;
                    String sortOredrField  = lstRelatedCstmProfileTab.SortField__c;

                    if (lstRelatedCstmProfileTab.SortFieldOrder__c != null) {
                        order = lstRelatedCstmProfileTab.SortFieldOrder__c == 'Ascending' ? 'ASC' : 'DESC';
                    }

                    String sanitizedObjectName = objCurrentCustomProfileTabParent.objectName__c.replaceAll('[^0-9a-zA-Z_.]', '');
                    String sanitizedLookupFieldName = objCurrentCustomProfileTabParent.LookupField__c.replaceAll('[^0-9a-zA-Z_.]', '');

                    List<String> sanitizedFieldApiNms = new List<String>();

                    for (String f : lstFldApiNms) {
                        sanitizedFieldApiNms.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                    }

                    String orderClause = '';

                    if (sortOredrField != null && !String.isBlank(sortOredrField)) {
                        String sanitizedOredrField = sortOredrField.replaceAll('[^0-9a-zA-Z_.]', '');
                        if (order != null) {
                            orderClause = String.format(
                                'ORDER BY {0} {1}',
                                new List<String>{
                                    sanitizedOredrField,
                                    order
                                }
                            );
                        } else {
                            orderClause = String.format(
                                'ORDER BY {0}',
                                new List<String>{
                                    sanitizedOredrField
                                }
                            );
                        }
                    }

                    String limitClause = '';

                    if (objCurrentCustomProfileTabParent.of_records_to_display__c > -1) {
                        limitClause = String.format(
                            'LIMIT {0}',
                            new List<String>{
                                String.valueOf(objCurrentCustomProfileTabParent.of_records_to_display__c)
                            }
                        );
                    }

                    String userAccountId = lstLoggedInUser[0].Contact.AccountId;

                    String strQuery = String.format(
                        'SELECT {0} FROM {1} WHERE {2} = :userAccountId WITH SECURITY_ENFORCED {3} {4}',
                        new List<String>{
                            String.join(sanitizedFieldApiNms, ', '),
                            sanitizedObjectName,
                            sanitizedLookupFieldName,
                            orderClause,
                            limitClause
                        }
                    );
                    mapTbIdToMapClnIdnObjRcrds.put(objCurrentCustomProfileTabParent.Id, Database.query(strQuery));                    
                }
            }
        } catch (Exception ex) {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ' ' +  ex.getMessage()  ));
        }
    }

    public List<sObject> getRLCRecordFromMap() {
        List<sObject> lstRlcRecord = new List<sObject>();
        try {
            fetchClndCstmPrflRcrds();
            if (mapTbIdToMapClnIdnObjRcrds != null && mapTbIdToMapClnIdnObjRcrds.get(selectedTab) != null) {
                return (List<sObject>) mapTbIdToMapClnIdnObjRcrds.get(selectedTab);
            }
        } catch (Exception ex) {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, '' + ex.getMessage() ));
        }

        return lstRlcRecord;
    }

    /**
     * @description This function is to set the fields from fieldset for
     * individual and organization type user's contact.
     */
    public void getContactRecord() {
        List<User> lstUser;
        userContact = new Contact();
        string strQuery;
        List<Contact> lstContacts;
        List<Schema.fieldSetMember> lstContactFields = getContactFields();

        if (lstContactFields != null && !lstContactFields.isEmpty()) {
            Set<String> setContactFields = new Set<String>();

            for (Schema.FieldSetMember fldStMmbr : lstContactFields) {

                if (!'Id'.equalsIgnoreCase(fldStMmbr.getFieldPath())) {
                    String fieldName = fldStMmbr.getFieldPath();
                    if (bIsSCPLEnable && (fieldName == 'MailingCountry' || fieldName == 'MailingState' || fieldName == 'OtherCountry' || fieldName == 'OtherState')) {
                        setContactFields.add(fieldName+'Code');
                    } else {
                        setContactFields.add(fieldName);
                    }
                }
            }

            if (!setContactFields.isEmpty()) {
                lstUser = [
                    SELECT
                        Contact.Id,
                        Contact.AccountId
                    FROM User
                    WHERE Id = :UserInfo.getUserId()
                    WITH SECURITY_ENFORCED
                ];

                if (lstUser != null && !lstUser.isEmpty()) {
                    Id lstUserContactId = lstUser[0].Contact.Id;
                    strQuery = 'SELECT Id, ' + String.join(new List<String>(setContactFields), ', ') +' FROM Contact WHERE Id = :lstUserContactId WITH SECURITY_ENFORCED';
                    lstContacts = Database.Query(strQuery);
                    if (lstContacts != null && !lstContacts.isEmpty()) {
                        userContact = lstContacts[0];
                    }
                }
            }
        }
    }

    /**
     * @description This function is to called on click of cancel and based on
     * from parameter value it redirects user to the page from which user has
     * landed to community application.
     */
    public PageReference cancelApplication() {
        try {
            if (urlParamFrom!=null && urlParamFrom != '') {
                if (urlParamFrom.equalsIgnoreCase('ego')) {
                    if (strSelectedappId == null) {
                        cancelDisplayPopup = false;
                        PageReference ref = new PageReference('/apex/CommunityLanding');
                        return ref;
                    }
                } else if (urlParamFrom.equalsIgnoreCase('dashboard')) {
                    cancelDisplayPopup = false;
                    PageReference ref = new PageReference('/apex/CommunityDashboard');
                    ref.getParameters().put('tab', 'request');
                    return ref;
                }
            }

            mapApplicationAttachments = null;
            cancelDisplayPopup = false;
            PageReference ref = new PageReference('/apex/CommunityDashboard');
            ref.getParameters().put('tab', 'request');
            return ref;
        } catch (Exception ex) {
            system.debug( 'Exception: ' + ex +'at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
            return null;
        }
    }

    /**
     * @description This function is to set the team role options in invite
     * team member pop-up with the additional valus given in Application
     * Ownership role fields of GPS.
     */
    public List<SelectOption> getOppTeamMemberTeamRoleOptions() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = OpportunityTeamMember.TeamMemberRole.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        GlobalPortalSettings__c globalSetting = GlobalPortalSettings__c.getOrgDefaults();

        if (globalSetting != null) {
            String strapplicationOwnerRole = globalSetting.Application_Ownership_Role__c;
            Set<String> setapplicationOwnerRole = FCGlobal.getApplicationOwnerRoleSet(strapplicationOwnerRole);

            if (setapplicationOwnerRole.isEmpty()) {
                setapplicationOwnerRole.add(APPLICANT);
            }

            if (setapplicationOwnerRole.contains(APPLICANT)) {
                options.add(new SelectOption(APPLICANT, APPLICANT));
            }

            for (Schema.PicklistEntry picklistEntry : picklistValues) {
                if (picklistEntry.getValue() != APPLICANT) {
                    if (setapplicationOwnerRole.contains(picklistEntry.getValue())) {
                        options.add(new SelectOption(picklistEntry.getValue(), picklistEntry.getLabel()));
                    }
                }
            }
        }

        return options;
    }

    /**
     * @description This function is to set the team role options in invite
     * team member ad per the picklist values in TeamMemberRole field on OTM
     * object.
     */
    public List<SelectOption> getAllOppTeamMemberTeamRoleOptions() {
        List<SelectOption> options = new List<SelectOption>();
        List<Schema.PicklistEntry> picklistValues = OpportunityTeamMember.TeamMemberRole.getDescribe().getPicklistValues();

        for (Schema.PicklistEntry picklistEntry : picklistValues) {
            options.add(new SelectOption(picklistEntry.getValue(), picklistEntry.getLabel()));
        }

        return options;
    }

    public PageReference getUserTypeStatus() {
        isUser=false;
        isContact=false;
        try {
            Id userSelected = Apexpages.currentPage().getParameters().get('SelectedUserType');

            if (userSelected == null) {
                return null;
            }

            if (String.valueOf(userSelected.getSobjectType()).toLowerCase() == 'user'.toLowerCase()) {
                isUser=true;
                isContact=true;
            } else if(string.valueOf(userSelected.getSobjectType()).toLowerCase() == 'contact'.toLowerCase()) {
                isContact=true;
            }
        } catch (Exception ex) {
            system.debug( 'Exception: ' + ex +'at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
            return null;
        }

        return null;
    }

    /**
     * @description This function is to set existing contact role values in
     * selected section of picklist.
     */
    public List<SelectOption> getExistingContactRoles() {
        List<SelectOption> additionalRoles = new List<SelectOption>();

        if (additionalContacRoles != null) {
            for (String role : additionalContacRoles) {
                additionalRoles.add(new SelectOption(role, role));
            }
        }

        return additionalRoles;
    }

    /**
     * @description This function is to set the opportunity access level
     * picklist value to default read-write instead of read. Read is the
     * default value in standard picklist of OpportunityAccessLevel.
     */
    public List<SelectOption> getOpportunityAccessLevelConfig() {
        List<SelectOption> lstOpportunityAccessLevels = new List<SelectOption>();
        List<Schema.PicklistEntry> lstPicklistValues = objectTypeMap.get('OpportunityShare').newSObject().getSObjectType().getDescribe().fields.getMap().get('OpportunityAccessLevel').getDescribe().getPickListValues();
        Schema.PicklistEntry entryTemp;

        for (Schema.PicklistEntry entry : lstPicklistValues) {
            if (!entry.getValue().equalsIgnoreCase('all') && entry.getValue().equalsIgnoreCase('Edit') && !entry.getValue().equalsIgnoreCase('Read')) {
                lstOpportunityAccessLevels.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }

            if (entry.getValue().equalsIgnoreCase('Read')) {
                entryTemp = entry;
            }
        }

        lstOpportunityAccessLevels.add(new SelectOption(entryTemp.getValue(), entryTemp.getLabel()));

        return lstOpportunityAccessLevels;
    }

    /**
     * @description This function is to set available contact role values by
     * excluding the existing contact role values in selected section of
     * picklist.
     */
    public List<SelectOption> getContactRolesConfig(Set<String> setRolesToExclude) {
        List<SelectOption> lstAvailableRoles = new List<SelectOption>();
        List<Schema.PicklistEntry> lstPicklistValues = objectTypeMap.get('OpportunityContactRole').newSObject().getSObjectType().getDescribe().fields.getMap().get('Role').getDescribe().getPickListValues();

        for (Schema.PicklistEntry entry : lstPicklistValues) {
            if ((setRolesToExclude == null || !setRolesToExclude.contains(entry.getLabel()))) {
                lstAvailableRoles.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
        }

        return lstAvailableRoles;
    }

    /**
     * @description This function is to set the multiselect picklist of
     * additional roles with the role values for OCR object.
     */
    public List<SelectOption> getContactRoles() {
        List<SelectOption> additionalRoles = new List<SelectOption>();
        List<String> lstPickvals = new List<String>();
        List<Schema.PicklistEntry> pickListValues = objectTypeMap.get('OpportunityContactRole').newSObject().getSObjectType().getDescribe().fields.getMap().get('Role').getDescribe().getPickListValues();

        for (Schema.PicklistEntry pklist : pickListValues) {
            lstPickvals.add(pklist.getValue());
            additionalRoles.add(new SelectOption(pklist.getValue(), pklist.getlabel()));
        }

        return additionalRoles;
    }

    /**
     * @description This function is to set the user value of search and add
     * with partner user's in same account and the contacts whose OTM value is
     * unavailable but contact role record is present.
     */
    public List<SelectOption> getPartnerUsers() {
        List<SelectOption> users = new List<SelectOption>();

        String accountId = '';

        if (!Test.isRunningTest()) {
            accountId = user.Contact.accountId;
        }

        List<User> lstUser = new List<User>();
        List<Contact> lstContact = new List<Contact>();

        if (!String.isBlank(accountId)) {
            lstUser = [
                SELECT Name
                FROM User
                WHERE Contact.AccountId = :accountId
                AND IsActive = TRUE
                WITH SECURITY_ENFORCED
                LIMIT 10000
            ];

            lstContact = [
                SELECT
                    Account.Name,
                    AccountId,
                    FirstName,
                    LastName,
                    Name
                FROM Contact
                WHERE AccountId = :accountId
                WITH SECURITY_ENFORCED
            ]; // for contacts that needs to be added in the "UserId" picklist

        }

        // for the contacts associated to the account of the users/ issue1629
        users.add(new SelectOption('', '--None--'));
        List<SelectOption> additionalRoles = getContactRoles();

        for (User objUser : lstUser) {
            users.add(new SelectOption(objUser.Id, objUser.name));
        }

        for (Contact objContact : lstContact) {
            users.add(new SelectOption(objContact.Id, objContact.name));
        }

        return users;
    }

    /**
     * @description This function is to get the object associated with current
     * tab.
     */
    public String getApplicationObjectName() {
        if (tabObject != null) {
            return String.valueOf(tabObject.getsObjectType());
        }
        return null;
    }

    /**
     * @description This method is to hide the pop-up on click of close.
     */
    public void exitOpenApplication() {
        displayPopup = false;
    }

    /**
     * @description This method is to redirect user to dashboard on click of go
     * to dashboard.
     */
    public PageReference redirectUser() {
        PageReference ref = System.Page.CommunityDashboard;
        ref.getParameters().put('tab', 'request');
        ref.setRedirect(true);
        return ref;
    }

    /**
     * @description This method is to count the attachments and files present
     * across question attachment records of all languages.
     */
    public Map<Id, Integer> getAttachmentCount() {
        List<Question_Attachment__c> lstAttachmentRecords;
        List<ContentDocumentLink> lstCDL;
        Map<Id, Integer> mapAttachmentCount = new Map<Id, Integer>();
        Map<Id, Id> mapQuestionAttachToQuestion = new Map<Id, Id>();
        Set<Id> queAttachIds = new Set<Id>();

        String questionAttachmentRelationField = FCGlobal.getRelationalField(currentParentObject, Question_Attachment__c.sObjectType);

        String query = 'SELECT Id, Question__r.Parent_QuestionID__c, (SELECT Name, Id FROM Attachments), Question__c, Description__c FROM Question_Attachment__c Where ' + questionAttachmentRelationField + ' = :applicationId WITH SECURITY_ENFORCED ORDER BY CreatedDate ASC LIMIT 10000';
        lstAttachmentRecords = Database.query(query);

        if (lstAttachmentRecords != null && !lstAttachmentRecords.isEmpty()) {

            for (Question_Attachment__c queAttach : lstAttachmentRecords) {
                queAttachIds.add(queAttach.Id);
                Integer attachCount = 0;
                mapQuestionAttachToQuestion.put(queAttach.Id, queAttach.Question__c);

                if (queAttach.Question__r.Parent_QuestionID__c == null) {
                    if (mapAttachmentCount.get(queAttach.Question__c) != null) {
                        attachCount = mapAttachmentCount.get(queAttach.Question__c);
                    }
                    attachCount = queAttach.Attachments.size() + queAttach.Feeds.size();
                    mapAttachmentCount.put(queAttach.Question__c, attachCount);
                } else {
                    if (mapAttachmentCount.get(queAttach.Question__r.Parent_QuestionID__c) != null) {
                        attachCount = mapAttachmentCount.get(queAttach.Question__r.Parent_QuestionID__c);
                    }
                    attachCount = attachCount + queAttach.Attachments.size() + queAttach.Feeds.size();
                    mapAttachmentCount.put(queAttach.Question__r.Parent_QuestionID__c, attachCount);
                    mapAttachmentCount.put(queAttach.Question__c, attachCount);
                }
            }

            if (!queAttachIds.isEmpty()) {

                lstCDL = [
                    SELECT LinkedEntityId
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId IN :queAttachIds
                    WITH SECURITY_ENFORCED
                ];

                if (!lstCDL.isEmpty()) {
                    Integer cntDocCount = 0;

                    for (ContentDocumentLink cntDoc : lstCDL) {
                        cntDocCount = mapAttachmentCount.get(mapQuestionAttachToQuestion.get(cntDoc.LinkedEntityId));
                        cntDocCount = cntDocCount + 1;
                        mapAttachmentCount.put(mapQuestionAttachToQuestion.get(cntDoc.LinkedEntityId), cntDocCount);
                    }
                }
            }
        }

        return mapAttachmentCount;
    }

    /**
     * @description This method is used to redirect user on
     * CommunityApplicationReview page.
     */
    public PageReference reviewSubmit() {
        try {
            String strCampaignID = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));

            if (String.isNotBlank(strCampaignID) && String.isNotBlank(String.valueOf(application.id)) && String.isNotBlank(String.valueOf(quiz.Id))) {
                PageReference ref = System.Page.CommunityApplicationReview;
                ref.getParameters().put('id', strCampaignID);
                ref.getParameters().put('quizId', quiz.Id);
                ref.getParameters().put('appID', application.Id);

                if (isReviewPrint == true) {
                    ref.getParameters().put('mode', 'view');
                }

                ref.getParameters().put('from', urlParamFrom);
                ref.setRedirect(true);
                return ref;
            }
        } catch (Exception ex) {
            System.debug('Exception : ' + ex.getMessage() + ' @Line number ' + ex.getLineNumber());
        }

        return null;
    }

    /**
     * @description This method is used to redirect user on same page.
     */
    public PageReference backToRecord() {
        try {
            String strCampaignID = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));

            if (String.isNotBlank(strCampaignID) && String.isNotBlank(String.valueOf(application.id)) && String.isNotBlank(String.valueOf(quiz.Id))) {
                PageReference ref = System.Page.CommunityApplication;
                ref.getParameters().put('id', strCampaignID);
                ref.getParameters().put('quizId', quiz.Id);
                ref.getParameters().put('appID', application.Id);

                if (isApplicationSubmitted) {
                    ref.getParameters().put('mode', 'view');
                } else {
                    ref.getParameters().put('mode', 'edit');
                }

                ref.getParameters().put('from', urlParamFrom);
                ref.setRedirect(true);
                return ref;
            }
        } catch (Exception ex) {
            System.debug('Exception : ' + ex.getMessage() + ' @Line number ' + ex.getLineNumber());
        }

        return null;
    }

    /**
     * @description This method is to show warning and errors for fields marked
     * as required from Quiz designer or database. Also, it updates the
     * submitted status and submitted by value of application.
     */
    public PageReference submit() {
        Savepoint savePoint;
        try{
        if (application != null && application.Id != null) {
            Map<Id, Integer> mapAttachmentCount = new Map<Id, Integer>();
            Related_List_Controller__c orgTab;
            Related_List_Controller__c contactTab;
            mapAttachmentCount = getAttachmentCount();

            //Logic to check required field must not be blank before review and submit the application.
            if (tabsList != null && !tabsList.isEmpty()) {
                Map<Id, Related_List_Controller__c> mapTabIdsToName = new Map<Id, Related_List_Controller__c>(tabsList);

                if (quizQuestionList != null && quizQuestionList.size() > 0) {                                        
                    for (Quiz_Questions__c quizQuestion: quizQuestionList) {
                        if (quizQuestion.Required__c) {
                            if (quizQuestion.Question__r.Type__c == 'Salesforce Data Type' ) {
                                if (String.isBlank(String.valueOf(application.get(quizQuestion.Field__c)))) {                                    
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, System.Label.FC_Required_Field_Label + ' ' +mapTabIdsToName.get(quizQuestion.Tab__c).Name+' : '+quizQuestion.Question__r.RichQuestion__c ));
                                }
                            } else if (quizQuestion.Question__r.Type__c == 'Attachment') {
                                if (mapApplicationAttachments.get(quizQuestion.Question__c) != null && mapAttachmentCount.get(quizQuestion.Question__c)<= 0) {                                    
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, System.Label.FC_Required_Field_Label + ' ' +mapTabIdsToName.get(quizQuestion.Tab__c).Name+' : '+quizQuestion.Question__r.RichQuestion__c ));
                                }
                            }
                        }
                    }
                                                

                }                                

                for (Related_List_Controller__c  tabListItem : tabsList) {

                    if((String.isBlank(tabListItem.ObjectName__c) || (tabListItem.ObjectName__c).equalsIgnoreCase('none') ) && String.isNotBlank(tabListItem.RecordType.Name) && (tabListItem.RecordType.Name).equalsIgnoreCase('Organization Tab')) {
                        orgTab = tabListItem;
                    }

                    if ((String.isBlank(tabListItem.ObjectName__c) || (tabListItem.ObjectName__c).equalsIgnoreCase('none') ) && String.isNotBlank(tabListItem.RecordType.Name) && (tabListItem.RecordType.Name).equalsIgnoreCase('Contact Tab')) {
                        contactTab = tabListItem;
                    }
                }


                //Logic to check required field must not be blank before review and submit the application for Organization Tab
                if (orgTab != null && userAccount != null && userAccount.Id != null) {
                    String strFieldSetApiName = (isIndividual ? 'FGM_Portal__CommunityIndividualProfile' : 'FGM_Portal__CommunityAccountFieldSet');
                    String fieldName = null;

                    for (Schema.FieldSetMember fieldSetMemberField : Schema.SObjectType.Account.FieldSets.getMap().get(strFieldSetApiName).getFields()) {
                        fieldName = fieldSetMemberField.getFieldPath();

                        if (bIsSCPLEnable && (fieldName == 'BillingCountry' || fieldName == 'BillingState' || fieldName == 'ShippingCountry' || fieldName == 'ShippingState')) {
                            fieldName = fieldName+'code';
                        }

                        if ((fieldSetMemberField.getDBRequired() || fieldSetMemberField.getRequired()) && String.isBlank(String.valueOf(userAccount.get(fieldName)))) {
                            ApexPages.addMessage(
                                new ApexPages.Message(
                                    ApexPages.Severity.Error,
                                    System.Label.FC_Required_Field_Label + ' ' + orgTab.Name + ' : '+ fieldSetMemberField.getLabel()
                                )
                            );
                        }
                    }
                }

                //Logic to check required field must not be blank before review and submit the application for Contact Tab
                if (contactTab != null && userContact != null && userContact.Id != null) {
                    String strFieldSetApiName = (isIndividual ? 'FGM_Portal__CommunityIndividualProfile' : 'FGM_Portal__CommunityContactFieldSet');
                    String fieldName = null;

                    for (Schema.FieldSetMember fieldSetMemberField : Schema.SObjectType.Contact.FieldSets.getMap().get(strFieldSetApiName).getFields()) {
                        fieldName = fieldSetMemberField.getFieldPath();

                        if (bIsSCPLEnable && (fieldName == 'MailingCountry' || fieldName == 'MailingState' || fieldName == 'OtherCountry' || fieldName == 'OtherState')) {
                            fieldName = fieldName+'code';
                        }

                        if ((fieldSetMemberField.getDBRequired() || fieldSetMemberField.getRequired()) && String.isBlank(String.valueOf(userContact.get(fieldName)))) {
                            ApexPages.addMessage(
                                new ApexPages.Message(
                                    ApexPages.Severity.Error,
                                    System.Label.FC_Required_Field_Label + ' ' + contactTab.Name + ' : ' + fieldSetMemberField.getLabel()
                                )
                            );
                        }
                    }
                }
            }
        }

        if (ApexPages.hasMessages()) {
            return null;
        } else {
            Database.SaveResult result;
            PageReference pageReference = System.Page.CommunityDashboard;
            savePoint = Database.setSavepoint();
            application = this.getCrudFlsService().stripInaccessibleForUpdate(application);
            if (String.isNotBlank(currentParentObject) && 'opportunity'.equalsIgnoreCase(currentParentObject)) {
                application.put('StageName',SUBMITTED_STATUS_VALUE);

                if (lstUser != null && !lstUser.isEmpty()) {
                    if (lstUser[0].ContactId != null) {
                        application.put('FGM_Base__Submitted_By__c', lstUser[0].ContactId);
                    }
                }

                CrudFlsService.getInstance().assertUpdateable(application);
                result = Database.Update(application,false);

                isApplicationSubmitted = true;
                isShowHidePrePostText = true;
            } else if(String.isNotBlank(currentParentObject) && 'lead'.equalsIgnoreCase(currentParentObject)) {
                application.put('Status', SUBMITTED_STATUS_VALUE);
                application.put('FGM_Base__Submission_Date__c', Date.today());
                if (lstUser != null && !lstUser.isEmpty()) {
                    if (lstUser[0].ContactId != null) {
                        application.put('FGM_Base__Submitted_By__c', lstUser[0].ContactId);
                    }
                }

                CrudFlsService.getInstance().assertUpdateable(application);
                result = Database.Update(application,false);

                isApplicationSubmitted = true;
                isShowHidePrePostText = true;
            }

            if (!result.isSuccess()) {
                ApexPages.addMessage(
                    new ApexPages.Message(
                        ApexPages.Severity.Error,
                        result.getErrors()[0].getMessage()
                    )
                );
            }

            bIsContactTab = true;
            SaveContactTab();
            bIsOrganizationTab = true;
            SaveOrganizationTab();

            if (ApexPages.hasMessages()) {
                isApplicationSubmitted = false;
                Database.rollback(savePoint);
                return null;
            }

            return pageReference;
        }
    }catch(Exception ex){
        system.debug('Exception :'+ex.getMessage()+' StackTraceString :'+ex.getStackTraceString());
        rollbackWithError( ex.getMessage(), savePoint );
    }
    return null;
}

    /**
     * @description This is a method to get the accesslevel options for
     * ApplicationAccessLevel field on Portal User Request Team Member.
     */
    public List<SelectOption> getApplicationAcessLevelOptions() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = PortalUserRequestTeamMembers__c.ApplicationAccessLevel__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry picklistEntry : picklistValues) {
            options.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));
        }

        return options;
    }

    /**
     * @description This is a method to get parameter value from current page.
     */
    public String getParam(String name) {
        return objSFDCEncoder.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get(name));
    }

    public PageReference redirectTo(PageReference pageReference) {
        if (pageReference != null) {
            pageReference.setRedirect(true);
        }

        return pageReference;
    }

    /**
     * @description This is a method to rollback to the savepoint or show the
     * message.
     */
    public PageReference rollbackWithError(String message, System.Savepoint savepoint) {
        if (savepoint != null) {
            Database.rollback(savepoint);
        }

        if (message != null) {
            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.Error,
                    message
                )
            );
        }

        return null;
    }

    /**
     * @description This is a method to get the Account record based on user
     * type i.e Individual or Organization
     */
    public void getOrganizationRecord() {
        userAccount = new Account();
        List<Schema.FieldSetMember> lstAccountFields = getAccountFields();

        if (lstAccountFields != null && !lstAccountFields.isEmpty()) {
            Set<String> setAccountFields = new Set<String>();

            for (Schema.FieldSetMember fldStMmbr : lstAccountFields) {
                if (!'Id'.equalsIgnoreCase(fldStMmbr.getFieldPath())) {
                    String fieldName = fldStMmbr.getFieldPath();

                    if (bIsSCPLEnable && (fieldName == 'BillingCountry' || fieldName == 'BillingState' || fieldName == 'ShippingCountry' || fieldName == 'ShippingState')) {
                        setAccountFields.add(fieldName+'Code');
                    } else {
                        setAccountFields.add(fieldName);
                    }

                }
            }

            if (!setAccountFields.isEmpty()) {
                if (user != null) {
                    Id userContactAccountId = user.Contact.AccountId;
                    String strQuery = 'SELECT Id, ' + String.join(new List<String>(setAccountFields), ', ') +' FROM Account WHERE Id = :userContactAccountId WITH SECURITY_ENFORCED';
                    List<Account> lstAccounts = Database.Query(strQuery);

                    if (lstAccounts != null && !lstAccounts.isEmpty()) {
                        userAccount = lstAccounts[0];
                    }

                }
            }
        }
    }

    /**
     * @description This is a method to initialize public properties, tabs,
     * campaign, Quiz and Application
     */
    public PageReference initialize() {
        initialized = true;
        try {
            isCampaignExpired = false;
            isSaveAndNext = false;
            isViewRecordLink = false;
            isOpportunity = false;
            isRecommendationTab = false;
            isAssignedTOConsultant = false;
            inviteOppTeamMember = new Portal_User__c();
            showPendingOpportunityTeamMembers = false;
            isApplicationSubmitted = false;
            isShowHidePrePostText = false;
            strApplicationMode = getParam('mode');
            // To get Multilanguage DateTime format
            Map<String, String> mappedValues = new Map<String, String>(); //map for holding locale to datetime format
            mappedValues = FCGlobal.getDateFormat();

            if (mappedValues.containsKey(portalLanguage)) {
                strDateTime = mappedValues.get(portalLanguage); //grab the datetime format for the locale
            }

            strRequestCampaignField = 'CampaignID';
            GlobalPortalSettings__c globalSetting = GlobalPortalSettings__c.getOrgDefaults();

            if (globalSetting != null) {

                if (globalSetting.Request_Campaign_Field_Name__c != null || String.isNotBlank(globalSetting.Request_Campaign_Field_Name__c)) {
                    strRequestCampaignField = globalSetting.Request_Campaign_Field_Name__c;
                }

                if (globalSetting.LOI_Campaign_Field_Name__c != null || String.isNotBlank(globalSetting.LOI_Campaign_Field_Name__c)) {
                    strLOICampaignField = globalSetting.LOI_Campaign_Field_Name__c;
                }

            }

            if (String.isNotBlank(strApplicationMode) && 'view'.equalsIgnoreCase(strApplicationMode)) {
                isApplicationSubmitted = true;
                isShowHidePrePostText = false;
            }

            //requiredQuestions  = new Set<String>();
            setAttachmentQuestionList = new Set<String>();
            mapApplicationAttachments = new Map<String, ApplicationAttachments>();

            lstUser = [
                SELECT
                    ContactId,
                    UserProfile__c
                FROM User
                WHERE Id = :UserInfo.getUserId()
                WITH SECURITY_ENFORCED
            ];

            Set<String> setProfileType = new Set<String>();

            if (lstUser != null && !lstUser.isEmpty()) {
                if (String.isNotBlank(lstUser[0].UserProfile__c)) {
                    setProfileType.addAll(lstUser[0].UserProfile__c.split(';'));
                    if (setProfileType.contains('Consultant')) {
                        isConsultant = true;
                    }
                }
            }

            initializeCampaign();

            if (campaign !=null && campaign.Id != null) {
                Map<String, Map<String, String>> mapCampaignIdToMapFieldTranslations = FCGlobal.getObjectTranslationMap(new List<Id>{campaign.Id}, portalLanguage, new Set<String>{'Name'});
                Map<String, String> mapFieldTranslations = new Map<String, String>();

                if (mapCampaignIdToMapFieldTranslations != null && mapCampaignIdToMapFieldTranslations.get(campaign.Id) != null && mapCampaignIdToMapFieldTranslations.get(campaign.Id).get('Name') != null) {
                    mapFieldTranslations.put('Name', mapCampaignIdToMapFieldTranslations.get(campaign.Id).get('Name').stripHtmlTags());
                } else {
                    mapFieldTranslations.put('Name', campaign.Name);
                }

                mapSobjectIdToMapFieldTranslations.put(campaign.Id,mapFieldTranslations);

                if (mapCampaignIdToMapFieldTranslations.get('FGM_Portal__Exception') != null && mapCampaignIdToMapFieldTranslations.get('FGM_Portal__Exception').get('FGM_Portal__Exception') != null) {
                    ApexPages.addMessage(
                        new ApexPages.Message(
                            ApexPages.Severity.Error,
                            mapCampaignIdToMapFieldTranslations.get('FGM_Portal__Exception').get('FGM_Portal__Exception')
                        )
                    );

                    return null;
                }
            }

            if (campaign !=null) {
                initializeQuiz();

                if (quiz == null) {
                    return null;
                }

                initializeTabs();
                initializeApplication();

                if (application == null) {
                    rollbackWithError(objSFDCEncoder.SFDC_HTMLENCODE(System.Label.FC_RegistrationProcess_ErrorMsg), null);
                }
            
                initializeQuizQuestionList('');
                initializeAttachment();
                InitializeCharCount();
                initializeMapRequiredFields();
            }

            if(isApplicationSubmitted == false){
                mode = 'edit';
            }
        } catch( Exception ex ) {
            System.debug( 'Exception: ' + ex +'at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getStackTraceString() ) );
        }

        return null;
    }

    public String getJSONApp() {
        if (application != null) {
            return JSON.serialize(application);
        }

        return null;
    }

    /**
     * @description This is a method to get JSON string of field and its char
     * limit
     */
    public void InitializeCharCount() {
        String strObjectName = '';

        if (tabsList != null && String.isNotBlank(selectedTab)) {
            for (Related_List_Controller__c tabRecord : tabsList) {
                if (selectedTab == String.valueOf(tabRecord.Id)) {
                    strObjectName = tabRecord.ObjectName__c;
                }
            }
        }

        if (String.isNotBlank(strObjectName) && strObjectName != 'none') {
            strFields = JSON.serialize(FCGlobal.getFieldLengthMap(strObjectName));
        }
    }

    /**
     * @description This is a method to check if Feeds are enabled in Portal
     * Configuration based on Language.
     */
    public void initalizePortalFeedAttachment(String portalLanguage) {
        try {
            for (PortalConfiguration__c portalConfig: PortalConfiguration__c.getall().values()) {
                if (portalConfig.Post_attachments_to_chatter_feeds__c == true && portalConfig.LanguageSelection__c.trim().toLowerCase().equals(portalLanguage.trim().toLowerCase())) {
                    isFeedAttachmentEnabled = true;
                    break;
                }
            }

            mapApplicationFeedAttachments = new Map<String,FeedAttachment>();
        } catch (Exception ex) {
            system.debug( 'Exception: ' + ex +'at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() ) );
        }
    }

    /**
     * @description This is a method to initialize review page with custom HTML
     * and calls initializeReviewPageList.
     */
    public PageReference initializeReview() {
        initialized = true;
        try {
            Id appID = objSFDCEncoder.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('appID'));
            string strcurrentParentObject;

            mapCustomHtml = new Map<Id, CustomHTML__c>([
                SELECT
                    RichDescription__c,
                    Language__c,
                    Name
                FROM CustomHTML__c
                WHERE Associated_FC_Portal_Type__c = 'Grantee'
                AND Name = 'GranteeApplicationReview'
                AND Language__c = :portalLanguage
                WITH SECURITY_ENFORCED
                LIMIT 1
            ]);

            isReviewSubmitPage = true;  // Force all pages to display
            initialize(); // Run the normal process
            strcurrentParentObject = currentParentObject;

            if (!tabsList.isEmpty() && tabsList[0].RecordType.Name.equalsIgnoreCase('Custom Profile Tab')) {
                for (Related_List_Controller__c rlcRecord : tabsList) {
                    if (rlcRecord.RecordType.Name.equalsIgnoreCase('Portal Tab')) {
                        currentParentObject =  rlcRecord.ParentObject__c;
                        if (currentParentObject != null) {
                            if (!tabsList[0].ParentObject__c.equalsIgnoreCase('Lead') && currentParentObject.equalsIgnoreCase('Lead')) {
                                initializeApplication();
                            }

                            if (!tabsList[0].ParentObject__c.equalsIgnoreCase('Opportunity') &&  currentParentObject.equalsIgnoreCase('Opportunity')) {
                                initializeApplication();
                            }
                        }
                    }
                }
            }

            initializeReviewPageList(); // Convert to a review list
            initializeNewPortalUserTeamMembersList();

            if (!String.isBlank(getparam('appID'))) {
                strSelectedappId = getparam('appID');
            }

            if (String.isNotBlank(strSelectedappId)) {
                Integer count = [
                    SELECT COUNT()
                    FROM Grantee_Budget_Line_Item__c
                    WHERE Opportunity__c = :Id.valueOf(strSelectedappId)
                    WITH SECURITY_ENFORCED
                    LIMIT 1000
                ];

                if (count > 0) {
                    generateExistingBudget();
                }
            }
        } catch (Exception ex) {
            system.debug( 'Exception: ' + ex.getMessage() + '; Line number: ' + ex.getLineNumber() + '; Stacktrace: ' + ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ' ' + ex.getMessage()  ) );
        }

        return null;
    }

    /**
     * @description This is a method to get the customHTML records.
     */
    public CustomHTML__c getCustomHTMLDescription() {
        if (mapCustomHtml != null && mapCustomHtml.size() >0 ) {
            return mapCustomHtml.values()[0];
        }

        return null;
    }

    /**
     * @description This is a method to initialize Iframe tab if application
     * fields are refered in URL value for iframe.
     */
    private void fillMapObjectFields() {
        try {
            if (tabsList != null && !tabsList.isEmpty()) {
                for (Related_List_Controller__c rlcRecord : tabsList) {
                    for (Quiz_Questions__c quizQuestion : rlcRecord.Quiz_Questions__r) {
                        if (quizQuestion.Question__r.Type__c == 'Salesforce Data Type') {
                            if (quizQuestion.Field__c != null && String.isNotBlank(quizQuestion.Field__c)) {
                                Set<String> lstFields;

                                if (mapObjNameLstFields == null) {
                                    mapObjNameLstFields = new Map<String, Set<String>>();
                                } else {
                                    lstFields = mapObjNameLstFields.get(rlcRecord.ObjectName__c.tolowercase());
                                }

                                if (lstFields == null) {
                                    lstFields = new Set < String >();
                                }

                                lstFields.add(quizQuestion.Field__c.tolowercase());
                                mapObjNameLstFields.put(rlcRecord.ObjectName__c.tolowercase(), lstFields);
                            }
                        }
                    }

                    if (rlcRecord.RecordType.Name.equalsIgnoreCase('IFrame Tab')) {
                        if (rlcRecord.BaseUrl__c != null && rlcRecord.BaseUrl__c.contains('{') && rlcRecord.BaseUrl__c.contains('}')) {
                            String strBaseUrl = rlcRecord.FGM_Portal__BaseUrl__c.remove('{');
                            strBaseUrl = strBaseUrl.remove('}');
                            strBaseUrl = strBaseUrl.tolowercase();
                            PageReference pageRef = new PageReference(strBaseUrl);

                            if (pageRef.getParameters() != null) {
                                for (String strParam : pageRef.getParameters().values()) {
                                    strParam = strParam.tolowercase();
                                    if (strParam.countMatches('.') == 1) {
                                        String strObjName = strParam.substring(0, strParam.indexOf('.'));
                                        String strFieldName = strParam.subString(strParam.indexOf('.') + 1, strParam.length());
                                        Set<String> lstFields;

                                        if (mapObjNameLstFields == null) {
                                            mapObjNameLstFields = new Map<String, Set<String>>();
                                        } else {
                                            lstFields = mapObjNameLstFields.get(strObjName);
                                        }

                                        if (lstFields == null) {
                                            lstFields = new Set<String>();
                                        }

                                        lstFields.add(strFieldName);
                                        mapObjNameLstFields.put(strObjName, lstFields);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch (Exception ex) {
            system.debug( 'Exception: ' + ex +'at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getStackTraceString() ) );
        }
    }

    /**
     * @description This is a method to fetch all the tabs for the Quiz and
     * questions based on the portal language.
     */
    public void initializeTabs() {
        try {
            List<Lead> lstLead = new List<Lead>();
            String strRLCLang = portalLanguage;
            List<Lead> lstConvertedLeads;

            Integer countLanguage = [
                SELECT COUNT()
                FROM Related_List_Controller__c
                WHERE IsCommunityRecord__c = TRUE
                AND Language__c = :portalLanguage
                WITH SECURITY_ENFORCED
            ];

            if (0 == countLanguage) {
                strRLCLang = 'en_US';
            }

            if (quiz.Id == null) {
                initializeCampaign();
                initializeQuiz();
            }

            if (tabsList == null) {
                tabsList = [
                    SELECT
                        Name,
                        Associated_FC_Portal_Type__c,
                        Associated_Tab_Type__c,
                        ObjectName__c,
                        ParentObject__c,
                        LookupField__c,
                        FieldHeaders__c,
                        FieldNames__c,
                        Language__c,
                        RichInstructionalText__c,
                        ShowNewButton__c,
                        ShowDeleteLink__c,
                        Hide_Edit_Link__c,
                        BaseUrl__c,
                        RecordTypeId,
                        RecordType.Name,
                        of_records_to_display__c,
                        Cloned_from__c,
                        Cloned_from__r.Name,
                        SortField__c,
                        SortFieldOrder__c,
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
                    WITH SECURITY_ENFORCED
                    ORDER BY SortOrder__c ASC NULLS LAST
                    LIMIT 10000
                ];
            }

            if (ApexPages.currentPage().getParameters().get('appId') != null) {
                applicationId = ApexPages.currentPage().getParameters().get('appId').escapeHtml4();
            }

            CommunitySetting__c communitySetting = CommunitySetting__c.getValues('ShowInquiryAttachmentTabToGrantee');

            if (tabsList != null && !tabsList.isEmpty() && communitySetting != null && communitySetting.IsEnabled__c == true && applicationId != null) {
                lstConvertedLeads = [
                    SELECT Id
                    FROM Lead
                    WHERE ConvertedOpportunityId = :applicationId
                    AND FGM_Base__Attachments_to_Request_on_Conversion__c = TRUE
                    WITH SECURITY_ENFORCED
                ];

                if (!lstConvertedLeads.isEmpty()) {
                    FGM_Portal__Related_List_Controller__c rlcLegacyTab = new FGM_Portal__Related_List_Controller__c();
                    rlcLegacyTab.Name = String.valueOf(DateTime.now().getTime());
                    strIquiryTabName = rlcLegacyTab.Name;
                    List<Schema.RecordTypeInfo> rTInfo = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfos();

                    for (Schema.RecordTypeInfo recordTypeInfo : rTInfo) {
                        if (recordTypeInfo.getName().equalsIgnoreCase('Portal Tab')) {
                            RecordType rtRecord = new RecordType();
                            rtRecord.Id = recordTypeInfo.getRecordTypeId();
                            rtRecord.Name = recordTypeInfo.getName();
                            rlcLegacyTab.RecordType = rtRecord;
                        }
                    }

                    
                    Schema.SObjectType sObjType = objectTypeMap.get('FGM_Portal__Related_List_Controller__c');
                    Schema.DescribeSObjectResult sObjTypeResult = sObjType.getDescribe();
                    String timeStampVal = String.valueOf(DateTime.now().getTime());
                    String keyPrefix = sObjTypeResult.getKeyPrefix() + 'A00000' + timeStampVal.right(11);
                    rlcLegacyTab.Id = keyPrefix.substring(0,18);
                    rlcLegacyTab.ParentObject__c = 'Opportunity';
                    rlcLegacyTab.ObjectName__c = 'Opportunity';
                    rlcLegacyTab.LookupField__c = 'Opportunity';
                    tabsList.add(rlcLegacyTab);
                }
            }

            if (tabsList != null && !tabsList.isEmpty()) {
                selectedTab = String.valueOf(tabsList[0].Id);
                currentParentObject = tabsList[0].ParentObject__c;
            }

            fillMapObjectFields();  // for Dynamic iFrames
        } catch (Exception ex) {
            system.debug( 'Exception: ' + ex +'at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() ) );
        }
    }

    /**
     * @description This is a method to fetch the current campaign.
     */
    public void initializeCampaign() {
        try {
            List<Campaign> campaignList = [
                SELECT
                    Application_Quiz__r.Introduction_Text__c,
                    Application_Quiz__r.Is_Active__c,
                    Application_Type__c,
                    EndDate,
                    LOI_Quiz__r.Introduction_Text__c,
                    LOI_Quiz__r.Is_Active__c,
                    Name,
                    No_of_Recommendation__c,
                    RecordType.Name
                FROM Campaign
                WHERE Id = :controller.getId()
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            if (campaignList == null || campaignList.isEmpty()) {
                campaign = new Campaign();
            } else {
                campaign = campaignList[0];
            }
        } catch (Exception ex) {
            system.debug( 'Exception: ' + ex +'at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage()) );
        }
    }

    /**
     * @description This is a method to initialize current Quiz based on quiz
     * value in URL. If Quiz on application is null then Quiz on campaign is
     * referred if its blank then campaign Quiz is reffered to get the Quiz.
     */
    public void initializeQuiz() {
        try {
            Id id = null;
            Id appId = null;
            Id paramQuizId = null;
            String sobjectName;
            String strQuery;

            if (ApexPages.currentPage().getParameters().get('Id') != null) {
                Id = objSFDCEncoder.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('Id'));
            }

            if (ApexPages.currentPage().getParameters().get('appID') != null) {
                appId = objSFDCEncoder.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('appID'));
            }

            if (getParam('quizId') != null && getParam('quizId') != '') {
                paramQuizId = getParam('quizId');
            }

            if (getParam('mode') != null && String.isNotBlank(getParam('mode'))) {
                mode = getParam('mode');
            }

            if (appId != null) {
                sobjectName = appId.getSObjectType().getDescribe().getName().tolowercase();  // Opportunity OR Lead
            }

            List<Opportunity> lstApplication;
            List<Lead> lstLOI;
            List<Quiz__c> lstQuizzes;

            List<Campaign_Quiz__c> lstcampaignQuiz = [
                SELECT
                    Name,
                    Quiz__c,
                    Quiz__r.Name
                FROM Campaign_Quiz__c
                WHERE Campaign__c = :controller.getId()
                AND IsActive__c = TRUE
                AND (
                    Quiz__c = :paramQuizId
                    OR Quiz__c != null
                )
                WITH SECURITY_ENFORCED
            ]; // @todo wtf? why check paramQuizId if all you care about is it isnt null?

            quiz = null;

            if (quiz == null && paramQuizId != null) {
                lstQuizzes = [
                    SELECT Id
                    FROM Quiz__c
                    WHERE Id = :paramQuizId
                    WITH SECURITY_ENFORCED
                ];

                if (!lstQuizzes.isEmpty()) {
                    quiz = lstQuizzes[0];
                }
            }

            Boolean bisValidQuiz = true;

            if (appId != null) {
                // edit or create mode
                if (String.isNotBlank(sobjectName)) {
                    if (sobjectName.equalsIgnoreCase('Opportunity')) {
                        strQuery = 'Select Quiz__c, Quiz__r.Name From Opportunity Where Quiz__c != null AND ID = :appId WITH SECURITY_ENFORCED LIMIT 1';
                        lstApplication = Database.query(strQuery);
                    } else if(sobjectName.equalsIgnoreCase('Lead')) {
                        strQuery = 'Select Quiz__c, Quiz__r.Name From Lead Where Quiz__c != null AND ID = :appId WITH SECURITY_ENFORCED LIMIT 1';
                        lstLOI = Database.query(strQuery);
                    }
                }

                if (lstApplication != null && !lstApplication.isEmpty()) {
                    quiz = lstApplication[0].Quiz__r;
                } else if (lstLOI != null && !lstLOI.isEmpty()) {
                    quiz = lstLOI[0].Quiz__r;
                }

                if (quiz == null) {
                    if (campaign.Application_Quiz__c != null && sobjectName.equalsIgnoreCase('Opportunity')) {
                        quiz = campaign.Application_Quiz__r;
                    } else if (campaign.LOI_Quiz__c != null  && sobjectName.equalsIgnoreCase('Lead')) {
                        quiz = campaign.LOI_Quiz__r;
                    }
                }
            } else if (application != null && application.Id != null) {
                sobjectName = (application.Id).getSObjectType().getDescribe().getName().tolowercase();

                if (String.isNotBlank(sobjectName)) {
                    if (sobjectName.equalsIgnoreCase('Opportunity')) {
                        strQuery = 'Select Quiz__c, Quiz__r.Name From Opportunity Where Quiz__c != null AND ID = :appId WITH SECURITY_ENFORCED LIMIT 1';
                        lstApplication = Database.query(strQuery);
                    } else if(sobjectName.equalsIgnoreCase('Lead')) {
                        strQuery = 'Select Quiz__c, Quiz__r.Name From Lead Where Quiz__c != null AND ID = :appId WITH SECURITY_ENFORCED LIMIT 1';
                        lstLOI = Database.query(strQuery);
                    }
                }

                if (lstApplication != null) {
                    quiz = lstApplication[0].FGM_Portal__Quiz__r;
                } else if (lstLOI != null) {
                    quiz = lstLOI[0].FGM_Portal__Quiz__r;
                }

                if (quiz == null) {
                    if (campaign.FGM_Portal__Application_Quiz__c != null && sobjectName.equalsIgnoreCase('Opportunity')) {
                        quiz = campaign.FGM_Portal__Application_Quiz__r;
                    } else if (campaign.LOI_Quiz__c != null  && sobjectName.equalsIgnoreCase('Lead')) {
                        quiz = campaign.FGM_Portal__LOI_Quiz__r;
                    }
                }
            }

            if (quiz == null) {
                if (campaign.Application_Type__c != null) {
                    if (campaign.Application_Type__c.equalsIgnoreCase('Application Quiz') && campaign.Application_Quiz__c != null) {
                        quiz = campaign.Application_Quiz__r;
                    } else if (campaign.Application_Type__c.equalsIgnoreCase('LOI Quiz') && campaign.FGM_Portal__LOI_Quiz__c != null) {
                        quiz = campaign.FGM_Portal__LOI_Quiz__r;
                    } else if (!lstcampaignQuiz.isEmpty() && lstcampaignQuiz.size() == 1 && lstcampaignQuiz[0].FGM_Portal__Quiz__c != null) {
                        quiz = lstcampaignQuiz[0].FGM_Portal__Quiz__r;
                    } else {
                        bisValidQuiz = false;
                    }
                } else {
                    if (lstcampaignQuiz != null && !lstcampaignQuiz.isEmpty() && lstcampaignQuiz.size() == 1 && lstcampaignQuiz[0].FGM_Portal__Quiz__c != null) {
                        quiz = lstcampaignQuiz[0].FGM_Portal__Quiz__r;
                    } else {
                        bisValidQuiz = false;
                    }
                }
            }

            if (!bisValidQuiz) {
                rollbackWithError(System.Label.FC_FCRecord_Processing_ErrorMsg , null);
            }
        } catch (Exception ex) {
            system.debug( 'Exception: ' + ex +'at Line: '+ ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, ' ' + ex.getMessage() + '' + ex.getLineNumber() ) );
            rollbackWithError(System.Label.FC_FCRecord_Processing_ErrorMsg,null);
        }
    }

    /**
     * @description This is a method to initialize current tab and its Quiz
     * Questions.
     */
    public void initializeQuizQuestionList() {
        strSelectedTabId = getParam('tabId');

        if(String.isNotBlank(strSelectedTabId))
            initializeQuizQuestionList(strSelectedTabId);
    }

    /**
     * @description This is a method to initialize quiz question data on review
     * page.
     */
    public void initializeQuizQuestionForReview() {
        if (tabsList != null) {
            quizQuestionList = new List<Quiz_Questions__c>();
            portalTabIds = new Set<Id>();
            relatedListTabIds = new Set<Id>();
            granteeBudgetTabIds = new Set<Id>();
            Set<Questions__c> setQuestions;
            List<Lead> lstConvertedLeads;
            for (Related_List_Controller__c tabRecord : tabsList) {
                if (tabRecord.Name == strIquiryTabName) {
                    currentTabType = 'Inquiry Attachments';
                    tabObject = application;
                    Set<Id> setQuestionIds = new Set<Id>();
                    mapQuestionAttachments = new Map<Id, List<AttachmentsWrapper>>();
                    if (applicationId == null) {
                        applicationId = getParam('appId');
                    }

                    lstConvertedLeads = [
                        SELECT Id
                        FROM Lead
                        WHERE ConvertedOpportunityId = :applicationId
                        WITH SECURITY_ENFORCED
                    ];

                    convertedLeadId = lstConvertedLeads[0].Id;
                    lstQuestions = new List<Questions__c>();
                    Map<Questions__c, Questions__c> mapQuestionToParentQuestion = new Map<Questions__c, Questions__c>();
                    Map<Questions__c, Questions__c> mapParentQuestionToQuestion = new Map<Questions__c, Questions__c>();
                    Map<String, Map<Questions__c, Questions__c>> mapLangQuestions = new Map<String, Map<Questions__c, Questions__c>>();
                    Map<Id, Questions__c> mapIdToQuestion = new Map<Id, Questions__c>();
                    Map<Questions__c, Id> mapAllQueToQueAttachment = new Map<Questions__c, Id>();
                    mapQueToQueAttachment = new Map<Questions__c, Id>();
                    Set<Id> setParentQuestionId = new Set<Id>();
                    Map<Id, Integer> mapQueAttachIdToNumberOfAttach = new Map<Id, Integer>();
                    Map<Id, Questions__c> mapAllChildQuestion = new Map<Id, Questions__c>();
                    List<FGM_Portal__Question_Attachment__c> lstqstnAtthmnt;

                    if (!lstConvertedLeads.isEmpty()) {

                        List<Questions__c> lstMultilingualQuestions = new List<Questions__c>();

                        lstqstnAtthmnt = [
                            SELECT
                                Inquiry__c,
                                Opportunity__c,
                                Question__c,
                                Question__r.Id,
                                Question__r.Language__c,
                                Question__r.Parent_QuestionID__c,
                                Question__r.RichQuestion__c,
                                (
                                    SELECT
                                        CreatedDate,
                                        Description,
                                        Name,
                                        ParentId
                                    FROM Attachments
                                ),
                                (
                                    SELECT
                                        ContentDocumentId,
                                        LinkedEntityId
                                    FROM ContentDocumentLinks
                                )
                                FROM Question_Attachment__c
                                WHERE Inquiry__c = :lstConvertedLeads[0].Id
                                AND Question__c != null
                                WITH SECURITY_ENFORCED
                            ];

                        for (FGM_Portal__Question_Attachment__c qstnAtthmntIterator : lstqstnAtthmnt) {
                            mapIdToQuestion.put(qstnAtthmntIterator.Question__c , qstnAtthmntIterator.Question__r);

                            if (qstnAtthmntIterator.FGM_Portal__Question__r.Language__c == 'en_US') {
                                setParentQuestionId.add(qstnAtthmntIterator.Id);
                            }
                        }

                        mapAllChildQuestion.putAll([
                            SELECT
                                Parent_QuestionID__c,
                                Language__c,
                                Name,                                
                                (
                                    SELECT Id
                                    FROM Question_Attachments__r
                                )
                                FROM Questions__c
                                WHERE Parent_QuestionID__c IN :setParentQuestionId
                                AND Language__c = :portalLanguage
                                WITH SECURITY_ENFORCED
                            ]);

                        for (Question_Attachment__c qstnAtthmnt : lstqstnAtthmnt) {

                            if (qstnAtthmnt.Question__r.Parent_QuestionID__c != null) {
                                mapQuestionToParentQuestion.put(
                                    qstnAtthmnt.Question__r,
                                    mapIdToQuestion.get(
                                        qstnAtthmnt.Question__r.Parent_QuestionID__c
                                    )
                                );
                            } else {
                                mapQuestionToParentQuestion.put(qstnAtthmnt.Question__r, null);
                            }

                            mapAllQueToQueAttachment.put(qstnAtthmnt.Question__r, qstnAtthmnt.Id);

                            if (qstnAtthmnt.Question__r.Parent_QuestionID__c != null) {
                                mapParentQuestionToQuestion.put(
                                    mapIdToQuestion.get(qstnAtthmnt.Question__r.Parent_QuestionID__c),
                                    qstnAtthmnt.Question__r
                                );
                            }

                            mapQueAttachIdToNumberOfAttach.put(qstnAtthmnt.Id, qstnAtthmnt.Attachments.size());
                        }

                        for (Id queId : mapAllChildQuestion.keySet()) {
                            if (mapAllChildQuestion.get(queId).Question_Attachments__r.isEmpty()) {
                                mapQueToQueAttachment.put(
                                    mapAllChildQuestion.get(queId),
                                    mapAllQueToQueAttachment.get(
                                        mapQuestionToParentQuestion.get(
                                            mapIdToQuestion.get(
                                                queId
                                            )
                                        )
                                    )
                                );
                            }
                        }

                        for (Question_Attachment__c qstnAtthmnt : lstqstnAtthmnt) {
                            if (qstnAtthmnt.Question__r.Language__c == portalLanguage) {
                                if (qstnAtthmnt.Attachments != null || qstnAtthmnt.ContentDocumentLinks != null) {
                                    mapQueToQueAttachment.put(qstnAtthmnt.Question__r, qstnAtthmnt.Id);
                                } else {
                                    mapQueToQueAttachment.put(
                                        qstnAtthmnt.Question__r,
                                        mapAllQueToQueAttachment.get(
                                            mapQuestionToParentQuestion.get(
                                                mapIdToQuestion.get(
                                                    qstnAtthmnt.Question__c
                                                )
                                            )
                                        )
                                    );
                                }
                            }
                        }

                        for (Question_Attachment__c qstnAtthmnt : lstqstnAtthmnt) {
                            if (qstnAtthmnt.Question__r.Language__c == 'en_US'  && mapQueToQueAttachment.get(mapParentQuestionToQuestion.get(qstnAtthmnt.Question__r)) == null) {
                                if (qstnAtthmnt.Attachments != null || qstnAtthmnt.ContentDocumentLinks != null) {
                                    mapQueToQueAttachment.put(qstnAtthmnt.Question__r, qstnAtthmnt.Id);
                                }
                            }
                        }
                    }

                    lstQuestions.addAll(mapQueToQueAttachment.keySet());
                    mapLangQuestions.put(portalLanguage, mapQuestionToParentQuestion);

                } else {
                    Map<Id, Schema.RecordTypeInfo> recordTypeInfo = Schema.SObjectType.Related_List_Controller__c.getRecordTypeInfosById();
                    Schema.RecordTypeInfo requiredRecordtType = recordTypeInfo.get(tabRecord.RecordTypeId);
                    String strRLCRecordTypeName = '';

                    if (requiredRecordtType != null) {
                        strRLCRecordTypeName = requiredRecordtType.getName();  // Get record Type Name
                    }

                    if (String.isNotBlank(strRLCRecordTypeName) && 'Related List With Tab'.equalsIgnoreCase(strRLCRecordTypeName)) {
                        relatedListTabIds.add(tabRecord.Id);
                    } else if (String.isNotBlank(strRLCRecordTypeName) && 'Portal Tab'.equalsIgnoreCase(strRLCRecordTypeName)) {
                        portalTabIds.add(tabRecord.Id);
                        if (tabRecord.Quiz_Questions__r != null) {
                            for (Quiz_Questions__c quizQuestion : tabRecord.Quiz_Questions__r) {
                                if ((quizQuestion.Field__c != null &&  quizQuestion.Question__r.Type__c.equalsIgnoreCase('Salesforce Data Type'))) {

                                    if (quizQuestion.Field__c.equalsIgnoreCase('TeamMemberRole')) {
                                        isTeamRoleInQuizQuestion = true;
                                    }

                                    if (quizQuestion.Field__c.equalsIgnoreCase('additional_roles__c') || quizQuestion.Field__c.equalsIgnoreCase('FGM_Portal__Additional_Roles__c')) {
                                        isAdditionalRoleInQuizQuestion = true;
                                    }

                                    for (Schema.SObjectField sObjField : objectTypeMap.get((isOpportunity) ? 'Opportunity' : 'Lead').getDescribe().fields.getMap().values()) {
                                        Schema.DescribeFieldResult fieldResult = sObjField.getDescribe();
                                        String apiName = fieldResult.getName().toLowerCase();
                                        String apiLocalName = fieldResult.getLocalName().toLowerCase();
                                        if (quizQuestion.Field__c.equalsIgnoreCase( apiName ) || quizQuestion.Field__c.equalsIgnoreCase(apiLocalName)) {
                                            Quiz_Questions__c newQuizQuestion = new Quiz_Questions__c();
                                            newQuizQuestion = quizQuestion;
                                            newQuizQuestion.Field__c = apiName;
                                            quizQuestionList.add(newQuizQuestion);
                                            break;
                                        }
                                    }
                                }

                                if (quizQuestion.Question__r.Type__c.equalsIgnoreCase('Attachment')  || quizQuestion.Question__r.Type__c.equalsIgnoreCase('Instruction')) {
                                    quizQuestionList.add(quizQuestion);
                                }
                            }
                        }
                    } else if (String.isNotBlank(strRLCRecordTypeName) && 'Grantee Budget Tab'.equalsIgnoreCase(strRLCRecordTypeName)) {
                        granteeBudgetTabIds.add(tabRecord.Id);
                    }
                }
            }
        }
    }

    /**
     * @description This is a method to initialize quiz question specific to
     * tab Id.
     */
    public void initializeQuizQuestionList(String strSelectedTabId) {
        try {
            if (isReviewSubmitPage) {
                initializeQuizQuestionForReview();
            } else {
                currentTabType = '';
                isViewRecordLink = false;
                isRelatedListView = false;
                isGranteeBudget=false;
                isIFrame   = false;
                bIsOrganizationTab = false;
                bIsContactTab = false;
                bIsCstPrflTab = false;
                showPendingOpportunityTeamMembers = false;
                newOpportunityMemberPortalUser = null;
                inviteOppTeamMember = null;
                newOpportunityMember = null;
                relatedListConfiguration = null;
                portalUserRequestTeamMember = null;
                applicationAccessLevel = '';
                portalUserTeamMembersRelatedListConfiguration = null;
                relatedListRecordObject = null;
                tabObject = null;
                tabRecordId = '';
                List<Lead> lstConvertedLeads;
                if (String.isNotBlank(strSelectedTabId)) {
                    selectedTab = strSelectedTabId;
                }
                nextTabID = getNextTab();
                if (tabsList != null && String.isNotBlank(selectedTab)) {
                    quizQuestionList = new List<Quiz_Questions__c>();
                    Set<Id> setTabIds = new Set<Id>();
                    for (Related_List_Controller__c rlcTab : tabsList) {
                        if (rlcTab.RecordType.Name.equalsIgnoreCase('Portal Tab')) {
                            setTabIds.add(rlcTab.Id);
                        }
                    }
                    for (Related_List_Controller__c tabRecord : tabsList) {
                        if (selectedTab == String.valueOf(tabRecord.Id)) {
                            currentParentObject = tabRecord.ParentObject__c;
                            if (String.isNotBlank(tabRecord.ObjectName__c) && (tabRecord.ObjectName__c == 'Recommendation__c' || tabRecord.ObjectName__c == 'FGM_Portal__Recommendation__c')) {
                                isRecommendationTab = true;
                            }
                            if (tabRecord.Name != strIquiryTabName && tabRecord.Quiz_Questions__r != null) {
                                for (Quiz_Questions__c quizQuestion : tabRecord.Quiz_Questions__r) {
                                    if (quizQuestion.Field__c != null &&  quizQuestion.Question__r.Type__c.equalsIgnoreCase('Salesforce Data Type')) {
                                        for (Schema.SObjectField sObjField : objectTypeMap.get(tabRecord.ObjectName__c).getDescribe().fields.getMap().values()) {
                                            Schema.DescribeFieldResult fieldResult = sObjField.getDescribe();
                                            String apiName = fieldResult.getName().toLowerCase();
                                            String apiLocalName = fieldResult.getLocalName().toLowerCase();
                                            if (quizQuestion.Field__c.equalsIgnoreCase(apiName) || quizQuestion.Field__c.equalsIgnoreCase(apiLocalName) || (quizQuestion.Field__c.equalsIgnoreCase('additional_roles__c')) || (quizQuestion.Field__c.equalsIgnoreCase('FGM_Portal__Additional_Roles__c'))) {
                                                Quiz_Questions__c newQuizQuestion = new Quiz_Questions__c();
                                                newQuizQuestion = quizQuestion;
                                                if (quizQuestion.Field__c.equalsIgnoreCase('TeamMemberRole')) {
                                                    isTeamRoleInQuizQuestion = true;
                                                }
                                                if (quizQuestion.Field__c.equalsIgnoreCase('additional_roles__c') || quizQuestion.Field__c.equalsIgnoreCase('FGM_Portal__Additional_Roles__c')) {
                                                    newQuizQuestion.Field__c = 'additional_roles__c';
                                                    isAdditionalRoleInQuizQuestion = true;
                                                } else {
                                                    newQuizQuestion.Field__c = apiName;
                                                }
                                                quizQuestionList.add( newQuizQuestion );
                                                break;
                                            }
                                        }
                                    }
                                    if (quizQuestion.Question__r.Type__c.equalsIgnoreCase('Attachment') || quizQuestion.Question__r.Type__c.equalsIgnoreCase('Instruction')) {
                                        quizQuestionList.add(quizQuestion);
                                    }
                                }
                            }
                            /* need to add the exceptional condition here */
                            if (tabRecord.Name == strIquiryTabName) {
                                currentTabType = 'Inquiry Attachments';
                                tabObject = application;
                                Set<Id> setQuestionIds = new Set<Id>();
                                mapQuestionAttachments = new Map<Id, List<AttachmentsWrapper>>();
                                if (applicationId == null) {
                                    applicationId = ApexPages.currentPage().getParameters().get('appId').escapeHtml4();
                                }
                                lstConvertedLeads = [
                                    SELECT Id
                                    FROM Lead
                                    WHERE ConvertedOpportunityId = :applicationId
                                    WITH SECURITY_ENFORCED
                                ];
                                convertedLeadId = lstConvertedLeads[0].Id;
                                lstQuestions = new List<Questions__c>();
                                Map<Questions__c, Questions__c> mapQuestionToParentQuestion = new Map<Questions__c, Questions__c>();
                                Map<Questions__c, Questions__c> mapParentQuestionToQuestion = new Map<Questions__c, Questions__c>();
                                Map<String, Map<Questions__c, Questions__c>> mapLangQuestions = new Map<String, Map<Questions__c, Questions__c>>();
                                Map<Id,Questions__c> mapIdToQuestion = new Map<Id, Questions__c>();
                                Map<Questions__c, Id> mapAllQueToQueAttachment = new Map<Questions__c, Id>();
                                mapQueToQueAttachment = new Map<Questions__c, Id>();
                                Set<Id> setParentQuestionId = new Set<Id>();
                                Map<Id, Integer> mapQueAttachIdToNumberOfAttach = new Map<Id, Integer>();
                                Map<Id, Questions__c> mapAllChildQuestion = new Map<Id, Questions__c>();
                                List<FGM_Portal__Question_Attachment__c> lstqstnAtthmnt;
                                if (!lstConvertedLeads.isEmpty()) {
                                    List<Questions__c> lstMultilingualQuestions = new List<Questions__c>();
                                    lstqstnAtthmnt = [
                                        SELECT
                                            Inquiry__c,
                                            Opportunity__c,
                                            Question__c,
                                            Question__r.Id,
                                            Question__r.Language__c,
                                            Question__r.Parent_QuestionID__c,
                                            Question__r.RichQuestion__c,
                                            (
                                                SELECT
                                                    CreatedDate,
                                                    Description,
                                                    Name,
                                                    ParentId
                                                FROM Attachments
                                            ),
                                            (
                                                SELECT
                                                    ContentDocumentId,
                                                    LinkedEntityId
                                                FROM ContentDocumentLinks
                                            )
                                        FROM Question_Attachment__c
                                        WHERE Inquiry__c = :lstConvertedLeads[0].Id
                                        AND Question__c != null
                                        WITH SECURITY_ENFORCED
                                    ];
                                    for (Question_Attachment__c qstnAtthmntIterator : lstqstnAtthmnt) {
                                        mapIdToQuestion.put(qstnAtthmntIterator.Question__c, qstnAtthmntIterator.Question__r);
                                        if (qstnAtthmntIterator.Question__r.Language__c == 'en_US') {
                                            setParentQuestionId.add(qstnAtthmntIterator.Id);
                                        }
                                    }
                                    mapAllChildQuestion.putAll([
                                        SELECT
                                            Language__c,
                                            Name,
                                            Parent_QuestionID__c,
                                            (
                                                SELECT Id
                                                FROM Question_Attachments__r
                                            )
                                        FROM Questions__c
                                        WHERE Parent_QuestionID__c IN :setParentQuestionId
                                        AND Language__c = :portalLanguage
                                        WITH SECURITY_ENFORCED
                                    ]);
                                    for (Question_Attachment__c qstnAtthmnt : lstqstnAtthmnt) {
                                        if (qstnAtthmnt.Question__r.Parent_QuestionID__c!=null) {
                                            mapQuestionToParentQuestion.put(qstnAtthmnt.Question__r, mapIdToQuestion.get(qstnAtthmnt.Question__r.Parent_QuestionID__c));
                                        } else {
                                            mapQuestionToParentQuestion.put(qstnAtthmnt.Question__r, null);
                                        }
                                        mapAllQueToQueAttachment.put(qstnAtthmnt.Question__r, qstnAtthmnt.Id);
                                        if (qstnAtthmnt.Question__r.Parent_QuestionID__c != null) {
                                            mapParentQuestionToQuestion.put(mapIdToQuestion.get(qstnAtthmnt.Question__r.Parent_QuestionID__c), qstnAtthmnt.Question__r);
                                        }
                                        mapQueAttachIdToNumberOfAttach.put(qstnAtthmnt.Id, qstnAtthmnt.Attachments.size());
                                    }
                                    for (Id queId : mapAllChildQuestion.keySet()) {
                                        if (mapAllChildQuestion.get(queId).Question_Attachments__r.isEmpty()) {
                                            mapQueToQueAttachment.put(
                                                mapAllChildQuestion.get(queId),
                                                mapAllQueToQueAttachment.get(
                                                    mapQuestionToParentQuestion.get(
                                                        mapIdToQuestion.get(
                                                            queId
                                                        )
                                                    )
                                                )
                                            );
                                        }
                                    }
                                    for (Question_Attachment__c qstnAtthmnt : lstqstnAtthmnt) {
                                        if (qstnAtthmnt.Question__r.Language__c == portalLanguage) {
                                            if (qstnAtthmnt.Attachments != null || qstnAtthmnt.ContentDocumentLinks != null) {
                                                mapQueToQueAttachment.put(qstnAtthmnt.Question__r, qstnAtthmnt.Id);
                                            } else {
                                                mapQueToQueAttachment.put(
                                                    qstnAtthmnt.Question__r,
                                                    mapAllQueToQueAttachment.get(
                                                        mapQuestionToParentQuestion.get(
                                                            mapIdToQuestion.get(
                                                                qstnAtthmnt.Question__c
                                                            )
                                                        )
                                                    )
                                                );
                                            }
                                        }
                                    }
                                    for (Question_Attachment__c qstnAtthmnt : lstqstnAtthmnt) {
                                        if (qstnAtthmnt.Question__r.Language__c == 'en_US'  && mapQueToQueAttachment.get(mapParentQuestionToQuestion.get(qstnAtthmnt.Question__r)) == null) {
                                            if (qstnAtthmnt.Attachments != null || qstnAtthmnt.ContentDocumentLinks != null) {
                                                mapQueToQueAttachment.put(qstnAtthmnt.Question__r, qstnAtthmnt.Id);
                                            }
                                        }
                                    }
                                }
                                lstQuestions.addAll(mapQueToQueAttachment.keySet());
                                mapLangQuestions.put(portalLanguage, mapQuestionToParentQuestion);
                            } else {
                                Map<Id, Schema.RecordTypeInfo> recordTypeInfo = Schema.SObjectType.Related_List_Controller__c.getRecordTypeInfosById();
                                Schema.RecordTypeInfo requiredRecordtType = recordTypeInfo.get(tabRecord.RecordTypeId);
                                String strRLCRecordTypeName = '';
                                if (requiredRecordtType != null) {
                                    strRLCRecordTypeName = requiredRecordtType.getName();
                                }
                                if (String.isNotBlank(strRLCRecordTypeName) && 'Related List With Tab'.equalsIgnoreCase(strRLCRecordTypeName) && String.isNotBlank(tabRecord.LookupField__c) && (tabRecord.ParentObject__c != tabRecord.ObjectName__c)) {
                                    if (!recordTypeInfo.isEmpty()) {
                                        if (String.isNotBlank(tabRecord.FieldHeaders__c) && String.isNotBlank(tabRecord.FieldNames__c)) {
                                            currentTabType = 'Related List With Tab';
                                            isRelatedListView = true;
                                            isIFrame   = false;
                                            if (relatedListConfiguration == null && application != null && application.id != null) {
                                                relatedListConfiguration = new relatedList();
                                                relatedListConfiguration.record = tabRecord;
                                                relatedListConfiguration.strRelatedListObject = tabRecord.ObjectName__c;
                                                relatedListConfiguration.isCreatable = tabRecord.ShowNewButton__c;
                                                relatedListConfiguration.isEditable = !tabRecord.Hide_Edit_Link__c;
                                                relatedListConfiguration.isDeletable = tabRecord.ShowDeleteLink__c;
                                                relatedListConfiguration.mapColumnFields =  getrelatedListColumn(tabRecord);
                                                relatedListConfiguration.lstColumnFields = getrelatedListColumnList(tabRecord);
                                                relatedListConfiguration.relatedListLookUp =  tabRecord.LookupField__c;
                                                if (String.isNotBlank(tabRecord.ObjectName__c) && 'OpportunityTeamMember'.equalsIgnoreCase(tabRecord.ObjectName__c)) {
                                                    showPendingOpportunityTeamMembers = true;
                                                    initializeNewPortalUserTeamMembersList();
                                                }
                                                if (!relatedListConfiguration.mapColumnFields.isEmpty()) {
                                                    relatedListConfiguration.lstRelatedListRecord = getRelatedListRecords(tabRecord, new Set<String>(relatedListConfiguration.mapColumnFields.values()));
                                                }
                                            }
                                        } else {
                                            rollbackWithError(objSFDCEncoder.SFDC_HTMLENCODE(System.Label.FC_ConfigurationProcess_ErrorMsg), null);
                                            return;
                                        }
                                    }
                                } else if ('Organization Tab'.equalsIgnoreCase(strRLCRecordTypeName)) {
                                    currentTabType = 'Organization Tab';
                                    bIsOrganizationTab = true;
                                    getOrganizationRecord();
                                    organizationTabInstructions = tabRecord;
                                } else if ('Contact Tab'.equalsIgnoreCase(strRLCRecordTypeName)) {
                                    currentTabType = 'Contact Tab';
                                    bIsContactTab = true;
                                    getContactRecord();
                                    contactTabInstructions = tabRecord;
                                } else if ('Custom Profile Tab'.equalsIgnoreCase(strRLCRecordTypeName)) {
                                    bIsCstPrflTab = true;
                                    currentTabType = 'Custom Profile Tab';
                                    for (integer iCount = 0; iCount < tabsList.size(); iCount++) {
                                        if (tabsList[iCount].Id == selectedTab) {
                                            objCurrentCustomProfileTabParent = tabsList[iCount];
                                        }
                                    }
                                    if (objCurrentCustomProfileTabParent != null && objCurrentCustomProfileTabParent.Cloned_from__c != null) {
                                        objCurrentCustomProfileTab = [
                                            SELECT
                                                Name,
                                                ObjectName__c,
                                                ShowNewButton__c,
                                                Hide_Edit_Link__c,
                                                ShowDeleteLink__c,
                                                FieldHeaders__c,
                                                RichInstructionalText__c,
                                                LookupField__c,
                                                FieldNames__c
                                            FROM Related_List_Controller__c
                                            WHERE Id = :objCurrentCustomProfileTabParent.Cloned_from__c
                                            WITH SECURITY_ENFORCED
                                            LIMIT 1
                                        ];
                                    } else {
                                        objCurrentCustomProfileTab = new Related_List_Controller__c();
                                    }
                                    flagshowpopup = false;
                                    objCurrentCustomObjectRecord = null;
                                } else if (String.isNotBlank(strRLCRecordTypeName) && 'Portal Tab'.equalsIgnoreCase(strRLCRecordTypeName)) {
                                    currentTabType = 'Portal Tab';
                                    initilizeSubmissionList();
                                    isIFrame  = false;
                                } else if (String.isNotBlank(strRLCRecordTypeName) && 'IFrame Tab'.equalsIgnoreCase(strRLCRecordTypeName)) {
                                    currentTabType = 'IFrame Tab';
                                    isIFrame  = true;
                                    PageReference pageRef;
                                    String strParamKeyTemp;
                                    try {
                                        String strIFrameUrl = tabRecord.BaseUrl__c.remove('{');
                                        strIFrameUrl = strIFrameUrl.remove('}').tolowercase();
                                        pageRef = new PageReference(strIFrameUrl);
                                        Map<String, String> mapOldURLParams = new Map<String, String>();
                                        mapOldURLParams = pageRef.getParameters();
                                        if (mapOldURLParams.values().size() > 0) {
                                            for (String strParamKey : mapOldURLParams.keySet()) {
                                                strParamKeyTemp = strParamKey;
                                                String strParamVal = mapOldURLParams.get(strParamKey);
                                                if (strParamVal.countMatches('.') == 1) {
                                                    String strObjName = strParamVal.substring(0, strParamVal.indexOf('.'));
                                                    String strFieldName = strParamVal.subString(strParamVal.indexOf('.') + 1, strParamVal.length());
                                                    sObject sObj = mapObjNameObjDetails.get(strObjName.tolowercase());
                                                    if (sObj != null) {
                                                        try {
                                                            if (sObj.get(strFieldName) != null) {
                                                                pageRef.getParameters().put(strParamKey, string.valueOf(sObj.get(strFieldName)));
                                                            } else {
                                                                pageRef.getParameters().put(strParamKey, 'null');
                                                            }
                                                        } catch (SObjectException sObjEx) {
                                                            system.debug( 'Exception: ' + sObjEx +'at Line: '+sObjEx.getLineNumber()+' stackTrace: '+sObjEx.getStackTraceString());
                                                            pageRef.getParameters().put(strParamKey, 'null');
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    } catch (Exception ex) {
                                        system.debug( 'Exception: ' + ex +'at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
                                        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex ) );
                                    }
                                    iFrameURL = pageRef.getUrl();
                                    quizQuestionList = new List<Quiz_Questions__c>();
                                } else if (String.isNotBlank(strRLCRecordTypeName) && 'Grantee Budget Tab'.equalsIgnoreCase(strRLCRecordTypeName)) {
                                    if (application.get('FGM_Base__Start_Date__c') != null && application.get('FGM_Base__Start_Date__c') != '') {
                                        strBudgetStartDate = Date.valueOf(application.get('FGM_Base__Start_Date__c')).format();
                                        dateFrom = strBudgetStartDate;
                                    } else {
                                        strBudgetStartDate = null;
                                        dateFrom = '';
                                    }
                                    if (application.get('FGM_Base__End_Date__c') != null && application.get('FGM_Base__End_Date__c') != '') {
                                        strBudgetEndDate = Date.valueOf(application.get('FGM_Base__End_Date__c')).format();
                                        dateTo = strBudgetEndDate;
                                    } else {
                                        strBudgetEndDate = null;
                                        dateTo = '';
                                    }
                                    currentTabType = 'Grantee Budget Tab';
                                    isIFrame  = false;
                                    tabObject = application;
                                    isGranteeBudget=true;
                                    if (relatedListConfiguration == null && application != null && application.id != null) {
                                        relatedListConfiguration = new relatedList();
                                        relatedListConfiguration.record = tabRecord;
                                    }
                                    if (relatedListConfiguration == null && application == null && application.id == null) {
                                        relatedListConfiguration = new relatedList();
                                        relatedListConfiguration.record = tabRecord;
                                    }
                                    Integer count = 0;
                                    if (String.isNotBlank(strSelectedappId)) {
                                        count = [
                                            SELECT COUNT()
                                            FROM Grantee_Budget_Line_Item__c
                                            WHERE Opportunity__c = :Id.valueOf(strSelectedappId)
                                            WITH SECURITY_ENFORCED
                                            LIMIT 50
                                        ];
                                    }
                                    if (count > 0) {
                                        isBudgetExist = true;
                                        generateExistingBudget();
                                    } else {
                                        isBudgetExist = false;
                                    }
                                    nextTabID = getNextTab();
                                }
                            }
                            initializeAttachment();
                        }
                    }
                    if(strRLCObjectName == 'OpportunityTeamMember') {
                        quizQuestionListForOTM = quizQuestionList;
                    }
                }
            }
        } catch (Exception ex) {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,' ' + ex.getMessage()));
        }
    }

    /**
     * @description This is a method to close invite member pop-up by setting
     * related flags to false.
     */
    public void closeOpportunityTeamMemberPopup() {
        newOpportunityMemberPortalUser = null;
        newOpportunityMember = null;
        isNewOpportunityTeamMemberView = false;
        portalUserRequestTeamMember = null;
        applicationAccessLevel = '';
        isDuplicateUserFound = false;
        strDuplicateUserFoundErrorMessage = '';
        selectedTeamRoleVal ='';
    }

    /**
     * @description This is a method to initialize pending invited members
     * table.
     */
    private void initializeNewPortalUserTeamMembersList() {
        try
        {
            portalUserTeamMembersRelatedListConfiguration = new relatedList();
            portalUserTeamMembersRelatedListConfiguration.strRelatedListObject = '';
            portalUserTeamMembersRelatedListConfiguration.isCreatable = true;
            portalUserTeamMembersRelatedListConfiguration.isEditable = true;
            portalUserTeamMembersRelatedListConfiguration.isDeletable = true;
            portalUserTeamMembersRelatedListConfiguration.mapColumnFields =  getPortalUserTeamMemberColumns();
            portalUserTeamMembersRelatedListConfiguration.lstColumnFields =  getPortalUserTeamMemberColumnsList(portalUserTeamMembersRelatedListConfiguration.mapColumnFields);
            portalUserTeamMembersRelatedListConfiguration.relatedListLookUp =  '';
            if(!portalUserTeamMembersRelatedListConfiguration.mapColumnFields.isEmpty())
                portalUserTeamMembersRelatedListConfiguration.lstRelatedListRecord = getPendingTeamMembersList(new Set<String>(portalUserTeamMembersRelatedListConfiguration.mapColumnFields.values()));
        }
        catch( Exception ex )
        {
            system.debug( 'Exception: ' + ex.getMessage() + '; Line number: ' + ex.getLineNumber() + '; Stacktrace: ' + ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ' ' + ex.getMessage()  ) );
        }
    }

    /**
     * @description This is a method to initialize pending invited members
     * table columns.
     */
    private List<String> getPortalUserTeamMemberColumnsList(Map<String, String> mapColumnFields) {
        LIST<String> lstColumnFields=new  LIST<String>();
        for(String field :mapColumnFields.keySet())
            lstColumnFields.add(field);
        return lstColumnFields;
    }

    @TestVisible
    /**
     * @description This is a method to get pending invited member records.
     */
    private List<sObject> getPendingTeamMembersList(Set<String> portalUserFields) {
        List<sObject> lstPendingOpportunityMemberList = new List<sObject>();
        List<sObject> portalUserObject;
        if(portalUserFields != null && !portalUserFields.isEmpty()){
            if(portalUserFields != null && !portalUserFields.isEmpty() && application != null && application.Id != null){
                String applicationOwnerId = UserInfo.getUserId();
                String applicationId = application.Id;
                Boolean isOpportunityRecord = 'Opportunity'.equalsIgnoreCase(FCGlobal.getObjectNameById(application.Id));
                if(isOpportunityRecord){
                    String strPortalUserField = String.valueOf(PortalUserRequestTeamMembers__c.PortalUser__c);
                    strPortalUserField = strPortalUserField.replace('__c','__r');
                    //add Required Fields
                    Set<String> lstRequiredFields = new Set<String>{strPortalUserField +'.Salutation__c'
                        ,strPortalUserField +'.Phone__c'
                        ,strPortalUserField +'.IsActive__c'
                        ,strPortalUserField +'.' + String.valueOf(Portal_User__c.GrantedPortalAccess__c)
                        ,String.valueOf(PortalUserRequestTeamMembers__c.PortalUser__c)
                        ,String.valueOf(PortalUserRequestTeamMembers__c.ApplicationAccessLevel__c)
                        };
                            for(String requiredField : lstRequiredFields){
                                if(!portalUserFields.contains(requiredField))
                                    portalUserFields.add(requiredField);
                            }

                    List<String> sanitizedPortalUserFields = new List<String>();

                    for (String portalUserField : portalUserFields) {
                        sanitizedPortalUserFields.add(portalUserField.replaceAll('[^0-9a-zA-Z_.]', ''));
                    }

                    portalUserObject = Database.query(''
                                                      + 'SELECT Id, '+ String.join(new List<String>(sanitizedPortalUserFields), ', ')
                                                      + '  FROM  '+ Schema.SObjectType.PortalUserRequestTeamMembers__c.getName()
                                                      + ' WHERE  '+ String.valueOf(PortalUserRequestTeamMembers__c.SharedRequest__c)  +'= :applicationId'
                                                      + '   AND '+ strPortalUserField +'.'+ String.valueOf(Portal_User__c.Approval_Status__c) +' != :CONVERTED_STATUS_VALUE'
                                                      + ' WITH SECURITY_ENFORCED'
                                                      + ' LIMIT 1000');

                    if(portalUserObject != null && !portalUserObject.isEmpty())
                    {
                        for(sObject objPortalUser : portalUserObject)
                        {
                            objPortalUser.put('FGM_Portal__UserRole__c',  objPortalUser.get('FGM_Portal__UserRole__c'));//mapOTMolePicklistEnrties.get(  String.valueOf(objPortalUser.get('FGM_Portal__UserRole__c'))  ) );
                        }
                        lstPendingOpportunityMemberList.addAll(portalUserObject);
                    }
                }
            }
        }
        return lstPendingOpportunityMemberList;
    }

    /**
     * @description This is a method to initialize Fixed columns for pending
     * invited member table.
     */
    private Map<String,String> getPortalUserTeamMemberColumns() {
        Map<String,String> mapPortalUserTeamMemberColumns = new Map<String,String>();

        // This code pattern used to work this code after this class packaged.
        String strPortalUserField = String.valueOf(PortalUserRequestTeamMembers__c.PortalUser__c);
        strPortalUserField = strPortalUserField.replace('__c','__r');
        mapPortalUserTeamMemberColumns.put(Label.FC_FirstName_ColumnHeaderLabel,strPortalUserField + '.FirstName__c');
        mapPortalUserTeamMemberColumns.put(Label.FC_LastName_ColumnHeaderLabel,strPortalUserField + '.LastName__c');
        mapPortalUserTeamMemberColumns.put(Label.FC_Email_ColumnHeaderLabel,strPortalUserField + '.Email__c');
        mapPortalUserTeamMemberColumns.put(Label.FC_Status_ColumnHeaderLabel,strPortalUserField + '.'+ String.valueOf(Portal_User__c.Approval_Status__c));
        mapPortalUserTeamMemberColumns.put(Label.FC_Role_ColumnHeaderLabel,String.valueOf(PortalUserRequestTeamMembers__c.UserRole__c));
        return mapPortalUserTeamMemberColumns;
    }

    /**
     * @description This is a method to edit OTM record.
     */
    public void editOpportunityMember() {
        isNewOpportunityTeamMemberView = false;
        String strRecordIndex = getParam('recordIndex');
        List<Sobject> lstApplicationRecords;
        if(portalUserTeamMembersRelatedListConfiguration != null && String.isNotBlank(strRecordIndex)){
            integer recordIndex = integer.valueOf(strRecordIndex);
            if(recordIndex != null && portalUserTeamMembersRelatedListConfiguration.lstRelatedListRecord != null && recordIndex < portalUserTeamMembersRelatedListConfiguration.lstRelatedListRecord.size())
            {
                object oldrelatedlistRecord = portalUserTeamMembersRelatedListConfiguration.lstRelatedListRecord[recordIndex];
            if(oldrelatedlistRecord != null){
                PortalUserRequestTeamMembers__c record = (PortalUserRequestTeamMembers__c)oldrelatedlistRecord;
                if(record == null)
                    return;
                newOpportunityMemberPortalUser = new Portal_User__c();
                // FCPROD-156:for getting customizable fields for invite Opportunty team member
                String applicationObjectName = String.valueOf(newOpportunityMemberPortalUser.getsObjectType());
                String applicationRecordId = String.valueOf(record.PortalUser__c);
                Map<String, Schema.SObjectField> mapFields = FGM_Portal__Portal_User__c.sObjectType.getDescribe().fields.getMap();
                List<String> lstApplicationObjectFields = new List<String>(this.getCrudFlsService().getReadableFields(applicationObjectName));

                    lstApplicationRecords = Database.query(''
                                                           + 'SELECT ' + String.join(lstApplicationObjectFields, ', ')
                                                           +' FROM '+ applicationObjectName
                                                           +' WHERE Id=:applicationRecordId'                                                           
                                                           +' LIMIT 1' 
                                                           );

                    if(lstApplicationRecords != null && lstApplicationRecords.size()>0){
                        //Stripping fields the running user does not have access to from the object query:                                       
                        SObjectAccessDecision decision = Security.stripInaccessible(AccessType.READABLE, lstApplicationRecords);
                        lstApplicationRecords = decision.getRecords();
                        //setting the portal user
                        record.PortalUser__r = (Portal_User__c) lstApplicationRecords[0];
                    }
                        
                    newOpportunityMember = new OpportunityTeamMember();
                    newOpportunityMemberPortalUser  = record.PortalUser__r;

                    if(isConsultant)
                        selectedTeamRoleVal = record.UserRole__c;
                    else
                        if(string.isBlank(record.UserRole__c))
                        newOpportunityMember.put('TeamMemberRole', Schema.sObjectType.OpportunityTeamMember.getSObjectType().getDescribe().fields.getMap().get('teammemberrole').getDescribe().getPickListValues()[0].getvalue());
                    else
                        newOpportunityMember.TeamMemberRole = record.UserRole__c;
                    applicationAccessLevel =  record.ApplicationAccessLevel__c;
                    isDuplicateUserFound = false;
                    strDuplicateUserFoundErrorMessage = '';
                }
            }
        }
    }

    /**
     * @description This is a method to delete OTM record.
     */
    public void deleteOpportunityMember() {
        String strRecordIndex = getParam('recordIndex');
        if(portalUserTeamMembersRelatedListConfiguration != null && String.isNotBlank(strRecordIndex)){
            integer recordIndex = integer.valueOf(strRecordIndex);
            if(recordIndex != null && recordIndex < portalUserTeamMembersRelatedListConfiguration.lstRelatedListRecord.size()){
                PortalUserRequestTeamMembers__c oldrelatedlistRecord = (PortalUserRequestTeamMembers__c) portalUserTeamMembersRelatedListConfiguration.lstRelatedListRecord[recordIndex];
                if(oldrelatedlistRecord != null && oldrelatedlistRecord.PortalUser__c != null){
                    try{
                        Portal_User__c portalUserToDelete = new Portal_User__c();
                        portalUserToDelete.Id = oldrelatedlistRecord.PortalUser__c;
                        AdminContextExecutionManager.executeDelete(new List<Sobject>{portalUserToDelete});
                        portalUserTeamMembersRelatedListConfiguration.lstRelatedListRecord.remove(recordIndex);
                    }
                    catch(Exception ex){
                        System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
                        rollbackWithError(ex.getMessage(),null);
                    }
                }
            }
        }
    }

    /**
     * @description This is a method to view OTM record.
     */
    public void viewOpportunityMember() {
        List<sObject> lstApplicationRecords;
        String strRecordIndex = getParam('recordIndex');
        if(portalUserTeamMembersRelatedListConfiguration != null && String.isNotBlank(strRecordIndex)){
            integer recordIndex = integer.valueOf(strRecordIndex);
            if(recordIndex != null && portalUserTeamMembersRelatedListConfiguration.lstRelatedListRecord != null && recordIndex < portalUserTeamMembersRelatedListConfiguration.lstRelatedListRecord.size()){
                object oldrelatedlistRecord = portalUserTeamMembersRelatedListConfiguration.lstRelatedListRecord[recordIndex];
                if(oldrelatedlistRecord != null){
                    PortalUserRequestTeamMembers__c record = (PortalUserRequestTeamMembers__c)oldrelatedlistRecord;
                    if(record == null)
                        return;
                    // FCPROD-156:for getting customizable fields for invite Opportunty team member
                    newOpportunityMemberPortalUser = new Portal_User__c();
                    String applicationObjectName = String.valueOf(newOpportunityMemberPortalUser.getsObjectType());
                    String applicationRecordId = String.valueOf(record.PortalUser__c);

                    Map<String, Schema.SObjectField> mapFields = FGM_Portal__Portal_User__c.sObjectType.getDescribe().fields.getMap();
                    List<String> lstApplicationObjectFields = new List<String>(this.getCrudFlsService().getReadableFields(applicationObjectName));

                    lstApplicationRecords = Database.query(''
                                                           + 'SELECT ' + String.join(lstApplicationObjectFields, ', ')
                                                           +' FROM '+ applicationObjectName
                                                           +' WHERE Id=:applicationRecordId'
                                                           +' LIMIT 1' );

                    if(lstApplicationRecords != null && lstApplicationRecords.size()>0){
                        //Stripping fields the running user does not have access to from the object query:                                       
                        SObjectAccessDecision decision = Security.stripInaccessible(AccessType.READABLE, lstApplicationRecords);
                        lstApplicationRecords = decision.getRecords();
                        //setting the portal user                        
                        record.PortalUser__r = (Portal_User__c) lstApplicationRecords[0];
                    }
                        
                    newOpportunityMemberPortalUser = record.PortalUser__r;
                    newOpportunityMember = new OpportunityTeamMember();
                    newOpportunityMember.TeamMemberRole = record.UserRole__c;
                    applicationAccessLevel = record.ApplicationAccessLevel__c;
                    isDuplicateUserFound = false;
                    strDuplicateUserFoundErrorMessage = '';
                    isNewOpportunityTeamMemberView = true;
                }
            }
        }
    }

    /**
     * @description This is a method to invite new OTM. A pop-up is shown to invite user.
     */
    public void openOpportunityTeamMemberPopup() {
        newOpportunityMemberPortalUser = new Portal_User__c();
        newOpportunityMemberPortalUser.GrantedPortalAccess__c = true;
        newOpportunityMember = new OpportunityTeamMember();
        isNewOpportunityTeamMemberView = false;
        isDuplicateUserFound = false;
        strDuplicateUserFoundErrorMessage = '';
    }

    //No reference
    public void openNewContact() {
        isNewContactView = True;
        newContact = new Contact();
    }

    /**
     * @description This is a method to cancel edit of contact Tab.
     */
    public void cancelNewContact() {
        isNewContactView = False;
        newContact = null;
    }

    /**
     * @description This is a method to update the contact record.
     */
    public void saveNewContact() {
        try
        {
            Database.SaveResult svRslt;
            if(newContact != null)
            {
                if(user != null && user.Contact != null && user.Contact.AccountId != null)
                {
                    newContact.AccountID = user.Contact.AccountId;
                    newContact.Languages__c = portalLanguage;
                }
                CrudFlsService.getInstance().assertCreateable(newContact);
                svRslt = Database.insert(newContact);
                if(svRslt.isSuccess())
                {
                    tabObject.put('ContactId', svRslt.getId());
                }

            }
            else
                if(string.isNotBlank(newContact.ID))
            {
                CrudFlsService.getInstance().assertUpdateable(newContact);
                svRslt = Database.update(newContact);
                if(svRslt.isSuccess())
                {
                    cancelNewContact();
                }
            }


        }
        catch(Exception ex)
        {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, ' ' + ex.getMessage() ));
        }
    }

    /**
     * @description This is a method to save the invited team member record and
     * create Portal user and Portal uer request Team member's record.
     */
    public PageReference saveOpportunityTeamMember() {
        GlobalPortalSettings__c globalSetting = GlobalPortalSettings__c.getInstance();
        string strapplicationOwnerRole = globalSetting.Application_Ownership_Role__c;
        User[] userList;
        Integer duplicateUserCount;
        Portal_User__c portalUser;
        PortalUserRequestTeamMembers__c objPortalUserRequestTeamMembers ;
        Set <String> setapplicationOwnerRole=FCGlobal.getApplicationOwnerRoleSet(strapplicationOwnerRole);
        if(strapplicationOwnerRole == null || String.isBlank(strapplicationOwnerRole))
            setapplicationOwnerRole.add(APPLICANT);
        if(newOpportunityMemberPortalUser != null && newOpportunityMember != null && application != null && application.Id != null)
        {
            Boolean isOpportunityRecord = 'opportunity'.equalsIgnoreCase(FCGlobal.getObjectNameById(application.Id));
            if(!isOpportunityRecord)
                return null;
            try
            {

                userList = [
                    SELECT
                        AccountId,
                        ContactId
                    FROM User
                    WHERE Id = :UserInfo.getUserId()
                    WITH SECURITY_ENFORCED
                    LIMIT 1
                ];

                // condition to check this record belong to perticular user or not
                if (userList == null || userList.isEmpty() && userList[0].ContactId == null && userList[0].AccountId == null)
                    return null;
                if(newOpportunityMemberPortalUser.Id == null)
                {

                    duplicateUserCount = [
                        SELECT COUNT()
                        FROM User
                        WHERE AccountId = :userList[0].AccountId
                        AND UserEmail__c = :newOpportunityMemberPortalUser.Email__c
                        WITH SECURITY_ENFORCED
                    ];

                    if(duplicateUserCount > 0)
                    {
                        isDuplicateUserFound = true;
                        strDuplicateUserFoundErrorMessage = Label.FC_DuplicationUserFoundMessage;
                        return null;
                    }
                    Portal_User__c[] lstPortalUser = null;

                    if(isConsultant)
                    {
                        if(portalUserTeamMembersRelatedListConfiguration != null && portalUserTeamMembersRelatedListConfiguration.lstRelatedListRecord != null && portalUserTeamMembersRelatedListConfiguration.lstRelatedListRecord.size() > 0)
                            return rollbackWithError('You can not add two '+ strapplicationOwnerRole +' for an application',null);

                        lstPortalUser = new List<Portal_User__c>();
                        lstPortalUser.add(newOpportunityMemberPortalUser);
                        newOpportunityMemberPortalUser.FGM_Portal__ProfileType__c = 'Individual';
                        newOpportunityMemberPortalUser.Organization_Legal_Name__c = newOpportunityMemberPortalUser.FirstName__c + ' ' + newOpportunityMemberPortalUser.LastName__c;
                    }
                    else
                    {

                        lstPortalUser = [
                            SELECT
                                Account__r.Name,
                                City__c,
                                Country__c,
                                EIN__c,
                                Email__c,
                                Fax__c,
                                Security_Question__c,
                                State_List__c,
                                State__c,
                                Street_New__c,
                                Zip_Code__c
                            FROM Portal_User__c
                            WHERE Contact__c = :userList[0].ContactId
                            AND Account__c = :userList[0].AccountId
                            WITH SECURITY_ENFORCED
                            LIMIT 1
                        ];

                        newOpportunityMemberPortalUser.Account__c = userList[0].AccountId;
                        if(lstPortalUser != null && lstPortalUser.size() > 0)
                            newOpportunityMemberPortalUser.Organization_Legal_Name__c = lstPortalUser[0].Account__r.Name;
                        newOpportunityMemberPortalUser.FGM_Portal__ProfileType__c = 'Organization';
                    }
                    if (lstPortalUser == null || lstPortalUser.isEmpty())
                        return null;
                    set<String> setportaluserFields = new set<String>(new List<String>{ 'FGM_Portal__Zip_Code__c', 'FGM_Portal__Country__c', 'FGM_Portal__City__c', 'FGM_Portal__EIN__c', 'FGM_Portal__Fax__c', 'FGM_Portal__State__c', 'FGM_Portal__Street_New__c', 'FGM_Portal__State_List__c'}) ;
                    // FCPROD-156 :for getting customizable fields for invite Opportunty team member
                    set<string> fieldsetFields = new set<String>();
                    for(Schema.FieldSetMember f :  SObjectType.Portal_User__c.FieldSets.InviteOpportunityTeamMemberFields.getFields())
                    {
                        fieldsetFields.add(f.fieldPath);
                    }
                    Sobject sExistingPortalUser = lstPortalUser[0];

                    for(String key:setportaluserFields)
                    {
                        if(!fieldsetFields.contains(key))
                            newOpportunityMemberPortalUser.put(key,sExistingPortalUser.get(key));
                    }
                    newOpportunityMemberPortalUser.Confirm_Email__c = newOpportunityMemberPortalUser.Email__c;
                    newOpportunityMemberPortalUser.Domain__c = Site.getDomain();
                    newOpportunityMemberPortalUser.Terms_And_Conditions__c = true;
                    newOpportunityMemberPortalUser.IsActive__c = false;
                    newOpportunityMemberPortalUser.Confirmation_Code__c = String.valueOf(Math.random() * 1000000);
                    newOpportunityMemberPortalUser.User_Profile__c = 'Grantee';
                    newOpportunityMemberPortalUser.IsCreatedByOpportunityTeamMember__c = true;
                    newOpportunityMemberPortalUser.FGM_Portal__Password__c = 'Pragati@1234';
                    newOpportunityMemberPortalUser.FGM_Portal__Confirm_Password__c = 'Pragati@1234';
                    newOpportunityMemberPortalUser.RecordTypeId = FCGlobal.getRecordTypeId(String.valueOf(Portal_User__c.sObjectType),'Opportunity Team Member');
                    CrudFlsService.getInstance().assertCreateable(newOpportunityMemberPortalUser);
                    insert newOpportunityMemberPortalUser;
                    //Create new portalUserTeamMember Record
                    portalUserRequestTeamMember = new PortalUserRequestTeamMembers__c();
                    portalUserRequestTeamMember.SharedRequest__c = application.Id;
                    portalUserRequestTeamMember.PortalUser__c = newOpportunityMemberPortalUser.Id;
                    if(newOpportunityMember.TeamMemberRole != null)
                        if(isConsultant)
                        portalUserRequestTeamMember.UserRole__c = newOpportunityMember.TeamMemberRole;
                    else
                        portalUserRequestTeamMember.UserRole__c = newOpportunityMember.TeamMemberRole;

                    portalUserRequestTeamMember.ApplicationAccessLevel__c = applicationAccessLevel;

                    // Did FC auto-create a contact?
                    portalUser = [
                        SELECT
                            Contact__c,
                            Portal_Account__c
                        FROM Portal_User__c
                        WHERE Id = :newOpportunityMemberPortalUser.Id
                        WITH SECURITY_ENFORCED
                    ];

                    if (portalUser.Contact__c != null)
                    {
                        Contact contactToDelete = new Contact(Id = portalUser.Contact__c);
                        CrudFlsService.getInstance().assertDeletable(contactToDelete);
                        delete contactToDelete;
                    }
                    if (portalUser.Portal_Account__c != null)
                    {
                        Portal_Account__c portalAccountToDelete = new Portal_Account__c(Id = portalUser.Portal_Account__c);
                        CrudFlsService.getInstance().assertDeletable(portalAccountToDelete);
                        delete portalAccountToDelete;
                    }
                    savePortalUserRequestTeamMember();
                }
                else if(newOpportunityMemberPortalUser.Id != null)
                {
                    //FCPROD-315 Cannot edit the Invited request team member Role
                    List<Sobject> lstSobject = new List<Sobject>();

                    objPortalUserRequestTeamMembers = [
                        SELECT Id
                        FROM PortalUserRequestTeamMembers__c
                        WHERE SharedRequest__c = :application.Id
                        AND PortalUser__c = :newOpportunityMemberPortalUser.Id
                        WITH SECURITY_ENFORCED
                        LIMIT 1
                    ];

                    if(objPortalUserRequestTeamMembers!=null && newOpportunityMember.TeamMemberRole != null)
                    {
                        if(isConsultant)
                            objPortalUserRequestTeamMembers.UserRole__c = newOpportunityMember.TeamMemberRole;
                        else
                            objPortalUserRequestTeamMembers.UserRole__c =  newOpportunityMember.TeamMemberRole;
                        lstSobject.add(objPortalUserRequestTeamMembers);
                    }

                    // Did FC auto-create a contact?
                    portalUser = [
                        SELECT
                            Contact__c,
                            Email__c,
                            GrantedPortalAccess__c,
                            Portal_Account__c
                        FROM Portal_User__c
                        WHERE Id = :newOpportunityMemberPortalUser.Id
                        WITH SECURITY_ENFORCED
                    ];

                    if(!newOpportunityMemberPortalUser.Email__c.equalsIgnoreCase(portalUser.Email__c)){
                        newOpportunityMemberPortalUser.Confirmation_Code__c = String.valueOf(Math.random() * 1000000);
                        newOpportunityMemberPortalUser.Confirm_Email__c = newOpportunityMemberPortalUser.Email__c;
                        newOpportunityMemberPortalUser.IsActive__c = false;
                        newOpportunityMemberPortalUser.RecordTypeId = FCGlobal.getRecordTypeId(String.valueOf(Portal_User__c.sObjectType),'Opportunity Team Member');
                        newOpportunityMemberPortalUser.Confirmation_Date__c = null;
                        lstSobject.add(newOpportunityMemberPortalUser);
                    }
                    else if(newOpportunityMemberPortalUser.GrantedPortalAccess__c && !portalUser.GrantedPortalAccess__c)
                    {
                        newOpportunityMemberPortalUser.Confirmation_Code__c = String.valueOf(Math.random() * 1000000);
                        newOpportunityMemberPortalUser.IsActive__c = false;
                        newOpportunityMemberPortalUser.RecordTypeId = FCGlobal.getRecordTypeId(String.valueOf(Portal_User__c.sObjectType),'Opportunity Team Member');
                        newOpportunityMemberPortalUser.Confirmation_Date__c = null;
                        lstSobject.add(newOpportunityMemberPortalUser);
                    }
                    else
                        lstSobject.add(newOpportunityMemberPortalUser);

                    this.getAdminContextExecutionManager().stripInaccessibleAndUpdate(lstSobject);
                    if (portalUser.Contact__c != null){
                        Contact contactToDelete = new Contact(Id = portalUser.Contact__c);
                        CrudFlsService.getInstance().assertDeletable(contactToDelete);
                        delete contactToDelete;
                    }
                }
                closeOpportunityTeamMemberPopup();
                if(portalUserTeamMembersRelatedListConfiguration != null)
                    portalUserTeamMembersRelatedListConfiguration.lstRelatedListRecord = getPendingTeamMembersList(new Set<String>(portalUserTeamMembersRelatedListConfiguration.mapColumnFields.values()));
            }
            catch(DMLException ex)
            {
                System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
                String errorMessage = ex.getMessage();
                Integer occurence;
                if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
                {
                    occurence = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
                    errorMessage = errorMessage.mid(occurence, errorMessage.length());
                    occurence = errorMessage.lastIndexOf(':');
                    errorMessage = errorMessage.mid(0, occurence);
                    return rollbackWithError(errorMessage,null);
                }
                else
                    return rollbackWithError(ex.getMessage(),null);
            }
            catch(Exception ex)
            {
                system.debug( 'Exception: ' + ex +' at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,' ' + ex.getMessage()));
            }
        }
        return null;
    }

    /**
     * @description This is a method to create portal user require team member
     * record on save of invite new team member.
     */
    public PageReference savePortalUserRequestTeamMember() {
        if(portalUserRequestTeamMember != null && portalUserRequestTeamMember.PortalUser__c != null && portalUserRequestTeamMember.SharedRequest__c != null)
            AdminContextExecutionManager.executeInsert(new List<Sobject>{portalUserRequestTeamMember});
        return null;
    }

    /**
     * @description Thi is a method to initialize portal Tab.
     */
    private void initilizeSubmissionList() {
        Id appID = objSFDCEncoder.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('appID'));
        String strcurrentParentObject = currentParentObject;

        if (appID != null) {
            currentParentObject = appId.getSObjectType().getDescribe().getName().tolowercase();
        }

        if (currentParentObject != null) {

            if ((!tabsList[0].ParentObject__c.equalsIgnoreCase('Lead') && currentParentObject.equalsIgnoreCase('Lead')) || (!tabsList[0].ParentObject__c.equalsIgnoreCase('Opportunity') &&  currentParentObject.equalsIgnoreCase('Opportunity'))) {
                initializeApplication();
            }

            if (tabsList[0].RecordType.Name=='Portal Tab' && application != null && application.Id==null &&selectedTab==tabsList[0].Id &&bisFirstPortalTab==true && isAppOrLeadUnsubmitted==true) {
                bisFirstPortalTab=false;
            }

        }

        currentParentObject = strcurrentParentObject;
        tabObject = application;
        applicationOnReview = application;

        if (application != null && application.Id != null) {
            tabRecordId = application.Id;
            // What are the fields in the question responses?
            Set<String> fieldSet = new Set<String>();
            if (quizQuestionList != null && quizQuestionList.size() > 0) {
                for (Quiz_Questions__c quizQuestion : quizQuestionList) {
                    if (String.isNotBlank(quizQuestion.Field__c)) {
                        fieldSet.add(quizQuestion.Field__c.toLowerCase());
                    }
                }
            }
        }
    }

    /**
     * @description This is a method to get related list columns for Related
     * List Tab.
     */
    private Map<String,String> getrelatedListColumn(Related_List_Controller__c relatedListController) {
        Map<String,String> mapColumns = new Map<String,String>();
        if(relatedListController != null)
        {
            String[] lstColumnLabels, lstColumnFields;
            if(String.isNotBlank(relatedListController.FieldHeaders__c))
                lstColumnLabels = relatedListController.FieldHeaders__c.split(',');
            if(String.isNotBlank(relatedListController.FieldNames__c))
                lstColumnFields = relatedListController.FieldNames__c.split(',');
            if(lstColumnLabels != null && lstColumnFields != null)
            {
                integer index = 0;
                for(String columnLabel : lstColumnLabels)
                {
                    if( lstColumnFields[index] != null && String.isNotBlank( lstColumnFields[index] ) )
                    {
                        String strFieldName = lstColumnFields[index];
                        if(!strFieldName.equalsIgnoreCase('additional_roles__c'))
                            mapColumns.put(columnLabel, strFieldName.toLowerCase());
                        index++;
                    }
                }
            }
        }
        return mapColumns;
    }

    /**
     * @description This is a method to get list of column labels of Related List tab.
     */
    private List<String> getrelatedListColumnList(Related_List_Controller__c relatedListController) {
        LIST<String> lstColumnFields=new  LIST<String>();
        if(relatedListController != null && String.isNotBlank(relatedListController.FieldHeaders__c))
            lstColumnFields = new LIST<String>(relatedListController.FieldHeaders__c.split(','));
        return lstColumnFields;
    }

    /**
     * @description To Assign application back to Consultant.
     */
    public void assignToConsultant() {
        List<OpportunityTeamMember> lstOpportunityTeamMember ;
        if(isOpportunity && applicationConsultant != null && application != null && application.Id != null){
            OpportunityTeamMember newOpportunityTeamMember = new OpportunityTeamMember();
            newOpportunityTeamMember.OpportunityId = application.Id;
            newOpportunityTeamMember.UserId = applicationConsultant;
            newOpportunityTeamMember.TeamMemberRole = 'Consultant';
            AdminContextExecutionManager.executeInsert(new List<Sobject>{newOpportunityTeamMember});

            lstOpportunityTeamMember = [
                SELECT
                    OpportunityId,
                    UserId
                FROM OpportunityTeamMember
                WHERE OpportunityId = :application.Id
                AND UserId = :applicationConsultant
                AND TeamMemberRole = 'Consultant'
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            List<OpportunityShare> oppShares = new List<OpportunityShare>();
            if(lstOpportunityTeamMember != null && lstOpportunityTeamMember.size() > 0){
                for(OpportunityTeamMember oppTeam : lstOpportunityTeamMember){
                    OpportunityShare os = new OpportunityShare();
                    os.OpportunityId = oppTeam.OpportunityId;
                    os.OpportunityAccessLevel = 'Edit';
                    os.UserOrGroupId = oppTeam.UserId;
                    os.RowCause = 'Manual';
                    oppShares.add(os);
                }
            }
            CrudFlsService.getInstance().assertCreateable(oppShares);
            Database.SaveResult[] result = Database.insert(oppShares, false);
            isAssignedTOConsultant = true;
        }
    }

    /**
     * @description To Remove application permission from Consultant.
     */
    public void removeConsultant() {
        List<OpportunityTeamMember> lstApplicationMemeber;
        if(isOpportunity && applicationConsultant != null && application != null && application.Id != null){

            lstApplicationMemeber = [
                SELECT Id
                FROM OpportunityTeamMember
                WHERE OpportunityId = :application.Id
                AND UserId = :applicationConsultant
                AND TeamMemberRole = 'Consultant'
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            if(lstApplicationMemeber != null && !lstApplicationMemeber.isEmpty()){
                try{
                    AdminContextExecutionManager.executeDelete(new List<Sobject>{lstApplicationMemeber[0]});
                    isAssignedTOConsultant = false;
                }
                catch(Exception ex)
                {
                    system.debug( 'Exception: ' + ex +'at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'' + ex.getMessage()));
                }
            }
        }
    }
    @TestVisible
    /**
     * @description This is a method to get Related list record based on related list object.
     */
    private List<Object> getRelatedListRecords(Related_List_Controller__c relatedListController, Set<String> setFields) {
        if (setFields.contains('additional_roles__c')) {
            setFields.remove('additional_roles__c');
        }

        List<Object> lstSobject = new List<Object>();
        List<Object> childObject = new List<Object>();
        List<Id> lstIds = new List<Id>();
        mapUserOppAccessLevel = null;

        try {
            if (quizQuestionList != null && quizQuestionList.size() > 0 && !isReviewSubmitPage) {
                for (Quiz_Questions__c quizQuestion : quizQuestionList) {
                    if (String.isNotBlank(quizQuestion.Field__c) && !setFields.contains(quizQuestion.Field__c) && !quizQuestion.Field__c.equalsIgnoreCase('additional_roles__c')) {
                        setFields.add(quizQuestion.Field__c.toLowerCase());
                    }
                }
            }

            if (String.isNotBlank(relatedListController.ParentObject__c) && String.isNotBlank(relatedListController.ObjectName__c) && String.isNotBlank(relatedListController.LookupField__c)) {
                if (setFields != null && !setFields.isEmpty() && application != null && application.Id != null) {
                    String applicationOwnerId = UserInfo.getUserId();
                    String applicationId = application.Id;
                    List<String> lstFieldsForFLSCheck = new List<String>();
                    lstFieldsForFLSCheck.addAll(setFields);
                    strRLCObjectName = relatedListController.ObjectName__c;

                    if (relatedListController.ObjectName__c == 'OpportunityTeamMember') {
                        for (string field : setFields) {
                            if (!field.equalsIgnoreCase('teammemberrole')) {
                                // Fixed FCPROD - 1298
                                setFields.add('teammemberrole');
                            }

                            if (!field.equalsIgnoreCase('userid')) {
                                // Fixed FCPROD - 1298
                                setFields.add('userid');
                            }

                            if (!field.equalsIgnoreCase('opportunityaccesslevel')) {
                                // Fixed FCPROD - 1298
                                setFields.add('opportunityaccesslevel');
                            }

                            if (!field.equalsIgnoreCase('FGM_Portal__ContactRoleID__c ')) {
                                setFields.add('FGM_Portal__ContactRoleID__c ');
                            }

                            if (!field.equalsIgnoreCase('User.ContactId')) {
                                setFields.add('User.ContactId');
                            }

                            if (!field.equalsIgnoreCase('User.Name')) {
                                setFields.add('User.Name');
                            }

                            if (!field.equalsIgnoreCase('opportunityid')) {
                                setFields.add('opportunityid');
                            }
                        }

                        List<String> lstOTMFieldsForFLSCheck = new List<String>{'FGM_Portal__ContactRoleID__c'};

                        List<String> sanitizedFields = new List<String>();

                        for (String f : setFields) {
                            sanitizedFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                        }

                        String sanitizedObjectName = relatedListController.ObjectName__c.replaceAll('[^0-9a-zA-Z_.]', '');
                        String sanitizedLookupField = relatedListController.LookupField__c.replaceAll('[^0-9a-zA-Z_.]', '');

                        childObject = Database.query(''+ 'SELECT Id, '+ String.join(new List<String>(sanitizedFields), ', ') + '  FROM  '+ sanitizedObjectName + ' WHERE  '+ sanitizedLookupField +'= :applicationId WITH SECURITY_ENFORCED LIMIT 1000');

                        if (relatedListController != null && string.isNotBlank(relatedListController.ObjectName__c) && 'OpportunityTeamMember'.equalsIgnoreCase(String.ValueOf(relatedListController.ObjectName__c).toLowerCase())) {
                            return fetchListOTMWrapper(childObject, applicationId);
                        }
                    }

                    String sortOredrField = relatedListController.FGM_Portal__SortField__c;
                    String order;

                    if (relatedListController.FGM_Portal__SortFieldOrder__c != null) {
                        order = relatedListController.SortFieldOrder__c == 'Ascending' ? 'ASC' : 'DESC';
                    }

                    String strQuery;

                    List<String> sanitizedFields = new List<String>();

                    for (String f : setFields) {
                        sanitizedFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                    }

                    String sanitizedObjectName = relatedListController.ObjectName__c.replaceAll('[^0-9a-zA-Z_.]', '');
                    String sanitizedLookupField = relatedListController.LookupField__c.replaceAll('[^0-9a-zA-Z_.]', '');
                    strQuery = ''+ 'SELECT Id, '+ String.join(new List<String>(sanitizedFields), ', ') + '  FROM  '+ sanitizedObjectName + ' WHERE  '+ sanitizedLookupField +'= :applicationId WITH SECURITY_ENFORCED';

                    if (sortOredrField !=null && !String.isBlank(sortOredrField)) {
                        strQuery = strQuery + ' ORDER BY '+sortOredrField.replaceAll('[^0-9a-zA-Z_.]', '')+' ';
                        if (order !=null) {
                            strQuery = strQuery +' '+ order;
                        }
                    }

                    strQuery = strQuery + ' LIMIT 1000';
                    childObject = Database.query(strQuery);

                    if (childObject != null && !childObject.isEmpty()) {
                        return childObject;
                    }
                }
            }
        } catch (Exception ex) {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, ' ' + ex.getMessage() + setFields));
        }

        return null;
    }

    /**
     * @description This is a method to create new Related list record based on
     * the questions for RLC.
     */
    public void getNewRelatedListRecord() {
        String strRecordTypeId = null;
        String strRecordTypeName =  null;
        String strQuery ;
        List<User> lstCurrentUser ;
        List<Contact> lstContacts;
        List<User> lstUsers;

        try {
            IsViewRecordLink = false;
            isOpenThroughLink = false;
            relatedListRecordObject = null;
            lstUsersPicklistValues = new List<SelectOption>();

            if (relatedListConfiguration != null && String.isNotBlank(relatedListConfiguration.strRelatedListObject)) {
                Object newRelatedListRecord = FCGlobal.getNewSobject(relatedListConfiguration.strRelatedListObject);

                if (newRelatedListRecord != null) {
                    isRelatedListView = false;
                    tabRecordId = '';
                    tabObject = (sObject) newRelatedListRecord;

                    //FCPROD-317 Related list with tab fields doesn't displays the default value.
                    Schema.SObjectType sObjectType = tabObject.getSObjectType();

                    if (relatedListConfiguration.strRelatedListObject.equalsIgnoreCase('OpportunityTeamMember')) {
                        //To initialize Quiz Question List again after removing TeamRole and OpportunityAccessLevel for only OCR records
                        quizQuestionList = quizQuestionListForOTM;

                        Id userId = UserInfo.getUserId();
                        strQuery = 'SELECT ContactId, Contact.AccountId FROM User WHERE Id = :userId WITH SECURITY_ENFORCED';
                        lstCurrentUser = (List<User>) Database.query(strQuery);
                        String strAccountId = (String) lstCurrentUser[0].Contact.AccountId;
                        strQuery = 'SELECT Id, Name FROM Contact WHERE AccountId = :strAccountId WITH SECURITY_ENFORCED';
                        lstContacts = (List<Contact>) Database.query(strQuery);
                        strQuery = 'SELECT Id, Name FROM User WHERE Contact.AccountId = :strAccountId AND IsActive = TRUE WITH SECURITY_ENFORCED';
                        lstUsers = (List<User>) Database.query(strQuery);

                        if (lstUsers != null && !lstUsers.isEmpty()) {
                            lstUsersPicklistValues.add(new SelectOption('', '--None--'));
                            for (User user : lstUsers) {
                                lstUsersPicklistValues.add(new SelectOption(user.Id, user.Name));
                            }
                        }

                        otmWrapperGlbl = null;
                        tabObject = (sObject) FCGlobal.getNewSobject(relatedListConfiguration.strRelatedListObject);

                        if (lstSelectedContactRoles != null) {
                            lstSelectedContactRoles.clear();
                        } else {
                            lstSelectedContactRoles = new List<SelectOption>();
                        }

                        if (lstAvailableContactRoles != null) {
                            lstAvailableContactRoles.clear();
                        } else {
                            lstAvailableContactRoles = new List<SelectOption>();
                        }

                        lstOpportunityAccessLevels = getOpportunityAccessLevelConfig();
                        strOtmAccessLevel = null;
                    }

                    List<Schema.RecordTypeInfo> infos = sObjectType.getDescribe().getRecordTypeInfos();

                    for (Schema.RecordTypeInfo info : infos) {
                        if (info.isDefaultRecordTypeMapping() && info.isAvailable()) {
                            strRecordTypeId = info.RecordTypeId;
                            strRecordTypeName = info.getName();
                            break;
                        }
                    }

                    sObject objSObject;

                    if (String.isNotBlank(strRecordTypeId) && String.isNotBlank(strRecordTypeName) && strRecordTypeName.toLowerCase() != 'master') {
                        objSObject = sObjectType.newSObject(strRecordTypeId, true);
                    } else {
                        objSObject = sObjectType.newSObject(null, true);
                    }

                    Schema.DescribeSObjectResult resSchema = sObjectType.getDescribe();

                    Map<String, Schema.SObjectField> sObjectFields = resSchema.fields.getMap();

                    if (sObjectFields != null && !sObjectFields.isEmpty()) {
                        for (Schema.SObjectField sfield : sObjectFields.values()) {
                            Schema.DescribeFieldResult dfield = sfield.getDescribe();
                            if (dfield.isUpdateable()) {
                                if (objSObject.get(dfield.getName()) != null) {
                                    tabObject.put(dfield.getName(), objSObject.get(dfield.getName()));
                                }
                            }
                        }
                    }
                }
            }
        } catch(Exception ex) {
            system.debug('Exception caught while saving records  ::  '+ ex +'at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,' ' + ex));
        }
    }

    /**
     * @description This is a method to go back to table view from question
     * view after edit/view/New.
     */
    public void backTOrelatedlistView() {
        relatedListRecordObject = null;
        isRelatedListView = true;
    }

    /**
     * @description This is a method to delete Related list record based on
     * record Index.
     */
    public void deleteRelatedListRecord() {
        try{
            String strRecordIndex = getParam('recordIndex');
            List<OpportunityTeamMember> lstTeamMemberToDelete;
            List<OpportunityContactRole> lstContactRolesToDelete;
            if(relatedListConfiguration != null && String.isNotBlank(relatedListConfiguration.strRelatedListObject) && String.isNotBlank(strRecordIndex))
            {
                integer recordIndex = integer.valueOf(strRecordIndex);
                if(recordIndex != null && string.isNotBlank(relatedListConfiguration.strRelatedListObject) && recordIndex < relatedListConfiguration.lstRelatedListRecord.size())
                {
                    if('OpportunityTeamMember'.equalsIgnoreCase(relatedListConfiguration.strRelatedListObject))
                    {
                        OTMOCRWrapper otmOcrWrapper = (OTMOCRWrapper)relatedListConfiguration.lstRelatedListRecord[recordIndex];
                        string strUserId = otmOcrWrapper.UserId;
                        string strContactId = otmOcrWrapper.ContactId;
                        if( strUserId != null )
                        {
                            lstTeamMemberToDelete = [
                                SELECT
                                    OpportunityId,
                                    User.ContactId,
                                    UserId
                                FROM OpportunityTeamMember
                                WHERE UserId = :strUserId
                                AND OpportunityId = :application.Id
                                WITH SECURITY_ENFORCED
                                LIMIT 1
                            ];

                            Engine.deleteListSObjects( lstTeamMemberToDelete );
                        }
                        if( strContactId != null )
                        {
                            lstContactRolesToDelete = [
                                SELECT
                                    ContactId,
                                    OpportunityId
                                FROM OpportunityContactRole
                                WHERE OpportunityId = :application.Id
                                AND ContactId = :strContactId
                                WITH SECURITY_ENFORCED
                            ];

                            Engine.deleteListSObjects( lstContactRolesToDelete );
                        }
                    }
                    else
                    {
                        object oldrelatedlistRecord = relatedListConfiguration.lstRelatedListRecord[recordIndex];
                        if(oldrelatedlistRecord != null)
                        {
                            sobject record = (sobject)oldrelatedlistRecord;
                            if(record != null)
                            {
                                CrudFlsService.getInstance().assertDeletable(record);
                                delete record;
                            }
                        }
                    }
                    relatedListConfiguration.lstRelatedListRecord.remove(recordIndex);
                }
            }
        }
        catch(Exception ex)
        {
            system.debug( 'Exception: ' + ex +'at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,' ' + ex.getMessage()));
        }
    }

    /**
     * @description This is a method to edit Related list record based on
     * record Index.
     */
    public void editRelatedListRecord() {
        isViewRecordLink = false;
        isOpenThroughLink=true;
        List<Contact> lstContact =new List<Contact>();
        String strRecordIndex = getParam('recordIndex');
        lstSelectedContactRoles = new List<SelectOption>();
        lstAvailableContactRoles = new List<SelectOption>();
        Set<String> setSelectedRoles;
        if( relatedListConfiguration != null && String.isNotBlank( relatedListConfiguration.strRelatedListObject ) && String.isNotBlank( strRecordIndex ) )
        {
            integer recordIndex = integer.valueOf(strRecordIndex);
            if( recordIndex != null && string.isNotBlank( relatedListConfiguration.strRelatedListObject ) && recordIndex < relatedListConfiguration.lstRelatedListRecord.size() )
            {
                object oldrelatedlistRecord;
                List<String> lstRoles = new List<String>();
                sobject record;
                if( relatedListConfiguration.strRelatedListObject.equalsIgnoreCase( 'OpportunityTeamMember' ) )
                {
                    string oldTeamMemberRole ;
                    OTMOCRWrapper otmOcrWrapper = (OTMOCRWrapper)relatedListConfiguration.lstRelatedListRecord[ recordIndex ];
                    otmWrapperGlbl = otmOcrWrapper;
                    if( otmOcrWrapper.OTM != null )
                    {
                        oldrelatedlistRecord = ( OpportunityTeamMember )otmOcrWrapper.OTM;
                        strRLCObjectName = 'OpportunityTeamMember';
                        lstOpportunityAccessLevels = getOpportunityAccessLevelConfig();
                        strOtmAccessLevel = otmOcrWrapper.OTM.OpportunityAccessLevel;
                        if(((OpportunityTeamMember )otmOcrWrapper.OTM).TeamMemberRole != null)
                            oldTeamMemberRole = ((OpportunityTeamMember )otmOcrWrapper.OTM).TeamMemberRole;
                    }
                    else if( otmOcrWrapper.OCR != null )
                    {
                        oldrelatedlistRecord = ( OpportunityContactRole )otmOcrWrapper.OCR;
                        strRLCObjectName = 'OpportunityContactRole';
                        if( lstOpportunityAccessLevels != null )
                            lstOpportunityAccessLevels.clear();
                        strOtmAccessLevel = null;
                    }

                    if( otmOcrWrapper.additionalRolesRW != null )
                        lstRoles = otmOcrWrapper.additionalRolesRW.split('; ', 0);
                    setSelectedRoles = new Set<String>();

                    for( String teamMemberRole : lstRoles )
                    {
                        if(oldTeamMemberRole!= null && teamMemberRole != null && !oldTeamMemberRole.equalsIgnoreCase(teamMemberRole))
                        {
                            lstSelectedContactRoles.add( new SelectOption( teamMemberRole, teamMemberRole) );
                            setSelectedRoles.add( teamMemberRole);
                        }
                    }
                    lstAvailableContactRoles = getContactRolesConfig( setSelectedRoles );
                }
                else
                    oldrelatedlistRecord = relatedListConfiguration.lstRelatedListRecord[ recordIndex ];
                if( oldrelatedlistRecord != null )
                {
                    record = ( sobject )oldrelatedlistRecord;
                    if( record == null )
                        return;

                    if(relatedListConfiguration.strRelatedListObject.equalsIgnoreCase( 'OpportunityTeamMember' ) && record != null )
                    {
                        OpportunityTeamMember otmRecord;
                        OpportunityContactRole ocrRecord;
                        Id sObjName = String.ValueOf(record.get('Id'));
                        List<Quiz_Questions__c> quizQuest = new  List<Quiz_Questions__c>();

                        if(sObjName.getSObjectType().getDescribe().getName()=='OpportunityContactRole')
                        {
                            ocrRecord = new OpportunityContactRole();
                            ocrRecord = (OpportunityContactRole) record ;
                            for(Quiz_Questions__c quizQuestion : quizQuestionList)
                            {
                                if(quizQuestion.FGM_Portal__Question__r.Type__c == 'Salesforce Data Type')
                                {
                                    if(quizQuestion.Field__c == 'UserId' || quizQuestion.Field__c == 'Additional_Roles__c')
                                    {
                                        quizQuest.add(quizQuestion);
                                    }
                                }
                                else
                                {
                                    quizQuest.add(quizQuestion);
                                }
                            }
                            quizQuestionList = quizQuest;

                            setSelectedRoles = new Set<String>();
                            for( String contactRole : lstRoles )
                            {
                                lstSelectedContactRoles.add( new SelectOption( contactRole, contactRole) );
                                setSelectedRoles.add( contactRole);
                            }
                            lstAvailableContactRoles = getContactRolesConfig( setSelectedRoles);
                        }
                        else
                        {
                            otmRecord = new OpportunityTeamMember();
                            otmRecord = (OpportunityTeamMember) record ;
                            quizQuestionList = quizQuestionListForOTM;
                        }
                        if(ocrRecord!=null)
                        {
                            if(ocrRecord.role == null)
                                ocrRecord.role = Schema.sObjectType.OpportunityContactRole.getSObjectType().getDescribe().fields.getMap().get('role').getDescribe().getPickListValues()[0].getValue();
                            tabObject = ocrRecord;
                        }
                        if(otmRecord!=null)
                        {
                            if(otmRecord.teammemberrole == null)
                                otmRecord.teammemberrole = Schema.sObjectType.OpportunityTeamMember.getSObjectType().getDescribe().fields.getMap().get('teammemberrole').getDescribe().getPickListValues()[0].getValue();
                            tabObject = otmRecord;
                        }
                    }
                    else
                        tabObject = record;
                    isRelatedListView = false;
                }
            }
        }
    }

    /**
     * @description This is a method to view Related list record based on
     * record Index.
     */
    public void viewRelatedListRecord() {
        try
        {
            isViewRecordLink = true;
            isOpenThroughLink=true;
            String strRecordIndex = getParam('recordIndex');
            if(relatedListConfiguration != null && String.isNotBlank(relatedListConfiguration.strRelatedListObject) && String.isNotBlank(strRecordIndex))
            {
                integer recordIndex = integer.valueOf(strRecordIndex);
                if( recordIndex != null && string.isNotBlank( relatedListConfiguration.strRelatedListObject ) && recordIndex < relatedListConfiguration.lstRelatedListRecord.size())
                {
                    object oldrelatedlistRecord;
                    if( relatedListConfiguration.strRelatedListObject.equalsIgnoreCase( 'OpportunityTeamMember' ) )
                    {
                        List<Quiz_Questions__c> quizQuest = new  List<Quiz_Questions__c>();
                        OTMOCRWrapper otmOcrWrapper = ( OTMOCRWrapper )relatedListConfiguration.lstRelatedListRecord[ recordIndex ];
                        otmWrapperGlbl = otmOcrWrapper;
                        if( otmOcrWrapper.OTM != null )
                        {
                            oldrelatedlistRecord = ( OpportunityTeamMember )otmOcrWrapper.OTM;
                            strRLCObjectName = 'OpportunityTeamMember';
                            quizQuestionList = quizQuestionListForOTM;
                        }
                        else if( otmOcrWrapper.OCR != null )
                        {
                            oldrelatedlistRecord = ( OpportunityContactRole )otmOcrWrapper.OCR;
                            strRLCObjectName = 'OpportunityContactRole';
                            for(Quiz_Questions__c quizQuestion : quizQuestionList)
                            {
                                if(quizQuestion.FGM_Portal__Question__r.Type__c == 'Salesforce Data Type')
                                {
                                    if(quizQuestion.Field__c == 'UserId' || quizQuestion.Field__c == 'Additional_Roles__c')
                                    {
                                        quizQuest.add(quizQuestion);
                                    }
                                }
                                else
                                {
                                    quizQuest.add(quizQuestion);
                                }
                            }
                            quizQuestionList = quizQuest;
                        }
                    }
                    else
                        oldrelatedlistRecord = relatedListConfiguration.lstRelatedListRecord[ recordIndex ];
                    if( oldrelatedlistRecord != null )
                    {
                        sobject record = ( sobject )oldrelatedlistRecord;
                        if( record == null )
                            return;
                        tabObject = record;
                        isRelatedListView = false;
                    }
                }
            }
        }
        catch( Exception ex )
        {
            system.debug( 'Exception: ' + ex.getMessage() + '; Line number: ' + ex.getLineNumber() + '; Stacktrace: ' + ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ' ' + ex.getMessage()  ) );
        }
    }

    /**
     * @description This is a method to get the existing application or create
     * the new one.
     */
    public void initializeApplication() {
        try
        {
            displayPopup = false;
            List<OpportunityShare> lstOpportunityShare;
            String applicationId = getParam('appId');
            if( application == null )
                application = FCGlobal.getNewSobject(currentParentObject);
            if( applicationId != null )
                fetchApplication( applicationId );
            else if( application.Id != null  )
                fetchApplication( application.Id );
            else
                createApplication();
            if(application != null)
                ApplicationId = application.Id;

            if(application != null) {
                lstOpportunityShare  = [
                    SELECT
                        OpportunityAccessLevel,
                        RowCause,
                        UserOrGroupId
                    FROM OpportunityShare
                    WHERE OpportunityId = :application.Id
                    AND RowCause = 'Team'
                    AND UserOrGroupId = :UserInfo.getUserId()
                    WITH SECURITY_ENFORCED
                ];
            }

            if(lstOpportunityShare !=null && !lstOpportunityShare.isEmpty())
            {
                if(lstOpportunityShare[0].OpportunityAccessLevel == 'Read' )
                {
                    strApplicationMode = 'view';
                    isApplicationSubmitted = true;
                }
            }
        }
        catch( Exception ex )
        {
            system.debug( 'Exception: ' + ex.getMessage() + '; Line number: ' + ex.getLineNumber() + '; Stacktrace: ' + ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ' ' + ex  ) );
        }
    }

    /**
     * @description This is a method to get the current application based on
     * appId and Quiz value on application.
     */
    public void fetchApplication(String applicationId) {
        try
        {
            String strQueryForLOIs;
            List<Lead> lstLeads;
            List<User> lstUsers;
            // check whether Campaign is still alive or expired
            isCampaignExpired = false;
            List<Campaign> lstCampaigns;
            String strQuery;
            List<Related_List_Controller__c> lstRLCs;
            List<Quiz_Questions__c> lstQuizQuestions;
            List<OpportunityTeamMember> lstApplicationMemeber;
            sObject fetchedApplication;
            string sobjectType;
            // below code is for lead conversion logic. The created by field changes for opportunity. This condition is now taken care by using submitted by field in converted LOI

            strQueryForLOIs = 'SELECT FGM_Base__Submitted_By__c FROM Lead WHERE ConvertedOpportunityId = :applicationId AND FGM_Base__Submitted_By__c != null WITH SECURITY_ENFORCED';
            lstLeads = (List<Lead>)Database.query( strQueryForLOIs );

            if( lstLeads != null && !lstLeads.isEmpty() )
            {
                lstUsers = [
                    SELECT ContactId
                    FROM User
                    WHERE ContactId = :lstLeads[0].FGM_Base__Submitted_By__c
                    AND IsActive = TRUE
                    WITH SECURITY_ENFORCED
                ];

                if( !lstUsers.isEmpty() )
                    objLOISubmittedBy = lstUsers[0]; //003A000001r8Zr1IAE
            }

            lstCampaigns = [
                SELECT
                    EndDate,
                    Application_Quiz__c,
                    LOI_Quiz__c
                FROM Campaign
                WHERE Id = :controller.getId()
                WITH SECURITY_ENFORCED
            ];

            if( !lstCampaigns.isEmpty() )
            {
                if( isCampaignExpired(lstCampaigns[0].EndDate) ){
                    isCampaignExpired = true;
                    isApplicationSubmitted = true;
                }
                //check validity of applicationId
                isOpportunity = false;
                if( ((Id)applicationId).getSObjectType().getDescribe().getName().equalsIgnoreCase('Opportunity') )
                    isOpportunity = true;
                String quizId;

                strQuery = 'SELECT Id, Quiz__c FROM ' + ( ( isOpportunity ) ? 'Opportunity' : 'Lead' ) + ' WHERE Id = :applicationId WITH SECURITY_ENFORCED';
                fetchedApplication = Database.query( strQuery )[0];

                if( fetchedApplication != null && (String)fetchedApplication.get('Quiz__c') != null )
                    quizId = (String)fetchedApplication.get('Quiz__c');
                if( quizId == null )
                {
                    if( isOpportunity )
                        quizId = lstCampaigns[0].Application_Quiz__c;
                    else
                        quizId = lstCampaigns[0].LOI_Quiz__c;
                }
                if( quizId != null )
                {
                    lstRLCs = [
                        SELECT ObjectName__c
                        FROM Related_List_Controller__c
                        WHERE Quiz__c = :quizId
                        AND RecordType.Name = 'Portal Tab'
                        AND ObjectName__c != null
                        AND Language__c = :portalLanguage
                        WITH SECURITY_ENFORCED
                    ];

                    Set<Id> setRLCIds = new Set<Id>();
                    for( Related_List_Controller__c rlcRecord : lstRLCs )
                        setRLCIds.add( rlcRecord.Id );

                    lstQuizQuestions = [
                        SELECT Field__c
                        FROM Quiz_Questions__c
                        WHERE Question__r.Type__c = 'Salesforce Data Type'
                        AND Tab__c IN :setRLCIds
                        WITH SECURITY_ENFORCED
                    ];

                    if( !lstQuizQuestions.isEmpty() )
                    {
                        getDefaultApplicationFields(isOpportunity);
                        for( Quiz_Questions__c question : lstQuizQuestions )
                        {

                            if( question.Field__c != null )
                            {
                                for( Schema.SObjectField sObjField : objectTypeMap.get( ( isOpportunity ) ? 'Opportunity' : 'Lead' ).getDescribe().fields.getMap().values() )
                                {
                                    Schema.DescribeFieldResult fieldResult = sObjField.getDescribe();
                                    String apiName = fieldResult.getName().toLowerCase();
                                    String apiLocalName = fieldResult.getLocalName().toLowerCase();

                                    if( question.Field__c.equalsIgnoreCase( apiName ) || question.Field__c.equalsIgnoreCase( apiLocalName ) )
                                    {
                                        if(!setApplicationFields.contains(apiName) && !setApplicationFields.contains(apiLocalName))
                                            setApplicationFields.add( apiName );
                                        break;
                                    }
                                }
                            }
                        }
                        sobjectType = ( isOpportunity ) ? 'Opportunity' : 'Lead';

                        strQuery = 'SELECT ' + String.join(new List<String>(setApplicationFields), ',');
                        strQuery += ' FROM ' + (( isOpportunity ) ? 'Opportunity' : 'Lead' ) + ' WHERE Id = :applicationId WITH SECURITY_ENFORCED';
                        application = Database.query( strQuery )[0];

                        PortalConfiguration__c portalConfig = new PortalConfiguration__c();
                        for( PortalConfiguration__c config : PortalConfiguration__c.getAll().values() )
                        {
                            if( config.LanguageSelection__c == portalLanguage )
                            {
                                portalConfig = config;
                                break;
                            }
                        }
                        mode = ( getParam('mode') == null ) ? 'edit' : getParam('mode');
                        if( portalConfig != null )
                        {
                            if( isOpportunity )
                            {
                                appStage = (string)application.get('stagename'); // part of legacy code
                                if( portalConfig.RequestEditableStatus__c != null && CollectionUtilities.getContainsIgnoreCase( portalConfig.RequestEditableStatus__c, (string)application.get('stagename') ) && mode.equalsIgnoreCase('edit') && !appStage.equalsIgnoreCase(SUBMITTED_STATUS_VALUE) && ((!isCampaignExpired && application.get('FGM_Base__Submitted_By__c') == null) || (isCampaignExpired && application.get('FGM_Base__Submitted_By__c') != null)) )
                                    mode = 'edit';
                                else
                                    mode = 'view';
                            }
                            else
                            {
                                appStage = (string)application.get('status'); // part of legacy code
                                if( portalConfig.InquiryEditableStatus__c != null && CollectionUtilities.getContainsIgnoreCase( portalConfig.InquiryEditableStatus__c, (string)application.get('status') ) && mode.equalsIgnoreCase('edit') && !appStage.equalsIgnoreCase(SUBMITTED_STATUS_VALUE) && !isCampaignExpired )
                                    mode = 'edit';
                                else
                                    mode = 'view';
                            }
                        }
                        strApplicationMode = mode; // part of legacy code
                        if(appStage!=null && appStage.equalsIgnoreCase(SUBMITTED_STATUS_VALUE) && mode.equalsIgnoreCase( 'view' ))
                        {
                            isApplicationSubmitted = true;
                            isAppOrLeadUnsubmitted = true;
                        }
                        else if(appStage!=null && !appStage.equalsIgnoreCase(SUBMITTED_STATUS_VALUE) && mode.equalsIgnoreCase( 'edit' ) )
                        {
                            isApplicationSubmitted = false;
                            isAppOrLeadUnsubmitted = false;
                        }
                        if(appStage!=null && appStage.equalsIgnoreCase(SUBMITTED_STATUS_VALUE))
                            isShowHidePrePostText = true;
                        else if(appStage!=null && !appStage.equalsIgnoreCase(SUBMITTED_STATUS_VALUE))
                            isShowHidePrePostText = false;
                        // part of legacy code
                        if( mode == 'view' ) // part of legacy code
                        {
                            isViewRecordLink = true;
                            isRelatedListView = true;
                        }
                        else
                        {
                            isViewRecordLink = false;
                            isRelatedListView = false;
                        }
                        if( isOpportunity )
                        {
                            if( application.get('ConsultantUser__c') != null )
                                applicationConsultant = Id.valueOf(String.valueOf(application.get('ConsultantUser__c')));
                            else if ( application.get('ConsultantUser__c') != null )
                                applicationConsultant = Id.valueOf(String.valueOf(application.get('ConsultantUser__c')));

                            lstApplicationMemeber = [
                                SELECT Id
                                FROM OpportunityTeamMember
                                WHERE OpportunityId = :application.Id
                                AND UserId = :applicationConsultant
                                AND TeamMemberRole = 'Consultant'
                                WITH SECURITY_ENFORCED
                                LIMIT 1
                            ];

                            if( lstApplicationMemeber!=null && !lstApplicationMemeber.isEmpty() )
                                isAssignedTOConsultant = true;
                            else
                                isAssignedTOConsultant = false;
                        }
                        if( mapObjNameObjDetails == null )
                            mapObjNameObjDetails = new Map< String, sObject >();
                        if( 'lead'.equalsIgnoreCase(currentParentObject) )
                            mapObjNameObjDetails.put( 'lead', application );
                        else
                            mapObjNameObjDetails.put( 'opportunity', application );

                        if(IsCampaignExpired &&  appStage.equalsIgnoreCase(SUBMITTED_STATUS_VALUE) )
                        {
                            bIsSubmittedAndExpiredCampaign = true;
                        }
                    }
                }
            }

        }
        catch( Exception ex )
        {
            system.debug( 'Exception: ' + ex.getMessage() + '; Line number: ' + ex.getLineNumber() + '; Stacktrace: ' + ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ' '+ ex.getMessage() + ' ' + ex.getLineNumber() ) );
        }
    }

    public void getDefaultApplicationFields(Boolean isOpportunityRecord) {
        if(isOpportunityRecord)
        {
            setApplicationFields.add('stagename');
            setApplicationFields.add('name');
            setApplicationFields.add('ownerid');
            setApplicationFields.add('createdbyid');
            setApplicationFields.add('fgm_base__start_date__c');
            setApplicationFields.add('fgm_base__end_date__c');
            setApplicationFields.add('fgm_portal__quiz__c');
            setApplicationFields.add('createddate');
            setApplicationFields.add('fgm_portal__consultantuser__c');
            setApplicationFields.add('fgm_base__submitted_by__c');
        }
        else
        {
            setApplicationFields.add('name');
            setApplicationFields.add('status');
            setApplicationFields.add('createdbyid');
            setApplicationFields.add('createddate');
            setApplicationFields.add('ownerid');
            setApplicationFields.add('fgm_portal__quiz__c');
            if(bIsSCPLEnable)
            {
                setApplicationFields.add('countrycode');
                setApplicationFields.add('statecode');
            }

        }
    }

    /**
     * @description This is a method to initialize the application record based
     * on quiz value and the parameters in campaign or campaign Quiz.
     */
    public void createApplication() {
        try
        {
            List<Campaign> lstCampaigns;
            List<Related_List_Controller__c> lstRLCs;
            List<Campaign_Quiz__c> lstCampaignQuizzes;
            List<sObject> lstApplications;
            // check whether Campaign is still alive or expired

            lstCampaigns = [
                SELECT
                    EndDate,
                    LOI_Prameters__c,
                    Parameters__c
                FROM Campaign
                WHERE Id = :controller.getId()
                WITH SECURITY_ENFORCED
            ];

            if( !lstCampaigns.isEmpty() )
            {
                if( isCampaignExpired(lstCampaigns[0].EndDate) )
                    isCampaignExpired = true;
                else
                    isCampaignExpired = false;
            }
            if( !isCampaignExpired )
            {
                // display Pop-up for unsubmitted applications
                String quizId = getParam('quizid');
                if( quiz != null )
                {

                    lstRLCs = [
                        SELECT ObjectName__c
                        FROM Related_List_Controller__c
                        WHERE Quiz__c = :quiz.Id
                        AND RecordType.Name = 'Portal Tab'
                        AND ObjectName__c != null
                        AND Language__c = :portalLanguage
                        WITH SECURITY_ENFORCED
                        LIMIT 1
                    ];

                    String campaignFieldName = 'Campaign';
                    String stageFieldName;
                    if( lstRLCs[0].ObjectName__c.equalsIgnoreCase('Opportunity') )  // for legacy code
                    {
                        stageFieldName = 'StageName';
                        isOpportunity = true;
                    }
                    else if( lstRLCs[0].ObjectName__c.equalsIgnoreCase('Lead') )    // for legacy code
                    {
                        stageFieldName = 'Status';
                        isOpportunity = false;
                    }
                    getDefaultApplicationFields(isOpportunity);


                    if( !lstRLCs.isEmpty() )
                    {
                        if(SchemaEngine.getCampaignLookupField( lstRLCs[0].ObjectName__c ) != null )
                            campaignFieldName = SchemaEngine.getCampaignLookupField( lstRLCs[0].ObjectName__c );
                        String fieldAPIName = (CollectionUtilities.getContainsIgnoreCase( campaignFieldName, '__c' ) ) ? (campaignFieldName.replace( '__c', '__r') + '.Id' ) : (campaignFieldName + '.Id');
                        String strQuery;

                        String sanitizedObjectName = lstRLCs[0].ObjectName__c.replaceAll('[^0-9a-zA-Z_.]', '');
                        String sanitizedfieldApiName = fieldApiName.replaceAll('[^0-9a-zA-Z_.]', '');
                        Set<Id> setLeadIds = new Set<Id>();
                        Id controllerId = controller.getId();

                        if( lstRLCs[0].ObjectName__c.equalsIgnoreCase('Lead') && !CollectionUtilities.getContainsIgnoreCase( campaignFieldName, '__c' ) )
                        {

                            for (CampaignMember member : [
                                SELECT LeadId
                                FROM CampaignMember
                                WHERE CampaignId = :lstCampaigns[0].Id
                                WITH SECURITY_ENFORCED
                            ]) {
                                if (member.LeadId != null) {
                                    setLeadIds.add(member.LeadId);
                                }
                            }


                            if( !setLeadIds.isEmpty())
                            {
                                strQuery = 'SELECT Id FROM ' + sanitizedObjectName + ' WHERE Id IN :setLeadIds AND Status != :SUBMITTED_STATUS_VALUE WITH SECURITY_ENFORCED';
                            }

                        }
                        else
                            strQuery = 'SELECT Id FROM ' + sanitizedObjectName+ ' WHERE ' + sanitizedFieldApiName + ' = :controllerId AND ' + stageFieldName + ' != :SUBMITTED_STATUS_VALUE WITH SECURITY_ENFORCED';
                        if( strQuery != null )
                        {
                            List<String> lstFieldToCheck = new List<String>();
                            for(String field : stageFieldName.split(',')){
                                if(!field.contains('.'))
                                lstFieldToCheck.add(field);
                            }
                            for(String field : fieldAPIName.split(',')){
                                if(!field.contains('.'))
                                lstFieldToCheck.add(field);
                            }

                            lstApplications = Database.query( strQuery );

                            displayPopup = ( !lstApplications.isEmpty() ) ? true : false;
                            isAppOrLeadUnsubmitted = displayPopup; // part of legacy code
                        }

                        lstCampaignQuizzes = [
                            SELECT Parameters__c
                            FROM Campaign_Quiz__c
                            WHERE Campaign__c = :controller.getId()
                            AND Quiz__c = :quizId
                            WITH SECURITY_ENFORCED
                            LIMIT 1
                        ];

                        Map<String,String> mapParameters;

                        if( lstCampaigns!=null && !lstCampaigns.isEmpty() && lstRLCs[0].ObjectName__c.equalsIgnoreCase('Opportunity') && lstCampaigns[0].Parameters__c != null )
                            mapParameters = CollectionUtilities.getMapFromParameters( lstCampaigns[0].Parameters__c, ',', ':' );
                        else if(  lstCampaigns!=null && !lstCampaigns.isEmpty() &&  lstRLCs[0].ObjectName__c.equalsIgnoreCase('Lead') && lstCampaigns[0].LOI_Prameters__c != null )
                            mapParameters = CollectionUtilities.getMapFromParameters( lstCampaigns[0].LOI_Prameters__c, ',', ':' );
                        else if( !lstCampaignQuizzes.isEmpty() && lstCampaignQuizzes[0].Parameters__c != null )
                            mapParameters = CollectionUtilities.getMapFromParameters( lstCampaignQuizzes[0].Parameters__c, ',', ':' );

                        if( mapParameters != null )
                        {
                            Map<String,Schema.SObjectField> mapObjectFields = new Map<String,Schema.SObjectField>();
                            if( lstRLCs[0].ObjectName__c.equalsIgnoreCase('Opportunity') )
                                mapObjectFields = Schema.SObjectType.Opportunity.fields.getMap();
                            if( lstRLCs[0].ObjectName__c.equalsIgnoreCase('Lead') )
                                mapObjectFields = Schema.SObjectType.Lead.fields.getMap();

                            for( String fieldName : mapParameters.keySet() )
                            {
                                for( String fldRslt : objectTypeMap.get(lstRLCs[0].ObjectName__c).getDescribe().fields.getMap().keySet() )
                                {
                                    String strfieldAPIName = objectTypeMap.get(lstRLCs[0].ObjectName__c).getDescribe().fields.getMap().get(fldRslt).getDescribe().getName();
                                    if( fieldName.equalsIgnoreCase(strfieldAPIName) )
                                    {
                                        Schema.DescribeFieldResult fieldResult = objectTypeMap.get(lstRLCs[0].ObjectName__c).getDescribe().fields.getMap().get(fldRslt).getDescribe();
                                        if( fieldResult.getType() == Schema.DisplayType.Date)
                                            application.put( strfieldAPIName, Date.parse(mapParameters.get(fieldName)) );
                                        else if( fieldResult.getType() == Schema.DisplayType.DateTime)
                                            application.put( strfieldAPIName, DateTime.parse(mapParameters.get(fieldName)) );
                                        else if( fieldResult.getType() == Schema.DisplayType.Percent || fieldResult.getType() == Schema.DisplayType.Currency )
                                            application.put( strfieldAPIName, Decimal.valueOf(mapParameters.get(fieldName)) );
                                        else if( fieldResult.getType() == Schema.DisplayType.Double)
                                            application.put( strfieldAPIName, Double.valueOf(mapParameters.get(fieldName)) );
                                        else if( fieldResult.getType() == Schema.DisplayType.Integer)
                                            application.put( strfieldAPIName, Integer.valueOf(mapParameters.get(fieldName)) );
                                        else if( fieldResult.getType() == Schema.DisplayType.Boolean)
                                            application.put( strfieldAPIName, Boolean.valueOf(mapParameters.get(fieldName)) );
                                        else
                                            application.put( strfieldAPIName, mapParameters.get(fieldName));
                                        break;
                                    }
                                }
                            }
                        }
                        appStage = NOTSUBMITTED; // part of legacy code
                        isApplicationSubmitted = false; // part of legacy code
                        mode = 'edit'; // part of legacy code
                        isViewRecordLink = false; // part of legacy code
                        isRelatedListView = false;

                        if( mapObjNameObjDetails == null )
                            mapObjNameObjDetails = new Map<String, sObject>();
                        if( 'lead'.equalsIgnoreCase(currentParentObject) )
                            mapObjNameObjDetails.put( 'lead', application );
                        else
                            mapObjNameObjDetails.put( 'opportunity', application );
                    }
                }
            }
        }
        catch( Exception ex )
        {
            system.debug( 'Exception: ' + ex.getMessage() + '; Line number: ' + ex.getLineNumber() + '; Stacktrace: ' + ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ' ' + ex.getMessage() ) );
        }
    }

    /**
     * @description This is a method to rollback to the get the Question
     * attachment records for current language and insert Question attachment
     * records for attachment type questions to which QA record is not present.
     */
    public void initializeAttachment() {
        try
        {
            mapApplicationAttachments = new Map<String,ApplicationAttachments>();
            setAttachmentQuestionList = new Set<String>();
            List<FGM_Portal__Question_Attachment__c> lstQuestionAttachment ;
            String query ;
            if(quizQuestionList != null && quizQuestionList.size() > 0)
            {
                for(Quiz_Questions__c quizQuestion : quizQuestionList)
                {
                    if(String.isNotBlank(quizQuestion.FGM_Portal__Question__r.Type__c) && quizQuestion.FGM_Portal__Question__r.Type__c == 'Attachment' )
                    {
                        setAttachmentQuestionList.add(quizQuestion.Question__c);
                        ApplicationAttachments tempApplicationAttachments = new ApplicationAttachments();
                        mapApplicationAttachments.put(String.valueOf(quizQuestion.FGM_Portal__Question__r.Id),tempApplicationAttachments);
                    }
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
                String applicationId = application.Id;

                query = 'SELECT Id,(SELECT Name,Id,ContentType, BodyLength,CreatedDate,Description FROM Attachments), (Select Id, ParentId, Type, CreatedDate, LastModifiedDate, Body, RelatedRecordId From Feeds),Question__c, Description__c FROM FGM_Portal__Question_Attachment__c Where ' + questionAttachmentRelationField + ' = :applicationId WITH SECURITY_ENFORCED ORDER BY CreatedDate ASC LIMIT 10000' ;
                lstQuestionAttachment = (List<FGM_Portal__Question_Attachment__c>)  Database.Query(query);

                Set<String> setQuestionIds = new Set<String>();

                for (Questions__c question : [
                    SELECT Parent_QuestionID__c
                    FROM Questions__c
                    WHERE Id IN :setAttachmentQuestionList
                    WITH SECURITY_ENFORCED
                ]) {
                    if (question.FGM_Portal__Parent_QuestionID__c != null) {
                        setAttachmentQuestionList.add(question.FGM_Portal__Parent_QuestionID__c);
                    }
                }

                if(lstQuestionAttachment != null && !lstQuestionAttachment.isEmpty())
                {
                    for(FGM_Portal__Question_Attachment__c questionAttachment :lstQuestionAttachment)
                    {
                        setAttachmentQuestionList.remove(questionAttachment.Question__c);
                        applicationAttachment = new ApplicationAttachments();
                        applicationAttachment.strQuestionAttachmentId = questionAttachment.Id;
                        applicationAttachment.questionAttachment = questionAttachment ;

                        for(Attachment attachment : questionAttachment.Attachments)
                        {
                            applicationAttachment.mapOldAttachments.put(String.valueOf(attachment.Id),(SObject)attachment);
                            applicationAttachment.mapAttachType.put(String.valueOf(attachment.Id),'Attachment');
                        }
                        for(Question_Attachment__Feed feedAttachment: questionAttachment.Feeds)
                        {
                            applicationAttachment.mapOldAttachments.put(String.valueOf(feedAttachment.Id),(SObject)feedAttachment);
                            applicationAttachment.mapAttachType.put(String.valueOf(feedAttachment.Id),'File');
                        }
                        applicationAttachment.oldMapSize = applicationAttachment.mapOldAttachments.size();
                        mapApplicationAttachments.put(String.valueOf(questionAttachment.Question__c),applicationAttachment);
                    }
                }

                if(!setAttachmentQuestionList.isEmpty() && application != null && application.Id != null)
                {
                    List<FGM_Portal__Question_Attachment__c> lstUpsertQuestionAttachment = new List<FGM_Portal__Question_Attachment__c>();
                    for(String questionId : setAttachmentQuestionList)
                    {
                        FGM_Portal__Question_Attachment__c questionAttachment = new FGM_Portal__Question_Attachment__c();
                        questionAttachment.put('Question__c',questionId);
                        questionAttachment.put(questionAttachmentRelationField,application.Id);
                        if(currentTabType=='Portal Tab' || isReviewSubmitPage)
                            lstUpsertQuestionAttachment.add(questionAttachment);
                    }
                    // Upsert the attachment placeholders
                    if(lstUpsertQuestionAttachment!=null && !lstUpsertQuestionAttachment.isEmpty())
                    {
                        CrudFlsService.getInstance().assertUpdateable(lstUpsertQuestionAttachment);
                        upsert lstUpsertQuestionAttachment;

                        for(FGM_Portal__Question_Attachment__c questionAttachment : lstUpsertQuestionAttachment)
                        {
                            applicationAttachment = new ApplicationAttachments();
                            applicationAttachment.strQuestionAttachmentId = questionAttachment.Id;

                            for(Attachment attachment: questionAttachment.Attachments)
                            {
                                applicationAttachment.mapOldAttachments.put(String.valueOf(attachment.Id),(Sobject)attachment);
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
        catch(Exception ex)
        {
            system.debug( 'Exception: ' + ex + ' @Line :: ' + ex.getLineNumber() + ' Message ' + ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() ) );
        }
    }

    /**
     * @description This is a method to initialize tabs and tab data for review page.
     */
    public void initializeReviewPageList() {
        // Setup the review list
        try
        {
            //application=applicationOnReview;
            reviewPageList = new ReviewPage[] {};
                if (application.Id == null || tabsList == null || tabsList.isEmpty())
                return;
            String applicationId = application.Id;

            if(relatedListTabIds != null && portalTabIds != null && granteeBudgetTabIds !=null){
                ReviewPage reviewPage = null;
                for(Related_List_Controller__c tabRecord : tabsList){
                    reviewPage = null;
                    if(portalTabIds.contains(tabRecord.Id) && tabRecord.Name != strIquiryTabName){
                        reviewPage = new ReviewPage();
                        reviewPage.name = tabRecord.Name;
                        reviewPage.TabType = 'Portal Tab';
                        reviewPage.reviewQuestionList = new ReviewQuestion[] {};
                            if(tabRecord.Quiz_Questions__r == null)
                            continue;
                        for(Quiz_Questions__c quizQuestion : tabRecord.Quiz_Questions__r) {
                            // Missing field types can  be skipped
                            if (quizQuestion.FGM_Portal__Question__r.Type__c == null)
                                continue;
                            // Missing field types can  be skipped
                            if (quizQuestion.FGM_Portal__Question__r.Type__c == 'Instruction')
                                continue;
                            // Basic response

                            ReviewQuestion reviewQuestion = new ReviewQuestion();
                            reviewQuestion.question = quizQuestion.FGM_Portal__Question__r;
                            // For fields mapped directly to the application
                            if (quizQuestion.Field__c != null && application.get(quizQuestion.Field__c) != null) {
                                reviewQuestion.responseField = quizQuestion.Field__c;
                                reviewQuestion.response = ''+ application.get(quizQuestion.Field__c);
                            }
                            reviewQuestion.questionType = quizQuestion.FGM_Portal__Question__r.Type__c;
                            reviewQuestion.questionId  = quizQuestion.Question__c;
                            if(quizQuestion.FGM_Portal__Question__r.Type__c == 'Salesforce Data Type') {
                                Schema.DescribeFieldResult fieldInstance = objectTypeMap.get(String.valueOf(tabRecord.ObjectName__c).toLowerCase()).getDescribe().fields.getMap().get(String.valueOf(quizQuestion.Field__c).toLowerCase()).getDescribe();
                                reviewQuestion.strFieldType = String.valueOf(fieldInstance.getType());
                                reviewQuestion.isHTMLenabled = fieldInstance.isHtmlFormatted();
                            }
                            // Add to reviewPage list
                            reviewPage.reviewQuestionList.add(reviewQuestion);
                            // Add if it required and Empty
                            //if(quizQuestion.Required__c && String.isEmpty(reviewQuestion.response))
                            //    requiredQuestions.add(quizQuestion.FGM_Portal__Question__r.Question__c);
                        }
                        // Only add the reviewPage to the list if there are matched questions
                        if (reviewPage.reviewQuestionList.isEmpty() == false)
                            reviewPageList.add(reviewPage);
                    }
                    else if(tabRecord.Name == strIquiryTabName)
                    {
                        reviewPage = new ReviewPage();
                        reviewPage.name = tabRecord.Name;
                        reviewPage.TabType = 'Inquiry Attachments';
                        reviewPage.relatedListConfiguration = new relatedList();
                        reviewPage.relatedListConfiguration.record = tabRecord;
                        reviewPageList.add(reviewPage);
                    }
                    else if( 'Organization Tab'.equalsIgnoreCase(tabRecord.RecordType.Name) )
                    {
                        reviewPage = new ReviewPage();
                        reviewPage.name = tabRecord.Name;
                        reviewPage.TabType = 'Organization Tab';
                        reviewPage.relatedListConfiguration = new relatedList();
                        reviewPage.relatedListConfiguration.record = tabRecord;
                        getOrganizationRecord();
                        reviewPageList.add(reviewPage);
                    }
                    else if( 'Contact Tab'.equalsIgnoreCase(tabRecord.RecordType.Name) )
                    {
                        reviewPage = new ReviewPage();
                        reviewPage.name = tabRecord.Name;
                        reviewPage.TabType = 'Contact Tab';
                        reviewPage.relatedListConfiguration = new relatedList();
                        reviewPage.relatedListConfiguration.record = tabRecord;
                        getContactRecord();
                        reviewPageList.add(reviewPage);
                    }
                    else if( 'Custom Profile Tab'.equalsIgnoreCase(tabRecord.RecordType.Name) )
                    {
                        reviewPage = new ReviewPage();
                        reviewPage.name = tabRecord.Name;
                        reviewPage.Id = tabRecord.Id;
                        reviewPage.relatedListConfiguration = new relatedList();
                        reviewPage.relatedListConfiguration.record = tabRecord;
                        objCurrentCustomProfileTabParent = tabRecord;

                        if( objCurrentCustomProfileTabParent != null && objCurrentCustomProfileTabParent.Cloned_from__c != null )
                        {

                            objCurrentCustomProfileTab = [
                                SELECT
                                    FieldHeaders__c,
                                    FieldNames__c,
                                    Hide_Edit_Link__c,
                                    RichInstructionalText__c,
                                    LookupField__c,
                                    Name,
                                    ObjectName__c,
                                    ShowDeleteLink__c,
                                    ShowNewButton__c
                                FROM Related_List_Controller__c
                                WHERE Id = :objCurrentCustomProfileTabParent.Cloned_from__c
                                WITH SECURITY_ENFORCED
                                LIMIT 1
                            ];

                        }
                        else
                            objCurrentCustomProfileTab = new Related_List_Controller__c();

                        reviewPage.TabType = 'Custom Profile Tab';
                        if( tabRecord.ObjectName__c != null && tabrecord.Cloned_from__r.Name != null )
                        {
                            if( mapTbIdToMapClnIdnObjRcrds == null )
                                mapTbIdToMapClnIdnObjRcrds = new Map< String, List<sObject> >();
                            if( mapTabIdLstCstPrflFldLbls == null )
                                mapTabIdLstCstPrflFldLbls = new Map< String, List<String> >();
                            if( mapTabIdLstCstPrflFldLblsAndAPINames == null )
                                mapTabIdLstCstPrflFldLblsAndAPINames = new Map< String, Map< String, String > >();
                            Map< String, String > mapFieldLabelsAndNames = getrelatedListColumn(objCurrentCustomProfileTab);
                            if(tabRecord.Id!=null)
                                mapTabIdLstCstPrflFldLblsAndAPINames.put( tabRecord.Id, mapFieldLabelsAndNames );
                            List< String > lstFieldLabels = new List< String >();
                            for( String strFieldLabel : mapFieldLabelsAndNames.keySet() )
                                lstFieldLabels.add( strFieldLabel );
                            mapTabIdLstCstPrflFldLbls.put( tabRecord.Id, lstFieldLabels );
                            List< String > lstFldAPINames = new List< String >();
                            lstFldAPINames = mapFieldLabelsAndNames.values();
                            List<String> sanitizedFieldApiNames = new List<String>();
                            for (String f : lstFldAPINames) {
                                sanitizedFieldApiNames.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                            }
                            String sanitizedObjectName = objCurrentCustomProfileTabParent.ObjectName__c.replaceAll('[^0-9a-zA-Z_.]', '');
                            String sanitizedLookupField = objCurrentCustomProfileTabParent.LookupField__c.replaceAll('[^0-9a-zA-Z_.]', '');
                            Id userContactAccountId = user.Contact.AccountId;
                            String strQuery = 'SELECT ' + String.join(sanitizedFieldApiNames,',') + ' FROM ' + sanitizedObjectName+ ' WHERE ' + sanitizedLookupField + ' = :userContactAccountId WITH SECURITY_ENFORCED ';
                            if( objCurrentCustomProfileTabParent.of_records_to_display__c > -1 )
                                strQuery += 'LIMIT ' + objCurrentCustomProfileTabParent.of_records_to_display__c;
                            if( mapTabIdAndLstCstmPrflTbRcrds == null )
                                mapTabIdAndLstCstmPrflTbRcrds = new Map< String, List<sObject>>();
                            mapTabIdAndLstCstmPrflTbRcrds.put( objCurrentCustomProfileTabParent.Id, Database.query(strQuery) );
                            reviewPageList.add(reviewPage);
                        }

                    }
                    else if(relatedListTabIds.contains(tabRecord.Id) && String.isNotBlank(tabRecord.ObjectName__c) && String.isNotBlank(tabRecord.LookupField__c)){
                        reviewPage = new ReviewPage();
                        reviewPage.name = tabRecord.Name;
                        reviewPage.TabType = 'Related List With Tab';
                        reviewPage.relatedListConfiguration = new relatedList();
                        reviewPage.relatedListConfiguration.record = tabRecord;

                        for(Quiz_Questions__c quizQuestion : tabRecord.Quiz_Questions__r)
                        {
                            if(quizQuestion.Field__c != null && quizQuestion.FGM_Portal__Question__r.Type__c == 'Salesforce Data Type' )
                            {
                                if(quizQuestion.Field__c.equalsIgnoreCase('TeamMemberRole') )
                                    isTeamRoleInQuizQuestion = true;
                                if( quizQuestion.Field__c.equalsIgnoreCase('additional_roles__c') || quizQuestion.Field__c.equalsIgnoreCase('FGM_Portal__Additional_Roles__c') )
                                    isAdditionalRoleInQuizQuestion = true;
                            }
                        }

                        reviewPage.relatedListConfiguration.strRelatedListObject = tabRecord.ObjectName__c;
                        reviewPage.relatedListConfiguration.mapColumnFields =  getrelatedListColumn(tabRecord);
                        reviewPage.relatedListConfiguration.lstColumnFields = getrelatedListColumnList(tabRecord);
                        reviewPage.relatedListConfiguration.relatedListLookUp =  tabRecord.LookupField__c;
                        if(!reviewPage.relatedListConfiguration.mapColumnFields.isEmpty())
                            reviewPage.relatedListConfiguration.lstRelatedListRecord = getRelatedListRecords(tabRecord,new Set<String>(reviewPage.relatedListConfiguration.mapColumnFields.values()));
                        reviewPageList.add(reviewPage);
                    }
                    else if(granteeBudgetTabIds.contains(tabRecord.Id) && String.isNotBlank(tabRecord.ObjectName__c) && String.isNotBlank(tabRecord.LookupField__c)){
                        reviewPage = new ReviewPage();
                        reviewPage.name = tabRecord.Name;
                        reviewPage.TabType = 'Grantee Budget Tab';
                        reviewPage.relatedListConfiguration = new relatedList();
                        reviewPage.relatedListConfiguration.record = tabRecord;
                        reviewPageList.add(reviewPage);
                    }
                }
            }
        }
        catch( Exception ex )
        {
            system.debug( 'Exception: ' + ex + ' @Line :: ' + ex.getLineNumber() + ' Message ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, ' ' + ex.getMessage() ));
        }
    }

    /**
     * @description This is a method to save the related list tab's record.
     */
    public void saveRelatedListRecord() {
        Savepoint sp = Database.setSavepoint();
        try
        {
            if( relatedListConfiguration != null && relatedListConfiguration.strRelatedListObject != null && relatedListConfiguration.relatedListLookUp != null )
            {
                Related_List_Controller__c tabRecord = null;
                List<OpportunityTeamMember> lstOpportunityTeamMembers;
                List<OpportunityContactRole> lstOpportunityContactRoles;
                Integer ocrCount;
                if( tabObject != null )
                {
                    if( tabObject.get('Id') == null )
                        tabObject.put( relatedListConfiguration.relatedListLookUp, application.get('id') );
                    Set<String> setSelectedRoles = new Set<String>();
                    List<OpportunityContactRole> lstContactRolesToCreate = new List<OpportunityContactRole>();
                    Boolean isOpportunityAccessLevelQuestion = false;
                    if( relatedListConfiguration.strRelatedListObject.equalsIgnoreCase( 'OpportunityTeamMember' ) )
                    {
                        string defaultTeamRole = Schema.sObjectType.OpportunityTeamMember.getSObjectType().getDescribe().fields.getMap().get('teammemberrole').getDescribe().getPickListValues()[0].getValue();
                        OpportunityContactRole defaultocr;

                        for( Quiz_Questions__c quizQuestion : quizQuestionList )
                        {
                            if(quizQuestion.Field__c != null && quizQuestion.FGM_Portal__Question__r.Type__c == 'Salesforce Data Type' )
                            {
                                if(quizQuestion.Field__c.equalsIgnoreCase('TeamMemberRole') )
                                    isTeamRoleInQuizQuestion = true;
                                if( quizQuestion.Field__c.equalsIgnoreCase('additional_roles__c') || quizQuestion.Field__c.equalsIgnoreCase('FGM_Portal__Additional_Roles__c') )
                                    isAdditionalRoleInQuizQuestion = true;
                                if( quizQuestion.Field__c.equalsIgnoreCase('OpportunityAccessLevel') )
                                    isOpportunityAccessLevelQuestion = true;
                            }

                            if( quizQuestion.FGM_Portal__Question__r.Type__c.equalsIgnoreCase( 'Salesforce Data Type' ) && quizQuestion.Field__c != null && quizQuestion.Required__c && !(quizQuestion.Field__c.equalsIgnoreCase('Additional_Roles__c') || quizQuestion.Field__c.equalsIgnoreCase('OpportunityAccessLevel')) )
                            {
                                if( String.isBlank(String.valueOf(tabObject.get( quizQuestion.Field__c )))  )
                                {
                                    throw new RequiredFieldException(quizQuestion.Question__r);
                                }
                            }
                            if( quizQuestion.FGM_Portal__Question__r.Type__c.equalsIgnoreCase( 'Salesforce Data Type' ) && quizQuestion.Field__c != null && quizQuestion.Required__c && quizQuestion.Field__c.equalsIgnoreCase('Additional_Roles__c') && lstSelectedContactRoles.isEmpty()  )
                            {
                                throw new RequiredFieldException(quizQuestion.Question__r);
                            }
                        }
                        if(strRLCObjectName=='OpportunityTeamMember')
                        {
                            if( String.isBlank(String.valueOf(tabObject.get('teammemberrole'))))
                            {
                                tabObject.put('teammemberrole', defaultTeamRole) ;
                            }
                            else
                            {
                                map<string,string> mapOTMPicklistEntries= SchemaEngine.getOpportunityTeamMemberPicklistEntries();
                                for(string strTRole  : mapOTMPicklistEntries.keyset() )
                                    if( (mapOTMPicklistEntries.get(strTRole)).equalsIgnoreCase(String.valueOf(tabObject.get('teammemberrole'))))
                                    tabObject.put('teammemberrole', strTRole) ;
                            }

                            if( strOtmAccessLevel == null && !isOpportunityAccessLevelQuestion )
                                strOtmAccessLevel = 'Edit';

                            lstOpportunityTeamMembers = [
                                SELECT TeamMemberRole
                                FROM OpportunityTeamMember
                                WHERE UserId = :(String)tabObject.get('UserId')
                                AND OpportunityId = :application.Id
                                WITH SECURITY_ENFORCED
                            ];

                            if(tabObject.Id != null){
                                tabObject = this.getCrudFlsService().stripInaccessibleForUpdate(tabObject);
                            }
                            else{
                                tabObject = this.getCrudFlsService().stripInaccessibleForInsert(new List<Sobject>{tabObject})[0];
                            }
                            tabObject.put('OpportunityAccessLevel',strOtmAccessLevel);
                            Engine.upsertListSObjects( new List<sObject>{ tabObject }, 'OpportunityTeamMember' );

                            if( strOtmAccessLevel != null )
                            {
                                OpportunityShare oppShare = new OpportunityShare();
                                oppShare.OpportunityId = (String)application.get('id');
                                oppShare.UserOrGroupId = (String)tabObject.get('UserId');
                                oppShare.RowCause = 'Team';

                                oppShare.OpportunityAccessLevel = strOtmAccessLevel;
                                Engine.upsertListSObjects( new List<sObject>{ oppshare }, 'OpportunityShare' );
                            }
                        }
                        if( otmWrapperGlbl != null && ( otmWrapperGlbl.IsForPartnerUser == true || otmWrapperGlbl.OCR != null ) )
                        {

                            lstOpportunityContactRoles = [
                                SELECT Role
                                FROM OpportunityContactRole
                                WHERE ContactId = :otmWrapperGlbl.ContactId
                                AND OpportunityId = :application.Id
                                WITH SECURITY_ENFORCED
                            ];

                            OpportunityContactRole oldOCR = new OpportunityContactRole();
                            List<OpportunityContactRole> lstOpportunityContactRolesToDelete = new List<OpportunityContactRole>();

                            for( SelectOption option : lstSelectedContactRoles )
                                setSelectedRoles.add( option.getValue() );

                            map<string,string> mapOCRPicklistEntries= SchemaEngine.getOpportunityContactRolePicklistEntries();
                            for(OpportunityContactRole existingOCR : lstOpportunityContactRoles)
                            {
                                if(setSelectedRoles.contains(mapOCRPicklistEntries.get(existingOCR.role)))
                                {
                                    if(existingOCR.role == SchemaEngine.getDefaultOpportunityContactRole().getValue() && strRLCObjectName=='OpportunityTeamMember' && tabObject.get('FGM_Portal__ContactRoleID__c')==existingOCR.Id)
                                    {
                                        tabObject.put('FGM_Portal__ContactRoleID__c','') ;
                                    }

                                    setSelectedRoles.remove(mapOCRPicklistEntries.get(existingOCR.role));
                                }
                                else
                                {
                                    lstOpportunityContactRolesToDelete.add(existingOCR);
                                }
                            }
                            set<String> roles = new set<String>();
                            for(OpportunityContactRole ocr : lstOpportunityContactRolesToDelete)
                            {
                                roles.add(ocr.Role);
                            }
                            if( !lstOpportunityContactRolesToDelete.isEmpty()) {
                                CrudFlsService.getInstance().assertDeletable(lstOpportunityContactRolesToDelete);
                                delete lstOpportunityContactRolesToDelete;
                            }

                            ocrCount = [
                                SELECT COUNT()
                                FROM OpportunityContactRole
                                WHERE ContactId = :otmWrapperGlbl.ContactId
                                AND OpportunityId = :application.Id
                                WITH SECURITY_ENFORCED
                            ];

                            if(!setSelectedRoles.isEmpty())
                            {
                                for( String role : setSelectedRoles )
                                {
                                    OpportunityContactRole ocr = new OpportunityContactRole();
                                    ocr.ContactId = otmWrapperGlbl.ContactId;
                                    ocr.Role = role;
                                    ocr.OpportunityId = (String)application.get('id');
                                    lstContactRolesToCreate.add( ocr );
                                }
                            }
                            else
                            {
                                if(ocrCount== 0)
                                {
                                    defaultocr = new OpportunityContactRole();
                                    defaultocr.ContactId = otmWrapperGlbl.ContactId;
                                    defaultocr.Role = SchemaEngine.getDefaultOpportunityContactRole().getValue();
                                    defaultocr.OpportunityId = (String)application.get('id');
                                    lstContactRolesToCreate.add( defaultocr );

                                }
                            }
                            if( !lstContactRolesToCreate.isEmpty() && lstContactRolesToCreate.size()>0)
                            {
                                AdminContextExecutionManager.executeUpsert(lstContactRolesToCreate);
                            }
                            if(strRLCObjectName == 'OpportunityTeamMember')
                            {
                                if(defaultocr!=null)
                                {
                                    if(lstOpportunityContactRoles.size()==0)
                                    {
                                        if(!SchemaEngine.getDefaultOpportunityContactRole().IsDefaultValue())
                                            tabObject.put('FGM_Portal__ContactRoleID__c',defaultocr.Id) ;
                                        else
                                            tabObject.put('FGM_Portal__ContactRoleID__c','') ;
                                    }
                                    else
                                    {
                                        tabObject.put('FGM_Portal__ContactRoleID__c',defaultocr.Id) ;
                                    }
                                }
                                else
                                {
                                    tabObject.put('FGM_Portal__ContactRoleId__c',' ') ;
                                }
                                if(tabObject.get('Id') == null){
                                    this.getAdminContextExecutionManager().stripInaccessibleAndInsert( new list<SObject> {tabObject} );
                                }
                                else{
                                    this.getAdminContextExecutionManager().stripInaccessibleAndUpdate( new list<SObject> {tabObject} );
                                }
                            }
                            if( lstSelectedContactRoles != null && !lstSelectedContactRoles.isEmpty() )
                            {
                                lstSelectedContactRoles.clear();
                            }
                        }
                    } else{                        
                        for( Quiz_Questions__c quizQuestion : quizQuestionList )
                        {
                            if( quizQuestion.FGM_Portal__Question__r.Type__c.equalsIgnoreCase( 'Salesforce Data Type' ) && quizQuestion.Field__c != null && quizQuestion.Required__c )
                            {
                                if( String.isBlank(String.valueOf(tabObject.get( quizQuestion.Field__c ))))
                                {
                                    throw new RequiredFieldException(quizQuestion.Question__r);
                                }
                            }
                            if(relatedListConfiguration.strRelatedListObject.equalsIgnoreCase( 'OpportunityContactRole' ) &&  quizQuestion.FGM_Portal__Question__r.Type__c.equalsIgnoreCase( 'Salesforce Data Type' ) && quizQuestion.Field__c != null && quizQuestion.Required__c && quizQuestion.Field__c.equalsIgnoreCase('Additional_Roles__c'))
                            {
                                tabObject.put( quizQuestion.Field__c,strOtmAccessLevel  );
                                if( String.isBlank(String.valueOf(tabObject.get( quizQuestion.Field__c ))))
                                {
                                    throw new RequiredFieldException(quizQuestion.Question__r);
                                }
                            }
                        }
                        
                            this.getAdminContextExecutionManager().stripInaccessibleAndUpsert(new List<SObject>{
                                this.tabObject
                            }); 
                    }
                    if(quizQuestionListForOTM!=null)
                    {
                        for( Quiz_Questions__c quizQuestion : quizQuestionListForOTM )
                        {
                            if(quizQuestion.Field__c != null && quizQuestion.FGM_Portal__Question__r.Type__c == 'Salesforce Data Type' )
                            {
                                if(quizQuestion.Field__c.equalsIgnoreCase('TeamMemberRole') )
                                    isTeamRoleInQuizQuestion = true;
                                if( quizQuestion.Field__c.equalsIgnoreCase('additional_roles__c') || quizQuestion.Field__c.equalsIgnoreCase('FGM_Portal__Additional_Roles__c') )
                                    isAdditionalRoleInQuizQuestion = true;
                            }
                        }
                    }
                }
                if( tabsList != null && String.isNotBlank(selectedTab) )
                {
                    for( Related_List_Controller__c tab : tabsList )
                    {
                        if( selectedTab == String.valueOf(tab.Id) )
                        {
                            tabRecord = tab;
                            break;
                        }
                    }
                }
                if( tabRecord != null )
                    relatedListConfiguration.lstRelatedListRecord = getRelatedListRecords(tabRecord,new Set<String>(relatedListConfiguration.mapColumnFields.values()));
                backTOrelatedlistView();
            }
        }
        catch (RequiredFieldException ex) {
            requiredQuestionErrors = new List<Questions__c>{ex.getQuestion()};
        }
        catch( DmlException dmlEx )
        {
            Database.rollback(sp);
            system.debug( 'Exception: ' + dmlEx + ' @Line :: ' + dmlEx.getLineNumber() + ' Message ' + dmlEx.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, dmlEx.getDMLMessage(0)));
        }
        catch( Exception ex )
        {
            system.debug( 'Exception: ' + ex + ' @Line :: ' + ex.getLineNumber() + ' Message ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ' ' + ex.getMessage() ));
        }
    }

    /**
     * @description This is a method to get the next tab Id based on the index
     * of current tab.
     */
    private String getNextTab() {
        isLastTab = false;
        String strnextTabID = '';
        if(String.isNotBlank(selectedTab) && tabsList != null){
            for(integer index = 0; index < tabsList.size(); index++){
                if(selectedTab.equalsIgnoreCase(String.valueOf(tabsList[index].Id))){
                    if(index + 1 < tabsList.size()){
                        strnextTabID = String.valueOf(tabsList[index + 1].Id);
                        break;
                    }
                    else
                        isLastTab = true;
                }
            }
        }
        return strnextTabID;
    }

    /**
     * @description This is a method to initialize the next tab on tab switch.
     */
    public void saveRecordOnTabChange() {
        try
        {
            strSelectedTabId = getParam('tabId');
            if(!currentTabType.Equals('Related List With Tab') && !currentTabType.Equals('Grantee Budget Tab') )
            {
                isSaveAndNext = true;

                if(String.isNotBlank(strSelectedTabId))
                    initializeQuizQuestionList(strSelectedTabId);
                isSaveAndNext= false;
            }
            else
            {
                if(String.isNotBlank(strSelectedTabId))

                    initializeQuizQuestionList(strSelectedTabId);
            }
            cancelViewRecord();
            flagshowpopup = false;
            initializeMapRequiredFields();
        }
        catch(Exception ex)
        {
            system.debug( 'Exception: ' + ex + ' @Line :: ' + ex.getLineNumber() + ' Message ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ' ' + ex));
        }
    }

    /**
     * @description This is a method to save and move to next tab.
     */
    public void saveAndNext() {
        isSaveAndNext = true;
        saveRecord();
        if(String.isNotBlank(nextTabID))
        {
            strSelectedTabId=nextTabID;
            initializeQuizQuestionList(nextTabID);
        }
        initializeMapRequiredFields();
        isSaveAndNext= false;
    }

    /**
     * @description This is a method to move to next tab on click of next
     * button on Related List Tab.
     */
    public void next() {
        if(String.isNotBlank(nextTabID))
            initializeQuizQuestionList(nextTabID);
    }

    /**
     * @description This is a method to save unsaved application changes.
     */
    public PageReference saveBeforeReviewSubmit() {
        Savepoint sp = Database.setSavepoint();
        try{
            if(tabObject == null)
                return null;
             tabObject = this.getCrudFlsService().stripInaccessibleForUpdate(tabObject);
             AdminContextExecutionManager.executeUpdate(new List<Sobject>{tabObject});
            //upsert tabObject;
            String strCampaignID = objSFDCEncoder.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('id'));
            String applicationId = application.id;
            String quizId = quiz.Id;
            if(String.isNotBlank(strCampaignID) && String.isNotBlank(applicationId) && String.isNotBlank(quizId)){
                PageReference ref = System.Page.CommunityApplicationReview;
                ref.getParameters().put('id', strCampaignID);
                ref.getParameters().put('quizId', quiz.Id);
                ref.getParameters().put('appID', application.Id);
                ref.getParameters().put('from', urlParamFrom);
                ref.setRedirect(true);
                return ref;
            }
        }catch(DMLException ex){
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            String errorMessage = ex.getMessage();
            Integer occurence;
            System.debug('Exception : ' +  ex.getMessage() + ' Line number ' + ex.getLineNumber());
            if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                occurence = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
                errorMessage = errorMessage.mid(occurence, errorMessage.length());
                occurence = errorMessage.lastIndexOf(':');
                errorMessage = errorMessage.mid(0, occurence);
                return rollbackWithError(errorMessage,sp);
            }
            else
                return rollbackWithError(ex.getMessage(),sp);
        }
        catch(Exception ex){
            System.debug('Exception : ' + ex.getMessage() + ' @Line number ' + ex.getLineNumber());
            rollbackWithError(ex.getMessage(),sp);
        }
        return null;
    }

    /**
     * @description This is a method to save the application record and create
     * OTM and OCR / Campaign members record.
     */
    public PageReference saveRecord() {
        try {
            Boolean isSCPLFieldAvailable = false;
            Savepoint sp = Database.setSavepoint();
            String strCampaignID = objSFDCEncoder.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('id'));
            GlobalPortalSettings__c globalSetting = GlobalPortalSettings__c.getOrgDefaults();
            CampaignMember newCampaignMember = null;
            OpportunityContactRole contactRole = null;
            sObject upsertObject = null;
            Integer isUserTeamMember;
            List<OpportunityShare> lstOppShares;
            List<User> userList;
            List<Schema.PicklistEntry> lstOTMPicklist = objectTypeMap.get('OpportunityTeamMember').newSObject().getSObjectType().getDescribe().fields.getMap().get('TeamMemberRole').getDescribe().getPickListValues();

            if (tabObject == null) {
                return null;
            }

            userList = [
                SELECT
                    CompanyName,
                    Contact.AccountId,
                    ContactId,
                    Email,
                    LastName,
                    UserProfile__c
                FROM User
                WHERE Id = :UserInfo.getUserId()
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            // condition to check this record bbelong to perticular user or not
            if (userList == null || userList.size() == 0 || campaign == null) {
                return null;
            }

            sObject parentSobject = null;

            if (tabObject.Id == null && !String.isNotBlank(userList[0].CompanyName)) {
                userList[0].CompanyName = userList[0].Email;
            }

            newCampaignMember = null;
            parentSobject = tabObject;
            String oppOwner = null;

            if (parentSobject.get('OwnerId') != null) {
                oppOwner = String.valueof(parentSobject.get('OwnerId'));
            }

            if (parentSobject.get('FGM_Portal__Quiz__c') == null && quiz != null) {
                parentSobject.put('FGM_Portal__Quiz__c',quiz.Id);
            }

            if (tabObject.Id == null && 'opportunity'.equalsIgnoreCase(currentParentObject)) {
                if (parentSobject.get('Name') == null) {
                    parentSobject.put('Name',campaign.Name);
                }

                if (globalSetting != null && globalSetting.Request_Campaign_Field_Name__c !=null || String.isNotBlank(globalSetting.Request_Campaign_Field_Name__c)) {
                    strRequestCampaignField = globalSetting.Request_Campaign_Field_Name__c;
                    parentSobject.put(strRequestCampaignField,campaign.Id);
                } else if (parentSobject.get('CampaignId') == null) {
                    parentSobject.put('CampaignId',campaign.Id);
                }

                if (parentSobject.get('CloseDate') == null) {
                    parentSobject.put('CloseDate',Date.today());
                }

                if (parentSobject.get('StageName') == null) {
                    parentSobject.put('StageName','In Progress');
                }

                if (parentSobject.get('AccountId') == null) {
                    parentSobject.put('AccountId',userList[0].Contact.AccountId);
                }

                parentSobject.put('OwnerId', UserInfo.getUserId());

                // The contact Role insert for Assign Grantee Report.
                contactRole = new OpportunityContactRole();
                contactRole.ContactId = userList[0].ContactId;
                contactRole.Role = SchemaEngine.getDefaultOpportunityContactRole().getValue();

                if (oppOwner == null || oppOwner == userInfo.getUserId()) {
                    contactRole.IsPrimary = true;
                } else {
                    contactRole.IsPrimary = false;
                }

            } else if (tabObject.Id == null && 'lead'.equalsIgnoreCase(currentParentObject)) {
                if (parentSobject.get('Email') == null) {
                    parentSobject.put('Email',userList[0].Email);
                }

                if (parentSobject.get('Company') == null) {
                    parentSobject.put('Company',userList[0].CompanyName);
                }

                if (parentSobject.get('LastName') == null) {
                    parentSobject.put('LastName',userList[0].LastName);
                }

                if (parentSobject.get('FGM_Base__Submitted_By__c') == null) {
                    parentSobject.put('FGM_Base__Submitted_By__c',userList[0].ContactId);
                }

                parentSobject.put('OwnerId', UserInfo.getUserId());

                if (globalSetting != null && String.isNotEmpty(globalSetting.LOI_Campaign_Field_Name__c)) {
                    strLOICampaignField = globalSetting.LOI_Campaign_Field_Name__c;
                    parentSobject.put(strLOICampaignField,campaign.Id);
                }

                newCampaignMember = new CampaignMember();
                newCampaignMember.CampaignId = campaign.Id;
            }

            upsertObject = parentSobject;

            if (upsertObject.Id != null) {
                strSelectedappId = upsertObject.Id;
            }

            ApexPages.currentPage().getParameters().put('id', Id.valueOf(strCampaignID));
            ApexPages.currentPage().getParameters().put('quizId', quiz.Id);
            ApexPages.currentPage().getParameters().put('appID',upsertObject.ID);

            try {
                Map<Id, Integer> mapAttachmentCount = new Map<Id, Integer>();

                if (!Test.isRunningTest()) {
                    mapAttachmentCount = getAttachmentCount();
                }

                //logic to check required field must not be blank before save the application.
                requiredQuestionErrors = new List<Questions__c>();
                if (!isSaveAndNext) {
                    for (Quiz_Questions__c quizQuestion: quizQuestionList) {
                        if (quizQuestion.Required__c && quizQuestion.Tab__c == selectedTab) {
                            if (quizQuestion.Question__r.Type__c == 'Salesforce Data Type') {
                                if (String.isBlank(String.valueOf(upsertObject.get(quizQuestion.Field__c)))) {
                                    requiredQuestionErrors.add(quizQuestion.Question__r);
                                }
                            } else if (quizQuestion.Question__r.Type__c == 'Attachment' && !String.isBlank(String.valueOf(upsertObject.Id))) {
                                if (mapApplicationAttachments.get(quizQuestion.Question__c) != null && mapAttachmentCount.get(quizQuestion.Question__c) <= 0) {
                                    requiredQuestionErrors.add(quizQuestion.Question__r);
                                }
                            }
                        }
                    }
                }

                attachedQuestionId = objSFDCEncoder.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('attachedQuestionId'));
                String countryCode, stateCode;

                if ('lead'.equalsIgnoreCase(currentParentObject) && Lead.getSobjectType().getDescribe().fields.getMap().keySet().contains('countrycode')) {
                    countryCode = string.valueOf(upsertObject.get('CountryCode'));
                    stateCode = string.valueOf(upsertObject.get('StateCode'));
                }

                if(upsertObject.Id != null){
                    upsertObject= this.getCrudFlsService().stripInaccessibleForUpdate(upsertObject);
                    update upsertObject;
                }
                else{
                    upsertObject = this.getCrudFlsService().stripInaccessibleForInsert(new List<Sobject>{upsertObject})[0];
                    insert upsertObject;
                }

                if ('lead'.equalsIgnoreCase(currentParentObject) && Lead.getSobjectType().getDescribe().fields.getMap().keySet().contains('countrycode') && (countryCode != null || stateCode != null)) {
                    upsertObject.put('CountryCode',countryCode);
                    upsertObject.put('StateCode', stateCode);
                    CrudFlsService.getInstance().assertUpdateable(upsertObject);
                    upsert upsertObject;
                }

                if (upsertObject !=null) {
                    ApplicationId = upsertObject.Id;
                }

                if (newCampaignMember != null && upsertObject.Id != null && 'lead'.equalsIgnoreCase(currentParentObject)) {
                    newCampaignMember.LeadId = upsertObject.Id;
                    CrudFlsService.getInstance().assertCreateable(newCampaignMember);
                    insert newCampaignMember;
                } else if (contactRole != null && upsertObject.Id != null && 'opportunity'.equalsIgnoreCase(currentParentObject) && !Test.isRunningTest()) {
                    contactRole.OpportunityId = upsertObject.Id;
                    AdminContextExecutionManager.executeInsert(new List<Sobject>{contactRole});
                }

                application = upsertObject;
                //Code for ownership model
                if (upsertObject.Id != null && 'opportunity'.equalsIgnoreCase(currentParentObject) && userList!=null && userList[0]!=null && userList[0].FGM_Portal__UserProfile__c.Contains('Grantee')) {
                    isUserTeamMember = [
                        SELECT COUNT()
                        FROM OpportunityTeamMember
                        WHERE OpportunityId = :upsertObject.Id
                        AND UserId = :Userinfo.getUserId()
                        WITH SECURITY_ENFORCED
                        LIMIT 1
                    ];

                    if (isUserTeamMember <= 0) {
                        OpportunityTeamMember TeamMember = new OpportunityTeamMember();
                        TeamMember.OpportunityId = upsertObject.Id;
                        TeamMember.UserId = userInfo.getUserId();
                        TeamMember.TeamMemberRole = userList[0].FGM_Portal__UserProfile__c.Contains('Consultant') ?'Consultant':lstOTMPicklist[0].getValue();

                        if (contactRole != Null && String.isNotBlank(contactRole.ID) && !SchemaEngine.getDefaultOpportunityContactRole().IsDefaultValue()) {
                            TeamMember.FGM_Portal__ContactRoleID__c  = contactRole.ID;
                        }

                        CrudFlsService.getInstance().assertCreateable(TeamMember);
                        Database.Saveresult saveResult =  Database.insert(TeamMember);
                    }

                    if (oppOwner != userInfo.getUserId() && oppOwner != null && isUserTeamMember <= 0) {
                        List<User> user = AdminContextExecutionManager.getUserResult(new List<String>{oppOwner});

                        if (user[0] != null && user[0].ContactId != null) {
                            contactRole = new OpportunityContactRole();
                            contactRole.ContactId = user[0].ContactId;
                            contactRole.OpportunityId = upsertObject.Id;
                            contactRole.Role = SchemaEngine.getDefaultOpportunityContactRole().getValue();
                            contactRole.IsPrimary = true;
                            AdminContextExecutionManager.executeInsert(new List<Sobject>{contactRole});

                            OpportunityTeamMember oppTeamMember = new OpportunityTeamMember();
                            oppTeamMember.OpportunityId = upsertObject.Id;
                            oppTeamMember.UserId = oppOwner;
                            oppTeamMember.TeamMemberRole = lstOTMPicklist[0].getValue();
                            CrudFlsService.getInstance().assertCreateable(oppTeamMember);
                            Database.Saveresult saveResult =  Database.insert(oppTeamMember);
                        }

                        //transfer opp owner and update opp account
                        if (user[0].Id != userList[0].ID && user[0].Contact.AccountId != null) {
                            upsertObject.put('AccountId',user[0].Contact.AccountId);
                        } else if (userList[0].Contact.AccountId != null) {
                            upsertObject.put('AccountId',userList[0].Contact.AccountId);
                        }

                        upsertObject.put('OwnerId', oppOwner);
                        AdminContextExecutionManager.executeUpdate(new List<Sobject>{upsertObject});
                    }

                    lstOppShares = [
                        SELECT
                            OpportunityAccessLevel,
                            RowCause,
                            UserOrGroupId
                        FROM OpportunityShare
                        WHERE OpportunityId = :upsertObject.Id
                        AND RowCause = 'Team'
                        WITH SECURITY_ENFORCED
                    ];

                    if (lstOppShares != null && lstOppShares.size() > 0) {
                        for (OpportunityShare share : lstOppShares) {
                            if ((share.UserOrGroupId == oppOwner) || (oppOwner == null && share.UserOrGroupId == userInfo.getUserId())) {
                                share.OpportunityAccessLevel = 'All';
                            } else if (share.UserOrGroupId == userInfo.getUserId()) {
                                share.OpportunityAccessLevel = 'Edit';
                            }
                        }

                        AdminContextExecutionManager.executeUpdate(lstOppShares);
                    }

                    strSelectedappId = upsertObject.Id;
                }

                if (upsertObject.Id != null && 'lead'.equalsIgnoreCase(currentParentObject) && userList!=null && userList[0]!=null && userList[0].FGM_Portal__UserProfile__c.Contains('Grantee')) {
                    if (oppOwner != userInfo.getUserId() && oppOwner != null) {
                        //transfer lead owner
                        upsertObject.put('OwnerId', oppOwner);
                        AdminContextExecutionManager.executeUpdate(new List<Sobject>{upsertObject});
                        //for sharing lead
                        LeadShare ls = new LeadShare();
                        ls.LeadId = upsertObject.Id;
                        ls.LeadAccessLevel = 'Edit';
                        ls.UserOrGroupId = userInfo.getUserId();
                        ls.RowCause = 'Manual';
                        AdminContextExecutionManager.executeInsert(new List<Sobject>{ls});
                    }
                }

                if (application != null) {
                    Set<String> setApplicationObjectFields = new Set<String>();
                    String applicationObjectName = String.valueOf(application.getsObjectType());
                    String applicationRecordId = String.valueOf(application.Id);
                    List<Sobject> lstApplicationRecords;
                    fillMapObjectFields();  // for Dynamic iFrames
                    setApplicationObjectFields.addAll(setApplicationFields);
                    if (mapObjNameLstFields != null && mapObjNameLstFields.get(currentParentObject.tolowercase()) != null && mapObjNameLstFields.get(currentParentObject.tolowercase()).size() > 0) {
                        for (String strField : mapObjNameLstFields.get(currentParentObject.tolowercase())) {
                            String strFieldAPIName = strField.tolowercase();
                            if (!setApplicationObjectFields.contains(strFieldAPIName)) {
                                setApplicationObjectFields.add(strFieldAPIName);
                            }
                        }

                        if (!setApplicationObjectFields.contains('Name') && !setApplicationObjectFields.contains('name')) {
                            setApplicationObjectFields.add('name');
                        }
                    }

                    List<String> sanitizedApplicationObjectFields = new List<String>();

                    for (String f : setApplicationObjectFields) {
                        sanitizedApplicationObjectFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                    }

                    lstApplicationRecords = Database.query(''
                                                           + 'SELECT ' + String.join(new List<String>(sanitizedApplicationObjectFields), ', ')
                                                           +' FROM ' + applicationObjectName
                                                           +' WHERE Id=:applicationRecordId'
                                                           +' WITH SECURITY_ENFORCED'
                                                           +' LIMIT 1' );

                    if (lstApplicationRecords != null && lstApplicationRecords.size() > 0) {
                        application = lstApplicationRecords[0];
                        tabObject = application;
                    }

                    if (mapObjNameObjDetails == null) {
                        mapObjNameObjDetails = new Map<String, sObject>();
                    }

                    mapObjNameObjDetails.put(currentParentObject.tolowercase(), application);
                }

                initializeAttachment();

                if (String.isBlank(getparam('appID'))) {
                    strSelectedappId=application.Id;
                }

            } catch (DMLException ex) {
                System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
                String errorMessage = ex.getMessage();
                Integer occurence;

                if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
                    occurence = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
                    errorMessage = errorMessage.mid(occurence, errorMessage.length());
                    occurence = errorMessage.lastIndexOf(':');
                    errorMessage = errorMessage.mid(0, occurence);
                    rollbackWithError(errorMessage,sp);
                } else {
                    rollbackWithError(ex.getMessage(),sp);
                }
            } catch(Exception ex) {
                System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
                rollbackWithError(ex.getMessage(),sp);
            }
        } catch (Exception ex) {
            System.debug( 'Exception: ' + ex +'at Line: '+ ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() ) );
        }

        return null;
    }

    public List<String> getyears() {
        return lstYears;
    }

    public List<Budget> getBudgets(){
        lstBudgets.sort();
        return lstBudgets;
    }

    /**
     * @description This is a method to update the existing grantee budget line
     * item records on click of Update on GBU tab. This button appears if the
     * budget has already been generated for current application.
     */
    public void UpdateBudgetLineItem() {
        try{
            List<Grantee_Budget_Line_Item__c> lstGranteeBudgetLineItem=new List<Grantee_Budget_Line_Item__c>();
            integer i =0;
            for(Budget objBudget:lstBudgets) {
                if(!objBudget.bisFooter)
                    for(BudgetLineItem objBudgetLineItem: objBudget.lstBudgetLineItem) {
                        Grantee_Budget_Line_Item__c objGranteeBudgetLineItem = new Grantee_Budget_Line_Item__c();
                        objGranteeBudgetLineItem.ID=objBudgetLineItem.IDBudgetLineItem;
                        objGranteeBudgetLineItem.Amount__c=objBudgetLineItem.decbudgetAmount;
                        objGranteeBudgetLineItem.Note__c = objBudget.strComment;
                        lstGranteeBudgetLineItem.add(objGranteeBudgetLineItem);
                    }
            }
            CrudFlsService.getInstance().assertUpdateable(lstGranteeBudgetLineItem);
            Database.Update(lstGranteeBudgetLineItem);
        }
        catch(Exception ex) {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            rollbackWithError(ex.getMessage(),null);
        }
    }

    /**
     * @description This is a method to insert the Grantee Budget Line item
     * records on click of save on grantee Budget tab.
     */
    public void InsertBudgetLineItem() {
        try{
            List<Grantee_Budget_Line_Item__c> lstGranteeBudgetLineItem=new List<Grantee_Budget_Line_Item__c>();
            Map<String,ID> mapGranteeBudget=new Map<String,ID>();
            Map<String,ID> mapGranteeBudgetCategory=new Map<String,ID>();
            Map<ID,ID> mapGranteeBudgetConfiguration=new Map<ID,ID>();
            List<Grantee_Budget__c> lstNewGranteeBudget=new List<Grantee_Budget__c>();

            for (Grantee_Budget__c objGranteeBudget : [
                SELECT Name
                FROM Grantee_Budget__c
                WITH SECURITY_ENFORCED
                LIMIT 100
            ]) {
                mapGranteeBudget.put(objGranteeBudget.Name, objGranteeBudget.Id);
            }

            for(string stryear:lstYears) {
                if(mapGranteeBudget!=null && !mapGranteeBudget.containsKey(stryear)) {
                    Grantee_Budget__c objGranteeBudget=new Grantee_Budget__c();
                    objGranteeBudget.Name=strYear;
                    lstNewGranteeBudget.add(objGranteeBudget);
                }
            }
            CrudFlsService.getInstance().assertCreateable(lstNewGranteeBudget);
            Database.Insert(lstNewGranteeBudget);
            for(Grantee_Budget__c objGranteeBudget:lstNewGranteeBudget)
                mapGranteeBudget.put(objGranteeBudget.Name,objGranteeBudget.ID);

            for (Grantee_Budget_Category__c objGranteeBudgetCategory : [
                SELECT Name
                FROM Grantee_Budget_Category__c
                WITH SECURITY_ENFORCED
                LIMIT 100
            ]) {
                mapGranteeBudgetCategory.put(objGranteeBudgetCategory.Name, objGranteeBudgetCategory.Id);
            }

            for (Grantee_Budget_Configuration__c objGranteeBudgetConfiguration : [
                SELECT Category__c
                FROM Grantee_Budget_Configuration__c
                WHERE Quiz__c = :quiz.Id
                AND Related_List_Controller__c = :selectedTab
                WITH SECURITY_ENFORCED
                LIMIT 100
            ]) {
                mapGranteeBudgetConfiguration.put(
                    objGranteeBudgetConfiguration.Category__c,
                    objGranteeBudgetConfiguration.Id
                );
            }

            for(Budget objBudget:lstBudgets) {
                if(!objBudget.bisFooter){
                    for(BudgetLineItem objBudgetLineItem: objBudget.lstBudgetLineItem) {
                        Grantee_Budget_Line_Item__c objGranteeBudgetLineItem = new Grantee_Budget_Line_Item__c();
                        objGranteeBudgetLineItem.Amount__c=objBudgetLineItem.decbudgetAmount;
                        objGranteeBudgetLineItem.Note__c = objBudget.strComment;
                        objGranteeBudgetLineItem.Opportunity__c=ID.valueOf(strSelectedappId);
                        objGranteeBudgetLineItem.Grantee_Budget__c=mapGranteeBudget.get(objBudgetLineItem.strbudgetYear);
                        objGranteeBudgetLineItem.Category__c=ID.valueOf(objBudget.strcategoryID);
                        objGranteeBudgetLineItem.Budget_Configuration__c=mapGranteeBudgetConfiguration.get(objBudget.strcategoryID);
                        lstGranteeBudgetLineItem.add(objGranteeBudgetLineItem);
                    }
                }
            }

            CrudFlsService.getInstance().assertCreateable(lstGranteeBudgetLineItem);
            List<Database.SaveResult> saveResult = Database.Insert(lstGranteeBudgetLineItem);
            isBudgetExist=true;
            generateExistingBudget();
        }
        catch(Exception ex){
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            rollbackWithError(ex.getMessage(),null);
        }
    }

    /**
     * @description This is a method to create the Budget wrapper class rows
     * and shows the table to user in which user can give budget as per
     * categories and years.
     */
    public void generateBudget() {
        try
        {
            List<Grantee_Budget_Configuration__c> lstCategory;
            if( String.isBlank( dateFrom ) || String.isBlank( dateTo ) )
            {
                rollbackWithError( System.Label.FC_BlankStartEndDateBudgetTabErrorMessage, null );
                return;
            }
            string[] arrfrmDate = dateFrom.split( '/', 3 );
            string[] arrtoDate= dateTo.split( '/' , 3 );
            integer yearDifference = Integer.valueOf( arrtoDate[2] ) - Integer.valueOf( arrfrmDate[2] );
            lstYears = new List<String>();
            for ( integer i = 0 ;i < = yearDifference; i++ )
                lstYears.add( String.valueOf( Integer.valueOf( arrfrmDate[2] ) + i ) );

            lstCategory = [
                SELECT
                    Category__c,
                    Category__r.Name,
                    Category__r.Parent_Category__r.Name,
                    Name,
                    Quiz__c,
                    Related_List_Controller__c,
                    Sort_Order__c
                FROM Grantee_Budget_Configuration__c
                WHERE Quiz__c = :quiz.Id
                AND Related_List_Controller__c = :selectedTab
                WITH SECURITY_ENFORCED
                ORDER BY Sort_Order__c
                LIMIT 100
            ];

            lstBudgets = new List<Budget>();
            for( Grantee_Budget_Configuration__c objCategory : lstCategory )
            {
                Budget objBudget = new Budget();
                objBudget.lstBudgetLineItem = new List<BudgetLineItem>();
                objBudget.strcategoryName = objCategory.Category__r.Name;
                objBudget.strParentcategoryName = objCategory.Category__r.Parent_Category__r.Name;
                objBudget.strcategoryNameID = objCategory.Category__c;
                objBudget.bisFooter = false;
                objBudget.strcategoryID = objCategory.Category__c;
                objBudget.sortOrder = 0;
                if(objCategory.Sort_Order__c != null)
                    objBudget.sortOrder = objCategory.Sort_Order__c;
                for( String stryear : lstYears )
                {
                    BudgetLineItem objBudgetLineItem = new BudgetLineItem();
                    objBudgetLineItem.decbudgetAmount = 0;
                    objBudgetLineItem.strbudgetYear = stryear;
                    objBudget.lstBudgetLineItem.add( objBudgetLineItem );
                }
                lstBudgets.add( objBudget );
            }
            Budget objBudgetFooter = new Budget();
            objBudgetFooter.strcategoryName = System.Label.FC_BudgetSubTotal ;
            objBudgetFooter.strcategoryNameID = 'SubTotal';
            objBudgetFooter.bisFooter = true;
            objBudgetFooter.lstBudgetLineItem = new List<budgetLineItem>();
            for( String stryear : lstYears )
            {
                BudgetLineItem objBudgetLineItem = new BudgetLineItem();
                objBudgetLineItem.decbudgetAmount = 0;
                objBudgetLineItem.strbudgetYear = stryear;
                objBudgetFooter.lstBudgetLineItem.add( objBudgetLineItem );
            }
            lstBudgets.add( objBudgetFooter );
            isBudgetGenerated = true;
        }
        catch( Exception ex )
        {
            System.debug('Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            rollbackWithError( ex.getMessage(), null );
        }
    }

    /**
     * @description This is a method to get the existing budget line item
     * records and show in table.
     */
    public void generateExistingBudget() {
        try{
            map<ID,Grantee_Budget_Category__c> mapGranteeBudgetCategory = new map<ID,Grantee_Budget_Category__c>();
            List<Grantee_Budget_Line_Item__c> lstGranteeBudgetLineItem;

            for (Grantee_Budget_Category__c objGranteeBudgetCategory : [
                SELECT Name
                FROM Grantee_Budget_Category__c
                WITH SECURITY_ENFORCED
                LIMIT 100
            ]) {
                mapGranteeBudgetCategory.put(
                    objGranteeBudgetCategory.Id,
                    objGranteeBudgetCategory
                );
            }

            lstGranteeBudgetLineItem = [
                SELECT
                    Amount__c,
                    Budget_Configuration__c,
                    Budget_Configuration__r.Sort_Order__c,
                    Category__c,
                    Category__r.Parent_Category__c,
                    Grantee_Budget__c,
                    Grantee_Budget__r.Name,
                    Name,
                    Note__c,
                    Opportunity__c
                FROM Grantee_Budget_Line_Item__c
                WHERE Opportunity__c = :Id.valueOf(strSelectedappId)
                WITH SECURITY_ENFORCED
                ORDER BY Grantee_Budget__r.Name
                LIMIT 1000
            ];

            map<ID,List<Grantee_Budget_Line_Item__c>> mapGranteeBudgetLineItemByCategory = new map<ID,List<Grantee_Budget_Line_Item__c>>();

            set<Integer> setYears = new set<Integer>();
            if(lstGranteeBudgetLineItem!=null && !lstGranteeBudgetLineItem.IsEmpty())
            {
               for(Grantee_Budget_Line_Item__c objGranteeBudgetLineItem:lstGranteeBudgetLineItem) {
                ID IDCategory=objGranteeBudgetLineItem.Category__c;
                if(mapGranteeBudgetLineItemByCategory!=null && mapGranteeBudgetLineItemByCategory.containsKey(IDCategory))
                    mapGranteeBudgetLineItemByCategory.get(IDCategory).add(objGranteeBudgetLineItem);
                else
                    mapGranteeBudgetLineItemByCategory.put(IDCategory,new LIST<Grantee_Budget_Line_Item__c>{objGranteeBudgetLineItem});
                setYears.add(Integer.valueOf(objGranteeBudgetLineItem.Grantee_Budget__r.Name));
            }
            }

            lstYears=new List<String>();

            for (integer intYear:setYears)
            {
                lstYears.add(String.valueOf(intYear));
            }
            lstBudgets=new List<Budget>();
            for(ID categoryID : mapGranteeBudgetLineItemByCategory.keySet()) {
                Budget objBudget=new Budget();
                objBudget.lstBudgetLineItem=new List<BudgetLineItem>();
                objBudget.bisFooter=false;
                objBudget.strcategoryName=mapGranteeBudgetCategory.get(categoryID).Name;
                objBudget.strcategoryNameID=String.valueOf(categoryID);
                objBudget.strcategoryID=String.valueOf(categoryID);
                for(Grantee_Budget_Line_Item__c objGranteeBudgetLineItem : mapGranteeBudgetLineItemByCategory.get(categoryID)) {
                    BudgetLineItem objBudgetLineItem=new BudgetLineItem();
                    objBudgetLineItem.granteebudgetlineitem=objGranteeBudgetLineItem;
                    objBudgetLineItem.IDBudgetLineItem=objGranteeBudgetLineItem.ID;
                    objBudgetLineItem.decbudgetAmount=objGranteeBudgetLineItem.Amount__c;
                    objBudgetLineItem.strbudgetYear=objGranteeBudgetLineItem.Grantee_Budget__r.Name;
                    objBudget.lstBudgetLineItem.add(objBudgetLineItem);
                    objBudget.strComment=objGranteeBudgetLineItem.Note__c;
                    objBudget.sortOrder = 0;
                    if(objGranteeBudgetLineItem.Budget_Configuration__r.Sort_Order__c != null)
                        objBudget.sortOrder = objGranteeBudgetLineItem.Budget_Configuration__r.Sort_Order__c;

                    if(string.isNotBlank(objGranteeBudgetLineItem.Category__r.Parent_Category__c) && string.isNotEmpty(objGranteeBudgetLineItem.Category__r.Parent_Category__c) && mapGranteeBudgetCategory.size()>0 && mapGranteeBudgetCategory != null )
                        objBudget.strParentcategoryName = mapGranteeBudgetCategory.get(objGranteeBudgetLineItem.Category__r.Parent_Category__c).Name;
                }
                lstBudgets.add(objBudget);
            }
            Budget objBudgetFooter = new Budget();
            objBudgetFooter.strcategoryName= System.Label.FC_BudgetSubTotal;
            objBudgetFooter.strcategoryNameID='SubTotal';
            objBudgetFooter.bisFooter=true;
            objBudgetFooter.lstBudgetLineItem=new List<budgetLineItem>();
            for(String stryear:lstYears) {
                BudgetLineItem objBudgetLineItem=new BudgetLineItem();
                objBudgetLineItem.decbudgetAmount=0;
                objBudgetLineItem.strbudgetYear=stryear;
                objBudgetFooter.lstBudgetLineItem.add(objBudgetLineItem);
            }
            lstBudgets.add(objBudgetFooter);
            isBudgetGenerated=true;
        }
        catch(Exception ex){
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            rollbackWithError(ex.getMessage(),null);
        }
    }

    /**
     * @description This is a method to reset the date values on click of first
     * cancel on Budget Tab.
     */
    public void cancelGenerateBudget() {
        dateFrom = '';
        dateTo = '';
    }

    /**
     * @description This is a method to reset the budget value to existing or
     * hide the section shown on generate budget if no budget is already
     * present.
     */
    public void CancelBudget() {
        if(isBudgetExist)
            generateExistingBudget();
        else
            isBudgetGenerated=false;
    }

    /**
     * @description This is a method to cancel organization tab and show tab in
     * read mode.
     */
    public pageReference CancelOrganizationTab() {
        getOrganizationRecord();
        return null;
    }

    /**
     * @description This is a method to check if there are any errors on save
     * based on result of Save OrganizationTabOnErr and navigate to next tab in
     * case of no errors.
     */
    public PageReference SaveOrganizationTabAndNext() {
        isSaveAndNext = true;
        Boolean saveRslt = SaveOrganizationTabOnErr();
        if(!saveRslt && String.isNotBlank(nextTabID))
        {
            strSelectedTabId=nextTabID;
            initializeQuizQuestionList(nextTabID);
        }
        else
            return null;
        initializeMapRequiredFields();
        isSaveAndNext= false;
        return null;
    }

    /**
     * @description This is a method to save account record.
     */
    public PageReference SaveOrganizationTab() {
        try
        {
            if (
                this.bIsOrganizationTab &&
                this.userAccount != null && 
                this.userAccount.Id != null
            ) {
                this.getAdminContextExecutionManager().stripInaccessibleAndUpdate(new List<SObject>{
                    this.userAccount
                });
            }
		}
        catch(DmlException ex) {
            for (Integer i = 0; i < ex.getNumDml(); i ++) {
                System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, '' + ex.getDmlMessage(i)));
            }
        }
        catch(Exception ex) {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, '' + ex.getMessage()));
        }
        return null;
    }

    /**
     * @description This is a method to save account record and return if it
     * has eny error to prevent jum to next on save and next of organization
     * tab.
     */
    public Boolean SaveOrganizationTabOnErr() {
        try
        {
            if (
                this.bIsOrganizationTab &&
                this.userAccount != null &&
                this.userAccount.Id != null
            ) {
                this.getAdminContextExecutionManager().stripInaccessibleAndUpdate(new List<SObject>{
                    this.userAccount
                });
            }                
        }
        catch(DmlException ex) {
            for (Integer i = 0; i < ex.getNumDml(); i ++) {
                System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, '' + ex.getDmlMessage(i)));
            }
            return true;
        }
        catch(Exception ex) {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, '' + ex.getMessage()));
            return true;
        }
        return false;
    }

    /**
     * @description This is a method to cancel the edit and show tab in read
     * mode
     */
    public pageReference CancelContactTab() {
        getContactRecord();
        return null;
    }

    /**
     * @description This is a method to save contact tab and navigate to next
     * tab
     */
    public pageReference SaveContactTabAndNext() {
        isSaveAndNext = true;
        SaveContactTab();
        if(ApexPages.hasMessages())
            return null;
        if(String.isNotBlank(nextTabID))
            initializeQuizQuestionList(nextTabID);
        isSaveAndNext= false;
        initializeMapRequiredFields();
        return null;
    }

    /**
     * @description This is a method to save the contact record
     */
    public PageReference SaveContactTab() {
        try {
            if (
                this.bIsContactTab &&
                this.userContact != null &&
                this.userContact.Id != null
            ) {
                this.getAdminContextExecutionManager().stripInaccessibleAndUpdate(new List<Contact>{
                    this.userContact
                });
            }

        } catch(DmlException ex) {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            for (Integer i = 0; i < ex.getNumDml(); i ++)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, '' + ex.getDmlMessage(i)));
        } catch(Exception ex) {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, '' + ex.getMessage()));
        }
        
        return null;
    }

    /**
     * @description This is a method to get the Account's field set depending
     * on user type i.e Organization or Individual.
     */
    public List<Schema.FieldSetMember> getAccountFields() {
        if( isIndividual)
            return SObjectType.Account.FieldSets.CommunityIndividualProfile.getFields();
        else
            return SObjectType.Account.FieldSets.CommunityAccountFieldSet.getFields();
    }

    /**
     * @description This is a method to get the contact's field set depending
     * on user type i.e Organization or Individual.
     */
    public List<Schema.FieldSetMember> getContactFields() {
        if( isIndividual)
            return SObjectType.Contact.FieldSets.CommunityIndividualProfile.getFields();
        else
            return SObjectType.Contact.FieldSets.CommunityContactFieldSet.getFields();
    }

    /**
     * @description This is a method to get the map of required fields for
     * contact or account depending on current tab object.
     */
    public void initializeMapRequiredFields() {
        if(bIsSCPLEnable)
        {
            mapRequiredField.clear();
            List<Schema.FieldSetMember> fieldset;
            if(currentTabType == 'Contact Tab')
                fieldset =  getContactFields();
            if(currentTabType == 'Organization Tab')
                fieldset = getAccountFields();
            if(fieldset!=null)
            {
                for(Schema.FieldSetMember field : fieldset)
                {
                    if(field.getDBRequired() || field.getRequired())
                    {
                        mapRequiredField.put(field.getFieldPath(),field.getLabel());
                    }
                }
            }
        }
    }

    public String getJSONmapRequiredField() {
        if( mapRequiredField != null && mapRequiredField.size()>0)
            return JSON.serialize(mapRequiredField);
        return null;
    }

    public class Budget implements Comparable {
        public String strcategoryName { get; set; }
        public String strcategoryNameID { get; set; }
        public String strParentcategoryName { get; set; }
        public String strcategoryID { get; set; }
        public Boolean bisFooter { get; set; }
        public String strComment { get; set; }
        public Double sortOrder { get; set; }
        public List<BudgetLineItem> lstBudgetLineItem { get; set; }

        public Integer compareTo(Object compareTo) {
            Budget compareToBudget = (Budget) compareTo;

            if (sortOrder == compareToBudget.sortOrder) {
                if (this.strParentcategoryName == null || compareToBudget.strParentcategoryName == null) {
                    return -1;
                }

                if (this.strParentcategoryName == compareToBudget.strParentcategoryName) {
                    return (this.strcategoryName.compareTo(compareToBudget.strcategoryName));
                }

                return (this.strParentcategoryName.compareTo(compareToBudget.strParentcategoryName));
            }

            if (sortOrder > compareToBudget.sortOrder) {
                return 1;
            }

            return -1;
        }
    }

    public class BudgetLineItem {
        public Id IDBudgetLineItem { get; set; }
        public Decimal decbudgetAmount { get; set; }
        public Grantee_Budget_Line_Item__c granteebudgetlineitem { get; set; }
        public String strbudgetYear { get; set; }
    }

    /**
     * @description This is a inner class the show opportunity team member and
     * opportunity contact role records toghther on OTM tab
     */
    public class OTMOCRWrapper {
        public String UserId { get; set; }
        public String ContactId { get; set; }
        public String OpportunityId { get; set; }
        public String TeamMemberRole { get; set; }
        public String additionalRolesRW { get; set; }
        public String additionalRolesRO { get; set; }
        public OpportunityTeamMember OTM { get; set; }
        public OpportunityContactRole OCR { get; set; }
        public Boolean IsForPartnerUser { get; set; }
        public String TeamMemberRoleLabel { get; set; }

        public OTMOCRWrapper(OpportunityTeamMember otm, OpportunityContactRole ocr, Set<String> setAdditionalRoles, Boolean isForPartnerUser) {
            this.OTM = otm;
            this.OCR = ocr;
            if( isForPartnerUser != null )
                this.IsForPartnerUser = isForPartnerUser;
            else if( ocr != null )
                this.IsForPartnerUser = true;
            else
                this.IsForPartnerUser = false;

            if( this.OTM != null && this.OTM.TeamMemberRole != null )
                this.TeamMemberRole = this.OTM.TeamMemberRole;
            string strTeamMemberRole = SchemaEngine.getOpportunityTeamMemberPicklistEntries().get(this.TeamMemberRole) != null ? SchemaEngine.getOpportunityTeamMemberPicklistEntries().get(this.TeamMemberRole) : this.TeamMemberRole;
            TeamMemberRoleLabel=strTeamMemberRole ;
            string ocrRoleEqualToTeam;
            if( setAdditionalRoles != null && !setAdditionalRoles.isEmpty() )
            {

                List<String> lstRoles = new List<String>();
                lstRoles.addAll( setAdditionalRoles );
                map<string, string> mapOCRolePicklistEnrties = SchemaEngine.getOpportunityContactRolePicklistEntries();
                for( Integer iCount = 0; iCount < lstRoles.size(); iCount ++ )
                {
                    string strOCRPicklist = (mapOCRolePicklistEnrties.get(lstRoles[iCount]) != null) ? mapOCRolePicklistEnrties.get(lstRoles[iCount]) : lstRoles[iCount];
                    if( this.additionalRolesRW == null )
                        this.additionalRolesRW = strOCRPicklist;
                    else
                        this.additionalRolesRW += '; ' + strOCRPicklist;


                    if( !strOCRPicklist.equalsIgnoreCase( strTeamMemberRole ) )
                    {
                        if( this.additionalRolesRO == null )
                        {
                            this.additionalRolesRO = strOCRPicklist;
                        }
                        else
                            this.additionalRolesRO += '; ' + strOCRPicklist;
                    }
                    else
                    {
                        ocrRoleEqualToTeam = strTeamMemberRole;
                    }

                }
            }
            if(strTeamMemberRole != null) // exisiting value in this.TeamMemberRole in API for PicklistEntry
            {
                if( String.isNotBlank(this.additionalRolesRO) && CommunityApplicationExtension.isTeamRoleInQuizQuestion && CommunityApplicationExtension.isAdditionalRoleInQuizQuestion)
                    this.additionalRolesRO = strTeamMemberRole + '; ' + this.additionalRolesRO;
                else if((String.isNotBlank(this.additionalRolesRO) || String.isBlank(this.additionalRolesRO)) && CommunityApplicationExtension.isTeamRoleInQuizQuestion && !CommunityApplicationExtension.isAdditionalRoleInQuizQuestion)
                    this.additionalRolesRO = strTeamMemberRole;
                else if(!CommunityApplicationExtension.isTeamRoleInQuizQuestion && !CommunityApplicationExtension.isAdditionalRoleInQuizQuestion )
                    this.additionalRolesRO = '-';
                else if(String.isBlank(this.additionalRolesRO) && !CommunityApplicationExtension.isTeamRoleInQuizQuestion && String.isBlank(ocrRoleEqualToTeam))
                    this.additionalRolesRO = '-';
                else if(String.isBlank(this.additionalRolesRO) && CommunityApplicationExtension.isTeamRoleInQuizQuestion )
                    this.additionalRolesRO = strTeamMemberRole;
                else if(String.isNotBlank(this.additionalRolesRO) && String.isNotBlank(ocrRoleEqualToTeam)&& !CommunityApplicationExtension.isTeamRoleInQuizQuestion && CommunityApplicationExtension.isAdditionalRoleInQuizQuestion)
                    this.additionalRolesRO = ocrRoleEqualToTeam+ '; ' + this.additionalRolesRO;
                else if(String.isBlank(this.additionalRolesRO) && String.isNotBlank(ocrRoleEqualToTeam) && !CommunityApplicationExtension.isTeamRoleInQuizQuestion && CommunityApplicationExtension.isAdditionalRoleInQuizQuestion)
                    this.additionalRolesRO = ocrRoleEqualToTeam;
            }
            else
            {
                if(!CommunityApplicationExtension.isAdditionalRoleInQuizQuestion)
                    this.additionalRolesRO = '-';
            }
        }
    }

    public class AttachmentsWrapper {
        public String id { get; set; }
        public String name { get; set; }
        public String description { get; set; }
        public Boolean isAttachment { get; set; }
        public Datetime createdDate { get; set; }
        public String relatedRecordId { get; set; }
        public AttachmentsWrapper(Id id, String name, String description, String relatedRecordId, Boolean isAttachment, Datetime createdDate) {
            this.id = id;
            this.name = name;
            this.description = description;
            this.isAttachment = isAttachment;
            this.createdDate = createdDate;
            this.relatedRecordId = relatedRecordId;
        }
    }

    public with sharing class ApplicationAttachments {
        public Question_Attachment__c questionAttachment { get; set; }
        public Map<String, sObject> mapOldAttachments { get; set; }
        public String strQuestionAttachmentId { get; set; }
        public Attachment newAttachment { get; set; }
        public Integer oldMapSize { get; set; }
        public Map<String, String> mapAttachType { get;set; }

        public ApplicationAttachments() {
            newAttachment = new Attachment();
            mapOldAttachments = new Map<String,SObject>();
            questionAttachment = new FGM_Portal__Question_Attachment__c();
            oldMapSize = 0;
            mapAttachType = new Map<String, String>();
        }
    }

    // class for showing related list records for custom object
    public with sharing class RelatedList {
        public Map<String, String> mapColumnFields { get; set; }
        public List<String> lstColumnFields { get; set; }
        public List<Object> lstRelatedListRecord { get; set; }
        public String strActionColLabel { get; set; }
        public String strRelatedListObject { get; set; }
        public String relatedListLookUp { get; set; }
        public Boolean isCreatable { get; set; }
        public Boolean isEditable { get; set; }
        public Boolean isDeletable { get; set; }
        public Related_List_Controller__c record { get; set; }

        public RelatedList() {
            lstRelatedListRecord = new List<Object>();
            strActionColLabel = Label.FC_Action_ColumnHeaderLabel;
        }
    }

    public with sharing class FeedAttachment {
        public String strQuestionAttachmentId { get; set; }
        public Attachment newAttachment { get; set; }
        public List<FeedItem> lstOldFeedAttachment { get; set; }
        public Map<String, FeedItem> mapOldFeedAttachments { get; set; }
        public Integer oldMapSize { get; set; }
        public Question_Attachment__c questionAttachment { get; set; }
        public FeedAttachment() {
            newAttachment = new Attachment();
            lstOldFeedAttachment = new List<FeedItem>();
            mapOldFeedAttachments = new Map<String,FeedItem>();
            oldMapSize = 0;
        }
    }

    public class ReviewPage {
        public String name { set; get; }
        public String Id { get; set; }
        public String TabType { set; get; }
        public RelatedList relatedListConfiguration { get; set; }
        public List<ReviewQuestion> reviewQuestionList { set; get; }
    }

    public class ReviewQuestion {
        public Questions__c question { set; get; }
        public String response { set; get; }
        public String responseField { set; get; }
        public String questionType { set; get; }
        public String questionId { get; set; }
        public String strFieldType { get; set; }
        public Boolean isHTMLenabled { get; set; }
    }

    public virtual class CustomException extends Exception {}

    private class RequiredFieldException extends CustomException {
        public Questions__c question;

        public Questions__c getQuestion() {
            return question;
        }

        public RequiredFieldException(Questions__c question) {
            this.question = question;
        }
    }

    private static Boolean isCampaignExpired(Date endDate) {
        return new DateUtility().dateHasPassedInCompanyTimezone(endDate);
    }
}