public class OnPortalApplication
{
    //For Deletion of QuestionAttachment related to the Opportunity
    public static void getQuestionAttachmentForDelete(List<Opportunity> lstOpportunity)
    {
        if(lstOpportunity != null && lstOpportunity.size() > 0){
            Set<ID> setOpportunityId = new Set<ID>();
            for(Opportunity opp: lstOpportunity)
            {
                setOpportunityId.add(opp.id);
            }

            List<Question_Attachment__c> lstQuestionAttachmentRecords = [
                SELECT Id
                FROM Question_Attachment__c
                WHERE Opportunity__c IN :setOpportunityId
                WITH SECURITY_ENFORCED
            ];


            if(lstQuestionAttachmentRecords != null && lstQuestionAttachmentRecords.size() > 0){
                CrudFlsService.getInstance().assertDeletable(lstQuestionAttachmentRecords);
                delete lstQuestionAttachmentRecords;
            }
        }
    }
    //For Deletion of QuestionAttachment related to Lead
    public static void questionAttachmentForDeleteBeforeLead(List<Lead> lstLead)
    {
        if(lstLead != null && lstLead.size() > 0)
        {
            Set<ID> setlstLeadId = new Set<ID>();
            for(Lead lead: lstLead)
            {
                setlstLeadId.add(lead.id);
            }


            List<Question_Attachment__c> lstQuestionAttachmentRecords = [
                SELECT Id
                FROM Question_Attachment__c
                WHERE Inquiry__c IN :setlstLeadId
                WITH SECURITY_ENFORCED
            ];


            if(lstQuestionAttachmentRecords != null && lstQuestionAttachmentRecords.size() > 0){
                CrudFlsService.getInstance().assertDeletable(lstQuestionAttachmentRecords);
                delete lstQuestionAttachmentRecords;

            }
        }
    }
    //For Deletion of QuestionAttachment related to Grantee Report
    public static void questionAttachmentForDeleteBeforeGranteeReport(List<FGM_Base__Grantee_Report__c> lstGranteeReport)
    {
        if(lstGranteeReport != null && lstGranteeReport.size() > 0)
        {
            Set<ID> setlstGranteeReportId = new Set<ID>();
            for(FGM_Base__Grantee_Report__c granteeReport: lstGranteeReport)
            {
                setlstGranteeReportId.add(granteeReport.id);
            }

            List<Question_Attachment__c> lstQuestionAttachmentRecords = [
                SELECT Id
                FROM Question_Attachment__c
                WHERE GranteeReport__c IN :setlstGranteeReportId
                WITH SECURITY_ENFORCED
            ];

            if(lstQuestionAttachmentRecords != null && lstQuestionAttachmentRecords.size() > 0){
                CrudFlsService.getInstance().assertDeletable(lstQuestionAttachmentRecords);
                delete lstQuestionAttachmentRecords;
            }
        }

    }
    //For Deletion of Relatedlist Tab
    public static void getRLCTabForDelete(List<FGM_Portal__Related_List_Controller__c> lstRLCTab)
    {
        set<string> setRLCTab = new set<string>();
        for(FGM_Portal__Related_List_Controller__c tabRLC : lstRLCTab)
        {
            setRLCTab.add(tabRLC.id);
        }

        if(lstRLCTab != null && lstRLCTab[0] != null)
        {

            List<Related_List_Controller__c>  delRLTab = [
                SELECT Name
                FROM Related_List_Controller__c
                WHERE Id IN :setRLCTab
                OR Parent_RLCTabID__c IN :setRLCTab
                WITH SECURITY_ENFORCED
            ];

            CrudFlsService.getInstance().assertDeletable(delRLTab);
            delete delRLTab;
        }
    }

    //For Deletion of Quiz Question and related Question
    public static void getQuizQuestionForDelete(List<FGM_Portal__Quiz_Questions__c> lstQuizQuestions){
        if(lstQuizQuestions != null && lstQuizQuestions[0] != null){

            List<Quiz_Questions__c> delQuizQuestion = [
                SELECT Name
                FROM Quiz_Questions__c
                WHERE Parent_QuizQuestionID__c =: lstQuizQuestions[0].Id
                WITH SECURITY_ENFORCED
            ];

            CrudFlsService.getInstance().assertDeletable(delQuizQuestion);
            delete delQuizQuestion;
        }
    }

    public static void getSecureMessageBeforeInsert(List<Secure_Message__c> lstSecureMsg)
    {
        for(Secure_Message__c secureMessage : lstSecureMsg)
        {
            if (secureMessage == null)
                continue;
            else
            {
                secureMessage.Sender__c = UserInfo.getUserId();
                secureMessage.OwnerId =  UserInfo.getUserId();
            }
        }
    }

    //Assign existing account to Portal User while registration
    public static void assignExistingAccount(List<FGM_Portal__Portal_User__c> lstPortalUser)
    {
        if(lstPortalUser != null && !lstPortalUser.isEmpty())
        {

            List<Account> lstAllAccount = [
                SELECT Name
                FROM Account
                WHERE Name = :lstPortalUser[0].Organization_Legal_Name__c
                AND FGM_Base__EIN__c =: lstPortalUser[0].EIN__c
                WITH SECURITY_ENFORCED
            ];

            if(lstAllAccount != null && lstAllAccount.size() != 0)
            {
                if(lstPortalUser[0].Account__c == null && lstPortalUser[0].FGM_Portal__ProfileType__c != 'Individual')
                    lstPortalUser[0].Account__c = lstAllAccount[0].Id;
            }
        }
    }

    //Create OpportunityTeamMember on User Activation
    public static void createOppotunityTeamMember(List<FGM_Portal__Portal_User__c> lstNewPortalUser,Map<Id,FGM_Portal__Portal_User__c> mapOldPortalUser, List<User> lstCommunityUser){
        List<OpportunityTeamMember> lstOTMToUpdate =new List<OpportunityTeamMember>();
        List<OpportunityTeamMember> lstOTMwithOCRid;
        List<OpportunityContactRole> lstOpportunityContactRole = new List<OpportunityContactRole>();
        map<Id,OpportunityContactRole> mapOtmContactRole = new map<Id,OpportunityContactRole>();
        if(lstNewPortalUser != null  && mapOldPortalUser != null && !mapOldPortalUser.isEmpty()){
            FGM_Portal__GlobalPortalSettings__c GlobalSettings = FGM_Portal__GlobalPortalSettings__c.getInstance();
            string strapplicationOwnerRole = GlobalSettings.Application_Ownership_Role__c;
            Set<String> setapplicationOwnerRole=FCGlobal.getApplicationOwnerRoleSet(strapplicationOwnerRole);
            if(strapplicationOwnerRole == null || String.isBlank(strapplicationOwnerRole))
                setapplicationOwnerRole.add('Applicant');

            List<PortalUserRequestTeamMembers__c> lstPortalUserRequestTeamMembers = [
                SELECT
                    IsShared__c,
                    PortalUser__c,
                    SharedRequest__c,
                    UserRole__c
                FROM PortalUserRequestTeamMembers__c
                WHERE PortalUser__r.IsCreatedByOpportunityTeamMember__c = TRUE
                AND IsShared__c = FALSE
                AND PortalUser__r.Contact__c != null
                AND PortalUser__r.Account__c != null
                AND PortalUser__r.Email__c != null
                WITH SECURITY_ENFORCED
                LIMIT 10000
            ];

            map<id,list<FGM_Portal__PortalUserRequestTeamMembers__c>> mapNewPortalTeamMember = new map<id,list<FGM_Portal__PortalUserRequestTeamMembers__c>>();
            for(FGM_Portal__PortalUserRequestTeamMembers__c newportalRequestTeamMember:lstPortalUserRequestTeamMembers){
                list<FGM_Portal__PortalUserRequestTeamMembers__c> lstPortalTeamMember;
                if( mapNewPortalTeamMember != null && mapNewPortalTeamMember.get(newportalRequestTeamMember.FGM_Portal__PortalUser__c) != null)
                    lstPortalTeamMember = mapNewPortalTeamMember.get(newportalRequestTeamMember.FGM_Portal__PortalUser__c);
                else
                    lstPortalTeamMember = new list<FGM_Portal__PortalUserRequestTeamMembers__c>();
                lstPortalTeamMember.add(newportalRequestTeamMember);
                mapNewPortalTeamMember.put(newportalRequestTeamMember.FGM_Portal__PortalUser__c, lstPortalTeamMember);
            }
            lstPortalUserRequestTeamMembers.clear();
            if(lstNewPortalUser[0].FGM_Portal__Contact__c != null && lstNewPortalUser[0].Account__c != null && lstNewPortalUser[0].FGM_Portal__Email__c != null && lstNewPortalUser[0].IsCreatedByOpportunityTeamMember__c){
                if(mapOldPortalUser.get(lstNewPortalUser[0].Id).FGM_Portal__Contact__c == null){
                    lstPortalUserRequestTeamMembers = mapNewPortalTeamMember.get(lstNewPortalUser[0].Id);
                    if(lstPortalUserRequestTeamMembers != null && lstPortalUserRequestTeamMembers.size() > 0 ){
                        List<User> portalUserRecord = new List<User>();

                        if (lstCommunityUser != null) {
                            portalUserRecord.add(lstCommunityUser[0]);
                        } else {

                            portalUserRecord = [
                                SELECT AccountId
                                FROM User
                                WHERE ContactId = :lstNewPortalUser[0].FGM_Portal__Contact__c
                                AND AccountId = :lstNewPortalUser[0].FGM_Portal__Account__c
                                AND Email = :lstNewPortalUser[0].FGM_Portal__Email__c
                                WITH SECURITY_ENFORCED
                            ];

                        }

                        if(portalUserRecord != null && !portalUserRecord.isEmpty() && portalUserRecord.size() == 1){
                            List<OpportunityTeamMember> lstOpportunityMember = new List<OpportunityTeamMember>();
                            MAP<ID,ID> mapOpportunitywiseUser=new MAP<ID,ID>();
                            OpportunityTeamMember newOpportunityTeamMember = null;
                            OpportunityContactRole newOpportunityContactRole = null;
                            for(PortalUserRequestTeamMembers__c portalUserMembers : lstPortalUserRequestTeamMembers){
                                mapOpportunitywiseUser.put(portalUserMembers.SharedRequest__c,portalUserRecord [0].Id);
                                    newOpportunityTeamMember = new OpportunityTeamMember();
                                    newOpportunityTeamMember.OpportunityId = portalUserMembers.SharedRequest__c;
                                    newOpportunityTeamMember.UserId = portalUserRecord [0].Id;
                                    newOpportunityTeamMember.TeamMemberRole = portalUserMembers.UserRole__c;
                                    portalUserMembers.IsShared__c = true;
                                    lstOpportunityMember.add(newOpportunityTeamMember);
                                    //Included for reporting
                                    newOpportunityContactRole = new OpportunityContactRole();
                                    newOpportunityContactRole.ContactId = lstNewPortalUser[0].FGM_Portal__Contact__c;
                                    newOpportunityContactRole.OpportunityId = portalUserMembers.SharedRequest__c;
                                    newOpportunityContactRole.Role = SchemaEngine.getDefaultOpportunityContactRole().getValue();
                                    lstOpportunityContactRole.add(newOpportunityContactRole);
                                if(!string.isBlank(portalUserMembers.UserRole__c) && setapplicationOwnerRole.contains(portalUserMembers.UserRole__c)){
                                    Set<String> setConsultantStatus = new Set<String>();
                                    if(String.isNotBlank(GlobalSettings.StatusofwithdrawConsultantAccess__c))
                                        setConsultantStatus.addAll(GlobalSettings.StatusofwithdrawConsultantAccess__c.split(';'));
                                    if(GlobalSettings != null && setConsultantStatus != null && setConsultantStatus.size() > 0 && !setConsultantStatus.isEmpty()){

                                        Opportunity sharedOpportunity = [
                                            SELECT
                                                OwnerId,
                                                StageName
                                            FROM Opportunity
                                            WHERE Id = :portalUserMembers.SharedRequest__c
                                            WITH SECURITY_ENFORCED
                                            LIMIT 1
                                        ];

                                        if(sharedOpportunity != null && setConsultantStatus.contains(sharedOpportunity.StageName)){
                                                sharedOpportunity.FGM_Portal__ConsultantUser__c  = sharedOpportunity.OwnerId;
                                                sharedOpportunity.OwnerId = portalUserRecord [0].Id;
                                                sharedOpportunity.AccountId = portalUserRecord [0].AccountId;
                                                CrudFlsService.getInstance().assertUpdateable(sharedOpportunity);
                                                update sharedOpportunity;
                                        }
                                    }
                                }
                            }
                            List<OpportunityShare> lstsharesToUpdate=new List<OpportunityShare>();
                            if(lstOpportunityMember != null && !lstOpportunityMember.isEmpty() && lstOpportunityContactRole!=null && !lstOpportunityContactRole.isEmpty()){
                                CrudFlsService.getInstance().assertCreateable(lstOpportunityMember);
                                List<Database.SaveResult> ResultlstOpportunityMember = Database.insert(lstOpportunityMember);
                                CrudFlsService.getInstance().assertUpdateable(lstPortalUserRequestTeamMembers);
                                Database.update(lstPortalUserRequestTeamMembers);
                                CrudFlsService.getInstance().assertCreateable(lstOpportunityContactRole);
                                Database.insert(lstOpportunityContactRole);

                                if(!SchemaEngine.getDefaultOpportunityContactRole().isDefaultValue()){
                                    lstOpportunityMember[0].ContactRoleID__c = lstOpportunityContactRole[0].Id;
                                    AdminContextExecutionManager.executeUpdate(lstOpportunityMember);
                                }
                            }

                            List<OpportunityShare> lstshares = [
                                SELECT
                                    OpportunityAccessLevel,
                                    OpportunityId,
                                    RowCause,
                                    UserOrGroupId
                                FROM OpportunityShare
                                WHERE OpportunityId IN :mapOpportunitywiseUser.keySet()
                                AND RowCause = 'Team'
                                WITH SECURITY_ENFORCED
                                LIMIT 1000
                            ];

                            for (OpportunityShare share : lstshares){
                                if( mapOpportunitywiseUser.get(share.OpportunityId ) == share.UserOrGroupId){
                                    share.OpportunityAccessLevel = 'Edit';
                                    lstsharesToUpdate.add(share);
                                }
                            }
                            CrudFlsService.getInstance().assertUpdateable(lstsharesToUpdate);
                            Database.update(lstsharesToUpdate);
                        }
                    }
                }
            }
        }

    }


    // Change the owner of Opportunity From consultant
    public static void changeOwnerFromConsultant(Map<Id,Opportunity> mapUpdatedOppotunity)
    {
        try
        {
            FGM_Portal__GlobalPortalSettings__c GlobalSettings = FGM_Portal__GlobalPortalSettings__c.getInstance();
            string strapplicationOwnerRole = GlobalSettings.Application_Ownership_Role__c;
            Set<String> setapplicationOwnerRole = FCGlobal.getApplicationOwnerRoleSet(strapplicationOwnerRole);

            if(strapplicationOwnerRole == null || String.isBlank(strapplicationOwnerRole))
                setapplicationOwnerRole.add('Applicant');

            Set<String> setConsultantStatus = new Set<String>();
            if(String.isNotBlank(GlobalSettings.StatusofwithdrawConsultantAccess__c))
            {
                setConsultantStatus.addAll(GlobalSettings.StatusofwithdrawConsultantAccess__c.split(';'));
            }
            if(GlobalSettings != null && setConsultantStatus != null && setConsultantStatus.size() > 0 && !setConsultantStatus.isEmpty())
            {
                Set<Id> setChangeOpportunity = new Set<Id>();
                for(Opportunity changeOppRecord : mapUpdatedOppotunity.values())
                {
                    if(setConsultantStatus.contains(changeOppRecord.StageName))
                        setChangeOpportunity.add(changeOppRecord.Id);
                }
                if(setChangeOpportunity != null && setChangeOpportunity.size() > 0)
                {

                    List<PortalUserRequestTeamMembers__c> lstPortalUserRequestTeamMembers = [
                        SELECT
                            IsShared__c,
                            PortalUser__r.Name,
                            SharedRequest__c,
                            SharedRequest__r.ConsultantUser__c,
                            SharedRequest__r.OwnerId,
                            UserRole__c
                        FROM PortalUserRequestTeamMembers__c
                        WHERE UserRole__c != null
                        AND PortalUser__c != null
                        AND SharedRequest__c IN :setChangeOpportunity
                        AND SharedRequest__r.ConsultantUser__c = null
                        WITH SECURITY_ENFORCED
                        LIMIT 10000
                    ];

                    if(lstPortalUserRequestTeamMembers != null && lstPortalUserRequestTeamMembers.size() > 0)
                    {
                        Map<String,FGM_Portal__PortalUserRequestTeamMembers__c> mapPortalUserReqTeamMem = new map<String,FGM_Portal__PortalUserRequestTeamMembers__c>();
                        for(FGM_Portal__PortalUserRequestTeamMembers__c portalUserMember : lstPortalUserRequestTeamMembers)
                        {
                            if(string.isNotBlank(portalUserMember.UserRole__c) && setapplicationOwnerRole.contains(portalUserMember.FGM_Portal__UserRole__c))
                                mapPortalUserReqTeamMem.put((portalUserMember.FGM_Portal__PortalUser__r.Name).trim(), portalUserMember);
                        }
                        if(mapPortalUserReqTeamMem != null && mapPortalUserReqTeamMem.size() > 0)
                        {

                            List<User> userRecord = [
                                SELECT
                                    Contact.AccountId,
                                    Username
                                FROM User
                                WHERE Username IN :mapPortalUserReqTeamMem.keySet()
                                AND IsActive = TRUE
                                WITH SECURITY_ENFORCED
                            ];

                            if(userRecord != null && userRecord.size() > 0)
                            {
                                List<FGM_Portal__PortalUserRequestTeamMembers__c> lstUserRequestMember = new List<FGM_Portal__PortalUserRequestTeamMembers__c>();
                                for(User user : userRecord)
                                {
                                    String username = (user.Username).trim();
                                    if(mapPortalUserReqTeamMem.get(username) != null && mapPortalUserReqTeamMem.get(username).FGM_Portal__SharedRequest__r.OwnerId != user.Id)
                                    {
                                        Id oppId = mapPortalUserReqTeamMem.get(username).FGM_Portal__SharedRequest__c;
                                        mapUpdatedOppotunity.get(oppId).FGM_Portal__ConsultantUser__c = mapPortalUserReqTeamMem.get(username).FGM_Portal__SharedRequest__r.OwnerId;
                                        mapUpdatedOppotunity.get(oppId).OwnerId = user.Id;
                                        mapUpdatedOppotunity.get(oppId).AccountId = user.Contact.AccountId;
                                        FGM_Portal__PortalUserRequestTeamMembers__c userRequestMember = new FGM_Portal__PortalUserRequestTeamMembers__c(Id = mapPortalUserReqTeamMem.get(username).Id , FGM_Portal__IsShared__c = true);
                                        lstUserRequestMember.add(userRequestMember);
                                    }
                                }
                                CrudFlsService.getInstance().assertUpdateable(lstUserRequestMember);
                                update lstUserRequestMember;
                            }
                        }
                    }
                }
            }
        }
        catch(Exception ex){
            System.debug('**Exception on ChangeOwnerFromConsultant :: ' + ex.getMessage());
        }
    }

    // Delete the Related List Tab when quiz is deleted
    public static void deleteTabs(List<FGM_Portal__Quiz__c> lstQuiz)
    {
        if(lstQuiz != null && !lstQuiz.isEmpty())
        {
            List<Id> lstQuizRecords = new List<Id>();
            for (FGM_Portal__Quiz__c quizRecord: lstQuiz)
            {
                if(quizRecord.Id != null)
                    lstQuizRecords.add(quizRecord.Id);
            }
            if(lstQuizRecords.isEmpty())
                return;

            List<Related_List_Controller__c> lstRLCRecords = [
                SELECT Id
                FROM Related_List_Controller__c
                WHERE Quiz__c IN :lstQuizRecords
                WITH SECURITY_ENFORCED
            ];

            if(lstRLCRecords != null && !lstRLCRecords .isEmpty()){
                CrudFlsService.getInstance().assertDeletable(lstRLCRecords);
                delete lstRLCRecords;
            }
        }
    }

    //To delete the Quiz Question when tab deleted
    public static void deleteQuizQuestion(List<FGM_Portal__Related_List_Controller__c > lstTabs){
        if(lstTabs != null && !lstTabs.isEmpty()){

            List<Quiz_Questions__c> lstQuizQuestions = [
                SELECT Id
                FROM Quiz_Questions__c
                WHERE Tab__c IN :lstTabs
                WITH SECURITY_ENFORCED
            ];

            if(lstQuizQuestions  != null && !lstQuizQuestions.isEmpty()){
                CrudFlsService.getInstance().assertDeletable(lstQuizQuestions);
                delete lstQuizQuestions;
            }
        }
    }
    //Delete ContactRole after deletion of opportunity Team Member
    public static void removeContactRoles(List<OpportunityTeamMember> lstOpportunityTeam){
        List<Id> lstContactRoleId = new List<Id>();
        for(OpportunityTeamMember objOpportunityTeamMember : lstOpportunityTeam)
            lstContactRoleId.add(objOpportunityTeamMember.FGM_Portal__ContactRoleID__c);

        List<OpportunityContactRole> lstContactRole = [
            SELECT Id
            FROM OpportunityContactRole
            WHERE Id IN :lstContactRoleId
            WITH SECURITY_ENFORCED
        ];

        CrudFlsService.getInstance().assertDeletable(lstContactRole);
        delete lstContactRole;
    }

    //To confirm Before delete that IS FGM_Portal__Grantee_Budget_Configuration__c is used by other grantee budget line item
    public static void confirmBudgetConfigurationIsInUse(Set<Id> setConfiguration,Boolean isDelete)
    {
        if(!setConfiguration.isEmpty()){

            Integer iCount = [
                SELECT COUNT()
                FROM Grantee_Budget_Line_Item__c
                WHERE Budget_Configuration__c IN :setConfiguration
                WITH SECURITY_ENFORCED
            ];

            if(iCount > 0)
            {
                if(isDelete)
                    Trigger.old[0].addError('This Category already in use,You cannot delete this record. ');
                else
                    Trigger.new[0].addError('This Category already in use,You cannot modify this record. ');
            }
        }
    }

    // To confirm Before delete that Is Category is used by any Grantee Line Item
    public static void confirmCategoryIsUsedInLineItem(Set<Id> setCategory)
    {
        if(!setCategory.isEmpty())
        {

            Integer iCount = [
                SELECT COUNT()
                FROM Grantee_Budget_Line_Item__c
                Where Category__c IN :setCategory
                WITH SECURITY_ENFORCED
            ];

            if(iCount > 0)
                Trigger.old[0].addError('This Category already in use,You cannot delete this record. ');
        }
    }

    // To Create record of OTM if Opportunity owner is Portal User or opp owner changed to portal user
    public static void createOTMRecord(Map<Id,Opportunity> mapNewOpp ,Map<Id,Opportunity> mapOldOpp)
    {
        try{

            List<Lead> lstLead = [
                SELECT
                    ConvertedOpportunityId,
                    IsConverted
                FROM Lead
                WHERE ConvertedOpportunityId IN :mapNewOpp.keySet()
                AND IsConverted = FALSE
                WITH SECURITY_ENFORCED
            ];

            String strUserId = UserInfo.getUserId();

            User currentUser = [
                SELECT
                    ContactId,
                    UserProfile__c
                FROM User
                WHERE Id = :strUserId
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            if(String.isEmpty(currentUser.ContactId))
            {
                    set<Id> setUsrId = new set<id>();
                    List<OpportunityShare> lstOppShare = new List<OpportunityShare>();
                    Set<OpportunityContactRole> setContactRole = new Set<OpportunityContactRole>();
                    map<Id,OpportunityShare> mapUserIdAndOppShare = new map<Id,OpportunityShare>();
                    map<id,OpportunityTeamMember> mapOtmToInsert = new map<id,OpportunityTeamMember>();
                    map<id,List<OpportunityTeamMember>> mapOppIdAndOtm = new map<id,List<OpportunityTeamMember>>();
                    List<Schema.PicklistEntry> lstOTMPicklist = Schema.getGlobalDescribe().get('OpportunityTeamMember').newSObject().getSObjectType().getDescribe().fields.getMap().get('TeamMemberRole').getDescribe().getPickListValues();

                    for(opportunity opp : mapNewOpp.values())
                        setUsrId.add(opp.OwnerId);

                    Map<Id, User> mapUser = new Map<Id, User>([
                        SELECT ContactId
                        FROM User
                        WHERE (
                            Id IN :setUsrId
                            AND ContactId != null
                        )
                        WITH SECURITY_ENFORCED
                        LIMIT 10000
                    ]);

                    if(trigger.isInsert && !lstLead.isEmpty()) //if condition to avoid creation of OCR if opp is by lead conversion process (to avoid duplicate value of ocr i.e ocr is created in LeadTriggerHandler
                    {
                        for(Id oppId : mapNewOpp.keySet())
                        {
                            if(mapUser.keySet().contains(mapNewOpp.get(oppId).OwnerId))
                            {
                                OpportunityTeamMember teamMember = new OpportunityTeamMember();
                                teamMember.OpportunityId = oppId;
                                teamMember.UserId = mapNewOpp.get(oppId).OwnerId;
                                teamMember.TeamMemberRole = lstOTMPicklist[0].getValue();
                                if(!mapOppIdAndOtm.containsKey(oppId))
                                    mapOppIdAndOtm.put(oppId,new List<OpportunityTeamMember> {teamMember});
                                else
                                {
                                    List<OpportunityTeamMember> lstOtm = new List<OpportunityTeamMember>();
                                    lstOtm = mapOppIdAndOtm.get(oppId);
                                    lstOtm.add(teamMember);
                                    mapOppIdAndOtm.put(oppId,lstOtm);
                                }
                                mapOtmToInsert.put(oppId,teamMember);
                                OpportunityContactRole contactRole = new OpportunityContactRole();
                                    contactRole.ContactId = mapUser.get(mapNewOpp.get(oppId).OwnerId).contactId;
                                    contactRole.Role = SchemaEngine.getDefaultOpportunityContactRole().getValue();
                                    contactRole.OpportunityId = oppId;
                                    contactRole.IsPrimary = true;
                                    setContactRole.add(contactRole);
                            }
                        }
                    }
                    if(trigger.isUpdate)
                    {
                        set<Id> setUsrContactId = new set<Id>();

                        List<OpportunityShare> lstOppShares = [
                            SELECT
                                OpportunityAccessLevel,
                                RowCause,
                                UserOrGroupId
                            FROM OpportunityShare
                            WHERE OpportunityId IN :mapNewOpp.keySet()
                            WITH SECURITY_ENFORCED
                            LIMIT 10000
                        ];


                        if(!lstOppShares.isEmpty())
                            for(OpportunityShare oppShare : lstOppShares)
                            mapUserIdAndOppShare.put(oppShare.UserOrGroupId, oppShare);

                        Map<Id, OpportunityTeamMember> mapOTM = new Map<Id, OpportunityTeamMember>([
                            SELECT
                                OpportunityId,
                                UserId
                            FROM OpportunityTeamMember
                            WHERE OpportunityId IN :mapNewOpp.keySet()
                            WITH SECURITY_ENFORCED
                            LIMIT 10000
                        ]);

                        if(!mapOTM.isEmpty())
                        {
                            for(OpportunityTeamMember otm : mapOTM.values())
                            {
                                if(mapOppIdAndOtm.containsKey(otm.OpportunityId))
                                {
                                    List<OpportunityTeamMember> lstOtm = new List<OpportunityTeamMember>(mapOppIdAndOtm.get(otm.OpportunityId));
                                    lstOtm.add(otm);
                                    mapOppIdAndOtm.put(otm.OpportunityId,lstOtm);
                                }
                                else
                                {
                                    List<OpportunityTeamMember> lstOtm = new List<OpportunityTeamMember>();
                                    lstOtm.add(otm);
                                    mapOppIdAndOtm.put(otm.OpportunityId,lstOtm);
                                }
                            }
                        }

                        if(!mapUser.isEmpty())
                        {
                            for(User usr : mapUser.Values())
                            {
                                setUsrContactId.add(usr.contactId);
                            }
                        }
                        map<id,OpportunityContactRole> mapOppContRole = new map<id,OpportunityContactRole>();
                        if(!setUsrContactId.isEmpty())
                        {

                            mapOppContRole.putAll([
                                SELECT
                                    ContactId,
                                    IsPrimary,
                                    OpportunityId,
                                    Role
                                FROM OpportunityContactRole
                                WHERE OpportunityId IN :mapNewOpp.keySet()
                                WITH SECURITY_ENFORCED
                                LIMIT 10000
                            ]);

                        }
                        map<ID, List<OpportunityContactRole>> mapOppIdAndOppContRole = new map<ID,List<OpportunityContactRole>>();
                        if(!mapOppContRole.isEmpty())
                        {
                            for(OpportunityContactRole contactRole : mapOppContRole.values())
                            {
                                if(!mapOppIdAndOppContRole.containsKey(contactRole.OpportunityId))
                                    mapOppIdAndOppContRole.put(contactRole.OpportunityId,new List<OpportunityContactRole>{contactRole});
                                else
                                {
                                    List<OpportunityContactRole> lstContRole = new List<OpportunityContactRole>();
                                    lstContRole = mapOppIdAndOppContRole.get(contactRole.OpportunityId);
                                    lstContRole.add(contactRole);
                                    mapOppIdAndOppContRole.put(contactRole.OpportunityId,lstContRole);
                                }
                            }
                        }
                        for(Id oppId : mapNewOpp.keySet())
                        {
                            if(mapNewOpp.get(oppId).OwnerId != mapOldOpp.get(oppId).OwnerId && setUsrId.contains(mapNewOpp.get(oppId).OwnerId))
                            {
                                boolean isOtmExist = false;
                                if(!mapOppIdAndOtm.isEmpty())
                                    for(OpportunityTeamMember otm  : mapOppIdAndOtm.get(oppId))
                                {
                                    OpportunityShare oppShare = new OpportunityShare();
                                    if(otm.UserId ==  mapOldOpp.get(oppId).OwnerId){
                                        oppShare = mapUserIdAndOppShare.get(mapOldOpp.get(oppId).OwnerId);
                                        if(oppShare.OpportunityAccessLevel == 'Owner'){
                                                oppShare.OpportunityAccessLevel = 'Edit';
                                        }
                                        lstOppShare.add(oppShare);
                                    }
                                }

                                if(!isOtmExist){
                                    OpportunityTeamMember teamMember = new OpportunityTeamMember();
                                    teamMember.OpportunityId = oppId;
                                    teamMember.UserId = mapNewOpp.get(oppId).OwnerId;
                                    teamMember.TeamMemberRole = lstOTMPicklist[0].getValue();
                                    if(!mapOppIdAndOtm.containsKey(oppId))
                                        mapOppIdAndOtm.put(oppId,new List<OpportunityTeamMember> {teamMember});
                                    else
                                    {
                                        List<OpportunityTeamMember> lstOtm = new List<OpportunityTeamMember>();
                                        lstOtm = mapOppIdAndOtm.get(oppId);
                                        lstOtm.add(teamMember);
                                        mapOppIdAndOtm.put(oppId,lstOtm);
                                    }
                                    mapOtmToInsert.put(oppId,teamMember);
                                    mapOtmToInsert.put(oppId,teamMember);
                                    OpportunityShare oppShare = new OpportunityShare();
                                    oppShare.OpportunityId = oppId;
                                }
                                boolean isOcr = false ;
                                if(!mapOppIdAndOppContRole.isEmpty())
                                {
                                    for(OpportunityContactRole ocr :  mapOppIdAndOppContRole.get(oppId))
                                    {
                                        if(ocr.ContactId == mapUser.get(mapNewOpp.get(oppId).OwnerId).ContactId &&  ocr.Role == SchemaEngine.getDefaultOpportunityContactRole().getValue())
                                        {
                                            ocr.IsPrimary = true;
                                            setContactRole.add(ocr);
                                            isOcr = true;
                                        }
                                    }
                                    if(!isOcr && mapUser.get(mapNewOpp.get(oppId).OwnerId) != null)
                                    {
                                        OpportunityContactRole contactRole = new OpportunityContactRole();
                                        contactRole.ContactId = mapUser.get(mapNewOpp.get(oppId).OwnerId).contactId;
                                        contactRole.Role = SchemaEngine.getDefaultOpportunityContactRole().getValue();
                                        contactRole.OpportunityId = oppId;
                                        contactRole.IsPrimary = true;
                                        setContactRole.add(contactRole);
                                        isOcr = true ;
                                    }
                                }
                                else if(mapUser.get(mapNewOpp.get(oppId).OwnerId) != null)
                                {
                                    OpportunityContactRole contactRole = new OpportunityContactRole();
                                    contactRole.ContactId = mapUser.get(mapNewOpp.get(oppId).OwnerId).contactId;
                                    contactRole.Role = SchemaEngine.getDefaultOpportunityContactRole().getValue();
                                    contactRole.OpportunityId = oppId;
                                    contactRole.IsPrimary = true;
                                    setContactRole.add(contactRole);
                                }
                            }
                        }
                    }

                    List<OpportunityContactRole> lstocr = new List<OpportunityContactRole>(setContactRole);
                    CrudflsService.getInstance().assertUpdateable(lstocr);
                    Database.UpsertResult[] saveResultContactRole =  Database.upsert(lstocr);

                    for(OpportunityContactRole ocr : setContactRole)
                    {
                        if(mapUser.get(mapOppIdAndOtm.get(ocr.OpportunityId)[mapOppIdAndOtm.get(ocr.OpportunityId).indexOf(mapOtmToInsert.get(ocr.OpportunityId))].UserId).ContactID == ocr.ContactId)
                        {
                            mapOtmToInsert.get(ocr.OpportunityId).FGM_Portal__ContactRoleID__c = ocr.id;
                        }
                    }
                    CrudFlsService.getInstance().assertUpdateable(mapOtmToInsert.values());
                    Database.UpsertResult[] saveResultOtm =  Database.upsert(mapOtmToInsert.values());
                    Set<Id> SetUserId = new Set<Id>();
                    for(Opportunity opp : mapNewOpp.values())
                    {
                        SetUserId.add(opp.OwnerId);
                    }

                    List<OpportunityShare> lstOppSharesTeam = [
                        SELECT
                            OpportunityAccessLevel,
                            RowCause,
                            UserOrGroupId
                        FROM OpportunityShare
                        WHERE OpportunityId IN :mapNewOpp.keySet()
                        AND (
                            UserOrGroupId IN :SetUserId
                            AND RowCause = 'Team'
                        )
                        WITH SECURITY_ENFORCED
                        LIMIT 10000
                    ];

                    for(OpportunityShare oppShare : lstOppSharesTeam)
                    {
                        if(lstOppShare.contains(oppShare))
                            lstOppShare[lstOppShare.indexOf(oppShare)].OpportunityAccessLevel = 'All';
                        else
                        {
                            oppShare.OpportunityAccessLevel = 'All';
                            lstOppShare.add(oppShare);
                        }
                    }
                    CrudFlsService.getInstance().assertUpdateable(lstOppShare);
                    Database.UpsertResult[] saveResultOppShare =  Database.upsert(lstOppShare);
            }

            }
            catch(Exception ex)
            {
                System.debug(' Exception ' + ex.getMessage() + '  @Line ' + ex.getLineNumber() + ' Cause : ' + ex.getStackTraceString());
            }

        }
    }