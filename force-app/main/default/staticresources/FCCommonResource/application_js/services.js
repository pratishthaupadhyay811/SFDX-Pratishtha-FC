
angular.module('processing', [])
.factory('processing', [function () {
    var processing = {
        show: function () {            
            document.getElementById("divSpinnerContainer").hidden = false;
        },
        hide: function () {
             setTimeout(function () { document.getElementById("divSpinnerContainer").hidden = true; }, 1000); 
        }
    };
    return processing;
}]).directive("processing", function () {
    var processing = {
        restrict: 'AE',
        template: '<style>.spinnerContainerprocessing { width: 100%; /* height: 100%; */position: fixed;    opacity: 0.5;    z-index: 1111111141;    left: 0px;    top: -113px;    bottom: -6px;    background-color: black; /*left:0px;*/ top:0px; background-color:black; /*#0581b7*/ } .spinnerprocessing { font-size: 13px;        /* top: 57%; */        position: fixed;    top: 50%;    left: 50%;    font-weight: bold;} .spinner > div { margin-left:2px; background-color: #F9F9F9; /*#0581b7*/ height: 59px; width: 5px; display: inline-block; -webkit-animation: stretchdelay 1.2s infinite ease-in-out; animation: stretchdelay 1.2s infinite ease-in-out; } .spanText{ color: #F9F9F9; } .spinner .rect2 { -webkit-animation-delay: -1.1s; animation-delay: -1.1s; } .spinner .rect3 { -webkit-animation-delay: -1.0s; animation-delay: -1.0s; } .spinner .rect4 { -webkit-animation-delay: -0.9s; animation-delay: -0.9s; } .spinner .rect5 { -webkit-animation-delay: -0.8s; animation-delay: -0.8s; } @-webkit-keyframes stretchdelay { 0%, 40%, 100% { -webkit-transform: scaleY(0.4) } 20% { -webkit-transform: scaleY(1.0) } } @keyframes stretchdelay { 0%, 40%, 100% { transform: scaleY(0.4); -webkit-transform: scaleY(0.4); } 20% { transform: scaleY(1.0); -webkit-transform: scaleY(1.0); }</style>\
                        <div id="divSpinnerContainer"  class="spinnerContainerprocessing" >\
                        <div class="spinnerprocessing">\
                            <div class="rect1"></div>\
                            <div class="rect2"></div>\
                            <div class="rect3"></div>\
                            <div class="rect4"></div>\
                            <div class="rect5"></div><br />\
                            <span class="spanText">Please wait...</span>\
                        </div>\
                    </div>',
        controller: function ($scope) {            
           setTimeout(function () { document.getElementById("divSpinnerContainer").hidden = true; }, 3000);
        }
    };
    return processing;
});
angular.module('salesforce', ['processing'])
.factory('salesforce', function (processing) {    
    salesforce = {
        invoke: function () {
          
            var onsuccess = arguments[arguments.length - 2];
            var onerror = arguments[arguments.length - 1];
            arguments[arguments.length - 2] = function (result, event) {
                processing.hide();
                if (event.status)
                    onsuccess.apply(this, arguments);
                else
                    onerror.call(this, event.message);
                
            };
            arguments[arguments.length - 1] = function (result, event) {
                processing.hide();
                onerror.call(this, event.message);
               
            };
            arguments[arguments.length] = { escape: false };
            ++arguments.length;
            processing.show();
            Visualforce.remoting.Manager.invokeAction.apply(Visualforce.remoting.Manager, arguments);
        }
    }
    return salesforce;
});