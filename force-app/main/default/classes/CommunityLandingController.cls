/****************************************************************************
Name : CommunityLandingController
Purpose: This class Used to show available Campaign on CommunityLanding page
*****************************************************************************/
public with sharing class CommunityLandingController
{
    public Boolean initialized {get; set;} {initialized = false;}
    public CampaignFilter filter   { set; get; }
    public Campaign[] campaignList { set; get; }
    public String portalLanguage   { get; set; }
    public String fcCommonResource { get; set; }
    public String fcStyleSheet     { get; set; }
    public FGM_Portal__CommunitySetting__c communitySetting {get;set;}
    public FGM_Portal__Community_Static_Resource__c staticResourceSetting { get; set; }
    public string htmlString {get;set;}
    public Map<String , Map<String,String>> mapSobjectAndFieldTranslations {get; set;}
    public Set<String> setFieldsContainingTranslations {get;set;}
    public Map<String,String> mapFieldAndTranslation = NEW Map<String,String>();

    public CommunityLandingController() {
        communitySetting = FGM_Portal__CommunitySetting__c.getInstance('ShowExploreGrantOpportunitySearch');
        if(communitySetting == NULL){
            communitySetting = NEW FGM_Portal__CommunitySetting__c();
        }
        staticResourceSetting = Community_Static_Resource__c.getInstance('FCCommonResource');
        //check if user has their own css configured
        if (staticResourceSetting != NULL && isBlank(staticResourceSetting.Static_Resource_Name__c) == FALSE && isBlank(staticResourceSetting.File_Relative_Path__c) == FALSE) {
            fcCommonResource =  staticResourceSetting.Static_Resource_Name__c;
            String fileName = staticResourceSetting.File_Relative_Path__c;
            if (fileName.contains('.css')){
                fcStyleSheet = fileName;
            }
            else{
                fcStyleSheet = fileName +'.css';
            }
            //it seems user don't have their own css configured, so lets load our standard
        }
        else {
            fcCommonResource =  'FGM_Portal__FCCommonResource';
            fcStyleSheet     =  'fc_community.css';
        }
        htmlString = Label.FC_CommunitiesLanding_CustomText;
        if(htmlString != NULL){
            htmlString = String.escapeSingleQuotes(htmlString);
        }
    }

/*****************************************************************************
Purpose: This method get the parameter from url
Parameters:[String]
Returns: [String]
******************************************************************************/
    public String parameter(String name) {
        String strNameValue = ApexPages.currentPage().getParameters().get(name);
        return String.isEmpty(strNameValue)  ? strNameValue :  String.escapeSingleQuotes(strNameValue);
    }

/*****************************************************************************
Purpose: This method Initialize the communityLanding page as per user Language
Parameters:
Returns: [PageReference]
******************************************************************************/
    public PageReference initialize() {
        initialized = true;
        FCGlobal.UserSession userSession = FCGlobal.getUserSession(UserInfo.getUserId());
        portalLanguage = userSession.UserLanguage;
        FCGlobal.setUserLanguage(userInfo.getUserId(),portalLanguage);
        initializeFilter();
        initializeCampaignList();
        //Translations logic
        Map<String,String> mapFieldAndTranslations = NEW Map<String,String>();
        Set<String> setFieldsOnPage = NEW Set<String>{'Name','Description'};
            Set<String> setRecordId = NEW Set<String>();
        List<Id> listOfSobjectId = NEW List<Id>();
        Map<String,Boolean> mapOfNillableFields = NEW Map<String,Boolean>(); // Nillable fields are true of fields are not required and false when required.

        Id sObjectId;
        if(campaignList != NULL && !campaignList.isEmpty()){
            for(Campaign objCampaign :campaignList){
                listOfSobjectId.add(objCampaign.Id);
            }
            sObjectId = campaignList[0].Id;
        }

        if(sObjectId != NULL)  {
            mapOfNillableFields.put('Name',sObjectId.getSObjectType().getDescribe().fields.getMap().get('Name').getDescribe().isNillable());
            mapOfNillableFields.put('Description',sObjectId.getSObjectType().getDescribe().fields.getMap().get('Description').getDescribe().isNillable());
        }
        if(listOfSobjectId != NULL && portalLanguage != NULL && setFieldsOnPage != NULL){
            mapSobjectAndFieldTranslations =  FCGlobal.getObjectTranslationMap(listOfSobjectId, portalLanguage,setFieldsOnPage);
            if(campaignList != NULL) {
                for(Campaign objCampaign : campaignList){
                    //if(portalLanguage == 'en_US') -- FCPROD-3001
                   if (mapSobjectAndFieldTranslations == null || mapSobjectAndFieldTranslations.isEmpty()) // added by Jyotsna
                    {
                        mapFieldAndTranslation = getFieldAndTranslationsMap(objCampaign);
                        if(mapFieldAndTranslation != NULL){
                            mapSobjectAndFieldTranslations.put(objCampaign.Id,mapFieldAndTranslation);
                        }
                    }
                    else
                    {
                     /*   if(mapSobjectAndFieldTranslations == NULL || mapSobjectAndFieldTranslations.isEmpty() ){
                            mapFieldAndTranslation = getFieldAndTranslationsMap(objCampaign);
                            if(mapFieldAndTranslation != NULL){
                                mapFieldAndTranslations.putAll(mapFieldAndTranslation);
                            }
                            mapSobjectAndFieldTranslations.put(objCampaign.Id,mapFieldAndTranslations);
                        }*/ //  FCPROD-3001

                        if(mapSobjectAndFieldTranslations != NULL && !mapSobjectAndFieldTranslations.isEmpty()){
                            setRecordId.addAll(mapSobjectAndFieldTranslations.keySet());
                            if(!setRecordId.contains(objCampaign.Id)){
                                mapFieldAndTranslation = getFieldAndTranslationsMap(objCampaign);
                                if(mapFieldAndTranslation != NULL){
                                    mapSobjectAndFieldTranslations.put(objCampaign.Id,mapFieldAndTranslation);
                                }
                            }
                            else if(setRecordId.contains(objCampaign.Id)){
                                mapFieldAndTranslations = mapSobjectAndFieldTranslations.get(objCampaign.Id);
                                if(mapFieldAndTranslations != NULL){
                                    setFieldsContainingTranslations = mapFieldAndTranslations.keySet();
                                }
                                if(setFieldsContainingTranslations != NULL){
                                    for(String field : setFieldsOnPage){
                                        if(!setFieldsContainingTranslations.contains(field)){
                                            if(objCampaign.get(field) != NULL){
                                                mapFieldAndTranslations.put(field,(String)objCampaign.get(field));
                                            }
                                            else{
                                                mapFieldAndTranslations.put(field,'');
                                            }
                                        }
                                        else{
                                            if(mapFieldAndTranslations.get(field) == ''){
                                                if(!mapOfNillableFields.get(field) && objCampaign.get(field) != NULL){
                                                    mapFieldAndTranslations.put(field,(String)objCampaign.get(field));
                                                }
                                                else{
                                                    mapFieldAndTranslations.put(field,'');
                                                }
                                            }
                                        }
                                    }
                                }
                                if(setFieldsContainingTranslations.contains('Name')){
                                    mapFieldAndTranslations.put('Name',mapFieldAndTranslations.get('Name').stripHtmlTags());
                                }
                            }
                        }
                    }
                }
            }
        }
        if(mapSobjectAndFieldTranslations.containsKey('FGM_Portal__Exception')){
            Map<string, string> mapOfTranslationException = mapSobjectAndFieldTranslations.get('FGM_Portal__Exception');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,mapOfTranslationException.get('FGM_Portal__Exception')));
            return NULL;
        }
        return NULL;
    }

 /*****************************************************************************
Purpose: This method return Field and translations map
Parameters:[Campaign]
Returns: [Map<String,String>]
******************************************************************************/
    public Map<String,String> getFieldAndTranslationsMap(Campaign objCampaign){
        mapFieldAndTranslation = new Map<String,String>();
        if(objCampaign.Name != NULL){
            mapFieldAndTranslation.put('Name',objCampaign.Name);
        }
        else{
            mapFieldAndTranslation.put('Name','');
        }
        if(objCampaign.Description != NULL){
            mapFieldAndTranslation.put('Description',objCampaign.Description);
        }
        else{
            mapFieldAndTranslation.put('Description','');
        }
        return mapFieldAndTranslation;
    }

    public Boolean isBlank(String value) {
        return value == NULL || value == '';
    }

/*****************************************************************************
 Purpose: This method initialize the CampaignFilter wrapper properties
 Parameters:[]
 Returns: []
******************************************************************************/
    public void initializeFilter() {
        filter = NEW CampaignFilter();
        filter.find = ApexPages.currentPage().getParameters().get('find');
        filter.type = parameter('type');
        filter.region = parameter('region');
        filter.issues = parameter('issues');
    }

/*****************************************************************************
 Purpose: This method get campaign record from object
 Parameters:[]
 Returns: []
******************************************************************************/
    public void initializeCampaignList() {
        String strPubic = 'Public';
        String campaignSOQL = ''
            + 'SELECT Name'
            + ', Description'
            + ', Description__c'
            + ', EndDate'
            + ', RecordType.Name'
            + ', StartDate'
            + ', Status'
            + ', Type'
            + ', Visibility__c'
            + ' FROM Campaign'
            + ' WHERE Id != NULL'
            + ' AND Visibility__c = :strPubic';

        if (!String.isEmpty(filter.type) && !filter.type.Equals('All')) {
            String strFiterType = filter.type.trim();
            campaignSOQL += ' AND Type = :strFiterType';
        }

        campaignSOQL += ' WITH SECURITY_ENFORCED';

        // Add limits
        campaignSOQL += ' ORDER BY Name ASC';
        campaignSOQL += ' LIMIT 1000';
        campaignList = NEW List<Campaign>();
        // Run the query
        if (!String.isEmpty(filter.find)) {
            for(Campaign objCampaign : (Campaign[]) Database.query(campaignSOQL)){
                if( (!string.isBlank(objCampaign.Description) && objCampaign.Description.containsIgnoreCase(filter.find.trim())) || (!string.isBlank(objCampaign.Name) && objCampaign.Name.containsIgnoreCase(filter.find.trim()))){
                    campaignList.add(objCampaign);
                }
            }
        }
        else{
            campaignList = (Campaign[]) Database.query(campaignSOQL);
        }
    }

/*****************************************************************************
 Purpose: This method Search the campaign record as per specified type
 Parameters:[]
 Returns: [PageReference]
******************************************************************************/
    public PageReference search() {
        filter.find = String.isEmpty(filter.find)  ? '' :  filter.find;
        filter.type = String.isEmpty(filter.type)  ? '' :  String.escapeSingleQuotes(filter.type);
        filter.region = String.isEmpty(filter.region)  ? '' :  String.escapeSingleQuotes(filter.region);
        filter.issues = String.isEmpty(filter.issues)  ? '' :  String.escapeSingleQuotes(filter.issues);

        PageReference pageReference = System.Page.CommunityLanding;
        pageReference.getParameters().put('sfdc.tabName', parameter('sfdc.tabName'));
        pageReference.getParameters().put('find',filter.find);
        pageReference.getParameters().put('type',filter.type);
        pageReference.getParameters().put('region',filter.region);
        pageReference.getParameters().put('issues',filter.issues);
        pageReference.setRedirect(TRUE);
        return pageReference;
    }

    public class CampaignFilter {
        public String type{ get; set;}
        public String find { get; set;}
        public String region{ get; set;}
        public String issues{ get; set;}
    }
}