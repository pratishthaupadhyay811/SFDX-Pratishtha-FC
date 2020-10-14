public with sharing class OnReportCreated{
    public static set<Id> setOpportunityIDs = new set<Id>();
    public static void CreatePermission(FGM_Base__Grantee_Report__c[] arrNewGranteeReport){
        set<ID> setOpportunityID = new set<ID>();
        for(FGM_Base__Grantee_Report__c objGranteeReport : arrNewGranteeReport){
            setOpportunityID.add(objGranteeReport.FGM_Base__Request__c);
        }
        List<FGM_Portal__Portal_Permission__c> lstPortalPermission = new List<FGM_Portal__Portal_Permission__c>();

        lstPortalPermission = [
            SELECT
                Account__c,
                Contact__c,
                Lead__c,
                Name,
                Opportunity__c,
                Portal_Account__c
            FROM Portal_Permission__c
            WHERE Opportunity__c in :setOpportunityID
            WITH SECURITY_ENFORCED
        ];

        Map<ID,List<FGM_Portal__Portal_Permission__c>> mapOpportunityPermission = new Map<ID,List<FGM_Portal__Portal_Permission__c>>();
        if(lstPortalPermission != null && lstPortalPermission.size() > 0) {
            for(FGM_Portal__Portal_Permission__c objPortalPermission : lstPortalPermission) {
                List<FGM_Portal__Portal_Permission__c> lstPermission = new List<FGM_Portal__Portal_Permission__c>();
                if(mapOpportunityPermission.containsKey(objPortalPermission.FGM_Portal__Opportunity__c)){
                    lstPermission = mapOpportunityPermission.get(objPortalPermission.FGM_Portal__Opportunity__c);
                }
                lstPermission.add(objPortalPermission);
                mapOpportunityPermission.put(objPortalPermission.FGM_Portal__Opportunity__c,lstPermission);
            }
        }
        List<FGM_Portal__Portal_Permission__c> lstNewPermission = new List<FGM_Portal__Portal_Permission__c>();
        for(FGM_Base__Grantee_Report__c objGranteeReport : arrNewGranteeReport) {
            List<FGM_Portal__Portal_Permission__c> lstPermission = mapOpportunityPermission.get(objGranteeReport.FGM_Base__Request__c);
            if(lstPermission != null) {
                for(FGM_Portal__Portal_Permission__c objPermission : lstPermission) {
                    FGM_Portal__Portal_Permission__c objTempPermission = new FGM_Portal__Portal_Permission__c();
                        objTempPermission.FGM_Portal__Grantee_Report__c = objGranteeReport.Id;
                        objTempPermission.FGM_Portal__Portal_Account__c = objPermission.FGM_Portal__Portal_Account__c;
                        objTempPermission.FGM_Portal__Account__c = objPermission.FGM_Portal__Account__c;
                        objTempPermission.FGM_Portal__Contact__c = objPermission.FGM_Portal__Contact__c;
                        lstNewPermission.add(objTempPermission);
                }
            }
        }
        Database.Saveresult [] arrSvRes = null;
        if(lstNewPermission != null && lstNewPermission.size() > 0){
            CrudFlsService.getInstance().assertCreateable(lstNewPermission);
            arrSvRes = Database.insert(lstNewPermission);
        }
        if(arrSvRes != null && (arrNewGranteeReport != null && arrNewGranteeReport.size() > 0)) {
            for(Database.Saveresult svRes : arrSvRes) {
                if(!svRes.isSuccess()) {
                    arrNewGranteeReport[0].addError(svRes.getErrors()[0].getMessage());
                }
            }
        }
    }
    public static void createGRbudgetUpdateAndByCategoryRecords(){

        Map<Id, FGM_Base__Grantee_Report__c> mapNewRecords = new Map<Id, FGM_Base__Grantee_Report__c>([
            SELECT
                FGM_Base__Request__c,
                (
                    SELECT Id
                    FROM Grantee_Budget_Update__r
                )
            FROM FGM_Base__Grantee_Report__c
            WHERE Id IN :Trigger.newMap.keySet()
            WITH SECURITY_ENFORCED
        ]);

        if(!mapNewRecords.isEmpty() && mapNewRecords.size()>0){
            for(FGM_Base__Grantee_Report__c report : mapNewRecords.values()){
                setOpportunityIDs.add(report.FGM_Base__Request__c);
            }
            // Record To be created : 1. Grantee_Budget_Update__c 2. FGM_Portal__Grantee_Budget_Update_By_Category__c
            List<Grantee_Budget_Update__c> lstGRBUpdateToInsert = new List<Grantee_Budget_Update__c>();
            //Get All Budget Line Item records for corresponding request(opportunity)

            Map<Id, Opportunity> mapOpporunities = new Map<Id, Opportunity>([
                SELECT
                    (
                        SELECT
                            Amount__c,
                            Category__c
                        FROM Grantee_Budget_Line_Items__r
                    )
                FROM Opportunity
                WHERE Id IN :setOpportunityIDs
                WITH SECURITY_ENFORCED
                LIMIT 1000
            ]);

            Map<String,Grantee_Budget_Update__c> mapGRBUByCategory = new Map<String,Grantee_Budget_Update__c>();
            for(FGM_Base__Grantee_Report__c report : mapNewRecords.values()){
                Opportunity application = mapOpporunities.get(report.FGM_Base__Request__c);
                Set<string> setCategory = new Set<String>();
                if(application.FGM_Portal__Grantee_Budget_Line_Items__r != null && application.FGM_Portal__Grantee_Budget_Line_Items__r.size()>0 && report.FGM_Portal__Grantee_Budget_Update__r.size()<1 )
                {
                    for(FGM_Portal__Grantee_Budget_Line_Item__c  lineItem:  application.FGM_Portal__Grantee_Budget_Line_Items__r){
                        if(!setCategory.contains(lineItem.FGM_Portal__Category__c)){
                            Grantee_Budget_Update__c updateRecord = new Grantee_Budget_Update__c();
                                updateRecord.FGM_Portal__Grantee_Report__c = report.Id;
                                updateRecord.FGM_Portal__Grantee_Budget_Category__c = lineItem.FGM_Portal__Category__c;
                                lstGRBUpdateToInsert.add(updateRecord);
                                setCategory.add(lineItem.FGM_Portal__Category__c);
                        }
                    }
                }
            }
            CrudFlsService.getInstance().assertUpdateable(lstGRBUpdateToInsert);
            Database.UpsertResult[] updateResult = Database.upsert(lstGRBUpdateToInsert);
            if(lstGRBUpdateToInsert !=null && lstGRBUpdateToInsert.size() > 0){
                BatchUtility batchUtil = new BatchUtility('CreateGBUbyCategory',true, setOpportunityIDs);
                Database.executeBatch(batchUtil,50);
            }
        }
    }
    public static Boolean IsTriggerExecuted = false;
}