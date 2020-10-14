public with sharing class CampaignTriggerHandler {
    public static void changeFileVisibility(Set<Id> setCampaignId, String requiredVisibility){
        Savepoint sPoint = Database.setSavepoint();
        List<ContentDocumentLink> lstContentDocLinkToCreate = new List<ContentDocumentLink>();
        List<ContentDocumentLink> lstContentDocLinkToDelete = new List<ContentDocumentLink>();
        List<ContentDocumentLink> lstContentDocLink = null;

        lstContentDocLink = [
            SELECT
                ContentDocumentId,
                LinkedEntityId,
                ShareType,
                Visibility
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :setCampaignId
            WITH SECURITY_ENFORCED
        ];

        if(lstContentDocLink != null){
            for(ContentDocumentLink oldContentDocLink : lstContentDocLink){
                if(requiredVisibility.equalsIgnoreCase(oldContentDocLink.Visibility)){
                    continue;
                }
                ContentDocumentLink newContentDocLink = new ContentDocumentLink();
                newContentDocLink.ContentDocumentId = oldContentDocLink.ContentDocumentId;
                newContentDocLink.Visibility = requiredVisibility;
                newContentDocLink.ShareType = oldContentDocLink.ShareType;
                newContentDocLink.LinkedEntityId = oldContentDocLink.LinkedEntityId;
                lstContentDocLinkToCreate.add(newContentDocLink);
                lstContentDocLinkToDelete.add(oldContentDocLink);
            }
            CrudFlsService.getInstance().assertDeletable(lstContentDocLinkToDelete);
            delete lstContentDocLinkToDelete;
            CrudFlsService.getInstance().assertCreateable(lstContentDocLinkToCreate);
            insert lstContentDocLinkToCreate;
        }
    }
}