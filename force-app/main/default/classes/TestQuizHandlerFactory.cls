@isTest
public class TestQuizHandlerFactory {
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
    public static Map<String,Schema.Recordtypeinfo> relatedListControllerRecordTypeMap = FGM_Portal__Related_List_Controller__c.SObjectType.getDescribe().getRecordTypeInfosByName();
    public static Map<String,Schema.Recordtypeinfo> newPortalQuestionRecordTypeMapByName = FGM_Portal__Questions__c.SObjectType.getDescribe().getRecordTypeInfosByName();
    public static void setupData() {
        //Test data for getOrgLanguages()
        FGM_Portal__PortalConfiguration__c PortalCOnfig = new FGM_Portal__PortalConfiguration__c();
        PortalCOnfig.FGM_Portal__InquiryHistoryTab__c='Submitted';
        PortalCOnfig.FGM_Portal__LanguageSelection__c='de';
        PortalCOnfig.FGM_Portal__BenchmarkName__c='Goals/Benchmarks';
        PortalCOnfig.FGM_Portal__GranteeReportFieldSortOrder__c='Ascending';
        PortalCOnfig.FGM_Portal__GranteeReportName__c='rantee Reports';
        PortalCOnfig.FGM_Portal__GranteeReportfieldfordefaultsorting__c='FGM_Base';
        PortalCOnfig.FGM_Portal__InquiryHiddenStatus__c='In Progress';
        PortalCOnfig.FGM_Portal__BenchmarkEditableStatus__c='Accepted;Completed';
        PortalCOnfig.FGM_Portal__AmendmentStatusField__c='FGM_Portal__StageName__c';
        PortalCOnfig.Name='Grantee Portal Configuration- German';
        PortalCOnfig.FGM_Portal__RequestName__c='Request/Application';
        PortalCOnfig.FGM_Portal__AmendmentEditableStatus__c='In Progress;Submitted;Under Review;Opened;Approved;Rejected';
        PortalCOnfig.FGM_Portal__HistoryItemTabLabel__c='History Items';
        PortalCOnfig.FGM_Portal__Flexible_Tabs__c=false;
        PortalCOnfig.FGM_Portal__GranteeInboxTabLabel__c='Inbox Messages';
        PortalCOnfig.FGM_Portal__GranteeReportHistoryTab__c='Submitted';
        PortalCOnfig.FGM_Portal__GranteeReportEditableStatus__c='Requested;Scheduled;Recived;Approved';
        PortalCOnfig.FGM_Portal__AmendmentHistoryTab__c='Submitted';
        PortalCOnfig.FGM_Portal__CustomizedHeaderFooter__c=false;
        PortalCOnfig.FGM_Portal__RequestHistoryTab__c='Declined;Closed;Submitted';
        PortalCOnfig.FGM_Portal__InquiryName__c='Inquiry/LOI';
        PortalCOnfig.FGM_Portal__GranteeReportStatusField__c='FGM_Base__Status__c';
        PortalCOnfig.FGM_Portal__InquiryStatusField__c='Status';
        PortalCOnfig.FGM_Portal__InquiryEditableStatus__c='New;Requested;More Information;Reopened;Application Invited;Open - Not Contacted;In Progress';
        PortalCOnfig.FGM_Portal__AmendmentHiddenStatus__c='Rejected';
        PortalCOnfig.FGM_Portal__Individual_Permissioning__c=true;
       // PortalCOnfig.SetupOwnerId='00Df40000022TF1EAM';
        PortalCOnfig.FGM_Portal__AmendmentDeletableStatus__c='Approved;In Progress';
        PortalCOnfig.FGM_Portal__BenchmarkDeletableStatus__c='Accepted;Completed';
        PortalCOnfig.FGM_Portal__Post_attachments_to_chatter_feeds__c=false;
        PortalCOnfig.FGM_Portal__OpenItemTabLabel__c='Open';
        PortalCOnfig.FGM_Portal__CustomizeDashboard__c=true;
        PortalCOnfig.FGM_Portal__RequestEditableStatus__c='Prospecting;In Progress;Submitted';
        PortalCOnfig.FGM_Portal__AmendmentName__c='Amendment';
        insert PortalCOnfig;
    }
    public static  List<FGM_Portal__Related_List_Controller__c> getValidQuizData()
    {
        Schema.DescribeSObjectResult quizSchema = Schema.SObjectType.FGM_Portal__Quiz__c;
        Map<String,Schema.RecordTypeInfo> quizRecordTypeInfo = quizSchema.getRecordTypeInfosByName();
        Id quizrecordTypeId = quizRecordTypeInfo.get(PORTAL_QUIZ_APPLICATION).getRecordTypeId();
        FGM_Portal__Quiz__c quiz = new FGM_Portal__Quiz__c();
        quiz.Name='test quiz for valid data';
        quiz.RecordTypeId= quizrecordTypeId;
        quiz.FGM_Portal__IsCommunityRecord__c=true;
        quiz.FGM_Portal__Is_Active__c=true;
        insert quiz;

        List<FGM_Portal__Related_List_Controller__c> quizTabs =new List<FGM_Portal__Related_List_Controller__c>();

        FGM_Portal__Related_List_Controller__c portalTab = new FGM_Portal__Related_List_Controller__c();
        portalTab.FGM_Portal__Quiz__c = quiz.Id;
        portalTab.FGM_Portal__Language__c = 'ja';
        portalTab.RecordTypeId = relatedListControllerRecordTypeMap.get(PORTAL_RELATEDLISTCONTROLLER_PORTALTAB).getRecordTypeId();
        portalTab.FGM_Portal__ParentObject__c=null;
        portalTab.FGM_Portal__LookupField__c='Opportunity';
        portalTab.FGM_Portal__ObjectName__c='Opportunity';
        portalTab.FGM_Portal__FieldHeaders__c ='Portal Tab Header';
        portalTab.FGM_Portal__FieldNames__c='OpportunityAccessLevel';
        quizTabs.add(portalTab);

        FGM_Portal__Related_List_Controller__c rLCWithTab = new FGM_Portal__Related_List_Controller__c();
        rLCWithTab.Name = 'Related List With Tab';
        rLCWithTab.FGM_Portal__Quiz__c = quiz.Id;
        rLCWithTab.FGM_Portal__Language__c = 'en_US';
        rLCWithTab.FGM_Portal__IsCommunityRecord__c = true;
        rLCWithTab.RecordTypeId = relatedListControllerRecordTypeMap.get(PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId();
        rLCWithTab.FGM_Portal__LookupField__c='Opportunity';
        rLCWithTab.FGM_Portal__ObjectName__c='Opportunity';
        rLCWithTab.FGM_Portal__FieldHeaders__c ='Opportunity Access,Created Date,Opportunity ID';
        rLCWithTab.FGM_Portal__FieldNames__c='OpportunityAccessLevel,CreatedDate,OpportunityId';
        rLCWithTab.FGM_Portal__Field_Labels_Long__c='{"Actions":{},"columns":[{"apiName":"OpportunityAccessLevel","apiNameLocal":"OpportunityAccessLevel","byteLimit":120,"characterLimit":40,"digitsLimit":0,"fieldAccess":{"isReadable":true,"isUpdateable":true},"fieldType":"PICKLIST","isAutoNumber":false,"isCaseSensitive":false,"isCustom":false,"isDependentPicklist":false,"isDeprecatedAndHidden":false,"isFilterable":true,"isFormula":false,"isGroupable":true,"isHtmlFormatted":false,"isRequired":false,"isSortable":true,"label":"Opportunity Access","picklistValues":[{"apiName":"None","isActive":true,"isDefault":false,"label":"Private"},{"apiName":"Read","isActive":true,"isDefault":false,"label":"Read Only"},{"apiName":"Edit","isActive":true,"isDefault":false,"label":"Read/Write"},{"apiName":"All","isActive":true,"isDefault":false,"label":"Owner"}],"precision":0,"relatedObjects":[],"scale":0,"isSearch":true,"isSort":true,"Name":"Opportunity Access"},{"apiName":"CreatedDate","apiNameLocal":"CreatedDate","byteLimit":0,"characterLimit":0,"digitsLimit":0,"fieldAccess":{"isReadable":true,"isUpdateable":false},"fieldType":"DATETIME","isAutoNumber":false,"isCaseSensitive":false,"isCustom":false,"isDependentPicklist":false,"isDeprecatedAndHidden":false,"isFilterable":true,"isFormula":false,"isGroupable":false,"isHtmlFormatted":false,"isRequired":true,"isSortable":true,"label":"Created Date","picklistValues":[],"precision":0,"relatedObjects":[],"scale":0,"isSearch":true,"isSort":true,"Name":"Created Date"},{"apiName":"OpportunityId","apiNameLocal":"OpportunityId","byteLimit":18,"characterLimit":18,"digitsLimit":0,"fieldAccess":{"isReadable":true,"isUpdateable":false},"fieldType":"REFERENCE","isAutoNumber":false,"isCaseSensitive":false,"isCustom":false,"isDependentPicklist":false,"isDeprecatedAndHidden":false,"isFilterable":true,"isFormula":false,"isGroupable":true,"isHtmlFormatted":false,"isRequired":true,"isSortable":true,"label":"Opportunity ID","picklistValues":[],"precision":0,"relatedObjects":[{"apiName":"Opportunity","label":"Opportunity"}],"scale":0,"isSearch":true,"isSort":true,"Name":"Opportunity ID"}]}';
        quizTabs.add(rLCWithTab);
        //IFrame Tab
        FGM_Portal__Related_List_Controller__c iFrameTab =new FGM_Portal__Related_List_Controller__c();
        iFrameTab.Name='IFrame Tab';
        iFrameTab.FGM_Portal__Quiz__c=quiz.Id;
        iFrameTab.FGM_Portal__ParentObject__c='Opportunity';
        iFrameTab.FGM_Portal__ObjectName__c='Opportunity';
        iFrameTab.FGM_Portal__LookupField__c ='Opportunity';
        iFrameTab.RecordTypeId=relatedListControllerRecordTypeMap.get(PORTAL_RELATEDLISTCONTROLLER_IFRAMETAB).getRecordTypeId();
        iFrameTab.FGM_Portal__ShowNewButton__c=false;
        iFrameTab.FGM_Portal__Hide_Edit_Link__c=false;
        iFrameTab.FGM_Portal__ShowDeleteLink__c=false;
        iFrameTab.FGM_Portal__BaseUrl__c='www.gmail.com?name=shahaji';
        iFrameTab.Column_View_Mode__c='One Column';
        iFrameTab.FGM_Portal__Field_Labels_Long__c='{"baseURL":"www.gmail.com","parameterList":[{"Key":"name","Field":{"label":"shahaji","apiName":""},"$$hashKey":"object:573"}]}}';
        quizTabs.add(iFrameTab);

        //Grantee Budget Tab
        FGM_Portal__Related_List_Controller__c granteeBudgetTab =new FGM_Portal__Related_List_Controller__c();
        granteeBudgetTab.Name = 'Grantee Budget Tab';
        granteeBudgetTab.FGM_Portal__Language__c = 'en_US';
        granteeBudgetTab.FGM_Portal__IsCommunityRecord__c = true;
        granteeBudgetTab.FGM_Portal__Quiz__c = quiz.Id;
        granteeBudgetTab.FGM_Portal__ObjectName__c = 'FGM_Portal__Grantee_Budget__c';
        granteeBudgetTab.FGM_Portal__ParentObject__c ='Quiz__c';
        granteeBudgetTab.FGM_Portal__LookupField__c ='FGM_Portal__Grantee_Budget__c';
        granteeBudgetTab.FGM_Portal__SortOrder__c = 6;
        granteeBudgetTab.RecordTypeId = relatedListControllerRecordTypeMap.get(PORTAL_RELATEDLISTCONTROLLER_GRANTEEBUDGETTAB).getRecordTypeId();
        granteeBudgetTab.FGM_Portal__FieldHeaders__c ='GBT';
        granteeBudgetTab.FGM_Portal__FieldNames__c='GBT Record';
        granteeBudgetTab.FGM_Portal__Field_Labels_Long__c='GBT LAbel';
        quizTabs.add(granteeBudgetTab);
        Insert quizTabs;

        List<FGM_Portal__Grantee_Budget_Category__c> lstCategory = new List<FGM_Portal__Grantee_Budget_Category__c>();
        FGM_Portal__Grantee_Budget_Category__c category1 = new FGM_Portal__Grantee_Budget_Category__c();
        category1.Name ='Admin';
        category1.FGM_Portal__Parent_Category__c = null;
        category1.FGM_Portal__IsActive__c=true;
        lstCategory.add(category1);

        FGM_Portal__Grantee_Budget_Category__c category2 = new FGM_Portal__Grantee_Budget_Category__c();
        category2.Name ='System Admin';
        category2.FGM_Portal__Parent_Category__c =  category1.Id;
        category2.FGM_Portal__IsActive__c=true;
        lstCategory.add(category2);

        FGM_Portal__Grantee_Budget_Category__c category3 = new FGM_Portal__Grantee_Budget_Category__c();
        category3.Name = 'Network Admin';
        category3.FGM_Portal__Parent_Category__c =  category1.Id;
        category3.FGM_Portal__IsActive__c=true;
        lstCategory.add(category3);

        FGM_Portal__Grantee_Budget_Category__c category4 = new FGM_Portal__Grantee_Budget_Category__c();
        category4.Name = 'Developer1';
        category4.FGM_Portal__Parent_Category__c = null;
        category4.FGM_Portal__IsActive__c=true;
        lstCategory.add(category4);

        FGM_Portal__Grantee_Budget_Category__c category5 = new FGM_Portal__Grantee_Budget_Category__c();
        category5.Name ='Developer2';
        category5.FGM_Portal__Parent_Category__c = null;
        category5.FGM_Portal__IsActive__c=true;
        lstCategory.add(category5);

        FGM_Portal__Grantee_Budget_Category__c category6 = new FGM_Portal__Grantee_Budget_Category__c();
        category6.Name ='Developer3';
        category6.FGM_Portal__Parent_Category__c = null;
        category6.FGM_Portal__IsActive__c=true;
        lstCategory.add(category6);
        Insert lstCategory;

        List <FGM_Portal__Grantee_Budget_Configuration__c> objGranteeBudgetConfiguration = new List <FGM_Portal__Grantee_Budget_Configuration__c>();
        List <FGM_Portal__Grantee_Budget_Category__c> lstBudgetCategories = [SELECT Id FROM FGM_Portal__Grantee_Budget_Category__c];
        for(integer index = 0;index < lstBudgetCategories.size(); index++)
        {
            FGM_Portal__Grantee_Budget_Configuration__c GranteeBudgetConfiguration =new FGM_Portal__Grantee_Budget_Configuration__c();
            objGranteeBudgetConfiguration.add(GranteeBudgetConfiguration);
            objGranteeBudgetConfiguration[index].FGM_Portal__Quiz__c = quiz.Id;
            objGranteeBudgetConfiguration[index].FGM_Portal__Category__c =lstBudgetCategories[index].Id;
        }
        insert objGranteeBudgetConfiguration;

        //Quiz Questions records
        List<FGM_Portal__Questions__c> lstPortalQuestion = new  List<FGM_Portal__Questions__c>();
        FGM_Portal__Questions__c portalQuestion1 = NEW FGM_Portal__Questions__c();
        portalQuestion1.FGM_Portal__RichQuestion__c = 'Name';
        portalQuestion1.FGM_Portal__RichPreText__c = 'strPreText';
        portalQuestion1.FGM_Portal__RichPostText__c = 'strPostText';
        portalQuestion1.FGM_Portal__Help_Tip__c = 'strHelpTip';
        portalQuestion1.FGM_Portal__Type__c = 'Salesforce Data Type';
        portalQuestion1.FGM_Portal__Quiz__c = quiz.Id;
        portalQuestion1.RecordTypeId = newPortalQuestionRecordTypeMapByName.get(PORTAL_QUESTION_RECORDFIELD).getRecordTypeId();
        lstPortalQuestion.add(portalQuestion1);

        FGM_Portal__Questions__c portalQuestion2 = NEW FGM_Portal__Questions__c();
        portalQuestion2.FGM_Portal__RichQuestion__c = 'Instruction';
        portalQuestion2.FGM_Portal__RichPreText__c = 'strPreText';
        portalQuestion2.FGM_Portal__RichPostText__c = 'strPostText';
        portalQuestion2.FGM_Portal__Help_Tip__c = 'strHelpTip';
        portalQuestion2.FGM_Portal__Type__c = 'Instruction';
        portalQuestion2.FGM_Portal__Quiz__c = quiz.Id;
        portalQuestion2.RecordTypeId = newPortalQuestionRecordTypeMapByName.get(PORTAL_QUESTION_RECORDFIELD).getRecordTypeId();
        lstPortalQuestion.add(portalQuestion2) ;

        FGM_Portal__Questions__c portalQuestion3 = NEW FGM_Portal__Questions__c();
        portalQuestion3.FGM_Portal__RichQuestion__c = 'Attachment';
        portalQuestion3.FGM_Portal__RichPreText__c = 'strPreText';
        portalQuestion3.FGM_Portal__RichPostText__c = 'strPostText';
        portalQuestion3.FGM_Portal__Help_Tip__c = 'strHelpTip';
        portalQuestion3.FGM_Portal__Type__c = 'Attachment';
        portalQuestion3.FGM_Portal__AttachmentNameFormula__c ='Opportunity ID+Account ID';
        portalQuestion3.FGM_Portal__Quiz__c = quiz.Id;
        portalQuestion3.RecordTypeId = newPortalQuestionRecordTypeMapByName.get(PORTAL_QUESTION_RECORDFIELD).getRecordTypeId();
        lstPortalQuestion.add(portalQuestion3);

        FGM_Portal__Questions__c portalQuestion4 = NEW FGM_Portal__Questions__c();
        portalQuestion4.FGM_Portal__RichQuestion__c = 'StageName';
        portalQuestion4.FGM_Portal__RichPreText__c = 'strPreText';
        portalQuestion4.FGM_Portal__RichPostText__c = 'strPostText';
        portalQuestion4.FGM_Portal__Help_Tip__c = 'strHelpTip';
        portalQuestion4.FGM_Portal__Type__c = 'Salesforce Data Type';
        portalQuestion4.FGM_Portal__Quiz__c = quiz.Id;
        portalQuestion4.RecordTypeId = newPortalQuestionRecordTypeMapByName.get(PORTAL_QUESTION_RECORDFIELD).getRecordTypeId();
        lstPortalQuestion.add(portalQuestion4);

        Database.Saveresult[] resultsFGMPortalQuestion = Database.insert(lstPortalQuestion);

        List<FGM_Portal__Quiz_Questions__c> lstFGMPortalQuizQuestion = new List<FGM_Portal__Quiz_Questions__c>();
        FGM_Portal__Quiz_Questions__c objQuizQuestion1 = NEW FGM_Portal__Quiz_Questions__c();
        objQuizQuestion1.FGM_Portal__Question__c = resultsFGMPortalQuestion[0].Id;
        objQuizQuestion1.FGM_Portal__Sort_Order__c = 1;
        objQuizQuestion1.FGM_Portal__Field__c = 'Name';
        objQuizQuestion1.FGM_Portal__Required__c = false;
        objQuizQuestion1.FGM_Portal__Tab__c = rLCWithTab.Id;
        objQuizQuestion1.FGM_Portal__Quiz__c = quiz.Id;
        objQuizQuestion1.Visibility_Configuration__c='{"dependentQuestions":["a0of4000002yZduAAE"],"filterLogic":{"logic":"","logicOperator":"AND"},"visibilityConditions":[]}';
        lstFGMPortalQuizQuestion.add(objQuizQuestion1);

        FGM_Portal__Quiz_Questions__c objQuizQuestion2 = NEW FGM_Portal__Quiz_Questions__c();
        objQuizQuestion2.FGM_Portal__Question__c = resultsFGMPortalQuestion[1].Id;
        objQuizQuestion2.FGM_Portal__Sort_Order__c = 2;
        objQuizQuestion2.FGM_Portal__Required__c = false;
        objQuizQuestion2.FGM_Portal__Tab__c = rLCWithTab.Id;
        objQuizQuestion2.FGM_Portal__Quiz__c = quiz.Id;
        lstFGMPortalQuizQuestion.add(objQuizQuestion2);

        FGM_Portal__Quiz_Questions__c objQuizQuestion3 = NEW FGM_Portal__Quiz_Questions__c();
        objQuizQuestion3.FGM_Portal__Question__c = resultsFGMPortalQuestion[2].Id;
        objQuizQuestion3.FGM_Portal__Sort_Order__c = 3;
        objQuizQuestion3.FGM_Portal__Required__c = false;
        objQuizQuestion3.FGM_Portal__Tab__c = rLCWithTab.Id;
        objQuizQuestion3.FGM_Portal__Quiz__c = quiz.Id;
        lstFGMPortalQuizQuestion.add(objQuizQuestion3);

        FGM_Portal__Quiz_Questions__c objQuizQuestion4 = NEW FGM_Portal__Quiz_Questions__c();
        objQuizQuestion4.FGM_Portal__Question__c = resultsFGMPortalQuestion[3].Id;
        objQuizQuestion4.FGM_Portal__Sort_Order__c = 4;
        objQuizQuestion4.FGM_Portal__Field__c = 'StageName';
        objQuizQuestion4.FGM_Portal__Required__c = false;
        objQuizQuestion4.FGM_Portal__Tab__c = rLCWithTab.Id;
        objQuizQuestion4.FGM_Portal__Quiz__c = quiz.Id;
        lstFGMPortalQuizQuestion.add(objQuizQuestion4);
        Insert lstFGMPortalQuizQuestion;
        return quizTabs;
    }
    public static FGM_Portal__Quiz__c getInValidQuizData()
    {
        Schema.DescribeSObjectResult quizSchema = Schema.SObjectType.FGM_Portal__Quiz__c;
        Map<String,Schema.RecordTypeInfo> quizRecordTypeInfo = quizSchema.getRecordTypeInfosByName();
        Id quizrecordTypeId = quizRecordTypeInfo.get(PORTAL_QUESTION_QUIZ).getRecordTypeId();
        FGM_Portal__Quiz__c quiz = new FGM_Portal__Quiz__c();
        quiz.Name='test Quiz for invalid data';
        quiz.RecordTypeId= quizrecordTypeId;
        quiz.FGM_Portal__IsCommunityRecord__c=true;
        quiz.FGM_Portal__Is_Active__c=true;
        insert quiz;

        FGM_Portal__Related_List_Controller__c rLCWithTab = new FGM_Portal__Related_List_Controller__c();
        rLCWithTab.Name = 'Related List With Tab';
        rLCWithTab.FGM_Portal__Quiz__c = quiz.Id;
        rLCWithTab.FGM_Portal__Language__c = 'en_US';
        rLCWithTab.FGM_Portal__IsCommunityRecord__c = true;
        rLCWithTab.RecordTypeId = relatedListControllerRecordTypeMap.get(PORTAL_RELATEDLISTCONTROLLER_RELATEDLISTTAB).getRecordTypeId();
        rLCWithTab.FGM_Portal__LookupField__c='Opportunity';
        rLCWithTab.FGM_Portal__ObjectName__c='Opportunity';
        rLCWithTab.FGM_Portal__FieldHeaders__c ='Opportunity Access,Created Date,Opportunity ID';
        rLCWithTab.FGM_Portal__FieldNames__c='OpportunityAccessLevel,CreatedDate,OpportunityId';
        insert rLCWithTab;
        return quiz;
    }

}