global with sharing class InboxEmailHandler implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env){
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        string refId = null;
        if(email.plainTextBody != null && email.plainTextBody != ''){
            string plainTextBody  = email.plainTextBody.substringAfter('ref:::');
            plainTextBody  = plainTextBody.substringBefore(':::').trim();
            if(plainTextBody != null && plainTextBody != '')
                refId  = decrypt(plainTextBody);
        }
        Set<String> setEmailIds = new Set<String>();
        if(email.toAddresses != null){
            for(String emailId : email.toAddresses)
                setEmailIds.add(emailId);
        }

        if(email.ccAddresses != null){
            for(String emailId : email.ccAddresses)
                setEmailIds.add(emailId);
            setEmailIds.add(env.fromAddress);
        }

        if(setEmailIds != null && setEmailIds.size() > 0 && refId != null){
            List<OpportunityTeamMember> lstOppTeamMember;

            List<OpportunityTeamMember> lstOpportunity = [
                SELECT
                    OpportunityId,
                    User.ContactId,
                    User.Email,
                    User.Name,
                    UserId
                FROM OpportunityTeamMember
                WHERE Id = :refId
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            if(lstOpportunity != null && lstOpportunity.size() > 0){

                lstOppTeamMember = [
                    SELECT
                        OpportunityId,
                        User.ContactId,
                        User.Email,
                        User.Name,
                        UserId
                    FROM OpportunityTeamMember
                    WHERE OpportunityId = :lstOpportunity[0].OpportunityId
                    AND User.IsActive = TRUE
                    AND (
                        User.Email IN :setEmailIds
                        OR User.ContactId = :lstOpportunity[0].User.ContactId
                    )
                    WITH SECURITY_ENFORCED
                ];

                if(lstOppTeamMember != null && lstOppTeamMember.size() > 0){
                    String responseBy = null;
                    String body = '';
                    Integer countRespondent = 0;
                    for(OpportunityTeamMember teamMember : lstOppTeamMember){
                        if(teamMember.User.Email == email.fromAddress){
                            countRespondent ++;
                            responseBy = teamMember.UserId;
                        }
                    }
                    if(countRespondent > 1){
                        body = 'Respondent: ' + email.fromName + '\n';
                        body = body + 'Respondent Email: ' + email.fromAddress + '\n';
                        responseBy = null;
                    }
                    else if(countRespondent == 0){

                        List<User> lstUsers = [
                            SELECT
                                Email,
                                Name
                            FROM User
                            WHERE Email = :email.fromAddress
                            WITH SECURITY_ENFORCED
                        ];

                        if(lstUsers != null && lstUsers.size() == 1)
                            responseBy = lstUsers[0].Id;
                        else{
                            body = 'Respondent: ' + email.fromName + '\n';
                            body = body + 'Respondent Email: ' + email.fromAddress + '\n';
                            responseBy = null;
                        }
                    }

                    List<Task> lstActivityHistory = new List<Task>();
                    for(OpportunityTeamMember oppTeamMem : lstOppTeamMember){
                        Task actHist = new Task();
                        actHist.OwnerId = oppTeamMem.UserId;
                        actHist.Status = 'Completed';
                        actHist.Subject = 'Email: '+email.subject;
                        actHist.WhoId = oppTeamMem.User.ContactId;
                        actHist.WhatId = oppTeamMem.OpportunityId;
                        actHist.ActivityDate =  Date.Today();
                        actHist.Description = body + 'Body: ' + email.htmlBody;
                        actHist.FGM_Portal__ResponseBy__c = responseBy;
                        lstActivityHistory.add(actHist);
                    }
                    String replyTo = lstOppTeamMember[0].User.Email;
                    if(!setEmailIds.contains(replyTo) && !(env.fromAddress).equals(replyTo)){
                        try{
                            String emailThreadRef = (email.references[0]).removeStart('<');
                            emailThreadRef = emailThreadRef.removeEnd('>');
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setToAddresses(new List<String>{replyTo});
                            mail.setSubject(email.subject);
                            mail.setHtmlBody(email.htmlBody);
                            mail.setReferences(emailThreadRef);
                            mail.setSaveAsActivity(false);
                            Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        }
                        catch(System.EmailException ex){
                            system.debug(ex.getMessage());
                        }
                    }
                        CrudFlsService.getInstance().assertCreateable(lstActivityHistory);
                        insert lstActivityHistory;
                }
            }
        }
        result.success = true;
        return result;
    }
    public String decrypt(String refId){
        try{
            Blob cryptoKey = Blob.valueOf('380db410e8b11fa9');
            Blob encryptedRefId = EncodingUtil.base64Decode(refId);
            Blob decrypted = Crypto.decryptWithManagedIV('AES128', cryptoKey, encryptedRefId );
            String decryptedString = decrypted.toString();
            return decryptedString;
        }
        catch(Exception ex){
            System.debug('Decryption Error : '+ ex.getMessage());
            return null;
        }
    }
}