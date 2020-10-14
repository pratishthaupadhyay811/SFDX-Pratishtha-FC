function initializeQuizDesigner(){
    $('.mainNavbar').addClass('QuixDesignForm_float');
        $('.apexp .totalRow').addClass('QuizDesignForm_TotalRow');
        $('#myModal').addClass('myModel_margin');
        $('.detailList').addClass('QuizDesignForm_detailList');
        $('.mainForm input[type="text"]').addClass('QuizDesign_input');
        $('.FGM_Portal__Quiz_Questions__c td"]').addClass('dataCell_padding');
}

function settFoot() {
        $('.mainNavbar').addClass('QuixDesignForm_float');
        $('.apexp .totalRow').addClass('QuizDesignForm_TotalRow');
        $('#myModal').addClass('myModel_margin');
        $('.detailList').addClass('QuizDesignForm_detailList');
        $('.mainForm input[type="text"]').addClass('QuizDesign_input');
        $('.FGM_Portal__Quiz_Questions__c td"]').addClass('dataCell_padding');
        }

function initializeForm(){
            try{
                $('.objectOptions').select2({
                    placeholder: "Select Object"
                });
            }
            catch(ex){                  
            }
            try{
                $('.ddlRecordType').select2({            
                    minimumResultsForSearch: -1
                });
            } catch(ex){
            }                
        }

 function initilizeJavascript(){
                $('.FGM_Portal__Quiz_Questions__c .FGM_Portal__Question__add').select2({
                    placeholder: "Add a question..",
                    allowClear: true
                });
                $('.fieldOptions').select2({
                    placeholder: "Select Field To Map with Answer.."
                });
                $('.portal_type').select2({
                    minimumResultsForSearch: -1
                });  
                settFoot();
            }        

            