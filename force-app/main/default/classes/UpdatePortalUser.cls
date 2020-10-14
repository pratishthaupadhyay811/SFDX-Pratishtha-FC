/*************************************************************************************************************  
    Note:
    This class is used solely to sync information between the Account and the Portal User records
    The Grantee Portal Registration flow currently updates an Account record which kicks off this process
    As of the Salesforce Guest User Security Restrictions (Padlock), Guest Users are no longer allowed 
    to own records and can only be shared records with Read-Only access. Without Sharing is required 
    to bypass this restriction during registration.
*/
public without sharing class UpdatePortalUser {
    public static Boolean isAccountUpdated = false;

    /************************************************************************************************************
    Purpose: This method is used for updating portal user related to contacts and account..
    Parameters: List<Account>
    Throws [Exceptions]: [optional]
    Return : Void
    */
    public static void updatePortalUserFromAccount(List<Account> newLstAccounts) {        
        if (newLstAccounts != null && newLstAccounts.size() > 0 && !isAccountUpdated) {
            isAccountUpdated = true;

            List<CommunityConfiguration__c> lstCommunityConfigurations = [
                SELECT
                    Name,
                    ConfiguationName__c,
                    JsonData__c
                FROM CommunityConfiguration__c
                WHERE ConfiguationName__c = 'PortalUserFieldMapping'
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            if (lstCommunityConfigurations != null && lstCommunityConfigurations.size() > 0) {
                Map<String,Account> mapAccountPortalUsers = new Map<String,Account>();

                for (Account account : newLstAccounts) {
                    mapAccountPortalUsers.put(String.valueof(account.Id),account);
                }

                List<Portal_User__c> lstPortalUserToUpdate = [
                    SELECT
                        Contact__c,
                        Account__c
                    FROM Portal_User__c
                    WHERE Account__c IN :mapAccountPortalUsers.keySet()
                    WITH SECURITY_ENFORCED
                    LIMIT 10000
                ];

                if (lstPortalUserToUpdate != null && lstPortalUserToUpdate.size() > 0) {
                    Schema.DescribeSObjectResult portalUserObjectResult = FGM_Portal__Portal_User__c.sObjectType.getDescribe();
                    Map<String, Schema.SObjectField> mapPortalUserObjectFields = portalUserObjectResult.fields.getMap();
                    Map<String,List<FCGlobal.Field>> mapSobjectsMappingFields = new Map<String,List<FCGlobal.Field>>();
                    Set<String> setFieldAPINames = new Set<String>();

                    //For API Name with name space prefix
                    for (Schema.SObjectField field:mapPortalUserObjectFields.values()) {
                        setFieldAPINames.add(String.valueof(field));
                    }

                    mapSobjectsMappingFields = (Map<String,List<FCGlobal.Field>>) JSON.deserialize(
                        lstCommunityConfigurations[0].FGM_Portal__JsonData__c,
                        map<String,List<FCGlobal.Field>>.class
                    );
                    
                    if (mapSobjectsMappingFields!= null && mapSobjectsMappingFields.size() >0) {
                        List<FCGlobal.Field> lstPortalUserToAccount = (List<FCGlobal.Field>) mapSobjectsMappingFields.get('PortalUserToAccount'); 
                        
                        if (lstPortalUserToAccount != null) {
                            Map<String,FCGlobal.Field> mapFieldsMappedToAccount =  new Map<String,FCGlobal.Field>();
                            List<SObject> lstPortalUsersToUpdate = new  List<SObject>();
                            
                            for (FCGlobal.Field field : lstPortalUserToAccount) {
                                mapFieldsMappedToAccount.put(field.Name,field);
                            }

                            for (FGM_Portal__Portal_User__c portalUser : lstPortalUserToUpdate) {
                        
                                if (String.isNotBlank(portalUser.FGM_Portal__Account__c)) {
                                    Sobject portalUserToUpdate = new FGM_Portal__Portal_User__c();
                                    portalUserToUpdate.put('Id',portalUser.Id);
                                    Sobject updatedAccount = mapAccountPortalUsers.get(String.valueof(portalUser.FGM_Portal__Account__c));
                        
                                    for (FCGlobal.Field field : lstPortalUserToAccount) {
                        
                                        if (String.IsNotBlank(field.Value)&& setFieldAPINames.contains(field.Value)) {
                        
                                            if (String.IsNotBlank(field.Name)) {
                                                portalUserToUpdate.put(field.Value, updatedAccount.get(field.Name));
                                            }
                                        }
                                    }
                        
                                    lstPortalUsersToUpdate.add(portalUserToUpdate);
                                }
                            }

                            CrudFlsService.getInstance().assertUpdateable(lstPortalUsersToUpdate);
                            update lstPortalUsersToUpdate;
                        }
                    }
                }
            }
        }
    }
}