public class CollectionUtilities {
    public static String setToString( Set<String> setValues, Boolean isEnclosed ){
        try{
            String result = '';
            List<String> lstValues = new List<String>();
            lstValues.addAll(setValues);
            if( lstValues != null && !lstValues.isEmpty() ){
                for( Integer iCount = 0; iCount < lstValues.size(); iCount++ ){
                    if( ( iCount + 1 ) < lstValues.size() ){
                        if( isEnclosed )
                            result += '\'' + String.escapeSingleQuotes(lstValues[iCount]) + '\', ';
                        else
                            result += String.escapeSingleQuotes(lstValues[iCount]) + ', ';
                    }
                    else{
                        if( isEnclosed )
                            result += '\'' + String.escapeSingleQuotes(lstValues[iCount]) + '\' ';
                        else
                            result += String.escapeSingleQuotes(lstValues[iCount]) + ' ';
                    }
                }
            }
            if( result.length() > 0 )
                return result;
            else
                return null;
        }
        catch( Exception ex ){
            catchException(ex,false);return null;
        }
    }
    public static String setToString( Set<Id> setValues, Boolean isEnclosed ){
        try{
            String result = '';
            List<Id> lstValues = new List<Id>();
            lstValues.addAll(setValues);
            if( lstValues != null && !lstValues.isEmpty() ){
                for( Integer iCount = 0; iCount < lstValues.size(); iCount++ ){
                    if( ( iCount + 1 ) < lstValues.size() ){
                        if( isEnclosed )
                            result += '\'' + String.escapeSingleQuotes(lstValues[iCount]) + '\', ';
                        else
                            result += String.escapeSingleQuotes(lstValues[iCount]) + ', ';
                    }
                    else{
                        if( isEnclosed )
                            result += '\'' + String.escapeSingleQuotes(lstValues[iCount]) + '\' ';
                        else
                            result += String.escapeSingleQuotes(lstValues[iCount]) + ' ';
                    }
                }
            }
            if( result.length() > 0 )
                return result;
            else
                return null;
        }
        catch( Exception ex ){
            catchException(ex,false);return null;
        }
    }
    public static String listToString( List<String> lstValues, Boolean isEnclosed ){
        try{
            String result = '';
            if( lstValues != null && !lstValues.isEmpty() ){
                for( Integer iCount = 0; iCount < lstValues.size(); iCount++ ){
                    if( ( iCount + 1 ) < lstValues.size() ){
                        if( isEnclosed )
                            result += '\'' + String.escapeSingleQuotes(lstValues[iCount]) + '\', ';
                        else
                            result += String.escapeSingleQuotes(lstValues[iCount]) + ', ';
                    }
                    else{
                        if( isEnclosed )
                            result += '\'' + String.escapeSingleQuotes(lstValues[iCount]) + '\' ';
                        else
                            result += String.escapeSingleQuotes(lstValues[iCount]) + ' ';
                    }
                }
            }
            if( result.length() > 0 )
                return result;
            else
                return null;
        }
        catch( Exception ex ){
            catchException(ex,false);return null;
        }
    }
    public static String listToString( List<Id> lstValues, Boolean isEnclosed ){
        try{
            String result = '';
            if( lstValues != null && !lstValues.isEmpty() ){
                for( Integer iCount = 0; iCount < lstValues.size(); iCount++ ){
                    if( ( iCount + 1 ) < lstValues.size() ){
                        if( isEnclosed )
                            result += '\'' + String.escapeSingleQuotes(lstValues[iCount]) + '\', ';
                        else
                            result += String.escapeSingleQuotes(lstValues[iCount]) + ', ';
                    }
                    else{
                        if( isEnclosed )
                            result += '\'' + String.escapeSingleQuotes(lstValues[iCount]) + '\' ';
                        else
                            result += String.escapeSingleQuotes(lstValues[iCount]) + ' ';
                    }
                }
            }
            if( result.length() > 0 )
                return result;
            else
                return null;
        }
        catch( Exception ex ){
            catchException(ex,false);return null;
        }
    }
    public static Map<String,String> getMapFromParameters(String parameters, String stringSeperator, String subStringSeperator){
        try{
            Map<String,String> mapResults = new Map<String,String>();
            for( String str : parameters.split(stringSeperator) ){
                List<String> lstSubStrings = str.split(subStringSeperator);
                mapResults.put( lstSubStrings[0], lstSubStrings[1] );
            }
            return mapResults;
        }
        catch( Exception ex ){
            catchException(ex,true);return null;
        }
    }
    public static Boolean getContainsIgnoreCase( String source, String content ){
        try{
            return source.containsIgnoreCase(content);
        }
        catch( Exception ex ){
            catchException(ex,true);return null;
        }
    }
    public static void catchException( Exception ex, Boolean bValue){
        if(bValue){
            system.debug( 'Exception: ' + ex +' at Line: '+ex.getLineNumber() +' stackTrace: '+ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));}
        else
            system.debug('Handled Exception: ' + ex.getMessage() + ', at line number: ' + ex.getLineNumber() + ', Stacktrace: ' + ex.getStackTraceString());
    }
    /*******************************************************************************
    This CustomException Class is used for handle custom exception throughout appliaction
    ******************************************************************************/
    public class CustomException extends Exception {}
    public class CustomExceptionWrapper
    {
        public Integer lineNumber {get;set;}
        public String exceptionMessage {get;set;}
        public String stackTraceString {get;set;}
        public String userMessage {get;set;}
        public string messageType {get;set;}
        public string messageTitle {get;set;}

        public CustomExceptionWrapper(Integer lineNumber, String exceptionMessage, String stackTraceString, String userMessage,string messageType,string messageTitle)
        {
            this.lineNumber = lineNumber;
            this.exceptionMessage= exceptionMessage;
            this.stackTraceString = stackTraceString;
            this.userMessage = userMessage;
            this.messageType = messageType;
            this.messageTitle = messageTitle;
        }
    }
     public static void handleException(Exception ex){
        System.debug('Exception Details: ' + ex.getMessage() + '; Error at line no: ' + ex.getLineNumber());
        String deleteErrorMessage = ex.getMessage();
        Integer occurence;
        if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
        {
            occurence = deleteErrorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
            deleteErrorMessage = deleteErrorMessage.mid(occurence, deleteErrorMessage.length());
            occurence = deleteErrorMessage.lastIndexOf(':');
            deleteErrorMessage = deleteErrorMessage.mid(0, occurence);
        }
        throw new CustomException (JSON.serialize(new CustomExceptionWrapper(ex.getLineNumber(),deleteErrorMessage,ex.getStackTraceString(),deleteErrorMessage,'error','Error')));

    }
}