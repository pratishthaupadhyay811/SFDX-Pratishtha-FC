@isTest
public class TestLookupComponentController {
static testMethod void LookupComponentController()
{
    LookupComponentController obj=new LookupComponentController();
    Account objAccount=new Account();
    objAccount.Name='Test Account';
    insert objAccount;
    System.assertNotEquals(null,objAccount);
    Opportunity objOpportunity=new Opportunity();
    objOpportunity.Name='Test Opportunity';
    objOpportunity.AccountId=objAccount.ID;
    objOpportunity.StageName='Application Started';
    objOpportunity.CloseDate=date.Today();
    insert objOpportunity;
    System.assertNotEquals(null,objOpportunity);
    obj.setcomponentValue(string.valueOf(string.valueOf(objopportunity.ID)));
    obj.getComponentValue();
}
}