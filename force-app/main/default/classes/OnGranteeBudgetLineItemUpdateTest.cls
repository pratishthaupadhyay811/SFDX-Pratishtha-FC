@isTest
public class OnGranteeBudgetLineItemUpdateTest
{
    public static testMethod void unitTestGranteeBudgetLineItemTrigger()
    {
        Opportunity opportunity = TestsObjectProvider.CreateOpportunity('testGranteeOpp', 'Submitted', Date.today());
        Database.Saveresult[] ResultOpportunity = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunity});

        FGM_Base__Grantee_Report__c FGMBaseGranteeReport1 = TestsObjectProvider.CreateFGMBaseGranteeReport(null, opportunity.Id, 'Received'); //newGranteeReportRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GRANTEEREPORT_NARRATIVEREPORT).getRecordTypeId()
        FGMBaseGranteeReport1.FGM_Base__Display_Benchmark__c = true;

        FGM_Base__Grantee_Report__c FGMBaseGranteeReport2 = TestsObjectProvider.CreateFGMBaseGranteeReport(null, opportunity.Id, 'Received'); //newGranteeReportRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GRANTEEREPORT_NARRATIVEREPORT).getRecordTypeId()
        FGMBaseGranteeReport2.FGM_Base__Display_Benchmark__c = true;

        Database.Saveresult[] ResultFGMBaseGranteeReport11 = TestsObjectProvider.InsertListWithAssert(new List<FGM_Base__Grantee_Report__c>{FGMBaseGranteeReport1,FGMBaseGranteeReport2});

        FGM_Portal__Grantee_Budget_Category__c FGMGranteeBudgetCategory = TestsObjectProvider.CreateGranteeBudgetCategory('Grantee Budget Category 1');
        Database.Saveresult[] ResultFGMPortalGBCategory = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Grantee_Budget_Category__c>{FGMGranteeBudgetCategory});

        FGM_Portal__Grantee_Budget__c FGMGranteeBudget = TestsObjectProvider.CreateGranteeBudget('2015');
        FGM_Portal__Grantee_Budget__c FGMGranteeBudget1 = TestsObjectProvider.CreateGranteeBudget('2016');
        FGM_Portal__Grantee_Budget__c FGMGranteeBudget2 = TestsObjectProvider.CreateGranteeBudget('2017');
        Database.Saveresult[] ResultFGMPortalGB = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Grantee_Budget__c>{FGMGranteeBudget,FGMGranteeBudget1,FGMGranteeBudget2});

        FGM_Portal__Grantee_Budget_Line_Item__c FGMGranteeBudgetLineItem = TestsObjectProvider.CreateGranteeBudgetLineItem(ResultOpportunity[0].Id,ResultFGMPortalGB[0].Id);
        FGMGranteeBudgetLineItem.FGM_Portal__Category__c = ResultFGMPortalGBCategory[0].Id;

        FGM_Portal__Grantee_Budget_Line_Item__c FGMGranteeBudgetLineItem1 = TestsObjectProvider.CreateGranteeBudgetLineItem(ResultOpportunity[0].Id,ResultFGMPortalGB[0].Id);
        FGMGranteeBudgetLineItem1.FGM_Portal__Category__c = ResultFGMPortalGBCategory[0].Id;

        FGM_Portal__Grantee_Budget_Line_Item__c FGMGranteeBudgetLineItem2 = TestsObjectProvider.CreateGranteeBudgetLineItem(ResultOpportunity[0].Id,ResultFGMPortalGB[0].Id);
        FGMGranteeBudgetLineItem2.FGM_Portal__Category__c = ResultFGMPortalGBCategory[0].Id;

        FGM_Portal__Grantee_Budget_Line_Item__c FGMGranteeBudgetLineItem3 = TestsObjectProvider.CreateGranteeBudgetLineItem(ResultOpportunity[0].Id,ResultFGMPortalGB[1].Id);
        FGMGranteeBudgetLineItem3.FGM_Portal__Category__c = ResultFGMPortalGBCategory[0].Id;

        List<FGM_Portal__Grantee_Budget_Line_Item__c> granteeBudgetLineItem = new List<FGM_Portal__Grantee_Budget_Line_Item__c>{FGMGranteeBudgetLineItem,FGMGranteeBudgetLineItem1,FGMGranteeBudgetLineItem2,FGMGranteeBudgetLineItem3};

        Database.Saveresult[] ResultFGMPortalGBLineItem = TestsObjectProvider.InsertListWithAssert(granteeBudgetLineItem);

        FGM_Portal__Grantee_Budget_Update__c gBudgetUpdate = TestsObjectProvider.CreateGranteeBudgetUpdate(ResultFGMBaseGranteeReport11[0].Id, ResultFGMPortalGBLineItem[0].Id);
        FGM_Portal__Grantee_Budget_Update__c gBudgetUpdate1 = TestsObjectProvider.CreateGranteeBudgetUpdate(ResultFGMBaseGranteeReport11[1].Id, ResultFGMPortalGBLineItem[1].Id);

        Database.Saveresult[] ResultFGMPortalGBUpdates = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Grantee_Budget_Update__c>{gBudgetUpdate,gBudgetUpdate1});

        List<FGM_Portal__Grantee_Budget_Update_By_Category__c>  lstGRBUpdateByCategoryToInsert = new List<FGM_Portal__Grantee_Budget_Update_By_Category__c>();
        FGM_Portal__Grantee_Budget_Update_By_Category__c GRBudgetUpdateCategoryRecord = new FGM_Portal__Grantee_Budget_Update_By_Category__c();
        GRBudgetUpdateCategoryRecord.FGM_Portal__Grantee_Budget_Line_Item__c = ResultFGMPortalGBLineItem[0].Id;
        GRBudgetUpdateCategoryRecord.FGM_Portal__Amount__c = 10 ;
        GRBudgetUpdateCategoryRecord.FGM_Portal__Grantee_Budget_Update__c = ResultFGMPortalGBUpdates[0].Id;
        lstGRBUpdateByCategoryToInsert.add(GRBudgetUpdateCategoryRecord);

        FGM_Portal__Grantee_Budget_Update_By_Category__c GRBudgetUpdateCategoryRecord1 = new FGM_Portal__Grantee_Budget_Update_By_Category__c();
        GRBudgetUpdateCategoryRecord1.FGM_Portal__Grantee_Budget_Line_Item__c = ResultFGMPortalGBLineItem[1].Id;
        GRBudgetUpdateCategoryRecord1.FGM_Portal__Amount__c = 10 ;
        GRBudgetUpdateCategoryRecord1.FGM_Portal__Grantee_Budget_Update__c = ResultFGMPortalGBUpdates[0].Id;
        lstGRBUpdateByCategoryToInsert.add(GRBudgetUpdateCategoryRecord1);


        FGM_Portal__Grantee_Budget_Update_By_Category__c GRBudgetUpdateCategoryRecord2 = new FGM_Portal__Grantee_Budget_Update_By_Category__c();
        GRBudgetUpdateCategoryRecord2.FGM_Portal__Grantee_Budget_Line_Item__c = ResultFGMPortalGBLineItem[2].Id;
        GRBudgetUpdateCategoryRecord2.FGM_Portal__Amount__c = 10;
        GRBudgetUpdateCategoryRecord2.FGM_Portal__Grantee_Budget_Update__c = ResultFGMPortalGBUpdates[1].Id;
        lstGRBUpdateByCategoryToInsert.add(GRBudgetUpdateCategoryRecord2);

        FGM_Portal__Grantee_Budget_Update_By_Category__c GRBudgetUpdateCategoryRecord3 = new FGM_Portal__Grantee_Budget_Update_By_Category__c();
        GRBudgetUpdateCategoryRecord3.FGM_Portal__Grantee_Budget_Line_Item__c = ResultFGMPortalGBLineItem[3].Id;
        GRBudgetUpdateCategoryRecord3.FGM_Portal__Amount__c = 10;
        GRBudgetUpdateCategoryRecord3.FGM_Portal__Grantee_Budget_Update__c = ResultFGMPortalGBUpdates[1].Id;
        lstGRBUpdateByCategoryToInsert.add(GRBudgetUpdateCategoryRecord3);

        Database.Saveresult[] ResultBUpdateByCategory = TestsObjectProvider.InsertListWithAssert(lstGRBUpdateByCategoryToInsert);
        List<FGM_Portal__Grantee_Budget_Line_Item__c> lstGranteeBudgetLineItems = [Select Name, Id,FGM_Portal__Amount__c From FGM_Portal__Grantee_Budget_Line_Item__c limit 1000];
        for( FGM_Portal__Grantee_Budget_Line_Item__c budgetItem : lstGranteeBudgetLineItems )
        {
            budgetItem.FGM_Portal__Amount__c = 100;
        }
        update lstGranteeBudgetLineItems;
    }
}