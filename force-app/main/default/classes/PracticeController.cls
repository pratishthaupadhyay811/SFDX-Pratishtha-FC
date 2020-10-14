public class PracticeController {
 public SObject mySobject {get; set;}
    public Id sObjectId {get;set;}
    public String objectName {get;set;} 
    public PracticeController()
    {
        sObjectId = ApexPages.currentPage().getParameters().get('id'); 
         

        //building object and fields:

        objectName = sObjectId.getSObjectType().getDescribe().getName(); 
        Set<String> setFields = new Set<String>();        
        DescribeSObjectResult objSchema = sObjectId.getSObjectType().getDescribe();
        Map<String, Schema.SObjectField> fieldMap = objSchema.fields.getMap();
        for (String fieldName : fieldMap.keySet())
        {
            SObjectField sfield = fieldMap.get(fieldName);
            schema.describefieldresult dfield = sfield.getDescribe();
            String field = dfield.getName(); 
            setFields.add(field);
        }
        String soqlQuery ='SELECT ';
        for(String sReqField : setFields) {            
            soqlQuery +=  sReqField + ','; 
        }
        soqlQuery = soqlQuery.removeEnd(',');
        soqlQuery += '  FROM ' + objectName + ' WHERE Id =  \''+sObjectId+'\''; 

        mySobject = Database.query(soqlQuery);

    


}
}