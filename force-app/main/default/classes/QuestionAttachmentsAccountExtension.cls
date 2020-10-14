public with sharing class QuestionAttachmentsAccountExtension {
    public List<Question_Attachment__c> LstQstnAttchmnts { get; set; }
    public List<QuestionAttachmentRecord> lstQuestionAttachments {get;set;}
    public string AttachmentTypeString {get;set;}
    public string FeedAttachmentTypeString {get;set;}
    public integer total_attachment {get;set;}
    public  String varAssignmentId {get;set;}
    public Id URLId {get;set;}
    public Map<id,integer> mapQuestionCount {get;set;}
    public integer total_Feedattachment {get;set;}
    public map<String,Integer> mapAttachCount{get;set;}
    public map<Id,String> mapQuestionName {get;set;}
        Set<Id> setParentId;
    List<ContentDocument> lstAllContentDocument;
    map<id, List<ContentDocument>> mapQAContentDocument = new map<id, List<ContentDocument>>();
    map<id,id> mapContentDocidQAid = new map<id,id>();
    public QuestionAttachmentsAccountExtension(ApexPages.StandardController con)
    {
        URLId=con.getId();
        mapQuestionCount=new Map<id,integer>();
        mapAttachCount = new map<String,Integer>();
        try
        {

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
                WHERE Inquiry__c IN :lstConvertedLeads
                AND Question__c != null
                WITH SECURITY_ENFORCED
                LIMIT 1000
            ];


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
                        ContentSize,
                        CreatedBy.Name,
                        Description,
                        FileType,
                        LastModifiedDate,
                        Title,
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

            lstQuestionAttachments = getQuestionAttachmentRecords(LstQstnAttchmnts);
        }
        catch (DMLException DMLex)
        {
            system.debug( 'DMLException : ' + DMLex);
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
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }

    public PageReference DeleteContentAttachment()
    {
        list<String> lstAttachmentIds = new list<String>{varAssignmentId};
            AttachmentUploadManager.deleteAttachments( 'ContentDocument', new list<String>{varAssignmentId}, mapContentDocidQAid.get(varAssignmentId)) ;
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
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
    public List<QuestionAttachmentRecord> getQuestionAttachmentRecords(List<Question_Attachment__c> LstQstnAttchmnts)
    {
        map<Id,List<Question_Attachment__c>> mapParentQA = new map<Id,List<Question_Attachment__c>>();
        List<Question_Attachment__c> lstChildQA = new List<Question_Attachment__c>();
        List<Question_Attachment__c> lstQnAttachments;

        mapQuestionName = new map<Id,String>();
        List<QuestionAttachmentRecord> lstQuestionAttachments = new List<QuestionAttachmentRecord>();

        for(Question_Attachment__c queAttachment :LstQstnAttchmnts)
        {
            List<Question_Attachment__c> lstQuestionAttachmentsOfParentQuestion ;
            if(String.IsBlank(queAttachment.Question__r.Parent_QuestionID__c))
            {
                if(!mapParentQA.keySet().contains(queAttachment.Question__c))
                    mapParentQA.put(queAttachment.Question__c,new List<Question_Attachment__c>{queAttachment});
                else
                {
                    lstQuestionAttachmentsOfParentQuestion = mapParentQA.get(queAttachment.Question__c);
                    lstQuestionAttachmentsOfParentQuestion.add(queAttachment);
                    mapParentQA.put(queAttachment.Question__c,lstQuestionAttachmentsOfParentQuestion);
                }
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
            WHERE Id In :mapParentQA.keySet()
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

        public QuestionAttachmentRecord(Id questionId,List<Attachment> lstAttachments, List<ContentDocument> lstContentDocuments, String name, String question)
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