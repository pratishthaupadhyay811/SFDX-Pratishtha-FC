public with sharing class ContentDocumentLinkTriggerHandler {
    public static void changeFileVisibility(List<ContentDocumentLink> lstContentDocLink){

            set<id> setCampaignId = new set<id>();
            Map<Id,Campaign> mapCampaignIdToCampaign = null;
            for(ContentDocumentLink contentDocLink:lstContentDocLink){
                if((String.valueOf(contentDocLink.LinkedEntityId)).startsWith(Campaign.sObjectType.getDescribe().getKeyPrefix()))
                    setCampaignId.add(contentDocLink.LinkedEntityId);
            }

            if (setCampaignId.size() > 0) {

                mapCampaignIdToCampaign = new Map<Id, Campaign>([
                    SELECT Visibility__c
                    FROM Campaign
                    WHERE Id= :setCampaignId
                    WITH SECURITY_ENFORCED
                ]);

            }

            for(ContentDocumentLink contentDocLink:lstContentDocLink){
                if((String.valueOf(contentDocLink.LinkedEntityId)).startsWith(Campaign.sObjectType.getDescribe().getKeyPrefix())){
                    if(mapCampaignIdToCampaign!=null && mapCampaignIdToCampaign.size()>0 && mapCampaignIdToCampaign.get(contentDocLink.LinkedEntityId)!= null && mapCampaignIdToCampaign.get(contentDocLink.LinkedEntityId).FGM_Portal__Visibility__c!=null){
                        if('Public'.equalsIgnoreCase(mapCampaignIdToCampaign.get(contentDocLink.LinkedEntityId).FGM_Portal__Visibility__c))
                            contentDocLink.Visibility = 'AllUsers';
                    }
                }
                else if((String.valueOf(contentDocLink.LinkedEntityId)).startsWith(FGM_Portal__Quiz__c.sObjectType.getDescribe().getKeyPrefix()))
                    contentDocLink.Visibility = 'AllUsers';
                else if((String.valueOf(contentDocLink.LinkedEntityId)).startsWith(FGM_Portal__Campaign_Quiz__c.sObjectType.getDescribe().getKeyPrefix()))
                    contentDocLink.Visibility = 'AllUsers';
            }

    }
}