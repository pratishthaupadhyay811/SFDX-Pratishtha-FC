@isTest
public with sharing class TestsObjectProvider{
    public final static string PORTAL_RELATEDLISTCONTROLLER_PORTALTAB = 'Portal Tab';
    public final static string PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB = 'Related List With Tab';
    public final static string PORTAL_RELATEDLISTCONTROLLER_GRANTEEBUDGETTAB = 'Grantee Budget Tab';
    public final static string PORTAL_RELATEDLISTCONTROLLER_IFRAMETAB = 'IFrame Tab';
    public final static string PORTAL_RELATEDLISTCONTROLLER_CONTACTTAB = 'Contact Tab';
    public final static string PORTAL_RELATEDLISTCONTROLLER_ORGANIZATIONTAB = 'Organization Tab';
    public final static string PORTAL_RELATEDLISTCONTROLLER_GRANTEEBUDGETUPDATETAB = 'Grantee Budget Update Tab';
    public final static string PORTAL_QUESTION_RECORDFIELD = 'Record Field';
    public final static string PORTAL_QUESTION_QUIZ = 'Quiz';
    public final static string PORTAL_GRANTEEREPORT_NARRATIVEREPORT = 'Narrative Report';
    public final static string PORTAL_GUIDESTAR_GUIDEPORTALUSER = 'GuideStar Portal User';
    public final static string PORTAL_GUIDESTAR_GUIDECONTACT = 'Guidestar Contact';
    public final static string PORTAL_GUIDESTAR_GUIDEORGANIZATION = 'Guidestar Organization';
    public final static string PORTAL_USER_OPPTEAMMEMBER = 'Opportunity Team Member';
    public final static string PORTAL_QUIZ_QUIZ = 'Quiz';
    public final static string PORTAL_QUIZ_APPLICATION = 'Application';
    public final static string PORTAL_PAGELAYOUT_CONTACTAMENDMENT = 'Contact';
    public final static string PORTAL_PAGELAYOUT_ACCOUNTAMENDMENT = 'Organization';

    public static Account CreateAccount(string strName){
        Account account = new Account();
        account.Name = strName;
        return account;
    }

    public static FGM_Portal__Grantee_Budget_Category__c CreateGranteeBudgetCategory(string strName){
        FGM_Portal__Grantee_Budget_Category__c objCategory = new FGM_Portal__Grantee_Budget_Category__c();
        objCategory.Name = strName;
        objCategory.FGM_Portal__IsActive__c=true;
        return objCategory;
    }

    public static FGM_Portal__Grantee_Budget__c CreateGranteeBudget(string strName){
        FGM_Portal__Grantee_Budget__c objGranteeBudget = new FGM_Portal__Grantee_Budget__c();
        objGranteeBudget.Name = strName;
        return objGranteeBudget;
    }

    public static FGM_Portal__Grantee_Budget_Configuration__c CreateGranteeBudgetConfig(string strQuiz){
        FGM_Portal__Grantee_Budget_Configuration__c objBudgetConfig = new FGM_Portal__Grantee_Budget_Configuration__c();
        objBudgetConfig.FGM_Portal__Quiz__c = strQuiz;
        return objBudgetConfig;
    }

    public static FGM_Portal__Recommendation__c CreateRecommendation(string strName, string strEmail, string strOpportunity,boolean isCommunityRecord){
        FGM_Portal__Recommendation__c objRecommendation = new FGM_Portal__Recommendation__c();
        objRecommendation.Name = strName;
        objRecommendation.FGM_Portal__Recommender_Email__c = strEmail;
        objRecommendation.FGM_Portal__Is_Community_Record__c = isCommunityRecord;
        objRecommendation.FGM_Portal__Opportunity__c = strOpportunity;
        return objRecommendation;
    }

    public static FGM_Portal__Grantee_Budget_Line_Item__c CreateGranteeBudgetLineItem(string strOpportunity, string strGranteeBudget){
        FGM_Portal__Grantee_Budget_Line_Item__c objBudgetLineItem = new FGM_Portal__Grantee_Budget_Line_Item__c();
        objBudgetLineItem.FGM_Portal__Opportunity__c = strOpportunity;
        objBudgetLineItem.FGM_Portal__Grantee_Budget__c = strGranteeBudget;
        return objBudgetLineItem;
    }

    public static FGM_Base__Grantee_Report__c CreateGranteeReport(string strRequest){
        FGM_Base__Grantee_Report__c objGranteeReport = new FGM_Base__Grantee_Report__c();
        objGranteeReport.FGM_Base__Request__c = strRequest;
        return objGranteeReport;
    }

    public static FGM_Portal__Grantee_Budget_Update__c CreateGranteeBudgetUpdate(string strGranteeRpt, string strBudgetLineItem){
        FGM_Portal__Grantee_Budget_Update__c objGranteeBudgetUpdate = new FGM_Portal__Grantee_Budget_Update__c();
        objGranteeBudgetUpdate.FGM_Portal__Grantee_Report__c = strGranteeRpt;
        objGranteeBudgetUpdate.FGM_Portal__Grantee_Budget_Line_Item__c = strBudgetLineItem;
        return objGranteeBudgetUpdate;
    }

    /*public static FGM_Portal__Portal_Permission__c CreatePortalPermission(){
FGM_Portal__Portal_Permission__c objPortalPermission = new FGM_Portal__Portal_Permission__c();
return objPortalPermission;
}*/

    public static FGM_Portal__CommunityConfiguration__c createCommunityConfigurationRecord(String recordName, String jsonData)
    {
        FGM_Portal__CommunityConfiguration__c objCommunityConfiguration = new FGM_Portal__CommunityConfiguration__c();
        objCommunityConfiguration.FGM_Portal__ConfiguationName__c = recordName;
        objCommunityConfiguration.FGM_Portal__JsonData__c = jsonData;
        return objCommunityConfiguration;
    }
    public static FGM_Portal__CustomValidation__c createCustomValidationConfiguration(String recordName, String language, String validationExpression, String errorMessage)
    {
        FGM_Portal__CustomValidation__c objCustomValidation = new FGM_Portal__CustomValidation__c();
        objCustomValidation.Name = recordName;
        objCustomValidation.FGM_Portal__LanguageSelection__c = language;
        objCustomValidation.FGM_Portal__Regular_Expression__c =validationExpression;
        objCustomValidation.FGM_Portal__Error_Message__c = errorMessage;
        return objCustomValidation;
    }
    public static FGM_Portal__PortalAlertSettings__c createPortalAlertConfiguration(string recordName, String objectName,String statusValues, String recordColor, Decimal timeTrigger, String dateFieldApi)
    {
        FGM_Portal__PortalAlertSettings__c objPortalAlertSetting = new FGM_Portal__PortalAlertSettings__c();
        objPortalAlertSetting.Name = recordName;
        objPortalAlertSetting.FGM_Portal__Object__c = objectName;
        objPortalAlertSetting.FGM_Portal__Status__c = statusValues;
        objPortalAlertSetting.FGM_Portal__Color__c = recordColor;
        objPortalAlertSetting.FGM_Portal__Time_Trigger__c = timeTrigger;
        objPortalAlertSetting.FGM_Portal__Use_Due_Date__c = dateFieldApi;
        return objPortalAlertSetting;
    }
    public static Document CreateDocument(string strName){
        Blob b = Blob.valueOf('Text to Display');
        Document document = new Document();
        document.Name = strName;
        document.Body = b;
        document.FolderId = UserInfo.getUserId();
        document.AuthorId = UserInfo.getUserId();
        return document;
    }

    public static Contact CreateContact(string strFirstName, string strLastName, string strAccountId, string strEmail){
        Contact contact = new Contact();
        contact.FirstName = strFirstName;
        contact.LastName = strLastName;
        contact.Email = strEmail;
        contact.AccountId = strAccountId;
        return contact;
    }

    public static Lead CreateLead(string strFirstName, string strLastName, string strCompany, string strStatus){
        Lead lead = new Lead();
        lead.FirstName = strFirstName;
        lead.LastName = strLastName;
        lead.Company = strCompany;
        lead.Status = strStatus;
        return lead;
    }

    /* public static Case CreateCase(string strAccountId, string strOrigin, string strDescription){
Case newcase = new Case();
newcase.AccountId = strAccountId;
newcase.Origin = strOrigin;
newcase.Description = strDescription;
return newcase;
}*/

    public static Attachment CreateAttachment(string strName, string strParentId){
        Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment();
        attachment.Name = strName;
        attachment.ParentId = strParentId;
        attachment.Body = b;
        return attachment;
    }

    public static Campaign CreateCampaign(string strName, string strEmail, Date dtEnd, Date dtStart, string strPortalQuizId, string strParameters){
        Campaign campaign = new Campaign();
        campaign.Name = strName;
        campaign.Email__c = strEmail;
        campaign.EndDate = dtEnd;
        campaign.StartDate = dtStart;
        campaign.Application_Quiz__c = strPortalQuizId;
        campaign.FGM_Portal__Application_Type__c='Application Quiz';
        campaign.FGM_Portal__Parameters__c = strParameters;
        return campaign;
    }
    public static Campaign CreateLOICampaign(string strName, string strEmail, Date dtEnd, Date dtStart, string strPortalQuizId, string strParameters){
        Campaign campaign = new Campaign();
        campaign.Name = strName;
        campaign.Email__c = strEmail;
        campaign.EndDate = dtEnd;
        campaign.StartDate = dtStart;
        campaign.FGM_Portal__LOI_Quiz__c = strPortalQuizId;
        campaign.FGM_Portal__Application_Type__c='LOI Quiz';
        campaign.FGM_Portal__LOI_Prameters__c = strParameters;
        return campaign;
    }
    public static CampaignMember CreateCampaignMember( string strCampaignId, string strContactId, string strStatus){
        CampaignMember campaignMember = new CampaignMember();
        campaignMember.CampaignId = strCampaignId;
        campaignMember.ContactId = strContactId;
        campaignMember.Status = strStatus;
        return campaignMember;
    }

    /* public static OpportunityContactRole CreateOpportunityContactRole( string strOppId, string strContactId, string strRole, boolean bPrimary){
OpportunityContactRole OppContactRole = new OpportunityContactRole();
OppContactRole.ContactId = strContactId;
OppContactRole.IsPrimary = bPrimary;
OppContactRole.OpportunityId = strOppId;
OppContactRole.Role = strRole;
return OppContactRole;
}*/

    public static OpportunityTeamMember CreateOpportunityTeamMember( string strOppId, string strTeamRole, string strUserId){
        OpportunityTeamMember newOpportunityTeamMember = new OpportunityTeamMember();
        newOpportunityTeamMember.OpportunityId = strOppId;
        newOpportunityTeamMember.TeamMemberRole = strTeamRole;
        newOpportunityTeamMember.UserId = strUserId;
        return newOpportunityTeamMember;
    }

    /*  public static UserRole CreateUserRole( string strName){
UserRole userRole = new UserRole();
userRole.Name = strName;
return userRole;
}*/

    public static User CreateUser( string strContactId, string strEmail, string strFirstName, string strLastName, string strUserName, boolean bActive, string strProfile, string strCompanyName){
        User user = new User();
        user.ContactId = strContactId;
        user.Email = strEmail;
        user.FirstName = strFirstName;
        user.LastName = strLastName;
        user.Alias = 'OSF';
        user.IsActive = bActive;
        user.Username = strUserName;
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.CompanyName = strCompanyName;
        Profile profile = [SELECT Id
                           FROM Profile
                           WHERE Name = :strProfile
                          ];
        user.ProfileId = profile.Id;
        return user;
    }

    public static User createUserWithProfile(String profileName) {
        String email = 'fcTestUser@example.com';
        Profile userProfile = [SELECT Id FROM Profile WHERE Name = :profileName];
        User testUser =  new User(
            Alias = 'jdoe',
            Email = email,
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LastName = 'Doe',
            LocaleSidKey = 'en_US',
            ProfileId = userProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = email + Datetime.now().getTime(),
            IsActive = true
        );

        insert testUser;
        return testUser;
    }

    public static Task CreateTask( string strAccountId, string strSubject, Date dtActivity, string strStatus){
        Task task = new Task();
        task.WhatId = strAccountId;
        task.Subject = strSubject;
        task.ActivityDate = dtActivity;
        task.Status = strStatus;
        return task;
    }

    public static Opportunity CreateOpportunity( string strName, string strStageName, Date dtClosed ){
        Opportunity opportunity = new Opportunity();
        opportunity.Name = strName;
        opportunity.StageName = strStageName;
        opportunity.CloseDate = dtClosed;
        return opportunity;
    }

    public static FGM_Portal__Portal_Account__c CreateFGMPortalAccount(string strAccountId, string strName){
        FGM_Portal__Portal_Account__c PortalAccount = new FGM_Portal__Portal_Account__c();
        PortalAccount.Name = strName;
        PortalAccount.FGM_Portal__Account__c = strAccountId;
        return PortalAccount;
    }

    public static FGM_Portal__Portal_User__c CreateFGMPortalUser(string strPortalAccountId, string strName, string strLastName, string strEmail, string strConfirmEmail, string strUserName, string strPassword, string strConfirmPassword, boolean bTermsAndConditions){
        FGM_Portal__Portal_User__c PortalUser = new FGM_Portal__Portal_User__c();
        PortalUser.FGM_Portal__Portal_Account__c = strPortalAccountId;
        PortalUser.FGM_Portal__Organization_Legal_Name__c = strName;
        PortalUser.FGM_Portal__LastName__c = strLastName;
        PortalUser.FGM_Portal__Email__c = strEmail;
        PortalUser.FGM_Portal__Confirm_Email__c = strConfirmEmail;
        PortalUser.Name = strUserName;
        PortalUser.FGM_Portal__Password__c = strPassword;
        PortalUser.FGM_Portal__Confirm_Password__c = strConfirmPassword;
        PortalUser.FGM_Portal__Terms_And_Conditions__c = bTermsAndConditions;
        return PortalUser;
    }

    public static FGM_Portal__Questions__c CreateFGMPortalQuestion(string strQuestion, string strPreText, string strPostText, string strHelpTip, string strType, string strQuizId, string strAttachmentFormula, string strRecordTypeId ){
        FGM_Portal__Questions__c PortalQuestion = new FGM_Portal__Questions__c();
        PortalQuestion.FGM_Portal__RichQuestion__c = strQuestion;
        PortalQuestion.FGM_Portal__RichPreText__c = strPreText;
        PortalQuestion.FGM_Portal__RichPostText__c = strPostText;
        PortalQuestion.FGM_Portal__Help_Tip__c = strHelpTip;
        PortalQuestion.FGM_Portal__Type__c = strType;
        PortalQuestion.Quiz__c = strQuizId;
        PortalQuestion.AttachmentNameFormula__c = strAttachmentFormula;
        PortalQuestion.RecordTypeId = strRecordTypeId;
        return PortalQuestion;
    }

    public static FGM_Portal__Quiz_Questions__c CreateFGMPortalQuizQuestion(string strQuestionId, double dSortOrder, string strField, string strLayout, double dLength, string strPage, string strTabId, boolean bRequired, string strQuizId ){
        FGM_Portal__Quiz_Questions__c PortalQuizQuestion = new FGM_Portal__Quiz_Questions__c();
        PortalQuizQuestion.FGM_Portal__Question__c = strQuestionId;
        PortalQuizQuestion.FGM_Portal__Sort_Order__c = dSortOrder;
        PortalQuizQuestion.Field__c = strField;
        PortalQuizQuestion.Required__c = bRequired;
        PortalQuizQuestion.Tab__c = strTabId;
        PortalQuizQuestion.FGM_Portal__Quiz__c = strQuizId;
        return PortalQuizQuestion;
    }

    public static FGM_Portal__Question_Responses__c CreateFGMPortalQuestionResponse(string strQuestionId, boolean bActive, boolean bAcceptedResponse ){
        FGM_Portal__Question_Responses__c FGMPortalQuestionResponses = new FGM_Portal__Question_Responses__c();
        FGMPortalQuestionResponses.FGM_Portal__Eligibility_Question__c = strQuestionId;
        FGMPortalQuestionResponses.FGM_Portal__Is_Active__c = bActive;
        FGMPortalQuestionResponses.FGM_Portal__Accepted_Response__c = bAcceptedResponse;
        return FGMPortalQuestionResponses;
    }

    public static Question_Attachment__c CreateQuestionAttachment(string strQuestionId, string strOpportunityId, string strInquiryId, string strGranteeReportId ){
        Question_Attachment__c QuestionAttachment = new Question_Attachment__c();
        QuestionAttachment.Question__c = strQuestionId;
        QuestionAttachment.Opportunity__c = strOpportunityId;
        QuestionAttachment.Inquiry__c = strInquiryId;
        QuestionAttachment.GranteeReport__c = strGranteeReportId;
        return QuestionAttachment;
    }

    public static FGM_Portal__Quiz__c CreateFGMPortalQuiz(string strName, string strEmail, string strPageName1, string strPageName2, string strPageName3, string strPageName4, string strPageName5, string strPortalIntroduction, boolean bPortalIsActive ){
        FGM_Portal__Quiz__c PortalQuiz = new FGM_Portal__Quiz__c();
        PortalQuiz.Name = strName;
        PortalQuiz.FGM_Portal__Introduction_Text__c = strPortalIntroduction;
        PortalQuiz.FGM_Portal__Is_Active__c = bPortalIsActive;
        return PortalQuiz;
    }

    public static FGM_Portal__Related_List_Controller__c CreateFGMPortalRelatedListController(string strName, string strAssociatedPortalType, string strAssociatedTabType, string strObjectName, string strParentObject, string strLookupField, string strFieldHeaders, string strFieldNames, string strRecordTypeId, string strQuizId){
        String DefaultLanguageCode = 'en_US';
        FGM_Portal__Related_List_Controller__c PortalRelatedListCont = new FGM_Portal__Related_List_Controller__c();
        PortalRelatedListCont.Name = strName;
        PortalRelatedListCont.FGM_Portal__Associated_FC_Portal_Type__c = strAssociatedPortalType;
        PortalRelatedListCont.FGM_Portal__Associated_Tab_Type__c = strAssociatedTabType;
        PortalRelatedListCont.FGM_Portal__ObjectName__c = strObjectName;
        PortalRelatedListCont.FGM_Portal__ParentObject__c = strParentObject;
        PortalRelatedListCont.FGM_Portal__LookupField__c = strLookupField;
        PortalRelatedListCont.FGM_Portal__FieldHeaders__c = strFieldHeaders;
        PortalRelatedListCont.FGM_Portal__FieldNames__c = strFieldNames;
        PortalRelatedListCont.Quiz__c = strQuizId;
        PortalRelatedListCont.RecordTypeId = strRecordTypeId;
        PortalRelatedListCont.Language__c = DefaultLanguageCode;
        return PortalRelatedListCont;
    }

    public static Secure_Message__c CreateSecureMessage( string strBody, string strProposalId, string strRecipientId, string strSenderId, string strSubject, string strRef){
        Secure_Message__c SecureMessage = new Secure_Message__c();
        SecureMessage.Body__c = strBody;
        SecureMessage.Proposals__c = strProposalId;
        SecureMessage.Recipient__c = strRecipientId;
        SecureMessage.Sender__c = strSenderId;
        SecureMessage.Subject__c = strSubject;
        SecureMessage.RefId__c = strRef;
        return SecureMessage;
    }

    public static FGM_Base__Grantee_Report__c CreateFGMBaseGranteeReport( string strRecordTypeId, string strRequestId, string strStatus){
        FGM_Base__Grantee_Report__c BaseGranteeReport = new FGM_Base__Grantee_Report__c();
        BaseGranteeReport.FGM_Base__Request__c = strRequestId;
        BaseGranteeReport.FGM_Base__Status__c = strStatus;
        return BaseGranteeReport;
    }

    public static FGM_Portal__Triggers__c CreateFGMPortalTriggers(){
        FGM_Portal__Triggers__c FGMPortalTriggers = new FGM_Portal__Triggers__c();
        FGMPortalTriggers.Name = 'CommunityPortalTriggerSettings';
        FGMPortalTriggers.FGM_Portal__OnContactInsert__c = true;
        FGMPortalTriggers.FGM_Portal__OnPortalPermissionInsert__c = true;
        FGMPortalTriggers.Trigger_OnGranteeReport__c = true;
        FGMPortalTriggers.Trigger_OnQuiz__c = true;
        FGMPortalTriggers.Trigger_OnPortalUser__c = true;
        FGMPortalTriggers.Trigger_OnOpportunity__c = true;
        FGMPortalTriggers.Trigger_OnSecureMessage__c = true;
        FGMPortalTriggers.Trigger_OnRelatedListController__c = true;
        FGMPortalTriggers.Trigger_OnQuizQuestions__c = true;
        FGMPortalTriggers.Trigger_OnLead__c = true;
        return FGMPortalTriggers;
    }

    public static Amendment__c CreateAmendment( string strAccountId, string strStageName, string strBankAccountId, string strOppId, Date dtStart, Date stEnd){
        Amendment__c Amendment = new Amendment__c();
        Amendment.Account__c = strAccountId;
        Amendment.StageName__c = strStageName;
        Amendment.ParentRequest__c = strOppId;
        Amendment.Proposed_Grant_Start_Date__c = dtStart;
        Amendment.Proposed_Grant_End_Date__c = stEnd;
        return Amendment;
    }

    public static FCPageLayout__c CreateFCPageLayout(string strName, string strRecordTypeId, string strObjectName, string strQuizId ){
        FCPageLayout__c FCPageLayout = new FCPageLayout__c();
        FCPageLayout.RecordTypeId__c = strRecordTypeId;
        FCPageLayout.ObjectName__c = strObjectName;
        FCPageLayout.Name = strName;
        FCPageLayout.Quiz__c = strQuizId;
        return FCPageLayout;
    }

    public static FGM_Portal__CustomHTML__c CreateFGMPortalCustomHTML ( string strName, string strPortalType, string strPortalLanguage, string strPortalLocation, string strDescription){
        FGM_Portal__CustomHTML__c FGMPortalCustomHTML = new FGM_Portal__CustomHTML__c();
        FGMPortalCustomHTML.FGM_Portal__Associated_FC_Portal_Type__c = strPortalType;
        FGMPortalCustomHTML.FGM_Portal__Language__c = strPortalLanguage;
        FGMPortalCustomHTML.FGM_Portal__Location__c = strPortalLocation;
        FGMPortalCustomHTML.FGM_Portal__RichDescription__c = strDescription;
        FGMPortalCustomHTML.Name = strName;
        return FGMPortalCustomHTML;
    }

    public static FGM_Base__Benchmark__c CreateFGMBaseBenchmark( string strRequestId, string strStatus, boolean bRequired, boolean bIncludeAggrement, Date dtDue, boolean bCompleted){
        FGM_Base__Benchmark__c FGMBaseBenchmark = new FGM_Base__Benchmark__c();
        FGMBaseBenchmark.FGM_Base__Request__c = strRequestId;
        FGMBaseBenchmark.FGM_Base__Status__c = strStatus;
        FGMBaseBenchmark.FGM_Base__Required__c = bRequired;
        FGMBaseBenchmark.FGM_Base__Include_in_Agreement__c = bIncludeAggrement;
        FGMBaseBenchmark.FGM_Base__Due_Date__c = dtDue;
        FGMBaseBenchmark.FGM_Base__Completed__c = bCompleted;
        return FGMBaseBenchmark;
    }

    /* public static FGM_Base__Program__c CreateFGMBaseProgram( string strName, string strAccount, boolean bActive, boolean bLeadParentProgram, string strGoal){
FGM_Base__Program__c FGMBaseProgram = new FGM_Base__Program__c();
FGMBaseProgram.Name = strName;
FGMBaseProgram.FGM_Base__Account__c = strAccount;
FGMBaseProgram.FGM_Base__Active__c = bActive;
FGMBaseProgram.FGM_Base__Goal__c = strGoal;
return FGMBaseProgram;
}*/

    public static FGM_Portal__GuidestarFieldMapping__c CreateFGMPortalGuidestarFieldMapping( string strRecordTypeId, string strRegisteredName, string strOrganization){
        FGM_Portal__GuidestarFieldMapping__c FGMPortalGuidestarFieldMapping = new FGM_Portal__GuidestarFieldMapping__c();
        FGMPortalGuidestarFieldMapping.RecordTypeId = strRecordTypeId;
        FGMPortalGuidestarFieldMapping.FGM_Portal__government_registered_name__c = strRegisteredName;
        FGMPortalGuidestarFieldMapping.FGM_Portal__organization_id__c = strOrganization;
        FGMPortalGuidestarFieldMapping.FGM_Portal__IsCommunityRecord__c = true;
        return FGMPortalGuidestarFieldMapping;
    }

    public static PortalUserRequestTeamMembers__c CreatePortalUserRequestTeamMembers( string strAppAccessLevel, boolean bShared, string strPortalUserId, string strOppId, string strUserRole){
        PortalUserRequestTeamMembers__c PortalUserRequestTeamMembers = new PortalUserRequestTeamMembers__c();
        PortalUserRequestTeamMembers.ApplicationAccessLevel__c = strAppAccessLevel;
        PortalUserRequestTeamMembers.IsShared__c = bShared;
        PortalUserRequestTeamMembers.PortalUser__c = strPortalUserId;
        PortalUserRequestTeamMembers.SharedRequest__c = strOppId;
        PortalUserRequestTeamMembers.UserRole__c = strUserRole;
        return PortalUserRequestTeamMembers;
    }

    /* public static FGM_Portal__Eligibility_Quiz_Submissions__c CreateFGMPortalEligibilityQuizSubmissions( string strContactId, string strQuestionId, string strIPAddress, string strPortalUserId, string strQuizId, string strResult){
FGM_Portal__Eligibility_Quiz_Submissions__c FGMPortalEligibilityQuizSubmissions = new FGM_Portal__Eligibility_Quiz_Submissions__c();
FGMPortalEligibilityQuizSubmissions.FGM_Portal__Contact__c = strContactId;
FGMPortalEligibilityQuizSubmissions.FGM_Portal__Exit_Question__c = strQuestionId;
FGMPortalEligibilityQuizSubmissions.FGM_Portal__IP_Address__c = strIPAddress;
FGMPortalEligibilityQuizSubmissions.FGM_Portal__Portal_User__c = strPortalUserId;
FGMPortalEligibilityQuizSubmissions.FGM_Portal__Quiz__c = strQuizId;
FGMPortalEligibilityQuizSubmissions.FGM_Portal__Result__c = strResult;
return FGMPortalEligibilityQuizSubmissions;
}*/

    public static FGM_Portal__PortalConfiguration__c CreateFGMPortalPortalConfiguration( string strName, string strGranteeReportEditable, boolean bHeaderFooter, boolean bDashboard, string strAmendmentName, string strBenchmarkName, boolean bFlexiTabs, string strGranteeInboxTab, string strGranteeReportName, string strLanguage, string strRequestHistoryTab, string strRequestName, string strRequestEditableStatus, string strInquiryName, string strInquiryHistoryTab, string strInquiryEditableStatus){
        FGM_Portal__PortalConfiguration__c FGMPortalPortalConfiguration = new FGM_Portal__PortalConfiguration__c();
        FGMPortalPortalConfiguration.Name = strName;
        FGMPortalPortalConfiguration.FGM_Portal__GranteeReportEditableStatus__c = strGranteeReportEditable;
        FGMPortalPortalConfiguration.FGM_Portal__CustomizedHeaderFooter__c = bHeaderFooter;
        FGMPortalPortalConfiguration.FGM_Portal__CustomizeDashboard__c = bDashboard;
        FGMPortalPortalConfiguration.AmendmentName__c = strAmendmentName;
        FGMPortalPortalConfiguration.BenchmarkName__c = strBenchmarkName;
        FGMPortalPortalConfiguration.FGM_Portal__Flexible_Tabs__c = bFlexiTabs;
        FGMPortalPortalConfiguration.GranteeInboxTabLabel__c = strGranteeInboxTab;
        FGMPortalPortalConfiguration.FGM_Portal__GranteeReportName__c = strGranteeReportName;
        FGMPortalPortalConfiguration.FGM_Portal__LanguageSelection__c = strLanguage;
        FGMPortalPortalConfiguration.FGM_Portal__RequestHistoryTab__c = strRequestHistoryTab;
        FGMPortalPortalConfiguration.FGM_Portal__RequestName__c = strRequestName;
        FGMPortalPortalConfiguration.FGM_Portal__RequestEditableStatus__c = strRequestEditableStatus;
        FGMPortalPortalConfiguration.FGM_Portal__InquiryName__c = strInquiryName;
        FGMPortalPortalConfiguration.FGM_Portal__InquiryHistoryTab__c = strInquiryHistoryTab;
        FGMPortalPortalConfiguration.FGM_Portal__InquiryEditableStatus__c = strInquiryEditableStatus;
        FGMPortalPortalConfiguration.FGM_Portal__AmendmentDeletableStatus__c = 'In Progress';
        FGMPortalPortalConfiguration.FGM_Portal__AmendmentEditableStatus__c = 'In Progress';
        FGMPortalPortalConfiguration.FGM_Portal__AmendmentHistoryTab__c = 'Rejected';
        FGMPortalPortalConfiguration.FGM_Portal__BenchmarkDeletableStatus__c = 'Accepted';
        FGMPortalPortalConfiguration.FGM_Portal__BenchmarkEditableStatus__c = 'Accepted';
        FGMPortalPortalConfiguration.FGM_Portal__GranteeReportDeletableStatus__c = 'Requested;Received;Approved';
        FGMPortalPortalConfiguration.FGM_Portal__GranteeReportHiddenStatus__c = 'Scheduled';
        FGMPortalPortalConfiguration.FGM_Portal__GranteeReportHistoryTab__c = 'Submitted;Rejected';
        FGMPortalPortalConfiguration.FGM_Portal__GranteeReportfieldfordefaultsorting__c = 'FGM_Base__Status__c';
        FGMPortalPortalConfiguration.FGM_Portal__HistoryItemTabLabel__c = 'Closed Tab';
        FGMPortalPortalConfiguration.FGM_Portal__InquiryDeletableStatus__c = 'In Progress';
        FGMPortalPortalConfiguration.FGM_Portal__OpenItemTabLabel__c = 'Open Tab';
        FGMPortalPortalConfiguration.FGM_Portal__RequestDeletableStatus__c = 'In Progress;Prospecting;Qualification';
        return FGMPortalPortalConfiguration;
    }

    //Method to get the record type of sObjects
    /* public static Map<String,Id> GetRecordTypeMap ( String strObjectType){
Map<String,Id> mapRecordTypeByName = new Map<String,Id>();
for( RecordType recordType :  [SELECT Id, Name FROM RecordType WHERE sObjectType =: strObjectType])
mapRecordTypeByName.put( recordType.Name, recordType.Id);

return mapRecordTypeByName;
}*/

    public static Database.SaveResult[] InsertListWithAssert( List<sObject> dataObjects){
        Database.SaveResult[] arrSaveResult = Database.insert( dataObjects);
        for(Database.SaveResult saveResult : arrSaveResult){
            System.assert( saveResult.isSuccess());
        }
        return arrSaveResult;
    }

    public static Database.SaveResult[] UpdateListWithAssert( List<sObject> dataObjects){
        Database.SaveResult[] arrUpdateResult = Database.update( dataObjects);
        for(Database.SaveResult saveResult : arrUpdateResult){
            System.assert( saveResult.isSuccess());
        }
        return arrUpdateResult;
    }

    public static Database.Upsertresult[] UpsertListWithAssert( List<sObject> dataObjects){
        Database.Upsertresult[] arrSaveResult = Database.upsert( dataObjects);
        for(Database.Upsertresult saveResult : arrSaveResult){
            System.assert( saveResult.isSuccess());
        }
        return arrSaveResult;
    }

    public static Database.DeleteResult[] DeleteListWithAssert( List<sObject> dataObjects){
        Database.DeleteResult[] arrDeleteResult = Database.delete( dataObjects);
        for(Database.DeleteResult deleteResult : arrDeleteResult){
            System.assert( deleteResult.isSuccess());
        }
        return arrDeleteResult;
    }

}