public with sharing class OnAccountDelete {
/************************************************************************************************************
Purpose: This function delete FGM_Portal__Portal_Account__c and FGM_Portal__Portal_Permission__c object record associated with Account
         when account get deleted
Parameters: [Map<Id,Account>]
Return : void
*************************************************************************************************************/
    public static void getPortalAccountPortalPermissions(Map<Id,Account> mapAccountById) {
        if(mapAccountById != NULL && mapAccountById.size()>0) {

            Map<Id, Portal_Account__c> mapPortalAccountById = new Map<Id, Portal_Account__c>([
                SELECT Account__c
                FROM Portal_Account__c
                WHERE Account__c IN :mapAccountById.keyset()
                WITH SECURITY_ENFORCED
            ]);

            Map<Id, Portal_Permission__c> mapPortalPermissionById = new Map<Id, Portal_Permission__c>();

            if(mapPortalAccountById != NULL && mapPortalAccountById.size()>0) {

                mapPortalPermissionById = new Map<Id, Portal_Permission__c>([
                    SELECT Portal_Account__c
                    FROM Portal_Permission__c
                    WHERE Portal_Account__c IN :mapPortalAccountById.keySet()
                    WITH SECURITY_ENFORCED
                ]);

            }

            if(mapPortalPermissionById.size() > 0 && mapPortalPermissionById != NULL) {
                CrudFlsService.getInstance().assertDeletable(mapPortalPermissionById.values());
                database.delete(mapPortalPermissionById.values());
            }

            if(mapPortalAccountById.size() > 0 && mapPortalAccountById != NULL) {
                CrudFlsService.getInstance().assertDeletable(mapPortalAccountById.values());
                database.delete(mapPortalAccountById.values());
            }
        }
    }
}