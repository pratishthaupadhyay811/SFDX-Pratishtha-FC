App.controller("PortalUserFieldMappingControllerd", ['$scope', 'salesforce', 'toaster', 'processing', function ($scope, salesforce, toaster, processing) {
    processing.show();
    $scope.mapPortlUserFields = {};
    $scope.communityConfiguration = { FGM_Portal__JsonData__c: { PortalUserToContact: [], PortalUserToAccount: [] }, FGM_Portal__ConfiguationName__c: 'PortalUserFieldMapping' };
    $scope.contactFieldsByRow = [];
    $scope.accountFieldsByRow = [];
    $scope.isObjectFieldLoaded = false;
    $scope.showMessageComponent = false;
    $scope.exception = {};
    $scope.isAccess = isAccess;
    $scope.onObjectChange = function () {
        if (!$scope.isObjectFieldLoaded) {
            $scope.isObjectFieldLoaded = true;
            salesforce.invoke("FGM_Portal.PortalUserFieldMappingController.GetObjectFields", "Account", [], ["ID", "SystemModstamp", "RecordTypeId", "LastActivityDate", "LastModifiedDate", "Ownership", "CreatedBy", "CreatedDate", "LastModifiedById", "createdby", "OwnerId", "CreatedById", "LastViewedDate", "IsDeleted", "MasterRecordId", "LastReferencedDate", "BillingStateCode", "BillingCountryCode", "ShippingStateCode", "ShippingCountryCode"], true,
         function (result) {
             if (result.IsSuccess) {

                 var rowData = { first: {}, second: {}, selectedFirstField: {}, selectedSecondField: {} };
                 var count = 0;
                 for (var i = 0 ; i < result.Data.length; i++) {
                     count++;
                     if ((i % 2) == 0) {
                         rowData["first"] = result.Data[i];
                     }
                     if ((i % 2) != 0) {
                         rowData["second"] = result.Data[i];
                     }
                     if (count == 2 || result.Data.length - 1 == i) {
                         $scope.accountFieldsByRow.push(angular.copy(rowData));
                         rowData = { first: {}, second: {} };
                         count = 0;
                     }
                 }

                 for (var i = 0; i < $scope.accountFieldsByRow.length; i++) {
                     $scope.accountFieldsByRow[i].selectedFirstField = $scope.mapPortlUserFields['--None--'];
                     $scope.accountFieldsByRow[i].selectedSecondField = $scope.mapPortlUserFields['--None--'];

                     for (j = 0; j < $scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToAccount.length; j++) {

                         if (angular.equals($scope.accountFieldsByRow[i].first.Name, $scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToAccount[j].Name)) {
                             $scope.accountFieldsByRow[i].selectedFirstField = $scope.mapPortlUserFields[$scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToAccount[j].Value];
                         } else if (angular.equals($scope.accountFieldsByRow[i].second.Name, $scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToAccount[j].Name)) {
                             $scope.accountFieldsByRow[i].selectedSecondField = $scope.mapPortlUserFields[$scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToAccount[j].Value];
                         }

                     }
                 }

                 $scope.$apply();
             }
         }, function (event) {
                        var messageWrapper = JSON.parse(event); 
                          $scope.exception.Text = messageWrapper.userMessage;
                          $scope.exception.Title = messageWrapper.messageType.charAt(0).toUpperCase() + messageWrapper.messageType.slice(1);
                          $scope.exception.Type = messageWrapper.messageType;
                          $scope.exception.timeToLive = 3000;
                          $scope.showPageMessage(true);
                          if(document.getElementsByClassName('slds-spinner_container')!=undefined && document.getElementsByClassName('slds-spinner_container').length>0)
                              document.getElementsByClassName('slds-spinner_container')[0].setAttribute('class','slds-hide');
                          $scope.cancel();
                          $scope.$apply();
          });
            salesforce.invoke("FGM_Portal.PortalUserFieldMappingController.GetObjectFields", "Contact", [], ["ID", "SystemModstamp", "RecordTypeId", "LastActivityDate", "LastModifiedDate", "Ownership", "CreatedBy", "CreatedDate", "LastModifiedById", "createdby", "OwnerId", "CreatedById", "LastViewedDate", "IsDeleted", "MasterRecordId", "LastReferencedDate", "OtherCountryCode", "OtherStateCode", "MailingStateCode", "MailingCountryCode"], true,
            function (result) {
                if (result.IsSuccess) {
                    var rowData = { first: {}, second: {}, selectedFirstField: {}, selectedSecondField: {} };
                    var count = 0;
                    for (var i = 0 ; i < result.Data.length; i++) {
                        count++;
                        if ((i % 2) == 0) {
                            rowData["first"] = result.Data[i];
                        }
                        if ((i % 2) != 0) {
                            rowData["second"] = result.Data[i];
                        }
                        if (count == 2 || result.Data.length - 1 == i) {
                            $scope.contactFieldsByRow.push(angular.copy(rowData));
                            rowData = { first: {}, second: {} };
                            count = 0;
                        }
                    }
                    for (var i = 0; i < $scope.contactFieldsByRow.length; i++) {

                        $scope.contactFieldsByRow[i].selectedFirstField = $scope.mapPortlUserFields['--None--'];
                        $scope.contactFieldsByRow[i].selectedSecondField = $scope.mapPortlUserFields['--None--'];


                        for (j = 0; j < $scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToContact.length; j++) {
                            if (angular.equals($scope.contactFieldsByRow[i].first.Name, $scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToContact[j].Name)) {
                                $scope.contactFieldsByRow[i].selectedFirstField = $scope.mapPortlUserFields[$scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToContact[j].Value];
                            } else if (angular.equals($scope.contactFieldsByRow[i].second.Name, $scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToContact[j].Name)) {
                                $scope.contactFieldsByRow[i].selectedSecondField = $scope.mapPortlUserFields[$scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToContact[j].Value];
                            }
                        }

                    }
                    $scope.$apply();
                }
            }, function (event) { 
                var messageWrapper = JSON.parse(event); 
                          $scope.exception.Text = messageWrapper.userMessage;
                          $scope.exception.Title = messageWrapper.messageType.charAt(0).toUpperCase() + messageWrapper.messageType.slice(1);
                          $scope.exception.Type = messageWrapper.messageType;
                          $scope.exception.timeToLive = 3000;
                          $scope.showPageMessage(true);
                          if(document.getElementsByClassName('slds-spinner_container')!=undefined && document.getElementsByClassName('slds-spinner_container').length>0)
                              document.getElementsByClassName('slds-spinner_container')[0].setAttribute('class','slds-hide');
                          $scope.$apply();
                         
            });
        }
    }

    $scope.isLoaded = true;


    $scope.getPortalUserFields = function () {
        salesforce.invoke("FGM_Portal.PortalUserFieldMappingController.GetObjectFields", "FGM_Portal__Portal_User__c", [], ["ID", "SystemModstamp", "RecordTypeId", "LastActivityDate", "LastModifiedDate", "Ownership", "CreatedBy", "CreatedDate", "LastModifiedById", "createdby", "OwnerId", "CreatedById", "LastViewedDate", "IsDeleted", "MasterRecordId", "LastReferencedDate"], false,
            function (result) {
                if (result.IsSuccess) {
                    $scope.mapPortlUserFields = result.Data;
                    $scope.mapPortlUserFields["--None--"] = { FieldType: "", Label: "--None--", Name: "--None--", ObjectName: "" };
                    $scope.$apply();
                }
            }, function () { });

        return false;
    }
    $scope.onFieldChange = function (Field, portalUserSelectedField, index, row) {

        if (angular.equals($scope.selectdObject, 'Contact')) {
            var isFieldExists = false;
           
            if (Field.FieldType != portalUserSelectedField.FieldType && !angular.equals("--None--", portalUserSelectedField.Name)) {
                toaster.pop('error', 'Error', 'Field Type does not match');
                //To set null values
                if (angular.equals(row, "firstRow")) {
                    $scope.contactFieldsByRow[index]["selectedFirstField"] = $scope.mapPortlUserFields['--None--'];
                } else if (angular.equals(row, "secondRow")) {
                    $scope.contactFieldsByRow[index]["selectedSecondField"] = $scope.mapPortlUserFields['--None--'];
                }
                return;
            }
            for (var i = 0; i < $scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToContact.length; i++) {
                if (angular.equals($scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToContact[i].Name, Field.Name)) {
                    isFieldExists = true;
                    if (angular.equals("--None--", portalUserSelectedField.Name)) {
                        $scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToContact.splice(i, 1);
                    }
                    else
                        $scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToContact[i] = { Name: Field.Name, Value: portalUserSelectedField.Name };

                    break;

                }
            }

            if (!isFieldExists)
                $scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToContact.push({ Name: Field.Name, Value: portalUserSelectedField.Name });

        }
        else if (angular.equals($scope.selectdObject, 'Account')) {
            var isFieldExists = false;
            
            if (Field.FieldType != portalUserSelectedField.FieldType && !angular.equals("--None--", portalUserSelectedField.Name)) {
                toaster.pop('error', 'Error', 'Field Type does not match');
                //To set null values
                if (angular.equals(row, "firstRow")) {
                    $scope.accountFieldsByRow[index]["selectedFirstField"] = $scope.mapPortlUserFields['--None--'];
                } else if (angular.equals(row, "secondRow")) {
                    $scope.accountFieldsByRow[index]["selectedSecondField"] = $scope.mapPortlUserFields['--None--'];
                }
                return;
            }
            
            for (var i = 0; i < $scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToAccount.length; i++) {
                if (angular.equals($scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToAccount[i].Name, Field.Name)) {
                    isFieldExists = true;
                    if (angular.equals("--None--", portalUserSelectedField.Name)) {
                        $scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToAccount.splice(i, 1);
                    } else
                        $scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToAccount[i] = { Name: Field.Name, Value: portalUserSelectedField.Name };
                    break;
                }
            }
            
            if (!isFieldExists)
                $scope.communityConfiguration.FGM_Portal__JsonData__c.PortalUserToAccount.push({ Name: Field.Name, Value: portalUserSelectedField.Name });

        }

    }
    $scope.UpsertRecord = function () {

        var record = angular.copy($scope.communityConfiguration);
        record.FGM_Portal__JsonData__c = JSON.stringify(record.FGM_Portal__JsonData__c);
        salesforce.invoke("FGM_Portal.PortalUserFieldMappingController.UpsertRecord", [record],
         function (result) {
            if (result.Data && result.Data[0]) {
                $scope.communityConfiguration = result.Data[0];
                $scope.communityConfiguration.FGM_Portal__JsonData__c = JSON.parse(result.Data[0].FGM_Portal__JsonData__c); 
            }

            if (result.IsSuccess) {
                toaster.pop('success', '', result.Message);                 
            } else {
                toaster.pop('warning', '', result.Message);                 
            }

            $scope.$apply();
         }, function (errorResult) { });
    }
    $scope.cancel = function () {
        $scope.selectdObject = '--None--';
    }
    
    $scope.showPageMessage = function (showMessage)
       {
           $scope.showMessageComponent = showMessage;
       }


    $scope.GetPortalUserMappingData = function () {
        salesforce.invoke("FGM_Portal.PortalUserFieldMappingController.GetPortalUserMappingData",
            function (result , event) {
                if (result.IsSuccess) {
                    $scope.communityConfiguration = result.Data;
                    $scope.communityConfiguration.FGM_Portal__JsonData__c = JSON.parse(result.Data.FGM_Portal__JsonData__c);
                    $scope.$apply();
                }
            }, function (event) { 
            var messageWrapper = JSON.parse(event); 
                          $scope.exception.Text = messageWrapper.userMessage;
                          $scope.exception.Title = messageWrapper.messageType.charAt(0).toUpperCase() + messageWrapper.messageType.slice(1);
                          $scope.exception.Type = messageWrapper.messageType;
                          $scope.exception.timeToLive = 3000;
                          $scope.showPageMessage(true);
                          if(document.getElementsByClassName('slds-spinner_container')!=undefined && document.getElementsByClassName('slds-spinner_container').length>0)
                              document.getElementsByClassName('slds-spinner_container')[0].setAttribute('class','slds-hide');
                          $scope.$apply();
                      });
    }
    $scope.GetPortalUserMappingData();
}]
);
