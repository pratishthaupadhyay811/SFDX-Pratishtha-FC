// To perform the common task related to Fc Community.
public with sharing class FCGlobal
{
    public FCGlobal() {
    }
    public  with sharing  class Field
    {
        public String ObjectName {get;set;}
        public String Name {get;set;}
        public String Value {get;set;}
        public String Label {get;set;}
        public Schema.Displaytype FieldType {get;set;}
    }

    public  with sharing  class Error
    {
        public object Data{get;set;}
        public Boolean IsSuccess{get;set;}
        public String Message{get;set;}

        public Error(){}

        public Error(object Data)
        {
            this.Data = Data;
        }

        public Error(Boolean IsSuccess,object Data)
        {
            this.IsSuccess = IsSuccess;
            this.Data = Data;
        }

        public Error(Boolean IsSuccess,String Message,object Data)
        {
            this.Data = Data;
            this.IsSuccess = IsSuccess;
            this.Message = Message;
        }

        public Error(Boolean IsSuccess,String Message)
        {
            this.IsSuccess = IsSuccess;
            this.Message = Message;
        }
    }

    public class NumberFormatting {
        String numberSeperator {get; set;}
        public NumberFormatting(){}
    }
    public class DateFormatting {
        String dateFormat{get; set;}
        public DateFormatting (){}
    }
    public class CurrencyFormatting{
        public String currencyName {get; set;}
        public String currencyISOCode {get; set;}
        public String currencySymbol {get; set;}
        public CurrencyFormatting () {}
    }
    public class LocalFormatting{
        public String languageCode {get; set;}
        public DateFormatting dateFormatting {get; set;}
        public CurrencyFormatting currencyFormatting {get; set;}
        public NumberFormatting numberFormatting {get; set;}
        public LocalFormatting (){}
    }
    public LocalFormatting getLocalFormatting (String portalLanguage){
        LocalFormatting objLocalFormatting = new LocalFormatting();
        DateFormatting objDateFormatting = new DateFormatting();
        CurrencyFormatting objCurrencyFormatting = new CurrencyFormatting();
        NumberFormatting objNumberFormatting = new NumberFormatting();
        objDateFormatting.dateFormat = getDateFormat().get(portalLanguage);
        return objLocalFormatting;
    }
    //start application designer methods
    @remoteAction
    public static Id insertQuiz(String strQuizeName) {
        FGM_Portal__Quiz__c quiz = new FGM_Portal__Quiz__c();
        quiz.Name = strQuizeName;
        quiz.RecordTypeId = getRecordTypeId('FGM_Portal__Quiz__c', 'Application');
        quiz.FGM_Portal__IsCommunityRecord__c = true;
        CrudFlsService.getInstance().assertCreateable(quiz);
        insert quiz;
        return quiz.Id;

    }
    @remoteAction /*To clone quiz with all tabs and add new translation*/
    public static String addTranslation(String portalLanguage , String quizID , String QuizName , Boolean isCloneRecord) {
        Set < ID > setRLCTabID = new Set < ID > ();
        List < FGM_Portal__Related_List_Controller__c > tabListEng = getTabRecords('en_US', quizID);
        list<FGM_Portal__Quiz_Questions__c> quizQuestionListEng;
        FGM_Portal__Quiz__c clonedQuiz = null;
        if(isCloneRecord)
        {
            Savepoint quizSavePoint = Database.setSavepoint();
            quizID = String.escapeSingleQuotes(quizID);
            if(!String.isNotBlank(quizID) && !String.isNotBlank(QuizName))
                return null;
            try
            {

                List<Quiz__c> lstExisingQuiz = [
                    SELECT
                        Failure_URL__c,
                        Introduction_Text__c,
                        Is_Active__c,
                        Success_URL__c,
                        (
                            SELECT
                                Field__c,
                                Question__c,
                                Required__c,
                                Sort_Order__c,
                                Tab__c
                            FROM Quiz_Questions__r
                        )
                    FROM Quiz__c
                    WHERE Id = :quizId
                    AND IsCommunityRecord__c = TRUE
                    WITH SECURITY_ENFORCED
                    LIMIT 1
                ];

                if(lstExisingQuiz != null && !lstExisingQuiz.isEmpty())
                {
                    clonedQuiz = lstExisingQuiz[0].clone(false,true,false,false);
                    clonedQuiz.Name = QuizName;
                    clonedQuiz.FGM_Portal__IsCommunityRecord__c = true;
                    CrudFlsService.getInstance().assertCreateable(clonedQuiz);
                    insert clonedQuiz;
                }
            }
            catch(Exception ex)
            {
                Database.rollback(quizSavePoint);
                return null;
            }
        }
        if (portalLanguage != 'en_US' && tabListEng != null && tabListEng.size() > 0) {
            if(portalLanguage == 'English' && isCloneRecord) portalLanguage = 'en_US';

            List<Related_List_Controller__c> tabListNonEng = [
                SELECT Parent_RLCTabID__c
                FROM Related_List_Controller__c
                WHERE Quiz__c = :quizID
                AND IsCommunityRecord__c = TRUE
                AND Language__c = :portalLanguage
                WITH SECURITY_ENFORCED
                LIMIT 1000
            ];

            Boolean isCloned;
            map < Id, FGM_Portal__Related_List_Controller__c > mapEmptyTabID = new map < Id, FGM_Portal__Related_List_Controller__c > ();
            List < FGM_Portal__Related_List_Controller__c > lstEmptyTabID = new List < FGM_Portal__Related_List_Controller__c > ();
            for (FGM_Portal__Related_List_Controller__c recordEng: tabListEng) {
                isCloned = false;
                for (FGM_Portal__Related_List_Controller__c recordNonEng: tabListNonEng) {
                    if (recordEng.Id == recordNonEng.FGM_Portal__Parent_RLCTabID__c) isCloned = true;
                }
                if (!isCloned) {
                    setRLCTabID.add(recordEng.Id);
                    mapEmptyTabID.put(recordEng.Id, recordEng);
                }
            }
            if (setRLCTabID != null && setRLCTabID.size() > 0) {

                quizQuestionListEng = [
                    SELECT
                        Field__c,
                        Hide_Post_Text__c,
                        Hide_Pre_Text__c,
                        Name,
                        Parent_QuizQuestionID__c,
                        Question__c,
                        Quiz__c,
                        Required__c,
                        Sort_Order__c,
                        Tab__c
                    FROM Quiz_Questions__c
                    WHERE Tab__c IN :setRLCTabID
                    WITH SECURITY_ENFORCED
                    LIMIT 1000
                ];

                if (quizQuestionListEng != null && quizQuestionListEng.size() > 0) {
                    if(isCloneRecord)
                        CloneQuizQuestion(quizQuestionListEng, clonedQuiz.Id, portalLanguage, true);
                    else
                        CloneQuizQuestion(quizQuestionListEng, quizID, portalLanguage, true);
                    for (FGM_Portal__Quiz_Questions__c quizQuestion: quizQuestionListEng)
                        mapEmptyTabID.remove(quizQuestion.FGM_Portal__Tab__c);
                }
                lstEmptyTabID = mapEmptyTabID.values();
                if (lstEmptyTabID != null && lstEmptyTabID.size() > 0)
                {
                    if(isCloneRecord)
                    {
                        CloneTabRecord(lstEmptyTabID, clonedQuiz.Id, portalLanguage);
                        return clonedQuiz.Id;
                    }
                    else
                        CloneTabRecord(lstEmptyTabID, quizID, portalLanguage);
                }
            }
        }
        return portalLanguage;
     }
    //To Clone Grantee Budget Configuration Category
    public static List<FGM_Portal__Grantee_Budget_Configuration__c> CloneGranteeBudgetConfiguration(List<FGM_Portal__Grantee_Budget_Configuration__c> lstGranteeBudgetConfiguration,Id QuizId,Id rlcTabId,String languageCode)
    {
        List<FGM_Portal__Grantee_Budget_Configuration__c> lstClonedGranteeBudgetConfiguration = new List<FGM_Portal__Grantee_Budget_Configuration__c>();
        if(QuizId == null)
            return lstClonedGranteeBudgetConfiguration;
        for(FGM_Portal__Grantee_Budget_Configuration__c granteeBudgetConfigurationRecord : lstGranteeBudgetConfiguration)
        {
            FGM_Portal__Grantee_Budget_Configuration__c granteeBudgetConfiguration = granteeBudgetConfigurationRecord.clone(false,true,false,false);
                granteeBudgetConfiguration.FGM_Portal__Related_List_Controller__c = String.escapeSingleQuotes(rlcTabId);
                granteeBudgetConfiguration.FGM_Portal__Quiz__c = String.escapeSingleQuotes(QuizId);
                lstClonedGranteeBudgetConfiguration.add(granteeBudgetConfiguration);
        }
        if(lstClonedGranteeBudgetConfiguration != null && !lstClonedGranteeBudgetConfiguration.isEmpty()) {
            CrudFlsService.getInstance().assertCreateable(lstClonedGranteeBudgetConfiguration);
            Database.insert(lstClonedGranteeBudgetConfiguration);
        }
        return lstClonedGranteeBudgetConfiguration;
    }




    //end application desinger methods
    public static String getValidationErrorMessage(Exception ex)
    {
        if(ex == null)
            return '';

        String errorMessage = ex.getMessage();
        Integer occurence;

        if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
        {
            occurence = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
            errorMessage = errorMessage.mid(occurence, errorMessage.length());
            occurence = errorMessage.lastIndexOf(':');
            errorMessage = errorMessage.mid(0, occurence);
            occurence = errorMessage.indexOf(':');
            errorMessage = errorMessage.mid(0, occurence);
        }
        return  errorMessage;
    }

    @future
    public static void assignPermissionSetToUser(String UserId)
    {

        List<PermissionSet> lstPermissionSet = [
            SELECT Id
            FROM PermissionSet
            WHERE Name = 'Community_Grantee_Permission_set_User_Login_Licence'
            LIMIT 1
        ];

        if(lstPermissionSet != null && lstPermissionSet.size() > 0 && String.isNotBlank(UserId) )
        {
            PermissionSetAssignment  permissionSetAssign = new PermissionSetAssignment(AssigneeId = userId,PermissionSetId = lstPermissionSet[0].Id );
            Database.Saveresult saveResult = Database.insert(permissionSetAssign);
        }
    }

    // To get the GuideStar Mapping based on RecordType.
    public static Map<String,Map<String,String>> getGuideStarMappingMap(List<String> RecordTypeNameList)
    {
        Map<String,Map<String,String>> mapGuideStarFields = new Map<String,Map<String,String>>();
        List<FGM_Portal__GuidestarFieldMapping__c> guideStarMappingList = new List<FGM_Portal__GuidestarFieldMapping__c>();
        List<String> lstObjectFields = new List<String>();
        Map<String,String> mapRecordType = new Map<String,String>();

        if(!RecordTypeNameList.isEmpty())
        {
            //getting all Recordtype for the GuideStar mapping Object.
            Map<String,Schema.RecordTypeInfo> recordTypeInfo = new WithoutSharing().getRecordTypesByNameWithoutSharing('FGM_Portal__GuidestarFieldMapping__c');//Schema.Sobjecttype.FGM_Portal__GuidestarFieldMapping__c.getRecordTypeInfosByName();

            if(recordTypeInfo.isEmpty())
                return mapGuideStarFields;

            for(String recodTypeName : RecordTypeNameList)
            {
                Schema.RecordTypeInfo requiredRecordtType = recordTypeInfo.get(recodTypeName);
                String recordTypeId = '';
                if(requiredRecordtType != null)
                {
                    recordTypeId = requiredRecordtType.getRecordTypeId();  // Get record Type Id
                    if(String.isNotBlank(recordTypeId) && !mapRecordType.containsKey(recordTypeId))
                        mapRecordType.put(recordTypeId,recodTypeName);
                }
            }
            if(!mapRecordType.isEmpty())
            {
                Map<String,Schema.SObjectField> fieldMapping = Schema.SobjectType.FGM_Portal__GuidestarFieldMapping__c.Fields.getMap();
                for(Schema.SObjectField field : fieldMapping.values())
                {
                    Schema.DescribeFieldResult fieldResult = field.getDescribe();

                    if(fieldResult.isAccessible())
                        lstObjectFields.add(fieldResult.getName());
                }
            }

            // Query to get GuideStar Mapping Record
            if(!lstObjectFields.isEmpty())
            {
                List<String> lstReocordtypeId = new List<String>( mapRecordType.keySet());

                List<String> sanitizedObjectFields = new List<String>();

                for (String f : lstObjectFields) {
                    sanitizedObjectFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                }

                String query = ''
                    + 'SELECT '+ String.join(new List<String>(sanitizedObjectFields),', ')
                    + ' FROM FGM_Portal__GuidestarFieldMapping__c'
                    +' Where RecordTypeId IN :lstReocordtypeId AND FGM_Portal__IsCommunityRecord__c=true'
                    +' WITH SECURITY_ENFORCED';

                guideStarMappingList = (List<FGM_Portal__GuidestarFieldMapping__c>) Database.Query(query);
            }
        }
        // Create Map for GuideStar mapping
        if(!guideStarMappingList.isEmpty())
        {
            for(FGM_Portal__GuidestarFieldMapping__c guideStarMapping : guideStarMappingList)
            {
                Map<String,String> mapFieldMapping = new Map<String,String>();

                for(String fieldName : lstObjectFields)
                {
                    if(fieldName.endsWith('__c') && guideStarMapping.get(fieldName) != null)
                    {
                        string strFieldKey = fieldName;
                        if(strFieldKey.startsWith('FGM_Portal__'))
                            strFieldKey = strFieldKey.SubString(12,strFieldKey.length());
                        if(strFieldKey.endsWith('__c'))
                            strFieldKey = strFieldKey.SubString(0,(strFieldKey.length()) - 3);
                        if(String.isNotBlank(strFieldKey))
                            mapFieldMapping.put(strFieldKey,String.valueOf(guideStarMapping.get(fieldName)));
                    }
                }

                if(!mapFieldMapping.isEmpty() && mapRecordType.containsKey(guideStarMapping.RecordTypeId) && !mapGuideStarFields.containsKey(mapRecordType.get(guideStarMapping.RecordTypeId)))
                    mapGuideStarFields.put(mapRecordType.get(guideStarMapping.RecordTypeId),mapFieldMapping);
            }
        }
        return mapGuideStarFields;
    }

    // To get the records from Trigger custom settings
    public static FGM_Portal__Triggers__c getPortalTriggerRecords()
    {
        List<FGM_Portal__Triggers__c> lstPortalTriggerRecord = FGM_Portal__Triggers__c.getall().values();
        if(lstPortalTriggerRecord != null && lstPortalTriggerRecord.size() > 0)
            return lstPortalTriggerRecord[0];
        else
            return null;
    }

    // To get new object of Given type.
    public static SObject getNewSobject(String objectType)
    {
        return getNewSObject(objectType, false);
    }

    public static SObject getNewSObject(String objectType, Boolean withDefaults)
    {
        if(String.isNotBlank(objectType))
        {
            // Call global describe to get the map of string to token.
            Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
            if(!globalDescribe.containsKey(objectType))
                return null;

            // Get the token for the sobject based on the type.
            Schema.SObjectType ObjectTypeInstance = globalDescribe.get(objectType);

            // Instantiate the sobject from the token.
            Sobject newObject = ObjectTypeInstance.newSObject(null, withDefaults);

            return newObject;
        }
        return null;
    }

    // To get visualforce page Name.
    public static string getVFPageName(String Url)
    {
        // THIS IS THE CLOSEST YOU CAN GET SO FAR
        String pageName = Url;
        // IT ALWAYS STARTS WITH /APEX/ SO REMOVE IT
        pageName = pageName.replaceFirst('/apex/','');
        pageName = EncodingUtil.urlEncode(pageName, 'UTF-8');
        // %3F IS THE VALUE OF THE QUESTION MARK IN UTF-8
        string[] pageNameExtra = pageName.split('%3F',0);
        // SO YOU MAY SPLIT THE STRING AT THAT POINT
        // FOR THIS PURPOSE YOU ONLY NEED THE FIRST
        // IN THE RESULTING ARRAY
        pageName = pageNameExtra[0];
        // HERE IS YOUR PRODUCT
        return pageName;
    }

    // To get Object API Name by ID
    public static String getObjectNameById(String RecordId)
    {
        String sObjectName = '';
        if(String.isNotBlank(RecordId))
        {
            ID IDRecord = ID.valueOf(RecordId);
            if(IDRecord != null)
            {
                Schema.SObjectType token = IDRecord.getSObjectType();
                Schema.DescribeSObjectResult objectDescribe = token.getDescribe();
                return objectDescribe.getName();
            }
        }
        return sObjectName;
    }

    // To get Object Label Name by ID
    public static String getObjectLabelById(String RecordId)
    {
        String sObjectLabel = '';
        if(String.isNotBlank(RecordId))
        {
            ID IDRecord = ID.valueOf(RecordId);
            if(IDRecord != null)
            {
                Schema.SObjectType token = IDRecord.getSObjectType();
                Schema.DescribeSObjectResult objectDescribe = token.getDescribe();
                return objectDescribe.getLabel();
            }
        }
        return sObjectLabel;
    }

    // To get has child object
    public static Boolean hasChildObject(String ParentObjectName)
    {
        if(String.isNotBlank(ParentObjectName))
        {
            Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe();
            Schema.SObjectType sObjectType = sObjectMap.get(ParentObjectName); // getting Sobject Type
            if(sObjectType != null)
            {
                Schema.DescribeSObjectResult resSchema = sObjectType.getDescribe();
                if(resSchema != null)
                {
                    List<Schema.ChildRelationship> lstChildObjects = resSchema.getChildRelationships();
                    for (Schema.ChildRelationship childrelationship: lstChildObjects)
                    {
                        Schema.DescribeSObjectResult childResSchema = childrelationship.getChildSObject().getDescribe();
                        if((childResSchema.getName().equalsIgnoreCase('Opportunity') || childResSchema.getName().equalsIgnoreCase('Lead') || childResSchema.getName().equalsIgnoreCase('OpportunityTeamMember') || childResSchema.getName().endsWith('__c')) && !childResSchema.getName().endsWith('Question_Attachment__c'))
                            return true;
                    }
                }
            }
        }
        return false;
    }

    /**
     * @description Return the API name of the first relationship field found
     * on the parent object to the given child object
     */
    public static String getRelationalField(Schema.SObjectType parent, Schema.SObjectType child) {
        List<Schema.ChildRelationship> childRelationships = parent.getDescribe().getChildRelationships();

        for (Schema.ChildRelationship cr : childRelationships) {
            if (cr.getChildSObject() == child) {
                return String.valueOf(cr.getField());
            }
        }

        return '';
    }

    /**
     * @description Return the API name of the first relationship field found
     * on the parent object (by API name) to the given child object
     */
    public static String getRelationalField(String parentName, Schema.SObjectType child) {
        return getRelationalField(Schema.getGlobalDescribe().get(parentName), child);
    }

    /**
     * @description Return the API name of the first relationship field found
     * on the parent object to the given child object (by API name)
     */
    public static String getRelationalField(Schema.SObjectType parent, String childName) {
        return getRelationalField(parent, Schema.getGlobalDescribe().get(childName));
    }

    // To get Relational field
    public static String getRelationalField(String ParentObjectName,String ChildObjectName)
    {
        try
        {
            String relationalField = '';
            if(String.isNotBlank(ParentObjectName) && String.isNotBlank(ChildObjectName))
            {
                Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe();
                Schema.SObjectType sObjectType = sObjectMap.get(ParentObjectName); // getting Sobject Type

                if(sObjectType == null)
                    return relationalField;

                Schema.DescribeSObjectResult resSchema = sObjectType.getDescribe();

                if(resSchema != null)
                {
                    List<Schema.ChildRelationship> childObjects = resSchema.getChildRelationships();
                    for (Schema.ChildRelationship childrelationship: childObjects)
                    {
                        if(ChildObjectName.equalsIgnoreCase(String.valueOf(childrelationship.getChildSObject())))
                            return String.valueOf(childrelationship.getField());
                    }
                }
            }
            return relationalField;
        }
        catch( Exception ex )
        {
            system.debug( 'Exception: ' + ex );
        }
        return null;
    }

    // To get An Object Fields.
    public static Map<String,String> getsObjectFields(String sObjectName, Set<String> excludeFieldTypes)
    {
        Map<String,String> mapsObjectFields = new Map<String,String>();
        if(String.isNotEmpty(sObjectName))
        {
            Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe();
            if(!sObjectMap.containsKey(sObjectName))
                return mapsObjectFields;

            Schema.SObjectType sObjectType = sObjectMap.get(sObjectName); // getting Sobject Type

            Schema.DescribeSObjectResult resSchema = sObjectType.getDescribe();
            Map <String, Schema.SObjectField> sObjectFields = resSchema.fields.getMap();

            if(sObjectFields != null && !sObjectFields.isEmpty())
            {
                for(Schema.SObjectField sfield : sObjectFields.Values())
                {
                    schema.describefieldresult dfield = sfield.getDescribe();
                    if(excludeFieldTypes != null)
                    {
                        if(excludeFieldTypes.contains('FORMULA') && dfield.isCalculated())
                            continue;
                        if(excludeFieldTypes.contains('REFERENCE') && 'REFERENCE'.equalsIgnoreCase(String.valueOf(dfield.getType())))
                            continue;
                        if(excludeFieldTypes.contains('CURRENCY') && 'CURRENCY'.equalsIgnoreCase(String.valueOf(dfield.getType())))
                            continue;
                        if(excludeFieldTypes.contains('DataCategoryGroupReference') && 'DataCategoryGroupReference'.equalsIgnoreCase(String.valueOf(dfield.getType())))
                            continue;
                        if(excludeFieldTypes.contains('Date') && 'Date'.equalsIgnoreCase(String.valueOf(dfield.getType())))
                            continue;
                        if(excludeFieldTypes.contains('DateTime') && 'DateTime'.equalsIgnoreCase(String.valueOf(dfield.getType())))
                            continue;
                        if(excludeFieldTypes.contains('Percent') && 'Percent'.equalsIgnoreCase(String.valueOf(dfield.getType())))
                            continue;
                        if(excludeFieldTypes.contains('Phone') && 'Phone'.equalsIgnoreCase(String.valueOf(dfield.getType())))
                            continue;
                        if(excludeFieldTypes.contains('BOOLEAN') && 'BOOLEAN'.equalsIgnoreCase(String.valueOf(dfield.getType())))
                            continue;
                    }
                    mapsObjectFields.put(dfield.getLabel(),dfield.getLocalName());
                }
            }
        }
        return mapsObjectFields;
    }

    // To get all Object SObjectField.
    public static Map<String,Schema.SObjectField> getMapsObjectFields(String sObjectName)
    {
        Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe();
        Schema.SObjectType sObjectType = sObjectMap.get(sObjectName);

        if(sObjectType == null)
            return null;

        Schema.DescribeSObjectResult resSchema = sObjectType.getDescribe();
        Map<String,Schema.SObjectField> FieldMapping = resSchema.Fields.getMap();

        return FieldMapping;
    }

    // To get all record type by Name.
    public static Map<String,Schema.RecordTypeInfo> getRecordTypesByName (String SobjectName)
    {
        if(String.isNotBlank(SobjectName))
        {
            Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe();
            Schema.SObjectType ObjectType = sObjectMap.get(SobjectName) ; // getting Sobject Type

            if(ObjectType == null)
                return null;

            Schema.DescribeSObjectResult resSchema = ObjectType.getDescribe();

            if(resSchema == null)
                return null;

            Map<String,Schema.RecordTypeInfo> recordTypeInfo = resSchema.getRecordTypeInfosByName(); //getting all Recordtype for the Sobject
            return recordTypeInfo;
        }
        return null;
    }

    // To get all record type by Id.
    public static Map<Id,Schema.RecordTypeInfo> getRecordTypesById (String SobjectName)
    {
        if(String.isNotBlank(SobjectName))
        {
            Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe() ;
            Schema.SObjectType s = sObjectMap.get(SobjectName) ; // getting Sobject Type
            Schema.DescribeSObjectResult resSchema = s.getDescribe() ;
            Map<Id,Schema.RecordTypeInfo> recordTypeInfo = resSchema.getRecordTypeInfosById(); //getting all Recordtype for the Sobject
            return recordTypeInfo;
        }
        return null;
    }

    // To get record type Name from Id.
    public static String getRecordTypeName(String strObjectName,String strRecordTypeId)
    {
        if(String.isNotBlank(strObjectName) && String.isNotBlank(strRecordTypeId))
        {
            Map<Id,Schema.RecordTypeInfo> mapRecordTypesByName = getRecordTypesById(strObjectName);
            if(mapRecordTypesByName != null && !mapRecordTypesByName.isEmpty() && mapRecordTypesByName.containsKey(strRecordTypeId))
                return mapRecordTypesByName.get(strRecordTypeId).getName();
        }
        return '';
    }

    // To get record type Id from Name.
    public static String getRecordTypeId(String strObjectName,String strRecordTypeName)
    {
        if(String.isNotBlank(strObjectName) && String.isNotBlank(strRecordTypeName))
        {
            Map<String,Schema.RecordTypeInfo> mapRecordTypesByName = getRecordTypesByName(strObjectName);

            if(mapRecordTypesByName != null && !mapRecordTypesByName.isEmpty() && mapRecordTypesByName.containsKey(strRecordTypeName))
                return mapRecordTypesByName.get(strRecordTypeName).getRecordTypeId();
        }
        return '';
    }

    // To get Related List Column for related List.
    public static Map<String,String> getrelatedListColumn(FGM_Portal__Related_List_Controller__c relatedListController)
    {
        Map<String,String> mapColumns = new Map<String,String>();
        if(relatedListController != null)
        {
            String[] lstColumnLabels = relatedListController.FGM_Portal__FieldHeaders__c.split(',');
            String[] lstColumnFields = relatedListController.FGM_Portal__FieldNames__c.split(',');

            if(lstColumnLabels != null && lstColumnFields != null)
            {
                integer index = 0;
                for(String columnLabel : lstColumnLabels)
                {
                    if(lstColumnFields[index] != null && String.isNotBlank(lstColumnFields[index]))
                    {
                        String strFieldName =   lstColumnFields[index];
                        mapColumns.put(columnLabel, strFieldName);
                        index++;
                    }
                }
            }
        }
        return mapColumns;
    }

    // Correct tht HTML Format
    public static String getCorrectHTML(String sourceValue)
    {
        String value = sourceValue;
        if(String.isNotBlank(value))
        {
            value = value.replace('</ ', '</');
            value = value.replace('< /', '</');
            value = value.replace('< / ', '</');
        }
        return value;
    }

    // To get all language from Organization.
    public static List<SelectOption> getOrgLanguages()
    {
        List<SelectOption> lstLanguages = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = User.LanguageLocaleKey.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry picklistEntry : picklistValues)
        {
            if(picklistEntry.isActive())
                lstLanguages.add(new SelectOption(picklistEntry.getValue(),picklistEntry.getLabel()));
        }
        return lstLanguages;
    }

    // To get all language from Portal Configuration
    public static List<SelectOption> getPortalLanguage()
    {
        List<SelectOption> lstPortalConfLang = new List<SelectOption>();
        List<FGM_Portal__PortalConfiguration__c> lstPortalConfRecord = FGM_Portal__PortalConfiguration__c.getall() != null ? FGM_Portal__PortalConfiguration__c.getall().values(): null;

        if(lstPortalConfRecord  != null && !lstPortalConfRecord.isEmpty())
        {
            for(FGM_Portal__PortalConfiguration__c portalConf :lstPortalConfRecord)
            {
                Map<String,String> mapOrgLanguages = FCGlobal.getOrgLanguageMap();
                if(mapOrgLanguages != null)
                {
                    String languageCode = mapOrgLanguages.get(portalConf.FGM_Portal__LanguageSelection__c);
                    if(String.isNotBlank(languageCode))
                        lstPortalConfLang.add(new SelectOption(portalConf.FGM_Portal__LanguageSelection__c,languageCode));
                }
            }
        }
        if(lstPortalConfLang == null || lstPortalConfLang.isEmpty())
        {
            lstPortalConfLang.add(new SelectOption('en_US','English'));
            return lstPortalConfLang;
        }
        return lstPortalConfLang;
    }

    // To get Map of all language from Organization.
    public static Map<String,String> getOrgLanguageMap()
    {
        Map<String,String> mapLanguages = new Map<String,String>();
        Schema.DescribeFieldResult fieldResult = User.LanguageLocaleKey.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry picklistEntry : picklistValues)
        {
            mapLanguages.put(picklistEntry.getValue(),picklistEntry.getLabel());
        }

        return mapLanguages;
    }

    // To get all language Fields From Object.
    public static Map<String,Map<String,String>> getLanguageFields(String ObjectName, Set<String> setFieldNames)
    {
        Map<String,Map<String,String>> mapLanguageFieldsByFieldName = new Map<String,Map<String,String>>();
        Map<String,String> mapLanguage = getOrgLanguageMap();
        Set<String> setOrganizationLanguages = new Set<String>(mapLanguage.keySet());

        if(String.isNotBlank(ObjectName) && setFieldNames != null && !setFieldNames.isEmpty())
        {
            Map<String,String> mapObjectFields = getsObjectFields(ObjectName, new Set<String> { 'FORMULA','REFERENCE','BOOLEAN','CURRENCY','DataCategoryGroupReference','DateTime','Date','Percent','Phone' });
            Set<String> setObjectFields = null;

            if(mapObjectFields != null)
            // TODO: How do we handle the translations? This code doesn't seem to be used anywhere.
            // QuizDesignFormExtension.getOtherLanguageConfig() calls this method, but nothing seems to call
            // getOtherLanguageConfig()
                setObjectFields = new Set<String>{'FGM_Portal__InstructionalText__c','InstructionalText_es__c'};

            if(setObjectFields != null && !setObjectFields.isEmpty())
            {
                for(String fieldAPI : setObjectFields)
                {
                    String[] splitOriginalField = fieldAPI.split('__');
                    String originalFieldName = '';

                    if(splitOriginalField != null)
                    {
                        if(splitOriginalField.size() == 1)
                            originalFieldName = splitOriginalField[0];    // This is Standard Field.
                        if(splitOriginalField.size() == 2)
                            originalFieldName = splitOriginalField[0];    // This is UnManaged Field.
                        if(splitOriginalField.size() == 3)
                            originalFieldName = splitOriginalField[1];    // This is Managed Field.
                    }

                    for(String languageDependentField : setFieldNames)
                    {
                        if(!setObjectFields.contains(languageDependentField))
                            continue;

                        if(!mapLanguageFieldsByFieldName.containsKey(languageDependentField))
                        {
                            Map<String,String> mapFieldsByLanguage = new Map<String,String>();
                            mapFieldsByLanguage.put('en_US',languageDependentField);
                            mapLanguageFieldsByFieldName.put(languageDependentField,mapFieldsByLanguage);
                        }

                        Map<String,String> mapFieldsByLanguage = new Map<String,String>();
                        mapFieldsByLanguage = mapLanguageFieldsByFieldName.get(languageDependentField);

                        String[] splitLanguageField = languageDependentField.split('__');
                        String languageDependentFieldName = '';

                        if(splitLanguageField != null)
                        {
                            if(splitLanguageField.size() == 1)
                                languageDependentFieldName = splitLanguageField[0];    // This is Standard Field.
                            if(splitLanguageField.size() == 2)
                                languageDependentFieldName = splitLanguageField[0];    // This is UnManaged Field.
                            if(splitLanguageField.size() == 3)
                                languageDependentFieldName = splitLanguageField[1];    // This is Managed Field.
                        }

                        if(!String.isNotBlank(originalFieldName) && !String.isNotBlank(languageDependentFieldName) &&  !originalFieldName.contains(languageDependentFieldName))
                            continue;
                        else if(String.isNotBlank(originalFieldName) && String.isNotBlank(languageDependentFieldName) && originalFieldName.contains(languageDependentFieldName))
                        {
                            String languageCode = originalFieldName.replace(languageDependentFieldName + '_','');

                            if(String.isNotBlank(languageCode) && !mapFieldsByLanguage.containsKey(languageCode) && setOrganizationLanguages != null && setOrganizationLanguages.contains(languageCode))
                                mapFieldsByLanguage.put(languageCode,fieldAPI);
                        }
                    }
                }
            }
        }
        return mapLanguageFieldsByFieldName;
    }

    //check session is expired
    public static PageReference checkSession()
    {
        String strCurrentUser = UserInfo.getUserId();
        if(UserInfo.getSessionId() == null)
        {
            PageReference pageRef = new PageReference('/secur/logout.jsp');
            pageRef.setRedirect(true);
            return pageRef;
        }
        return null;
    }

    // FC Community Session Logic.
    public static UserSession getUserSession(ID UserId)
    {
        if(UserId != null)
        {
            Cookie userLanguage = ApexPages.currentPage().getCookies().get(String.escapeSingleQuotes('UserLanguage'));
            Cookie userProfileType = ApexPages.currentPage().getCookies().get(String.escapeSingleQuotes('UserProfileType'));
            if(userLanguage != null && userProfileType != null)
            {
                UserSession userSession = new UserSession();
                userSession.UserLanguage =  userLanguage.getValue();
                userSession.UserPortalType = userProfileType.getValue();
                return userSession;
            }
            else
            {
                    return initilizeSession(UserId);
            }
        }
        return null;
    }

    public static void setUserLanguage(ID UserId, String language)
    {
        if(String.isNotBlank(language) && UserId != null)
        {
            Cookie userLanguageCookie = new Cookie('UserLanguage',language, null, 315569260, false); //Here 315569260 represents cookie expiry date = 10 years. You can set this to what ever expiry date you want. Read apex docs for more details.
            ApexPages.currentPage().setCookies(new Cookie[] {
                userLanguageCookie
            });
        }
    }

    public static void setUserPortalProfile(ID UserId, String PortalProfile)
    {
        if(String.isNotBlank(PortalProfile) && UserId != null)
        {
            Cookie userLanguageCookie = new Cookie('UserProfileType',PortalProfile, null, 315569260, false); //Here 315569260 represents cookie expiry date = 10 years. You can set this to what ever expiry date you want. Read apex docs for more details.
            ApexPages.currentPage().setCookies(new Cookie[] {
                userLanguageCookie
            });
        }
    }

    //ValidateUrl
    public static Boolean validateUrl()
    {
        String strCurrentPageUrl =  URL.getCurrentRequestUrl().toExternalForm();
        if(String.isNotBlank(strCurrentPageUrl))
        {
            Set<String> setSplitParam = new Set<String>(strCurrentPageUrl.split('/'));
            if(setSplitParam != null && setSplitParam.size() > 0)
            {
                if(setSplitParam.contains('FCReviewer'))
                    return true;
                else
                    return false;
            }
        }
        return false;
    }

    //setCookie
    public static UserSession initilizeSession(ID UserId)
    {
        if(UserId != null)
        {
            String strUserProfileType = '';
            String strUserId = UserInfo.getUserId();

            User currentUser = [
                SELECT
                    LanguageLocaleKey,
                    UserProfile__c
                FROM User
                WHERE Id = :strUserId
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            if(currentUser != null)
            {
                Cookie userProfileTypeCookie = null;
                Cookie userLanguageCookie = new Cookie('UserLanguage',currentUser.LanguageLocaleKey, null, 315569260, false); //Here 315569260 represents cookie expiry date = 10 years. You can set this to what ever expiry date you want. Read apex docs for more details.

                if('Grantee'.equalsIgnoreCase(currentUser.UserProfile__c))
                    strUserProfileType = 'Grantee';
                else if('Reviewer'.equalsIgnoreCase(currentUser.UserProfile__c))
                    strUserProfileType= 'Reviewer';
                else
                    strUserProfileType = 'Grantee';

                userProfileTypeCookie = new Cookie('UserProfileType',strUserProfileType, null, 315569260, false);
                ApexPages.currentPage().setCookies(new Cookie[] {
                    userLanguageCookie,userProfileTypeCookie
                });

                UserSession userSession = new UserSession();
                userSession.UserLanguage =  currentUser.LanguageLocaleKey;
                userSession.UserPortalType = strUserProfileType;
                return userSession;
            }
        }
        return null;
    }

    public with sharing class UserSession
    {
        public String UserLanguage { get; set; }
        public String UserPortalType { get; set; }

        public UserSession()
        {
            UserPortalType = 'Grantee';
        }
    }


    // END FC Community Session Logic.
    // Logic To clone the Quiz.
    public static FGM_Portal__Quiz__c cloneQuiz(String QuizId,String QuizName)
    {
        Savepoint quizSavePoint = Database.setSavepoint();
        FGM_Portal__Quiz__c clonedQuiz = null;
        QuizId = String.escapeSingleQuotes(QuizId);

        if(!String.isNotBlank(QuizId) && !String.isNotBlank(QuizName))
            return null;

        try
        {

            List<Quiz__c> lstExisingQuiz = [
                SELECT
                    Failure_URL__c,
                    Introduction_Text__c,
                    Is_Active__c,
                    Success_URL__c,
                    (
                        SELECT
                            Field__c,
                            Question__c,
                            Required__c,
                            Sort_Order__c,
                            Tab__c
                        FROM Quiz_Questions__r
                    )
                FROM Quiz__c
                WHERE Id = :QuizId
                AND IsCommunityRecord__c = TRUE
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            if(lstExisingQuiz != null && !lstExisingQuiz.isEmpty())
            {
                clonedQuiz = lstExisingQuiz[0].clone(false,true,false,false);
                clonedQuiz.Name = QuizName;
                clonedQuiz.FGM_Portal__IsCommunityRecord__c = true;
                CrudFlsService.getInstance().assertCreateable(clonedQuiz);
                insert clonedQuiz;

                if(lstExisingQuiz[0].FGM_Portal__Quiz_Questions__r != null && !lstExisingQuiz[0].FGM_Portal__Quiz_Questions__r.isEmpty())
                    List<FGM_Portal__Quiz_Questions__c> lstClonedQuizQuestions = CloneQuizQuestion(lstExisingQuiz[0].FGM_Portal__Quiz_Questions__r, clonedQuiz.Id,'',false);
            }
            return clonedQuiz;
        }
        catch(Exception ex)
        {
            Database.rollback(quizSavePoint);
            return null;
        }
    }

    public static List<FGM_Portal__Quiz_Questions__c> CloneQuizQuestion(List<FGM_Portal__Quiz_Questions__c> lstQuizQuestions,Id QuizId,String languageCode,Boolean deepCloneQuestions)
    {
        List<FGM_Portal__Quiz_Questions__c> lstClonedQuizQuestions = null;

        if(QuizId == null)
            return lstClonedQuizQuestions;

        Map<String,Set<ID>> mapQuestionAndTabID = getQuestionAndTabID(lstQuizQuestions);
        if(mapQuestionAndTabID != null && !mapQuestionAndTabID.isEmpty())
        {
            Map<Id,FGM_Portal__Questions__c> mapQuestion = null;
            Map<Id,FGM_Portal__Related_List_Controller__c> mapTab = null;
            Map<Id,Id> mapOldNewTabRecords = null;
            Map<Id,Id> mapOldNewQuestionRecords = null;

            if(mapQuestionAndTabID.containsKey('questionIDSet') && deepCloneQuestions)
            {
                Set<Id> setQuestionsID = mapQuestionAndTabID.get('questionIDSet');
                if(setQuestionsID != null && !setQuestionsID.isEmpty())
                {
                    Map<String,Schema.SObjectField> Question_FIELDS = Schema.SObjectType.FGM_Portal__Questions__c.Fields.getMap();
                    String strQuery = ''
                                    + 'SELECT '+ String.join(new List<String>(Question_FIELDS.keySet()), ', ')
                                    + '  FROM  FGM_Portal__Questions__c'
                                    + ' WHERE Id IN :setQuestionsID'
                                    + ' WITH SECURITY_ENFORCED'
                                    + ' LIMIT 1000';
                    List<FGM_Portal__Questions__c> lstQuestionsRecords = (List<FGM_Portal__Questions__c>)Database.Query(strQuery);
                    mapOldNewQuestionRecords = CloneQuestion(lstQuestionsRecords, String.escapeSingleQuotes(QuizId),languageCode);
                }
            }

            if(mapQuestionAndTabID.containsKey('tabIDSet'))
            {
                Set<Id> setTabID = mapQuestionAndTabID.get('tabIDSet');

                if(setTabID != null && !setTabID.isEmpty())
                {
                    String quizlookUpField = String.valueOf(FGM_Portal__Related_List_Controller__c.Quiz__c);
                    String quizlookUpLanguageField = String.valueOf(FGM_Portal__Related_List_Controller__c.Language__c);
                    String andCondtion = '';
                    String defaultLanguage = 'en_US';

                    if(String.isNotBlank(languageCode))
                        andCondtion = ' AND ' + quizlookUpLanguageField + '=:defaultLanguage';

                    Map<String,Schema.SObjectField> RLC_FIELDS = Schema.SObjectType.FGM_Portal__Related_List_Controller__c.Fields.getMap();
                    String strQuery = ''
                                        + 'SELECT RecordType.Id, RecordType.Name,'+ String.join(new List<String>(RLC_FIELDS.keySet()), ', ')
                                        + '  FROM  FGM_Portal__Related_List_Controller__c'
                                        + ' WHERE (Id IN :setTabID)'
                                        + andCondtion
                                        + ' WITH SECURITY_ENFORCED'
                                        + ' LIMIT 1000';
                    List<FGM_Portal__Related_List_Controller__c> lstRLCRecords = (List<FGM_Portal__Related_List_Controller__c>)Database.Query(strQuery);
                    mapOldNewTabRecords = CloneTabRecord(lstRLCRecords,QuizId,languageCode);
                }
            }
            //Clone the Tab
            if(mapOldNewTabRecords != null && !mapOldNewTabRecords.isEmpty())
            {
                lstClonedQuizQuestions = new List<FGM_Portal__Quiz_Questions__c>();
                for(FGM_Portal__Quiz_Questions__c quizQuestionRecord : lstQuizQuestions)
                {
                    FGM_Portal__Quiz_Questions__c clonedQuizQuestion = quizQuestionRecord.clone(false,true,false,false);
                        clonedQuizQuestion.Parent_QuizQuestionID__c = quizQuestionRecord.Id;
                        clonedQuizQuestion.FGM_Portal__Quiz__c = String.escapeSingleQuotes(QuizId);
                        if(String.isNotBlank(languageCode))
                            clonedQuizQuestion.Language__c = languageCode;
                        if(quizQuestionRecord.Tab__c != null && mapOldNewTabRecords.containsKey(quizQuestionRecord.Tab__c))
                            clonedQuizQuestion.Tab__c = mapOldNewTabRecords.get(quizQuestionRecord.Tab__c);
                        if(deepCloneQuestions && mapOldNewQuestionRecords != null && !mapOldNewQuestionRecords.isEmpty() && mapOldNewQuestionRecords.containsKey(quizQuestionRecord.FGM_Portal__Question__c))
                            clonedQuizQuestion.FGM_Portal__Question__c = mapOldNewQuestionRecords.get(quizQuestionRecord.FGM_Portal__Question__c);
                        lstClonedQuizQuestions.add(clonedQuizQuestion);
                }
                if(lstClonedQuizQuestions != null && !lstClonedQuizQuestions.isEmpty()) {
                    CrudFlsService.getInstance().assertCreateable(lstClonedQuizQuestions);
                    Database.insert(lstClonedQuizQuestions);
                }
            }
        }
        return lstClonedQuizQuestions;
    }

    public static Map<String,Set<ID>> getQuestionAndTabID(List<FGM_Portal__Quiz_Questions__c> lstQuizQuestions)
    {
        Map<String,Set<ID>> mapQuestionAndTabID = new Map<String,Set<ID>>();
        Set<ID> setQuestionID = null;
        Set<ID> setTabID = null;

        if(lstQuizQuestions != null && !lstQuizQuestions.isEmpty())
        {
            setQuestionID = new Set<ID>();
            setTabID = new Set<ID> ();
            for(FGM_Portal__Quiz_Questions__c quizQuestionRecord : lstQuizQuestions)
            {
                if(quizQuestionRecord.FGM_Portal__Question__c != null && !setQuestionID.contains(quizQuestionRecord.FGM_Portal__Question__c))
                    setQuestionID.add(quizQuestionRecord.FGM_Portal__Question__c);

                if(quizQuestionRecord.Tab__c != null && !setQuestionID.contains(quizQuestionRecord.Tab__c))
                    setTabID.add(quizQuestionRecord.Tab__c);
            }
            if(setQuestionID != null && !setQuestionID.isEmpty())
                mapQuestionAndTabID.put('questionIDSet',setQuestionID);

            if(setTabID != null && !setTabID.isEmpty())
                mapQuestionAndTabID.put('tabIDSet',setTabID);
        }
        return mapQuestionAndTabID;
    }

    public static Map<Id,Id> CloneTabRecord(List<FGM_Portal__Related_List_Controller__c> lstTabRecords,Id QuizId,String languageCode)
    {
        Map<Id,Id> mapOldNewTabRecords = new Map<Id,Id>();
        Map<Id,FGM_Portal__Related_List_Controller__c> mapRLCById = new Map<Id,FGM_Portal__Related_List_Controller__c>();
        List<FGM_Portal__Grantee_Budget_Configuration__c> lstExistingGBT = new LIST<FGM_Portal__Grantee_Budget_Configuration__c>();
        String recordTypeName = null;
        if(QuizId == null)
            return mapOldNewTabRecords;
        try
        {
            for(FGM_Portal__Related_List_Controller__c record : lstTabRecords)
            {
                if(record.RecordType.Name == 'Grantee Budget Tab')
                {
                    lstExistingGBT = record.FGM_Portal__Grantee_Budget_Configurations__r;
                    recordTypeName = 'Grantee Budget Tab';
                }
                FGM_Portal__Related_List_Controller__c clonedRLCRecord = record.clone(false,true,false,false);
                clonedRLCRecord.Parent_RLCTabID__c = record.Id;
                clonedRLCRecord.FGM_Portal__IsCommunityRecord__c = true;
                clonedRLCRecord.Quiz__c = String.escapeSingleQuotes(QuizId);
                if(String.isNotBlank(languageCode))
                    clonedRLCRecord.Language__c = languageCode;
                mapRLCById.put(record.Id,clonedRLCRecord);
            }
            if(mapRLCById != null && mapRLCById.values() != null)
            {
                CrudflsService.getInstance().assertCreateable(mapRLCById.values());
                Database.Insert(mapRLCById.values());
                for(FGM_Portal__Related_List_Controller__c rlcTab : mapRLCById.values())
                {
                    if(rlcTab.FGM_Portal__ObjectName__c == 'FGM_Portal__Grantee_Budget__c' && recordTypeName != null)
                        CloneGranteeBudgetConfiguration(lstExistingGBT, QuizId, rlcTab.Id, languageCode);
                }
                for(ID RLCRecord : mapRLCById.keySet())
                    mapOldNewTabRecords.put(RLCRecord,(mapRLCById.get(RLCRecord).Id));
            }
            return mapOldNewTabRecords;
        }
        catch(Exception ex)
        {
            system.debug( 'Exception: ' + ex +'at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
            return null;
        }
    }
    private static List < FGM_Portal__Related_List_Controller__c > getTabRecords(String languageCode, String strQuizID)
    {
        List < FGM_Portal__Related_List_Controller__c > lstTabs;
        Map<String, List<FGM_Portal__Quiz_Questions__c>> mapTabIdWthQQs;
        try
        {
            if ( !String.isNotBlank(languageCode) )
                return null;

                List<String> sanitizedTabRelatedListFields = new List<String>();

                for (String f : getTabRelatedListFields(null)) {
                    sanitizedTabRelatedListFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                }
            String strQuery = 'SELECT RecordType.Id, RecordType.Name, FGM_Portal__Quiz__c , ' + String.join(sanitizedTabRelatedListFields, ', ') + ', FGM_Portal__of_records_to_display__c, FGM_Portal__Cloned_from__r.Name, FGM_Portal__Cloned_from__r.Id, (Select Id, Name, FGM_Portal__Category__c, FGM_Portal__Sort_Order__c,FGM_Portal__Quiz__c, FGM_Portal__Related_List_Controller__c from FGM_Portal__Grantee_Budget_Configurations__r where FGM_Portal__Quiz__c =: strQuizID ORDER BY FGM_Portal__Sort_Order__c) FROM FGM_Portal__Related_List_Controller__c WHERE FGM_Portal__Quiz__c =: strQuizID AND FGM_Portal__IsCommunityRecord__c = true AND FGM_Portal__Language__c =: languageCode WITH SECURITY_ENFORCED ORDER BY FGM_Portal__SortOrder__c ASC NULLS LAST LIMIT 1000';
            lstTabs = ( List < FGM_Portal__Related_List_Controller__c > )Database.query( strQuery );
            return lstTabs;
        }
        catch( Exception ex )
        {
            system.debug('Get Tab Record Exception ::'+ex.getMessage()+' line num :'+ex.getLineNumber());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Exception: ' + ex.getMessage()));
        }
        return lstTabs;
    }
    private static Set < String > getTabRelatedListFields(Set < String > setRequiredFields) {
        Set < String > setRLCObject = new Set < String > ();
        setRLCObject.add('Name');
        setRLCObject.add('FGM_Portal__Associated_FC_Portal_Type__c');
        setRLCObject.add('FGM_Portal__Associated_Tab_Type__c');
        setRLCObject.add('FGM_Portal__ObjectName__c');
        setRLCObject.add('FGM_Portal__ParentObject__c');
        setRLCObject.add('FGM_Portal__LookupField__c');
        setRLCObject.add('FGM_Portal__SortOrder__c');
        setRLCObject.add('FGM_Portal__SortField__c');
        setRLCObject.add('FGM_Portal__ShowNewButton__c');
        setRLCObject.add('FGM_Portal__ShowDeleteLink__c');
        setRLCObject.add('FGM_Portal__RichInstructionalText__c');
        setRLCObject.add('FGM_Portal__Hide_Edit_Link__c');
        setRLCObject.add('FGM_Portal__FieldHeaders__c');
        setRLCObject.add('FGM_Portal__FieldNames__c');
        setRLCObject.add('FGM_Portal__Field_Names_Long__c');
        setRLCObject.add('FGM_Portal__Field_Labels_Long__c');
        setRLCObject.add('FGM_Portal__BaseUrl__c');
        setRLCObject.add('FGM_Portal__SortFieldOrder__c');
        setRLCObject.add('RecordTypeId');
        setRLCObject.add('FGM_Portal__Language__c');
        return setRLCObject;
    }
    public static Map<Id,Id> CloneQuestion(List<FGM_Portal__Questions__c> lstQuestions,Id QuizId,String languageCode)
    {
        try
        {
            Map<Id,Id> mapOldNewQuestionRecords = new Map<Id,Id>();
            Map<Id,FGM_Portal__Questions__c> mapQuestionsById = new Map<Id,FGM_Portal__Questions__c>();

            if(QuizId == null)
                return mapOldNewQuestionRecords;
            Id currentUserId = UserInfo.getUserId();
            for(FGM_Portal__Questions__c record : lstQuestions)
            {
                FGM_Portal__Questions__c clonedQuestions = record.clone(false,true,false,false);
                clonedQuestions.OwnerId  = currentUserId;
                clonedQuestions.FGM_Portal__Parent_QuestionID__c = record.Id;
                clonedQuestions.Quiz__c = QuizId;

                if(String.isNotBlank(languageCode))
                    clonedQuestions.Language__c = languageCode;
                mapQuestionsById.put(record.Id,clonedQuestions);
            }

            if(mapQuestionsById != null && mapQuestionsById.values() != null)
            {
                CrudFlsService.getInstance().assertCreateable(mapQuestionsById.values());
                Database.Insert(mapQuestionsById.values());
                for(ID QuestionsRecord : mapQuestionsById.keySet())
                {
                    mapOldNewQuestionRecords.put(QuestionsRecord,(mapQuestionsById.get(QuestionsRecord).Id));
                }
            }
            return mapOldNewQuestionRecords;
        }
        catch( Exception ex )
        {
            system.debug('Handled Exception:' + ex.getMessage() + '; at line number:' + ex.getLineNumber());
            return null;
        }
    }

    public static String NewGuid()
    {
        String kHexChars = '0123456789abcdef';
        String returnValue = '';
        Integer nextByte = 0;

        for (Integer i=0; i<16; i++)
        {
            if (i==4 || i==6 || i==8 || i==10)
                returnValue += '-';

            nextByte = (Math.round(Math.random() * 255)-128) & 255;

            if (i==6)
            {
                nextByte = nextByte & 15;
                nextByte = nextByte | (4 << 4);
            }

            if (i==8)
            {
                nextByte = nextByte & 63;
                nextByte = nextByte | 128;
            }

            returnValue += getCharAtIndex(kHexChars, nextByte >> 4);
            returnValue += getCharAtIndex(kHexChars, nextByte & 15);
        }

        return returnValue;
    }

    public static String getCharAtIndex(String str, Integer index)
    {
        if (str == null)
            return null;

        if (str.length() <= 0)
            return str;

        if (index == str.length())
            return null;

        return str.substring(index, index+1);
    }
    // END Logic To clone the Quiz.

    // To Excute operation without permission.
    public without sharing class WithoutSharing
    {
        public void executeInsert(List<Sobject> lstRecords)
        {
            CrudFlsService.getInstance().assertCreateable(lstRecords);
            insert lstRecords;
        }

        public List<sObject> getUserResult(List<String> lstUserId) {
            return [
                SELECT
                    Contact.AccountId,
                    ContactId,
                    Email,
                    Name
                FROM User
                WHERE Id IN :lstUserId
                WITH SECURITY_ENFORCED
            ];
        }

        public void executeUpsert(List<Sobject> lstRecords)
        {
            CrudFlsService.getInstance().assertUpdateable(lstRecords);
            upsert lstRecords;
        }

        public List<Sobject> executeUpdate(List<Sobject> lstRecords)
        {
            CrudFlsService.getInstance().assertUpdateable(lstRecords);
            update lstRecords;
            return lstRecords;
        }

        public Map<String,Schema.RecordTypeInfo> getRecordTypesByNameWithoutSharing (String SobjectName)
        {
            if(String.isNotBlank(SobjectName))
            {
                Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe() ;
                Schema.SObjectType s = sObjectMap.get(SobjectName) ; // getting Sobject Type
                Schema.DescribeSObjectResult resSchema = s.getDescribe() ;
                Map<String,Schema.RecordTypeInfo> recordTypeInfo = resSchema.getRecordTypeInfosByName(); //getting all Recordtype for the Sobject
                return recordTypeInfo;
            }
            return null;
        }

        private List<FeedItem> getFeedAttachments(Set<Id> setParentId, Integer recordLimit) {
            return [
                SELECT
                    CreatedDate,
                    LastModifiedDate,
                    ParentId,
                    RelatedRecordId,
                    Type
                 FROM FeedItem
                 WHERE Type = 'ContentPost'
                 AND ParentId IN :setParentId
                 WITH SECURITY_ENFORCED
                 ORDER BY CreatedDate DESC, Id DESC
                 LIMIT :recordLimit
             ];
        }

        public List<FeedItem> getFeedAttachments(Set<Id> setParentId) {
            List<FeedItem> lstFeedAttachments = getFeedAttachments(setParentId,1000);
            return lstFeedAttachments;
        }

        public Integer getRegContacts(String orgName, String ein, String email) {
            return [
                SELECT COUNT()
                FROM Contact
                WHERE Contact.Email = :email
                AND Account.Name = :orgName
                AND Account.FGM_Base__EIN__c = :ein
                WITH SECURITY_ENFORCED
           ];
        }

    }

    public class FieldDescrition
    {
        public boolean isHTML;
        public string name;
        public Integer length;

        public FieldDescrition(boolean isHTML,string name,Integer length)
        {
            this.isHTML=isHTML;
            this.name=name;
            this.length=length;
        }
    }

    public static Map<String,Map<String,Integer>> getFieldLengthMap(String ObjectName)
    {
        Map<String, Map<String,Integer>> mapField=new Map<String,Map<String,Integer>>();
        Map<String,Integer> mapRichText=new Map<String,Integer>();
        Map<String,Integer> mapLongText=new Map<String,Integer>();

        if(String.isBlank(ObjectName))
            return mapField;

        sObject requiredObject = getNewsObject(ObjectName);
        Map<String, Schema.SobjectField> fields =  requiredObject.getSObjectType().getDescribe().fields.getMap();

        for (String s : fields.keySet())
        {
            if (String.valueOf(fields.get(s).getDescribe().getType()) == 'TEXTAREA')
            {
                if(fields.get(s).getDescribe().isHtmlFormatted())
                    mapRichText.put(fields.get(s).getDescribe().getName(),fields.get(s).getDescribe().getLength());
                else
                    mapLongText.put(fields.get(s).getDescribe().getName(),fields.get(s).getDescribe().getLength());
            }
        }
        mapField.put('rich', mapRichText);
        mapField.put('long', mapLongText);
        return mapField;
    }

    public static Set<String> getApplicationOwnerRoleSet(String applicationOwnerRole)
    {
        if(!string.isBlank(applicationOwnerRole))
        {
            LIST<String> lstapplicationOwnerRole=applicationOwnerRole.split(',');
            return new Set<String>(lstapplicationOwnerRole);
        }
        else
            return new Set<String>();
    }

    public class PageRedirectURL
    {
        public Boolean IsCommunityuser;
        public PageReference communityUrl;
        public PageRedirectURL(){}

        public PageRedirectURL(boolean IsCommUser, PageReference commUrl)
        {
            this.IsCommunityuser = IsCommUser;
            this.communityUrl = commUrl;
        }
    }

    // Method for redirect to dashboard for Case : Security - Internal Salesforce accessible in community with a shared ID
    public static PageRedirectURL getRedirectURL()
    {
        map<string,string> mapProfileId;
        List<String> lstProfiles = new List<String>();
        PageRedirectURL ObjPageRedirectURL;
        Boolean IsCommUSER = false;
        PageReference commURL;
        FGM_Portal__GlobalPortalSettings__c portalSettings = FGM_Portal__GlobalPortalSettings__c.getOrgDefaults();

        if(String.isNotBlank(portalSettings.FGM_Portal__Redirect_URL__c))
        {
            lstProfiles = portalSettings.FGM_Portal__Redirect_URL__c.split(';');
            mapProfileId = new map<string,string>();
            for(String keyValue : lstProfiles )
            {
                List<string> lstKeyValue = keyValue.split(':');
                if(lstKeyValue != null && lstKeyValue.size() > 0)
                    mapProfileId.put(string.valueOf(lstKeyValue[0]),string.valueOf(lstKeyValue[1]));
            }

            if(mapProfileId != null && mapProfileId.size() > 0)
            {
                string profileId = UserInfo.getProfileId();

                if(mapProfileId.containsKey(profileId))
                {
                    IsCommUSER = true;
                    commURL = new PageReference(mapProfileId.get(profileId));
                }
                else
                {
                    if(profileId.length() > 15)
                        profileId = profileId.substring(0, 15);
                    if(mapProfileId.containsKey(profileId))
                    {
                        IsCommUSER = true;
                        commURL = new PageReference(mapProfileId.get(profileId));
                    }
                }
                if(commURL ==null)
                    commURL =  new PageReference('/apex/fgm_portal__communitydashboard');

                ObjPageRedirectURL = new PageRedirectURL(IsCommUSER,commURL);
            }
        }
        return ObjPageRedirectURL;
    }

    public static Campaign getCampaign(Id campaignId) {
        return [
            SELECT
                Application_Type__c,
                EndDate,
                IsActive,
                Name,
                RecordType.Name,
                StartDate
            FROM Campaign
            WHERE Id = :campaignId
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
    }

    //populate a map with locale values and corresponding datetime formats
    public static Map<String, String> getDateFormat()
    {
        Map<String, String> locale_map = new Map<String, String>(); //holds the locale to timedate formats
        locale_map.put('ar', 'DD/MM/YYYY , hh:mm A');
        locale_map.put('ar_AE', 'DD/MM/YYYY , hh:mm A');
        locale_map.put('bg', 'YYYY-MM-DD , H:mm');
        locale_map.put('bs', 'DD.MM.YYYY , HH:mm');
        locale_map.put('cs', 'DD.MM.YYYY , H:mm');
        locale_map.put('cy', 'DD/MM/YYYY , HH:mm');
        locale_map.put('da', 'DD-MM-YYYY , HH:mm');
        locale_map.put('de', 'DD.MM.YYYY , HH:mm');
        locale_map.put('el', 'D/M/YYYY , h:mm A');
        locale_map.put('en_AU', 'D/MM/YYYY , HH:mm');
        locale_map.put('en_CA', 'DD/MM/YYYY , h:mm A');
        locale_map.put('en_GB', 'DD/MM/YYYY , HH:mm');
        locale_map.put('en_IN', 'MM/DD/YYYY , h:mm A');
        locale_map.put('en_MY', 'DD/MM/YYYY , HH:mm');
        locale_map.put('en_PH', 'MM/DD/YYYY , h:mm A');
        locale_map.put('en_US', 'MM/DD/YYYY , h:mm A');
        locale_map.put('es', 'DD/MM/YYYY , H:mm');
        locale_map.put('et', 'DD.MM.YYYY , H:mm');
        locale_map.put('eu', 'YYYY-MM-DD , HH:mm');
        locale_map.put('eu_ES', 'YYYY-MM-DD , HH:mm');
        locale_map.put('fi', 'DD.MM.YYYY , H:mm');
        locale_map.put('fr', 'DD/MM/YYYY , HH:mm');
        locale_map.put('fr_CA', 'YYYY-MM-DD , HH:mm');
        locale_map.put('hr', 'YYYY.MM.DD , HH:mm');
        locale_map.put('hi', 'DD/MM/YYYY , HH:mm');
        locale_map.put('hu', 'YYYY.MM.DD , H:mm');
        locale_map.put('hy', 'MM/DD/YYYY , h:mm A');
        locale_map.put('in', 'DD/MM/YYYY , HH:mm');
        locale_map.put('it', 'DD/MM/YYYY , H.mm');
        locale_map.put('iw', 'HH:mm , DD/MM/YYYY');
        locale_map.put('ja', 'YYYY/MM/DD , H:mm');
        locale_map.put('ka', 'YYYY-MM-DD HH:mm');
        locale_map.put('ko', 'YYYY.MM.DD A h:mm');
        locale_map.put('lb', 'DD/MM/YYYY H:mm');
        locale_map.put('lt', 'YYYY.MM.DD HH.mm');
        locale_map.put('lv', 'YYYY.DD.M HH:mm');
        locale_map.put('mk', 'DD.MM.YYYY H:mm');
        locale_map.put('nl_NL', 'DD-MM-YYYY H:mm');
        locale_map.put('no', 'DD.MM.YYYY HH:mm');
        locale_map.put('pl', 'YYYY-MM-DD HH:mm');
        locale_map.put('pt_BR', 'DD/MM/YYYY HH:mm');
        locale_map.put('pt_PT', 'DD-MM-YYYY H:mm');
        locale_map.put('rm', 'DD.MM.YYYY HH:mm');
        locale_map.put('ro', 'DD.MM.YYYY HH:mm');
        locale_map.put('ro_MD', 'DD.MM.YYYY HH:mm');
        locale_map.put('ru', 'DD.MM.YYYY H:mm');
        locale_map.put('sk', 'DD.MM.YYYY H:mm');
        locale_map.put('sl', 'DD.MM.YYYY H:mm');
        locale_map.put('sq', 'YYYY-MM-DD HH:mm.a');
        locale_map.put('sv', 'YYYY-MM-DD HH:mm');
        locale_map.put('th', 'MM/DD/YYYY h:mm A');
        locale_map.put('tl', 'DD/MM/YYYY hh:mm A');
        locale_map.put('tr', 'DD.MM.YYYY HH:mm');
        locale_map.put('uk', 'DD.MM.YYYY HH:mm');
        locale_map.put('ur', 'DD/MM/YYYY hh:mm A');
        locale_map.put('vi', 'HH:mm DD/MM/YYYY');
        locale_map.put('zh_CN', 'YYYY-MM-DD A h:mm');
        locale_map.put('zh_TW', 'YYYY/MM/DD A h:mm');
        return locale_map;
    }

    public static Map<String , Map<String,String>> getObjectTranslationMap(List<Id> lstsObjectID ,  String lang, Set<String> setFields)
    {
        Map<String,String> mapFieldAndTranslations = null;
        Set<String> setOfStringFields = new Set<String>();
        Map<String , Map<String,String>> mapSobjectAndFieldTranslations = new Map<String , Map<String,String>>();
        try
        {

            List<Field_Value_Translation__c> lstTranslation = [
                SELECT
                    Field_Name__c,
                    Language__c,
                    Name,
                    RecordID__c,
                    Translation_Value__c
                FROM Field_Value_Translation__c
                WHERE Language__c = :lang
                AND RecordID__c IN :lstsObjectID
                AND Field_Name__c IN :setFields
                WITH SECURITY_ENFORCED
            ];

            if(lstTranslation != null && !lstTranslation.isEmpty())
            {
                for (Schema.SObjectField field : lstsObjectID[0].getSObjectType().getDescribe().fields.getMap().values())
                    setOfStringFields.add(field.getDescribe().getName());

                for (FGM_Portal__Field_Value_Translation__c objTranslation : lstTranslation )
                    if(setOfStringFields.contains(objTranslation.FGM_Portal__Field_Name__c))
                    {
                        if(mapSobjectAndFieldTranslations.get(objTranslation.FGM_Portal__RecordID__c)!=null)
                               mapFieldAndTranslations = mapSobjectAndFieldTranslations.get(objTranslation.FGM_Portal__RecordID__c);
                        else
                               mapFieldAndTranslations = new Map<String,String>();
                        if(String.isNotBlank(objTranslation.FGM_Portal__Field_Name__c) )
                        {
                            if(String.isNotBlank(objTranslation.FGM_Portal__Translation_Value__c))
                                mapFieldAndTranslations.put(objTranslation.FGM_Portal__Field_Name__c,objTranslation.FGM_Portal__Translation_Value__c);
                            else
                                mapFieldAndTranslations.put(objTranslation.FGM_Portal__Field_Name__c,'');
                            if(!mapFieldAndTranslations.isEmpty())
                                mapSobjectAndFieldTranslations.put(objTranslation.FGM_Portal__RecordID__c,mapFieldAndTranslations);
                        }
                    }

            }
            return mapSobjectAndFieldTranslations;
        }
        catch(Exception ex)
        {
            System.debug('***** Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            mapFieldAndTranslations.put('FGM_Portal__Exception',ex.getMessage());
            mapSobjectAndFieldTranslations.put('FGM_Portal__Exception',mapFieldAndTranslations);
            return mapSobjectAndFieldTranslations;
        }
    }

    public static Map<String,Set<String>> getClonedQuestionsParent(Set<String> setAttachmentQuestionList)
    {
        Map<String,Set<String>> mapParentChildQuestion = new Map<String,Set<String>>();

        List<Questions__c> lstQuestions = [
            SELECT
                AttachmentNameFormula__c,
                Language__c,
                Name,
                Parent_QuestionID__c,
                RichQuestion__c,
                Quiz__c,
                RecordTypeId,
                Type__c
            FROM Questions__c
            WHERE Parent_QuestionID__c IN :setAttachmentQuestionList
            WITH SECURITY_ENFORCED
        ];

        for(FGM_Portal__Questions__c question : lstQuestions)
        {
            if(mapParentChildQuestion.containsKey((String)question.FGM_Portal__Parent_QuestionID__c))
            {
                Set<String> setQuestion = mapParentChildQuestion.get((String)question.FGM_Portal__Parent_QuestionID__c);
                setQuestion.add(question.Id);
            }
            else if(question.FGM_Portal__Parent_QuestionID__c !=null && String.isNotBlank(question.FGM_Portal__Parent_QuestionID__c) && setAttachmentQuestionList.contains((string)question.FGM_Portal__Parent_QuestionID__c) )
            {
                Set<String> setQuestion = new Set<String>();
                setQuestion.add(question.Id);
                mapParentChildQuestion.put(question.FGM_Portal__Parent_QuestionID__c ,setQuestion );
            }
        }
        return mapParentChildQuestion;
    }
}