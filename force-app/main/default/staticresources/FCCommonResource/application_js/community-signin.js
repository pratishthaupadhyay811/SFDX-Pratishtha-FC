function initialize(){
          unescape();              
          intializeForm();
          $('.logo-home').addClass('logo_margin');   
           if(invalidCredential){
            $('.sign_errMsg').text('');
            var InvalidCredentialError = invalidSigninCredential;
            InvalidCredentialError = $.parseHTML('Error:'+InvalidCredentialError);
            $('.sign_errMsg').append(InvalidCredentialError);
          }
}
function intializeForm(){
          $('.ddl-portal-language').select2({
              minimumResultsForSearch: -1
          });
           
          // Set placeholders
          $('input.for-username').attr('placeholder',userName);
          $('input.for-password').attr('placeholder',password);  
          // Set required data
          $('input.for-username').attr('required', 'required');
          $('input.for-password').attr('required', 'required');
}