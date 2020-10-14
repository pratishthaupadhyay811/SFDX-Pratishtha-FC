var systemService = angular.module('systemService',['exceptionService']);
systemService.service('$systemService',function($http, $q, $exception){
	var controllerMethodPath = "FGM_Portal.Engine";
	if( typeof engineMethodPath !== 'undefined' && engineMethodPath )
		controllerMethodPath = engineMethodPath;
	this.getUserInfo = function()
	{
		var deferred = $q.defer();
		Visualforce.remoting.Manager.invokeAction( controllerMethodPath + '.getUserInfo', function callBack( result, error ){
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