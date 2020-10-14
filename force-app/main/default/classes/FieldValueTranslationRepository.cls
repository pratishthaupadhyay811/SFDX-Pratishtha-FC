public with sharing virtual class FieldValueTranslationRepository {
    public final static String TRANSLATION_EXCEPTION_KEY = 'FGM_Portal__Exception';

    public Map<String, Map<String, Field_Value_Translation__c>> getFieldTranslationsByTranslatedRecordId(List<Id> recordIds, String languageCode, Set<String> fieldsToTranslate) {
        Map<String, Map<String, Field_Value_Translation__c>> fieldTranslationsByTranslatedRecordId =
            new Map<String, Map<String, Field_Value_Translation__c>>();

        try {
            List<Field_Value_Translation__c> translations = findTranslations(recordIds, languageCode, fieldsToTranslate);

            if (translations.isEmpty()) {
                return fieldTranslationsByTranslatedRecordId;
            }

            Set<String> validFields = getValidSObjectFieldsForSObjetType(recordIds[0].getSObjectType());
            fieldTranslationsByTranslatedRecordId = groupTranslationsByObjectIdAndField(fieldTranslationsByTranslatedRecordId, translations, validFields);

        } catch(Exception ex) {
            addExceptionToTranslations(ex, fieldTranslationsByTranslatedRecordId);
        }
        return fieldTranslationsByTranslatedRecordId;
    }

    protected virtual List<Field_Value_Translation__c> findTranslations(List<Id> recordIds, String languageCode, Set<String> fieldsToTranslate) {
        return [
            SELECT Field_Name__c, Language__c, Name,
                    RecordID__c, Translation_Value__c
            FROM Field_Value_Translation__c
            WHERE Language__c = :languageCode
                AND RecordID__c IN :recordIds
                AND Field_Name__c IN :fieldsToTranslate
            WITH SECURITY_ENFORCED
        ];
    }

    private void addExceptionToTranslations(Exception ex, Map<String, Map<String, Field_Value_Translation__c>> fieldTranslationsByTranslatedRecordId) {
        System.debug('***** Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
        Field_Value_Translation__c translationError = new Field_Value_Translation__c(
            Translation_Value__c = ex.getMessage()
        );

        fieldTranslationsByTranslatedRecordId.put(
            TRANSLATION_EXCEPTION_KEY, new Map<String, Field_Value_Translation__c>{ TRANSLATION_EXCEPTION_KEY => translationError }
        );
    }

    private Map<String, Map<String, Field_Value_Translation__c>> groupTranslationsByObjectIdAndField(
        Map<String, Map<String, Field_Value_Translation__c>> fieldTranslationsByTranslatedRecordId,
        List<Field_Value_Translation__c> translations,
        Set<String> validFields
    ) {

        for (Field_Value_Translation__c translation : translations ){
            if (!validFields.contains(translation.Field_Name__c)) {
                continue;
            }

            if(!fieldTranslationsByTranslatedRecordId.containsKey(translation.RecordID__c)){
                fieldTranslationsByTranslatedRecordId.put(
                    translation.RecordID__c,
                    new Map<String, Field_Value_Translation__c>()
                );
            }
            fieldTranslationsByTranslatedRecordId.get(translation.RecordID__c).put(
                translation.Field_Name__c,
                translation
            );
        }

        return fieldTranslationsByTranslatedRecordId;
    }

    private Set<String> getValidSObjectFieldsForSObjetType(SObjectType sObjType) {
        Set<String> validFields = new Set<String>();
        for (Schema.SObjectField field : sObjType.getDescribe().fields.getMap().values()) {
            validFields.add(field.getDescribe().getName());
        }
        return validFields;
    }
}