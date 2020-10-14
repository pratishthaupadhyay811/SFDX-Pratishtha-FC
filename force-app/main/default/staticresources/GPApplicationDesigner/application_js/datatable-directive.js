var datatableApp = angular.module('datatableApp',['messageApp']);
datatableApp.config(function($sceDelegateProvider){
    var baseUrl = window.location.protocol + '//' + window.location.host + '/**';
    $sceDelegateProvider.resourceUrlWhitelist([
        'https://localhost/**',
        baseUrl
    ]);
});
datatableApp.directive('dtTable', function($compile , $filter,$fieldFormat) {
        
        return {
            
            scope:{
                data :'=dtTable',
                configuration:'=',
                selectedDataItem: '=selectedDataItem',
                deleteRecord:'&',
                datatableTranslations : '='
            },
            link: function($scope , element) {
                if($scope.selectedDataItem!=undefined)
                    $scope.selectedDataItem.record = [] ;
                $scope.isDeletable = false;
                $scope.dataToRemove = []; 
                var tabrecord = [];
               
                var lstColumn =[];
                var actions = [];
                var isdelete = false;
                var sortColNo;
                var sortOrder;
                var columnsList = [];
                var gReportColumns = [];
                var deleteRecordId ; 
                
                
                if($scope.configuration.aplicationDesignerConfiguration!=undefined)
                {
                    isBoth = $scope.configuration.aplicationDesignerConfiguration.actionsPosition == 'Both side' ? true : false;
                    isLeft = $scope.configuration.aplicationDesignerConfiguration.actionsPosition == 'Left-most' ? true : false;
                    isRight= $scope.configuration.aplicationDesignerConfiguration.actionsPosition == 'Right-most' ? true : false;
                }
                if(currentObject=='Opportunity')
                {
                    if(actions.indexOf('REPORTS')<0)
                        actions.push('REPORTS');
                }
                if($scope.configuration.aplicationDesignerConfiguration.Actions.isEdit)
                {
                    if(actions.indexOf('EDIT')<0 && (/EDIT/i).test($scope.configuration.mode))
                        actions.push('EDIT');
                }
                if($scope.configuration.aplicationDesignerConfiguration.Actions.isView)
                {
                    if(actions.indexOf('VIEW')<0)
                        actions.push('VIEW');
                }
                if($scope.configuration.aplicationDesignerConfiguration.Actions.isDelete)
                {
                    if(actions.indexOf('DELETE')<0  && (/EDIT/i).test($scope.configuration.mode))
                        actions.push('DELETE');
                }
                if($scope.configuration.aplicationDesignerConfiguration.Actions.isAmendable)
                {
                    if(actions.indexOf('AMMEND') < 0 )
                        actions.push('AMMEND');
                }
                
                    
                for(var i = 0 ; i < $scope.data.record.length ; i ++ ){
                    
                    if($scope.configuration.aplicationDesignerConfiguration.Actions.isEdit )
                    {
                        $scope.data.record[i].record.EDIT = $scope.data.record[i].recordAccess.isEditable;
                        
                        if($scope.data.record[i].record.EDIT != false)
                            $scope.data.record[i].record.EDIT= '<a onClick="selectedAction(\'EDIT\')"><img src="https://www.foundationconnect.org/staticresources/SLDS/icons/utility/edit_form_60.png"></img></a>';
                        else
                            $scope.data.record[i].record.EDIT = '';
                        
                    }
                    if($scope.configuration.aplicationDesignerConfiguration.Actions.isView){
                        $scope.data.record[i].record.VIEW = $scope.data.record[i].recordAccess.isReadable;
                        
                        if($scope.data.record[i].record.VIEW != false)
                            $scope.data.record[i].record.VIEW = '<a onClick="selectedAction(\'VIEW\')"><img src="https://www.foundationconnect.org/staticresources/SLDS/icons/utility/search_60.png"></img></a>';
                        else
                            $scope.data.record[i].record.VIEW = '';
                        
                    }
                    if($scope.configuration.aplicationDesignerConfiguration.Actions.isDelete){
                        $scope.data.record[i].record.DELETE = $scope.data.record[i].recordAccess.isDeletable;
                       
                        
                        if($scope.data.record[i].record.DELETE != false)
                            $scope.data.record[i].record.DELETE = '<a onClick="selectedAction(\'DELETE\')" class="deleteRecord"> <img src="https://www.foundationconnect.org/staticresources/SLDS/icons/utility/delete_60.png"></img></a>';
                        else
                            $scope.data.record[i].record.DELETE = '';
                        
                    }
                    
                    if($scope.configuration.aplicationDesignerConfiguration.Actions.isAmendable){
                        if($scope.data.record[i].recordAccess.isAmendable && !$scope.data.record[i].recordAccess.isEditable)
                            $scope.data.record[i].record.AMMEND = $scope.data.record[i].recordAccess.isAmendable;
                        
                        if($scope.data.record[i].record.AMMEND != false && $scope.data.record[i].record.AMMEND!=undefined)
                            $scope.data.record[i].record.AMMEND = '<a onClick="selectedAction(\'AMMEND\')"><img src="https://www.foundationconnect.org/staticresources/SLDS/icons/utility/file_60.png"></img></a>';
                        else
                            $scope.data.record[i].record.AMMEND = '';
                        
                    }
                    
                    if($scope.data.record[i].relatedRecords.length>0)
                    {
                        $scope.data.record[i].record.REPORTS = '<a name="select_all" class="headerCheck"><img src="https://www.foundationconnect.org/staticresources/SLDS/icons/utility/chevrondown_60.png"></img></a>'
                    }
                    else
                    {
                        $scope.data.record[i].record.REPORTS = '';
                    }
                }
          
                if( isRight || isBoth){
                    
                    for(var index = 0 ; index < actions.length ; index ++){
                        var obj = {};
                        obj.apiName =  actions[index] ;
                        if(actions[index] == 'EDIT')
                        {
                            obj.label = $scope.datatableTranslations.editLinkLable
                            obj.Name =  $scope.datatableTranslations.editLinkLable
                        }
                        if(actions[index] == 'VIEW')
                        {
                            obj.label = $scope.datatableTranslations.viewLinkLabel
                            obj.Name =  $scope.datatableTranslations.viewLinkLabel
                        }
                        if(actions[index] == 'DELETE')
                        {
                            obj.label = $scope.datatableTranslations.deleteLinkLabel
                            obj.Name =  $scope.datatableTranslations.deleteLinkLabel
                        }
                        if(actions[index] == 'AMMEND')
                        {
                            obj.label = $scope.datatableTranslations.amendLinkLabel
                            obj.Name =  $scope.datatableTranslations.amendLinkLabel
                        }
                        if(actions[index] == 'REPORTS')
                        {
                            obj.label = ''
                            obj.Name =  ''
                        }
                        $scope.configuration.aplicationDesignerConfiguration.columns.push(obj);
                    }                  
                }
                if( !isRight || isBoth){ 
                    
                    for(var index = actions.length - 1 ; index >= 0 ; index --){
                         var obj = {};
                        obj.apiName =  actions[index] ;
                        if(actions[index] == 'EDIT')
                        {
                            obj.label = $scope.datatableTranslations.editLinkLable
                            obj.Name =  $scope.datatableTranslations.editLinkLable
                        }
                        if(actions[index] == 'VIEW')
                        {
                            obj.label = $scope.datatableTranslations.viewLinkLabel
                            obj.Name =  $scope.datatableTranslations.viewLinkLabel
                        }
                        if(actions[index] == 'DELETE')
                        {
                            obj.label = $scope.datatableTranslations.deleteLinkLabel
                            obj.Name =  $scope.datatableTranslations.deleteLinkLabel
                        }
                        if(actions[index] == 'AMMEND')
                        {
                            obj.label = $scope.datatableTranslations.amendLinkLabel
                            obj.Name =  $scope.datatableTranslations.amendLinkLabel
                        }
                        if(actions[index] == 'REPORTS')
                        {
                            obj.label = ''
                            obj.Name =  ''
                        }
                        obj.isSearch = true;
                        $scope.configuration.aplicationDesignerConfiguration.columns.unshift(obj);
                    }
                }
                gReportColumns = angular.copy($scope.configuration.aplicationDesignerConfiguration.granteeReportColumns);                
              
                var deleteAction = {};
                deleteAction.data = 'DELETE';
                deleteAction.title = $scope.datatableTranslations.deleteLinkLabel;
                deleteAction.isSort = false;
                deleteAction.defaultContent = '';
                gReportColumns.unshift(deleteAction);
                
                var viewAction = {};
                viewAction.data = 'VIEW';
                viewAction.title = $scope.datatableTranslations.viewLinkLabel
                viewAction.isSort = false;
                viewAction.defaultContent = '';
                gReportColumns.unshift(viewAction);
                
                var editAction = {};
                editAction.data = 'EDIT';
                editAction.title =  $scope.datatableTranslations.editLinkLable
                editAction.isSort = false;
                editAction.defaultContent = '';
                gReportColumns.unshift(editAction);
                
                
                //Reports
               
                var lstGranteeReportColumns = [];
                var mapInnerFieldToMaskChar = new Map();
                var mapInnerFieldToMaskType = new Map();
                for (var i = 0; i <gReportColumns.length; i++) {
                    columnObject = new Object();
                    columnObject.data = gReportColumns[i].data;
                    columnObject.title = gReportColumns[i].title;
                    columnObject.class = 'slds-truncate';
                    columnObject.width = '10%';
                    if($scope.configuration.aplicationDesignerConfiguration.sortableField != undefined && $scope.configuration.aplicationDesignerConfiguration.sortableField == columnObject.data){
                        sortColNo = i ;
                        sortOrder = $scope.configuration.aplicationDesignerConfiguration.sortableFieldOrder.toLocaleLowerCase().slice(0,3)
                    }
                    if(['EDIT','VIEW','DELETE','REPORTS','AMMEND'].indexOf(columnObject.data)<0 && columnObject.data.indexOf('.Name')<0){
                        
                        columnObject.fieldType = $filter('filter')($scope.configuration.childSchema.fieldDetails, { apiName: columnObject.data})[0].fieldType;
                       
                        if($filter('filter')($scope.configuration.childSchema.fieldDetails, { apiName: columnObject.data})[0].maskChar!=undefined && $filter('filter')($scope.configuration.childSchema.fieldDetails, { apiName: columnObject.data})[0].maskType!=undefined)
                        {
                            mapInnerFieldToMaskChar.set(columnObject.data, $filter('filter')($scope.configuration.childSchema.fieldDetails, { apiName: columnObject.data})[0].maskChar);
                            mapInnerFieldToMaskType.set(columnObject.data,$filter('filter')($scope.configuration.childSchema.fieldDetails, { apiName: columnObject.data})[0].maskType);
                        }
                         if(columnObject.fieldType == 'REFERENCE')
                        {
                            if(gReportColumns[i].data.endsWith('__c'))
                            {
                                columnObject.data = gReportColumns[i].data.replace('__c','__r.Name');
                            }
                            else
                                columnObject.data = gReportColumns[i].data.replace('Id','.Name');
                                
                        }
                        
                        if(columnObject.fieldType == 'DATE'){
                            columnObject.render = function ( data, type, row ) {
                                if(data != undefined){
                                    $.fn.dataTable.moment($scope.configuration.dateFormat);
                                    return moment.utc(data).format($scope.configuration.dateFormat);
                                } 
                                return '';
                            }
                        }
                        
                         if(columnObject.fieldType == 'DATETIME'){
                            columnObject.render = function ( data, type, row ) {
                                if(data != undefined){
                                    $.fn.dataTable.moment($scope.configuration.dateTimeFormat);
                                    return moment(data).utcOffset($scope.configuration.offSet).format($scope.configuration.dateTimeFormat);
                                } 
                                return '';
                            }
                        }
                        
                         if(columnObject.fieldType == 'TIME'){
                            columnObject.render = function ( data, type, row ) {
                                if(data != undefined){
                                    $.fn.dataTable.moment($scope.configuration.timeFormat);
                                    return moment(data).utcOffset($scope.configuration.offSet).format($scope.configuration.timeFormat);
                                } 
                                return '-' ;
                            }
                        }
                        if(columnObject.fieldType == 'CURRENCY'){
                            columnObject.render = function ( data, type, row ) {
                                if(data != undefined){
                                    return $scope.configuration.currency + data.toLocaleString();
                                } 
                                return '-' ;
                            }
                        }
                        
                        if(columnObject.fieldType == 'BOOLEAN'){
                            columnObject.render = function ( data, type, row ) {
                                if(data != undefined){
                                    if (data == true)
                                        return '<input type="checkbox" checked disabled >';
                                    else
                                        return '<input type="checkbox" disabled/ >';
                                } 
                                return '-' ;
                                
                            }
                        }
                        
                        if(columnObject.fieldType == 'PERCENT'){
                            columnObject.render = function ( data, type, row ) {
                                if(data != undefined){
                                    
                                    return  data + ' %';
                                } 
                                return '-' ;
                                
                            }
                        }
                       
                        if(columnObject.fieldType == 'ENCRYPTEDSTRING')
                        {
                            columnObject.render = function ( data, type, row,meta) 
                            {
                                if(data != undefined)
                                {
                                    var encryptedString = '';
                                    if( mapInnerFieldToMaskType.get(meta.settings.aoColumns[meta.col].data) == 'all')
                                    { 
                                        for(var k=0;k<data.length;k++)
                                        {
                                            encryptedString+=  mapInnerFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data);
                                        }
                                    }
                                    else if( mapInnerFieldToMaskType.get(meta.settings.aoColumns[meta.col].data) == 'lastFour')
                                    {
                                        if(data.length>4)
                                        {
                                            for(var k=0;k<data.length-4;k++)
                                            {
                                                encryptedString+=  mapInnerFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data);
                                            }
                                            encryptedString+=data.substr(data.length - 4);
                                        }
                                        else
                                            encryptedString+= data;                                        
                                    }
                                    else if( mapInnerFieldToMaskType.get(meta.settings.aoColumns[meta.col].data) == 'creditCard')
                                    {
                                        if( mapInnerFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data) == '*')
                                            encryptedString = '****-****-****-';
                                        else if( mapInnerFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data)== 'X')
                                            encryptedString = 'XXXX-XXXX-XXXX-';
                                        if(data.length>=4)
                                        {
                                           encryptedString+= data.substr(data.length - 4);
                                        }
                                        else
                                        {
                                            var maskData = 4 - data.length;
                                            if(maskData>0)
                                            {
                                                for(var a = 0 ; a < maskData ; a ++)
                                                {
                                                    encryptedString+= mapInnerFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data);
                                                }
                                                encryptedString+= data;
                                            }
                                        }
                                    }
                                    else if( mapInnerFieldToMaskType.get(meta.settings.aoColumns[meta.col].data) == 'nino')
                                    {
                                        if( mapInnerFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data) == '*')
                                            encryptedString = '** ** ** ** *';
                                        else  if( mapInnerFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data) == 'X')
                                            encryptedString = 'XX XX XX XX X';
                                    }
                                    else if( mapInnerFieldToMaskType.get(meta.settings.aoColumns[meta.col].data) == 'ssn')
                                    {
                                        if( mapInnerFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data) == '*')
                                            encryptedString = '***-**-';
                                        else  if( mapInnerFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data) == 'X')
                                            encryptedString = 'XXX-XX-';
                                        
                                        if(data.length>=4)
                                        {
                                            encryptedString+= data.substr(data.length - 4);
                                        }
                                        else
                                        {
                                            var maskData = 4 - data.length;
                                            if(maskData>0)
                                            {
                                                for(var a = 0 ; a < maskData ; a ++)
                                                {
                                                    encryptedString+= mapInnerFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data);
                                                }
                                                encryptedString+= data;
                                            }
                                        }
                                    }  
                                    else if( mapInnerFieldToMaskType.get(meta.settings.aoColumns[meta.col].data) == 'sin')
                                    {
                                        if( mapInnerFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data) == '*')
                                            encryptedString = '***-***-';
                                        else  if( mapInnerFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data) == 'X')
                                            encryptedString = 'XXX-XXX-';
                                        
                                        if(data.length>=3)
                                        {
                                            encryptedString+= data.substr(data.length - 3);
                                        }
                                        else
                                        {
                                            var maskData = 3 - data.length;
                                            if(maskData>0)
                                            {
                                                for(var a = 0 ; a < maskData ; a ++)
                                                {
                                                    encryptedString+= mapInnerFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data);
                                                }
                                                encryptedString+=data;
                                            }
                                        }
                                    }
                                    return encryptedString;
                                } 
                                else
                                    return '-' ;
                            }
                        }
                    }
                    
                    if(columnObject.data == '<a name="select_all"  class="headerCheck"><img src="https://www.foundationconnect.org/staticresources/SLDS/icons/utility/chevrondown_60.png"></img> </a>')
                        columnObject.defaultContent ='<a name="select_all"  class="headerCheck"><img src="https://www.foundationconnect.org/staticresources/SLDS/icons/utility/chevrondown_60.png"></img></a>';
                    else
                        columnObject.defaultContent ='-';
                    columnObject.searchable = true;
                    columnObject.sortable = true;
                    
                    lstGranteeReportColumns.push(columnObject);
                }
                
                //Reports
                var parser = new DOMParser;
                var dateFormat= $scope.configuration.dateFormat;
                for(var index = 0 ; index < $scope.data.record.length ; index ++)
                {
                    var editUrl = parser.parseFromString(
                        '<!doctype html><body>' +  $scope.data.record[index].editUrl,
                        'text/html');
                    var viewUrl = parser.parseFromString(
                        '<!doctype html><body>' +  $scope.data.record[index].viewUrl,
                        'text/html');
                    $scope.data.record[index].record.EditUrl = editUrl.body.textContent;
                    $scope.data.record[index].record.ViewUrl = viewUrl.body.textContent;
                    $scope.data.record[index].record.color = $scope.data.record[index].color;
                    if($scope.data.record[index].relatedRecords!=undefined && currentObject=='Opportunity')
                    {
                        $scope.data.record[index].record.reports = [];
                        $scope.data.record[index].record.reports =  $scope.data.record[index].relatedRecords;
                    }
                    tabrecord.push($scope.data.record[index].record);
                }
                selectedAction = function(action) {
                    
                    $scope.selectedDataItem.record = [] ;
                    $scope.selectedDataItem.recordMode = action;
                    if(action == 'DELETE' || action == 'GRDELETE')
                        isDeletable = true;
                    else 
                        isDeletable = false;
                    if($scope.selectedDataItem!=undefined)
                        $scope.selectedDataItem.tab = $scope.configuration.tab;
                }
                var table;
                var innertable ;
                initializeTable = function(columnList) {
                    
                    j$ = jQuery.noConflict();
                    if (table != undefined) {
                        table.destroy();
                        table.draw();
                    }
                    var events = $('#events');
                    var rows_selected = [];
                   // $.fn.dataTable.moment( 'HH:mm MMM D, YY' );
                    table = $('#dataTableId').DataTable({
                        "createdRow": function( row, data, dataIndex){
                            $(row).find('td').each (function() {
                                if(data.color!=undefined)
                                    $(this).attr('style','color:' + data.color );
                                else
                                    $(this).attr('style','color:black' );
                            }); 
                        },
                        "pagingType": "full_numbers",
                        "data": tabrecord,
                        "columns": columnList,
                        "oLanguage": {
                            "sInfoEmpty": $scope.datatableTranslations.emaptyPaginationFooter,
                            "sLengthMenu": $scope.datatableTranslations.paginationHeader,
                            "sInfo": $scope.datatableTranslations.paginationFooter,
                            "sSearch": $scope.datatableTranslations.SearchLabel,
                            "sInfoFiltered": $scope.datatableTranslations.datatableFilterLabel,
                            "sZeroRecords": $scope.datatableTranslations.emaptytableLabel,
                            "oPaginate": {
                                "sNext": $scope.datatableTranslations.nextLinkLabel,
                                "sPrevious": $scope.datatableTranslations.previousLinklabel,
                                "sFirst": $scope.datatableTranslations.firstLabel,
                                "sLast": $scope.datatableTranslations.lastLabel,
                            }
                        },
                        "destroy": true,
                        'rowCallback': function(row, data, dataIndex){
                            // Get row ID
                            var rowId = data[0];
                            
                            if($.inArray(rowId, rows_selected) !== -1){
                                $(row).find('input[class="headerCheck"]').prop('checked', true);
                                $(row).addClass('selected');
                            }
                        },
                        'initComplete': function () {
                            var columns =  $('#dataTableId').DataTable().settings().init().columns;
                            
                            this.api().columns().every( function () {
                                var column = this;
                                if(['EDIT','VIEW','DELETE','REPORTS','AMMEND'].indexOf(columns[column.index()].data)<0) 
                                {
                                    var select = $('<select id="selecttab" class="slds-select search_filter" style="z-index: 100"><option value="">'+$scope.datatableTranslations.picklistDefaultValueAll+'</option></select>')
                                    .appendTo( $(column.header()))
                                    .on( 'change , click', function (e) {
                                        e.stopPropagation();
                                        var val = $.fn.dataTable.util.escapeRegex(
                                            $(this).val()
                                        );
                                        if(val != $scope.datatableTranslations.picklistDefaultValueAll){
                                            let searchRegex;
                                            if(val) {
                                                //If filter is "-", match on "-" and empty columns
                                                if (val === "\\-") {
                                                    searchRegex = '^\-$|^$';
                                                } else {
                                                    searchRegex = '^'+val+'$';
                                                }
                                            } else {
                                                searchRegex = '';
                                            }
                                            column.search( searchRegex, true, false ).draw();
                                        }
                                    } );
                                    column.data().unique().sort().each( function ( d, j ) {
                                        if(['DATETIME','DATE','TIME','CURRENCY','BOOLEAN','PERCENT','ENCRYPTEDSTRING'].indexOf(columns[column.index()].fieldType)>-1){
                                            var formatedData = $fieldFormat.setFieldFormat(d,columns[column.index()].fieldType != 'undefine' ? columns[column.index()].fieldType :null,$scope.configuration,columns[column.index()].data);
                                            if(formatedData != undefined)
                                                select.append( '<option value="'+formatedData+'">'+formatedData+'</option>')
                                                }
                                        else{
                                            select.append( '<option value="'+d+'">'+d+'</option>')
                                        }
                                    });
                                }
                            } );
                        }
                     
                    });
                    $('#dataTableId td').css('white-space','initial');
                     $('#dataTableId tbody').on('click', 'a.headerCheck', function(e){
                         
                         var records = [];
                         var tr = $(this).closest('tr');
                         $(this).toggleClass('expand');

                         var row = table.row( tr );
                         
                         if ( row.child.isShown() ) {
                             // This row is already open - close it
                             row.child.hide();
                             tr.removeClass('shown');
                         }
                         else {
                             // Open this row
                             row.child( '<table id="innertable"></table>');
                             row.child( '<table id="innertable'+ row.index()+'"></table>').show();
                             if(row.data().reports!=undefined)
                             {
                                 for(var index = 0 ; index <= row.data().reports.length ; index ++)
                                 {  
                                     if(row.data().reports[index]!=undefined)
                                     {
                                         var editUrl = parser.parseFromString(
                                             '<!doctype html><body>' +  row.data().reports[index].editUrl,
                                             'text/html');
                                         var viewUrl = parser.parseFromString(
                                             '<!doctype html><body>' + row.data().reports[index].viewUrl,
                                             'text/html');
                                         row.data().reports[index].record.EditUrl = editUrl.body.textContent;
                                         row.data().reports[index].record.ViewUrl = viewUrl.body.textContent;
                                         row.data().reports[index].record.color =  row.data().reports[index].color;
                                         if(row.data().reports[index].recordAccess.isDeletable)                                             
                                             row.data().reports[index].record.DELETE = '<a onClick="selectedAction(\'GRDELETE\')" class="deleteRecord"><img src="https://www.foundationconnect.org/staticresources/SLDS/icons/utility/delete_60.png"></img></a>';
                                         //if(row.data().reports[index].recordAccess.isReadable)
                                             row.data().reports[index].record.VIEW = '<a onClick="selectedAction(\'GRVIEW\')"><img src="https://www.foundationconnect.org/staticresources/SLDS/icons/utility/search_60.png"></a>';
                                         if(row.data().reports[index].recordAccess.isEditable)
                                             row.data().reports[index].record.EDIT = '<a onClick="selectedAction(\'GREDIT\')"><img src="https://www.foundationconnect.org/staticresources/SLDS/icons/utility/edit_form_60.png"></img></a>';
                                         
                                         records.push(row.data().reports[index].record);
                                     }
                                 }
                                 var datatable = initialize(records,lstGranteeReportColumns,row.index());
                                 datatable.draw();
                                 tr.addClass('shown');
                             }
                         } 
                    });
                    
                    $('#dataTableId tbody').on('click', 'tr', function(e){
                         
                        var row = $(this).closest('tr');
                        var rowData;
                        var tableId = $(this).closest('table').attr('id');
                        rowData = $('#' + tableId).DataTable().row(row).data();

                        
                        $scope.dataToRemove = row;
                        
                            if (rowData.hasOwnProperty('EDIT'))
                                delete rowData.EDIT;
                            if (rowData.hasOwnProperty('VIEW')) 
                                delete rowData.VIEW;
                            if (rowData.hasOwnProperty('DELETE')) 
                                delete rowData.DELETE;
                            if (rowData.hasOwnProperty('AMMEND')) 
                                delete rowData.DELETE;
                            if (rowData.hasOwnProperty('REPORTS')) 
                                delete rowData.DELETE;
                            var rowId = rowData;
                            
                            // Determine whether row ID is in the list of selected row IDs
                            var index = $.inArray(rowId, $scope.selectedDataItem.record);
                            
                            // If checkbox is checked and row ID is not in list of selected row IDs
                            if(this.checked && index === -1){
                                $scope.selectedDataItem.record.push(rowId);
                                
                                // Otherwise, if checkbox is not checked and row ID is in list of selected row IDs
                            } 
                            else{ 
                                if (!this.checked && index !== -1 && !$scope.selectedDataItem.recordMode){
                                    $scope.selectedDataItem.record.splice(index, 1);
                                }
                                else if($scope.selectedDataItem.recordMode)
                                    $scope.selectedDataItem.record.push(rowId);
                            }
                            $scope.$apply();
                            
                            
                            if(this.checked){
                                row.addClass('selected');
                            } else {
                                row.removeClass('selected');
                            }
                            if(isDeletable)
                            {  
                                row.remove();
                                $scope.selectedDataItem.recordMode = '';
                            }                            
                            isDeletable = false;
                            // Update state of "Select all" control
                            updateDataTableSelectAllCtrl(table);
                            
                            // Prevent click event from propagating to parent
                            e.stopPropagation();
                       
                    });
            
            $('#dataTableDeleteButton').click( function(e){
                        if (confirm("Are you sure to delete !")) {
                            setTimeout($scope.deleteRecord(), 300);
                            table.rows('.selected').remove().draw( false );
                        }
                        else 
                        {
                            $scope.isDeletable = false;
                            txt = "You pressed Cancel!";
                        }
                    });
                    
                    $('#dataTableId').on('click', 'tbody td, thead th:first-child', function(e){
                        $(this).parent().find('input[class="headerCheck"]').trigger('click');
                    });
                    
                    // Handle click on "Select all" control
                    $('thead input[name="select_all"]', table.table().container()).on('click', function(e){
                        if(this.checked){
                            $('#dataTableId tbody input[class="headerCheck"]:not(:checked)').trigger('click');
                        } else {
                            $('#dataTableId tbody input[class="headerCheck"]:checked').trigger('click');
                        }
                        
                        // Prevent click event from propagating to parent
                        e.stopPropagation();
                    });
                    
                    // Handle table draw event
                    table.on('draw', function(){
                        // Update state of "Select all" control
                        updateDataTableSelectAllCtrl(table);
                    });
                    
                    function updateDataTableSelectAllCtrl(table){
                        var $table             = table.table().node();
                        var $chkbox_all        = $('tbody input[class="headerCheck"]', $table);
                        var $chkbox_checked    = $('tbody input[class="headerCheck"]:checked', $table);
                        var chkbox_select_all  = $('thead input[name="select_all"]', $table).get(0);
                        
                        // If none of the checkboxes are checked
                       if($chkbox_checked!= undefined)
                        {
                            if ($chkbox_checked.length === 0) 
                            {
                                if(chkbox_select_all!=undefined)
                                {
                                    chkbox_select_all.checked = false;
                                    if ('indeterminate' in chkbox_select_all) 
                                    {
                                        chkbox_select_all.indeterminate = false;
                                    }
                                    // If all of the checkboxes are checked
                                    }
                            } 
                            else if ($chkbox_checked.length === $chkbox_all.length) 
                            {
                                if(chkbox_select_all!= undefined)
                                {
                                    chkbox_select_all.checked = true;
                                    if ('indeterminate' in chkbox_select_all) 
                                    {
                                    chkbox_select_all.indeterminate = false;
                                    }
                                    // If some of the checkboxes are checked
                                }
                            } 
                            else 
                            {
                                if(chkbox_select_all!= undefined)
                                {
                                    chkbox_select_all.checked = true;
                                    if ('indeterminate' in chkbox_select_all) 
                                    {
                                        chkbox_select_all.indeterminate = true;
                                    }
                                }
                            }
                        }

                    }
                    
                }
                
                function initialize(records, column, rowIndex)
                {
                    var tableId = '#innertable' + rowIndex;
                    j$ = jQuery.noConflict();
                    if ( $.fn.DataTable.isDataTable( tableId) ) {
                        $(tableId).dataTable().destroy();
                        $(tableId).dataTable().draw();
                    }
                    else                        
                    {
                        innertable = $(tableId).DataTable({
                            "bPaginate": false,
                            "bFilter": false,
                            "data": records,
                            "columns": column
                        });
                        return innertable;
                    }
                }
                
                var mapFieldToMaskChar = new Map();
                var mapFieldToMaskType = new Map();
                for(var i = 0; i < $scope.configuration.aplicationDesignerConfiguration.columns.length; i++){
                    if(['EDIT','VIEW','DELETE','REPORTS','AMMEND'].indexOf($scope.configuration.aplicationDesignerConfiguration.columns[i].apiName)<0 && !$scope.configuration.aplicationDesignerConfiguration.columns[i].apiName.endsWith('.Name')){
                        var type = $filter('filter')($scope.configuration.schema.fieldDetails, { apiName: $scope.configuration.aplicationDesignerConfiguration.columns[i].apiName})[0].fieldType;
                        if(type == 'REFERENCE')
                        {
                            if($scope.configuration.aplicationDesignerConfiguration.columns[i].apiName.endsWith('__c'))
                            {
                                $scope.configuration.aplicationDesignerConfiguration.columns[i].apiName = $scope.configuration.aplicationDesignerConfiguration.columns[i].apiName.replace('__c','__r.Name');
                            }
                            else
                                $scope.configuration.aplicationDesignerConfiguration.columns[i].apiName = $scope.configuration.aplicationDesignerConfiguration.columns[i].apiName.replace('Id','.Name');
                                
                        }
                    }
                    columnsList.push($scope.configuration.aplicationDesignerConfiguration.columns[i]);
                }
                for (var i = 0; i <columnsList.length; i++) {
                 
                    fieldApi = columnsList[i].apiName;
                    columnObject = new Object();
                    columnObject.data = columnsList[i].apiName;
                    columnObject.title = columnsList[i].Name ? columnsList[i].Name : columnsList[i].label;
                    columnObject.class = 'slds-truncate';
                      columnObject.width = '10%';
                    if($scope.configuration.aplicationDesignerConfiguration.sortableField != undefined && $scope.configuration.aplicationDesignerConfiguration.sortableField == columnObject.data){
                        sortColNo = i ;
                        sortOrder = $scope.configuration.aplicationDesignerConfiguration.sortableFieldOrder.toLocaleLowerCase().slice(0,3)
                    }
                    if(['EDIT','VIEW','DELETE','REPORTS','AMMEND'].indexOf(columnObject.data)<0 && columnObject.data.indexOf('.Name')<0){
                        
                        columnObject.fieldType = $filter('filter')($scope.configuration.schema.fieldDetails, { apiName: columnObject.data})[0].fieldType;
                        if($filter('filter')($scope.configuration.schema.fieldDetails, { apiName: columnObject.data})[0].maskChar!=undefined && $filter('filter')($scope.configuration.schema.fieldDetails, { apiName: columnObject.data})[0].maskType!=undefined)
                        {
                            mapFieldToMaskChar.set(columnObject.data, $filter('filter')($scope.configuration.schema.fieldDetails, { apiName: columnObject.data})[0].maskChar);
                            mapFieldToMaskType.set(columnObject.data,$filter('filter')($scope.configuration.schema.fieldDetails, { apiName: columnObject.data})[0].maskType);
                        }
                       $scope.configuration.mapFieldToMaskChar = mapFieldToMaskChar;
                       $scope.configuration.mapFieldToMaskType = mapFieldToMaskType;
                        
                        

                        if(columnObject.fieldType == 'DATE'){
                            columnObject.render = function ( data, type, row ) {
                                if(data != undefined){
                                    $.fn.dataTable.moment($scope.configuration.dateFormat);
                                    return moment.utc(data).format($scope.configuration.dateFormat);
                                } 
                                return '' ;
                                
                            }
                        }
                        
                        if(columnObject.fieldType == 'DATETIME'){
                            columnObject.render = function ( data, type, row ) {
                                if(data != undefined){
                                    $.fn.dataTable.moment($scope.configuration.dateTimeFormat);
                                    return moment(data).utcOffset($scope.configuration.offSet).format($scope.configuration.dateTimeFormat);
                                } 
                                return '' ;
                                
                            }
                        }
                        
                        if(columnObject.fieldType == 'TIME'){
                            columnObject.render = function ( data, type, row ) {
                                if(data != undefined){
                                    $.fn.dataTable.moment($scope.configuration.timeFormat);

                                    return moment(data).utcOffset($scope.configuration.offSet).format($scope.configuration.timeFormat);
                                } 
                                return '-' ;
                                
                            }
                        }
                        if(columnObject.fieldType == 'CURRENCY'){
                            columnObject.render = function ( data, type, row ) {
                                if(data != undefined){
                                    return $scope.configuration.currency + data.toLocaleString();
                                } 
                                return '-' ;
                            }
                        }
                        
                        if(columnObject.fieldType == 'BOOLEAN'){
                            columnObject.render = function ( data, type, row ) {
                                if(data != undefined){
                                    if (data == true)
                                        return '<input type="checkbox" checked disabled >';
                                    else
                                        return '<input type="checkbox" disabled/ >';
                                } 
                                return '-' ;
                                
                            }
                        }
                        
                        if(columnObject.fieldType == 'PERCENT'){
                            columnObject.render = function ( data, type, row ) {
                                if(data != undefined){
                                    
                                    return  data + ' %';
                                } 
                                return '-' ;
                                
                            }
                        }
                       
                        if(columnObject.fieldType == 'ENCRYPTEDSTRING')
                        {
                            columnObject.render = function ( data, type, row,meta) 
                            {
                                if(data != undefined)
                                {
                                    var encryptedString = '';
                                    if(mapFieldToMaskType.get(meta.settings.aoColumns[meta.col].data) == 'all')
                                    { 
                                        for(var k=0;k<data.length;k++)
                                        {
                                            encryptedString+= mapFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data);
                                        }
                                    }
                                    else if(mapFieldToMaskType.get(meta.settings.aoColumns[meta.col].data) == 'lastFour')
                                    {
                                        if(data.length>4)
                                        {
                                            for(var k=0;k<data.length-4;k++)
                                            {
                                                encryptedString+= mapFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data);
                                            }
                                            encryptedString+=data.substr(data.length - 4);
                                        }
                                        else
                                            encryptedString+= data; 
                                    }
                                    else if(mapFieldToMaskType.get(meta.settings.aoColumns[meta.col].data) == 'creditCard')
                                    {
                                        if(mapFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data) == '*')
                                            encryptedString = '****-****-****-';
                                        else if(mapFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data)== 'X')
                                            encryptedString = 'XXXX-XXXX-XXXX-';
                                        
                                        if(data.length>=4)
                                        {
                                           encryptedString+= data.substr(data.length - 4);
                                        }
                                        else
                                        {
                                            var maskData = 4 - data.length;
                                            if(maskData>0)
                                            {
                                                for(var a = 0 ; a < maskData ; a ++)
                                                {
                                                    encryptedString+= mapFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data);
                                                }
                                                encryptedString+= data;
                                            }
                                        }
                                    }
                                    else if(mapFieldToMaskType.get(meta.settings.aoColumns[meta.col].data) == 'nino')
                                    {
                                        if(mapFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data) == '*')
                                            encryptedString = '** ** ** ** *';
                                        else  if(mapFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data) == 'X')
                                            encryptedString = 'XX XX XX XX X';
                                    }
                                    else if(mapFieldToMaskType.get(meta.settings.aoColumns[meta.col].data) == 'ssn')
                                    {
                                        if(mapFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data) == '*')
                                            encryptedString = '***-**-';
                                        else  if(mapFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data) == 'X')
                                            encryptedString = 'XXX-XX-';
                                        
                                        if(data.length>=4)
                                        {
                                            encryptedString+= data.substr(data.length - 4);
                                        }
                                        else
                                        {
                                            var maskData = 4 - data.length;
                                            if(maskData>0)
                                            {
                                                for(var a = 0 ; a < maskData ; a ++)
                                                {
                                                    encryptedString+= mapFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data);
                                                }
                                                encryptedString+= data;
                                            }
                                        }
                                    }  
                                    else if(mapFieldToMaskType.get(meta.settings.aoColumns[meta.col].data) == 'sin')
                                    {
                                        if(mapFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data) == '*')
                                            encryptedString = '***-***-';
                                        else  if(mapFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data) == 'X')
                                            encryptedString = 'XXX-XXX-';
                                        
                                        if(data.length>=3)
                                        {
                                            encryptedString+= data.substr(data.length - 3);
                                        }
                                        else
                                        {
                                            var maskData = 3 - data.length;
                                            if(maskData>0)
                                            {
                                                for(var a = 0 ; a < maskData ; a ++)
                                                {
                                                    encryptedString+= mapFieldToMaskChar.get(meta.settings.aoColumns[meta.col].data);
                                                }
                                                encryptedString+= data;
                                            }
                                        }
                                    }
                                    return encryptedString;
                                } 
                                else
                                    return '-' ;
                            }
                        }
                    }
                    
                    if(columnObject.data == '<a name="select_all"  class="headerCheck"><img src="https://www.foundationconnect.org/staticresources/SLDS/icons/utility/chevrondown_60.png"></img> </a>')
                        columnObject.defaultContent ='<a name="select_all"  class="headerCheck"><img src="https://www.foundationconnect.org/staticresources/SLDS/icons/utility/chevrondown_60.png"></img></a>';
                    else
                        columnObject.defaultContent ='-';
                    columnObject.searchable = $scope.configuration.aplicationDesignerConfiguration.columns[i].isSearch == true ? true : false;
                    columnObject.sortable = $scope.configuration.aplicationDesignerConfiguration.columns[i].isSort == true ? true : false;
                    
                    lstColumn.push(columnObject);
                }
                var findKey = function(obj, value)
                {
                    var key = null;
                    for (var prop in obj)
                    {
                        if (obj.hasOwnProperty(prop))
                        {
                            if (obj[prop] === value)
                            {
                                key = prop;
                            }
                        }
                    }
                    
                    return key;
                };
                
                initializeTable(lstColumn);
                
            }
        }
    });

datatableApp.service('$dtTableInitializeSettings' ,function(){
    var serviceHandle = this;
        serviceHandle.initializeTranslation = function (openTabLabel,closeTabLabel,editLinkLable, viewLinkLabel,deleteLinkLabel,amendLinkLabel,emaptyPaginationFooter,paginationHeader,paginationFooter,SearchLabel,datatableFilterLabel,emaptytableLabel,nextLinkLabel, previousLinklabel,confirmAmendment,firstLabel,lastLabel,picklistDefaultValueAll)
        {
            var translation = {};
            translation.openTabLabel = openTabLabel;
            translation.closeTabLabel = closeTabLabel;
            translation.editLinkLable = editLinkLable;
            translation.viewLinkLabel = viewLinkLabel;
            translation.deleteLinkLabel = deleteLinkLabel;
            translation.amendLinkLabel = amendLinkLabel;
            translation.emaptyPaginationFooter = emaptyPaginationFooter;
            translation.paginationHeader = paginationHeader;
            translation.paginationFooter = paginationFooter; 
            translation.SearchLabel = SearchLabel;
            translation.datatableFilterLabel = datatableFilterLabel;
            translation.emaptytableLabel = emaptytableLabel;
            translation.nextLinkLabel = nextLinkLabel;
            translation.previousLinklabel = previousLinklabel;
            translation.confirmAmendment = confirmAmendment;
            translation.firstLabel = firstLabel;
            translation.lastLabel = lastLabel;
            translation.picklistDefaultValueAll = picklistDefaultValueAll;
            return translation;
        }
    });

datatableApp.service('$fieldFormat',function(){
        var serviceHandle = this;
        serviceHandle.setFieldFormat = function(data,fielddataType,configuration,fieldApi) 
        {
            if(data !=undefined  && fielddataType != undefined) 
            {
                if(fielddataType == 'DATETIME')
                {
                    $.fn.dataTable.moment(configuration.dateFormat);
                   if (data !== "-")
                       return moment(data).utcOffset(configuration.offSet).format(configuration.dateTimeFormat);
                    else
                        return "-";
                }
                else if(fielddataType!=undefined && fielddataType == 'DATE')
                {
                    $.fn.dataTable.moment(configuration.dateFormat); 
                    if (data !== "-")
                       return moment.utc(data).format(configuration.dateFormat);
                    else
                        return "-";
                }
                else if(fielddataType!=undefined && fielddataType == 'TIME')
                {
                    $.fn.dataTable.moment(configuration.timeFormat);
                    if(moment(data).utcOffset(configuration.offSet).format(configuration.timeFormat) == "Invalid date")
                         return '-';
                     else
                        return moment(data).utcOffset(configuration.offSet).format(configuration.timeFormat);
                }
                else if(fielddataType!=undefined && fielddataType == 'CURRENCY'){
                    if (data !== "-")
                        return configuration.currency + data.toLocaleString();
                    else
                        return "-";
                }
                else if(fielddataType!=undefined && fielddataType == 'BOOLEAN')
                {
                    if (data == true)
                        return '<input type="checkbox" checked disabled >';
                    else
                        return '<input type="checkbox" disabled/ >';
                }
                else if(fielddataType!=undefined && fielddataType == 'PERCENT')
                {
                    if (data !== "-")
                       return  data + ' %';
                    else
                        return "-";
                }
                else if(fielddataType!=undefined && fielddataType == 'ENCRYPTEDSTRING')
                            {
                                if(data !== "-")
                                {
                                    var encryptedString = '';
                                    if(configuration.mapFieldToMaskType.get(fieldApi) == 'all')
                                    { 
                                        for(var k=0;k<data.length;k++)
                                        {
                                            encryptedString+= configuration.mapFieldToMaskChar.get(fieldApi);
                                        }
                                    }
                                    else if(configuration.mapFieldToMaskType.get(fieldApi) == 'lastFour')
                                    {
                                        if(data.length>4)
                                        {
                                            for(var k=0;k<data.length-4;k++)
                                            {
                                                encryptedString+= configuration.mapFieldToMaskChar.get(fieldApi);
                                            }
                                            encryptedString+=data.substr(data.length - 4);
                                        }
                                        else
                                            encryptedString+= data; 
                                    }
                                        else if(configuration.mapFieldToMaskType.get(fieldApi) == 'creditCard')
                                        {
                                            if(configuration.mapFieldToMaskChar.get(fieldApi) == '*')
                                                encryptedString = '****-****-****-';
                                            else if(configuration.mapFieldToMaskChar.get(fieldApi)== 'X')
                                                encryptedString = 'XXXX-XXXX-XXXX-';
                                            
                                            if(data.length>=4)
                                            {
                                                encryptedString+= data.substr(data.length - 4);
                                            }
                                            else
                                            {
                                                var maskdata = 4 - data.length;
                                                if(maskdata>0)
                                                {
                                                    for(var a = 0 ; a < maskdata ; a ++)
                                                    {
                                                        encryptedString+= configuration.mapFieldToMaskChar.get(fieldApi);
                                                    }
                                                    encryptedString+= data;
                                                }
                                            }
                                        }
                                            else if(configuration.mapFieldToMaskType.get(fieldApi) == 'nino')
                                            {
                                                if(configuration.mapFieldToMaskChar.get(fieldApi) == '*')
                                                    encryptedString = '** ** ** ** *';
                                                else  if(configuration.mapFieldToMaskChar.get(fieldApi) == 'X')
                                                    encryptedString = 'XX XX XX XX X';
                                            }
                                                else if(configuration.mapFieldToMaskType.get(fieldApi) == 'ssn')
                                                {
                                                    if(configuration.mapFieldToMaskChar.get(fieldApi) == '*')
                                                        encryptedString = '***-**-';
                                                    else  if(configuration.mapFieldToMaskChar.get(fieldApi) == 'X')
                                                        encryptedString = 'XXX-XX-';
                                                    
                                                    if(data.length>=4)
                                                    {
                                                        encryptedString+= data.substr(data.length - 4);
                                                    }
                                                    else
                                                    {
                                                        var maskdata = 4 - data.length;
                                                        if(maskdata>0)
                                                        {
                                                            for(var a = 0 ; a < maskdata ; a ++)
                                                            {
                                                                encryptedString+= configuration.mapFieldToMaskChar.get(fieldApi);
                                                            }
                                                            encryptedString+= data;
                                                        }
                                                    }
                                                }  
                                                    else if(configuration.mapFieldToMaskType.get(fieldApi) == 'sin')
                                                    {
                                                        if(configuration.mapFieldToMaskChar.get(fieldApi) == '*')
                                                            encryptedString = '***-***-';
                                                        else  if(configuration.mapFieldToMaskChar.get(fieldApi) == 'X')
                                                            encryptedString = 'XXX-XXX-';
                                                        
                                                        if(data.length>=3)
                                                        {
                                                            encryptedString+= data.substr(data.length - 3);
                                                        }
                                                        else
                                                        {
                                                            var maskdata = 3 - data.length;
                                                            if(maskdata>0)
                                                            {
                                                                for(var a = 0 ; a < maskdata ; a ++)
                                                                {
                                                                    encryptedString+= configuration.mapFieldToMaskChar.get(fieldApi);
                                                                }
                                                                encryptedString+= data;
                                                            }
                                                        }
                                                    }
                                    return encryptedString;
                                }
                                else
                                    return "-"
            }
            else
                return '-';
        }
 }
        });
