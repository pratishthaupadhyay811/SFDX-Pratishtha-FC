public with sharing class FCRecordReviewComponentController {
     public String currentParentObject { get ; set; }
     public sobject application { set; get; }
     public Boolean initialized { get; set; }
     public FGM_Portal__Quiz__c quiz { set; get; }
     public List<FGM_Portal__Related_List_Controller__c> tabsList { get; set; }    // To get Tab records from RLC
     public String selectedTab { set; get; }
     public FGM_Portal__Quiz_Questions__c[] quizQuestionList { set; get; }
     private Set<Id> portalTabIds;
     private Set<Id> relatedListTabIds;
     public Map<String,ApplicationAttachments> mapApplicationAttachments {get; set;}
     public Set<String> setAttachmentQuestionList {set; get;}
     public Boolean isErrorInAttachment { get; set; }
     public ReviewPage[] reviewPageList { set; get; }
     public SFDCEncoder ESAPI = new SFDCEncoder();

     public String appId { get; set{
        appId = value;
         if (!initialized) {
             initializeReview();
             initialized = true;
         }
     } }

     public FCRecordReviewComponentController(){
        initialized = false;
     }
     private void initializeReview() {
        initializeApplication();
        if(quiz == null)
            return;
        initializeTabs();
        if(application == null)
            rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_FCRecord_Processing_ErrorMsg),null);
        initializeQuizQuestionList('');
        initializeAttachment();
        // Convert to a review list
        initializeReviewPageList();
        return;
    }

     public PageReference rollbackWithError(String message, System.Savepoint savepoint) {
        if (savepoint != null)
            Database.rollback(savepoint);
        if (message != null)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, message));
        return null;
    }

     // To get Quiz Questions and Tab Records.
    public void initializeTabs(){

        tabsList = [
            SELECT
                Associated_FC_Portal_Type__c,
                Associated_Tab_Type__c,
                FieldHeaders__c,
                FieldNames__c,
                Hide_Edit_Link__c,
                RichInstructionalText__c,
                LookupField__c,
                Name,
                ObjectName__c,
                ParentObject__c,
                RecordTypeId,
                ShowDeleteLink__c,
                ShowNewButton__c,
                (
                    SELECT
                        Field__c,
                        Question__c,
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
            WITH SECURITY_ENFORCED
            ORDER BY SortOrder__c ASC NULLS LAST
            LIMIT 10000
        ];

        if(!tabsList.isEmpty()){
            if(tabsList != null && !tabsList.isEmpty() && !String.isNotBlank(selectedTab)){
                selectedTab = String.valueOf(tabsList[0].Id);
                currentParentObject = tabsList[0].FGM_Portal__ParentObject__c;
            }
        }
    }

    public void initializeQuizQuestionList(String strSelectedTabId) {
        if(tabsList != null){
            quizQuestionList = new List<FGM_Portal__Quiz_Questions__c>();
            portalTabIds = new Set<Id>();
            relatedListTabIds = new Set<Id>();
            for(FGM_Portal__Related_List_Controller__c tabRecord : tabsList){
                Map<Id,Schema.RecordTypeInfo> recordTypeInfo = Schema.Sobjecttype.FGM_Portal__Related_List_Controller__c.getRecordTypeInfosById();
                Schema.RecordTypeInfo requiredRecordtType = recordTypeInfo.get(tabRecord.RecordTypeId);
                String strRLCRecordTypeName = '';
                if(requiredRecordtType != null)
                    strRLCRecordTypeName = requiredRecordtType.getName();  // Get record Type Name

                if(String.isNotBlank(strRLCRecordTypeName) && 'Related List With Tab'.equalsIgnoreCase(strRLCRecordTypeName))
                    relatedListTabIds.add(tabRecord.Id);
                else if(String.isNotBlank(strRLCRecordTypeName) && 'Portal Tab'.equalsIgnoreCase(strRLCRecordTypeName)){
                    portalTabIds.add(tabRecord.Id);
                    if(tabRecord.Quiz_Questions__r != null)
                        quizQuestionList.addAll(tabRecord.Quiz_Questions__r);
                }
            }
        }
    }

    // initialize Application Record.
    private void initializeApplication() {
        // What are the fields in the question responses?
        String applicationCondition =  '';
        String applicationRecordTypeId = '';
        String applicationQuizId = '';
        sObject[] applicationList = null;
        Set<String> fieldSet = new Set<String>();

        if(String.isNotBlank(appId))
            applicationCondition = 'Id= : appID';

        // What's the running user's contact?
        String applicationOwnerId = UserInfo.getUserId();
        if(String.isNotBlank(applicationCondition)){
            currentParentObject = FCGlobal.getObjectNameById(appID);
            Map<String, String> mapApplicationFields = new Map<String, String>();

            for (Schema.SObjectField f : Schema.getGlobalDescribe().get(currentParentObject).getDescribe().fields.getMap().values()) {
                if (f.getDescribe().isAccessible()) {
                    mapApplicationFields.put(f.getDescribe().getLabel(), f.getDescribe().getLocalName());
                    fieldSet.add(f.getDescribe().getLocalName());
                }
            }

            String sanitizedParentObject = currentParentObject.replaceAll('[^0-9a-zA-Z_.]', '');

            applicationList = (sObject[]) Database.query(''
                                                         + 'SELECT ' + String.join(mapApplicationFields.values(), ', ')
                                                         + '  FROM '+ sanitizedParentObject
                                                         + ' WHERE '+ applicationCondition
                                                         + ' WITH SECURITY_ENFORCED'
                                                         + ' LIMIT 1'
                                                        );

        }
        if (applicationList != null && !applicationList.isEmpty() && String.isNotBlank(applicationCondition)) {
            application = applicationList[0];
            try{
                if(fieldSet.contains('RecordTypeId') && application.get('RecordTypeId') != null)
                    applicationRecordTypeId = String.valueOf(application.get('RecordTypeId'));
                if(currentParentObject.equalsIgnoreCase('opportunity')) {
                    if(application.get('CampaignId') != null){

                        Campaign campaignrecord = [
                            SELECT
                                Application_Quiz__c,
                                Application_Type__c,
                                LOI_Quiz__c
                            FROM Campaign
                            WHERE Id = :((Id) application.get('CampaignId'))
                            WITH SECURITY_ENFORCED
                            LIMIT 1
                        ];

                        if(campaignrecord != null && (campaignrecord.Application_Quiz__c != null || campaignrecord.LOI_Quiz__c != null) ){
                            if(campaignrecord.Application_Quiz__c != null && campaignrecord.FGM_Portal__Application_Type__c == 'Application Quiz')
                                applicationQuizId  = campaignrecord.Application_Quiz__c ;
                            else if(campaignrecord.Application_Quiz__c != null && campaignrecord.FGM_Portal__Application_Type__c == 'LOI Quiz' )
                                applicationQuizId  = campaignrecord.LOI_Quiz__c ;
                        }
                    }
                }else if(currentParentObject.equalsIgnoreCase('lead')){

                    CampaignMember campaignMemberRecord = [
                        SELECT
                            Campaign.Application_Quiz__c,
                            Campaign.Application_Type__c,
                            Campaign.LOI_Quiz__c
                        FROM CampaignMember
                        WHERE LeadId = :application.Id
                        WITH SECURITY_ENFORCED
                        LIMIT 1
                    ];

                     if(campaignMemberRecord != null && (campaignMemberRecord.Campaign.Application_Quiz__c != null || campaignMemberRecord.Campaign.LOI_Quiz__c != null)){
                         // applicationQuizId  = campaignMemberRecord.Campaign.Application_Quiz__c != null ? campaignMemberRecord.Campaign.Application_Quiz__c : campaignMemberRecord.Campaign.LOI_Quiz__c;
                         if(campaignMemberRecord.Campaign.Application_Quiz__c != null && campaignMemberRecord.Campaign.FGM_Portal__Application_Type__c == 'Application Quiz')
                             applicationQuizId  = campaignMemberRecord.Campaign.Application_Quiz__c ;
                         else if(campaignMemberRecord.Campaign.Application_Quiz__c !=null && campaignMemberRecord.Campaign.FGM_Portal__Application_Type__c == 'LOI Quiz' )
                             applicationQuizId  = campaignMemberRecord.Campaign.LOI_Quiz__c ;
                     }
                }
            }
            catch(Exception ex){}
            initializeQuiz(applicationRecordTypeId,applicationQuizId);
        }
    }

     // initialize the Quiz
    private void initializeQuiz(String RecordTypeId, String QuizID){
        if(String.isNotBlank(QuizID)){
            quiz = new FGM_Portal__Quiz__c();
            quiz.Id = QuizID;
        }
        else if(String.isNotBlank(RecordTypeId)){

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

            if(lstPageLayout != null && !lstPageLayout.isEmpty()){
                quiz = lstPageLayout[0].Quiz__r;
                if(currentParentObject == null)
                    currentParentObject = lstPageLayout[0].ObjectName__c;
            }
            else
                rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_FCRecord_PageLayoutProcessing_ErrorMsg),null);
        }
        else
            rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_FCRecord_PageLayoutProcessing_ErrorMsg),null);
    }

    public void initializeAttachment() {
        mapApplicationAttachments = new Map<String,ApplicationAttachments>();
        setAttachmentQuestionList = new Set<String>();
        for(FGM_Portal__Quiz_Questions__c quizQuestion : quizQuestionList) {
            if(String.isNotBlank(quizQuestion.FGM_Portal__Question__r.FGM_Portal__Type__c) && quizQuestion.FGM_Portal__Question__r.FGM_Portal__Type__c == 'Attachment')
                setAttachmentQuestionList.add(quizQuestion.FGM_Portal__Question__c);
        }
        String questionAttachmentRelationField = FCGlobal.getRelationalField(currentParentObject, Question_Attachment__c.sObjectType);
        if(setAttachmentQuestionList != null && !setAttachmentQuestionList.isEmpty() && application != null && application.Id != null) {
            if(!String.isNotBlank(questionAttachmentRelationField)){
                isErrorInAttachment = true;
                return;
            }
            String applicationId = application.Id;
            List<Question_Attachment__c> lstQuestionAttachment = (List<Question_Attachment__c>)Database.Query(''
                                                                                                              +'SELECT (SELECT Name'
                                                                                                              +',Id'
                                                                                                              +', ContentType'
                                                                                                              +', BodyLength'
                                                                                                              +',CreatedDate'
                                                                                                              +' FROM Attachments)'
                                                                                                              +', Question__c'
                                                                                                              +', Description__c'
                                                                                                              +' FROM Question_Attachment__c'
                                                                                                              +' WHERE ' + questionAttachmentRelationField + ' = :applicationId'
                                                                                                              +' WITH SECURITY_ENFORCED'
                                                                                                              +' ORDER BY CreatedDate ASC'
                                                                                                              +' LIMIT 10000'
                                                                                                             );

            if(lstQuestionAttachment != null && !lstQuestionAttachment.isEmpty()) {
                for(Question_Attachment__c questionAttachment : lstQuestionAttachment){
                    setAttachmentQuestionList.remove(questionAttachment.Question__c);
                    ApplicationAttachments applicationAttachment = new ApplicationAttachments();
                    applicationAttachment.strQuestionAttachmentId = questionAttachment.Id;
                    for(Attachment attachment: questionAttachment.Attachments)
                        applicationAttachment.mapOldAttachments.put(String.valueOf(attachment.Id),attachment);                    applicationAttachment.oldMapSize = applicationAttachment.mapOldAttachments.size();
                    mapApplicationAttachments.put(String.valueOf(questionAttachment.Question__c),applicationAttachment);
                }
            }

            if(!setAttachmentQuestionList.isEmpty() && application != null && application.Id != null){
                List<Question_Attachment__c> lstUpsertQuestionAttachment = new List<Question_Attachment__c>();
                if(String.isNotBlank(questionAttachmentRelationField)){
                    for(String questionId : setAttachmentQuestionList) {
                        Question_Attachment__c questionAttachment = new Question_Attachment__c();
                        questionAttachment.put('Question__c',questionId);
                        questionAttachment.put(questionAttachmentRelationField,application.Id);
                        lstUpsertQuestionAttachment.add(questionAttachment);
                    }
                }
                else
                    isErrorInAttachment = true;

                // Upsert the attachment placeholders
                if(!lstUpsertQuestionAttachment.isEmpty()){
                    CrudFlsService.getInstance().assertUpdateable(lstUpsertQuestionAttachment);
                    upsert lstUpsertQuestionAttachment;
                    for(Question_Attachment__c questionAttachment : lstUpsertQuestionAttachment){
                        ApplicationAttachments applicationAttachment = new ApplicationAttachments();
                        applicationAttachment.strQuestionAttachmentId = questionAttachment.Id;
                        for(Attachment attachment: questionAttachment.Attachments)
                            applicationAttachment.mapOldAttachments.put(String.valueOf(attachment.Id),attachment);
                        applicationAttachment.oldMapSize = applicationAttachment.mapOldAttachments.size();
                        mapApplicationAttachments.put(String.valueOf(questionAttachment.Question__c),applicationAttachment);
                    }
                }
            }
        }
    }

     // To get Related List Column for related List.
    private Map<String,String> getrelatedListColumn(FGM_Portal__Related_List_Controller__c relatedListController) {
        Map<String,String> mapColumns = new Map<String,String>();
        if(relatedListController != null){
            String[] lstColumnLabels = relatedListController.FGM_Portal__FieldHeaders__c.split(',');
            String[] lstColumnFields = relatedListController.FGM_Portal__FieldNames__c.split(',');
            if(lstColumnLabels != null && lstColumnFields != null){
                integer index = 0;
                for(String columnLabel : lstColumnLabels){
                    if(lstColumnFields[index] != null && String.isNotBlank(lstColumnFields[index])){
                        String strFieldName =   lstColumnFields[index];
                        mapColumns.put(columnLabel, strFieldName);
                        index++;
                    }
                }
            }
        }
        return mapColumns;
    }

    // To get Related List Records for related List.
    private List<Object> getRelatedListRecords(FGM_Portal__Related_List_Controller__c relatedListController, Set<String> setFields){
        List<Object> lstSobject = new List<Object>();
        if(String.isNotBlank(relatedListController.FGM_Portal__ParentObject__c) && String.isNotBlank(relatedListController.FGM_Portal__ObjectName__c) && String.isNotBlank(relatedListController.FGM_Portal__LookupField__c)){
            if(setFields != null && !setFields.isEmpty() && application != null && application.Id != null){
                String applicationOwnerId = UserInfo.getUserId();
                String applicationId = application.Id;
                List<String> sanitizedFields = new List<String>();
                for (String f : setFields) {
                    sanitizedFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                }
                String sanitizedObjectName = relatedListController.ObjectName__c.replaceAll('[^0-9a-zA-Z_.]', '');
                String sanitizedLookupField = relatedListController.LookupField__c.replaceAll('[^0-9a-zA-Z_.]', '');
                Object[] childObject = Database.query(''
                                                      + 'SELECT Id, '+ String.join(sanitizedFields, ', ')
                                                      + '  FROM  '+ sanitizedObjectName
                                                      + ' WHERE  '+ sanitizedLookupField +'= :applicationId'
                                                      + ' WITH SECURITY_ENFORCED'
                                                      + ' LIMIT 1000');
                if(childObject != null && !childObject.isEmpty())
                    lstSobject.addAll(childObject);
            }
        }
        return lstSobject;
    }

    // To show record in Review Page.
    public void initializeReviewPageList() {
        // Setup the review list
        reviewPageList = new ReviewPage[] {};
        if (application.Id == null || tabsList == null || tabsList.isEmpty())
            return;
        if(relatedListTabIds != null && portalTabIds != null){
            ReviewPage reviewPage = null;
            for(FGM_Portal__Related_List_Controller__c tabRecord : tabsList){
                reviewPage = null;
                if(portalTabIds.contains(tabRecord.Id)){
                    reviewPage = new ReviewPage();
                    reviewPage.name = tabRecord.Name;
                    reviewPage.TabType = 'Portal Tab';
                    reviewPage.reviewQuestionList = new ReviewQuestion[] {};

                    if(tabRecord.Quiz_Questions__r == null)
                        continue;
                    for(FGM_Portal__Quiz_Questions__c quizQuestion : tabRecord.Quiz_Questions__r) {
                        // Missing field types can  be skipped
                        if (quizQuestion.FGM_Portal__Question__r.FGM_Portal__Type__c == null)
                            continue;
                        // Basic response
                        ReviewQuestion reviewQuestion = new ReviewQuestion();
                        reviewQuestion.question = quizQuestion.FGM_Portal__Question__r;

                        // For fields mapped directly to the application
                        if (quizQuestion.Field__c != null && application.get(quizQuestion.Field__c) != null) {
                            reviewQuestion.response = '' + application.get(quizQuestion.Field__c);
                            reviewQuestion.field = String.valueOf(quizQuestion.Field__c);
                        }
                        reviewQuestion.questionType = quizQuestion.FGM_Portal__Question__r.FGM_Portal__Type__c;
                        reviewQuestion.questionId  = quizQuestion.FGM_Portal__Question__c;

                        // Add to reviewPage list
                        reviewPage.reviewQuestionList.add(reviewQuestion);
                    }
                    // Only add the reviewPage to the list if there are matched questions
                    if (reviewPage.reviewQuestionList.isEmpty() == false) {
                        reviewPageList.add(reviewPage);
                    }
                }
                else if(relatedListTabIds.contains(tabRecord.Id) && String.isNotBlank(tabRecord.FGM_Portal__ObjectName__c) && String.isNotBlank(tabRecord.FGM_Portal__LookupField__c)){
                    reviewPage = new ReviewPage();
                    reviewPage.name = tabRecord.Name;
                    reviewPage.TabType = 'Related List With Tab';
                    reviewPage.relatedListConfiguration = new relatedList();
                    reviewPage.relatedListConfiguration.record = tabRecord;
                    reviewPage.relatedListConfiguration.strRelatedListObject = tabRecord.FGM_Portal__ObjectName__c;
                    reviewPage.relatedListConfiguration.mapColumnFields =  getrelatedListColumn(tabRecord);
                    reviewPage.relatedListConfiguration.relatedListLookUp =  tabRecord.FGM_Portal__LookupField__c;

                    if(!reviewPage.relatedListConfiguration.mapColumnFields.isEmpty())
                        reviewPage.relatedListConfiguration.lstRelatedListRecord = getRelatedListRecords(tabRecord,new Set<String>(reviewPage.relatedListConfiguration.mapColumnFields.values()));
                    reviewPageList.add(reviewPage);
                }
            }
        }
    }

    public class ReviewPage {
        public String name { set; get; }
        public String TabType { set; get; }
        public relatedList relatedListConfiguration { get; set; }
        public ReviewQuestion[] reviewQuestionList { set; get; }
    }

    public class ReviewQuestion {
        public Questions__c question { set; get; }
        public String response { set; get; }
        public String questionType {set; get;}
        public string questionId {get; set;}
        public String field{get;set;}
    }
    // class for showing related list records for custom object
    public with sharing class relatedList{
        public Map<String,String> mapColumnFields { get; set; }
        public List<Object> lstRelatedListRecord { get; set; }
        public String strActionColLabel  { get; set; }
        public String strRelatedListObject { get; set; }
        public String relatedListLookUp { get; set; }
        public Boolean isCreatable { get; set; }
        public Boolean isEditable { get; set; }
        public Boolean isDeletable { get; set; }
        public Related_List_Controller__c record { get; set; }
        public relatedList(){
            lstRelatedListRecord = new List<Object>();
            strActionColLabel = 'Action';
        }
    }
    //Class for Attachment
    public with sharing class ApplicationAttachments{
        public String strQuestionAttachmentId {get; set;}
        public Attachment newAttachment {get; set;}
        public Map<String,Attachment> mapOldAttachments {get; set;}
        public integer oldMapSize {get; set;}

        public ApplicationAttachments() {
            newAttachment = new Attachment();
            mapOldAttachments  = new Map<String,Attachment>();
            oldMapSize = 0;
        }
    }
}