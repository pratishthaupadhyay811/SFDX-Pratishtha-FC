public with sharing class CommunityStateCountryConfigController
{
    public List<FGM_Portal__StateCountryConfig__c> lstStateCountryConfig {get; set;}
    public List<wrapperStateCountry> lstwrapperStateCountry {get; set;}
    public wrapperStateCountry objwrapperStateCountry {get;set;}
    public Map<String, Object> mapStateCode {get; set;}

    public CommunityStateCountryConfigController()
    {
        lstwrapperStateCountry = new List<wrapperStateCountry>();

        lstStateCountryConfig = [
            SELECT
                CountryCode__c,
                Name,
                PicklistValues__c
            FROM StateCountryConfig__c
            WITH SECURITY_ENFORCED
            ORDER BY Name
            LIMIT 10000
        ];

        if(lstStateCountryConfig!=null && !lstStateCountryConfig.isEmpty() )
        {
            for(FGM_Portal__StateCountryConfig__c obj : lstStateCountryConfig)
            {
                 objwrapperStateCountry = new wrapperStateCountry();
                 mapStateCode = (Map<String, Object>)JSON.deserializeUntyped(obj.FGM_Portal__PicklistValues__c);
                 objwrapperStateCountry.countryName = obj.Name;
                 objwrapperStateCountry.stateCount = mapStateCode.size();
                 lstwrapperStateCountry.add(objwrapperStateCountry);
            }
        }
        else
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, 'No records to display'));
    }
    public class wrapperStateCountry
    {
        public String countryName {get; set;}
        public Integer stateCount {get; set;}
    }
    public List<wrapperStateCountry> getStateCountries()
    {
        return lstwrapperStateCountry;
    }
    public PageReference SyncStateCountries()
    {
        try
        {
            string scplJSONData = '';
            StateCountryConfig__c StateCountryConfig ;
            pickListMeta.Metadata1 service = new pickListMeta.Metadata1();
            service.SessionHeader = new pickListMeta.SessionHeader_element();
            service.SessionHeader.sessionId = UserInfo.getSessionId();
            pickListMeta.AddressSettings ad = new pickListMeta.AddressSettings();
            String[] fullname = new String[1];
            fullname[0]='Address';
            String type1 = 'AddressSettings';
            PickListMeta.ReadResult result = service.readMetadata(type1,fullname);
            for(PickListMeta.Metadata record :result.records)
            {
                for(PickListMeta.CountriesAndStates mapping :record.countriesAndStates)
                {
                    for(PickListMeta.Country country :mapping.countries)
                    {
                        scplJSONData = '{';
                        StateCountryConfig = new StateCountryConfig__c();
                        if( country.states != null && country.states.size() >= 0)
                        {
                            for(PickListMeta.state state :country.states)
                            {
                                scplJSONData = scplJSONData + '"' + state.isoCode + '":"' + state.label + '",';
                            }
                        }
                            StateCountryConfig.Name = country.Label;
                            StateCountryConfig.CountryCode__c = country.isoCode;
                            StateCountryConfig.PicklistValues__c = scplJSONData.substringBeforeLast(',') + '}';
                            lstStateCountryConfig.add(StateCountryConfig);

                    }
                }
            }
            if(!lstStateCountryConfig.isEmpty()) {
                CrudFlsService.getInstance().assertUpdateable(lstStateCountryConfig);
                Database.upsert(lstStateCountryConfig,false);
            }
            PageReference pageReference = new PageReference('/apex/communitystatecountryconfig');
            pageReference.setRedirect(true);
            return pageReference ;
        }
        catch(exception ex)
        {
            System.debug('*****---'+ex.getMessage() + '  ' + ex.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, ex.getMessage()));
        }
        return null;
    }
    public PageReference Cancel()
    {
        PageReference pageReference = new PageReference('/apex/FCPortalManager');
        pageReference.setRedirect(true);
        return pageReference ;
    }
}