
function initializeQuizDesignForm(){
    $('.apexp').addClass('apexp_border');
    $('.mainNavbar').addClass('QuixDesignForm_float');
    $('.apexp .totalRow').addClass('QuizDesignForm_TotalRow');
    $('#myModal').addClass('myModel_margin');
    $('.detailList').addClass('QuizDesignForm_detailList');
    $('.mainForm input[type="text"]').addClass('Quizdesigner_padding');
    $('.FGM_Portal__Quiz_Questions__c').addClass('Quizdesigner_border_new');
    $($('.clsProcessing').parent().parent()).css('padding', '.5%');
    removeNoneOption();

    //Removing slds-scope from page so only modal is styled. applyBodyTag=false in apex:page doesn't seem to work
    let el = document.getElementsByClassName("slds-scope")[0];
    if (el) {
        el.classList.remove("slds-scope");
    }
}

function removeNoneOption()
{
    setTimeout(function(){
        for(var i = 0; i < ($(".portal_type.portal_type_width.select2-offscreen").find('option:first').length); i++)
        {
            if($(".portal_type.portal_type_width.select2-offscreen").find('option:first')[i].innerHTML == '--None--')
            if($(".portal_type.portal_type_width.select2-offscreen")[i].selectedIndex > 0 && $(".portal_type.portal_type_width.select2-offscreen").find('option:first')[i].innerHTML == '--None--')
                $(".portal_type.portal_type_width.select2-offscreen").find('option:first')[i].remove();
        }
        $(".FGM_Portal__Question__new").hide();
    }, 500);
 }     

function settFoot() {
    $('.apexp').addClass('apexp_border');
    $('.mainNavbar').addClass('QuixDesignForm_float');
    $('.apexp .totalRow').addClass('QuizDesignForm_TotalRow');
    $('#myModal').addClass('myModel_margin');
    $('.detailList').addClass('QuizDesignForm_detailList');
    $('.mainForm input[type="text"]').addClass('Quizdesigner_padding');
    $('.FGM_Portal__Quiz_Questions__c').addClass('Quizdesigner_border_new');
    $($('.clsProcessing').parent().parent()).css('padding', '.5%');
}



function confirmDelete() {
    return confirm("Are you sure you want to delete this tab?");    
 } 
 function showModel() {                            
      $(jQuery('[id$=saveAllModel]')[0]).show();
 }    
 function doNothing(){};
// Load question dataset
  $(document).ready(function(event) { 
      initializeJavascript(); 
  });

function confirmDialog(quizQuesId)
{
    $(jQuery('[id$=confirmDialog]')[0]).show();
    $('.closeConfDialog').click(function(event)
    {
         if($(event.currentTarget).text() == 'Yes')
              delQuizQuestion(quizQuesId);
         $(jQuery('[id$=confirmDialog]')[0]).hide();
     });   
}

function initializeJavascript(updateQuestionList){
 var prevQuesType, currentQuesIdx, mapQuizQues = {}, mapQuizQuesVal={};
 var prevQues, mapQues = {}, mapQuesVal={}, qqId, quizQuesId ;                         
   
 $('.hideSaveModel').click(function(event){
     if($(event.currentTarget).text() == 'No'){
          $($($('.portal_type').find('span'))[currentQuesIdx]).text(prevQuesType);
          $($($('.portal_type'))[currentQuesIdx+1]).find('option:contains('+prevQuesType+')').attr("selected","selected");
          if(prevQuesType == "Instruction" || prevQuesType == "Attachment" || prevQuesType == ''){
              $($($('.portal_type').closest('td')).prev().find('.fieldOptions')[currentQuesIdx]).hide();
          }
          else{
              $($($('.portal_type').closest('td')).prev().find('.fieldOptions')[currentQuesIdx]).show();
          }
          $($('[id$=ques]')[currentQuesIdx]).find('.select2-chosen').text(prevQues);
          $($($('[id$=ques]'))[currentQuesIdx+1]).find('option:contains('+prevQues+')').attr("selected","selected");
     }
      $(jQuery('[id$=saveModel]')[0]).hide();
 });                          
  
 $('.hideSaveAllModel').click(function(event){
      if($(event.currentTarget).text() == 'Cancel' ){
          $($($('.portal_type').find('span'))[currentQuesIdx]).text(prevQuesType); 
          $($($('.portal_type'))[currentQuesIdx+1]).find('option:contains('+prevQuesType+')').attr("selected","selected");
          if(prevQuesType == "Instruction" || prevQuesType == "Attachment" || prevQuesType == ''){
              $($($('.portal_type').closest('td')).prev().find('.fieldOptions')[currentQuesIdx]).hide();
          }
          else{
              $($($('.portal_type').closest('td')).prev().find('.fieldOptions')[currentQuesIdx]).show();
          }
          $($('[id$=ques]')[currentQuesIdx]).find('.select2-chosen').text(prevQues);
          $($($('[id$=ques]'))[currentQuesIdx+1]).find('option:contains('+prevQues+')').attr("selected","selected");
      }
      if($(event.currentTarget).text() == 'No'){
          $(jQuery('[id$=saveModel]')[0]).show();
      }
      if($(event.currentTarget).text() == 'Yes'){
          updateQuestion(qqId);
      }
      $(jQuery('[id$=saveAllModel]')[0]).hide();
  });         
   
   if(!updateQuestionList){
      if($('.message').find('img').attr('title') == 'ERROR'){
           $('.FGM_Portal__Question__new').show();
          if('{!questionInsert.Type__c}' != '' && '{!questionInsert.Type__c}' == 'Salesforce Data Type'){
             $('.FGM_Portal__Question__new').find('tr').last().prev().show();
             $("#newQstn").prop("checked", true);
          }                            
      }
    }else{
          $('.FGM_Portal__Question__new').hide();
    }
  
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
  var quesIdx = 0;
  $('[id$=ques]').change(function(event){
      prevQues = mapQuesVal[$(event.currentTarget.parentElement).children('input').val()];
      currentQuesIdx = mapQues[$(event.currentTarget.parentElement).children('input').val()];   
      qqId = $(event.currentTarget.parentElement).children('input').val();

      if(isClonedApp){                              
          showModel();
      }
  });
  $('[id$=ques]').each(function(event){
      mapQues[$(this).prev('input').val()] = quesIdx;
      mapQuesVal[$(this).prev('input').val()] = $(this).find('.select2-chosen').text();
      quesIdx++;
  });
  $('.portal_type').change(function(event){
      prevQuesType = mapQuizQuesVal[$(event.currentTarget.parentElement).children('input').val()];
      currentQuesIdx = mapQuizQues[$(event.currentTarget.parentElement).children('input').val()];
      qqId = $(event.currentTarget.parentElement).children('input').val();
      try{          
          if(isClonedApp){                              
              showModel();
          }
          if($(this).val()== "Instruction" || $(this).val()== "Attachment" || $(this).val() == ''){
               $($(this).closest('td')).prev().find('.fieldOptions').hide();
          }
          else{
               $($(this).closest('td')).prev().find('.fieldOptions').show();
          }
      } catch(ex){
          console.log('error',ex);
      }
  });        
  var quizQuesIdx = 0;
  $('div.portal_type').each(function(){
      mapQuizQues[$(this).prev('input').val()] = quizQuesIdx;
      mapQuizQuesVal[$(this).prev('input').val()] = $(this).find('.select2-chosen').text();
      quizQuesIdx = quizQuesIdx+2;
      try{
          if($(this).find('.select2-chosen').text() == "Instruction" || $(this).find('.select2-chosen').text() == "Attachment" || $(this).find('.select2-chosen').text() == ''){
              $($(this).closest('td')).prev().find('.fieldOptions').hide();
          }
          else{
              $($(this).closest('td')).prev().find('.fieldOptions').show();
          }
      } catch(ex){
          console.log('error',ex);
      }
  });
  //apply checkbox 
  try{
      var mainForm = $('[id$=mainForm]');
      if(!$.isEmptyObject(mainForm)){
          var checkboxInputs = $(mainForm).find('.input_wrapper input[type="checkbox"]');
          if(!$.isEmptyObject(checkboxInputs)){
              $(checkboxInputs).fcCheckBox();
          }
      }
  } catch(ex){
      console.log('error',ex);
  }
  //apply datePicker
  try{                    
      $(".dateOnlyInput .dateFormat").hide();                 
  } catch(ex){
      console.log('error',ex);
  }
  settFoot();
}
$(function(){
  hideDataTypeField();
});
function hideDataTypeField(){ 
  $('select[id$="ddlDataTypes"]').parent().parent().hide();
  $('select[id$="ddlPortalType"]').val('');
}
function onDataTypeChange(record){
  if(record.value=="Salesforce Data Type"){
      $('select[id$="ddlDataTypes"]').parent().parent().show();
  }else{ 
      $('select[id$="ddlDataTypes"]').parent().parent().hide() 
  }    
}

                              
function saveTabRecord(){
    if( tinymce.editors.length > 0 ) {
        for( i = 0; i < tinymce.editors.length; i++ ) {  
            tinyMCE.editors[i].save();                                  
        }
    }                                        
    saveRelatedListControllerRecord();
}    
function initializeTinymceEditor(){
    if( tinymce.editors.length > 0 ) {                                        
        for( i = 0; i < tinymce.editors.length; i++ ) {  
            tinyMCE.editors[i].setContent($(tinyMCE.editors[0].getElement()).val());
            tinyMCE.editors[i].destroy();
        }
    }                                    
    setTimeout(function(){                                          
        tinymce.init({                                       
            selector: 'textarea.txtinstruction',
            menubar : false,
            plugins: "textcolor,fullscreen",                       
            toolbar: ["undo redo | ,styleselect,formatselect,fontselect,fontsizeselect  | bold italic | alignleft aligncenter alignright alignjustify | fullscreen | forecolor backcolor | bullist numlist"]
        });
    }, 500);      
}
function setFooter(){        
    setTimeout(function(){
        settFoot();
    },3000);        
}

function checkPortalLanguage(languageSelector, quizId) {
    Visualforce.remoting.Manager.invokeAction(
        'FGM_Portal.QuizDesignFormExtension.quizIsTranslatedInLanguage',
        quizId, languageSelector.value,
        function(result){
            if (result === false) {
                createConfirmModal();
                document.getElementById("confirmTranslation").addEventListener("click", function() {
                    setPortalLanguage();
                });
                document.getElementById("cancelTranslation").addEventListener("click", function() {
                    languageSelector.value = languageSelector.oldPortalLanguage;
                    document.getElementById("confirmTranslationModal").remove();
                });
            } else {
                setPortalLanguage();
            }
        }, 
        {escape: true}
    );

    function createConfirmModal() {
        let el = document.createElement('div');
        var newQuizLanguageLabel = (typeof newQuizLanguageLabel === 'undefined') ? "It looks like you don't have a quiz set up for that language yet. Click Continue to create a new quiz for that language." : newQuizLanguageLabel;

        let domString =
            `<div style="height:640px;" id="confirmTranslationModal" class="slds-scope">
                <section role="dialog" tabindex="-1" aria-modal="true" aria-describedby="modal-content-id-1" class="slds-modal slds-fade-in-open">
                    <div class="slds-modal__container">
                        <header class="slds-modal__header slds-modal__header_empty"/>
                        <div class="slds-modal__content slds-p-around_medium" id="modal-content-id-1" style="padding-bottom:30px; padding-top:30px;">
                            <p style="text-align:center;">
                                ${newQuizLanguageLabel}
                            </p>
                        </div>
                        <footer class="slds-modal__footer">
                            <button id="cancelTranslation" class="slds-button slds-button_neutral">Cancel</button>
                            <button id="confirmTranslation" class="slds-button slds-button slds-button_brand">Create a new translation</button>
                        </footer>
                        </div>
                </section>
                <div class="slds-backdrop slds-backdrop_open"></div>
            </div>`
        
        el.innerHTML =  domString;
        document.body.appendChild(el.firstChild);
    }
}