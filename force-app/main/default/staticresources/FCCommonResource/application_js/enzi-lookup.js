angular.module('enzi-lookup', [])
.controller('testEnziLookup', ['$scope', function ($scope) {
    //$scope.records = [{ Id: 1, Name: 'Test 1' }, { Id: 2, Name: 'Test 2' }, { Id: 3, Name: 'Test 3' }, { Id: 4, Name: 'Test 4' }];
    //$scope.selected = $scope.records[2];
    $scope.getdata = function (onsuccess) {
        $scope.records = [{ Id: 1, Name: 'Test 1' }, { Id: 2, Name: 'Test 2' }, { Id: 3, Name: 'Test 3' }, { Id: 4, Name: 'Test 4' }];
        $scope.selected = $scope.records[2];
        onsuccess($scope.records, $scope.selected);
    }

    $scope.onselected = function (record) {
        alert(record.Name);
    }
}])
.directive('enziLookup', function () {
    var enziLookup = {
        scope:{
            ontxtchange: '&',
            onselect: '&',
            records: '=',
            template: '@',
            label: '@',
            key: '@',
            styleClass: '@class',
            placeholder: '@',
            ngModel: '=ngModel',
            disabled: '='
        },
        styles: '<style>.autocomplete{position: relative;} .autocomplete input.focussed + .datalist{display:block;} .datalist{display: none;position: absolute; left: 0; top: 35px; z-index: 10000;max-height: 300px;overflow-y: scroll;} .list-group-item {min-width: 200px;} .list-group-item{}</style>',
        templateInternal: '\
            <div class="autocomplete" id="{{lookupId}}" ><input ng-disabled="disabled" class="slds-input slds-combobox__input search form-control search-textbox" placeholder="{{placeholder}}" type="text" ng-model="enziLookup.enteredtext.{{lookupId}}" ng-change="enziLookup.onChange()"  ng-model-options="{ debounce : 500 }" ng-focus="enziLookup.onfocus($event)"\
            ng-blur="enziLookup.onblur($event)" ng-keydown="enziLookup.onkeydown($event)" />\
                <div class="datalist list-group slds-input slds-combobox__input">\
                    <a class="list-group-item eziLookup" style="text-decoration:none;" ng-hide="modelRecords && modelRecords.length" >No records found</a>\
                    <a class="list-group-item eziLookup" style="text-decoration:none;" ng-click="enziLookup.onclick(r, $event)" id="r[key]" ng-class="{active: enziLookup.selectedIndex.{{lookupId}} == $index}" href="#"\
                    ng-mouseover="enziLookup.onitemmouseover($event, $index)" ng-mouseout="enziLookup.onitemmouseout($event)" ng-show="records && records.length" ng-repeat="r in modelRecords" >{{{{attrs.labeltemplate}}}}</a>\
                </div>\
            </div>',
        controller: ['$scope', '$filter', '$rootScope', '$attrs', '$element', '$compile', function ($scope, $filter, $rootScope, $attrs, $element, $compile) {
            var template = enziLookup.templateInternal;
            if (!$scope.enziLookup) {
                template = enziLookup.styles + enziLookup.templateInternal;
                $scope.enziLookup = {
                    enteredtext: {},
                    attrs: {},
                    selectedIndex: {},
                    setSelected: function (id, elementId) {
                        if (id && $scope.records) {
                            var matchedRecords = $filter('filter')($scope.records, { Id: id }, 'strict');
                            if (matchedRecords.length > 0) {
                                $scope.enziLookup.enteredtext[elementId] = matchedRecords[0][$scope.enziLookup.attrs[elementId].label];
                                //$scope.onselect({ Id: matchedRecords[0].Id });
                                if ($scope[$scope.enziLookup.attrs[elementId].ngModel])
                                    $scope[$scope.enziLookup.attrs[elementId].ngModel] = id;
                                else
                                    eval("$scope.$parent." + $scope.enziLookup.attrs[elementId].ngModel + "='" + id + "'");
                                $scope.onselect({ Id: matchedRecords[0].Id });
                            }
                        }
                    },
                    onChange: function (event) {
                        angular.forEach($scope.enziLookup.enteredtext, function (value, key) {
                            $scope.ontxtchange({ searchText: value });
                            if (!value) {
                                eval("$scope.$parent." + $scope.enziLookup.attrs[key].ngModel + "=''");
                                $scope.onselect({ Id: '' });
                            }
                        });
                    },
                    onfocus: function (event) { $(event.target).addClass('focussed'); },
                    onblur: function (event) {
                        setTimeout(function () { $(event.target).removeClass('focussed') }, 200);
                    },
                    onkeydown: function (event) {
                        $(event.target).addClass('focussed');
                        switch (event.keyCode) {
                            //Down key
                            case 40:
                                var lookupId = $(event.target).parents('.autocomplete').attr('id');
                                var recordCount = $filter('filter')($scope.records, $scope.enziLookup.enteredtext[lookupId]).length;
                                if ($scope.enziLookup.selectedIndex[lookupId] < recordCount - 1)
                                    ++$scope.enziLookup.selectedIndex[lookupId];
                                else
                                    $scope.enziLookup.selectedIndex[lookupId] = recordCount - 1;
                                event.preventDefault();
                                break;
                                //Up key
                            case 38:
                                var lookupId = $(event.target).parents('.autocomplete').attr('id');
                                var recordCount = $filter('filter')($scope.records, $scope.enziLookup.enteredtext[lookupId]).length;
                                if ($scope.enziLookup.selectedIndex[lookupId] > 0)
                                    --$scope.enziLookup.selectedIndex[lookupId];
                                event.preventDefault();
                                break;
                                //Enter key
                            case 13:
                                $(event.target).removeClass('focussed');
                                var lookupId = $(event.target).parents('.autocomplete').attr('id');
                                var record = $filter('filter')($scope.records, $scope.enziLookup.enteredtext[lookupId])[$scope.enziLookup.selectedIndex[lookupId]];
                                $scope.enziLookup.setSelected(record[$scope.enziLookup.attrs[lookupId].key], lookupId);
                                event.preventDefault();
                                break;
                        }
                    },

                    onclick: function (record, event) {
                        $scope.onClickFlag = true;
                        event.preventDefault();
                        var lookupId = $(event.target).parents('.autocomplete').attr('id');
                        $scope.enziLookup.setSelected(record[$scope.key], lookupId);
                        $scope.$parent.searchText = record.Name;
                    },

                    onitemmouseover: function (event, index) {
                        var lookupId = $(event.target).parents('.autocomplete').attr('id');
                        $scope.enziLookup.selectedIndex[lookupId] = index;
                    },

                    onitemmouseout: function (event) {
                    },
                }
            }
            if (!$scope.records || !$scope.label || !$scope.key) {
                console.error('Attributes [records, label, key] are required.');
                return;
            }

            template = template.replace('{{attrs.labeltemplate}}', ($attrs.template) ? $attrs.template : 'r.' + $attrs.label);

            var lookupId = 'k' + Math.random(36).toString().substr(2, 9);
            var find = RegExp('{{lookupId}}', 'g');
            template = template.replace(find, lookupId);
            $scope.enziLookup.enteredtext[lookupId] = '';
            $scope.enziLookup.attrs[lookupId] = $attrs;
            $scope.enziLookup.selectedIndex[lookupId] = -1;

            var element = angular.element(template);
            $element.append(element);
            $compile(element)($scope);

            $scope.originalRecords = [];
            $scope.$watch('records', function (newValue, oldValue) {
                $scope.enziLookup.setSelected($scope.ngModel, lookupId);
                $scope.modelRecords = angular.copy($scope.records);
            }, true)
            
            $scope.$watch('ngModel', function (newValue, oldValue) {
                if (!$scope.onClickFlag)
                    $scope.enziLookup.setSelected(newValue, lookupId);
                $scope.onClickFlag = false;
            }, true)

            $scope.$watch('enziLookup.enteredtext.' + lookupId + '', function (newValue, oldValue) {
                if (!newValue) {
                    $scope.enziLookup.enteredtext[lookupId] = '';
                    $scope.modelRecords = angular.copy($scope.records);
                }
                else {
                    $scope.modelRecords = $filter('filter')($scope.records, newValue);
                }
            }, true)
        }]
    }
    return enziLookup;
})