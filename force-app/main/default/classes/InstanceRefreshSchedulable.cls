global with sharing class InstanceRefreshSchedulable implements Schedulable {
  global void execute(SchedulableContext sc) {
        String domainName;
        try {

            List<Domain> domain = [
                SELECT
                    Domain,
                    DomainType
                FROM Domain
                WITH SECURITY_ENFORCED
            ];

             domainName = domain[0].Domain;
        }
        catch(Exception ex)
        {
            system.debug( 'Exception: ' + ex +'at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
        }
        InstanceRefreshBatchable userBatchJob = new InstanceRefreshBatchable();
        userBatchJob.DomainName = domainName;
        userBatchJob.query = 'SELECT Id, UserName, Name, IsActive FROM User WHERE (NOT UserName LIKE \'%@' + domainName + '\') AND  User.ContactID != null LIMIT 50000000';
            database.executebatch(userBatchJob);

        InstanceRefreshBatchable portalUserBatchJob = new InstanceRefreshBatchable();
        portalUserBatchJob.DomainName = domainName;
        portalUserBatchJob.query = 'SELECT Id, Name, FGM_Portal__Domain__c FROM FGM_Portal__Portal_User__c WHERE (NOT Name LIKE \'%@' + domainName + '\') LIMIT 50000000';
            database.executebatch(portalUserBatchJob);
    }
}