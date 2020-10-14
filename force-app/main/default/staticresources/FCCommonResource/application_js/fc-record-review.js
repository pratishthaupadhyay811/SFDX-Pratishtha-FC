        function removeAttributes(){
            $('.mruList .campaignBlock').each(function () {
                $(this).removeAttr('data-hovid');
            });
            $('.apexp').not(".skip-block .apexp").addClass('apexp_dashboard');
            $('.homeTab .tertiaryPalette').addClass('tertiaryPalette_border');
            $('.uploadedAttachment .pbBody').addClass('ApplicationReview_uploadedAttachment');
            $('[id*=lookup').removeAttr("href");
            $('[id*=lookup').css("text-decoration", "none");
            $('[id*=lookup').css("color", "black")
            $('[id*=lookup').removeAttr("onmouseover");
            $('[id*=lookup').removeAttr("onmouseout");
            $('[id*=lookup').removeAttr("onblur");
            $('[id*=lookup').removeAttr("onfocus");
            $('.footerAlign').css('text-align', 'center');
            LookupHoverDetail.getHover = function(){return {show : function(){return false}, hide : function(){return false}}}; 
            
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
    function relatedListTables(){
                       var oTable = $('.relatedListTable').dataTable({
                      "paging":   false,
                      stateSave: true,
                      bJQueryUI: true,
                      aoColumnDefs: [{
                          bSortable: false,
                          aTargets: [ -1 ]
                      }],
                      "oLanguage":{
                          "sInfoEmpty" : datatableEmptyPaginationFooter,
                          "sEmptyTable": emptyDatatablePaginationFooterError,
                          "sInfo" : datatablePaginationFooter,
                          "sSearch": datatableSearch,
                          "sInfoFiltered": datatableFilterFromRecords,
                          "sZeroRecords": datatableZeroRecords
                  }
                  });
             }