public with sharing class CommunitySignupExtension
{
    public Boolean initialized {get; set;} {initialized = false;}
    public static final String STR_FC_LOGO = Label.FC_Logo_Name;
    public static final Map<String, Schema.SObjectField> PORTAL_USER_FIELDS = Schema.Sobjecttype.FGM_Portal__Portal_User__c.Fields.getMap();
    public ApexPages.StandardController controller { set; get; }
    public FGM_Portal__Portal_User__c portalUser { set; get; }
    public Integer portalStep { set; get; }
    public string userType {get; set;}
    public string profileType {get; set;}   // Used to define the User profile type (Individual/ Belongs to an Organization)
    public String guideStarField {get; set;}
    public List<Map<String,Object>> lstGuideStarSearchResult { get; set; }
    public String guidestarSearchResultInstruction { get; set; }
    public String agreementUrl {get; set;}
    public FGM_Portal__GlobalPortalSettings__c termAndConditionUrl {get; set;}
    public String currentFieldSetName ;
    public String portalLanguage {get; set;}
    public Map<String,String> mapPortalUserHelpText  {get; set;}
    public Boolean IsSessionFound {get; set;}
    public SFDCEncoder ESAPI = new SFDCEncoder();
    public string userProfile {get; set;}
    public string returnURL{ get; set; }
    public Integer intChkEmailField = 0;
    public Integer intChkEmailConfField = 0;
    public Integer intChkLastNameField = 0;
    public User user { set; get; }
    public String countryField { set; get; }
    public String stateField { set; get; }
    public String countryName;
    public String stateName;
    public String date_time { get; set; }
    public string strFields{get;set;}

    public Boolean hasGuideStarNamedCredential {
        get {
            if (hasGuideStarNamedCredential == null) {
                hasGuideStarNamedCredential = ![SELECT Id FROM NamedCredential WHERE DeveloperName = 'Guide_Star_Credential'].isEmpty();
            }
            return hasGuideStarNamedCredential;
        }
        private set;
    }

    public String searchField;

    public List<SelectOption> getItems()
    {
        List<SelectOption> lstOptions = new List<SelectOption>();
        lstOptions.add(new SelectOption('Organization',System.Label.FC_Organization_RadioButtonLabel));
        lstOptions.add(new SelectOption('Individual',System.Label.FC_Individual_RadioButtonLabel));
        return lstOptions;
    }

    public CommunitySignupExtension()
    {
        returnURL = 'retUrl=' + ApexPages.currentPage().getParameters().get('retUrl');
        strFields=JSON.serialize(FCGlobal.getFieldLengthMap('FGM_Portal__Portal_User__c'));
    }

    public CommunitySignupExtension(ApexPages.StandardController controller)
    {
        this.controller = controller;
        IsSessionFound = (UserInfo.getSessionId() != null && UserInfo.getUserType() != 'Guest')?true:false;
        returnURL = 'retUrl=' + ApexPages.currentPage().getParameters().get('retUrl');
        user = new User();
        countryName = '';
        stateName = '';

        Boolean isCountryEnable = User.getSobjectType().getDescribe().fields.getMap().keySet().contains('countrycode');
        if(isCountryEnable)
        {
            countryField = 'CountryCode';
            stateField = 'StateCode';
        }
        else
        {
            countryField = 'Country';
            stateField = 'State';
        }

        portalLanguage = System.currentPageReference().getParameters().get('ln');
        portalLanguage = ESAPI.SFDC_HTMLENCODE(portalLanguage);
        portalLanguage = String.isBlank(portalLanguage)?'en_US':portalLanguage;

        // To get Multilanguage DateTime format
        Map<String, String> mappedValues = new Map<String, String>(); //map for holding locale to datetime format
        mappedValues = FCGlobal.getDateFormat();

        if (mappedValues.containsKey(portalLanguage)) //if the map contains the correct datetime format
            date_time = mappedValues.get(portalLanguage); //grab the datetime format for the locale

        String userProf = ApexPages.currentPage().getParameters().get('UType');

        if(userProf != null && String.isNotBlank(userProf))
        {
            userProf = userProf.trim();
            if(userProf.equalsIgnoreCase('Organization') || userProf.equalsIgnoreCase('Individual'))
            {
                userProf = userProf.toLowerCase();
                userProfile = userProf.capitalize();
            }
            else
                userProfile = 'Organization';
        }
        else
            userProfile = 'Organization';
    }

    public String username { get {
        return portalUser.Name + '@' + Site.getDomain();
    } set; }

    public String getParam(String name)
    {
        return ESAPI.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get(name));
    }

    // logo for signin page
    public String getImageLogoUrl()
    {

        List<Document> documentList = [
            SELECT Name
            FROM Document
            WHERE Name = :STR_FC_LOGO
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

        if(documentList != null && documentList.size()>0)
            return Site.getPathPrefix()+'/servlet/servlet.FileDownload?file='+documentList[0].Id;

        return null;
    }

    //for custom text
    public CustomHTML__c getCustomHTMLDescription()
    {
        List<CustomHTML__c> customHtml = new List<CustomHTML__c>();
        portalLanguage = String.isBlank(portalLanguage)?'en_US':portalLanguage;

        if(String.isNotBlank(currentFieldSetName))
        {
            customHtml = [
                SELECT
                    RichDescription__c,
                    Language__c,
                    Name
                FROM CustomHTML__c
                WHERE Name = :currentFieldSetName
                AND Associated_FC_Portal_Type__c = 'Grantee'
                AND Language__c = :portalLanguage
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];
        }
        return customHtml.isEmpty()
            ? null
            : customHtml[0];
    }

    // For HelpText
    public String getHelpText()
    {
        for(Schema.SObjectField sfield : PORTAL_USER_FIELDS.Values())
        {
            schema.describefieldresult dfield = sfield.getDescribe();
            String helpText = dfield.getInlineHelpText();

            if(String.isNotBlank(helpText))
                mapPortalUserHelpText.put(dfield.getName(),helpText);
            else
                mapPortalUserHelpText.put(dfield.getName(),'Blank');
        }
        return null;
    }

    // Passthrough JSON
    public PageReference initialize()
    {
        initialized = true;
        //For terms and condition
        termAndConditionUrl = FGM_Portal__GlobalPortalSettings__c.getInstance();
        agreementUrl = termAndConditionUrl.AgreementUrl__c;
        guidestarSearchResultInstruction = '';
        portalUser = new FGM_Portal__Portal_User__c();
        portalStep = 1;
        countryName = '';
        stateName = '';
        user = new User();

        if(String.isNotBlank(String.escapeSingleQuotes(userProfile)) && String.escapeSingleQuotes(userProfile).equalsIgnoreCase('Individual'))
        {
            profileType = 'Individual';
            userType = 'Grantee';
            currentFieldSetName = 'Communities Sign Up - Step 1 Individual';
        }
        else
        {
            profileType = 'Organization';
            userType = 'Grantee';
            currentFieldSetName = 'Communities Sign Up - Step 1';
        }

        Schema.DescribeSObjectResult objDescription = FGM_Portal__Portal_User__c.sObjectType.getDescribe();
        Map<String, Schema.FieldSet> mapPortalUserFieldSet = objDescription.fieldSets.getMap();
        mapPortalUserHelpText = new Map<String,String>();
        getHelpText();
        lstGuideStarSearchResult = null;
        if( IsSessionFound )
            return Page.CommunityDashboard;
        else
            return null;
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

    public PageReference prev()
    {
        portalStep --;
        intChkEmailField = 0;
        intChkEmailConfField = 0;
        intChkLastNameField = 0;
        currentFieldSetName = ('Individual'.equalsIgnoreCase(profileType))?'Communities Sign Up - Step '+ portalStep + ' Individual':'Communities Sign Up - Step '+ portalStep;
        return null;
    }

    public PageReference next()
    {
        String countrystate = apexpages.currentpage().getparameters().get('cntryst');
        if(countrystate != null && countrystate != '')
        {
            List<String> lstCS = countrystate.split(':cs:');
            countryName = lstCS[0] != '--None--'?lstCS[0]:'';
            stateName = lstCS[1] != '--None--'?lstCS[1]:'';
        }

        List<Schema.FieldSetMember> lstCurrentFieldSet;
        String strFieldSetName;
        Boolean bLastNameFieldExists=false;
        map<String,Schema.FieldSet> mapPortalUserFieldSet = Schema.SObjectType.FGM_Portal__Portal_User__c.fieldsets.getMap();
        strFieldSetName = ('Individual'.equalsIgnoreCase(profileType))?('fgm_portal__Communities_Sign_Up_Step_'+ portalStep +'_Individual').toLowerCase():('fgm_portal__Communities_Sign_Up_Step_'+ portalStep).toLowerCase();

        lstCurrentFieldSet = mapPortalUserFieldSet.get(strFieldSetName).getFields();

        if(lstCurrentFieldSet!=null && lstCurrentFieldSet.size()>0)
        {
            for(Schema.FieldSetMember objFieldSetMember : lstCurrentFieldSet)
            {
                if(objFieldSetMember.getFieldPath() == 'FGM_Portal__Email__c')
                    intChkEmailField = 1;

                if(objFieldSetMember.getFieldPath() == 'FGM_Portal__Confirm_Email__c')
                    intChkEmailConfField = 1;

                if(objFieldSetMember.getFieldPath()=='FGM_Portal__LastName__c')
                    intChkLastNameField = 1;
            }
        }

        if ('Individual'.equalsIgnoreCase(profileType)) {

            Integer portalUserCount = [
                SELECT COUNT()
                FROM Portal_User__c
                WHERE Email__c = :portalUser.Email__c
                AND LastName__c = :portalUser.LastName__c
                AND FirstName__c = :portalUser.FirstName__c
                AND ProfileType__c = 'Individual'
                WITH SECURITY_ENFORCED
            ];

            if (0 != portalUserCount) {
                return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_DuplicateIndividualUser), null);
            }

            Integer userCount = [
                SELECT COUNT()
                FROM User
                WHERE Email = :portalUser.Email__c
                AND LastName = :portalUser.LastName__c
                AND FirstName = :portalUser.FirstName__c
                AND ProfileType__c = 'Individual'
                WITH SECURITY_ENFORCED
            ];

            if (0 != userCount) {
                return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_DuplicateIndividualUser), null);
            }
        }

        if (intChkLastNameField == 1 && portalUser.FGM_Portal__LastName__c == null)
            return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_LastNameRequired_ErrorMsg), null);

        if (portalUser.FGM_Portal__Email__c != null && intChkEmailField == 1 && (portalUser.FGM_Portal__Organization_Legal_Name__c != null || portalUser.FGM_Portal__EIN__c != null)) {

            Integer portalUserCount = [
                SELECT COUNT()
                FROM Portal_User__c
                WHERE Email__c = :portalUser.Email__c
                AND Organization_Legal_Name__c = :portalUser.Organization_Legal_Name__c
                AND EIN__c = :portalUser.EIN__c
                WITH SECURITY_ENFORCED
            ];

            if (0 != portalUserCount) {
                return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_Singup_DuplicateEmailId_ErrorMsg), null);
            }
        }

        if(portalUser.FGM_Portal__Email__c != null && intChkEmailField == 1 && (portalUser.FGM_Portal__Organization_Legal_Name__c != null || portalUser.FGM_Portal__EIN__c != null))
        {
            Integer contactCount = 0;
            contactCount = new FCGlobal.WithoutSharing().getRegContacts(portalUser.FGM_Portal__Organization_Legal_Name__c,portalUser.FGM_Portal__EIN__c,portalUser.FGM_Portal__Email__c);

            if (0 != contactCount)
                return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_Singup_DuplicateEmailId_ErrorMsg), null);
        }

        if(intChkEmailField == 1 && intChkEmailConfField == 1)
        {
            if (portalUser.FGM_Portal__Email__c != portalUser.FGM_Portal__Confirm_Email__c )
               return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_EmailMismatch_ErrorMsg), null);
        }

        //Auto populate username according to email
        if(intChkEmailField == 1 && portalUser.FGM_Portal__Email__c != null && String.isNotBlank(portalUser.FGM_Portal__Email__c) && String.isBlank(portalUser.Name)){
                portalUser.Name = portalUser.FGM_Portal__Email__c.split('@')[0];
        }

        portalStep ++;
        currentFieldSetName = ('Individual'.equalsIgnoreCase(profileType))?'Communities Sign Up - Step '+ portalStep + ' Individual':'Communities Sign Up - Step '+ portalStep;

        return null;
    }

    public PageReference getIndividualMode()
    {
        profileType = 'Individual';
        portalStep = 1;
        return null;
    }

    public PageReference getOrganizationMode()
    {
        profileType = 'Organization';
        portalStep = 1;
        return null;
    }

// Purpose : To Encode value for GuideStar Authetication.

    public String URLENCODE(String value)
    {
        string encodedValue = value;
        if(String.isNotBlank(encodedValue))
        {
            encodedValue = encodedValue.replace('%','%25');
            encodedValue = encodedValue.replace(' ','%20');
            encodedValue = encodedValue.replace('"','%22');
            encodedValue = encodedValue.replace('-','%2D');
            encodedValue = encodedValue.replace('.','%2E');
            encodedValue = encodedValue.replace('<','%3C');
            encodedValue = encodedValue.replace('>','%3E');
            encodedValue = encodedValue.replace('\\','%5C');
            encodedValue = encodedValue.replace('^','%5E');
            encodedValue = encodedValue.replace('_','%5F');
            encodedValue = encodedValue.replace('`','%60');
            encodedValue = encodedValue.replace('{','%7B');
            encodedValue = encodedValue.replace('|','%7C');
            encodedValue = encodedValue.replace('}','%7D');
            encodedValue = encodedValue.replace('~','%7E');
        }
        return encodedValue;
    }


// Purpose : To get The Organization information from GuideStar DB.
    public void getGuideStarInfo()
    {
        string strGuideStarInfoField =  getParam('guidestarField');
        if(String.isNotBlank(strGuideStarInfoField)){
            searchField = '';
            try{
                if('FGM_Portal__Organization_Legal_Name__c'.equalsIgnoreCase(strGuideStarInfoField))
                    searchField = portalUser.FGM_Portal__Organization_Legal_Name__c;
                else if('FGM_Portal__EIN__c'.equalsIgnoreCase(strGuideStarInfoField)){
                    if(String.isNotBlank(portalUser.FGM_Portal__EIN__c) && portalUser.FGM_Portal__EIN__c.length() > 8){
                        if(!portalUser.FGM_Portal__EIN__c.contains('-'))
                            portalUser.FGM_Portal__EIN__c = string.format('{0}-{1}',new string[]{portalUser.FGM_Portal__EIN__c.substring(0, 2), portalUser.FGM_Portal__EIN__c.substring(2, portalUser.FGM_Portal__EIN__c.length())});
                        searchField =  portalUser.FGM_Portal__EIN__c ;
                    }else
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'EIN is not valid for this organization'));
                }
                if(String.isNotBlank(searchField)){
                    List<Object> lstGuideStarRecords = new List<Object>();
                    lstGuideStarRecords = callout(searchField);
                    if(lstGuideStarRecords != null){
                        if(!lstGuideStarRecords.isEmpty() && lstGuideStarRecords.size() > 0)
                            showGuideStarSearch(lstGuideStarRecords);
                        else
                            processSingleGuideStarResult(lstGuideStarRecords[0]);
                    }
                }
            }catch(System.CalloutException ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
            }
        }
    }

   // Purpose : Generic method to callout based on EIN or any search string
    public List<Object> callout(String searchField){
        HttpRequest request  = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('callout:Guide_Star_Credential');
        request.setHeader('Subscription-Key', '{!$Credential.Password}');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        JSONGenerator generator = JSON.createGenerator(true);
        generator.writeStartObject();
        generator.writeStringField('search_terms', searchField);
        generator.writeEndObject();
        String jsonString = generator.getAsString();
        request.setBody(jsonString);
        Http http = new Http();
        HTTPResponse response = new HttpResponse();
        Map<String,Object> mapGuidestarResponse = new Map<String,Object>();
        try{
            response = http.send(request);
            if(response.getStatusCode() != 200){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'Record not found'));
                return null;
            }
            mapGuidestarResponse = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
        }catch(System.CalloutException ex){
            System.debug('Exception in callout: '+ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, System.Label.FC_Guidestar_Services_ErrorMsg));
            return null;
        }
        mapGuidestarResponse =  (Map<String,Object>)mapGuidestarResponse.get('data');
        if(mapGuidestarResponse.containsKey('hits'))
            return (List<Object>)mapGuidestarResponse.get('hits');
        return null;
    }

   // Purpose : To process selected GuideStar Search Result to user.
    public void processSingleGuideStarResult(Object GuideStarSearchRecord){
        Map<String,Object> mapGuideStarResult = (Map<String,Object>)GuideStarSearchRecord;
        if(!mapGuideStarResult.isEmpty()){
            searchField =  '';
            if(mapGuideStarResult.containsKey('ein'))
                searchField = String.valueOf(mapGuideStarResult.get('ein'));
            else if(mapGuideStarResult.containsKey('organization_name'))
                searchField = String.valueOf(mapGuideStarResult.get('organization_name'));
            if(String.isNotBlank(searchField)){
                List<Object> lstGuideStarRecords = new List<Object>();
                lstGuideStarRecords = callout(searchField);
                Map<String,Object> mapGuidestarResponse = (Map<String,Object>)lstGuideStarRecords[0];
                if(!mapGuidestarResponse.isEmpty()){

                    if (mapGuidestarResponse.containsKey('organization_name'))
                        mapGuidestarResponse.put('primary_organization_name', String.valueOf(mapGuidestarResponse.get('organization_name')));

                    if (mapGuidestarResponse.containsKey('ein'))
                        mapGuidestarResponse.put('government_issued_id', String.valueOf(mapGuidestarResponse.get('ein')));

                    if (mapGuidestarResponse.containsKey('city'))
                        mapGuidestarResponse.put('city', String.valueOf(mapGuidestarResponse.get('city')));

                    if (mapGuidestarResponse.containsKey('county'))
                        mapGuidestarResponse.put('country_abbrev', String.valueOf(mapGuidestarResponse.get('county')));

                    if (mapGuidestarResponse.containsKey('state'))
                        mapGuidestarResponse.put('country_subdivision_abbrev', String.valueOf(mapGuidestarResponse.get('state')));

                    if (mapGuidestarResponse.containsKey('address_line_1'))
                        mapGuidestarResponse.put('address_line_1', String.valueOf(mapGuidestarResponse.get('address_line_1')));

                    if (mapGuidestarResponse.containsKey('address_line_2'))
                        mapGuidestarResponse.put('address_line_2', String.valueOf(mapGuidestarResponse.get('address_line_2')));

                    if (mapGuidestarResponse.containsKey('zip'))
                        mapGuidestarResponse.put('postal_code', String.valueOf(mapGuidestarResponse.get('zip')));

                    if (mapGuidestarResponse.containsKey('contact_phone '))
                        mapGuidestarResponse.put('telephone_number', String.valueOf(mapGuidestarResponse.get('contact_phone')));

                    Map<String,Map<String,String>> mapPortalUserMappingObject = FCGlobal.getGuideStarMappingMap(new List<String>{'GuideStar Portal User'});
                    Map<String,String> mapPortalUserMapping =  null;

                    if(!mapPortalUserMappingObject.isEmpty() && mapPortalUserMappingObject.containsKey('GuideStar Portal User'))
                        mapPortalUserMapping = mapPortalUserMappingObject.get('GuideStar Portal User');

                    if(mapPortalUserMapping != null && mapPortalUserMapping.size() > 0){
                        for(String keyField : mapPortalUserMapping.keySet()){
                            if(mapGuidestarResponse.containsKey(keyField)){
                                // Implamented to avoid error if user configure wrong field in mapping.
                                try{
                                    object field = portalUser.get(mapPortalUserMapping.get(keyField));
                                }
                                catch(System.SObjectException ex){
                                    System.debug('exception'+ex);
                                    continue;
                                }
                                portalUser.put(mapPortalUserMapping.get(keyField),mapGuidestarResponse.get(keyField));
                            }
                        }
                    }
                }
            }
        }
    }

// Purpose : To show the GuideStar Search Result to user.
    public void showGuideStarSearch(List<Object> lstGuideStarSearch){
        if(!lstGuideStarSearch.isEmpty()){
            String searchKey = 'FGM_Portal__Organization_Legal_Name__c'.equalsIgnoreCase(getParam('guidestarField')) ? portalUser.FGM_Portal__Organization_Legal_Name__c : portalUser.FGM_Portal__EIN__c;
            guidestarSearchResultInstruction = string.format('Your search for \"{0}\" resulted in {1} matches. Click the organization name to select.',new string[]{searchKey,string.valueOf(lstGuideStarSearch.size())});
            for (Object guideStarObject : lstGuideStarSearch){
                Map<String,Object> mapGuidestarInfo = (Map<String,Object>) guideStarObject;
                if(!mapGuidestarInfo.isEmpty()){
                    if(lstGuideStarSearchResult == null)
                        lstGuideStarSearchResult = new List<Map<String,Object>>();
                    if(mapGuidestarInfo.containsKey('organization_name'))
                        lstGuideStarSearchResult.add(mapGuidestarInfo);
                }
            }
        }
    }

  // Purpose : To Process the GuideStar Search Result.
    public void processGuideStarSearch(){
        string strRecordIndex =  getParam('recordIndex');
        if( lstGuideStarSearchResult!= null && !lstGuideStarSearchResult.isEmpty() && String.isNotBlank(strRecordIndex)){
            if(integer.valueOf(strRecordIndex) < lstGuideStarSearchResult.size()){
                Object searchResult = lstGuideStarSearchResult[integer.valueOf(strRecordIndex)];
                if(searchResult != null)
                    processSingleGuideStarResult(searchResult);
            }
        }
        guidestarSearchResultInstruction = '';
        lstGuideStarSearchResult = null;
    }

  // Purpose : To Process the GuideStar Search Result.
    public void closeGuideStarResult(){
        guidestarSearchResultInstruction = '';
        lstGuideStarSearchResult = null;
    }

    public PageReference register() {
        String countrystate = apexpages.currentpage().getparameters().get('countrystate');
        if(countrystate != null && String.isNotBlank(countrystate)) {
            List<String> lstCS = countrystate.split(':cs:');
            countryName = lstCS[0] != '--None--'?lstCS[0]:'';
            stateName = lstCS[1] != '--None--'?lstCS[1]:'';
        }

        System.Savepoint savepoint = Database.setSavepoint();
        // Create the account
        try {
            List<Schema.FieldSetMember> lstCurrentFieldSet;
            String strFieldSetName;
            Boolean bLastNameFieldExists=false;
            map<String,Schema.FieldSet> mapPortalUserFieldSet = Schema.SObjectType.FGM_Portal__Portal_User__c.fieldsets.getMap();
            strFieldSetName = ('Individual'.equalsIgnoreCase(profileType))?('fgm_portal__Communities_Sign_Up_Step_3_Individual').toLowerCase():('fgm_portal__Communities_Sign_Up_Step_3').toLowerCase();
            lstCurrentFieldSet = mapPortalUserFieldSet.get(strFieldSetName).getFields();

            if(lstCurrentFieldSet!=null && lstCurrentFieldSet.size()>0) {
                for(Schema.FieldSetMember objFieldSetMember : lstCurrentFieldSet) {
                    if(objFieldSetMember.getFieldPath() == 'FGM_Portal__Email__c') {
                        intChkEmailField = 1;
                    }

                    if(objFieldSetMember.getFieldPath() == 'FGM_Portal__Confirm_Email__c') {
                        intChkEmailConfField = 1;
                    }
                }
            }

            if ('Individual'.equalsIgnoreCase(profileType)) {
                Integer portalUserCount = [
                    SELECT COUNT()
                    FROM Portal_User__c
                    WHERE Email__c = :portalUser.Email__c
                    AND LastName__c = :portalUser.LastName__c
                    AND FirstName__c = :portalUser.FirstName__c
                    AND ProfileType__c = 'Individual'
                    WITH SECURITY_ENFORCED
                ];

                if (0 != portalUserCount) {
                    return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_DuplicateIndividualUser), null);
                }

                Integer userCount = [
                    SELECT COUNT()
                    FROM User
                    WHERE Email = :portalUser.Email__c
                    AND LastName = :portalUser.LastName__c
                    AND FirstName = :portalUser.FirstName__c
                    AND ProfileType__c = 'Individual'
                    WITH SECURITY_ENFORCED
                ];

                if (0 != userCount) {
                    return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_DuplicateIndividualUser), null);
                }
            }

            if (portalUser.FGM_Portal__Email__c != null && intChkEmailField == 1 && (portalUser.FGM_Portal__Organization_Legal_Name__c != null || portalUser.FGM_Portal__EIN__c != null)) {

                Integer portalUserCount = [
                    SELECT COUNT()
                    FROM Portal_User__c
                    WHERE Email__c = :portalUser.Email__c
                    AND Organization_Legal_Name__c = :portalUser.Organization_Legal_Name__c
                    AND EIN__c = :portalUser.EIN__c
                    WITH SECURITY_ENFORCED
                ];

                if (0 != portalUserCount) {
                    return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_Singup_DuplicateEmailId_ErrorMsg), null);
                }
            }

            if(portalUser.FGM_Portal__Email__c != null && intChkEmailField == 1 && (portalUser.FGM_Portal__Organization_Legal_Name__c != null || portalUser.FGM_Portal__EIN__c != null)) {
                Integer contactCount = 0;
                contactCount = new FCGlobal.WithoutSharing().getRegContacts(portalUser.FGM_Portal__Organization_Legal_Name__c,portalUser.FGM_Portal__EIN__c,portalUser.FGM_Portal__Email__c);

                if (0 != contactCount) {
                    return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_Singup_DuplicateEmailId_ErrorMsg), null);
                }
            }

            if(intChkEmailField == 1 && intChkEmailConfField == 1) {
                if (portalUser.FGM_Portal__Email__c != portalUser.FGM_Portal__Confirm_Email__c ) {
                   return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_EmailMismatch_ErrorMsg), null);
               }
            }
            //Auto populate username according to email
            if(intChkEmailField == 1 && portalUser.FGM_Portal__Email__c != null && String.isNotBlank(portalUser.FGM_Portal__Email__c) && !String.isNotBlank(portalUser.Name)) {
                portalUser.Name = portalUser.FGM_Portal__Email__c.split('@')[0];
            }

            if (portalUser.Name == null || portalUser.Name.trim().length() == 0) {
                return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_UsernameRequired_ErrorMsg), savepoint);
            }

            Integer portalUserCount = [
                SELECT COUNT()
                FROM Portal_User__c
                WHERE Name = :username
                WITH SECURITY_ENFORCED
            ];

            if (0 != portalUserCount) {
                return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_Signup_ExistingPortalUser_ErrorMsg), savepoint);
            } else {

                Integer userCount = [
                    SELECT COUNT()
                    FROM User
                    WHERE Username = :username
                    WITH SECURITY_ENFORCED
                ];

                if (0 != userCount) {
                    return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_Signup_ExistingUser_ErrorMsg), savepoint);
                }
            }

            if (portalUser.Name.contains('@')) {
                return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_UsernameContainsEmailID_ErrorMsg), savepoint);
            } else if (portalUser.Name.contains(' ')) {
                return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_UsernameContainsSpace_ErrorMsg), savepoint);
            } else if (portalUser.Name.length() > 20) {
                return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_InvalidUsernameLength_ErrorMsg), savepoint);
            }

            if(portalUser.FGM_Portal__Password__c != portalUser.FGM_Portal__Confirm_Password__c) {
                return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_PasswordMisMatch_ErrorMsg), savepoint);
            }


           List<FGM_Portal__CustomValidation__c> lstCustomValidation = FGM_Portal__CustomValidation__c.getall().values();
           if(lstCustomValidation != null && !lstCustomValidation.isEmpty()) {
               for(FGM_Portal__CustomValidation__c CustomValidation : lstCustomValidation) {
                   Pattern passwordPattern = Pattern.compile(String.valueOf(customValidation.FGM_Portal__Regular_Expression__c.trim()));
                   Matcher passwordMatcher = passwordPattern.matcher(portalUser.FGM_Portal__Password__c);
                   if(!passwordMatcher.matches()) {
                       if(CustomValidation.FGM_Portal__LanguageSelection__c == portalLanguage) {
                           return rollbackWithError(customValidation.FGM_Portal__Error_Message__c, savepoint);
                       }
                   }
               }
           }

            Boolean isCountryPiklstEnable = User.getSobjectType().getDescribe().fields.getMap().keySet().contains('countrycode');
            portalUser.Name = String.escapeSingleQuotes(username);
            portalUser.FGM_Portal__Domain__c = Site.getDomain();
            portalUser.FGM_Portal__Organization_Legal_Name__c = String.isBlank(portalUser.FGM_Portal__Organization_Legal_Name__c)?String.isNotBlank(portalUser.FGM_Portal__FirstName__c)?portalUser.FGM_Portal__FirstName__c+' '+ portalUser.FGM_Portal__LastName__c:portalUser.FGM_Portal__LastName__c:portalUser.FGM_Portal__Organization_Legal_Name__c;
            portalUser.FGM_Portal__ProfileType__c = profileType;
            portalUser.FGM_Portal__User_Profile__c = userType ;
            portalUser.FGM_Portal__Country__c = isCountryPiklstEnable?countryName:user.Country;
            portalUser.FGM_Portal__State__c = isCountryPiklstEnable?stateName:user.State;
            portalUser.FGM_Portal__IsActive__c = false;
            portalUser.FGM_Portal__Confirmation_Code__c = String.valueOf(Math.random() * 100000);
            portalUser.FGM_Portal__Portal_Language__c = portalLanguage;
            portalUser.FGM_Portal__Default_Time_Zone__c = String.valueOf(UserInfo.getTimeZone());
            if(String.IsNotBlank(returnURL)) {
                portalUser.FGM_Portal__Return_URL__c = returnURL;
              }
            CrudFlsService.getInstance().assertCreateable(portalUser);
            insert portalUser;
            PageReference pageReference = System.Page.CommunitySignupConfirm;
            pageReference.getParameters().put('id', portalUser.Id);
            pageReference.getParameters().put('ln', portalLanguage);
            pageReference.setRedirect(true);
            return pageReference;
        } catch (System.DMLException problem) {
             if(username != null && String.isNotBlank(username))
                portalUser.Name =  username.split('@')[0];

             return rollbackWithError(problem.getdmlMessage(0), savepoint);
        }
    }
}