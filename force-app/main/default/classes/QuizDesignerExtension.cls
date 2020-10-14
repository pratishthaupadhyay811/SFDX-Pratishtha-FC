public with sharing class QuizDesignerExtension{
    public Boolean initialized {get; set;} {initialized = false;}
    // To Render the application tabs form Related List Controller object.
    public ApexPages.StandardController controller { set; get; }
    public SelectOption[] quizOptions { set; get; }
    public SelectOption[] questionOptions { set; get; }
    public String selectedQuizId { set; get; }
    public FGM_Portal__Quiz__c quiz { set; get; }
    public FGM_Portal__Quiz_Questions__c[] quizQuestionList { set; get; }
    public FGM_Portal__Quiz_Questions__c quizQuestionInsert { set; get; }
    public FGM_Portal__Questions__c questionInsert { set; get; }
    public String existQuiz { get; set; }
    public QuizDesignerExtension(ApexPages.StandardController controller) {
        this.controller = controller;
    }

    public String getParam(String name) {
        return ApexPages.currentPage().getParameters().get(name);
    }

    public PageReference redirectTo(PageReference pageReference) {
        if (pageReference != null) {
            pageReference.setRedirect(true);
        }
        return pageReference;
    }

    public PageReference rollbackWithError(String message, System.Savepoint savepoint) {
        if (savepoint != null) {
            Database.rollback(savepoint);
        }

        if (message != null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, message));
        }
        return null;
    }

    public PageReference initialize() {
        initialized = true;
        initializeQuizOptions();
        initializeQuiz();
        if(quiz == null || quiz.Id == null)
            return null;
        initializeQuizQuestionList();
        initializeQuestionOptions();
        initializeQuizQuestionInsert();
        initializeQuestionInsert();
        return null;
    }


    public void initializeQuizOptions() {
        quizOptions = new SelectOption[] {};

            for (Quiz__c quiz : [
                SELECT Name
                FROM Quiz__c
                WHERE RecordTypeId =: FCGlobal.getRecordTypeId('FGM_Portal__Quiz__c','Quiz')
                WITH SECURITY_ENFORCED
                ORDER BY Name ASC
                LIMIT 1000
            ]) {
                quizOptions.add(new SelectOption(quiz.Id, quiz.Name));
            }

    }

    public void initializeQuiz() {

        List<Quiz__c> quizList = [
            SELECT
                Name,
                Is_Active__c,
                Introduction_Text__c,
                toLabel(RecordType.Name)
            FROM Quiz__c
            WHERE Id = :controller.getId()
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

        if (quizList.isEmpty()) {
            quiz = new FGM_Portal__Quiz__c();
        } else {
            quiz = quizList[0];
        }
    }

    public void initializeQuizQuestionList() {
      if(quiz != null && quiz.Id != null){

            quizQuestionList = [
                SELECT
                    Question__r.RichQuestion__c,
                    Question__r.RichPreText__c,
                    Question__r.RichPostText__c,
                    Question__r.Type__c,
                    Question__r.Quiz__c,
                    Question__c,
                    Quiz__c,
                    Sort_Order__c
                FROM Quiz_Questions__c
                WHERE Quiz__c = :quiz.Id
                WITH SECURITY_ENFORCED
                ORDER BY Sort_Order__c ASC NULLS LAST
                LIMIT 10000
            ];

          if(quizQuestionList == null || quizQuestionList.isEmpty()){
                   quizQuestionList = new List<FGM_Portal__Quiz_Questions__c>();
          }
      }
    }
    public void initializeQuestionOptions() {
        questionOptions = new SelectOption[] {};

            for(Questions__c question : [
                SELECT
                    Name,
                    RichQuestion__c
                FROM Questions__c
                WHERE RecordTypeId = :FCGlobal.getRecordTypeId('FGM_Portal__Questions__c', 'Quiz')
                WITH SECURITY_ENFORCED
                ORDER BY Name ASC
                LIMIT 10000
            ]) {
                questionOptions.add(new SelectOption(question.Id, question.Name + ': ' + question.FGM_Portal__RichQuestion__c));
            }
    }
    public void initializeQuizQuestionInsert() {
        quizQuestionInsert = new FGM_Portal__Quiz_Questions__c();
        quizQuestionInsert.FGM_Portal__Quiz__c = quiz.Id;
    }
    public void initializeQuestionInsert() {
        questionInsert = new FGM_Portal__Questions__c();
        questionInsert.RecordTypeId =  FCGlobal.getRecordTypeId('FGM_Portal__Questions__c','Quiz');
    }
    public PageReference selectQuiz() {
        if (selectedQuizId == null) {
            return rollbackWithError('No quiz/form selected', null);
        }
        PageReference pageReference = System.Page.QuizDesigner;
        pageReference.getParameters().put('id', selectedQuizId);
        pageReference.setRedirect(true);
        return pageReference;
    }

    public PageReference insertQuiz() {
        System.Savepoint savepoint = Database.setSavepoint();

        try {
                quiz.RecordTypeId = FCGlobal.getRecordTypeId('FGM_Portal__Quiz__c','Quiz');
                CrudFlsService.getInstance().assertCreateable(quiz);
                insert quiz;

        } catch (System.Exception problem) {
            return rollbackWithError(problem.getTypeName() + ': ' + problem.getMessage(), savepoint);
        }
        PageReference pageReference = System.Page.QuizDesigner;
        pageReference.getParameters().put('id', quiz.Id);
        pageReference.setRedirect(true);
        return pageReference;
    }

    public PageReference insertQuizQuestion() {
        System.Savepoint savepoint = Database.setSavepoint();
        try {
            quizQuestionInsert.FGM_Portal__Quiz__c = quiz.Id;
            quizQuestionInsert.FGM_Portal__Sort_Order__c = quizQuestionList == null ? 1 : quizQuestionList.size() + 1;
            CrudFlsService.getInstance().assertCreateable(quizQuestionInsert);
            insert quizQuestionInsert;
        } catch (System.Exception problem) {
            return rollbackWithError(problem.getTypeName() + ': ' + problem.getMessage(), savepoint);
        }

        initializeQuizQuestionList();
        initializeQuizQuestionInsert();
        initializeQuestionInsert();
        return null;
    }

    public PageReference insertQuestion() {
        System.Savepoint savepoint = Database.setSavepoint();

        if (questionInsert == null) {
            return null;
        }

        if (questionInsert.FGM_Portal__RichQuestion__c == null) {
            return null;
        }
        try {

            questionInsert.Quiz__c = quiz.Id;
            CrudFlsService.getInstance().assertCreateable(questionInsert);
            insert questionInsert;
            quizQuestionInsert.FGM_Portal__Question__c = questionInsert.Id;
            quizQuestionInsert.FGM_Portal__Quiz__c = quiz.Id;
            quizQuestionInsert.FGM_Portal__Sort_Order__c = quizQuestionList == null ? 1 : quizQuestionList.size() + 1;
            CrudFlsService.getInstance().assertCreateable(quizQuestionInsert);
            insert quizQuestionInsert;
        } catch (System.Exception problem) {
            return rollbackWithError(problem.getTypeName() + ': ' + problem.getMessage(), savepoint);
        }

        initializeQuizQuestionList();
        initializeQuizQuestionInsert();
        initializeQuestionInsert();
        return null;
    }

    public PageReference updateQuizQuestionList() {
        System.Savepoint savepoint = Database.setSavepoint();
        if (quizQuestionList == null || quizQuestionList.isEmpty()) {
            return null;
        }
        try{
            CrudFlsService.getInstance().assertUpdateable(quizQuestionList);
            update quizQuestionList;
        }
        catch (System.Exception problem){
            return rollbackWithError(problem.getTypeName() + ': ' + problem.getMessage(), savepoint);
        }
        // Find any questions that are exclusive to this quiz, and update those as well.
        Map<Id, FGM_Portal__Questions__c> questionUpdateMap = new Map<Id, FGM_Portal__Questions__c>();
            for(FGM_Portal__Quiz_Questions__c quizQuestion : quizQuestionList) {
                FGM_Portal__Questions__c question = quizQuestion.FGM_Portal__Question__r;

                if (question == null) {
                    continue;
                }

                if (question.Quiz__c == null) {

                }
                question.RecordTypeId = FCGlobal.getRecordTypeId('FGM_Portal__Questions__c','Quiz');
                questionUpdateMap.put(question.Id, question);
            }
            if (questionUpdateMap.isEmpty() == false) {
                CrudFlsService.getInstance().assertUpdateable(questionUpdateMap.values());
                update questionUpdateMap.values();
            }

        initializeQuizQuestionList();
        initializeQuizQuestionInsert();
        initializeQuestionInsert();
        return null;
    }

    @RemoteAction
    public static FGM_Portal__Question_Responses__c[] getQuestionResponseList(String[] questionIds) {
        Set<String> questionIdsSet = new Set<String>(questionIds);

        return [
            SELECT
                Accepted_Response__c,
                Is_Active__c,
                Post_Text__c,
                Pre_Text__c,
                Eligibility_Question__c,
                Response__c,
                Sort_Order__c
            FROM Question_Responses__c
            WHERE Eligibility_Question__c IN :questionIdsSet
            WITH SECURITY_ENFORCED
            ORDER BY Eligibility_Question__c ASC, Sort_Order__c ASC
            LIMIT 10000
        ];

    }
}