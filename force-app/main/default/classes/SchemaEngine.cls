public class SchemaEngine {
    /***********************************************************************************************
    Purpose : TO describe or fetch the information(meta data) of specified sObject
    Returns : returns object of class DescribeSObjectResultWrapper

     ***********************************************************************************************/
    @remoteAction
    public static DescribeSObjectResultWrapper describeSobject( string sObjectApiName, boolean fetchObjectAccess, boolean fetchChildrenObjects, boolean fetchRecordTypes, boolean fetchFieldSets, boolean fetchFieldsResult ){
        try{
            return new DescribeSObjectResultWrapper( Schema.getGlobalDescribe().get(sObjectApiName).getDescribe(), fetchObjectAccess, fetchChildrenObjects, fetchRecordTypes, fetchFieldSets, fetchFieldsResult);
        }
        catch( Exception ex ){
            CollectionUtilities.catchException(ex,false);
            return null;
        }
    }

    /***********************************************************************************************
    Purpose : To construct sObject
    Returns : returns sobject

     ***********************************************************************************************/
    public static sObject constructSobject(String sObjectApiName, String jSONSObject){
        try{
            Map<String, Object> mapField = null;
            mapField = (Map<String, Object>)JSON.deserializeUntyped(jSONSObject);
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjectApiName);
            SObject newSobject = targetType.newSObject();
            Map<String, Schema.sObjectField> mapTargetFields = targetType.getDescribe().fields.getMap();
            for (String key : mapField.keySet()){
                Object value = mapField.get(key);
                Schema.DisplayType valueType = mapTargetFields.get(key).getDescribe().getType();
                if (value instanceof String && valueType != null && valueType != Schema.DisplayType.String){
                    String sValue = (String)value;
                    if (valueType == Schema.DisplayType.Date)
                        newSobject.put(key, Date.valueOf(sValue));
                    else if(valueType == Schema.DisplayType.DateTime)
                        newSobject.put(key, DateTime.valueOfGmt(sValue));
                    else if (valueType == Schema.DisplayType.Percent || valueType == Schema.DisplayType.Currency)
                        newSobject.put(key, sValue == '' ? null : Decimal.valueOf(sValue));
                    else if (valueType == Schema.DisplayType.Double)
                        newSobject.put(key, sValue == '' ? null : Double.valueOf(sValue));
                    else if (valueType == Schema.DisplayType.Integer)
                        newSobject.put(key, Integer.valueOf(sValue));
                    else if (valueType == Schema.DisplayType.Base64)
                        newSobject.put(key, Blob.valueOf(sValue));
                    else
                        newSobject.put(key, sValue);
                }
                else
                    newSobject.put(key, value);
            }
            return newSobject;
        }
        catch(Exception ex){
            CollectionUtilities.catchException(ex,false);return null;
        }
    }

    /***********************************************************************************************
    Purpose : To retreive field set of specified sobject
    returns : Map of fielsSet name and list of FieldInfoWrapper object
    ***********************************************************************************************/
    @RemoteAction
    public static map<string , list<FieldInfoWrapper>> getFieldSets(String objectName){
        map<string , list<FieldInfoWrapper>> mapFieldSet = new map<string,list<FieldInfoWrapper>>();
        Map<String, Schema.SObjectType> mapGlobalDescribe = Schema.getGlobalDescribe();
        Schema.SObjectType sObjectTypeObj = mapGlobalDescribe.get(objectName);
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Map<String, Schema.SObjectField> mapFields = describeSObjectResultObj.fields.getMap();
        Map<String,Schema.FieldSet>  mapAllFieldSets = describeSObjectResultObj.FieldSets.getMap();
        final String PICKLIST = 'PICKLIST';
        final String MULTIPICKLIST = 'MULTIPICKLIST';
        final String FGM_PORTAL_NEW = 'FGM_Portal__new';
        final String FGM_PORTAL_EDIT = 'FGM_Portal__edit';
        final String VIEW = 'view';
        try{
            for(string currentSetName : mapAllFieldSets.keySet()){
                if(currentSetName.startsWithIgnoreCase(FGM_PORTAL_NEW) || currentSetName.startsWithIgnoreCase(VIEW) || currentSetName.startsWithIgnoreCase(FGM_PORTAL_EDIT)){
                    for(Schema.FieldSetMember currentField : mapAllFieldSets.get(currentSetName).getFields()){
                        List<String> lstPickListValues = new List<String>();
                        if(string.valueOf(currentField.getType()).equalsIgnoreCase(PICKLIST) || string.valueOf(currentField.getType()).equalsIgnoreCase(MULTIPICKLIST)){
                            List<Schema.PicklistEntry> pickListValues = mapFields.get(currentField.getFieldPath()).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
                            for(Schema.PicklistEntry currentPicklist : pickListValues){
                                lstPickListValues.add(currentPicklist.getValue());
                            }
                        }
                        boolean isUpdateable = mapFields.get(currentField.getFieldPath()).getDescribe().isUpdateable();
                        string referenceName = mapFields.get(currentField.getFieldPath()).getDescribe().getRelationshipName();
                        string parentName = '';
                        List<Schema.sObjectType> lstParentTypes = mapFields.get(currentField.getFieldPath()).getDescribe().getReferenceTo();
                        if(lstParentTypes != null && lstParentTypes.size()>0)
                            parentName = lstParentTypes[0].getDescribe().getName();
                        if(mapFieldSet.get(currentSetName) != null)
                            mapFieldSet.get(currentSetName).add(new FieldInfoWrapper(currentField.getLabel(),currentField.getFieldPath(),string.valueOf(currentField.getType()),currentField.getDBRequired() ? true:currentField.getRequired(),lstPickListValues, isUpdateable, referenceName, parentName));
                        else{
                            mapFieldSet.put(currentSetName, new list<FieldInfoWrapper>());
                            mapFieldSet.get(currentSetName).add(new FieldInfoWrapper(currentField.getLabel(),currentField.getFieldPath(),string.valueOf(currentField.getType()),currentField.getDBRequired() ? true:currentField.getRequired(),lstPickListValues, isUpdateable, referenceName, parentName));
                        }
                    }
                }
            }
            return mapFieldSet;
        }
        catch(Exception ex){
            CollectionUtilities.catchException(ex,false);return null;
        }
    }

    /***********************************************************************************************
    Purpose : This method retirns list of chield object of specified object
    Returns : List of sObjects

     ***********************************************************************************************/
    @RemoteAction
    public static sObject[] getChildObjectData(String objectName){
        objectName = objectName.replaceAll('[^0-9a-zA-Z_.]', '');
        Map<String, Schema.SObjectField> mapFields = Schema.getGlobalDescribe().get(objectName).getDescribe().SObjectType.getDescribe().fields.getMap();
        List<String> lstAccessibleFields = new List<String>();
        try{
            for(Schema.SObjectField field : mapFields.values()){
                if(field.getDescribe().isAccessible()){
                    lstAccessibleFields.add(field.getDescribe().getName());
                    if(string.valueOf(field.getDescribe().getType()) == 'REFERENCE' && field.getDescribe().isCustom()){
                        lstAccessibleFields.add(field.getDescribe().getName().replace('__c','__r')+'.Name');
                    }
                }
            }
            String allFields='';
            List<String> lstField = new List<String>();
            for(String fieldName : lstAccessibleFields){
                allFields += fieldName+',';
                lstField.add(fieldName);
            }
            allFields = allFields.subString(0,allFields.length()-1);
            string strQuery = 'SELECT '+allFields+' FROM '+objectName +' WITH SECURITY_ENFORCED LIMIT 5 ';
            return Database.query(strQuery);
        }
        catch(Exception ex){
            CollectionUtilities.catchException(ex,false);return null;
        }
    }
    /************************************************************************************************
    Purpose : To get Quiz specific SObjectField.
    Ruturns : List of sObject field
    **************************************************************************************************/
    public static list<Schema.SObjectField> getQuestionFields(string strQuizID, string strObjectName, string strLanguage){
        set<String> setQuestionFields = new set<String>();
        list<Schema.SObjectField> lstQuestionFields = new list<Schema.SObjectField>();

        try{
            List<Quiz_Questions__c> lstQuizQuestion = new List<Quiz_Questions__c> ();

                lstQuizQuestion = [
                    SELECT
                        Name,
                        Quiz__c,
                        Field__c,
                        Language__c
                    FROM Quiz_Questions__c
                    WHERE (
                        Language__c = null
                        OR Language__c = :strLanguage
                    )
                    AND Quiz__c = :strQuizID
                    AND Field__c != null
                    AND Tab__r.RecordType.Name = 'Portal Tab'
                    WITH SECURITY_ENFORCED
                ];

            for(Quiz_Questions__c  quizQuestion :  lstQuizQuestion){
                setQuestionFields.add(quizQuestion.Field__c);
            }
            for( Schema.SObjectField field : Schema.getGlobalDescribe().get(strObjectName).getDescribe().fields.getMap().values() ){
                if(setQuestionFields.contains(field.getDescribe().getname()))
                    lstQuestionFields.add( field );
            }
            return lstQuestionFields;
        }
        catch(Exception ex){
            CollectionUtilities.catchException(ex,true);return null;
        }
    }
  /************************************************************************************************************
    Purpose: This function is to get the fields from fieldset.
    Parameters: [objectName, fieldSetName]
    Throws [Exceptions]: [optional]
    Return : map of field apiName to fieldLabel
    */
    public static Map<String,String> getFieldsFromFieldSet(String objectName, String fieldSetName)
    {
        Map<String,String> fields;
        try
        {
            fields = new Map<String,String>();
            if( objectName != null && fieldSetName != null )
            {
                Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
                Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(objectName);
                if( sObjectTypeObj != null )
                {
                    Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
                    if( describeSObjectResultObj != null )
                    {
                        Map<String,Schema.FieldSet> mapfieldSetObj = describeSObjectResultObj.FieldSets.getMap();
                        Schema.FieldSet fieldSetObj = null;
                        for(Schema.FieldSet fieldset : mapfieldSetObj.values())
                        {
                            if(fieldSetName.equalsIgnoreCase(fieldset.getLabel()))
                            {
                                fieldSetObj = fieldset;
                                break;
                            }
                        }
                        if( fieldSetObj == null )
                            return fields;
                        else
                        {
                            List<Schema.FieldSetMember> fieldSetMemberList =  fieldSetObj.getFields();
                            if( fieldSetMemberList != null )
                            {
                                for( Schema.FieldSetMember fieldSetMemeber : fieldSetMemberList )
                                {
                                    fields.put(fieldSetMemeber.getLabel(), fieldSetMemeber.getFieldPath());
                                }
                            }
                        }
                    }
                }
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.FC_CommunityPage_Please_contact_the_administrator_ErrorMsg));
                }
            }
        }
        catch(Exception ex)
        {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ' ' + ex.getMessage()));
        }
        return fields;
    }
    /************************************************************************************************************
    Purpose: This function is to get the list of fields from fieldset.
    Parameters: [objectName, fieldSetName]
    Throws [Exceptions]: [optional]
    Return : List<Schema.FieldSetMember>
    */
    public static List<Schema.FieldSetMember> getlstFieldsFromFieldSet(String objectName, String fieldSetName)
    {
        try
        {
            List<Schema.FieldSetMember> lstFields = new List<Schema.FieldSetMember>();
            for(Schema.FieldSet fieldset : Schema.getGlobalDescribe().get(objectName).getDescribe().FieldSets.getMap().values())
            {
                if(fieldSetName.equalsIgnoreCase(fieldset.getLabel()))
                {
                    lstFields = fieldset.getFields();
                    break;
                }
            }
            return lstFields;

        }
        catch(Exception ex)
        {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ' ' + ex.getMessage() ));
        }
        return null;
    }
    /************************************************************************************************
    Purpose : To get relative field to campaign from specified sobject.
    Ruturns : Api name of lookup field
    **************************************************************************************************/
    public static string getCampaignLookupField( String sObjectName ){
        try{
            GlobalPortalSettings__c globalPortalSettings = GlobalPortalSettings__c.getInstance();
            if( globalPortalSettings != null ){
                if( sObjectName.equalsIgnoreCase( 'Opportunity' ) && globalPortalSettings.Request_Campaign_Field_Name__c != null ){
                    for( Schema.SObjectField sObjField : Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap().values() ){
                        Schema.DescribeFieldResult fieldResult = sObjField.getDescribe();
                        String apiName = fieldResult.getName().toLowerCase();
                        String apiLocalName = fieldResult.getLocalName().toLowerCase();
                        if( globalPortalSettings.Request_Campaign_Field_Name__c.equalsIgnoreCase( apiName ) || globalPortalSettings.Request_Campaign_Field_Name__c.equalsIgnoreCase( apiLocalName ) )
                            return globalPortalSettings.Request_Campaign_Field_Name__c.toLowerCase();
                    }
                }
                else if ( sObjectName.equalsIgnoreCase( 'Lead' ) && globalPortalSettings.LOI_Campaign_Field_Name__c != null ){
                    for( Schema.SObjectField sObjField : Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().values() ){
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
        catch( Exception ex ){
            CollectionUtilities.catchException(ex,false);return null;
        }
    }

    /************************************************************************************************
    Purpose : To get default opportunity contact role (OCR).
    Ruturns : Single value of opportunity contact role (OCR)
    **************************************************************************************************/
    public static Schema.PicklistEntry getDefaultOpportunityContactRole(){
        List<Schema.PicklistEntry> lstOpportunityContactRolePicklist = Schema.getGlobalDescribe().get('OpportunityContactRole').newSObject().getSObjectType().getDescribe().fields.getMap().get('Role').getDescribe().getPickListValues();
        Schema.PicklistEntry strDefaultOpportunityContactRole = lstOpportunityContactRolePicklist[0];
        for (Schema.PicklistEntry role : lstOpportunityContactRolePicklist){
            if(role.isDefaultValue()){
                strDefaultOpportunityContactRole = role;
                break;
            }
        }
        return strDefaultOpportunityContactRole;
    }

    /************************************************************************************************
    Purpose : To get team role entries.
    Ruturns : map of teamRole <Api name , Label>
    **************************************************************************************************/
    public static Map<string,string> getOpportunityTeamMemberPicklistEntries(){
        Map<string,string> mapOpportunityTeamMemberPicklist = new Map<string,string>();
        for (Schema.PicklistEntry teamRole : Schema.getGlobalDescribe().get('OpportunityTeamMember').newSObject().getSObjectType().getDescribe().fields.getMap().get('teammemberrole').getDescribe().getPickListValues()){
            mapOpportunityTeamMemberPicklist.put(teamRole.getValue(), teamRole.getLabel());
        }
        return mapOpportunityTeamMemberPicklist;
    }

    /************************************************************************************************
    Purpose : To get opportunity contact role entries.
    Ruturns : map of opportunity contact role <Api name , Label>
    **************************************************************************************************/
    public static Map<string,string> getOpportunityContactRolePicklistEntries(){
        Map<string,string> mapOpportunityContactRolePicklist = new Map<string,string>();
        for (Schema.PicklistEntry contactRole : Schema.getGlobalDescribe().get('OpportunityContactRole').newSObject().getSObjectType().getDescribe().fields.getMap().get('Role').getDescribe().getPickListValues()){
            mapOpportunityContactRolePicklist.put(contactRole.getValue(), contactRole.getLabel());
        }
        return mapOpportunityContactRolePicklist;
    }


    /**********************************************************************
    ======================================================
    Purpose: While returning describe sobject , we want all meta-data of object, for creating that object this class is created

    ======================================================
    ***********************************************************************/

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

    /**********************************************************************
    ======================================================
    Purpose: To wrap field related information in single object
    ======================================================
    ***********************************************************************/
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

    /**********************************************************************
    ======================================================
    Purpose: To wrap fieldset related detail information in single object
    ======================================================
    ***********************************************************************/
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
            for( Schema.FieldSetMember fieldSetMember : fieldSet.getFields() ){
                Schema.SObjectField fieldResult;
                if(String.valueOf(fieldSetMember.getFieldPath()).contains('.')){
                    String relatedObject = null;
                    List<Schema.SObjectType> lstObjectName = null;

                    String preString = String.valueOf(fieldSetMember.getFieldPath()).substringBefore('.').endsWith('__r') ? String.valueOf(fieldSetMember.getFieldPath()).substringBefore('.').replace('__r','__c') : String.valueOf(fieldSetMember.getFieldPath()).substringBefore('.');
                    String fieldValue = String.valueOf(fieldSetMember.getFieldPath()).substringAfter('.');

                    if(String.isNotEmpty( preString ) && (preString.endsWith('By')  || preString == 'DandbCompany' || preString == 'RecordType')){
                        preString = preString+'Id';
                    } else if(String.isNotEmpty( preString ) && !preString.endsWith('__c')){
                        if( preString.containsIgnoreCase('Converted')) {
                            relatedObject = preString.removeStartIgnoreCase('Converted');
                        } else if( preString.containsIgnoreCase('Partner')) {
                            relatedObject = preString.removeStartIgnoreCase('Partner');
                        } else if (preString.containsIgnoreCase('MasterRecord')) {
                            relatedObject = String.valueOf(fieldSet.getSObjectType());
                        } else {
                            relatedObject = preString;
                        }
                    }

                    if(String.isNotBlank( preString ) && relatedObject == null) {
                        lstObjectName = Schema.getGlobalDescribe().get(String.valueOf(fieldSet.getSObjectType())).getDescribe().fields.getMap().get( preString ).getDescribe().getReferenceTo();
                    }

                    if(lstObjectName != null && relatedObject == null) {
                        relatedObject = String.valueOf(lstObjectName[0]);
                    }

                    SObjectType relatedSObjType = Schema.getGlobalDescribe().get(relatedObject);

                    if (relatedSObjType == null) {
                        continue;
                    }

                    fieldResult = relatedSObjType.getDescribe().fields.getMap().get( fieldValue );

                } else {
                    fieldResult = fieldSet.getSobjectType().getDescribe().fields.getMap().get( fieldSetMember.getFieldPath() );
                }

                if(fieldResult != null) {
                    this.fieldSetMembers.add( new FieldSetMemberWrapper( fieldSetMember, fieldResult ) );
                }
            }

            this.description = fieldSet.getDescription();
            this.label = fieldSet.getLabel();
            this.apiName = fieldSet.getName();
            this.nameSpace = fieldSet.getNamespace();
            this.sObjectType = String.valueOf( fieldSet.getSObjectType() );
        }
    }

    /**********************************************************************
    ======================================================
    Purpose: To wrap objectspecific access level
    ======================================================
    ***********************************************************************/

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

    /**********************************************************************
    ======================================================
    Purpose: To wrap field specific information in single object
    ======================================================
    ***********************************************************************/
    public class FieldInfoWrapper{
        public string label{get;set;}
        public string name{get;set;}
        public string type{get;set;}
        public boolean isRequired{get;set;}
        public boolean isUpdateable{get;set;}
        public string relationshipName{get;set;}
        public string parentObject{get;set;}
        public list<string> lstPicklistValues{get;set;}
        public FieldInfoWrapper(string strLabel, string strName, string strType, boolean boolRequired, list<string> lstValues, boolean boolUpdateable, string strRelationshipName, string strParentObject){
            label = strLabel;
            name = strName;
            type = strType;
            isRequired = boolRequired;
            isUpdateable = boolUpdateable;
            lstPicklistValues = lstValues;
            relationshipName = strRelationshipName;
            parentObject = strParentObject;
        }
    }

    /**********************************************************************
    ======================================================
    Purpose: To wrap fieldsetmember specific information in single object
    ======================================================
    ***********************************************************************/
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

    /**********************************************************************
    ======================================================
    Purpose: To wrap picklist-values specific information in single object
    ======================================================
    ***********************************************************************/
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

    /**********************************************************************
    ======================================================
    Purpose: To wrap picklist-values specific information in single object
    ======================================================
    ***********************************************************************/
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
}