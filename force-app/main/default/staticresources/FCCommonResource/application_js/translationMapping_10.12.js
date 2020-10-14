///////////////////////////////////////////////
///                                         ///
///                  opt 1                  ///
///                                         ///
///////////////////////////////////////////////

angular.module("transApp", ['enzi-lookup'])
    .controller("ObjDataTranslateController", function($scope) {
        $scope.lang = { selectedLanguage: false };
        $scope.languageOptions = JSON.parse(JSON_LanguageOptions);
        $scope.fieldsOptions = [];
        //$scope.fieldDescribe = [];
        $scope.selectedObjectName;
        $scope.lstTranslationRecord;
        $scope.selectedTranslationRecord;
        $scope.Index = 1;
        $scope.lstSelectedFields = [];
        $scope.numberOfFieldsSelected = 0;
    })
    .directive("topBar", function() {
        return {
            restrict: 'E',
            template: "<div class='slds-grid slds-grid--vertical-align-center '>\
                        <div class='slds-col--padded slds-size--1-of-6 slds-col--bump-left'>\
                            <select ng-model='selectedObjectName' class='slds-input slds-combobox__input' ng-options='x as x.label for x in objectList track by x.value' ng-change='getRecords();'>\
                                <option value='' selected>Select Object</option>\
                            </select>\
                        </div>\
                        <div class='slds-col--padded slds-size--2-of-6 slds-col--bump-left'>\
                            <div id ='Enzi-lookup' class='slds-combobox__input' style='width:95% padding-left: 5%;'></div>\
                        </div>\
                        <div class='slds-col--padded slds-size--4-of-6 slds-col--bump-right' style='text-align: end;'>\
                            <button type='button' class='slds-button slds-button--success' ng-click='backtofcportalManager()' >  Back to Configuration  </button>\
                        </div>\
                    </div>",
            controller: function($scope, $compile) {
                $scope.objectList = [{
                    label: 'Campaign',
                    value: 'Campaign'
                }, {
                    label: 'Campaign Quiz',
                    value: 'FGM_Portal__Campaign_Quiz__c'
                            }];
                /*, {
                                label: 'Budget Category',
                                value: 'Grantee_Budget_Category__c'
                            }];*/
                $scope.selectedRecordID;
                $scope.selectedRecordName;
                $scope.lookupRecords;
                $scope.selectedlookupRecord;
                $scope.selectedRecordTransationMap;
                $scope.selectedRecordTransationBackupMap = undefined;

                $scope.backtofcportalManager = function() {
                    //console.log(' getFields  selectedObjectName   ' + $scope.selectedObjectName);
                    Visualforce.remoting.Manager.invokeAction(
                        'FGM_Portal.ObjectDataTranslationController.backtofcportalManager',
                        function(result, event) {
                            window.location = result;
                        }
                    );
                };

                $scope.renderRowOne = function() {                    
                    $scope.lang.selectedLanguage = false;
                    if ($('#divTranslationRecord0').children().length < 1) 
                    {
                        $compile($('#divTranslationRecord0').append("<div id='divRec0'><translation-row id='translationRow0' parent-record ='selectedlookupRecord' translation-records ='selectedRecordTransationMap' field-list ='fieldsOptions' selected-language ='lang.selectedLanguage' row-counter=0></translation-row></div>"))($scope);
 
                        if (!$scope.$$phase)
                            $scope.$apply();
                    }
                }

                $scope.getFields = function() {
                    //console.log(' getFields  selectedObjectName   ' + $scope.selectedObjectName);
                    //$('.search.form-control.search-textbox.ng-pristine.ng-valid').val('');
                    if ($scope.selectedObjectName != undefined) {
                        $scope.lstSelectedFields = [];
                        Visualforce.remoting.Manager.invokeAction(
                            'FGM_Portal.ObjectDataTranslationController.getallTextFields',
                            $scope.selectedObjectName.value,
                            function(result, event) {
                                //var tempResult = result;
                                for (var key in result) {
                                    var a = { id: '', label: '', selected: false, disabled: '' };
                                    a.id = angular.copy(key);
                                    a.label = angular.copy(result[key]);
                                    $scope.lstSelectedFields.push(a);
                                }
                                $scope.fieldsOptions = result;

                            }
                        );
                        $scope.renderRowOne();
                    }
                };

                $scope.enziTextChange = function() {
                    console.log(' enziTextChange ');
                    $("[id^=divRec]").remove();
                    $scope.selectedLanguage = undefined;
                    $scope.renderRowOne();
                    $scope.showRow();
                }
                 
                $scope.showRow = function() {
                    console.log(' showRow  $scope.selectedRecordID    ' + $scope.selectedRecordID);

                    //Changes
                    /*$("[id^=divRec]").remove();
                    $scope.selectedLanguage = undefined;
                    $scope.renderRowOne();
                    $('#divTranslation').css("display", "block");*/
                    //Changes

                    if($scope.lookupRecords!=undefined)
                    {
                        for (index = 0; index < $scope.lookupRecords.length; index++) {
                        if ($scope.lookupRecords[index].Id == $scope.selectedRecordID) {
                            $scope.selectedlookupRecord = angular.copy($scope.lookupRecords[index]);
                            $scope.selectedRecordName = $scope.lookupRecords[index].Name;
                            $('#divTranslation').css("display", "block");
                            //console.log('  showRow  $scope.selectedRecordName    ' + $scope.selectedRecordName);
                            break;
                        }
                    } 
                }
                    if ($scope.selectedRecordID != undefined && $scope.selectedObjectName.value != undefined) {
                        Visualforce.remoting.Manager.invokeAction(
                            'FGM_Portal.ObjectDataTranslationController.getAllTranslations',
                            $scope.selectedRecordID,
                            $scope.selectedObjectName.value,
                            function(result, event) {
                                $scope.selectedRecordTransationMap = angular.copy(result);
                                $scope.selectedRecordTransationBackupMap = angular.copy(result);
                                //console.log('  showRow   $scope.selectedRecordTransationMap    ' + $scope.selectedRecordTransationMap);
                                if ($scope.lstSelectedFields.length < 1)
                                    $scope.getFields();
                                $scope.$apply();
                                setTimeout(function() {
                                    $(".spinnerContainer").hide();
                                }, 500);
                            }, {
                                escape: false
                            }
                        );
                        //console.log('  showRow   $scope.selectedRecordID    ' + $scope.selectedRecordID);
                    }


                };

                $scope.getRecords = function() {
                    //console.log('  showRow  selectedObjectName   ' + $scope.selectedObjectName);
                    $('.search.form-control.search-textbox.ng-pristine.ng-valid').val('');
                    if($scope.selectedObjectName!=undefined)
                    {
                        $('#divTranslation').css('display','none');
                        if ($scope.selectedObjectName.value != undefined) {
                        Visualforce.remoting.Manager.invokeAction(
                            'FGM_Portal.ObjectDataTranslationController.getLookUpRecords',
                            $scope.selectedObjectName.value,
                            function(result, event) {
                                $scope.lookupRecords = result;
                                if ($('#Enzi-lookup').children().length < 1) {
                                    $compile($('#Enzi-lookup').append("<div enzi-lookup='' records='lookupRecords' key='Id' label='Name' ng-model='selectedRecordID' onselect='showRow()' ontxtchange='enziTextChange()' placeholder='-- Select Record --'/>"))($scope);
                                }
                                                                
                                $scope.getFields();

                                if (!$scope.$$phase)
                                    $scope.$apply();
                            }, {
                                escape: false
                            }
                        );
                    }
                    }
                };

                $scope.$watch('selectedObjectName', function(newField, oldField) {
                    if (oldField != undefined && newField != oldField) {
                        //console.log(' $watch        selectedObjectName    ' +  $scope.selectedObjectName);
                        $scope.lookupRecords = [];

                    }
                });

                $scope.$watch('selectedRecordID', function(newField, oldField) {
                    if (oldField != undefined && newField != oldField) {
                        //console.log(' $watch        selectedRecordID    ' +  $scope.selectedRecordID);
                    }
                });

                $scope.$watch('lookupRecords',
                    function(newval, oldval) {
                        ////console.log(' $watch        lookupRecords    '  +  $scope.lookupRecords);
                        //alert(' $watch        lookupRecords    '  +  $scope.lookupRecords);
                    }
                );

            }
        };
    })
    .directive("fieldRow", function() {
        return {
            restrict: 'E',
            template: "<div id'=fieldRow' style='padding: 1% 0% 1% 0%;'>\
                        <div id='divTranslation' style='display:none; padding-bottom:1%;'>\
                            <div style='padding-bottom:1%;'>\
                                <div class='slds-grid slds-grid--vertical-align-center' style='padding-bottom:1%;border-bottom: #2195bb;border-bottom-style: solid;border-bottom-width: thin;'>\
                                    <div class='slds-col--padded slds-size--9-of-12 slds-col--bump-left'>\
                                        <label class='slds-page-header__title slds-truncate slds-align-middle' style='color:#2195bb;'>{{selectedRecordName}}</label> \
                                    </div>\
                                    <div class='slds-col--padded slds-col--bump-right' style='text-align: end;'>\
                                        <button type='button' class='slds-button slds-button--success' ng-click='SaveTranslations()' style='padding-left:padding:0% 1% 0% 1%;'>  Save  </button>\
                                        <button type='button' class='slds-button slds-button--brand' ng-click='addNewTranslation()' style='padding:0% 1% 0% 1%;'>  Add New Translation  </button>\
                                    </div>\
                                </div>\
                            </div>\
                            <div id='divTranslationHeader' class='slds-grid slds-grid--vertical-align-center'>\
                                <div class='slds-col slds-size--2-of-12'></div>\
                                <div class='slds-col slds-size--4-of-12' style='padding-top: 0.65%;'  >\
                                    <center style='padding-top: 2%;'>\
                                        <label style='font-size: large;color:#2195bb;'>Source Data</label>\
                                    </center> \
                                </div>\
                                <div class='slds-col slds-size--1-of-12'></div>\
                                <div class='slds-col slds-size--3-of-12'>\
                                    <center style='padding-top: 3%;'>\
                                        <select ng-model='lang.selectedLanguage' class='slds-input slds-combobox__input'  ng-options='id as value for (id, value) in languageOptions | orderBy:value' style='width:60%' >\
                                            <option value='' ng-hide='languageOptions && languageOptions.length'>Select Language</option>\
                                        </select>\
                                    </center>\
                                </div>\
                                <div class='slds-col slds-size--2-of-12'></div>\
                            </div>\
                            <div id='divTranslationRecord0' style='padding-bottom:1%;'>\
                            </div>\
                            <div id='divTranslationRecord1' style='padding-bottom:1%;'>\
                            </div>\
                        </div>\
                    </div>",
            controller: function($scope, $compile, $timeout) {
                //console.log('$scope.selectedRecordID    ' + $scope.selectedRecordID);
                $scope.lang = { selectedLanguage: false };
                $scope.saveResult;
                $scope.field;
                $scope.addNewTranslation = function() {
                    $('#divTranslationRecord1').append("<div id='divRec" + ($scope.Index) + "'><translation-row  id='translationRow" + ($scope.Index) + "' parent-record ='selectedlookupRecord' translation-records ='selectedRecordTransationMap' field-list ='fieldsOptions' selected-language ='lang.selectedLanguage' row-counter='" + ($scope.Index) + "'></translation-row></div>")
                    $compile($('#divRec' + $scope.Index))($scope);
                    $scope.Index++;
                    $scope.numberOfFieldsSelected++;
                }

                $scope.SaveTranslations = function() {
                    window.scrollTo(0, 0);
                    $(".spinnerContainer").show();
                    $scope.lstfieldValueTranslationList = [];
                    debugger;
                    angular.forEach($scope.selectedRecordTransationMap, function(translationRecordList, mapkey) {
                        $scope.field = mapkey;
                        angular.forEach(translationRecordList, function(translationRecords, languagekey) {

                            var localTranslationRecord = { Id: '', FGM_Portal__Translation_Value__c: '', FGM_Portal__RecordID__c: '', FGM_Portal__Language__c: '', FGM_Portal__Field_Name__c: '' };
                            //if($scope.selectedLanguage == translationRecords.FGM_Portal__Language__c)
                            {
                                //console.log('translationRecords  :  ' + translationRecords);                                
                                localTranslationRecord.FGM_Portal__Language__c = translationRecords.FGM_Portal__Language__c ? translationRecords.FGM_Portal__Language__c : $scope.selectedLanguage;
                                localTranslationRecord.FGM_Portal__Field_Name__c = translationRecords.FGM_Portal__Field_Name__c;
                                localTranslationRecord.Id = translationRecords.Id ? translationRecords.Id : '';
                                localTranslationRecord.FGM_Portal__RecordID__c = $scope.selectedRecordID;
                                localTranslationRecord.FGM_Portal__Translation_Value__c = translationRecords.FGM_Portal__Translation_Value__c ? translationRecords.FGM_Portal__Translation_Value__c : '';
                                localTranslationRecord.Name = localTranslationRecord.FGM_Portal__Language__c + ' - ' + $scope.selectedRecordName + ' - ' + translationRecords.FGM_Portal__Field_Name__c;

                                if (localTranslationRecord != {} && (localTranslationRecord.Id == "" || localTranslationRecord.Id == undefined)) {
                                    delete localTranslationRecord.Id;
                                    $scope.lstfieldValueTranslationList.push(localTranslationRecord);
                                } else {
                                    localTranslationRecord.Id = translationRecords.Id;

                                    if ((localTranslationRecord.FGM_Portal__Field_Name__c != undefined || localTranslationRecord.FGM_Portal__Field_Name__c != "") && (localTranslationRecord.FGM_Portal__Language__c != undefined || localTranslationRecord.FGM_Portal__Language__c != "") && (localTranslationRecord.FGM_Portal__RecordID__c != undefined || localTranslationRecord.FGM_Portal__RecordID__c != ""))
                                        if ($scope.selectedRecordID == localTranslationRecord.FGM_Portal__RecordID__c) //&& ($scope.selectedRecordTransationBackupMap[$scope.field] == undefined || ($scope.selectedRecordTransationBackupMap[$scope.field] != undefined && $scope.selectedRecordTransationBackupMap[$scope.field][$scope.selectedLanguage] == undefined ) || ( $scope.selectedRecordTransationBackupMap[$scope.field][$scope.selectedLanguage].FGM_Portal__Translation_Value__c != undefined && $scope.selectedRecordTransationBackupMap[$scope.field][$scope.selectedLanguage].FGM_Portal__Translation_Value__c != translationRecords.FGM_Portal__Translation_Value__c)))
                                            $scope.lstfieldValueTranslationList.push(localTranslationRecord);
                                }
                            }
                        })

                    })
                  
                    if($scope.selectedlookupRecord.Name == '')
                       $scope.selectedlookupRecord.Name = $scope.selectedRecordName;
                          
                    Visualforce.remoting.Manager.invokeAction(
                        'FGM_Portal.ObjectDataTranslationController.saveTranslationRecords',
                        $scope.selectedObjectName.value,
                        angular.toJson(JSON.parse(angular.toJson($scope.selectedlookupRecord))),
                        angular.toJson(JSON.parse(angular.toJson($scope.lstfieldValueTranslationList))),
                        function(result, event) {
                            $scope.saveResult = result;
                            for (index = 0; index < $scope.lookupRecords.length; index++) {
                                if ($scope.lookupRecords[index].Id == $scope.selectedRecordID) {
                                    if($scope.selectedlookupRecord.Name == '')
                                       $scope.selectedlookupRecord.Name = $scope.lookupRecords[index].Name;
                                    $scope.lookupRecords[index] = angular.copy($scope.selectedlookupRecord);
                                    break;
                                }
                            }
                            $timeout(function() { $scope.showRow(); }, 1000);

                        }, {
                            escape: false
                        }
                    );



                }


                //new code

                $scope.$watch('lang.selectedLanguage', function(newField, oldField) {
                    console.log(' no :  ' + $scope.numberOfFieldsSelected + 'new ' + newField + ' old :' + oldField + 'field:' + $scope.selectedField);
                    if ($scope.numberOfFieldsSelected > 0 && $scope.selectedLanguage && newField != oldField) {
                        //window.scrollTo(0, 0);
                        $(".spinnerContainer").show();
                        //showProcessing();
                    }
                    $scope.tempselectedRecordTransationMap = angular.copy($scope.selectedRecordTransationMap);

                    /*angular.forEach($scope.tempselectedRecordTransationMap, function(value, key) {
                        if (value[newField] == undefined && newField != '')
                            value[newField] = { Id: '', FGM_Portal__Translation_Value__c: '', FGM_Portal__RecordID__c: $scope.selectedlookupRecord.Id, FGM_Portal__Language__c: newField, FGM_Portal__Field_Name__c: key };
                    });*/

                    if($scope.lstSelectedFields.length)
                    {
                        for(var i = 0; i < $scope.lstSelectedFields.length; i++)
                        {
                            if( $scope.lstSelectedFields[i].selected)
                                {
                                    if($scope.tempselectedRecordTransationMap[$scope.lstSelectedFields[i].id] == undefined)
                                                $scope.tempselectedRecordTransationMap[$scope.lstSelectedFields[i].id] = {};
                                    if($scope.tempselectedRecordTransationMap[$scope.lstSelectedFields[i].id] != undefined && $scope.tempselectedRecordTransationMap[$scope.lstSelectedFields[i].id][newField] == undefined) 
                                                $scope.tempselectedRecordTransationMap[$scope.lstSelectedFields[i].id][newField] = { Id: '', FGM_Portal__Translation_Value__c: '', FGM_Portal__RecordID__c: $scope.selectedlookupRecord.Id, FGM_Portal__Language__c: newField, FGM_Portal__Field_Name__c: $scope.lstSelectedFields[i].id };
                                }
                        }
                    }

                    $scope.selectedRecordTransationMap = angular.copy($scope.tempselectedRecordTransationMap);


                    angular.forEach($scope.selectedRecordTransationMap, function(value, key) {

                        if (newField != '' && oldField) {
                            if (value[oldField] != undefined) {
                                delete $scope.tempselectedRecordTransationMap[key][oldField];
                            }
                        }
                    });
                    $scope.selectedRecordTransationMap = angular.copy($scope.tempselectedRecordTransationMap);


                    // $scope.$apply();
                    // console.log('1  selectedField   :    ' + $scope.selectedField + '  newField    :    ' + newField);    
                    //  console.log('2  tempTranslationRecords[$scope.selectedField]   :    ' + $scope.tempTranslationRecords[$scope.selectedField] + '  $scope.tempTranslationRecords[$scope.selectedField][newField]   :    ' + $scope.tempTranslationRecords[$scope.selectedField][newField]);    
                    //  console.log('3  $scope.tempTranslationRecords[$scope.selectedField][newField].value   :    ' + $scope.tempTranslationRecords[$scope.selectedField][newField].FGM_Portal__Translation_Value__c);    
                    //debugger;
                    setTimeout(function() {
                        $(".spinnerContainer").hide();
                    }, 500);
                    //hideProcessing();
                });

                //new code end
            }
        };


    })
    .directive("translationRow", function($timeout) {
        return {
            restrict: 'E',
            scope: {
                parentRecord: '=',
                translationRecords: '=',
                fieldList: '=',
                selectedLanguage: '=',
                rowCounter: '='
            },
            template: " <div  class='slds-grid slds-grid--vertical-align-center' style='padding: 1% 0% 1% 0%;'>\
                        <div class='slds-col  slds-size--2-of-12'>\
                            <div style='padding-right: 10%;'>\
                                <select ng-model='selectedField' class='slds-input slds-combobox__input' onselect='disableSelected()' style='height: 21px; padding: 1% 0% 1% 0%;' class='horizontal-align' >\
                                    <option value=''>Select Field</option>\
                                    <option value='{{field.id}}' ng-disabled='field.disabled' ng-repeat=\"field in localSelectedFieldList  | orderBy:'label'\" >{{field.label}}</option>\
                                </select>\
                            </div>\
                        </div>\
                        <div class='slds-col slds-size--4-of-12' >\
                            <div class='horizontal-align' style='width: 82%;' ng-show='selectedField'>\
                                <textArea type='Text' id='row{{rowCounter}}' rows='20' ng-if='!fieldDescribe[selectedField].richText' ng-model='parentRecord[selectedField]' style='font-weight: normal;' class='horizontal-align slds-textarea'></textArea>\
                                    <div ng-if='fieldDescribe[selectedField].richText' style='margin-bottom:8%'>\
                                        <textarea type='Text' id='row{{rowCounter}}' rows='8' ng-model='parentRecord[selectedField]' ckeditor></textarea>\
                                        <!--label><strong>Note : </strong> Attachments will need to be re-uploaded to the translated field<\label-->\
                                    </div>\
                            </div>\
                        </div>\
                        <div class='slds-col slds-size--1-of-12' >\
                            <div class='horizontal-align'>\
                                <utility-toolbox model='parentRecord[selectedField]' undo-redo = 'true' close = 'true' delete = 'false' record-counter = {{rowCounter}}\
                                    undo-icon = 'https://www.foundationconnect.org/staticresources/SLDS/icons/utility/undo_120.png' \
                                    redo-icon = 'https://www.foundationconnect.org/staticresources/SLDS/icons/utility/redo_120.png' \
                                    close-icon = 'https://www.foundationconnect.org/staticresources/SLDS/icons/utility/clear_120.png' \
                                    delete-icon = 'https://www.foundationconnect.org/staticresources/SLDS/icons/utility/delete_120.png'></utility-toolbox>\
                            </div>\
                        </div>\
                        <div class='slds-col slds-size--4-of-12' >\
                            <div class='horizontal-align'  style='width: 82%;' ng-show='selectedField && selectedLanguage'>\
                                <textarea rows='20' ng-if='!fieldDescribe[selectedField].richText' ng-model='translationRecords[selectedField][selectedLanguage].FGM_Portal__Translation_Value__c' style='font-weight: normal;'  class='horizontal-align slds-textarea'></textarea>\
                                <div ng-if='fieldDescribe[selectedField].richText'>\
                                    <textarea  rows='8' ng-model='translationRecords[selectedField][selectedLanguage].FGM_Portal__Translation_Value__c' ckeditor></textarea>\
                                    <label><strong>Note : </strong> Attachments will need to be re-uploaded to the translated field</label>\
                                </div>\
                            </div>\
                        </div>\
                        <div class='slds-col slds-size--2-of-12' >\
                            <div class='horizontal-align' >\
                                <utility-toolbox model='translationRecords[selectedField][selectedLanguage].FGM_Portal__Translation_Value__c' undo-redo = 'true' close = 'true' delete = 'true' record-to-delete='{{translationRecords[selectedField][selectedLanguage].Id}}' record-counter = {{rowCounter}} local-selected-field = '{{selectedField}}'\
                                undo-icon = 'https://www.foundationconnect.org/staticresources/SLDS/icons/utility/undo_120.png' \
                                redo-icon = 'https://www.foundationconnect.org/staticresources/SLDS/icons/utility/redo_120.png' \
                                close-icon = 'https://www.foundationconnect.org/staticresources/SLDS/icons/utility/clear_120.png' \
                                delete-icon = 'https://www.foundationconnect.org/staticresources/SLDS/icons/utility/delete_120.png'></utility-toolbox>\
                            </div>\
                        </div>\
                    </div>",
            controller: function($scope) {
                $scope.selectedField = angular.isUndefined($scope.selectedField) ? '' : $scope.selectedField;
                //$scope.selectedLanguage = $scope.selectedLanguage == false ? 'en_US' : $scope.selectedLanguage;

                $scope.selectedLanguageNew = angular.copy($scope.selectedLanguage);
                $scope.tempTranslationRecords = angular.copy($scope.translationRecords);
                $scope.record = angular.copy($scope.parentRecord);
                $scope.fieldDescribe = [];
                $scope.localSelectedFieldList = $scope.$parent.lstSelectedFields;


                $scope.getFieldDescribe = function() {
                    //console.log(' getFieldDescribe  selectedObjectName   ' + $scope.$parent.selectedObjectName);
                    //$('.search.form-control.search-textbox.ng-pristine.ng-valid').val('');
                    if ($scope.$parent.selectedObjectName.value != undefined) {
                        Visualforce.remoting.Manager.invokeAction(
                            'FGM_Portal.ObjectDataTranslationController.getallTextFieldDescribe',
                            $scope.$parent.selectedObjectName.value,
                            function(result, event) {

                                for (var key in result) {
                                    $scope.fieldDescribe[key] = JSON.parse(result[key]);
                                    //console.log($scope.fieldDescribe[key]);
                                }
                            }, {
                                escape: false
                            }
                        );
                    }
                };
                $scope.getFieldDescribe();
                $scope.$watch('fieldList', function(newval, oldval) {});
                $scope.$watch('selectedField', function(newField, oldField) {

                    if ($scope.selectedLanguage && $scope.selectedField) {
                        //window.scrollTo(0, 0);
                        $(".spinnerContainer").show();
                    }
                    $scope.tempTranslationRecords = angular.copy($scope.translationRecords);

                    if (newField != oldField) {
                        $scope.localSelectedFieldList.forEach(function(element) {
                            {
                                delete element.$$hashKey;
                                if (element.id == $scope.selectedField) {
                                    element.disabled = true;
                                    element.selected = true;
                                }
                                if (oldField != "" && element.id == oldField) {
                                    element.disabled = '';
                                    element.selected = false;
                                }

                            }
                        });
                    }


                    if (newField && $scope.selectedLanguage) {
                        if ($scope.tempTranslationRecords[newField] == undefined) {
                            $scope.tempTranslationRecords[newField] = {};
                        }
                        if ($scope.tempTranslationRecords[newField] && $scope.tempTranslationRecords[newField][$scope.selectedLanguage] == undefined) {
                            $scope.tempTranslationRecords[newField][$scope.selectedLanguage] = { Id: '', FGM_Portal__Translation_Value__c: '', FGM_Portal__RecordID__c: $scope.parentRecord.Id, FGM_Portal__Language__c: $scope.selectedLanguage, FGM_Portal__Field_Name__c: newField };
                            $scope.translationRecords = angular.copy($scope.tempTranslationRecords);
                            $timeout(function() {
                                if (!$scope.$$phase)
                                    $scope.$apply();
                            }, 100);
                        }
                    }

                    if (newField != '' && oldField && $scope.selectedLanguage) {
                        if ($scope.tempTranslationRecords[oldField][$scope.selectedLanguage].Id == '') {
                            delete $scope.tempTranslationRecords[oldField][$scope.selectedLanguage];
                            $scope.translationRecords = angular.copy($scope.tempTranslationRecords);
                        }
                    }

                    //debugger;       
                    setTimeout(function() {
                        $(".spinnerContainer").hide();
                    }, 500);

                });



                /*$scope.$watch('selectedLanguage', function (newField, oldField) 
                {
                    console.log(' no :  ' + $scope.$parent.numberOfFieldsSelected + 'new ' + newField + ' old :' + oldField+'field:' + $scope.selectedField) ;
                    if($scope.$parent.numberOfFieldsSelected>0 && $scope.selectedLanguage)
                        {
                            window.scrollTo(0, 0);
                            $(".spinnerContainer").show();
                            //showProcessing();
                        }
                    $scope.tempTranslationRecords = angular.copy($scope.translationRecords);

                    if ($scope.selectedField && newField)
                    {
                        if($scope.tempTranslationRecords[$scope.selectedField] == undefined)
                        {
                            $scope.tempTranslationRecords[$scope.selectedField] = {};
                            if (!$scope.$$phase) 
                                $scope.$apply();
                        }
                        if($scope.tempTranslationRecords[$scope.selectedField] && $scope.tempTranslationRecords[$scope.selectedField][newField] == undefined)
                        {                     
                            $scope.tempTranslationRecords[$scope.selectedField][newField] = {Id:'',FGM_Portal__Translation_Value__c:'', FGM_Portal__RecordID__c:$scope.parentRecord.Id, FGM_Portal__Language__c:newField, FGM_Portal__Field_Name__c:$scope.selectedField};
                            $scope.translationRecords = angular.copy($scope.tempTranslationRecords);
                            $timeout(function()
                             { 
                                if (!$scope.$$phase)
                                    $scope.$apply(); 
                             },100);
                        }
                    }
                    if(newField!='' && oldField)
                    {
                        if($scope.tempTranslationRecords[$scope.selectedField] && $scope.tempTranslationRecords[$scope.selectedField][oldField] && $scope.tempTranslationRecords[$scope.selectedField][oldField].Id == '')
                        {
                            delete $scope.tempTranslationRecords[$scope.selectedField][oldField];
                            $scope.translationRecords = angular.copy($scope.tempTranslationRecords);
                        }
                    }
                        
                    console.log('1  selectedField   :    ' + $scope.selectedField + '  newField    :    ' + newField);    
                    console.log('2  tempTranslationRecords[$scope.selectedField]   :    ' + $scope.tempTranslationRecords[$scope.selectedField] + '  $scope.tempTranslationRecords[$scope.selectedField][newField]   :    ' + $scope.tempTranslationRecords[$scope.selectedField][newField]);    
                    console.log('3  $scope.tempTranslationRecords[$scope.selectedField][newField].value   :    ' + $scope.tempTranslationRecords[$scope.selectedField][newField].FGM_Portal__Translation_Value__c);    
                        //debugger;
                    setTimeout(function() {
                        $(".spinnerContainer").hide();
                    },500);
                        //hideProcessing();
                });*/

                $scope.$watch('translationRecords', function(newField, oldField) {

                    //console.log('    ++++  newField   ++++   ' + newField +'    ++++  oldField   ++++   ' + oldField );

                });
            }
        }


    })
    .directive('utilityToolbox', function($compile, $timeout) {
        return {
            restrict: 'E',
            replace: true,
            scope: {
                model: '=',
                undoRedo: '@',
                close: '@',
                delete: '@',
                undoIcon: '@',
                redoIcon: '@',
                closeIcon: '@',
                deleteIcon: '@',
                recordToDelete: '@',
                recordCounter: '@',
                localSelectedField: '@'
            },
            template: '<div>\
                    <button type="button" class="slds-button" ng-click="undo()" ng-show="{{undoRedo}}">\
                        <img src="{{undoIcon}}" style="height:20px;" alt="undo"  title="Undo">\
                    </button>\
                    <button type="button" class="slds-button" ng-click="redo()" ng-show="{{undoRedo}}">\
                        <img src="{{redoIcon}}"  style="height:20px;" alt="redo"  title="Redo">\
                    </button>\
                    <button type="button" class="slds-button" ng-click="clear()" ng-show="{{close}}">\
                        <img src="{{closeIcon}}"  style="height:20px;" alt="clear"  title="Clear Text">\
                    </button>\
                    <button type="button" class="slds-button" ng-click="deleteRecord()" ng-show="{{delete}}">\
                        <img src="{{deleteIcon}}"  style="height:20px;" alt="delete"  title="Delete Translations">\
                    </button>\
               </div>',
            link: function($scope, $compile) {
                $scope.counter = 0;
                $scope.queue = [];
                $scope.changedByFunction = false;

                $scope.localSelectedFieldList = $scope.$parent.$parent.lstSelectedFields;

                $scope.$watch('model', function(newVal, oldVal) {
                    if (newVal != undefined && !$scope.changedByFunction) {
                        if ($scope.queue.length == $scope.counter) {
                            $scope.queue.push(newVal);
                        } else {
                            $scope.queue.splice($scope.counter, ($scope.queue.length - $scope.counter));
                            $scope.queue.push(newVal);
                        }

                        $scope.counter++;
                    }
                    $scope.changedByFunction = false;
                });
                $scope.undo = function() {
                    if ($scope.counter > 0) {
                        $scope.counter = $scope.counter == $scope.queue.length ? $scope.counter - 2 : $scope.counter - 1;
                        $scope.model = $scope.counter == -1 ? $scope.model : angular.copy($scope.queue[$scope.counter]);
                        $scope.changedByFunction = true;
                    }
                }
                $scope.redo = function() {
                    if ($scope.counter + 1 < $scope.queue.length) {
                        $scope.counter++;
                        $scope.model = angular.copy($scope.queue[$scope.counter]);
                        $scope.changedByFunction = true;
                    }
                }

                $scope.clear = function() {
                    $scope.model = '';
                    $scope.RecordToDelete;
                }

                $scope.deleteRecord = function() {
                    var intSelectedField = 0;
                    var boolDeleteConfirmation = confirm("Do you really want to delete the Translation Record");
                    debugger;
                    if (boolDeleteConfirmation) {
                        $scope.localSelectedFieldList.forEach(function(element) {
                            {
                                delete element.$$hashKey;
                                if (element.id == $scope.localSelectedField) {
                                    element.disabled = '';
                                    element.selected = false;
                                }

                                if (element.selected)
                                    intSelectedField++;
                            }
                        });
                        if ($scope.recordToDelete != '') {
                            Visualforce.remoting.Manager.invokeAction(
                                'FGM_Portal.ObjectDataTranslationController.deleteTranslationRecord',
                                $scope.recordToDelete,
                                function(result, event) {
                                    //console.log(' Record Deleted ' + $scope.recordCounter);
                                    $('#divRec' + $scope.recordCounter).html('');


                                    $scope.localSelectedField = undefined;
                                    $scope.model = undefined;
                                    $scope.$parent.numberOfFieldsSelected--;
                                    debugger;
                                    $scope.$apply();
                                }, {
                                    escape: false
                                }
                            );
                        }
                        if ($("[id^=translationRow]").length > 1) {
                            $('#divRec' + $scope.recordCounter).html('');
                        }

                        $scope.$parent.selectedField = undefined;
                        $scope.localSelectedField = undefined;

                        $timeout(function() {
                            $scope.$parent.$apply();
                            $scope.$apply();
                        }, 500);
                    }
                }
            }
        }
    })
    .directive('ckeditor', function($rootScope, $timeout) {
        return {
            require: '?ngModel',
            link: function(scope, element, attr, ngModel) {

                if (!ngModel) return;
                CKEDITOR.config.width = '110%';


                var ck = CKEDITOR.replace(element[0]);
                //debugger;
                var oldValue = ck.getData();

                ck.on('instanceReady', function() {
                    ck.setData(ngModel.$viewValue);
                });

                ngModel.$render = function(value) {
                    ck.setData(ngModel.$viewValue);
                };

                function updateModel() {
                    //debugger;
                    var newValue = ck.getData();
                    if (newValue && oldValue != newValue) {
                        $timeout(function() {
                            scope.$apply(function() {
                                //debugger;                        
                                ////console.log('ckModel: ' + ngModel);
                                if (scope.$parent.$$phase) {
                                    scope.$parent.$$postDigest(function() {
                                        ngModel.$setViewValue(newValue);
                                        oldValue = newValue;
                                    });
                                } else {
                                    ngModel.$setViewValue(newValue);
                                    oldValue = newValue;
                                }
                            })
                        }, 188);
                    }
                }

                ck.on('change', changeUpdateModel);
                //ck.on('key', keyUpdateModel);
                ck.on('dataReady', dataReadyUpdateModel);
                ck.on('blur', blurUpdateModel);

                function changeUpdateModel() {
                    //console.log('changeUpdateModel');
                    updateModel();
                }

                function keyUpdateModel() {
                    //console.log('keyUpdateModel');
                    updateModel();
                }

                function dataReadyUpdateModel() {
                    //console.log('dataReadyUpdateModel');
                    //updateModel();
                }

                function blurUpdateModel() {
                    //console.log('blurUpdateModel');
                    updateModel();
                }

                scope.$watch('ngModel', function(newField, oldField) {
                    //console.log('    ++++  newField   ++++   ' + newField +'    ++++  oldField   ++++   ' + oldField );

                });
                ngModel.$render = function(value) {
                    ck.setData(ngModel.$viewValue);
                };
            }
        };
    });