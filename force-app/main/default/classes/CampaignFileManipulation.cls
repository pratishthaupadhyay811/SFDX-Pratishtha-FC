global class CampaignFileManipulation implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id,(SELECT ContentDocumentId, Visibility, ShareType, LinkedEntityId FROM ContentDocumentLinks WHERE Visibility=\'InternalUsers\' LIMIT 100) From Campaign WHERE FGM_Portal__Visibility__c=\'Public\' LIMIT 500000';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Campaign> scope){
        Savepoint sp = Database.setSavepoint();
        try{
            List<ContentDocumentLink> lstContentDocLinkToCreate = new List<ContentDocumentLink>();
            List<ContentDocumentLink> lstContentDocLinkToDelete = new List<ContentDocumentLink>();
            ContentDocumentLink newContentDocLink = null;
            for(Campaign campaign:scope){
                for(ContentDocumentLink contentDocLink:campaign.ContentDocumentLinks){
                    newContentDocLink = new ContentDocumentLink();
                    newContentDocLink.ContentDocumentId = contentDocLink.ContentDocumentId;
                    newContentDocLink.Visibility = 'AllUsers';
                    newContentDocLink.ShareType = contentDocLink.ShareType;
                    newContentDocLink.LinkedEntityId = contentDocLink.LinkedEntityId;
                    lstContentDocLinkToCreate.add(newContentDocLink);
                    lstContentDocLinkToDelete.add(contentDocLink);
                }
            }
            ProcessorControl.isEscapeCDLTrigger = true;
            CrudFlsService.getInstance().assertDeletable(lstContentDocLinkToDelete);
            Database.delete(lstContentDocLinkToDelete);
            CrudFlsService.getInstance().assertCreateable(lstContentDocLinkToCreate);
            Database.insert(lstContentDocLinkToCreate);
            ProcessorControl.isEscapeCDLTrigger = false;
        }
        Catch(Exception ex){
            Database.rollback(sp);
        }
    }
    global void finish(Database.BatchableContext BC){
    }
}