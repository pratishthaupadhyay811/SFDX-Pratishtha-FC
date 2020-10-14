/****************************************************************************
Name : CommunityForgotPasswordController
Purpose: This class Used to Reset the Community user password
*****************************************************************************/
public with sharing class CommunityForgotPasswordController{
	public Boolean initialized {get; set;} {initialized = false;}
    public String userName{ get; set;}
    public Boolean isCheckEmail { get; set;}
    public String portalLanguage { get; set;}
    @TestVisible private Boolean isSessionFound;

    public CommunityForgotPasswordController(){
        isSessionFound = (UserInfo.getSessionId() != NULL && UserInfo.getUserType() != 'Guest') ? TRUE : FALSE;
        portalLanguage = System.currentPageReference().getParameters().get('ln');
        if(!String.isBlank(portalLanguage)){
            portalLanguage = String.escapeSingleQuotes(portalLanguage);
        }
        if(!String.isNotBlank(portalLanguage)){
            portalLanguage = 'en_US';
        }
    }

/**********************************************************************************
Purpose: This method redirect the user to community Dashboard if user session found
Parameters:[]
Returns: [PageReference]
***********************************************************************************/
    public PageReference initialize()
    {
        initialized = true;
        userName = '';
        if( isSessionFound ){
            return Page.CommunityDashboard;
        }else{
            return NULL;
        }
    }

/**********************************************************************************
Purpose: This method used to show logo for forgot Password Page
Parameters:[]
Returns: [String]
***********************************************************************************/
    // logo for forgot Password Page

    public String getImageLogoUrl(){
        List<Document> lstDocument = new List<Document>();

        String labelName = Label.FC_Logo_Name;

        if (String.isNotBlank(labelName)) {

            lstDocument  = [
                SELECT Name
                FROM Document
                WHERE Name = :labelName
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

        }

        if (lstDocument != NULL && lstDocument.size() > 0) {
            return '/servlet/servlet.FileDownload?file=' + lstDocument[0].Id;
        }

        return null;
    }

/**********************************************************************************
Purpose: This method contains actual code to redirect user to reset password
Parameters:[]
Returns: [Pagereference]
***********************************************************************************/
    public Pagereference forgotPassword(){
        Boolean success = FALSE;
        if(String.isBlank(userName)){
            ApexPages.addMessage(NEW ApexPages.message(ApexPages.severity.Error,String.escapeSingleQuotes(System.Label.FC_ForgotPassword_userName_Required)));
            isCheckEmail = FALSE;
            return NULL;
        }

        if(String.isNotBlank(userName)) {
            String strUserName = userName + '@' + Site.getDomain();

            success = Site.forgotPassword(strUserName);

            if(success){
                isCheckEmail = TRUE;
            }else {
                userName = '';
                isCheckEmail = FALSE;
                ApexPages.addMessage(NEW ApexPages.message(ApexPages.severity.Error,String.escapeSingleQuotes(System.Label.FC_ForgotPassword_InvalidUser_ErrorMsg)));
            }
        }
        return NULL;
    }
}