public without sharing virtual class CommunitySignupConfirmExtension
{
    public Boolean initialized {get; set;} {initialized = false;}
    public static final Map<String, Schema.SObjectField> PORTAL_USER_FIELDS = Schema.Sobjecttype.FGM_Portal__Portal_User__c.Fields.getMap();
    public ApexPages.StandardController controller { set; get; }
    public static final String STR_FC_LOGO = Label.FC_Logo_Name;
    public FGM_Portal__Portal_User__c portalUser { set; get; }
    public String portalLanguage {get; set;}
    public Boolean isOpportunityTeamMemberPortalUser { get; set; }
    public string UserAdminId = Site.getAdminId();
    public String userId;
    public Boolean isError{ get; set;}
    public SFDCEncoder ESAPI = new SFDCEncoder();
    public string returnURL{get;set;}
    public string quizID{get;set;}
    public FGM_Portal__CommunitySetting__c communitySetting;
    public Boolean isAutoActivate{get;set;}
    public Boolean IsSessionFound {get; set;}
    public Map<String,String> mapPortalUserHelpText  {get; set;}
    public String code{get;set;}
    public String username { get { return portalUser.Name + '@' + Site.getDomain();} set; }
    public CommunitySignupConfirmExtension(ApexPages.StandardController controller)
    {
        IsSessionFound = ( UserInfo.getSessionId() != null && UserInfo.getUserType() != 'Guest' ) ? true : false;
        this.controller = controller;
        isOpportunityTeamMemberPortalUser = false;
        this.portalUser = (FGM_Portal__Portal_User__c) controller.getRecord();
        portalLanguage = System.currentPageReference().getParameters().get('ln');
        portalLanguage  = ESAPI.SFDC_HTMLENCODE(portalLanguage);
        communitySetting = FGM_Portal__CommunitySetting__c.getInstance('AutoActivateGrantee');
        isAutoActivate = (communitySetting != null && communitySetting.FGM_Portal__IsEnabled__c == true)?true:false;
        if(ApexPages.currentPage().getParameters().get('retUrl')!=null)
            returnURL = ApexPages.currentPage().getParameters().get('retUrl');
        if(ApexPages.currentPage().getParameters().get('quizId')!=null){
            quizID = ApexPages.currentPage().getParameters().get('quizId');
            returnURL = returnURL + '&quizId=' + ApexPages.currentPage().getParameters().get('quizId');
        }
    }
    // To get the logo
    public String getImageLogoUrl(){

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
    public PageReference rollbackWithError(String message, System.Savepoint savepoint){
        if (savepoint != null)
            Database.rollback(savepoint);
        if (message != null)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, message));

        return null;
    }
    // For HelpText
    public String getHelpText() {
        for(Schema.SObjectField sfield : PORTAL_USER_FIELDS.Values()){
            schema.describefieldresult dfield = sfield.getDescribe();
            String helpText = dfield.getInlineHelpText();
            if(String.isNotBlank(helpText))
                mapPortalUserHelpText.put(dfield.getName(),helpText);
            else
                mapPortalUserHelpText.put(dfield.getName(),'Blank');
        }
        return null;
    }
    public Pagereference initialize(){
        system.debug('in initialize:::::::::');
        initialized = true;
        if(this.portalUser != null && this.portalUser.Id != null){
            PageReference pageReference = null;
            isOpportunityTeamMemberPortalUser = false;
            code = '';
            String parentURL = ApexPages.currentPage().getHeaders().get('referer');
            if(parentURL != null){
                pageReference = new PageReference(parentURL);
                code = pageReference.getParameters().get('code');
            }
            if(String.isNotBlank(ApexPages.currentPage().getParameters().get('code')))
                code = String.escapeSingleQuotes(ESAPI.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('code')));
            ID currentRecordTypeId = FCGlobal.getRecordTypeId(String.valueOf(FGM_Portal__Portal_User__c.sObjectType),'Opportunity Team Member');
                if(currentRecordTypeId != null && this.portalUser.RecordTypeId == currentRecordTypeId){
                    if((portalUser.FGM_Portal__Confirmation_Code__c.equalsIgnoreCase(code) && portalUser.FGM_Portal__Confirmation_Date__c == null)){
                        isOpportunityTeamMemberPortalUser = true;
                        portalUser.Name = null;
                    }
                }
                // Is there a confirmation code?
                if((portalUser.FGM_Portal__Confirmation_Code__c.equalsIgnoreCase(code) && (portalUser.FGM_Portal__Confirmation_Date__c == null || isAutoActivate) && !portalUser.FGM_Portal__IsCreatedByOpportunityTeamMember__c)){
                    portalUser.FGM_Portal__Confirmation_Date__c = DateTime.now();
                    portalUser.FGM_Portal__User_Profile__c = 'Grantee';
                    List<Sobject> lstSobject = WithoutSharing.executeUpdate(new List<Sobject>{portalUser});
                    if(isAutoActivate && portalUser.FGM_Portal__Confirmation_Date__c != null)
                        activate();
                    else{
                        // Done, redirect to the page again
                        pageReference = System.Page.CommunitySignupConfirm;
                        pageReference.getParameters().put('id', controller.getId());
                        pageReference.getParameters().put('message', 'email-confirmed');
                        pageReference.setRedirect(false);
                        return pageReference;
                    }
                }
        }
        mapPortalUserHelpText = new Map<String,String>();
        getHelpText();
        if(IsSessionFound)
            return Page.CommunityDashboard;
        else
            return null;
    }
    //Registeration for Opportunity Team member
    public PageReference register(){
        system.debug('portalUser::::::::'+portalUser);
        System.Savepoint savepoint = Database.setSavepoint();
        if(portalUser != null && portalUser.Id != null && isOpportunityTeamMemberPortalUser){
     //       if (portalUser.Name == null || portalUser.Name.trim().length() == 0)
      //          return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_UsernameRequired_ErrorMsg), savepoint);
            try{

                Integer userCount = new WithoutSharing().doCountQuery(
                    'SELECT COUNT() FROM User WHERE Username = \'' + String.escapeSingleQuotes(username) + '\' WITH SECURITY_ENFORCED'
                );

                Integer portalUserCount = [
                    SELECT COUNT()
                    FROM Portal_User__c
                    WHERE Name = :username
                    WITH SECURITY_ENFORCED
                ];

          /*      if (0 != userCount)
                    return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_Signup_ExistingUser_ErrorMsg), savepoint);
                if (0 != portalUserCount)
                    return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_Signup_ExistingPortalUser_ErrorMsg), savepoint);
                if (portalUser.Name.contains('@'))
                    return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_UsernameContainsEmailID_ErrorMsg), savepoint);
                if (portalUser.Name.contains(' '))
                    return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_UsernameContainsSpace_ErrorMsg), savepoint);
                if (portalUser.Name.length() > 20)
                    return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_InvalidUsernameLength_ErrorMsg), savepoint);
                if(portalUser.FGM_Portal__Password__c != portalUser.FGM_Portal__Confirm_Password__c)
                    return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_PasswordMisMatch_ErrorMsg), savepoint);
              */  FGM_Portal__CustomValidation__c customValidation = FGM_Portal__CustomValidation__c.getInstance('PasswordValidation');
                if(customValidation != null ){
                    Pattern passwordPattern = Pattern.compile(String.valueOf(customValidation.FGM_Portal__Regular_Expression__c.trim()));
                    Matcher passwordMatcher = passwordPattern.matcher(portalUser.FGM_Portal__Password__c);
                    if(!passwordMatcher.matches())
                        return rollbackWithError(customValidation.FGM_Portal__Error_Message__c, savepoint);
                }
                // Copy over the full proper username
               // portalUser.Name = username;
                portalUser.FGM_Portal__IsActive__c = true;
                portalUser.FGM_Portal__Domain__c = Site.getDomain();

                if(portalUser.FGM_Portal__Confirmation_Date__c == null)
                    portalUser.FGM_Portal__Confirmation_Date__c = DateTime.now();
                portalUser.RecordTypeId = FCGlobal.getRecordTypeId(String.valueOf(FGM_Portal__Portal_User__c.sObjectType),'New User');
                WithoutSharing.executeUpdate(new List<sObject>{portalUser});
            }
            catch (System.DMLException problem){
                portalUser.Name =  username.split('@')[0];
                return rollbackWithError(problem.getdmlMessage(0), savepoint);
            }
            catch (System.Exception problem){
                portalUser.Name =  username.split('@')[0];
                return rollbackWithError(problem.getMessage(), savepoint);
            }
            // Done, forward to the confirmation page
            PageReference pageReference = System.Page.CommunitySignupConfirm;
            pageReference.getParameters().put('id', portalUser.Id);
            pageReference.getParameters().put('ln', portalLanguage);
            pageReference.setRedirect(true);
            return pageReference;
        }
        return null;
    }
        //go to login
    public PageReference goToLogin(){
        PageReference pageReference = System.Page.CommunitySignin;
        pageReference.getParameters().put('retURL', returnURL);
        return pageReference;
    }
    
    public PageReference activate() {
        System.Savepoint savepoint = Database.setSavepoint();
        try{

            Portal_User__c currentPortalUser = [
                SELECT
                    Account__c,
                    Account__r.Id,
                    Account__r.Name,
                    Approval_Status__c,
                    EIN__c,
                    IsCreatedByOpportunityTeamMember__c,
                    Organization_Legal_Name__c,
                    Return_URL__c
                FROM Portal_User__c
                WHERE Id = :portalUser.Id
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            setAccountOnPortalUser(currentPortalUser);

            createUserFromPortalUser(currentPortalUser);

            if(userId != null){
                linkContactToPortalUser(Id.valueOf(userId));
                isError = false;
            } else {
                isError = true;
                return null;
            }

            // Purpose :- Mapping the GuideStar fields to Account and Contact.
            Map<String,Map<String,String>> mapPortalUserMappingObject = FCGlobal.getGuideStarMappingMap(new List<String>{'GuideStar Portal User','Guidestar Contact','Guidestar Organization'});
            Map<String,String> mapPortalUserMapping =  null;
            Map<String,String> mapAccountMapping =  null;
            Map<String,String> mapContactMapping =  null;
            if(mapPortalUserMappingObject != null && !mapPortalUserMappingObject.isEmpty() && mapPortalUserMappingObject.containsKey('GuideStar Portal User'))
                mapPortalUserMapping = mapPortalUserMappingObject.get('GuideStar Portal User');
            if(mapPortalUserMapping != null && !mapPortalUserMapping.isEmpty()){
                if(mapPortalUserMappingObject != null && !mapPortalUserMappingObject.isEmpty() && mapPortalUserMappingObject.containsKey('Guidestar Contact'))
                    mapContactMapping = mapPortalUserMappingObject.get('Guidestar Contact');
                if(mapPortalUserMappingObject != null && !mapPortalUserMappingObject.isEmpty() && mapPortalUserMappingObject.containsKey('Guidestar Organization'))
                    mapAccountMapping = mapPortalUserMappingObject.get('Guidestar Organization');

                SObjectType portalUserType = Schema.getGlobalDescribe().get('FGM_Portal__Portal_User__c');
                Map<String,Schema.SObjectField> mapPortalUserfields = portalUserType.getDescribe().fields.getMap();

                for(String keyField : mapPortalUserMapping.keySet()){
                    // Mapping with Account
                    if((mapAccountMapping != null && !mapAccountMapping.isEmpty() && currentPortalUser.Account__c == null) || (mapAccountMapping != null && !mapAccountMapping.isEmpty() && portalUser.FGM_Portal__ProfileType__c == 'Individual')){
                        if(mapAccountMapping.containsKey(keyField)){
                            // Implamented to avoid error if user configure wrong field in mapping.
                            try{
                                if(mapPortalUserfields.containsKey(mapPortalUserMapping.get(keyField)) && portalUser.get(mapPortalUserMapping.get(keyField)) != null)
                                    portalUser.Account__r.put(mapAccountMapping.get(keyField),portalUser.get(mapPortalUserMapping.get(keyField)));
                            }
                            catch(System.SObjectException ex){
                                continue;
                            }
                        }
                    }
                    // Mapping with Contcat
                    if(mapContactMapping != null && !mapContactMapping.isEmpty() && portalUser.FGM_Portal__Contact__c != null){
                        if(portalUser.FGM_Portal__Contact__r != null){
                            if(mapContactMapping.containsKey(keyField)){
                                if(mapPortalUserfields.containsKey(mapPortalUserMapping.get(keyField)) && portalUser.get(mapPortalUserMapping.get(keyField)) != null)
                                    portalUser.FGM_Portal__Contact__r.put(mapContactMapping.get(keyField),portalUser.get(mapPortalUserMapping.get(keyField)));
                            }
                        }
                    }
                }
            }
            
            // Finally update the portal user with a converted status
            portalUser.FGM_Portal__Approval_Status__c = 'Converted';
            WithoutSharing.executeUpdate(new List<sObject>{portalUser});

            mapPortalUserFieldsToContactAndAccount();            
            
        // Refresh this page to login page to show the confirmation message
            PageReference pageReference = System.Page.CommunitySignupConfirm;
            pageReference.getParameters().put('id', portalUser.Id);
            if(String.isNotBlank(returnURL) && returnURL != null && String.isNotBlank(quizID) && quizID != null ){
                pageReference.getParameters().put('retURL',returnURL);
                if(!returnURL.containsIgnoreCase('quizId')) {
                    pageReference.getParameters().put('quizId',quizID);
                }
            } else if(String.isNotBlank(returnURL) && returnURL != null) {
                pageReference.getParameters().put('retURL',returnURL);
            }

            pageReference.setRedirect(true);
                return pageReference;

        } catch (System.Nullpointerexception nullPointerException){
            isError = true;
            Database.rollback(savepoint);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, nullPointerException.getTypeName() + ': ' + nullPointerException.getMessage()));
            return null;

        } catch (Exception problem){
            isError = true;
            Database.rollback(savepoint);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, problem.getTypeName() + ': ' + problem.getMessage()));
            return null;
        }
    }

    private void setAccountOnPortalUser(Portal_User__c currentPortalUser) {
        if (
            currentPortalUser.Account__c == null
            && currentPortalUser.FGM_Portal__Approval_Status__c != 'Converted'
            && currentPortalUser.FGM_Portal__Organization_Legal_Name__c != null
        ){
            portalUser.Account__r = new Account();
            portalUser.Account__r.Name = currentPortalUser.FGM_Portal__Organization_Legal_Name__c;
            portalUser.Account__r.FGM_Base__EIN__c = portalUser.FGM_Portal__EIN__c;
            portalUser.Account__r.OwnerId = UserAdminId;

            WithoutSharing.executeInsert(new List<sObject>{portalUser.Account__r});

            portalUser.Account__c = portalUser.Account__r.Id;

        } else if (
            portalUser.FGM_Portal__ProfileType__c == 'Individual'
            && (currentPortalUser.Account__c == null  || currentPortalUser.FGM_Portal__Approval_Status__c != 'Converted')
        ) {
            portalUser.Account__r = new Account();
            portalUser.Account__r.Name = 
                portalUser.FGM_Portal__FirstName__c != null ?
                portalUser.FGM_Portal__FirstName__c + ' ' + portalUser.FGM_Portal__LastName__c
                : portalUser.FGM_Portal__LastName__c;

            portalUser.Account__r.OwnerId = UserAdminId;
            WithoutSharing.executeInsert(new List<sObject>{portalUser.Account__r});
            portalUser.Account__c = portalUser.Account__r.Id;

        } else if(currentPortalUser.Account__c != null && portalUser.FGM_Portal__ProfileType__c != 'Individual') {
            portalUser.Account__c = currentPortalUser.Account__c;
        }
    }

    private void createUserFromPortalUser(Portal_User__c currentPortalUser) {
        User user = new User();
        user.Username = portalUser.Name;
        user.Email = portalUser.FGM_Portal__Email__c;
        user.FirstName = portaluser.FGM_Portal__FirstName__c;
        user.LastName = portaluser.FGM_Portal__LastName__c;
        user.FGM_Portal__Return_URL__c = currentPortalUser.FGM_Portal__Return_URL__c ;

        if(
            currentPortalUser.FGM_Portal__Organization_Legal_Name__c.length() > Schema.getGlobalDescribe().get('User').getDescribe().fields.getMap().get('CompanyName').getDescribe().getLength()
            && currentPortalUser.Account__c == null
        ){
            if(portalUser.FGM_Portal__ProfileType__c == 'Individual'){
                user.CompanyName = portalUser.Account__r.Name.substring(0, Schema.getGlobalDescribe().get('User').getDescribe().fields.getMap().get('CompanyName').getDescribe().getLength()-1);
            } else {
                user.CompanyName=currentPortalUser.FGM_Portal__Organization_Legal_Name__c.substring(0, Schema.getGlobalDescribe().get('User').getDescribe().fields.getMap().get('CompanyName').getDescribe().getLength()-1);
            }

        } else if(currentPortalUser.Account__c == null){
            user.CompanyName = (portalUser.FGM_Portal__ProfileType__c == 'Individual')?portalUser.Account__r.Name:currentPortalUser.FGM_Portal__Organization_Legal_Name__c;
        }

        user.ProfileType__c =  portalUser.ProfileType__c;
        user.CommunityNickname =
            (portalUser.Name != null && portalUser.Name.length() > 40) ?
            portalUser.Name.substring(0,39)
            : portalUser.Name + '';

        String accountId = '';
        if(currentPortalUser.Account__c != null && portalUser.ProfileType__c != 'Individual') {
            accountId = currentPortalUser.Account__c;
        } else if(portalUser.Account__c != null) {
            accountId = portalUser.Account__c;
        } else {
            accountId = portalUser.Account__r.Id;
        }

        if(string.isNotBlank(currentPortalUser.FGM_Portal__Return_URL__c) && currentPortalUser.FGM_Portal__Return_URL__c != null){
            returnURL = currentPortalUser.FGM_Portal__Return_URL__c;
        }

        userId = createPortalUser(user, accountId, portaluser.FGM_Portal__Password__c);
        
        //Assign permission set to user using future method
        if(string.isNotBlank(userId)) {
            FCGlobal.assignPermissionSetToUser(userId);
        }
    }                

    private void linkContactToPortalUser(Id newUserId) {
        List<User> newUser = new WithoutSharing()
            .doQuery('SELECT ContactId, FGM_Portal__UserProfile__c FROM User WHERE Id = \'' + newUserId+ '\' WITH SECURITY_ENFORCED');

        if(newUser != null && !newUser.isEmpty()) {
            portalUser.FGM_Portal__Contact__c = newUser[0].ContactId;
            portalUser.FGM_Portal__Contact__r = new Contact();
            portalUser.FGM_Portal__Contact__r.Id = newUser[0].ContactId;
        }
    }

    private void mapPortalUserFieldsToContactAndAccount() {
        List<String> lstPortalUserFields = new List<String>(FGM_Portal__Portal_User__c.SObjectType.getDescribe().fields.getMap().keySet());
        String portalUserId = String.valueOf(portalUser.Id);
        List<FGM_Portal__Portal_User__c> lstPortalUser =
            Database.query(''
                + 'SELECT ' + String.join(lstPortalUserFields, ', ')
                +' FROM FGM_Portal__Portal_User__c'
                +' WHERE Id = :portalUserId'
                +' LIMIT 1'
            );

        SObjectAccessDecision decision = Security.stripInaccessible(AccessType.READABLE, lstPortalUser);
        lstPortalUser = decision.getRecords();

        FGM_Portal__Portal_User__c portalUserUpdatedValues = new FGM_Portal__Portal_User__c();

        if(lstPortalUser != null && lstPortalUser.size()>0) {
            portalUserUpdatedValues =  lstPortalUser[0];
        }
        
        //Start code for Mapping for Portal User to Account and Contact
        List<SObject> accountAndContactToUpdate = new List<SObject>();

        List<CommunityConfiguration__c> communityConfig = [
            SELECT ConfiguationName__c, JsonData__c
            FROM CommunityConfiguration__c
            WHERE ConfiguationName__c = 'PortalUserFieldMapping'
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

        if( !communityConfig.isEmpty() && String.isNotBlank(communityConfig[0].FGM_Portal__JsonData__c ) ){
            Map<String, List<FCGlobal.Field>> mapSobjects = 
                (Map<String, List<FCGlobal.Field>>) JSON.deserialize(communityConfig[0].FGM_Portal__JsonData__c, Map<String,List<FCGlobal.Field>>.class);

            if(mapSobjects != null && mapSobjects.size()>0){
                if(!portalUserUpdatedValues.FGM_Portal__IsCreatedByOpportunityTeamMember__c){
                    List<FCGlobal.Field> accountMappings = (List<FCGlobal.Field>)mapSobjects.get('PortalUserToAccount');
                    if(portalUser.Account__r != null && accountMappings != null){
                        accountAndContactToUpdate.add(buildAccountWithMappedValues(accountMappings, portalUserUpdatedValues));
                    }
                }

                List<FCGlobal.Field> contactMappings = (List<FCGlobal.Field>)mapSobjects.get('PortalUserToContact');
                if(contactMappings != null){
                    accountAndContactToUpdate.add(buildContactWithMappedValues(contactMappings, portalUserUpdatedValues));
                }
            }
        }
        
        UpdatePortalUser.isAccountUpdated = false;
        if(accountAndContactToUpdate != null && accountAndContactToUpdate.size() > 0) {
            new WithoutSharing().doUpdate(accountAndContactToUpdate);
        }

        WithoutSharing.executeUpdate(new List<sObject>{portalUser});
    }

    private Account buildAccountWithMappedValues(List<FCGlobal.Field> fieldMappings, Portal_User__c sourcePortalUser) {
        Set<String> validAccountFields = new Set<String>();

        for (Schema.SObjectField field : Account.sObjectType.getDescribe().fields.getMap().values()) {
            validAccountFields.add(String.valueof(field.getDescribe().getName()));
        }

        Account sAccount = portalUser.Account__r;
        for (FCGlobal.Field field : fieldMappings) {
            if(String.isNotBlank(field.Name) && validAccountFields.contains(field.Name)) {
                sAccount.put(field.Name, sourcePortalUser.get(field.Value));
            }
        }
        return sAccount;
    }

    private Contact buildContactWithMappedValues(List<FCGlobal.Field> fieldMappings, Portal_User__c sourcePortalUser) {
        Set<String> validContactFields = new Set<String>();

        for (Schema.SObjectField field : Contact.sObjectType.getDescribe().fields.getMap().values()) {
            validContactFields.add(String.valueof(field.getDescribe().getName()));
        }

        Contact sContact =  portalUser.Contact__r;
        for (FCGlobal.Field field : fieldMappings) {
            if(String.isNotBlank(field.Name) &&  validContactFields.contains(field.Name)) {
                sContact.put(field.Name, sourcePortalUser.get(field.Value));
            }
        }

        return sContact;
    }

    @TestVisible
    private virtual Id createPortalUser(User aUser, String accountId, String password) {
        return Site.createPortalUser(aUser, accountId, password);
    }
}