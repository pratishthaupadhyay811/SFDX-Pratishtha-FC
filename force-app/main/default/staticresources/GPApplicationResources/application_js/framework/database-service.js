var databaseService = angular.module("databaseService",["exceptionService"]);
databaseService.service("$database", function( $http, $q, $exception )
{
    var controllerMethodPath = "FGM_Portal.Engine";
    if( typeof engineMethodPath !== 'undefined' && engineMethodPath )
        controllerMethodPath = engineMethodPath;

    this.deleteAttachments = function( sObjectAPIName, lstIds,questionAttachmentId )
    {
        var deferred = $q.defer();
        Visualforce.remoting.Manager.invokeAction( controllerMethodPath + ".deleteAttachments", sObjectAPIName, lstIds,questionAttachmentId, function( result, error ){
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
