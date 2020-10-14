// An apex class that keeps updates of a portal user in sync with its corresponding contact.
// Guest users are never able to access this page.

public with sharing class MyProfilePageController {

    @TestVisible private User user;
    @TestVisible private boolean isEdit = false;

    public User getUser() {
        return user;
    }

    public MyProfilePageController() {
        user = [
            SELECT
                City,
                CommunityNickname,
                Contact.Email,
                Country,
                Email,
                Extension,
                Fax,
                FirstName,
                LanguageLocaleKey,
                LastName,
                LocaleSidKey,
                MobilePhone,
                Phone,
                PostalCode,
                State,
                Street,
                TimezoneSidKey,
                Title,
                UserType,
                Username
            FROM User
            WHERE Id = :UserInfo.getUserId()
            WITH SECURITY_ENFORCED
        ];

        // guest users should never be able to access this page
        if (user.usertype == 'GUEST') {
            throw new NoAccessException();
        }
    }

    public Boolean getIsEdit() {
        return isEdit;
    }

    public void edit() {
        isEdit=true;
    }

    public void save() {
        if (user.contact != NULL) {
            setContactFields(user.contact, user);
        }
        try {
            CrudFlsService.getInstance().assertUpdateable(user);
            update user;
            if (user.contact != NULL) {
                List<String> lstContcatFields = NEW List<String>{'title','email','phone','fax'};
                CrudFlsService.getInstance().assertUpdateable(user.contact);
                 update user.contact;
            }
            isEdit=false;
        } catch(DmlException e) {
            ApexPages.addMessages(e);
        }
    }

    public PageReference changePassword() {
        return Page.ChangePassword;
    }

    public void cancel() {
        isEdit=false;

        user = [
            SELECT
                City,
                CommunityNickname,
                Contact.Email,
                Country,
                Email,
                Extension,
                Fax,
                FirstName,
                LanguageLocaleKey,
                LastName,
                LocaleSidKey,
                MobilePhone,
                Phone,
                PostalCode,
                State,
                Street,
                TimezoneSidKey,
                Title,
                Username
            FROM User
            WHERE id = :UserInfo.getUserId()
            WITH SECURITY_ENFORCED
        ];

    }
    public static void setContactFields(Contact c, User u) {
        c.title = u.title;
        c.firstname = u.firstname;
        c.lastname = u.lastname;
        c.email = u.email;
        c.phone = u.phone;
        c.mobilephone = u.mobilephone;
        c.fax = u.fax;
        c.mailingstreet = u.street;
        c.mailingcity = u.city;
        c.mailingstate = u.state;
        c.mailingpostalcode = u.postalcode;
        c.mailingcountry = u.country;
    }
}