public with sharing class GuidestarConfigurationExtension {
    public Boolean initialized {get; set;} {initialized = false;}
    public List<Selectoption> lstRecordType { get; set; }
    public List<Selectoption> lstFields { get; set; }
    public String selectedRecordType { get; set; }
    public String recordTypeName { get; set;}
    public FGM_Portal__GuidestarFieldMapping__c configurationRecord { get; set; }
    public List<String> lstGuidestarFields { get; set; }
    public Map<String,String> mapGuidestarFields { get; set; }
    public Boolean showFieldsToMap {get;set;}
    public GuidestarConfigurationExtension (ApexPages.StandardController controller) {

    }
    public void initializeConfiguration(){
        initialized = true;
        showFieldsToMap = true;
        initializeRecordTypes();
        lstFields = null;
    }

    // Get selected Object recordType
    public void initializeRecordTypes(){
        initializeGuidestarFields();
            List<SelectOption> RecordTypeOptions = new List<SelectOption>();
            Map<String,Schema.RecordTypeInfo> mapRecordTypeInfo = AdminContextExecutionManager.getRecordTypesByName('FGM_Portal__GuidestarFieldMapping__c'); //getting all Recordtype for the Sobject
            for(Schema.RecordTypeInfo recordTypeInfo : mapRecordTypeInfo.values()){
                if(recordTypeInfo.isAvailable()) {
                    if(!'Master'.equalsIgnoreCase(recordTypeInfo.getName())) {
                        RecordTypeOptions.add(new Selectoption(recordTypeInfo.getRecordTypeId() ,recordTypeInfo.getName()));
                    }
                }
            }
            if(RecordTypeOptions.size() > 0){
                lstRecordType = RecordTypeOptions;
            } else{
                lstRecordType = null;
            }
    }

    //get Fields
    public void initializeFieldsOptions(){
        lstFields = new List<SelectOption>();
        if(String.isNotBlank(selectedRecordType)){
            String objectName = '';
            recordTypeName = getRecordTypeName(selectedRecordType);
            if(String.isNotBlank(recordTypeName)){
                showFieldsToMap = false;
                if('Guidestar Contact'.equalsIgnoreCase(recordTypeName)){
                    recordTypeName = 'Contact Mapping';
                    objectName ='Contact';
                }
                else if('GuideStar Portal User'.equalsIgnoreCase(recordTypeName)){
                    recordTypeName = 'Portal User Mapping';
                    objectName = 'FGM_Portal__Portal_User__c';
                }
                else if('Guidestar Organization'.equalsIgnoreCase(recordTypeName)){
                    recordTypeName = 'Organization/Account Mapping';
                    objectName = 'Account';
                }
                if(String.isNotBlank(objectName)){
                    Map<String,String> mapFields = FCGlobal.getsObjectFields(objectName, new Set<String>{'FORMULA','REFERENCE','BOOLEAN'});
                    if(!mapFields.isEmpty()){
                        for(String fieldName : mapFields.keySet()){
                            lstFields.add(new SelectOption(mapFields.get(fieldName),fieldName));
                        }
                         initializeConfigurationRecord();
                    }
                }
            }
        }
    }
    public void initializeGuidestarFields(){

        mapGuidestarFields = new Map<String,string>();
        lstGuidestarFields = new List<String>();
        mapGuidestarFields.put('Primary Organization Name','FGM_Portal__primary_organization_name__c');
        lstGuidestarFields.add('Primary Organization Name');

        mapGuidestarFields.put('Government Registered Name','FGM_Portal__government_registered_name__c');
        lstGuidestarFields.add('Government Registered Name');

        mapGuidestarFields.put('Also Known As Name','FGM_Portal__also_known_as__c');
        lstGuidestarFields.add('Also Known As Name');

        mapGuidestarFields.put('GuideStar Specific Organization ID','FGM_Portal__organization_id__c');
        lstGuidestarFields.add('GuideStar Specific Organization ID');

        mapGuidestarFields.put('EIN','FGM_Portal__government_issued_id__c');
        lstGuidestarFields.add('EIN');

        mapGuidestarFields.put('Address Line 1','FGM_Portal__address_line_1__c');
        lstGuidestarFields.add('Address Line 1');

        mapGuidestarFields.put('Address Line 2','FGM_Portal__address_line_2__c');
        lstGuidestarFields.add('Address Line 2');

        mapGuidestarFields.put('State','FGM_Portal__country_subdivision_abbrev__c');
        lstGuidestarFields.add('State');

        mapGuidestarFields.put('City','FGM_Portal__city__c');
        lstGuidestarFields.add('City');

        mapGuidestarFields.put('Country','FGM_Portal__country_abbrev__c');
        lstGuidestarFields.add('Country');

        mapGuidestarFields.put('Postal Code','FGM_Portal__postal_code__c');
        lstGuidestarFields.add('Postal Code');

        mapGuidestarFields.put('Telephone Number','FGM_Portal__telephone_number__c');
        lstGuidestarFields.add('Telephone Number');
        //Basic Registry of Identified Global Entities
        mapGuidestarFields.put('BRIDGE ID','FGM_Portal__bridge_id__c');
        lstGuidestarFields.add('BRIDGE ID');

        mapGuidestarFields.put('Mission Statement','FGM_Portal__mission_statement__c');
        lstGuidestarFields.add('Mission Statement');

        mapGuidestarFields.put('Doing Business As','FGM_Portal__doing_business_as__c');
        lstGuidestarFields.add('Doing Business As');

        mapGuidestarFields.put('Impact Statement','FGM_Portal__impact_statement__c');
        lstGuidestarFields.add('Impact Statement');

        mapGuidestarFields.put('CEO Comments','FGM_Portal__ceo_comments__c');
        lstGuidestarFields.add('CEO Comments');

        mapGuidestarFields.put('Geographic Areas Served Narrative','FGM_Portal__geographic_areas_served_narrative__c');
        lstGuidestarFields.add('Geographic Areas Served Narrative');

        mapGuidestarFields.put('Government Issued Ruling Year','FGM_Portal__government_issued_ruling_year__c');
        lstGuidestarFields.add('Government Issued Ruling Year');

        mapGuidestarFields.put('Incorporation Year','FGM_Portal__incorporation_year__c');
        lstGuidestarFields.add('Incorporation Year');

        mapGuidestarFields.put('Reseason for Nonprivate FoundationStatus','FGM_Portal__reason_nonprivate_foundation__c');
        lstGuidestarFields.add('Reseason for Nonprivate FoundationStatus');
     }

    //get recordType Name
    public String getRecordTypeName(String recordTypeId){
        if(lstRecordType != null && lstRecordType.size() > 0){
            for(SelectOption recordType : lstRecordType){
                if(recordTypeId.equalsIgnoreCase(recordType.getValue())){
                    return recordType.getLabel();
                }
            }
        }
        return '';
    }
    // initializeExisting Record if available
    public void initializeConfigurationRecord(){
        configurationRecord = new FGM_Portal__GuidestarFieldMapping__c();
        List<FGM_Portal__GuidestarFieldMapping__c> lstConfigurationRecords;
        if(!mapGuidestarFields.isEmpty() && String.isNotBlank(selectedRecordType)){

            List<String> sanitizedGuidestarFields = new List<String>();

            for (String f : mapGuidestarFields.values()) {
                sanitizedGuidestarFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
            }

              lstConfigurationRecords = (List<FGM_Portal__GuidestarFieldMapping__c>)Database.query(
                'SELECT Id'
                +', '+ String.join(sanitizedGuidestarFields, ', ')
                + ' FROM FGM_Portal__GuidestarFieldMapping__c'
                + ' WHERE RecordTypeId =: selectedRecordType AND FGM_Portal__IsCommunityRecord__c=true'
                + ' WITH SECURITY_ENFORCED'
              );

            if(lstConfigurationRecords == null ||  lstConfigurationRecords.isEmpty()){
                    configurationRecord = new FGM_Portal__GuidestarFieldMapping__c();
                    configurationRecord.RecordTypeId =  selectedRecordType;
                    configurationRecord.FGM_Portal__IsCommunityRecord__c =  true;
            }
            else{
                configurationRecord = lstConfigurationRecords[0];
            }
        }

    }

    public PageReference saveRecord(){
        if(configurationRecord != null){
            if((configurationRecord.Id==null)) {
                CrudFlsService.getInstance().assertUpdateable(configurationRecord);
                upsert configurationRecord;
            }
        }
        return null;
    }

    public PageReference cancel(){
        lstGuidestarFields = null;
        mapGuidestarFields = null;
        selectedRecordType = '';
        recordTypeName = '';
        configurationRecord = null;
        return null;
    }
}