var uploadProcessQueue = [];
var isUploadProcessQueueEmpty = function()
{   
    if( uploadProcessQueue.length > 0 ){
        return false;
    }
    else{
        return true;
    }
}

$(document).ready(function () {
    /**/
    jQuery.support.cors = true;
    /**/
    LookupHoverDetail.getHover = function () {
        return {
            show: function () {
                return false
            },
            hide: function () {
                return false
            }
        }
    };
    
    if (isCampaignExpired && !isSubmittedAndExpiredCampaign) {
        $("[id$='modalcmpgnExpireInstructionOutPanel']").show();
    }
    $(".bodyDiv").append(loadingDiv);
    $('.mruList .campaignBlock').each(function () {
        $(this).find('a.campaignMru').attr('href', urlForCommunityCampaign+'?id=' + $(this).attr('data-hovid'));
        $(this).removeAttr('data-hovid');
    });

    
    // for encoding
    unescape();
    setcharcount();

    //$('textarea[id*="textAreaDescription"]').css('width', '99.1%');
    $('.textAreaDescription').css('width', '99.1%');
    $('.Quiz_Questions__c').addClass('application_Quiz_Questions__c');
    $('.Quiz_Questions__c td').addClass('Quiz_Questions__c_height');
    $('.mainForm .attachmentList .dataCell ').addClass('dataCell_padding');
    $('.message').addClass('application_msg');
    $('.apexp').addClass('apexp_new');
    $('.quizQuestionList').addClass('borderNone');
    $('.mainForm input[type="text"]').addClass('input_width');
    $('.errorMsg').addClass('errorMsg_FCRecord');
    $(".ui-widget-header").css('border', 'none');


    for (var objinput in jQuery('input[id$=inputFieldId]')) {
        $(objinput).on('keyup', function (e) {
            if (e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40 && e.keyCode != 16 && e.keyCode != 17 && e.keyCode != 18) {
                isRecordChanged = true;
                if (isUploadProcessQueueEmpty())
                    $("[id$='btnClearChange']").removeAttr('disabled');
                $("[id$='btnClearContact']").removeAttr('disabled');
                $("[id$='btnClearAccount']").removeAttr('disabled');
                $("[id$='btnClearDates']").removeAttr('disabled');
            }
        });
        $(objinput).change(function () {
            isRecordChanged = true;
            if (isUploadProcessQueueEmpty())
                $("[id$='btnClearChange']").removeAttr('disabled');
            $("[id$='btnClearContact']").removeAttr('disabled');
            $("[id$='btnClearAccount']").removeAttr('disabled');
            $("[id$='btnClearDates']").removeAttr('disabled');
        });
    }
    for (var objinput in jQuery('input[id$=inputRichTextAreaId]')) {
        $(objinput).on('keyup', function () {
            isRecordChanged = true;
            if (isUploadProcessQueueEmpty())
                $("[id$='btnClearChange']").removeAttr('disabled');
        });
        $(objinput).change(function () {
            isRecordChanged = true;
            if (isUploadProcessQueueEmpty())
                $("[id$='btnClearChange']").removeAttr('disabled');
        });
    }
    for (var objinput in jQuery('input[id$=inputFieldViewNonOTMOCR]')) {
        $(objinput).on('keyup', function (e) {
            if (e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40 && e.keyCode != 16 && e.keyCode != 17 && e.keyCode != 18) {
                isRecordChanged = true;
                if (isUploadProcessQueueEmpty())
                    $("[id$='btnClearChange']").removeAttr('disabled');
            }
        });
        $(objinput).change(function () {
            isRecordChanged = true;
            if (isUploadProcessQueueEmpty())
                $("[id$='btnClearChange']").removeAttr('disabled');
        });
    }
    for (var objinput in jQuery('input[id$=inputFieldIdOTM]')) {
        $(objinput).on('keyup', function (e) {
            if (e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40 && e.keyCode != 16 && e.keyCode != 17 && e.keyCode != 18) {
                isRecordChanged = true;
                if (isUploadProcessQueueEmpty())
                    $("[id$='btnClearChange']").removeAttr('disabled');
            }
        });
        $(objinput).change(function () {
            isRecordChanged = true;
            if (isUploadProcessQueueEmpty())
                $("[id$='btnClearChange']").removeAttr('disabled');
        });
    }
    for (var objinput in jQuery('input[id$=inputFieldIdEdit]')) {
        $(objinput).on('keyup', function (e) {
            if (e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40 && e.keyCode != 16 && e.keyCode != 17 && e.keyCode != 18) {
                isRecordChanged = true;
                if (isUploadProcessQueueEmpty())
                    $("[id$='btnClearChange']").removeAttr('disabled');
            }
        });
        $(objinput).change(function () {
            isRecordChanged = true;
            if (isUploadProcessQueueEmpty())
                $("[id$='btnClearChange']").removeAttr('disabled');
        });
    }
    for (var objinput in jQuery('input[id$=TeamRoleId]')) {
        $(objinput).on('keyup', function (e) {
            if (e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40 && e.keyCode != 16 && e.keyCode != 17 && e.keyCode != 18) {
                isRecordChanged = true;
                if (isUploadProcessQueueEmpty())
                    $("[id$='btnClearChange']").removeAttr('disabled');
            }
        });
        $(objinput).change(function () {
            isRecordChanged = true;
            if (isUploadProcessQueueEmpty())
                $("[id$='btnClearChange']").removeAttr('disabled');
        });
    }


    for (var objinput in $("[id*='-description']")) {

        $(objinput).on('keyup', function (e) {
            if (e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40 && e.keyCode != 16 && e.keyCode != 17 && e.keyCode != 18) {
                var attachmentDescription = $("[id*='-description']");
                var descCount = 0;
                var labelCount = 0;
                if (attachmentDescription != undefined) {
                    attachmentDescription.each(function (element) {
                        if (attachmentDescription[element].value == '')
                            descCount++;
                    });
                }
                if (descCount == attachmentDescription.length)
                    attachmentChanged = false;
                else
                    attachmentChanged = true;
                if (isUploadProcessQueueEmpty())
                    $("[id$='btnClearChange']").removeAttr('disabled');
            }
        });
        $(objinput).change(function () {
            isAttachmentRecordChanged = true;
            if (isUploadProcessQueueEmpty())
                $("[id$='btnClearChange']").removeAttr('disabled');
        });
    }
    for (var objinput in jQuery(':file')) {
        $(objinput).on('keyup', function (e) {
            if (e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40 && e.keyCode != 16 && e.keyCode != 17 && e.keyCode != 18) {
                isAttachmentRecordChanged = true;
                if (isUploadProcessQueueEmpty())
                    $("[id$='btnClearChange']").removeAttr('disabled');
            }
        });
        $(objinput).change(function () {
            isAttachmentRecordChanged = true;
            if (isUploadProcessQueueEmpty())
                $("[id$='btnClearChange']").removeAttr('disabled');
        });
    }
    bIsReviewSubmittedClicked = false;
    $('[id$=inputFieldIdPortal_mlktp]').hide();
    $('[id$=inputFieldId_mlktp]').hide();
    $('[id$=CancelApplicationPopup]').hide();
});
CKEDITOR.on('instanceReady', function (event) {
    event.editor.on('change', function () {
        isRecordChanged = true;
        if (isUploadProcessQueueEmpty())
            $("[id$='btnClearChange']").removeAttr('disabled');
        $("[id$='btnClearContact']").removeAttr('disabled');
        $("[id$='btnClearAccount']").removeAttr('disabled');
    });
});
CKEDITOR.on('instanceCreated', function (e) {
    e.editor.on('contentDom', function () {
        e.editor.document.on('keyup', function (event) {
            if (event.keyCode != 37 && event.keyCode != 38 && event.keyCode != 39 && event.keyCode != 40 && event.keyCode != 16 && event.keyCode != 17 && event.keyCode != 18) {
                isRecordChanged = true;
                if (isUploadProcessQueueEmpty())
                    $("[id$='btnClearChange']").removeAttr('disabled');
                $("[id$='btnClearContact']").removeAttr('disabled');
                $("[id$='btnClearAccount']").removeAttr('disabled');
            }
        });
    });
});
function redirectToDashboard(){
    if (isInvalidAppl) {
        window.location = urlForCommunityDashboard;
    }
}
function confirmRemoveConsultant() {
    var box = bootbox.dialog({
        show: false,
        backdrop: true,
        animate: false,
        title: communityapplicationRemoveconsultantTitle,
        message: removeConsultantConfirmationMsg,
        buttons: {
            cancel: {
                label: 'No',
                className: 'btn-warning'
            },
            save: {
                label: 'Yes',
                className: 'btn-success',
                callback: function() {
                    removeFromConsultant();
                }
            }
        }
    });
    box.modal('show');
    return false;
}

function confirmAssignToConsultant() {
    var box = bootbox.dialog({
        show: false,
        backdrop: true,
        animate: false,
        title: shareApplicationWithconsultantTitle,
        message: shareApplicationWithConsultantConfirmationMsg,
        buttons: {
            cancel: {
                label: 'No',
                className: 'btn-warning'
            },
            save: {
                label: 'Yes',
                className: 'btn-success',
                callback: function() {
                    // handling with ajax
                    shareToConsultant();
                }
            }
        }
    });
    box.modal('show');
    return false;
}

function setFocus() {
    document.getElementById("hiddenElement").focus();
}
function hideCampignExpiredPopup() 
{
    $('[id$=modalcmpgnExpireInstructionOutPanel]').hide();  
    $('[id$=cmpgnExpireInstruction]').show(); 
    return false;
}


function disableLookup() {
    // To disable lookup link
    var lookupLink = $('a[id^=lookup]');
    for (index = 0; index < lookupLink.length; index++) {
        lookupLink.removeAttr("href");
        lookupLink.removeAttr('onmouseover');
        lookupLink.css("text-decoration", "none");
        lookupLink.css("color", "#000000");
    }
}
function disableLinks()
{
    $("[id$=viewRecord]").find("a:not(.actionLink)").removeAttr('href');
    $("[id$=viewRecord]").find("a:not(.actionLink)").removeAttr('onmouseover');
    $("[id$=viewRecord]").find("a:not(.actionLink)").css("text-decoration", "none");
    $("[id$=viewRecord]").find("a:not(.actionLink)").css("color", "#000000");
}

function hidepopup() {
    $(".ui-widget-header").css('border','none');
    $(jQuery('[id$=ModalOutPanel]')[0]).hide();
    $(jQuery('[id$=ModalOutPanelAttachment]')[0]).hide();
    $(jQuery('[id$=ModalOutPanelForSubmittedApplication]')[0]).hide();
    $(jQuery('[id$=modalcmpgnExpireInstructionOutPanel]')[0]).hide()
}

function confirmDelete() {
    return confirm(deleteConfirmation);
}

function showProcessing() {
    $('.spinnerContainer').fadeIn("slow", function() {
        window.scrollTo(0, 0);
        $(".spinnerContainer").addClass("spinnerContainer_display");
    });
}
function iframeLoad(sourceIFrame) {
    if (sourceIFrame != null && sourceIFrame != undefined) {
        var height = document.documentElement.clientHeight;
        height -= pageY(sourceIFrame) + 20;
        height = (height < 0) ? 0 : height;
        sourceIFrame.style.height = height + 'px';
    }
}

function pageY(elem) {
    return elem.offsetParent ? (elem.offsetTop + pageY(elem.offsetParent)) : elem.offsetTop;
}

function modalHide() {
    $(".ui-widget-header").css('border','none');
    isRecordChanged = false;
    $(".duplicateRecordPopup").hide();
    setcharcount();
}



function fnPopupOnRecordChange() {
    if (isRecordChanged && isViewRecordLink) {
        $(jQuery('[id$=ModalOutPanel]')[0]).show();
        return false;
    } else return true;
}

function OnUserSelect(selectedValue) {
    SelectUser(selectedValue.value);
}

function verifyRecordChange() 
{
    $('[id$=CancelApplicationPopup]').hide();
    
    attachmentDesc = null;
    attachmentLabel = null; 
    attachmentChanged = false;
    
    if (jsMode == 'edit' && !isJSViewRecordLink) 
    {
        if(isRecordChanged || !isUploadProcessQueueEmpty())
        {
            $(jQuery('[id$=ModalOutPanel]')[0]).show();
            return false;
        }
        else
        {
            return true;
        }
    }
    else if((!isUploadProcessQueueEmpty() && bIsApplicationSubmitted) || (bIsApplicationSubmitted && isRecordChanged && isDescChange()))
    {
        $(jQuery('[id$=ModalOutPanelForSubmittedApplication]')[0]).show(); 
        return false; 
    }
    
    targetLink=null;
    TabID=null;
    return true;
}
function resetChanges(element) 
{
    element.form.reset();
    try {
        var attachmentLabel = $("[name^='fileUploader']");
        if (attachmentLabel!=undefined)
        {
            attachmentLabel.each(function(element) {
                if(attachmentLabel.nextAll("label")[element].innerText!='')
                {
                    attachmentLabel.nextAll("label")[element].innerText = noFileChoosenLabel;
                }
            }); 
        }  
        for (instance in CKEDITOR.instances) {
            CKEDITOR.instances[instance].setData(function() {
                this.updateElement();
            });
        }                  
    } catch (ex) {}
    isRecordChanged = false;
    isAttachmentRecordChanged = false;
    element.disabled = true;
}


function checkAttachmentChanged()
{
    if( !isIEExplorer )
    {
        var attachmentDescription = [];
        var attachmentLabel = [];
        for(var i=0;i<frames.length-1;i++){
            attachmentDescription.push(frames[i].document.getElementsByClassName("attachment-uplod-control-container")[0].firstElementChild);
            attachmentLabel.push(frames[i].document.getElementsByName('fileUploader'))
        }
        if(attachmentDescription!=undefined)
        {
            for(var i=0;i<attachmentDescription.length;i++)
            {
                if(attachmentDescription[i].value!='')
                {
                    $(jQuery('[id$=ModalOutPanelAttachment]')[0]).show();                        
                    return false;
                }
                else
                {
                    descCount ++;
                }
            }
        }
        if (attachmentLabel!=undefined)
        {
            for(var i=0;i<attachmentLabel.length;i++)
            {
                if(attachmentLabel[i].value!='')
                {
                    $(jQuery('[id$=ModalOutPanelAttachment]')[0]).show();                        
                    return false;
                }
                else
                {
                    labelCount ++;  
                }
            }
        } 
        if(descCount == attachmentDescription.length && labelCount == attachmentLabel.length)
        {
            return true;
        }
    }
    else
    {
        var attachmentDescription = $("[id*='-description']");
        var attachmentLabel = $("[name^='fileUploader']");
        var descCount = 0;
        var labelCount = 0;
        if(attachmentDescription!=undefined)
        {
            attachmentDescription.each(function(element) {
                if(attachmentDescription[element].value!='')
                {
                    $(jQuery('[id$=ModalOutPanelAttachment]')[0]).show();                        
                    return false;
                }
                else{
                    descCount ++;
                }
            });
        }
        if (attachmentLabel!=undefined)
        {
            attachmentLabel.each(function(element) {
                if(attachmentLabel [element].value!='')
                {
                    $(jQuery('[id$=ModalOutPanelAttachment]')[0]).show(); 
                    return false;
                }
                else
                    labelCount ++;  
            }); 
        } 
        if(descCount == attachmentDescription.length && labelCount == attachmentLabel.length)
        {
            return true;
        }
    }
}  
 
function switchTab()
{
    isAttachmentRecordChanged=false;
    $(".ui-widget-header").css('border','none');
    if(AttachQuestionCount>0 && AttachQuestionCount!=null)
        for(i=1;i<=AttachQuestionCount; i++)
        {
            $("[data-id$=textAreaDescription" + i + "]").val("");
            $("[id$=file" + i + "]").val("");
            if($(".lblFileInput")[i - 1] != undefined)
                $(".lblFileInput")[i - 1].innerText = noFileChosenLabel;
        }
    if(targetLink!=null)
    {
        enforceNavigate = true;
        targetLink.click();
        targetLink=null;
        return false;
    }
    if(TabID!=null)
    {
        navigateToTab(TabID);
        TabID=null;
        return false;
    }
    if(bIsReviewSubmittedClicked && (TabID == null && targetLink == null))
    {
        ReviewSubmit();
    }
    if(!isUploadProcessQueueEmpty())
        return true;
} 
function checkFieldSetRequired(strReqiredFields,tab)
{
    var mapRequiredFields = JSON.parse(strReqiredFields);
    var fieldLabels = [];
    for(var key in mapRequiredFields)
    {
        fieldLabels.push(mapRequiredFields[key]);
    }
    
    var errorMessageElement;
    if(tab==='Organization Tab')
        errorMessageElement =$("[id$='organizationError']")[0];
    if(tab==='Contact Tab')
        errorMessageElement =$("[id$='contactError']")[0];
    
    if(errorMessageElement!=null && errorMessageElement != undefined)
    {
        
        var listItems = errorMessageElement.getElementsByTagName('li');
        
        for (var i=0; i<listItems.length; i++)
        { 
            for(var j=0; j< fieldLabels.length ; j++)
            {
                
                if( i!==(listItems.length-1) && listItems[i].innerText.substring(0,listItems[i].innerText.indexOf(':')).search(fieldLabels[j]) !== -1 && listItems[i+1].innerText.substring(0,listItems[i+1].innerText.indexOf(':')).search(fieldLabels[j]+' Code') !== -1)
                {
                    var curItem = listItems[i+1].innerText.substring(0,listItems[i+1].innerText.indexOf(':'));
                    var remove = 1;
                    for(var k=0; k< fieldLabels.length ; k++)
                    {
                        if(curItem===fieldLabels[k])
                            remove=0;    
                    }
                    if(remove===1)
                    {
                        listItems[i+1].hidden = true;
                        i=i+1;
                        break;
                    }
                    
                }
                if(listItems[i].innerText.substring(0,listItems[i].innerText.indexOf(':')).search(fieldLabels[j]+' Code') !== -1)
                {
                    var curItem = listItems[i].innerText.substring(0,listItems[i].innerText.indexOf(':'));
                    var change = 1;
                    for(var k=0; k< fieldLabels.length ; k++)
                    {
                        if(curItem===fieldLabels[k])
                            change=0;    
                    }
                    
                    if(change===1)
                    {
                        listItems[i].innerText = fieldLabels[j]+': You must enter a value';
                        break;
                    }
                    
                }
                
            }
        }
        
    }
}

function disableMe(element) {
    isRecordChanged = false;
    if (element.value == saveButtonLbl ) {
        setTimeout(function() {
            element.setAttribute("disabled", "");
        }, 1);
        element.nextElementSibling.setAttribute("disabled", "");
    }
    if (element.value == saveNextButtonLbl ) {
        setTimeout(function() {
            element.setAttribute("disabled", "");
        }, 1);
        element.previousElementSibling.setAttribute("disabled", "");
    }
}

function initializeTable() {
    $(".ui-widget-header").css('border','none');
    var relatedListTables = $('.relatedListTable');
    if (relatedListTables == null || relatedListTables == undefined) {
        return;
    }

    relatedListTables = $('.relatedListTable');
    for (i = 0; i < relatedListTables.length; i++) {
        if (!$.fn.dataTable.isDataTable(relatedListTables[i])) {
            $.fn.dataTable.moment(languageSpecifications.date_format);
            $.fn.dataTable.moment(languageSpecifications.date_time_format);
            $.fn.dataTable.moment(languageSpecifications.time_format);
            var oTable = $(relatedListTables[i]).dataTable({
                "paging": true,
                "scrollX": true,
                "sScrollXInner": "100%",
                "autoWidth": false,
                "bAutoWidth": false,
                //stateSave: true,
                bJQueryUI: true,
                "aaSorting" : [],
                aoColumnDefs: [{
                    bSortable: false,
                    aTargets: [-1]
                }],
                "oLanguage": {
                    "sInfoEmpty": emptyPaginationFooter,
                    "sEmptyTable": emptyDatatableErrorMsg,
                    "sInfo": datatablePaginationFooter,
                    "sSearch": datatableSearch,
                    "sInfoFiltered": datatableFilterFromRecords,
                    "sZeroRecords": datatableZeroRecords
                }
            });
            
            var widthSize = screen.width * 0.94625;
            $('.tabBottomLine').css("width", widthSize + "px");
            oTable._fnDraw();
        }
    }
    
}

function displayUserId(target) {
    populateOTMValues(target.selectedOptions[0].value);
}

function removeNonePicklistOption()
{
    var teamrole = $(".teammemberrole")[0].options[0].innerHTML;
    if(teamrole.startsWith("--"))
        $(".teammemberrole")[0].options[0].remove();
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
function calculateSubTotalnTotal() {
    $($(jQuery('table[id$=tblGBU]')).find('tr:last')).addClass("customFooter");
    var lstTR = jQuery('table[id$=tblGBU]').find('tbody').find('tr');
    for (var trCount = 0; trCount < lstTR.length - 1; trCount++) {
        var rowtotal = 0;
        var lstINPUT = $(lstTR[trCount]).find('input');
        for (var inputCount = 0; inputCount < lstINPUT.length; inputCount++) {
            if ($(lstINPUT[inputCount]).val().length > 0) {
                rowtotal += parseFloat($(lstINPUT[inputCount]).val());
            }
        }
        $($(lstTR[trCount]).find('span')[$(lstTR[trCount]).find('span').length - 1]).text(getCurrency(rowtotal));
    }
    var columnTotal = 0;
    var grandtotal = 0;
    var totalNoOfColumns = $(jQuery('table[id$=tblGBU]')).find('tr')[0].cells.length;
    for (var columnCount = 1; columnCount < totalNoOfColumns; columnCount++) {
        columnTotal = 0;
        if (columnCount >= 2 && columnCount <= totalNoOfColumns - 2) {
            $(lstTR).children("td:nth-child(" + columnCount + ")").each(function() {
                if ($.isNumeric($(this).find('input').val())) {
                    columnTotal += parseFloat($(this).find('input').val());
                }
            });
            $($(jQuery('table[id$=tblGBU]')).find('tr:last')).children("td:nth-child(" + columnCount + ")").text(getCurrency(columnTotal));
            grandtotal += columnTotal;
        }
    }
    $('.lbl_SubTotal').text(getCurrency(grandtotal));
}
function calculateGrandTotal() {
    var totalNoOfRows = $(jQuery('table[id$=budget]')).find('tr').length;
    var lstElement = $($(jQuery('table[id$=budget]')).find('tr')[totalNoOfRows - 1]).find('span');
    var grandtotal = 0;
    for (var eleCounter = 0; eleCounter < lstElement.length; eleCounter++) {
        if ($(lstElement[eleCounter]).text().length > 0 && ($(lstElement[eleCounter]).attr('class') != 'lbl_SubTotal'))
            grandtotal += parseFloat(getNumber($(lstElement[eleCounter]).text()));
    }
    $('.lbl_SubTotal').text(getCurrency(grandtotal));
}

function validateInputForNumbers(evt) {
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}

function ValidateEndDategreater() {
    if (($.trim($('.dateField:first').val()).length != 0) && ($.trim($('.dateField:last').val()).length != 0)) {
        var fromDate = Date.parse($('.dateField:first').val());
        var toDate = Date.parse($('.dateField:last').val());
        
        if (fromDate > toDate) {
            alert(grBudgetStartDtErrMsg);
            return false;
        } else {
            return true;
        }
    }
    else
        return true
    
}
function calculateSubTotalnTotalMain() {
    $($(jQuery('table[id$=budget]')).find('tr:last')).addClass("customFooter");
    $($(jQuery('table[id$=budget]'))).find('input').removeClass('input_width');
    var lstTR = jQuery('table[id$=budget]').find('tbody').find('tr');
    
    for (var trCount = 0; trCount < lstTR.length - 1; trCount++) {
        var rowtotal = 0;
        var lstINPUT = $(lstTR[trCount]).find('input');
        for (var inputCount = 0; inputCount < lstINPUT.length; inputCount++) {
            if ($(lstINPUT[inputCount]).val().length > 0)
                rowtotal += parseFloat($(lstINPUT[inputCount]).val());
        }
        $(lstTR[trCount]).find('span').text(getCurrency(rowtotal));
    }
    var columnTotal = 0;
    var totalNoOfColumns = $(jQuery('table[id$=budget]')).find('tr')[0].cells.length;
    for (var columnCount = 1; columnCount < totalNoOfColumns; columnCount++) {
        columnTotal = 0;
        if (columnCount >= 2 && columnCount <= totalNoOfColumns - 2) {
            $(lstTR).children("td:nth-child(" + columnCount + ")").each(function() {
                if ($.isNumeric($(this).find('input').val()))
                    columnTotal += parseFloat($(this).find('input').val());
            });
            $(lstTR).children("td:nth-child(" + columnCount + ")").each(function() {
                $($(this).find('span')[0]).text(getCurrency(columnTotal));
            });
        }
    }
    calculateGrandTotal();
}

function calculateSubTotal(strthis) {
    var strinput = '.' + $(strthis).attr('class');
    var lblinput = strinput.replace('txt', 'lbl');
    if (!$.isNumeric($(strthis).val())) {
        $(strthis).val(('0.00'));
    } else {
        $(strthis).val(parseFloat($(strthis).val()).toFixed(2));
    }
    var subtotal = 0;
    for (var txtElement = 0; txtElement < $(strinput).length; txtElement++) {
        subtotal += parseFloat($($(strinput)[txtElement]).val())
    };
    $($(lblinput)[0]).text(getCurrency(subtotal));
    var total = 0;
    for (var txtElement = 0; txtElement < $((strthis.parentElement.parentElement)).find('input').length; txtElement++) {
        total += parseFloat($($((strthis.parentElement.parentElement)).find('input')[txtElement]).val())
    };
    $((strthis.parentElement.parentElement)).find('span').text(getCurrency(total));
    calculateGrandTotal();
}

function getCurrency(amount) {
    return '$' + parseFloat(amount).toFixed(2);
}

function getNumber(amount) {
    return amount.replace('$', '');
}
function dataPickerConfiguration(){
    $('.dateField:first').datepicker({
        changeMonth: true,
        changeYear: true,
        dateFormat: 'mm-dd-yy',
        todayHighlight: true,
        autoclose: true,
        startDate: startDate,
        endDate: endDate
    }).on("change", function(e) {
        if ($(this).val() == '' && startDate != '') {
            alert(budgetStartDateInvalid);
        }
    });
    $('.dateField:last').datepicker({
        changeMonth: true,
        changeYear: true,
        dateFormat: 'mm-dd-yy',
        todayHighlight: true,
        autoclose: true,
        startDate: startDate,
        endDate: endDate
    }).on("change", function(e) {
        if ($(this).val() == '' && endDate != '') {
            alert(budgetEndDateInvalid);
        }
    });

}
function granteeBudgetCalculateTotal(){
    if ($(jQuery('table[id$=tblGBU]')).length > 0)
                                    calculateSubTotalnTotal();
                                if ($(jQuery('table[id$=budget]')).length > 0)
                                    calculateSubTotalnTotalMain();
                                if ($("[class~=txt_]").val() == 0)
                                    $(".txt_2015").val('0.00');
}
function hideErrorMsgBlock(){
    if($("[id$='errorMsgBlock']")!= undefined && $("[id$='errorMsgBlock']") !=null)
                                $("[id$='errorMsgBlock']").hide(); 
}
function setIsRecordChanged( bValue){
    isRecordChanged = bValue;
}
var recompileDirectives = function(tabType,convertedLeadId)
{
    var jsQueAttachmentLookup = (currentParentObject == "Opportunity" ? "FGM_Portal__Opportunity__c" : "FGM_Portal__Inquiry__c");
    jsMode = 'edit';
    if(tabType == 'Inquiry Attachments'){
        jsQueAttachmentLookup ='FGM_Portal__Inquiry__c';
        if(convertedLeadId !=null && convertedLeadId != undefined && convertedLeadId !=''){
            appId =convertedLeadId;
            jsMode = 'view';
        }
    }
    $(".ui-widget-header").css('border','none');
    if(appId)
    {
        Visualforce.remoting.Manager.invokeAction( engineMethodPath + '.getApplicationRecord', jsQueAttachmentLookup,appId, function( result, error ){
            jsScope.appQuestionWrapper = result;
        },
                                                  { 
                                                      escape : false 
                                                  });
        Visualforce.remoting.Manager.invokeAction( engineMethodPath + '.getAttachments', null, jsQueAttachmentLookup, appId , function( result, error ){
            jsScope.attachments = result;
            var elements = document.getElementsByClassName("uploadManagerComponent");
            for( var index = 0; index < elements.length; index ++ )
            {
                jsCompile(elements[index])(jsScope);
            }
        } );
    }
    else
    {
        jsScope.attachments = [];
        var elements = document.getElementsByClassName("uploadManagerComponent");
        for( var index = 0; index < elements.length; index ++ )
        {
            jsCompile(elements[index])(jsScope);
        }
    }
    setIsRecordChanged(false);
}
function disableAttachButton(){
    var elements = document.querySelectorAll('.attachment-uplod-control-container:not(.ng-hide)');
    for(var i=0; i<elements.length; i++){
        var scope = angular.element(elements[i]).scope();
        scope.isUploadDisabled = true;
        //scope.formData = {};
        scope.fileInputPath = scope.fileInputTranslationSetup.chosenFileLabel;
        //scope.xmlHttpRequest = {};
        scope.$apply();
    }
}    
