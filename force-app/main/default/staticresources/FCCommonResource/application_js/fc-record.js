var uploadProcessQueue = [];
    var isUploadProcessQueueEmpty = function()
    {
        if( uploadProcessQueue.length > 0 )
            return false;
        else
            return true;
    }
    var recompileDirectives = function()
    {
        Visualforce.remoting.Manager.invokeAction( engineMethodPath + '.getApplicationRecord', jsQueAttachmentLookup,appId, function( result, error ){
            jsScope.appQuestionWrapper = result;
        },
        { 
            escape : false 
        });  
        Visualforce.remoting.Manager.invokeAction( engineMethodPath + '.getAttachments', null, jsQueAttachmentLookup, appId , function( result, error ){
            jsScope.attachment = result;
            var elements = document.getElementsByClassName("uploadManagerComponent");
            for( var index = 0; index < elements.length; index ++ )
            {
                jsCompile(elements[index])(jsScope);
            }
        } );
    }    
    function confirmDelete() {
        return confirm(deleteConfirmation);
    }
    function setFocus() 
    {
        document.getElementById("hiddenElement").focus();
    }
    var intcount = 0;
    


    $(window).on('load', function ()  {
        setTimeout(function () {
            billMailingState = $('.BillMailState').find(":selected").text();
            ShipOtherState = $('.ShipOthrState').find(":selected").text();
            billMailingCountry = $('.BillMailCountry').find(":selected").text();
            ShipOtherCountry = $('.ShipOthrCountry').find(":selected").text();                    
        }, 100);               
    });  
    function iframeLoad(sourceIFrame)
    {
        viewModeRecord();   
        if(sourceIFrame != null && sourceIFrame != undefined)
        {
            var height = document.documentElement.clientHeight;
            height -= pageY(sourceIFrame)+ 20 ;
            height = (height < 0) ? 0 : height;
            sourceIFrame.style.height = height + 'px';
        }
    }
    function pageY(elem) 
    {
        return elem.offsetParent ? (elem.offsetTop + pageY(elem.offsetParent)) : elem.offsetTop;
    }
    // fix sidebar links
    $(document).ready(function() {
        /**/
        jQuery.support.cors = true;
        /**/   
        var isFileupload = -1;
        $(".bodyDiv").append(loadingDiv);
        $('.mruList .campaignBlock').each(function() 
                                          {
                                              $(this).find('a.campaignMru').attr('href', urlForCommunityCampaign+'?id=' + $(this).attr('data-hovid'));
                                              $(this).removeAttr('data-hovid');
                                          });
        //remove href and text-decoration for Account name on pagination  .Ace
        $('[id*=lookup]').removeAttr("href");
        $('[id*=lookup]').css("text-decoration", "none");
        $('[id*=lookup]').css("color", "black")
        $('[id*=lookup]').removeAttr("onmouseover");
        $('[id*=lookup]').removeAttr("onmouseout");
        $('[id*=lookup]').removeAttr("onblur");
        $('[id*=lookup]').removeAttr("onfocus");
        $('.footerAlign').css('text-align', 'center');
        
        var aTags = $('[id*=lookup]');if ( aTags.parent().is( "span" ) ) {aTags.contents().unwrap();} //   FIXED  FCPROD - 1350
        
        //for encoding
        unescape();
        setcharcount();
        $('.Quiz_Questions__c').addClass('application_Quiz_Questions__c');
        $('.tabBottomLine').addClass('tabBottomLine_padding');
        $('.mainForm .attachmentList .dataCell ').addClass('dataCell_padding');
        $('.Quiz_Questions__c td').addClass('Quiz_Questions__c_height');
        $('.apexp').addClass('apexp_new');
        $('.quizQuestionList').addClass('borderNone');
        $('.mainForm input[type="text"]').addClass('input_margin');
        $('.errorMsg').addClass('errorMsg_FCRecord');
        $('.pbBody').addClass('pbBody_margin');
        $('.Quiz_Questions__c textarea').addClass('pbBody_margin');
        $('.Quiz_Questions__c select').addClass('pbBody_margin');
        
        var lookupLink = $('a[id^=lookup]');
        if(bIsApplicationSubmitted)
        {
            for(index=0; index < lookupLink.length; index++){
                lookupLink.removeAttr( "href" );
            }
        }
        
        for(var objinput in jQuery('input[id$=inputFieldId]')) 
        {
            $(objinput).on('keyup',function(e)
                           {
                               if(e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40 && e.keyCode != 16 && e.keyCode != 17 && e.keyCode != 18 && e.keyCode != 32)
                               {
                                   isRecordChanged=true;
                               }
                           });
            $(objinput).change(function(e) 
                               {
                                   if(e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40 && e.keyCode != 16 && e.keyCode != 17 && e.keyCode != 18 && e.keyCode != 32)
                                   {
                                       isRecordChanged=true;
                                   }
                               });
        }
        for (var objinput in jQuery('.textAreaDescription')) {
            
            $(objinput).on('keyup', function(e) {
                if (e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40 && e.keyCode != 16 && e.keyCode != 17 && e.keyCode != 18){
                    isAttachmentRecordChanged = true;
                    
                }
            });
            $(objinput).change(function() {
                isAttachmentRecordChanged = true;
                
                
            });
        }
        for (var objinput in jQuery('.lblFileInput')) {
            $(objinput).on('keyup', function(e) {
                if (e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40 && e.keyCode != 16 && e.keyCode != 17 && e.keyCode != 18){
                    isAttachmentRecordChanged = true;
                    
                }
            });
            $(objinput).change(function() {
                isAttachmentRecordChanged = true;
                
            });
        }
        for (var objinput in jQuery(':file')) {
            $(objinput).on('keyup', function(e) {
                if (e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40 && e.keyCode != 16 && e.keyCode != 17 && e.keyCode != 18){
                    isAttachmentRecordChanged = true;
                    isRecordChanged = true;
                }
            });
            $(objinput).change(function() {
                isAttachmentRecordChanged = true;
            });
        }
        initializeCkeditor();
        bIsReviewSubmittedClicked = false;
        $('[id$=ModalOutPanel]').hide();
        $(jQuery('[id$=ModalOutPanelAttachment]')[0]).hide();
        $(jQuery('[id$=ModalOutPanelForSubmittedApplication]')[0]).hide();
        $('[id$=CancelApplicationPopup]').hide();
        
    });
    CKEDITOR.on('instanceReady', function(event) {
        event.editor.on('change', function() {
            isRecordChanged = true;
        });
    });
    CKEDITOR.on('instanceCreated', function(e) {
        e.editor.on('contentDom', function() {
            e.editor.document.on('keyup', function(event) {
                isRecordChanged=true;
            });
        });
    }); 
    
    function disableLookup()
    {
        var lookupLink = $('a[id^=lookup]');
        if(bIsApplicationSubmitted)
        {
            for(index=0; index < lookupLink.length; index++){
                lookupLink.removeAttr( "href" );
            }
        }
    }
    function showProcessing(event,controlId)
    {
        $(".btn.upload_btn."+controlId).prop("disabled", true);
        $('.spinnerContainer').fadeIn("slow" ,function() {
            window.scrollTo(0, 0);
            $(".spinnerContainer").addClass("spinnerContainer_display");
        });
    }
    function reloadCKEditor() 
    {
        for(name in CKEDITOR.instances) 
        {
            delete CKEDITOR.instances[name];
        }
        CKEDITOR.replaceAll();
    }
    function modalHide() 
    {
        isRecordChanged=false;
        isAttachmentRecordChanged= false;
        $('.duplicateRecordPopup').hide();
        $('[id$=inputFieldId]').show();
    }
    function hidepopup() 
    {
        $(jQuery('[id$=ModalOutPanel]')[0]).hide();
        $(jQuery('[id$=ModalOutPanelAttachment]')[0]).hide();
        $(jQuery('[id$=ModalOutPanelForSubmittedApplication]')[0]).hide();
    }
    function getState(obj,stateType)
    {            
        if ($(obj.selectedOptions).text() != '' && stateType == 'BillMailState') 
        {
            billMailingState = $(obj.selectedOptions).text();
        }
        if ($(obj.selectedOptions).text() != '' && stateType == 'ShipOthrState')
        {
            ShipOtherState = $(obj.selectedOptions).text();
        }
        $('input[id$=stateHidden]').val(billMailingState+';'+ShipOtherState); 
    }
    function getCountry(obj,countryType)
    {
        if ($(obj.selectedOptions).text() != '' && countryType == 'BillMailCountry') 
        {
            billMailingCountry = $(obj.selectedOptions).text();                
        }
        if ($(obj.selectedOptions).text() != '' && countryType == 'ShipOthrCountry') 
        {                
            ShipOtherCountry = $(obj.selectedOptions).text();
        }
        $('input[id$=countryHidden]').val(billMailingCountry+';'+ShipOtherCountry);
    }
    
    function confirmChanges()
    {
        attachmentDesc = null;
        attachmentLabel = null; 
        attachmentChanged = false;
        
        if (jsMode == 'edit' && jsTabMode == 'edit') 
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
    function sortTable()
    {
        j$("[id$=recordTableBU]").tablesorter();
    }
    function viewModeRecord()
    {
        jsTabMode = 'view';
    }
    function editModeRecord()
    {
        jsTabMode = 'edit';
    }
    function checkAttachmentChanged()
    {
        if( navigator.appName && navigator.appName.indexOf( 'Internet Explorer' ) >= 0 )
        {
            if( navigator.userAgent.indexOf('Trident') >= 0 && navigator.userAgent.indexOf('rv:11') >= 0 )
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
                    else
                        descCount ++;
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
    
function disableLookupLink() {
    var lookupLink = $('a[id^=lookup]')
    for (index = 0; index < lookupLink.length; index++) {
        lookupLink.removeAttr("href");
    }
    $('[id*=lookup]').removeAttr("href");
    $('[id*=lookup]').css("text-decoration", "none");
    $('[id*=lookup]').css("color", "black")
    $('[id*=lookup]').off("onmouseover");
    $('[id*=lookup]').off("onmouseout");
    $('[id*=lookup]').off("onblur");
    $('[id*=lookup]').off("onfocus");
    var aTags = $('[id*=lookup]');
    if (aTags.parent().is("span")) {
        aTags.contents().unwrap();
    }
}
    function switchTab()
    {
        isAttachmentRecordChanged=false;
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
    }
    function initializeTable(){
        var relatedListTables = $('.relatedListTable');
        if(relatedListTables == null || relatedListTables == undefined)
        {
            return;
        }  
        relatedListTables.DataTable().destroy();
        relatedListTables = $('.relatedListTable');     
        for(i = 0; i < relatedListTables.length; i++)
        {
            if(!$.fn.dataTable.isDataTable( relatedListTables[i] ))
            {
                $.fn.dataTable.moment(languageSpecifications.date_format);
                $.fn.dataTable.moment(languageSpecifications.date_time_format);
                $.fn.dataTable.moment(languageSpecifications.time_format);
                var oTable = $(relatedListTables[i]).dataTable({
                    "paging":   false,
                    "scrollX": true,
                    "sScrollXInner": "100%",
                    "autoWidth": false,
                    "bAutoWidth": false,
                    //stateSave: true,
                    bJQueryUI: true,
                    "aaSorting" : [],
                    aoColumnDefs: [{
                        bSortable: false,
                        aTargets: [ -1 ]
                    }],
                    "oLanguage":{
                        "sInfoEmpty" : emptyPaginationFooter,
                        "sEmptyTable": emptyDatatableErrorMsg,
                        "sInfo" : datatablePaginationFooter,
                        "sSearch": datatableSearch,
                        "sInfoFiltered": datatableFilterFromRecords,
                        "sZeroRecords": datatableZeroRecords
                    }
                });
                
                var widthSize = screen.width *0.94625;                            
                $('.tabBottomLine').css("width",widthSize+"px");
                oTable._fnDraw();
            }
        }
    }
    function reinitializeTable() {
        var relatedListTables = $('.relatedListTable');
        if(relatedListTables == null || relatedListTables == undefined)
        {
            return;
        }  
        relatedListTables.DataTable().destroy();
        relatedListTables = $('.relatedListTable');     
        for(i = 0; i < relatedListTables.length; i++)
        {
            if(!$.fn.dataTable.isDataTable( relatedListTables[i] ))
            {
                $.fn.dataTable.moment(languageSpecifications.date_format);
                $.fn.dataTable.moment(languageSpecifications.date_time_format);
                $.fn.dataTable.moment(languageSpecifications.time_format);
                var oTable = $(relatedListTables[i]).dataTable({
                    "paging":   false,
                    "scrollX": true,
                    "sScrollXInner": "100%",
                    "autoWidth": false,
                    "bAutoWidth": false,
                    renderer: "bootstrap",
                    //stateSave: true,
                    bJQueryUI: true,
                    "aaSorting" : [],
                    aoColumnDefs: [{
                        bSortable: false,
                        aTargets: [ -1 ]
                    }],
                    "oLanguage":{
                        "sInfoEmpty" : emptyPaginationFooter,
                        "sEmptyTable": emptyDatatableErrorMsg,
                        "sInfo" : datatablePaginationFooter,
                        "sSearch": datatableSearch,
                        "sInfoFiltered": datatableFilterFromRecords,
                        "sZeroRecords": datatableZeroRecords
                    }
                });
                
                var widthSize = screen.width *0.94625;                            
                $('.tabBottomLine').css("width",widthSize+"px");
                oTable._fnDraw();
            }
        }
    } 
    