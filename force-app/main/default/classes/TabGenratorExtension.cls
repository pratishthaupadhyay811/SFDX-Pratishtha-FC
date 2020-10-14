public with sharing class TabGenratorExtension {
    public string assoiciatedTab { get; set;}
    public String associatedPortal { get; set; }
    public Boolean showAssociatedTab { get; set; }
    public RelatedListController currentRLCRecord { get; set;}
    public String existingTabRecord { get; set; }
    public List<SelectOption> parentObjects { get; set;}
    public String newTabName { get; set; }
    public List<SelectOption> lstOrgObject;
    public Map<String,String> mapChildrelationShip;
    public List<FGM_Portal__Related_List_Controller__c> lstExistingTabs;
    public List<SelectOption> lstExistingTabOptions { get; set; }
    public List<SelectOption> childObjectFieldsOptions { set; get; }
    public Map<String,String> mapFieldNameByAPI;
    public SFDCEncoder ESAPI = new SFDCEncoder();
    public String portalLanguage {get; set;}
    public List<SelectOption> lstLanguageOptions { get; set; }

    public TabGenratorExtension(ApexPages.StandardController controller) {
        initializePortalLanguages();
    }

    public PageReference rollbackWithError(String message, System.Savepoint savepoint) {
        if (savepoint != null)
            Database.rollback(savepoint);
        if (message != null)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, message));
        return null;
    }

    /// Get All Portal Languages
    private void initializePortalLanguages(){
        if(lstLanguageOptions == null || lstLanguageOptions.isEmpty()){
            lstLanguageOptions = new List<SelectOption>();
            lstLanguageOptions = FCGlobal.getPortalLanguage();
        }
    }

    // Implemented to Get Tab Type
    public List<SelectOption> getTabType(){
        List<SelectOption> lstTabTypes = new List<SelectOption>();
        lstTabTypes.add(new SelectOption('Profile','Profile'));
        return lstTabTypes;
    }

    // Implemented to Get Tab Type
    public List<SelectOption> getPortalType(){
        List<SelectOption> lstPortalTypes = new List<SelectOption>();
        lstPortalTypes.add(new SelectOption('Grantee','Grantee'));
        lstPortalTypes.add(new SelectOption('Reviewer','Reviewer'));
        lstPortalTypes.add(new SelectOption('Consultant','Consultant'));
        return lstPortalTypes;
    }

    public void showassociatedTab(){
        if(String.isNotBlank(associatedPortal))
            showAssociatedTab = true;
        else{
            showAssociatedTab= false;
            assoiciatedTab = null;
        }
    }

    public void getExistingTabs(){
        lstExistingTabOptions = new List<SelectOption>();
        if(String.isNotBlank(assoiciatedTab) && String.isNotBlank(associatedPortal)){

        lstExistingTabs = [
            SELECT
                Associated_FC_Portal_Type__c,
                Associated_Tab_Type__c,
                EnableAmendment__c,
                FieldHeaders__c,
                FieldNames__c,
                Hide_Edit_Link__c,
                RichInstructionalText__c,
                LookupField__c,
                Name,
                ObjectName__c,
                ParentObject__c,
                RecordTypeId,
                ShowDeleteLink__c,
                ShowNewButton__c,
                Show_Tab_to_Individual_Users__c,
                Show_Tab_to_Organization_Users__c,
                SortFieldOrder__c,
                SortField__c,
                SortOrder__c
            FROM Related_List_Controller__c
            WHERE Associated_Tab_Type__c = :assoiciatedTab
            AND Associated_FC_Portal_Type__c = :associatedPortal
            AND Language__c = :portalLanguage
            WITH SECURITY_ENFORCED
            ORDER BY SortOrder__c ASC NULLS LAST
            LIMIT 10000
        ];

        }
        if(lstExistingTabs != null && !lstExistingTabs.isEmpty()){
            for(FGM_Portal__Related_List_Controller__c tabRecord : lstExistingTabs){
                lstExistingTabOptions.add(new SelectOption(tabRecord.Id,tabRecord.Name));
            }
        }
    }
    public void DeleteExistingTabRecord(){
        if(String.isNotBlank(existingTabRecord)){
            FGM_Portal__Related_List_Controller__c tabRecord = getTabRecord(existingTabRecord);
            if(tabRecord != null){
                CrudFlsService.getInstance().assertDeletable(tabRecord);
                Database.Deleteresult deleteResult = Database.delete(tabRecord);
                if(deleteResult.isSuccess())
                    getExistingTabs();
            }

        }
    }
    public void OpenExistingTabRecord(){
        if(String.isNotBlank(existingTabRecord)){
            FGM_Portal__Related_List_Controller__c tabRecord = getTabRecord(existingTabRecord);
            if(tabRecord != null){
                 currentRLCRecord = getcurrentRelatedListRecord(tabRecord);
                 currentRLCRecord.lstRLCFields.addAll(getFieldsList());
            }
        }
    }

    private RelatedListController getcurrentRelatedListRecord(FGM_Portal__Related_List_Controller__c tabRecord){
        RelatedListController RLCRecord = new RelatedListController();
        RLCRecord.currentRelatedListController = tabRecord;
        RLCRecord.currentRelatedListController.FGM_Portal__Hide_Edit_Link__c = !tabRecord.FGM_Portal__Hide_Edit_Link__c;
        RLCRecord.AssociatedType = tabRecord.FGM_Portal__Associated_Tab_Type__c;
        getObjectFields(tabRecord.FGM_Portal__ObjectName__c);
        if(String.isNotBlank(tabRecord.FGM_Portal__FieldHeaders__c) && String.isNotBlank(tabRecord.FGM_Portal__FieldNames__c)){
            List<String> lstLabels = (List<String>)tabRecord.FGM_Portal__FieldHeaders__c.split(',');
            List<String> lstFields = (List<String>)tabRecord.FGM_Portal__FieldNames__c.split(',');
            if(lstLabels != null && lstFields != null){
                columnConfiguration colConfig = null;
                for(integer i=0;i < lstLabels.size() ; i++){
                    if(String.isNotBlank(lstLabels[i]) && i < lstFields.size()){
                        String fieldLabel = getFieldLabel(lstFields[i]);
                        if(String.isNotBlank(fieldLabel)){
                            colConfig = new columnConfiguration();
                            colConfig.colLabel = lstLabels[i];
                            colConfig.colField = lstFields[i];
                            colConfig.colfieldLabel = fieldLabel;
                            RLCRecord.relatedListColumns.add(colConfig);
                        }
                    }
                }
            }
        }
        return RLCRecord;
    }

    @TestVisible private String getFieldLabel(String fieldAPIName){
        if(mapFieldNameByAPI != null && mapFieldNameByAPI.size() > 0 && mapFieldNameByAPI.containsKey(fieldAPIName))
            return mapFieldNameByAPI.get(fieldAPIName);
        return null;
    }

    // To close the RLC form./

    public void closeRLCPopUp() {
        currentRLCRecord = null;
        childObjectFieldsOptions = null;
    }

    public void createNewTab(){
        if(String.isNotBlank(associatedPortal) && String.isNotBlank(assoiciatedTab) && String.isNotBlank(newTabName)){
              FGM_Portal__Related_List_Controller__c newTabRecord = new FGM_Portal__Related_List_Controller__c();
              newTabRecord.Name = newTabName;
              newTabRecord.FGM_Portal__Associated_Tab_Type__c = assoiciatedTab;
              newTabRecord.FGM_Portal__Associated_FC_Portal_Type__c = associatedPortal;
              newTabRecord.Language__c = portalLanguage;
              newTabRecord.FGM_Portal__IsCommunityRecord__c = true;
              newTabRecord.RecordTypeId = FCGlobal.getRecordTypeId(String.valueOf(FGM_Portal__Related_List_Controller__c.sObjectType),'Related List With Tab');
              currentRLCRecord = getcurrentRelatedListRecord(newTabRecord);
              currentRLCRecord.lstRLCFields.addAll(getFieldsList());
        }
    }

    // To add Column in related List Fields column list.

    public void addColumnInRelatedListTable(){
        if(currentRLCRecord != null && String.isNotBlank(currentRLCRecord.newColumn.colLabel) && String.isNotBlank(currentRLCRecord.newColumn.colField)){
            currentRLCRecord.newColumn.colfieldLabel = getFieldLabel(currentRLCRecord.newColumn.colField);
            currentRLCRecord.relatedListColumns.add(currentRLCRecord.newColumn);
            currentRLCRecord.newColumn = new columnConfiguration();
        }
    }

    // To Remove Column from related List Fields column list./

    public void removeColumnFromRelatedListTable(){
        string strColIndex = ESAPI.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('columnIndex'));
        if(String.isNotBlank(strColIndex)){
            integer recordIndex = integer.valueOf(strColIndex);
            if(recordIndex != null && currentRLCRecord.relatedListColumns != null && currentRLCRecord.relatedListColumns.size() > recordIndex){
                columnConfiguration OldColumnRecord = currentRLCRecord.relatedListColumns[recordIndex];
                if(OldColumnRecord != null)
                    currentRLCRecord.relatedListColumns.remove(recordIndex);
            }
        }
    }

    // To Insert/Update the RLC record.
    public PageReference saveRelatedListControllerRecord(){
        if(currentRLCRecord != null && currentRLCRecord.currentRelatedListController != null){
                currentRLCRecord.currentRelatedListController.FGM_Portal__Hide_Edit_Link__c = !currentRLCRecord.currentRelatedListController.FGM_Portal__Hide_Edit_Link__c;
                String strChildLookUpField = '';
                    if(mapChildrelationShip != null && mapChildrelationShip.containsKey(currentRLCRecord.currentRelatedListController.FGM_Portal__ParentObject__c))
                        strChildLookUpField = mapChildrelationShip.get(currentRLCRecord.currentRelatedListController.FGM_Portal__ParentObject__c);
                    else
                        strChildLookUpField = currentRLCRecord.currentRelatedListController.FGM_Portal__LookupField__c;

                    currentRLCRecord.currentRelatedListController.FGM_Portal__LookupField__c = strChildLookUpField;
                    if(currentRLCRecord.relatedListColumns != null && !currentRLCRecord.relatedListColumns.isEmpty()){
                        currentRLCRecord.currentRelatedListController.FGM_Portal__FieldHeaders__c = '';
                        currentRLCRecord.currentRelatedListController.FGM_Portal__FieldNames__c = '';
                        for(columnConfiguration column : currentRLCRecord.relatedListColumns){
                            if(String.isNotBlank(column.colLabel) && String.isNotBlank(column.colField)){
                                if(String.isNotBlank(currentRLCRecord.currentRelatedListController.FGM_Portal__FieldHeaders__c))
                                    currentRLCRecord.currentRelatedListController.FGM_Portal__FieldHeaders__c += ',';
                                if(String.isNotBlank(currentRLCRecord.currentRelatedListController.FGM_Portal__FieldNames__c))
                                    currentRLCRecord.currentRelatedListController.FGM_Portal__FieldNames__c += ',';

                                currentRLCRecord.currentRelatedListController.FGM_Portal__FieldHeaders__c  += column.colLabel;
                                currentRLCRecord.currentRelatedListController.FGM_Portal__FieldNames__c += column.colField;
                             }
                        }
                    }
                    else{
                        currentRLCRecord.currentRelatedListController.FGM_Portal__FieldHeaders__c = '';
                        currentRLCRecord.currentRelatedListController.FGM_Portal__FieldNames__c = '';
                    }

            if(currentRLCRecord.currentRelatedListController.FGM_Portal__SortOrder__c == null)
                currentRLCRecord.currentRelatedListController.FGM_Portal__SortOrder__c = lstExistingTabs != null ? lstExistingTabs.size() + 1 : 1;

            currentRLCRecord.currentRelatedListController.FGM_Portal__IsCommunityRecord__c= true;
            CrudFlsService.getInstance().assertUpdateable(currentRLCRecord.currentRelatedListController);
            upsert currentRLCRecord.currentRelatedListController;
            currentRLCRecord = null;
            mapChildrelationShip = null;
            newTabName = '';
            getExistingTabs();
        }
        return null;
    }

    private FGM_Portal__Related_List_Controller__c getTabRecord(String TabId){
        if(String.isNotBlank(TabId) && lstExistingTabs != null && !lstExistingTabs.isEmpty()){
            for(FGM_Portal__Related_List_Controller__c tabRecord : lstExistingTabs){
                if(TabId.equalsIgnoreCase(String.valueOf(tabRecord.Id)))
                    return tabRecord;
            }
        }
        return null;
    }

    // To initilize the New RelatedListController record.
   public void addTab() {
        currentRLCRecord = new RelatedListController();
        currentRLCRecord.currentRelatedListController.FGM_Portal__Associated_Tab_Type__c = assoiciatedTab;
        currentRLCRecord.AssociatedType = assoiciatedTab;
        currentRLCRecord.lstRLCFields.addAll(getFieldsList());
    }

    public void getObjectFields(){
        getObjectFields(currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c);
        currentRLCRecord.lstRLCFields.clear();
        currentRLCRecord.lstRLCFields.addAll(getFieldsList());
    }

    // To handle RLC tab Functionality/Fill Child Object picklist.

    @TestVisible private void getObjectFields(String ObjectName) {
        List<SelectOption> lstChildObjectFields = new List<SelectOption>();
        childObjectFieldsOptions = new List<SelectOption>();
        parentObjects = new List<SelectOption>();
        mapChildrelationShip = new Map<String,String>();
        if(String.isNotBlank(ObjectName)){
            if(mapFieldNameByAPI == null)
                mapFieldNameByAPI = new Map<String,String>();
                Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe();
                Schema.SObjectType sObjectType = sObjectMap.get(ObjectName); // getting Sobject Type
                Schema.DescribeSObjectResult resSchema = sObjectType.getDescribe();
                Map <String, Schema.SObjectField> childObjectFields = resSchema.fields.getMap();
                if(childObjectFields != null && !childObjectFields.isEmpty()){
                    for(Schema.SObjectField sfield : childObjectFields.Values()) {
                        schema.describefieldresult dfield = sfield.getDescribe();
                        lstChildObjectFields.add(new SelectOption(dfield.getName(),dfield.getLabel()));
                        mapFieldNameByAPI.put(dfield.getName(),dfield.getLabel());
                    }
                }

                if(String.isNotBlank(assoiciatedTab) && assoiciatedTab.equalsIgnoreCase('Dashboard'))
                    initializeParents(ObjectName);
                else if(String.isNotBlank(assoiciatedTab) && assoiciatedTab.equalsIgnoreCase('Profile') && currentRLCRecord != null && currentRLCRecord.currentRelatedListController != null){
                    currentRLCRecord.currentRelatedListController.FGM_Portal__ParentObject__c = String.valueof(Account.getsObjectType());
                    currentRLCRecord.currentRelatedListController.FGM_Portal__LookupField__c = FCGlobal.getRelationalField(Account.sObjectType, ObjectName);
                }
        }
        childObjectFieldsOptions.addAll(lstChildObjectFields);
    }

    public void initializeParents(String objectName){
        Set<String> excludeObjects = new Set<String> {'User','RecordType','Group'};
        if(parentObjects != null && String.isNotBlank(objectName)){
            Map<String,Schema.SObjectField> mapObjectFields = FCGlobal.getMapsObjectFields(objectName);
            if(mapObjectFields != null){
                for(Schema.SObjectField objectField : mapObjectFields.values()){
                    Schema.DescribeFieldResult FieldDescribe = objectField.getDescribe();
                    if(FieldDescribe.getType() == Schema.DisplayType.Reference){
                        List<Schema.sObjectType> parentObject = FieldDescribe.getReferenceTo();
                        if(parentObject[0].getDescribe().isQueryable() && !excludeObjects.contains(parentObject[0].getDescribe().getName()) ){
                            mapChildrelationShip.put(parentObject[0].getDescribe().getName(),FieldDescribe.getName());
                            parentObjects.add(new SelectOption(parentObject[0].getDescribe().getName(),parentObject[0].getDescribe().getLabel()));
                        }
                     }
                 }
             }
         }
    }

    // To define the required fields of RLC object on form.

    public List<Map<String,String>> getFieldsList(){
        List<Map<String,String>> lstRTFields = new List<Map<String,String>>();
        Map<String,String> mapField = new Map<String,String>{'Name' => 'Tab Name'};
        lstRTFields.add(mapField);
            if(String.isNotBlank(assoiciatedTab) && assoiciatedTab.equalsIgnoreCase('Profile')){
                mapField = new Map<String,String>{'FGM_Portal__ObjectName__c' => 'Select Object'};
                lstRTFields.add(mapField);
            }
            else if(String.isNotBlank(assoiciatedTab) && assoiciatedTab.equalsIgnoreCase('Dashboard')){
                mapField = new Map<String,String>{'FGM_Portal__ObjectName__c' => 'Select Object'};
                lstRTFields.add(mapField);
            }

            mapField = new Map<String,String>{'FGM_Portal__SortOrder__c' => 'Tab Sort Order'};
            lstRTFields.add(mapField);

            if(String.isNotBlank(assoiciatedTab) && assoiciatedTab.equalsIgnoreCase('Dashboard')){
                 mapField = new Map<String,String>{'FGM_Portal__ParentObject__c' => 'Select Parent Object'};
                lstRTFields.add(mapField);
            }
            mapField = new Map<String,String>{'FGM_Portal__SortField__c' => 'Sort Field'};
                lstRTFields.add(mapField);
            mapField = new Map<String,String>{'FGM_Portal__SortFieldOrder__c' => 'Sort Field Order'};
                lstRTFields.add(mapField);
            mapField = new Map<String,String>{'FGM_Portal__ShowNewButton__c' => 'Show New Button'};
                lstRTFields.add(mapField);
            mapField = new Map<String,String>{'FGM_Portal__Hide_Edit_Link__c' => 'Show Edit Link'};
                lstRTFields.add(mapField);
            mapField = new Map<String,String>{'FGM_Portal__ShowDeleteLink__c' => 'Show Delete Link'};
                lstRTFields.add(mapField);
            mapField = new Map<String,String>{'FGM_Portal__Show_Tab_to_Individual_Users__c' => 'Show Tab to Individual Users'};
                lstRTFields.add(mapField);
            mapField = new Map<String,String>{'FGM_Portal__Show_Tab_to_Organization_Users__c' => 'Show Tab to Organization Users'};
                lstRTFields.add(mapField);

        if(currentRLCRecord != null && currentRLCRecord.currentRelatedListController != null && String.isNotBlank(currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c)){
            string lookUpOnAmendment = FCGlobal.getRelationalField(currentRLCRecord.currentRelatedListController.FGM_Portal__ObjectName__c, Amendment__c.sObjectType);
            if(String.IsNotBlank(lookUpOnAmendment)){
                mapField = new Map<String,String>{String.valueOf(FGM_Portal__Related_List_Controller__c.Fields.EnableAmendment__c) => 'Enable Amendment'};
                lstRTFields.add(mapField);
            }
            else
                currentRLCRecord.currentRelatedListController.EnableAmendment__c = false;
         }
         mapField = new Map<String,String>{'FGM_Portal__RichInstructionalText__c' => 'InstructionText'};
           lstRTFields.add(mapField);

        return lstRTFields;
    }

    public List<SelectOption> getAvailableObjects(){
        if(lstOrgObject == null || lstOrgObject.isEmpty()){
            lstOrgObject = getOrgObjects();
            return lstOrgObject;
        }
        else
            return lstOrgObject;
    }

    private List<SelectOption> getOrgObjects() {
        List<SelectOption> FieldOptions = new List<SelectOption>();
        if(String.isNotBlank(assoiciatedTab) && assoiciatedTab.equalsIgnoreCase('Dashboard')){
            List<Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe().Values();
            for(Schema.SObjectType orgObject : globalDescribe) {
                Schema.DescribeSObjectResult objectdescribe = orgObject.getDescribe();
                if(objectdescribe.isAccessible() && objectdescribe.isQueryable() && objectdescribe.isCreateable() && (objectdescribe.isCustom() || 'Account'.equalsIgnoreCase(objectdescribe.getLocalName()) || 'Contact'.equalsIgnoreCase(objectdescribe.getLocalName()) || 'Opportunity'.equalsIgnoreCase(objectdescribe.getLocalName()) || 'Lead'.equalsIgnoreCase(objectdescribe.getLocalName())))
                    FieldOptions.add(new Selectoption(objectdescribe.getName(),objectdescribe.getLabel()));
            }
        }
        else if(String.isNotBlank(assoiciatedTab) && assoiciatedTab.equalsIgnoreCase('Profile'))
            FieldOptions.addAll(getChildObjects('Account'));

        return FieldOptions;
    }

    private List<SelectOption> getChildObjects(String objectName){
        List<SelectOption> lstChildObject = new List<SelectOption>();
        if(String.isNotBlank(objectName)){
            Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe();
            Schema.SObjectType sObjectType = sObjectMap.get(objectName); // getting Sobject Type

            if(sObjectType == null)
                return lstChildObject;

            Schema.DescribeSObjectResult resSchema = sObjectType.getDescribe();
            if(resSchema != null){
                List<Schema.ChildRelationship> childObjects = resSchema.getChildRelationships();
                for (Schema.ChildRelationship childrelationship: childObjects){
                    Schema.DescribeSObjectResult childResSchema = childrelationship.getChildSObject().getDescribe();
                    if(childResSchema.getLocalName().endsWith('__c') && !childResSchema.getLocalName().endsWith('Question_Attachment__c')){
                        lstChildObject.add(new SelectOption(childResSchema.getName(),childResSchema.getLabel()));
                        if(mapChildrelationShip == null)
                            mapChildrelationShip = new Map<String,String>();

                        mapChildrelationShip.put(childResSchema.getName(),childrelationship.getField().getDescribe().getName());
                    }
                }
            }
        }
        return lstChildObject;
    }

    //  To handle RLC tab Functionality.
    public class RelatedListController{
        public FGM_Portal__Related_List_Controller__c currentRelatedListController { get; set; }
        public List<Map<String,String>> lstRLCFields { get; set; }
        public List<columnConfiguration> relatedListColumns { get; set; }
        public columnConfiguration newColumn { get; set; }
        public String AssociatedType { get; set; }

        public RelatedListController(){
            relatedListColumns = new List<columnConfiguration>();
            lstRLCFields = new List<Map<String,String>>();
            currentRelatedListController = new FGM_Portal__Related_List_Controller__c();
            newColumn = new columnConfiguration();
        }
    }

    public class columnConfiguration{
        public String colLabel { get; set; }
        public String colField { get; set; }
        public String colfieldLabel { get; set; }
    }
}