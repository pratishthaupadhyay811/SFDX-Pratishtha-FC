/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestOnPortalPermissionInsert {

    static testMethod void TestAvoidCreatingDuplicatest() {
        // TO DO: implement unit test
        Account newAccount = new Account(Name='TestAccountName');
        Database.SaveResult saveAccount = Database.insert(newAccount);
        System.assertNotEquals(saveAccount.getId(), null);

        Contact newContact = new Contact(Account = newAccount,LastName='TestContactName',Email='baswaraj.patil@enzigma.com');
        Database.SaveResult saveContact = Database.insert(newContact);
        System.assertNotEquals(saveContact.getId(), null);

        Lead newLead = new Lead(LastName='TestLeadName',Company='TestCompany');
        Database.SaveResult saveLead = Database.insert(newLead);
        System.assertNotEquals(saveLead.getId(), null);

        FGM_Portal__Portal_Permission__c newPortalPermission = new FGM_Portal__Portal_Permission__c();
        newPortalPermission.FGM_Portal__Lead__c = newLead.Id;
        newPortalPermission.FGM_Portal__Contact__c = newContact.Id;
        newPortalPermission.FGM_Portal__Account__c = newAccount.Id;
        Database.SaveResult savePortalPermission = Database.insert(newPortalPermission);
        System.assertNotEquals(savePortalPermission.getId(), null);

        FGM_Portal__Portal_Permission__c duplicatePortalPermission = new FGM_Portal__Portal_Permission__c();
        duplicatePortalPermission.FGM_Portal__Lead__c = newLead.Id;
        duplicatePortalPermission.FGM_Portal__Contact__c = newContact.Id;
        duplicatePortalPermission.FGM_Portal__Account__c = newAccount.Id;
        Database.SaveResult saveDuplicatePortalPermission = Database.insert(duplicatePortalPermission, false);
        System.assertNotEquals(saveDuplicatePortalPermission.getErrors(), null);

        Opportunity newOpportunity = new Opportunity(Name = 'TestOpportunityName-' + Date.today(), StageName='Qualification', CloseDate = Date.today().addDays(2));
        Database.SaveResult saveOpp = Database.insert(newOpportunity, false);
        System.assertNotEquals(saveOpp.getId(), null);

        FGM_Portal__Portal_Permission__c dupLeadOppPortalPermission = new FGM_Portal__Portal_Permission__c();
        dupLeadOppPortalPermission.FGM_Portal__Lead__c = newLead.Id;
        dupLeadOppPortalPermission.FGM_Portal__Opportunity__c = newOpportunity.Id;
        dupLeadOppPortalPermission.FGM_Portal__Contact__c = newContact.Id;
        dupLeadOppPortalPermission.FGM_Portal__Account__c = newAccount.Id;
        Database.SaveResult saveDupLeadPortalPermission = Database.insert(dupLeadOppPortalPermission, false);
        System.assertNotEquals(saveDupLeadPortalPermission.getErrors(), null);

        FGM_Portal__Portal_Permission__c newOppPortalPermission = new FGM_Portal__Portal_Permission__c();
        newOppPortalPermission.FGM_Portal__Opportunity__c = saveOpp.getId();
        newOppPortalPermission.FGM_Portal__Contact__c = newContact.Id;
        newOppPortalPermission.FGM_Portal__Account__c = newAccount.Id;
        Database.SaveResult saveNewOppPortalPermission = Database.insert(newOppPortalPermission, false);
        System.debug(saveNewOppPortalPermission.isSuccess() + ' Error :' + saveNewOppPortalPermission.getErrors());
        System.assertEquals(saveNewOppPortalPermission.isSuccess(), true);

        FGM_Portal__Portal_Permission__c dupOppPortalPermission = new FGM_Portal__Portal_Permission__c();
        dupOppPortalPermission.FGM_Portal__Opportunity__c = saveOpp.getId();
        dupOppPortalPermission.FGM_Portal__Contact__c = newContact.Id;
        dupOppPortalPermission.FGM_Portal__Account__c = newAccount.Id;
        Database.SaveResult saveDuOppPortalPermission = Database.insert(dupOppPortalPermission, false);
        System.assertNotEquals(saveDuOppPortalPermission.getErrors(), null);

        FGM_Portal__Portal_Permission__c dupOppPortalPermission2 = new FGM_Portal__Portal_Permission__c();
        dupOppPortalPermission2.FGM_Portal__Opportunity__c = saveOpp.getId();
        dupOppPortalPermission2.FGM_Portal__Contact__c = newContact.Id;
        dupOppPortalPermission2.FGM_Portal__Account__c = newAccount.Id;

        Opportunity newOpportunity2 = new Opportunity(Name = 'TestNewOpportunityName', StageName='Qualification', CloseDate = Date.today().addDays(2));
        Database.SaveResult saveOpp2 = Database.insert(newOpportunity2, false);
        System.assertNotEquals(saveOpp2.getId(), null);

        FGM_Portal__Portal_Permission__c newOppPortalPermission2 = new FGM_Portal__Portal_Permission__c();
        newOppPortalPermission2.FGM_Portal__Opportunity__c = saveOpp2.getId();
        newOppPortalPermission2.FGM_Portal__Contact__c = newContact.Id;
        newOppPortalPermission2.FGM_Portal__Account__c = newAccount.Id;

        List<FGM_Portal__Portal_Permission__c> lstPortalPermissions = new List<FGM_Portal__Portal_Permission__c>();
        lstPortalPermissions.add(dupOppPortalPermission);
        lstPortalPermissions.add(dupOppPortalPermission2);
        lstPortalPermissions.add(newOppPortalPermission2);
        Database.SaveResult[] arrSaveDupOppPermissions = Database.insert(lstPortalPermissions, false);
        System.assertNotEquals(arrSaveDupOppPermissions[0].getErrors(), null);
        System.assertNotEquals(arrSaveDupOppPermissions[1].getErrors(), null);
        System.assertEquals(arrSaveDupOppPermissions[2].isSuccess(), true);
    }
}