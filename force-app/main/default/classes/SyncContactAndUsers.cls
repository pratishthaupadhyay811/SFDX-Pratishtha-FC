public class SyncContactAndUsers implements queueable
{
    private Set<Id> SetIds;
    private String context;
    private String SObjectType;
    private Map<String, List<FCGlobal.Field>> MapFieldMapping;
    private List<User> lstUsers;
    private List<Contact> lstContacts;
    private List<FGM_Portal__Portal_User__c> lstPortalUsersToUpdate;
    map<Id,Contact> mapContactIdToContact;
    List<FCGlobal.Field> lstPortalUserToContact;

    public SyncContactAndUsers( Set<Id> setIds, CommunityConfiguration__c commConfig , String strContext)
    {

        try
        {
            if( setIds != null && !setIds.isEmpty() )
            {
                for( String strId : setIds )
                {
                    if( Schema.getGlobalDescribe().get('user').getDescribe().getKeyPrefix() == strId.left(3) )
                    {
                        this.SObjectType = 'user';
                        break;
                    }
                    else if( Schema.getGlobalDescribe().get('contact').getDescribe().getKeyPrefix() == strId.left(3) )
                    {
                        this.SObjectType = 'contact';
                        break;
                    }
                    else if( Schema.getGlobalDescribe().get('FGM_Portal__Portal_User__c').getDescribe().getKeyPrefix() == strId.left(3) )
                    {
                        this.SObjectType = 'PortalUser';
                        break;
                    }
                }
                this.SetIds = setIds;
                this.context = strContext;


                if(commConfig!=null)
                    MapFieldMapping = (Map<String,List<FCGlobal.Field>>)JSON.deserialize(commConfig.JsonData__c, Map<String,List<FCGlobal.Field>>.class);

                Set<String> setUserFields = new Set<String>();
                setUserFields.add('Id');

                Set<String> setContactFields = new Set<String>();
                setContactFields.add('Id');

                if(MapFieldMapping!=null)
                {
                    if(MapFieldMapping.get('CommunityUserToContact') !=null)
                    {
                        for( FCGlobal.Field field : MapFieldMapping.get('CommunityUserToContact') )
                        {
                            if( !String.isBlank(field.Value) && field.Value != 'null' )
                                setUserFields.add(field.Value);
                            if( !String.isBlank(field.Name) && field.Name != 'null' )
                                setContactFields.add(field.Name);
                        }
                    }
                    else
                    {
                        Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('contact').getDescribe().fields.getMap();
                        for(Schema.SObjectField sfield : fieldMap.Values())
                        {
                            setContactFields.add(sfield.getDescribe().getName());
                        }
                        fieldMap = Schema.getGlobalDescribe().get('user').getDescribe().fields.getMap();
                        for(Schema.SObjectField sfield : fieldMap.Values())
                        {
                            setUserFields.add(sfield.getDescribe().getName());
                        }
                    }

                }
                if( !setUserFields.contains('ContactId') )
                    setUserFields.add('ContactId');
                if( this.SObjectType.equalsIgnoreCase('contact') )
                    lstUsers = (List<User>)fetchRecords( 'user', setUserFields, 'contactid', this.SetIds);
                else
                    lstUsers = (List<User>)fetchRecords( 'user', setUserFields, 'id', this.SetIds);
                if( this.SObjectType.equalsIgnoreCase('contact') )
                {
                         lstContacts = (List<Contact>)fetchRecords( 'contact', setContactFields, 'id', this.SetIds);
                }
                else
                {
                    Set<Id> setContactIds = new Set<Id>();
                    if(lstUsers!=null && lstUsers.size()>0)
                    {
                        for( User user : lstUsers )
                            setContactIds.add(user.ContactId);
                        lstContacts = (List<Contact>)fetchRecords( 'contact', setContactFields, 'id', setContactIds);
                    }
                }

                //Update portal user from contact
                if(commConfig!=null)
                {
                   if(commConfig.ConfiguationName__c.equalsIgnoreCase('PortalUserFieldMapping'))
                    {
                        Set<String> setPortalUserFields = new Set<String>();
                        mapContactIdToContact = new map<Id,Contact>();

                        for(Contact contact : lstContacts){
                            mapContactIdToContact.put(contact.Id,contact);
                        }
                        map<String,List<FCGlobal.Field>> mapSobjectsMappingFields = new  map<String,List<FCGlobal.Field>>();
                        mapSobjectsMappingFields = (map<String,List<FCGlobal.Field>>)JSON.deserialize(commConfig.FGM_Portal__JsonData__c,map<String,List<FCGlobal.Field>>.class);

                        if(mapSobjectsMappingFields!=null)
                        {
                            lstPortalUserToContact = (List<FCGlobal.Field>)mapSobjectsMappingFields.get('PortalUserToContact');
                            if(lstPortalUserToContact!=null)
                            {
                                for( FCGlobal.Field field : lstPortalUserToContact )
                                {
                                    if( !String.isBlank(field.Value) && field.Value != 'null' )
                                        setPortalUserFields.add(field.Value);
                                }
                                setPortalUserFields.add('FGM_Portal__Contact__c');
                                lstPortalUsersToUpdate = fetchRecords('FGM_Portal__Portal_User__c', setPortalUserFields, 'FGM_Portal__Contact__c', mapContactIdToContact.keySet());
                            }
                        }
                    }
                }
                //Update portal user from contact
            }
        }
        catch(Exception ex)
        {
            system.debug('Handled Exception: ' + ex.getMessage() + ', at line number: ' + ex.getLineNumber());
        }
    }
    private List<sObject> fetchRecords( String objectName, Set<String> fields, string whereToken, Set<Id> conditionSet )
    {
        try
        {
            if(objectName!=null && fields!=null)
            {
                List<String> sanitizedFields = new List<String>();

                for (String f : fields) {
                    sanitizedFields.add(f.replaceAll('[^0-9a-zA-Z_.]', ''));
                }

                String sanitizedObjectName = objectName.replaceAll('[^0-9a-zA-Z_.]', '');

                String strUserQuery = 'SELECT ';
                strUserQuery += String.join(sanitizedFields, ', ');
                strUserQuery += ' FROM ';
                strUserQuery += sanitizedObjectName;
                if (whereToken!=null || whereToken!= '')
                {
                    String sanitizedWhereToken = whereToken.replaceAll('[^0-9a-zA-Z_.]', '');
                    strUserQuery += ' WHERE ';
                    strUserQuery += sanitizedWhereToken +' IN :conditionSet';
                }
                strUserQuery += ' WITH SECURITY_ENFORCED';
                strUserQuery += ' Limit 10000';
                return Database.query(strUserQuery);
            }
            else
                return null;
        }
        catch( Exception ex )
        {
            system.debug('Handled Exception: ' + ex.getMessage() + ', at line number: ' + ex.getLineNumber());
            return null;
        }
    }
    public void execute( QueueableContext context )
    {
        try
        {
            if(this.context == 'Update')
            {
                if( this.SObjectType.equalsIgnoreCase('user'))
                {
                    syncContactsFromUsers();
                }
                else if (this.SObjectType.equalsIgnoreCase('contact') && lstPortalUsersToUpdate==null)
                {
                     syncUsersFromContacts();
                }
                else if (this.SObjectType.equalsIgnoreCase('contact') && lstPortalUsersToUpdate!=null && lstPortalUsersToUpdate.size()>0)
                {
                    syncPortalUserFromContact();
                }
            }
            else if (this.context == 'Delete')
            {
                if(this.SObjectType.equalsIgnoreCase('PortalUser'))
                {
                    deletePortalUserForMergedContact();
                }
            }
        }
        catch( Exception ex )
        {
            system.debug('Handled Exception: ' + ex.getMessage() + ', at line number: ' + ex.getLineNumber());
        }
    }
    private void syncUsersFromContacts()
    {
        try
        {
            if(lstContacts!=null && lstUsers!=null)
            {
                 for( User user : lstUsers )
                {
                    for( Contact contact : lstContacts )
                    {
                        if( user.ContactId == contact.Id )
                        {
                            for( FCGlobal.Field field : MapFieldMapping.get('CommunityUserToContact') )
                                user.put( field.Value, contact.get(field.Name) );
                            break;
                        }
                    }
                }
                ProcessorControl.inCntUpdtCntxt = true;
                CrudFlsService.getInstance().assertUpdateable(lstUsers);
                update lstUsers;
            }
        }
        catch( Exception ex )
        {
            system.debug('Handled Exception: ' + ex.getMessage() + ', at line number: ' + ex.getLineNumber());

        }
    }
    private void syncContactsFromUsers()
    {
        try
        {
            if(lstContacts!=null && lstContacts.size()>0)
            {
                for( Contact contact : lstContacts )
                {
                    for( User user : lstUsers )
                    {
                        if( user.ContactId == contact.Id )
                        {
                            for( FCGlobal.Field field : MapFieldMapping.get('CommunityUserToContact') )
                                contact.put( field.Name, user.get(field.Value) );
                            break;
                        }
                    }
                }
                ProcessorControl.inUsrUpdtCntxt = true;
                CrudFlsService.getInstance().assertUpdateable(lstContacts);
                update lstContacts;
            }
        }
        catch( Exception ex )
        {
            system.debug('Handled Exception: ' + ex.getMessage() + ', at line number: ' + ex.getLineNumber());
        }
    }

    private void syncPortalUserFromContact()
    {
        try
        {
            if(lstPortalUsersToUpdate!=null && lstPortalUsersToUpdate.size()>0)
            {
                for(FGM_Portal__Portal_User__c portalUser : lstPortalUsersToUpdate)
                {
                    FGM_Portal__Portal_User__c sPortalUserToUpdate = new FGM_Portal__Portal_User__c();
                    Contact objContact = mapContactIdToContact.get(portalUser.FGM_Portal__Contact__c);
                    for(FCGlobal.Field field : lstPortalUserToContact)
                    {
                        if(String.IsNotBlank(field.Value))
                        {
                            if(String.IsNotBlank(field.Name))
                            {
                                portalUser.put(field.Value,objContact.get(field.Name));
                            }
                        }
                    }
                }
                CrudFlsService.getInstance().assertUpdateable(lstPortalUsersToUpdate);
                update lstPortalUsersToUpdate;
            }
        }
        catch(Exception ex)
        {
             system.debug('Handled Exception: ' + ex.getMessage() + ', at line number: ' + ex.getLineNumber());
        }
    }

    private void deletePortalUserForMergedContact()
    {
        Savepoint sp;
        try
        {
            Set<String> setPUserFields = new Set<String>();
            setPUserFields.add('Id');
            setPUserFields.add('FGM_Portal__Contact__c');

            List<FGM_Portal__Portal_User__c > lstPortalUsersToDelete = fetchRecords('FGM_Portal__Portal_User__c', setPUserFields, 'Id', SetIds);
            sp = Database.setSavepoint();
            if(!lstPortalUsersToDelete.isEmpty()){
                CrudFlsService.getInstance().assertDeletable(lstPortalUsersToDelete);
                delete lstPortalUsersToDelete;
            }

            ProcessorControl.isCntDltCntxt = false;
        }
        catch(Exception ex)
        {
            Database.rollback(sp);
            system.debug('Handled Exception: ' + ex.getMessage() + ', at line number: ' + ex.getLineNumber());
        }
    }
}