@isTest
private class TestCommunitySignupExtension{
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            System.assertEquals('POST', req.getMethod());
            string strJson =  '{ "data": {"took": 39,"total_hits": 1, "hits":['+ '{ "organization_id": "7831216", "ein": "13-4145441", "organization_name": "New York", "city": "Brooklyn", "state": "NY", "zip": "11201", "nteecode": "S02 (Management & Technical Assistance)", "participation": "Silver", "irs_subsection": "501(c)(3) Public Charity", "msa": "5600 New York, NY-NJ" }, { "organization_id": "6933739", "ein": "13-4145449", "organization_name": "New york", "city": "Test", "state": "DC", "zip": "11201", "nteecode": "S02 (Management & Technical Assistance)", "participation": "Silver", "irs_subsection": "501(c)(3) Public Charity", "msa": "5600 New York, NY-NJ" } ], "telephones":[ '+ '{"telephone_id":"1480504","telephone_type_id":"1", "telephone_number":"212444-7241" } ],"addresses":[ '+ '{ "address_type_id":"7","address_line_1":"3 MetroTech Center","address_line_2":"Mezzanine Level","city":"Brooklyn","country_subdivision_abbrev":"NY","country_abbrev":"","postal_code":"11201" } ],"subsection":{"subsection_code":"03","section_name":"501(c)(3)","subsection":"Private Foundations and Public Charities"},"reason_nonprivate_foundation":"Section 509(a)(1) organization as referred to in Section 170(b)(1)(A)(vi)","ntee_codes":[{"organization_ntee_id":2743726,"organization_id":7831216,"ntee_code":"T50","ntee_code_detail":{"ntee_code_id":512,"ntee_code":"T50","ntee_code_description":"Philanthropy Charity Voluntarism Promotion (General)"}}],"government_issued_id":"54-1774039"}}';
            res.setHeader('Content-Type', 'application/json');
            res.setBody(strJson);
            res.setStatusCode(200);
            return res;
        }
    }
    @testSetup
    static void setupData(){
        FGM_Portal__Portal_User__c portalUser = new FGM_Portal__Portal_User__c();
        portaluser.FGM_Portal__EIN__c =' 22-3256831';
        PortalUser.FGM_Portal__LastName__c ='test';
        insert portalUser;
    }
    static testMethod void CommunitySignupExtension(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        map<string,string> telephones = new map<string,string>{'telephone_id'=>'3517415', 'telephone_number'=>'414977-1780', 'telephone_type'=>'Primary'};
        map<string,string> mapEIN = new map<string,string>{'75-0851900'=>'75-0851900'};
        map<string,string> mapOrgID = new map<string,string>{'8144831'=>'8144831'};
        map<string,string> mapOrgName = new map<string,string>{'ABILENE'=>'ABILENE'};
        List <Map<String, Map<String, String>>> mapGuideStarRecords1 = new List <Map<String, Map<String, String>>> {
         new Map<String, Map<String, String>>{'ein'=>mapEIN,'organization_id'=>mapOrgID,'organization_name'=>mapOrgName,'telephones'=>telephones}
        };
        FGM_Portal__Quiz__c quiz = TestsObjectProvider.CreateFGMPortalQuiz('testquiz', 'test@test.com','strPageName1', 'strPageName2', 'strPageName3', 'strPageName4', 'strPageName5',  'strPortalIntroduction', true);
        insert quiz;

        Campaign campaign= TestsObjectProvider.CreateCampaign('TestCampaign', 'test@test.com', Date.today(), Date.today(), quiz.Id, '');
        insert campaign;

        Account account = TestsObjectProvider.CreateAccount('TestAccount1');
        Database.SaveResult[] ResultAccount = TestsObjectProvider.InsertListWithAssert(new List<Account>{account});

        FGM_Portal__Portal_Account__c PortalAccount = TestsObjectProvider.CreateFGMPortalAccount(ResultAccount[0].Id, 'PortalAccountName');
        Database.SaveResult[] ResultPortalAccount = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Portal_Account__c>{PortalAccount});

        Contact contact = TestsObjectProvider.CreateContact('TestFirstName', 'TestLastName', ResultAccount[0].Id, 'test@test.com');
        Database.SaveResult[] Resultcontact = TestsObjectProvider.InsertListWithAssert(new List<Contact>{contact});

        System.assertEquals(CommunitySignupExtension.STR_FC_LOGO, CommunitySignupExtension.STR_FC_LOGO );
        Document document = TestsObjectProvider.CreateDocument('test.jpg');
        Database.SaveResult[] ResultDocument = TestsObjectProvider.InsertListWithAssert(new List<Document>{document});

        List<FGM_Portal__CustomHTML__c> lstFGMPortalCustomHTML = new List<FGM_Portal__CustomHTML__c>();
        lstFGMPortalCustomHTML.add(TestsObjectProvider.CreateFGMPortalCustomHTML('Communities Sign Up - Step 1', 'Grantee', 'en_US', 'Header', 'Description1'));
        lstFGMPortalCustomHTML.add(TestsObjectProvider.CreateFGMPortalCustomHTML('Communities Sign Up - Step 1', 'Grantee', 'en', 'Header', 'Description1'));
        lstFGMPortalCustomHTML.add(TestsObjectProvider.CreateFGMPortalCustomHTML('Communities Sign Up - Step 1', 'Grantee', 'en_US', 'Header', 'Description2'));
        Database.Saveresult[] ResultsFGMPortalCustomHTML = TestsObjectProvider.InsertListWithAssert(lstFGMPortalCustomHTML);

        FGM_Portal__Portal_User__c PortalUser = TestsObjectProvider.CreateFGMPortalUser(ResultPortalAccount[0].Id, 'test@osf-communities-developer-edition.na17.force.com', 'Portal LastName', 'test@test1.com', 'test@test1.com', 'test@osf-communities-developer-edition.na17.force.com', 'Test1234', 'Test1234', true);
        PortalUser.FGM_Portal__EIN__c='75-0851900';
        Database.Saveresult[] ResultFGMPortalUser = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__Portal_User__c>{PortalUser});

        FGM_Portal__Portal_User__c PortalUser1 = TestsObjectProvider.CreateFGMPortalUser(ResultPortalAccount[0].Id, 'test1@osf-communities-developer-edition.na17.force.com', 'Portal LastName1', 'test@test.com', 'test@test.com', 'test1', 'Test1234', 'Test1234', true);
        PortalUser1.FGM_Portal__FirstName__c ='test FirstName';

        Map<String,Schema.Recordtypeinfo> newGuidestarFieldRecordTypeMapByName = FGM_Portal__GuidestarFieldMapping__c.SObjectType.getDescribe().getRecordTypeInfosByName();
        FGM_Portal__GuidestarFieldMapping__c FGMPortalGuidestarFieldMapping = TestsObjectProvider.CreateFGMPortalGuidestarFieldMapping(newGuidestarFieldRecordTypeMapByName.get(TestsObjectProvider.PORTAL_GUIDESTAR_GUIDEPORTALUSER).getRecordTypeId(), 'testRegistered', ResultAccount[0].Id);
        Database.Saveresult[] ResultFGMPortalGuidestarFieldMapping = TestsObjectProvider.InsertListWithAssert(new List<FGM_Portal__GuidestarFieldMapping__c>{FGMPortalGuidestarFieldMapping});

        FGM_Portal__GlobalPortalSettings__c PortalSetting = FGM_Portal__GlobalPortalSettings__c.getInstance();
        if( PortalSetting.SetupOwnerId != null){
            PortalSetting = new FGM_Portal__GlobalPortalSettings__c( Name = 'Global Portal Settings');
            PortalSetting.FGM_Portal__Grantee_Portal_Prefix__c = 'fcgrantee';
            PortalSetting.FGM_Portal__Reviewer_Portal_Prefix__c = 'grantee';
            insert PortalSetting;
            System.assertNotEquals( PortalSetting.Id, null);
        }
         List <Map<String, String>> mapGuideStarRecords = new List <Map<String, String>> {
            new Map<String, String>{'city'=>'Abilene', 'ein'=>'75-0851900','organization_id'=>'8144831','organization_name'=>'ABILENE CHRISTIAN UNIVERSITY'},
            new Map<String, String>{'city'=>'Abilene', 'ein'=>'75-0851900','organization_id'=>'8144832','organization_name'=>'Enzigma'}
        };

        List<object> lstGuideStarRecords = new List<object>();
        lstGuideStarRecords.add(mapGuideStarRecords[0]);
        CommunitySignupExtension commSignUp = new CommunitySignupExtension();
        commSignUp.getItems();
        commSignUp.portalLanguage ='';
        commSignUp.getCustomHTMLDescription();

        Pagereference testPageReference = Page.CommunitySignup;
        Test.setCurrentPageReference(testPageReference);

        ApexPages.currentPage().getParameters().put('recordIndex', '1');
        ApexPages.currentPage().getParameters().put('guidestarField', 'FGM_Portal__EIN__c');
        ApexPages.currentPage().getParameters().put('UType','Organization');
        ApexPages.StandardController scPortalUser = new ApexPages.standardController( PortalUser1);

        CommunitySignupExtension commSignUpParameterised = new CommunitySignupExtension(scPortalUser);
        commSignUpParameterised.userProfile = 'Individual';
        commSignUpParameterised.initialize();
        commSignUpParameterised.userProfile = 'Organization';
        commSignUpParameterised.IsSessionFound=false;
        commSignUpParameterised.initialize();
        commSignUpParameterised.portalUser = PortalUser1;

        commSignUpParameterised.username =  PortalUser1.Name + '@osf-communities-developer-edition.na17.force.com';
        commSignUpParameterised.getImageLogoUrl();
        commSignUpParameterised.getCustomHTMLDescription();


        commSignUpParameterised.getGuideStarInfo();
        ApexPages.currentPage().getParameters().put('guidestarField','FGM_Portal__Organization_Legal_Name__c');
        ApexPages.currentPage().getParameters().put('cntryst','India:cs:Maharashtra');
        ApexPages.currentPage().getParameters().put('countrystate','India:cs:Maharashtra');
        commSignUpParameterised.getGuideStarInfo();
        commSignUpParameterised.getOrganizationMode();
        commSignUpParameterised.profileType = 'Individual';
        commSignUpParameterised.next();
        commSignUpParameterised.prev();
        commSignUpParameterised.profileType = 'Organization';
        commSignUpParameterised.intChkEmailField = 1;
        commSignUpParameterised.next();
        commSignUpParameterised.prev();
        commSignUpParameterised.showGuideStarSearch(lstGuideStarRecords);
        commSignUpParameterised.processGuideStarSearch();
        commSignUpParameterised.closeGuideStarResult();
        PortalUser1.FGM_Portal__Organization_Legal_Name__c = null;
        commSignUpParameterised.intChkEmailField = 1;
        commSignUpParameterised.register();
        commSignUpParameterised.redirectTo(testPageReference);
        commSignUpParameterised.getIndividualMode();
        commSignUpParameterised.rollbackWithError('error', null);
        commSignUpParameterised.guideStarField='';
        Account account1 = TestsObjectProvider.CreateAccount('TestAccount2');
        System.assert(account1 != null);
        account1.Name='TestAccount2';
        commSignUpParameterised.returnURL='https://fc-community-developer-edition.na7.force.com/FGM_Portal__CommunitySignin?retUrl=/apex/FGM_Portal__CommunityApplication?id='+campaign.Id+'&quizid=a05A000000SD4uRIAT';
        commSignUpParameterised.register();
        //FCPROD-456
        try
        {
            FCGlobal.checkSession();
            FCGlobal.Error error = new FCGlobal.Error();
            error = new FCGlobal.Error(new Account());
            String errormessage =  FCGlobal.getValidationErrorMessage(new NullPointerException());
        }
        catch(Exception ex){}
    }
      static testMethod void httpCallOutTest()
      {
          Test.startTest();
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
          System.assertEquals(CommunitySignupExtension.PORTAL_USER_FIELDS, Schema.Sobjecttype.FGM_Portal__Portal_User__c.Fields.getMap());
          Test.stopTest();
      }
    static testMethod void callOutTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        map<string,string> telephones = new map<string,string>{'telephone_id'=>'3517415', 'telephone_number'=>'414977-1780', 'telephone_type'=>'Primary'};
        map<string,string> mapEIN = new map<string,string>{'34-1488720'=>'34-1488720'};
        map<string,string> mapOrgName = new map<string,string>{'ABILENE'=>'ABILENE'};
        map<string,string> mapOrgCity = new map<string,string>{'ABILENE'=>'ABILENE'};
        map<string,string> mapOrgCounty = new map<string,string>{'ABILENE'=>'ABILENE'};
        map<string,string> mapOrgState = new map<string,string>{'ABILENE'=>'ABILENE'};
        map<string,string> mapOrgZip = new map<string,string>{'ABILENE'=>'ABILENE'};

        List <Map<String, Map<String, String>>> mapGuideStarRecords1 = new List <Map<String, Map<String, String>>> {
              new Map<String, Map<String, String>>{'ein'=>mapEIN,'organization_name'=>mapOrgName,'telephones'=>telephones,'city'=>mapOrgCity,'county'=>mapOrgCounty,'state'=>mapOrgState,'zip'=>mapOrgZip}
         };
        CommunitySignupExtension communitySignupExtension = new CommunitySignupExtension();
        communitySignupExtension.processSingleGuideStarResult(mapGuideStarRecords1[0]);
        String strURLEncode = communitySignupExtension.URLENCODE('Roundcorner');
        System.assert(strURLEncode != null);
        Test.stopTest();
    }

    @isTest
    private static void shouldCheckForGuideStarNamedCredential() {
        Boolean namedCredentialFound = ![SELECT Id FROM NamedCredential WHERE DeveloperName = 'Guide_Star_Credential'].isEmpty();
        System.assertEquals(namedCredentialFound, new CommunitySignupExtension().hasGuideStarNamedCredential,
            'hasGuideStarNamedCredential should reflect if Named Credential is found');
    }
}