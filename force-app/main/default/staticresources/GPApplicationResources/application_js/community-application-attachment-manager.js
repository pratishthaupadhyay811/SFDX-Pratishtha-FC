var angularApp = angular.module('angularApp',['uploadManagerApp','systemService','schemaService']);

angularApp.controller('angularController',function($scope,$attachmentUploadUtilities,$systemService,$schema,$compile)
{
    jsCompile = $compile;
    $scope.attachments = [];
    var baseUrl;
    $scope.$watch(function() 
        {
            if (uploadProcessQueue.length > 0)
                return true;
            else
                return false;
        },
        function(newVal, oldVal) 
        {
            if (newVal) 
            {
               $('.footer-btn').attr("disabled","disabled");
            } 
            else
            {
                 $('.footer-btn').removeAttr('disabled');
            }
        }
    );
    var isEditable = false;
    if(jsMode=='view')
        isEditable = false;
    if(jsMode=='edit')
        isEditable = true;
    if(appId)
    {
            Visualforce.remoting.Manager.invokeAction( engineMethodPath + '.getApplicationRecord', jsQueAttachmentLookup,appId, function( result, error ){
                $scope.appQuestionWrapper = result;
            },
            { 
                escape : false 
            });
            $attachmentUploadUtilities.getAttachmentsFromSF(null,jsQueAttachmentLookup,appId).then(function(result){
            $scope.attachments = result;
            baseUrl =  window.location.protocol + '//' + window.location.host;
            Visualforce.remoting.Manager.invokeAction( engineMethodPath + '.getAttachmentComponentSettings', isEditable, baseUrl, pageLanguage, '42.0', function( result, error ){
                $scope.initializationSettings = result;
                $scope.$apply();
                jsScope = $scope;
            } );

        },function(error){
            console.log(error);
        });
    }
    else
    {
        baseUrl =  window.location.protocol + '//' + window.location.host;
        Visualforce.remoting.Manager.invokeAction( engineMethodPath + '.getAttachmentComponentSettings', isEditable, baseUrl, pageLanguage, '42.0', function( result, error ){
            $scope.initializationSettings = result;
            $scope.$apply();
            jsScope = $scope;
        } );
    }
    $scope.translationForStatuses = $attachmentUploadUtilities.translationsForStatusCodes( attachmentProcessErr, uploadSuccessMsg, fileInfectedMsg, extensionNotAllowMsg, attachmentSizeErrorMsg,zeroByteFileErr,iEBrowserSupportErr);    
    $scope.transationForTable = $attachmentUploadUtilities.translationsForAttachmentTable(srNoLabel,nameLabel,descriptionLabel,createdDateLabel,actionLabel,deleteLabel,noAttachmentMsg,deleteConfirmation);
    $scope.transationForFileUploader = $attachmentUploadUtilities.translationsForFileUploader(chooseFileLabel, noFileChoosenLabel,uploadLabel,descriptionPlaceholder,attachmentProcessing,characterCountOfLabel,charactersLabel);
   
});
angularApp.filter('removeTags',function(){
    return function( stringWithTags ){

    }
});