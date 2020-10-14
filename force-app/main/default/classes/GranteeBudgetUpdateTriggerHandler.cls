public with sharing class GranteeBudgetUpdateTriggerHandler{
/************************************************************************************************************
Purpose: This function update Expenditures to Date field when Grantee Budget Update object record get updated
Parameters: []
Return : void
*************************************************************************************************************/
    public static void updateExpenditureToDate(){
        try{
            if( Trigger.isExecuting && !ProcessorControl.BIsExecuting ){
                ProcessorControl.BIsExecuting = true;
                Set<Id> setGranteeReportIds = new Set<Id>(); //Grantee report Ids from Trigger.New
                Set<Id> setGReportIds = new Set<Id>();       //All Grantee report Ids from Opportunity
                String strGRDateField;
                String strQuery;
                Schema.DisplayType fldType;
                FGM_Portal__GlobalPortalSettings__c globalSetting = FGM_Portal__GlobalPortalSettings__c.getOrgDefaults();
                Boolean isValidField = false;
                if(globalSetting != null ){
                    if( String.isNotBlank(globalSetting.FGM_Portal__Grantee_Report_Order_by_Date__c)){
                        strGRDateField = globalSetting.FGM_Portal__Grantee_Report_Order_by_Date__c;
                        Map<String, Schema.SObjectField> mapSobjectFields = Schema.SObjectType.FGM_Base__Grantee_Report__c.fields.getMap();
                        Schema.SObjectField field = mapSobjectFields.get(strGRDateField);
                        if(field!=null){
                            fldType = field.getDescribe().getType();
                            if((String.valueOf(fldType)=='Date' || String.valueOf(fldType)=='DateTime'))
                                isValidField = true;
                        }
                        else
                            isValidField = false;
                    }
                }
                if(String.isNotBlank(strGRDateField) && isValidField){
                    for(Grantee_Budget_Update__c objGBUpdate  : (List<Grantee_Budget_Update__c>) Trigger.New)
                        setGReportIds.add(objGBUpdate.Grantee_Report__c);

                    String sanitizedDateField = strGRDateField.replaceAll('[^0-9a-zA-Z_.]', '');
                    strQuery = 'SELECT FGM_Base__Request__c,'+ sanitizedDateField + ' FROM FGM_Base__Grantee_Report__c WHERE Id IN :setGReportIds WITH SECURITY_ENFORCED';

                    List<FGM_Base__Grantee_Report__c> lstGranteeReports = Database.query(strQuery);
                    Set<Id> setOpportunities = new Set<Id>();
                    for( FGM_Base__Grantee_Report__c granteeReport : lstGranteeReports )
                        setOpportunities.add( granteeReport.FGM_Base__Request__c );

                    strQuery = 'SELECT Id,' + sanitizedDateField + ' FROM FGM_Base__Grantee_Report__c WHERE FGM_Base__Request__c IN : setOpportunities WITH SECURITY_ENFORCED Order By ' + sanitizedDateField;
                    lstGranteeReports = Database.query(strQuery);

                    //map of report with its future reports
                    map<Id,set<Id>> mapReportToFutureReports = new  map<Id,set<Id>>();
                    set<Id> reportIdsWithBlankdate = new set<Id>();
                    map<Id,map<Id, double>> mapOppIdtomapCategorywiseExpenses = new map<Id,map<Id, double>>();

                    for (integer icount = 0 ;icount < lstGranteeReports.size() ; icount ++){
                        setGReportIds.add(lstGranteeReports[icount].Id);
                        Sobject objGReport = lstGranteeReports[icount];
                        if(objGReport.get(strGRDateField)== null){
                            reportIdsWithBlankdate.add(String.valueOf(objGReport.get('Id')));
                            mapReportToFutureReports.put(String.valueOf(objGReport.get('Id')),new set<Id> {String.valueOf(objGReport.get('Id'))});
                        }
                        else {
                            set<ID> setFutureReports = new set<ID>();
                            for(integer jCount = 0 ; jCount <  lstGranteeReports.size() ; jCount ++)
                            {
                                if(icount <= jCount)
                                {
                                    setFutureReports.add(lstGranteeReports[jCount].Id);
                                }
                            }
                            setFutureReports.addAll(reportIdsWithBlankdate);
                            mapReportToFutureReports.put(String.valueOf(objGReport.get('Id')),setFutureReports);
                        }
                    }

                    //Add filter to categories modified in Trigger.New

                    List<Grantee_Budget_Update__c> lstBudgetUpdates = [
                        SELECT
                            Current_Period_Expenses__c,
                            Expenditures_to_Date__c,
                            Grantee_Budget_Category__c,
                            Grantee_Budget_Category__r.Name,
                            Grantee_Report__r.FGM_Base__Due_Date__c,
                            Grantee_Report__r.FGM_Base__Request__c
                        FROM Grantee_Budget_Update__c
                        WHERE Grantee_Report__c IN :setGReportIds
                        WITH SECURITY_ENFORCED
                    ];

                    //FCPROD-2131
                    Map<Id, Map<Id, Double>> mapGRIdWithCategoryWiseExpenditure = new Map<Id, Map<Id, Double>>(); //Map of grantee report to map of categorywise expenditure.
                    Map<Id, Double> mapCategoryWiseExpenditure;
                    Double expenditureToDate = 0;
                    set<Id> setFutureReportIds ;
                    for( Grantee_Budget_Update__c budgetUpdate : lstBudgetUpdates ){
                        if(mapGRIdWithCategoryWiseExpenditure.containsKey(budgetUpdate.Grantee_Report__c)){
                            mapCategoryWiseExpenditure = mapGRIdWithCategoryWiseExpenditure.get(budgetUpdate.Grantee_Report__c);
                            mapCategoryWiseExpenditure.put(budgetUpdate.Grantee_Budget_Category__c, expenditureToDate);
                        }
                        else{
                            mapCategoryWiseExpenditure = new Map<Id, Double>();
                            mapCategoryWiseExpenditure.put( budgetUpdate.Grantee_Budget_Category__c, expenditureToDate );
                        }
                        mapGRIdWithCategoryWiseExpenditure.put( budgetUpdate.Grantee_Report__c, mapCategoryWiseExpenditure );
                    }
                    //This will update the map of report and category wise expenditure with the expenses of previous report's expenses.

                    for( Grantee_Budget_Update__c budgetUpdate : lstBudgetUpdates ){
                        expenditureToDate = 0;
                        setFutureReportIds = mapReportToFutureReports.get( budgetUpdate.Grantee_Report__c);
                        for(Id gRid : setFutureReportIds){
                            if(mapGRIdWithCategoryWiseExpenditure.get(gRid) != null ){
                                mapCategoryWiseExpenditure = mapGRIdWithCategoryWiseExpenditure.get(gRid);
                                if(mapCategoryWiseExpenditure!=null && mapCategoryWiseExpenditure.get( budgetUpdate.Grantee_Budget_Category__c)!=null){
                                    mapCategoryWiseExpenditure.put(budgetUpdate.Grantee_Budget_Category__c, mapCategoryWiseExpenditure.get(budgetUpdate.Grantee_Budget_Category__c) + budgetUpdate.Current_Period_Expenses__c);
                                }
                                else{
                                    mapCategoryWiseExpenditure.put( budgetUpdate.Grantee_Budget_Category__c, budgetUpdate.Current_Period_Expenses__c);
                                }
                                mapGRIdWithCategoryWiseExpenditure.put(gRid , mapCategoryWiseExpenditure);
                            }
                            else{
                                mapCategoryWiseExpenditure = new Map<Id, Double>();
                                mapCategoryWiseExpenditure.put( budgetUpdate.Grantee_Budget_Category__c, budgetUpdate.Current_Period_Expenses__c );
                                mapGRIdWithCategoryWiseExpenditure.put( budgetUpdate.Grantee_Report__c, mapCategoryWiseExpenditure );
                            }
                        }
                    }

                    //FCPROD-2131
                    Set<Id> setGranteeReportsToModify = new Set<Id>();
                    set<Id> setFutureReports;
                    for(Id reportId : setGReportIds){
                        if(mapReportToFutureReports.containskey(reportId)){
                            setFutureReports = mapReportToFutureReports.get(reportId);
                            for(Id report : setFutureReports){
                                setGranteeReportsToModify.add(report);
                            }
                        }
                    }

                    List<Grantee_Budget_Update__c> lstBudgetUpdatesToModify = [
                        SELECT
                            Current_Period_Expenses__c,
                            Expenditures_to_Date__c,
                            Grantee_Budget_Category__c,
                            Grantee_Report__r.FGM_Base__Request__c
                        FROM Grantee_Budget_Update__c
                        WHERE Grantee_Report__c IN :setGranteeReportsToModify
                        WITH SECURITY_ENFORCED
                    ];

                    Boolean bNeedUpdate = false;
                    for( Grantee_Budget_Update__c budgetUpdate : lstBudgetUpdatesToModify ) {
                        if( mapGRIdWithCategoryWiseExpenditure != null && mapGRIdWithCategoryWiseExpenditure.get( budgetUpdate.Grantee_Report__c ) != null ){
                            mapCategoryWiseExpenditure = mapGRIdWithCategoryWiseExpenditure.get( budgetUpdate.Grantee_Report__c );
                            if( mapCategoryWiseExpenditure.get( budgetUpdate.Grantee_Budget_Category__c ) != null && budgetUpdate.FGM_Portal__Current_Period_Expenses__c!=null)
                                budgetUpdate.Expenditures_to_Date__c = mapCategoryWiseExpenditure.get( budgetUpdate.Grantee_Budget_Category__c );
                        }
                    }

                    CrudFlsService.getInstance().assertUpdateable(lstBudgetUpdatesToModify);
                    update lstBudgetUpdatesToModify;
                }
            }
        }
       catch( Exception ex )
        {
            Trigger.new[0].addError(ex.getMessage());
            System.debug('Handled Exception: ' + ex.getMessage() + ', at line number: ' + ex.getLineNumber());
        }
    }
}