public with sharing class ObjectRecordsPaginationInLightning {
    
    public static List<LightningRecordsPaginationWrapper> objectWrapper = new List<LightningRecordsPaginationWrapper>();
    public static Map<string,Schema.SObjectField> mpConField = new Map<String, Schema.SObjectField>();
    
    public ObjectRecordsPaginationInLightning() {
        
    }
    
    @AuraEnabled
    public static List<LightningRecordsPaginationWrapper> getObjectList(){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        list<schema.SobjectType> lst=schemaMap.values();
        
        for(schema.SobjectType sObj : lst){
            if(sObj.getDescribe().isAccessible() && sObj.getDescribe().isDeletable() && sObj.getDescribe().isQueryable() && sObj.getDescribe().isUndeletable() && sObj.getDescribe().isUpdateable() && sObj.getDescribe().iscreateable() && sObj.getDescribe().issearchable()){
                    objectWrapper.add(new LightningRecordsPaginationWrapper(sObj.getDescribe().getLabel(), sObj.getDescribe().getName()));                                        
            }
        }
        system.debug(objectWrapper);
        return objectWrapper;
    }
    
    @AuraEnabled
    public static List<LightningRecordsPaginationWrapper> getFilds(String objectName){
        //System.debug(objectName);
        List<LightningRecordsPaginationWrapper> fieldsList = new List<LightningRecordsPaginationWrapper>();
        LightningRecordsPaginationWrapper wrapperObject;
        Schema.DescribeSObjectResult desribeResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
        Map<String,Schema.SObjectField> fieldsMap = desribeResult.fields.getMap();
        for(Schema.SObjectField obj:fieldsMap.values()) {
            Schema.DescribeFieldResult describefields =  obj.getDescribe();
            
            if(describefields.isCreateable() && describefields.isAccessible() && describefields.isUpdateable()) {

                SObjectType r = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
				DescribeSObjectResult d = r.getDescribe();
				String fldDataType = String.valueOf(d.fields.getMap().get(describefields.getName()).getDescribe().getType());
				wrapperObject = new LightningRecordsPaginationWrapper(describefields.getLabel(),describefields.getName(), fldDataType);

				System.debug(fldDataType);

                if(! describefields.isNillable()) {
                    //wrapperObject.isRequired = true;
                    wrapperObject.isRequired = true;
                } else {
                    wrapperObject.isRequired = true;
                }
                fieldsList.add(wrapperObject);
            }  
        }
        //System.debug(fieldsList);
        return fieldsList;
    }

    @AuraEnabled
    public static List<SObject> showRecordsController(String objectName, List<String>fields){
    	system.debug('objectName : ' + objectName);
    	system.debug('fields : ' + fields);
		String queryFields = '';

		for(Integer i = 0; i < fields.size(); i++){
			if(i == fields.size()-1){
				system.debug('if : ' + fields[i].removeEnd('\''));
				queryFields = queryFields + fields[i].removeEnd('\'');

			} else{
				queryFields = queryFields + fields[i] + ',';
				system.debug('else : ' + fields[i]);
			}			
		}
		system.debug('queryFields : ' + queryFields);		

		List<SObject> slctObjRecord = new List<SObject>();
		slctObjRecord = Database.query('select ' + queryFields + ' from ' + objectName);

		system.debug('queryFields : ' + slctObjRecord);

		return slctObjRecord;
    }
}


/*
String objectName = 'Account';
String fieldName = 'Name';

SObjectType r = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
DescribeSObjectResult d = r.getDescribe();
System.debug(d.fields
        .getMap()
        .get(fieldName)
        .getDescribe()
        .getType());
*/