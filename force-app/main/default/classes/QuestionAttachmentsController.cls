public with sharing class QuestionAttachmentsController
{
    public List<Question_Attachment__c> LstQstnAttchmnts { get; set; }
    public List<QuestionAttachmentRecord> lstQuestionAttachments {get;set;}
    //public string AttachmentTypeString {get;set;} //not used
    public string FeedAttachmentTypeString {get;set;}
    public integer total_attachment {get;set;}
    public String varAssignmentId {get;set;}
    public Id URLId {get;set;}
    public Map<id,integer> mapQuestionCount {get;set;}
    public integer total_Feedattachment {get;set;}
    public Questions__c ObjQuestion {get;set;}
    public map<String,Integer> mapAttachCount{get;set;}
    public map<Id,String> mapQuestionName {get;set;}
    Set<Id> setParentId;
    List<ContentDocument> lstAllContentDocument {get;set;}
    map<id, List<ContentDocument>> mapQAContentDocument {get;set;}
    map<id,id> mapContentDocidQAid {get;set;}

    public QuestionAttachmentsController extension {
        get {
            return this;
        }
    }
    
    public QuestionAttachmentsController(ApexPages.StandardController con)
    {
        mapQuestionCount=new Map<id,integer>();
        mapAttachCount = new map<String,Integer>();
        URLId=con.getId();

        try
        {
            if(URLId.getSobjectType()==Opportunity.getSobjectType() && con.getId() !=null) {

                LstQstnAttchmnts = [
                    SELECT
                        CreatedBy.Name,
                        Name,
                        Question__c,
                        Question__r.Name,
                        Question__r.Parent_QuestionID__c,
                        Question__r.RichQuestion__c,
                        (
                            SELECT
                                ContentType,
                                CreatedBy.Name,
                                LastModifiedDate,
                                Name
                            FROM Attachments
                        ),
                        (
                            SELECT
                                Body,
                                CreatedBy.Name,
                                CreatedDate,
                                LastModifiedDate,
                                ParentId,
                                RelatedRecordId,
                                Title,
                                Type
                            FROM Feeds
                        )
                    FROM Question_Attachment__c
                    WHERE Opportunity__c = :con.getId()
                    WITH SECURITY_ENFORCED
                ];

            } else if(URLId.getSobjectType()==Account.getSobjectType() && con.getId() !=null) {

                List<Lead> lstConvertedLeads = [
                    SELECT
                        Company,
                        ConvertedAccountId,
                        FGM_Base__Attachments_to_Request_on_Conversion__c,
                        FirstName,
                        IsConverted,
                        LastName,
                        Name,
                        Status
                    FROM Lead
                    WHERE IsConverted = TRUE
                    AND FGM_Base__Attachments_to_Request_on_Conversion__c = FALSE
                    AND ConvertedAccountId = :con.getId()
                    WITH SECURITY_ENFORCED
                    LIMIT 1000
                ];

                if (!lstConvertedLeads.isEmpty()) {

                    LstQstnAttchmnts = [
                        SELECT
                            Name,
                            CreatedBy.Name,
                            Question__r.RichQuestion__c,
                            Question__c,
                            Question__r.Parent_QuestionID__c,
                            Question__r.Name,
                            (
                                SELECT
                                    LastModifiedDate,
                                    CreatedBy.Name,
                                    Name,
                                    ContentType
                                FROM Attachments
                            ),
                            (
                                SELECT
                                    ParentId,
                                    Title,
                                    Type,
                                    CreatedBy.Name,
                                    CreatedDate,
                                    LastModifiedDate,
                                    Body,
                                    RelatedRecordId
                                FROM Feeds
                            )
                        FROM Question_Attachment__c
                        WHERE Inquiry__c IN :lstConvertedLeads
                        AND Question__c != null
                        WITH SECURITY_ENFORCED
                        LIMIT 1000
                    ];

                }
            } else if(URLId.getSobjectType()==Lead.getSobjectType() && con.getId() !=null ) {

                LstQstnAttchmnts = [
                    SELECT
                        Name,
                        CreatedBy.Name,
                        Question__r.RichQuestion__c,
                        Question__c,
                        Question__r.Parent_QuestionID__c,
                        Question__r.Name,
                        (
                            SELECT
                                LastModifiedDate,
                                CreatedBy.Name,
                                Name,
                                ContentType
                            FROM Attachments
                        ),
                        (
                            SELECT
                                ParentId,
                                Title,
                                Type,
                                CreatedBy.Name,
                                CreatedDate,
                                LastModifiedDate,
                                Body,
                                RelatedRecordId
                            FROM Feeds
                        )
                    FROM Question_Attachment__c
                    WHERE Inquiry__c = :con.getId()
                    WITH SECURITY_ENFORCED
                ];

            } else if(URLId.getSobjectType()==FGM_Base__Grantee_Report__c.getSobjectType() && con.getId() !=null) {

                LstQstnAttchmnts = [
                    SELECT
                        Name,
                        CreatedBy.Name,
                        Question__r.RichQuestion__c,
                        Question__c,
                        Question__r.Parent_QuestionID__c,
                        Question__r.Name,
                        (
                            SELECT
                                LastModifiedDate,
                                CreatedBy.Name,
                                Name,
                                ContentType
                            FROM Attachments
                        ),
                        (
                            SELECT
                                ParentId,
                                Title,
                                Type,
                                CreatedBy.Name,
                                CreatedDate,
                                LastModifiedDate,
                                Body,
                                RelatedRecordId
                            FROM Feeds
                        )
                    FROM Question_Attachment__c
                    WHERE GranteeReport__c = :con.getId()
                    WITH SECURITY_ENFORCED
                ];

            } else if(URLId.getSobjectType()==FGM_Base__Benchmark__c.getSobjectType() && con.getId() !=null) {

                LstQstnAttchmnts = [
                    SELECT
                        Name,
                        CreatedBy.Name,
                        Question__r.RichQuestion__c,
                        Question__c,
                        Question__r.Parent_QuestionID__c,
                        Question__r.Name,
                        (
                            SELECT
                                LastModifiedDate,
                                CreatedBy.Name,
                                Name,
                                ContentType
                            FROM Attachments
                        ),
                        (
                            SELECT
                                ParentId,
                                Title,
                                Type,
                                CreatedBy.Name,
                                CreatedDate,
                                LastModifiedDate,
                                Body,
                                RelatedRecordId
                            FROM Feeds
                        )
                    FROM Question_Attachment__c
                    WHERE Benchmark_del__c = :con.getId()
                    WITH SECURITY_ENFORCED
                ];

            } else if(URLId.getSobjectType()==Amendment__c.getSobjectType() && con.getId() !=null) {

                LstQstnAttchmnts = [
                    SELECT
                        Name,
                        CreatedBy.Name,
                        Question__r.RichQuestion__c,
                        Question__c,
                        Question__r.Parent_QuestionID__c,
                        Question__r.Name,
                        (
                            SELECT
                                LastModifiedDate,
                                CreatedBy.Name,
                                Name,
                                ContentType
                            FROM Attachments
                        ),
                        (
                            SELECT
                                ParentId,
                                Title,
                                Type,
                                CreatedBy.Name,
                                CreatedDate,
                                LastModifiedDate,
                                Body,
                                RelatedRecordId
                            FROM Feeds
                        )
                    FROM Question_Attachment__c
                    WHERE Amendment__c = :con.getId()
                    WITH SECURITY_ENFORCED
                ];

            } else if(URLId.getSobjectType()==Recommendation__c.getSobjectType() && con.getId() !=null) {

                LstQstnAttchmnts = [
                    SELECT
                        Name,
                        CreatedBy.Name,
                        Question__r.RichQuestion__c,
                        Question__c,
                        Question__r.Parent_QuestionID__c,
                        Question__r.Name,
                        (
                            SELECT
                                LastModifiedDate,
                                CreatedBy.Name,
                                Name,
                                ContentType
                            FROM Attachments
                        ),
                        (
                            SELECT
                                ParentId,
                                Title,
                                Type,
                                CreatedBy.Name,
                                CreatedDate,
                                LastModifiedDate,
                                Body,
                                RelatedRecordId
                            FROM Feeds
                        )
                    FROM Question_Attachment__c
                    WHERE Recommendation__c = :con.getId()
                    WITH SECURITY_ENFORCED
                ];

            }

            total_attachment=0;
            total_Feedattachment=0;
            if(LstQstnAttchmnts!=null)
            {
                setParentId = new map<Id,sObject>(LstQstnAttchmnts).keyset();
            }

            if(!setParentId.isEmpty())
            {
                set<id> setContentDocumentIds = new set<id>();

                List<ContentDocumentLink> lstContentDocumenLink = [
                    SELECT
                        ContentDocumentId,
                        LinkedEntityId
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId IN :setParentId
                    WITH SECURITY_ENFORCED
                ];

                List<ContentDocument> lstContentDocument = new List<ContentDocument>();
                for(ContentDocumentLink cdl : lstContentDocumenLink)
                {
                    setContentDocumentIds.add(cdl.ContentDocumentId);
                }

                List<ContentDocument> lstContentDocs = new List<ContentDocument>();

                Map<Id, ContentDocument> mapContentDocument = new Map<Id, ContentDocument>([
                    SELECT
                        FileType,
                        ContentSize,
                        Title,
                        Description,
                        LastModifiedDate,
                        CreatedBy.Name,
                        (
                            SELECT Id
                            FROM ContentVersions
                            ORDER BY CreatedDate DESC
                            LIMIT 1
                        )
                    FROM ContentDocument
                    WHERE Id IN :setContentDocumentIds
                    WITH SECURITY_ENFORCED
                ]);

                mapQAContentDocument = new map<id, List<ContentDocument>>();
                mapContentDocidQAid = new map<id,id>();

                for(ContentDocumentLink cdl : lstContentDocumenLink)
                {
                    if(mapQAContentDocument != null && (mapQAContentDocument.get(cdl.LinkedEntityId)) != null && !(mapQAContentDocument.get(cdl.LinkedEntityId)).isEmpty())
                    {
                        lstContentDocs = mapQAContentDocument.get(cdl.LinkedEntityId);
                    }
                    else
                    {
                        lstContentDocs = new List<ContentDocument>();
                    }

                    lstContentDocs.add(mapContentDocument.get(cdl.ContentDocumentId));

                    mapQAContentDocument.put(cdl.LinkedEntityId,lstContentDocs);
                    mapContentDocidQAid.put(cdl.ContentDocumentId, cdl.LinkedEntityId);
                    lstContentDocs = new List<ContentDocument>();

                }
            }

            lstQuestionAttachments = getQuestionAttachmentRecords(LstQstnAttchmnts,con.getId());
        }
        catch (DMLException DMLex)
        {
            system.debug( 'DMLException : ' + DMLex + '; @ line number : ' + DMLex.getLineNumber() );
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + DMLex.getDmlMessage(0) ) );
        }
        catch( Exception ex )
        {
            system.debug( 'Exception : ' + ex + '; @ line number : ' + ex.getLineNumber() );
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, '' + ex.getMessage() ) );
        }
    }
    public PageReference DeleteAttachment()
    {
        sObject varAssignment= new Attachment(id=varAssignmentId);
        String sObjectName = varAssignment.Id.getSObjectType().getDescribe().getName();
        CrudFlsService.getInstance().assertDeletable(varAssignment);
        delete varAssignment;
        if(((String)ApexPages.currentPage().getUrl()).startsWith('/')){
            PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
            pageRef.setRedirect(true);
            return pageRef;
        }
        return null;
    }

    public PageReference DeleteContentAttachment()
    {
        list<String> lstAttachmentIds = new list<String>{varAssignmentId};
    AttachmentUploadManager.deleteAttachments( 'ContentDocument', new list<String>{varAssignmentId}, mapContentDocidQAid.get(varAssignmentId)) ;
        if(((String)ApexPages.currentPage().getUrl()).startsWith('/')){
            PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
            pageRef.setRedirect(true);
            return pageRef;
        }
        return null;
    }

    public PageReference Reload()
    {
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference EditPageRedirect()
    {
        sObject varAssignment= new FeedItem(id=varAssignmentId);
        Id AttachmentId =varAssignmentId;
        PageReference pageRef = new PageReference('/'+AttachmentId+'/e?retURL=/'+URLId);
        pageRef.setRedirect(true);
        return pageRef;
    }

    //This method will return a wrapper object with all the attachments related to single question attachment.
    public QuestionAttachmentRecord getAttachmentRecords(Id questionId,List<Question_Attachment__c> LstQstnAttchmnts)
    {
        List<Attachment> lstAttachments = new List<Attachment>();
        List<ContentDocument> lstContentDocs = new List<ContentDocument>();

        for(Question_Attachment__c qa : LstQstnAttchmnts)
        {
            lstAttachments.addAll(qa.attachments);
            if(mapQAContentDocument.get(qa.Id) != null)
            {
                lstContentDocs.addAll(mapQAContentDocument.get(qa.id));
            }
        }

        QuestionAttachmentRecord questionAttachmentRecord = new QuestionAttachmentRecord(questionId,lstAttachments,lstContentDocs,LstQstnAttchmnts[0].Question__r.Name,mapQuestionName.get(questionId).stripHtmlTags());
        return questionAttachmentRecord;
    }

    //This method will return the QuestionAttachmentRecord wrapper record list to show as a list on vf page.
    public List<QuestionAttachmentRecord> getQuestionAttachmentRecords(List<Question_Attachment__c> LstQstnAttchmnts,Id opportunityId)
    {
        map<Id,List<Question_Attachment__c>> mapParentQA = new map<Id,List<Question_Attachment__c>>();
        List<Question_Attachment__c> lstChildQA = new List<Question_Attachment__c>();
        List<Question_Attachment__c> lstQnAttachments;
        mapQuestionName = new map<Id,String>();
        List<QuestionAttachmentRecord> lstQuestionAttachments = new List<QuestionAttachmentRecord>();

        for(Question_Attachment__c queAttachment :LstQstnAttchmnts)
        {
            if(String.IsBlank(queAttachment.Question__r.Parent_QuestionID__c))
            {
                mapParentQA.put(queAttachment.Question__c,new List<Question_Attachment__c>{queAttachment});
            }
            else
            {
                lstChildQA.add(queAttachment);
            }
        }
        for(Question_Attachment__c queAttachment : lstChildQA)
        {
            Id id = queAttachment.Question__r.Parent_QuestionID__c;
            if(!mapParentQA.IsEmpty() && mapParentQA.get(id)!=null)
            {
                lstQnAttachments = mapParentQA.get(id);
                lstQnAttachments.add(queAttachment);
                mapParentQA.put(id,lstQnAttachments);
            }
            else
            {
                mapParentQA.put(id,new List<Question_Attachment__c>{queAttachment});
            }
        }

        List<Questions__c> lstQuestions = [
            SELECT
                Language__c,
                RichQuestion__c
            FROM Questions__c
            WHERE Id IN :mapParentQA.keySet()
            WITH SECURITY_ENFORCED
        ];

        for(Questions__c question : lstQuestions)
        {
            mapQuestionName.put(question.Id,question.RichQuestion__c);
        }

        for(Id id : mapParentQA.keyset())
        {
            QuestionAttachmentRecord questionAttachRecord = getAttachmentRecords(id,mapParentQA.get(id));
            mapAttachCount.put(id,questionAttachRecord.attachCount);
            lstQuestionAttachments.add(questionAttachRecord);
        }
        return lstQuestionAttachments;
    }

    public class QuestionAttachmentRecord
    {
        public Id questionId{get;set;}
        public String Name {get;set;}
        public String question {get;set;}
        public List<Attachment> lstAttachments {get;set;}
        public List<ContentDocument> lstContentDocument{get;set;}
        public Integer attachCount {get;set;}

        public QuestionAttachmentRecord(Id questionId, List<Attachment> lstAttachments, List<ContentDocument> lstContentDocuments, String name, String question)
        {
            this.questionId = questionId;
            this.Name = name;
            this.question = question;
            this.lstAttachments = lstAttachments;
            this.lstContentDocument = lstContentDocuments;
            this.attachCount = 0;
            if(!lstAttachments.isEmpty())
                this.attachCount = lstAttachments.size();

            if(lstContentDocuments != null && !lstContentDocuments.isEmpty())
                this.attachCount += lstContentDocuments.size();
        }
    }
}