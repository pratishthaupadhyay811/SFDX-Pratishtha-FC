@isTest
public class TestOpportunityTriggerHandler
{
    static testMethod void OpportunityTriggerHandlerTestMethod()
    {
        List<User> lstSysAdminUsers = [ SELECT Id FROM User WHERE Profile.Name ='System Administrator' AND IsActive = true ];

        Account account = TestsObjectProvider.CreateAccount('TestAccountBenchh');
        account.OwnerId = lstSysAdminUsers[0].Id;
        Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

        Opportunity opportunity = TestsObjectProvider.CreateOpportunity('TestBenchOpp', 'In Progress', Date.today());
        opportunity.OwnerId = lstSysAdminUsers[0].Id;
        opportunity.AccountId = ResultAccount[0].Id;
        Database.Saveresult[] ResultOpportunity = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunity});

        List<FGM_Base__Grantee_Report__c> lstGranteeReport = new List<FGM_Base__Grantee_Report__c>();
        lstGranteeReport.add(TestsObjectProvider.CreateGranteeReport(ResultOpportunity[0].Id));
        Database.Saveresult[] ResultGranteeReport = TestsObjectProvider.InsertListWithAssert(lstGranteeReport);

        List<FGM_Base__Benchmark__c> lstBenchmark = new List<FGM_Base__Benchmark__c>();
        lstBenchmark.add(TestsObjectProvider.CreateFGMBaseBenchmark(ResultOpportunity[0].Id, 'Proposed', true, true, Date.today(), true));
        Database.Saveresult[] ResultBenchmark = TestsObjectProvider.InsertListWithAssert(lstBenchmark);

        List<FGM_Base__Benchmark_Update__c> lstBenchmarkUpdate = new List<FGM_Base__Benchmark_Update__c>();
        lstBenchmarkUpdate.add(new FGM_Base__Benchmark_Update__c(FGM_Base__Benchmark__c=lstBenchmark[0].Id, FGM_Base__Grantee_Report__c=ResultGranteeReport[0].Id));
        insert lstBenchmarkUpdate;

        System.assertNotEquals(lstBenchmarkUpdate[0].Id, null);

        FGM_Base__Benchmark_Update__c benchmarkUpdate = new FGM_Base__Benchmark_Update__c();
        benchmarkUpdate.FGM_Base__Benchmark__c = ResultBenchmark[0].Id;
        benchmarkUpdate.FGM_Base__Grantee_Report__c = ResultGranteeReport[0].Id;
        try{
            insert benchmarkUpdate;
            System.assertEquals(benchmarkUpdate.Id, null);
        }
        catch(DMLException ex){
            if(ex.getTypeName() == 'FIELD_CUSTOM_VALIDATION_EXCEPTION'){
                System.assertEquals(benchmarkUpdate.Id, null);
            }
        }

    }
}