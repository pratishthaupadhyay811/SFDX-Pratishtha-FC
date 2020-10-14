var uploaddemo = angular.module('uploaddemo',['uploadManagerApp','systemService',"databaseService","exceptionService"]);
uploaddemo.controller('uploaddemocontroller',function($scope,$attachmentUploadUtilities, $database, $systemService, $exception,$compile){
    jsCompile = $compile;
Visualforce.remoting.Manager.invokeAction(engineMethodPath+'.getApplicationRecord', jsQueAttachmentLookup,appId, function( result, error ){
    $scope.appQuestionWrapper = result;
},
{ 
    escape : false 
});

var isEditable = false;
if(jsMode == 'edit')
    isEditable = true ;
if (jsMode == 'view' && !IsApplicationSubmitted && uploadAfterSubmit)
{
    isEditable = true;
}
$scope.$watch(function() {
        if (uploadProcessQueue.length > 0)
            return true;
        else
            return false;
    },
    function(newVal, oldVal) {
        if (newVal) {
           $('.footer-btn').attr("disabled","disabled");

        } else
            $('.footer-btn').removeAttr('disabled');

    }
);
$attachmentUploadUtilities.getAttachmentsFromSF(null,jsQueAttachmentLookup,appId).then(function(attachmentResult){
   $scope.attachment = attachmentResult;
    var baseUrl = window.location.protocol + '//' + window.location.host; 
   Visualforce.remoting.Manager.invokeAction( engineMethodPath+'.getAttachmentComponentSettings', isEditable, baseUrl, pageLanguage, '42.0', function( AttachmentComponentSettings, error ){
        $scope.initializationSettings = AttachmentComponentSettings;
        $scope.$apply();
       jsScope = $scope;
          
        } );
    }, function errorCallback(error){

    });

    $scope.transationForTable = $attachmentUploadUtilities.translationsForAttachmentTable(srLabel,nameLabel,descriptionLabel,createdDateLabel,actionsLabel,deleteLabel, noRecordsFound,deleteConfirmation);
    $scope.transationForFileUploader = $attachmentUploadUtilities.translationsForFileUploader(chooseFileLabel, noFileLabel, uploadLabel, descriptionLabel, uploadingLabel, characterCountOfLabel, charactersLabel);
    $scope.translationForStatuses = $attachmentUploadUtilities.translationsForStatusCodes( uploadFailureMsg, uploadSuccessMsg, fileInfectedMsg, extensionNotAllowMsg, attachmentSizeErrorMsg, zeroByteFileErr, iEBrowserSupportErr);
    
});
