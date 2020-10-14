public with sharing class CommunitySigninController {
    public Boolean initialized {get; set;} {initialized = false;}
    //Properties required to display on this page
    public static final String STR_FC_LOGO = Label.FC_Logo_Name;
    public boolean isSessionFound { get; set;}
    public String strURL {get; set;}
    public String portalLanguage { get; set;}
    public List<SelectOption> lstLanguageOptions { get; set; }
    public String username { set; get; }
    public String password { set; get; }
    public string returnURL{ get; set; }
    public string profileType { get; set;}
    public Boolean isReviewerURL;
    public Boolean invalidCredential{get;set;}
    public String currentFieldSetName;
    List<User> lstUser ;
    public String strUsername;
    public String strDomain;
    public string userProfile;
    public PageReference reference;
    public SFDCEncoder ESAPI = new SFDCEncoder();
    public String domainName = Site.getDomain();
    public Boolean isIExplorer {get;set;}
    public Boolean userUITheme{get;set;}
    //constructor
    public CommunitySigninController(){
        if(!Test.isRunningTest()){
            if(ApexPages.currentPage().getHeaders().get('USER-AGENT').indexOf('Trident') >= 0){
                if(ApexPages.currentPage().getHeaders().get('USER-AGENT').indexOf('MSIE 10.0') >= 0 || ApexPages.currentPage().getHeaders().get('USER-AGENT').indexOf('MSIE 9.0') >= 0 || ApexPages.currentPage().getHeaders().get('USER-AGENT').indexOf('MSIE 8.0') >= 0 || ApexPages.currentPage().getHeaders().get('USER-AGENT').indexOf('MSIE 7.0') >= 0){
                    isIExplorer = true;
                }
            }
            else{
                isIExplorer = false;
            }
        }
        invalidCredential = false;
        FCGlobal.UserSession userSession = FCGlobal.getUserSession(UserInfo.getUserId());
        portalLanguage = ESAPI.SFDC_HTMLENCODE(System.currentPageReference().getParameters().get('ln'));
        portalLanguage = ESAPI.SFDC_HTMLENCODE(portalLanguage);
        lstUser = new List<user>();
        strDomain = '';
        userProfile = getParam('UType');
        strUsername = getParam('un');
        isReviewerURL = false;
        isReviewerURL = FCGlobal.validateUrl();
        if(UserInfo.getUserId() != null){
            if(isReviewerURL == false){
                if( UserInfo.getSessionId() != null && UserInfo.getUserType() != 'Guest' && userSession.UserPortalType == 'Grantee'){
                    String retUrlContinue = null;
                    retUrlContinue = ESAPI.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('retUrl'));
                    if(retUrlContinue != null && String.isNotBlank(retUrlContinue)){
                        if(getParam('quizId') != null && getParam('quizId') != ''){
                            strURL = retUrlContinue+'&quizId='+getParam('quizId');
                        }
                        else{
                            strURL = retUrlContinue;
                        }
                    }
                    else{
                        PageReference refGranteeDashboard = System.Page.CommunityDashboard;
                        strURL = String.ValueOf(refGranteeDashboard.getUrl());
                    }
                }
                if (UserInfo.getSessionId() != null && UserInfo.getUserType() == 'Guest') {
                    isSessionFound = false;
                } else if (UserInfo.getSessionId() == null) {
                    isSessionFound = false;
                } else {
                    isSessionFound = true;
                }
            }
        }

        if(String.isBlank(portalLanguage)){
            portalLanguage = 'en_US';
        }
        initializePortalLanguages();
        if(String.isNotBlank(userProfile) && userProfile.equalsIgnoreCase('Individual')){
            profileType = 'Individual';
            currentFieldSetName = 'Grantee Sign In';
        }else{
            profileType = 'Organization';
            currentFieldSetName = 'Grantee Sign In';
        }
        if(String.isNotBlank(strUsername)){
            username = strUsername;
        }
        returnURL = ESAPI.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('retUrl'));
        if(ApexPages.currentPage().getParameters().get('quizId')!=null){
            returnURL = returnURL + '&quizId=' + String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('quizId'));
        }
        if(ApexPages.currentPage().getParameters().get('id')!=null){
            returnURL = returnURL + '&id=' + String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        }
    }
        /************************************************************************************************************
Purpose: This method is used to redirect user into CommunityDashboard page if session found.
Parameters: NA
Throws [Exceptions]: [optional]
Return : PageReference
*****************************************************************************************************************/
    public PageReference initialize(){
        initialized = true;
        if(isSessionFound){
            String rturl = ESAPI.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('retUrl'));
            if(rturl != null){
                if(ApexPages.currentPage().getParameters().get('quizId')!=null){
                    rturl = rturl + '&quizId=' + String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('quizId'));
                }
                PageReference refRetUrl = new PageReference(rturl.startsWith('/') ? rturl : '/' + rturl);
                return refRetUrl;
            }
            else{
                return Page.CommunityDashboard;
            }
        }
        else{
            return null;
        }
    }
        /************************************************************************************************************
Purpose: This method is used for getting customHTML object record to describe on communitysignin page.
Parameters: NA
Throws [Exceptions]: [optional]
Return : String
*****************************************************************************************************************/
    public CustomHTML__c getCustomHTMLDescription(){
        if(String.isBlank(portalLanguage)){
            portalLanguage = 'en_US';
        }
        if(String.isNotBlank(currentFieldSetName)){

            return [
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
        return null;
    }
    public String getParam(String name) {
        return ESAPI.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get(name));
    }
        /************************************************************************************************************
Purpose: This method is used to initialize user theme(classic/lightning).
Parameters: NA
Throws [Exceptions]: [optional]
Return : Pagereference
*****************************************************************************************************************/
    public Pagereference initializeTheme(){
        if(userUITheme){
            userUITheme = userUITheme;
        }
        else{
            userUITheme = false;
        }
        return null;
    }
        /************************************************************************************************************
Purpose: This method is used for getting logo for communitysignin page.
Parameters: NA
Throws [Exceptions]: [optional]
Return : String
*****************************************************************************************************************/
    public String getImageLogoUrl(){

        List<Document> lstDocument = [
            SELECT Name
            FROM Document
            WHERE Name = :STR_FC_LOGO
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

        if(lstDocument != null && lstDocument.size() > 0){
            return Site.getPathPrefix()+'/servlet/servlet.FileDownload?file='+lstDocument[0].Id;
        }
        return null;
    }
        /************************************************************************************************************
Purpose: This method is used for getting All Portal Languages.
Parameters: NA
Throws [Exceptions]: [optional]
Return : void
*****************************************************************************************************************/
    private void initializePortalLanguages(){
        if(lstLanguageOptions == null || lstLanguageOptions.isEmpty()){
            lstLanguageOptions = new List<SelectOption>();
            lstLanguageOptions = FCGlobal.getPortalLanguage();
        }
    }
        /************************************************************************************************************
Purpose: This method is used to redirect user into communityForgotPassword page on click of cannot access account button.
Parameters: NA
Throws [Exceptions]: [optional]
Return : PageReference
*****************************************************************************************************************/
    public PageReference cannotAccessAccount(){
        PageReference refCommunityForgotPassword = System.Page.CommunityForgotPassword;
        refCommunityForgotPassword.getParameters().put('ln', portalLanguage);
        refCommunityForgotPassword.setRedirect(true);
        return refCommunityForgotPassword;
    }
        /************************************************************************************************************
Purpose: This method is used to redirect user into CommunitySignup page on click of New User button.
Parameters: NA
Throws [Exceptions]: [optional]
Return : PageReference
*****************************************************************************************************************/
    public PageReference newUser(){
        PageReference refCommunitySignup = System.Page.CommunitySignup;
        refCommunitySignup.getParameters().put('ln', portalLanguage);
        refCommunitySignup.getParameters().put('retUrl',returnURL );
        refCommunitySignup.setRedirect(true);
        return refCommunitySignup;
    }
        /************************************************************************************************************
Purpose: This method is used for validating user entered credential and redriect user into CommunityDashboard if credentials are validated.
Parameters: NA
Throws [Exceptions]: [Exception]
Return : PageReference
*****************************************************************************************************************/
    public PageReference save() {
        try {
            invalidCredential = false;
            lstUser = new List<user>();
            strDomain =  Site.getDomain();
            String strUserName = username + '@' + domainName;

            lstUser = new WithoutSharing()
                .doQuery(
                    'SELECT IsActive, Return_URL__c, User.contactId, UserProfile__c, Username FROM User WHERE Username = \''
                    + String.escapeSingleQuotes(strUserName)
                    + '\' WITH SECURITY_ENFORCED LIMIT 1'
                );

            if(lstUser != null && lstUser.size() > 0) {
                if(lstUser[0].IsActive == true) {
                    String strGranteeDashboardPage = '';
                    String retUrl = null;
                    String strAppURL = null;
                    if(!Test.isRunningTest()) {         // if(!Test.isRunningTest()){ --- }   will exclude the code in test method
                        PageReference refGranteeDashboard = System.Page.CommunityDashboard;
                        if(userUITheme){
                            strGranteeDashboardPage = '/s/fCCommunityDashboard';
                        }
                        else{
                            strGranteeDashboardPage = String.ValueOf(refGranteeDashboard.getUrl());
                        }
                        retUrl = ESAPI.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('retUrl'));
                        if(lstUser[0] != null && string.isNotEmpty(lstUser[0].Return_URL__c) && 'Grantee'.equalsIgnoreCase(lstUser[0].UserProfile__c)){
                            reference = Site.login(username + '@' + Site.getDomain(), password,lstUser[0].Return_URL__c.substring(7));
                            if(reference != null){
                                new WithoutSharing().doUpdate(
                                    new User(Id = lstUser[0].Id, Return_URL__c = null)
                                );
                            }
                            else{
                                invalidCredential = true;
                            }
                        }
                        else if(retUrl != null){
                            if(getParam('quizId') != null && getParam('quizId') != ''){
                                strAppURL = retUrl+'&quizId='+getParam('quizId');
                            }
                            else{
                                strAppURL = retUrl;
                            }
                            reference = Site.login(username + '@' + Site.getDomain(), password,strAppURL);
                            if(reference == null){
                                invalidCredential = true;
                            }
                        }
                        else {
                            if('Grantee;Reviewer'.equalsIgnoreCase(lstUser[0].FGM_Portal__UserProfile__c)){
                                reference = Site.login(username + '@' + Site.getDomain(), password, strGranteeDashboardPage);
                            }
                            else if('Reviewer;Grantee'.equalsIgnoreCase(lstUser[0].FGM_Portal__UserProfile__c)){
                                reference = Site.login(username + '@' + Site.getDomain(), password, strGranteeDashboardPage);
                            }
                            else{
                                if('Grantee'.equalsIgnoreCase(lstUser[0].FGM_Portal__UserProfile__c) ){
                                    reference = Site.login(username + '@' + Site.getDomain(), password, strGranteeDashboardPage);
                                }
                            }
                            if(reference == null){
                                invalidCredential = true;
                            }
                        }
                    }
                    if(reference != null) {
                        FCGlobal.initilizeSession(lstUser[0].Id);
                        FCGlobal.setUserPortalProfile(lstUser[0].Id,'Grantee');
                        FCGlobal.setUserLanguage(lstUser[0].Id,portalLanguage);
                        return reference;
                    }
                } else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.Label.FC_InActiveUser_ErrorMsg));
                    return null;
                }
            } else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.Label.FC_InvalidSigninCredential_ErrorMsg));
                return null;
            }
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.Label.FC_InvalidSigninCredential_ErrorMsg));
            return null;
        }
        return null;
    }
}