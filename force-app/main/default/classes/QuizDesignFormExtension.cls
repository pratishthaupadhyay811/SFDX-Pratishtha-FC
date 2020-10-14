public with sharing class QuizDesignFormExtension {
    public Boolean initialized {get; set;} {initialized = false;}
    public ApexPages.StandardController controller { set; get; }
    public SelectOption[] quizOptions { set; get; }
    public SelectOption[] questionOptions { set; get; }
    public String selectedQuizId { set; get; }
    public String selectedPage { set; get; }
    public String selectedTab { set; get; }
    public Map < String, String > fieldType { get; set; }
    public Map < String, String > formulaFields { get; set; }
    public Map < String, String > mapChildrelationShip;
    public Boolean hasChildObject { set; get; }
    public Boolean BlnTestField { get; set; }
    public Boolean isRequestPortalTab { set; get; }
    public Boolean isBudgetTabExist { set; get; }
    public Boolean isBudgetUpdateTabExist { set; get; }
    public FGM_Portal__Quiz__c quiz { set; get; }
    public List<FGM_Portal__Quiz_Questions__c> quizQuestionList { set; get; }
    public List < FGM_Portal__Related_List_Controller__c > tabsList { get; set; }
    public List < FGM_Portal__Related_List_Controller__c > portalTabsList;
    public static List < FGM_Portal__Related_List_Controller__c > relatedListTabList;
    public List < FGM_Portal__Related_List_Controller__c > tabListEng;
    public List < FGM_Portal__Quiz_Questions__c > quizQuestionListEng;
    public FGM_Portal__Related_List_Controller__c portalRLC;
    public FGM_Portal__Quiz_Questions__c quizQuestionInsert { set; get; }
    public FGM_Portal__Questions__c questionInsert { set; get; }
    public RelatedListController currentRLCRecord { get; set; }
    public Question_Attachment__c questionAttachment;
    public Map < String, String > mapLanguageFieldNotPresentOnObject;
    public Map < String, Map < String, Map < String, String >>> mapLanguageDependentFieldsByObject;
    public String portalType { get; set; }
    public Boolean isExternalReviewer { get; set; }
    public Boolean isShowExternalRelatedObject { get; set; }
    public String strSelectedObject;
    public Boolean isApplicationdesigner { get; set; }
    public Boolean isOtherLanguageConfig { get; set; }
    public String selectedLanguage { get; set; }
    public String selectedObject { get; set; }
    public String selectedRecordType { get; set; }
    public String selectedPageLayout { get; set; }
    public String existPageLayout { get; set; }
    public Map < Id, FCPageLayout__c > mapFCPageLayout;
    public List < FCPageLayout__c > lstFCPageLayout;
    public List < Selectoption > lstRecordType { get; set; }
    public List < Selectoption > lstExistingLayout { get; set; }
    public FCPageLayout__c newPageLayout { get; set; }
    public Integer iColumnIndex { get; set; }
    public boolean showTabBelongToExternalReviewForShowApplication { get; set; }
    String tabObject = '';
    public SelectOption[] fieldOptions { set; get; }
    public List < SelectOption > childObjectFieldsOptions { set; get; }
    public User user { get; set; }
    public Boolean isCloneQuiz { get; set; }
    public String newQuizName { get; set; }
    public Boolean isCloneQuizPopUpVisible { get; set; }
    public String portalLanguage { get; set; }
    public List < SelectOption > lstLanguageOptions { get; set; }
    private FGM_Portal__Related_List_Controller__c cloneRLC;
    public ID newRLCRecordId;

    @TestVisible
    public ID quizID { get; private set; }
    public Boolean isIFrameTab { get; set; }
    public Boolean isGranteeBudgetTab { get; set; }
    public Boolean isGranteeBudgetUpdateTab { get; set; }
    public Boolean bIsBenchmarkUpdateTab {get; set;}
    public SFDCEncoder ESAPI = new SFDCEncoder();
    public Boolean isBudgetError { get; set; }
    public Boolean isClonedApp { get; set; }
    public Boolean IsContactTabActive { get; set; }
    public Boolean IsContactTabPresent { get; set; }
    private Integer iNoOfBenchmarkUpdateTab;
    public Boolean bIsBenchmarkUpdateExist {get; set;}
    // FCPROD - 1320
    private FCGlobal.UserSession userSession;
    public List < SelectOption > LstSlctAccntChldObjcts { set; get; }
    public String SelectedObjectOption { get; set; }
    public String SelectedProfileTabOption { get; set; }
    public Boolean BIsCstmPrflTbActv { get; set; }
    public Map< String, List<FGM_Portal__Related_List_Controller__c>> MapObjNRlcRecords { get; set; }

    // FCPROD - 1303
    public Boolean IsOrgTabPresent { get; set; }
    public Boolean IsOrgTabActive { get; set; }

    //To refresh page in certain time
    public void refreshPage() {}

    private Map<Id, String> mapRLCTabWithObjectName;
    private Map<String, Set<String>> mapObjectNameSetFields;
    private Boolean IsWarningShown = false;
    private Boolean IsWarningForDependentPicklistShown = false;
    private String ErrorMessage;

    public Map< String, String > MapFieldApiNameToLabel { get; set; }
    private Map< String, List<Quiz_Questions__c> > mapTabIdWthQQs;

    private void findDuplicateQuizQuestionMappings()
    {
        try
        {
            mapRLCTabWithObjectName = new Map<Id, String>();
            mapObjectNameSetFields = new Map<String, Set<String>>();
            Map<String, Set<String>> mapObjectNameSetRLCTabs = new Map<String, Set<String>>();
            Map<String, Integer> mapObjectNameCountDuplicates = new Map<String, Integer>();
            List<String> lstTabNames = new List<String>();
            Set<Id> setRLCIds = new Set<Id>();
            Set<String> setRLCTabs;
            for( Related_List_Controller__c rlcTab : tabsList )
            {
                if( rlcTab.Quiz__c == quizID && rlcTab.Language__c == portalLanguage && ( rlcTab.RecordType.Name == 'Portal Tab' || rlcTab.RecordType.Name == 'Related List With Tab' ) && rlcTab.ObjectName__c != null )
                {
                    setRLCIds.add( rlcTab.Id );
                    mapRLCTabWithObjectName.put( rlcTab.Id, rlcTab.ObjectName__c );
                    if( mapObjectNameSetRLCTabs.get( rlcTab.ObjectName__c ) != null )
                        setRLCTabs = mapObjectNameSetRLCTabs.get( rlcTab.ObjectName__c );
                    else
                        setRLCTabs = new Set<String>();
                    setRLCTabs.add( rlcTab.Name );
                    mapObjectNameSetRLCTabs.put( rlcTab.ObjectName__c, setRLCTabs );
                }
            }
            for( List<Quiz_Questions__c> lstQuestions : mapTabIdWthQQs.values() )
            {
                for( Quiz_Questions__c quizQuestion : lstQuestions )
                {
                    if( setRLCIds.contains( quizQuestion.Tab__c ) && quizQuestion.Question__r.Type__c != null && quizQuestion.Question__r.Type__c.equalsIgnoreCase( 'Salesforce Data Type' ) && quizQuestion.Field__c != null && quizQuestion.Tab__r.ObjectName__c != null )
                    {
                        Integer iDupCount;
                        Set<String> setFields;
                        if( mapObjectNameSetFields.get( quizQuestion.Tab__r.ObjectName__c ) != null )
                            setFields = mapObjectNameSetFields.get( quizQuestion.Tab__r.ObjectName__c );
                        else
                            setFields = new Set<String>();
                        if( setFields.contains( quizQuestion.Field__c ) )
                        {
                            if( mapObjectNameCountDuplicates.get( quizQuestion.Field__c ) != null )
                                iDupCount = mapObjectNameCountDuplicates.get( quizQuestion.Field__c );
                            else
                                iDupCount = 0;
                            iDupCount++;
                            mapObjectNameCountDuplicates.put( quizQuestion.Tab__r.ObjectName__c, iDupCount );
                        }
                        else
                            setFields.add( quizQuestion.Field__c );
                        mapObjectNameSetFields.put( quizQuestion.Tab__r.ObjectName__c, setFields );
                    }
                }
            }
            for( String objectName : mapObjectNameCountDuplicates.keySet() )
            {
                if( mapObjectNameCountDuplicates.get( objectName ) > 0 )
                {
                    for( String rlcTabName : mapObjectNameSetRLCTabs.get( objectName ) )
                        lstTabNames.add( rlcTabName );
                }
            }
            if( !lstTabNames.isEmpty() && !IsWarningShown )
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'We found following tab/s which have duplicate fields mapped to questions. Please, revisit the mappings.'));
                for( String tabName : lstTabNames )
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, ''+ tabName));
                IsWarningShown = true;
            }
        }
        catch( Exception ex )
        {
            system.debug( 'Exception: ' + ex + ' @Line :: ' + ex.getLineNumber() + ' Message ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Exception: ' + ex.getMessage()));
        }
    }
    private String getLabelFromAPIName( String fieldApiName, String objectApiName, boolean bIsObject )
    {
        try
        {
            String strObjectLabel = Schema.getGlobalDescribe().get( objectApiName ).getDescribe().getLabel();
            if( bIsObject == true )
                return strObjectLabel;
            else
            {
                for( Schema.SObjectField field : Schema.getGlobalDescribe().get( objectApiName ).getDescribe().fields.getMap().values() )
                {
                    if( field.getDescribe().getName() == fieldApiName )
                    {
                        return field.getDescribe().getLabel();
                    }
                }
                return fieldApiName;
            }
        }
        catch( Exception ex )
        {
            system.debug( 'Exception: ' + ex + ' @Line :: ' + ex.getLineNumber() + ' Message ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ''+ ex.getMessage()));
            return fieldApiName;
        }
    }
    public QuizDesignFormExtension(ApexPages.StandardController controller)
    {
        try
        {
            this.controller = controller;
            isClonedApp = false;
            quizID = ESAPI.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('id'));

            user = [
                SELECT Id
                FROM User
                WHERE Id = :UserInfo.getUserId()
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            // To reset the language
            String strLanguage = ESAPI.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('lang'));

            if (!String.isNotBlank(strLanguage))
                FCGlobal.setUserLanguage(userInfo.getUserId(), 'en_US');

            Integer countRLC = [
                SELECT COUNT()
                FROM Related_List_Controller__c
                WHERE Quiz__c = :quizID
                AND IsCommunityRecord__c = TRUE
                AND Language__c != 'en_US'
                AND Language__c != ''
                WITH SECURITY_ENFORCED
            ];

            if (countRLC > 0)
                isClonedApp = true;

            userSession = FCGlobal.getUserSession(UserInfo.getUserId());
            portalLanguage = userSession.UserLanguage;
            if (portalLanguage == 'en' || String.isBlank(portalLanguage))
                portalLanguage = 'en_US';

            Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe();
            Schema.SObjectType sObjectType = sObjectMap.get('Account');
            Schema.DescribeSObjectResult resSchema = sObjectType.getDescribe();
            List<Schema.ChildRelationship> childObjects = resSchema.getChildRelationships();
            LstSlctAccntChldObjcts = new List < SelectOption >();
            LstSlctAccntChldObjcts.add(new SelectOption('-- Select Object --', '-- Select Object --' ));

            for (Schema.ChildRelationship childrelationship: childObjects)
            {
                Schema.DescribeSObjectResult childResSchema = childrelationship.getChildSObject().getDescribe();
                if(childResSchema.isCustom() && !childResSchema.getLocalName().endsWith('Question_Attachment__c'))
                    LstSlctAccntChldObjcts.add(new SelectOption(childResSchema.getName(), childResSchema.getLabel()));
            }

            if( LstSlctAccntChldObjcts.size() > 1 )
            {

                List<Related_List_Controller__c> LstProfileTabs = [
                    SELECT
                        FieldHeaders__c,
                        FieldNames__c,
                        Hide_Edit_Link__c,
                        LookupField__c,
                        Name,
                        ObjectName__c,
                        ShowDeleteLink__c,
                        ShowNewButton__c,
                        Show_Tab_to_Individual_Users__c,
                        Show_Tab_to_Organization_Users__c,
                        SortFieldOrder__c,
                        SortField__c
                    FROM Related_List_Controller__c
                    WHERE ParentObject__c = 'Account'
                    AND Associated_Tab_Type__c = 'Profile'
                    AND ObjectName__c != null
                    AND Associated_FC_Portal_Type__c = 'Grantee'
                    AND Language__c = :portalLanguage
                    WITH SECURITY_ENFORCED
                    LIMIT 1000
                ];

                MapObjNRlcRecords = new Map<String, List<FGM_Portal__Related_List_Controller__c>>();
                List<FGM_Portal__Related_List_Controller__c> lstRlcRecords;
                for( FGM_Portal__Related_List_Controller__c rlcRecord : LstProfileTabs )
                {
                    if( MapObjNRlcRecords.get(rlcRecord.FGM_Portal__ObjectName__c) != null && MapObjNRlcRecords.get(rlcRecord.FGM_Portal__ObjectName__c) != null && !MapObjNRlcRecords.get(rlcRecord.FGM_Portal__ObjectName__c).isEmpty() )
                        lstRlcRecords = MapObjNRlcRecords.get(rlcRecord.FGM_Portal__ObjectName__c);
                    else
                        lstRlcRecords = new List<FGM_Portal__Related_List_Controller__c>();
                    lstRlcRecords.add(rlcRecord);
                    MapObjNRlcRecords.put(rlcRecord.FGM_Portal__ObjectName__c, lstRlcRecords);
                }
            }
        }
        catch( Exception ex )
        {
            system.debug( 'Exception: ' + ex + ' @Line :: ' + ex.getLineNumber() + ' Message ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Exception: ' + ex.getMessage()));
        }
    }
    public String getSubTitle() {
        return isApplicationdesigner ? 'Application Designer' : 'Page Layout Designer';
    }
    public String getParam(String name) {
            String queryParameter = ApexPages.currentPage().getParameters().get(name);
            if (String.isNotBlank(queryParameter)) {
                return String.escapeSingleQuotes(ESAPI.SFDC_HTMLENCODE(queryParameter));
            }
            return '';
        }
        /// Get All Portal Languages
    private void initializePortalLanguages() {
            if (lstLanguageOptions == null || lstLanguageOptions.isEmpty()) {
                lstLanguageOptions = new List < SelectOption > ();
                lstLanguageOptions = FCGlobal.getPortalLanguage();
            }
        }

    @RemoteAction
    public static Boolean quizIsTranslatedInLanguage(Id quizToTranslateId, String language) {
        List<Related_List_Controller__c> translatedRLCs = [
            SELECT Parent_RLCTabID__c
            FROM Related_List_Controller__c
            WHERE Quiz__c = :quizToTranslateId
            AND IsCommunityRecord__c = TRUE
            AND Language__c = :language
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

        return !translatedRLCs.isEmpty();
    }

    //set portal language
    public PageReference setPortalLanguage() {
        Set < ID > setRLCTabID = new Set < ID > ();
        FCGlobal.setUserLanguage(userInfo.getUserId(), portalLanguage);
        tabListEng = getTabRecords('en_US');
        if (portalLanguage != 'en_US' && tabListEng != null && tabListEng.size() > 0) {

            List<Related_List_Controller__c> tabListNonEng = [
                SELECT Parent_RLCTabID__c
                FROM Related_List_Controller__c
                WHERE Quiz__c = :quizID
                AND IsCommunityRecord__c = TRUE
                AND Language__c = :portalLanguage
                WITH SECURITY_ENFORCED
                LIMIT 1000
            ];

            Boolean isCloned;
            map < Id, FGM_Portal__Related_List_Controller__c > mapEmptyTabID = new map < Id, FGM_Portal__Related_List_Controller__c > ();
            List < FGM_Portal__Related_List_Controller__c > lstEmptyTabID = new List < FGM_Portal__Related_List_Controller__c > ();
            for (FGM_Portal__Related_List_Controller__c recordEng: tabListEng) {
                isCloned = false;
                for (FGM_Portal__Related_List_Controller__c recordNonEng: tabListNonEng) {
                    if (recordEng.Id == recordNonEng.FGM_Portal__Parent_RLCTabID__c) isCloned = true;
                }
                if (!isCloned) {
                    setRLCTabID.add(recordEng.Id);
                    mapEmptyTabID.put(recordEng.Id, recordEng);
                }
            }
            if (setRLCTabID != null && setRLCTabID.size() > 0) {

                quizQuestionListEng = [
                    SELECT
                        Field__c,
                        Hide_Post_Text__c,
                        Hide_Pre_Text__c,
                        Hide_question_from_Reviewers__c,
                        Name,
                        Parent_QuizQuestionID__c,
                        Question__c,
                        Quiz__c,
                        Required__c,
                        Sort_Order__c,
                        Tab__c
                    FROM Quiz_Questions__c
                    WHERE Tab__c IN :setRLCTabID
                    WITH SECURITY_ENFORCED
                    LIMIT 1000
                ];

                if (quizQuestionListEng != null && quizQuestionListEng.size() > 0) {
                    FCGlobal.CloneQuizQuestion(quizQuestionListEng, quizID, portalLanguage, true);
                    for (FGM_Portal__Quiz_Questions__c quizQuestion: quizQuestionListEng)
                        mapEmptyTabID.remove(quizQuestion.FGM_Portal__Tab__c);
                }
                lstEmptyTabID = mapEmptyTabID.values();
                if (lstEmptyTabID != null && lstEmptyTabID.size() > 0) FCGlobal.CloneTabRecord(lstEmptyTabID, quizID, portalLanguage);
            }
        }
        PageReference currentPage = ApexPages.currentPage();
        currentPage.getParameters().put('id', quizID);
        currentPage.getParameters().put('lang', portalLanguage);
        currentPage.setRedirect(true);
        return currentPage;
    }
    public PageReference redirectTo(PageReference pageReference) {
        if (pageReference != null) pageReference.setRedirect(true);
        return pageReference;
    }
    public PageReference rollbackWithError(String message, System.Savepoint savepoint) {
        if (savepoint != null) Database.rollback(savepoint);
        if (message != null) ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, message));
        return null;
    }
    public PageReference initialize()
    {
        initialized = true;
        try
        {
            initializePortalLanguages();
            isIFrameTab = false;
            isGranteeBudgetTab = false;
            isBudgetError = false;
            portalRLC = new FGM_Portal__Related_List_Controller__c();
            selectedTab = getParam('selectedTab');
            strSelectedObject = '';
            isCloneQuiz = false;
            object currentpage = Apexpages.currentPage();
            String strPageUrl = String.valueOf((currentpage != null ? currentpage : ''));
            // decide whether the method is called from Quiz Designer for Page Layout
            if (strPageUrl.toLowerCase().contains('fgm_portal__quizdesignform'))
                isApplicationdesigner = true;
            else
                isApplicationdesigner = false;
            relatedListTabList = new List < FGM_Portal__Related_List_Controller__c > ();
            portalTabsList = new List < FGM_Portal__Related_List_Controller__c > ();
            initializeQuizOptions();    // to fetch picklist options in List of existing Quizzes
            PageReference redirect = initializeQuiz();
            if ( redirect != null )
                return redirect;
            if ( quiz == null || quiz.Id == null )
                return null;
            if ( !isApplicationdesigner )
                initilizePageLayout();
            initializeTabs();
            initializeQuestionOptions();
            initializeQuizQuestionInsert();
            initializeQuestionInsert();
            findDuplicateQuizQuestionMappings();
        }
        catch( Exception ex )
        {
            system.debug( 'Exception: ' + ex + ' @Line :: ' + ex.getLineNumber() + ' Message ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Exception: ' + ex.getMessage()));
        }
        return null;
    }
        // To get Quiz Questions and Tab Records.
    public void initializeTabs()
    {
        try
        {
            if ( quiz == null && quiz.Id == null )
                return;
            relatedListTabList = new List < FGM_Portal__Related_List_Controller__c > ();
            portalTabsList = new List < FGM_Portal__Related_List_Controller__c > ();
            //CreateDynamic query for RLC for multilanguage
            string strQuizID = quiz.Id;
            Set < String > setRLCLanguageFields = new Set < String > ();
            //Get languageFields
            if (mapLanguageDependentFieldsByObject == null)
                mapLanguageDependentFieldsByObject = new Map < String, Map < String, Map < String, String >>> ();
            isRequestPortalTab = false;
            isBudgetTabExist = false;
            isBudgetError = false;
            isBudgetUpdateTabExist = false;
            IsContactTabPresent = false;
            IsOrgTabPresent = false;
            iNoOfBenchmarkUpdateTab = 0;
            bIsBenchmarkUpdateExist = false;
            tabsList = getTabRecords(portalLanguage);
            if ( tabsList != null && !tabsList.isEmpty() )
            {
                FilterTabs();
                if ( String.isBlank(selectedTab) )
                {
                    if (portalTabsList != null && portalTabsList.size() > 0)
                        selectedTab = String.valueOf(portalTabsList[0].Id);
                    else if (relatedListTabList != null && relatedListTabList.size() > 0){
                        selectedTab = String.valueOf(relatedListTabList[0].Id);
                    }
                }
            }
            initializeQuizQuestionList();
        }
        catch( Exception ex )
        {
            system.debug( 'Exception: ' + ex + ' @Line :: ' + ex.getLineNumber() + ' Message ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Exception: ' + ex.getMessage()));
        }
    }
    private List < FGM_Portal__Related_List_Controller__c > getTabRecords(String languageCode)
    {
        List < FGM_Portal__Related_List_Controller__c > lstTabs;
        try
        {
            if ( !String.isNotBlank(languageCode) )
                return null;
            mapTabIdWthQQs = new Map< String, List<Quiz_Questions__c> >();
            string strQuizID = quiz.Id;
            string parentObjectForInquiryTab = 'sobject';
            String strQuery = 'SELECT RecordType.Id, RecordType.Name, Quiz__c, ' + String.join(new List < String > (getTabRelatedListFields(null)), ', ') + ', FGM_Portal__of_records_to_display__c, FGM_Portal__Cloned_from__r.Name, FGM_Portal__Cloned_from__r.Id FROM FGM_Portal__Related_List_Controller__c WHERE Quiz__c =: strQuizID AND FGM_Portal__IsCommunityRecord__c = true AND Language__c =: languageCode AND ParentObject__c !=: parentObjectForInquiryTab WITH SECURITY_ENFORCED ORDER BY FGM_Portal__SortOrder__c ASC NULLS LAST LIMIT 1000';
            lstTabs = ( List < Related_List_Controller__c > )Database.query( strQuery );
            Set<String> setTabIds = new Set<String>();
            for( Related_List_Controller__c rlcTab : lstTabs )
                setTabIds.add( rlcTab.Id );
            String strQQQuery = 'SELECT Id, Name, ' + String.join(new List < String > (getQuestionFields(null)), ', ') + ', FGM_Portal__Question__c, FGM_Portal__Quiz__c, FGM_Portal__Sort_Order__c, Field__c, Required__c, Tab__c, Tab__r.ObjectName__c, Tab__r.Name, FGM_Portal__Hide_Pre_Text__c, FGM_Portal__Hide_Post_Text__c, FGM_Portal__Parent_QuizQuestionID__c, FGM_Portal__Can_upload_after_submission__c, FGM_Portal__Hide_question_from_Reviewers__c FROM Quiz_Questions__c WHERE Tab__c IN :setTabIds WITH SECURITY_ENFORCED ORDER BY FGM_Portal__Sort_Order__c ASC NULLS LAST LIMIT 1000';
            List<Quiz_Questions__c> lstQQs = (List<Quiz_Questions__c>)Database.query( strQQQuery );
            for( Related_List_Controller__c rlcTab : lstTabs )
            {
                for( Quiz_Questions__c quizQuestion : lstQQs )
                {
                    if( quizQuestion.Tab__c == rlcTab.Id )
                    {
                        List<Quiz_Questions__c> lstQuizQuestions;
                        if( mapTabIdWthQQs.get( quizQuestion.Tab__c ) != null )
                            lstQuizQuestions = mapTabIdWthQQs.get( quizQuestion.Tab__c );
                        else
                            lstQuizQuestions = new List<Quiz_Questions__c>();
                        lstQuizQuestions.add( quizQuestion );
                        mapTabIdWthQQs.put( quizQuestion.Tab__c, lstQuizQuestions );
                    }
                }
            }
            return lstTabs;
        }
        catch( Exception ex )
        {
            system.debug( 'Exception: ' + ex + ' @Line :: ' + ex.getLineNumber() + ' Message ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Exception: ' + ex.getMessage()));
        }
        return lstTabs;
    }
    private Set < String > getTabRelatedListFields(Set < String > setRequiredFields) {
        Set < String > setRLCObject = new Set < String > ();
        setRLCObject.add('Name');
        setRLCObject.add('FGM_Portal__Associated_FC_Portal_Type__c');
        setRLCObject.add('FGM_Portal__Associated_Tab_Type__c');
        setRLCObject.add('FGM_Portal__ObjectName__c');
        setRLCObject.add('FGM_Portal__ParentObject__c');
        setRLCObject.add('FGM_Portal__LookupField__c');
        setRLCObject.add('FGM_Portal__SortOrder__c');
        setRLCObject.add('FGM_Portal__SortField__c');
        setRLCObject.add('FGM_Portal__ShowNewButton__c');
        setRLCObject.add('FGM_Portal__ShowDeleteLink__c');
        setRLCObject.add('FGM_Portal__RichInstructionalText__c');
        setRLCObject.add('FGM_Portal__Hide_Edit_Link__c');
        setRLCObject.add('FGM_Portal__FieldHeaders__c');
        setRLCObject.add('FGM_Portal__FieldNames__c');
        setRLCObject.add('FGM_Portal__Field_Names_Long__c');
        setRLCObject.add('FGM_Portal__Field_Labels_Long__c');
        setRLCObject.add('FGM_Portal__BaseUrl__c');
        setRLCObject.add('FGM_Portal__SortFieldOrder__c');
        setRLCObject.add('RecordTypeId');
        setRLCObject.add('Language__c');
        return setRLCObject;
    }
    private Set < String > getQuestionFields(Set < String > setRequiredFields) {
            Set < String > setRLCObject = new Set < String > ();
            setRLCObject.add('FGM_Portal__Question__r.FGM_Portal__RichQuestion__c');
            setRLCObject.add('FGM_Portal__Question__r.FGM_Portal__RichPreText__c');
            setRLCObject.add('FGM_Portal__Question__r.AttachmentNameFormula__c');
            setRLCObject.add('FGM_Portal__Question__r.FGM_Portal__RichPostText__c');
            setRLCObject.add('FGM_Portal__Question__r.FGM_Portal__Type__c');
            setRLCObject.add('FGM_Portal__Question__r.Quiz__c');
            //Add Required Fields
            if (setRequiredFields != null && !setRequiredFields.isEmpty()) {
                for (String strFields: setRequiredFields) {
                    String relationField = 'FGM_Portal__Question__r.' + strFields;
                    if (!setRLCObject.contains(relationField)) setRLCObject.add(relationField);
                }
            }
            return setRLCObject;
        }
        // To Sort the Tab Records by Record Type.
    public void FilterTabs()
    {
        if (tabsList != null)
        {
            Map < Id, Schema.RecordTypeInfo > recordTypeInfo = Schema.Sobjecttype.FGM_Portal__Related_List_Controller__c.getRecordTypeInfosById();
            if (!recordTypeInfo.isEmpty())
            {
                for (FGM_Portal__Related_List_Controller__c relatedListRecord: tabsList)
                {
                    Schema.RecordTypeInfo requiredRecordType = recordTypeInfo.get(relatedListRecord.RecordTypeId);
                    String strRLCRecordTypeName = '';
                    if (requiredRecordType != null)
                    {
                        strRLCRecordTypeName = requiredRecordType.getName(); // Get record Type Name
                        if (String.isNotBlank(strRLCRecordTypeName))
                        {
                            if ('Portal Tab'.equalsIgnoreCase(strRLCRecordTypeName))
                            {
                                if (relatedListRecord.FGM_Portal__ParentObject__c != null)
                                {
                                    String strSelectedObject = relatedListRecord.FGM_Portal__ParentObject__c;
                                    if ('Opportunity'.equalsIgnoreCase(relatedListRecord.FGM_Portal__ParentObject__c))
                                        isRequestPortalTab = true;
                                    system.debug('isRequestPortalTab'+isRequestPortalTab);
                                    hasChildObject = FCGlobal.hasChildObject(strSelectedObject);
                                    system.debug('hasChildObject---'+hasChildObject);
                                }
                                if (portalTabsList == null) portalTabsList = new List < FGM_Portal__Related_List_Controller__c > ();
                                    portalTabsList.add(relatedListRecord);
                            }
                            else if ('Related List with Tab'.equalsIgnoreCase(strRLCRecordTypeName))
                            {
                                if (relatedListTabList == null) relatedListTabList = new List < FGM_Portal__Related_List_Controller__c > ();
                                    relatedListTabList.add(relatedListRecord);
                                if( String.isNotBlank(relatedListRecord.FGM_Portal__ParentObject__c) && 'FGM_Base__Grantee_Report__c'.equalsIgnoreCase(relatedListRecord.FGM_Portal__ParentObject__c) && String.isNotBlank(relatedListRecord.FGM_Portal__ObjectName__c) && 'FGM_Base__Benchmark_Update__c'.equalsIgnoreCase(relatedListRecord.FGM_Portal__ObjectName__c)){
                                    iNoOfBenchmarkUpdateTab += 1;
                                }else{
                                    bIsBenchmarkUpdateExist= false;
                                }
                            }
                            else if ('Grantee Budget Tab'.equalsIgnoreCase(strRLCRecordTypeName))
                                isBudgetTabExist = true;
                            else if ('Grantee Budget Update Tab'.equalsIgnoreCase(strRLCRecordTypeName))
                                isBudgetUpdateTabExist = true;
                            else if ('Contact Tab'.equalsIgnoreCase(strRLCRecordTypeName))
                                IsContactTabPresent = true;
                            else if ( 'Organization Tab'.equalsIgnoreCase(strRLCRecordTypeName) )
                                IsOrgTabPresent = true;
                        }
                    }
                }
            }
        }
    }
    public void initializeQuizOptions() {
        newQuizName = '';
        quizOptions = new SelectOption[] {};

        for (Quiz__c quiz : [
            SELECT Name
            FROM Quiz__c
            WHERE RecordTypeId = :FCGlobal.getRecordTypeId('FGM_Portal__Quiz__c', 'Application')
            AND IsCommunityRecord__c = TRUE
            WITH SECURITY_ENFORCED
            ORDER BY Name ASC
            LIMIT 1000
        ]) {
            quizOptions.add(new SelectOption(quiz.Id, quiz.Name));
        }

    }
    public PageReference initializeQuiz()
    {

        List<Quiz__c> quizList = [
            SELECT
                Name,
                Is_Active__c,
                Introduction_Text__c,
                toLabel(RecordType.Name)
            FROM Quiz__c
            WHERE Id = :controller.getId()
            AND IsCommunityRecord__c = TRUE
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

        if (quizList.isEmpty())
            quiz = new FGM_Portal__Quiz__c();
        else
        {
            quiz = quizList[0];
            String QuizRecordTypeName = FCGLobal.getRecordTypeName(String.valueOf(FGM_Portal__Quiz__c.getsObjectType()), quizList[0].RecordTypeId);
            if (String.isNotBlank(QuizRecordTypeName) && 'Quiz'.equalsIgnoreCase(QuizRecordTypeName))
            {
                PageReference pageReference = System.Page.QuizDesigner;     // if record type is Quiz it should redirect to QuizDesigner (Eligibility Quiz)
                pageReference.getParameters().put('id', quizList[0].id);
                pageReference.setRedirect(true);
                return pageReference;
            }
            isApplicationdesigner = 'Application'.equalsIgnoreCase(quizList[0].RecordType.Name);
        }
        return null;
    }
    public void initializeQuizQuestionList()
    {
        try
        {
            isGranteeBudgetTab = false;
            bIsBenchmarkUpdateTab = false;
            isGranteeBudgetUpdateTab = false;
            isIFrameTab = false;
            BIsCstmPrflTbActv = false;
            IsContactTabActive = false;
            IsOrgTabActive = false;
            String strSelectedTabId = getParam('tabId');
            quizQuestionList = null;
            if (String.isNotBlank(strSelectedTabId))
                selectedTab = strSelectedTabId;
            showTabBelongToExternalReviewForShowApplication = false;
            if ( tabsList != null && tabsList.size() > 0 && String.isNotBlank(selectedTab) )
            {
                quizQuestionList = null;
                for (FGM_Portal__Related_List_Controller__c tabRecord: tabsList)
                {
                    if( selectedTab == String.valueOf(tabRecord.Id) )
                    {
                        if (tabRecord.FGM_Portal__ParentObject__c.equalsIgnoreCase('sObject') || tabRecord.FGM_Portal__LookupField__c.equalsIgnoreCase('sObject'))
                            showTabBelongToExternalReviewForShowApplication = true;
                        Map < Id, Schema.RecordTypeInfo > recordTypeInfo = Schema.Sobjecttype.FGM_Portal__Related_List_Controller__c.getRecordTypeInfosById();
                        if (!recordTypeInfo.isEmpty())
                        {
                            Schema.RecordTypeInfo requiredRecordType = recordTypeInfo.get(tabRecord.RecordTypeId);
                            if (requiredRecordType != null)
                            {
                                if ('IFrame Tab'.equalsIgnoreCase(requiredRecordType.getName()))
                                    isIFrameTab = true;
                                else if ('Grantee Budget Tab'.equalsIgnoreCase(requiredRecordType.getName()))
                                    isGranteeBudgetTab = true;
                                else if ('Grantee Budget Update Tab'.equalsIgnoreCase(requiredRecordType.getName()))
                                    isGranteeBudgetUpdateTab = true;
                                else if( 'Custom Profile Tab'.equalsIgnoreCase(requiredRecordType.getName()) )
                                    BIsCstmPrflTbActv = true;
                                else if ('Contact Tab'.equalsIgnoreCase(requiredRecordType.getName()))
                                    IsContactTabActive = true;
                                else if( 'Organization Tab'.equalsIgnoreCase(requiredRecordType.getName()) )
                                    IsOrgTabActive = true;
                                else if( 'Related List With Tab'.equalsIgnoreCase(requiredRecordType.getName()) && 'FGM_Base__Grantee_Report__c'.equalsIgnoreCase(tabRecord.FGM_Portal__ParentObject__c) && 'FGM_Base__Benchmark_Update__c'.equalsIgnoreCase(tabRecord.FGM_Portal__ObjectName__c))
                                    bIsBenchmarkUpdateTab = true;
                            }
                        }
                        if( mapTabIdWthQQs != null && mapTabIdWthQQs.get( tabRecord.Id ) != null )
                        {
                            if( quizQuestionList == null )
                                quizQuestionList = new List<Quiz_Questions__c>();
                            quizQuestionList = mapTabIdWthQQs.get( tabRecord.Id );
                        }
                    }
                }
            }
            if (!showTabBelongToExternalReviewForShowApplication && !isIFrameTab && !isGranteeBudgetTab)
                initializeFieldOptions();
            if(!IsWarningForDependentPicklistShown && string.isNotBlank(selectedTab) && quiz != null && quiz.id != null)
            {
                for( Integer iCount = 0; iCount < tabsList.size(); iCount++ )
                {
                    if( tabsList[iCount].id == selectedTab && ( tabsList[iCount].RecordType.Name.equalsIgnoreCase('Portal Tab') || tabsList[iCount].RecordType.Name.equalsIgnoreCase('Related List With Tab')) )
                    {
                        checkDependentPicklist();
                        break;
                    }
                }
            }
        }
        catch( Exception ex )
        {
            system.debug( 'Exception: ' + ex + ' @Line :: ' + ex.getLineNumber() + ' Message ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Exception: ' + ex.getMessage()));
        }
    }
    public void initializeQuestionOptions() {
        questionOptions = new SelectOption[] {};
        Set < String > setQuestionType = new Set < String > {
            'Instruction',
            'Attachment',
            'Salesforce Data Type'
        };

        for (Questions__c question : [
            SELECT
                Name,
                RichQuestion__c
            FROM Questions__c
            WHERE Type__c IN :setQuestionType
            AND Is_Active__c = TRUE
            AND Language__c = :portalLanguage
            WITH SECURITY_ENFORCED
            ORDER BY Name ASC
            LIMIT 1000
        ]) {
            questionOptions.add(new SelectOption(question.Id, question.Name + ': ' + question.RichQuestion__c));
        }
    }
    public void initializeQuizQuestionInsert() {
        quizQuestionInsert = new FGM_Portal__Quiz_Questions__c();
        quizQuestionInsert.FGM_Portal__Quiz__c = quiz.Id;
    }
    public void initializeQuestionInsert() {
        questionInsert = new FGM_Portal__Questions__c();
    }
    public void initializeFieldOptions() {
        fieldOptions = new SelectOption[] {};
        tabObject = '';
        if (tabsList != null && String.isNotBlank(selectedTab)) {
            for (FGM_Portal__Related_List_Controller__c tabRecord: tabsList) {
                if (selectedTab == String.valueOf(tabRecord.Id)) {
                    tabObject = tabRecord.FGM_Portal__ObjectName__c;
                }
            }
        }
        if (String.isNotBlank(tabObject)) {
            fieldType = new Map < String, String > ();
            Map < String, Schema.SObjectField > FieldMapping = FCGlobal.getMapsObjectFields(tabObject);
            if (FieldMapping != null && !FieldMapping.values().isEmpty()) {

                if(tabObject.equalsIgnoreCase('OpportunityTeamMember'))
                {
                    fieldOptions.add(new SelectOption('FGM_Portal__Additional_Roles__c', 'Additional Roles'));
                    fieldType.put('FGM_Portal__Additional_Roles__c', 'PICKLIST');
                }

                for (Schema.SObjectField field: FieldMapping.values())
                {
                    Schema.DescribeFieldResult fieldResult = field.getDescribe();
                    if (fieldResult.isAccessible() && fieldResult.getType() != Schema.DisplayType.ID && fieldResult.getName().toLowerCase() != 'address')
                    {
                        fieldOptions.add(new SelectOption(fieldResult.getName(), fieldResult.getLabel()));
                    }

                    if (fieldResult.isCalculated())
                    {
                        fieldType.put(fieldResult.getName(), 'FORMULA');
                    }
                    else
                    {
                        fieldType.put(fieldResult.getName(), String.valueOf(fieldResult.getType()));
                    }
                }
            }
        }
    }
    public PageReference selectQuiz() {
        if (selectedQuizId == null) return rollbackWithError('No quiz/form selected', null);
        PageReference pageReference = System.Page.QuizDesignForm;
        pageReference.getParameters().put('id', selectedQuizId);
        pageReference.setRedirect(true);
        return pageReference;
    }
    public PageReference insertQuiz() {
        if (!String.isBlank(quiz.Name)) {
            System.Savepoint savepoint = Database.setSavepoint();
            try {
                quiz.RecordTypeId = FCGlobal.getRecordTypeId('FGM_Portal__Quiz__c', 'Application');
                quiz.FGM_Portal__IsCommunityRecord__c = true;
                CrudFlsService.getInstance().assertCreateable(quiz);
                insert quiz;
            } catch (System.Exception problem) {
                return rollbackWithError(problem.getTypeName() + ': ' + problem.getMessage(), savepoint);
            }
            PageReference pageReference = System.Page.QuizDesignForm;
            pageReference.getParameters().put('id', quiz.Id);
            pageReference.setRedirect(true);
            return pageReference;
        } else return rollbackWithError('Form name is mandatory', null);
    }
    public PageReference insertQuizWithClone() {
        System.Savepoint savepoint = Database.setSavepoint();
        if (!String.isNotBlank(selectedQuizId)) return rollbackWithError('No quiz/form selected', null);
        if (!String.isNotBlank(newQuizName)) return rollbackWithError('Enter Quiz Name', null);
        try {
            quiz = FCGlobal.cloneQuiz(String.escapeSingleQuotes(selectedQuizId), newQuizName);
        } catch (System.Exception problem) {
            return rollbackWithError(problem.getTypeName() + ': ' + problem.getMessage(), savepoint);
        }
        if (quiz != null) {
            PageReference pageReference = System.Page.QuizDesignForm;
            pageReference.getParameters().put('id', quiz.Id);
            pageReference.setRedirect(true);
            return pageReference;
        }
        return null;
    }
    public void openCloneQuizPopUp() {
        isCloneQuizPopUpVisible = true;
        newQuizName = '';
    }
    public void closeCloneQuizPopUp() {
        isCloneQuizPopUpVisible = false;
        newQuizName = '';
    }
    public PageReference insertQuizQuestion() {
            System.Savepoint savepoint = Database.setSavepoint();
            try {
                quizQuestionInsert.FGM_Portal__Quiz__c = quiz.Id;
                quizQuestionInsert.Tab__c = selectedTab;
                quizQuestionInsert.FGM_Portal__Sort_Order__c = quizQuestionList == null ? 1 : quizQuestionList.size() + 1;
                CrudFlsService.getInstance().assertCreateable(quizQuestionInsert);
                insert quizQuestionInsert;
            } catch (System.Exception problem) {
                return rollbackWithError(problem.getTypeName() + ': ' + problem.getMessage(), savepoint);
            }
            initializeTabs();
            initializeQuizQuestionList();
            initializeQuizQuestionInsert();
            initializeQuestionInsert();
            return null;
        }
        // Show Other Language Configuration PopUp
    public void getOtherLanguageConfig() {
            isOtherLanguageConfig = true;
            isShowExternalRelatedObject = false;
            String ObjectName = String.valueOf(FGM_Portal__Related_List_Controller__c.getsObjectType());
            if (mapLanguageDependentFieldsByObject == null) mapLanguageDependentFieldsByObject = new Map < String, Map < String, Map < String, String >>> ();
            if (!mapLanguageDependentFieldsByObject.containsKey(ObjectName)) mapLanguageDependentFieldsByObject.put(ObjectName, FCGlobal.getLanguageFields(ObjectName, new Set < String > {
                'Name',
                'FGM_Portal__RichInstructionalText__c',
                'FGM_Portal__FieldHeaders__c'
            }));
            selectedLanguage = '';
            initializeLanguages();
        }
        // Get All Organization Languages
    private void initializeLanguages() {
        if (lstLanguageOptions == null || lstLanguageOptions.isEmpty()) {
            lstLanguageOptions = new List < SelectOption > ();
            lstLanguageOptions = FCGlobal.getOrgLanguages();
        }
    }
    public PageReference insertQuestion()
    {
        findDuplicateQuizQuestionMappings();
        System.Savepoint savepoint = Database.setSavepoint();
        if (questionInsert == null)
            return null;
        if (questionInsert.RichQuestion__c == null)
            return null;
        if (questionInsert.RichQuestion__c == '')
            return rollbackWithError('Question: Validation Error: Value is required', savepoint);
        Related_List_Controller__c selectedTabRLT = getTabRecordById(selectedTab);
        if (selectedTabRLT != null && selectedTabRLT.RecordTypeId != null)
        {

            List<RecordType> lstRecordTypes = [
                SELECT Name
                FROM RecordType
                WHERE Id = :selectedTabRLT.RecordTypeId
                AND SobjectType = 'Related_List_Controller__c'
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            if( !lstRecordTypes.isEmpty() && lstRecordTypes[0].Name.toLowerCase() == ('Related List With Tab'.toLowerCase()))
            {
                if (questionInsert.Type__c == 'Attachment')
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Attachment can not be used for Related Lists.'));
                    return null;
                }
            }
        }
        try
        {
            if (questionInsert.Type__c == 'Salesforce Data Type' && quizQuestionInsert.Field__c == null)
                return rollbackWithError(System.Label.FC_CommunityManager_FieldNameRequired, savepoint);
            questionInsert.Quiz__c = quiz.Id;
            questionInsert.Is_Active__c = true;
            CrudFlsService.getInstance().assertCreateable(questionInsert);
            insert questionInsert;

            quizQuestionInsert.Tab__c = selectedTab;
            quizQuestionInsert.Question__c = questionInsert.Id;
            quizQuestionInsert.Quiz__c = quiz.Id;
            quizQuestionInsert.Sort_Order__c = quizQuestionList == null ? 1 : quizQuestionList.size() + 1;

            Set<Id> setRLCIds = new Set<Id>();
            Set<String> setFields = new Set<String>();

            for (Related_List_Controller__c rlcTab : [
                SELECT RecordType.Name
                FROM Related_List_Controller__c
                WHERE Quiz__c = :quizID
                AND Language__c = :portalLanguage
                AND (
                    RecordType.Name = 'Portal Tab'
                    OR RecordType.Name = 'Related List With Tab'
                )
                AND Id != :selectedTab
                WITH SECURITY_ENFORCED
                LIMIT 1000
            ]) {
                setRLCIds.add( rlcTab.Id );
                if( mapRLCTabWithObjectName.get( rlcTab.Id ) != null && mapObjectNameSetFields.get( mapRLCTabWithObjectName.get( rlcTab.Id ) ) != null )
                    setFields.addAll( mapObjectNameSetFields.get( mapRLCTabWithObjectName.get( rlcTab.Id ) ) );
            }

            Map<String, Integer> mapFieldNameCount = new Map<String, Integer>();

            for (Quiz_Questions__c quizQuestion : [
                SELECT
                    Tab__r.ObjectName__c,
                    Field__c,
                    Tab__r.Name
                FROM Quiz_Questions__c
                WHERE Tab__c IN :setRLCIds
                AND Field__c IN :setFields
                AND Tab__r.ObjectName__c = :mapRLCTabWithObjectName.get(selectedTab)
                AND Field__c != null
                WITH SECURITY_ENFORCED
                LIMIT 1000
            ]) {
                Integer iCount = 0;
                if( mapFieldNameCount.get( quizQuestion.Field__c) != null )
                    iCount = mapFieldNameCount.get( quizQuestion.Field__c);
                iCount++;
                mapFieldNameCount.put( quizQuestion.Field__c, iCount );
            }

            // this check is for cross tab duplication
            if( mapFieldNameCount.get( quizQuestionInsert.Field__c ) > 1 )
                return rollbackWithError('You are attempting to map "' + getLabelFromAPIName( quizQuestionInsert.Field__c, mapRLCTabWithObjectName.get( selectedTab ), false) + '" field of "'+ getLabelFromAPIName( null, mapRLCTabWithObjectName.get( selectedTab ), true)  + '" object more than once.', savepoint);

            if( mapRLCTabWithObjectName.get( selectedTab ) != null )
            {
                if( mapObjectNameSetFields.get( mapRLCTabWithObjectName.get( selectedTab ) ) != null )
                {
                    setFields = mapObjectNameSetFields.get( mapRLCTabWithObjectName.get( selectedTab ) );
                    // this check is for same tab duplication
                    if( setFields.contains( quizQuestionInsert.Field__c ) )
                    {
                        questionInsert.Id = null;
                        String fieldName = quizQuestionInsert.Field__c;
                        quizQuestionInsert = new Quiz_Questions__c();
                        return rollbackWithError('You are attempting to map "' + getLabelFromAPIName( fieldName, mapRLCTabWithObjectName.get( selectedTab ), false) + '" field of "'+ getLabelFromAPIName( null, mapRLCTabWithObjectName.get( selectedTab ), true)  + '" object more than once.', savepoint);
                    }
                }
            }
           if ('Salesforce Data Type'.equalsIgnoreCase(questionInsert.Type__c) && quizQuestionInsert.Field__c != null)
           {
            Boolean isErrorMessage = checkDependentPicklist();
               if(isErrorMessage)
               {
                    isErrorMessage=false;
                    return rollbackWithError(ErrorMessage, savepoint);
               }
           }
           CrudFlsService.getInstance().assertCreateable(quizQuestionInsert);
            insert quizQuestionInsert;
            //Clone Quiz Question and Question
            Set<String> setLanguage = new Set<String>();

            List<Related_List_Controller__c> lstRLCTab = [
                SELECT Language__c
                FROM Related_List_Controller__c
                WHERE IsCommunityRecord__c = TRUE
                AND Language__c != 'en_US'
                AND Language__c != null
                AND Parent_RLCTabID__c = :selectedTab
                WITH SECURITY_ENFORCED
                LIMIT 1000
            ];

            if (lstRLCTab != null)
            {
                for (Integer i = 0; i < lstRLCTab.size(); i++)
                {
                    Questions__c clonedQuestions = questionInsert.clone(false, true, false, false);
                    clonedQuestions.Quiz__c = quiz.Id;
                    clonedQuestions.Parent_QuestionID__c = questionInsert.Id;
                    if( String.isNotBlank( lstRLCTab[i].Language__c ))
                        clonedQuestions.Language__c = lstRLCTab[i].Language__c;
                    CrudFlsService.getInstance().assertCreateable(clonedQuestions);
                    insert clonedQuestions;

                    Quiz_Questions__c clonedQuizQuestion = quizQuestionInsert.clone(false, true, false, false);
                    clonedQuizQuestion.Parent_QuizQuestionID__c = quizQuestionInsert.Id;
                    clonedQuizQuestion.Quiz__c = quiz.Id;
                    clonedQuizQuestion.Tab__c = lstRLCTab[i].Id;
                    clonedQuizQuestion.Question__c = clonedQuestions.Id;
                    if (String.isNotBlank(lstRLCTab[i].Language__c)) clonedQuizQuestion.Language__c = lstRLCTab[i].Language__c;
                    CrudFlsService.getInstance().assertCreateable(clonedQuizQuestion);
                    insert clonedQuizQuestion;
                }
            }
        } catch (System.Exception problem) {
            system.debug( 'Exception: ' + problem + ' @Line :: ' + problem.getLineNumber() + ' Message ' + problem.getStackTraceString());
            return rollbackWithError(problem.getTypeName() + ': ' + problem.getMessage(), savepoint);
        }
        initializeTabs();
        findDuplicateQuizQuestionMappings();
        initializeQuizQuestionList();
        initializeQuestionOptions();
        initializeQuizQuestionInsert();
        initializeQuestionInsert();
        return null;
    }
    private Boolean deleteControllingFieldWithoutDependent(FGM_Portal__Quiz_Questions__c quizQuestion)
    {

        Quiz_Questions__c deletedQuizQuestion = [
            SELECT
                Name,
                Field__c
            FROM Quiz_Questions__c
            WHERE Id = :quizQuestion.Id
            WITH SECURITY_ENFORCED
        ];

        Set<String> setFields =  mapObjectNameSetFields.get( mapRLCTabWithObjectName.get( selectedTab ) );
        Schema.SObjectType currentSObject = Schema.getGlobalDescribe().get(mapRLCTabWithObjectName.get( selectedTab ));
        Map<String, Schema.SObjectField> mapFieldAPIs = currentSObject.getDescribe().fields.getMap();
        Schema.DescribeFieldResult describeFieldResult;
        if(setFields != null && !setFields.isEmpty())
        {
            for(String field: setFields)
            {
                    describeFieldResult=mapFieldAPIs.get(field.tolowercase()).getDescribe();
                    if(describeFieldResult.isDependentPicklist())
                    {
                        Schema.sObjectField controllingPicklistField=describeFieldResult.getController();
                        if(deletedQuizQuestion.Field__c==controllingPicklistField.getDescribe().getName())
                        {
                            ErrorMessage='You are attempting to delete a controlling field "'+controllingPicklistField.getDescribe().getLabel()+'" field of "'+ getLabelFromAPIName( null, mapRLCTabWithObjectName.get( selectedTab ), true)  + '" without it\'s dependent picklist "' + describeFieldResult.getLabel() + '", make sure to delete the depenent picklist first.';
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ErrorMessage));
                            return true;
                        }

                    }
            }
        }
        return false;
    }


    private Boolean checkDependentPicklist()
    {
        Set<String> setFields;
        if( String.isNotBlank(selectedTab) && mapObjectNameSetFields != null && mapRLCTabWithObjectName != null )
        {
            setFields =  mapObjectNameSetFields.get( mapRLCTabWithObjectName.get( selectedTab ) );

            Schema.SObjectType currentSObject = Schema.getGlobalDescribe().get(mapRLCTabWithObjectName.get( selectedTab ));
            Map<String, Schema.SObjectField> mapFieldAPIs = currentSObject.getDescribe().fields.getMap();
            Schema.DescribeFieldResult describeFieldResult;
            Set<String> setFieldsInASingleTab = new Set<String>();
            if( quizQuestionList != null )
            {
                for(FGM_Portal__Quiz_Questions__c quizQuestion : quizQuestionList)
                    setFieldsInASingleTab.add(quizQuestion.Field__c);
            }

            if(mapFieldAPIs!=null)
            {
                if(!IsWarningForDependentPicklistShown)
                {
                        try
                        {
                            IsWarningForDependentPicklistShown= true;
                            if(setFields != null && !setFields.isEmpty())
                            {
                                for(String field: setFields)
                                {
                                    if(!field.equalsIgnoreCase('FGM_Portal__Additional_Roles__c'))
                                    {
                                        describeFieldResult=mapFieldAPIs.get(field.tolowercase()).getDescribe();
                                        if(describeFieldResult.isDependentPicklist())
                                        {
                                            Schema.sObjectField controllingPicklistField=describeFieldResult.getController();
                                            if(describeFieldResult.getController()!=null  && !setFields.contains( controllingPicklistField.getDescribe().getName() ))
                                            {
                                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'We found that this Quiz contains a dependent picklist "' + getLabelFromAPIName( field, mapRLCTabWithObjectName.get( selectedTab ), false) + '" without it\'s controlling field "'+controllingPicklistField.getDescribe().getLabel()+'". Please, revisit the mappings.'));
                                            }

                                        }
                                    }
                                }
                            }
                        }
                        catch(System.Exception problem)
                        {system.debug( 'Exception: ' + problem + ' @Line :: ' + problem.getLineNumber() + ' Message ' + problem.getStackTraceString());
                        return null;
                        }
                }
                else
                {
                    if(quizQuestionInsert.Field__c!=null)
                    {
                        if( mapFieldAPIs.containsKey(quizQuestionInsert.Field__c.tolowercase()))
                        {
                            describeFieldResult=mapFieldAPIs.get(quizQuestionInsert.Field__c.tolowercase()).getDescribe();
                            if(describeFieldResult.isDependentPicklist())
                            {
                                Schema.sObjectField controllingPicklistField=describeFieldResult.getController();
                                if(describeFieldResult.getController()!=null && !setFieldsInASingleTab.contains( controllingPicklistField.getDescribe().getName() ))
                                {
                                    ErrorMessage='You are attempting to add a Dependent picklist "' + describeFieldResult.getLabel() + '" field of "'+ getLabelFromAPIName( null, mapRLCTabWithObjectName.get( selectedTab ), true)  + '" without it\'s controlling field "'+controllingPicklistField.getDescribe().getLabel()+'"';
                                    questionInsert.id = null;
                                    return true;
                                }
                            }
                        }
                    }
                    else
                    {
                        for(FGM_Portal__Quiz_Questions__c quizQuestion : quizQuestionList)
                        {
                            if(quizQuestion.Question__r.Type__c == 'Salesforce Data Type' && String.isNotBlank(quizQuestion.Field__c) && !quizQuestion.Field__c.equalsIgnoreCase('FGM_Portal__Additional_Roles__c'))
                            {
                                describeFieldResult=mapFieldAPIs.get(quizQuestion.Field__c.tolowercase()).getDescribe();
                                if(describeFieldResult.isDependentPicklist())
                                {
                                    Schema.sObjectField controllingPicklistField=describeFieldResult.getController();
                                    if(describeFieldResult.getController()!=null && !setFieldsInASingleTab.contains( controllingPicklistField.getDescribe().getName() ))
                                    {
                                        ErrorMessage='You are attempting to add a Dependent picklist "' + describeFieldResult.getLabel() + '" field of "'+ getLabelFromAPIName( null, mapRLCTabWithObjectName.get( selectedTab ), true)  + '" without it\'s controlling field "'+controllingPicklistField.getDescribe().getLabel()+'"';
                                        questionInsert.id = null;
                                        return true;
                                    }
                                }
                            }
                        }
                    }
                }
              }
        }
        return false;
    }

    public PageReference updateClonedQuestion()
    {

        findDuplicateQuizQuestionMappings();
        System.Savepoint spUpdtClndQstns = Database.setSavepoint();
        try
        {
            String quizQuesid = ApexPages.currentPage().getParameters().get('qqId');
            if (quizQuesid != null && quizQuestionList != null)
            {
                Id currentQuesId = null;
                List < FGM_Portal__Quiz_Questions__c > lstUptQuizQues = new List < FGM_Portal__Quiz_Questions__c > ();
                map < Id, FGM_Portal__Quiz_Questions__c > mapUptQuizQues = new map < Id, FGM_Portal__Quiz_Questions__c > ();
                map < Id, FGM_Portal__Questions__c > mapUptQues = new map < Id, FGM_Portal__Questions__c > ();
                for (FGM_Portal__Quiz_Questions__c quizQues: quizQuestionList)
                {
                    mapUptQuizQues.put(quizQues.Id, quizQues);
                    mapUptQues.put(quizQues.Id, quizQues.FGM_Portal__Question__r);
                }
                if (mapUptQuizQues != null && mapUptQuizQues.size() > 0 && mapUptQues != null && mapUptQues.size() > 0)
                {

                    Questions__c currentQuestion = [
                        SELECT
                            Type__c,
                            Parent_QuestionID__c
                        FROM Questions__c
                        WHERE Id = :mapUptQues.get(quizQuesid).Id
                        WITH SECURITY_ENFORCED
                    ];

                    if (currentQuestion.FGM_Portal__Parent_QuestionID__c != null)
                        currentQuesId = currentQuestion.FGM_Portal__Parent_QuestionID__c;
                    else
                        currentQuesId = currentQuestion.Id;

                    List<Questions__c> lstUptQues = [
                        SELECT
                            Type__c,
                            (
                                SELECT Field__c
                                FROM Quiz_Questions__r
                                WHERE Field__c != null
                                LIMIT 1000
                            )
                        FROM Questions__c
                        WHERE Id = :currentQuesId
                        OR Parent_QuestionID__c = :currentQuesId
                        WITH SECURITY_ENFORCED
                    ];

                    Map<String, Integer> mapFieldNameCount = new Map<String, Integer>();
                    for (Questions__c ques: lstUptQues)
                    {
                        for ( Quiz_Questions__c quizQues: ques.Quiz_Questions__r)
                        {
                            Integer iCount = 0;
                            if( mapFieldNameCount.get( quizQues.Field__c) != null )
                                iCount = mapFieldNameCount.get( quizQues.Field__c);
                            iCount++;
                            mapFieldNameCount.put( quizQues.Field__c, iCount );
                            // check for cloned quiz question field mapping
                            if( iCount > 1 )
                                return rollbackWithError('You are attempting to map "' + getLabelFromAPIName( quizQues.Field__c, mapRLCTabWithObjectName.get( selectedTab ), false) + '" field of "'+ getLabelFromAPIName( null, mapRLCTabWithObjectName.get( selectedTab ), true)  + '" object more than once.', spUpdtClndQstns);
                            quizQues.Field__c = mapUptQuizQues.get(quizQuesid).Field__c;
                            lstUptQuizQues.add(quizQues);
                        }
                        ques.Type__c = mapUptQues.get(quizQuesid).Type__c;
                    }
                    CrudFlsService.getInstance().assertUpdateable(lstUptQues);
                    update lstUptQues;
                    CrudFlsService.getInstance().assertUpdateable(lstUptQuizQues);
                    update lstUptQuizQues;
                    findDuplicateQuizQuestionMappings();
                }
            }
            return null;
        }
        catch (System.Exception problem)
        {
            system.debug( 'Exception: ' + problem + ' @Line :: ' + problem.getLineNumber() + ' Message ' + problem.getStackTraceString());
            return rollbackWithError(problem.getTypeName() + ': ' + problem.getMessage(), spUpdtClndQstns);
        }
    }
    public PageReference updateQuizQuestionList()
    {
        findDuplicateQuizQuestionMappings();
        System.Savepoint spUpdtQzQstn = Database.setSavepoint();
        if (quizQuestionList == null || quizQuestionList.isEmpty())
            return null;
        try
        {
            Boolean isErrorMessage = checkDependentPicklist();
            Map<String, Integer> mapFieldNameCount = new Map<String, Integer>();
            Integer iCount;
            Set<String> setFields = new Set<String>();
            for( Quiz_Questions__c quizQuestion : quizQuestionList )
            {
                if( quizQuestion.Field__c != null )
                {
                    iCount = 0;
                    if( mapFieldNameCount.get( quizQuestion.Field__c) != null )
                        iCount = mapFieldNameCount.get( quizQuestion.Field__c);
                    iCount++;
                    mapFieldNameCount.put( quizQuestion.Field__c, iCount );
                    // check for same tab field duplicate mapping
                    if( iCount > 1 )
                        return rollbackWithError('You are attempting to map "' + getLabelFromAPIName( quizQuestion.Field__c, mapRLCTabWithObjectName.get( selectedTab ), false) + '" field of "'+ getLabelFromAPIName( null, mapRLCTabWithObjectName.get( selectedTab ), true)   + '" object more than once.', spUpdtQzQstn);
                }
            }
            Set<Id> setRLCIds = new Set<Id>();
            setFields = new Set<String>();
            for( Related_List_Controller__c rlcTab : tabsList )
            {
                if( rlcTab.Id != selectedTab )
                {
                    setRLCIds.add( rlcTab.Id );
                    if( mapRLCTabWithObjectName.get( rlcTab.Id ) != null && mapObjectNameSetFields.get( mapRLCTabWithObjectName.get( rlcTab.Id )) != null )
                        setFields.addAll(mapObjectNameSetFields.get( mapRLCTabWithObjectName.get( rlcTab.Id )));
                }
            }
            for( List<Quiz_Questions__c> lstQuizQuestions : mapTabIdWthQQs.values() )
            {
                for( Quiz_Questions__c quizQuestion : lstQuizQuestions )
                {
                    if( setRLCIds.contains( quizQuestion.Tab__c ) && setFields.contains( quizQuestion.Field__c ) && mapRLCTabWithObjectName.get( selectedTab ).equalsIgnoreCase( quizQuestion.Tab__r.ObjectName__c )  )
                    {
                        iCount = 0;
                        if( mapFieldNameCount.get( quizQuestion.Field__c) != null )
                            iCount = mapFieldNameCount.get( quizQuestion.Field__c);
                        iCount++;
                        mapFieldNameCount.put( quizQuestion.Field__c, iCount );
                        // check for cross tab duplicate mapping
                        if( iCount > 1 )
                            return rollbackWithError('You are attempting to map "' + getLabelFromAPIName( quizQuestion.Field__c, mapRLCTabWithObjectName.get( selectedTab ), false) + '" field of "'+ getLabelFromAPIName( null, mapRLCTabWithObjectName.get( selectedTab ), true)  + '" object more than once.', spUpdtQzQstn);
                    }
                }
            }
            if(isErrorMessage)
            {
                isErrorMessage=false;
                return rollbackWithError(ErrorMessage, spUpdtQzQstn);
            }
            checkDependentPicklist();
            CrudFlsService.getInstance().assertUpdateable(quizQuestionList);
            update quizQuestionList;
        }
        catch (System.Exception problem)
        {
            system.debug( 'Exception: ' + problem + ' @Line :: ' + problem.getLineNumber() + ' Message ' + problem.getStackTraceString());
            return rollbackWithError(problem.getTypeName() + ': ' + problem.getMessage(), spUpdtQzQstn);
        }
        // Find any questions that are exclusive to this quiz, and update those as well.
        Map < Id, FGM_Portal__Questions__c > questionUpdateMap = new Map < Id, FGM_Portal__Questions__c > ();
        try
        {
            for (FGM_Portal__Quiz_Questions__c quizQuestion: quizQuestionList)
            {
                FGM_Portal__Questions__c question = quizQuestion.FGM_Portal__Question__r;
                if (question == null)
                    continue;
                questionUpdateMap.put(question.Id, question);
                if (quizQuestion.FGM_Portal__Question__r.AttachmentNameFormula__c != null)
                {
                    Map < String, Schema.SObjectField > FieldMapping = FCGlobal.getMapsObjectFields(tabObject);
                    Map < String, Schema.SObjectField > mapFieldName = new Map < String, Schema.SObjectField > ();
                    for (Schema.SObjectField fieldName: FieldMapping.values()) mapFieldName.put(String.valueof(fieldName), fieldName);
                    String[] parts = new List < String > ();
                    Boolean isSeparator = quizQuestion.FGM_Portal__Question__r.AttachmentNameFormula__c.contains('+');
                    parts = quizQuestion.FGM_Portal__Question__r.AttachmentNameFormula__c.split('\\+');
                    String[] Fieldsparts = new List < String > ();
                    for (integer i = 0; i < parts.size(); i++)
                    {
                        String strPart = parts[i].trim();
                        Boolean isFileName = parts[i].contains('FileName');
                        Boolean isField = parts[i].contains('\'');
                        if (isField == false && isFileName == false)
                        {
                            if ((mapFieldName.containsKey(strPart) == false))
                                return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_Invalid_field_API_name + strPart), spUpdtQzQstn);
                            else
                            {
                                if (questionUpdateMap.isEmpty() == false) {
                                    CrudFlsService.getInstance().assertUpdateable(questionUpdateMap.values());
                                    update questionUpdateMap.values();
                                }
                            }
                        }
                        else if ((isField == true && isSeparator == false && (!(strPart.endsWith('\'')) || !(strPart.startsWith('\'')))) || (isFileName == true && isSeparator == false && strPart != 'FileName'))
                        {
                            return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_AttachmentNamingFromula_ErrorMsg), spUpdtQzQstn);
                        }
                        else if ((isField == true && isSeparator == true && (!(strPart.endsWith('\'')) || !(strPart.startsWith('\'')))) || (isFileName == true && isSeparator == true && strPart != 'FileName'))
                        {
                            return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_AttachmentNamingFromula_ErrorMsg), spUpdtQzQstn);
                        }
                    }
                }
                if (quizQuestion.FGM_Portal__Question__r.FGM_Portal__Type__c == 'Salesforce Data Type' && quizQuestion.Field__c == null)
                {
                    return rollbackWithError(System.Label.FC_CommunityManager_FieldNameRequired, spUpdtQzQstn);
                }
            }
            if (questionUpdateMap.isEmpty() == false) {
                CrudFlsService.getInstance().assertUpdateable(questionUpdateMap.values());
                update questionUpdateMap.values();
            }
        }
        catch (DMLException dmlEx)
        {
            if (dmlEx.getMessage().containsIgnoreCase('Attachment can not be used for Related Lists.'))
            {
                ApexPages.getMessages().clear();
                return null;
            }
            return rollbackWithError(dmlEx.getTypeName() + ': ' + dmlEx.getMessage(), spUpdtQzQstn);
        }
        catch (System.Exception problem)
        {
            system.debug( 'Exception: ' + problem + ' @Line :: ' + problem.getLineNumber() + ' Message ' + problem.getStackTraceString());
            return rollbackWithError(problem.getTypeName() + ': ' + problem.getMessage(), spUpdtQzQstn);
        }
        // Reinitialize
        initializeQuizQuestionList();
        initializeQuestionOptions();
        initializeQuizQuestionInsert();
        initializeQuestionInsert();
        findDuplicateQuizQuestionMappings();
        return null;
    }
        // To handle RLC tab Functionality/Fill Child Object picklist.
    public List < SelectOption > getChildObjects() {
            List < SelectOption > lstChildObject = new List < SelectOption > ();
            if (currentRLCRecord != null && currentRLCRecord.currentRelatedListController != null && String.isNotEmpty(currentRLCRecord.currentRelatedListController.FGM_Portal__ParentObject__c)) {
                Map < String, Schema.SObjectType > sObjectMap = Schema.getGlobalDescribe();
                Schema.SObjectType sObjectType = sObjectMap.get(currentRLCRecord.currentRelatedListController.FGM_Portal__ParentObject__c); // getting Sobject Type
                Schema.DescribeSObjectResult resSchema = sObjectType.getDescribe();
                if (resSchema != null) {
                    List < Schema.ChildRelationship > childObjects = resSchema.getChildRelationships();
                    for (Schema.ChildRelationship childrelationship: childObjects) {
                        Schema.DescribeSObjectResult childResSchema = childrelationship.getChildSObject().getDescribe();
                        if ((childResSchema.getLocalName().equalsIgnoreCase('OpportunityTeamMember') || childResSchema.getLocalName().endsWith('__c')) && !childResSchema.getLocalName().endsWith('Question_Attachment__c') && !childResSchema.getLocalName().equalsIgnoreCase('PortalUserRequestTeamMembers__c')) {
                            lstChildObject.add(new SelectOption(childResSchema.getName(), childResSchema.getLabel()));
                            if (mapChildrelationShip == null) {
                                mapChildrelationShip = new Map < String, String > ();
                            }
                            mapChildrelationShip.put(childResSchema.getName(), childrelationship.getField().getDescribe().getName());
                        }
                    }
                }
            }
            return lstChildObject;
        }
        // To handle RLC tab Functionality/Fill Child Object picklist.
    public void getChildObjectFields()
    {
            List < SelectOption > lstChildObjectFields = new List < SelectOption > ();
            ChildObjectFieldsOptions = new List < SelectOption > ();
            if (currentRLCRecord != null && currentRLCRecord.currentRelatedListController != null)
            {
                if (String.isNotBlank(currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c))
                {
                    if(currentRLCRecord.currentRelatedListController.FGM_Portal__ParentObject__c == 'FGM_Base__Grantee_Report__c' && currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c == 'FGM_Base__Benchmark_Update__c' )
                    {
                       if(iNoOfBenchmarkUpdateTab > 0 && currentRLCRecord.currentRelatedListController.Id == null)
                       {
                            currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c.addError('Please select different child object as Benchmark Update tab already exists.');
                            bIsBenchmarkUpdateExist = true;
                            return ;
                       }
                    }
                    else
                    {
                        bIsBenchmarkUpdateExist = false;
                    }

                    Map < String, Schema.SObjectType > sObjectMap = Schema.getGlobalDescribe();
                    Schema.SObjectType sObjectType = sObjectMap.get(currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c); // getting Sobject Type
                    if (sObjectType == null)
                        return;
                    Schema.DescribeSObjectResult resSchema = sObjectType.getDescribe();
                    Map < String, Schema.SObjectField > childObjectFields = resSchema.fields.getMap();
                    if (childObjectFields != null && !childObjectFields.isEmpty())
                    {
                        if (!String.isBlank(resSchema.Name) && resSchema.Name == 'OpportunityTeamMember')
                        {
                            for (Schema.SObjectField sfield: childObjectFields.Values())
                            {
                                schema.describefieldresult dfield = sfield.getDescribe();
                                if (dfield.getType() != Schema.DisplayType.ID && dfield.getName() != 'Name')
                                    lstChildObjectFields.add(new SelectOption(dfield.getName(), dfield.getLabel()));
                                if( MapFieldApiNameToLabel == null )
                                    MapFieldApiNameToLabel = new Map< String, String >();
                                MapFieldApiNameToLabel.put( dfield.getName(), dfield.getLabel() );
                            }
                        }
                        else
                        {
                            for (Schema.SObjectField sfield: childObjectFields.Values())
                            {
                                schema.describefieldresult dfield = sfield.getDescribe();
                                if (dfield.getType() != Schema.DisplayType.ID)
                                {
                                    lstChildObjectFields.add(new SelectOption(dfield.getName(), dfield.getLabel()));
                                    if( MapFieldApiNameToLabel == null )
                                        MapFieldApiNameToLabel = new Map< String, String >();
                                    MapFieldApiNameToLabel.put( dfield.getName(), dfield.getLabel() );
                                }
                            }
                            if( !String.isBlank(resSchema.Name) && resSchema.Name.equalsIgnoreCase( 'FGM_Base__Benchmark_Update__c' ) && currentRLCRecord.currentRelatedListController.FGM_Portal__ParentObject__c != null && currentRLCRecord.currentRelatedListController.FGM_Portal__ParentObject__c.equalsIgnoreCase( 'FGM_Base__Grantee_Report__c' ) )
                            {
                                for( String field : Schema.getGlobalDescribe().get('FGM_Base__Benchmark__c').getDescribe().fields.getMap().keySet() )
                                {
                                    Schema.DescribeFieldResult sObjField = Schema.getGlobalDescribe().get('FGM_Base__Benchmark__c').getDescribe().fields.getMap().get(field).getDescribe();
                                    String fieldLabel = 'Benchmark > ' + sObjField.getLabel();
                                    String fieldAPIName = 'FGM_Base__Benchmark__r.' + sObjField.getName();
                                    lstChildObjectFields.add(new SelectOption( fieldAPIName, fieldLabel));
                                    if( MapFieldApiNameToLabel == null )
                                        MapFieldApiNameToLabel = new Map< String, String >();
                                    MapFieldApiNameToLabel.put( fieldAPIName, fieldLabel );
                                }

                            }
                        }
                    }
                }
                ChildObjectFieldsOptions.addAll(lstChildObjectFields);
            }
        }
        // To get Parent Object For External Reviewer.
    public List < SelectOption > getParentObjectsForExternalReviewer() {
            List < SelectOption > lstParentObjects = new List < SelectOption > ();
            lstParentObjects.add(new SelectOption('Opportunity', 'Request'));
            lstParentObjects.add(new SelectOption('Lead', 'Inquiry'));
            return lstParentObjects;
        }
        // To get Parent Object.
    public List < SelectOption > getParentObjects() {
        List < SelectOption > lstParentObjects = new List < SelectOption > ();
        if (!isApplicationdesigner) lstParentObjects.addAll(getAvailableObjects());
        else {
            lstParentObjects.add(new SelectOption('Opportunity', 'Request'));
            lstParentObjects.add(new SelectOption('Lead', 'Inquiry'));
        }
        return lstParentObjects;
    }
    private FGM_Portal__Related_List_Controller__c getTabRecordById(String tabId)
    {
            FGM_Portal__Related_List_Controller__c tabRecord = null;
            tabId = String.escapeSingleQuotes(tabId);
            if (tabsList != null && !tabsList.isEmpty() && String.isNotBlank(tabId))
            {
                for (FGM_Portal__Related_List_Controller__c Record: tabsList)
                {
                    if (tabId == String.valueOf(Record.Id)) tabRecord = Record;
                }
            }
            return tabRecord;
        }
        //---------Grantee Budget Administrator--------------
    private Map < Id, FGM_Portal__Grantee_Budget_Category__c > mapCategories;
    public List < SelectOption > lstSubCategories {
        get;
        set;
    }
    public string selectedBudgetCategory {
        get;
        set;
    }
    public string selectedBudgetSubCategory {
        get;
        set;
    }
    public Integer categoryId {
        get;
        set;
    }
    public Boolean IsEditCategory {
        get;
        set;
    }
    public List < FGM_Portal__Grantee_Budget_Configuration__c > lstBudgetConfiguration {
        get;
        set;
    }
    public FGM_Portal__Grantee_Budget_Configuration__c budgetConfiguration {
        get;
        set;
    }
    private Map < String, FGM_Portal__Grantee_Budget_Configuration__c > mapAddedCategoryInBudget;
    // initialize to grantee budget functionality
    public void initializeGranteeBudget() {
            IsEditCategory = false;
            mapAddedCategoryInBudget = new Map < String, FGM_Portal__Grantee_Budget_Configuration__c > ();
            lstSubCategories = new List < SelectOption > ();
            budgetConfiguration = new FGM_Portal__Grantee_Budget_Configuration__c();
            lstBudgetConfiguration = new List < FGM_Portal__Grantee_Budget_Configuration__c > ();

            mapCategories = new Map<Id, Grantee_Budget_Category__c>([
                SELECT
                    Name,
                    IsActive__c,
                    Parent_Category__c,
                    Parent_Category__r.Name
                FROM Grantee_Budget_Category__c
                WHERE IsActive__c = TRUE
                WITH SECURITY_ENFORCED
                LIMIT 5000
            ]);

        }
        //get method for getting all category
    public List < SelectOption > getGranteeBudgetCategories() {
            List < SelectOption > options = new List < SelectOption > ();
            set < Id > setParentCategory = new set < Id > ();

            mapCategories = new Map<Id, Grantee_Budget_Category__c>([
                SELECT
                    Name,
                    IsActive__c,
                    Parent_Category__c,
                    Parent_Category__r.Name,
                    (
                        SELECT Id
                        FROM Grantee_Budget_Categories__r
                        WHERE IsActive__c = TRUE
                        LIMIT 1000
                    )
                FROM Grantee_Budget_Category__c
                WHERE IsActive__c = TRUE
                WITH SECURITY_ENFORCED
                LIMIT 5000
            ]);

            for (Id CategoryKey: mapCategories.keySet()) {
                if ((mapCategories.get(CategoryKey).FGM_Portal__Grantee_Budget_Categories__r).size() > 0) setParentCategory.add(CategoryKey);
            }

            mapCategories = new Map<Id, Grantee_Budget_Category__c>([
                SELECT
                    Name,
                    IsActive__c,
                    Parent_Category__c,
                    Parent_Category__r.Name
                FROM Grantee_Budget_Category__c
                WHERE IsActive__c = TRUE
                AND Id IN :setParentCategory
                WITH SECURITY_ENFORCED
                ORDER BY Name ASC
                LIMIT 5000
            ]);

            if (mapCategories != null && !mapCategories.isEmpty()) {
                for (FGM_Portal__Grantee_Budget_Category__c category: mapCategories.values()) {
                    options.add(new SelectOption(category.Id, category.Name));
                }
            }
            return options;
        }
        //method to get all subcategories
    public void budgetSubCategories() {
            selectedBudgetSubCategory = '';
            if (String.isNotBlank(selectedBudgetCategory)) {
                List < SelectOption > options = new List < SelectOption > ();
                if (mapCategories.containsKey(selectedBudgetCategory)) {

                    for (Grantee_Budget_Category__c subcategory : [
                        SELECT
                            Name,
                            IsActive__c,
                            Parent_Category__c
                        FROM Grantee_Budget_Category__c
                        WHERE Parent_Category__c = :selectedBudgetCategory
                        AND IsActive__c = TRUE
                        WITH SECURITY_ENFORCED
                        ORDER BY Name ASC
                        LIMIT 1000
                    ]) {
                        options.add(new SelectOption(subcategory.Id, subcategory.Name));
                    }

                }
                lstSubCategories = options;
            }
        }
        //--------------------------
    public void updateCategory() {
            Boolean bSuccess = false;
            System.Savepoint savepoint = Database.setSavepoint();
            if (categoryId >= 0) {
                if (String.isNotBlank(selectedBudgetCategory) && mapCategories.containsKey(selectedBudgetCategory)) {
                    // if Sub Category is Not Empty
                    if (String.isNotBlank(selectedBudgetSubCategory) && mapCategories.containsKey(selectedBudgetSubCategory)) {
                        if ((selectedBudgetSubCategory != lstBudgetConfiguration[categoryId].FGM_Portal__Category__c) && mapAddedCategoryInBudget.containsKey(selectedBudgetSubCategory)) {
                            isBudgetError = true;
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'This category already exists, please select another category.'));
                        } else {
                            // If budget configuration record is not inserted
                            if (lstBudgetConfiguration[categoryId].Id == null) {
                                if (mapAddedCategoryInBudget.containsKey(lstBudgetConfiguration[categoryId].FGM_Portal__Category__c)) {
                                    mapAddedCategoryInBudget.remove(lstBudgetConfiguration[categoryId].FGM_Portal__Category__c);
                                    lstBudgetConfiguration[categoryId].FGM_Portal__Category__r = mapCategories.get(selectedBudgetSubCategory);
                                    lstBudgetConfiguration[categoryId].FGM_Portal__Category__c = mapCategories.get(selectedBudgetSubCategory).Id;
                                    bSuccess = true;
                                }
                            } else {
                                if (mapAddedCategoryInBudget.containsKey(lstBudgetConfiguration[categoryId].FGM_Portal__Category__c)) {
                                    mapAddedCategoryInBudget.remove(lstBudgetConfiguration[categoryId].FGM_Portal__Category__c);
                                    lstBudgetConfiguration[categoryId].FGM_Portal__Category__r = mapCategories.get(selectedBudgetSubCategory);
                                    lstBudgetConfiguration[categoryId].FGM_Portal__Category__c = mapCategories.get(selectedBudgetSubCategory).Id;
                                    saveGranteeBudgetConfiguration(savepoint);
                                    bSuccess = true;
                                }
                            }
                        }
                    } // END OF Sub Category is Not Empty
                    else {
                        if ((selectedBudgetCategory != lstBudgetConfiguration[categoryId].FGM_Portal__Category__c) && mapAddedCategoryInBudget.containsKey(selectedBudgetCategory)) {
                            isBudgetError = true;
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'This category already exists, please select another category.'));
                        } else {
                            // If budget configuration record is not inserted
                            if (lstBudgetConfiguration[categoryId].Id == null) {
                                if (mapAddedCategoryInBudget.containsKey(lstBudgetConfiguration[categoryId].FGM_Portal__Category__c)) {
                                    mapAddedCategoryInBudget.remove(lstBudgetConfiguration[categoryId].FGM_Portal__Category__c);
                                    lstBudgetConfiguration[categoryId].FGM_Portal__Category__r = mapCategories.get(selectedBudgetCategory);
                                    lstBudgetConfiguration[categoryId].FGM_Portal__Category__c = mapCategories.get(selectedBudgetCategory).Id;
                                    bSuccess = true;
                                }
                            } else {
                                if (mapAddedCategoryInBudget.containsKey(lstBudgetConfiguration[categoryId].FGM_Portal__Category__c)) {
                                    mapAddedCategoryInBudget.remove(lstBudgetConfiguration[categoryId].FGM_Portal__Category__c);
                                    lstBudgetConfiguration[categoryId].FGM_Portal__Category__r = mapCategories.get(selectedBudgetCategory);
                                    lstBudgetConfiguration[categoryId].FGM_Portal__Category__c = mapCategories.get(selectedBudgetCategory).Id;
                                    saveGranteeBudgetConfiguration(savepoint);
                                    bSuccess = true;
                                }
                            }
                        }
                    }
                }
                if (bSuccess) {
                    mapAddedCategoryInBudget.put(lstBudgetConfiguration[categoryId].FGM_Portal__Category__c, lstBudgetConfiguration[categoryId]);
                }
                lstBudgetConfiguration[categoryId].FGM_Portal__Sort_Order__c = budgetConfiguration.FGM_Portal__Sort_Order__c;
                selectedBudgetCategory = '';
                selectedBudgetSubCategory = '';
                IsEditCategory = false;
            }
            categoryId = -1;
        }
        // Add Category
    public void addCategory() {
            Boolean bSuccess = false;

            mapCategories = new Map<Id, Grantee_Budget_Category__c>([
                SELECT
                    Name,
                    IsActive__c,
                    Parent_Category__c,
                    Parent_Category__r.Name
                FROM Grantee_Budget_Category__c
                WHERE IsActive__c = TRUE
                WITH SECURITY_ENFORCED
                LIMIT 5000
            ]);

            if (String.isNotBlank(selectedBudgetCategory) && mapCategories.containsKey(selectedBudgetCategory) && String.isNotBlank(selectedBudgetSubCategory) && mapCategories.containsKey(selectedBudgetSubCategory)) {
                string strQuizID = quiz.Id;
                String quizId = String.escapeSingleQuotes(strQuizID);
                FGM_Portal__Grantee_Budget_Configuration__c config = new FGM_Portal__Grantee_Budget_Configuration__c();
                if (String.isBlank(String.valueOf(budgetConfiguration.FGM_Portal__Sort_Order__c))) {
                    budgetConfiguration.FGM_Portal__Sort_Order__c = 0;
                }
                config.FGM_Portal__Sort_Order__c = budgetConfiguration.FGM_Portal__Sort_Order__c;
                if (String.isNotBlank(quizId)) {
                    config.FGM_Portal__Quiz__c = quizId;
                }
                if (String.isNotBlank(selectedBudgetSubCategory) && mapCategories.containsKey(selectedBudgetSubCategory)) {
                    if (mapAddedCategoryInBudget.isEmpty()) {
                        config.FGM_Portal__Category__r = mapCategories.get(selectedBudgetSubCategory);
                        config.FGM_Portal__Category__c = mapCategories.get(selectedBudgetSubCategory).Id;
                        bSuccess = true;
                    } else {
                        if (mapAddedCategoryInBudget.containsKey(selectedBudgetSubCategory)) {
                            isBudgetError = true;
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'This category already exists, please select another category.'));
                        } else {
                            config.FGM_Portal__Category__r = mapCategories.get(selectedBudgetSubCategory);
                            config.FGM_Portal__Category__c = mapCategories.get(selectedBudgetSubCategory).Id;
                            bSuccess = true;
                        }
                    }
                } else {
                    if (mapAddedCategoryInBudget.isEmpty()) {
                        config.FGM_Portal__Category__r = mapCategories.get(selectedBudgetCategory);
                        config.FGM_Portal__Category__c = mapCategories.get(selectedBudgetCategory).Id;
                        bSuccess = true;
                    } else {
                        if (mapAddedCategoryInBudget.containsKey(selectedBudgetCategory)) {
                            isBudgetError = true;
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'This category already exists, please select another category.'));
                        } else {
                            config.FGM_Portal__Category__r = mapCategories.get(selectedBudgetCategory);
                            config.FGM_Portal__Category__c = mapCategories.get(selectedBudgetCategory).Id;
                            bSuccess = true;
                        }
                    }
                }
                if (bSuccess) {
                    lstBudgetConfiguration.add(config);
                    mapAddedCategoryInBudget.put(config.FGM_Portal__Category__c, config);
                }
            } else {
                isBudgetError = true;
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Please Select Category and its Subcategory.'));
            }
            selectedBudgetCategory = '';
            selectedBudgetSubCategory = '';
        }
        //---------------------------
    public void cancelUpdateCategory() {
            IsEditCategory = false;
            selectedBudgetCategory = '';
            selectedBudgetSubCategory = '';
            budgetConfiguration.FGM_Portal__Sort_Order__c = 0;
        }
        //method for edit Category
    public void editCategory() {
            if (lstBudgetConfiguration[categoryId].FGM_Portal__Category__r.FGM_Portal__Parent_Category__r == null) {
                selectedBudgetCategory = lstBudgetConfiguration[categoryId].FGM_Portal__Category__r.Id;
                budgetSubCategories();
            } else {
                selectedBudgetCategory = lstBudgetConfiguration[categoryId].FGM_Portal__Category__r.FGM_Portal__Parent_Category__r.Id;
                budgetSubCategories();
                selectedBudgetSubCategory = lstBudgetConfiguration[categoryId].FGM_Portal__Category__r.Id;
            }
            budgetConfiguration.FGM_Portal__Sort_Order__c = lstBudgetConfiguration[categoryId].FGM_Portal__Sort_Order__c;
            IsEditCategory = true;
        }
        //method for delete Category
    public PageReference deleteCategory() {
        if (categoryId >= 0) {
            if (lstBudgetConfiguration.size() == 1) {
                isBudgetError = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'At least one record is required.'));
                return null;
            }
            if (lstBudgetConfiguration[categoryId].Id == null) {
                if (mapAddedCategoryInBudget.containsKey(lstBudgetConfiguration[categoryId].FGM_Portal__Category__c)) {
                    mapAddedCategoryInBudget.remove(lstBudgetConfiguration[categoryId].FGM_Portal__Category__c);
                    lstBudgetConfiguration.remove(categoryId);
                    isBudgetError = true;
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Record Deleted Successfully!'));
                }
            } else {
                try {
                    CrudFlsService.getInstance().assertDeletable(lstBudgetConfiguration[categoryId]);
                    Database.DeleteResult deleteResult = Database.delete(lstBudgetConfiguration[categoryId]);
                    if (deleteResult.isSuccess()) {
                        if (mapAddedCategoryInBudget.containsKey(lstBudgetConfiguration[categoryId].FGM_Portal__Category__c)) {
                            mapAddedCategoryInBudget.remove(lstBudgetConfiguration[categoryId].FGM_Portal__Category__c);
                            lstBudgetConfiguration.remove(categoryId);
                            isBudgetError = true;
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Record Deleted Successfully!'));
                        }
                    }
                } catch (DMLException ex) {
                    isBudgetError = true;
                    ApexPages.getMessages().clear();
                    String errorMessage = ex.getMessage();
                    Integer occurence;
                    if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
                        occurence = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
                        errorMessage = errorMessage.mid(occurence, errorMessage.length());
                        occurence = errorMessage.lastIndexOf(':');
                        errorMessage = errorMessage.mid(0, occurence);
                    } else {
                        categoryId = -1;
                        return null;
                    }
                    categoryId = -1;
                    return null;
                }
            }
            IsEditCategory = false;
            categoryId = -1;
        }
        return null;
    }
    public void showGranteeBudgetCategories(String tabId)
    {
        try
        {
            string strQuizID = quiz.Id;
            String quizId = String.escapeSingleQuotes(strQuizID);
            if (String.isNotBlank(tabId) && String.isNotBlank(quizId)) {

                List<Grantee_Budget_Configuration__c> lstConfiguartion = [
                    SELECT
                        Category__c,
                        Category__r.Parent_Category__r.Name,
                        Category__r.Name,
                        Quiz__c,
                        Sort_Order__c,
                        Related_List_Controller__c
                    FROM Grantee_Budget_Configuration__c
                    WHERE Quiz__c = :quizId
                    AND Related_List_Controller__c = :tabId
                    WITH SECURITY_ENFORCED
                ];

                if (lstConfiguartion != null && !lstConfiguartion.isEmpty()) {
                    lstBudgetConfiguration = lstConfiguartion;
                }
                //To avoid duplicate categories to be added
                if (lstBudgetConfiguration != null && lstBudgetConfiguration.size() > 0) {
                    for (FGM_Portal__Grantee_Budget_Configuration__c configRecord: lstBudgetConfiguration) {
                        mapAddedCategoryInBudget.put(configRecord.FGM_Portal__Category__c, configRecord);
                    }
                }
            }
        }
        catch(Exception ex)
        {
            system.debug( 'Exception: ' + ex + ' @Line :: ' + ex.getLineNumber() + ' Message ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, '' + ex));
        }
    }
    public PageReference saveGranteeBudgetConfiguration(System.Savepoint savepoint) {
            try {
                if (lstBudgetConfiguration != null && lstBudgetConfiguration.size() > 0) {
                    for (FGM_Portal__Grantee_Budget_Configuration__c config: lstBudgetConfiguration) {
                        config.FGM_Portal__Related_List_Controller__c = currentRLCRecord.currentRelatedListController.Id;
                    }
                    CrudFlsService.getInstance().assertUpdateable(lstBudgetConfiguration);
                    Database.UpsertResult[] upsertResult = Database.upsert(lstBudgetConfiguration);
                    // Iterate through each returned result
                    for (Database.UpsertResult sr: upsertResult) {
                        if (sr.isSuccess()) {
                            // Operation was successful, so get the ID of the record that was processed
                            isBudgetError = true;
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Record Saved Successfully!'));
                        } else {
                            // Operation failed, so get all errors
                            for (Database.Error err: sr.getErrors()) {
                                isBudgetError = true;
                            }
                            if (isBudgetError) {
                                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Something went wrong!'));
                            }
                        }
                    }
                }
            } catch (DMLException ex) {
                isBudgetError = true;
                ApexPages.getMessages().clear();
                String errorMessage = ex.getMessage();
                Integer occurence;
                if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
                    occurence = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
                    errorMessage = errorMessage.mid(occurence, errorMessage.length());
                    occurence = errorMessage.lastIndexOf(':');
                    errorMessage = errorMessage.mid(0, occurence);
                }
                return null;
            }
            return null;
        }
        //---------End of Grantee Budget Config--------------
        // To initilize the RLC record.
    public void addTab()
    {
        try
        {
            quizID = ESAPI.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('id'));
            isShowExternalRelatedObject = false;
            String strRLCRecordType = getParam('RCLType');
            isOtherLanguageConfig = false;
            String strRLCRecordTypeId = '';
            if (String.isNotBlank(strRLCRecordType))
            {
                Map < String, Schema.RecordTypeInfo > recordTypeInfo = Schema.Sobjecttype.FGM_Portal__Related_List_Controller__c.getRecordTypeInfosByName();
                if (!recordTypeInfo.isEmpty())
                {
                    Schema.RecordTypeInfo requiredRecordType = recordTypeInfo.get(strRLCRecordType);
                    if (requiredRecordType != null)
                        strRLCRecordTypeId = requiredRecordType.getRecordTypeId(); // Get record Type Id
                }
            }
            if (String.isNotBlank(strRLCRecordTypeId))
            {
                currentRLCRecord = new RelatedListController();
                currentRLCRecord.currentRelatedListController.RecordTypeId = strRLCRecordTypeId;
                currentRLCRecord.recordTypeName = strRLCRecordType;
                if (portalTabsList != null && !portalTabsList.isEmpty())
                {
                    if (portalTabsList[0].FGM_Portal__ParentObject__c.equalsIgnoreCase('sObject'))
                    {
                        if (strRLCRecordType != 'Contact Tab' && strRLCRecordType != 'Organization Tab' )
                            currentRLCRecord.currentRelatedListController.FGM_Portal__ParentObject__c = portalTabsList[0].FGM_Portal__ObjectName__c;
                        else
                            currentRLCRecord.currentRelatedListController.ParentObject__c = 'Opportunity';
                        currentRLCRecord.currentRelatedListController.Language__c = 'en_US';
                        if (!('Related List With Tab'.equalsIgnoreCase(strRLCRecordType)))
                            isExternalReviewer = false;
                    }
                    else if( 'Custom Profile Tab'.equalsIgnoreCase(strRLCRecordType) )
                        currentRLCRecord.currentRelatedListController.FGM_Portal__ParentObject__c = 'Account';
                    else
                        currentRLCRecord.currentRelatedListController.FGM_Portal__ParentObject__c = portalTabsList[0].FGM_Portal__ParentObject__c;
                    currentRLCRecord.currentRelatedListController.FGM_Portal__Associated_FC_Portal_Type__c = portalTabsList[0].FGM_Portal__Associated_FC_Portal_Type__c;
                }
                //Related List Tab for Application designer
                else if (!isApplicationdesigner && String.isNotBlank(selectedObject)) {
                    currentRLCRecord.currentRelatedListController.FGM_Portal__ParentObject__c = selectedObject;
                    currentRLCRecord.currentRelatedListController.Language__c = 'en_US';
                }
                currentRLCRecord.lstRLCFields.addAll(getFieldsList(strRLCRecordType));
                if ('Grantee Budget Tab'.equalsIgnoreCase(strRLCRecordType)) {
                    initializeGranteeBudget();
                    isGranteeBudgetTab = true;
                }
            }
        }
        catch(Exception ex)
        {
            system.debug( 'Exception: ' + ex + ' @Line :: ' + ex.getLineNumber() + ' Message ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, '' + ex));
        }
    }
        // To edit the RLC record.
    public void editTab()
    {
            String strTabID = getParam('tabId');
            String strRLCRecordTypeName = '';
            isOtherLanguageConfig = false;
            if (String.isNotBlank(strTabID))
            {
                selectedTab = strTabID;
                FGM_Portal__Related_List_Controller__c tabRecord = getTabRecordById(strTabID);
                if (tabRecord != null) {
                    Map < Id, Schema.RecordTypeInfo > recordTypeInfo = Schema.Sobjecttype.FGM_Portal__Related_List_Controller__c.getRecordTypeInfosById();
                    if (!recordTypeInfo.isEmpty())
                    {
                        Schema.RecordTypeInfo requiredRecordType = recordTypeInfo.get(tabRecord.RecordTypeId);
                        if (requiredRecordType != null)
                        {
                            strRLCRecordTypeName = requiredRecordType.getName(); // Get record Type Name
                        }
                    }
                    if (String.isNotBlank(strRLCRecordTypeName))
                    {
                        currentRLCRecord = new RelatedListController();
                        currentRLCRecord.currentRelatedListController = tabRecord;
                        currentRLCRecord.currentRelatedListController.FGM_Portal__Hide_Edit_Link__c = !tabRecord.FGM_Portal__Hide_Edit_Link__c;
                        currentRLCRecord.recordTypeName = strRLCRecordTypeName;
                        if (!'IFrame Tab'.equalsIgnoreCase(strRLCRecordTypeName) && !'Grantee Budget Tab'.equalsIgnoreCase(strRLCRecordTypeName)) {
                            getChildObjectFields();
                        }
                        if( 'Custom Profile Tab'.equalsIgnoreCase(strRLCRecordTypeName) )
                        {
                            SelectedObjectOption = currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c;
                            for( FGM_Portal__Related_List_Controller__c rlcRecord : MapObjNRlcRecords.get(SelectedObjectOption) )
                            {
                                if( tabRecord.FGM_Portal__Cloned_from__r.Name.equalsIgnoreCase(rlcRecord.Name) )
                                    SelectedProfileTabOption = rlcRecord.Name;
                            }
                        }
                        currentRLCRecord.lstRLCFields.addAll(getFieldsList(strRLCRecordTypeName));
                        //To get All Category of Budget
                        if ('Grantee Budget Tab'.equalsIgnoreCase(strRLCRecordTypeName))
                        {
                            initializeGranteeBudget();
                            showGranteeBudgetCategories(tabRecord.Id);
                        }

                        if (String.isNotBlank(tabRecord.FGM_Portal__FieldHeaders__c) && String.isNotBlank(tabRecord.FGM_Portal__FieldNames__c))
                        {
                            List < String > lstLabels = (List < String > ) tabRecord.FGM_Portal__FieldHeaders__c.split(',');
                            List < String > lstFields = (List < String > ) tabRecord.FGM_Portal__FieldNames__c.split(',');
                            if (lstLabels != null && lstFields != null) {
                                columnConfiguration colConfig = null;
                                for (integer i = 0; i < lstLabels.size(); i++) {
                                    if (String.isNotBlank(lstLabels[i]) && i < lstFields.size()) {
                                        colConfig = new columnConfiguration();
                                        colConfig.colLabel = lstLabels[i];
                                        colConfig.colField = lstFields[i];
                                        currentRLCRecord.relatedListColumns.add(colConfig);
                                    }
                                }
                            }
                        }
                        else if( tabRecord.Field_Labels_Long__c != null && tabRecord.Field_Names_Long__c != null )
                        {
                            List < String > lstLabels = (List < String > ) tabRecord.Field_Labels_Long__c.split(',');
                            List < String > lstFields = (List < String > ) tabRecord.Field_Names_Long__c.split(',');
                            if (lstLabels != null && lstFields != null) {
                                columnConfiguration colConfig = null;
                                for (integer i = 0; i < lstLabels.size(); i++) {
                                    if (String.isNotBlank(lstLabels[i]) && i < lstFields.size()) {
                                        colConfig = new columnConfiguration();
                                        colConfig.colLabel = lstLabels[i];
                                        colConfig.colField = lstFields[i];
                                        currentRLCRecord.relatedListColumns.add(colConfig);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        // To delete the RLC record.
    public void deleteTab() {
            String strTabID = String.escapeSingleQuotes(getParam('tabId'));
            if (String.isNotBlank(strTabID)) {
                FGM_Portal__Related_List_Controller__c tabRecord = getTabRecordById(strTabID);
                if (tabRecord != null) {
                    try {
                        CrudFlsService.getInstance().assertDeletable(tabRecord);
                        delete tabRecord;
                        initializeTabs();
                        initializeQuizQuestionList();
                    } catch (Exception problem) {
                        rollbackWithError(problem.getTypeName() + ': ' + problem.getMessage(), null);
                    }
                }
            }
        }
        // To close the RLC form.
    public void closeRLCPopUp() {
            isShowExternalRelatedObject = false;
            currentRLCRecord = null;
            isOtherLanguageConfig = false;
            ChildObjectFieldsOptions = null;
            SelectedObjectOption = null;
            SelectedProfileTabOption = null;
        }
        // Back to RLC Configuration.
    public void backTORLCConfiguration() {
            isOtherLanguageConfig = false;
            isShowExternalRelatedObject = false;
        }
        // To add Column in related List Fields column list.
    public void addColumnInRelatedListTable()
    {
        if( currentRLCRecord != null && String.isNotBlank(currentRLCRecord.newColumn.colLabel) && String.isNotBlank(currentRLCRecord.newColumn.colField) )
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'currentRLCRecord.newColumn: ' + currentRLCRecord.newColumn));
            currentRLCRecord.relatedListColumns.add(currentRLCRecord.newColumn);
            currentRLCRecord.newColumn = new columnConfiguration();
        }
    }
        // To remove Column in related List Fields column list.
    public void removeColumnInRelatedListTable() {
            currentRLCRecord.relatedListColumns.remove(iColumnIndex);
        }
        // To edit Column in related List Fields column list.
    public void editColumnInRelatedListTable() {
            currentRLCRecord.relatedListColumns[iColumnIndex].isEdit = true;
        }
        // To save edited Column in related List Fields column list.
    public void saveColumnInRelatedListTable() {
            currentRLCRecord.relatedListColumns[iColumnIndex].isEdit = false;
        }
        // To define the required fields of RLC object on form
    public List < Map < String, String >> getFieldsList(String RLCRecordType)
    {
            List < Map < String, String >> lstRTFields = new List < Map < String, String >> ();
            //Add Common fields in list
            Map < String, String > mapField = new Map < String, String > {
                'Name' => 'Tab Name'
            };
            lstRTFields.add(mapField);
            if (!'IFrame Tab'.equalsIgnoreCase(RLCRecordType) && !'Contact Tab'.equalsIgnoreCase(RLCRecordType) && !'Organization Tab'.equalsIgnoreCase(RLCRecordType) && !'Custom Profile Tab'.equalsIgnoreCase(RLCRecordType) && !'Grantee Budget Update Tab'.equalsIgnoreCase(RLCRecordType))
            {
                mapField = new Map < String, String > {
                    'FGM_Portal__ParentObject__c' => 'Object Name'
                };
                lstRTFields.add(mapField);
            }
            mapField = new Map < String, String > {
                'FGM_Portal__SortOrder__c' => 'Tab Sort Order'
            };
            lstRTFields.add(mapField);
            // code for Contact Tab
            if ('Contact Tab'.equalsIgnoreCase(RLCRecordType))
            {
                mapField = new Map < String, String > {
                    'FGM_Portal__RichInstructionalText__c' => 'InstructionText'
                };
                lstRTFields.add(mapField);
            }

            if( 'Organization Tab'.equalsIgnoreCase(RLCRecordType) )
            {
                mapField = new Map < String, String > {
                    'FGM_Portal__RichInstructionalText__c' => 'InstructionText'
                };
                lstRTFields.add(mapField);
            }
            // code for Custom Profile Tab
            if( 'Custom Profile Tab'.equalsIgnoreCase(RLCRecordType) )
            {
                mapField = new Map < String, String > {
                    'FGM_Portal__of_records_to_display__c' => 'No. of records to display in Table',
                    'FGM_Portal__RichInstructionalText__c' => 'Instruction Text'
                };
                lstRTFields.add(mapField);
            }
            if ('Related List With Tab'.equalsIgnoreCase(RLCRecordType))
            {
                mapField = new Map < String, String > {
                    'FGM_Portal__ObjectName__c' => 'Child Object'
                };
                lstRTFields.add(mapField);
                mapField = new Map < String, String > {
                    'FGM_Portal__SortField__c' => 'Sort Field'
                };
                lstRTFields.add(mapField);
                mapField = new Map < String, String > {
                    'FGM_Portal__SortFieldOrder__c' => 'Sort Field Order'
                };
                lstRTFields.add(mapField);
                mapField = new Map < String, String > {
                    'FGM_Portal__ShowNewButton__c' => 'Show New Button'
                };
                lstRTFields.add(mapField);
                mapField = new Map < String, String > {
                    'FGM_Portal__Hide_Edit_Link__c' => 'Show Edit Link'
                };
                lstRTFields.add(mapField);
                mapField = new Map < String, String > {
                    'FGM_Portal__ShowDeleteLink__c' => 'Show Delete Link'
                };
                lstRTFields.add(mapField);
                mapField = new Map < String, String > {
                    'FGM_Portal__RichInstructionalText__c' => 'InstructionText'
                };
                lstRTFields.add(mapField);
            }
            if ('IFrame Tab'.equalsIgnoreCase(RLCRecordType))
            {
                mapField = new Map < String, String > {
                    'FGM_Portal__BaseUrl__c' => 'URL'
                };
                lstRTFields.add(mapField);
            }
            if ('Grantee Budget Tab'.equalsIgnoreCase(RLCRecordType))
            {
                mapField = new Map < String, String > {
                    'FGM_Portal__RichInstructionalText__c' => 'InstructionText'
                };
                lstRTFields.add(mapField);
            }
            if ('Grantee Budget Update Tab'.equalsIgnoreCase(RLCRecordType))
            {
                mapField = new Map < String, String > {
                    'FGM_Portal__ParentObject__c' => 'Parent Object'
                };
                lstRTFields.add(mapField);
                mapField = new Map < String, String > {
                    'FGM_Portal__RichInstructionalText__c' => 'InstructionText'
                };
                lstRTFields.add(mapField);
            }
            return lstRTFields;
        }
        // To Insert/Update the RLC record
    public PageReference saveRelatedListControllerRecord()
    {
        if (currentRLCRecord != null && String.isNotBlank(currentRLCRecord.recordTypeName) && currentRLCRecord.currentRelatedListController != null && quiz != null && quiz.Id != null)
        {
            if (!String.isNotBlank(currentRLCRecord.currentRelatedListController.Name))
            {
                currentRLCRecord.currentRelatedListController.Name.addError('Please Enter Tab Label');
                return null;
            }
            if (!String.isNotBlank(currentRLCRecord.currentRelatedListController.FGM_Portal__ParentObject__c))
            {
                currentRLCRecord.currentRelatedListController.FGM_Portal__ParentObject__c.addError('Please Enter Object Name');
                return null;
            }
            // To save Portal tab RecordType Record
            if ( 'Contact Tab'.equalsIgnoreCase(currentRLCRecord.recordTypeName) || 'Organization Tab'.equalsIgnoreCase(currentRLCRecord.recordTypeName) )
            {
                currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c = 'none';
                currentRLCRecord.currentRelatedListController.FGM_Portal__LookupField__c = 'none';
            }
            if( 'Custom Profile Tab'.equalsIgnoreCase(currentRLCRecord.recordTypeName) )
            {
                if( SelectedObjectOption.equalsIgnoreCase('-- Select Object --')  )
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select SObject.'));
                    return null;
                }
                else if( SelectedProfileTabOption.equalsIgnoreCase('-- Select Profile Tab --') )
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select Profile Tab.'));
                    return null;
                }
            }
            if ('Portal Tab'.equalsIgnoreCase(currentRLCRecord.recordTypeName) && currentRLCRecord.currentRelatedListController.Id == null)
            {
                currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c = currentRLCRecord.currentRelatedListController.FGM_Portal__ParentObject__c;
                currentRLCRecord.currentRelatedListController.FGM_Portal__LookupField__c = currentRLCRecord.currentRelatedListController.FGM_Portal__ParentObject__c;
            }
            else if ('IFrame Tab'.equalsIgnoreCase(currentRLCRecord.recordTypeName))
            {
                currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c = 'none';
                currentRLCRecord.currentRelatedListController.FGM_Portal__LookupField__c = 'none';
            }
            else if ('Related List With Tab'.equalsIgnoreCase(currentRLCRecord.recordTypeName))
            {
                if (!String.isNotBlank(currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c))
                {
                    currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c.addError('Please Select Child Object Name');
                    return null;
                }

                currentRLCRecord.currentRelatedListController.FGM_Portal__Hide_Edit_Link__c = !currentRLCRecord.currentRelatedListController.FGM_Portal__Hide_Edit_Link__c;
                if (String.isNotBlank(currentRLCRecord.currentRelatedListController.FGM_Portal__Associated_Tab_Type__c))
                {
                    currentRLCRecord.currentRelatedListController.FGM_Portal__Associated_Tab_Type__c = 'Related List Tab';
                }
                String strChildLookUpField = '';
                if (mapChildrelationShip != null && mapChildrelationShip.containsKey(currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c) && currentRLCRecord.currentRelatedListController.Id == null)
                    strChildLookUpField = mapChildrelationShip.get(currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c);
                else
                    strChildLookUpField = currentRLCRecord.currentRelatedListController.FGM_Portal__LookupField__c;
                if (String.isNotBlank(strChildLookUpField))
                {
                    currentRLCRecord.currentRelatedListController.FGM_Portal__LookupField__c = strChildLookUpField;
                    if (currentRLCRecord.relatedListColumns != null && !currentRLCRecord.relatedListColumns.isEmpty())
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'currentRLCRecord.relatedListColumns: ' + currentRLCRecord.relatedListColumns));
                        currentRLCRecord.currentRelatedListController.FGM_Portal__FieldHeaders__c = '';
                        currentRLCRecord.currentRelatedListController.FGM_Portal__FieldNames__c = '';
                        currentRLCRecord.currentRelatedListController.Field_Labels_Long__c = null;
                        currentRLCRecord.currentRelatedListController.Field_Names_Long__c = null;
                        for (columnConfiguration column: currentRLCRecord.relatedListColumns)
                        {
                            if (String.isNotBlank(column.colLabel) && String.isNotBlank(column.colField))
                            {
                                if( currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c.equalsIgnoreCase( 'FGM_Base__Benchmark_Update__c' ) )
                                {
                                    if( currentRLCRecord.currentRelatedListController.Field_Labels_Long__c == null )
                                        currentRLCRecord.currentRelatedListController.Field_Labels_Long__c = column.colLabel;
                                    else
                                    {
                                        currentRLCRecord.currentRelatedListController.Field_Labels_Long__c += ',' + column.colLabel;
                                    }
                                    if( currentRLCRecord.currentRelatedListController.Field_Names_Long__c == null )
                                        currentRLCRecord.currentRelatedListController.Field_Names_Long__c = column.colField;
                                    else
                                    {
                                        currentRLCRecord.currentRelatedListController.Field_Names_Long__c += ',' + column.colField;
                                    }
                                    currentRLCRecord.currentRelatedListController.FGM_Portal__FieldHeaders__c = null;
                                    currentRLCRecord.currentRelatedListController.FGM_Portal__FieldNames__c = null;
                                }
                                else
                                {
                                    if (String.isNotBlank(currentRLCRecord.currentRelatedListController.FGM_Portal__FieldHeaders__c))
                                        currentRLCRecord.currentRelatedListController.FGM_Portal__FieldHeaders__c += ',';
                                    if (String.isNotBlank(currentRLCRecord.currentRelatedListController.FGM_Portal__FieldNames__c))
                                        currentRLCRecord.currentRelatedListController.FGM_Portal__FieldNames__c += ',';
                                    currentRLCRecord.currentRelatedListController.FGM_Portal__FieldHeaders__c += column.colLabel;
                                    currentRLCRecord.currentRelatedListController.FGM_Portal__FieldNames__c += column.colField;
                                }
                                if (currentRLCRecord.currentRelatedListController.FGM_Portal__SortOrder__c == null)
                                    currentRLCRecord.currentRelatedListController.FGM_Portal__SortOrder__c = relatedListTabList != null ? relatedListTabList.size() + 1 : 1;
                            }
                        }
                    }
                }
            }
            if (currentRLCRecord.currentRelatedListController.FGM_Portal__SortOrder__c == null)
                currentRLCRecord.currentRelatedListController.FGM_Portal__SortOrder__c = portalTabsList != null ? portalTabsList.size() + 1 : 1;
            if (String.isNotBlank(currentRLCRecord.currentRelatedListController.FGM_Portal__Associated_Tab_Type__c))
                currentRLCRecord.currentRelatedListController.FGM_Portal__Associated_Tab_Type__c = 'Details';
            if (!String.isNotBlank(currentRLCRecord.currentRelatedListController.FGM_Portal__Associated_FC_Portal_Type__c))
                currentRLCRecord.currentRelatedListController.FGM_Portal__Associated_FC_Portal_Type__c = portalType;
            currentRLCRecord.currentRelatedListController.Quiz__c = quiz.Id;
            if ('Related List With Tab'.equalsIgnoreCase(currentRLCRecord.recordTypeName) && !String.isNotBlank(currentRLCRecord.currentRelatedListController.FGM_Portal__LookupField__c))
                return null;
            currentRLCRecord.currentRelatedListController.FGM_Portal__IsCommunityRecord__c = true;
            currentRLCRecord.currentRelatedListController.FGM_Portal__Language__c = portalLanguage;
            if ('Grantee Budget Tab'.equalsIgnoreCase(currentRLCRecord.recordTypeName))
            {
                currentRLCRecord.currentRelatedListController.FGM_Portal__LookupField__c = 'FGM_Portal__Grantee_Budget__c';
                currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c = 'FGM_Portal__Grantee_Budget__c';
            }
            if ('Grantee Budget Update Tab'.equalsIgnoreCase(currentRLCRecord.recordTypeName))
            {
                currentRLCRecord.currentRelatedListController.FGM_Portal__LookupField__c = 'FGM_Portal__Grantee_Budget_Update__c';
                currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c = 'FGM_Portal__Grantee_Budget_Update__c';
            }
            CrudFlsService.getInstance().assertUpdateable(currentRLCRecord.currentRelatedListController);
            upsert currentRLCRecord.currentRelatedListController;
            if (currentRLCRecord.currentRelatedListController.FGM_Portal__ParentObject__c != null)
            {
                String strSelectedObject = currentRLCRecord.currentRelatedListController.FGM_Portal__ParentObject__c;
                hasChildObject = FCGlobal.hasChildObject(strSelectedObject);
            }
            if ('Grantee Budget Tab'.equalsIgnoreCase(currentRLCRecord.recordTypeName))
            {
                if (currentRLCRecord.currentRelatedListController.Id != null)
                    saveGranteeBudgetConfiguration(null);
            }
            currentRLCRecord = null;
            mapChildrelationShip = null;
            SelectedObjectOption = null;
            SelectedProfileTabOption = null;
            initializeTabs();
        }
        isShowExternalRelatedObject = false;
        initializeFieldOptions();
        return null;
    }
        // Additional methods for PageLayout Genrator.
        // Get all Objects from Organization
    public List < SelectOption > getAvailableObjects() {
            List < SelectOption > FieldOptions = new List < SelectOption > ();
            List < Schema.SObjectType > globalDescribe = Schema.getGlobalDescribe().Values();
            for (Schema.SObjectType orgObject: globalDescribe) {
                Schema.DescribeSObjectResult objectdescribe = orgObject.getDescribe();
                if (objectdescribe.isAccessible() && objectdescribe.isQueryable() && objectdescribe.isCreateable() && objectdescribe.isCustom() && !objectdescribe.isCustomSetting() && objectdescribe.getLocalName() != 'Opportunity' && objectdescribe.getLocalName() != 'Lead' && (objectdescribe.getName().toLowerCase() != 'FC_Reviewer__External_Review__c'.toLowerCase())) {
                    FieldOptions.add(new Selectoption(objectdescribe.getName(), objectdescribe.getLabel()));
                }
            }
            return FieldOptions;
        }
        // Get Portal type
    public List < SelectOption > getPortalTypes() {
            List < SelectOption > lstPortalTypeOptions = new List < SelectOption > ();
            lstPortalTypeOptions.add(new SelectOption('Grantee', 'Grantee'));
            lstPortalTypeOptions.add(new SelectOption('Reviewer', 'Reviewer'));
            return lstPortalTypeOptions;
        }
        // Get selected Object recordType
    public void getRecordType() {
        Set < String > existingRecordtype = initilizePageLayouts();
        isCloneQuiz = false;
        List < SelectOption > RecordTypeOptions = new List < SelectOption > ();
        if (String.isNotBlank(selectedObject)) {
            //hasChildObject = FCGlobal.hasChildObject(selectedObject);
            if (AdminContextExecutionManager.getRecordTypesByName(selectedObject) != null) {
                Map < String, Schema.RecordTypeInfo > mapRecordTypeInfo = AdminContextExecutionManager.getRecordTypesByName(selectedObject); //getting all Recordtype for the Sobject
                for (Schema.RecordTypeInfo recordTypeInfo: mapRecordTypeInfo.values()) {
                    if (recordTypeInfo.isAvailable() && recordTypeInfo.getName() != 'Master') {
                        if (!existingRecordtype.contains(recordTypeInfo.getRecordTypeId())) {
                            RecordTypeOptions.add(new Selectoption(recordTypeInfo.getRecordTypeId(), recordTypeInfo.getName()));
                        }
                    }
                }
            }
        }
        if (RecordTypeOptions.size() > 0) {
            lstRecordType = RecordTypeOptions;
        } else {
            lstRecordType = null;
        }
    }
    public void initilizePageLayout() {
        if ( quiz == null || quiz.id == null)
            return;

        List<FCPageLayout__c> pageLayout = [
            SELECT
                Name,
                ObjectName__c,
                RecordTypeId__c,
                Quiz__c
            FROM FCPageLayout__c
            WHERE Quiz__c = :quiz.Id
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

        if ( !pageLayout.isEmpty() )
            selectedObject = pageLayout[0].ObjectName__c;
    }
    public Set < String > initilizePageLayouts() {
        lstExistingLayout = null;
        Set < String > setExistingRecordType = new Set < String > ();

        mapFCPageLayout = new Map<Id, FCPageLayout__c>([
            SELECT
                Name,
                ObjectName__c,
                RecordTypeId__c,
                Quiz__c
            FROM FCPageLayout__c
            WHERE ObjectName__c = :selectedObject
            AND Quiz__c != null
            WITH SECURITY_ENFORCED
        ]);

        if (mapFCPageLayout != null && mapFCPageLayout.size() > 0) {
            lstExistingLayout = new List < SelectOption > ();
            for (FCPageLayout__c pageLayout: mapFCPageLayout.values()) {
                lstExistingLayout.add(new Selectoption(pageLayout.Id, pageLayout.Name));
                if (String.isNotBlank(pageLayout.RecordTypeId__c)) {
                    setExistingRecordType.add(pageLayout.RecordTypeId__c.trim());
                }
            }
        }
        return setExistingRecordType;
    }
    public PageReference createNewPageLayout() {
        if (String.isNotBlank(selectedRecordType)) {
            System.Savepoint savepoint = Database.setSavepoint();
            try {
                quiz = null;
                if (isCloneQuiz) {
                    if (mapFCPageLayout != null && !mapFCPageLayout.isEmpty() && mapFCPageLayout.containsKey(existPageLayout)) {
                        FCPageLayout__c selectedPageLayout = mapFCPageLayout.get(existPageLayout);
                        if (String.isNotBlank(existPageLayout)) {
                            quiz = FCGlobal.cloneQuiz(selectedPageLayout.Quiz__c, getObjectName(selectedObject) + ':' + getRecordTypeName(selectedRecordType));
                        } else {
                            return rollbackWithError('Please Select Existing RecordType to clone', null);
                        }
                    }
                } else {
                    quiz = new FGM_Portal__Quiz__c();
                    quiz.Name = getObjectName(selectedObject) + ':' + getRecordTypeName(selectedRecordType);
                    quiz.FGM_Portal__Is_Active__c = true;
                    quiz.FGM_Portal__IsCommunityRecord__c = true;
                    quiz.RecordTypeId = FCGlobal.getRecordTypeId(String.valueOf(FGM_Portal__Quiz__c.sObjectType), 'Page Layout');
                    CrudFlsService.getInstance().assertCreateable(quiz);
                    insert quiz;
                }
                FCPageLayout__c newPageLayout = new FCPageLayout__c();
                newPageLayout.Name = getRecordTypeName(selectedRecordType);
                newPageLayout.ObjectName__c = selectedObject;
                newPageLayout.RecordTypeId__c = selectedRecordType;
                newPageLayout.Quiz__c = quiz.Id;
                CrudFlsService.getInstance().assertCreateable(newPageLayout);
                insert newPageLayout;
            } catch (System.Exception problem) {
                system.debug( 'Exception: ' + problem + ' @Line :: ' + problem.getLineNumber() + ' Message ' + problem.getStackTraceString());
                return rollbackWithError(problem.getTypeName() + ': ' + problem.getMessage(), savepoint);
            }
            PageReference pageReference = System.Page.QuizDesignForm;
            pageReference.getParameters().put('id', quiz.Id);
            pageReference.setRedirect(true);
            return pageReference;
        } else {
            return rollbackWithError('Please Select Record Type', null);
        }
    }
    public PageReference OpenExistingPageLayout() {
        if (mapFCPageLayout != null && !mapFCPageLayout.isEmpty() && String.isNotBlank(selectedPageLayout) && mapFCPageLayout.containsKey(selectedPageLayout)) {
            FCPageLayout__c selectedPageLayout = mapFCPageLayout.get(selectedPageLayout);
            PageReference pageReference = System.Page.QuizDesignForm;
            pageReference.getParameters().put('id', selectedPageLayout.Quiz__c);
            pageReference.setRedirect(true);
            return pageReference;
        } else {
            return rollbackWithError('Please Select Existing PageLayout.', null);
        }
    }
    public String getRecordTypeName(String recordTypeId) {
        if (String.isNotBlank(recordTypeId) && lstRecordType != null && lstRecordType.size() > 0) {
            for (SelectOption recordType: lstRecordType) {
                if (recordTypeId.equalsIgnoreCase(recordType.getValue())) {
                    return recordType.getLabel();
                }
            }
        }
        return '';
    }
    public String getObjectName(String ObjectId) {
            if (String.isNotBlank(ObjectId)) {
                Map < String, Schema.SObjectType > sObjectMap = Schema.getGlobalDescribe();
                Schema.SObjectType sObjectdescribe = sObjectMap.get(selectedObject); // getting Sobject Type
                Schema.DescribeSObjectResult resSchema = sObjectdescribe.getDescribe();
                return resSchema.getLabel();
            }
            return '';
        }
        //  To handle RLC tab Functionality
    public class RelatedListController {
        public FGM_Portal__Related_List_Controller__c currentRelatedListController { get; set; }
        public List < Map < String, String >> lstRLCFields { get; set; }
        public List < Map < String, String >> lstLanguageSpecificFields { get; set; }
        public List < columnConfiguration > relatedListColumns { get; set; }
        public columnConfiguration newColumn { get; set; }
        public String recordTypeName { get; set; }
        public RelatedListController() {
            relatedListColumns = new List < columnConfiguration > ();
            lstRLCFields = new List < Map < String, String >> ();
            currentRelatedListController = new FGM_Portal__Related_List_Controller__c();
            newColumn = new columnConfiguration();
        }
    }
    public class columnConfiguration {
        public String colLabel { get; set; }
        public String colField { get; set; }
        public String colFieldLabel { get; set; }
        public Boolean isEdit { get; set; }
    }
    public PageReference cloneRLCWithItems() {
        FGM_Portal__Related_List_Controller__c newRLC;

        cloneRLC = [
            SELECT
                Name,
                Description__c,
                ObjectName__c,
                ParentObject__c,
                LookupField__c,
                Associated_Tab_Type__c,
                Associated_FC_Portal_Type__c,
                Quiz__c,
                EnableAmendment__c,
                Language__c,
                SortOrder__c,
                FieldHeaders__c,
                FieldNames__c,
                EditStatus__c
            FROM Related_List_Controller__c
            WHERE Name = 'Home Page'
            AND IsCommunityRecord__c = TRUE
            AND (
                Language__c = 'en_US'
                OR Language__c = ''
            )
            WITH SECURITY_ENFORCED
            LIMIT 1000
        ];

        newRLC = cloneRLC.clone(false);
        CrudFlsService.getInstance().assertCreateable(newRLC);
        insert newRLC;
        return null;
    }

    public List< SelectOption > GetProfileTabs()
    {
        try
        {
            if( MapObjNRlcRecords != null && MapObjNRlcRecords.values() != null )
            {
                List< SelectOption > lstProfileTabs = new List< SelectOption >();
                lstProfileTabs.add(new SelectOption('-- Select Profile Tab --', '-- Select Profile Tab --'));
                if( MapObjNRlcRecords.get(SelectedObjectOption) != null )
                {
                    for( FGM_Portal__Related_List_Controller__c rlcRecord : MapObjNRlcRecords.get(SelectedObjectOption) )
                        lstProfileTabs.add(new SelectOption(rlcRecord.Name, rlcRecord.Name));
                    return lstProfileTabs;
                }
                SelectedProfileTabOption = null;
                return lstProfileTabs;
            }
            else
                return null;
        }
        catch(Exception ex)
        {
            system.debug( 'Exception: ' + ex + ' @Line :: ' + ex.getLineNumber() + ' Message ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, '' + ex));
            return null;
        }
    }
    public void CloneRLCRecord()
    {
        try
        {
            if( SelectedProfileTabOption != null && !SelectedProfileTabOption.equalsIgnoreCase('-- Select Profile Tab --') )
            {
                if( !SelectedObjectOption.equalsIgnoreCase('-- Select Object --') && MapObjNRlcRecords.get(SelectedObjectOption) != null )
                {
                    for( FGM_Portal__Related_List_Controller__c rlcRecord : MapObjNRlcRecords.get(SelectedObjectOption) )
                    {
                        if( SelectedProfileTabOption.equalsIgnoreCase(rlcRecord.Name) )
                        {
                            currentRLCRecord.currentRelatedListController.FGM_Portal__Cloned_from__c = rlcRecord.Id;
                            currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c = rlcRecord.FGM_Portal__ObjectName__c;
                            currentRLCRecord.currentRelatedListController.FGM_Portal__LookupField__c = rlcRecord.FGM_Portal__LookupField__c;
                        }
                    }
                }
            }
        }
        catch(Exception ex)
        {
            system.debug( 'Exception: ' + ex + ' @Line :: ' + ex.getLineNumber() + ' Message ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, '' + ex));
        }
    }
    public PageReference deleteQuizQuestion()
    {
        try {
            String quizQuesId = ApexPages.currentPage().getParameters().get('quizQuestionId');
            if(quizQuesId != null && String.isNotBlank(quizQuesId)){
                FGM_Portal__Quiz_Questions__c quizQues = new FGM_Portal__Quiz_Questions__c(Id = quizQuesId);
                Boolean isErrorMessage = deleteControllingFieldWithoutDependent(quizQues);
                if(isErrorMessage)
                {
                    isErrorMessage=false;
                    return null;
                }
                CrudFlsService.getInstance().assertDeletable(quizQues);
                Database.DeleteResult deleteResult = Database.delete(quizQues);
            }
            PageReference pageReference = System.Page.QuizDesignForm;
            pageReference.getParameters().put('id', quiz.Id);
            pageReference.setRedirect(true);
            return pageReference;
        }
        catch(Exception ex) {
            system.debug( 'Exception: ' + ex + ' @Line :: ' + ex.getLineNumber() + ' Message ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, '' + ex.getMessage()));
            return null;
        }
    }
}