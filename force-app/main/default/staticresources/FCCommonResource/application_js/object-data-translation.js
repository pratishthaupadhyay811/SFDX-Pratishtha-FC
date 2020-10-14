        

function showProcessing() 
{
    //$('.spinnerContainer').fadeIn("slow", function() {
    window.scrollTo(0, 0);
    $(".spinnerContainer").addClass("spinnerContainer_display");
    $(".spinnerContainer").removeClass("spinnerContainer");
    //});
    
    window.onload = function (e) 
    {
        $(".spinnerContainer").fadeOut("slow");
    }
}

function hideProcessing() 
{
    window.scrollTo(0, 0);
    $(".spinnerContainer_display").addClass("spinnerContainer");
    $(".spinnerContainer_display").removeClass("spinnerContainer_display");
}
