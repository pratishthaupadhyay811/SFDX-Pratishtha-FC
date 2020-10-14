public with sharing class DateUtility {
    @TestVisible
    private static TimeZone orgTimezone {
        get {
            if (orgTimezone == null) {
                orgTimezone = Timezone.getTimeZone([SELECT TimeZoneSidKey FROM Organization][0].TimeZoneSidKey);
            }

            return orgTimezone;
        }
        set;
    }

    public Boolean dateHasPassedInCompanyTimezone(Date aDate) {
        if (aDate == null) {
            return false;
        }

        Time endTime = Time.newInstance(23, 59, 59, 999);

        //Find 23:59:59.999 PM in the time zone of the org, convert to a long so you can compare across timezones
        Integer offsetSeconds = orgTimezone.getOffset(aDate) / 1000;
        Long deadline =
            Datetime.newInstanceGmt(aDate, endTime)
                    .addSeconds(-offsetSeconds)
                    .getTime();

        Long currentTime =
            DateTime.now()
                .getTime();

        return deadline < currentTime;
    }

    public Date getOrgToday() {
        Integer offsetSeconds = orgTimezone.getOffset(Date.today()) / 1000;
        Datetime orgDateTime = Datetime.now().addSeconds(offsetSeconds);
        return Date.newInstance(orgDateTime.yearGMT(), orgDateTime.monthGMT(), orgDateTime.dayGMT());
    }
}