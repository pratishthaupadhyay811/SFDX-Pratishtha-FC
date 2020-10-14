@isTest
private class TestLeadConversion
{
    public static testMethod void PGRequestNumberTest()
    {
        Test.startTest();
        //Create Lead Object
        Lead lead = new Lead();
        lead.Company = 'Enzigma';
        lead.LastName = 'Gupta';
        lead.FirstName = 'Akhilesh';
        lead.Status = 'New';
        insert lead;

        FGM_Portal__Portal_Permission__c portalpermission = new FGM_Portal__Portal_Permission__c();
        portalpermission.FGM_Portal__Lead__c = lead.Id;
        insert portalpermission;
        System.assertNotEquals(portalpermission.id, null);

        Database.LeadConvert leadCnvert = new database.LeadConvert();
        leadCnvert.setLeadId(lead.id);
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1 ];
        leadCnvert.setConvertedStatus(convertStatus.MasterLabel);
        leadCnvert.setDoNotCreateOpportunity(false);

        Database.LeadConvertResult leadCnvertRslt = Database.convertLead(leadCnvert);
        System.assert(leadCnvertRslt.isSuccess());
        List<Lead> lstCnvrtdLead = new List<Lead>([SELECT Id, Name, IsConverted, ConvertedOpportunityId FROM Lead WHERE IsConverted = TRUE LIMIT 1]);
        LeadConversion.UpdateLeadsOpportunities(new List<Lead>{lead},lstCnvrtdLead);

        Test.stopTest();
    }
}