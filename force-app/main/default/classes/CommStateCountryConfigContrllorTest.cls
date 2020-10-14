@isTest(SeeAllData=true)
public class CommStateCountryConfigContrllorTest
{
    static testMethod void CommunityStateCountryConfigController()
    {
        PickListMeta objPickListMeta = new PickListMeta();
        PickListMeta.ReadResult objReadResult = new PickListMeta.ReadResult();
        PickListMeta.Metadata record = new PickListMeta.Metadata();
        PickListMeta.Country country = new PickListMeta.Country();
        PickListMeta.state state =  new PickListMeta.state();
        pickListMeta.Metadata1 service = new pickListMeta.Metadata1();
        pickListMeta.AddressSettings ad = new pickListMeta.AddressSettings();

        Test.startTest();

        List<FGM_Portal__StateCountryConfig__c> lstStateCountryConfig = new List<FGM_Portal__StateCountryConfig__c>();
        List<User> lstSysAdminUsers = [ SELECT Id
                                        FROM User
                                        WHERE Profile.Name ='System Administrator'
                                        AND IsActive = true
                                      ];
        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        account.OwnerId = lstSysAdminUsers[0].Id;
        Boolean isSCPLEnable = Account.getSobjectType().getDescribe().fields.getMap().keySet().contains('billingcountrycode');

        if(isSCPLEnable)
        {
            account.put('BillingCountryCode','IN');
            account.put('BillingStateCode','MH');
        }
        else
        {
            account.put('BillingCountry','India');
            account.put('BillingState','Maharashtra');
        }

        Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});
        System.runAs(lstSysAdminUsers[0])
        {
            FGM_Portal__StateCountryConfig__c objStateCountryConfig = new FGM_Portal__StateCountryConfig__c();
            objStateCountryConfig.Name = 'India';
            objStateCountryConfig.FGM_Portal__CountryCode__c = 'IN';
            objStateCountryConfig.FGM_Portal__PicklistValues__c = '{"MH":"Maharashtra","ML":"Meghalaya","MN":"Manipur","MP":"Madhya Pradesh"}';

            CommunityStateCountryConfigController commStateCountryConfig = new CommunityStateCountryConfigController();
            PageReference syncPage = commStateCountryConfig.SyncStateCountries();
            PageReference CancelPage = commStateCountryConfig.Cancel();
        }
        Test.stopTest();
    }

}