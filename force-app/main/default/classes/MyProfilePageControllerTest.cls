@IsTest public with sharing class MyProfilePageControllerTest {
    @testSetup static void testSetup() {
        Try{

            List<User> lstSysAdminUsers = [ SELECT Id FROM User WHERE Profile.Name ='System Administrator' AND IsActive = true ];
            Account account = TestsObjectProvider.CreateAccount('Sun Micro System');
            account.OwnerId = lstSysAdminUsers[0].Id;
            Database.SaveResult[] resultAccount = TestsObjectProvider.InsertListWithAssert(NEW List<Account>{account});

            Contact objContcat = NEW Contact();
            objContcat.LastName = 'Test';
            objContcat.Email = 'test@test.com';
            objContcat.AccountId =resultAccount[0].Id;
            Database.SaveResult[]  saveResult =  Database.insert(NEW List<Contact>{objContcat});

            String strProfile ='FC Community Users Profile';

            Profile profile = [SELECT Id FROM Profile WHERE Name = :strProfile];

            User objUser = NEW User();
            objUser.email =  'test@test.com';
            objUser.Alias ='test';
            objUser.EmailEncodingKey = 'UTF-8';
            objUser.username = 'test@test..1356.com';
            objUser.communitynickname = 'test';
            objUser.timezonesidkey ='Asia/Singapore';
            objUser.languagelocalekey ='en_US';
            objUser.localesidkey ='en_US';
            objUser.firstname ='test';
            objUser.lastname ='test';
            objUser.phone ='9090909090';
            objUser.mobilephone ='12345';
            objUser.fax = '123 456 789';
            objUser.street = 'ABC';
            objUser.city = 'pune';
            objUser.state ='Maharashtra';
            objUser.postalcode ='413739';
            objUser.country ='India';
            objUser.ContactId = saveResult[0].Id;
            objUser.ProfileId = profile.Id;
            insert objUser;
        }catch(Exception ex){
            system.debug('exc :'+ex.getMessage() +' '+ex.getStackTraceString());
        }
    }

    static testMethod void  getIsEditTest(){
        User objUser =[SELECT Id FROM User WHERE username = 'test@test..1356.com'];
        System.runAs(objUser){
            MyProfilePageController objController = NEW MyProfilePageController();
            system.assert(objController.isEdit == objController.getIsEdit());
            objController.edit();
            system.assert(objController.isEdit == TRUE);
            objController.getUser();
            objController.changePassword();
        }
    }

    static testMethod void  saveTest(){
        User objUser =[SELECT Id FROM User WHERE username = 'test@test..1356.com'];
        System.runAs(objUser){
            MyProfilePageController objController = NEW MyProfilePageController();
            objController.edit();
            objController.save();
            system.debug('objController.isEdit'+objController.isEdit);
            system.assert(objController.isEdit == FALSE);
        }
    }

    static testMethod void  cancelTest(){
        User objUser =[SELECT Id FROM User WHERE username = 'test@test..1356.com'];
        System.runAs(objUser){
            MyProfilePageController objController = NEW MyProfilePageController();
            objController.cancel();
            system.assert(objController.isEdit == FALSE);
        }
    }
}