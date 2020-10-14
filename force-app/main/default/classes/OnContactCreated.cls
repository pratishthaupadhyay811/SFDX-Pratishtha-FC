public with sharing class OnContactCreated {
    public static void CheckDuplicateAndAssignAccount(Contact[] arrNewContacts) {
        List<Contact> lstContactsToAddAccount = NEW List<Contact>();
        List<Account> lstNewAccountsToAdd = NEW List<Account>();
        List<Contact> lstOldContacts = NEW List<Contact>();
        List<Id> idContacts = NEW List<Id>();
        Map<String,Contact> mapContact = NEW Map<String,Contact>();
        for(Contact newContact : arrNewContacts) {
            if(newContact.Id != NULL){
                idContacts.add(newContact.Id);
            }
            if(newContact.FGM_Portal__Username__c != NULL && newContact.FGM_Portal__Username__c != '') {
                if(!mapContact.containsKey(newContact.FGM_Portal__Username__c)){
                     mapContact.put(newContact.FGM_Portal__Username__c,newContact);
                }
                else{
                     newContact.addError(' Username '+ newContact.FGM_Portal__Username__c +' is not available. Please try with different username.');
                }
            }
        }

        lstOldContacts = [
            SELECT Username__c
            FROM Contact
            WHERE Username__c IN :mapContact.KeySet()
            WITH SECURITY_ENFORCED
        ];

        if(lstOldContacts != NULL && lstOldContacts.size() > 0) {
            for(Contact dublicateContact: lstOldContacts) {
                if(mapContact.containsKey(dublicateContact.FGM_Portal__Username__c)) {
                    mapContact.get(dublicateContact.FGM_Portal__Username__c).addError(' Username '+ dublicateContact.FGM_Portal__Username__c +' is not available. Please try with different username.');
                    mapContact.remove(dublicateContact.FGM_Portal__Username__c);
                }
            }
        }
    }
}