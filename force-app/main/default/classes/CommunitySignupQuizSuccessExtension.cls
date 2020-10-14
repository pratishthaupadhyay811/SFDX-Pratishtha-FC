public with sharing class CommunitySignupQuizSuccessExtension {
    public ApexPages.StandardController controller { set; get; }
    public FGM_Portal__Quiz__c quiz { set; get; }
    public String portalLanguage {get; set;}
    public SFDCEncoder ESAPI = new SFDCEncoder();

    public CommunitySignupQuizSuccessExtension (ApexPages.StandardController controller) {
        this.controller = controller;
        portalLanguage = System.currentPageReference().getParameters().get('ln');
        portalLanguage = ESAPI.SFDC_HTMLENCODE(portalLanguage);
        if(String.isBlank(portalLanguage)){
           portalLanguage = 'en_US';
        }
    }

    public String getImageLogoUrl() {

        List<Document> documentList = [
            SELECT Name
            FROM Document
            WHERE Name = :Label.FC_Logo_Name
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

        if (documentList != null && documentList.size() > 0) {
            return Site.getPathPrefix() + '/servlet/servlet.FileDownload?file=' + documentList[0].Id;
        }

        return null;
    }

    public PageReference continueSignUp() {

        List<Quiz__c> quizList = [
            SELECT Success_URL__c
            FROM Quiz__c
            WHERE Id = :controller.getId()
            AND RecordTypeId = :FCGlobal.getRecordTypeId('FGM_Portal__Quiz__c', 'Quiz')
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

        if (quizList != null && quizList.size() > 0) {
            quiz = quizList[0];
            if (quiz.Success_URL__c == null) {
                quiz.Success_URL__c = System.Page.CommunitySignUp.getUrl();
            }
            if (quiz.Success_URL__c.startsWith('~')) {
                quiz.Success_URL__c = quiz.Success_URL__c.substring(1);
            }
            PageReference pr = new PageReference(quiz.Success_URL__c);
            pr.getParameters().put('ln', portalLanguage);
            pr.setRedirect(true);
            return pr;
        }
        return null;
    }
}