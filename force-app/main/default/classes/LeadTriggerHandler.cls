public with sharing class LeadTriggerHandler
{
    public static map<Id,Boolean> mapUserToIsPartner = new map<Id,Boolean>();
    public static void portalPermissionForConvertedOpportunity(List<Lead> lstLead)
    {
        try
        {   // the values that will come from trigger.new on lead conversion

            List<Lead> lstLeadConvertedLeads = [
                SELECT
                    ConvertedOpportunityId,
                    IsConverted
                FROM Lead
                WHERE Id IN :lstLead
                WITH SECURITY_ENFORCED
            ];

            List<Portal_Permission__c> lstPortalPermissions = [
                SELECT
                    Account__c,
                    Contact__c,
                    Grantee_Report__c,
                    Lead__c,
                    Name,
                    Opportunity__c,
                    OwnerId,
                    Portal_Account__c,
                    Portal_User__c
                FROM Portal_Permission__c
                WHERE Lead__c != null
                AND Lead__c IN :lstLeadConvertedLeads
                WITH SECURITY_ENFORCED
            ];

            List<FGM_Portal__Portal_Permission__c> lstPortalPermissionsToUpdate = new List<FGM_Portal__Portal_Permission__c>();

            if(lstPortalPermissions!=null){
                for(Lead convertedLead : lstLeadConvertedLeads){
                    if(convertedLead.IsConverted && convertedLead.ConvertedOpportunityId!=null ){
                        for(FGM_Portal__Portal_Permission__c permission : lstPortalPermissions){
                            if(permission.FGM_Portal__Lead__c == convertedLead.Id){
                                    permission.FGM_Portal__Opportunity__c = convertedLead.ConvertedOpportunityId;
                                    lstPortalPermissionsToUpdate.add(permission);
                            }
                        }
                    }
                }
                if(lstPortalPermissionsToUpdate!=null) {
                    CrudFlsService.getInstance().assertUpdateable(lstPortalPermissionsToUpdate);
                    update lstPortalPermissionsToUpdate;
                }
            }
        }
        catch(Exception ex)
        {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
        }
    }

    public static void AssignQuestionAttachmentsForConvertedOpportunity(List<Lead> lstLead)
    {
        try
        {

            List<Lead> lstLeadConvertedLeads = [
                SELECT
                    ConvertedAccountId,
                    ConvertedContactId,
                    ConvertedOpportunityId,
                    FGM_Base__Attachments_to_Request_on_Conversion__c,
                    IsConverted
                FROM Lead
                WHERE Id IN :lstLead
                WITH SECURITY_ENFORCED
            ];

            List <Question_Attachment__c> lstQuestionAttachments = [
                SELECT
                    Amendment__c,
                    Benchmark_del__c,
                    Description__c,
                    GranteeReport__c,
                    Inquiry__c,
                    Name,
                    Opportunity__c,
                    Question__c,
                    (
                        SELECT
                            BodyLength,
                            ContentType,
                            CreatedDate,
                            Description,
                            Name
                        FROM Attachments
                    ),
                    (
                        SELECT
                            ContentDocumentId,
                            LinkedEntityId
                        FROM ContentDocumentLinks
                    )
                FROM Question_Attachment__c
                WHERE Inquiry__c IN :lstLead
                WITH SECURITY_ENFORCED
            ];

            List <FGM_Portal__Question_Attachment__c> lstQusetionAttachmentToBeUpserted = new List <FGM_Portal__Question_Attachment__c>();
            List<Id> lstConvertedContactId = new List<Id>();
            if(lstLeadConvertedLeads!=null && !lstLeadConvertedLeads.isEmpty())
                for(Lead convertedLead : lstLeadConvertedLeads){
                if(convertedLead.IsConverted && convertedLead.ConvertedOpportunityId!=null && convertedLead.FGM_Base__Attachments_to_Request_on_Conversion__c && convertedLead.ConvertedContactId!=null)
                {
                    lstConvertedContactId.add(convertedLead.ConvertedContactId);
                    if(lstQuestionAttachments != null && !lstQuestionAttachments.isEmpty())
                        for(FGM_Portal__Question_Attachment__c  questionAttachment : lstQuestionAttachments){
                        if(!questionAttachment.Attachments.isEmpty() || !questionAttachment.ContentDocumentLinks.isEmpty()){
                                questionAttachment.FGM_Portal__Opportunity__c = convertedLead.ConvertedOpportunityId;
                                lstQusetionAttachmentToBeUpserted.add(questionAttachment);
                        }
                    }
                }
            }
            if(lstQusetionAttachmentToBeUpserted!=null && !lstQusetionAttachmentToBeUpserted.isEmpty()) {
                CrudFlsService.getInstance().assertUpdateable(lstQusetionAttachmentToBeUpserted);
                upsert lstQusetionAttachmentToBeUpserted;
            }

            List<Attachment> lstConvertedContactAttachents = [
                SELECT
                    Body,
                    BodyLength,
                    ContentType,
                    CreatedById,
                    Description,
                    IsPrivate,
                    Name,
                    OwnerId,
                    ParentId
                FROM Attachment
                WHERE ParentId IN :lstConvertedContactId
                WITH SECURITY_ENFORCED
            ];

            if(lstConvertedContactAttachents != null && !lstConvertedContactAttachents.isEmpty()){
                CrudFlsService.getInstance().assertDeletable(lstConvertedContactAttachents);
                delete lstConvertedContactAttachents;
            }
        }
        catch(Exception ex)
        {
            System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
        }
    }

    public static void updtOppsPostLeadCnvrsn( )
    {
        String strCustomCampaignField = SchemaEngine.getCampaignLookupField( 'opportunity' );
        String strOppCampaignField = ( strCustomCampaignField != null ) ? strCustomCampaignField : 'CampaignId';
        strCustomCampaignField = SchemaEngine.getCampaignLookupField( 'lead' );

        updateOpportunities(trigger.newMap.keySet(), strCustomCampaignField, strOppCampaignField );
        // update the opportunities with Campaign lookup fields
    }
    static void updateOpportunities( Set<Id> setLeadIds, String strLOICampaignField, String strOppCstmCmpgnFld )
    {
        try
        {
            if( setLeadIds != null && !setLeadIds.isEmpty() )
            {
                Map<Id, Id> mapOppIdWthCmpgnId = new Map<Id, Id>();
                Map<Id, Boolean> mapCntctIdWthPrtnrUsrSts = new Map<Id, Boolean>();
                Map<Id, Boolean> mapUsrIdWthPrtnrUsrSts = new Map<Id, Boolean>();
                Set<Id> setLeadIdsToProcess = new Set<Id>();

                Map<Id, Profile> mapProfileIds = new Map<Id, Profile>([
                    SELECT UserLicenseId
                    FROM Profile
                    WHERE UserLicenseId IN (
                        SELECT Id
                        FROM UserLicense
                        WHERE Name LIKE '%Partner Community%'
                    )
                    WITH SECURITY_ENFORCED
                    LIMIT 100
                ]);

                if( strLOICampaignField != null )
                {
                    String sanitizedLOICampaignField = strLOICampaignField.replaceAll('[^0-9a-zA-Z_.]', '');

                    String strQuery = 'SELECT Id, ' + sanitizedLOICampaignField + ', ConvertedOpportunityId, OwnerId, FGM_Base__Submitted_By__c FROM Lead WHERE Id IN :setLeadIds AND ConvertedOpportunityId != null AND ' + sanitizedLOICampaignField + ' != null WITH SECURITY_ENFORCED';
                    List<sObject> lstSobjLeads = Database.query( strQuery );
                    for( Lead leadRec : (List<Lead>) lstSobjLeads )
                    {
                        if( leadRec.FGM_Base__Submitted_By__c != null )
                            mapCntctIdWthPrtnrUsrSts.put( leadRec.FGM_Base__Submitted_By__c, false );
                        mapUsrIdWthPrtnrUsrSts.put( leadRec.OwnerId, false );
                    }
                    if( !mapCntctIdWthPrtnrUsrSts.isEmpty() )
                    {

                        for (User actvPrtnrUsr : [
                            SELECT ContactId
                            FROM User
                            WHERE IsActive = TRUE
                            AND ContactId IN :mapCntctIdWthPrtnrUsrSts.keySet()
                            AND (
                                UserProfile__c = 'Grantee'
                                OR UserProfile__c = 'Grantee;Reviewer'
                                OR UserProfile__c = 'Reviewer;Grantee'
                            )
                            AND ProfileId IN :mapProfileIds.keyset()
                            WITH SECURITY_ENFORCED
                        ]) {
                            mapCntctIdWthPrtnrUsrSts.put(
                                actvPrtnrUsr.ContactId,
                                true
                            );
                        }

                        for( Lead leadRec : (List<Lead>) lstSobjLeads )
                        {
                            if( leadRec.FGM_Base__Submitted_By__c != null && mapCntctIdWthPrtnrUsrSts.get( leadRec.FGM_Base__Submitted_By__c ) == true )
                            {
                                mapOppIdWthCmpgnId.put( (Id)leadRec.get('ConvertedOpportunityId'), (Id)leadRec.get(strLOICampaignField) );
                                setLeadIdsToProcess.add( (Id)leadRec.get('Id') );
                            }
                        }
                    }
                    if( !mapUsrIdWthPrtnrUsrSts.isEmpty() )
                    {

                        for (User actvPrtnrUsr : [
                            SELECT Id
                            FROM User
                            WHERE IsActive = TRUE
                            AND ContactId != null
                            AND Id IN :mapUsrIdWthPrtnrUsrSts.keySet()
                            AND (
                                UserProfile__c = 'Grantee'
                                OR UserProfile__c = 'Grantee;Reviewer'
                                OR UserProfile__c = 'Reviewer;Grantee'
                            )
                            AND ProfileId IN :mapProfileIds.keyset()
                            WITH SECURITY_ENFORCED
                        ]) {
                            mapUsrIdWthPrtnrUsrSts.put(actvPrtnrUsr.Id, true);
                        }


                        for( Lead leadRec : (List<Lead>) lstSobjLeads )
                        {
                            if( mapUsrIdWthPrtnrUsrSts.get( leadRec.OwnerId ) == true )
                            {
                                mapOppIdWthCmpgnId.put( (Id)leadRec.get('ConvertedOpportunityId'), (Id)leadRec.get(strLOICampaignField) );
                                setLeadIdsToProcess.add( (Id)leadRec.get('Id') );
                            }
                        }
                    }
                }
                else
                {

                    List<Lead> lstLeads = [
                        SELECT
                            FGM_Base__Submitted_By__c,
                            OwnerId
                        FROM Lead
                        WHERE Id IN :setLeadIds
                        AND ConvertedOpportunityId != null
                        WITH SECURITY_ENFORCED
                    ];

                    for( Lead leadRec : lstLeads )
                    {
                        if( leadRec.FGM_Base__Submitted_By__c != null )
                            mapCntctIdWthPrtnrUsrSts.put( leadRec.FGM_Base__Submitted_By__c, false );
                        mapUsrIdWthPrtnrUsrSts.put( leadRec.OwnerId, false );
                    }
                    if( !mapCntctIdWthPrtnrUsrSts.isEmpty() )
                    {

                        for (User actvPrtnrUsr : [
                            SELECT ContactId
                            FROM User
                            WHERE IsActive = TRUE
                            AND ContactId IN :mapCntctIdWthPrtnrUsrSts.keySet()
                            AND (
                                UserProfile__c = 'Grantee'
                                OR UserProfile__c = 'Grantee;Reviewer'
                                OR UserProfile__c = 'Reviewer;Grantee'
                            )
                            AND ProfileId IN :mapProfileIds.keyset()
                            WITH SECURITY_ENFORCED
                        ]) {
                            mapCntctIdWthPrtnrUsrSts.put(actvPrtnrUsr.ContactId, true);
                        }

                    }
                    if( !mapUsrIdWthPrtnrUsrSts.isEmpty() )
                    {

                        for (User actvPrtnrUsr : [
                            SELECT Id
                            FROM User
                            WHERE IsActive = TRUE
                            AND ContactId != null
                            AND Id IN :mapUsrIdWthPrtnrUsrSts.keySet()
                            AND (
                                UserProfile__c = 'Grantee'
                                OR UserProfile__c = 'Grantee;Reviewer'
                                OR UserProfile__c = 'Reviewer;Grantee'
                            )
                            AND ProfileId IN :mapProfileIds.keyset()
                            WITH SECURITY_ENFORCED
                        ]) {
                            mapUsrIdWthPrtnrUsrSts.put(actvPrtnrUsr.Id, true);
                        }

                    }
                    Map<Id, Boolean> mapLeadIdRltdToPrtnrUsr = new Map<Id, Boolean>();
                    for( Lead leadRec : lstLeads )
                    {
                        if( leadRec.FGM_Base__Submitted_By__c != null && !mapCntctIdWthPrtnrUsrSts.isEmpty() && mapCntctIdWthPrtnrUsrSts.get( leadRec.FGM_Base__Submitted_By__c ) == true )
                            mapLeadIdRltdToPrtnrUsr.put( leadRec.Id, true );
                        if( !mapUsrIdWthPrtnrUsrSts.isEmpty() && mapUsrIdWthPrtnrUsrSts.get( leadRec.OwnerId ) == true )
                            mapLeadIdRltdToPrtnrUsr.put( leadRec.Id, true );
                    }

                    List<CampaignMember> lstCampaignMembers = [
                        SELECT
                            CampaignId,
                            Lead.ConvertedOpportunityId,
                            LeadId
                        FROM CampaignMember
                        WHERE LeadId IN :setLeadIds
                        AND Lead.ConvertedOpportunityId != null
                        WITH SECURITY_ENFORCED
                    ];

                    for( CampaignMember campMem : lstCampaignMembers )
                    {
                        if( !mapLeadIdRltdToPrtnrUsr.isEmpty() && mapLeadIdRltdToPrtnrUsr.get( campMem.LeadId ) == true )
                        {
                            mapOppIdWthCmpgnId.put( campMem.Lead.ConvertedOpportunityId, campMem.CampaignId );
                            setLeadIdsToProcess.add( campMem.LeadId );
                        }
                    }
                }

                mapUserToIsPartner = mapUsrIdWthPrtnrUsrSts;
                if( !mapOppIdWthCmpgnId.isEmpty() && !mapOppIdWthCmpgnId.keySet().isEmpty() )
                {
                    String sanitizedOppCstmCmpgnFld = strOppCstmCmpgnFld.replaceAll('[^0-9a-zA-Z_.]', '');

                    String strQuery = 'SELECT Id, ' + sanitizedOppCstmCmpgnFld ;
                    if(string.isNotBlank(strOppCstmCmpgnFld) && !strOppCstmCmpgnFld.equalsIgnoreCase('campaignID'))
                        strQuery += ', campaignID';
                    Set<Id> oppIdWithCmpgnIdKeys = mapOppIdWthCmpgnId.keySet();
                    strQuery += ' FROM Opportunity WHERE Id IN :oppIdWithCmpgnIdKeys WITH SECURITY_ENFORCED';
                    List<sObject> lstOpportunities = Database.query(strQuery);

                    for( Opportunity oppRec : (List<Opportunity>) lstOpportunities )
                    {
                        if(string.isNotBlank(strOppCstmCmpgnFld) && !strOppCstmCmpgnFld.equalsIgnoreCase('campaignID') )
                        {
                            oppRec.put( strOppCstmCmpgnFld, oppRec.get('campaignID'));
                            oppRec.put( 'campaignID', '' );
                        }
                        else
                            oppRec.put( strOppCstmCmpgnFld, (Id)mapOppIdWthCmpgnId.get( (Id)oppRec.get( 'Id' ) ) );
                    }
                    CrudFlsService.getInstance().assertUpdateable(lstOpportunities);
                    update lstOpportunities;
                    // create Opportunity Team Members and update Opportunity Shares with Read / Write Access
                    crtOppTeamMembersAndOppShares( setLeadIdsToProcess );
                }
            }
        }
        catch( Exception ex )
        {
            system.debug('Exception: ' + ex.getMessage() + '; at line number: ' + ex.getLineNumber());
        }
    }
    static void crtOppTeamMembersAndOppShares( Set<Id> setLeadIds )
    {
        try
        {
            List<Schema.PicklistEntry> lstopportunityTeamMemberPicklist = Schema.getGlobalDescribe().get('OpportunityTeamMember').newSObject().getSObjectType().getDescribe().fields.getMap().get('TeamMemberRole').getDescribe().getPickListValues();

            if( setLeadIds != null && !setLeadIds.isEmpty() )
            {
                List<OpportunityTeamMember> lstOppTeamMembers = new List<OpportunityTeamMember>();
                Map<Id, Id> mapCntctIdWthUsrId = new Map<Id, Id>();

                for (Lead leadRec : [
                    SELECT FGM_Base__Submitted_By__c
                    FROM Lead
                    WHERE Id IN :setLeadIds
                    WITH SECURITY_ENFORCED
                ]) {
                    mapCntctIdWthUsrId.put(
                        leadRec.FGM_Base__Submitted_By__c,
                        leadRec.FGM_Base__Submitted_By__c
                    );
                }

                for (User userRec : [
                    SELECT ContactId
                    FROM User
                    WHERE ContactId IN :mapCntctIdWthUsrId.keySet()
                    WITH SECURITY_ENFORCED
                ]) {
                    mapCntctIdWthUsrId.put(userRec.ContactId, userRec.Id);
                }

                for (Lead leadRec : [
                    SELECT
                        ConvertedOpportunityId,
                        FGM_Base__Submitted_By__c,
                        OwnerId
                    FROM Lead
                    WHERE Id IN :setLeadIds
                    WITH SECURITY_ENFORCED
                ]) {
                    if(mapUserToIsPartner.get(leadRec.OwnerId)!=null && mapUserToIsPartner.get(leadRec.OwnerId))
                    {
                        OpportunityTeamMember opportunityTeamMember = new OpportunityTeamMember();
                            opportunityTeamMember.OpportunityAccessLevel = 'Edit';
                            opportunityTeamMember.OpportunityId = leadRec.ConvertedOpportunityId;
                            opportunityTeamMember.TeamMemberRole = lstopportunityTeamMemberPicklist[0].getValue();
                            opportunityTeamMember.UserId = leadRec.OwnerId;
                            lstOppTeamMembers.add(opportunityTeamMember);
                    }

                    if( leadRec.FGM_Base__Submitted_By__c != null && mapCntctIdWthUsrId.get( leadRec.FGM_Base__Submitted_By__c ) != leadRec.OwnerId )
                    {
                        OpportunityTeamMember opportunityTeamMemberSub = new OpportunityTeamMember();
                        opportunityTeamMemberSub.OpportunityAccessLevel = 'Edit';
                        opportunityTeamMemberSub.OpportunityId = leadRec.ConvertedOpportunityId;
                        opportunityTeamMemberSub.TeamMemberRole = lstopportunityTeamMemberPicklist[0].getValue();
                        opportunityTeamMemberSub.UserId = mapCntctIdWthUsrId.get( leadRec.FGM_Base__Submitted_By__c );
                        lstOppTeamMembers.add( opportunityTeamMemberSub );
                    }
                }
                if( !lstOppTeamMembers.isEmpty() )
                {
                    CrudFlsService.getInstance().assertCreateable(lstOppTeamMembers);
                    insert lstOppTeamMembers;

                    Set<Id> setUserIds = new Set<Id>();
                    for( OpportunityTeamMember opportunityTeamMember : lstOppTeamMembers )
                        setUserIds.add( opportunityTeamMember.UserId );

                    Map<Id, User> mapUserIdWithUserDetails = new Map<Id, User>([
                        SELECT ContactId
                        FROM User
                        WHERE Id IN :setUserIds
                        AND ContactId != null
                        WITH SECURITY_ENFORCED
                    ]);

                    if( !mapUserIdWithUserDetails.isEmpty() )
                    {
                        List<OpportunityContactRole> lstOppContactRoles = new List<OpportunityContactRole>();
                        Set<Id> setContactIds = new Set<Id>();
                        map<Id,OpportunityContactRole> mapopportunityTeamMemberContactRole = new map<Id,OpportunityContactRole>();
                        for( OpportunityTeamMember opportunityTeamMember : lstOppTeamMembers )
                        {
                            if( mapUserIdWithUserDetails.get( opportunityTeamMember.UserId ) != null )
                            {
                                OpportunityContactRole opportunityContactRole = new OpportunityContactRole();
                                    opportunityContactRole.ContactId = mapUserIdWithUserDetails.get( opportunityTeamMember.UserId ).ContactId;
                                    opportunityContactRole.OpportunityId = opportunityTeamMember.OpportunityId;
                                    if(!SchemaEngine.getDefaultOpportunityContactRole().isDefaultValue())
                                    {
                                        mapopportunityTeamMemberContactRole.put(opportunityTeamMember.id,opportunityContactRole);
                                    }
                                    opportunityContactRole.Role = SchemaEngine.getDefaultOpportunityContactRole().getValue();
                                    if( !setContactIds.contains( opportunityContactRole.ContactId ) )
                                    {
                                        lstOppContactRoles.add( opportunityContactRole );
                                        setContactIds.add( opportunityContactRole.ContactId );
                                    }
                            }
                        }
                        if( !lstOppContactRoles.isEmpty() ) {
                            CrudFlsService.getInstance().assertCreateable(lstOppContactRoles);
                            insert lstOppContactRoles;
                        }

                        map<Id,String> mapContactRole = new map<Id,String>();
                        OpportunityContactRole ocrContact;
                        List<OpportunityTeamMember> lstopportunityTeamMemberwithOCRid ;
                        List<OpportunityTeamMember> lstopportunityTeamMemberToUpdate = new List<OpportunityTeamMember>();

                        for(OpportunityContactRole ocr :lstOppContactRoles)
                        {
                            mapContactRole.put(ocr.Id,ocr.ContactId);
                        }

                        if (!mapopportunityTeamMemberContactRole.keySet().isEmpty() && mapopportunityTeamMemberContactRole.keySet()!= null) {

                            lstopportunityTeamMemberwithOCRid = [
                                SELECT ContactRoleID__c
                                FROM OpportunityTeamMember
                                WHERE Id IN :mapopportunityTeamMemberContactRole.keySet()
                                WITH SECURITY_ENFORCED
                            ];

                        }

                        if(lstopportunityTeamMemberwithOCRid!=null && !lstopportunityTeamMemberwithOCRid.isEmpty())
                        {
                            for(OpportunityTeamMember opportunityTeamMember : lstopportunityTeamMemberwithOCRid)
                            {
                                ocrContact = new OpportunityContactRole();
                                ocrContact = mapopportunityTeamMemberContactRole.get(opportunityTeamMember.id);
                                opportunityTeamMember.ContactRoleID__c = ocrContact.Id;
                                lstopportunityTeamMemberToUpdate.add(opportunityTeamMember);
                            }
                        }
                        if(!lstopportunityTeamMemberToUpdate.isEmpty()) {
                            CrudFlsService.getInstance().assertUpdateable(lstopportunityTeamMemberToUpdate);
                            update lstopportunityTeamMemberToUpdate;
                        }
                        // delete contacts created as byproduct of lead conversion process
                        delContactRoles( setLeadIds,mapContactRole );
                    }
                }
            }
        }
        catch( Exception ex )
        {
            system.debug('Exception: ' + ex.getMessage() + '; at line number: ' + ex.getLineNumber());
        }
    }
    static void delContactRoles( Set<Id> setLeadIds,map<Id,String> mapContactRole)
    {
        try
        {
            if( setLeadIds != null && !setLeadIds.isEmpty() )
            {
                Set<Id> setContactIds = new Set<Id>();
                List<OpportunityContactRole> lstContactsRoleToDel;
                List<OpportunityContactRole> lstDeleteContactRoles = new List<OpportunityContactRole>();
                Boolean defaultRole = SchemaEngine.getDefaultOpportunityContactRole().isDefaultValue();

                for (Lead leadRec : [
                    SELECT ConvertedContactId
                    FROM Lead
                    WHERE Id IN :setLeadIds
                    WITH SECURITY_ENFORCED
                ]) {
                    setContactIds.add(leadRec.ConvertedContactId);
                }

                if(defaultRole) {

                    lstContactsRoleToDel = [
                        SELECT
                            ContactId,
                            Role
                        FROM OpportunityContactRole
                        WHERE ContactId IN :setContactIds
                        WITH SECURITY_ENFORCED
                    ];

                } else {

                    lstContactsRoleToDel = [
                        SELECT
                            ContactId,
                            Role
                        FROM OpportunityContactRole
                        WHERE Role = ''
                        AND ContactId IN :setContactIds
                        WITH SECURITY_ENFORCED
                    ];

                }
                for(OpportunityContactRole ocr :lstContactsRoleToDel)
                {
                    if(!mapContactRole.keyset().contains(ocr.Id))
                        lstDeleteContactRoles.add(ocr);
                }
                CrudFlsService.getInstance().assertDeletable(lstDeleteContactRoles);
                delete lstDeleteContactRoles;
            }
        }
        catch( Exception ex )
        {
            system.debug('Exception: ' + ex.getMessage() + '; at line number: ' + ex.getLineNumber());
        }
    }
}