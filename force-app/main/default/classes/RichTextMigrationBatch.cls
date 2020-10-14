public without sharing class RichTextMigrationBatch implements Database.Batchable<sObject> {
    private SObjectType sObjectTypeToMigrate;
    private String originalField;
    private String newField;

    public RichTextMigrationBatch(SObjectType sObjectTypeToMigrate) {
        this.sObjectTypeToMigrate = sObjectTypeToMigrate;
    }

    public RichTextMigrationBatch withTranslationField(String originalField, String newField) {
        this.originalField = originalField;
        this.newField = newField;
        return this;
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        if (sObjectTypeToMigrate == CustomHTML__c.SObjectType) {
            return Database.getQueryLocator([SELECT Description__c, RichDescription__c FROM CustomHTML__c]);

        } else if (sObjectTypeToMigrate == Questions__c.SObjectType) {
            return Database.getQueryLocator([SELECT Question__c, RichQuestion__c, Pre_Text__c, RichPreText__c, Post_Text__c, RichPostText__c FROM Questions__c]);

        } else if (sObjectTypeToMigrate == Related_List_Controller__c.SObjectType) {
            return Database.getQueryLocator([SELECT InstructionalText__c, RichInstructionalText__c FROM Related_List_Controller__c]);

        } else if (sObjectTypeToMigrate == Campaign_Quiz__c.SObjectType) {
            return Database.getQueryLocator([SELECT Instructional_Text__c, Rich_Instructional_Text__c FROM Campaign_Quiz__c]);

        } else if (
            sObjectTypeToMigrate == Field_Value_Translation__c.SObjectType
            && !String.isEmpty(originalField)
            && !String.isEmpty(newField)
        ) {
            return Database.getQueryLocator([
                SELECT Name, Field_Name__c, Language__c, RecordID__c, Translation_Value__c
                FROM Field_Value_Translation__c
                WHERE Field_Name__c = :originalField
            ]);

        } else {
            // If no conditions are met, this returns an empty query to avoid an NPE
            return Database.getQueryLocator([SELECT Id FROM Account LIMIT 0]);
        }
    }

    public void execute(Database.BatchableContext context, List<SObject> records){
        if (sObjectTypeToMigrate == CustomHTML__c.SObjectType) {
            List<CustomHTML__c> customHTML = records;
            for (CustomHTML__c customRecord : customHTML) {
                customRecord.RichDescription__c = customRecord.Description__c;
            }
            update customHTML;

        } else if (sObjectTypeToMigrate == Questions__c.SObjectType) {
            List<Questions__c> questions = records;
            for (Questions__c question : questions) {
                question.RichQuestion__c = question.Question__c;
                question.RichPreText__c = question.Pre_Text__c;
                question.RichPostText__c = question.Post_Text__c;
            }
            update questions;

        } else if (sObjectTypeToMigrate == Related_List_Controller__c.SObjectType) {
            List<Related_List_Controller__c> relatedListControllers = records;
            for (Related_List_Controller__c relatedListController : relatedListControllers) {
                relatedListController.RichInstructionalText__c = relatedListController.InstructionalText__c;
            }
            update relatedListControllers;

        } else if (sObjectTypeToMigrate == Campaign_Quiz__c.SObjectType) {
            List<Campaign_Quiz__c> campaignQuizzes = records;
            for (Campaign_Quiz__c campaignQuiz : campaignQuizzes) {
                campaignQuiz.Rich_Instructional_Text__c = campaignQuiz.Instructional_Text__c;
            }
            update campaignQuizzes;

        } else if (
            sObjectTypeToMigrate == Field_Value_Translation__c.SObjectType
            && !String.isEmpty(originalField)
            && !String.isEmpty(newField)
        ) {
            List<Field_Value_Translation__c> translations = records;
            List<Field_Value_Translation__c> clones = new List<Field_Value_Translation__c>();

            for (Field_Value_Translation__c translation : translations) {
                Field_Value_Translation__c clone = translation.clone(false, true);
                clone.Field_Name__c = newField;
                clones.add(clone);
            }

            insert clones;
        }
    }

    public void finish(Database.BatchableContext context) {}
}