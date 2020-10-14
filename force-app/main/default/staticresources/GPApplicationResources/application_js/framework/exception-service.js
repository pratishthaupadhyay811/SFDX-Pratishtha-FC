var exceptionService = angular.module("exceptionService",[]);
exceptionService.service("$exception", function(){
	this.create = function( cause, message ){
		var exception = { };
		exception.cause = cause;
		exception.message = message;
		return exception;
	}
});