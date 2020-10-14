public with sharing class CommunitySecureMessageController{
    public Secure_Message__c secureMessage{ get; set;}
    public ActivityHistory lstActivity { get; set;}
    public List<User> userContact;
    public User user { get; set;}
    public String selCampaign { get; set;}
    public String selOpportunity { get; set;}
    public List<String> lstOpportunityTeamMember {get;set;}
    public List<Campaign> lstCampignOwner;
    public List<Contact> lstContact;
    public String portalLanguage{ get; set;}
    public List<SelectOption> lstOpportunity { get; set; }
    public List<SelectOption> lstSelectOpportunityTeamMember { get; set; }
    public SFDCEncoder ESAPI = new SFDCEncoder();
    public String strRequestCampaignField{get;set;}
    public Map<Id,String> mapCampaign;
    public String oppTeamMemberId;
    public CommunitySecureMessageController(){
        FCGlobal.UserSession userSession = FCGlobal.getUserSession(UserInfo.getUserId());
        portalLanguage = userSession.UserLanguage;
        secureMessage = new Secure_Message__c();
        lstContact= new List<Contact>();
        lstActivity = new ActivityHistory();
        lstSelectOpportunityTeamMember = new List<SelectOption>();
        lstCampignOwner = new List<Campaign>();
        strRequestCampaignField = 'CampaignID';
        FGM_Portal__GlobalPortalSettings__c globalSetting = FGM_Portal__GlobalPortalSettings__c.getOrgDefaults();
        if(globalSetting != null){
            if(globalSetting.FGM_Portal__Request_Campaign_Field_Name__c !=null && String.isNotBlank(globalSetting.FGM_Portal__Request_Campaign_Field_Name__c)){
                strRequestCampaignField = globalSetting.FGM_Portal__Request_Campaign_Field_Name__c;
             }
        }

        userContact = [
            SELECT
                ContactId,
                Email
            FROM User
            WHERE Id = :UserInfo.getUserId()
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

    }
    /************************************************************************************************************
Purpose: This method is used for getting campaign selected list.
Parameters: NA
Throws [Exceptions]: [optional]
Return : List<SelectOption>
*****************************************************************************************************************/
    //Code for Campaign Selectlist
    public List<SelectOption> getCampaignList(){
        mapCampaign = new Map<Id,String>();
        List<SelectOption> lstCampaignOptions = new List<SelectOption>();
        List<Campaign> lstCampaign = null;
        if(String.isNotBlank(strRequestCampaignField)){

            String sanitizedRequestCampaignField = strRequestCampaignField.replaceAll('[^0-9a-zA-Z_.]', '');

            lstCampaign =  new List<Campaign>((List<Campaign>)Database.query(''
                                                                             +'SELECT Id, Name, FGM_Portal__Email__c '
                                                                             +' FROM Campaign '
                                                                             +' WHERE ID in ( SELECT ' + sanitizedRequestCampaignField + ' FROM Opportunity ) '
                                                                             +' AND IsActive=true WITH SECURITY_ENFORCED Limit 10000'));

            if(lstCampaign != null && lstCampaign.size() > 0){
                lstCampaignOptions.add(new SelectOption('0','--SELECT--'));
                for(Campaign campaign :lstCampaign){
                    lstCampaignOptions.add(new SelectOption(campaign.id,campaign.name));
                    if(campaign.FGM_Portal__Email__c != null && campaign.FGM_Portal__Email__c != ''){
                        mapCampaign.put(campaign.Id,campaign.FGM_Portal__Email__c);
                    }
                }
                return lstCampaignOptions;
            }
        }
        return null;
    }
    /************************************************************************************************************
Purpose: This method is used for getting Opportunity Selected list.
Parameters: NA
Throws [Exceptions]: [optional]
Return : Void
*****************************************************************************************************************/
    public void getOppList(){
        String oppConatctId ;
        lstSelectOpportunityTeamMember = new List<SelectOption>();
        lstOpportunity = new List<SelectOption>();
        oppConatctId = userContact[0].Id;
        list<SelectOption> oppOptions = new List<SelectOption>();
        list<OpportunityTeamMember> lstOppTeamMember = null;

        String sanitizedRequestCampaignField = strRequestCampaignField.replaceAll('[^0-9a-zA-Z_.]', '');

        lstOppTeamMember = new list<OpportunityTeamMember>((List<OpportunityTeamMember>)Database.query('SELECT Id'
                                                                                                       + ', Name, OpportunityId, Opportunity.Name, UserId '
                                                                                                       + ' FROM OpportunityTeamMember '
                                                                                                       + ' WHERE UserId = :oppConatctId '
                                                                                                       + ' AND Opportunity.'+sanitizedRequestCampaignField+' = :selCampaign WITH SECURITY_ENFORCED'));

        if(lstOppTeamMember != null && lstOppTeamMember.size() > 0){
            lstOpportunity.add(new SelectOption('0','--SELECT--'));
            for(OpportunityTeamMember oppTeamMem :lstOppTeamMember){
                lstOpportunity.add(new SelectOption(oppTeamMem.OpportunityId,oppTeamMem.Opportunity.Name));
            }
        }
    }
    /************************************************************************************************************
Purpose: This method is used for getting Opportunity Team memeber in Select list.
Parameters: NA
Throws [Exceptions]: [optional]
Return : Void
*****************************************************************************************************************/
    public void getOppTeamMember(){
        lstSelectOpportunityTeamMember = new List<SelectOption>();
        lstOpportunityTeamMember = new List<String>();
        oppTeamMemberId = '';
        FCGlobal.WithoutSharing withoutSharing =  new FCGlobal.WithoutSharing();
        List<Opportunity> lstOpportunity = null;
        List<OpportunityTeamMember> lstOppTeamMember = null;
        Boolean isInternalUser = true;

        lstOpportunity = [
            SELECT
                CreatedById,
                Owner.Name,
                OwnerId
            FROM Opportunity
            WHERE Id = :selOpportunity
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

        if(lstOpportunity[0].OwnerId == lstOpportunity[0].CreatedById){
            isInternalUser = false;
        }

        if (!isInternalUser) {
            lstOppTeamMember = [
                SELECT
                    Name,
                    UserId
                FROM OpportunityTeamMember
                WHERE OpportunityId = :selOpportunity
                WITH SECURITY_ENFORCED
            ];
        } else {
            lstOppTeamMember = [
                SELECT
                    Name,
                    UserId
                FROM OpportunityTeamMember
                WHERE OpportunityId = :selOpportunity
                AND UserId != :lstOpportunity[0].OwnerId
                WITH SECURITY_ENFORCED
            ];
        }

        List<User> lstUsers = withoutSharing.getUserResult(new List<String> {lstOpportunity[0].OwnerId});
        if(lstOppTeamMember != null && lstOppTeamMember.Size() > 0){
            lstSelectOpportunityTeamMember = new List<SelectOption>();
            lstSelectOpportunityTeamMember.clear();
            for(OpportunityTeamMember teamMember :lstOppTeamMember){
                if(teamMember.UserId == userContact[0].Id) {
                    oppTeamMemberId = teamMember.Id;
                }
                lstSelectOpportunityTeamMember.add(new SelectOption(teamMember.UserId,teamMember.Name));
            }
            if(isInternalUser){
                lstSelectOpportunityTeamMember.add(new SelectOption(lstOpportunity[0].OwnerId, lstUsers[0].Name));//FCPROD-2153 Added a record in CC list to show Opportunity Owner in list irrespective of Team Member record.
            }
        }
    }
    /************************************************************************************************************
Purpose: This method is used for for encrypting ref id.
Parameters: String
Throws [Exceptions]: [Exception]
Return : String
*****************************************************************************************************************/
    public String encrypt(String refId){
        try{
            Blob cryptoKey = Blob.valueOf('380db410e8b11fa9');
            Blob relatedToId = Blob.valueOf(refId);
            Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey , relatedToId);
            return EncodingUtil.base64Encode(encryptedData);
        }
        catch(Exception ex){
            System.debug('Encryption Error : '+ ex.getMessage());
            return null;
        }
    }
    /************************************************************************************************************
Purpose: This method is used for Sending MAil and Creating Activity History in Contact.
Parameters: NA
Throws [Exceptions]: [EmailException,DMLException]
Return : PageReference
*****************************************************************************************************************/
    public PageReference sendEmail(){
        List<EmailServicesAddress> serviceAddress = new List<EmailServicesAddress>();
        List<String> lstTOEmailIds = new List<String>();
        List<String> lstCCEmailIds = new List<String>();
        Set<User> setUserContact = new Set<User>();
        String recipientEmail ='';
        String subject='';
        String activitybody='';
        String emailBody='';
        String response='' ;
        ID relatedTo;
        if(selCampaign == '0'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ESAPI.SFDC_HTMLENCODE(System.Label.FC_ComposeMessage_RequiredField_ErrorMsg)));
            return null;
        }
        if(selCampaign == null){
            return null;
        }
        if(selOpportunity == '0'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ESAPI.SFDC_HTMLENCODE(System.Label.FC_ComposeMessageRequiredRequest)));
            return null;
        }
        if(selOpportunity == null){
            return null;
        }
        if(!Test.isRunningTest()){

            serviceAddress = [
                SELECT
                    EmailDomainName,
                    IsActive,
                    LocalPart,
                    RunAsUserId
                FROM EmailServicesAddress
                WHERE LocalPart = 'inboxemailhandler'
                AND IsActive = TRUE
                LIMIT 1
            ];

        }
        if(oppTeamMemberId != null && oppTeamMemberId.length() >= 15){
            oppTeamMemberId = oppTeamMemberId.substring(0,15);
        }
        String encryptedRelatedTo = encrypt(oppTeamMemberId);
        if(secureMessage.Subject__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ESAPI.SFDC_HTMLENCODE(System.Label.FC_ComposeMessageRequiredSubject)));
            return null;
        }
        else{
            subject = secureMessage.Subject__c;
        }
        if(secureMessage.Body__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ESAPI.SFDC_HTMLENCODE(System.Label.FC_ComposeMessageRequiredEmailBody)));
            return null;
        }
        else{
            if(serviceAddress != null && !serviceAddress.isEmpty()){
                emailBody = secureMessage.Body__c + '<br/>' + '<br/>' + String.escapeSingleQuotes(System.Label.FC_GranteeInbox_BodyWarningText) + '<br/>' + 'ref:::' + encryptedRelatedTo + ':::';
                activitybody = secureMessage.Body__c.replaceall('\n','') + '<br/>' + '<br/>' + String.escapeSingleQuotes(System.Label.FC_GranteeInbox_BodyWarningText) + '<br/>' + 'ref:::' + encryptedRelatedTo + ':::';
            }
            else{
                emailBody = secureMessage.Body__c;
                activitybody = secureMessage.Body__c.replaceall('\n','');
            }
        }
        List<User> lstCCUser = new FCGlobal.WithoutSharing().getUserResult(lstOpportunityTeamMember);
        if(mapCampaign != null && mapCampaign.size() > 0 && mapCampaign.get(selCampaign) != null){
            lstTOEmailIds.add(mapCampaign.get(selCampaign));
        }
        if(lstCCUser != null && lstCCUser.size() > 0){
            for(User userTeamMem :lstCCUser){
                if(userTeamMem.Email != null && userTeamMem.Id != userContact[0].Id){
                    lstCCEmailIds.add(userTeamMem.Email);
                    setUserContact.add(userTeamMem);
                }
            }
        }
        setUserContact.add(userContact[0]);
        relatedTo = selOpportunity;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(lstTOEmailIds);
        mail.setCcAddresses(lstCCEmailIds);
        mail.setSubject(subject);
        mail.setHtmlBody(emailBody.replace('\r\n', '<br/>'));
        mail.setWhatId(relatedTo);
        mail.setTargetObjectId(userContact[0].ContactId);
        mail.setSaveAsActivity(false);
        if(serviceAddress != null && !serviceAddress.isEmpty()){
            mail.setReplyTo(serviceAddress[0].LocalPart + '@' + serviceAddress[0].EmailDomainName);
        }
        try{
            List<Task> lstActivityHistory = new List<Task>();
            for(User userCnt : setUserContact){
                Task actHist = new Task();
                actHist.OwnerId = userCnt.Id;
                actHist.Status = 'Completed';
                actHist.Subject = 'Email:'+ subject;
                actHist.WhoId = userCnt.ContactId;
                actHist.WhatId = relatedTo;
                actHist.FGM_Portal__ResponseBy__c = userContact[0].Id;
                actHist.ActivityDate =  Date.Today();
                actHist.Description = 'Body:' + activitybody;
                lstActivityHistory.add(actHist);
            }
            Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            if(resultMail[0].isSuccess()){
                //Creating Activity History
                AdminContextExecutionManager.executeInsert(lstActivityHistory);
                PageReference reRend;
                reRend = System.Page.CommunityDashboard;
                reRend.setRedirect(true);
                return reRend;
            }
            else{
                response = resultMail[0].getErrors().get(0).getMessage();
            }
        }
        catch(System.EmailException emailEx){
            System.debug('Exception : ' + emailEx.getDMLMessage(0));
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ESAPI.SFDC_HTMLENCODE(System.Label.FC_ComposeMessage_MsgSendingFail_ErrorMsg)));
        }
        catch(System.DMLException dmlEx){
            System.debug('Exception : ' + dmlEx.getDMLMessage(0));
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, dmlEx.getDMLMessage(0)));
        }
        return null;
    }
}