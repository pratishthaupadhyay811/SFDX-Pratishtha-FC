var tablistApp = angular.module('tablistApp',['inboxApp','datatableApp','messageApp']);
tablistApp.config(function($sceDelegateProvider){
    var baseUrl = window.location.protocol + '//' + window.location.host + '/**';
    $sceDelegateProvider.resourceUrlWhitelist([
        'https://localhost/**',
        baseUrl
    ]);
});
tablistApp.directive('tablist', function($compile,$InboxComponentInitializeSettings,$dtTableInitializeSettings,$filter, $sce){
        
        return {
            restrict: 'EA',
            scope :{
                tabs : '=',
                datatableTranslations: '=',
                inboxTranslations: '=',
                exception : '='
            },
            templateUrl : staticResourcePath + '/application_js/templates/tablist-template.html',
            link: function($scope, element, attr)
            {
                $scope.isLoading = true;
                $scope.renderGranteeBudget = false;
                $scope.data = {};
                $scope.configuration = {};
                $scope.budgetConfig = {};
                $scope.tabId = {};
                $scope.granteBudgetconfigurationRecords = {};
                //$scope.quizId = $scope.tabs.quiz.Id;
                $scope.selected_data_item ={};
                $scope.mode= '';
                $scope.isIframe= false;
                $scope.iframeUrl  = {};
                var mapObjToTabDetails = new Map();
                $scope.selectedIndex = 0;
                $scope.selectedHorizantalIndex = 0;
                $scope.setTab = function(index){
                    $scope.selectedIndex = index;
                    $scope.selectedHorizantalIndex = 0;
                }
                $scope.sethorizantalTab = function(index){
                    $scope.selectedHorizantalIndex = index;
                }

                $scope.getOpportunityData = function()
                {
                  Visualforce.remoting.Manager.invokeAction('FGM_Portal.CommunityDashboardController.getOpportunityTeamMembers',function(result, event) 
                  {
                      if(result!=null)
                      {
                            $scope.oppIds = result;
                            Visualforce.remoting.Manager.invokeAction('FGM_Portal.CommunityDashboardController.getData','Opportunity',$scope.oppIds,Object.keys($scope.oppIds), pageLanguage, function(result, event) 
                            {
                                if(result!=null)
                                {
                                    $scope.oppOwners = Object.keys(result[0].data.mapRelatedRecords);
                                    for(var i = 0;i<result.length; i ++)
                                    {
                                        if(result[i].tabLabel == 'Open Tab')
                                            result[i].tabLabel = $scope.datatableTranslations.openTabLabel;
                                        else if(result[i].tabLabel == 'Close Tab')
                                            result[i].tabLabel = $scope.datatableTranslations.closeTabLabel;
                                    }
                                    if(mapObjToTabDetails.has('Opportunity'))
                                        mapObjToTabDetails.get('Opportunity').lstInternalTabs = result;
                                    else
                                    {
                                        var opptab = {};
                                        opptab.lstInternalTabs = [];
                                        mapObjToTabDetails.set('Opportunity',opptab);
                                        mapObjToTabDetails.get('Opportunity').lstInternalTabs = result;
                                    }
                                    var tab = mapObjToTabDetails.get('Opportunity');
                                    Visualforce.remoting.Manager.invokeAction('FGM_Portal.CommunityDashboardController.getData','FGM_Base__Grantee_Report__c',$scope.oppIds,Object.keys($scope.oppIds),pageLanguage,function(result, event) 
                                    {
                                        if(result!=null)
                                        {
                                            grReferenceMap= result[0].data.lstReferenceFieldRecord;
                                            for(var i = 0;i<result.length; i ++)
                                            {
                                                if(result[i].tabLabel == 'Open Tab')
                                                    result[i].tabLabel = $scope.datatableTranslations.openTabLabel;
                                                else if(result[i].tabLabel == 'Close Tab')
                                                   result[i].tabLabel = $scope.datatableTranslations.closeTabLabel;
                                            }
                                            if(mapObjToTabDetails.has('FGM_Base__Grantee_Report__c'))
                                                mapObjToTabDetails.get('FGM_Base__Grantee_Report__c').lstInternalTabs = result;
                                            else
                                            {
                                                var grtab = {};
                                                grtab.lstInternalTabs = [];
                                                mapObjToTabDetails.set('FGM_Base__Grantee_Report__c',grtab);
                                                mapObjToTabDetails.get('FGM_Base__Grantee_Report__c').lstInternalTabs = result;
                                            }
                                              mapObjToTabDetails.get('FGM_Base__Grantee_Report__c').lstInternalTabs = result;
                                              for(var b = 0 ; b < result.length; b ++)
                                              {
                                                  if(result[b].tabLabel == $scope.datatableTranslations.openTabLabel)
                                                      $scope.mapOpenRelatatedRecords = result[b].data.mapRelatedRecords;
                                                  else if(result[b].tabLabel == $scope.datatableTranslations.closeTabLabel) 
                                                      $scope.mapCloseRelatatedRecords = result[b].data.mapRelatedRecords;       
                                              }
                                            for(var a = 0 ; a <  tab.lstInternalTabs.length ; a++)
                                            {
                                                  for(var i = 0 ; i < tab.lstInternalTabs[a].data.records.length ; i ++)
                                                  {
                                                      if(tab.lstInternalTabs[a].tabLabel == $scope.datatableTranslations.openTabLabel)
                                                      {
                                                          if($scope.mapOpenRelatatedRecords[tab.lstInternalTabs[a].data.records[i].record.Id]!=undefined)
                                                                tab.lstInternalTabs[a].data.records[i].relatedRecords = $scope.mapOpenRelatatedRecords[tab.lstInternalTabs[a].data.records[i].record.Id];
                                                           else
                                                               tab.lstInternalTabs[a].data.records[i].relatedRecords = [];
                                                      }
                                                  }
                                            }
                                            $scope.mapRelatedRecords = result[0];
                                            $scope.currentTab = $scope.tabs.lstTabs[0];
                                            $scope.selectedTab($scope.currentTab);
                                            }
                                            else if(event.type == 'exception')
                                            {
                                                var messageWrapper = JSON.parse(event.message); 
                                                $scope.exception.Text = messageWrapper.userMessage;
                                                $scope.exception.Title = messageWrapper.messageType.charAt(0).toUpperCase() + messageWrapper.messageType.slice(1);
                                                $scope.exception.Type = messageWrapper.messageType;
                                                $scope.exception.timeToLive = 3000;
                                                $scope.$parent.showPageMessage(true);
                                                if(document.getElementsByClassName('slds-spinner_container')!=undefined && document.getElementsByClassName('slds-spinner_container').length>0)
                                                    document.getElementsByClassName('slds-spinner_container')[0].setAttribute('class','slds-hide');
                                                $scope.$parent.$apply();
                                            } 

                                        
                                         $scope.isLoading = false;
                                    });  
                                    $scope.$apply();
                                }
                                else if(event.type == 'exception')
                                {
                                    var messageWrapper = JSON.parse(event.message); 
                                    $scope.exception.Text = messageWrapper.userMessage;
                                    $scope.exception.Title = messageWrapper.messageType.charAt(0).toUpperCase() + messageWrapper.messageType.slice(1);
                                    $scope.exception.Type = messageWrapper.messageType;
                                    $scope.exception.timeToLive = 3000;
                                    $scope.$parent.showPageMessage(true);
                                    if(document.getElementsByClassName('slds-spinner_container')!=undefined && document.getElementsByClassName('slds-spinner_container').length>0)
                                        document.getElementsByClassName('slds-spinner_container')[0].setAttribute('class','slds-hide');
                                    $scope.$parent.$apply();
                                } 
                            });
                      }
                      else if(event.type == 'exception')
                      {
                          var messageWrapper = JSON.parse(event.message); 
                          $scope.exception.Text = messageWrapper.userMessage;
                          $scope.exception.Title = messageWrapper.messageType.charAt(0).toUpperCase() + messageWrapper.messageType.slice(1);
                          $scope.exception.Type = messageWrapper.messageType;
                          $scope.exception.timeToLive = 3000;
                          $scope.$parent.showPageMessage(true);
                          if(document.getElementsByClassName('slds-spinner_container')!=undefined && document.getElementsByClassName('slds-spinner_container').length>0)
                              document.getElementsByClassName('slds-spinner_container')[0].setAttribute('class','slds-hide');
                          $scope.$parent.$apply();
                      } 
                  });
                }
                for(var i=0 ; i<=$scope.tabs.lstTabs.length ; i++)
                {   
                    if($scope.tabs.lstTabs[i]!=undefined)
                    {
                        mapObjToTabDetails.set($scope.tabs.lstTabs[i].tabName, $scope.tabs.lstTabs[i]);
                    }
                }
                $scope.getOpportunityData();
                
                $scope.delete = function (record)
                {
                    Visualforce.remoting.Manager.invokeAction('FGM_Portal.CommunityDashboardController.deleteRecord',record, function(result, event) 
                                                              {
                                                                  if(result)
                                                                  {
                                                                      if(currentObject == 'Opportunity' || currentObject == 'FGM_Base__Grantee_Report__c')
                                                                      {
                                                                          $scope.renderRlcTable = true;
                                                                          $scope.isInboxTab = false;
                                                                          $scope.isLoading = true;
                                                                          $scope.currentTab.isSelected = true;
                                                                          $scope.getOpportunityData();
                                                                          setTimeout(function() {
                                                                              $scope.renderRlcTable = true;
                                                                              $scope.isLoading = false;
                                                                              $scope.$apply();
                                                                          },50);
                                                                      } 
                                                                      else
                                                                          $scope.selectedTab(mapObjToTabDetails.get(currentObject));
                                                                  }
                                                                  else if(event.type == 'exception')
                                                                  {
                                                                      var messageWrapper = JSON.parse(event.message); 
                                                                      $scope.$parent.messageWrapper = {};
                                                                      $scope.$parent.messageWrapper.Text = messageWrapper.userMessage;
                                                                      $scope.$parent.messageWrapper.Title = messageWrapper.messageType.charAt(0).toUpperCase() + messageWrapper.messageType.slice(1);
                                                                      $scope.$parent.messageWrapper.Type = messageWrapper.messageType;
                                                                      $scope.$parent.messageWrapper.timeToLive = 3000;
                                                                      $scope.$parent.showPageMessage(true);
                                                                      if(document.getElementsByClassName('slds-spinner_container')!=undefined && document.getElementsByClassName('slds-spinner_container').length>0)
                                                                          document.getElementsByClassName('slds-spinner_container')[0].setAttribute('class','slds-hide');
                                                                      $scope.$parent.$apply();
                                                                  } 
                                                              });
                }
                $scope.confirmDelete = function (record) {
                    var txt;
                    if (confirm("Are you sure to delete !")) {
                        $scope.delete(record);
                    } 
                    else 
                    {
                       isDeletable = false;
                        $scope.selectedDataItem.recordMode = '';
                    }
                }
               
                var fromActonFunction = false;
                var flag = false;
                $scope.$watch('selectedDataItem.recordMode' , function(newVal , oldVal){
                    if(newVal == 'DELETE' || newVal == 'GRDELETE')
                    {
                        $scope.confirmDelete($scope.selectedDataItem.record[0].Id);
                        //$scope.selectedTab($scope.selectedDataItem.record[0].tab);
                    }
                        
                    if(newVal == 'EDIT' || newVal == 'VIEW' || newVal == 'GRVIEW' || newVal == 'GREDIT'){
                        isToRenderAsForm = true;
                        for(var i = 0 ; i < $scope.selectedDataItem.tab.data.records.length ; i ++){
                            if($scope.selectedDataItem.tab.data.records[i].record.Id == $scope.selectedDataItem.record[0].Id){
                                rltIndex = i;
                            }
                        }
                        fromActonFunction = true;
                        $scope.navigateToRecord($scope.selectedDataItem.record[0], newVal);
                    }
                    if(newVal == 'AMMEND')
                    {
                        if(confirm($scope.datatableTranslations.confirmAmendment))
                            $scope.createAmendment($scope.selectedDataItem.record[0].Id);
                        else
                        {
                            $scope.selectedDataItem.recordMode = '';
                            $scope.$parent.$parent.showPageMessage(false);
                        }
                            
                    }
                });
        
                $scope.createAmendment = function(requestId)
                {
                    Visualforce.remoting.Manager.invokeAction('FGM_Portal.CommunityDashboardController.saveAmendmentRecord',requestId, function(result, event) 
                                                              {
                                                                  if(result!=null)
                                                                  {
                                                                      var parser = new DOMParser;
                                                                      var amendUrl = parser.parseFromString(
                                                                          '<!doctype html><body>' +  result,
                                                                          'text/html');
                                                                      if(sforce.one == undefined)
                                                                        top.location.href  = amendUrl.body.textContent;
                                                                      else
                                                                        sforce.one.navigateToURL(amendUrl.body.textContent, true);
                                                                  }
                                                                  else if(event.type == 'exception')
                                                                  { 
                                                                      var messageWrapper = JSON.parse(event.message)
                                                                      $scope.selectedDataItem.recordMode = '';
                                                                      $scope.$parent.messageWrapper.Text = messageWrapper.userMessage;
                                                                      $scope.$parent.messageWrapper.Title = messageWrapper.messageType.charAt(0).toUpperCase() + messageWrapper.messageType.slice(1);
                                                                      $scope.$parent.messageWrapper.Type = messageWrapper.messageType;
                                                                      $scope.$parent.messageWrapper.timeToLive = 3000;
                                                                      $scope.$parent.showPageMessage(true);
                                                                      if(document.getElementsByClassName('slds-spinner_container')!=undefined && document.getElementsByClassName('slds-spinner_container').length>0)
                                                                          document.getElementsByClassName('slds-spinner_container')[0].setAttribute('class','slds-hide');
                                                                      $scope.$parent.$apply();
                                                                  } 
                                                              });
                }
                $scope.navigateToRecord = function(record, mode)
                {
                    if(sforce.one!=undefined)
                    {
                      if(mode == 'EDIT' || mode == 'GREDIT')
                        sforce.one.navigateToURL(record.EditUrl,false)
                      if(mode == 'VIEW' || mode == 'GRVIEW')
                        sforce.one.navigateToURL(record.ViewUrl,false)
                    }
                    else
                    {
                        if(mode == 'EDIT' || mode == 'GREDIT')
                            top.location.href = record.EditUrl;
                        if(mode == 'VIEW' || mode == 'GRVIEW')
                            top.location.href = record.ViewUrl;
                    }
                   
                } 
                $scope.getActivityHistoryData = function(showTable)
                {
                    Visualforce.remoting.Manager.invokeAction('FGM_Portal.CommunityDashboardController.getActivityHistoryData',function(result, event) 
                                                              {
                                                                  if(result!=null)
                                                                  {
                                                                      $scope.activityData = result;
                                                                      var unreadCount = 0;
                                                                      for(var i = 0; i < $scope.activityData.length; i++)
                                                                      {
                                                                        if($scope.activityData[i].activity.ActivityDate){
                                                                            $scope.activityData[i].activity.ActivityDate = moment.utc($scope.activityData[i].activity.ActivityDate).format('MMM D, Y');
                                                                        }
                                                                        if($scope.activityData[i].mailStatus == 'unread')
                                                                            unreadCount++;                                                                      
                                                                      }
                                                                      mapObjToTabDetails.get('Contact').badgeCount = unreadCount;
                                                                      $scope.isLoading = false;
                                                                      //$('#tblEmailList').dataTable().draw();
                                                                      $scope.$apply();
                                                                      //}

                                                                      if(showTable!=undefined && showTable && showDataTableFlg)
                                                                        $scope.showDataTable();

                                                                  }
                                                                  else if(event.type == 'exception')
                                                                  {
                                                                      var messageWrapper = JSON.parse(event.message); 
                                                                      $scope.$parent.messageWrapper = {};
                                                                      $scope.$parent.messageWrapper.Text = messageWrapper.userMessage;
                                                                      $scope.$parent.messageWrapper.Title = messageWrapper.messageType.charAt(0).toUpperCase() + messageWrapper.messageType.slice(1);
                                                                      $scope.$parent.messageWrapper.Type = messageWrapper.messageType;
                                                                      $scope.$parent.messageWrapper.timeToLive = 3000;
                                                                      $scope.$parent.showPageMessage(true);
                                                                      if(document.getElementsByClassName('slds-spinner_container')!=undefined && document.getElementsByClassName('slds-spinner_container').length>0)
                                                                          document.getElementsByClassName('slds-spinner_container')[0].setAttribute('class','slds-hide');
                                                                      $scope.$parent.$apply();
                                                                  } 
                                                              });    
                }
                $scope.showDataTable = function ()
                {
                    if(flag)
                       showDataTableFlg = false;
                    jQuery.noConflict();
                    if ( $.fn.DataTable.isDataTable('#tblEmailList') ) 
                    {
                        $('#tblEmailList').DataTable().clear();
                        //$('#tblEmailList').DataTable().destroy();
                        $('#tblEmailList').DataTable().draw()
                    }
                    else
                    {
                        $('#tblEmailList').DataTable({
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
                                },
                                    "bJQueryUI" :false,
                                    "destroy": true,
                                    "columns":{
                                        "defaultContent" : '',
                                        "bSortable": false, 
                                        "aTargets": [ 0,1 ] 
                                    },
                                
                            }
                        });
                        setTimeout(function(){
                          $('#tblEmailList').DataTable().draw();
                        },500);                         
                     }
                }
                $scope.showSelectedTabRecords = function(tab)
                {
                    if(tab!==undefined)
                    {
                        $scope.isInbox = true;
                        $scope.renderRlcTable = false;
                        $scope.data = {};
                        $scope.configuration ={};
                        $scope.selectedDataItem = {};
                        $scope.selectedDataItem.record = [];
                        $scope.data.record = tab.data.records ;
                        $scope.data.isEditable = true;
                        $scope.data.isDeletable = true;
                        $scope.data.isAmendable =true;          
                        $scope.configuration.aplicationDesignerConfiguration = {};
                        $scope.configuration.aplicationDesignerConfiguration.Actions = {}
                        $scope.configuration.aplicationDesignerConfiguration.Actions.BulkDelete = false;
                        if(tab.tabLabel == $scope.datatableTranslations.openTabLabel)
                        {  
                            $scope.configuration.aplicationDesignerConfiguration.Actions.isDelete = true; ;
                            $scope.configuration.aplicationDesignerConfiguration.Actions.isEdit = true ;
                            $scope.configuration.aplicationDesignerConfiguration.Actions.isView = true;
                            if(tab.tabName == 'Opportunity') {
                                $scope.configuration.aplicationDesignerConfiguration.Actions.isAmendable = amendmentEnabled;
                            }
                        }
                        else
                        {
                            $scope.configuration.aplicationDesignerConfiguration.Actions.isDelete = false; ;
                            $scope.configuration.aplicationDesignerConfiguration.Actions.isEdit = false ;
                            $scope.configuration.aplicationDesignerConfiguration.Actions.isView = true;
                        }
                        
                        $scope.configuration.aplicationDesignerConfiguration.columns = [];
                        $scope.configuration.aplicationDesignerConfiguration.granteeReportColumns = [];
                        
                        
                        var lstLabel = tab.lstFieldLabels;
                        var lstApiName = tab.lstFieldNames;
                        
                        for (var index  = 0 ; index < lstApiName.length ; index ++){
                            var obj = {};
                            obj.apiName = lstApiName[index];
                            obj.label = lstLabel[index];
                            obj.isSort = true;
                            obj.isSearch = true;
                            $scope.configuration.aplicationDesignerConfiguration.columns.push(obj);
                            
                        }
                        var relatedTab = $scope.mapRelatedRecords;
                        if(relatedTab!=null || relatedTab!=undefined)
                        {
                            var lstGRFieldLabel =relatedTab.lstFieldLabels;
                            var lstGRFieldApiName = relatedTab.lstFieldNames;
                            
                            for (var index  = 0 ; index < lstGRFieldApiName.length ; index ++)
                            {
                                var obj = {};
                                obj.data = lstGRFieldApiName[index];
                                obj.title = lstGRFieldLabel[index];
                                obj.isSort = true;
                                obj.isSearch = true;
                                obj.defaultContent = '';
                                $scope.configuration.aplicationDesignerConfiguration.granteeReportColumns.push(obj);
                            }
                        }

                        if(languageSpecifications != undefined){
                          $scope.configuration.currency = languageSpecifications.symbol;
                          $scope.configuration.dateFormat = languageSpecifications.date_format;
                          $scope.configuration.timeFormat = languageSpecifications.time_format;
                          $scope.configuration.dateTimeFormat = languageSpecifications.date_time_format;                      
                        }
                        else{    
                          $scope.configuration.currency = '$';
                          $scope.configuration.dateFormat = 'DD/MM/YYYY';
                          $scope.configuration.timeFormat = 'hh:mm A';
                          $scope.configuration.dateTimeFormat = "DD/MM/YYYY  hh:mm A";
                        }
                        $scope.configuration.offSet = $scope.tabs.userTimeOffset;
                        $scope.configuration.schema = tab.schema;
                        var parentSchema = $filter('filter')(tab.schema.fieldSets, { nameSpace: 'FGM_Portal'})[0];
                        var childSchema = $filter('filter')(tab.childSchema.fieldSets, { nameSpace: 'FGM_Portal'})[0];
                        $scope.configuration.schema.fieldDetails = parentSchema.fieldSetMembers;
                        $scope.configuration.childSchema = {};
                        $scope.configuration.childSchema.fieldDetails = childSchema.fieldSetMembers;
                        $scope.configuration.tab = tab;
                        $scope.configuration.mode = 'Edit';
                        $scope.selectedDataItem.recordMode = '' ;
                        
                        setTimeout(function() {
                            $scope.renderRlcTable = true;
                            $scope.isLoading = false;
                            $scope.$apply();
                        },100);
                    }
                }
               
                $scope.selectedTab = function(tab)
                {
                    currentObject = tab.tabName;
                    if(currentObject == 'Contact'){
                        flag = true;
                    }
                    else
                        showDataTableFlg = true;
                    $scope.isLoading = true;
                    $scope.renderRlcTable = true;
                    $scope.currentTab = mapObjToTabDetails.get(tab.tabName);
                    $scope.currentTab.isSelected = false;
                    $scope.granteeReportColumns = [];
                    $scope.$parent.$parent.showPageMessage(false);
                    if(tab.tabDetails==undefined)
                    {    
                        if(tab.tabName == 'Contact')
                        {
                            $scope.isInboxTab = true;
                            $scope.renderRlcTable = false;
                            $scope.getActivityHistoryData(true);
                        }
                        else if (tab.tabName == 'Opportunity' || tab.tabName == 'FGM_Base__Grantee_Report__c')
                        {
                            $scope.renderRlcTable = true;
                            $scope.isInboxTab = false;
                            $scope.isLoading = true;
                            $scope.currentTab.isSelected = true;
                            $scope.showSelectedTabRecords(mapObjToTabDetails.get(tab.tabName).lstInternalTabs[0]);
                            setTimeout(function() {
                                $scope.renderRlcTable = true;
                                $scope.isLoading = false;
                                $scope.$apply();
                            },100); 
                        }
                        else
                        {
                            $scope.renderRlcTable = true;
                            $scope.isInboxTab = false;
                            Visualforce.remoting.Manager.invokeAction('FGM_Portal.CommunityDashboardController.getData',tab.tabName,$scope.oppIds,$scope.oppOwners,pageLanguage, function(result, event) 
                            {
                                if(result!=null)
                                {
                                    for(var i = 0;i<result.length; i ++)
                                    {
                                        if(result[i].tabLabel == 'Open Tab')
                                            result[i].tabLabel = $scope.datatableTranslations.openTabLabel;
                                        else if(result[i].tabLabel == 'Close Tab')
                                            result[i].tabLabel = $scope.datatableTranslations.closeTabLabel;
                                    }
                                    $scope.isLoading = false;
                                    tab.lstInternalTabs = result;
                                    $scope.currentTab.isSelected = true;
                                    $scope.showSelectedTabRecords(tab.lstInternalTabs[0]);
                                    $scope.$apply();
                                }
                                else if(event.type == 'exception')
                                {
                                    var messageWrapper = JSON.parse(event.message); 
                                    $scope.exception.Text = messageWrapper.userMessage;
                                    $scope.exception.Title = messageWrapper.messageType.charAt(0).toUpperCase() + messageWrapper.messageType.slice(1);
                                    $scope.exception.Type = messageWrapper.messageType;
                                    $scope.exception.timeToLive = 3000;
                                    $scope.$parent.showPageMessage(true);
                                    if(document.getElementsByClassName('slds-spinner_container')!=undefined && document.getElementsByClassName('slds-spinner_container').length>0)
                                        document.getElementsByClassName('slds-spinner_container')[0].setAttribute('class','slds-hide');
                                    $scope.$parent.$apply();
                                } 
                            });
                        }
                    }
                    if(document.getElementsByClassName('slds-spinner_container')!=undefined && document.getElementsByClassName('slds-spinner_container').length>0)
                        document.getElementsByClassName('slds-spinner_container')[0].setAttribute('class','slds-hide');
                }
                
            }
          };
});