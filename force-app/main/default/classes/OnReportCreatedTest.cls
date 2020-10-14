@isTest
public class OnReportCreatedTest {

    private static Account testAccount;
    private static FGM_Portal__Portal_Account__c testPortalAccount;
    private static Contact testContact;
    private static Opportunity testOpportunity;
    private static FGM_Portal__Grantee_Budget__c testGranteeBudget;
    private static FGM_Portal__Quiz__c testPortalQuiz;
    private static FGM_Portal__Grantee_Budget_Category__c testGranteeBudgetCategory;
    private static FGM_Portal__Grantee_Budget_Configuration__c testGranteeBudgetConfiguration;
    private static FGM_Portal__Grantee_Budget_Line_Item__c testGranteeBudgetLineItem;
    private static FGM_Base__Grantee_Report__c testGranteeReport;

    public static testmethod void createAdditionPermissionTest(){
        Account objAcc =  new Account(Name = 'Test');
        insert objAcc;
        System.assert(objAcc.Id != null);

        FGM_Portal__Portal_Account__c objPortAcc = new FGM_Portal__Portal_Account__c(Name = 'TestPortAcc');
        insert  objPortAcc;
        System.assert(objPortAcc.Id != null);

        Contact objPortalUser = new Contact();
        objPortalUser.LastName='TestLastName';
        objPortalUser.Email='testuser@gmail.com';
        objPortalUser.FGM_Portal__Confirm_Email__c ='testuser@gmail.com';
        objPortalUser.FGM_Portal__Password__c='123';
        objPortalUser.FGM_Portal__Confirm_Password__c='123';
        insert objPortalUser;
        System.assert(objPortalUser.Id != null);

        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'TestOpp';
        objOpp.AccountId = objAcc.Id;
        objOpp.Amount =  12000;
        objOpp.CloseDate = Date.today();
        objOpp.FGM_Base__Amount_Requested__c = 12000;
        objOpp.StageName = 'Invited';
        insert objOpp;
        System.assert(objOpp.Id != null);


        FGM_Base__Grantee_Report__c objReport1  = new FGM_Base__Grantee_Report__c();
        objReport1.FGM_Base__Request__c = objOpp.Id;
        objReport1.FGM_Base__Due_Date__c = Date.today().addDays(30);
        objReport1.FGM_Base__Interim_Report__c = true;
        insert objReport1;
        System.assert(objReport1.Id != null);


        FGM_Portal__Portal_Permission__c objPortPerm = new FGM_Portal__Portal_Permission__c();
        objPortPerm.FGM_Portal__Opportunity__c = objOpp.Id;
        objPortPerm.FGM_Portal__Portal_Account__c  = objPortAcc.Id;
        objPortPerm.FGM_Portal__Contact__c = objPortalUser.Id;
        objPortPerm.FGM_Portal__Grantee_Report__c = objReport1.Id;
        insert objPortPerm;
        System.assert(objPortPerm.Id != null);

        Test.startTest();

        list<FGM_Base__Grantee_Report__c> lstReports =  new list<FGM_Base__Grantee_Report__c>();

        FGM_Base__Grantee_Report__c objReport2  = new FGM_Base__Grantee_Report__c();
        objReport2.FGM_Base__Request__c = objOpp.Id;
        objReport2.FGM_Base__Due_Date__c = Date.today().addDays(35);
        objReport2.FGM_Base__Interim_Report__c = true;
        lstReports.add(objReport2);

        FGM_Base__Grantee_Report__c objReport3  = new FGM_Base__Grantee_Report__c();
        objReport3.FGM_Base__Request__c = objOpp.Id;
        objReport3.FGM_Base__Due_Date__c = Date.today().addDays(40);
        objReport3.FGM_Base__Interim_Report__c = true;
        lstReports.add(objReport3);

        FGM_Base__Grantee_Report__c objReport4  = new FGM_Base__Grantee_Report__c();
        objReport4.FGM_Base__Request__c = objOpp.Id;
        objReport4.FGM_Base__Due_Date__c = Date.today().addDays(45);
        objReport4.FGM_Base__Final_Report__c = true;
        lstReports.add(objReport4);

        insert lstReports;
        System.assert(lstReports[0].Id != null);
        Test.stopTest();
    }

    public static testmethod void createGranteeBudgetUpdateRecordsTest(){

        FGM_Portal__Grantee_Budget__c granteeBudget = TestsObjectProvider.CreateGranteeBudget('2015');
        Database.SaveResult[] resultGranteeBudget = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Grantee_Budget__c>{granteeBudget});

        FGM_Portal__Grantee_Budget_Category__c granteeBudgetCategory = TestsObjectProvider.CreateGranteeBudgetCategory('Annual Budget');
        Database.SaveResult[] resultGranteeBudgetCategory = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Grantee_Budget_Category__c>{granteeBudgetCategory});

        FGM_Portal__Quiz__c fgmPortalQuiz = TestsObjectProvider.CreateFGMPortalQuiz('PortalQuiz1', 'test@test1.com', 'Page1', 'Page2', 'Page3', 'Page4', 'Page5', 'Introduction', true);
        Database.Saveresult[] resultFGMPortalQuiz = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Quiz__c>{fgmPortalQuiz});

        FGM_Portal__Grantee_Budget_Configuration__c granteeBudgetConfig = TestsObjectProvider.CreateGranteeBudgetConfig(resultFGMPortalQuiz[0].Id);
        Database.SaveResult[] resultGranteeBudgetConfig = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Grantee_Budget_Configuration__c>{granteeBudgetConfig});

        Opportunity opportunity = TestsObjectProvider.CreateOpportunity('testOpp', 'In Progress', Date.today());
        Database.Saveresult[] resultOpportunity = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunity});

        FGM_Portal__Grantee_Budget_Line_Item__c granteeBudgetLineItem = TestsObjectProvider.CreateGranteeBudgetLineItem(resultOpportunity[0].Id,ResultGranteeBudget[0].Id);
        Database.SaveResult[] resultGranteeBudgetLineItem = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Grantee_Budget_Line_Item__c>{granteeBudgetLineItem});

        list<FGM_Base__Grantee_Report__c> lstReports =  new list<FGM_Base__Grantee_Report__c>();
        FGM_Base__Grantee_Report__c objReport  = new FGM_Base__Grantee_Report__c();
        objReport.FGM_Base__Request__c = resultOpportunity[0].Id;
        lstReports.add(objReport);
        insert lstReports;
        System.assert(lstReports[0].Id != null);

        FGM_Portal__Grantee_Budget_Update__c granteeBudgetUpdate = TestsObjectProvider.CreateGranteeBudgetUpdate(lstReports[0].Id, resultGranteeBudgetLineItem[0].Id);
        Database.SaveResult[] resultGranteeBudgetUpdate = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Grantee_Budget_Update__c>{granteeBudgetUpdate});
    }

    public static testmethod void calculateExpendituresToDateAmountTest(){

        Opportunity opportunity = TestsObjectProvider.CreateOpportunity('testOpportunity', 'In Progress', Date.today());
        Database.Saveresult[] resultOpportunity = TestsObjectProvider.InsertListWithAssert(new List<Opportunity>{opportunity});

        FGM_Portal__Grantee_Budget__c granteeBudget = TestsObjectProvider.CreateGranteeBudget('2015');
        Database.SaveResult[] resultGranteeBudget = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Grantee_Budget__c>{granteeBudget});


        FGM_Portal__Grantee_Budget_Line_Item__c granteeBudgetLineItem = TestsObjectProvider.CreateGranteeBudgetLineItem(resultOpportunity[0].Id,ResultGranteeBudget[0].Id);
        Database.SaveResult[] resultGranteeBudgetLineItem = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Grantee_Budget_Line_Item__c>{granteeBudgetLineItem});

        list<FGM_Base__Grantee_Report__c> lstReports =  new list<FGM_Base__Grantee_Report__c>();
        FGM_Base__Grantee_Report__c objReport  = new FGM_Base__Grantee_Report__c();
        objReport.FGM_Base__Request__c = resultOpportunity[0].Id;
        lstReports.add(objReport);
        insert lstReports;
        System.assert(lstReports[0].Id != null);

        FGM_Portal__Grantee_Budget_Update__c granteeBudgetUpdate = TestsObjectProvider.CreateGranteeBudgetUpdate(lstReports[0].Id, resultGranteeBudgetLineItem[0].Id);
        Database.SaveResult[] resultGranteeBudgetUpdate = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Grantee_Budget_Update__c>{granteeBudgetUpdate});

        granteeBudgetUpdate.FGM_Portal__Current_Period_Expenses__c = 10;
        Database.SaveResult[] resultGranteeBudgetUpdate1 = TestsObjectProvider.UpdateListWithAssert(new List<FGM_Portal__Grantee_Budget_Update__c>{granteeBudgetUpdate});


    }
    
    public static testMethod void createPermissionTest()
    {
        Account objAcc =  new Account(Name = 'Test');
        insert objAcc;
        System.assert(objAcc.Id != null);

        FGM_Portal__Portal_Account__c objPortAcc = new FGM_Portal__Portal_Account__c(Name = 'TestPortAcc');
        insert  objPortAcc;
        System.assert(objPortAcc.Id != null);

        Contact objPortalUser = new Contact();
        objPortalUser.LastName='TestLastName';
        objPortalUser.Email='testuser@gmail.com';
        objPortalUser.FGM_Portal__Confirm_Email__c ='testuser@gmail.com';
        objPortalUser.FGM_Portal__Password__c='123';
        objPortalUser.FGM_Portal__Confirm_Password__c='123';
        insert objPortalUser;
        System.assert(objPortalUser.Id != null);

        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'TestOpp';
        objOpp.AccountId = objAcc.Id;
        objOpp.Amount =  12000;
        objOpp.CloseDate = Date.today();
        objOpp.FGM_Base__Amount_Requested__c = 12000;
        objOpp.StageName = 'Invited';
        insert objOpp;
        System.assert(objOpp.Id != null);


        FGM_Base__Grantee_Report__c objReport1  = new FGM_Base__Grantee_Report__c();
        objReport1.FGM_Base__Request__c = objOpp.Id;
        objReport1.FGM_Base__Due_Date__c = Date.today().addDays(30);
        objReport1.FGM_Base__Interim_Report__c = true;
        insert objReport1;
        System.assert(objReport1.Id != null);


        FGM_Portal__Portal_Permission__c objPortPerm = new FGM_Portal__Portal_Permission__c();
        objPortPerm.FGM_Portal__Opportunity__c = objOpp.Id;
        objPortPerm.FGM_Portal__Portal_Account__c  = objPortAcc.Id;
        objPortPerm.FGM_Portal__Contact__c = objPortalUser.Id;
        objPortPerm.FGM_Portal__Grantee_Report__c = objReport1.Id;
        insert objPortPerm;
        System.assert(objPortPerm.Id != null);

        FGM_Base__Grantee_Report__c objReport2  = new FGM_Base__Grantee_Report__c();
        objReport2.FGM_Base__Request__c = objOpp.Id;
        objReport2.FGM_Base__Due_Date__c = Date.today().addDays(30);
        objReport2.FGM_Base__Interim_Report__c = true;
        insert objReport2;
        System.assert(objReport2.Id != null);
    }

    @isTest
    public static void createGranteeBudgetUpdateWithOutBudgetByCategory(){
        Test.startTest();
        createBaseDataByCategoryTest();
        Test.stopTest();
        FGM_Portal__Grantee_Budget_Update__c testGranteeBudgetUpdate = [SELECT 
                                                            Id, 
                                                            Name, 
                                                            FGM_Portal__Grantee_Report__c, 
                                                            FGM_Portal__Grantee_Budget_Category__c, 
                                                            FGM_Portal__Grantee_Report__r.FGM_Base__Request__c, 
                                                                (SELECT 
                                                                        Id 
                                                                    FROM FGM_Portal__Grantee_Budget_Update_By_Categories__r) 
                                                        FROM FGM_Portal__Grantee_Budget_Update__c 
                                                        WHERE FGM_Portal__Grantee_Report__c = :testGranteeReport.Id
                                                        LIMIT 1];
        System.assert(testGranteeBudgetUpdate.FGM_Portal__Grantee_Budget_Category__c != null, 'Grantee Budget Update was not created correctly');
    }

    @isTest
    public static void createGranteeBudgetUpdateWithBudgetByCategory(){
        Test.startTest();
        createBaseDataByCategoryTest();
        FGM_Portal__Grantee_Budget_Update__c testGranteeBudgetUpdate = new FGM_Portal__Grantee_Budget_Update__c();
        testGranteeBudgetUpdate.FGM_Portal__Grantee_Budget_Line_Item__c = testGranteeBudgetLineItem.Id;
        testGranteeBudgetUpdate.FGM_Portal__Grantee_Budget_Category__c = testGranteeBudgetCategory.Id;
        testGranteeBudgetUpdate.FGM_Portal__Grantee_Report__c = testGranteeReport.Id;
        insert testGranteeBudgetUpdate;
        FGM_Portal__Grantee_Budget_Update_By_Category__c testGranteBudgetUpdateByCategory = new FGM_Portal__Grantee_Budget_Update_By_Category__c();
        testGranteBudgetUpdateByCategory.FGM_Portal__Grantee_Budget_Line_Item__c = testGranteeBudgetLineItem.Id;
        testGranteBudgetUpdateByCategory.FGM_Portal__Amount__c = testGranteeBudgetLineItem.FGM_Portal__Amount__c;
        testGranteBudgetUpdateByCategory.FGM_Portal__Grantee_Budget_Update__c = testGranteeBudgetUpdate.Id;
        insert testGranteBudgetUpdateByCategory;
        Test.stopTest();
        List<FGM_Portal__Grantee_Budget_Update_By_Category__c> testGranteeBudgetUpdateByCategory = [SELECT 
                   		Id 
                   	FROM FGM_Portal__Grantee_Budget_Update_By_Category__c 
                   	WHERE FGM_Portal__Grantee_Budget_Update__c = :testGranteeBudgetUpdate.Id
                   	LIMIT 10];
        System.assert(1 == testGranteeBudgetUpdateByCategory.size(), 'Grantee Budget Update was not created correctly or it was created more than once.');
        System.assert(testGranteBudgetUpdateByCategory.Id == testGranteeBudgetUpdateByCategory.get(0).Id, 'Grantee Budget Update By Category should be the same.');
    }

    @isTest
    private static void createBaseDataByCategoryTest() {
        testAccount =  new Account(Name = 'Test');
        insert testAccount;
        System.assert(testAccount.Id != null);
        
        testPortalAccount = new FGM_Portal__Portal_Account__c(Name = 'TestPortAcc');
        insert  testPortalAccount;
        System.assert(testPortalAccount.Id != null);
        
        testContact = new Contact();
        testContact.LastName='TestLastName';
        testContact.Email='testuser@gmail.com';
        testContact.FGM_Portal__Confirm_Email__c ='testuser@gmail.com';
        testContact.FGM_Portal__Password__c='123';
        testContact.FGM_Portal__Confirm_Password__c='123';
        insert testContact;
        System.assert(testContact.Id != null);
        
        testOpportunity = new Opportunity();
        testOpportunity.Name = 'TestOpp';
        testOpportunity.AccountId = testAccount.Id;
        testOpportunity.Amount =  12000;
        testOpportunity.CloseDate = Date.today();
        testOpportunity.FGM_Base__Amount_Requested__c = 12000;
        testOpportunity.StageName = 'Invited';
        insert testOpportunity;
        System.assert(testOpportunity.Id != null);
        
        testGranteeBudget = new FGM_Portal__Grantee_Budget__c();
        testGranteeBudget.Name = 'Test Grante Budget';
        insert testGranteeBudget;
        System.assert(testGranteeBudget.Id != null);
        
        testPortalQuiz = new FGM_Portal__Quiz__c();
        testPortalQuiz.Name = 'Quiz';
        testPortalQuiz.FGM_Portal__Is_Active__c = true;
        insert testPortalQuiz;
        System.assert(testPortalQuiz.Id != null);
        
        testGranteeBudgetCategory = new FGM_Portal__Grantee_Budget_Category__c();
        testGranteeBudgetCategory.FGM_Portal__IsActive__c = true;
        testGranteeBudgetCategory.Name = 'Admin';
        insert testGranteeBudgetCategory;
        System.assert(testGranteeBudgetCategory.Id != null);
        
        testGranteeBudgetConfiguration = new FGM_Portal__Grantee_Budget_Configuration__c();
        testGranteeBudgetConfiguration.FGM_Portal__Quiz__c = testPortalQuiz.Id;
        testGranteeBudgetConfiguration.FGM_Portal__Category__c = testGranteeBudgetCategory.Id;
        insert testGranteeBudgetConfiguration;
        System.assert(testGranteeBudgetConfiguration.Id != null);
        
        testGranteeBudgetLineItem = new FGM_Portal__Grantee_Budget_Line_Item__c();
        testGranteeBudgetLineItem.FGM_Portal__Opportunity__c = testOpportunity.Id;
        testGranteeBudgetLineItem.FGM_Portal__Grantee_Budget__c = testGranteeBudget.Id;
        testGranteeBudgetLineItem.FGM_Portal__Budget_Configuration__c = testGranteeBudgetConfiguration.Id;
        testGranteeBudgetLineItem.FGM_Portal__Amount__c = 1000.00;
        testGranteeBudgetLineItem.FGM_Portal__Category__c = testGranteeBudgetCategory.Id;
        insert testGranteeBudgetLineItem;        
        System.assert(testGranteeBudgetLineItem.Id != null);
        
        testGranteeReport  = new FGM_Base__Grantee_Report__c();
        testGranteeReport.FGM_Base__Request__c = testOpportunity.Id;
        testGranteeReport.FGM_Base__Due_Date__c = Date.today().addDays(30);
        testGranteeReport.FGM_Base__Interim_Report__c = true;
        testGranteeReport.FGM_Base__Submitted_By__c = testContact.Id;
        insert testGranteeReport;
        System.assert(testGranteeReport.Id != null);
    }
}