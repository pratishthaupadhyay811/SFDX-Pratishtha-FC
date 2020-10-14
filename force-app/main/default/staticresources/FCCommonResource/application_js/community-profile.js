        function addClassOnReady(){
            $('.tabBottomLine').addClass('tabBottomLine_padding_new');
            $('.mainForm .dataCol input[type="text"]').addClass('input_width');
            $('.mainForm .multiSelectPicklistTable select').addClass('multiSelectPicklistTable_picklist');
            $('.apexp').not(".skip-block .apexp").addClass('apexp_dashboard');
            $(this).addClass('apexp_dashboard');
            $('[id*=lookup').css("pointer-events", "none");
            $('[id*=lookup').css("text-decoration", "none");
            $('[id*=lookup').css("color", "#4a4a56");
            $('.confirmModal').hide();
            
            for (var objinput in jQuery('input[id$=inputFieldId]'))
            {
                $(objinput).change(function () {
                    isRecordChanged=true;
                });
            } 

        }

        function initInput(){
            for (var objinput in jQuery('input[id$=inputFieldId]'))
            {
                $(objinput).change(function () {
                    isRecordChanged=true;
                });
            } 
        }

        //apply datePicker
        function applyDatePicker()
        {            
            try
            {
                $(".dateOnlyInput input").datepicker({
                    language: portalLanguage,
                    format: (dateTimes.toLowerCase().split(" "))[0],
                });
                if (dateTimes != '' || dateTimes != null)
                {
                    $(".dateOnlyInput .dateFormat").hide();
                }
            } catch (e) { }
        }

        function setcharcount()
        {        
            window.counterOf = characterCounterOf;
            window.counterCharacters = characterCounterCharacter;
            setCharCountForTextArea();
            setApexpStyleClass();
        }   
    
        function removelookupLink()
        {
            var lookupLink = $('a[id^=lookup]');
            for (index = 0; index < lookupLink.length; index++)
            {
                lookupLink.removeAttr("href");
                lookupLink.removeAttr('onmouseover');
                lookupLink.css("pointer-events", "none");
                lookupLink.css("text-decoration", "none");
                lookupLink.css("color", "#4a4a56");
            }
        }
    
        function setApexpStyleClass()
        {
            $('.apexp').not(".skip-block .apexp").addClass('apexp_dashboard');
            $('.tabBottomLine').addClass('tabBottomLine_padding');
            $('.mainForm .dataCol input[type="text"]').addClass('input_width');
            $('.mainForm .multiSelectPicklistTable select').addClass('multiSelectPicklistTable_picklist');
        }
       
        function getUpdatedUsers(id, event)
        {
            var user = new Object();
            user.Id = id;
            user.IsActive = event.target.checked;
            mapUser[id] = user;
        }
    
        function updateUsers(e)
        {
            try
            {
                $('#umUpdateBtn').text(updateLabel);
                Visualforce.remoting.Manager.invokeAction(
                '{!$RemoteAction.CommunityProfileController.updateUsers}', mapUser, function (result, event) {
                    if (event.type === 'exception')
                    {
                        mapUser = {};
                        if (event.message.includes("LICENSE_LIMIT_EXCEEDED"))
                        {
                            errorMsg = fc_License_Limit_Exceeded;
                        }
                        else
                        {
                            errorMsg = event.message;
                        }
                    }
                    else
                    {
                        errorMsg = '';
                    }
                    refreshUMTable();
                }, { escape: false });
            }
            catch (err) { }
            return false;
        }
    
        function updateStatus()
        {
            $('#umUpdateBtn').text(updateButtonLabel);
            if (errorMsg != '')
            {
                $('.umMsgBlock').css("display", "block");
                $('.messageText').html(errorMsg);
            }
            else
            {
                $('.umMsgBlock').css("display", "none");
            }
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
                catch (e) 
                { 
                    console.log('JS Exception :   ' + e); 
                }
                finally
                {
                    CKEDITOR.replace(editorId);
                }
            });
        }
    
        function saveTextBeforeReset()
        {
            counter = 0;
            isRecordChanged=false;
            for (name in CKEDITOR.instances)
            {
                $($("textarea[id$=inputRichTextAreaId]")[counter]).val(CKEDITOR.instances[name].getData());
                counter++;
                CKEDITOR.instances[name].destroy(true);
            }      
        }
    
        function confirmChanges()
        {   
            if(isRecordChanged)
            { 
                $('.confirmModal').show(); 
                return false;
            } 
            else
            {
                return true;
            }           
        }
    
        function hidePopup()
        {           
            $('.confirmModal').hide();
            $(jQuery('[id$=ModalOutPanel]')[0]).hide();
        }
    
        function resetModalFlag()
        {
            isRecordChanged=false;
        }
    
        // initialaize data table for custom tabs
        function initilizeTable()
        {
            var showAmend = 1;
            var arrDisableSortCol = new Array();
            arrDisableSortCol[0] = -1;
            if (CheckforAmendCol('.relatedListTable'))
            {
                arrDisableSortCol[1] = 0;
            }
			$.fn.dataTable.moment(languageSpecifications.date_format);
            $.fn.dataTable.moment(languageSpecifications.date_time_format);
            $.fn.dataTable.moment(languageSpecifications.time_format);
            var oTable = $('.relatedListTable').dataTable({
                "paging": false,
                //stateSave: true,
                bJQueryUI: true,
				"aaSorting" : [],
                aoColumnDefs: [{
                    bSortable: false,
                    aTargets: [-1]
                }],
                "oLanguage": {
                    "sInfoEmpty": emptyPaginationFooter,
                    "sEmptyTable": emptyDatatableErrorMsg ,
                    "sInfo": datatablePaginationFooter,
                    "sSearch": datatableSearch,
                    "sInfoFiltered": datatableFilterFromRecords,
                    "sZeroRecords": datatableZeroRecords
                }
            });
        }
        function CheckforAmendCol(selector)
        {
            var table = $(selector);
            if (table != null && (table[0] != null && table[0] != undefined))
            {
                var amendmentCol = $(table[0]).find('th.amendmentCol');
                if (amendmentCol != null || amendmentCol != undefined && !jQuery.isEmptyObject(amendmentCol) && amendmentCol.length > 0)
                {
                    return true;
                }
            }
            return false;
        }
        
    //initialaize data table for user management tab
        function initializaUMtable()
        {
			$.fn.dataTable.moment(languageSpecifications.date_format);
            $.fn.dataTable.moment(languageSpecifications.date_time_format);
            $.fn.dataTable.moment(languageSpecifications.time_format);
            $('.userManagement').dataTable({
                //"stateSave": true,
                "bJQueryUI": true,
                "aaSorting" : [],
                "aoColumnDefs": [{
                    "bSortable": false,
                    "aTargets": [-1]
                }],
                "oLanguage": {
                    "sInfoEmpty": emptyPaginationFooter,
                    "sLengthMenu": datatablePaginationHeader,
                    "sEmptyTable": emptyDatatableErrorMsg ,
                    "sInfo":datatablePaginationFooter ,
                    "sSearch": datatableSearch,
                    "sInfoFiltered": datatableFilterFromRecords,
                    "sZeroRecords": datatableZeroRecords,
                }
            });
        }
        
        function checkFieldSetRequired(strReqiredFields)
        {
            var mapFields = JSON.parse(strReqiredFields);
            var fieldLabels = [];
            for(var key in mapFields)
            {
                fieldLabels.push(mapFields[key]);
            }
            var errorMessageElement =$("[id*='errorMessages']")[4];
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