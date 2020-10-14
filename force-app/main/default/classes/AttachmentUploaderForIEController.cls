public class AttachmentUploaderForIEController
{
    @RemoteAction
    public static List<AttachmentUploadManager.AttachmentWrapper> getAttachments( String recordId, String lookupFieldApiName, String lookupFieldValue )
    {
        return AttachmentUploadManager.getAttachments( recordId, lookupFieldApiName, lookupFieldValue );
    }

    @RemoteAction
    public static AttachmentUploadManager.AttachmentComponentSettingsWrapper getAttachmentComponentSettings( Boolean isEditable, String baseUrl, String locale, String apiVersion )
    {
        return new AttachmentUploadManager.AttachmentComponentSettingsWrapper( isEditable, baseUrl, locale, apiVersion );
    }

    @RemoteAction
    public static List<sObject> getCustomSettingRecords( String customSettingName, String instanceKey )
    {
        return Engine.getCustomSettingRecords(customSettingName, instanceKey);
    }

    @RemoteAction
    public static AttachmentUploadManager.ApplicationQuestionWrapper getApplicationRecord( String lookupFieldApiName, String lookupFieldValue )
    {
        return AttachmentUploadManager.getApplicationRecord(lookupFieldApiName, lookupFieldValue);
    }
}