public class BatchUtilityHelper {
    public String operation;
    public Boolean bUpdateAllOrNone;
    public set<Id> setIdWhereConditionforQuery = new  set<Id>() ;
    static final string UPDATE_CAMPAIGN = 'UpdateCampaign';
    static final string UPDATE_CAMPAIGN_QUIZ_INSTRUCTION = 'UpdateCampaignQuizInstruction';
    static final string UPDATE_ATTACHMENT = 'UpdateAttachment';
    static final string CREATE_GBU_BY_CATEGORY = 'CreateGBUbyCategory';
    static final string UPDATE_PORTAL_USER_REQUEST_TEAM_MEMBER = 'updatePortalUserRequestTeamMember';
    public Database.QueryLocator getQueryLocator()
    {
        String queryString;
        if(operation == UPDATE_CAMPAIGN)
            queryString = 'SELECT Id,(SELECT ContentDocumentId, Visibility, ShareType, LinkedEntityId FROM ContentDocumentLinks WHERE Visibility=\'InternalUsers\' LIMIT 100) From Campaign WHERE FGM_Portal__Visibility__c=\'Public\' LIMIT 500000';
        else if(operation == UPDATE_CAMPAIGN_QUIZ_INSTRUCTION)
            queryString = 'SELECT Id, Name, FGM_Portal__Quiz__c,FGM_Portal__Quiz__r.FGM_Portal__Introduction_Text__c, FGM_Portal__Rich_Instructional_Text__c, FGM_Portal__Campaign__c FROM FGM_Portal__Campaign_Quiz__c LIMIT 500000';
        else if(operation == UPDATE_ATTACHMENT)
            queryString = 'SELECT Id FROM FGM_Portal__Question_Attachment__c Where FGM_Portal__Recommendation__c != null AND CreatedBy.Profile.UserType = \'Guest\' LIMIT 500000';
        else if(operation == CREATE_GBU_BY_CATEGORY)
            queryString = 'SELECT Id, Name, FGM_Portal__Grantee_Report__c, FGM_Portal__Grantee_Budget_Category__c, FGM_Portal__Grantee_Report__r.FGM_Base__Request__c, (SELECT Id FROM FGM_Portal__Grantee_Budget_Update_By_Categories__r) FROM FGM_Portal__Grantee_Budget_Update__c Where FGM_Portal__Grantee_Report__r.FGM_Base__Request__c IN : setIdWhereConditionforQuery LIMIT 500000' ;
        else if(operation == UPDATE_PORTAL_USER_REQUEST_TEAM_MEMBER)
            queryString = 'SELECT Id,Name,FGM_Portal__UserRole__c FROM FGM_Portal__PortalUserRequestTeamMembers__c LIMIT 500000';
        return Database.getQueryLocator(queryString);
    }
    public void executeOperation(List<Sobject> scope)
    {
        Savepoint sp = Database.setSavepoint();
        try
        {
            if(operation.equalsIgnoreCase(UPDATE_CAMPAIGN))
            {
                List<ContentDocumentLink> lstContentDocLinkToCreate = new List<ContentDocumentLink>();
                List<ContentDocumentLink> lstContentDocLinkToDelete = new List<ContentDocumentLink>();
                ContentDocumentLink newContentDocLink = null;

                for(Campaign campaign: (List<Campaign>) scope)
                {
                    for(ContentDocumentLink contentDocLink:campaign.ContentDocumentLinks)
                    {
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
            else if(operation.equalsIgnoreCase(UPDATE_CAMPAIGN_QUIZ_INSTRUCTION))
            {
                List<FGM_Portal__Campaign_Quiz__c> lstCampaignQuizes = new List<FGM_Portal__Campaign_Quiz__c>();
                For(FGM_Portal__Campaign_Quiz__c objCampaignQuiz:(List<FGM_Portal__Campaign_Quiz__c>) scope)
                {
                    objCampaignQuiz.FGM_Portal__Rich_Instructional_Text__c = objCampaignQuiz.FGM_Portal__Quiz__r.FGM_Portal__Introduction_Text__c;
                    lstCampaignQuizes.add(objCampaignQuiz);
                }
                CrudFlsService.getInstance().assertUpdateable(lstCampaignQuizes);
                Database.SaveResult[] updateResult = Database.update(lstCampaignQuizes,bUpdateAllOrNone);
            }
            else if(operation.equalsIgnoreCase(UPDATE_ATTACHMENT))
            {
                List<Attachment> lstAttachToUpdate = new  List<Attachment>();

                List<Attachment> lstAttachment = [
                    SELECT
                        IsPrivate,
                        ParentId
                    FROM Attachment
                    WHERE IsPrivate = true
                    AND CreatedBy.Profile.UserType = 'Guest'
                    AND ParentId IN :scope
                    WITH SECURITY_ENFORCED
                    LIMIT 10000
                ];

                For(Attachment attach : lstAttachment)
                {
                    attach.IsPrivate = false;
                    lstAttachToUpdate.add(attach);
                }
                CrudFlsService.getInstance().assertUpdateable(lstAttachToUpdate);
                Database.update(lstAttachToUpdate);
            }
            // To insert GBUbyCategory
            else if(operation.equalsIgnoreCase(CREATE_GBU_BY_CATEGORY))
            {
                Set<Id> setOppId =  new Set<Id>();
                List<FGM_Portal__Grantee_Budget_Update_By_Category__c> lstGRBUpdateByCategoryToInsert = new List<FGM_Portal__Grantee_Budget_Update_By_Category__c>();

                Map<Id, Opportunity> mapOpporunities = new Map<Id, Opportunity>([
                    SELECT
                        (
                            SELECT
                                Amount__c,
                                Category__c
                            FROM Grantee_Budget_Line_Items__r
                        )
                    FROM Opportunity
                    WHERE Id IN :setIdWhereConditionforQuery
                    WITH SECURITY_ENFORCED
                    LIMIT 1000
                ]);
                Map<Id, List<Grantee_Budget_Update__c>> mapOppIdAndGBUpdate = new Map<Id, List<Grantee_Budget_Update__c>>();
                if (scope != null && scope.size() > 0)
                {
                    for(Grantee_Budget_Update__c GRBUpdate : (List<Grantee_Budget_Update__c>) scope)
                    {
                        if(GRBUpdate.FGM_Portal__Grantee_Budget_Update_By_Categories__r.isEmpty()){
                            if(!mapOppIdAndGBUpdate.containsKey(GRBUpdate.FGM_Portal__Grantee_Report__r.FGM_Base__Request__c)){
                                mapOppIdAndGBUpdate.put(GRBUpdate.FGM_Portal__Grantee_Report__r.FGM_Base__Request__c, new List<Grantee_Budget_Update__c>());
                            }
                            mapOppIdAndGBUpdate.get(GRBUpdate.FGM_Portal__Grantee_Report__r.FGM_Base__Request__c).add(GRBUpdate);
                        }
                        setOppId.add(GRBUpdate.FGM_Portal__Grantee_Report__r.FGM_Base__Request__c);
                    }
                }
                if(mapOppIdAndGBUpdate.keySet() != null && mapOppIdAndGBUpdate.keySet().size() > 0)
                {
                    for(ID key : mapOppIdAndGBUpdate.keySet())
                    {
                        Opportunity application = mapOpporunities.get(key);
                        List<Grantee_Budget_Update__c> LstGBUpdate = new List<Grantee_Budget_Update__c>(mapOppIdAndGBUpdate.get(key));
                        for(Grantee_Budget_Update__c GBUpdate : LstGBUpdate)
                        {
                            if(application.FGM_Portal__Grantee_Budget_Line_Items__r != null && application.FGM_Portal__Grantee_Budget_Line_Items__r.size() >0)
                            {
                                for(FGM_Portal__Grantee_Budget_Line_Item__c lineItem : application.FGM_Portal__Grantee_Budget_Line_Items__r)
                                {
                                    if(GBUpdate.FGM_Portal__Grantee_Budget_Category__c == lineItem.FGM_Portal__Category__c)
                                    {
                                        FGM_Portal__Grantee_Budget_Update_By_Category__c GRBudgetUpdateCategoryRecord = new FGM_Portal__Grantee_Budget_Update_By_Category__c();
                                        GRBudgetUpdateCategoryRecord.FGM_Portal__Grantee_Budget_Line_Item__c = lineItem.Id;
                                        GRBudgetUpdateCategoryRecord.FGM_Portal__Amount__c = lineItem.FGM_Portal__Amount__c ;
                                        GRBudgetUpdateCategoryRecord.FGM_Portal__Grantee_Budget_Update__c = GBUpdate.Id ;
                                        lstGRBUpdateByCategoryToInsert.add(GRBudgetUpdateCategoryRecord);
                                    }
                                }
                            }
                        }
                    }
                    CrudFlsService.getInstance().assertUpdateable(lstGRBUpdateByCategoryToInsert);
                    Database.UpsertResult[] updateResult = Database.upsert(lstGRBUpdateByCategoryToInsert);
                }
            }
            else if(operation.equalsIgnoreCase(UPDATE_PORTAL_USER_REQUEST_TEAM_MEMBER)){
                Map<string,string> mapOpportunityTeamMemberPicklist =  SchemaEngine.getOpportunityTeamMemberPicklistEntries();
                Map<string,string> mapOpportunityTeamMemberPicklistbyLabel =  NEW  Map<string,string>();
                for(string  objTeamMember : mapOpportunityTeamMemberPicklist.keySet()){
                    mapOpportunityTeamMemberPicklistbyLabel.put(mapOpportunityTeamMemberPicklist.get(objTeamMember),objTeamMember);
                }
                List<FGM_Portal__PortalUserRequestTeamMembers__c> lstPortalUserMember = NEW  List<FGM_Portal__PortalUserRequestTeamMembers__c>();
                for(FGM_Portal__PortalUserRequestTeamMembers__c objTeamMember :  (List<FGM_Portal__PortalUserRequestTeamMembers__c>)scope){
                    if(mapOpportunityTeamMemberPicklistbyLabel.get(objTeamMember.FGM_Portal__UserRole__c) != NULL){
                        objTeamMember.FGM_Portal__UserRole__c = mapOpportunityTeamMemberPicklistbyLabel.get(objTeamMember.FGM_Portal__UserRole__c);
                        lstPortalUserMember.add(objTeamMember);
                    }
                }
                CrudFlsService.getInstance().assertUpdateable(lstPortalUserMember);
                Database.update(lstPortalUserMember);
            }
        }
        Catch(Exception ex)
        {
            System.debug('ex' + ex.getStackTraceString() + '' + ex.getMessage());
            Database.rollback(sp);
        }
    }
}