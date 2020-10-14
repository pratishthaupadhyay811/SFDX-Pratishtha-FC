@isTest
public class GranteeBudgetUpdateTriggerHandlerTest {

    public static List<Schema.RecordTypeInfo> granteeReportRecordTypes = Schema.getGlobalDescribe().get('FGM_Base__Grantee_Report__c').getDescribe().getRecordTypeInfos();

    @TestSetup 
    public static void testSetup() {
        List<Grantee_Budget_Category__c> budgetCategoryList = new List<Grantee_Budget_Category__c>();
        FGM_Portal__GlobalPortalSettings__c globalSetting = new FGM_Portal__GlobalPortalSettings__c();
        globalSetting.FGM_Portal__Grantee_Report_Order_by_Date__c = 'FGM_Base__Due_Date__c';
        globalSetting.FGM_Portal__Grantee_Portal_Prefix__c = 'fcgrantee';
        globalSetting.FGM_Portal__Reviewer_Portal_Prefix__c = 'grantee';
        insert globalSetting;

        Grantee_Budget_Category__c categoryOne = TestsObjectProvider.CreateGranteeBudgetCategory( 'Fulltime Staff' );
        categoryOne.IsActive__c = true;
        budgetCategoryList.add(categoryOne);

        Grantee_Budget_Category__c categoryTwo = TestsObjectProvider.CreateGranteeBudgetCategory( 'Legal Services' );
        categoryTwo.IsActive__c = true;
        budgetCategoryList.add(categoryTwo);
        
        Grantee_Budget_Category__c categoryThree = TestsObjectProvider.CreateGranteeBudgetCategory( 'Part-time Staff' );
        categoryThree.IsActive__c = true;
        budgetCategoryList.add(categoryThree);
        insert budgetCategoryList;

        Opportunity request = TestsObjectProvider.CreateOpportunity( 'TheRequest', 'Submitted', system.today() );
        insert request;
    }

    static testMethod void unitTestExpenditureToDateCalculation(){
		List<Grantee_Budget_Category__c> budgetCategoryList = new List<Grantee_Budget_Category__c>(
        	[
                SELECT 	Id, Name
                FROM 	Grantee_Budget_Category__c
            ]
        );
        Opportunity request = [
            SELECT Id 
            FROM Opportunity 
            LIMIT 1
        ];
        
        FGM_Base__Grantee_Report__c reportOne = TestsObjectProvider.CreateFGMBaseGranteeReport( granteeReportRecordTypes[0].getRecordTypeId(), request.Id, 'Requested' );
        reportOne.FGM_Base__Due_Date__c = Date.newInstance(2017, 10 ,9);
        insert reportOne;

        FGM_Base__Grantee_Report__c reportTwo = TestsObjectProvider.CreateFGMBaseGranteeReport( granteeReportRecordTypes[0].getRecordTypeId(), request.Id, 'Requested' );
        reportTwo.FGM_Base__Due_Date__c = Date.newInstance(2018 , 10 ,9);
        insert reportTwo;

        FGM_Base__Grantee_Report__c reportThree = TestsObjectProvider.CreateFGMBaseGranteeReport( granteeReportRecordTypes[0].getRecordTypeId(), request.Id, 'Requested' );
        insert reportThree;

        FGM_Base__Grantee_Report__c reportFour = TestsObjectProvider.CreateFGMBaseGranteeReport( granteeReportRecordTypes[0].getRecordTypeId(), request.Id, 'Requested' );
        insert reportFour;

        // for Grantee Report One
        Grantee_Budget_Update__c budgetUpdateOne = TestsObjectProvider.CreateGranteeBudgetUpdate( reportOne.Id, null );
        budgetUpdateOne.Current_Period_Expenses__c = 0.0;
        budgetUpdateOne.Grantee_Budget_Category__c = budgetCategoryList.get(0).Id;
        budgetUpdateOne.Expenditures_to_Date__c = 0.0;
        insert budgetUpdateOne;

        // for Grantee Report Two
        Grantee_Budget_Update__c budgetUpdateTwo = TestsObjectProvider.CreateGranteeBudgetUpdate( reportTwo.Id, null );
        budgetUpdateTwo.Current_Period_Expenses__c = 0.0;
        budgetUpdateTwo.Grantee_Budget_Category__c = budgetCategoryList.get(0).Id;
        budgetUpdateTwo.Expenditures_to_Date__c = 0.0;
        insert budgetUpdateTwo;

        // Testing the Insert part of the trigger
        // fetching Grantee Budget Update records for preparing cheat code
        List<Grantee_Budget_Update__c> lstGranteeBudgetUpdates = [ SELECT Current_Period_Expenses__c, Expenditures_to_Date__c, Grantee_Report__r.FGM_Base__Request__c, Grantee_Budget_Category__c FROM Grantee_Budget_Update__c];
        Map<Id, Map<Id, Double>> mapGRIdWithCategoryWiseExpenditure = new Map<Id, Map<Id, Double>>(); //Map of grantee report to map of categorywise expenditure.
        Map<Id, Double> mapCategoryWiseExpenditure;
        Double expenditureToDate = 0;

        for( Grantee_Budget_Update__c budgetUpdate : lstGranteeBudgetUpdates ){
            if(mapGRIdWithCategoryWiseExpenditure.containsKey(budgetUpdate.Grantee_Report__c)!=null){
                mapCategoryWiseExpenditure = mapGRIdWithCategoryWiseExpenditure.get(budgetUpdate.Grantee_Report__c);
                if(mapCategoryWiseExpenditure!=null && mapCategoryWiseExpenditure.containsKey( budgetUpdate.Grantee_Budget_Category__c)!=null){
                    mapCategoryWiseExpenditure.put(budgetUpdate.Grantee_Budget_Category__c, expenditureToDate);
                }
                else{
                    mapCategoryWiseExpenditure = new Map<Id, Double>();
                    mapCategoryWiseExpenditure.put( budgetUpdate.Grantee_Budget_Category__c, expenditureToDate);
                }
            }
            else{
                mapCategoryWiseExpenditure = new Map<Id, Double>();
                mapCategoryWiseExpenditure.put( budgetUpdate.Grantee_Budget_Category__c, expenditureToDate );
            }
            mapGRIdWithCategoryWiseExpenditure.put( budgetUpdate.Grantee_Report__c, mapCategoryWiseExpenditure );
        }

        // updating Grantee Budget update records to verify Update trigger part
        for( Grantee_Budget_Update__c budgetUpdate : lstGranteeBudgetUpdates )
          budgetUpdate.Current_Period_Expenses__c = 50;
        update lstGranteeBudgetUpdates;

        for( Grantee_Budget_Update__c budgetUpdate : lstGranteeBudgetUpdates ){
            expenditureToDate = mapGRIdWithCategoryWiseExpenditure.get( budgetUpdate.Grantee_Report__c ).get(budgetUpdate.Grantee_Budget_Category__c);
            system.assertEquals( ( budgetUpdate.Expenditures_to_Date__c), expenditureToDate);
        }
    }

    @isTest
    private static void shouldUpdateCurrentReportCategoryExpenditureDate(){
		List<Grantee_Budget_Category__c> budgetCategoryList = new List<Grantee_Budget_Category__c>(
        	[
                SELECT 	Id, Name
                FROM 	Grantee_Budget_Category__c
            ]
        );
        Opportunity request = [
            SELECT Id 
            FROM Opportunity 
            LIMIT 1
        ];
        
        FGM_Base__Grantee_Report__c report = TestsObjectProvider.CreateFGMBaseGranteeReport( granteeReportRecordTypes[0].getRecordTypeId(), request.Id, 'Requested' );
        report.FGM_Base__Due_Date__c = Date.newInstance(2017, 10 ,9);
        insert report;

        // for Grantee Report: Category one
        Grantee_Budget_Update__c budgetUpdateOne = TestsObjectProvider.CreateGranteeBudgetUpdate( report.Id, null );
        budgetUpdateOne.Current_Period_Expenses__c = 0.0;
        budgetUpdateOne.Grantee_Budget_Category__c = budgetCategoryList.get(0).Id; // Category One
        budgetUpdateOne.Expenditures_to_Date__c = 0.0;
        insert budgetUpdateOne;

        // for Grantee Report: Category Two
        Grantee_Budget_Update__c budgetUpdateTwo = TestsObjectProvider.CreateGranteeBudgetUpdate( report.Id, null );
        budgetUpdateTwo.Current_Period_Expenses__c = 0.0;
        budgetUpdateTwo.Grantee_Budget_Category__c = budgetCategoryList.get(1).Id; // Category Two
        budgetUpdateTwo.Expenditures_to_Date__c = 0.0;
        insert budgetUpdateTwo;

        // Test that updating the current period expense updates the Expenditure Date for that category only
        Test.startTest();
        budgetUpdateOne.Current_Period_Expenses__c = 50000;
        update budgetUpdateOne;
        Test.stopTest();

        Map<Id, Grantee_Budget_Update__c> mapBudgetUpdates = new Map<Id, Grantee_Budget_Update__c>([
            SELECT  Id, Current_Period_Expenses__c, Expenditures_to_Date__c
            FROM    Grantee_Budget_Update__c
        ]);

        System.assertEquals(2, mapBudgetUpdates.size());
        System.assertEquals(50000, mapBudgetUpdates.get(budgetUpdateOne.Id).Expenditures_to_Date__c);
        System.assertEquals(0, mapBudgetUpdates.get(budgetUpdateTwo.Id).Expenditures_to_Date__c);
    }

    @isTest
    private static void shouldUpdateFutureReportsCategoryExpenditureDateCummulatively(){

        List<Grantee_Budget_Category__c> budgetCategoryList = new List<Grantee_Budget_Category__c>(
        	[
                SELECT 	Id, Name
                FROM 	Grantee_Budget_Category__c
            ]
        );
        Opportunity request = [
            SELECT Id 
            FROM Opportunity 
            LIMIT 1
        ];

        // Create 3 reports and their grantee budget updates
        List<FGM_Base__Grantee_Report__c> reports = new List<FGM_Base__Grantee_Report__c>();
        for(Integer i = 0; i<3; i++){
            FGM_Base__Grantee_Report__c report = TestsObjectProvider.CreateFGMBaseGranteeReport( granteeReportRecordTypes[0].getRecordTypeId(), request.Id, 'Requested' );
            report.FGM_Base__Due_Date__c = Date.today().addYears(i);
            reports.add(report);
        }
        insert reports;

        // Create budget update for each category for the reports
        List<Grantee_Budget_Update__c> granteeBudgetUpdates = new List<Grantee_Budget_Update__c>();
        for(Grantee_Budget_Category__c category : budgetCategoryList){
            for(FGM_Base__Grantee_Report__c report: reports){
                Grantee_Budget_Update__c budgetUpdate = TestsObjectProvider.CreateGranteeBudgetUpdate( report.Id, null );
                budgetUpdate.Current_Period_Expenses__c = 0.0;
                budgetUpdate.Grantee_Budget_Category__c = category.Id;
                budgetUpdate.Expenditures_to_Date__c = 0.0;
                granteeBudgetUpdates.add(budgetUpdate);
            }
        }
        insert granteeBudgetUpdates;

        granteeBudgetUpdates = [
            SELECT      Current_Period_Expenses__c, Expenditures_to_Date__c, Grantee_Report__c,
                        Grantee_Report__r.FGM_Base__Request__c, Grantee_Budget_Category__c 
            FROM        Grantee_Budget_Update__c
            ORDER BY    Grantee_Report__r.FGM_Base__Due_Date__c 
        ];

        Map<Id, Map<Id, Grantee_Budget_Update__c>> mapOfMapOfGBUByCategoryIdByReportId = new Map<Id, Map<Id, Grantee_Budget_Update__c>>();
        for(Grantee_Budget_Update__c budgetUpdate : granteeBudgetUpdates){
            if(mapOfMapOfGBUByCategoryIdByReportId.containsKey(budgetUpdate.Grantee_Report__c)){
                mapOfMapOfGBUByCategoryIdByReportId.get(budgetUpdate.Grantee_Report__c).put(budgetUpdate.Grantee_Budget_Category__c, budgetUpdate);
            }else{
                mapOfMapOfGBUByCategoryIdByReportId.put(budgetUpdate.Grantee_Report__c, new Map<Id, Grantee_Budget_Update__c>{budgetUpdate.Grantee_Budget_Category__c => budgetUpdate});
            }
        }

        
        Test.startTest();
            granteeBudgetUpdates = new List<Grantee_Budget_Update__c>();
            
            for(Map<Id, Grantee_Budget_Update__c> mapGBUByCategory: mapOfMapOfGBUByCategoryIdByReportId.values()){
                for(Grantee_Budget_Update__c gbu: mapGBUByCategory.values()){
                    // Update Current Expense for each category's GBU for the 1st report)
                    if(gbu.Grantee_Report__c == reports.get(0).Id){
                        gbu.Current_Period_Expenses__c += 50000;
                    }
                    // Update Current Expense for first category's GBU for the 2nd report. This is for testing that the expenditure-to-date is cumulative
                    if(gbu.Grantee_Report__c == reports.get(1).Id && gbu.Grantee_Budget_Category__c == budgetCategoryList.get(0).Id){
                        gbu.Current_Period_Expenses__c += 25000;
                    }
                    granteeBudgetUpdates.add(gbu);
                }
            }

        update granteeBudgetUpdates;
        Test.stopTest();

        granteeBudgetUpdates = new List<Grantee_Budget_Update__c>([
            SELECT  Current_Period_Expenses__c, Expenditures_to_Date__c, Grantee_Report__c,
                    Grantee_Report__r.FGM_Base__Request__c, Grantee_Budget_Category__c 
            FROM    Grantee_Budget_Update__c
        ]);

        System.assertEquals(9, granteeBudgetUpdates.size());
        for(Grantee_Budget_Update__c gbu: granteeBudgetUpdates){
            if(gbu.Grantee_Report__c == reports.get(0).Id || gbu.Grantee_Budget_Category__c != budgetCategoryList.get(0).Id){
                // Check that the expenditure-to-date value is matching the Current Expense of the first report's similar category
                System.assertEquals(50000, gbu.Expenditures_to_Date__c);
            }else {
                // For the 2nd and 3rd reports, 1st category: check that the expenditure-to-date value is cumulating the current expense for the 1st and 2nd report
                System.assertEquals(75000, gbu.Expenditures_to_Date__c);
            }
        }
    }
    
    @isTest
    private static void shouldUpdateFutureReportsCategoryExpenditureDateWhenMissingCategoryGBUs(){

        List<Grantee_Budget_Category__c> budgetCategoryList = new List<Grantee_Budget_Category__c>(
        	[
                SELECT 	Id, Name
                FROM 	Grantee_Budget_Category__c
            ]
        );
        Opportunity request = [
            SELECT Id 
            FROM Opportunity 
            LIMIT 1
        ];

        // Create 3 reports and their grantee budget updates
        List<FGM_Base__Grantee_Report__c> reports = new List<FGM_Base__Grantee_Report__c>();
        for(Integer i = 0; i<3; i++){
            FGM_Base__Grantee_Report__c report = TestsObjectProvider.CreateFGMBaseGranteeReport( granteeReportRecordTypes[0].getRecordTypeId(), request.Id, 'Requested' );
            report.FGM_Base__Due_Date__c = Date.today().addYears(i);
            reports.add(report);
        }
        insert reports;

        // Create budget update for each category for the reports
        List<Grantee_Budget_Update__c> granteeBudgetUpdates = new List<Grantee_Budget_Update__c>();
        for(FGM_Base__Grantee_Report__c report: reports){
            for(Grantee_Budget_Category__c category : budgetCategoryList){
                Grantee_Budget_Update__c budgetUpdate = TestsObjectProvider.CreateGranteeBudgetUpdate( report.Id, null );
                budgetUpdate.Current_Period_Expenses__c = 0.0;
                budgetUpdate.Grantee_Budget_Category__c = category.Id;
                budgetUpdate.Expenditures_to_Date__c = 0.0;
                granteeBudgetUpdates.add(budgetUpdate);
            }
        }
        insert granteeBudgetUpdates;

        granteeBudgetUpdates = [
            SELECT      Current_Period_Expenses__c, Expenditures_to_Date__c, Grantee_Report__c,
                        Grantee_Report__r.FGM_Base__Request__c, Grantee_Budget_Category__c 
            FROM        Grantee_Budget_Update__c
            ORDER BY    Grantee_Report__r.FGM_Base__Due_Date__c 
        ];

        Map<Id, Map<Id, Grantee_Budget_Update__c>> mapOfMapOfGBUByCategoryIdByReportId = new Map<Id, Map<Id, Grantee_Budget_Update__c>>();
        for(Grantee_Budget_Update__c budgetUpdate : granteeBudgetUpdates){
            if(mapOfMapOfGBUByCategoryIdByReportId.containsKey(budgetUpdate.Grantee_Report__c)){
                mapOfMapOfGBUByCategoryIdByReportId.get(budgetUpdate.Grantee_Report__c).put(budgetUpdate.Grantee_Budget_Category__c, budgetUpdate);
            }else{
                mapOfMapOfGBUByCategoryIdByReportId.put(budgetUpdate.Grantee_Report__c, new Map<Id, Grantee_Budget_Update__c>{budgetUpdate.Grantee_Budget_Category__c => budgetUpdate});
            }
        }

        Grantee_Budget_Update__c updateGrantee = mapOfMapOfGBUByCategoryIdByReportId.get(reports.get(0).Id).get(budgetCategoryList.get(0).Id);
		updateGrantee.Current_Period_Expenses__c += 50000;
        update updateGrantee;
        /*	Current values:     Current Period Expense | Expenditure-to-date
         * 				
         *                      ReportOne       ReportTwo       ReportThree
         *  Category One:       50000 | 50000   0 | 50000       0 | 50000
         *  Category Two:       0 | 0           0 | 0           0 | 0
         *  Category Three:     0 | 0           0 | 0           0 | 0
         */
        
        granteeBudgetUpdates = new List<Grantee_Budget_Update__c>([
            SELECT      Current_Period_Expenses__c, Expenditures_to_Date__c, Grantee_Report__c,
                        Grantee_Report__r.FGM_Base__Request__c, Grantee_Budget_Category__c 
            FROM        Grantee_Budget_Update__c
        ]);

        mapOfMapOfGBUByCategoryIdByReportId = new Map<Id, Map<Id, Grantee_Budget_Update__c>>();
        for(Grantee_Budget_Update__c budgetUpdate : granteeBudgetUpdates){
            if(mapOfMapOfGBUByCategoryIdByReportId.containsKey(budgetUpdate.Grantee_Report__c)){
                mapOfMapOfGBUByCategoryIdByReportId.get(budgetUpdate.Grantee_Report__c).put(budgetUpdate.Grantee_Budget_Category__c, budgetUpdate);
            }else{
                mapOfMapOfGBUByCategoryIdByReportId.put(budgetUpdate.Grantee_Report__c, new Map<Id, Grantee_Budget_Update__c>{budgetUpdate.Grantee_Budget_Category__c => budgetUpdate});
            }
        }
        
        // 2. Delete GBU for the 2nd category, 2nd and 3rd reports
        delete new List<Grantee_Budget_Update__c>{
            mapOfMapOfGBUByCategoryIdByReportId.get(reports.get(1).Id).get(budgetCategoryList.get(1).Id),
			mapOfMapOfGBUByCategoryIdByReportId.get(reports.get(2).Id).get(budgetCategoryList.get(1).Id)
		};
        /*	Current values after deletion:     Current Period Expense | Expenditure-to-date	
         * 				
         *                      ReportOne       ReportTwo       ReportThree
         *  Category One:       50000 | 50000   0 | 50000       0 | 50000
         *  Category Two:       0 | 0           null            null
         *  Category Three:     0 | 0           0 | 0           0 | 0
         */
        
        Test.startTest();
            // 3. Update GBU for 1st category, 3rd report
            Grantee_Budget_Update__c gbuFirstReportThirdCategory = mapOfMapOfGBUByCategoryIdByReportId.get(reports.get(0).Id).get(budgetCategoryList.get(2).Id);
        	gbuFirstReportThirdCategory.Current_Period_Expenses__c += 40000;
        	ProcessorControl.BIsExecuting = false;
        	update new List<Grantee_Budget_Update__c>{gbuFirstReportThirdCategory};
        Test.stopTest();
        /*	Current values after update:     Current Period Expense | Expenditure-to-date
         * 				
         *                      ReportOne       ReportTwo       ReportThree
         *  Category One:       50000 | 50000   0 | 50000       0 | 50000
         *  Category Two:       0 | 0           null            null
         *  Category Three:     40000 | 40000   0 | 40000       0 | 40000
         */

        granteeBudgetUpdates = new List<Grantee_Budget_Update__c>([
            SELECT  Current_Period_Expenses__c, Expenditures_to_Date__c, Grantee_Report__c,
		            Grantee_Report__r.FGM_Base__Due_Date__c,
            		Grantee_Report__r.Name, Grantee_Budget_Category__r.Name,
                    Grantee_Report__r.FGM_Base__Request__c, Grantee_Budget_Category__c 
            FROM    Grantee_Budget_Update__c
        ]);

        System.assertEquals(7, granteeBudgetUpdates.size(), 'Should have 7 GBU records.');
        for(Grantee_Budget_Update__c gbu: granteeBudgetUpdates){
            if(gbu.Grantee_Budget_Category__c == budgetCategoryList.get(0).Id){
                System.assertEquals(50000, gbu.Expenditures_to_Date__c, 'All expenditure-to-date values should be 50000 for the 1st category');
            }else if(gbu.Grantee_Budget_Category__c == budgetCategoryList.get(1).Id){
                System.assertEquals(0.0, gbu.Expenditures_to_Date__c, 'All expenditure-to-date values should be 0 for the 2nd category');
            }else{
                System.assertEquals(40000, gbu.Expenditures_to_Date__c, 'All expenditure-to-date values should be 40000 for the 3rd category');
            }
        }
    }

}