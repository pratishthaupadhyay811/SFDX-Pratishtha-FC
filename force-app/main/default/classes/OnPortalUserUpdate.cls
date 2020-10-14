public with sharing class OnPortalUserUpdate{
    public static void UpdateContact(map<Id,FGM_Portal__Portal_User__c> mapPortalUser){
        if(mapPortalUser != null && mapPortalUser.size() > 0){
            map<id,Contact> mapContactById = null;
            List<Contact> lstContactToUpdate = new List<Contact>();
            set<Id> setContactId = new set<Id>();
            for(FGM_Portal__Portal_User__c pUser : mapPortalUser.values()){
                if(pUser.FGM_Portal__Contact__c != null)
                    setContactId.add(pUser.FGM_Portal__Contact__c);
            }

            if (setContactId.size() > 0) {

                mapContactById = new Map<Id, Contact>([
                    SELECT
                        Email,
                        Name
                    FROM Contact
                    WHERE Id IN :setContactId
                    WITH SECURITY_ENFORCED
                ]);

            }

            if(mapContactById != null){
                for(FGM_Portal__Portal_User__c pUser : mapPortalUser.values()){
                    Contact objContact = mapContactById.get(pUser.FGM_Portal__Contact__c);
                    if(objContact != null && objContact.Email != pUser.FGM_Portal__Email__c){
                            objContact.Email = pUser.FGM_Portal__Email__c;
                            objContact.FGM_Portal__Confirm_Email__c = pUser.FGM_Portal__Confirm_Email__c;
                            lstContactToUpdate.add(objContact);
                    }
                }
            }
            try{
                database.Saveresult[] arrSaveResult = null;
                if(lstContactToUpdate.size()>0) {
                    CrudFlsService.getInstance().assertUpdateable(lstContactToUpdate);
                    arrSaveResult = Database.update(lstContactToUpdate);
                }
                if(arrSaveResult != null){
                    for(Database.Saveresult objSaveResult : arrSaveResult){
                        FGM_Portal__Portal_User__c portalUser = mapPortalUser.get(objSaveResult.getId());
                        if(!objSaveResult.isSuccess() && portalUser != null)
                            portalUser.addError(objSaveResult.getErrors()[0].getMessage());
                    }
                }
            }
            catch(Exception ex){
                mapPortalUser.values()[0].addError(ex.getMessage());
            }
        }
    }
}