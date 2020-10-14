global without sharing class PostInstallationScript implements InstallHandler
{
    global void onInstall(InstallContext context) {
        if (context.previousVersion() != null && context.previousVersion().compareTo(new Version(11, 28)) < 0) {
            Database.executeBatch(new RichTextMigrationBatch(CustomHTML__c.SObjectType));
            Database.executeBatch(new RichTextMigrationBatch(Questions__c.SObjectType));
            Database.executeBatch(new RichTextMigrationBatch(Related_List_Controller__c.SObjectType));
            Database.executeBatch(new RichTextMigrationBatch(Campaign_Quiz__c.SObjectType));
            Database.executeBatch(
                new RichTextMigrationBatch(Field_Value_Translation__c.SObjectType)
                    .withTranslationField('FGM_Portal__Instructional_Text__c', 'FGM_Portal__Rich_Instructional_Text__c')
            );
        }
    }
}