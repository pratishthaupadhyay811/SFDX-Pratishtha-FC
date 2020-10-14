var dashboardApp = angular.module('dashboardApp',['tablistApp','datatableApp','inboxApp','messageApp']);
dashboardApp.config(function($sceDelegateProvider){
    var baseUrl = window.location.protocol + '//' + window.location.host + '/**';
    $sceDelegateProvider.resourceUrlWhitelist([
        'https://localhost/**',
        baseUrl
    ]);
});
dashboardApp.controller('dashboardAppController',['$scope','$InboxComponentInitializeSettings','$dtTableInitializeSettings', function($scope,$InboxComponentInitializeSettings,$dtTableInitializeSettings)
                                               {
                                                   Visualforce.remoting.Manager.invokeAction('FGM_Portal.CommunityDashboardController.initializeDashboard',pageLanguage,function(result, event) 
                                                                                             {
                                                                                                 $scope.showMessageComponent=false;
                                                                                                 $scope.messageWrapper = {};
                                                                                                 $scope.messageWrapper.Text = '';
                                                                                                 $scope.messageWrapper.Title = '';
                                                                                                 $scope.messageWrapper.Type = 'error';
                                                                                                 $scope.messageWrapper.timeToLive = 0;
                                                                                                 
                                                                                                 if(result!=null)
                                                                                                 {
                                                                                                     $scope.isTabsRecieved = true;
                                                                                                     $scope.tabList = result;                                                  var parser = new DOMParser;
                                                                                                     
                                                                                                     for(var index = 0 ; index < $scope.tabList.lstTabs.length ; index ++)
                                                                                                     {
                                                                                                         var tabLabel = parser.parseFromString(
                                                                                                             '<!doctype html><body>' +  $scope.tabList.lstTabs[index].tabLabel,
                                                                                                             'text/html');
                                                                                                         
                                                                                                         $scope.tabList.lstTabs[index].tabLabel = tabLabel.body.textContent;
                                                                                                     }

                                                                                                     $scope.$apply();
                                                                                                 }
                                                                                                 else
                                                                                                 {
                                                                                                     if(event.type == 'exception')
                                                                                                     {
                                                                                                         var messageWrapper = JSON.parse(event.message);                                                         
                                                                                                         $scope.showMessageComponent=true;
                                                                                                         $scope.messageWrapper.Text = messageWrapper.userMessage;
                                                                                                         $scope.messageWrapper.Title = messageWrapper.messageType.charAt(0).toUpperCase() + messageWrapper.messageType.slice(1);
                                                                                                         $scope.messageWrapper.Type = messageWrapper.messageType;
                                                                                                         $scope.messageWrapper.timeToLive = 3000;
                                                                                                         $scope.showPageMessage(true); 
                                                                                                         if(document.getElementsByClassName('slds-spinner_container')!=undefined && document.getElementsByClassName('slds-spinner_container').length>0)
                                                                                                             document.getElementsByClassName('slds-spinner_container')[0].setAttribute('class','slds-hide');
                                                                                                         $scope.$apply();
                                                                                                     } 
                                                                                                 }
                                                                                             });
                                                   
                                                   $scope.inboxTranslations = $InboxComponentInitializeSettings.initializeInboxTranslation(FromHeaderLabel,subjectHeaderLabel,dateheaderLabel, printButtonLabel,composeMessageLabel,deleteButtonlabel,backButtonLabel,firstLabel,lastLabel);
                                                   $scope.datatableTranslations = $dtTableInitializeSettings.initializeTranslation(openTabLabel,closeTabLabel,editLinkLable, viewLinkLabel,deleteLinkLabel,amendLinkLabel,emaptyPaginationFooter,paginationHeader,paginationFooter,SearchLabel,datatableFilterLabel,emaptytableLabel,nextLinkLabel, previousLinklabel,confirmAmendment,firstLabel,lastLabel,picklistDefaultValueAll)
                                                   $scope.showPageMessage = function (showMessage)
                                                   {
                                                       $scope.showMessageComponent = showMessage;
                                                   }
                                               }]);