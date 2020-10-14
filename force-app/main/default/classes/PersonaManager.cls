@isTest
public without sharing class PersonaManager {
    public class GuestProfileNotProvisionedException extends Exception {
    }

    public static Profile getGuestUserProfile() {
        final List<String> licenseDefinitionKeys = new List<String>{
            'PID_Guest_User',
            'Guest'
        };

        final List<Profile> guestProfiles = [
            SELECT Name
            FROM Profile
            WHERE UserLicense.LicenseDefinitionKey IN :licenseDefinitionKeys
            ORDER BY UserLicense.LicenseDefinitionKey DESC
            LIMIT 1
        ];
        if (guestProfiles.isEmpty()) {
            throw new GuestProfileNotProvisionedException(
                String.format(
                    'A Guest User Profile should be provisioned.   No Profile found whose UserLicense.LicenseDefinitionKey is one of the following: {0}',
                    new List<String>{
                        '"' +
                        String.join(licenseDefinitionKeys, '", "') +
                        '"'
                    }
                )
            );
        }
        return guestProfiles[0];
    }

    public static PermissionSetManager getGuestPersona() {
        final String EMPTY_PERMISSION_SET_NAME = 'FGM_Portal_PersonaManager_EmptyPermSet';
        final Profile guestProfile = PersonaManager.getGuestUserProfile();
        final User guestUser = PermissionSetManager.createAndInsertUserWithoutAnyProfilePermissions(
            guestProfile.Name,
            EMPTY_PERMISSION_SET_NAME,
            new List<Schema.DescribeSObjectResult>()
        );

        final PermissionSetManager guestPermissions = new PermissionSetManager(
            guestProfile.Name,
            EMPTY_PERMISSION_SET_NAME
        );

        System.runAs(guestPermissions.getUser()) {
            deleteAllPermissionsForUser(guestPermissions.getUser());
            guestPermissions
                .getObjectPermission(CustomHTML__c.SObjectType.getDescribe())
                .setRead(true)
                .setFieldPermissions(
                    new Map<Schema.SObjectField, Set<PermissionSetManager.FLS>>{
                        CustomHTML__c.RichDescription__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.READ
                        },
                        CustomHTML__c.Language__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.READ
                        },
                        CustomHTML__c.Name => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.READ
                        }
                    }
                );

            guestPermissions
                .getObjectPermission(CommunityConfiguration__c.SObjectType.getDescribe())
                .setRead(true)
                .setFieldPermissions(
                    new Map<Schema.SObjectField, Set<PermissionSetManager.FLS>>{
                        CommunityConfiguration__c.Name => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.READ
                        },
                        CommunityConfiguration__c.ConfiguationName__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.READ
                        },
                        CommunityConfiguration__c.JsonData__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.READ
                        }
                    }
                );

            guestPermissions
                .getObjectPermission(User.SObjectType.getDescribe())
                .setFieldPermissions(
                    new Map<Schema.SObjectField, Set<PermissionSetManager.FLS>>{
                        User.Return_URL__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        User.UserProfile__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        User.ProfileType__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        }
                    }
                );

            guestPermissions
                .getObjectPermission(Account.SObjectType.getDescribe())
                .setRead(true)
                .setCreate(true)
                .setFieldPermissions(
                    new Map<Schema.SObjectField, Set<PermissionSetManager.FLS>>{
                        Account.FGM_Base__EIN__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Account.OwnerId => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Account.Name => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        }
                    }
                );

            guestPermissions
                .getObjectPermission(Contact.SObjectType.getDescribe())
                .setRead(true)
                .setFieldPermissions(
                    new Map<Schema.SObjectField, Set<PermissionSetManager.FLS>>{
                        Contact.Email => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.Read
                        }
                    }
                );

            guestPermissions
                .getObjectPermission(Portal_User__c.SObjectType.getDescribe())
                .setRead(true)
                .setCreate(true)
                .setEdit(true)
                .setFieldPermissions(
                    new Map<Schema.SObjectField, Set<PermissionSetManager.FLS>>{
                        Portal_User__c.Account__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Approval_Status__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.City__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Contact__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Country__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.EIN__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Email__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.IsCreatedByOpportunityTeamMember__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Organization_Legal_Name__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Portal_Account__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Return_URL__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.State__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Domain__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.ProfileType__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.User_Profile__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.IsActive__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Confirmation_Code__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Confirmation_Date__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Portal_Language__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Default_Time_Zone__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.FirstName__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.LastName__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        }
                    }
                );

            guestPermissions.save();
        }

        return guestPermissions;
    }

    /*
     * Criteria Based Sharing rules are not evaluated in a test, (see https://help.salesforce.com/articleView?id=security_sharing_rule_types.htm&type=5)
     * but if "Secure Guest User Record Access" (i.e. Padlock) is on then the Guest User will not be able to view any records
     * Setting View All Records on these objects simulates the sharing rules needed
     */
    public static void addSimulatedPadlockSharingRules(PermissionSetManager permissions) {
        permissions.getObjectPermission(
                CommunityConfiguration__c.SObjectType.getDescribe()
            )
            .setViewAllRecords(true);
        permissions.getObjectPermission(Portal_User__c.SObjectType.getDescribe())
            .setViewAllRecords(true);
        permissions.getObjectPermission(CustomHTML__c.SObjectType.getDescribe())
            .setViewAllRecords(true);
        permissions.getObjectPermission(Questions__c.SObjectType.getDescribe())
            .setViewAllRecords(true);
        permissions.getObjectPermission(Quiz__c.SObjectType.getDescribe())
            .setViewAllRecords(true);
        permissions.getObjectPermission(
                GuidestarFieldMapping__c.SObjectType.getDescribe()
            )
            .setViewAllRecords(true);
    }

    public static PermissionSetManager getInternalUserPersona() {
        final String EMPTY_PERMISSION_SET_NAME = 'FGM_Portal_PersonaManager_EmptyPermSet';
        final Profile readOnlyProfile = [
            SELECT Name
            FROM Profile
            WHERE Name = 'Read Only'
            LIMIT 1
        ];

        final User internalUser = PermissionSetManager.createAndInsertUserWithoutAnyProfilePermissions(
            readOnlyProfile.Name,
            EMPTY_PERMISSION_SET_NAME,
            new List<Schema.DescribeSObjectResult>()
        );

        final PermissionSetManager permissions = new PermissionSetManager(
            readOnlyProfile.Name,
            EMPTY_PERMISSION_SET_NAME
        );

        System.runAs(permissions.getUser()) {
            permissions
                .getObjectPermission(CustomHTML__c.SObjectType.getDescribe())
                .setRead(true)
                .setFieldPermissions(
                    new Map<Schema.SObjectField, Set<PermissionSetManager.FLS>>{
                        CustomHTML__c.RichDescription__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.READ
                        },
                        CustomHTML__c.Language__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.READ
                        },
                        CustomHTML__c.Name => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.READ
                        }
                    }
                );

            permissions
                .getObjectPermission(CommunityConfiguration__c.SObjectType.getDescribe())
                .setRead(true)
                .setFieldPermissions(
                    new Map<Schema.SObjectField, Set<PermissionSetManager.FLS>>{
                        CommunityConfiguration__c.ConfiguationName__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.READ
                        },
                        CommunityConfiguration__c.JsonData__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.READ
                        }
                    }
                );

            permissions
                .getObjectPermission(Account.SObjectType.getDescribe())
                .setRead(true)
                .setCreate(true)
                .setEdit(true)
                .setFieldPermissions(
                    new Map<Schema.SObjectField, Set<PermissionSetManager.FLS>>{
                        Account.FGM_Base__EIN__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Account.OwnerId => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Account.Name => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        }
                    }
                );

            permissions
                .getObjectPermission(Contact.SObjectType.getDescribe())
                .setRead(true)
                .setFieldPermissions(
                    new Map<Schema.SObjectField, Set<PermissionSetManager.FLS>>{
                        Contact.Email => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.Read
                        }
                    }
                );

            permissions
                .getObjectPermission(Portal_User__c.SObjectType.getDescribe())
                .setRead(true)
                .setCreate(true)
                .setEdit(true)
                .setFieldPermissions(
                    new Map<Schema.SObjectField, Set<PermissionSetManager.FLS>>{
                        Portal_User__c.Account__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Approval_Status__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.City__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Contact__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Country__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.EIN__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Email__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.IsCreatedByOpportunityTeamMember__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Organization_Legal_Name__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Portal_Account__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Return_URL__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.State__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Domain__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.ProfileType__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.User_Profile__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.IsActive__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Confirmation_Code__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Confirmation_Date__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Portal_Language__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.Default_Time_Zone__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.FirstName__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        },
                        Portal_User__c.LastName__c => new Set<PermissionSetManager.FLS>{
                            PermissionSetManager.FLS.EDIT
                        }
                    }
                );

            permissions.save();
        }

        return permissions;
    }

    private static void deleteAllPermissionsForUser(User theUser) {
        List<Id> objectPermissionsToDelete = new List<Id>();
        objectPermissionsToDelete.addAll(
            new Map<Id, SObject>(
                    [
                        SELECT Id
                        FROM ObjectPermissions
                        WHERE
                            ParentId IN (
                                SELECT PermissionSetId
                                FROM PermissionSetAssignment
                                WHERE AssigneeId = :theUser.Id
                            )
                    ]
                )
                .keySet()
        );

        //Child objects in a master-detail will fail to delete their objectpermissions
        //if they are positioned first in the list.
        //This block deal with out of order objectpermissions.  
        List<Id> tempPermissions = objectPermissionsToDelete.clone();
        while(!tempPermissions.isEmpty()) {
            Database.DeleteResult[] results = Database.delete(tempPermissions, false);
            objectPermissionsToDelete = tempPermissions.clone();
            tempPermissions.clear();
            
            for(Integer index = 0, size = objectPermissionsToDelete.size(); index < size; index++) {
                if(!results[index].isSuccess()) {
                    tempPermissions.add(objectPermissionsToDelete[index]);
                }
            }
        }

        List<Id> fieldPermissionsToDelete = new List<Id>();
        fieldPermissionsToDelete.addAll(
            new Map<Id, SObject>(
                    [
                        SELECT Id
                        FROM FieldPermissions
                        WHERE
                            ParentId IN (
                                SELECT PermissionSetId
                                FROM PermissionSetAssignment
                                WHERE AssigneeId = :theUser.Id
                            )
                    ]
                )
                .keySet()
        );
        Database.delete(fieldPermissionsToDelete);
    }
}