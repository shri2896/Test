public with sharing class LightningObjectConfiguration {


	public LightningObjectConfiguration() {
		
	}

	@AuraEnabled
	public static List<LightningRecordConfigurationWrapper.storeApiNameOfObject> getSobjectList(){
		try{
			List<SelectOption> listOfObject = new List<SelectOption>();	
			List<string> SobjectList = new List<string>();		
			List<LightningRecordConfigurationWrapper.storeApiNameOfObject> lst = new List<LightningRecordConfigurationWrapper.storeApiNameOfObject>();				

			for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){

				LightningRecordConfigurationWrapper.storeApiNameOfObject obj = new LightningRecordConfigurationWrapper.storeApiNameOfObject();
				Schema.DescribeSObjectResult describe = objTyp.getDescribe();
				
				if(describe.isAccessible() && describe.isDeletable() && describe.isQueryable() && describe.isUndeletable() &&describe.isUpdateable() && describe.iscreateable() && describe.issearchable()){
					String label = describe.getLabel();		   
					String value = describe.getName();

					obj.label = label;
					obj.name = value;				      	
			      	listOfObject.add(new SelectOption(value, label));
			      	//lst.add(obj);
				}			
		  	}		
		  	if(listOfObject.size() > 0){
		  		listOfObject.sort();
		  	}

		  	for(Integer i = 0; i < listOfObject.size(); i++){
		   	   	LightningRecordConfigurationWrapper.storeApiNameOfObject objWrapper = new LightningRecordConfigurationWrapper.storeApiNameOfObject();

		   	   	String label = listOfObject[i].getLabel();
	           	String name = listOfObject[i].getValue();

	           	objWrapper.label = label;
	           	objWrapper.name = name;

	        	//System.debug('label : ' + label + ' name : ' + name);
	           	lst.add(objWrapper);

		    }
		  	//System.debug('obj : ' + lst.size());
		  	return lst;
		  }
		catch(Exception e){
			throw new AuraHandledException('Error message to display in component');
			return null;
		}
	}

	@AuraEnabled
	public static List<LightningRecordConfigurationWrapper.setFieldsApiName> getFields(String selectedObj){

		try{			

			System.debug('selectedObj : ' + selectedObj);
			List<LightningRecordConfigurationWrapper.setFieldsApiName> lst = new List<LightningRecordConfigurationWrapper.setFieldsApiName>();		
			List<SelectOption> lstOfFlds = new List<SelectOption>();
			Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
			Set<String> flds;				
			Map<string,Schema.SObjectField> mpConField = new Map<String, Schema.SObjectField>();
			Map<String, String> mapOfFieldDataType = new Map<String, String>();

			mpConField=schemaMap.get(selectedObj).getDescribe().fields.getMap();
	    	flds = mpConField.keySet();                           

	    	for(String singleField : flds){                                          
		       Schema.DescribeFieldResult fldResult = mpConField.get(singleField).getDescribe(); 
		       
		       if(fldResult.isAccessible() && fldResult.isUpdateable()){
		           //mapOfApiName.put(fldResult.getLabel(), fldResult.getName());                                      
		           String label = fldResult.getLabel();
		           String name = fldResult.getName();		
		           
		           Schema.DisplayType fieldDataType = Schema.getGlobalDescribe() 
				    .get(selectedObj)
				    .getDescribe()
				    .fields
				    .getMap()
				    .get(name)
				    .getDescribe()
				    .getType(); 
					//System.debug(fieldDataType);           
		           
		           lstOfFlds.add(new SelectOption(name, label));

		           mapOfFieldDataType.put(name, String.valueOf(fieldDataType));
		        }
		    }          

		    if(lstOfFlds.size() > 0){
		   		lstOfFlds.sort();
		    }

		    for(Integer i = 0; i < lstOfFlds.size(); i++){
		   	   	LightningRecordConfigurationWrapper.setFieldsApiName obj = new LightningRecordConfigurationWrapper.setFieldsApiName();

		   	   	String label = lstOfFlds[i].getLabel();
	           	String name = lstOfFlds[i].getValue();

	           	obj.label = label;
	           	obj.name = name;
	           	obj.fieldDataType = mapOfFieldDataType.get(name);
	        	//System.debug('data type : ' + mapOfFieldDataType.get(name));
	           	lst.add(obj);

		    }

		    System.debug('lst : ' + lst);
		    return lst;
		}
		catch(Exception e){
			return null;
		}		
	}

	@AuraEnabled
	public static void saveRecordInObject(String obj, String lstOfFields, String recName, Integer column){						
		
		System.debug('column : ' + column);
		RecordConfiguration__c rec = new RecordConfiguration__C();
		rec.ObjectName__c = obj;
		rec.Fields__c = lstOfFields;
		rec.name = recName;
		rec.column__c = column;
		upsert rec;

		System.debug('after insert : ' + Database.query('select ObjectName__c from RecordConfiguration__C'));
	}

	@AuraEnabled
	public static List<LightningRecordConfigurationWrapper> getObjectRecords(){
		try{
			List<RecordConfiguration__C> rec = [select ObjectName__c, Fields__c, id, name, column__c from RecordConfiguration__C];
			System.debug('all rec : ' + rec);

			List<LightningRecordConfigurationWrapper> wraperObj = new List<LightningRecordConfigurationWrapper>();
			
			for(Integer i = 0; i < rec.size(); i++){
				LightningRecordConfigurationWrapper tmpObj = new LightningRecordConfigurationWrapper();
				tmpObj.objName = rec[i].ObjectName__c;
				tmpObj.field = rec[i].Fields__c;				
				tmpObj.recId = rec[i].Id;	
				tmpObj.recordName = rec[i].name;
				tmpObj.column = Integer.valueOf(rec[i].column__c);

				wraperObj.add(tmpObj);
			}
			System.debug('all rec : ' + wraperObj);
			return wraperObj;
		}
		catch(Exception exce){
			System.debug('Exception : ' + exce);
			return null;
		}
	}
}