if (!jQuery) { throw new Error("Bootstrap requires jQuery") }
(function($) {
$.fn.fcCheckBox = function(options) {
  //var defaults = {    
  //};
  // Extend our default options with those provided.
  //var opts = $.extend(defaults, options);
  // Our plugin implementation code goes here.

  // To apply fcCheckbox CSS
  $(this).each(function(input){
	try{
  	$(this).addClass('checkbox');
  	var checkbox_wrapper = $('<div>').addClass('switch');
  	var yesLabel = $('<label>').attr('data-status', 'checked').attr('for',($(this).attr('id'))).append('Yes');
  	var noLabel = $('<label>').attr('data-status', 'unchecked').attr('for',($(this).attr('id'))).append('No');
  	$(checkbox_wrapper).append(yesLabel);
  	$(checkbox_wrapper).append(noLabel);
  	$(checkbox_wrapper).append($('<span>'));
  	$(checkbox_wrapper).insertAfter(this);
	$(this).hide();
	//$(this).attr('disabled','disabled');
  }
  catch(ex){
		$(this).show();
	}
  });
};
})(jQuery);