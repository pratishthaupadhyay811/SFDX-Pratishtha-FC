var inboxApp = angular.module('inboxApp',['messageApp','ngSanitize']);
inboxApp.config(function($sceDelegateProvider){
    var baseUrl = window.location.protocol + '//' + window.location.host + '/**';
    $sceDelegateProvider.resourceUrlWhitelist([
        'https://localhost/**',
        baseUrl
    ]);
});
inboxApp.directive("inboxComponent", function() 
                  {
        return {
            restrict: 'EA',
            scope :{
                activities : '=',
                inboxTranslations : '='
            },
            templateUrl : staticResourcePath + '/application_js/templates/inbox-template.html',
            link : function($scope, element, attr )
            {
                $scope.isDetail = false;
                $scope.showcontent =  function(d)
                {
                    console.log($scope.activities[d]);
                    Visualforce.remoting.Manager.invokeAction('FGM_Portal.CommunityDashboardController.setEmailContent',$scope.activities[d].activity.Id,$scope.activities[d].mailStatus, function(result, event) 
                                                              {
                                                                    if(result!=null)
                                                                    {
                                                                            $scope.isDetail = true;
                                                                            $scope.details = result;
                                                                            $scope.$apply();
                                                                            setTimeout(function() {
                                                                        },80);
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
                }
                $scope.backToEmails = function()
                {
                    showDataTableFlg = true;
                    $scope.isDetail = false;
                    setTimeout(function() {
                        $scope.$apply();
                        $scope.$parent.getActivityHistoryData(true);
                    },80);
                }
                $scope.ComposeMail = function() 
                { 
                     Visualforce.remoting.Manager.invokeAction('FGM_Portal.CommunityDashboardController.ComposeMail', function(result, event) 
                                                              {
                                                                  if(result!=null)
                                                                  {
                                                                      if(sforce.one!=undefined)
                                                                      {
                                                                        sforce.one.navigateToUrl(result,true);
                                                                      }
                                                                      else
                                                                        top.location.href = result;
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
                }
                $scope.enableDelete = function() 
                {
                    if ($('input[id$=chkId]:checked').length > 0) {
                        $("[id$='btnDelMsg']").prop("disabled", false);
                        $("[id$='btnDelMsg']").css({ "opacity": "1", "cursor": 'pointer' });
                    } else {
                        $("[id$='btnDelMsg']").prop("disabled", true);
                        $("[id$='btnDelMsg']").css("opacity", 0.4);
                    }
                    return false;
                } 
                $scope.deleteMessage = function() 
                {
                    if ($('input[id$=chkId]').length > 0) 
                    { 
                        if (confirm('Are you sure you want to delete message(s)')) 
                        {
                            var checkid = [];
                            $('input[id$=chkId]').each(function (index, val) {
                                if ($(val).prop('checked') == true) {
                                    checkid.push($(val).attr('class'));
                                }
                            });
                            if (checkid.length > 0) {
                                Visualforce.remoting.Manager.invokeAction('FGM_Portal.CommunityDashboardController.delMessage',JSON.stringify(checkid), function(result, event) 
                                                                          {
                                                                              if(event.type == 'exception')
                                                                              {
                                                                                  $scope.messageWrapper = {};
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
                                                                              else
                                                                                  $scope.$parent.getActivityHistoryData(false);
                                                                          });    
                            }
                            return true;
                        }
                        else {
                            $("input[type='checkbox']").prop('checked', false);
                            $("[id$='btnDelMsg']").attr("disabled", !checkboxes.is(":checked"));
                            $("[id$='btnDelMsg']").css({ "opacity": "0.4", "cursor": 'pointer' });
                            return false;
                        }
                    }
                    return false;
               }
            }
                };
            });
inboxApp.service('$InboxComponentInitializeSettings' ,function(){
        var serviceHandle = this;
        serviceHandle.initializeInboxTranslation = function (FromHeaderLabel,subjectHeaderLabel,dateheaderLabel, printButtonLabel,composeMessageLabel,deleteButtonlabel,backButtonLabel)
        {
            var translation = {};
            translation.FromHeaderLabel = FromHeaderLabel;
            translation.subjectHeaderLabel = subjectHeaderLabel;
            translation.dateheaderLabel = dateheaderLabel;
            translation.printButtonLabel = printButtonLabel;
            translation.composeMessageLabel = composeMessageLabel;
            translation.deleteButtonlabel = deleteButtonlabel;
            translation.backButtonLabel = backButtonLabel;
            return translation;
        }
    });