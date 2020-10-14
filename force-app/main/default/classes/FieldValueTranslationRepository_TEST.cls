@isTest
public with sharing class FieldValueTranslationRepository_TEST {
    @isTest
    private static void shouldGetFieldTranslationsByTranslatedRecordId() {
        final String SPANISH_CODE = 'es';
        final Set<String> EXPECTED_TRANSLATED_FIELDS = new Set<String>{ 'Name', 'Description' };

        List<Id> mockExpectedCampaignIds = TestIdMocker.mockIds(Campaign.SObjectType, 5);
        List<Id> mockUnexpectedCampaignIds = TestIdMocker.mockIds(Campaign.SObjectType, 5);

        List<Field_Value_Translation__c> expectedSpanishNameTranslations =
            buildTranslationsForIds(mockExpectedCampaignIds, 'Name', SPANISH_CODE);

        List<Field_Value_Translation__c> expectedSpanishDescriptionTranslation =
            buildTranslationsForIds(mockExpectedCampaignIds, 'Description', SPANISH_CODE);

        List<Field_Value_Translation__c> unexpectedFrenchNameTranslation =
            buildTranslationsForIds(mockExpectedCampaignIds, 'Name', 'fr');

        List<Field_Value_Translation__c> unexpectedSpanishNameTranslations =
            buildTranslationsForIds(mockUnexpectedCampaignIds, 'Name', SPANISH_CODE);

        List<Field_Value_Translation__c> unexpectedSpanishTypeTranslations =
            buildTranslationsForIds(mockExpectedCampaignIds, 'Status', SPANISH_CODE);

        List<Field_Value_Translation__c> allTranslations = new List<Field_Value_Translation__c>();

        allTranslations.addAll(expectedSpanishNameTranslations);
        allTranslations.addAll(expectedSpanishDescriptionTranslation);
        allTranslations.addAll(unexpectedFrenchNameTranslation);
        allTranslations.addAll(unexpectedSpanishNameTranslations);
        allTranslations.addAll(unexpectedSpanishTypeTranslations);

        insert allTranslations;

        FieldValueTranslationRepository repository = new FieldValueTranslationRepository();

        Test.startTest();

        Map<String, Map<String, Field_Value_Translation__c>> result =
            repository.getFieldTranslationsByTranslatedRecordId(
                mockExpectedCampaignIds,
                SPANISH_CODE,
                new Set<String>{ 'Name', 'Description' }
            );

        Test.stopTest();

        Set<String> expectedKeys = new Set<String>((List<String>) mockExpectedCampaignIds);
        System.assertEquals(expectedKeys, result.keySet(),
            'Only the translations for the requested Ids should be returned'
        );

        Set<String> translatedFields = new Set<String>();
        Set<String> languages = new Set<String>();
        for (Map<String, Field_Value_Translation__c> translationsByField : result.values()) {
            translatedFields.addAll(translationsByField.keySet());
            for(Field_Value_Translation__c translation : translationsByField.values()) {
                languages.add(translation.Language__c);
            }
        }

        System.assertEquals(EXPECTED_TRANSLATED_FIELDS, translatedFields,
            'Only the requested translated fields should be returned');

        System.assertEquals(1, languages.size(), 'The correct number of languages should be returned');
        System.assert(languages.contains(SPANISH_CODE), 'Only the requested language translations should be returned');
    }

    @isTest
    private static void shouldReturnEmptyMapWhenNoTranslationsAreFound() {
        FieldValueTranslationRepository repository = new FieldValueTranslationRepository();

        Test.startTest();
        Map<String, Map<String, Field_Value_Translation__c>> result =
            repository.getFieldTranslationsByTranslatedRecordId(
                new List<Id>(),
                'fr',
                new Set<String>{ 'Name' }
            );

        Test.stopTest();

        System.assert(result.isEmpty(), 'An empty object should returned when no translations are found');
    }

    @isTest
    private static void shouldNotReturnTranslationsIfFieldValueIsInvalid() {
        List<Id> mockExpectedCampaignIds = TestIdMocker.mockIds(Campaign.SObjectType, 5);

        insert buildTranslationsForIds(mockExpectedCampaignIds, 'FakeField', 'fr');

        FieldValueTranslationRepository repository = new FieldValueTranslationRepository();
        Test.startTest();
        Map<String, Map<String, Field_Value_Translation__c>> result =
            repository.getFieldTranslationsByTranslatedRecordId(
                mockExpectedCampaignIds,
                'fr',
                new Set<String>{ 'FakeField' }
            );

        Test.stopTest();

        System.assert(result.isEmpty(), 'Translations for invalid fields should not be returned');
    }

    @isTest
    private static void shouldCaptureExceptionsInATranslation() {
        MockRepository repository = new MockRepository();
        repository.shouldThrowException = true;

        Test.startTest();

        Map<String, Map<String, Field_Value_Translation__c>> result;
        try {
            result =
                repository.getFieldTranslationsByTranslatedRecordId(
                    new List<Id>(),
                    'fr',
                    new Set<String>{ 'SomeField' }
                );
        } catch (Exception ex) {
            System.assert(false, 'An exception should not be thrown: ' + ex.getMessage());
        }

        Test.stopTest();

        System.assert(result.containsKey(FieldValueTranslationRepository.TRANSLATION_EXCEPTION_KEY),
            'There should be a key in the result that holds the translation exception' + result);

        System.assert(
            result.get(FieldValueTranslationRepository.TRANSLATION_EXCEPTION_KEY)
                .containsKey(FieldValueTranslationRepository.TRANSLATION_EXCEPTION_KEY),
            'A dummy Field Value Translation should be mapped to an exception key'
        );

        System.assertEquals(
            'Mock Exception!',
            result.get(FieldValueTranslationRepository.TRANSLATION_EXCEPTION_KEY)
                .get(FieldValueTranslationRepository.TRANSLATION_EXCEPTION_KEY).Translation_Value__c,
            'A dummy Field Value Translation should have the exception message as the translation'
        );
    }

    private static List<Field_Value_Translation__c> buildTranslationsForIds(List<Id> ids, String fieldName, String languageCode) {
        List<Field_Value_Translation__c> translations = new List<Field_Value_Translation__c>();
        for (Id i : ids ) {
            translations.add(
                new Field_Value_Translation__c(
                    RecordID__c = i,
                    Field_Name__c = fieldName,
                    Name = fieldName,
                    Language__c = languageCode
                )
            );
        }

        return translations;
    }

    private class MockRepository extends FieldValueTranslationRepository {
        private Boolean shouldThrowException = false;

        private MockRepository() {}

        protected override List<Field_Value_Translation__c> findTranslations(List<Id> recordIds, String languageCode, Set<String> fieldsToTranslate) {
            if (shouldThrowException) {
                throw new MockException('Mock Exception!');
            }

            return new List<Field_Value_Translation__c>();
        }
    }

    public class Stub implements System.StubProvider {
        Map<String, Object> returnValueByMethod = new Map<String, Object>{
            'getFieldTranslationsByTranslatedRecordId' => new Map<String, Map<String, Field_Value_Translation__c>>()
        };

        public Stub withReturnValue(String methodName, Object returnValue) {
            returnValueByMethod.put(methodName, returnValue);
            return this;
        }

        public Object handleMethodCall(
            Object stubbedObject,
            String stubbedMethodName,
            Type returnType,
            List<Type> paramTypes,
            List<String> paramNames,
            List<Object> args
        ) {
            return returnValueByMethod.get(stubbedMethodName);
        }
    }

    public class MockException extends Exception {}
}