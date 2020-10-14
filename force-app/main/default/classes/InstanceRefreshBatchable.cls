Public class InstanceRefreshBatchable implements Database.Batchable<sObject>
{
    Public String Query;
    Public String DomainName;
    Public string sObjectName;
    Public Integer RecordsProcessed = 0;

    Public Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }

    Public void execute(Database.BatchableContext BC, List<sObject> lstsObjects)
    {
        Savepoint executeSavePoint = Database.setSavepoint();
        try
        {
            string userNamewithoutDomain;
            string exsitingDomain;

            sObjectName = String.valueOf(lstsObjects.getSobjectType());

            if('User'.equalsIgnoreCase(sObjectName))
            {
                for(User usr : (List<User>)lstsObjects)
                {
                    userNamewithoutDomain = usr.Username.substringbefore('@');
                    usr.Username = userNamewithoutDomain + '@' + DomainName;
                }

                CrudFlsService.getInstance().assertUpdateable(lstsObjects);
                Database.SaveResult[] SaveResults = DataBase.update(lstsObjects);

                for(Database.SaveResult sR : SaveResults)
                {
                    if(!sR.isSuccess())
                        System.debug(' ::  Errors  :: ' + sR.getErrors() + ' ::  ID  :: ' + sR.getID());
                    else
                        RecordsProcessed++;
                    System.debug(' ::  Errors  :: ' + sR.getErrors() + ' ::  ID  :: ' + sR.getID());
                }
            }
            if('FGM_Portal__Portal_User__c'.equalsIgnoreCase(sObjectName))
            {

                for(FGM_Portal__Portal_User__c pUsr : (List<FGM_Portal__Portal_User__c>)lstsObjects)
                {
                    userNamewithoutDomain = pUsr.name.substringbefore('@');
                    pUsr.Name = userNamewithoutDomain + '@' + DomainName;
                    pUsr.FGM_Portal__Domain__c = DomainName;
                }

                CrudFlsService.getInstance().assertUpdateable(lstsObjects);
                Database.SaveResult[] SaveResults = DataBase.update(lstsObjects);

                for(Database.SaveResult sR : SaveResults)
                {
                    if(!sR.isSuccess())
                        System.debug(' ::  Errors  :: ' + sR.getErrors() + ' ::  ID  :: ' + sR.getID());
                    else
                        RecordsProcessed++;
                    System.debug(' ::  Errors  :: ' + sR.getErrors() + ' ::  ID  :: ' + sR.getID());
                }
            }
        }
        catch(Exception ex)
        {
            Database.rollback(executeSavePoint);
            system.debug( 'Exception: ' + ex +'at Line: '+ex.getLineNumber()+' stackTrace: '+ex.getStackTraceString());
        }
    }

    Public void finish(Database.BatchableContext BC)
    {
        System.debug(' ::  Number  of  ' + sObjectName+ ' records updated :: ' + RecordsProcessed);
    }
}