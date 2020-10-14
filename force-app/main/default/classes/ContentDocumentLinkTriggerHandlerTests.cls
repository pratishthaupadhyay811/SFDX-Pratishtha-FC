@isTest
public class ContentDocumentLinkTriggerHandlerTests {
    @testSetup
    static void setupData(){
        List<Id> lstSobjectId = new List<Id>();
        Campaign campaign = new Campaign(Name='Test Campaign',FGM_Portal__Visibility__c='Public');
        insert campaign;
        lstSobjectId.add(campaign.Id);

        FGM_Portal__Quiz__c quiz = new FGM_Portal__Quiz__c();
        insert quiz;
        lstSobjectId.add(quiz.Id);

        FGM_Portal__Campaign_Quiz__c campQuiz = new FGM_Portal__Campaign_Quiz__c(FGM_Portal__Campaign__c = campaign.Id, FGM_Portal__Quiz__c = quiz.Id);
        insert campQuiz;
        lstSobjectId.add(campQuiz.Id);
        List<ContentVersion> lstContentVersion = new List<ContentVersion>();
        for(Integer index = 0; index <= 2; index++){
            Blob data = Blob.valueOf('Test Version Data'+index);
            ContentVersion contentVersion = new ContentVersion(Title='Test Version'+index, PathOnClient='Test Path'+index, VersionData=data);
            lstContentVersion.add(contentVersion);
        }
        insert lstContentVersion;
        lstContentVersion = [SELECT Id, ContentDocumentId From ContentVersion limit 10];
        List<ContentDocumentLink> lstContentDocumentLink = new List<ContentDocumentLink>();
        for(Integer index = 0; index <= 2; index++){
            ContentDocumentLink contentDoclink = new ContentDocumentLink(ContentDocumentId=lstContentVersion[index].ContentDocumentId,LinkedEntityId=lstSobjectId.get(index),ShareType='V',Visibility='InternalUsers');
            lstContentDocumentLink.add(contentDoclink);
        }
        insert lstContentDocumentLink;
    }
    static testmethod void changeFileVisibility(){
        List<ContentVersion> lstContentVersion = [SELECT Id,ContentDocumentId From ContentVersion limit 2];
        System.assert(!lstContentVersion.isEmpty());
        List<ContentDocumentLink> lstContentDocumentLink = [SELECT Id,ContentDocumentId,LinkedEntityId,Visibility,ShareType FROM ContentDocumentLink WHERE ContentDocumentId =: lstContentVersion[0].ContentDocumentId];
        ContentDocumentLinkTriggerHandler.changeFileVisibility(lstContentDocumentLink);
        System.assert(!lstContentDocumentLink.isEmpty());
    }
}