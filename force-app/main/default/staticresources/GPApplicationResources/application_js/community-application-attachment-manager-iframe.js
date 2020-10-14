var angularAppIframe = angular.module('angularAppIframe',['uploadManagerApp','systemService','schemaService']);
angularAppIframe.controller('angularControllerIframe',function($scope,$attachmentUploadUtilities,$systemService,$schema,$compile,$timeout)
{
    $scope.attachments = [];
    var session = sessionId;
    $scope.appQuestionWrapper = appQuestionWrapper;
    $scope.initializationSettings = initializeSettings;
    $attachmentUploadUtilities.getAttachmentsFromSF().then(function(result){
        $scope.attachments = result;
        setTimeout(function () {$scope.$apply();}, 200);
    });   
    $scope.$watch(function() 
    {
        if (window.parent.uploadProcessQueue.length > 0)
            return true;
        else
            return false;
    },
    function(newVal, oldVal) 
    {
        if (newVal) 
        {
           window.parent.disableSaveNext();
        } 
        else
        {
            window.parent.enableSaveNext();
        }
    }
    );
    $scope.translationForStatuses = $attachmentUploadUtilities.translationsForStatusCodes( attachmentProcessErr, uploadSuccessMsg, fileInfectedMsg, extensionNotAllowMsg, attachmentSizeErrorMsg,zeroByteFileErr,iEBrowserSupportErr);    
    $scope.transationForTable = $attachmentUploadUtilities.translationsForAttachmentTable(srNoLabel,nameLabel,descriptionLabel,createdDateLabel,actionLabel,deleteLabel,noAttachmentMsg,deleteConfirmation);
    $scope.transationForFileUploader = $attachmentUploadUtilities.translationsForFileUploader(chooseFileLabel, noFileChoosenLabel,uploadLabel,descriptionPlaceholder,attachmentProcessing,characterCountOfLabel,charactersLabel);

});