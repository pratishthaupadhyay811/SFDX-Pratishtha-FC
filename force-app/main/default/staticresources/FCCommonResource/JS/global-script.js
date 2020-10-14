// To hide "My Settings"  from user header under user name on portal
$( document ).ready(function() {
    if($('a.menuButtonMenuLink')[0] != undefined  &&  $('a.menuButtonMenuLink')[0].title == 'My Settings' )
        $('a.menuButtonMenuLink').first().remove();
});



// code common to fcrecord and communityapplication page
jQuery(window).on ('load', function () {
    var fileUploaderElements = document.getElementsByName('fileUploader')!=undefined;
    if(fileUploaderElements) 
        for(var i = 0; i < fileUploaderElements.length; i++)
        {
            fileUploaderElements[i].nextSibling.nextElementSibling.setAttribute("type", "button");
        }
    setTimeout(function () {
        document.activeElement.blur();
        window.scrollTo(0,0);
        // initializeCkeditor();
    }, 10); 
});
function initializeCkeditor() {
    // code to create new instances
    $("textarea.ckeditor").each(function(){
        var editorId = $(this).attr("id");
        try 
        {
            CKEDITOR.replace(editorId);
        } 
        catch (e) 
        {
            console.log('Inside Catch' + e);
        }
    });
};
function saveTextBeforeReset() 
{
    $('[id$=CancelApplicationPopup]').hide();
    $(".ui-widget-header").css('border','none');
    //isRecordChanged = false;
    counter = 0;
    for (name in CKEDITOR.instances) 
    {
        if (CKEDITOR.instances[name]) 
        {
            $($("textarea[id$=inputRichTextAreaId]")[counter]).val(CKEDITOR.instances[name].getData());
            var instance = CKEDITOR.instances[name];
            if (instance)
                instance.destroy(false);
        }
        counter++;
    }
}
var disableSaveNext = function(){
    $('.footer-btn').attr("disabled","disabled");
}
var enableSaveNext = function() {
    $('.footer-btn').removeAttr('disabled');
}
function resizeIframe(obj) {
    setTimeout(function(){obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';},1000);        
}
function changePopupFlag() {
    isRecordChanged = false;
}
function HandleBrowseClick(controlId) {
    $("." + controlId).click();
};
function Handlechange(e, controlId) {
    $(".lblFileInput." + controlId).text(e.files[0].name);
    //btnDisabled btn upload_btn lbl1
    $(".upload_btn." + controlId).removeAttr("style");
    
};
function setcharcount() {
    window.counterOf = counterOf;
    window.counterCharacters = counterCharacters;
    setCharCountForTextArea();
}
function isDescChange(){
    var attachmentDescriptionTst = $("[id*='-description']");
    var attachmentLabelTst = $("[name^='fileUploader']");
    var descCountTst = 0;
    var labelCountTst = 0;
    attachmentDescriptionTst.each(function(element) {
        if(attachmentDescriptionTst[element].value =='')
            descCountTst ++;
    });
    if (attachmentLabelTst!=undefined){
        attachmentLabelTst.each(function(element) {
            if(attachmentLabelTst [element].value=='')
                labelCountTst ++;  
        }); 
    } 
    if(descCountTst == attachmentDescriptionTst.length && labelCountTst == attachmentLabelTst.length)
        return false;
    else
        return true;
}
function totalAttachmentQuestions(qCount)
{
    AttachQuestionCount=qCount;
    setcharcount();
}
    function getTabSwitchId(tabId)
{
    TabID=tabId;
}
function clearNavigation()
{
    if(targetLink!=null)
        targetLink=null;
    if(TabID!=null)
        TabID=null;
}
function applyCheckBox(){
    var mainForm = $('[id$=mainForm]');
    if (!$.isEmptyObject(mainForm)) {
        var checkboxInputs = $(mainForm).find('input[type="checkbox"]');
        if (!$.isEmptyObject(checkboxInputs)) {
            $(checkboxInputs).fcCheckBox();
        }
    }
}  
function applyDatePicker(){
    $(".dateOnlyInput input").datepicker({
        language: pageLanguage,
        format: (dateTimeFormat.toLowerCase().split(" "))[0],
    });
    if(dateTimeFormat != '' || dateTimeFormat != null)
    {
        $(".dateOnlyInput .dateFormat").hide();
    }
} 
function applyLookupField(){
    var lookUpLink = $(".lookupInput a");
    if(!$.isEmptyObject(lookUpLink) && lookUpLink.length > 0){
        $( ".lookupInput input" ).click(function(){
            var link = $(this).parent().find('a');
            if(!$.isEmptyObject(link) && link.length > 0){
                $(link[0]).click();
            }
        });
    }
}