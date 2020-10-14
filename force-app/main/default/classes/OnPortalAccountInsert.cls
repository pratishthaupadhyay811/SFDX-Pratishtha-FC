public with sharing class OnPortalAccountInsert{
    public static void CreateAccount(map<Id,FGM_Portal__Portal_Account__c> mapPortalAccById){
        if(mapPortalAccById != null & mapPortalAccById.size() > 0) {
            map<String,Account> mapAccByName = new map<String,Account>();
            for(FGM_Portal__Portal_Account__c pAcc : mapPortalAccById.values()){
                if(pAcc.Account__c == null){
                    Account objAcc = new Account();
                    objAcc.Name = pAcc.Name;
                    mapAccByName.put(objAcc.Name,objAcc);
                }
            }
            Database.Saveresult[] arrSvResAcc = null;
            try{
                if(mapAccByName.size()  > 0) {
                    CrudFlsService.getInstance().assertCreateable(mapAccByName.values());
                    arrSvResAcc = Database.Insert(mapAccByName.values(),true);
                }
                Boolean bAllAccInserted = false;
                if(arrSvResAcc != null) {
                    bAllAccInserted = true;
                    for(Database.Saveresult svRes : arrSvResAcc){
                        if(!svRes.isSuccess()){
                            mapPortalAccById.values()[0].addError(svRes.getErrors()[0].getMessage());
                            bAllAccInserted = false;
                        }
                    }
                }
                list<FGM_Portal__Portal_Account__c> lstPortalAcc = new list<FGM_Portal__Portal_Account__c>();
                if(bAllAccInserted) {
                    for(FGM_Portal__Portal_Account__c pAcc : mapPortalAccById.values()){
                        if(mapAccByName.containsKey(pAcc.Name)){
                            Account objAcc = mapAccByName.get(pAcc.Name);
                            FGM_Portal__Portal_Account__c objTempPAcc =  new FGM_Portal__Portal_Account__c(Id = pAcc.Id);
                                objTempPAcc.FGM_Portal__Account__c = objAcc.Id;
                                lstPortalAcc.add(objTempPAcc);
                        }
                    }
                }
                Database.Saveresult[] arrSvResPAcc = null;
                if(lstPortalAcc.size() > 0) {
                    CrudFlsService.getInstance().assertUpdateable(lstPortalAcc);
                    arrSvResPAcc = Database.Update(lstPortalAcc,true);
                }
                if(arrSvResPAcc != null) {
                    for(Database.Saveresult svRes : arrSvResPAcc) {
                        if(!svRes.isSuccess() && mapPortalAccById.containsKey(svRes.getId()))
                            (mapPortalAccById.get(svRes.getId())).addError(svRes.getErrors()[0].getMessage());
                    }
                }
            }catch(Exception ex) {
                mapPortalAccById.values()[0].addError(ex.getMessage());
            }
        }
    }
}