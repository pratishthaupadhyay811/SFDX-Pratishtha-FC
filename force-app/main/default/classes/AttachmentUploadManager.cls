public class AttachmentUploadManager
{
    /*
Purpose: update contendocument and Insert contendocumentLink record uploaded from community
parameter: recordId to wich contentdocument need to link,contententdocumentID which need to update, contentdocumentdescription, shareType of contentdocument
return: save result of contentdocumentlink
*/
    @RemoteAction
    public static Database.SaveResult insertAndUpdateContentDocumentLink( String recordId, String contentDocumentId, String cntntDcmntDscrptn, String shareType )
    {
        ContentDocument contentDocument = new ContentDocument( Id = contentDocumentId, Description = cntntDcmntDscrptn );
        CrudFlsService.getInstance().assertUpdateable(contentDocument);
        Database.SaveResult saveResult = Database.update( contentDocument );
        if( !saveResult.isSuccess() )
        {
            return saveResult;
        }

        ContentDocumentLink contentDocumentLink = new ContentDocumentLink( ContentDocumentId = contentDocumentId, LinkedEntityId = recordId, ShareType = shareType );
        CrudFlsService.getInstance().assertCreateable(contentDocumentLink);
        saveResult = Database.insert(contentDocumentLink);

        return saveResult;
    }

    /*
Purpose: get Attachments for Question Attachmet
parameter: []
return: Wrapper of Attachments
*/

    @RemoteAction
    public static List<AttachmentWrapper> getAttachments( String recordId, String lookupFieldApiName, String lookupFieldValue )
    {
        try {
            Set<Id> setParentIds = new Set<Id>();

            List<Question_Attachment__c> lstQuestionAttachments = new List<Question_Attachment__c>() ;

            List<String> queryFields = new List<String>{
                'Name',
                'Question__c',
                'Question__r.Parent_QuestionId__c',
                'Question__r.AttachmentNameFormula__c'
            };

            String queryFrom = 'Question_Attachment__c';

            List<String> queryWhereAnd = new List<String>{
                'Question__c != null'
            };

            String queryLimit = '200';

            if (recordId != null && ((Id) recordId).getSObjectType() != null) {
                queryWhereAnd.add('Id = :recordId');
            }

            if (lookupFieldApiName != null) {
                Schema.SObjectField lookupField = Question_Attachment__c.sObjectType.getDescribe().fields.getMap().get(lookupFieldApiName);

                if (lookupField != null) {
                    queryFields.add(lookupField.getDescribe().getName());

                    if (lookupFieldValue != null) {
                        queryWhereAnd.add(
                            lookupField.getDescribe().getName() + ' = :lookupFieldValue'
                        );

                        queryLimit = '1000';
                    }
                }
            }

            String query = String.format(
                'SELECT {0} FROM {1} WHERE {2} WITH SECURITY_ENFORCED LIMIT {3}',
                new List<String>{
                    String.join(queryFields, ', '),
                    queryFrom,
                    String.join(queryWhereAnd, ' AND '),
                    queryLimit
                }
            );

            lstQuestionAttachments  = Database.query(query);

            Set<Id> setQuestionIds = new Set<Id>();
            Map<Id, Set<Id>> mapQuestionAttachmentsWithRelatedQuestions = new Map<Id, Set<Id>>();
            Map<Id, FGM_Portal__Question_Attachment__c> mapQuestionAttachments = new Map<Id, FGM_Portal__Question_Attachment__c>();
            Map<Id, Set<Id>> mapQuestionIdSetIds = new Map<Id, Set<Id>>();
            if(!lstQuestionAttachments.isEmpty()){
                for( FGM_Portal__Question_Attachment__c questionAttachment : lstQuestionAttachments )
                {
                    setParentIds.add( questionAttachment.Id );
                    setQuestionIds.add( (Id)questionAttachment.FGM_Portal__Question__c );
                    if( questionAttachment.FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c != null ){
                        setQuestionIds.add( (Id)questionAttachment.FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c );
                    }
                }

                for( FGM_Portal__Question_Attachment__c questionAttachment : lstQuestionAttachments )
                {
                    mapQuestionAttachments.put( questionAttachment.Id, questionAttachment );
                    if(!setQuestionIds.isEmpty()){
                        if(setQuestionIds.contains(questionAttachment.FGM_Portal__Question__c))
                        {
                            Set<Id> setQuestionIdsTemp = new Set<Id>();
                            if( mapQuestionIdSetIds.get( questionAttachment.FGM_Portal__Question__c ) != null && !mapQuestionIdSetIds.get( questionAttachment.FGM_Portal__Question__c ).isEmpty() ){
                                setQuestionIdsTemp = mapQuestionIdSetIds.get( questionAttachment.FGM_Portal__Question__c );
                            }
                            setQuestionIds.add( questionAttachment.FGM_Portal__Question__c );
                            if( questionAttachment.FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c != null )
                            {
                                setQuestionIdsTemp.add( questionAttachment.FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c );
                                if( mapQuestionIdSetIds.get( questionAttachment.FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c ) != null && !mapQuestionIdSetIds.get( questionAttachment.FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c ).isEmpty()  )
                                {
                                    setQuestionIdsTemp.addAll(mapQuestionIdSetIds.get( questionAttachment.FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c ));
                                    mapQuestionIdSetIds.put( questionAttachment.FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c, setQuestionIdsTemp );
                                }
                            }
                            mapQuestionIdSetIds.put( questionAttachment.FGM_Portal__Question__c, setQuestionIdsTemp );
                        }
                        if(setQuestionIds.contains( questionAttachment.FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c))
                        {
                            Set<Id> setQuestionIdsTemp = new Set<Id>();
                            if( mapQuestionIdSetIds.get( questionAttachment.FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c ) != null && !mapQuestionIdSetIds.get( questionAttachment.FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c ).isEmpty() ){
                                setQuestionIdsTemp = mapQuestionIdSetIds.get( questionAttachment.FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c );
                            }
                            setQuestionIdsTemp.add( questionAttachment.FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c );
                            setQuestionIdsTemp.add( questionAttachment.FGM_Portal__Question__c );
                            if( mapQuestionIdSetIds.get( questionAttachment.FGM_Portal__Question__c ) != null && !mapQuestionIdSetIds.get( questionAttachment.FGM_Portal__Question__c ).isEmpty()  )
                            {
                                setQuestionIdsTemp.addAll(mapQuestionIdSetIds.get( questionAttachment.FGM_Portal__Question__c ));
                                mapQuestionIdSetIds.put( questionAttachment.FGM_Portal__Question__c, setQuestionIdsTemp );
                            }
                            mapQuestionIdSetIds.put( questionAttachment.FGM_Portal__Question__r.FGM_Portal__Parent_QuestionID__c, setQuestionIdsTemp );
                        }
                    }
                }

                for( FGM_Portal__Question_Attachment__c qa : lstQuestionAttachments )
                {
                    if(mapQuestionIdSetIds.containsKey(qa.FGM_Portal__Question__c))
                        mapQuestionAttachmentsWithRelatedQuestions.put( qa.Id, mapQuestionIdSetIds.get( qa.FGM_Portal__Question__c ) );
                }
            }
            List<AttachmentWrapper> lstAttachments = new List<AttachmentWrapper>();
            list<Attachment> lstAttachment = new list<Attachment>();
            if(!setParentIds.isEmpty()){
                lstAttachment = [
                    SELECT
                        BodyLength,
                        ContentType,
                        CreatedDate,
                        Description,
                        Name,
                        OwnerId,
                        ParentId
                    FROM Attachment
                    WHERE ParentId IN :setParentIds
                    WITH SECURITY_ENFORCED
                ];
            }

            List<string> ListUserIds = new List<string>();
            if(!lstAttachment.isEmpty()){
                for( Attachment attachment : lstAttachment )
                {
                    if(!ListUserIds.contains(attachment.OwnerId))
                        ListUserIds.add(attachment.OwnerId);
                }
            }
            map<id,User> mapUsers = new map<id,User>();
            List<Sobject> lstSobject;
            List<User> lstUser;
            if(!ListUserIds.isEmpty()){
                lstSobject = new List<Sobject>(AdminContextExecutionManager.getUserResult(ListUserIds));
                lstUser =(List<User>)lstSobject;
                for(User user:lstUser){
                    mapUsers.put(user.Id,user);
                }
            }
            if(!lstAttachment.isEmpty() ){
                for( Attachment attachment : lstAttachment )
                {
                    boolean isDeletable;
                    if( mapQuestionAttachmentsWithRelatedQuestions.get( attachment.ParentId ) != null )
                    {
                        FGM_Portal__Question_Attachment__c questionAttachment = (FGM_Portal__Question_Attachment__c)mapQuestionAttachments.get( attachment.ParentId );
                        if(mapUsers.containsKey(attachment.OwnerId)){
                            if(mapUsers.get(attachment.OwnerId).ContactId != null ){
                                isDeletable = true;
                            }
                            else{
                                isDeletable = false;
                            }
                            lstAttachments.add( new AttachmentWrapper( attachment, mapQuestionAttachmentsWithRelatedQuestions.get( attachment.ParentId ), questionAttachment,isDeletable));
                        }
                    }
                }
            }

            Set<Id> setAllOtherContentDocumentIds = new Set<Id>();
            Map<Id, Set<Id>> mapParentIdWithSetContentDocumentIds = new Map<Id,Set<Id>>();
            map<id,User> mapCdlUsers;
            if(!setParentIds.isEmpty())
            {
                List<ContentDocumentLink> lstContentDocumentLink = [
                    SELECT
                        LinkedEntityId,
                        ContentDocumentId,
                        ContentDocument.CreatedById
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId IN :setParentIds
                    WITH SECURITY_ENFORCED
                ];

                set<string> setCdlUserIds = new set<string>();
                if(!lstContentDocumentLink.isEmpty()){
                    for( ContentDocumentLink cdl : lstContentDocumentLink )
                    {
                        setCdlUserIds.add(cdl.ContentDocument.CreatedById);
                    }

                    ListUserIds = new List<string>(setCdlUserIds);
                    lstSobject = new List<Sobject>(AdminContextExecutionManager.getUserResult(ListUserIds));
                    lstUser =(List<User>)lstSobject;
                    mapCdlUsers = new map<id,User>(lstUser);
                    for( ContentDocumentLink contentDocumentLink : lstContentDocumentLink )
                    {
                        for( Id id : setParentIds )
                        {
                            if( contentDocumentLink.LinkedEntityId == id )
                            {
                                Set<Id> setIds = new Set<Id>();
                                if( mapParentIdWithSetContentDocumentIds.get( id ) != null && !mapParentIdWithSetContentDocumentIds.get( id ).isEmpty() )
                                    setIds = mapParentIdWithSetContentDocumentIds.get( id );
                                setIds.add( contentDocumentLink.ContentDocumentId );
                                mapParentIdWithSetContentDocumentIds.put( id, setIds );
                                break;
                            }
                        }
                        setAllOtherContentDocumentIds.add( contentDocumentLink.ContentDocumentId );
                    }
                }

                Map<Id, ContentDocument> mapIdAndContentDocument = new Map<Id, ContentDocument>([
                    SELECT
                        ContentSize,
                        CreatedById,
                        CreatedDate,
                        Description,
                        FileType,
                        Title,
                        (
                            SELECT Id
                            FROM ContentVersions
                            ORDER BY CreatedDate DESC
                            LIMIT 1
                        )
                    FROM ContentDocument
                    WHERE Id IN :setAllOtherContentDocumentIds
                    WITH SECURITY_ENFORCED
                ]);

                for( Id id : setParentIds )
                {
                    if( mapParentIdWithSetContentDocumentIds.get(id) != null )
                    {
                        for( Id contentDocumentId : mapParentIdWithSetContentDocumentIds.get( id ) )
                        {
                            ContentDocument contentDoc = mapIdAndContentDocument.get( contentDocumentId );
                            if( contentDoc != null )
                            {
                                if( mapQuestionAttachmentsWithRelatedQuestions.get( id ) != null )
                                {   boolean isDeletable;
                                 FGM_Portal__Question_Attachment__c questionAttachment = (FGM_Portal__Question_Attachment__c)mapQuestionAttachments.get( id );
                                 if(mapCdlUsers.containsKey(mapIdAndContentDocument.get(contentDocumentId).CreatedById)){
                                     if(mapCdlUsers.get(mapIdAndContentDocument.get(contentDocumentId).CreatedById).ContactId != null ){
                                         isDeletable = true;
                                     }
                                     else{
                                         isDeletable = false;
                                     }
                                     lstAttachments.add( new AttachmentWrapper( contentDoc, id, mapQuestionAttachmentsWithRelatedQuestions.get( id ), questionAttachment,isDeletable ) );
                                 }
                                }
                            }
                        }
                    }
                }
            }

            return lstAttachments;
        }
        catch( Exception ex )
        {
            system.debug( 'Exception:' + ex.getStackTraceString() );
            return null;
        }

    }

    public class AttachmentWrapper
    {
        public string id { get; set; }
        public string name { get; set; }
        public string description { get; set; }
        public dateTime createdDate { get; set; }
        public decimal sizeInBytes { get; set; }
        public id questionAttachmentId { get; set; }
        public Set<Id> relatedQuestions { get; set; }
        public string contentType { get; set; }
        public string type { get; set; }
        public string downloadUrlPath { get; set; }
        public sObject question { get; set; }
        public sObject questionAttachment { get; set; }
        public sObject questionAttachmentParent { get; set; }
        public boolean isDeletable { get; set; }
        public AttachmentWrapper( Attachment attachment, Set<Id> setQuestionIds, FGM_Portal__Question_Attachment__c questionAttachment ,boolean isDeletable)
        {
            this.id = attachment.Id;
            this.name = attachment.Name;
            this.description = attachment.Description;
            this.createdDate = attachment.CreatedDate;
            this.sizeInBytes = attachment.BodyLength;
            this.contentType = attachment.ContentType;
            this.questionAttachmentId = attachment.ParentId;
            this.relatedQuestions = setQuestionIds;
            this.type = 'Attachment';
            this.downloadUrlPath = Site.getPathPrefix()+ '/servlet/servlet.FileDownload?file=' + this.id;
            this.question = questionAttachment.FGM_Portal__Question__r;
            this.questionAttachment = questionAttachment;
            this.isDeletable = isDeletable;
        }
        public AttachmentWrapper( ContentDocument contentDocument, Id parentId, Set<Id> setQuestionIds, FGM_Portal__Question_Attachment__c questionAttachment, boolean isDeletable )
        {
            this.id = contentDocument.Id;
            this.name = contentDocument.Title;
            this.description = contentDocument.Description;
            this.createdDate = contentDocument.CreatedDate;
            this.sizeInBytes = contentDocument.ContentSize;
            this.contentType = contentDocument.FileType;
            this.questionAttachmentId = parentId;
            this.relatedQuestions = setQuestionIds;
            this.type = 'ContentDocument';
            this.downloadUrlPath = Site.getPathPrefix()+ '/sfc/servlet.shepherd/version/download/' + contentDocument.ContentVersions[0].Id;
            this.question = questionAttachment.FGM_Portal__Question__r;
            this.questionAttachment = questionAttachment;
            this.isDeletable = isDeletable;
        }
    }

    public class AttachmentComponentSettingsWrapper
    {
        public string sessionId { get; set; }
        public string userId { get; set; }
        public string orgId { get; set; }
        public string chatterApiUrl { get; set; }
        public string restApiUrl { get; set; }
        public boolean isEditable { get; set; }
        public boolean isScanEnabled { get; set; }
        public boolean isFile { get; set; }
        public string virusScanUrl { get; set; }
        public string networkId { get; set; }
        public integer allowedFileSizeInBytes { get; set; }
        public boolean isDescriptionEnabled { get; set; }
        public List<String> allowedFileExtensions { get; set; }
        public AttachmentComponentSettingsWrapper( Boolean isEditable, String baseUrl, String locale, String apiVersion )
        {
            Engine.UserInfoWrapper userInfo = Engine.getUserInfo();
            this.sessionId = userInfo.sessionId;
            this.userId = userInfo.id;
            this.orgId = userInfo.orgId;
            this.networkId = userInfo.networkId;
            if( this.networkId != null )
            {
                if(Site.getPathPrefix()!=null || Site.getPathPrefix()!='')
                    this.chatterApiUrl = baseUrl + Site.getPathPrefix() + '/services/data/v' + ( apiVersion == null ? '42.0' : apiVersion ) + '/connect/communities/' + this.networkId + '/files/users/' + this.userId;
                else
                    this.chatterApiUrl = baseUrl + '/services/data/v' + ( apiVersion == null ? '42.0' : apiVersion ) + '/connect/communities/' + this.networkId + '/files/users/' + this.userId;
            }
            else
            {
                if(Site.getPathPrefix()!=null || Site.getPathPrefix()!='')
                    this.chatterApiUrl = baseUrl + Site.getPathPrefix() + '/services/data/v' + ( apiVersion == null ? '42.0' : apiVersion ) + '/connect/files/users/' + this.userId;
                else
                    this.chatterApiUrl = baseUrl + '/services/data/v' + ( apiVersion == null ? '42.0' : apiVersion ) + '/connect/files/users/' + this.userId;
            }
            if(Site.getPathPrefix()!=null || Site.getPathPrefix()!='')
                this.restApiUrl = baseUrl + Site.getPathPrefix()+ '/services/data/v' + ( apiVersion == null ? '42.0' : apiVersion ) + '/sobjects';
            else
                this.restApiUrl = baseUrl + '/services/data/v' + ( apiVersion == null ? '42.0' : apiVersion ) + '/sobjects';
            this.isEditable = isEditable;

            List<FGM_Portal__CommunitySetting__c> lstCommunitySettings = (List<FGM_Portal__CommunitySetting__c>)Engine.getCustomSettingRecords('FGM_Portal__CommunitySetting__c', null);
            if( !lstCommunitySettings.isEmpty() )
            {
                for( FGM_Portal__CommunitySetting__c communitySetting : lstCommunitySettings )
                {
                    if( communitySetting.Name.equalsIgnoreCase('IsAttachmentDescriptionEnabled') )
                    {
                        this.isDescriptionEnabled = communitySetting.FGM_Portal__IsEnabled__c;
                        break;
                    }
                }
            }

            List<sObject> lstGlobalPortalSettings = Engine.getCustomSettingRecords( 'FGM_Portal__GlobalPortalSettings__c', this.userId );
            if( !lstGlobalPortalSettings.isEmpty() )
                this.isScanEnabled = (Boolean)lstGlobalPortalSettings[0].get('FGM_Portal__Is_VirusScan_Enabled__c');

            this.virusScanUrl = 'https://virusscan.foundationconnect.org/scan/service';

            List<sObject> lstPortalConfigurations = Engine.getCustomSettingRecords( 'FGM_Portal__PortalConfiguration__c', null );
            if( !lstPortalConfigurations.isEmpty() )
            {
                for( sObject portalConfig : lstPortalConfigurations )
                {
                    if( ((String)portalConfig.get('FGM_Portal__LanguageSelection__c')).equalsIgnoreCase( locale ) )
                    {
                        this.isFile = (Boolean)portalConfig.get('FGM_Portal__Post_attachments_to_chatter_feeds__c');
                    }
                }
            }

            if( this.networkId != null )
            {
                List<Network> lstNetworks = [
                    SELECT
                        AllowedExtensions,
                        MaxFileSizeKb
                    FROM Network
                    WHERE Id = :this.networkId
                    WITH SECURITY_ENFORCED
                ];

                if( !lstNetworks.isEmpty() )
                {
                    if( lstNetworks[0].MaxFileSizeKb != null )
                        this.allowedFileSizeInBytes = lstNetworks[0].MaxFileSizeKb * 1000;
                    if( lstNetworks[0].AllowedExtensions != null && lstNetworks[0].AllowedExtensions.contains(',') )
                    {
                        for( String extension : lstNetworks[0].AllowedExtensions.split( ',', 0 ) )
                        {
                            if( this.allowedFileExtensions == null )
                                this.allowedFileExtensions = new List<String>();
                            this.allowedFileExtensions.add( extension.removeStart('.') );
                        }
                    }
                }
            }

        }
    }
    public class ApplicationQuestionWrapper
    {
        public sObject application { get; set; }
        public List<sObject> questionAttachments { get; set; }
        public ApplicationQuestionWrapper( sObject application, List<sObject> questionAttachments )
        {
            this.application = application;
            this.questionAttachments = questionAttachments;
        }
    }

    @RemoteAction
    public static ApplicationQuestionWrapper getApplicationRecord(String lookupFieldApiName, String lookupFieldValue) {
        try {
            if (lookupFieldApiName != null && lookupFieldValue != null) {

                // allow only simple field references, including letters, numbers, underscores, and dots
                lookupFieldApiName = lookupFieldApiName.replaceAll('[^0-9a-zA-Z_.]', '');

                List<String> queryFields = new List<String>{
                    'Question__c',
                    'Question__r.AttachmentNameFormula__c',
                    lookupFieldApiName
                };

                List<String> queryWhere = new List<String>{
                    lookupFieldApiName + ' = :lookupFieldValue',
                    'Question__c != null'
                };

                String query = String.format(
                    'SELECT {0} FROM Question_Attachment__c WHERE {1} WITH SECURITY_ENFORCED LIMIT 1000',
                    new List<String>{
                        String.join(queryFields, ', '),
                        String.join(queryWhere, ' AND ')
                    }
                );

                List<Question_Attachment__c> lstQuestionAttachments = (List<Question_Attachment__c>) Database.query(query);

                // fetch sObject field api names from question_attachment_naming_formula

                Set<String> setSobjectFieldApiNames = new Set<String>();

                for (Question_Attachment__c questionAttachment : lstQuestionAttachments) {
                    if (questionAttachment.Question__r.AttachmentNameFormula__c != null) {
                        List<String> lstNamingFormulaTokens = questionAttachment.Question__r.AttachmentNameFormula__c.split('\\+');
                        for (String token : lstNamingFormulaTokens) {
                            if (!token.contains('\'') && !token.equalsIgnoreCase('FileName')) {
                                setSobjectFieldApiNames.add(token);
                            }
                        }
                    }
                }

                ApplicationQuestionWrapper appQuestionWrapper = new ApplicationQuestionWrapper(null, lstQuestionAttachments);

                // validate the fetched field API names from describeSobject result
                Set<String> setValidFieldApiNames = new Set<String>();

                Set<String> setSobjectFields = new Set<String>();

                Schema.SObjectType sot = ((Id) lookupFieldValue).getSObjectType();
                List<Schema.SObjectField> objectFields = sot.getDescribe().fields.getMap().values();

                for (Schema.SObjectField f : objectFields) {
                    setSobjectFields.add(f.getDescribe().getName());
                }

                for (String formulaFieldApiName : setSobjectFieldApiNames) {
                    for (String actualFieldApiName : setSobjectFields) {
                        if (formulaFieldApiName.equalsIgnoreCase(actualFieldApiName)) {
                            setValidFieldApiNames.add(actualFieldApiName);
                            break;
                        }
                    }
                }

                // fetch the application record with all the required fields to develop the formula
                if (!setValidFieldApiNames.isEmpty()) {
                    List<String> lstStr = new List<String>();
                    lstStr.addAll(setValidFieldApiNames);

                    String lookupQuery = String.format(
                        'SELECT {0} FROM {1} WHERE Id = :lookupFieldValue WITH SECURITY_ENFORCED',
                        new List<String>{
                            String.join(lstStr, ', '),
                            sot.getDescribe().getName()
                        }
                    );

                    List<sObject> lstSobject = Database.query(lookupQuery);

                    if (!lstSobject.isEmpty()) {
                        appQuestionWrapper.application = lstSobject[0];
                    }
                }

                return appQuestionWrapper;
            }
        } catch(Exception ex) {
            System.debug('Exception: ' + ex.getStackTraceString());
        }

        return null;
    }

    /*
Purpose: delete Attachmet record
*/

    @RemoteAction
    public static List<Database.DeleteResult> deleteAttachments( String attachmentApiName, List<String> lstAttachmentIds,String questionAttachmentId )
    {
        if( attachmentApiName.equalsIgnoreCase('Attachment')  )
        {
            CrudFlsService.getInstance().assertDeletable(lstAttachmentIds);
            return Database.delete(lstAttachmentIds);
        }
        else if( attachmentApiName.equalsIgnoreCase('ContentDocument') )
        {
            Map<Id, Id> mapCntntVrsnIdAndCntntDcmntId = new Map<Id, Id>();

            for (ContentVersion contentVersion : [
                SELECT ContentDocumentId
                FROM ContentVersion
                WHERE ContentDocumentId IN :lstAttachmentIds
                WITH SECURITY_ENFORCED
            ]) {
                mapCntntVrsnIdAndCntntDcmntId.put( contentVersion.Id, contentVersion.ContentDocumentId );
            }

            Map<Id, Id> mapFdItmAndCntntVrsn = new Map<Id, Id>();
            set<Id> feedIds = new set<Id>();
            list<FGM_Portal__Question_Attachment__c> lstQuestionAttachment;

            if(String.isNotBlank(questionAttachmentId)) {
                lstQuestionAttachment = [
                    SELECT
                        Name,
                        (
                            SELECT Id
                            FROM Feeds
                        )
                    FROM Question_Attachment__c
                    WHERE Id = :questionAttachmentId
                    WITH SECURITY_ENFORCED
                ];
            }

            if(!lstQuestionAttachment.isEmpty())
            {
                for(FGM_Portal__Question_Attachment__c queAttachment : lstQuestionAttachment)
                {
                    for(FGM_Portal__Question_Attachment__Feed feed : queAttachment.feeds)
                    {
                        feedIds.add(feed.Id);
                    }
                }

                for (FeedAttachment feedAttachment : [
                    SELECT
                        FeedEntityId,
                        RecordId
                    FROM FeedAttachment
                    WHERE RecordId IN :mapCntntVrsnIdAndCntntDcmntId.keySet()
                    AND FeedEntityId IN :feedIds
                    WITH SECURITY_ENFORCED
                ]) {
                    mapFdItmAndCntntVrsn.put( feedAttachment.FeedEntityId, feedAttachment.RecordId );
                }
            }
            Database.DeleteResult[] arrCntntDcmntDltRslt;
            CrudFlsService.getInstance().assertDeletable(lstAttachmentIds);
            arrCntntDcmntDltRslt = Database.delete(lstAttachmentIds, true);

            List<Id> lstFeedItemsToDelete = new List<Id>();

            for( Database.DeleteResult deleteResult : arrCntntDcmntDltRslt )
            {
                for( Id contentVersionId : mapCntntVrsnIdAndCntntDcmntId.keySet() )
                {
                    if( deleteResult.getId() == mapCntntVrsnIdAndCntntDcmntId.get(contentVersionId) )
                    {
                        for( Id feedEntityId : mapFdItmAndCntntVrsn.keySet() )
                        {
                            if( contentVersionId == mapFdItmAndCntntVrsn.get( feedEntityId ) )
                            {
                                lstFeedItemsToDelete.add( feedEntityId );
                                break;
                            }
                        }
                        break;
                    }
                }
            }
            if( !lstFeedItemsToDelete.isEmpty() )
                CrudFlsService.getInstance().assertDeletable(lstFeedItemsToDelete);
                Database.delete(lstFeedItemsToDelete);
            return arrCntntDcmntDltRslt;
        }
        else
            return null;
    }
}