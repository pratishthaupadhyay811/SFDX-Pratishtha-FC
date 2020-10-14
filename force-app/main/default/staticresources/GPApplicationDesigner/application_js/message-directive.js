var messageApp = angular.module('messageApp',[]);
messageApp.directive('messageComponent',function($rootScope,$timeout){
            return {
                restrict: 'E',
                scope:{
                    messagewrapper : '=',
                    showMessageAction: '&'
                },
                template: '<div ng-click="showMessageAction()(false)" ng-mouseenter="onMouseEnter($event)" ng-mouseleave="onMouseLeave($event)">\
                                <div id = "messageComp" ng-if="messagewrapper.Type != undefined" class = "slds-box slds-is-fixed messagePositioning borderUnset slds-popover_warning ng-binding ng-scope slds-theme_{{messagewrapper.Type}}">\
                                    <img class="slds-icon slds-icon_small" src="https://www.foundationconnect.org/staticresources/SLDS/icons/standard/{{messagewrapper.Type}}_60.png">\
                                    {{messagewrapper.Title}} :\
                                    {{messagewrapper.Text}}\
                                    <div ng-if="messagewrapper.lstFieldMessage != undefined">\
                                        <ul class="slds-list--dotted slds-text-longform">\
                                            <div ng-repeat="field in messagewrapper.lstFieldMessage">\
                                                <li>\
                                                    {{field}}\
                                                </li>\
                                            </div>\
                                        </ul>\
                                    </div>\
                               </div>\
                           </div>',
                link: function($scope, element, attr )
                {
                    //$scope.ShowMessage = true;
                    if( ($scope.messagewrapper.Type == "warning" || $scope.messagewrapper.Type == "info" || $scope.messagewrapper.Type == "success") && $scope.messagewrapper.timeToLeave != -1 && $scope.messagewrapper.timeToLeave != undefined )
                        $timeout(function() {
                            //$scope.showMessage = false;
                           $scope.showMessageAction()(false);
                        }, $scope.messagewrapper.timeToLeave);

                    if( $scope.messagewrapper.Type == "error" )
                        $timeout(function() {
                            //$scope.showMessage = false;
                           $(".borderUnset").css("opacity", "0.5");
                        }, 3000);

                    $scope.onMouseEnter = function ($event) {
                      $(".borderUnset").css("opacity", "1");
                    };
                    $scope.onMouseLeave = function ($event) {
                      $(".borderUnset").css("opacity", "0.5");
                    };

                    $(document).keyup(function(e) {     
                        if(e.keyCode== 27 && $scope.messagewrapper != undefined) {
                            $scope.showMessageAction()(false);
                        } 
                    });

                }
            }
        });
