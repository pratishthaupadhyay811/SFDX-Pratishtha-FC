public with sharing class ObjectDataTranslationController {

    public map<string, string> mapLanguageOptions { get; set; }
    public string languageOptionsJSON { get; set; }
    public ObjectDataTranslationController()
    {
        languageOptionsJSON = JSON.serialize(getPortalLanguage());
    }
    @RemoteAction
    public static Map<string,string> getallTextFields( string strObjectName )
    {
        set<string> type = new set<string>();
        Map<string,Schema.SObjectField> mapFields = Schema.getGlobalDescribe().get(strObjectName).getDescribe().fields.getMap();
        Map<string,string> mapTextfields = new Map<string,string>();

        for( Schema.SObjectField field : mapFields.values() )
        {
            string fieldType = string.valueOf(field.getDescribe().getType());
            if( 'String'.equalsIgnoreCase(fieldType) || 'TextArea'.equalsIgnoreCase(fieldType) )
            {
                mapTextfields.put(string.valueOf(field.getDescribe().getName()),string.valueOf(field.getDescribe().getLabel()));

            }
        }
        return mapTextfields;
    }

    @RemoteAction
    public static Map<string,string> getallTextFieldDescribe( string strObjectName )
    {
        set<string> type = new set<string>();
        Map<string,Schema.SObjectField> mapFields = Schema.getGlobalDescribe().get(strObjectName).getDescribe().fields.getMap();
        Map<string,string> mapTextfields = new Map<string,string>();

        try
        {
            for( Schema.SObjectField field : mapFields.values() )
            {
                string fieldType = string.valueOf(field.getDescribe().getType());
                if( 'String'.equalsIgnoreCase(fieldType) || 'TextArea'.equalsIgnoreCase(fieldType) )
                {
                    JSONGenerator gen = JSON.createGenerator(true);
                    gen.writeStartObject();
                    gen.writeNumberField('length', field.getDescribe().length);
                    gen.writeBooleanField('richText', field.getDescribe().htmlFormatted);
                    if(field.getDescribe().getName()=='Name' && field.getDescribe().nillable)
                        gen.writeBooleanField('required', true);
                    else
                        gen.writeBooleanField('required', !field.getDescribe().nillable);
                    gen.writeEndObject();
                    mapTextfields.put(string.valueOf(field.getDescribe().getName()),gen.getAsString());
                }
            }
        }
        catch(exception ex)
        {
            System.debug('  ++  ' + ex.getMessage() + '   ' +ex.getLineNumber() + '  stack   ' + ex.getStackTraceString());
        }
        return mapTextfields;
    }

    @RemoteAction
    public static map<string,map<string,Field_Value_Translation__c>> getAllTranslations( string strRecordID, string strObjectName )
    {
        set<string> setFields = getallTextFields(strObjectName).keySet();
        string strQuery = 'SELECT Id, Field_Name__c, Language__c, RecordID__c, Translation_Value__c, Name FROM Field_Value_Translation__c WHERE Field_Name__c IN : setFields AND RecordID__c = :strRecordID WITH SECURITY_ENFORCED';
        list<Field_Value_Translation__c> lstsObject = DataBase.query(strQuery);

        map<string,map<string,Field_Value_Translation__c>> mapTransData = new map<string,map<string,Field_Value_Translation__c>>();
        for(Field_Value_Translation__c fieldTranslation : lstsObject)
        {
            map<string,Field_Value_Translation__c> mapInnerTransData = new map<string,Field_Value_Translation__c>();
            if(string.isNotBlank(fieldTranslation.Field_Name__c) && string.isNotBlank(fieldTranslation.Language__c))
            {
                for(Field_Value_Translation__c innerfieldTranslation : lstsObject)
                {
                    if((fieldTranslation.Field_Name__c).equalsIgnoreCase(innerfieldTranslation.Field_Name__c))
                    {
                        mapInnerTransData.put(innerfieldTranslation.Language__c, innerfieldTranslation);
                    }
                }
                mapTransData.put(fieldTranslation.Field_Name__c,mapInnerTransData);
            }
        }
        return mapTransData;
    }

    @RemoteAction
    public static list<sObject> getLookUpRecords( string strObjectName )
    {
        strObjectName = strObjectName.replaceAll('[^0-9a-zA-Z_.]', '');
        string strWhereCondition = '';
        if(strObjectName == 'Campaign')
            strWhereCondition = 'FGM_Portal__Visibility__c = \'Public\' AND FGM_Portal__Visibility__c != Null';
        else if (strObjectName == 'FGM_Portal__Campaign_Quiz__c')
            strWhereCondition = 'FGM_Portal__isActive__c = true';

        map<string,string> mapFields = getallTextFields(strObjectName);
        string strQuery = 'SELECT Id ' + (mapFields != null && !mapFields.isEmpty() ? (', '+ String.join(new list<String>(mapFields.keySet()), ', ') ) : '')  +' FROM ' + strObjectName ;
        if(string.isNotBlank(strWhereCondition))
            strQuery += ' Where ' + strWhereCondition;
        strQuery += ' WITH SECURITY_ENFORCED';
        list<sObject> lstsObject = DataBase.query(strQuery);
        return lstsObject;
    }

    @RemoteAction
    public static void deleteTranslationRecord( Id idRecordToDelete )
    {
        String sobjectType = idRecordToDelete.getSObjectType().getDescribe().getLocalName();
        if(sobjectType.equalsIgnoreCase('Field_Value_Translation__c'))
        {
            string strDeleteQuery = 'SELECT Id, Field_Name__c, Language__c, RecordID__c, Translation_Value__c, Name FROM Field_Value_Translation__c WHERE ID =: idRecordToDelete WITH SECURITY_ENFORCED';
            list<Field_Value_Translation__c> lstToDelete = DataBase.query(strDeleteQuery);
            CrudFlsService.getInstance().assertDeletable(lstToDelete);
            delete lstToDelete;
        }
    }

    @RemoteAction
    public static void saveTranslationRecords( string strObjectName, string strTranslatedRecord, string fieldValueTranslationJSON)
    {
        try
        {
            if(string.isNotBlank(strObjectName) && string.isNotBlank(fieldValueTranslationJSON))
            {
                list<Field_Value_Translation__c> lstfieldTranslationdeserialized  = (list<Field_Value_Translation__c>)JSON.deserialize(fieldValueTranslationJSON, list<Field_Value_Translation__c>.class);//Type.forName('Field_Value_Translation__c'));
                if(!lstfieldTranslationdeserialized.isEmpty()) {
                    CrudFlsService.getInstance().assertUpdateable(lstfieldTranslationdeserialized);
                    upsert lstfieldTranslationdeserialized;
                }
            }

            if(string.isNotBlank(strObjectName) && string.isNotBlank(strTranslatedRecord))
            {
                sObject lstTranslatedRecord = (sObject)JSON.deserialize(strTranslatedRecord, Type.forName(strObjectName));
                if(lstTranslatedRecord != null ) {
                    CrudFlsService.getInstance().assertUpdateable(lstTranslatedRecord);
                    upsert lstTranslatedRecord;
                }
            }
        }
        catch(exception ex)
        {
            System.debug('  ++  ' + ex.getMessage() + '   ' +ex.getLineNumber() + '  stack   ' + ex.getStackTraceString());
        }

    }

    // To get all language from Portal Configuration
    public static map<string, string> getPortalLanguage()
    {
        Map<String,String> mapConfigLanguages = new Map<String,String>();
        List<FGM_Portal__PortalConfiguration__c> lstPortalConfRecord = FGM_Portal__PortalConfiguration__c.getall() != null ? FGM_Portal__PortalConfiguration__c.getall().values(): null;

        if(lstPortalConfRecord  != null && !lstPortalConfRecord.isEmpty())
        {
            for(FGM_Portal__PortalConfiguration__c portalConf :lstPortalConfRecord)
            {
                Map<String,String> mapOrgLanguages = getOrgLanguageMap();
                if(mapOrgLanguages != null)
                {
                    String languageCode = mapOrgLanguages.get(portalConf.FGM_Portal__LanguageSelection__c);
                    if(String.isNotBlank(languageCode) && String.isBlank(mapConfigLanguages.get(portalConf.FGM_Portal__LanguageSelection__c)))
                        mapConfigLanguages.put(portalConf.FGM_Portal__LanguageSelection__c,languageCode);
                }
            }
        }
        if(mapConfigLanguages == null || mapConfigLanguages.isEmpty())
        {
            mapConfigLanguages.put('en_US','English');
            return mapConfigLanguages;
        }
        return mapConfigLanguages;
    }

    // Code we will invoke on page load.
    @RemoteAction
    public static string backtofcportalManager()
    {
        return string.valueOf(System.Page.fcportalManager.getUrl());
    }
    // To get Map of all language from Organization.
    public static Map<String,String> getOrgLanguageMap()
    {
        Map<String,String> mapLanguages = new Map<String,String>();
        Schema.DescribeFieldResult fieldResult = User.LanguageLocaleKey.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry picklistEntry : picklistValues)
        {
            mapLanguages.put(picklistEntry.getValue(),picklistEntry.getLabel());
        }
        return mapLanguages;
    }
}