public with sharing class CommunitySignupQuizExtension {
    public Boolean initialized {get; set;} {initialized = false;}
    public ApexPages.StandardController controller { set; get; }
    public FGM_Portal__Quiz__c quiz { set; get; }
    public FGM_Portal__Quiz_Questions__c quizQuestion { set; get; }
    public integer questionNumber { get; set;}
    public FGM_Portal__Quiz_Questions__c[] quizQuestionList { get; set; }
    public FGM_Portal__Question_Responses__c[] questionResponseList { set; get; }
    public List<SelectOption> lstResponseOptions { get; set; }
    public String questionResponseSelectedId { set; get; }
    public String[] questionMultiResponseSelectedId { set; get; }
    public String portalLanguage {get; set;}
    public SFDCEncoder ESAPI = new SFDCEncoder();
    public FGM_Portal__Quiz__c[] quizList;

    public CommunitySignupQuizExtension(ApexPages.StandardController controller) {
        this.controller = controller;
        questionMultiResponseSelectedId  = new String[]{};
        portalLanguage = System.currentPageReference().getParameters().get('ln');
        if(!String.isBlank(portalLanguage)){
             portalLanguage = String.escapeSingleQuotes( portalLanguage);
        }else{
             portalLanguage = 'en_US';
        }
    }

    public String getParam(String name) {
         return ESAPI.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get(name));
    }


    /************************************************************************************************************
Purpose: This function initializes the quiz and quizQuestion
Parameters:
Return : PageReference
*************************************************************************************************************/
    public PageReference initialize() {
        initialized = true;
        initializeQuiz();
        questionNumber = 0;
        initializeQuizQuestion();
            return null;
    }

    /************************************************************************************************************
Purpose: This function returns the image URL for the purpuse of show image on to page
Parameters:
Return : String
*************************************************************************************************************/
     public String getImageLogoUrl(){
       CommunitySigninController objectSigninController = NEW CommunitySigninController();
       return objectSigninController.getImageLogoUrl();
    }

    /************************************************************************************************************
Purpose: This function initializes the Quiz and QuizQuestion
Parameters:
Return : void
*************************************************************************************************************/
    @testVisible private void initializeQuiz() {
       quizList = NEW List<FGM_Portal__Quiz__c>();
        if(quiz == null || quiz.Id == null && !String.isBlank(portalLanguage)) {

            quizList = [
                SELECT
                    Failure_URL__c,
                    Introduction_Text__c,
                    Is_Active__c,
                    Success_URL__c,
                    (
                        SELECT
                            Question__c,
                            Question__r.Error_Text__c,
                            Question__r.Help_Tip__c,
                            Question__r.Is_Active__c,
                            Question__r.RichPostText__c,
                            Question__r.RichPreText__c,
                            Question__r.RichQuestion__c,
                            Question__r.Type__c,
                            Quiz__c,
                            Sort_Order__c
                        FROM Quiz_Questions__r
                        WHERE Question__c != NULL
                        AND Question__r.Language__c = :portalLanguage
                        AND Question__r.Is_Active__c = TRUE
                        ORDER BY Sort_Order__c ASC NULLS LAST
                        LIMIT 10000
                    )
                FROM Quiz__c
                WHERE Id = :controller.getId()
                AND RecordTypeId = :FCGlobal.getRecordTypeId('FGM_Portal__Quiz__c', 'Quiz')
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            if (quizList.isEmpty()) {
                quiz = new FGM_Portal__Quiz__c();
            } else {
                quiz = quizList[0];
                if(quizList[0].FGM_Portal__Quiz_Questions__r != null && !quizList[0].FGM_Portal__Quiz_Questions__r.isEmpty()){
                    quizQuestionList = new List<FGM_Portal__Quiz_Questions__c>();
                    quizQuestionList.addAll(quizList[0].FGM_Portal__Quiz_Questions__r);
                }
            }
        }

    }

 /************************************************************************************************************
Purpose: This function initializes the responce for QuizQuestions
Parameters:
Return : List<SelectOption>
*************************************************************************************************************/
    public List<SelectOption> initializeResponses(){
         lstResponseOptions = new List<SelectOption>();
        if(questionResponseList != null && !questionResponseList.isEmpty()){
            for(FGM_Portal__Question_Responses__c response : questionResponseList){
                if(String.isNotBlank(response.FGM_Portal__Response__c)){
                    lstResponseOptions.add(new Selectoption(response.id,response.FGM_Portal__Response__c));
                }
            }
        }
        return lstResponseOptions;
    }

    /************************************************************************************************************
Purpose: This function initialize the quiz Question
Parameters:
Return : void
*************************************************************************************************************/
    @testVisible private void initializeQuizQuestion() {
        if (quizQuestionList !=  null && quizQuestionList.size() > questionNumber) {
            quizQuestion = quizQuestionList[questionNumber];
            initializeQuestionResponseList();
        }
    }


/************************************************************************************************************
Purpose: This function used to get quizQuestionResponce and initialize the questionResponseList
Parameters: [Map<Id,Account>]
Return : void
*************************************************************************************************************/
   @testVisible private void initializeQuestionResponseList() {
        if(quizQuestion != null && quizQuestion.Id != null) {

            questionResponseList = [
                SELECT
                    Accepted_Response__c,
                    Eligibility_Question__c,
                    Is_Active__c,
                    Post_Text__c,
                    Pre_Text__c,
                    Response__c,
                    Sort_Order__c
                FROM Question_Responses__c
                WHERE Eligibility_Question__c = :quizQuestion.Question__c
                AND Is_Active__c = TRUE
                WITH SECURITY_ENFORCED
                ORDER BY Sort_Order__c ASC
            ];

        }
        initializeResponses();
    }

 /************************************************************************************************************
Purpose: This function used for multi selected responces it redirect user to next question or success url if
valid responce selected else it redirect user to failure url
Parameters:
Return : PageReference
*************************************************************************************************************/
    public PageReference MultiSelect(){
        Boolean MoveNext = false;
        if(questionMultiResponseSelectedId != null && questionMultiResponseSelectedId.size() > 0){

            for(String strResponse : questionMultiResponseSelectedId)
            {
                FGM_Portal__Question_Responses__c questionResponse = new Map<String, FGM_Portal__Question_Responses__c>(questionResponseList).get(strResponse);

                if (questionResponse == null || questionResponse.Id == null) {
                        return null;
                    } else if (questionResponse.FGM_Portal__Accepted_Response__c == true) {
                        MoveNext = true;
                    }else if (questionResponse.FGM_Portal__Accepted_Response__c == false) {
                            if(quiz.FGM_Portal__Failure_URL__c.startsWith('~')) {
                                quiz.FGM_Portal__Failure_URL__c= quiz.FGM_Portal__Failure_URL__c.substring(1);
                            }
                            PageReference pageRefrence = new PageReference(quiz.FGM_Portal__Failure_URL__c);
                            pageRefrence.getParameters().put('id',quizQuestionList[questionNumber].FGM_Portal__Question__c);
                            pageRefrence.getParameters().put('ln', portalLanguage);
                            pageRefrence.setRedirect(true);
                            return pageRefrence;
                    }
                }
            }
        if(MoveNext){
            questionNumber++;
            if(quizQuestionList.size() == questionNumber) {
                PageReference pageRefrence = new PageReference(System.Page.CommunitySignupQuizSuccess.getUrl());
                pageRefrence.getParameters().put('id', quiz.Id);
                pageRefrence.setRedirect(true);
                return pageRefrence;
            }else if(quizQuestionList.size() > questionNumber){
                initializeQuizQuestion();
            }
        }
    return null;
    }

    /************************************************************************************************************
Purpose:This function used for multi selected responces it redirect user to next question or success url if
valid responce selected else it redirect user to failure url.
Parameters:
Return : PageReference
*************************************************************************************************************/
    Public PageReference next() {
        // Get the response
        if(quizQuestion.FGM_Portal__Question__r.FGM_Portal__Type__c == 'MultiSelect'){
            return MultiSelect();
        }
        FGM_Portal__Question_Responses__c questionResponse = new Map<String, FGM_Portal__Question_Responses__c>(questionResponseList).get(questionResponseSelectedId);

        if (questionResponse == null || questionResponse.Id == null) {
            return null;
        } else if (questionResponse.FGM_Portal__Accepted_Response__c == true) {
            questionNumber++;
            if(quizQuestionList.size() == questionNumber) {
                PageReference pageRefrence = new PageReference(System.Page.CommunitySignupQuizSuccess.getUrl());
                pageRefrence.getParameters().put('id', quiz.Id);
                pageRefrence.getParameters().put('ln', portalLanguage);
                pageRefrence.setRedirect(true);
                return pageRefrence;
            }else if(quizQuestionList.size() > questionNumber){
                initializeQuizQuestion();
            }
        }else if (questionResponse.FGM_Portal__Accepted_Response__c == false) {
                if(quiz.FGM_Portal__Failure_URL__c.startsWith('~')) {
                    quiz.FGM_Portal__Failure_URL__c= quiz.FGM_Portal__Failure_URL__c.substring(1);
                }
                PageReference pageRefrence = new PageReference(quiz.FGM_Portal__Failure_URL__c);
                pageRefrence.getParameters().put('id',quizQuestionList[questionNumber].FGM_Portal__Question__c);
                pageRefrence.getParameters().put('ln', portalLanguage);
                pageRefrence.setRedirect(true);
                return pageRefrence;
        }
        return null;
    }
}