@isTest
public class CampaignTriggerHandlerTests {
    static testmethod void changeFileVisibility(){
        Campaign campaign = new Campaign(Name='Test Campaign',FGM_Portal__Visibility__c='Public');
        insert campaign;
        system.assertNotEquals( campaign.Id, null );
        Blob data = Blob.valueOf('Test Version Data');
        ContentVersion contentVersion = new ContentVersion(Title='Test Version',PathOnClient='Test Path',VersionData=data);
        insert contentVersion;
        contentVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id=:contentVersion.Id];
        ContentDocumentLink contentDoclink = new ContentDocumentLink(ContentDocumentId=contentVersion.ContentDocumentId,LinkedEntityId=campaign.Id,ShareType='V',Visibility='InternalUsers');
        insert contentDoclink;
        contentDoclink = [SELECT Visibility FROM ContentDocumentLink WHERE LinkedEntityId=:campaign.Id];
        system.assertEquals( contentDoclink.Visibility, 'AllUsers');
        campaign.FGM_Portal__Visibility__c = 'Private';
        update campaign;
        contentDoclink = [SELECT Visibility FROM ContentDocumentLink WHERE LinkedEntityId=:campaign.Id];
        system.assertEquals( contentDoclink.Visibility, 'InternalUsers');
    }
}