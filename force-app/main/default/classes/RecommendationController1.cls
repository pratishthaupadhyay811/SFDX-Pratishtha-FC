public without sharing class RecommendationController1 {
    public Boolean initialized {get; set;} {initialized = false;}
    public Set<String> setAttachmentQuestionList;
    public String currentParentObject;
    public sobject recommendationReview {get;set;}
    //public Set<String> requiredQuestions;
    public String  tabRecordId;
    private String appID ='';
    private String applicationRecordTypeId ;
    private Boolean isReviewSubmitPage;
    private Set<Id> portalTabIds;
    public FGM_Portal__Quiz__c quiz { set; get; }
    public sobject application { set; get; }
    public FGM_Portal__Quiz_Questions__c[] quizQuestionList { set; get; }
    public List<FGM_Portal__Related_List_Controller__c> tabsList { get; set; }    // To get Tab records from RLC
    public String selectedTab { set; get; }
    public string applicationRecordType {get; set;}
    public sobject tabObject { get; set; }
    public Map<String,String> mapFormulaFields { get; set; }
    public String strHiddenValue {get; set;}
    public Map<String,Map<String,String>> mapFormulaFieldsByObject;
    public Map<String,ApplicationAttachments> mapApplicationAttachments {get; set;}
    public Boolean isErrorInAttachment { get; set; }
    public String attachedQuestionId { get; set;}
    public ReviewPage[] reviewPageList { set; get; }
    public Boolean isFeedbackSubmitted {get; set;}
    public String appStage {get; set;}
    public Boolean showFeedbackMsg {get; set;}
    public string strFields{get;set;}
    public SFDCEncoder ESAPI = new SFDCEncoder();
    public List<Questions__c> requiredQuestionErrors {get; set;} {requiredQuestionErrors = new List<Questions__c>();}

    public RecommendationController1()
    {
        isReviewSubmitPage = false;
        isFeedbackSubmitted = false;
    }

    
    //Review
     public FGM_Portal__Recommendation_Review__c beforeSave()
   {
       FGM_Portal__Recommendation_Review__c newObject = null;  
       sObject insertSobject = null;
       sObject parentSobject = null; // placeholder
       
       parentSobject = tabObject;
       insertSobject = parentSobject;
       
       newObject = (FGM_Portal__Recommendation_Review__c)insertSobject;
       newObject.FGM_Portal__Recommendation__c= ApexPages.currentPage().getParameters().get('id');
       return newObject;
   }    
    // Save Record
    public void saveRecord()
    {
        // Set save point to rollback on error
         System.debug('save Record -->>');
        Savepoint sp = Database.setSavepoint();
        sobject upsertObject = null;
        FGM_Portal__Recommendation_Review__c newObject= null;
        if(tabObject == null)
        {
            return ;
        }
        sObject parentSobject = null; // placeholder
        parentSobject = tabObject;
        upsertObject = parentSobject;
        System.debug('<<--upsertObject-->>'+upsertObject);
        try
        {
            //logic to check required field must not be blank before save the application.
            requiredQuestionErrors = new List<Questions__c>();
            for(FGM_Portal__Quiz_Questions__c quizQuestion: quizQuestionList)
            {
                if(quizQuestion.FGM_Portal__Required__c && quizQuestion.FGM_Portal__Tab__c == selectedTab)
                {
                    if(quizQuestion.FGM_Portal__Question__r.Type__c == 'Salesforce Data Type' )
                    {
                        if(upsertObject.get(quizQuestion.FGM_Portal__Field__c) == null )
                        {
                            requiredQuestionErrors.add(quizQuestion.Question__r);
                        }
                    }
                    else if(quizQuestion.FGM_Portal__Question__r.Type__c == 'Attachment')
                    {
                        if(mapApplicationAttachments.get(quizQuestion.FGM_Portal__Question__c) != null && mapApplicationAttachments.get(quizQuestion.FGM_Portal__Question__c).oldMapSize <= 0)
                        {
                            requiredQuestionErrors.add(quizQuestion.Question__r);
                        }
                    }
                }
            }//end of for
           /* List<Schema.PicklistEntry> picklistValues = FGM_Portal__Recommendation__c.FGM_Portal__Status__c.getDescribe().getPicklistValues();
            for(Schema.PicklistEntry picklistEntry : picklistValues ){
                if(picklistEntry.getValue() == 'In Progress'){
                    upsertObject.put('FGM_Portal__Status__c', picklistEntry.getLabel());  
                    break;
                }
            }

            upsertObject = CrudFlsService.getInstance().stripInaccessibleForUpdate(upsertObject);*/
           // upsert upsertObject;
           newObject = (FGM_Portal__Recommendation_Review__c)upsertObject;
           newObject.FGM_Portal__Recommendation__c= ApexPages.currentPage().getParameters().get('id');
            insert newObject;
            
            application = newObject;
            System.debug('<< -90-application -->>'+ application);
            if(application != null )
            {
                List<String> lstApplicationObjectFields = new List<String>(application.getsObjectType().getDescribe().fields.getMap().keySet());
                String applicationObjectName = String.valueOf(application.getsObjectType());
                String applicationRecordId = String.valueOf(application.Id);
                List<Sobject> lstApplicationRecords = Database.query(''
                                                                     + 'SELECT ' + String.join(lstApplicationObjectFields, ', ')
                                                                     +' FROM '+applicationObjectName
                                                                     +' WHERE Id=:applicationRecordId');

			    lstApplicationRecords = CrudFlsService.getInstance().stripInaccessibleForRead(lstApplicationRecords);

                if(lstApplicationRecords!= null && lstApplicationRecords.size()>0)
                {
                    application = lstApplicationRecords[0];
                    tabObject = application;
                }

            }
           
        }
        catch(DMLException ex)
        {
            String errorMessage = ex.getMessage();
            Integer occurence;
            if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
            {
                occurence = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
                errorMessage = errorMessage.mid(occurence, errorMessage.length());
                occurence = errorMessage.lastIndexOf(':');
                errorMessage = errorMessage.mid(0, occurence);
                rollbackWithError(errorMessage,sp);
            }
            else
            {
                rollbackWithError(ex.getMessage(),sp);
            }
        }
        catch(Exception ex)
        {
            rollbackWithError(ex.getMessage(),sp);
        }
         
    }

    public PageReference submit()
    {
        if(application != null && application.Id != null)
        {
            //Logic to check required field must not be blank before review and submit the recommondation
            if(tabsList != null && !tabsList.isEmpty())
            {
                Map<id,FGM_Portal__Related_List_Controller__c> mapTabIdsToName = new Map<id,FGM_Portal__Related_List_Controller__c>(tabsList);
                if(quizQuestionList != null && !quizQuestionList.isEmpty())
                {
                    
                    for(FGM_Portal__Quiz_Questions__c quizQuestion: quizQuestionList)
                    {
                        if(quizQuestion.FGM_Portal__Required__c && quizQuestion.FGM_Portal__Question__r.Type__c == 'Salesforce Data Type' )
                        {
                            if(application.get(quizQuestion.FGM_Portal__Field__c) == null )
                            {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, System.Label.FC_Required_Field_Label + ' : ' +quizQuestion.FGM_Portal__Question__r.RichQuestion__c ));
                            }
                        }
                        else if(quizQuestion.FGM_Portal__Required__c &&  quizQuestion.FGM_Portal__Question__r.Type__c == 'Attachment' )
                        {
                            if(mapApplicationAttachments.get(quizQuestion.FGM_Portal__Question__c) != null && mapApplicationAttachments.get(quizQuestion.FGM_Portal__Question__c).oldMapSize <= 0)
                            {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, System.Label.FC_Required_Field_Label + ' : ' +quizQuestion.FGM_Portal__Question__r.RichQuestion__c ));
                            }
                        }//end of if
                    }//end of for loop
                }
            }
        }
        if(ApexPages.hasMessages())
        {
            return null;
        }
        else
        {
            if(String.isNotBlank(currentParentObject) && 'FGM_Portal__Recommendation__c'.equalsIgnoreCase(currentParentObject))
            {
                application.put('FGM_Portal__Status__c','Submitted');
            }

            application = CrudFlsService.getInstance().stripInaccessibleForUpdate(application);
            Database.saveResult saveResult =  Database.update(application);
            if(saveResult != null && saveResult.isSuccess())
            {
                isFeedbackSubmitted = true;
                showFeedbackMsg = true;
            }
            else
            {
                isFeedbackSubmitted = false;
                showFeedbackMsg = false;
            }
        }
        return null;
    }

     public PageReference saveBeforeReviewSubmit(){
        Savepoint sp = Database.setSavepoint();
        try{
            if(application == null)
                return null;

            application = CrudFlsService.getInstance().stripInaccessibleForUpdate(application);
            Database.saveResult saveResult =  Database.update(application);
            if(saveResult != null && saveResult.isSuccess()){
                PageReference pageRefrence = System.Page.RecommendationReview;
                pageRefrence.getParameters().put('id', ApexPages.currentPage().getParameters().get('id'));
                pageRefrence.getParameters().put('quizId', quiz.Id);
                pageRefrence.setRedirect(true);
                return pageRefrence;
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
  
    
    // To Upload the Attachment.
    
    public PageReference uploadAttachment()
    {
        try
        {
            attachedQuestionId = ApexPages.currentPage().getParameters().get('attachedQuestionId');
            String extension = '';
            String filename;
            if(String.isNotBlank(attachedQuestionId) && mapApplicationAttachments.containsKey(attachedQuestionId))
            {
                FGM_Portal__Questions__c  question = new FGM_Portal__Questions__c();
                question = getQuestionById(attachedQuestionId);
                string namingFormula = question.FGM_Portal__AttachmentNameFormula__c;
                attachedQuestionId = String.escapeSingleQuotes(attachedQuestionId);
                ApplicationAttachments applicationAttachment = mapApplicationAttachments.get(attachedQuestionId);
                String[] parts = new List<String>();
                if(namingFormula != null)
                {
                    parts = namingFormula.split('\\+');
                }
                Attachment newAttachment = applicationAttachment.newAttachment;
                FGM_Portal__GlobalPortalSettings__c GlobalPortalSetting = FGM_Portal__GlobalPortalSettings__c.getOrgDefaults();
                if(newAttachment != null  && GlobalPortalSetting != null && GlobalPortalSetting.FGM_Portal__Is_VirusScan_Enabled__c)
                {
                    VirusScan.ScanStatus status =  scanFile(newAttachment);
                    if(status.IsInfected)
                    {
                        return null;
                    }
                }
                if(applicationAttachment != null)
                {
                    if (application.Id != null && String.isNotBlank(applicationAttachment.strQuestionAttachmentId) && newAttachment.Body != null && newAttachment.Name != null)
                    {
                        newAttachment.ParentId = applicationAttachment.strQuestionAttachmentId;
                        newAttachment.IsPrivate = false;
                        newAttachment.OwnerId = UserInfo.getUserId();
                        String attachmentName = '';
                        if(namingFormula != null){
                            for(integer i=0; i < parts.size(); i++){
                                Boolean isFileName = parts[i].contains('FileName');
                                Boolean isField = parts[i].contains('\'');
                                string[] filenameparts;
                                filename = newAttachment.Name;
                                if(filename != null && String.isNotBlank(filename)){
                                    filenameparts = filename.split('\\.');
                                }
                                if(filenameparts != null && filenameparts.size() > 0){
                                    extension = filenameparts[filenameparts.size()-1];
                                }
                                if(extension != null && String.isNotBlank(extension)){
                                    filename = filename.removeEnd('.' + extension);
                                }
                                if(isFileName == true){
                                    attachmentName = attachmentName + filename + '-';
                                }
                                else{
                                    if(isField == false){
                                        string strfieldName = parts[i].trim();
                                        attachmentName = attachmentName + application.get(strfieldName) + '-';
                                    }
                                    else{
                                        string strStaticText;
                                        if(parts[i].substring(1) != null && String.isNotBlank(parts[i].substring(1))){
                                            strStaticText = parts[i].substring(1).substringBeforeLast('\'');
                                        }
                                        attachmentName = attachmentName + strStaticText + '-';
                                    }
                                }
                            }
                            attachmentName = attachmentName.removeEnd('-');
                            newAttachment.Name = attachmentName + '.' + extension;
                        }
                        else{
                            attachmentName = newAttachment.Name;
                            newAttachment.Name = attachmentName;
                        }
                        CrudFlsService.getInstance().assertCreateable(newAttachment);
                        insert newAttachment;

                        applicationAttachment.questionAttachment = [
                            SELECT
                                Name,
                                Id,
                                Question__c,
                                Opportunity__c,
                                Inquiry__c,
                                GranteeReport__c,
                                Description__c,
                                Benchmark_del__c,
                                Amendment__c
                            FROM Question_Attachment__c
                            WHERE Id = :applicationAttachment.strQuestionAttachmentId
                            WITH SECURITY_ENFORCED
                        ];

                        if(applicationAttachment.questionAttachment != null && applicationAttachment.questionAttachment.Id != null)
                        {
                            applicationAttachment.questionAttachment.Description__c = newAttachment.Description;
                            CrudFlsService.getInstance().assertUpdateable(applicationAttachment.questionAttachment);
                            update applicationAttachment.questionAttachment;
                        }
                        newAttachment.Body = null;
                        applicationAttachment.mapOldAttachments.put(newAttachment.Id, newAttachment);
                        applicationAttachment.newAttachment = new Attachment();
                        applicationAttachment.oldMapSize = applicationAttachment.mapOldAttachments.size();
                    }
                }
            }
            return null;
        }
        catch(Exception ex)
        {
            return null;
        }
    }

    // To delete the Attachment.
    public void deleteAttachment()
    {
        string attachmentQuestionId = ApexPages.currentPage().getParameters().get('attachedQuestionId');
        string attachmentId = ApexPages.currentPage().getParameters().get('attachedId');
        if(String.isNotBlank(attachmentQuestionId) && String.isNotBlank(attachmentId) && mapApplicationAttachments.containsKey(attachmentQuestionId))
        {
            attachmentId = String.escapeSingleQuotes(attachmentId);
            attachmentQuestionId = String.escapeSingleQuotes(attachmentQuestionId);
            if((mapApplicationAttachments.get(attachmentQuestionId)).mapOldAttachments.containsKey(attachmentId))
            {
                Attachment attchmentToDelete = (mapApplicationAttachments.get(attachmentQuestionId)).mapOldAttachments.get(attachmentId);
                List<Attachment> deleteAttachment = new List<Attachment>{attchmentToDelete};
                    try
                {
                    CrudFlsService.getInstance().assertDeletable(deleteAttachment);
                    delete deleteAttachment;
                    (mapApplicationAttachments.get(attachmentQuestionId)).mapOldAttachments.remove(attachmentId);
                    (mapApplicationAttachments.get(attachmentQuestionId)).oldMapSize = (mapApplicationAttachments.get(attachmentQuestionId)).mapOldAttachments.size();
                }
                catch(Exception ex)
                {
                    rollbackWithError(ex.getMessage(),null);
                }
            }
        }
    }

    public PageReference initialize()
    {
        initialized = true;
        mapFormulaFieldsByObject = new Map<String,Map<String,String>>();
        mapApplicationAttachments = new Map<String,ApplicationAttachments>();
        setAttachmentQuestionList = new Set<String>();
        //requiredQuestions  = new Set<String>();
        // 1. Initilize Recommender record as per record type
        initializeApplication();
        if(quiz == null)
        {
            return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_FCRecord_Processing_ErrorMsg),null);
        }
        application = (sobject) new FGM_Portal__Recommendation_Review__c();
        System.debug('application' +application);
       if(application == null)
        {
            return rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_FCRecord_Processing_ErrorMsg),null);
        } 
        //2. Initialize Tabs for Recommneder as per designed Quiz.
        initializeTabs();
        initializeQuizQuestionList(selectedTab);
        initializeAttachment();
        strFields=JSON.serialize(FCGlobal.getFieldLengthMap('FGM_Portal__Recommendation__c'));
        return null;
    }

    // To get Query String Parameter.
    public String getParam(String name)
    {
        String strNameValue = ApexPages.currentPage().getParameters().get(name);
        String strReturnNameValue = '';
        if(String.isEmpty(strNameValue))
        {
            strReturnNameValue = '';
        }
        else
        {
            strReturnNameValue = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(name));
        }
        return strReturnNameValue;
    }

    public String getApplicationObjectName()
    {
        if(tabObject != null)
        {
            return  String.valueOf(tabObject.getsObjectType());
        }
        return null;
    }
    public PageReference rollbackWithError(String message, System.Savepoint savepoint)
    {
        if (savepoint != null)
        {
            Database.rollback(savepoint);
        }
        if (message != null)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, message));
        }
        return null;
    }

    // Initialize Recommender Application records
    public void initializeApplication()  
    {
         //String recommendationID = getParam('id');   
         appID = getParam('id');
       // FGM_Portal__Recommendation__c recommendation = [SELECT Id FROM FGM_Portal__Recommendation__c WHERE Id =:recommendationID ];
        //recommendationReview = new FGM_Portal__Recommendation_Review__c(FGM_Portal__Recommendation1__c = appID);  
       // Database.SaveResult reviewResult = Database.insert(recommendationReview); 
       // appID = recommendationReview.Id;
         System.debug('appID : ' +appID);
        applicationRecordTypeId = '';
        sobject[] applicationList = null;
        Set<String> fieldSet = new Set<String> {};
            if(String.isNotBlank(appID))
        {
            //currentParentObject = FCGlobal.getObjectNameById(appID);
              currentParentObject = 'FGM_Portal__Recommendation_Review__c';  
            //Map<String,String> mapApplicationFields = FCGLobal.getsObjectFields('FGM_Portal__Recommendation__c',null);
            Map<String,String> mapApplicationFields = FCGLobal.getsObjectFields('FGM_Portal__Recommendation_Review__c',null);
            System.debug('461 currentParentObject'+currentParentObject);
            if(!mapApplicationFields.isEmpty())
            {
                fieldSet.addAll(mapApplicationFields.values());
            }

            List<String> sanitizedFields = new List<String>();

            for (String f : fieldSet) {
                sanitizedFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
            }

            /*applicationList = (sObject[]) Database.query(''
                                                         + 'SELECT ' + String.join(sanitizedFields, ', ')
                                                         + '  FROM FGM_Portal__Recommendation_Review__c'
                                                         + ' WHERE Id =: appID');*/

                 
			//applicationList = CrudFlsService.getInstance().stripInaccessibleForRead(applicationList);
          
            //if (applicationList != null && !applicationList.isEmpty())
            
                //application = applicationList[0];
               

                /*if('FGM_Portal__Recommendation__c'.equalsIgnoreCase(currentParentObject))
                {
                    appStage = String.valueof(application.get('FGM_Portal__Status__c'));
                    if(appStage.equalsIgnoreCase('Submitted'))
                    {
                        isFeedbackSubmitted = true;
                    }
                } */
                try
                {
                   // if(application.get('RecordTypeId') != null)
                    
                     RecordType recordtype= [SELECT Id FROM RecordType WHERE Name =:'Recommendation Review' ];
                        applicationRecordTypeId = String.valueOf(recordtype.Id);
                        System.debug('applicationRecordTypeId : '+ applicationRecordTypeId);
                    
                }
                catch(Exception ex){ }
                initializeQuiz(applicationRecordTypeId);
            
        }
    }

    // initialize the Quiz according to RecordType
    @TestVisible private void initializeQuiz(String RecordTypeId)
    {
        if(String.isNotBlank(RecordTypeId))
        {

            List<FCPageLayout__c> lstPageLayout = [
                SELECT
                    ObjectName__c,
                    Quiz__c,
                    Quiz__r.FGM_Portal__Is_Active__c,
                    Quiz__r.Id
                 FROM FCPageLayout__c
                 WHERE RecordTypeId__c = :RecordTypeId
                 AND Quiz__c != null
                 WITH SECURITY_ENFORCED
            ];

            if(lstPageLayout != null && !lstPageLayout.isEmpty())
            {
                quiz = lstPageLayout[0].Quiz__r;
                if(currentParentObject == null)
                {
                    currentParentObject = lstPageLayout[0].ObjectName__c;
                }
            }
            else
            {
                rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_FCRecord_PageLayoutProcessing_ErrorMsg),null);
            }
        }
        else
        {
            rollbackWithError(ESAPI.SFDC_HTMLENCODE(System.Label.FC_FCRecord_PageLayoutProcessing_ErrorMsg),null);
        }
    }

    //Initialize Tabs for Recommeneder as per designed Quiz and show related Quiz Questions.
    public void initializeTabs()
    {
        System.debug('<<-||initialize tabs->>');  
        String strRLCLang = 'en_US';

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
                RecordType.Name,
                RecordTypeId,
                ShowDeleteLink__c,
                ShowNewButton__c,
                (
                    SELECT
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
            AND (
                Language__c =: strRLCLang
                OR Language__c = ''
            )
            AND IsCommunityRecord__c = TRUE
            WITH SECURITY_ENFORCED
            ORDER BY SortOrder__c ASC NULLS LAST 
            LIMIT 10000
        ];
        System.debug('<<-tablist->>>'+tabsList);

        if(!tabsList.isEmpty())
        {
            if(tabsList != null && !tabsList.isEmpty() && !String.isNotBlank(selectedTab))
            {
                selectedTab = String.valueOf(tabsList[0].Id);
                if(!tabsList[0].FGM_Portal__ParentObject__c.equalsIgnoreCase('sObject'))
                {
                    currentParentObject = tabsList[0].FGM_Portal__ParentObject__c;
                }
                else if(tabsList.size() > 1)
                {
                    currentParentObject = tabsList[1].FGM_Portal__ParentObject__c;
                }
            }
        }
        // To show the application sObject recordtype name
        Map<Id,Schema.RecordTypeInfo> recordTypeInfo = Schema.Sobjecttype.FGM_Portal__Recommendation_Review__c.getRecordTypeInfosById();
        if(recordTypeInfo.Size() != 1)
        {

           /* List<RecordType> lstsObjectApplicationRecordType = [
                SELECT Name
                FROM RecordType
                WHERE Id = :((Id) application.get('RecordTypeId'))
                WITH SECURITY_ENFORCED
            ]; */ 

            applicationRecordType =  'Recommendation Review' ;
          
      
        }
    }

    // To initialize the Submission List of Application.
    private void initilizeSubmissionList()
    { System.debug('initilizeSubmissionList 628 : ');
        tabObject = application;
        if(application != null && application.Id != null)
        {
            tabRecordId = application.Id;
        }
    }

    //Initialize ReadOnly Fields for Tab
    public Map<String,String> initializeReadonlyFields()
    {
        Map<String,String> mapReadOnlyFields = new Map<String,String>();
        if(tabObject != null)
        {
            String strObjectName = tabObject.getsObjectType().getDescribe().name;
            if(String.isNotBlank(strObjectName))
            {
                if(!mapFormulaFieldsByObject.containsKey(strObjectName))
                {
                    Map<String,String> mapReadOnlyField = new Map<String,String>();
                    Map<String,Schema.SObjectField> objectFields =  FCGLobal.getMapsObjectFields(strObjectName);
                    if(objectFields != null)
                    {
                        for(Schema.SObjectField field : objectFields.values())
                        {
                            Schema.DescribeFieldResult fieldResult = field.getDescribe();
                            if(fieldResult.isCalculated())
                            {
                                mapReadOnlyField.put(fieldResult.getName(),'FORMULA');
                            }
                            else
                            {
                                mapReadOnlyField.put(fieldResult.getName(),String.valueOf(fieldResult.getType()));
                            }
                        }
                        mapFormulaFieldsByObject.put(strObjectName,mapReadOnlyField);
                        return mapReadOnlyField;
                    }
                }
                else
                {
                    return mapFormulaFieldsByObject.get(strObjectName);
                }
            }
        }
        return mapReadOnlyFields;
    }

    //Initialize Quiz Question for Tab
    public void initializeQuizQuestionList()
    {
        String strSelectedTabId = getParam('tabId');
        initializeQuizQuestionList(strSelectedTabId);
    }

    //Initialize Quiz Question for Selected Tab
    public void initializeQuizQuestionList(String strSelectedTabId)
    {
        if(isReviewSubmitPage)
        {
            if(tabsList != null)
            {
                quizQuestionList = new List<FGM_Portal__Quiz_Questions__c>();
                portalTabIds = new Set<Id>();
                Map<Id,Schema.RecordTypeInfo> recordTypeInfo = Schema.Sobjecttype.FGM_Portal__Related_List_Controller__c.getRecordTypeInfosById();
                for(FGM_Portal__Related_List_Controller__c tabRecord : tabsList)
                {
                    Schema.RecordTypeInfo requiredRecordType = recordTypeInfo.get(tabRecord.RecordTypeId);
                    String strRLCRecordTypeName = '';
                    if(requiredRecordType != null)
                    {
                        strRLCRecordTypeName = requiredRecordType.getName();  // Get record Type Name
                    }
                    if(String.isNotBlank(strRLCRecordTypeName) && 'Portal Tab'.equalsIgnoreCase(strRLCRecordTypeName))
                    {
                        portalTabIds.add(tabRecord.Id);
                        if(tabRecord.Quiz_Questions__r != null)
                        {
                            quizQuestionList.addAll(tabRecord.Quiz_Questions__r);
                        }
                    }
                }//End of for Loop for tabsList
            }
            return;
        }
        else
        {
            tabObject = null;
            tabRecordId = '';
            isErrorInAttachment = false;
            mapFormulaFields = new Map<String,String>();
            if(String.isNotBlank(strSelectedTabId))
            {
                selectedTab = strSelectedTabId;
            }
            if(tabsList != null && String.isNotBlank(selectedTab))
            {
                quizQuestionList = new List<FGM_Portal__Quiz_Questions__c>();
                Map<Id,Schema.RecordTypeInfo> recordTypeInfo = Schema.Sobjecttype.FGM_Portal__Related_List_Controller__c.getRecordTypeInfosById();
                for(FGM_Portal__Related_List_Controller__c tabRecord : tabsList)
                {
                    if(selectedTab == String.valueOf(tabRecord.Id))
                    {
                        if(tabRecord.Quiz_Questions__r != null)
                        {
                            quizQuestionList = tabRecord.Quiz_Questions__r;
                        }
                        Schema.RecordTypeInfo requiredRecordType = recordTypeInfo.get(tabRecord.RecordTypeId);
                        String strRLCRecordTypeName = '';
                        if(requiredRecordType != null)
                        {
                            strRLCRecordTypeName = requiredRecordType.getName();  // Get record Type Name
                        }
                        if(String.isNotBlank(strRLCRecordTypeName) && 'Portal Tab'.equalsIgnoreCase(strRLCRecordTypeName))
                        {
                            initilizeSubmissionList();
                            mapFormulaFields = initializeReadonlyFields();
                        }
                        break;
                    }
                }//End of for Loop for tabsList
            }
        }
    }

    public PageReference cancel()
    {
        PageReference reference = System.Page.CommunitySignin;
        reference.setRedirect(true);
        return reference;
    }

    // Initialize the Attachments
    public void initializeAttachment()
    {
        mapApplicationAttachments = new Map<String,ApplicationAttachments>();
        setAttachmentQuestionList = new Set<String>();
        if(quizQuestionList != null)
        {
            for(FGM_Portal__Quiz_Questions__c quizQuestion : quizQuestionList)
            {
                if(String.isNotBlank(quizQuestion.FGM_Portal__Question__r.FGM_Portal__Type__c) && quizQuestion.FGM_Portal__Question__r.FGM_Portal__Type__c == 'Attachment')
                {
                    setAttachmentQuestionList.add(quizQuestion.FGM_Portal__Question__c);
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
            String sanitizedQuestionAttachmentRelationField = questionAttachmentRelationField.replaceAll('[^0-9a-zA-Z_.]', '');

            List<Question_Attachment__c> lstQuestionAttachment = new List<Question_Attachment__c>((List<Question_Attachment__c>)Database.Query(''
                                                                                                                                               +'SELECT (SELECT Name'
                                                                                                                                               +',Id'
                                                                                                                                               +', ContentType'
                                                                                                                                               +', BodyLength'
                                                                                                                                               +',CreatedDate'
                                                                                                                                               +' FROM Attachments)'
                                                                                                                                               +', Question__c'
                                                                                                                                               +', Description__c'
                                                                                                                                               +' FROM Question_Attachment__c'
                                                                                                                                               +' Where ' + sanitizedQuestionAttachmentRelationField + ' = :applicationId'
                                                                                                                                               +' WITH SECURITY_ENFORCED'
                                                                                                                                               +' ORDER BY CreatedDate ASC'
                                                                                                                                               +' LIMIT 10000'));

            if(lstQuestionAttachment != null && !lstQuestionAttachment.isEmpty())
            {
                for(Question_Attachment__c questionAttachment : lstQuestionAttachment)
                {
                    setAttachmentQuestionList.remove(questionAttachment.Question__c);
                    ApplicationAttachments applicationAttachment = new ApplicationAttachments();
                    applicationAttachment.strQuestionAttachmentId = questionAttachment.Id;
                    applicationAttachment.questionAttachment = questionAttachment;

                    for(Attachment attachment: questionAttachment.Attachments)
                    {
                        applicationAttachment.mapOldAttachments.put(String.valueOf(attachment.Id),attachment);
                    }

                    applicationAttachment.oldMapSize = applicationAttachment.mapOldAttachments.size();
                    mapApplicationAttachments.put(String.valueOf(questionAttachment.Question__c),applicationAttachment);
                }
            }
            if(!setAttachmentQuestionList.isEmpty() && application != null && application.Id != null)
            {
                List<Question_Attachment__c> lstUpsertQuestionAttachment = new List<Question_Attachment__c>();
                if(String.isNotBlank(questionAttachmentRelationField))
                {
                    for(String questionId : setAttachmentQuestionList)
                    {
                        Question_Attachment__c questionAttachment = new Question_Attachment__c();
                        questionAttachment.put('Question__c',questionId);
                        questionAttachment.put(questionAttachmentRelationField,application.Id);
                        lstUpsertQuestionAttachment.add(questionAttachment);
                    }
                }
                else
                {
                    isErrorInAttachment = true;
                }
                // Upsert the attachment placeholders
                if(!lstUpsertQuestionAttachment.isEmpty())
                {
                    CrudFlsService.getInstance().assertUpdateable(lstUpsertQuestionAttachment);
                    upsert lstUpsertQuestionAttachment;
                    for(Question_Attachment__c questionAttachment : lstUpsertQuestionAttachment)
                    {
                        ApplicationAttachments applicationAttachment = new ApplicationAttachments();
                        applicationAttachment.strQuestionAttachmentId = questionAttachment.Id;
                        for(Attachment attachment: questionAttachment.Attachments)
                        {
                            applicationAttachment.mapOldAttachments.put(String.valueOf(attachment.Id),attachment);
                        }
                        applicationAttachment.oldMapSize = applicationAttachment.mapOldAttachments.size();
                        mapApplicationAttachments.put(String.valueOf(questionAttachment.Question__c),applicationAttachment);
                    }
                }
            }
        }
    }

    //To scan Upload attachment
    public VirusScan.ScanStatus scanFile(Attachment file)
    {
        if(file != null && file.Body != null)
        {
            VirusScan.FileDetailInfo fileDetailInfo = new VirusScan.FileDetailInfo();
            fileDetailInfo.FileName =  file.Name;
            fileDetailInfo.GUID = FCGlobal.NewGuid(); //globally unique identifier (GUID)
            fileDetailInfo.DataInBase64 = EncodingUtil.base64Encode(file.Body);
            fileDetailInfo.OrgID = UserInfo.getOrganizationId();
            VirusScan.ScanFileManagerSoap scanFile = new VirusScan.ScanFileManagerSoap();
            if(Test.isRunningTest())
            {
                VirusScan.ScanStatus fileScanTestStatus = new VirusScan.ScanStatus();
                fileScanTestStatus.IsCompleted = true;
                fileScanTestStatus.Status = 'completed';
                fileScanTestStatus.IsInfected = false;
                return fileScanTestStatus;
            }
            VirusScan.ScanStatus fileUploadStatus = scanFile.UploadFileToScan(fileDetailInfo);
            if(fileUploadStatus.Success)
            {
                VirusScan.ScanStatus fileScanStatus = scanFile.ScanFile(fileDetailInfo);
                if(fileScanStatus.IsCompleted && fileScanStatus.IsInfected)
                {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,System.Label.FC_Infected_File_Error_Message));
                    return fileScanStatus;
                }
            }
            return fileUploadStatus ;
        }
        return new VirusScan.ScanStatus();
    }

    // To Show Attachment Description

    public Boolean IsFileDescriptionEnabled
    {
        get
        {
            FGM_Portal__CommunitySetting__c communitySetting = FGM_Portal__CommunitySetting__c.getInstance('IsAttachmentDescriptionEnabled');
            if(communitySetting == null || communitySetting.FGM_Portal__IsEnabled__c == false)
            {
                return false;
            }
            else
            {
                return true;
            }
        }
    }

    private FGM_Portal__Questions__c  getQuestionById(String questionId)
    {
        FGM_Portal__Questions__c   question = null;
        if(quizQuestionList != null && !quizQuestionList.isEmpty() && String.isNotBlank(questionId))
        {
            for(FGM_Portal__Quiz_Questions__c quizQuestionRecord : quizQuestionList)
            {
                if(quizQuestionRecord.FGM_Portal__Question__c != null && questionId.equalsIgnoreCase(String.valueOf(quizQuestionRecord.FGM_Portal__Question__c)))
                {
                    question = quizQuestionRecord.FGM_Portal__Question__r;
                    break;
                }
            }
        }
        return question;
    }

    //---------------Review And Submit--------------------
    public void initializeReview()
    {
        initialized = true;
        // Force all pages to display
        showFeedbackMsg = false;
        isReviewSubmitPage = true;
        isFeedbackSubmitted = false;
        // Run the normal process
        initialize();
        // Convert to a review list
        initializeReviewPageList();
        return;
    }

    //To show record in Review Page.
    public void initializeReviewPageList()
    {
        // Setup the review list
        reviewPageList = new ReviewPage[] {};
            if (application.Id == null || tabsList == null || tabsList.isEmpty())
        {
            return;
        }
        try
        {
            if(portalTabIds != null)
            {
                ReviewPage reviewPage = null;
                for(FGM_Portal__Related_List_Controller__c tabRecord : tabsList)
                {
                    reviewPage = null;
                    if(portalTabIds.contains(tabRecord.Id))
                    {
                        reviewPage = new ReviewPage();
                        reviewPage.name = tabRecord.Name;
                        reviewPage.TabType = 'Portal Tab';
                        reviewPage.reviewQuestionList = new ReviewQuestion[] {};
                            if(tabRecord.Quiz_Questions__r == null)
                        {
                            continue;
                        }
                        for(FGM_Portal__Quiz_Questions__c quizQuestion : tabRecord.Quiz_Questions__r)
                        {
                            // Missing field types can  be skipped
                            if (quizQuestion.FGM_Portal__Question__r.FGM_Portal__Type__c == null)
                            {
                                continue;
                            }
                            // Missing field types can  be skipped
                            if (quizQuestion.FGM_Portal__Question__r.FGM_Portal__Type__c == 'Image')
                            {
                                continue;
                            }
                            if (quizQuestion.Question__r.Type__c == 'Instruction')
                                continue;
                            // Basic response
                            ReviewQuestion reviewQuestion = new ReviewQuestion();
                            reviewQuestion.question = quizQuestion.FGM_Portal__Question__r;
                            // For fields mapped directly to the application
                            if (quizQuestion.Field__c != null && application.get(quizQuestion.Field__c) != null)
                            {
                                reviewQuestion.response = '' + application.get(quizQuestion.Field__c);
                                reviewQuestion.field =  quizQuestion.Field__c;
                            }
                            reviewQuestion.questionType = quizQuestion.FGM_Portal__Question__r.FGM_Portal__Type__c;
                            reviewQuestion.questionId  = quizQuestion.FGM_Portal__Question__c;
                            if(quizQuestion.FGM_Portal__Question__r.FGM_Portal__Type__c == 'Salesforce Data Type')
                            {
                                Schema.DescribeFieldResult FieldInstance = Schema.getGlobalDescribe().get(String.valueOf(tabRecord.FGM_Portal__ObjectName__c).toLowerCase()).getDescribe().fields.getMap().get(String.valueOf(quizQuestion.FGM_Portal__Field__c).toLowerCase()).getDescribe();
                                reviewQuestion.strFieldType = String.valueOf(FieldInstance.getType());
                                reviewQuestion.isHTMLenabled = FieldInstance.isHtmlFormatted();
                            }
                            // Add to reviewPage list
                            reviewPage.reviewQuestionList.add(reviewQuestion);
                            // Add if it required and Empty
                            //if(quizQuestion.Required__c && String.isEmpty(reviewQuestion.response))
                            //{
                            //    requiredQuestions.add(quizQuestion.FGM_Portal__Question__r.FGM_Portal__Question__c);
                            //}
                        }//End OF QuizQuestion For Loop
                        // Only add the reviewPage to the list if there are matched questions
                        if (reviewPage.reviewQuestionList.isEmpty() == false)
                        {
                            reviewPageList.add(reviewPage);
                        }
                    }
                }//End of Tablist For loop
            }
        }
        catch(Exception ex)  
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
        }
    }




    //Class for review Page
    public class ReviewPage
    {
        public String name { set; get; }
        public String TabType { set; get; }
        public ReviewQuestion[] reviewQuestionList { set; get; }
    }
    public class ReviewQuestion
    {
        public Questions__c question { set; get; }
        public String response { set; get; }
        public String questionType {set; get;}
        public string questionId {get; set;}
        public string field{get;set;}
        public String strFieldType {get; set;}
        public Boolean isHTMLenabled {get; set;}
    }

    //Class for Attachment
    public without sharing class ApplicationAttachments
    {
        public String strQuestionAttachmentId {get; set;}
        public Attachment newAttachment {get; set;}
        public Map<String,Attachment> mapOldAttachments {get; set;}
        public integer oldMapSize {get; set;}
        public FGM_Portal__Question_Attachment__c questionAttachment{ get; set; }

        public ApplicationAttachments()
        {
            newAttachment = new Attachment();
            mapOldAttachments  = new Map<String,Attachment>();
            oldMapSize = 0;
        }
    }
}