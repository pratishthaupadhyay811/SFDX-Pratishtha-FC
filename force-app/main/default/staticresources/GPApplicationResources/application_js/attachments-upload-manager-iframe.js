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
			if( navigator.userAgent.indexOf('Trident') >= 0 && navigator.userAgent.indexOf('rv:11') >= 0 )
			{
				if( navigator.appVersion && navigator.appVersion.indexOf( 'MSIE 9.0' ) >= 0 )
					$scope.isUploadSupported = false;
				if( navigator.appVersion && navigator.appVersion.indexOf( 'MSIE 8.0' ) >= 0 )
					$scope.isUploadSupported = false;
			}
			else
				$scope.isUploadSupported = true;
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
			window.parent.isRecordChanged = false;
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
			
			$attachmentUploadUtilities.uploadFile( $scope.xmlHttpRequest, $scope.questionAttachmentId, $scope.description, $scope.documentShareType, $scope ).then( function successCallback(result)
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

				$attachmentUploadUtilities.getAttachmentsFromSF().then(function(result)
				{
					var attachmentIds = [];
					for( var attchmntIndex = 0; attchmntIndex < $scope.localAttachments.length; attchmntIndex ++ )
					{
						attachmentIds.push( $scope.localAttachments[attchmntIndex].id );
					}
					for( var index = 0; index < result.length; index ++ )
					{
						if( attachmentIds.indexOf( result[index].id ) < 0 && result[index].question == $scope.questionId)
						{
							var attachment = {};
							attachment = result[index];
							attachment.name = $sce.trustAsHtml( result[index].name);
							attachment.description = $sce.trustAsHtml(result[index].description);
							$scope.localAttachments.push( attachment );
							break;
						}
					}
					$scope.removeDirectiveFromProcessQueue();
					$timeout(function() {
						$scope.hideRequestStatus();
					}, 1500);

				}, function errorCallback( error){
					$scope.isUploadDisabled = true;
					$scope.fileInputElement = {};
					$scope.removeDirectiveFromProcessQueue();
				});
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
			$scope.$apply();
		}

		$scope.deleteAttachment = function(attachmentId, type, questionAttachmentId)
		{
			$attachmentUploadUtilities.deleteAttachments( type, attachmentId,questionAttachmentId).then(function successCallback(result, error){
				var newArray = [];
				for( var index = 0; index < $scope.localAttachments.length; index ++ )
				{
					if( $scope.localAttachments[index].id == result[0])
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
			if(window.parent.uploadProcessQueue )
				window.parent.uploadProcessQueue.push( $scope.directiveId );
		}

		$scope.removeDirectiveFromProcessQueue = function()
		{
			if(window.parent.uploadProcessQueue )
			{
				var index = window.parent.uploadProcessQueue.indexOf( $scope.directiveId );
				if( index >= 0 )
					window.parent.uploadProcessQueue.splice( index, 1 );
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
				else if( attachmentsWithParentMap[index].question === parentId )
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
	        if( thisXhr.upload )
	            thisXhr.upload.addEventListener('progress',progressTrackerFunction,false);
	        return thisXhr;	
		}
		return xhrFunction;
	}
	serviceHandle.uploadFile = function( xmlHttpRequestObj, recordId, description, shareType,scope )
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
					scope.progress.counter = 100;
					scope.$apply();
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
		var sessionId = initializeSettings.sessionId;
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


			var requestUrl = window.location.protocol + '//' + window.location.host + '/services/data/v41.0/sobjects/ContentDocument/' + fileId;
			var requestSetting = {};
			requestSetting.method = 'GET';
			requestSetting.url = requestUrl;
			requestSetting.headers = {
				"Authorization" : "Bearer " + sessionId
			};
			$.ajax(requestSetting).done(function successCallback( response )
			{
				var requestUrl = window.location.protocol + '//' + window.location.host + '/services/data/v41.0/sobjects/ContentDocument/' + fileId;
				var requestSetting = {};
				requestSetting.method = 'PATCH';
				requestSetting.url = requestUrl;
				requestSetting.headers = {
					"Authorization" : "Bearer " + sessionId,
					"content-type" : "application/json"
				};
				var data = {};
				data.Description = description;
				requestSetting.data = JSON.stringify(data);
				$.ajax(requestSetting).done(function successCallback(response) 
				{
					var requestUrl = window.location.protocol + '//' + window.location.host + '/services/data/v41.0/sobjects/ContentDocumentLink/';
					var requestSetting = {};
					requestSetting.method = 'POST';
					requestSetting.url = requestUrl;
					requestSetting.headers = {
						"Authorization" : "Bearer " + sessionId,
						"content-type" : "application/json"
					};
					var data = {};
					data.ContentDocumentId = fileId ,
					data.LinkedEntityId = recordId,
					data.ShareType = shareType
					requestSetting.data = JSON.stringify(data);

					$.ajax(requestSetting).done(function successCallback(response) 
					{
						return deferred.resolve( response );

					}).fail(function errorCallback(error){

						return deferred.reject( error );
					})
				}).fail(function errorCallback(error)
				{
					return deferred.reject( error );
				})
			}).fail(function errorCallback(error)
			{
				return deferred.reject( error );
			})
		}
		else
			return deferred.reject();
		return deferred.promise;
	}
	serviceHandle.deleteAttachments = function(attachmentType, lstIds, questionAttachmentId)
	{
		function Map() {
	    this.obj = {};
	    this.length = 0;
			};
		Map.prototype.set = function(key, value) {
		    this.obj[key] = value;
		    this.length++;
		};
		Map.prototype.get = function(key) {
		    return this.obj[key];
		};
		Map.prototype.has = function(key) {
		    return this.obj.hasOwnProperty(key);
		};
		Map.prototype.length = function() {
		    return this.obj.hasOwnProperty(key);
		};
		var lstIdsToDelete = [];
		if( typeof lstIds === 'string' )
			lstIdsToDelete.push(lstIds);
		else if( typeof lstIds === 'array' )
			lstIdsToDelete = lstIds;
		
		var deferred = $q.defer();
		if(attachmentType == 'Attachment')
		{
			var requestUrl = window.location.protocol + '//' + window.location.host + '/services/data/v41.0/sobjects/Attachment/' + lstIdsToDelete[0];
			var requestSetting = {};
			requestSetting.method = 'DELETE';
			requestSetting.url = requestUrl;
			requestSetting.headers = {
			"Authorization" : "Bearer " + initializeSettings.sessionId
			};
			$.ajax(requestSetting).done(function successCallback(response)
			{
				return deferred.resolve(lstIdsToDelete);

			}).fail(function errorCallback(error){

				return deferred.reject(error);
			});
		}
		else if(attachmentType == 'ContentDocument')
		{
			var requestUrl = window.location.protocol + '//' + window.location.host + '/services/data/v42.0/query/?q=SELECT Id, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN ' + JSON.stringify(lstIdsToDelete).replace("[","(").replace("]",")").replace(/"/g, '\'');
			var requestSetting = {};
			requestSetting.method = 'GET';
			requestSetting.url = requestUrl;
			requestSetting.headers = {
			"Authorization" : "Bearer " + initializeSettings.sessionId
			};
			$.ajax(requestSetting).done(function successCallback(response)
			{
				if(response.records!=undefined && response.records!=null)
				{
					var mapCntntVrsnIdAndCntntDcmntId = new Map(); 
					var contentVersionIds = []
					for(var i=0;i<response.records.length;i++)
					{
						mapCntntVrsnIdAndCntntDcmntId.set(response.records[i].Id,response.records[i].ContentDocumentId);
						if(contentVersionIds.indexOf(response.records[i].Id)<0)
							contentVersionIds.push(response.records[i].Id);
					}
					var mapFdItmAndCntntVrsn = new Map();
					var feedIds = [];

					if(questionAttachmentId)
					{
						var requestUrl = window.location.protocol + '//' + window.location.host + '/services/data/v42.0/query/?q=SELECT Id, Name,(Select Id From Feeds) FROM FGM_Portal__Question_Attachment__c where Id = \'' + questionAttachmentId + '\'';
						var requestSetting = {};
						requestSetting.method = 'GET';
						requestSetting.url = requestUrl;
						requestSetting.headers = {
						"Authorization" : "Bearer " + initializeSettings.sessionId
						};
						$.ajax(requestSetting).done(function successCallback(response)
						{
							if(response!=undefined && response.records.length>0)
							{
								for(var i = 0 ; i < response.records.length; i++)
								{
									if(response.records[0].Feeds!= null)
									{
										for(var j = 0 ; j<response.records[0].Feeds.records.length;j++)
										{
											if(feedIds.indexOf(response.records[0].Feeds.records[j].Id)<0)
												feedIds.push(response.records[0].Feeds.records[j].Id);
										}
									}
								}
							}
							var requestUrl = window.location.protocol + '//' + window.location.host + '/services/data/v41.0/sobjects/ContentDocument/' + lstIdsToDelete[0]; 
							var requestSetting = {};
							requestSetting.method = 'DELETE';
							requestSetting.url = requestUrl;
							requestSetting.headers = {
							"Authorization" : "Bearer " + initializeSettings.sessionId
							};
							$.ajax(requestSetting).done(function successCallback(response)
							{
								if(feedIds!=null && feedIds.length>0 && contentVersionIds!=null && contentVersionIds!=null)
								{
									var mapFdItmAndCntntVrsn = new Map();
									var requestUrl = window.location.protocol + '//' + window.location.host + '/services/data/v42.0/query/?q=SELECT FeedEntityId, RecordId FROM FeedAttachment WHERE RecordId IN ' + JSON.stringify(contentVersionIds).replace("[","(").replace("]",")").replace(/"/g, '\'') + 'AND FeedEntityId IN ' + JSON.stringify(feedIds).replace("[","(").replace("]",")").replace(/"/g, '\''); 
									var requestSetting = {};
									requestSetting.method = 'GET';
									requestSetting.url = requestUrl;
									requestSetting.headers = {
									"Authorization" : "Bearer " + initializeSettings.sessionId
									};
									$.ajax(requestSetting).done(function successCallback(response)
									{
										if(response.records>0)
										{
											var lstFeedItems = [];
											for(var i = 0;i < response.records; i++)
											{
												mapFdItmAndCntntVrsn.set(response.records[i].FeedEntityId,response.records[i].RecordId);
												if(lstFeedItems.indexOf(response.records[i].FeedEntityId)<0)
													lstFeedItems.push(response.records[i].FeedEntityId)
											}
											var lstFeedItemsToDelete = [];

								            for( var i=0; i < lstIdsToDelete.length;i++ )
								            {
								                for( var j = 0; j < contentVersionIds.length; j++)
								                {
								                    if(lstIdsToDelete[i] == mapCntntVrsnIdAndCntntDcmntId.get(contentVersionIds[j]) )
								                    {
								                        for( var k = 0; k< lstFeedItems.length; k++ )
								                        {
								                            if( contentVersionIds[j] == mapFdItmAndCntntVrsn.get( lstFeedItems[k] ) )
								                            {
								                                lstFeedItemsToDelete.add(lstFeedItems[k]);
								                                break;
								                            }
								                        }
								                        break;
								                    }
								                }
								            }
							        		var requestUrl = window.location.protocol + '//' + window.location.host + '/services/data/v41.0/sobjects/FeedItem/' + lstFeedItemsToDelete[0]; 
											var requestSetting = {};
											requestSetting.method = 'DELETE';
											requestSetting.url = requestUrl;
											requestSetting.headers = {
											"Authorization" : "Bearer " + initializeSettings.sessionId
											};
											$.ajax(requestSetting).done(function successCallback(response)
											{
												return deferred.resolve(lstIdsToDelete);
											}).fail(function errorCallback(error)
											{
												return deferred.reject(error);
											});	
										}
										else
											return deferred.resolve(lstIdsToDelete);
									
									}).fail(function errorCallback(error)
									{
										return deferred.reject(error);
									});	
								}
								else
									return deferred.resolve(lstIdsToDelete);
								
							}).fail(function errorCallback(error)
							{
								return deferred.reject(error);
							});	
						}).fail(function errorCallback(error)
						{
							return deferred.reject(error);
						});
					}
				}
				
			}).fail(function errorCallback(error){

				return deferred.reject(error);
			});					
		}
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
	serviceHandle.getAttachmentsFromSF = function()
	{
		function Map()
		{
			this.obj = {};
			this.length = 0;
		};
		Map.prototype.set = function(key, value)
		{
			this.obj[key] = value;
			this.length ++;
		};
		Map.prototype.get = function(key)
		{
			return this.obj[key];
		};
		Map.prototype.has = function(key)
		{
			return this.obj.hasOwnProperty(key);
		};
		Map.prototype.length = function()
		{
			return this.obj.hasOwnProperty(key);
		};

		var attachmentRecords = [];
		var deferred = $q.defer();
		var session = initializeSettings.sessionId;
		var requestUrl = window.location.protocol + '//' + window.location.host + '/services/data/v42.0/query/?q=' + queryString;
		var requestSetting = {};
		requestSetting.method = 'GET';
		requestSetting.url = requestUrl;
		requestSetting.cache = false;
		requestSetting.headers = {
		"Authorization" : "Bearer " + session
		};
		$.ajax(requestSetting).done(function successCallback(response)
		{
			if(response.records.length>0)
			{
				var questionAttachments = response.records;
				var questions = [];
				var queAttachments = [];
				var mapQueToQAttach = new Map();
				for(var i=0;i<response.records.length;i++)
				{
					if(queAttachments.indexOf(response.records[i].Id)<0)
						queAttachments.push(response.records[i].Id);
					if(questions.indexOf(response.records[i].FGM_Portal__Question__c)<0)
						questions.push(response.records[i].FGM_Portal__Question__c);
					if(response.records[i].FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c!=null && questions.indexOf(response.records[i].FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c)<0)
					     questions.push(response.records[i].FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c);
				}
				var mapQuestionIdSetIds = new Map();
				for(var i=0;i<response.records.length;i++)
				{
					mapQueToQAttach.set(response.records[i].Id,response.records[i]); 
					for(var k = 0 ; k < questions.length; k++)
					{
					    if(questions[k]==response.records[i].FGM_Portal__Question__c)
					    {
					        var setQuestionIdsTemp = [];
					        if(mapQuestionIdSetIds.size!=0 && mapQuestionIdSetIds.get(response.records[i].FGM_Portal__Question__c)!=undefined)
					            setQuestionIdsTemp = mapQuestionIdSetIds.get(response.records[i].FGM_Portal__Question__c).slice();
					        if(questions.indexOf(response.records[i].FGM_Portal__Question__c)<0)
					            questions.push(response.records[i].FGM_Portal__Question__c);
					        if(response.records[i].FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c!=null)
					        {
					            setQuestionIdsTemp.push(response.records[i].FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c);
					            if( mapQuestionIdSetIds.get(response.records[i].FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c ) != null && mapQuestionIdSetIds.get(response.records[i].FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c).length!=0  )
					            {
					                for(var j=0;j<mapQuestionIdSetIds.get(response.records[i].FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c ).length;j++)
					                {
					                    if(setQuestionIdsTemp.indexOf(mapQuestionIdSetIds.get(response.records[i].FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c )[j]<0))
					                        setQuestionIdsTemp.push(mapQuestionIdSetIds.get(response.records[i].FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c )[j]);  
					                }
					                mapQuestionIdSetIds.set( response.records[i].FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c, setQuestionIdsTemp );
					            }
					        }
					        mapQuestionIdSetIds.set( response.records[i].FGM_Portal__Question__c, setQuestionIdsTemp );
					    }
					    if(questions[k]==response.records[i].FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c)
					    {
					        var setQuestionIdsTemp = [];
					        if( mapQuestionIdSetIds.has( response.records[i].FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c ) && mapQuestionIdSetIds.get(response.records[i].FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c).length!=0 )
					            setQuestionIdsTemp = mapQuestionIdSetIds.get(response.records[i].FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c);
					        if(setQuestionIdsTemp.indexOf(response.records[i].FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c)<0)
					            setQuestionIdsTemp.push(response.records[i].FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c);
					        if(setQuestionIdsTemp.indexOf(response.records[i].FGM_Portal__Question__c)<0)
					            setQuestionIdsTemp.push(response.records[i].FGM_Portal__Question__c);
					        if( mapQuestionIdSetIds.get( response.records[i].FGM_Portal__Question__c ) != null && mapQuestionIdSetIds.get( response.records[i].FGM_Portal__Question__c).length!=0 )
					        {
					            for(var j=0;j<mapQuestionIdSetIds.get( response.records[i].FGM_Portal__Question__c).length;j++)
					            {
					                if(setQuestionIdsTemp.indexOf(mapQuestionIdSetIds.get(response.records[i].FGM_Portal__Question__c )[j]<0))
					                    setQuestionIdsTemp.push(mapQuestionIdSetIds.get(response.records[i].FGM_Portal__Question__c )[j]);
					            }
					            mapQuestionIdSetIds.set(response.records[i].FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c, setQuestionIdsTemp );
					        }
					        mapQuestionIdSetIds.set( response.records[i].FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c, setQuestionIdsTemp );
					    }
					}
				}
				var mapQuestionAttachmentsWithRelatedQuestions = new Map();
				for(var i=0;i<response.records.length;i++)
				{
					for(var j=0;j< mapQuestionIdSetIds.length;j++)
					{
						if(mapQuestionIdSetIds.has(response.records[i].FGM_Portal__Question__c))
						{
							if(!mapQuestionAttachmentsWithRelatedQuestions.has(response.records[i].Id))
								mapQuestionAttachmentsWithRelatedQuestions.set(response.records[i].Id,mapQuestionIdSetIds.get(response.records[i].FGM_Portal__Question__c));
						}
					}
				}
				if(queAttachments!=null || queAttachments!=undefined)
				{
					var query = ' SELECT Id, Name, Description, CreatedDate, BodyLength, ContentType, OwnerId, ParentId FROM Attachment WHERE ParentId IN ' + JSON.stringify(queAttachments).replace("[","(").replace("]",")").replace(/"/g, '\'');
					var requestUrl = window.location.protocol + '//' + window.location.host + '/services/data/v42.0/query/?q=' + query;

					var requestSetting = {};
					requestSetting.method = 'GET';
					requestSetting.url = requestUrl;
					requestSetting.cache = false;
					requestSetting.headers = {
					"Authorization" : "Bearer " + session
					};
					$.ajax(requestSetting).done(function successCallback( response )
					{
						if(response.records.length>0)
						{
							var userIds = [];
							var attachments = response.records;
							for(var i=0;i<response.records.length;i++)
							{
							    if(userIds.indexOf(response.records[i].OwnerId)<0)
							        userIds.push(response.records[i].OwnerId);
							}
							if(userIds!=null || userIds!=undefined)
							{
								var query = 'SELECT Id, User.ContactId FROM User WHERE Id IN' + JSON.stringify(userIds).replace("[","(").replace("]",")").replace(/"/g, '\'');
								var requestUrl = window.location.protocol + '//' + window.location.host + '/services/data/v42.0/query/?q=' + query;
								var requestSetting = {};
								requestSetting.method = 'GET';
								requestSetting.url = requestUrl;
								requestSetting.cache = false;
								requestSetting.headers = {
								"Authorization" : "Bearer " + session
								};
								$.ajax(requestSetting).done(function successCallback( response )
								{
									var userIdToUser = new Map();
									var lstAttachments = [];
									for(var i=0;i<response.records.length;i++)
									{
									    userIdToUser.set(response.records[i].Id,response.records[i].ContactId);
									}
									for(var i=0;i<attachments.length;i++)
									{
									    
								        if(mapQuestionAttachmentsWithRelatedQuestions.has(attachments[i].ParentId))
								        {
								            var attachmentWrapper = {};
								            var questionAttachment = mapQueToQAttach.get(attachments[i].ParentId);
								            attachmentWrapper.id = attachments[i].Id;
								            if(lstAttachments.indexOf(attachments[i].Id)<0)
								            	lstAttachments.push(attachments[i].Id);
								            attachmentWrapper.name = attachments[i].Name;
								            attachmentWrapper.description = attachments[i].Description;
								            attachmentWrapper.createdDate = attachments[i].CreatedDate;
								            attachmentWrapper.sizeInBytes = attachments[i].BodyLength;
								            attachmentWrapper.contentType = attachments[i].ContentType;
								            attachmentWrapper.questionAttachmentId = attachments[i].ParentId;
								            attachmentWrapper.relatedQuestions = mapQuestionAttachmentsWithRelatedQuestions.get(attachments[i].ParentId);
								            attachmentWrapper.type = 'Attachment';
								            attachmentWrapper.downloadUrlPath = '/servlet/servlet.FileDownload?file=' + attachments[i].Id;
								            attachmentWrapper.question = questionAttachment.FGM_Portal__Question__c;
								            attachmentWrapper.questionAttachment = questionAttachment;
								            if(userIdToUser.get(attachments[i].OwnerId)!=null)
								                attachmentWrapper.isDeletable = true;
								            else
								                attachmentWrapper.isDeletable = false;
								           		attachmentRecords.push(attachmentWrapper);
								        }
									}
								}).fail(function errorCallBack( error ){
								return deferred.reject(error);
								}); 
								}
						}
						var query = ' SELECT LinkedEntityId, ContentDocumentId, ContentDocument.CreatedById  FROM ContentDocumentLink WHERE LinkedEntityId IN ' + JSON.stringify(queAttachments).replace("[","(").replace("]",")").replace(/"/g, '\'');
						var requestUrl = window.location.protocol + '//' + window.location.host + '/services/data/v42.0/query/?q=' + query;

						var requestSetting = {};
						requestSetting.method = 'GET';
						requestSetting.url = requestUrl;
						requestSetting.cache = false;
						requestSetting.headers = {
						"Authorization" : "Bearer " + session
						};
						$.ajax(requestSetting).done(function successCallback( response )
						{
							if(response.records.length<=0)
					    	{
					    		return deferred.resolve(attachmentRecords);
					    	}
					    	else
					    	{
								var userIds = [];
								var setAllOtherContentDocumentIds = [];
								var contentDocumnetLinks = response.records;
								var mapParentIdWithSetContentDocumentIds =  new Map();
								for(var i=0;i<response.records.length;i++)
								{
								    setAllOtherContentDocumentIds.push(response.records[i].ContentDocumentId);
								    if(userIds.indexOf(response.records[i].ContentDocument.CreatedById)<0)
								        userIds.push(response.records[i].ContentDocument.CreatedById);
								    
								    if(queAttachments.indexOf(response.records[i].LinkedEntityId)>=0)
								    {
								        var setIds = [];
								        if(mapParentIdWithSetContentDocumentIds.has(response.records[i].LinkedEntityId) && mapParentIdWithSetContentDocumentIds.get(response.records[i].LinkedEntityId)!=null)
								          setIds = mapParentIdWithSetContentDocumentIds.get(response.records[i].LinkedEntityId);
								        if(setIds.indexOf(response.records[i].ContentDocumentId)<0)
								        	setIds.push(response.records[i].ContentDocumentId);
								        mapParentIdWithSetContentDocumentIds.set(response.records[i].LinkedEntityId,setIds);
								    }
								} 
								if(userIds.length>0 && userIds!=undefined)
								{
									var query = 'SELECT Id, User.ContactId FROM User WHERE Id IN' + JSON.stringify(userIds).replace("[","(").replace("]",")").replace(/"/g, '\'');
									var requestUrl = window.location.protocol + '//' + window.location.host + '/services/data/v42.0/query/?q=' + query;

									var requestSetting = {};
									requestSetting.method = 'GET';
									requestSetting.url = requestUrl;
									requestSetting.cache = false;
									requestSetting.headers = {
									    "Authorization" : "Bearer " + session
									};
									$.ajax(requestSetting).done(function successCallback( response )
									{
									    var userIdToUserCD = new Map();
									    for(var i=0;i<response.records.length;i++)
									    {
									        userIdToUserCD.set(response.records[i].Id,response.records[i].ContactId);
									    }
									    var query = 'SELECT Id, FileType,CreatedById, ContentSize, Title, Description, CreatedDate, ( SELECT Id FROM ContentVersions ORDER BY CreatedDate DESC LIMIT 1 ) FROM ContentDocument WHERE Id IN ' + JSON.stringify(setAllOtherContentDocumentIds).replace("[","(").replace("]",")").replace(/"/g, '\'');
									    var requestUrl = window.location.protocol + '//' + window.location.host + '/services/data/v42.0/query/?q=' + query;
									    
									    var requestSetting = {};
									    requestSetting.method = 'GET';
									    requestSetting.url = requestUrl;
									    requestSetting.headers = {
									        "Authorization" : "Bearer " + session
									    };
									    $.ajax(requestSetting).done(function successCallback( response )
									    {
									    		var mapContDoc = new Map();
										        var attach = [];
										        var lstAttachments = [];
										        for(var i=0;i<response.records.length;i++)
										        {
										            mapContDoc.set(response.records[i].Id,response.records[i]);
										        }
										        for(var i = 0; i < questionAttachments.length; i++)
										        {
										            
									                if(mapQuestionAttachmentsWithRelatedQuestions.has(questionAttachments[i].Id))
									                {
									                    if(mapParentIdWithSetContentDocumentIds.get(questionAttachments[i].Id)!=null)
									                    {
									                        var contentDocs = mapParentIdWithSetContentDocumentIds.get(questionAttachments[i].Id);
									                        for(var k=0; k<contentDocs.length;k++)
									                        {										                            
									                            var attachmentWrapper = {};
									                            var queAttach = mapQueToQAttach.get(questionAttachments[i].Id);
									                            var contentDocument = mapContDoc.get(contentDocs[k]);
									                            if(lstAttachments.indexOf(contentDocument.Id)<0)
									                            	lstAttachments.push(contentDocument.Id);
									                            attachmentWrapper.id = contentDocument.Id;
									                            attachmentWrapper.name = contentDocument.Title;
									                            attachmentWrapper.description = contentDocument.Description;
									                            attachmentWrapper.createdDate = contentDocument.CreatedDate;
									                            attachmentWrapper.sizeInBytes = contentDocument.ContentSize;
									                            attachmentWrapper.contentType = contentDocument.FileType;
									                            attachmentWrapper.questionAttachmentId = questionAttachments[i].Id;
									                            attachmentWrapper.relatedQuestions = mapQuestionAttachmentsWithRelatedQuestions.get(questionAttachments[i].Id);
									                            attachmentWrapper.type = 'ContentDocument';
									                            attachmentWrapper.downloadUrlPath = '/sfc/servlet.shepherd/version/download/' + contentDocument.ContentVersions.records[0].Id;
									                            attachmentWrapper.question = queAttach.FGM_Portal__Question__c;
									                            attachmentWrapper.questionAttachment = queAttach;
									                            if(userIdToUserCD.get(contentDocument.CreatedById)!=null)
									                                attachmentWrapper.isDeletable = true;
									                            else
									                                attachmentWrapper.isDeletable = false;
									                            	attachmentRecords.push(attachmentWrapper);
									                        }
									                	}
									            	}
										        }
										        return deferred.resolve(attachmentRecords);
									    }).fail(function errorCallback(error){                                          
									         return deferred.reject(error);
									    });
									}).fail(function errorCallBack(error){
									  	return deferred.reject(error);
									});
								}
							}
							
						}).fail(function errorCallBack(error){
							return deferred.reject(error);
						});						
					}).fail(function errorCallBack( error ){
					return deferred.reject(error);
					});		
				}
			}			
				
		}).fail(function errorCallBack( error ){
			return deferred.reject(error);
		});
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
templateValue += "<div class=\"bootstrap-fc\" style=\"font-size: 13px; border: 1px solid #aaa;margin: 1%;padding: 1%;border-radius: 3px;padding-top: 2%;width:95%;max-width:1250px;min-width: 800px;text-align: left;display: inline-block;background-color: white\">\r\n\t<table class=\"table table-sm\">\r\n\t\t<tr>\r\n\t\t\t<!--<th style=\"width: 5%\">{{tableTranslationSetup.type}}<\/th>-->\r\n\t\t\t<th style=\"width: 5%\" ng-bind-html=\"tableTranslationSetup.serialNumber\"><\/th>\r\n\t\t\t<th style=\"width: 30%\" ng-bind-html=\"tableTranslationSetup.name\" ><\/th>\r\n\t\t\t<th style=\"width: {{ controlSetup.isEditable ? \'40\' : \'50\' }}%\" ng-bind-html=\"tableTranslationSetup.description\" ><\/th>\r\n\t\t\t<th style=\"width: 15%\" ng-bind-html=\"tableTranslationSetup.createdDate\" ><\/th>\r\n\t\t\t<th style=\"width: 10%\" ng-if=\"controlSetup.isEditable\" ng-bind-html=\"tableTranslationSetup.actionColumn\" ><\/th>\r\n\t\t<\/tr>\r\n\t\t<tr ng-if=\"localAttachments.length <= 0\">\r\n\t\t\t<td colspan=\"{{ controlSetup.isEditable ? 5 : 4 }}\">{{tableTranslationSetup.noRecordsFound}}<\/td>\r\n\t\t<\/tr>\r\n\t\t<tr ng-if=\"localAttachments.length > 0\" ng-repeat=\"attachment in localAttachments | orderBy: \'-createdDate\' track by $index\">\r\n\t\t\t<!--<td>{{attachment.type}}<\/td>-->\r\n\t\t\t<td>{{$index + 1}}<\/td>\r\n\t\t\t<td class=\"wrapData\">\r\n\t\t\t\t<a href=\"{{attachment.downloadUrlPath}}\" target=\"_blank\" style=\"text-decoration: none\" ng-bind-html=\"attachment.name\"><\/a>\r\n\t\t\t<\/td>\r\n\t\t\t<td class=\"wrapData\" ng-bind-html=\"attachment.description\"><\/td>\r\n\t\t\t<td>{{attachment.createdDate | date : \'MM\/dd\/yy\'}}<\/td>\r\n\t\t\t<td ng-if=\"controlSetup.isEditable\"><a ng-if=\"attachment.isDeletable\" href=\"\" ng-click=\"confirmDelete( attachment.id, attachment.type, attachment.questionAttachmentId )\"  style=\"text-decoration: none\">{{tableTranslationSetup.deleteAction}}<\/a><\/td>\r\n\t\t<\/tr>\r\n\t<\/table>\r\n\t<div class=\"attachment-uplod-control-container\" style=\"display:inline-block;width:100%;\" ng-show=\"uploadEnabled\">\r\n\t\t<textarea ng-if=\"controlSetup.isDescriptionEnabled\" id=\"{{directiveId}}-description\" placeholder=\"{{fileInputTranslationSetup.descriptionPlaceholder | removetags}}\" style=\"width: 100%;font-size: 13px;border-radius: 3px;max-width: 1250px; min-width: 800px\" ng-keydown=\"countDescriptionLength( $event )\" ng-paste=\"countDescriptionLength()\" ng-cut=\"countDescriptionLength()\" maxlength=\"{{descriptionAllowedLength}}\"><\/textarea>\r\n\t\t<div ng-if=\"controlSetup.isDescriptionEnabled\" style=\"text-align: right;margin-top: .5%;display: inline-block;width: 100%;font-style: italic;font-size: 11px;\">{{descriptionLength}} {{fileInputTranslationSetup.characterCountOfLabel}} {{controlSetup.isFile == true ? \'1000\' : \'500\'}} {{fileInputTranslationSetup.charactersLabel}}<\/div>\r\n\t\t<br\/>\r\n\t\t<div >\r\n\t\t\t<div style=\"display:inline-block;width:49%\">\r\n\t\t\t\t<label for=\"{{directiveId}}\" class=\"btn btn-sm btn-primary\" style=\"font-size: 13px\" ng-disabled=\"progress.isActive\">{{fileInputTranslationSetup.choseFileBtn}}<\/label>\r\n\t\t\t\t<input id=\"{{directiveId}}\" type=\"file\" name=\"fileUploader\" onchange=\"angular.element(this).scope().getFileFromControl(this)\" style=\"width: 85%;display: none\" ng-disabled=\"progress.isActive\">\r\n\t\t\t\t<input type=\"button\" class=\"btn btn-sm btn-primary\" value=\"{{fileInputTranslationSetup.uploadBtn}}\" ng-click=\"uploadFile()\" style=\"font-size: 13px\" ng-disabled=\"isUploadDisabled\" \/>\r\n\t\t\t\t<br\/><br\/>\r\n\t\t\t\t<label ng-bind=\"fileInputPath\" style=\"width: 70%;font-size: 13px\"><\/label>\r\n\t\t\t<\/div>\r\n\t\t\t<div class=\"progress-bar-container\" ng-show=\"progress.counter >= 0 && !request.showInfo\" style=\"display: inline-block;width: 50%;text-align: right;\">\r\n\t\t\t\t<div style=\"display: inline-block;width: 100%\">\r\n\t\t\t\t\t<div class=\"progress\" style=\"width: 100%;\">\r\n\t\t\t\t\t\t<div class=\"progress-bar\" ng-style=\"{ \'width\' : progress.counter + \'%\'}\"><\/div>\r\n\t\t\t\t\t<\/div>\t\r\n\t\t\t\t<\/div>\r\n\t\t\t\t<br\/>\r\n\t\t\t\t<div style=\"display: inline-block; width: 100%; text-align: left;\">\r\n\t\t\t\t\t<div style=\"display: inline-block\">{{fileInputTranslationSetup.processingLabel}}<\/div>\r\n\t\t\t\t\t<div style=\"display: inline-block;float: right;\">{{progress.counter}}%<\/div>\t\r\n\t\t\t\t<\/div>\r\n\t\t\t<\/div>\t\r\n\t\t\t<div class=\"progress-bar-container\" style=\"display: inline-block;width: 50%;text-align: right;vertical-align: top;\" ng-show=\"request.showInfo\">\r\n\t\t\t\t<div style=\"padding: 1%;text-align: right;\">\r\n\t\t\t\t\t<div style=\"display: inline-block;height: 20px;\">{{request.message}}<\/div>\r\n\t\t\t\t\t<span class=\"glyphicon glyphicon-{{request.status == \'failure\' ? \'alert\' : \'ok-sign\'}}\" style=\"font-size: 20px;color: {{request.status == \'failure\' ? \'red\' : \'#3cb63c\'}};\" ng-show=\"request.showInfo\"><\/span>\r\n\t\t\t\t<\/div>\r\n\t\t\t<\/div>\r\n\t\t<\/div>\r\n\t<\/div>\r\n<\/div>";
// the above string is generated using the online tool - https://www.freeformatter.com/javascript-escape.html. You just need to preprend and append the " ( double quote ) to the output that you will recieve from the tool