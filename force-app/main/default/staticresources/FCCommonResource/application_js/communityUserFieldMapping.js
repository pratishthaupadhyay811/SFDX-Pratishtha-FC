var communityUserFieldMappingApp = angular.module('communityUserFieldMappingApp', ['salesforce', 'toaster', 'processing','messageApp']);
communityUserFieldMappingApp.controller("communityUserFieldMappingController", ['$scope', 'salesforce', 'toaster', 'processing','$window', function ($scope, salesforce, toaster, processing,window) {
	
	$scope.mapCommunityUserFields = {};
	$scope.communityConfiguration = { FGM_Portal__JsonData__c: { CommunityUserToContact: [] }, FGM_Portal__ConfiguationName__c: 'CommunityUserFieldMapping' };
	$scope.contactFieldsByRow = [];
    $scope.showMessageComponent = false;
    $scope.exception = {};
    $scope.isAccess = isAccess;

	$scope.onObjectChange = function () {        
        salesforce.invoke("FGM_Portal.CommunityUserFieldMappingController.GetObjectFields", "Contact", [], ["ID", "SystemModstamp", "RecordTypeId", "LastActivityDate", "LastModifiedDate", "Ownership", "CreatedBy", "CreatedDate", "LastModifiedById", "createdby", "OwnerId", "CreatedById", "LastViewedDate", "IsDeleted", "MasterRecordId", "LastReferencedDate","OtherCountryCode","OtherStateCode", "MailingStateCode", "MailingCountryCode"], true,
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

                    $scope.contactFieldsByRow[i].selectedFirstField = $scope.mapCommunityUserFields['--None--'];
                    $scope.contactFieldsByRow[i].selectedSecondField = $scope.mapCommunityUserFields['--None--'];


                    for (j = 0; j < $scope.communityConfiguration.FGM_Portal__JsonData__c.CommunityUserToContact.length; j++) {
                        if (angular.equals($scope.contactFieldsByRow[i].first.Name, $scope.communityConfiguration.FGM_Portal__JsonData__c.CommunityUserToContact[j].Name)) {
                            $scope.contactFieldsByRow[i].selectedFirstField = $scope.mapCommunityUserFields[$scope.communityConfiguration.FGM_Portal__JsonData__c.CommunityUserToContact[j].Value];
                        } else if (angular.equals($scope.contactFieldsByRow[i].second.Name, $scope.communityConfiguration.FGM_Portal__JsonData__c.CommunityUserToContact[j].Name)) {
                            $scope.contactFieldsByRow[i].selectedSecondField = $scope.mapCommunityUserFields[$scope.communityConfiguration.FGM_Portal__JsonData__c.CommunityUserToContact[j].Value];
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
		
	$scope.getCommunityUserFields = function () {
        salesforce.invoke("FGM_Portal.CommunityUserFieldMappingController.GetObjectFields", "User", [], ["ID", "SystemModstamp", "RecordTypeId", "LastActivityDate", "LastModifiedDate", "Ownership", "CreatedBy", "CreatedDate", "LastModifiedById", "createdby", "OwnerId", "CreatedById", "LastViewedDate", "IsDeleted", "MasterRecordId", "LastReferencedDate","CountryCode","StateCode"], false,
            function (result) {
                if (result.IsSuccess) {
                    $scope.mapCommunityUserFields = result.Data;
                    $scope.mapCommunityUserFields["--None--"] = { FieldType: "", Label: "--None--", Name: "--None--", ObjectName: "" };
                    $scope.$apply();
                }
            }, function () { });

        return false;
    }

    $scope.onFieldChange = function (Field, portalUserSelectedField, index, row) {
       
        var isFieldExists = false;
        if (Field.FieldType != portalUserSelectedField.FieldType && !angular.equals("--None--", portalUserSelectedField.Name)) {
            toaster.pop('error', 'Error', 'Field Type does not match');
            //To set null values
            if (angular.equals(row, "firstRow")) {
                $scope.contactFieldsByRow[index]["selectedFirstField"] = $scope.mapCommunityUserFields['--None--'];
            } else if (angular.equals(row, "secondRow")) {
                $scope.contactFieldsByRow[index]["selectedSecondField"] = $scope.mapCommunityUserFields['--None--'];
            }
            return;
        }
        for (var i = 0; i < $scope.communityConfiguration.FGM_Portal__JsonData__c.CommunityUserToContact.length; i++) {
            if (angular.equals($scope.communityConfiguration.FGM_Portal__JsonData__c.CommunityUserToContact[i].Name, Field.Name)) {
                isFieldExists = true;
                if (angular.equals("--None--", portalUserSelectedField.Name)) {
                    $scope.communityConfiguration.FGM_Portal__JsonData__c.CommunityUserToContact.splice(i, 1);
                }
                else
                    $scope.communityConfiguration.FGM_Portal__JsonData__c.CommunityUserToContact[i] = { Name: Field.Name, Value: portalUserSelectedField.Name };

                break;
            }
        }
        if (!isFieldExists)
            $scope.communityConfiguration.FGM_Portal__JsonData__c.CommunityUserToContact.push({ Name: Field.Name, Value: portalUserSelectedField.Name });
      
    }
    
    $scope.UpsertRecord = function () {

        var record = angular.copy($scope.communityConfiguration);
        record.FGM_Portal__JsonData__c = JSON.stringify(record.FGM_Portal__JsonData__c);
        salesforce.invoke("FGM_Portal.CommunityUserFieldMappingController.UpsertRecord", [record],
         function (result) {
             
             if (result.IsSuccess) {
                 $scope.communityConfiguration = result.Data[0];
                 $scope.communityConfiguration.FGM_Portal__JsonData__c = JSON.parse(result.Data[0].FGM_Portal__JsonData__c);
                 
                 toaster.pop('success', '', result.Message);                 
                 //$scope.$apply();

             }
             else {
                 toaster.pop('warning', '', result.Message);
             }
             $scope.$apply();
         }, function (errorResult) { });
    }
    $scope.cancel = function () {
        window.location.reload();
    }
    $scope.showPageMessage = function (showMessage)
    {
        $scope.showMessageComponent = showMessage;
    }

    $scope.GetPortalUserMappingData = function () {
        salesforce.invoke("FGM_Portal.CommunityUserFieldMappingController.GetPortalUserMappingData",
            function (result) {
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
