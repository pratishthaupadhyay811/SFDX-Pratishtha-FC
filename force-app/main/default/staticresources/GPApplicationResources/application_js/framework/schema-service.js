var schemaService = angular.module( "schemaService", [ "exceptionService" ] );
schemaService.service( "$schema", function( $http, $q, $exception ) 
{
	this.fetchObjectAccess = null;
	this.sObjectApiName = null;
	this.fetchChildrenObjects = null;
	this.fetchRecordTypes = null;
	this.fetchFieldsResult = null;
	this.fetchFieldSets = null;
	this.describeSobject = function( sObjectApiName, fetchObjectAccess, fetchChildrenObjects, fetchRecordTypes, fetchFieldsResult, fetchFieldSets )
	{
		if( sObjectApiName )
			this.sObjectApiName = sObjectApiName;
		if( fetchChildrenObjects )
			this.fetchChildrenObjects = fetchChildrenObjects;
		if( fetchRecordTypes )
			this.fetchRecordTypes = fetchRecordTypes;
		if( fetchFieldsResult )
			this.fetchFieldsResult = fetchFieldsResult;
		if( fetchFieldSets )
			this.fetchFieldSets = fetchFieldSets;
		if( fetchObjectAccess )
			this.fetchObjectAccess = fetchObjectAccess;
		var deferred = $q.defer();
		Visualforce.remoting.Manager.invokeAction("FGM_Portal.Engine.describeSobject", this.sObjectApiName, this.fetchObjectAccess, this.fetchChildrenObjects, this.fetchRecordTypes, this.fetchFieldsResult, this.fetchFieldSets , function( result, error ){
			if( error.status == true )
			{
				return deferred.resolve( result );
			}
			else
			{
				var exception = $exception.create( error.action + '.' + error.method, error.message );
				return deferred.reject( exception );
			}
		});
		return deferred.promise;
	}
});