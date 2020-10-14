public with sharing class OpportunityTriggerHandler
{
    public static List<FGM_Base__Benchmark_Update__c> BechmarkUpdateInsertHandler(List<FGM_Base__Benchmark_Update__c> lstNewBenchmarkUpdate)
    {
        if(lstNewBenchmarkUpdate != null && lstNewBenchmarkUpdate.size() > 0)
        {
            List<FGM_Base__Benchmark_Update__c> lstOldBenchmarkUpdate = new List<FGM_Base__Benchmark_Update__c> ();

            lstOldBenchmarkUpdate = Database.query('SELECT Id,FGM_Base__Benchmark__c,FGM_Base__Benchmark__r.FGM_Base__Request__c,FGM_Base__Grantee_Report__c,FGM_Base__Grantee_Report__r.FGM_Base__Request__c FROM FGM_Base__Benchmark_Update__c WHERE FGM_Base__Benchmark__c != null AND FGM_Base__Grantee_Report__c != null WITH SECURITY_ENFORCED') ;

            List<FGM_Base__Benchmark_Update__c> lstResult = new List<FGM_Base__Benchmark_Update__c>();

            if(lstOldBenchmarkUpdate != null && lstOldBenchmarkUpdate.size() > 0)
            {
                for(FGM_Base__Benchmark_Update__c benchmarkUpdateNewRecord: lstNewBenchmarkUpdate)
                {
                    if(benchmarkUpdateNewRecord.FGM_Base__Benchmark__c != null && benchmarkUpdateNewRecord.FGM_Base__Grantee_Report__c != null)
                    {
                        for(FGM_Base__Benchmark_Update__c benchmarkUpdateExistRecord : lstOldBenchmarkUpdate)
                        {
                            if(benchmarkUpdateExistRecord.FGM_Base__Benchmark__c != null && benchmarkUpdateExistRecord.FGM_Base__Grantee_Report__c != null)
                            {
                                if(benchmarkUpdateNewRecord.FGM_Base__Benchmark__c == benchmarkUpdateExistRecord.FGM_Base__Benchmark__c && benchmarkUpdateNewRecord.FGM_Base__Grantee_Report__c == benchmarkUpdateExistRecord.FGM_Base__Grantee_Report__c )
                                {
                                    if(benchmarkUpdateExistRecord.FGM_Base__Benchmark__r.FGM_Base__Request__c != null &&  benchmarkUpdateExistRecord.FGM_Base__Grantee_Report__r.FGM_Base__Request__c != null )
                                    {
                                        if(benchmarkUpdateExistRecord.FGM_Base__Benchmark__r.FGM_Base__Request__c == benchmarkUpdateExistRecord.FGM_Base__Grantee_Report__r.FGM_Base__Request__c)
                                        {
                                            lstResult.add(benchmarkUpdateNewRecord);
                                            return lstResult;
                                        }
                                    }
                                }

                            }
                        }
                    }
                }//END_FOR
            }
        }
        return null;
    }
}