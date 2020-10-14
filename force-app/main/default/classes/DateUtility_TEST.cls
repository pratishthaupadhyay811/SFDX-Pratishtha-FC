@isTest
private with sharing class DateUtility_TEST {
    //NOTE: Cannot test the edge case where user in a different timezone as an org and today has
    //passed for user, but not the org. That test wouldn't pass 100% of the time because there is 1 hour in the day
    //where everyone is on the same day and I don't want a late night deploy to be prevented by that edge case

    @isTest
    private static void shouldReturnFalseWhenDayHasNotPassedInOrgTimezoneForToday() {
        //set org timezone to user timezone so that today always matches
        DateUtility.orgTimezone = UserInfo.getTimeZone();

        Test.startTest();
        Boolean dateHasPassedInCompanyTimezone = new DateUtility().dateHasPassedInCompanyTimezone(Date.today());
        Test.stopTest();

        System.assertEquals(false, dateHasPassedInCompanyTimezone,
            'Should indicate that Today has not passed in the org timezone');
    }

    @isTest
    private static void shouldReturnTrueWhenDayHasPassedInOrgTimezoneForToday() {
        Test.startTest();
        Boolean dateHasPassedInCompanyTimezone = new DateUtility().dateHasPassedInCompanyTimezone(Date.today().addMonths(-1));
        Test.stopTest();

        System.assertEquals(true, dateHasPassedInCompanyTimezone,
            'Should indicate that a day in the past has not passed in the org timezone');
    }

    @isTest
    private static void shouldReturnTodayForOrgIfUserIsInDifferentTimeZone() {
        User differentTimezoneUser = createUser('Pacific/Kiritimati');
        User orgTimezoneUser = createUser([SELECT TimeZoneSidKey FROM Organization][0].TimeZoneSidKey);

        Date expectedToday;
        System.runAs(orgTimezoneUser) {
            expectedToday = Date.today();
        }

        Date orgToday;
        System.runAs(differentTimezoneUser) {
            orgToday = new DateUtility().getOrgToday();
        }

        System.assertEquals(expectedToday, orgToday, 'Today should be based on the org timezone');
    }

    private static User createUser(String timezone) {
        Profile userProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User testUser =  new User(
            Alias = 'jdoe',
            Email = 'testuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            LastName = 'Doe',
            ProfileId = userProfile.Id,
            TimeZoneSidKey = timezone,
            Username = 'testuser@example.com' + Datetime.now().getTime()
        );

        insert testUser;
        return testUser;
    }
}