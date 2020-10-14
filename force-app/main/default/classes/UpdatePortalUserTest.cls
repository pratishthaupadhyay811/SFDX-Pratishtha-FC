@isTest
public with sharing class UpdatePortalUserTest {

    // A Profile without any CRUD or FLS to Custom Objects
    private static final String READ_ONLY_PROFILE_NAME = 'Read Only';

    // Unique name of new Permission Set that should not grant and permissions to anything by default.
    private static final String EMPTY_PERMISSION_SET_NAME = 'FGM_Portal_UpdatePortalUserTest_EmptyPermSet';

    private static final Schema.DescribeSObjectResult ACCOUNT = Schema.SObjectType.Account;    
    private static final Schema.DescribeFieldResult ACCOUNT_NAME = Schema.SObjectType.Account.fields.Name;
    private static final Schema.DescribeFieldResult ACCOUNT_EIN = Schema.SObjectType.Account.fields.FGM_Base__EIN__c;
    private static final List<Schema.DescribeFieldResult> ACCOUNT_FIELDS = new List<Schema.DescribeFieldResult> {
        ACCOUNT_NAME,
        ACCOUNT_EIN
    };
    
    private static final Schema.DescribeSObjectResult PORTAL_USER = Schema.SObjectType.FGM_Portal__Portal_User__c;
    private static final Schema.DescribeFieldResult PORTAL_USER_ORGANIZATION_LEGAL_NAME = Schema.SObjectType.FGM_Portal__Portal_User__c.fields.FGM_Portal__Organization_Legal_Name__c;
    private static final Schema.DescribeFieldResult PORTAL_USER_EIN = Schema.SObjectType.FGM_Portal__Portal_User__c.fields.FGM_Portal__EIN__c;
    private static final Schema.DescribeFieldResult PORTAL_USER_ACCOUNT = Schema.SObjectType.FGM_Portal__Portal_User__c.fields.FGM_Portal__Account__c;
    private static final Schema.DescribeFieldResult PORTAL_USER_CONTACT = Schema.SObjectType.FGM_Portal__Portal_User__c.fields.FGM_Portal__Contact__c;
    private static final List<Schema.DescribeFieldResult> PORTAL_USER_FIELDS = new List<Schema.DescribeFieldResult> {
        PORTAL_USER_ORGANIZATION_LEGAL_NAME,
        PORTAL_USER_EIN,
        PORTAL_USER_ACCOUNT,
        PORTAL_USER_CONTACT
    };

    private static Map<String, String> portalUserToAccountFieldMap = new Map<String, String> {
        PORTAL_USER_ORGANIZATION_LEGAL_NAME.getName() => ACCOUNT_NAME.getName(),
        PORTAL_USER_EIN.getName() => ACCOUNT_EIN.getName()
    };

    private static Account testOrg;

    @TestSetup
    private static void setupTestData() {        
        createAndInsertPortalTrigger();
        createAndInsertCommunityConfiguration();
        createAndInsertOrganization();
        createAndInsertPortalUsers();
    }

    private static void createAndInsertPortalTrigger() {
        FGM_Portal__Triggers__c portalTrigger = new FGM_Portal__Triggers__c();
        portalTrigger.Name = 'AllTriggers';
        portalTrigger.FGM_Portal__OnAccountUpdate__c = true;
        portalTrigger.FGM_Portal__OnContactUpdate__c = true;
        insert portalTrigger;
        
        System.assertNotEquals(portalTrigger.Id, null);
    }

    private static void createAndInsertCommunityConfiguration() {        
        Map<String, List<FieldMapping>> portalConfigToFieldMappingMap = new Map<String, List<FieldMapping>>();
        FGM_Portal__CommunityConfiguration__c communityConfiguration = new FGM_Portal__CommunityConfiguration__c();        

        portalConfigToFieldMappingMap.put('PortalUserToAccount', new List<FieldMapping>());
        
        for (String portalUserField : portalUserToAccountFieldMap.keySet()) {            
            portalConfigToFieldMappingMap.get('PortalUserToAccount')
                .add(new FieldMapping(portalUserToAccountFieldMap.get(portalUserField), portalUserField));
        }        

        communityConfiguration.FGM_Portal__JsonData__c = JSON.serialize(portalConfigToFieldMappingMap);
        communityConfiguration.FGM_Portal__ConfiguationName__c = 'PortalUserFieldMapping';
        insert communityConfiguration;
    }

    private static void createAndInsertOrganization() {
        Account account = new Account();
        account.Name = 'Test_Org_Account';
        insert account;

        System.assertNotEquals(account.Id, null);
    }

    private static List<FGM_Portal__Portal_User__c> createAndInsertPortalUsers() {
        Integer portalUserCount = 3;
        List<FGM_Portal__Portal_User__c> lstPortalUser = new List<FGM_Portal__Portal_User__c>();
        setTestOrg();

        for(Integer i = 0; i < portalUserCount; i++){
            String orgName = testOrg.Name;
            String username = 'testuser' + String.valueOf(i) + '@salesforce.com';
            String lastName = 'User' + String.valueOf(i);

            FGM_Portal__Portal_User__c portalUser = new FGM_Portal__Portal_User__c();
            portalUser.FGM_Portal__Account__c = testOrg.Id;
            portalUser.Name = username;
            portalUser.FGM_Portal__Organization_Legal_Name__c = orgName;
            portalUser.FGM_Portal__LastName__c = lastName;
            portalUser.FGM_Portal__Email__c = username;
            portalUser.FGM_Portal__Confirm_Email__c = username;
            portalUser.FGM_Portal__Password__c = 'test12345';
            portalUser.FGM_Portal__Confirm_Password__c = 'test12345';
            portalUser.FGM_Portal__Terms_And_Conditions__c = true;
            lstPortalUser.add(portalUser);
        }

        insert lstPortalUser;
        return lstPortalUser;
    }

    @IsTest
    private static void internalUserupdatePortalUserFromAccount() {
        Boolean exceptionThrown = false;        
        setTestOrg();

        List<FGM_Portal__Portal_User__c> lstPortalUser = getPortalUsers();                

        String testOrgUpdatedName = 'Test_Name_Updated';        
        testOrg.Name = testOrgUpdatedName;

        PermissionSetManager permissions = getInternalUserPermissions();

        Test.startTest();

        System.runAs(permissions.getUser()) {
            try {
                update testOrg;
            } catch (Exception e) {
                exceptionThrown = true;
                System.debug('Exception: ' + e.getMessage());
            }
        }
        
        System.assert(!exceptionThrown, 'Should have saved the organization name update');

        Test.stopTest();

        List<FGM_Portal__Portal_User__c> portalUsersResult = getPortalUsers();

        for(FGM_Portal__Portal_User__c portalUser : getPortalUsers()) {
            for(String portalUserField : portalUserToAccountFieldMap.keySet()) {
                System.assertEquals(                    
                    testOrg.get(portalUserToAccountFieldMap.get(portalUserField)),
                    portalUser.get(portalUserField),
                    'The Portal User field value did not match the mapped Account field value'
                );
            }
        }
    }

   // @IsTest
   //This test is deprecated
    private static void guestUserUpdateAccountToPortalUser() {        
        UpdatePortalUser.isAccountUpdated = false;
        String updatedOrgName = 'Updated Name';
        String updatedEIN = '0987654321';
        
        setTestOrg();  
        
        List<FGM_Portal__Portal_User__c> lstPortalUser = getPortalUsers();

        for (FGM_Portal__Portal_User__c portalUser : lstPortalUser) {
            System.assertNotEquals(
                portalUser.FGM_Portal__Organization_Legal_Name__c, 
                updatedOrgName, 
                'Portal User record should not yet be updated'
            );
            
            System.assertNotEquals(
                portalUser.FGM_Portal__EIN__c, 
                updatedEIN, 
                'Portal User record should not yet be updated'
            );
        }

        testOrg.Name = updatedOrgName;
        testOrg.FGM_Base__EIN__c = updatedEIN;
        
        PermissionSetManager permissions = getGuestUserPermissions();
        
        Test.startTest();
        
        System.runAs(permissions.getUser()) {
            try {
                UpdatePortalUser.updatePortalUserFromAccount(new List<Account>{testOrg});
            } catch (Exception e) {
                System.debug('Exception: ' + e.getMessage());
            }
        }

        Test.stopTest();

        for(FGM_Portal__Portal_User__c portalUser : getPortalUsers()) {
            for(String portalUserField : portalUserToAccountFieldMap.keySet()) {
                System.assertEquals(                    
                    testOrg.get(portalUserToAccountFieldMap.get(portalUserField)),
                    portalUser.get(portalUserField),
                    'The Portal User field value did not match the mapped Account field value'
                );
            }
        }
    }

    @IsTest
    private static void internalUserUpdateAccountToPortalUser() {
        UpdatePortalUser.isAccountUpdated = false;
        String updatedOrgName = 'Updated Name';
        String updatedEIN = '0987654321';

        List<FGM_Portal__Portal_User__c> lstPortalUser = getPortalUsers();
        
        setTestOrg();  

        for(FGM_Portal__Portal_User__c portalUser : lstPortalUser) {
            System.assertNotEquals(
                portalUser.FGM_Portal__Organization_Legal_Name__c, 
                updatedOrgName, 
                'Portal User record should not yet be updated'
            );
            
            System.assertNotEquals(
                portalUser.FGM_Portal__EIN__c, 
                updatedEIN, 
                'Portal User record should not yet be updated'
            );
        }

        testOrg.Name = updatedOrgName;
        testOrg.FGM_Base__EIN__c = updatedEIN;

        PermissionSetManager permissions = getInternalUserPermissions();

        System.assert(
            permissions.getObjectPermission(PORTAL_USER).getRead(), 
            'User should have read access to Portal User object'
        );
        System.assert(
            permissions.getObjectPermission(ACCOUNT).getRead(), 
            'User should have read access to Account object'
        );
        System.assert(
            permissions.getObjectPermission(PORTAL_USER).getEdit(), 
            'User should have edit access to Portal User object'
        );
        System.assert(
            permissions.getObjectPermission(ACCOUNT).getEdit(), 
            'User should have edit access to Account object'
        );

        Test.startTest();        
        String exceptionMessage = '';
        System.runAs(permissions.getUser()) {
            try {
                UpdatePortalUser.updatePortalUserFromAccount(new List<Account>{testOrg});
            } catch(Exception e) {
                exceptionMessage = e.getMessage();
            }
        }

        Test.stopTest();

        System.assert(String.isBlank(exceptionMessage), 'An exception should not have been thrown');

        for (FGM_Portal__Portal_User__c portalUser : getPortalUsers()) {
            for (String portalUserField : portalUserToAccountFieldMap.keySet()) {
                System.assertEquals(
                    testOrg.get(portalUserToAccountFieldMap.get(portalUserField)),
                    portalUser.get(portalUserField),                     
                    'The Portal User field value did not match the mapped Account field value'
                );
            }
        }
    }

    //@IsTest
    //This test is deprecated 
    private static void shouldNotUpdatePortalUsersIfUpdatedFlagIsSet() {
        UpdatePortalUser.isAccountUpdated = true;
        String updatedOrgName = 'Updated Name';
        String updatedEIN = '0987654321';        
        List<FGM_Portal__Portal_User__c> lstPortalUser = getPortalUsers();
        
        setTestOrg();

        for (FGM_Portal__Portal_User__c portalUser : lstPortalUser) {
            System.assertNotEquals(
                portalUser.FGM_Portal__Organization_Legal_Name__c, 
                updatedOrgName, 
                'Portal User record should not yet be updated'
            );
            System.assertNotEquals(
                portalUser.FGM_Portal__EIN__c, 
                updatedEIN, 
                'Portal User record should not yet be updated'
            );
        }        

        testOrg.Name = updatedOrgName;
        testOrg.FGM_Base__EIN__c = updatedEIN;

        PermissionSetManager permissions = getGuestUserPermissions();
        System.assert(
            permissions.getObjectPermission(PORTAL_USER).getRead(), 
            'User should have read access to Portal User object'
        );
        System.assert(
            permissions.getObjectPermission(ACCOUNT).getRead(), 
            'User should have read access to Account object'
        );
        System.assert(
            permissions.getObjectPermission(PORTAL_USER).getEdit(), 
            'User should have edit access to Portal User object'
        );
        System.assert(
            !permissions.getObjectPermission(ACCOUNT).getEdit(), 
            'User should not have edit access to Account object'
        );

        Test.startTest();

        String exceptionMessage = '';
        
        System.runAs(permissions.getUser()) {
            try {
                UpdatePortalUser.updatePortalUserFromAccount(new List<Account>{testOrg});
            } catch(Exception e) {
                exceptionMessage = e.getMessage();
            }
        }

        Test.stopTest();

        System.assert(String.isBlank(exceptionMessage), 'An exception should not have been thrown');

        for (FGM_Portal__Portal_User__c portalUser : lstPortalUser) {
            System.assertNotEquals(
                portalUser.FGM_Portal__Organization_Legal_Name__c, 
                updatedOrgName, 
                'Portal User record should not have been updated'
            );
            System.assertNotEquals(
                portalUser.FGM_Portal__EIN__c, 
                updatedEIN, 
                'Portal User record should not have been updated'
            );
        }  
    }

    @IsTest
    private static void shouldThrowExceptionIfMissingPortalUserEditPermission(){
        UpdatePortalUser.isAccountUpdated = false;
        String updatedOrgName = 'Updated Name';
        String updatedEIN = '0987654321';        
        List<FGM_Portal__Portal_User__c> lstPortalUser = getPortalUsers();
        
        setTestOrg();

        for (FGM_Portal__Portal_User__c portalUser : lstPortalUser) {
            System.assertNotEquals(
                portalUser.FGM_Portal__Organization_Legal_Name__c,
                updatedOrgName, 
                'Portal User record should not yet be updated'
            );
            System.assertNotEquals(
                portalUser.FGM_Portal__EIN__c, 
                updatedEIN, 
                'Portal User record should not yet be updated'
            );
        }

        testOrg.Name = updatedOrgName;
        testOrg.FGM_Base__EIN__c = updatedEIN;
        
        Boolean exceptionThrown = false;
        String exceptionType = '';
        
        PermissionSetManager permissions = getPermissionlessUserPermissions();
        System.assert(
            !permissions.getObjectPermission(PORTAL_USER).getRead(), 
            'User should not have read access to Portal User object'
        );
        System.assert(
            !permissions.getObjectPermission(ACCOUNT).getRead(), 
            'User should not have read access to Account object'
        );
        System.assert(
            !permissions.getObjectPermission(PORTAL_USER).getEdit(), 
            'User should not have edit access to Portal User object'
        );
        System.assert(
            !permissions.getObjectPermission(ACCOUNT).getEdit(), 
            'User should not have edit access to Account object'
        );

        Test.startTest();
        
        System.runAs(permissions.getUser()) {
            try {
                UpdatePortalUser.updatePortalUserFromAccount(new List<Account>{testOrg});
            } catch(Exception e) {
                exceptionThrown = true;
                exceptionType = e.getTypeName();
                System.debug('exception type: ' + e.getTypeName());
                System.debug('exception message: ' + e.getMessage());
            }
        }

        Test.stopTest();

        System.assert(
            exceptionThrown, 
            'A permissions exception should have been thrown for user missing Update permission'
        );
        System.assertEquals(
            exceptionType, 
            'System.QueryException', 
            'Should have thrown an exception of System.QueryException type'
        );

        for (FGM_Portal__Portal_User__c portalUser : lstPortalUser) {
            System.assertNotEquals(
                portalUser.FGM_Portal__Organization_Legal_Name__c, 
                updatedOrgName, 
                'Portal User record should not have been updated'
            );
            System.assertNotEquals(
                portalUser.FGM_Portal__EIN__c, 
                updatedEIN, 
                'Portal User record should not have been updated'
            );
        }  
    }

    private static PermissionSetManager getGuestUserPermissions() {
        PermissionSetManager permissions = PersonaManager.getGuestPersona();
        PersonaManager.addSimulatedPadlockSharingRules(permissions);
        return permissions;
    }

    private static PermissionSetManager getInternalUserPermissions() {
        return PersonaManager.getInternalUserPersona();
    }

    private static PermissionSetManager getPermissionlessUserPermissions(){        
        final Profile readOnlyProfile =
            [
                SELECT Name
                FROM Profile
                WHERE Name = 'Read Only' LIMIT 1
            ];

        final User user = PermissionSetManager.createAndInsertUserWithoutAnyProfilePermissions(
            readOnlyProfile.Name,
            EMPTY_PERMISSION_SET_NAME,
            new List<Schema.DescribeSObjectResult>()
        );

        final PermissionSetManager permissions = new PermissionSetManager(
            readOnlyProfile.Name,
            EMPTY_PERMISSION_SET_NAME
        );

        return permissions;
    }

    private static List<FGM_Portal__Portal_User__c> getPortalUsers() {
        String portalUserQuery = 'SELECT Id';
        for(Schema.DescribeFieldResult dfr : PORTAL_USER_FIELDS){
            portalUserQuery += ', ';
            portalUserQuery += dfr.getName();
        }
        portalUserQuery += ' FROM FGM_Portal__Portal_User__c';                
        
        List<FGM_Portal__Portal_User__c> lstPortalUser = Database.query(portalUserQuery);
        
        System.assert(!lstPortalUser.isEmpty(), 'Portal users should have been created and inserted.');        
        
        return lstPortalUser;
    }

    private static void setTestOrg() {
        if (testOrg == null){
            testOrg = [
                SELECT Id, Name, FGM_Base__EIN__c 
                FROM Account 
                WHERE Name = 'Test_Org_Account' 
                LIMIT 1
            ];
        }
    }

    private class FieldMapping {
        public String Name;
        public String Value;
        
        FieldMapping(String sourceName, String targetName){
            this.Name = sourceName;
            this.Value = targetName;
        }
    }
}