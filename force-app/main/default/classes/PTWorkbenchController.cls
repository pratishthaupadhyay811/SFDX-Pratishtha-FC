public with sharing class PTWorkbenchController {
    public string strPortalLanguage {get; set;}
    public FieldInformation objFieldInfo {get; set;}
    public FGM_Portal__PortalTranslationWorkbench__c objTranslation {get; set;}
    private Map<String,integer> mapMessageFields {get; set;}
    private Map<String,integer> mapErrorFields {get; set;}
    private Map<String,integer> mapLabelFields {get; set;}
    private Map<String,integer> mapOtherFields {get; set;}
    private Map<String,integer> mapbtnLabelFields {get; set;}
    public List<String> lstbtnLabelFields {get; set;}
    public List<String> lstMessageFields {get; set;}
    public List<String> lstErrorFields {get; set;}
    public List<String> lstLabelFields {get; set;}
    public List<String> lstOtherFields {get; set;}
    public Boolean IsLanguageSelected {get; set;}
    public PTWorkbenchController() {
            objFieldInfo = new FieldInformation();
            objTranslation = new FGM_Portal__PortalTranslationWorkbench__c();
            mapMessageFields = new Map<String,integer>();
            mapErrorFields = new Map<String,integer>();
            mapLabelFields = new Map<String,integer>();
            mapOtherFields = new Map<String,integer>();
            mapbtnLabelFields = new Map<String,integer>();
            lstbtnLabelFields = new List<String>();
            lstMessageFields = new List<String>();
            lstErrorFields = new List<String>();
            lstLabelFields = new List<String>();
            lstOtherFields = new List<String>();
    }
    public void LoadLanguage(){
          string languageQuery = '';
        if(objFieldInfo.CurrentTranslation != null && strPortalLanguage != null && strPortalLanguage != '') {
            Pattern isValidCulture = Pattern.Compile('^[a-z]{2}-[A-Z]{2}|[a-z]{2}$');
            Matcher cutureMatch = isValidCulture.matcher(strPortalLanguage);
            if(!cutureMatch.Matches()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error ,'Invallid Language code.'));
                return;
            }
                objFieldInfo = new FieldInformation();
                IsLanguageSelected = true;
                SObjectType objToken = Schema.getGlobalDescribe().get('FGM_Portal__PortalTranslationWorkbench__c');
                DescribeSObjectResult objDef = objToken.getDescribe();
                Map<String, SObjectField> fields = objDef.fields.getMap();
                Set<String> fieldSet = fields.keySet();
                List<String> fieldsToQuery = new List<String>();
                languageQuery = 'SELECT ';
                for(String s:fields.keySet()) {
                    DescribeFieldResult selectedField = fields.get(s).getDescribe();
                    if (selectedField.getName().contains('LastViewedDate') || selectedField.getName().contains('LastReferencedDate')) {
                        continue;
                    }
                    fieldsToQuery.add(selectedField.getName());
                }
                if(fieldsToQuery!=null && fieldsToQuery.size()>0)
                    languageQuery += String.join(fieldsToQuery, ',');
                languageQuery += ' FROM FGM_Portal__PortalTranslationWorkbench__c where FGM_Portal__LanguageCode__c= : strPortalLanguage WITH SECURITY_ENFORCED';

                List<FGM_Portal__PortalTranslationWorkbench__c> lstLanguageConfig = null;
                lstLanguageConfig = Database.query(LanguageQuery);
                if(lstLanguageConfig != null && lstLanguageConfig.size() > 0)
                    objFieldInfo.CurrentTranslation  = lstLanguageConfig[0];

                for(String s:fieldSet) {
                    SObjectField fieldToken = fields.get(s);
                    DescribeFieldResult selectedField = fieldToken.getDescribe();
                    if(selectedField.getName().contains('FGM_Portal__LanguageCode__c')){
                        continue;
                    }
                    if(selectedField.getName().contains('__c')) {
                      integer intDefaultLength = 0;
                          objFieldInfo.mapLabel.put(selectedField.getName(),selectedField.getLabel());
                          objFieldInfo.mapDescription.put(selectedField.getName(),String.valueOf(selectedField.getDefaultValueFormula()));
                      if(String.valueOf(selectedField.getDefaultValueFormula()) != null && String.valueOf(selectedField.getDefaultValueFormula()) != '') {
                           intDefaultLength = (String.valueOf(selectedField.getDefaultValueFormula())).length();
                           string DefaultValue = String.valueOf(selectedField.getDefaultValueFormula());
                           DefaultValue = DefaultValue.Replace('\'','');
                           DefaultValue = DefaultValue.Replace('\\','\'');
                           DefaultValue = DefaultValue.Replace('& BR() &','<br/>');
                           DefaultValue = DefaultValue.Replace('&BR()&','<br/>');
                           objFieldInfo.mapDescription.put(selectedField.getName(),DefaultValue);
                      } else{
                            objFieldInfo.mapDescription.put(selectedField.getName(),'');
                        }

                      if(String.valueOf(selectedField.getInlineHelpText()) != null && String.valueOf(selectedField.getInlineHelpText()) != '') {
                           objFieldInfo.mapHelpData.put(selectedField.getName(),String.valueOf(selectedField.getInlineHelpText()));
                      } else{
                            objFieldInfo.mapHelpData.put(selectedField.getName(),'Help Text not provided');
                        }

                      if(selectedField.getName().contains('_Error__c')){
                           mapErrorFields.put(selectedField.getName(),intDefaultLength);
                       } else if(selectedField.getName().contains('_Msg__c'))     {
                          mapMessageFields.put(selectedField.getName(),intDefaultLength);
                       } else if(selectedField.getName().contains('_Label__c'))     {
                          mapLabelFields.put(selectedField.getName(),intDefaultLength);
                       } else if(selectedField.getName().contains('_btnLabel__c') || selectedField.getName().contains('_lnkLabel__c'))     {
                          mapbtnLabelFields.put(selectedField.getName(),intDefaultLength);
                       } else if(selectedField.getName().contains('__c')){
                         mapOtherFields.put(selectedField.getName(),intDefaultLength);
                       }
                    }
                }
                SortMap();
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error ,'Language code should not be Empty.'));
            return;
        }
    }
    public void SortMap() {
        if(mapLabelFields != null && mapLabelFields.size() > 0) {
             lstLabelFields = new List<String>();
            lstLabelFields = getSortedList(mapLabelFields);
        }
        if(mapbtnLabelFields != null && mapbtnLabelFields.size() > 0) {
             lstbtnLabelFields = new List<String>();
            lstbtnLabelFields= getSortedList(mapbtnLabelFields);
        }
        if(mapMessageFields != null && mapMessageFields.size() > 0) {
            lstMessageFields = new List<String>();
            lstMessageFields = getSortedList(mapMessageFields);
        }
        if(mapErrorFields != null && mapErrorFields.size() > 0) {
            lstErrorFields = new List<String>();
            lstErrorFields = getSortedList(mapErrorFields);
        }
       if(mapOtherFields != null && mapOtherFields.size() > 0) {
            lstOtherFields = new List<String>();
            lstOtherFields = getSortedList(mapOtherFields);
        }
    }

     private List<String> getSortedList(Map<String,integer> mapFields) {
        List<String> lstSorted = new List<String>();
        integer currentSize = 0;
        if(mapFields != null && mapFields.size() > 0) {
            List<integer> lstSortable = new List<integer>();
            lstSortable.addAll(mapFields.values());
            lstSortable.sort();
            for(integer index : lstSortable) {
                for(string fieldname : mapFields.KeySet()) {
                    if(index == mapFields.get(fieldname)) {
                        lstSorted.add(fieldname);
                        mapFields.remove(fieldname);
                    }
                }
            }
        }
        return lstSorted;
    }

    public PageReference PreviousClick() {
        PageReference HomePage = new PageReference(URL.getCurrentRequestUrl().toExternalForm());
        HomePage.setRedirect(true);
        return HomePage;    }

    public PageReference CancelClick() {
        PageReference HomePage = new PageReference(URL.getSalesforceBaseUrl().toExternalForm());
        return HomePage;
    }

    public PageReference SaveLanguage() {
        if(objFieldInfo.CurrentTranslation != null && strPortalLanguage != null && strPortalLanguage != '') {
            try {
                objFieldInfo.CurrentTranslation.LanguageCode__c = strPortalLanguage;
                if(objFieldInfo.CurrentTranslation.Id==null)
                {
                    CrudFlsService.getInstance().assertUpdateable(objFieldInfo.CurrentTranslation);
                    Database.upsert(objFieldInfo.CurrentTranslation);
                    PageReference HomePage = new PageReference(URL.getSalesforceBaseUrl().toExternalForm());
                    return HomePage;
                }
            } catch(Exception e)  {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error ,'An error occurred in the wizard. For more information contact the administrator.'));
                 return null;
            }
        }
        return null;
    }

    public class FieldInformation {
        public FGM_Portal__PortalTranslationWorkbench__c CurrentTranslation {get; set;}
        public Map<String,String> mapLabel {get; set;}
        public Map<String,String> mapDescription {get; set;}
        public Map<string,string> mapHelpData {get; set;}

        public FieldInformation() {
          CurrentTranslation = new FGM_Portal__PortalTranslationWorkbench__c ();
          mapLabel = new Map<String,String>();
          mapDescription = new Map<String,String>();
          mapHelpData = new Map<String,String>();
        }
    }
}