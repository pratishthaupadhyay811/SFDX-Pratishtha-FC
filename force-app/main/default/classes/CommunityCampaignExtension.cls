public with sharing class CommunityCampaignExtension {
    public String portalLanguage { get; set;}
    public List<QuizCampaignWrapper> lstCampaignQuizzes { get; set; }
    public String quizId { get; set; }
    public Boolean isCampaignExpired{get; set;}
    public String campaignRecordTypeName { get; set; }
    public List<ContentDocumentLink> lstContentDocumentLinkForCampaign{ get; set; }

    public Map<String, Field_Value_Translation__c> campaignTranslations {get; private set;}
    public Map<String, Boolean> shouldUseFieldTranslation {get; private set;}

    public Boolean showAttachmentBlock {
        get {
            return (lstContentDocumentLinkForCampaign.size() > 0 || communityCampaign.Attachments.size() > 0);
        }
    }

    private Set<Id> setSobjectId = new Set<Id>();
    private List<Id> campaignQuizIds = new List<Id>();
    private Campaign communityCampaign;

    @TestVisible
    private transient FieldValueTranslationRepository translationRepository {
        get {
            if (translationRepository == null) {
                translationRepository = new FieldValueTranslationRepository();
            }
            return translationRepository;
        } set;
    }

    public CommunityCampaignExtension(ApexPages.StandardController controller) {
        try {
            setLanguage();

            lstContentDocumentLinkForCampaign = new List<ContentDocumentLink>();
            lstCampaignQuizzes = new List<QuizCampaignWrapper>();

            communityCampaign = (Campaign)controller.getRecord();
            setSobjectId.add(communityCampaign.Id);

            Campaign campaignWithData = getCampaignWithData(communityCampaign.Id);

            setCampaignQuizzes(campaignWithData);
            initializeFiles();
            setCampaignExpiration();
            localizeRecordTypeName(campaignWithData);

        } catch( Exception ex ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,ex.getMessage()));
        }
    }

    private void setLanguage() {
        Id runningUserId = UserInfo.getUserId();
        FCGlobal.UserSession userSession = FCGlobal.getUserSession(runningUserId);
        portalLanguage = userSession.UserLanguage;
        FCGlobal.setUserLanguage(runningUserId, portalLanguage);
    }

    private Campaign getCampaignWithData(Id cId) {
        //query for campaign so we can access other fields on it
        Campaign campaignWithData = [
            SELECT
                Name, RecordTypeId, RecordType.Name, Application_Type__c,
                Application_Quiz__c,LOI_Quiz__c, Description, Description__c
            FROM Campaign
            WHERE Id = :cId
            WITH SECURITY_ENFORCED
        ];

        return campaignWithData;
    }

    private void setCampaignQuizzes(Campaign aCampaign) {
        Set<Id> childQuizIds = new Set<Id>();
        for (Campaign_Quiz__c campaignQuiz : [
                SELECT Name, Quiz__c, Quiz__r.Introduction_Text__c, Rich_Instructional_Text__c,
                    (SELECT Name, Description, BodyLength, ContentType FROM Attachments)
                FROM Campaign_Quiz__c
                WHERE Campaign__c = :communityCampaign.Id AND IsActive__c = TRUE
                WITH SECURITY_ENFORCED
        ]) {
            campaignQuizIds.add(campaignQuiz.Id);
            childQuizIds.add(campaignQuiz.Quiz__c);
            setSobjectId.add(campaignQuiz.Id);
            
            lstCampaignQuizzes.add(new QuizCampaignWrapper(campaignQuiz));
        }

        addParentQuiz(aCampaign, childQuizIds);
    }

    private void addParentQuiz(Campaign aCampaign, Set<Id> childQuizIds) {
        String parentQuizId;

        if (aCampaign.Application_Type__c == 'Application Quiz') {
            parentQuizId = aCampaign.Application_Quiz__c;
        } else if (aCampaign.Application_Type__c == 'LOI Quiz' ) {
            parentQuizId = aCampaign.LOI_Quiz__c;
        } else {
            return;
        }

        if (!childQuizIds.contains(parentQuizId)) {
            setSobjectId.add(parentQuizId);
            Quiz__c parentQuiz = [
                SELECT
                    Introduction_Text__c, Name,
                    (SELECT Name, Description, BodyLength, ContentType FROM Attachments)
                FROM Quiz__c
                WHERE Id = :parentQuizId
                WITH SECURITY_ENFORCED
            ];

            lstCampaignQuizzes.add(new QuizCampaignWrapper(parentQuiz));
        }
    }

    /***************************************************************************************************
     * @description Expiration should be based on midnight on the EndDate of the Campaign using the timezone
     * of the org. This becomes an issue when a seeker is in a timezone that is a day ahead of the grantmaker.
     * Campaign.EndDate is a Date field, so this method compares midnight of the EndDate based on the Org's
     * timezone and the current time.
     */
    private void setCampaignExpiration() {
        isCampaignExpired = new DateUtility().dateHasPassedInCompanyTimezone(communityCampaign.EndDate);
    }

    private void localizeRecordTypeName(Campaign aCampaign) {
        List<RecordTypeLocalization> lstRecordTypeLocalization = [
            SELECT Value
            FROM RecordTypeLocalization
            WHERE ParentId = :aCampaign.RecordTypeId
            AND Language = :portalLanguage
            WITH SECURITY_ENFORCED
        ];

        if( lstRecordTypeLocalization != null && !lstRecordTypeLocalization.isEmpty() ) {
            campaignRecordTypeName = lstRecordTypeLocalization[0].Value;
        } else {
            campaignRecordTypeName = aCampaign.RecordType.Name;
        }
    }

    /*
    purpose: initilize the translation for the campaign and campaign Quiz with respect to the portal language
    */
    public PageReference initializeTranslations() {
        Campaign campaignWithData = getCampaignWithData(communityCampaign.Id);
        initializeCampaignTranslations();
        initializeCampaignQuizTranslations();
        return null;
    }

    private void initializeCampaignTranslations() {
        Map<String, Map<String, Field_Value_Translation__c>> translations = translationRepository.getFieldTranslationsByTranslatedRecordId(
            new List<Id>{ communityCampaign.Id },
            portalLanguage,
            new Set<String>{ 'Name', 'Description', 'FGM_Portal__Description__c' }
        );

        campaignTranslations = translations.get(communityCampaign.Id) == null
            ? new Map<String, Field_Value_Translation__c>()
            : translations.get(communityCampaign.Id);

        shouldUseFieldTranslation = new Map<String, Boolean>{
            'Name' => campaignTranslations.containsKey('Name'),
            'FGM_Portal__Description__c' => campaignTranslations.containsKey('FGM_Portal__Description__c'),
            'Description' => campaignTranslations.containsKey('Description')
        };

        if (campaignTranslations.containsKey('Name')) {
            Field_Value_Translation__c nameTranslation = campaignTranslations.get('Name');
            nameTranslation.Translation_Value__c = nameTranslation.Translation_Value__c.stripHtmlTags();
        }

        if (translations.containsKey('FGM_Portal__Exception')) {
            Map<String, Field_Value_Translation__c> exceptionTranslation = translations.get('FGM_Portal__Exception');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,exceptionTranslation.get('FGM_Portal__Exception').Translation_Value__c));
        }
    }

    private void initializeCampaignQuizTranslations() {
        Map<String, Map<String, Field_Value_Translation__c>> mapCQSobjectAndFieldTranslations =
            translationRepository.getFieldTranslationsByTranslatedRecordId(
                campaignQuizIds,
                portalLanguage,
                new Set<String>{'Name', 'FGM_Portal__Rich_Instructional_Text__c'}
            );

        if (mapCQSobjectAndFieldTranslations != null) {
            for(QuizCampaignWrapper wrapper : lstCampaignQuizzes) {
                wrapper.translate(mapCQSobjectAndFieldTranslations);
            }
        }
    }

    /*
    Purpose: navigation to communityApplication page after clicking on Create Application button
    */
    public PageReference createApplication()
    {
        PageReference pgCommAppln = Page.CommunityApplication;
        pgCommAppln.getParameters().put( 'id',communityCampaign.Id);
        pgCommAppln.getParameters().put( 'quizId',quizId);
        pgCommAppln.getParameters().put( 'from', 'ego' );
        return pgCommAppln;
    }

    /*
    Purpose: Method to get files uploaded to Campaign,CampaignQuizes and Quizes from SF instance
    */
    public void initializeFiles() {
        try {
            List<ContentDocumentLink> lstContentDocumentLink;
            lstContentDocumentLinkForCampaign = new List<ContentDocumentLink>();
            if (!setSobjectId.isEmpty()) {

                lstContentDocumentLink = [
                    SELECT
                        ContentDocument.ContentSize,
                        ContentDocument.Description,
                        ContentDocument.FileType,
                        ContentDocument.LatestPublishedVersionId,
                        ContentDocument.Title,
                        ContentDocumentId,
                        LinkedEntityId
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId IN :setSobjectId
                    WITH SECURITY_ENFORCED
                ];

            }

            if(!lstContentDocumentLink.isEmpty()){

                for(ContentDocumentLink contentDocumentLink :lstContentDocumentLink)
                {
                    if(communityCampaign.Id == contentDocumentLink.LinkedEntityId)
                    {
                        lstContentDocumentLinkForCampaign.add(contentDocumentLink);
                        continue;
                    }
                    for(QuizCampaignWrapper wrapper :lstCampaignQuizzes)
                    {
                        if((wrapper.CampaignQuizId != null && wrapper.CampaignQuizId.equalsIgnoreCase(String.valueOf(contentDocumentLink.LinkedEntityId))) || wrapper.QuizId.equalsIgnoreCase(String.valueOf(contentDocumentLink.LinkedEntityId)))
                        {
                            wrapper.lstContentDocumentLink.add(contentDocumentLink);
                            break;
                        }
                    }
                }
            }

        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, ex.getMessage()));
        }
    }

    @TestVisible
    private class QuizCampaignWrapper {
        public Quiz__c quiz { get; private set; }
        public Campaign_Quiz__c campaignQuiz { get; private set; }

        public String campaignQuizId { get; private set; }
        public String quizId { get; private set; }
        public String name { get; private set; }
        public List<Attachment> attachments { get; private set; }
        public List<ContentDocumentLink> lstContentDocumentLink{ get; private set; }
        public Map<String, Field_Value_Translation__c> translations {get; private set;}
        public Map<String, Boolean> shouldUseFieldTranslation {get; private set;}

        private QuizCampaignWrapper(Quiz__c quiz) {
            this.quiz = quiz;

            this.campaignQuizId = null;
            this.quizId = quiz.Id;
            this.name = quiz.Name;
            this.attachments = quiz.Attachments;

            lstContentDocumentLink = new List<ContentDocumentLink>();
        }

        private QuizCampaignWrapper(Campaign_Quiz__c campaignQuiz) {
            this.campaignQuiz = campaignQuiz;

            this.campaignQuizId = campaignQuiz.Id;
            this.quizId = campaignQuiz.Quiz__c;
            this.name = campaignQuiz.Name;
            this.attachments = campaignQuiz.Attachments;

            lstContentDocumentLink = new List<ContentDocumentLink>();
        }

        private void translate(Map<String, Map<String, Field_Value_Translation__c>> fieldTranslationByCampaignQuizId) {
            this.translations = fieldTranslationByCampaignQuizId.get(this.campaignQuizId);
            this.shouldUseFieldTranslation = new Map<String, Boolean>{
                'Name' => false,
                'FGM_Portal__Rich_Instructional_Text__c' => false
            };

            if(this.translations == null) {
                this.translations = new Map<String, Field_Value_Translation__c>();
                return;
            }
            
            Field_Value_Translation__c nameTranslation = this.translations.get('Name');
            Boolean shouldTranslateNameField = nameTranslation != null && String.isNotBlank(nameTranslation.Translation_Value__c);
            this.shouldUseFieldTranslation.put('Name', shouldTranslateNameField);

            Field_Value_Translation__c instructionsTranslation = this.translations.get('FGM_Portal__Rich_Instructional_Text__c');
            Boolean shouldTranslateinstructions = instructionsTranslation != null && String.isNotBlank(instructionsTranslation.Translation_Value__c);
            this.shouldUseFieldTranslation.put('FGM_Portal__Rich_Instructional_Text__c', shouldTranslateinstructions);
        }
    }
}