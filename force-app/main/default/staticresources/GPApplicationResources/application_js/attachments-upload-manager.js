// @ts-nocheck
var uploadManagerApp = angular.module('uploadManagerApp',['databaseService','systemService', 'exceptionService','ngSanitize']);
uploadManagerApp.config(function($sceDelegateProvider){
	var baseUrl = window.location.protocol + '//' + window.location.host + '/**';
	$sceDelegateProvider.resourceUrlWhitelist([
		'https://localhost/**',
		baseUrl
	]);
});
uploadManagerApp.filter('removetags',function(){
    return function( stringToParse ){
		return stringToParse ? String(stringToParse).replace(/<[^>]+>/gm, '') : '';
	}
});
uploadManagerApp.directive('uploadManagerComponent',function( $sce, $templateRequest, $compile, $database, $attachmentUploadUtilities, $timeout)
{

	var directiveObj = {};
	directiveObj.scope = {};
	directiveObj.restrict = 'ECMA';
	directiveObj.scope.questionAttachmentId = '@';
	directiveObj.scope.attachments = '@';
	directiveObj.scope.uiTheme = '@';

	directiveObj.scope.tableTranslations = '@';
	directiveObj.scope.fileInputTranslations = '@';
	directiveObj.scope.initializationSettings = '@';
	directiveObj.scope.uploadEnabled = '@';
	directiveObj.scope.documentShareType = '@';
	directiveObj.scope.statusCodes = '@';
	directiveObj.scope.parentRecord = '@';

	directiveObj.template = templateValue;

	directiveObj.link = function($scope,$element)
	{
		/*
		** the template URL is not used right now due to incompatibility with Microsoft user agents
		**
		var templateUrl = templateBaseUrl + 'templates/upload-manager-component.html'; 
		if( $scope.uiTheme == 'slds' )
			templateUrl = templateBaseUrl + 'templates/upload-manager-component-slds.html'; 
		$templateRequest(templateUrl).then(function(html){
			$element.append($compile(html)($scope));
		});
		*/

		$scope.$watch('attachments',function(newVal,oldVal){
			if( newVal && typeof newVal === 'string' && newVal.length > 0 )
			{
				$scope.localAttachments = [];
				$scope.preFetchProcessCount--;
			}
		});

		$scope.$watch('initializationSettings',function(newVal,oldVal){
			if( newVal && newVal.length > 0 )
			{
				$scope.controlSetup = JSON.parse(newVal);
				if( $scope.controlSetup.isFile )
					$scope.descriptionAllowedLength = 1000;
				else
					$scope.descriptionAllowedLength = 500;
			}
		});

		$scope.$watch('tableTranslations',function(newVal,oldVal){
			if( newVal && newVal.length > 0 )
				$scope.tableTranslationSetup = JSON.parse(newVal);
		});

		$scope.$watch('fileInputTranslations',function(newVal,oldVal){
			if( newVal && newVal.length > 0 )
			{
				$scope.fileInputTranslationSetup = JSON.parse(newVal);
				$scope.fileInputPath = $scope.fileInputTranslationSetup.chosenFileLabel;
			}
		});

		$scope.$watch('uploadEnabled',function(newVal,oldVal){
			if( newVal && newVal.length > 0 )
				$scope.uploadEnabled = JSON.parse(newVal.toLowerCase());
		});

		$scope.$watch('statusCodes', function( newVal, oldVal ){
			if( newVal && newVal.length > 0 )
				$scope.localStatusCodes = JSON.parse(newVal);
		});

		$scope.$watch('parentRecord', function( newVal, oldVal ){
			if( newVal && newVal.length > 0 )
			{
				var jsonObject = JSON.parse( newVal );
				if( jsonObject.application )
					$scope.objApplication = JSON.parse( newVal ).application;
				if( jsonObject.questionAttachments )
				{
					for( var index = 0; index < jsonObject.questionAttachments.length; index ++ )
					{
						if( $scope.questionAttachmentId === jsonObject.questionAttachments[index].Id )
						{
							$scope.questionId = jsonObject.questionAttachments[index].FGM_Portal__Question__c;
							$scope.attachmentNamingFormula = jsonObject.questionAttachments[index].FGM_Portal__Question__r.FGM_Portal__AttachmentNameFormula__c;
							break;
						}
					}
				}
			}
		});

		$scope.$watch('questionId', function( newVal, oldVal ){
			if( newVal && newVal.length > 0 )
			{
				$scope.preFetchProcessCount--;
			}
		});

		$scope.$watch( 'preFetchProcessCount', function( newVal ){
			if( newVal <= 0 )
			{
				$scope.localAttachments = $attachmentUploadUtilities.getAttachments( JSON.parse($scope.attachments), $scope.questionId );
			}
			if(jsMode && jsMode == 'view')
				$scope.controlSetup.isEditable = false
		} );
	};

	directiveObj.controller = function($scope,$timeout, $sce)
	{
		$scope.s4 = function()
		{
			return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
		}

		$scope.generateGUID = function( suffix )
		{
			return $scope.s4() + '-' + $scope.s4() + '-' + suffix;
		}

		$scope.areAttachmentsFetched = false;
		$scope.isUploadSupported = true;
		if( navigator.appName && navigator.appName.indexOf( 'Internet Explorer' ) )
		{
			if( navigator.appVersion && navigator.appVersion.indexOf( 'MSIE 9.0' ) >= 0 )
				$scope.isUploadSupported = false;
			if( navigator.appVersion && navigator.appVersion.indexOf( 'MSIE 8.0' ) >= 0 )
				$scope.isUploadSupported = false;
		}

		$scope.directiveId = $scope.generateGUID( $scope.questionAttachmentId );
		
		$scope.preFetchProcessCount = 2;

		$scope.request = {};
		$scope.request.showInfo = false;

		$scope.description = '';
		$scope.descriptionLength = 0;
		$scope.descriptionAllowedLength = 0;

		$scope.progress = {};
		$scope.progress.counter = -1;
		$scope.progress.isActive = false;

		if( typeof $scope.localAttachments === 'undefined'  )
			$scope.localAttachments = [];

		$scope.isUploadDisabled = true;
		$scope.documentShareType = 'V';

		$scope.getFileFromControl = function(element)
		{
			$scope.isUploadDisabled = true;
			$scope.fileInputPath = $scope.fileInputTranslationSetup.chosenFileLabel;

			if( element.files.length > 0 )
			{
				var fileValidationResult = $attachmentUploadUtilities.validateCommunitySettings( element.files[0], $scope.controlSetup );
				if( fileValidationResult === 'Okay' )
				{
					$scope.request = {};
					
					$scope.isUploadDisabled = false;
					$scope.fileInputPath = element.files[0].name;
					var fileObj = element.files[0];
					
					var fileName = '';

					if( $scope.attachmentNamingFormula )
					{
						var formulaTokens = $scope.attachmentNamingFormula.split('+');
						for( var tokenIndex = 0; tokenIndex < formulaTokens.length; tokenIndex++ )
						{
							var token = formulaTokens[tokenIndex];
							if( formulaTokens[tokenIndex].indexOf('\'') >= 0 )
							{
								token = token.substring( token.indexOf('\'') + 1, token.lastIndexOf('\'') );
								if( fileName.length > 0 )
									fileName += '-';
								fileName += token;
							}
							else if( formulaTokens[tokenIndex].indexOf('FileName') < 0 )
							{
								if( $scope.objApplication && $scope.objApplication[token] )
								{
									token = $scope.objApplication[token];
									if( fileName.length > 0 )
										fileName += '-';
									fileName += token;
								}
							}
							else
							{
								if( fileName.length > 0 )
									fileName += '-';
								fileName += element.files[0].name;
							}
						}
					}
					else
						fileName += element.files[0].name;

					if( !$scope.controlSetup.isFile )
					{
						// attachment with or without scan
						$scope.formData = $attachmentUploadUtilities.createFormDataObject( fileObj, fileName, $scope.controlSetup.networkId, $scope.controlSetup.sessionId, $scope.questionAttachmentId, $scope.controlSetup.userId, $scope.controlSetup.isFile, $scope.controlSetup.isScanEnabled, $scope.controlSetup.restApiUrl, $scope.controlSetup.chatterApiUrl, $scope.localStatusCodes);
						$scope.xmlHttpRequest = $attachmentUploadUtilities.createHttpRequestObject( $scope.controlSetup.virusScanUrl, 'POST', 'multipart/form-data', false, $attachmentUploadUtilities.getXhrFunction( $scope.trackUploadProgress ) );
					}
					else
					{
						if( !$scope.controlSetup.isScanEnabled )
						{
							// file without scan
							$scope.formData = $attachmentUploadUtilities.createFormDataObject( fileObj, fileName );
							$scope.xmlHttpRequest = $attachmentUploadUtilities.createHttpRequestObject( $scope.controlSetup.chatterApiUrl, 'POST', 'multipart/form-data', false, $attachmentUploadUtilities.getXhrFunction( $scope.trackUploadProgress ), $scope.controlSetup.sessionId );
						}
						else
						{
							// file with scan
							$scope.formData = $attachmentUploadUtilities.createFormDataObject( fileObj, fileName, $scope.controlSetup.networkId, $scope.controlSetup.sessionId, $scope.questionAttachmentId, $scope.controlSetup.userId, $scope.controlSetup.isFile, $scope.controlSetup.isScanEnabled, $scope.controlSetup.restApiUrl, $scope.controlSetup.chatterApiUrl, $scope.localStatusCodes);
							$scope.xmlHttpRequest = $attachmentUploadUtilities.createHttpRequestObject( $scope.controlSetup.virusScanUrl, 'POST', 'multipart/form-data', false, $attachmentUploadUtilities.getXhrFunction( $scope.trackUploadProgress ) );
						}
					}
					$scope.xmlHttpRequest.data = $scope.formData;
				}
				else if( fileValidationResult === 'FileSizeException'  )
				{
					$scope.request.showInfo = true;
					$scope.request.status = 'failure';
					$scope.request.message = $scope.localStatusCodes.fgm_portal__FC_Attachment_size_ErrorMsg;
					element.files[0].value = "";
					$scope.isUploadDisabled = true;
					$scope.fileInputPath = element.files[0].name;
				}
				else if( fileValidationResult === 'FileExtensionException' )
				{
					$scope.request.showInfo = true;
					$scope.request.status = 'failure';
					$scope.request.message = $scope.localStatusCodes.fgm_portal__FC_File_Extension_Not_Allowed;
					element.files[0].value = "";
					$scope.isUploadDisabled = true;
					$scope.fileInputPath = element.files[0].name;
				}
				else if( fileValidationResult === 'FileSizeZero' )
				{
					$scope.request.showInfo = true;
					$scope.request.status = 'failure';
					$scope.request.message = $scope.localStatusCodes.fgm_portal__FC_zero_byte_File_Error_Message;
					element.files[0].value = "";
					$scope.isUploadDisabled = true;
					$scope.fileInputPath = element.files[0].name;
				}
			}
			element.removeAttribute('disabled');
			$timeout( function(){
				$scope.$apply();	
			},10 );
			
		}
		
		$scope.uploadFile = function()
		{
			isRecordChanged = false;
			$scope.isUploadDisabled = true;
			$scope.progress.counter = 0;
			$scope.progress.isActive = true;
			var max = Math.floor(Math.random() * (98 - 88 + 1)) + 88;
			var min = Math.floor(Math.random() * (85 - 75 + 1)) + 75;
			$scope.random = Math.floor(Math.random() * (max - min + 1)) + min;
			$scope.addDirectiveToProcessQueue();

			if( document.getElementById($scope.directiveId + '-description') )
				$scope.description = document.getElementById($scope.directiveId + '-description').value;
			
			if( $scope.description && $scope.description.length > 0 )
			{
				var formData = $scope.xmlHttpRequest.data;
				formData.append( 'desc', $scope.description );
				$scope.xmlHttpRequest.data = formData;
			}
			
			$attachmentUploadUtilities.uploadFile( $scope.xmlHttpRequest, $scope.questionAttachmentId, $scope.description, $scope.documentShareType,$scope ).then( function successCallback(result)
			{
				if( result.success == true )
				{
					$scope.request.showInfo = true;
					$scope.request.status = 'success';
					$scope.request.message = $scope.localStatusCodes.fgm_portal__FC_File_Upload_Success_Message;
					$scope.progress.counter = -1;
					$scope.progress.isActive = false;

					$scope.fileInputPath = $scope.fileInputTranslationSetup.chosenFileLabel;
					$scope.isUploadDisabled = true;
					$scope.fileInputElement = {};
					if( document.getElementById($scope.directiveId + '-description'))
						document.getElementById($scope.directiveId + '-description').value = '';
					$scope.countDescriptionLength();
					
				}
				else if( typeof result === 'string' &&  result.indexOf('statusMessage') >= 0 )
				{
					$scope.request.showInfo = true;
					$scope.request.status = 'success';
					$scope.request.message = $scope.localStatusCodes.fgm_portal__FC_File_Upload_Success_Message;
					
					$scope.progress.counter = -1;
					$scope.progress.isActive = false;

					$scope.fileInputPath = $scope.fileInputTranslationSetup.chosenFileLabel;
					$scope.isUploadDisabled = true;
					$scope.fileInputElement = {};
					if( document.getElementById($scope.directiveId + '-description'))
						document.getElementById($scope.directiveId + '-description').value = '';
					$scope.countDescriptionLength();
					
				}
				
				document.getElementById($scope.directiveId).value = '';

				$attachmentUploadUtilities.getAttachmentsFromSF( $scope.questionAttachmentId ).then( function successCallback(result)
				{
					//$scope.localAttachments = [];
					var attachmentIds = [];
					for( var attchmntIndex = 0; attchmntIndex < $scope.localAttachments.length; attchmntIndex ++ )
					{
						attachmentIds.push( $scope.localAttachments[attchmntIndex].id );
					}
					for( var index = 0; index < result.length; index ++ )
					{
						if( attachmentIds.indexOf( result[index].id ) < 0)
						{
							var attachment = {};
							attachment = result[index];
							attachment.name = $sce.trustAsHtml( result[index].name );
							attachment.description = $sce.trustAsHtml( result[index].description );
							attachment.createdDate = result[index].createdDate;
							$scope.localAttachments.push( attachment );
							break;
						}
					}
					$scope.removeDirectiveFromProcessQueue();
					$timeout(function() {
						$scope.hideRequestStatus();
					}, 15000);

				}, function errorCallback( error){
					$scope.isUploadDisabled = true;
					$scope.fileInputElement = {};
					$scope.removeDirectiveFromProcessQueue();
				} );
			},function errorCallback(error){
				
				$scope.request.message = $scope.localStatusCodes.fgm_portal__FC_AttachmentProcess_ErrorMsg;
				var errorJSON = {};
				if( typeof error === 'string' )
				 	errorJSON = JSON.parse( error );
			 	else
			 		errorJSON = error;

			 	if( errorJSON.responseText && errorJSON.responseText.indexOf('errorCode') >= 0 )
				{
					if( JSON.parse(errorJSON.responseText)[0].errorCode === 'FILE_EXTENSION_NOT_ALLOWED' )
						$scope.request.message = $scope.localStatusCodes. fgm_portal__FC_File_Extension_Not_Allowed;
					if( JSON.parse(errorJSON.responseText)[0].errorCode === 'FILE_SIZE_LIMIT_EXCEEDED' )
						$scope.request.message = $scope.localStatusCodes.fgm_portal__FC_Attachment_size_ErrorMsg;
					console.log( 'Exception: ' + JSON.parse(errorJSON.responseText)[0].message );
				}
				else if( errorJSON.statusMessage )
				{
					console.log( 'Exception: ' + errorJSON.statusMessage );
					if( $scope.localStatusCodes.fgm_portal__FC_Infected_File_Error_Message === errorJSON.statusMessage )
						$scope.request.message = errorJSON.statusMessage;
				}

				$scope.request.showInfo = true;
				$scope.request.status = 'failure';
				
				$scope.progress.counter = -1;
				$scope.progress.isActive = false;
				
				$scope.isUploadDisabled = false;
				
				document.getElementById($scope.directiveId).value = '';
				
				$scope.removeDirectiveFromProcessQueue();
				
				$scope.countDescriptionLength();
				
				$timeout(function() {
					$scope.hideRequestStatus();
				}, 15000);
			});
		}

		$scope.hideRequestStatus = function()
		{
			$scope.request = {};
			$scope.request.showInfo = false;
			$timeout(function() {
					$scope.$apply();
				}, 15000);
		}

		$scope.deleteAttachment = function(attachmentId, type, questionAttachmentId)
		{
			$attachmentUploadUtilities.deleteAttachments( type, attachmentId,questionAttachmentId).then(function successCallback(result, error){
				var newArray = [];
				for( var index = 0; index < $scope.localAttachments.length; index ++ )
				{
					if( $scope.localAttachments[index].id == result[0].id )
						matchIndex = index;
					else
						newArray.push($scope.localAttachments[index]);
				}
				$scope.localAttachments = newArray;

			},function errorCallback(error){
				console.log(error);
			});
		}

		$scope.trackUploadProgress = function(event)
		{
			$scope.progress.counter = Math.ceil(( event.loaded / event.total ) * $scope.random);

			$timeout(function() {
				$scope.$apply();
			});
		}

		// not in use right now
		$scope.countDescriptionLength = function( event )
		{
			if( document.getElementById($scope.directiveId + '-description') )
			{
				if( event && event.key === 'Enter' )
				{
					var data = document.getElementById( $scope.directiveId + '-description' ).value;
					if( data.length + 2 > $scope.descriptionAllowedLength )
						event.preventDefault();
				}
				$timeout( function(){
					if( document.getElementById( $scope.directiveId + '-description' ) )
					{
						var data = document.getElementById( $scope.directiveId + '-description' ).value;
						var acceptedData = '';
						var lineBreaks = data.match( new RegExp( '\n', 'g' ) );
						var dataLength = 0;
						if( lineBreaks && lineBreaks.length > 0 )
						{
							for( var index = 0; index < lineBreaks.length; index++ )
								dataLength++;
						}
						acceptedData = data.slice( 0, ( $scope.controlSetup.isFile == true ? 1000: 500 )  - dataLength );
						document.getElementById( $scope.directiveId + '-description' ).value = acceptedData;
						$scope.descriptionLength = acceptedData.length + dataLength;
						$scope.descriptionAllowedLength = ( $scope.controlSetup.isFile == true ? 1000: 500 ) - dataLength;
						$scope.$apply();
					}
				}, 100 );
			}
		}

		$scope.addDirectiveToProcessQueue = function()
		{
			if( uploadProcessQueue )
				uploadProcessQueue.push( $scope.directiveId );
		}

		$scope.removeDirectiveFromProcessQueue = function()
		{
			if( uploadProcessQueue )
			{
				var index = uploadProcessQueue.indexOf( $scope.directiveId );
				if( index >= 0 )
					uploadProcessQueue.splice( index, 1 );
			}
		}

		$scope.confirmDelete = function( attachmentId, type, questionAttachmentId )
		{
			if( confirm( $scope.tableTranslationSetup.deleteConfirmation ) )
			{
				$scope.deleteAttachment( attachmentId, type, questionAttachmentId );
			}
			return false;
		}
	}
	return directiveObj;
});
uploadManagerApp.service('$attachmentUploadUtilities',function($exception, $q, $database, $sce){
	var serviceHandle = this;
	serviceHandle.getAttachments = function( attachmentsWithParentMap, parentId)
	{
		var attachments = [];
		if( attachmentsWithParentMap && parentId )
		{
			for(var index = 0; index < attachmentsWithParentMap.length; index ++ )
			{
				var attachment = {};
				attachment = attachmentsWithParentMap[index];
				attachment.name = $sce.trustAsHtml( attachment.name );
				attachment.description = $sce.trustAsHtml( attachment.description );
				if( attachmentsWithParentMap[index].relatedQuestions.indexOf( parentId ) >= 0 )
					attachments.push( attachment );
				else if( attachmentsWithParentMap[index].question.Id === parentId )
					attachments.push( attachment );
			}
		}
		return attachments;
	}
	serviceHandle.createFormDataObject = function( fileObj, fileName, networkId, sessionId, recordId, userId, isFile, doScan, restApiUrl, chatterApiUrl, customErrors)
	{
		if( typeof fileObj === 'object' )
		{
			var formDataObj = new FormData();
			formDataObj.append('fileData', fileObj, fileName);

			formDataObj.append('customErrors', JSON.stringify(customErrors));
			
			if( networkId )
				formDataObj.append('networkId', networkId);
			
			if( sessionId )
				formDataObj.append('sessionId',sessionId);
			
			if( recordId )
				formDataObj.append('recordId',recordId);
			
			if( userId )
				formDataObj.append('userId',userId);
			
			if( isFile )
				formDataObj.append('isFile',isFile);
			
			if( doScan )
				formDataObj.append('doScan',doScan);
			
			if( restApiUrl )
				formDataObj.append('restApi',restApiUrl);
			
			if( chatterApiUrl )
				formDataObj.append('chatterApi',chatterApiUrl);

			return formDataObj;	
		}
		return;
	}
	serviceHandle.createHttpRequestObject = function( url, method, mimeType, contentType, xhr, sessionId)
	{
		if( typeof url !== 'undefined' )
		{
			var httpRequestObject = {};
			httpRequestObject.url = url;
			httpRequestObject.method = 'GET';
			httpRequestObject.processData = false;

			if( method )
				httpRequestObject.method = method;
			
			if( mimeType )
			{
				httpRequestObject.mimeType = mimeType;
				httpRequestObject.contentType = false;
			}
			else if( contentType )
				httpRequestObject.contentType = contentType;

			if( xhr && typeof xhr === 'function' )
				httpRequestObject.xhr = xhr;

			if( sessionId )
			{
				httpRequestObject.headers = {};
				httpRequestObject.headers.Authorization = 'Bearer ' + sessionId;
			}
		}
		else
			return;
		return httpRequestObject;
	}
	serviceHandle.getXhrFunction = function(progressTrackerFunction)
	{
		var xhrFunction = function()
		{
			var thisXhr = new XMLHttpRequest();
	        if( thisXhr.upload ){
	           // thisXhr.upload.addEventListener('progress',progressTrackerFunction,false);
	           thisXhr.upload.onprogress = progressTrackerFunction;
	        }
	        return thisXhr;	
		}
		return xhrFunction;
	}
	serviceHandle.uploadFile = function( xmlHttpRequestObj, recordId, description, shareType, scope )
	{
		var deferred = $q.defer();
		if( typeof xmlHttpRequestObj === 'object' )
		{
			var ajaxRequestSuccessCallback = function(response)
			{
				if( JSON.parse( response ).is_uploaded == true ){
					scope.progress.counter = 100;
					scope.$apply();
					setTimeout(function(){return deferred.resolve(response); }, 1000);

					
				}
				else if( JSON.parse( response ).id )
				{
					serviceHandle.attachFileToRecord( JSON.parse( response ).id, recordId, description, shareType  ).then( function successCallback(response){
						return deferred.resolve( response );
					}, function errorCallback(error){
						return deferred.reject( error );
					} );
				}
				else
					return deferred.reject(response);
			}
			
			var ajaxRequestErrorCallback = function(response,error)
			{
				return deferred.reject(response);
			}
			$.ajax(xmlHttpRequestObj).done(ajaxRequestSuccessCallback).fail(ajaxRequestErrorCallback);
		}
		else
			return deferred.reject(  );
		return deferred.promise;
	}
	// written for future use
	serviceHandle.sendAjaxRequest = function( requestBaseUrl, sessionId, method, sObjectApiName, jsonObject )
	{
		var deferred = $q.defer();
		if( requestBaseUrl && sessionId && method && jsonObject )
		{

			var xmlHttpRequestObj = serviceHandle.createHttpRequestObject( requestBaseUrl + '/' + sObjectApiName, method, null, 'application/json', null, sessionId );
			xmlHttpRequestObj.data = JSON.stringify( jsonObject );
			$.ajax( xmlHttpRequestObj ).done( function( response ){
				return deferred.resolve( response );
			} ).fail( function( error ){
				return deferred.reject( error );
			} );
		}
		else
			return deferred.reject();
		return deferred.promise;
	}

	serviceHandle.attachFileToRecord = function( fileId, recordId, description, shareType )
	{
		var deferred = $q.defer();
		if( fileId && recordId )
		{
			var successCallback = function( result, error )
			{
				if( error.status == true )
					return deferred.resolve( result );
				else
				{
					var exception = $exception.create( error.action + '.' + error.method, error.message );
					return deferred.reject( exception );
				}
			}
			if( !description )
				description = null;
			if( !shareType )
				shareType = 'V';
			Visualforce.remoting.Manager.invokeAction( engineMethodPath + '.insertAndUpdateContentDocumentLink', recordId, fileId, description, shareType, successCallback );
		}
		else
			return deferred.reject();
		return deferred.promise;
	}
	serviceHandle.deleteAttachments = function(sObjectApiName, lstIds, questionAttachmentId)
	{
		
		var lstIdsToDelete = [];
		if( typeof lstIds === 'string' )
			lstIdsToDelete.push(lstIds);
		else if( typeof lstIds === 'array' )
			lstIdsToDelete = lstIds;
		
		var deferred = $q.defer();

		var successCallback = function(result)
		{
			return deferred.resolve(result);
		}

		var errorCallback = function(error)
		{
			return deferred.reject(error);
		}
		$database.deleteAttachments( sObjectApiName, lstIdsToDelete, questionAttachmentId).then(successCallback,errorCallback);

		return deferred.promise;
	}
	serviceHandle.translationsForStatusCodes = function( uploadFailureMsg, uploadSuccessMsg, fileInfectedMsg, extensionErrorMsg, sizeErrorMsg, zeroByteError, ie_9_exception )
	{
		var translation = {};
		translation.fgm_portal__FC_AttachmentProcess_ErrorMsg = uploadFailureMsg;
		translation.fgm_portal__FC_File_Upload_Success_Message = uploadSuccessMsg;
		translation.fgm_portal__FC_Infected_File_Error_Message = fileInfectedMsg;
		translation.fgm_portal__FC_File_Extension_Not_Allowed = extensionErrorMsg;
		translation.fgm_portal__FC_Attachment_size_ErrorMsg = sizeErrorMsg;
		translation.fgm_portal__FC_zero_byte_File_Error_Message = zeroByteError;
		translation.ie_9_exception = ie_9_exception;
		return translation;
	}
	serviceHandle.translationsForAttachmentTable = function(serialNumber, name, description, createdDate, actionColumn, deleteAction, noRecordsFound, deleteConfirmation)
	{
		var translation = {};
		translation.serialNumber = serialNumber;
		translation.name = name;
		translation.description = description;
		translation.createdDate = createdDate;
		translation.actionColumn = actionColumn;
		translation.deleteAction = deleteAction;
		translation.noRecordsFound = noRecordsFound;
		translation.deleteConfirmation = deleteConfirmation;
		return translation;
	}
	serviceHandle.translationsForFileUploader = function(choseFileBtn, chosenFileLabel, uploadBtn, descriptionPlaceholder, processingLabel, characterCountOfLabel, charactersLabel)
	{
		var translation = {};
		translation.choseFileBtn = choseFileBtn;
		translation.chosenFileLabel = chosenFileLabel;
		translation.uploadBtn = uploadBtn;
		translation.descriptionPlaceholder = descriptionPlaceholder;
		translation.processingLabel = processingLabel;
		translation.characterCountOfLabel = characterCountOfLabel;
		translation.charactersLabel = charactersLabel;
		return translation;
	}
	// not in use
	serviceHandle.initializationSettings = function(sessionId, userId, orgId, chatterApiUrl, restApiUrl, networkId, isEditable, isScanEnabled, isFile, virusScanUrl)
	{
		var setting = {};
		setting.sessionId = sessionId.toString();
		setting.userId = userId.toString();
		setting.orgId = orgId.toString();
		setting.chatterApiUrl = chatterApiUrl;
		setting.restApiUrl = restApiUrl;
		setting.isEditable = isEditable;
		setting.isScanEnabled = isScanEnabled.toString();
		setting.isFile = isFile.toString();
		setting.virusScanUrl = virusScanUrl;
		setting.networkId = networkId.toString();
		return setting;
	}
	serviceHandle.getAttachmentsFromSF = function( parentId, lookupFieldApiName, lookupFieldValue )
	{
		var deferred = $q.defer();
		if( typeof engineMethodPath !== 'undefined' && engineMethodPath )
		{
			if( !parentId )
				var parentId = null;
			if( !lookupFieldValue )
				var lookupFieldValue = null;
			if( !lookupFieldApiName )
				var lookupFieldApiName = null;
			Visualforce.remoting.Manager.invokeAction( engineMethodPath + '.getAttachments', parentId, lookupFieldApiName, lookupFieldValue, function(result, error){
				if( error.status == true )
				{
					return deferred.resolve(result);
				}
				else
					return deferred.reject(error);
			},{ escape : false }); 
		}
		return deferred.promise;
	}
	// for future use to avoid queries after file upload
	serviceHandle.createAttachmentObj = function( id, name, description, createdDate, fileType, contentSize )
	{
		var attachment = {};
		attachment.id = id;
		attachment.name = name;
		attachment.description = description;
		attachment.createdDate = Date.parse(createdDate);
		attachment.fileType = fileType;
		attachment.contentSize = contentSize;
		attachment.type = 'ContentDocument';
		return attachment;
	}
	serviceHandle.validateCommunitySettings = function( fileObj, initializationSettings )
	{
		var defaultFileSizeInBytes = initializationSettings.isFile == true ? 2147483648 : 38797312;
		var allowedFileSizeInBytes;
		if( initializationSettings.allowedFileSizeInBytes )
		{
			if( initializationSettings.allowedFileSizeInBytes < defaultFileSizeInBytes )
				allowedFileSizeInBytes = initializationSettings.allowedFileSizeInBytes;
			else
				allowedFileSizeInBytes = defaultFileSizeInBytes;
		}
		else
			allowedFileSizeInBytes = defaultFileSizeInBytes;
		if( serviceHandle.checkAllowedFileSize( fileObj, allowedFileSizeInBytes ))
		{
			if( !serviceHandle.checkZeroSize( fileObj ) )
				return 'FileSizeZero';
			if( serviceHandle.checkAllowedExtension( fileObj, initializationSettings.allowedFileExtensions ) )
				return 'Okay';
			else
				return 'FileExtensionException';
		}
		else
			return 'FileSizeException';
	}
	serviceHandle.checkZeroSize = function( fileObj )
	{
		if( fileObj && fileObj.size === 0 )
			return false;
		else
			return true;
	}
	serviceHandle.checkAllowedFileSize = function( fileObj, allowedFileSizeInBytes )
	{
		if( fileObj && fileObj.size && allowedFileSizeInBytes )
		{
			if( fileObj.size > allowedFileSizeInBytes)
				return false;
		}
		return true;
	}
	serviceHandle.checkAllowedExtension = function( fileObj, allowedExtensions )
	{
		if( fileObj && allowedExtensions )
		{
			var fileExtension = fileObj.name.split('.').pop().toLowerCase();
			for( var index = 0; index < allowedExtensions.length; index ++ )
			{
				var allowedExtension = allowedExtensions[index].toLowerCase();
				if( fileExtension === allowedExtension )
					return true;
			}
			return false;
		}
		return true;
	}
});

var templateValue = '';
templateValue += "<div class=\"bootstrap-fc\" style=\"font-size: 13px; border: 1px solid #aaa;margin: 1%;padding: 1%;border-radius: 3px;padding-top: 2%;width:95%;max-width:1250px;min-width: 800px;text-align: left;display: inline-block;background-color: white\">\r\n\t<table class=\"table table-sm\">\r\n\t\t<tr>\r\n\t\t\t<!--<th style=\"width: 5%\">{{tableTranslationSetup.type}}<\/th>-->\r\n\t\t\t<th style=\"width: 5%\" ng-bind-html=\"tableTranslationSetup.serialNumber\"><\/th>\r\n\t\t\t<th style=\"width: 30%\" ng-bind-html=\"tableTranslationSetup.name\"><\/th>\r\n\t\t\t<th style=\"width: {{ controlSetup.isEditable ? \'40\' : \'50\' }}%\" ng-bind-html=\"tableTranslationSetup.description\"><\/th>\r\n\t\t\t<th style=\"width: 15%\" ng-bind-html =\"tableTranslationSetup.createdDate\"><\/th>\r\n\t\t\t<th style=\"width: 10%\" ng-if=\"controlSetup.isEditable\" ng-bind-html=\"tableTranslationSetup.actionColumn\"><\/th>\r\n\t\t<\/tr>\r\n\t\t<tr ng-if=\"localAttachments.length <= 0\">\r\n\t\t\t<td colspan=\"{{ controlSetup.isEditable ? 5 : 4 }}\">{{tableTranslationSetup.noRecordsFound}}<\/td>\r\n\t\t<\/tr>\r\n\t\t<tr ng-if=\"localAttachments.length > 0\" ng-repeat=\"attachment in localAttachments | orderBy: \'-createdDate\' track by $index\">\r\n\t\t\t<!--<td>{{attachment.type}}<\/td>-->\r\n\t\t\t<td>{{$index + 1}}<\/td>\r\n\t\t\t<td class=\"wrapData\">\r\n\t\t\t\t<a href=\"{{attachment.downloadUrlPath}}\" target=\"_blank\" style=\"text-decoration: none\" ng-bind-html=\"attachment.name\"><\/a>\r\n\t\t\t<\/td>\r\n\t\t\t<td class=\"wrapData\" ng-bind-html=\"attachment.description\"><\/td>\r\n\t\t\t<td>{{attachment.createdDate | date : \'MM\/dd\/yy\'}}<\/td>\r\n\t\t\t<td ng-if=\"controlSetup.isEditable\"><a ng-if=\"attachment.isDeletable\" href=\"\" ng-click=\"confirmDelete( attachment.id, attachment.type, attachment.questionAttachmentId )\"  style=\"text-decoration: none\">{{tableTranslationSetup.deleteAction}}<\/a><\/td>\r\n\t\t<\/tr>\r\n\t<\/table>\r\n\t<div class=\"attachment-uplod-control-container\" style=\"display:inline-block;width:100%;\" ng-show=\"uploadEnabled && isUploadSupported\">\r\n\t\t<textarea ng-if=\"controlSetup.isDescriptionEnabled\" id=\"{{directiveId}}-description\" placeholder=\"{{fileInputTranslationSetup.descriptionPlaceholder | removetags }}\" style=\"width: 100%;font-size: 13px;border-radius: 3px;max-width: 1250px; min-width: 800px\" ng-keydown=\"countDescriptionLength( $event )\" ng-paste=\"countDescriptionLength()\" ng-cut=\"countDescriptionLength()\" maxlength=\"{{descriptionAllowedLength}}\"><\/textarea>\r\n\t\t<div ng-if=\"controlSetup.isDescriptionEnabled\" style=\"text-align: right;margin-top: .5%;display: inline-block;width: 100%;font-style: italic;font-size: 11px;\">{{descriptionLength}} {{fileInputTranslationSetup.characterCountOfLabel}} {{controlSetup.isFile == true ? \'1000\' : \'500\'}} {{fileInputTranslationSetup.charactersLabel}}<\/div>\r\n\t\t<br\/>\r\n\t\t<div >\r\n\t\t\t<div style=\"display:inline-block;width:49%\">\r\n\t\t\t\t<label for=\"{{directiveId}}\" class=\"btn btn-sm btn-primary\" style=\"font-size: 13px\" ng-disabled=\"progress.isActive\">{{fileInputTranslationSetup.choseFileBtn}}<\/label>\r\n\t\t\t\t<input id=\"{{directiveId}}\" type=\"file\" name=\"fileUploader\" onchange=\"angular.element(this).scope().getFileFromControl(this)\" style=\"width: 85%;display: none\" ng-disabled=\"progress.isActive\">\r\n\t\t\t\t<input type=\"button\" class=\"btn btn-sm btn-primary\" value=\"{{fileInputTranslationSetup.uploadBtn}}\" ng-click=\"uploadFile()\" style=\"font-size: 13px\" ng-disabled=\"isUploadDisabled\" \/>\r\n\t\t\t\t<br\/><br\/>\r\n\t\t\t\t<label ng-bind=\"fileInputPath\" style=\"width: 70%;font-size: 13px\"><\/label>\r\n\t\t\t<\/div>\r\n\t\t\t<div class=\"progress-bar-container\" ng-show=\"progress.counter >= 0 && !request.showInfo\" style=\"display: inline-block;width: 50%;text-align: right;\">\r\n\t\t\t\t<div style=\"display: inline-block;width: 100%\">\r\n\t\t\t\t\t<div class=\"progress\" style=\"width: 100%;\">\r\n\t\t\t\t\t\t<div class=\"progress-bar\" ng-style=\"{ \'width\' : progress.counter + \'%\'}\"><\/div>\r\n\t\t\t\t\t<\/div>\t\r\n\t\t\t\t<\/div>\r\n\t\t\t\t<br\/>\r\n\t\t\t\t<div style=\"display: inline-block; width: 100%; text-align: left;\">\r\n\t\t\t\t\t<div style=\"display: inline-block\">{{fileInputTranslationSetup.processingLabel}}<\/div>\r\n\t\t\t\t\t<div style=\"display: inline-block;float: right;\">{{progress.counter}}%<\/div>\t\r\n\t\t\t\t<\/div>\r\n\t\t\t<\/div>\t\r\n\t\t\t<div class=\"progress-bar-container\" style=\"display: inline-block;width: 50%;text-align: right;vertical-align: top;\" ng-show=\"request.showInfo\">\r\n\t\t\t\t<div style=\"padding: 1%;text-align: right;\">\r\n\t\t\t\t\t<div style=\"display: inline-block;height: 20px;\">{{request.message}}<\/div>\r\n\t\t\t\t\t<span class=\"glyphicon glyphicon-{{request.status == \'failure\' ? \'alert\' : \'ok-sign\'}}\" style=\"font-size: 20px;color: {{request.status == \'failure\' ? \'red\' : \'#3cb63c\'}};\" ng-show=\"request.showInfo\"><\/span>\r\n\t\t\t\t<\/div>\r\n\t\t\t<\/div>\r\n\t\t<\/div>\r\n\t<\/div>\r\n\t<div class=\"attachment-uplod-control-container\" style=\"display:inline-block;width:100%;\" ng-show=\"!isUploadSupported\">\r\n\t\t<div style=\"padding: 1%;text-align: right;\">\r\n\t\t\t<div style=\"display: inline-block;height: 20px;\">{{localStatusCodes.ie_9_exception}}<\/div>\r\n\t\t\t<span class=\"glyphicon glyphicon-alert\" style=\"font-size: 20px;color:red;\" ><\/span>\r\n\t\t<\/div>\r\n\t<\/div>\r\n<\/div>";
// the above string is generated using the online tool - https://www.freeformatter.com/javascript-escape.html. You just need to preprend and append the " ( double quote ) to the output that you will recieve from the tool