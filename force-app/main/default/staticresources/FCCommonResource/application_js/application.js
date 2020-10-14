var App = angular.module('App', ['salesforce', 'toaster', 'processing','messageApp']);
var Global = {
    isEmptyORNull: function (obj) {
        if (angular.equals(obj, undefined) || angular.equals(obj, null) || angular.equals(obj, {}))
            return true;
        else
            return false;

    },
};

// function to expand and collapse attachments on QuestionAttachment pages
 function toggleImage(imgToHideId,imgToshowId,panelId,option)
    {
        setTimeout(function() {
        
            var panel = $('[id$='+panelId+']');
            $("[id$=toggleImage"+imgToHideId+"]").hide();
            $("[id$=toggleImage"+imgToshowId+"]").show();
            if(panel.hasClass("in")===false && option==='show')
            {
             $("[id$="+panelId+"]").collapse("show"); 
            }   
            else if(panel.hasClass("in")===true && option==='hide')
            {
             $("[id$="+panelId+"]").collapse("hide"); 
            }  
             
        }, 400);         
    }
