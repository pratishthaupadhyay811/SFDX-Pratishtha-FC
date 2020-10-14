public with sharing class CommunityUserFieldMappingController{
    Public static Boolean isAccess{get;set;}
    static{
        try{
            if (CommunityConfiguration__c.JsonData__c.getDescribe().isAccessible()) {
                isAccess = true;
            }
        }
        catch (CollectionUtilities.CustomException ex)
        {
            isAccess = false;
            CollectionUtilities.handleException(ex);
        }

    }
    @RemoteAction
    public static object GetObjectFields(String sobjectName, List<String> lstExcludeFieldTypes,List<String> lstExcludeField,Boolean IsReturnList){
        if(string.isBlank(sobjectName))
            return new FCGlobal.Error(false,'Object Name can not be blank.');

        Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe();
        if(!sObjectMap.containsKey(sobjectName))
            return new FCGlobal.Error(false,'Invalid object Name');

        set<String> setExcludeFieldTypes = new set<String>(lstExcludeFieldTypes);
        set<String> setExcludeFields = new set<String>(lstExcludeField);
        map<String,FCGlobal.Field> mapFields = new Map<string,FCGlobal.Field>();

        Schema.SObjectType sObjectType = sObjectMap.get(sobjectName);
        Schema.DescribeSObjectResult sobjectResult = sObjectType.getDescribe();

        Map <String, Schema.SObjectField> sObjectFields = sobjectResult.fields.getMap();
        for(Schema.SObjectField sField : sObjectFields.Values()){
            schema.describefieldresult sFieldResult = sfield.getDescribe();
            Schema.Displaytype fieldType = sFieldResult.getType();

            String fieldName =  sFieldResult.getName();
            if(!setExcludeFields.contains(fieldName) && !setExcludeFieldTypes.contains(string.valueOf(fieldType) ) && sFieldResult.isUpdateable())
            {
                FCGlobal.Field field = new FCGlobal.Field();
                field.FieldType = fieldType;
                field.Name = fieldName;
                field.Label = sFieldResult.getLabel();
                field.ObjectName = sobjectName;
                mapFields.put(field.Name,Field);
            }
        }
        if(IsReturnList)
            return new FCGlobal.Error(true,mapFields.values());
        else return new FCGlobal.Error(true,mapFields);
    }

    @RemoteAction
    public static Object GetPortalUserMappingData(){
        try{
            isAccess = true;

            List<CommunityConfiguration__c> lstCommunityConfigurations = [
                SELECT
                    ConfiguationName__c,
                    JsonData__c,
                    Name
                FROM CommunityConfiguration__c
                WHERE ConfiguationName__c = 'CommunityUserFieldMapping'
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            if (lstCommunityConfigurations != null && lstCommunityConfigurations.size() > 0) {
                return new FCGlobal.Error(true, lstCommunityConfigurations[0]);
            }

            return new FCGlobal.Error(false, 'No Record Found');
        } catch (Exception e) {
            isAccess = false;
            return null;
        }
    }

    @RemoteAction
    public static object UpsertRecord(List<FGM_Portal__CommunityConfiguration__c> communityConfiguration){
        Database.Upsertresult upResult;
        Boolean bIsLengthExceed =false;
        String errorMessage=null;
        List<String> lstErrorMessage= new List<String>();
        try
        {
            Map<String, List<FCGlobal.Field>> MapFieldMapping;
            List<FGM_Portal__CommunityConfiguration__c> lstUpserts = new List<FGM_Portal__CommunityConfiguration__c>();
            for(FGM_Portal__CommunityConfiguration__c fgmPortalCommunityConfig : communityConfiguration){
                MapFieldMapping = (Map<String,List<FCGlobal.Field>>)JSON.deserialize(fgmPortalCommunityConfig.FGM_Portal__JsonData__c, Map<String,List<FCGlobal.Field>>.class);
                lstUpserts.add(fgmPortalCommunityConfig);
            }
            for( FCGlobal.Field field : MapFieldMapping.get('CommunityUserToContact') )
            {
                if(Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().get(field.Name).getDescribe().getLength()>Schema.getGlobalDescribe().get('User').getDescribe().fields.getMap().get(field.Value).getDescribe().getLength())
                {
                    bIsLengthExceed=true;
                    errorMessage='Contact field "'+Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().get(field.Name).getDescribe().getLabel() +'"\'s field length is greater than that of the user\'s field "'+ Schema.getGlobalDescribe().get('User').getDescribe().fields.getMap().get(field.Value).getDescribe().getLabel();
                    lstErrorMessage.add(errorMessage);
                }
            }
            List<FGM_Portal__CommunityConfiguration__c> lstToUpdateCommunityConfRecord = new List<FGM_Portal__CommunityConfiguration__c>();
            List<FGM_Portal__CommunityConfiguration__c> lstToInsertCommunityConfRecord = new List<FGM_Portal__CommunityConfiguration__c>();
            if(! lstUpserts.isEmpty()  ){
                for(FGM_Portal__CommunityConfiguration__c communityconf : lstUpserts){
                    if(communityconf.id != null)
                        lstToUpdateCommunityConfRecord.add(communityconf);
                    else
                        lstToInsertCommunityConfRecord.add(communityconf);
                }
            }
            List<Database.Upsertresult> lstUpsertResult = new  List<Database.Upsertresult>();
            if(!lstToInsertCommunityConfRecord.isEmpty()){
                CrudFlsService.getInstance().assertUpdateable(lstToInsertCommunityConfRecord);
                lstUpsertResult.addAll(Database.upsert(lstToInsertCommunityConfRecord));
                upResult = lstUpsertResult[0];
            }
            if(!lstToUpdateCommunityConfRecord.isEmpty()){
                isAccess = true;
                CrudFlsService.getInstance().assertUpdateable(lstToUpdateCommunityConfRecord);
                lstUpsertResult.addAll(Database.upsert(lstToUpdateCommunityConfRecord));
                upResult = lstUpsertResult[0];
            }
        }
        catch (CollectionUtilities.CustomException ex)
        {
            //CollectionUtilities.handleException(ex);
            return new FCGlobal.Error(false,ex.getMessage(),communityConfiguration);
            //return new FCGlobal.Error(false,'We found that '+'lstErrorMessage'+'". Please, revisit the mappings else there would be a loss of data or unexpected errors on the User record.',communityConfiguration);
        }
        catch(Exception ex){
            return new FCGlobal.Error(false,ex.getMessage(),communityConfiguration);
        }
        if(bIsLengthExceed)
            return new FCGlobal.Error(false,'We found that '+lstErrorMessage+'". Please, revisit the mappings else there would be a loss of data or unexpected errors on the User record.',communityConfiguration);
        if(upResult != null && upResult.isSuccess())
            return new FCGlobal.Error(true,'Mapping is saved successfuly',communityConfiguration);

        if(upResult != null){
            List<Database.Error> lstErrors = upResult.getErrors();
            return new FCGlobal.Error(false, lstErrors[0].getMessage(),communityConfiguration);
        }
        return new FCGlobal.Error(false,'');
    }
}