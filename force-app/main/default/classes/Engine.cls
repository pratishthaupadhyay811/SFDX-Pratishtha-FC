public with sharing class Engine {

    @RemoteAction
    public static List<Database.SaveResult> insertRecords(String strAPIName, List<String> lstJSONObject)
    {
        List<sObject> lstNewSobject = new List<sObject>();
        for(String strJSONObject : lstJSONObject)
        {
            sObject newSobject = ConstructSobject(strAPIName.trim(), strJSONObject);
            lstNewSobject.add(newSobject);
        }
        CrudFlsService.getInstance().assertCreateable(lstNewSobject);
        return Database.insert(lstNewSobject);
    }

    @RemoteAction
    public static List<Database.SaveResult> updateRecords(String strAPIName, List<String> lstJSONObject)
    {
        List<sObject> lstNewSobject = new List<sObject>();
        for(String strJSONObject : lstJSONObject)
        {
            sObject newSobject = ConstructSobject(strAPIName.trim(), strJSONObject);
            lstNewSobject.add(newSobject);
        }
        CrudFlsService.getInstance().assertUpdateable(lstNewSobject);
        return Database.update(lstNewSobject);
    }

    @RemoteAction
    public static List<Database.DeleteResult> deleteRecords(String strAPIName, List<String> lstJSONObject)
    {
        List<sObject> lstNewSobject = new List<sObject>();
        for(String strJSONObject : lstJSONObject)
        {
            sObject newSobject = ConstructSobject(strAPIName.trim(), strJSONObject);
            lstNewSobject.add(newSobject);
        }
        CrudFlsService.getInstance().assertDeletable(lstNewSobject);
        return Database.delete(lstNewSobject);
    }

    @remoteAction
    public static DescribeSObjectResultWrapper describeSobject( string sObjectApiName, boolean fetchObjectAccess, boolean fetchChildrenObjects, boolean fetchRecordTypes, boolean fetchFieldSets, boolean fetchFieldsResult ){
        try{
            return new DescribeSObjectResultWrapper( Schema.getGlobalDescribe().get(sObjectApiName).getDescribe(), fetchObjectAccess, fetchChildrenObjects, fetchRecordTypes, fetchFieldSets, fetchFieldsResult);
        }
        catch( Exception ex ){
            return null;
        }
    }
    public class DescribeSObjectResultWrapper{
        public List<String> childrenObjects { get; set; }
        public string keyPrefix { get; set; }
        public string label { get; set; }
        public string labelPlural { get; set; }
        public string apiName { get; set; }
        public string apiNameLocal { get; set; }
        public Map<string,string> recordTypes { get; set; }
        public ObjectLevelAccessWrapper objectAccess { get; set; }
        public List<DescribeSObjectFieldResultWrapper> fieldDetails { get; set; }
        public List<FieldSetWrapper> fieldSets { get; set; }
        public DescribeSObjectResultWrapper( Schema.DescribeSObjectResult describeSobjectResult, boolean fetchObjectAccess, boolean fetchChildrenObjects, boolean fetchRecordTypes, boolean fetchFieldSets, boolean fetchFieldsResult )
        {
            if( fetchChildrenObjects == true )
            {
                this.childrenObjects = new List<string>();
                if( describeSobjectResult.getChildRelationships() != null && describeSobjectResult.getChildRelationships().size() > 0 ){
                    for( Schema.ChildRelationship relationship : describeSobjectResult.getChildRelationships() ){
                        this.childrenObjects.add( relationship.getChildSObject().getDescribe().getName() );
                    }
                }
            }
            this.keyPrefix = describeSobjectResult.getKeyPrefix();
            this.label = describeSobjectResult.getLabel();
            this.labelPlural = describeSobjectResult.getLabelPlural();
            this.apiName = describeSobjectResult.getName();
            this.apiNameLocal = describeSobjectResult.getLocalName();
            if( fetchRecordTypes == true ){
                recordTypes = new Map<String,string>();
                if( describeSobjectResult.getRecordTypeInfos() != null && describeSobjectResult.getRecordTypeInfos().size() > 0 ){
                    for( Schema.RecordTypeInfo recordTypeInfo : describeSobjectResult.getRecordTypeInfos() ){
                        this.recordTypes.put( String.valueOf(recordTypeInfo.getRecordTypeId()), recordTypeInfo.getName() );
                    }
                }
            }
            if( fetchObjectAccess == true )
                this.objectAccess = new ObjectLevelAccessWrapper( describeSobjectResult );
            if( fetchFieldsResult == true ){
                this.fieldDetails = new List<DescribeSObjectFieldResultWrapper>();
                for( Schema.SobjectField field : describeSobjectResult.fields.getMap().values() ){
                    Schema.DescribeFieldResult fieldResult = field.getDescribe();
                    this.fieldDetails.add( new DescribeSObjectFieldResultWrapper( field ));
                }
            }
            if( fetchFieldSets == true ){
                this.fieldSets = new List<FieldSetWrapper>();
                if( describeSobjectResult.FieldSets.getMap() != null && describeSobjectResult.FieldSets.getMap().values().size() > 0 ){
                    for( Schema.FieldSet fieldSet : describeSobjectResult.FieldSets.getMap().values() ){
                        this.fieldSets.add( new FieldSetWrapper( fieldSet ) );
                    }
                }
            }
        }
    }
    public class FieldSetWrapper
    {
        public string description { get; set; }
        public string label { get; set; }
        public string apiName { get; set; }
        public string nameSpace { get; set; }
        public string sObjectType { get; set; }
        public List<FieldSetMemberWrapper> fieldSetMembers { get; set; }
        public FieldSetWrapper( Schema.FieldSet fieldSet )
        {
            this.fieldSetMembers = new List<FieldSetMemberWrapper>();
            for( Schema.FieldSetMember fieldSetMember : fieldSet.getFields() )
            {
                Schema.SObjectField fieldResult = fieldSet.getSobjectType().getDescribe().fields.getMap().get( fieldSetMember.getFieldPath() );
                this.fieldSetMembers.add( new FieldSetMemberWrapper( fieldSetMember, fieldResult ) );
            }
            this.description = fieldSet.getDescription();
            this.label = fieldSet.getLabel();
            this.apiName = fieldSet.getName();
            this.nameSpace = fieldSet.getNamespace();
            this.sObjectType = String.valueOf( fieldSet.getSObjectType() );
        }
    }

    public class FieldSetMemberWrapper
    {
        public boolean isDBRequired { get; set; }
        public boolean isRequired { get; set; }
        public string label { get; set; }
        public string apiName { get; set; }
        public string fieldType { get; set; }
        public string inlineHelp { get; set; }
        public integer characterLimit { get; set; }
        public integer byteLimit { get; set; }
        public integer digitsLimit { get; set; }
        public string apiNameLocal { get; set; }
        public List<PicklistEntryWrapper> picklistValues { get; set; }
        public integer precision { get; set; }
        public List<SObjectTypeWrapper> relatedObjects { get; set; }
        public integer scale { get; set; }
        public FieldLevelAccessWrapper fieldAccess { get; set; }
        public boolean isAutoNumber { get; set; }
        public boolean isFormula { get; set; }
        public boolean isCaseSensitive { get; set; }
        public boolean isCustom { get; set; }
        public boolean isDependentPicklist { get; set; }
        public boolean isDeprecatedAndHidden { get; set; }
        public boolean isFilterable { get; set; }
        public boolean isGroupable { get; set; }
        public boolean isHtmlFormatted { get; set; }
        public boolean isSortable { get; set; }
        public String maskChar {get;set;}
        public String maskType {get;set;}
        public FieldSetMemberWrapper( Schema.FieldSetMember fieldSetMember, Schema.SObjectField field )
        {
            this.isDBRequired = fieldSetMember.getDBRequired();
            this.isRequired = fieldSetMember.getRequired();
            this.label = fieldSetMember.getLabel();
            this.apiName = fieldSetMember.getFieldPath();
            this.fieldType = String.valueOf( fieldSetMember.getType() );

            this.inlineHelp = field.getDescribe().getInlineHelpText();
            this.characterLimit = field.getDescribe().getLength();
            this.byteLimit = field.getDescribe().getByteLength();
            this.digitsLimit = field.getDescribe().getDigits();
            this.apiNameLocal = field.getDescribe().getLocalName();
            this.picklistValues = new List<PicklistEntryWrapper>();
            for( Schema.PicklistEntry picklistEntry : field.getDescribe().getPicklistValues() )
            {
                this.picklistValues.add( new PicklistEntryWrapper( picklistEntry ));
            }
            this.precision = field.getDescribe().getPrecision();
            this.relatedObjects = new List<SObjectTypeWrapper>();
            for( Schema.SobjectType sobjType : field.getDescribe().getReferenceTo() )
            {
                this.relatedObjects.add( new SObjectTypeWrapper( sobjType ) );
            }
            this.scale = field.getDescribe().getScale();
            this.fieldAccess = new FieldLevelAccessWrapper( field.getDescribe() );
            this.isAutoNumber = field.getDescribe().isAutoNumber();
            this.isFormula = field.getDescribe().isCalculated();
            this.isCaseSensitive = field.getDescribe().isCaseSensitive();
            this.isCustom = field.getDescribe().isCustom();
            this.isDependentPicklist = field.getDescribe().isDependentPicklist();
            this.isDeprecatedAndHidden = field.getDescribe().isDeprecatedAndHidden();
            this.isFilterable = field.getDescribe().isFilterable();
            this.isGroupable = field.getDescribe().isGroupable();
            this.isHtmlFormatted = field.getDescribe().isHtmlFormatted();
            this.isSortable = field.getDescribe().isSortable();
            this.maskChar = field.getDescribe().getMask();
            this.maskType = field.getDescribe().getMaskType();
        }
    }

    public class ObjectLevelAccessWrapper
    {
        public boolean isCreatable { get; set; }
        public boolean isEditable { get; set; }
        public boolean isReadable { get; set; }
        public boolean isDeletable { get; set; }
        public ObjectLevelAccessWrapper ( Schema.DescribeSObjectResult describeSobjectResult )
        {
            this.isReadable = describeSobjectResult.isAccessible();
            this.isCreatable = describeSobjectResult.isCreateable();
            this.isEditable = describeSobjectResult.isUpdateable();
            this.isDeletable = describeSobjectResult.isDeletable();
        }
    }

    public class DescribeSObjectFieldResultWrapper
    {
        public string inlineHelp { get; set; }
        public string label { get; set; }
        public integer characterLimit { get; set; }
        public integer byteLimit { get; set; }
        public integer digitsLimit { get; set; }
        public string apiNameLocal { get; set; }
        public string apiName { get; set; }
        public string controllerField { get; set; }
        public List<PicklistEntryWrapper> picklistValues { get; set; }
        public integer precision { get; set; }
        public List<SObjectTypeWrapper> relatedObjects { get; set; }
        public integer scale { get; set; }
        public string fieldType { get; set; }
        public FieldLevelAccessWrapper fieldAccess { get; set; }
        public boolean isAutoNumber { get; set; }
        public boolean isFormula { get; set; }
        public boolean isCaseSensitive { get; set; }
        public boolean isCustom { get; set; }
        public boolean isDependentPicklist { get; set; }
        public boolean isDeprecatedAndHidden { get; set; }
        public boolean isFilterable { get; set; }
        public boolean isGroupable { get; set; }
        public boolean isHtmlFormatted { get; set; }
        public boolean isRequired { get; set; }
        public boolean isSortable { get; set; }
        public String maskChar {get;set;}
        public String maskType {get;set;}
        public DescribeSObjectFieldResultWrapper( Schema.SObjectField field )
        {
            this.inlineHelp = field.getDescribe().getInlineHelpText();
            this.label = field.getDescribe().getLabel();
            this.characterLimit = field.getDescribe().getLength();
            this.byteLimit = field.getDescribe().getByteLength();
            this.digitsLimit = field.getDescribe().getDigits();
            this.apiNameLocal = field.getDescribe().getLocalName();
            this.apiName = field.getDescribe().getName();
            this.controllerField = string.valueOf(field.getDescribe().getController());
            this.picklistValues = new List<PicklistEntryWrapper>();
            for( Schema.PicklistEntry picklistEntry : field.getDescribe().getPicklistValues() )
            {
                this.picklistValues.add( new PicklistEntryWrapper( picklistEntry ));
            }
            this.precision = field.getDescribe().getPrecision();
            this.relatedObjects = new List<SObjectTypeWrapper>();
            for( Schema.SobjectType sobjType : field.getDescribe().getReferenceTo() )
            {
                this.relatedObjects.add( new SObjectTypeWrapper( sobjType ) );
            }
            this.scale = field.getDescribe().getScale();
            this.fieldType = String.valueOf(field.getDescribe().getType());
            this.fieldAccess = new FieldLevelAccessWrapper( field.getDescribe() );
            this.isAutoNumber = field.getDescribe().isAutoNumber();
            this.isFormula = field.getDescribe().isCalculated();
            this.isCaseSensitive = field.getDescribe().isCaseSensitive();
            this.isCustom = field.getDescribe().isCustom();
            this.isDependentPicklist = field.getDescribe().isDependentPicklist();
            this.isDeprecatedAndHidden = field.getDescribe().isDeprecatedAndHidden();
            this.isFilterable = field.getDescribe().isFilterable();
            this.isGroupable = field.getDescribe().isGroupable();
            this.isHtmlFormatted = field.getDescribe().isHtmlFormatted();
            this.isRequired = !(field.getDescribe().isNillable());
            this.isSortable = field.getDescribe().isSortable();
            this.maskChar = field.getDescribe().getMask();
            this.maskType = field.getDescribe().getMaskType();

        }
    }

    public class SObjectTypeWrapper
    {
        public string label { get; set; }
        public string apiName { get; set; }
        public SObjectTypeWrapper( Schema.SObjectType sobjectType )
        {
            this.label = sobjectType.getDescribe().getLabel();
            this.apiName = sobjectType.getDescribe().getName();
        }
    }

    public class PicklistEntryWrapper
    {
        public string label { get; set; }
        public string apiName { get; set; }
        public boolean isActive { get; set; }
        public boolean isDefault { get; set; }
        public PicklistEntryWrapper( Schema.PicklistEntry picklistEntry )
        {
            this.label = picklistEntry.getLabel();
            this.apiName = picklistEntry.getValue();
            this.isActive = picklistEntry.isActive();
            this.isDefault = picklistEntry.isDefaultValue();
        }
    }

    public class FieldLevelAccessWrapper
    {
        public boolean isReadable { get; set; }
        public boolean isUpdateable { get; set; }
        public FieldLevelAccessWrapper( Schema.DescribeFieldResult fieldResult )
        {
            this.isReadable = fieldResult.isAccessible();
            this.isUpdateable = fieldResult.isUpdateable();
        }
    }

    @remoteAction
    public static List<sObject> getCustomSettingRecords(String customSettingName, string instanceKey)
    {
        List<sObject> lstSObjects;
        if( customSettingName.equalsIgnoreCase('FGM_Portal__AddressCopy__c') )
        {
            lstSObjects = FGM_Portal__AddressCopy__c.getAll().values();
        }
        else if( customSettingName.equalsIgnoreCase('FGM_Portal__CommunitySetting__c') )
        {
            lstSObjects = FGM_Portal__CommunitySetting__c.getAll().values();
        }
        else if( customSettingName.equalsIgnoreCase('FGM_Portal__Community_Static_Resource__c') )
        {
            lstSObjects = FGM_Portal__Community_Static_Resource__c.getAll().values();
        }
        else if( customSettingName.equalsIgnoreCase('FGM_Portal__CustomValidation__c') )
        {
            lstSObjects = FGM_Portal__CustomValidation__c.getAll().values();
        }
        else if( customSettingName.equalsIgnoreCase('FGM_Base__GRAlertSettings__c') )
        {
            lstSObjects = FGM_Base__GRAlertSettings__c.getAll().values();
        }
        else if( customSettingName.equalsIgnoreCase('FGM_Portal__PortalAlertSettings__c') )
        {
            lstSObjects = FGM_Portal__PortalAlertSettings__c.getAll().values();
        }
        else if( customSettingName.equalsIgnoreCase('FGM_Portal__PortalConfiguration__c') )
        {
            lstSObjects = FGM_Portal__PortalConfiguration__c.getAll().values();
        }
        else if( customSettingName.equalsIgnoreCase('FGM_Portal__PortalDashboardConfiguration__c') )
        {
            lstSObjects = FGM_Portal__PortalDashboardConfiguration__c.getAll().values();
        }
        else if( customSettingName.equalsIgnoreCase('FGM_Portal__Portal_Instance_User__c') )
        {
            lstSObjects = FGM_Portal__Portal_Instance_User__c.getAll().values();
        }
        else if( customSettingName.equalsIgnoreCase('FGM_Portal__RecommendationPortalConfiguration__c') )
        {
            lstSObjects = FGM_Portal__RecommendationPortalConfiguration__c.getAll().values();
        }
        else if( customSettingName.equalsIgnoreCase('FGM_Portal__Triggers__c') )
        {
            lstSObjects = FGM_Portal__Triggers__c.getAll().values();
        }
        else if( customSettingName.equalsIgnoreCase('FGM_Portal__GlobalPortalSettings__c') )
        {
            if( instanceKey != null )
            {
                lstSObjects = new List<sObject>();
                lstSObjects.add(FGM_Portal__GlobalPortalSettings__c.getInstance( instanceKey ));
            }
            else
            {
                lstSObjects = new List<sObject>();
                lstSObjects.add(FGM_Portal__GlobalPortalSettings__c.getInstance());
            }
        }
        else
            return null;
        return lstSObjects;
    }

    public static sObject constructSobject(String sObjectApiName, String jSONSObject)
    {
        try
        {
            Map<String, Object> fieldMap = null;
            fieldMap = (Map<String, Object>)JSON.deserializeUntyped(jSONSObject);
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjectApiName);
            SObject newSobject = targetType.newSObject();
            Map<String, Schema.sObjectField> targetFields = targetType.getDescribe().fields.getMap();
            for (String key : fieldMap.keySet())
            {
                Object value = fieldMap.get(key);
                Schema.DisplayType valueType = targetFields.get(key).getDescribe().getType();
                if (value instanceof String && valueType != null && valueType != Schema.DisplayType.String)
                {
                    String svalue = (String)value;
                    if (valueType == Schema.DisplayType.Date)
                        newSobject.put(key, Date.valueOf(svalue));
                    else if(valueType == Schema.DisplayType.DateTime)
                        newSobject.put(key, DateTime.valueOfGmt(svalue));
                    else if (valueType == Schema.DisplayType.Percent || valueType == Schema.DisplayType.Currency)
                        newSobject.put(key, svalue == '' ? null : Decimal.valueOf(svalue));
                    else if (valueType == Schema.DisplayType.Double)
                        newSobject.put(key, svalue == '' ? null : Double.valueOf(svalue));
                    else if (valueType == Schema.DisplayType.Integer)
                        newSobject.put(key, Integer.valueOf(svalue));
                    else if (valueType == Schema.DisplayType.Base64)
                        newSobject.put(key, Blob.valueOf(svalue));
                    else
                        newSobject.put(key, svalue);
                }
                else
                    newSobject.put(key, value);
            }
            return newSobject;
        }
        catch(Exception ex)
        {
            system.debug('Exception occured while creating sObject:'+ex.getMessage());
            return null;
        }
    }
    public class UserInfoWrapper
    {
        public string defaultCurrency { get; set; }
        public string firstName { get; set; }
        public string lastName { get; set; }
        public string locale { get; set; }
        public string name { get; set; }
        public string orgId { get; set; }
        public string orgName { get; set; }
        public string profileId { get; set; }
        public string timezone { get; set; }
        public string preferredUITheme { get; set; }
        public string appliedUITheme { get; set; }
        public string email { get; set; }
        public string id { get; set; }
        public string username { get; set; }
        public string roleId { get; set; }
        public string userType { get; set; }
        public string sessionId { get; set; }
        public string networkId { get; set; }
        public UserInfoWrapper()
        {
            this.defaultCurrency = UserInfo.getDefaultCurrency();
            this.firstName = UserInfo.getFirstName();
            this.lastName = UserInfo.getLastName();
            this.locale = UserInfo.getLocale();
            this.name = UserInfo.getName();
            this.orgId = UserInfo.getOrganizationId();
            this.orgName = UserInfo.getOrganizationName();
            this.profileId = UserInfo.getProfileId();
            this.timezone = UserInfo.getTimeZone().toString();
            this.preferredUITheme = UserInfo.getUiTheme();
            this.appliedUITheme = UserInfo.getUiThemeDisplayed();
            this.email = UserInfo.getUserEmail();
            this.id = UserInfo.getUserId();
            this.username = UserInfo.getUserName();
            this.roleId = UserInfo.getUserRoleId();
            this.userType = UserInfo.getUserType();
            this.sessionId = UserInfo.getSessionId();
            this.networkId = System.Network.getNetworkId();
        }
    }
    @RemoteAction
    public static Engine.UserInfoWrapper getUserInfo()
    {
        return new Engine.UserInfoWrapper();
    }

    //Utilities class merged methods
    @RemoteAction
    public static Database.SaveResult[] create(sObject[] records){
        CrudFlsService.getInstance().assertCreateable(records);
        return Database.insert(records);
    }
    @RemoteAction
    public static Database.SaveResult[] save(sObject[] records){
        CrudFlsService.getInstance().assertUpdateable(records);
        return Database.update(records);
    }
    @RemoteAction
    public static Database.DeleteResult remove(sObject record){
        CrudFlsService.getInstance().assertDeletable(record);
        return Database.delete(record);
    }
    @RemoteAction
    public static Database.DeleteResult[] removeItems(sObject[] records){
        CrudFlsService.getInstance().assertDeletable(records);
        return Database.delete(records);
    }
    @RemoteAction
    public static Database.SaveResult[] updateQuizTabsInfo(String[] records){
        Integer count=0;

        List<FGM_Portal__Related_List_Controller__c> lstTabs = [
            SELECT
                Field_Labels_Long__c,
                Name,
                ObjectName__c,
                ParentObject__c,
                RecordType.Name,
                ShowNewButton__c,
                SortOrder__c
            FROM Related_List_Controller__c
            WHERE Id IN :records
            WITH SECURITY_ENFORCED
        ];

        for(Id tabId : records)
        {
            for(FGM_Portal__Related_List_Controller__c tab : lstTabs)
            {
                if(tabId == tab.Id)
                {
                    tab.FGM_Portal__SortOrder__c = count;
                    count++;
                }
            }
        }
        CrudFlsService.getInstance().assertUpdateable(lstTabs);
        return Database.update(lstTabs);
    }
    @RemoteAction
    public static map<string , list<FieldInfoWrapper>> getFieldsets(String objectName){
        map<string , list<FieldInfoWrapper>> fieldSetMap = new map<string,list<FieldInfoWrapper>>();
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Map<String, Schema.SObjectField> field_map = DescribeSObjectResultObj.fields.getMap();
        Map<String,Schema.FieldSet>  allFieldSetsMap = DescribeSObjectResultObj.FieldSets.getMap();
        final String PICKLIST = 'PICKLIST';
        final String MULTIPICKLIST = 'MULTIPICKLIST';
        final String FGM_PORTAL_NEW = 'FGM_Portal__new';
         final String FGM_PORTAL_EDIT = 'FGM_Portal__edit';
        final String VIEW = 'view';
        try{
            for(string currentSetName : allFieldSetsMap.keySet()) {
                if(currentSetName.startsWithIgnoreCase(FGM_PORTAL_NEW) || currentSetName.startsWithIgnoreCase(VIEW) || currentSetName.startsWithIgnoreCase(FGM_PORTAL_EDIT)){
                    for(Schema.FieldSetMember currentField : allFieldSetsMap.get(currentSetName).getFields()){
                        List<String> lstPickListValues = new List<String>();
                        if(string.valueOf(currentField.getType()).equalsIgnoreCase(PICKLIST) || string.valueOf(currentField.getType()).equalsIgnoreCase(MULTIPICKLIST)){
                            List<Schema.PicklistEntry> pick_list_values = field_map.get(currentField.getFieldPath()).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
                            for(Schema.PicklistEntry currentPicklist : pick_list_values){
                                lstPickListValues.add(currentPicklist.getValue());
                            }
                        }
                        boolean isUpdateable = field_map.get(currentField.getFieldPath()).getDescribe().isUpdateable();
                        string referenceName = field_map.get(currentField.getFieldPath()).getDescribe().getRelationshipName();
                        string parentName = '';
                        List<Schema.sObjectType> parentTypes = field_map.get(currentField.getFieldPath()).getDescribe().getReferenceTo();
                        if(parentTypes != null && parentTypes.size()>0)
                            parentName = parentTypes[0].getDescribe().getName();
                        if(fieldSetMap.get(currentSetName) != null)
                            fieldSetMap.get(currentSetName).add(new FieldInfoWrapper(currentField.getLabel(),currentField.getFieldPath(),string.valueOf(currentField.getType()),currentField.getDBRequired() ? true:currentField.getRequired(),lstPickListValues, isUpdateable, referenceName, parentName));
                        else{
                            fieldSetMap.put(currentSetName, new list<FieldInfoWrapper>());
                            fieldSetMap.get(currentSetName).add(new FieldInfoWrapper(currentField.getLabel(),currentField.getFieldPath(),string.valueOf(currentField.getType()),currentField.getDBRequired() ? true:currentField.getRequired(),lstPickListValues, isUpdateable, referenceName, parentName));
                        }
                    }
                }
            }
            return fieldSetMap;
        }
        catch(Exception ex)
        {
            system.debug( 'Exception: ' + ex +'at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
            return null;
        }
    }
    @RemoteAction
    public static sObject[] getChildObjectData(String objectName){
        Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get(objectName).getDescribe().SObjectType.getDescribe().fields.getMap();
        List<String> accessiblefields = new List<String>();
        try{
            for(Schema.SObjectField field : fields.values()){
                if(field.getDescribe().isAccessible())
                {
                    accessiblefields.add(field.getDescribe().getName());
                    if(string.valueOf(field.getDescribe().getType()) == 'REFERENCE' && field.getDescribe().isCustom()){
                        accessiblefields.add(field.getDescribe().getName().replace('__c','__r')+'.Name');
                    }
                }
            }
            String allfields='';
            for(String fieldname : accessiblefields)
                allfields += fieldname+',';
            allfields = allfields.subString(0,allfields.length()-1);
            string strQuery = 'SELECT '+allfields+' FROM '+objectName +' WITH SECURITY_ENFORCED limit 5 ';
            return Database.query(strQuery);
        }
        catch(Exception ex)
        {
            system.debug( 'Exception: ' + ex +'at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
            return null;
        }
    }

    public static String setToString( Set<String> setValues, Boolean isEnclosed )
    {
        try
        {
            String result = '';
            List<String> lstValues = new List<String>();
            lstValues.addAll(setValues);
            if( lstValues != null && !lstValues.isEmpty() )
            {
                for( Integer iCount = 0; iCount < lstValues.size(); iCount++ )
                {
                    if( ( iCount + 1 ) < lstValues.size() )
                    {
                        if( isEnclosed )
                            result += '\'' + String.escapeSingleQuotes(lstValues[iCount]) + '\', ';
                        else
                            result += String.escapeSingleQuotes(lstValues[iCount]) + ', ';
                    }
                    else
                    {
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
        catch( Exception ex )
        {
            system.debug('Handled Exception: ' + ex.getMessage() + ', at line number: ' + ex.getLineNumber());
            return null;
        }
    }
    public static String setToString( Set<Id> setValues, Boolean isEnclosed )
    {
        try
        {
            String result = '';
            List<Id> lstValues = new List<Id>();
            lstValues.addAll(setValues);
            if( lstValues != null && !lstValues.isEmpty() )
            {
                for( Integer iCount = 0; iCount < lstValues.size(); iCount++ )
                {
                    if( ( iCount + 1 ) < lstValues.size() )
                    {
                        if( isEnclosed )
                            result += '\'' + String.escapeSingleQuotes(lstValues[iCount]) + '\', ';
                        else
                            result += String.escapeSingleQuotes(lstValues[iCount]) + ', ';
                    }
                    else
                    {
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
        catch( Exception ex )
        {
            system.debug('Handled Exception: ' + ex.getMessage() + ', at line number: ' + ex.getLineNumber() + ', Stacktrace: ' + ex.getStackTraceString());
            return null;
        }
    }
    public static String listToString( List<String> lstValues, Boolean isEnclosed )
    {
        try
        {
            String result = '';
            if( lstValues != null && !lstValues.isEmpty() )
            {
                for( Integer iCount = 0; iCount < lstValues.size(); iCount++ )
                {
                    if( ( iCount + 1 ) < lstValues.size() )
                    {
                        if( isEnclosed )
                            result += '\'' + String.escapeSingleQuotes(lstValues[iCount]) + '\', ';
                        else
                            result += String.escapeSingleQuotes(lstValues[iCount]) + ', ';
                    }
                    else
                    {
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
        catch( Exception ex )
        {
            system.debug('Handled Exception: ' + ex.getMessage() + ', at line number: ' + ex.getLineNumber());
            return null;
        }
    }
    public static String listToString( List<Id> lstValues, Boolean isEnclosed )
    {
        try
        {
            String result = '';
            if( lstValues != null && !lstValues.isEmpty() )
            {
                for( Integer iCount = 0; iCount < lstValues.size(); iCount++ )
                {
                    if( ( iCount + 1 ) < lstValues.size() )
                    {
                        if( isEnclosed )
                            result += '\'' + String.escapeSingleQuotes(lstValues[iCount]) + '\', ';
                        else
                            result += String.escapeSingleQuotes(lstValues[iCount]) + ', ';
                    }
                    else
                    {
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
        catch( Exception ex )
        {
            system.debug('Handled Exception: ' + ex.getMessage() + ', at line number: ' + ex.getLineNumber());
            return null;
        }
    }

    // To get Quiz specific SObjectField.
    public static list<Schema.SObjectField> getQuestionFields(string strQuizID, string strObjectName, string strLanguage)
    {
        set<String> setQuestionFields = new set<String>();
        list<Schema.SObjectField> lstQuestionFields = new list<Schema.SObjectField>();

        try
        {

            for (Quiz_Questions__c  quizQuestion : [
                SELECT
                    Field__c,
                    Language__c,
                    Name,
                    Quiz__c
                FROM Quiz_Questions__c
                WHERE (
                    Language__c = null
                    OR Language__c = :strLanguage
                )
                AND Quiz__c = :strQuizID
                AND Field__c != null
                AND Tab__r.RecordType.Name = 'Portal Tab'
                WITH SECURITY_ENFORCED
            ]) {
                setQuestionFields.add(quizQuestion.Field__c);
            }

            for( Schema.SObjectField field : Schema.getGlobalDescribe().get(strObjectName).getDescribe().fields.getMap().values() )
            {
                if(setQuestionFields.contains(field.getDescribe().getname()))
                    lstQuestionFields.add( field );
            }
            return lstQuestionFields;
        }
        catch(Exception ex)
        {
            system.debug( 'Exception: ' + ex +' at Line: '+ex.getLineNumber() +' stackTrace: '+ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            return null;
        }
    }
    public static Map<String,String> getMapFromParameters(String parameters, String stringSeperator, String subStringSeperator)
    {
        try
        {
            Map<String,String> mapResults = new Map<String,String>();
            for( String str : parameters.split(stringSeperator) )
            {
                List<String> lstSubStrings = str.split(subStringSeperator);
                mapResults.put( lstSubStrings[0], lstSubStrings[1] );
            }
            return mapResults;
        }
        catch( Exception ex )
        {
            system.debug( 'Exception: ' + ex +' at Line: '+ex.getLineNumber() +' stackTrace: '+ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            return null;
        }
    }
    public static Boolean getContainsIgnoreCase( String source, String content )
    {
        try
        {
            return source.containsIgnoreCase( content );
        }
        catch( Exception ex )
        {
            system.debug( 'Exception: ' + ex +' at Line: '+ex.getLineNumber() +' stackTrace: '+ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            return null;
        }
    }
    public static string getCampaignLookupField( String sObjectName )
    {
        try
        {
            GlobalPortalSettings__c globalPortalSettings = GlobalPortalSettings__c.getInstance();
            if( globalPortalSettings != null )
            {
                if( sObjectName.equalsIgnoreCase( 'Opportunity' ) && globalPortalSettings.Request_Campaign_Field_Name__c != null )
                {
                    for( Schema.SObjectField sObjField : Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap().values() )
                    {
                        Schema.DescribeFieldResult fieldResult = sObjField.getDescribe();
                        String apiName = fieldResult.getName().toLowerCase();
                        String apiLocalName = fieldResult.getLocalName().toLowerCase();
                        if( globalPortalSettings.Request_Campaign_Field_Name__c.equalsIgnoreCase( apiName ) || globalPortalSettings.Request_Campaign_Field_Name__c.equalsIgnoreCase( apiLocalName ) )
                            return globalPortalSettings.Request_Campaign_Field_Name__c.toLowerCase();
                    }
                }
                else if ( sObjectName.equalsIgnoreCase( 'Lead' ) && globalPortalSettings.LOI_Campaign_Field_Name__c != null )
                {
                    for( Schema.SObjectField sObjField : Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().values() )
                    {
                        Schema.DescribeFieldResult fieldResult = sObjField.getDescribe();
                        String apiName = fieldResult.getName().toLowerCase();
                        String apiLocalName = fieldResult.getLocalName().toLowerCase();
                        if( globalPortalSettings.LOI_Campaign_Field_Name__c.equalsIgnoreCase( apiName ) || globalPortalSettings.LOI_Campaign_Field_Name__c.equalsIgnoreCase( apiLocalName ) )
                            return globalPortalSettings.LOI_Campaign_Field_Name__c.toLowerCase();
                    }
                }
            }
            return null;
        }
        catch( Exception ex )
        {
            system.debug( 'Exception: ' + ex.getMessage() + '; Line number: ' + ex.getLineNumber() + '; Stacktrace: ' + ex.getStackTraceString());
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage()  ) );
            return null;
        }
    }

    public static List<Database.SaveResult> insertListSObjects( List<sObject> lstSObjects )
    {
        CrudFlsService.getInstance().assertCreateable(lstSObjects);
        return Database.insert( lstSObjects, false );
    }
    public static List<Database.UpsertResult> upsertListSObjects( List<sObject> lstSObjects, String sObjectType )
    {
        String strListType = 'List<' + sObjectType + '>';
        List<SObject> castRecords = (List<SObject>)Type.forName(strListType).newInstance();
        castRecords.addAll(lstSObjects);
        CrudFlsService.getInstance().assertUpdateable(castRecords);
        return Database.upsert( castRecords, false );
    }
    public static List<Database.DeleteResult> deleteListSObjects( List<sObject> lstSObjects )
    {
        CrudFlsService.getInstance().assertDeletable(lstSObjects);
        return Database.delete( lstSObjects, false );
    }

    public static Schema.PicklistEntry getDefaultOCR()
    {
        List<Schema.PicklistEntry> lstOCRPicklist = Schema.getGlobalDescribe().get('OpportunityContactRole').newSObject().getSObjectType().getDescribe().fields.getMap().get('Role').getDescribe().getPickListValues();
        Schema.PicklistEntry strDefaultOCR = lstOCRPicklist[0];
        for (Schema.PicklistEntry role : lstOCRPicklist)
        { //for all values in the picklist list
            if(role.isDefaultValue())
            {
                strDefaultOCR = role;
                break;
            }
        }
        return strDefaultOCR;
    }

    public static Map<string,string> getOTMPicklistEntries()
    {
        Map<string,string> mapOTMPicklistEntries = new Map<string,string>();
        for (Schema.PicklistEntry TMRole : Schema.getGlobalDescribe().get('OpportunityTeamMember').newSObject().getSObjectType().getDescribe().fields.getMap().get('teammemberrole').getDescribe().getPickListValues())
        {
            mapOTMPicklistEntries.put(TMRole.getValue(), TMRole.getLabel());
        }
        return mapOTMPicklistEntries;
    }

    public static Map<string,string> getOCRPicklistEntries()
    {
        Map<string,string> mapOCRPicklistEntries = new Map<string,string>();
        for (Schema.PicklistEntry OCRole : Schema.getGlobalDescribe().get('OpportunityContactRole').newSObject().getSObjectType().getDescribe().fields.getMap().get('Role').getDescribe().getPickListValues())
        {
            mapOCRPicklistEntries.put(OCRole.getValue(), OCRole.getLabel());
        }
        return mapOCRPicklistEntries;
    }
    public class FieldInfoWrapper{
        public string label{get;set;}
        public string name{get;set;}
        public string type{get;set;}
        public boolean isRequired{get;set;}
        public boolean isUpdateable{get;set;}
        Public string relationshipName{get;set;}
        public string parentObject{get;set;}
        public list<string> picklistValues{get;set;}
        public FieldInfoWrapper(string strLabel, string strName, string strType, boolean boolRequired, list<string> lstValues, boolean boolUpdateable, string strRelationshipName, string strParentObject){
            label = strLabel;
            name = strName;
            Type = strType;
            isRequired = boolRequired;
            isUpdateable = boolUpdateable;
            picklistValues = lstValues;
            relationshipName = strRelationshipName;
            parentObject = strParentObject;
        }
    }
}