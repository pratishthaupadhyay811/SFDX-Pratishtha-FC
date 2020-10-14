function loadDataFields(){
      $('[data-field-name=FGM_Portal__Phone__c]').find('input').mask("(999) 999-9999? x999");
    }
    function disablePaste()
    {
        $('.confirmField').bind('paste',function(e) {  e.preventDefault(); });
    }
    
    function initializeForm()
    {        
        disablePaste();
        $('.input-field[data-field-type="encryptedstring"]').each(function () {
            $(this).find('input').attr('type', 'password');
        });
        $('.input-field').each(function () {
            $(this).find('input').attr('required', $(this).data('required'));
            $(this).find('input').addClass('form-control');
            $(this).removeClass('hidden');
        });
        $("textarea").each(function () {
            $(this).addClass('form-control');
            $(this).css('max-width', $(this).css('width'));
            $("[data-required='true'] textarea").attr('required', 'required');
        });
        setTimeout(function () { $('[id$=countrystate]').addClass('form-control'); }, 100);
    }    
    function getCountry(e)
    {
        setTimeout(function () { $('[id$=countrystate]').addClass('form-control'); }, 20);
        if ($(e.options[e.selectedIndex]).text() != '') {
            country = $(e.options[e.selectedIndex]).text();
        }
        if ($(e.options[e.selectedIndex]).text() == '') {
            country = $(e).val();
        }
    }
    function getState(e)
    {
        if ($(e.options[e.selectedIndex]).text() != '') {
            state = $(e.options[e.selectedIndex]).text();
        }
        if ($(e.options[e.selectedIndex]).text() == '') {
            state = $(e).val();
        }
    }
    
    function nextCS()
    {
        var cntryst = getCountryState();
        next(cntryst);
    }
    
    function registerCS()
    {
        var countrystate = getCountryState();
        register(countrystate);
    }
    
    function getCountryState()
    {
        var cntryst;
        if ((country != undefined && country != '') || (state != undefined && state != ''))
        {
            if (state == undefined) {
                cntryst = country + ':cs:' + ' ';
            }
            if (state == '') {
                cntryst = country + ':cs:' + ' ';
            }
            if (country == undefined) {
                cntryst = ' ' + ':cs:' + state;
            }
            if (country == '') {
                cntryst = ' ' + ':cs:' + state;
            }
            if ((country != undefined && country != '') && (state != undefined && state != '')) {
                cntryst = country + ':cs:' + state;
            }
        }
        else
        {
            cntryst = '';
        }
        return cntryst;
    }