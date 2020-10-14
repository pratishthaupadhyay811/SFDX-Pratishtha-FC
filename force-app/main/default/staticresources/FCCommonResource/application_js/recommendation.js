
$(document).ready(function() 
{
setcharcount();
unescape();            
// To remove link
var lookupLink = $('a[id^=lookup]');
if(bIsApplicationSubmitted)
{
    for(index=0; index < lookupLink.length; index++)
    {
        lookupLink.removeAttr( "href" );
    }
}
var loadingDiv = $('<div class="spinnerContainer" ><div class="spinner"><div class="rect1"></div><div class="rect2"></div><div class="rect3"></div><div class="rect4"></div><div class="rect5"></div><br /><span class="spanText">Uploading...</span></div></div>');
$(".bodyDiv").append(loadingDiv);
$('.FGM_Portal__Quiz_Questions__c').addClass('application_FGM_Portal__Quiz_Questions__c');
$('.tabBottomLine').addClass('tabBottomLine_padding');
$('.mainForm .attachmentList .dataCell ').addClass('dataCell_padding');
$('.mainForm input[type="text"]').addClass('input_margin');
$('.FGM_Portal__Quiz_Questions__c td').addClass('FGM_Portal__Quiz_Questions__c_height');
$('.FGM_Portal__Quiz_Questions__c').addClass('application_FGM_Portal__Quiz_Questions__c');
$('.quizQuestionList').addClass('borderNone');
$('.pbBody').addClass('pbBody_margin');
$('.FGM_Portal__Quiz_Questions__c textarea').addClass('pbBody_margin');
$('.FGM_Portal__Quiz_Questions__c select').addClass('pbBody_margin');

//apply datePicker
try
{
    $(".dateOnlyInput input").datepicker();
    $(".dateOnlyInput .dateFormat").hide();
} 
catch(e){}          
});
function showProcessing()
{
$('.spinnerContainer').fadeIn("slow" ,function() {
    window.scrollTo(0, 0);
    $(".spinnerContainer").addClass("spinnerContainer_display");
});
}

function HandleBrowseClick(controlId)
{
$("."+ controlId).click();
};

function Handlechange(e,controlId)
{
$(".lblFileInput."+ controlId).html(e.files[0].name );
//btnDisabled btn upload_btn lbl1
$(".btn.upload_btn."+controlId).removeAttr("style");
};

function setcharcount()
{
window.counterOf = " {!$Label.fgm_portal__fc_character_counter_of} ";
window.counterCharacters = " {!$Label.fgm_portal__fc_character_counter_character} ";
setCharCountForTextArea();
}

function initializeCkeditor()
{            
$("textarea.ckeditor").each(function () {
    var editorId = $(this).attr("id");                
    try 
    {
        var instance = CKEDITOR.instances[editorId];
        if (instance) { instance.destroy(true); }
    }
    catch(e) {console.log('Inside Catch' + e);}
    finally 
    {
        CKEDITOR.replace(editorId);
    }
})
};

function saveTextBeforeReset() 
{
counter = 0;
for(name in CKEDITOR.instances) 
{
    $("input[id$=theHiddenStrInput]").val(CKEDITOR.instances[name].getData());
    if(CKEDITOR.instances[name])
    {
        $($("textarea[id$=inputRichTextAreaId]")[counter]).val(CKEDITOR.instances[name].getData());
        CKEDITOR.instances[name].destroy(true);
    }
    counter++;
}
}

function checkIsRecordChanged(){
for (var objinput in jQuery('input[id$=inputFieldId]')) {
    $(objinput).on('keyup', function(e) {
        if (e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40 && e.keyCode != 16 && e.keyCode != 17 && e.keyCode != 18)
            isRecordChanged = true;
    });
    $(objinput).change(function() {
        isRecordChanged = true;
    });
}
}

function verifyRecordChange() 
{
    $('[id$=CancelApplicationPopup]').hide();
    if (!isFeedbackSubmitted) 
    {
        if(isRecordChanged)
        {
            $(jQuery('[id$=ModalOutPanel]')[0]).show();
            return false;
        }
        else
        {
            return true;
        }
    }
    return true;
}

function hidepopup() {
$(jQuery('[id$=ModalOutPanel]')[0]).hide();
}
