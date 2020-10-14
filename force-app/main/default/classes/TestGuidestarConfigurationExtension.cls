@isTest
private class TestGuidestarConfigurationExtension{
    static testMethod void GuidestarConfigurationExtension(){
        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

        Map<String,Schema.Recordtypeinfo> newGuidestarFieldRecordTypeMapByName = FGM_Portal__GuidestarFieldMapping__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        List<FGM_Portal__GuidestarFieldMapping__c> lstFGMPortalGuidestarFieldMapping = new List<FGM_Portal__GuidestarFieldMapping__c>();

        lstFGMPortalGuidestarFieldMapping.add(TestsObjectProvider.CreateFGMPortalGuidestarFieldMapping(newGuidestarFieldRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GUIDESTAR_GUIDEPORTALUSER).getRecordTypeId(), 'testRegistered', ResultAccount[0].Id));
        lstFGMPortalGuidestarFieldMapping.add(TestsObjectProvider.CreateFGMPortalGuidestarFieldMapping(newGuidestarFieldRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GUIDESTAR_GUIDECONTACT).getRecordTypeId(), 'testRegistered1', ResultAccount[0].Id));
        lstFGMPortalGuidestarFieldMapping.add(TestsObjectProvider.CreateFGMPortalGuidestarFieldMapping(newGuidestarFieldRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GUIDESTAR_GUIDEORGANIZATION).getRecordTypeId(), 'testRegistered2', ResultAccount[0].Id));
        Database.Saveresult[] ResultsFGMPortalGuidestarFieldMapping = TestsObjectProvider.InsertListWithAssert(lstFGMPortalGuidestarFieldMapping);

        ApexPages.StandardController scFGMPortalGuidestarFieldMapping = new ApexPages.standardController( lstFGMPortalGuidestarFieldMapping[0]);

        GuidestarConfigurationExtension guidestarConfigurationExtension = new GuidestarConfigurationExtension(scFGMPortalGuidestarFieldMapping);
        guidestarConfigurationExtension.initializeConfiguration();
        guidestarConfigurationExtension.selectedRecordType  = newGuidestarFieldRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GUIDESTAR_GUIDEPORTALUSER).getRecordTypeId();
        guidestarConfigurationExtension.initializeFieldsOptions();
        guidestarConfigurationExtension.saveRecord();
        guidestarConfigurationExtension.cancel();

        ApexPages.StandardController scFGMPortalGuidestarFieldMapping1 = new ApexPages.standardController( lstFGMPortalGuidestarFieldMapping[1]);

        GuidestarConfigurationExtension guidestarConfigurationExtension1 = new GuidestarConfigurationExtension(scFGMPortalGuidestarFieldMapping1);
        guidestarConfigurationExtension1.initializeConfiguration();
        guidestarConfigurationExtension1.selectedRecordType  = newGuidestarFieldRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GUIDESTAR_GUIDECONTACT).getRecordTypeId();
        guidestarConfigurationExtension1.initializeFieldsOptions();
        guidestarConfigurationExtension1.saveRecord();
        guidestarConfigurationExtension1.cancel();

        ApexPages.StandardController scFGMPortalGuidestarFieldMapping2 = new ApexPages.standardController( lstFGMPortalGuidestarFieldMapping[2]);

        GuidestarConfigurationExtension guidestarConfigurationExtension2 = new GuidestarConfigurationExtension(scFGMPortalGuidestarFieldMapping2);
        guidestarConfigurationExtension2.initializeConfiguration();
        guidestarConfigurationExtension2.selectedRecordType  = newGuidestarFieldRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GUIDESTAR_GUIDEORGANIZATION).getRecordTypeId();
        guidestarConfigurationExtension2.initializeFieldsOptions();
        guidestarConfigurationExtension2.saveRecord();
        guidestarConfigurationExtension2.cancel();

    }
}