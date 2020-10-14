    function addClasses(){ 
        $('.apexp').not(".skip-block .apexp").addClass('apexp_dashboard');
        $('.detailList').addClass('detailList_paddingbottom');
        $('.data2Col .dataTables_wrapper').addClass('dataTables_wrapper_new');
        $('NewClass').addClass('NewClass');
        $('.uploadedAttachment .pbBody').addClass('ApplicationReview_uploadedAttachment');
        $('.apexp .detailList .list .headerRow th').addClass('headerRowBorder');
        $('.mainForm .attachmentList .headerRow').addClass('campaignBlock_table_border');
        $('.headerRow div').addClass('headerRowpadding');
        $('.list table tbody tr td').addClass('campaignBlock_table_border');
        $($(jQuery('table[id$=budget]')).find('tr:last')).css("display", "none");
    }
    function disableLookup() {
        // To disable lookup link
        var lookupLink = $('a[id^=lookup]');
        lookupLink.removeAttr("href");
        lookupLink.removeAttr('onmouseover');
        lookupLink.css("text-decoration", "none");
        lookupLink.css("color", "#000000");
    }  
     function calculateSubTotalnTotal() {
                        $($(jQuery( 'table[id$=tblGBU]' )).find('tr:last')).addClass("customFooter");
                        var lstTR=jQuery( 'table[id$=tblGBU]' ).find('tbody').find('tr');
                        for(var trCount=0;trCount<lstTR.length-1;trCount++) {
                            var rowtotal=0;
                            var lstINPUT=$(lstTR[trCount]).find('input');
                            for (var inputCount=0;inputCount<lstINPUT.length;inputCount++) {
                                if($(lstINPUT[inputCount]).val().length>0)
                                    rowtotal+=parseFloat($(lstINPUT[inputCount]).val());
                            }
                            $($(lstTR[trCount]).find('span')[$(lstTR[trCount]).find('span').length-1]).text(getCurrency(rowtotal));
                        }
                        var columnTotal=0;
                        var grandtotal=0;
                        var totalNoOfColumns=$(jQuery( 'table[id$=tblGBU]' )).find('tr')[0].cells.length;
                        for(var columnCount=1;columnCount<totalNoOfColumns;columnCount++) {
                            columnTotal=0;
                            if(columnCount>=3&&columnCount<=totalNoOfColumns-2) {
                                $(lstTR).children("td:nth-child("+columnCount+")").each(function() {
                                    if( $.isNumeric( $(this).find('input').val() ) )
                                        columnTotal+=parseFloat($(this).find('input').val());
                                });
                                $($(jQuery( 'table[id$=tblGBU]' )).find('tr:last')).children("td:nth-child("+columnCount+")").text(getCurrency(columnTotal));
                                grandtotal+=columnTotal;
                            }
                        }
                        $('.lbl_SubTotal').text(getCurrency(grandtotal));
                    } 
    function getCurrency(amount) {
                        return '$' + parseFloat(amount).toFixed(2);
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