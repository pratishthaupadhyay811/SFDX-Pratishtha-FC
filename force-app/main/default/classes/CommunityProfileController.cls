/****************************************************************************
Name : CommunityProfileController
Purpose: This class Used for the purpose of community Profile
*****************************************************************************/
public with sharing class CommunityProfileController {
    public Boolean initialized {get; set;} {initialized = false;}
    public String strObjectName;
    public String selectedTab {get; set;}
    public String tabMode {get; set;}
    public Boolean isButtonsVisible {get; set;}
    public Boolean isRelatedListTab {get; set;}
    public Boolean isRecordDetailView { get; set; }
    public String selectedTabName { get; set; }
    public relatedList relatedListConfiguration { get; set; }
    public Integer count{get; set;}
    @TestVisible private String strContactId;
    @TestVisible private String strAccountId;
    public String isEditable { get; set; }
    public Boolean isAccountEditable { get; set; }
    public Boolean iscontactEditable { get; set; }
    public Account userAccount {get; set;}
    public Contact userContact {get; set;}
    public string profileType {get; set;}
    public string portalType;
    //public string portalType { get; set; }
    public Map<integer,Schema.FieldSetMember> mapContactFields;
    public Map<Id,List<Object>> mapRelatedListRecordByTab;
    public List<Related_List_Controller__c> lstTabs{get; set;}
    public Map<String,List<Schema.FieldSetMember>> mapFieldsByTabName;
    public List<Schema.FieldSetMember> lstRelatedListObjectFields;
    public List<string> lstField;
    public List<Schema.FieldSetMember> lstFieldsName { get ; set ;}
    public Map<String,String> mapDataTypeByFields;
    private Map<String,String> mapDefaultValueByFields;
    public Map<String,Map<String,String>> mapDataTypeByTabs;
    public sobject tabObject { get; set; }
    public String portalLanguage {get; set;}
    public string strFields {get; set; }
    public list<FieldInformation> lstFieldInformation;
    public list<FieldInformation> lstAccountFieldInformation;
    public Map<String, CommunitySetting__c> mapCommunitySetting {get;set;}
    public boolean isShowOrganizationTabToOrganization { get; set; }
    public boolean isShowContactTabToOrganization { get; set; }
    public boolean isShowOrganizationTabToIndividual { get; set; }
    public boolean isShowContactTabToIndividual { get; set; }
    public object relatedListRecordObject;
    public user currentUser { get ; set ; }
    public List<UserDetails> lstUser;
    public String strDateTime { get; set; }
    public Boolean isSCPLEnable {get ; set;}
    public Map<string,string> mapRequiredField {get;set;}
    public string tabName;
    @TestVisible private Map<id,CustomHTML__c> mapCustomHtml{get;set;}
    @TestVisible
    private transient AdminContextExecutionManager adminContextExecutionMgr;

    /** 
     * Use this method to access an instance of the AdminContextExecutionManager service.
     * The instance is stored in transient AdminContextExecutionManager adminContextExecutionMgr,
     * so adminContextExecutionMgr isn't stored in the View State.
     * 
     * In unit tests, set adminContextExecutionMgr as a stub before testing getAdminContextExecutionManager().
     * @return instance of AdminContextExecutionManager service
     */
    @TestVisible
    private AdminContextExecutionManager getAdminContextExecutionManager() {
        if (this.adminContextExecutionMgr == null) {
            this.adminContextExecutionMgr = new AdminContextExecutionManager();
        }
        return this.adminContextExecutionMgr;
    } 


     public Boolean isOrgNameEditable{
        get{
            CommunitySetting__c communitySetting = CommunitySetting__c.getInstance('IsOrgNameEditable');
            if(communitySetting == NULL || communitySetting.IsEnabled__c == FALSE){
                return FALSE;
            }
            else{
                return TRUE;
            }
        }
    }

    public class FieldInformation {
        public String name {get;set;}
        public Boolean hasField {get;set;}

        public FieldInformation(String name , Boolean hasField) {
            this.Name = name ;
            this.hasField = hasField;
        }
    }

/*****************************************************************************
Purpose: This method get the parameter from url
Parameters:[String]
Returns: [String]
******************************************************************************/
    private String getParam(String name) {
         String strNameValue = ApexPages.currentPage().getParameters().get(name);
        return String.isEmpty(strNameValue)  ? strNameValue :  String.escapeSingleQuotes(strNameValue);
    }

/*****************************************************************************
Purpose: This method returns the object types
Returns: [String]
******************************************************************************/
    public String getApplicationObjectName(){
        if(tabObject != NULL){
            return  String.valueOf(tabObject.getsObjectType());
        }
        return NULL;
    }

/*****************************************************************************
Purpose: Get Fields from Account FieldSet for Profile
Parameters:[]
Returns: [List<Schema.FieldSetMember>]
******************************************************************************/
    public List<Schema.FieldSetMember> getAccountFields()  {
        if(String.isNotBlank(profileType) && profileType.equalsIgnoreCase('Individual')){
            return SObjectType.Account.FieldSets.CommunityIndividualProfile.getFields();
        }
        else{
            return SObjectType.Account.FieldSets.CommunityAccountFieldSet.getFields();
        }

    }


/*****************************************************************************
Purpose: Get Fields from Contact FieldSet for Profile.
Parameters:[]
Returns: [List<Schema.FieldSetMember>]
******************************************************************************/
    public List<Schema.FieldSetMember> getContactFields()  {
        if(String.isNotBlank(profileType) && profileType.equalsIgnoreCase('Individual')){
            return SObjectType.Contact.FieldSets.CommunityIndividualProfile.getFields();
        }
        else{
            return SObjectType.Contact.FieldSets.CommunityContactFieldSet.getFields();
        }
    }

/*****************************************************************************
Purpose: This method check For Account Contact Editable
Parameters:[]
Returns: []
******************************************************************************/
    @TestVisible private void checkForAccountContactEditable(){
        Schema.DescribeSObjectResult accountDescribe = Account.sObjectType.getDescribe();
        isAccountEditable = accountDescribe.isUpdateable();
        Schema.DescribeSObjectResult contactDescribe = Contact.sObjectType.getDescribe();
        iscontactEditable = contactDescribe.isUpdateable();
    }

/*****************************************************************************
Purpose: This method returns customHtml Description
Parameters:[]
Returns: [String]
******************************************************************************/
    public CustomHTML__c getCustomHTMLDescription(){
        if(mapCustomHtml != NULL && mapCustomHtml.size() >0) {
            return mapCustomHtml.values()[0];
        }
        return null;
    }

    // Constructor of class to get User Contact and organization Information.
    public CommunityProfileController() {
        try{
            isSCPLEnable = User.getSobjectType().getDescribe().fields.getMap().keySet().contains('countrycode');
            count=0;
            checkForAccountContactEditable();
            strContactId = '';
            strAccountId = '';
            userAccount = NULL;
            userContact = NULL;
            isShowOrganizationTabToOrganization = FALSE;
            isShowContactTabToOrganization = FALSE;
            isShowOrganizationTabToIndividual = FALSE;
            isShowContactTabToIndividual = FALSE;
            selectedTab = 'organization';  // Default seleceted Tab
            tabMode = 'readonly';            // Default tab Mode.+
            isButtonsVisible = FALSE;
            mapContactFields = new Map<integer,Schema.FieldSetMember>();
            mapRelatedListRecordByTab = new Map<Id,List<Object>>();
            mapFieldsByTabName = new Map<String,List<Schema.FieldSetMember>>();
            mapDataTypeByTabs = new Map<String,Map<String,String>>();
            mapCommunitySetting = CommunitySetting__c.getAll();
            mapRequiredField = new Map<string,string>();
            // Query to get contact Id and Account Id of User.

            currentUser = [
                SELECT
                    AccountId,
                    ContactId,
                    Name,
                    Portal_Account_Admin__c,
                    ProfileType__c,
                    UserProfile__c
                FROM User
                WHERE Id = :UserInfo.getUserId()
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            if(currentUser != NULL) {
                strContactId = currentUser.ContactId;
                strAccountId = currentUser.AccountId;
                profileType = currentUser.ProfileType__c;

                if(String.isNotBlank(currentUser.UserProfile__c)){
                    FCGlobal.UserSession currentUserSession = FCGlobal.getUserSession(String.escapeSingleQuotes(UserInfo.getUserId()));
                    if(currentUserSession != NULL && String.isNotBlank(currentUserSession.UserPortalType)){
                        portalType = currentUserSession.UserPortalType;
                    }
                }
                if(String.isNotBlank(portalType) && String.isNotBlank(currentUser.UserProfile__c)){
                    portalType = currentUser.UserProfile__c;
                }
                else{
                    portalType = 'Grantee';
                }
            }
            if(!String.IsNotBlank(profileType)){
                profileType = 'Organization';
            }

            //******* Contact
            Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Contact.fields.getMap();
            lstFieldInformation = new List<FieldInformation>();
            if(fieldMap.containsKey('mailingcountrycode')){
                lstFieldInformation.add( new FieldInformation('mailingcountrycode',TRUE));
            }
            else {
                lstFieldInformation.add( new FieldInformation('mailingcountry',TRUE));
            }
            if(fieldMap.containsKey('mailingstatecode')){
                lstFieldInformation.add( new FieldInformation('mailingstatecode',TRUE));
            }
            else{
                lstFieldInformation.add( new FieldInformation('mailingstate',TRUE));
            }
            if(fieldMap.containsKey('othercountrycode')){
                lstFieldInformation.add( new FieldInformation('othercountrycode',TRUE));
            }
            else {
                lstFieldInformation.add( new FieldInformation('othercountry',TRUE));
            }
            if(fieldMap.containsKey('otherstatecode')){
                lstFieldInformation.add( new FieldInformation('otherstatecode',TRUE));
            }
            else{
                lstFieldInformation.add( new FieldInformation('otherstate',TRUE));
            }
            //******* Account
            Map<String, Schema.SObjectField> mapAccountfields = Schema.SObjectType.Account.fields.getMap();
            Set<String> setAccFieldKey = mapAccountfields.keySet();
            lstAccountFieldInformation = new List<FieldInformation>();
            if(mapAccountfields.containsKey('billingcountrycode')){
                lstAccountFieldInformation.add( new FieldInformation('billingcountrycode',TRUE));
            }
            else {
                lstAccountFieldInformation.add( new FieldInformation('billingcountry',TRUE));
            }

            if(mapAccountfields.containsKey('billingstatecode')){
                lstAccountFieldInformation.add( new FieldInformation('billingstatecode',TRUE));
            }
            else{
                lstAccountFieldInformation.add( new FieldInformation('billingstate',TRUE));
            }
            if(mapAccountfields.containsKey('Shippingcountrycode')){
                lstAccountFieldInformation.add( new FieldInformation('Shippingcountrycode',TRUE));
            }
            else {
                lstAccountFieldInformation.add( new FieldInformation('Shippingcountry',TRUE));
            }

            if(mapAccountfields.containsKey('Shippingstatecode')){
                lstAccountFieldInformation.add( new FieldInformation('Shippingstatecode',TRUE));
            }
            else{
                lstAccountFieldInformation.add( new FieldInformation('Shippingstate',TRUE));
            }
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
        }
    }

/*****************************************************************************
Purpose: This method initialize the community profile tab
Parameters:[]
Returns: [void]
******************************************************************************/
    public void initialize() {
        initialized = true;
        try{
            string orgTab;
            string contactTab;
            FCGlobal.UserSession userSession = FCGlobal.getUserSession(String.escapeSingleQuotes(UserInfo.getUserId()));
            portalLanguage = userSession.UserLanguage;
            FCGlobal.setUserLanguage(String.escapeSingleQuotes(UserInfo.getUserId()),portalLanguage);
            // To get Multilanguage DateTime format
            Map<String, String> mappedValues = new Map<String, String>(); //map for holding locale to datetime format
            mappedValues = FCGlobal.getDateFormat();
            if (mappedValues.containsKey(portalLanguage)) { //if the map contains the correct datetime format
                strDateTime = mappedValues.get(portalLanguage); //grab the datetime format for the locale
            }

            set<String> setUserTypes = new set<String>(currentUser.UserProfile__c.split(';'));
            string strUserType = '';
            string strCustomHtmlRecordName = '';
            if(setUserTypes.contains('Grantee')){
                strUserType = 'Grantee';
                strCustomHtmlRecordName = 'GranteeProfile';
            }
            else if(setUserTypes.contains('Reviewer')){
                strUserType = 'Reviewer';
                strCustomHtmlRecordName = 'ReviewerProfile' ;
            }

            mapCustomHtml = new Map<Id, CustomHTML__c>([
                SELECT
                    RichDescription__c,
                    Language__c,
                    Name
                FROM CustomHTML__c
                WHERE Associated_FC_Portal_Type__c = :strUserType
                AND Name = :strCustomHtmlRecordName
                AND Language__c = :portalLanguage
                WITH SECURITY_ENFORCED
                LIMIT 1
            ]);

            lstTabs = new List<Related_List_Controller__c>();
            initializeTabs();
            //** Hide and Show tab
            if(mapCommunitySetting != NULL && mapCommunitySetting.size() > 0){
                // Grantee
                if(portalType.contains('Grantee') && profileType == 'Organization'){
                    if(mapCommunitySetting.get('ShowOrganizationTabToGranteeOrg') != NULL){
                        isShowOrganizationTabToOrganization = mapCommunitySetting.get('ShowOrganizationTabToGranteeOrg').IsEnabled__c;
                    }
                    if(mapCommunitySetting.get('ShowContactTabToGranteeOrg') != NULL){
                        isShowContactTabToOrganization = mapCommunitySetting.get('ShowContactTabToGranteeOrg').IsEnabled__c;
                    }
                }

                else if(portalType.contains('Grantee') && profileType == 'Individual') {
                    if(mapCommunitySetting.get('ShowOrganizationTabToGranteeInd') != NULL){
                        isShowOrganizationTabToIndividual = mapCommunitySetting.get('ShowOrganizationTabToGranteeInd').IsEnabled__c;
                    }
                    if(mapCommunitySetting.get('ShowContactTabToGranteeInd') != NULL){
                        isShowContactTabToIndividual = mapCommunitySetting.get('ShowContactTabToGranteeInd').IsEnabled__c;
                    }
                }
                //end grantee
                // Reviewer
                if(portalType.contains('Reviewer') && profileType == 'Organization'){
                    if(mapCommunitySetting.get('ShowOrganizationTabToReviwerOrg') != NULL){
                        isShowOrganizationTabToOrganization = mapCommunitySetting.get('ShowOrganizationTabToReviwerOrg').IsEnabled__c;
                    }
                    if(mapCommunitySetting.get('ShowContactTabToReviwerOrg') != NULL){
                        isShowContactTabToOrganization = mapCommunitySetting.get('ShowContactTabToReviwerOrg').IsEnabled__c;
                    }
                }
                else if(portalType.contains('Reviewer') && profileType == 'Individual'){
                    if(mapCommunitySetting.get('ShowOrganizationTabToReviwerInd') != NULL){
                        isShowOrganizationTabToIndividual = mapCommunitySetting.get('ShowOrganizationTabToReviwerInd').IsEnabled__c;
                    }
                    if(mapCommunitySetting.get('ShowContactTabToReviwerInd') != NULL){
                        isShowContactTabToIndividual = mapCommunitySetting.get('ShowContactTabToReviwerInd').IsEnabled__c;
                    }
                }
                // reviewer End

                // Consultant
                if(portalType.contains('Consultant') && profileType == 'Organization'){
                    if(mapCommunitySetting.get('ShowOrganizationTabToConsultantOrg') != NULL){
                        isShowOrganizationTabToOrganization = mapCommunitySetting.get('ShowOrganizationTabToConsultantOrg').IsEnabled__c;
                    }
                    if(mapCommunitySetting.get('ShowContactTabToConsultantOrg') != NULL){
                        isShowContactTabToOrganization = mapCommunitySetting.get('ShowContactTabToConsultantOrg').IsEnabled__c;
                    }
                }
                //end consultant

                Id amendId = getParam('amendment');
                if(amendId != NULL && String.isNotBlank(amendId)){
                    Schema.SObjectType sobjectType = amendId.getSObjectType();
                    tabName = sobjectType.getDescribe().getName();
                }

                if(profileType == 'Organization') {
                    getObjectRecordAsPerUserProfile(isShowOrganizationTabToOrganization,isShowContactTabToOrganization);
                }
                if(profileType == 'Individual') {
                    getObjectRecordAsPerUserProfile(isShowOrganizationTabToIndividual,isShowContactTabToIndividual);
            }


            if(isSCPLEnable){
                List<Schema.FieldSetMember> fieldset;
                if(selectedTab == 'contact'){
                    fieldset =  getContactFields();
                }
                if(selectedTab == 'organization'){
                    fieldset = getAccountFields();
                }
                if(fieldset!=NULL){
                    for(Schema.FieldSetMember field : fieldset){
                        if(field.getDBRequired() || field.getRequired()){
                            mapRequiredField.put(field.getFieldPath(),field.getLabel());
                        }
                    }
                }
            }
          }
        }
        catch(Exception ex) {
            ApexPages.addMessages(ex);
        }
    }

/*****************************************************************************
Purpose: This method initialize the character counter
Parameters:[]
Returns: [void]
******************************************************************************/
    public void initializeCharCount() {
        if(lstTabs != NULL && String.isNotBlank(selectedTab)){
            for(Related_List_Controller__c tabRecord : lstTabs){
                if(selectedTab == String.valueOf(tabRecord.Id)){
                    strObjectName = tabRecord.ObjectName__c;
                }
            }
            strFields=JSON.serialize(FCGlobal.getFieldLengthMap(strObjectName));
        }
    }

/*****************************************************************************
Purpose: This method used to get object record as per user profile
Parameters:[Boolean,Boolean]
Returns: [void]
******************************************************************************/
     public void getObjectRecordAsPerUserProfile(Boolean isOrganization,Boolean isContact){
                if(isOrganization && isContact){
                        isButtonsVisible = TRUE;
                        if(tabName != NULL && String.isNotBlank(tabName)){
                            if(tabName == 'Account'){
                                selectedTab = 'organization';
                                userAccount = getAccountRecord();
                            }
                            else{
                                selectedTab = 'contact';
                                userContact = getContactrecord();
                            }
                        }
                        else{
                            selectedTab = 'organization';
                            userAccount = getAccountRecord();
                        }
                    }
                    else if(isOrganization && !isContact) {
                        isButtonsVisible = TRUE;
                        selectedTab = 'organization';
                        userAccount = getAccountRecord();
                    }
                    else if(!isOrganization && isContact){
                        isButtonsVisible = TRUE;
                        selectedTab = 'contact';
                        userContact = getContactrecord();
                    }
                    else if(!isOrganization && !isContact && lstTabs != NULL && lstTabs.size() > 0){
                        isButtonsVisible = TRUE;
                        selectedTab = lstTabs[0].Id;
                        initializeRelatedListTab();
                    }
            }
/*****************************************************************************
Purpose: This method used to get tab record
Parameters:[]
Returns: [void]
******************************************************************************/
    public void initializeTabs() {
        try{
            String activeTabField ='';
            if(profileType == 'Organization'){
                activeTabField = 'Show_Tab_to_Organization_Users__c = TRUE';
            }
            if(profileType == 'Individual'){
                activeTabField = 'Show_Tab_to_Individual_Users__c = TRUE';
            }
            List<string> userProfile = new List<string>();
            for(string prtltyp : portalType.split(';')){
                userProfile.add(prtltyp);
            }

            List<String> lstFields = New List<String>{'Name','RecordTypeId','FGM_Portal__Associated_FC_Portal_Type__c','FGM_Portal__Associated_Tab_Type__c','FGM_Portal__Hide_Edit_Link__c',
                'FGM_Portal__RichInstructionalText__c','FGM_Portal__FieldNames__c','FGM_Portal__FieldHeaders__c','FGM_Portal__ShowDeleteLink__c','FGM_Portal__ShowNewButton__c','FGM_Portal__SortField__c','FGM_Portal__EnableAmendment__c','FGM_Portal__SortFieldOrder__c',
                'FGM_Portal__ObjectName__c','FGM_Portal__ParentObject__c','FGM_Portal__LookupField__c','FGM_Portal__Show_Tab_to_Individual_Users__c','FGM_Portal__Show_Tab_to_Organization_Users__c'
                };

            String query = 'SELECT Id,' ;
            query +=  String.join(lstFields,',');
            query += ' FROM Related_List_Controller__c WHERE Associated_Tab_Type__c = \'Profile\' AND Associated_FC_Portal_Type__c IN :userProfile';
            query += ' AND Language__c =: portalLanguage AND ';
            query += activeTabField ;
            query += ' WITH SECURITY_ENFORCED';
            query += ' ORDER BY SortOrder__c ASC NULLS LAST LIMIT 10000' ;
            lstTabs = Database.query(query);
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
        }
    }

/*****************************************************************************
Purpose: This method used to initialize the related list tab
Parameters:[]
Returns: [void]
******************************************************************************/
    public void initializeRelatedListTab(){
        try{
            mapDataTypeByFields = new Map<String,String>();
            mapDefaultValueByFields = new Map<String,String>();
            lstFieldsName  = new List<Schema.FieldSetMember> ();
            relatedListConfiguration = NULL;
            isRelatedListTab = TRUE;
            isRecordDetailView = FALSE;
            tabMode = 'readonly';
            tabObject = NULL;
            String strSelectedTabId = getParam('tabId');
            if(String.isNotBlank(strSelectedTabId)){
                selectedTab = strSelectedTabId;
            }
            Related_List_Controller__c tabRecord = getTabRecord();
            if(tabRecord != NULL){
                selectedTabName = tabRecord.Name;
                if(String.isNotBlank(tabRecord.FieldHeaders__c) && String.isNotBlank(tabRecord.FieldNames__c)){
                    relatedListConfiguration = new relatedList();
                    relatedListConfiguration.record =  tabRecord;
                    relatedListConfiguration.strRelatedListObject = tabRecord.ObjectName__c;
                    relatedListConfiguration.isCreatable = tabRecord.ShowNewButton__c;
                    relatedListConfiguration.isEditable = !tabRecord.Hide_Edit_Link__c;
                    relatedListConfiguration.isDeletable = tabRecord.ShowDeleteLink__c;
                    relatedListConfiguration.mapColumnFields =  FCGLobal.getrelatedListColumn(tabRecord);
                    relatedListConfiguration.listColumnFields = tabRecord.FieldHeaders__c.split(',');
                    relatedListConfiguration.relatedListLookUp =  tabRecord.LookupField__c;
                    relatedListConfiguration.isAmendmentEnable = (tabRecord.EnableAmendment__c && tabRecord.Hide_Edit_Link__c);

                    if(!relatedListConfiguration.mapColumnFields.isEmpty()){
                        relatedListConfiguration.lstRelatedListRecord = getRelatedListRecords(tabRecord,new Set<String>(relatedListConfiguration.mapColumnFields.values()));
                    }
                }
            }
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
        }
    }

 /*****************************************************************************
Purpose: To Get RelatedList Records the tab Records
Parameters:[Related_List_Controller__c,Set<String>]
Returns: [ List<Object>]
******************************************************************************/
    @TestVisible private List<Object> getRelatedListRecords(Related_List_Controller__c relatedListController, Set<String> setFields){
        try{
            List<Object> lstSobject = new List<Object>();
            // code to get the fields from FieldSet which will used while record Details Page.
            List<String> lstFieldSetFields = getFieldsFromFieldSet(relatedListController.ObjectName__c,relatedListController.Name);
            if(lstFieldSetFields != NULL && !lstFieldSetFields.isEmpty()){
                for(String field : lstFieldSetFields){
                    if(!setFields.contains(field)){
                        setFields.add(field);
                    }
                }
            }
            String sortOredrField  = relatedListController.FGM_Portal__SortField__c;
            String order;
            if(relatedListController.FGM_Portal__SortFieldOrder__c !=null)
               order = relatedListController.FGM_Portal__SortFieldOrder__c == 'Ascending' ? 'ASC' : 'DESC';
            if(mapRelatedListRecordByTab != NULL && mapRelatedListRecordByTab.containsKey(relatedListController.Id)){
                if(String.isNotBlank(relatedListController.ObjectName__c)) {
                    if(setFields != NULL && !setFields.isEmpty()){
                        Object[] childObject = NULL;
                        String childQuery = '' ;
                        List<String> sanitizedFields = new List<String>();
                        for (String f : setFields) {
                            sanitizedFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                        }
                        String sanitizedObjectName = relatedListController.ObjectName__c.replaceAll('[^0-9a-zA-Z_.]', '');
                        if(String.isNotBlank(relatedListController.ParentObject__c) && String.isNotBlank(relatedListController.LookupField__c)){
                            String sanitizedLookupField = relatedListController.LookupField__c.replaceAll('[^0-9a-zA-Z_.]', '');
                            String sanitizedParentObject = relatedListController.ParentObject__c.replaceAll('[^0-9a-zA-Z_.]', '');
                            childQuery += 'SELECT ';
                            childQuery += String.join(new List<String>(sanitizedFields), ', ') ;
                            childQuery += ' FROM  '+ sanitizedObjectName;
                            childQuery += ' WHERE '+ sanitizedLookupField;
                            childQuery += ' IN (SELECT Id From ' + sanitizedParentObject;
                            childQuery += ' Where Id =:strAccountId)';
                            childQuery += ' WITH SECURITY_ENFORCED';
                                if(sortOredrField !=null && !String.isBlank(sortOredrField)){
                                    String sanitizedOredrField = sortOredrField.replaceAll('[^0-9a-zA-Z_.]', '');
                                    childQuery = childQuery + ' ORDER BY '+sanitizedOredrField+' ';
                                    if(order !=null )
                                        childQuery = childQuery +' '+ order;
                                }
                            childQuery += ' LIMIT 10000' ;
                            childObject = Database.query(childQuery);
                        }
                        else{
                            childQuery += 'SELECT  ';
                            childQuery += String.join(new List<String>(sanitizedFields), ', ') ;
                            childQuery += '  FROM  '+ sanitizedObjectName;
                            childQuery += ' WITH SECURITY_ENFORCED';
                            if(sortOredrField !=null && !String.isBlank(sortOredrField)){
                                String sanitizedOredrField = sortOredrField.replaceAll('[^0-9a-zA-Z_.]', '');
                                childQuery = childQuery + ' ORDER BY '+sanitizedOredrField+' ';
                                if(order !=null )
                                    childQuery = childQuery +' '+ order;
                            }
                            childQuery += ' LIMIT 10000' ;
                            childObject = Database.query(childQuery);
                        }
                        if(childObject != NULL && !childObject.isEmpty()){
                            lstSobject.addAll(childObject);
                        }
                    }
                }
                if(lstSobject != NULL && !lstSobject.isEmpty()){
                    mapRelatedListRecordByTab.put(relatedListController.Id,lstSobject);
                }
                lstSobject = mapRelatedListRecordByTab.get(relatedListController.Id);
            }
            else{
                lstSobject = new List<Object>();
                Map<String,String> mapFields =  FCGlobal.getsObjectFields(relatedListController.ObjectName__c,NULL);
                if(mapFields == NULL && mapFields.isEmpty()){
                    return lstSobject;
                }

                if(String.isNotBlank(relatedListController.ObjectName__c)) {
                    if(setFields != NULL && !setFields.isEmpty()){
                        Object[] childObject = NULL;
                        String childQuery = '';
                        List<String> sanitizedFields = new List<String>();
                        for (String f : setFields) {
                            sanitizedFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                        }
                        String sanitizedObjectName = relatedListController.ObjectName__c.replaceAll('[^0-9a-zA-Z_.]', '');
                        if(String.isNotBlank(relatedListController.ParentObject__c) && String.isNotBlank(relatedListController.LookupField__c)){
                            String sanitizedLookupField = relatedListController.LookupField__c.replaceAll('[^0-9a-zA-Z_.]', '');
                            String sanitizedParentObject = relatedListController.ParentObject__c.replaceAll('[^0-9a-zA-Z_.]', '');
                            childQuery += 'SELECT ';
                            childQuery += String.join(new List<String>(sanitizedFields), ', ') ;
                            childQuery += ' FROM '+ sanitizedObjectName;
                            childQuery += ' WHERE '+ sanitizedLookupField;
                            childQuery += ' IN (SELECT Id FROM ' + sanitizedParentObject;
                            childQuery += ' WHERE ID =:strAccountId)' ;
                            childQuery += ' WITH SECURITY_ENFORCED';
                            if(sortOredrField !=null && !String.isBlank(sortOredrField)){
                                String sanitizedOredrField = sortOredrField.replaceAll('[^0-9a-zA-Z_.]', '');
                                childQuery = childQuery + ' ORDER BY '+sanitizedOredrField+' ';
                                if(order !=null )
                                    childQuery = childQuery +' '+ order;
                            }
                            childObject = Database.query(childQuery);
                        }
                        else{
                            childQuery += 'SELECT ';
                            childQuery += String.join(new List<String>(sanitizedFields), ', ') ;
                            childQuery += '  FROM  '+ sanitizedObjectName;
                            childQuery += ' WITH SECURITY_ENFORCED';
                            if(sortOredrField !=null && !String.isBlank(sortOredrField)){
                                String sanitizedOredrField = sortOredrField.replaceAll('[^0-9a-zA-Z_.]', '');
                                childQuery = childQuery + ' ORDER BY '+sanitizedOredrField+' ';
                                if(order !=null )
                                    childQuery = childQuery +' '+ order;
                            }
                            childQuery += ' LIMIT 10000' ;
                            childObject = Database.query(childQuery);
                        }
                        if(childObject != NULL && !childObject.isEmpty()){
                            lstSobject.addAll(childObject);
                        }
                    }
                }
                if(lstSobject != NULL && !lstSobject.isEmpty()){
                    mapRelatedListRecordByTab.put(relatedListController.Id,lstSobject);
                }
            }
            return lstSobject;
        }
        catch(Exception ex) {
            ApexPages.addMessages(ex) ;
            return NULL ;
        }
    }

 /*****************************************************************************
Purpose: this method used to get the tab record
Parameters:[]
Returns: [ Related_List_Controller__c]
******************************************************************************/
    @TestVisible
    private Related_List_Controller__c getTabRecord(){
        if(String.isNotBlank(selectedTab) && lstTabs != NULL && !lstTabs.isEmpty()){
            for(Related_List_Controller__c tabRecord : lstTabs){
                if(selectedTab.equalsIgnoreCase(String.valueOf(tabRecord.Id))){
                    return tabRecord;
                }
            }
        }
        return NULL;
    }

/*****************************************************************************
Purpose: this method used to Create Amendment Record
Parameters:[]
Returns: [ PageReference]
******************************************************************************/
    public PageReference createAmendmentRecord(){
        try{
            String objectName;
            String recordTypeId;
            Amendment__c amendment;
            PageReference reference = System.Page.FCRecord;
            if(selectedTab.toLowerCase() == 'organization'){
                objectName = FCGlobal.getObjectLabelById(strAccountId);
                recordTypeId = FCGlobal.getRecordTypeId(String.valueOf(Amendment__c.getsObjectType()),'Organization');
                amendment = new Amendment__c();
                amendment.RecordTypeId = recordTypeId;
                amendment.Account__c = strAccountId;
                reference.getParameters().put('ParentId',strAccountId);
            }
            if(selectedTab.toLowerCase() == 'contact'){
                objectName = FCGlobal.getObjectLabelById(strContactId);
                recordTypeId = FCGlobal.getRecordTypeId(String.valueOf(Amendment__c.getsObjectType()),'Contact');
                amendment = new Amendment__c();
                amendment.RecordTypeId = recordTypeId;
                amendment.Contact__c = strContactId;
                reference.getParameters().put('ParentId',strContactId);
            }
            CrudFlsService.getInstance().assertCreateable(amendment);
            Database.insert(NEW List<Amendment__c>{amendment}, false);
            reference.getParameters().put('Id',amendment.Id);
            reference.getParameters().put('RecordTypeId',recordTypeId);
            reference.getParameters().put('from','profile');
            reference.getParameters().put('mode','edit');
            reference.setRedirect(TRUE);
            return reference;
        }
        catch(Exception ex){
            ApexPages.addMessages(ex) ;
            return NULL ;
        }
    }

/*****************************************************************************
Purpose: To get Related List new Record for related List.
Parameters:[]
Returns: [ void]
******************************************************************************/
    public void getNewRelatedListRecord(){
        try{
            initializeCharCount();
            Related_List_Controller__c tabrecord = getTabRecord();
            if(relatedListConfiguration != NULL && String.isNotBlank(relatedListConfiguration.strRelatedListObject) && tabrecord != NULL){
                object newRelatedListRecord = FCGlobal.getNewSobject(relatedListConfiguration.strRelatedListObject);
                SObject objectWithDefaults = FCGlobal.getNewSObject(relatedListConfiguration.strRelatedListObject, true);

                if(newRelatedListRecord != NULL){
                    isRecordDetailView = TRUE;
                    tabMode = 'edit';
                    tabObject = (sobject) newRelatedListRecord;
                    if(String.IsnOtBlank(relatedListConfiguration.relatedListLookUp)){
                        tabObject.put(relatedListConfiguration.relatedListLookUp,strAccountId);
                        Set<String> defaultKey = mapDefaultValueByFields.keySet();
                        for(String e : defaultKey) {
                            if(mapDefaultValueByFields.get(e) != null) {
                                tabObject.put(e, objectWithDefaults.get(e));
                            }
                        }
                    }
                    lstField = getFieldsFromFieldSet(tabrecord.ObjectName__c,tabrecord.Name);
                }
            }
        }
        catch(Exception ex){
            ApexPages.addMessages(ex) ;
        }
    }

/*****************************************************************************
Purpose: This method used to get fields from Field set
Parameters:[String,String]
Returns: [ List<String> ]
******************************************************************************/
    Public List<String> getFieldsFromFieldSet(String objectName, String fieldSetName){
        try{
            List<String> fields = new List<String>();
            lstFieldsName = new List<Schema.FieldSetMember>();
            mapDataTypeByFields = new Map<String,String>();
            mapDefaultValueByFields = new Map<String,String>();
            if(mapFieldsByTabName != NULL && mapFieldsByTabName.containsKey(fieldSetName) && mapDataTypeByTabs != NULL && mapDataTypeByTabs.containsKey(fieldSetName) ){
                for(Schema.FieldSetMember fieldSetMemeber: mapFieldsByTabName.get(fieldSetName)){
                    fields.add(fieldSetMemeber.getFieldPath());
                    lstFieldsName.add(fieldSetMemeber);
                    mapDefaultValueByFields.put(fieldSetMemeber.getFieldPath(), getDefaultFieldValue(fieldSetMemeber));
                }
                mapDataTypeByFields = mapDataTypeByTabs.get(fieldSetName);
            }
            else{
                fields = new List<String>();
                if(String.isNotBlank(objectName) && String.isNotBlank(fieldSetName)){
                    Map<String, Schema.SObjectType> mapGlobalDescribe = Schema.getGlobalDescribe();
                    Schema.SObjectType objectSobjectType = mapGlobalDescribe.get(objectName);
                    if(objectSobjectType == NULL){
                        return fields;
                    }
                    Schema.DescribeSObjectResult objectDescribeSObjectResult = objectSobjectType.getDescribe();
                    Map<String,Schema.FieldSet> mapfieldSetObj = objectDescribeSObjectResult.FieldSets.getMap();
                    if(mapfieldSetObj == NULL || mapfieldSetObj.isEmpty()){
                        return fields;
                    }
                    Schema.FieldSet fieldSetObj = NULL;
                    for(Schema.FieldSet fieldset : mapfieldSetObj.values()){
                        if(FieldSetName.equalsIgnoreCase(fieldset.getLabel())){
                            fieldSetObj = fieldset;
                            break;
                        }
                    }

                    if(fieldSetObj == NULL){
                        return fields;
                    }
                    List<Schema.FieldSetMember> fieldSetMemberList =  fieldSetObj.getFields();
                    if(fieldSetMemberList != NULL){
                        for(Schema.FieldSetMember fieldSetMemeber : fieldSetMemberList){
                            lstFieldsName.add(fieldSetMemeber);
                            fields.add(fieldSetMemeber.getFieldPath());
                            mapDataTypeByFields.put(fieldSetMemeber.getFieldPath(),String.valueOf(fieldSetMemeber.getType()));
                            mapDefaultValueByFields.put(fieldSetMemeber.getFieldPath(), getDefaultFieldValue(fieldSetMemeber));
                        }
                    }
                }
                if(fields != NULL && !fields.isEmpty()){
                    mapFieldsByTabName.put(fieldSetName,lstFieldsName);
                    mapDataTypeByTabs.put(fieldSetName,mapDataTypeByFields);
                }
            }
            return fields;
        }
        catch(Exception ex){
            ApexPages.addMessages(ex) ;
            return NULL ;
        }
    }

/*****************************************************************************
Purpose: To Refersh the tab Records
Parameters:[Id]
Returns: [void]
******************************************************************************/
    // To Refersh the tab Records
    @TestVisible private void removeRecordsFromMap(Id tabID){
        if(tabID != NULL){
            if(mapRelatedListRecordByTab != NULL && mapRelatedListRecordByTab.containsKey(tabID)){
                mapRelatedListRecordByTab.remove(tabID);
            }
        }
    }

/*****************************************************************************
Purpose: This method used to delete tab record
Parameters:[]
Returns: [ void ]
******************************************************************************/
    public void deleteTabRecord(){
        try{
            sObject selectedRecord = getSelectedTabObject();
            Related_List_Controller__c tabrecord = getTabRecord();
            if(selectedRecord != NULL && tabrecord != NULL){
                tabObject = selectedRecord;
                isRecordDetailView = FALSE;
                tabMode = 'readonly';
                CrudFlsService.getInstance().assertDeletable(tabObject);
                Database.delete(NEW List<sObject>{tabObject}, false);
                Integer intRecordIndex =Integer.valueOf(getParam('recordIndex'));
                relatedListConfiguration.lstRelatedListRecord.remove(intRecordIndex);
            }
        }
        catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
    }

/*****************************************************************************
Purpose: This method used to view tab record
Parameters:[]
Returns: [ void ]
******************************************************************************/
    public void viewTabRecord(){
        try{
            sObject selectedRecord = getSelectedTabObject();
            Related_List_Controller__c tabrecord = getTabRecord();
            if(selectedRecord != NULL && tabrecord != NULL){
                tabObject = selectedRecord;
                isRecordDetailView = TRUE;
                tabMode = 'readonly';
                lstField = getFieldsFromFieldSet(tabrecord.ObjectName__c,tabrecord.Name);
            }
        }
        catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
    }

/*****************************************************************************
Purpose: This method used to edit tab record
Parameters:[]
Returns: [ void ]
******************************************************************************/
    public void editTabRecord(){
        try{
            initializeCharCount();
            sObject selectedRecord = getSelectedTabObject();
            Related_List_Controller__c tabrecord = getTabRecord();
            if(selectedRecord != NULL && tabrecord != NULL){

                tabObject = selectedRecord;
                isRecordDetailView = TRUE;
                tabMode = 'edit';
                lstField = getFieldsFromFieldSet(tabrecord.ObjectName__c,tabrecord.Name);
            }
        }
        catch(Exception ex){
            ApexPages.addMessages(ex) ;
        }
    }

/*****************************************************************************
Purpose: This method used to save amendment record
Parameters:[]
Returns: [ PageReference ]
******************************************************************************/
    public PageReference saveAmendmentRecord(){
        try {
            String parentIdForAmendment = ID.valueOf(getParam('ParentId'));
            if(String.isNotBlank(parentIdForAmendment)){
                PageReference reference = System.Page.FCRecord;
                String objectName = FCGlobal.getObjectLabelById(parentIdForAmendment);
                String objectAPIName = FCGlobal.getObjectNameById(parentIdForAmendment);
                String recordTypeId = FCGlobal.getRecordTypeId(String.valueOf(Amendment__c.getsObjectType()),objectName);
                String parentObjLookup = FCGlobal.getRelationalField(Id.valueOf(parentIdForAmendment).getSObjectType(), Amendment__c.sObjectType);
                if(recordTypeId != NULL && String.isNotBlank(recordTypeId)){
                    if(parentObjLookup != NULL && String.isNotBlank(parentObjLookup)){
                        Amendment__c amendment = new Amendment__c();
                        amendment.RecordTypeId = recordTypeId;
                        amendment.put(parentObjLookup,parentIdForAmendment);
                        CrudFlsService.getInstance().assertCreateable(amendment);
                        Database.insert(NEW List<Amendment__c>{amendment}, false);
                        reference.getParameters().put('Id',amendment.Id);
                        reference.getParameters().put('ParentId',parentIdForAmendment);
                        reference.getParameters().put('RecordTypeId',recordTypeId);
                        reference.getParameters().put('mode','edit');
                        reference.setRedirect(TRUE);
                        return reference;
                    }
                    else{
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, System.Label.FC_Lookup_Relationship_Amendment_Message + ' : ' + objectName));
                        return NULL ;
                    }
                }
                else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, System.Label.FC_RecordType_On_Amendment_Message + ' : ' + objectName));
                    return NULL ;
                }
            }
            return NULL;
        }
        catch(Exception ex){
            ApexPages.addMessages(ex) ;
            return NULL ;
        }
    }

/*****************************************************************************
Purpose: This method used to get the selected tab object
Parameters:[]
Returns: [ sObject ]
******************************************************************************/
    public sObject getSelectedTabObject(){
        try{
            String strRecordIndex = getParam('recordIndex');
            if(relatedListConfiguration != NULL && String.isNotBlank(relatedListConfiguration.strRelatedListObject) && String.isNotBlank(strRecordIndex)){
                integer recordIndex = integer.valueOf(strRecordIndex);
                if(recordIndex != NULL && string.isNotBlank(relatedListConfiguration.strRelatedListObject) && recordIndex < relatedListConfiguration.lstRelatedListRecord.size()){
                    object oldRelatedlistRecord = relatedListConfiguration.lstRelatedListRecord[recordIndex];
                    if(oldRelatedlistRecord != NULL){
                        sobject record = (sobject)oldRelatedlistRecord;
                        if(record == NULL){
                            return NULL;
                        }
                        return record;
                    }
                }
            }
            return NULL;
        }
        catch(Exception ex) {
            ApexPages.addMessages(ex) ;
            return NULL ;
        }
    }

/*****************************************************************************
Purpose: To get the User account record.
Parameters:[]
Returns: [ Account ]
******************************************************************************/
    // To get the User account record.
    public Account getAccountRecord() {
        try{
           strObjectName='Account';
            strAccountId = userContact != NULL ? userContact.AccountId : currentUser.AccountId;
            if((userAccount == NULL && String.isNotBlank(strAccountId)) || (tabMode == 'readonly' && tabObject == NULL)) {
                // Get all account fields from field set
                List<String> lstAccountFields = new List<String>();
                //Create dynamic query to get User Account Details
                //Map<String, Schema.SObjectField> mapAccfields = Schema.SObjectType.Account.fields.getMap();
                //Set<String> setAccFieldKey = mapAccfields.keySet();
                //lstAccountFields.addAll(setAccFieldKey);

                Set<String> setAccFields = new Set<String>();
                for(Schema.FieldSetMember fldsetmembet : SObjectType.Account.FieldSets.CommunityAccountFieldSet.getFields())
                {
                    setAccFields.add(fldsetmembet.getFieldPath());
                }
                for(Schema.FieldSetMember fldsetmembet : SObjectType.Account.FieldSets.CommunityIndividualProfile.getFields())
                {
                    setAccFields.add(fldsetmembet.getFieldPath());
                }
                if(isSCPLEnable)
                {
                    setAccFields.addALL(new List<String>{'BillingCountryCode','BillingStateCode','ShippingCountryCode','ShippingStateCode'});
                }

                if(setAccFields != NULL && setAccFields.size() > 0) {
                    List<String> sanitizedAccFields = new List<String>();
                    for (String f : setAccFields) {
                        sanitizedAccFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                    }
                    String accQuery = '';
                    accQuery += 'SELECT ';
                    accQuery += String.join(new List<String>(sanitizedAccFields), ', ') ;

                    accQuery += ' FROM Account' ;
                    accQuery += ' WHERE Id= :strAccountId WITH SECURITY_ENFORCED LIMIT 1';
                    Account[] userAccountList = (List<Account>) Database.query(accQuery);
                    if(!userAccountList.isEmpty()){
                        userAccount =  userAccountList[0];
                    }
                }
            }
            return userAccount;
        }
        catch(DmlException ex){
            ApexPages.addMessages(ex);
            return NULL;
        }
    }

/*****************************************************************************
Purpose: To get the User Contact record
Parameters:[]
Returns: [ Contact ]
******************************************************************************/
    public Contact getContactRecord() {
        try{
            strObjectName='Contact';
            if((userContact == NULL && String.isNotBlank(strContactId )) || (tabMode == 'readonly' && tabObject == NULL))  {
                // Get all account fields from field set
                //List<String> lstContactFields = new List<String>();
                /*for(Schema.FieldSetMember field : getContactFields()) {
                    lstContactFields.add(field.getFieldPath());
                }*/
                //Create dynamic query to get User Contact Details

                 Set<String> setContactFields = new Set<String>();
                for(Schema.FieldSetMember fldsetmembet : SObjectType.Contact.FieldSets.CommunityContactFieldSet.getFields())
                {
                    setContactFields.add(fldsetmembet.getFieldPath());
                }
                for(Schema.FieldSetMember fldsetmembet : SObjectType.Contact.FieldSets.CommunityIndividualProfile.getFields())
                {
                    setContactFields.add(fldsetmembet.getFieldPath());
                }
                setContactFields.add('AccountId');
                if(isSCPLEnable)
                {
                    setContactFields.addALL(new List<String>{'MailingCountryCode','MailingStateCode','OtherCountryCode','OtherStateCode'});
                }

               // Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Contact.fields.getMap();
               // Set<String> fieldKeySet = fieldMap.keySet();
                if(setContactFields != NULL && setContactFields.size() > 0) {
                    String contactQuery = '';
                    contactQuery += 'SELECT ';
                    contactQuery += String.join(new List<String>(setContactFields), ', ') ;
                    contactQuery += '  FROM Contact';
                    contactQuery += ' WHERE Id= :strContactId WITH SECURITY_ENFORCED LIMIT 1' ;
                    Contact[] userContactlist = (List<Contact>) Database.query(contactQuery);
                    if(!userContactlist.isEmpty()){
                        userContact =  userContactlist[0];
                    }
                }
            }
            return userContact;
        }
        catch(DmlException ex){
            ApexPages.addMessages(ex);
            return NULL;
        }
    }

/*****************************************************************************
Purpose: To map of required fields from account or contact field set
Parameters:[]
Returns: [ void ]
******************************************************************************/
    public void initializeMapRequiredFields(){
        if(isSCPLEnable){
            mapRequiredField.clear();
            List<Schema.FieldSetMember> fieldset;
            if(selectedTab == 'contact'){
                fieldset =  getContactFields();
            }
            if(selectedTab == 'organization'){
                fieldset = getAccountFields();
            }
            if(fieldset!=NULL){
                for(Schema.FieldSetMember field : fieldset){
                    if(field.getDBRequired() || field.getRequired()){
                        mapRequiredField.put(field.getFieldPath(),field.getLabel());
                    }
                }
            }
        }
    }

/*****************************************************************************
Purpose:To get the User Account Information and display on page.
Parameters:[]
Returns: [ void ]
******************************************************************************/
    public void getOrganizationInformation(){
        try{
            tabMode = 'readonly';
            selectedTab = 'organization';
            relatedListConfiguration = NULL;
            isRelatedListTab = FALSE;
            selectedTabName = '';
            userAccount = getAccountRecord();
            initializeMapRequiredFields();
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
        }
    }

/*****************************************************************************
Purpose:This method used to get the require field in json format
Parameters:[]
Returns: [ void ]
******************************************************************************/
    public String getJSONmapRequiredField(){
        if( mapRequiredField != NULL && mapRequiredField.size() > 0){
            return JSON.serialize(mapRequiredField);
        }
        return NULL;
    }

/*****************************************************************************
Purpose:To get the User Contact Information and display on page.
Parameters:[]
Returns: [ void ]
******************************************************************************/
    public void getContcatInformation(){
        try{
            tabMode = 'readonly';
            selectedTab = 'contact';
            relatedListConfiguration = NULL;
            isRelatedListTab = FALSE;
            selectedTabName = '';
            userContact = getContactRecord();
            initializeMapRequiredFields();
        }
        catch(Exception ex){
            ApexPages.addMessages(ex) ;
        }
    }

/*****************************************************************************
Purpose:To Show an record in edit mode
Parameters:[]
Returns: [ void ]
******************************************************************************/
    public void getEditMode(){
        try{
            tabmode = 'edit';
            initializeCharCount();
        }
        catch(Exception ex){
            CollectionUtilities.catchException(ex, TRUE);
        }
    }


/*****************************************************************************
Purpose:To Cancel the operation and make record readonly.
Parameters:[]
Returns: [ void ]
******************************************************************************/
    public void cancel(){
        try{
            tabMode = 'readonly';
            tabObject = NULL;
            isRecordDetailView = FALSE;
            if(selectedTab == 'contact'){
                getContactRecord();
            }
            if(selectedTab == 'organization'){
                getAccountRecord();
            }
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
        }
    }

/*****************************************************************************
Purpose:This method used to save the record
Parameters:[]
Returns: [ void ]
******************************************************************************/
    public void save(){
        try{
            boolean isRequiredFieldMissing = FALSE;
            if(selectedTab == 'organization' && userAccount != NULL && userAccount.Id != NULL)  {
                List<Schema.FieldSetMember> fieldset;
                fieldset = getAccountFields();
                if(fieldset != NULL){
                    for(Schema.FieldSetMember field : fieldset){
                        if(String.isBlank(String.valueOf(userAccount.get(field.getFieldPath()))) && field.getRequired() == TRUE){
                            ApexPages.addMessage(NEW ApexPages.Message(ApexPages.Severity.Error, System.Label.FC_Required_Field_Label + ' ' +field.getLabel() ));
                            isRequiredFieldMissing = TRUE;
                        }
                    }
                }
                if(!isRequiredFieldMissing){
                    this.getAdminContextExecutionManager().stripInaccessibleAndUpdate(new List<Sobject> {userAccount});                
                    tabMode = 'readonly';
                    userAccount = NULL;
                    userAccount = getAccountRecord();
                }
                tabMode = 'readonly';
            }
            else if(selectedTab == 'contact' && userContact != NULL && userContact.Id != NULL) {
                List<Schema.FieldSetMember> fieldset;
                fieldset =  getContactFields();
                if(fieldset!=NULL){
                    for(Schema.FieldSetMember field : fieldset){
                        if(String.isBlank(String.valueOf(userContact.get(field.getFieldPath()))) && field.getRequired() == TRUE){
                            ApexPages.addMessage(NEW ApexPages.Message(ApexPages.Severity.Error, System.Label.FC_Required_Field_Label + ' ' +field.getLabel() ));
                            isRequiredFieldMissing = TRUE;
                        }
                    }
                }
                if(!isRequiredFieldMissing){
                    this.getAdminContextExecutionManager().stripInaccessibleAndUpdate(new List<Sobject> {userContact});                     
                    tabMode = 'readonly';
                    userAccount = NULL;
                    userContact = getContactRecord();
                }
                tabMode = 'readonly';
            }
            if(String.isNotBlank(selectedTab) && tabObject != NULL){
                Related_List_Controller__c tabrecord = getTabRecord();
                List<Schema.FieldSetMember> fieldset;
                fieldset = mapFieldsByTabName.get(tabrecord.Name);
                if(fieldset !=NULL){
                    for(Schema.FieldSetMember field : fieldset){
                        if(String.isBlank(String.valueOf(tabObject.get(field.getFieldPath()))) && field.getRequired() == TRUE){
                            ApexPages.addMessage(NEW ApexPages.Message(ApexPages.Severity.Error, System.Label.FC_Required_Field_Label + ' ' +field.getLabel() ));
                            isRequiredFieldMissing = TRUE;
                        }
                    }
                }

                if(tabObject.id != NULL && !isRequiredFieldMissing)  {
                    this.getAdminContextExecutionManager().stripInaccessibleAndUpdate(new List<Sobject> {tabObject});                    
                }
                else if(tabObject.id == NULL && !isRequiredFieldMissing){
                    //TODO need to test this context - if it's a tab that creates records we may need to confirm proper function with fieldset+readOnly combo
                    AdminContextExecutionManager.executeInsert(NEW List<Sobject> {tabObject});
                }
                tabMode = 'readonly';
                if(!isRequiredFieldMissing){
                    initializeRelatedListTab();
                }
            }
        }
        catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
    }

/*****************************************************************************
Purpose:This is wrapper class for related list
******************************************************************************/
    // class for showing related list records for custom object
    public with sharing class relatedList{
        public Map<String,String> mapColumnFields { get; set; }
        public List<Object> lstRelatedListRecord { get; set; }
        public List<String> listColumnFields { get; set; }
        public String strActionColLabel  { get; set; }
        public String strRelatedListObject { get; set; }
        public String relatedListLookUp { get; set; }
        public Boolean isCreatable { get; set; }
        public Boolean isEditable { get; set; }
        public Boolean isDeletable { get; set; }
        public Boolean isAmendmentEnable { get; set; }
        public Related_List_Controller__c record { get; set; }

        public relatedList(){
            lstRelatedListRecord = new List<Object>();
            strActionColLabel = 'Action';
        }
    }

/*****************************************************************************
Purpose: To get the User Managemant tab Information and display on page.
Parameters:[]
Returns: [ void ]
******************************************************************************/
    public void userManagementTab(){
        tabMode = 'readonly';
        selectedTab = 'UserMngmt';
        relatedListConfiguration = NULL;
        isRelatedListTab = TRUE;
        selectedTabName = '';
    }

/*****************************************************************************
Purpose: this method used to get the user detail
Parameters:[]
Returns: [ List<UserDetails> ]
******************************************************************************/
    public List<UserDetails> getUsers(){
        lstUser = new List<UserDetails>();

        for (User user : [
            SELECT
                Contact.Email,
                Contact.Name,
                Contact.Title,
                IsActive,
                LastLoginDate,
                Username
            FROM User
            WHERE AccountId = :currentUser.AccountId
            AND Id != :UserInfo.getUserId()
            AND ProfileType__c = 'Organization'
            WITH SECURITY_ENFORCED
        ]) {
           lstUser.add(new UserDetails(user));
        }

        return lstUser;
    }

    public class UserDetails  {
        public User userObj {get; set;}
        public UserDetails(User user) {
            userObj = user;
        }
    }

/*****************************************************************************
Purpose: this method used to update the user data
Parameters:[map<Id,User>]
Returns: [List<User> ]
******************************************************************************/
    @RemoteAction
    public static List<User> updateUsers(map<Id,User> mapUsers){
        try{
            List<User> lstUsers = new List<User>();
            if(mapUsers != NULL && mapUsers.size() > 0) {
                lstUsers = mapUsers.values();
                CrudFlsService.getInstance().assertUpdateable(lstUsers);
                Database.update(lstUsers);
            }
            return lstUsers;
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            return NULL;
        }
    }

    private static String getDefaultFieldValue(FieldSetMember field) {
        String defaultValue = String.valueof(field.getSObjectField().getDescribe().getDefaultValue());
        if (defaultValue == null) {
            defaultValue = field.getSObjectField().getDescribe().getDefaultValueFormula();
        }
        return defaultValue;
    }
}