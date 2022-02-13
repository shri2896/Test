global with sharing class PaginationUsingJSRemotingController {

	static Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();	
	static Public List<SelectOption> sObjLst{get;set;}
	static List<SelectOption> fldLst;		
	static Map<string,Schema.SObjectField> mpConField = new Map<String, Schema.SObjectField>();
	static Set<String> fldsKeySet = new Set<String>();		
	static List<ObjectWrapper> fieldsWrapper = new List<ObjectWrapper>();

	public PaginationUsingJSRemotingController(){}

	public static void getObject(){	
		try{			
			sObjLst = new List<SelectOption>();
			sObjLst.add(new SelectOption('','---None---'));			
			List<Schema.SobjectType> lstOfObj = schemaMap.values();			
			for(Schema.SObjectType  sObj : lstOfObj){	
				Schema.DescribeSObjectResult describeSObjResult = sObj.getDescribe();		
				if(describeSObjResult.isAccessible() && describeSObjResult.isDeletable() && describeSObjResult.isQueryable() && describeSObjResult.isUndeletable() && describeSObjResult.isUpdateable() && describeSObjResult.iscreateable() && describeSObjResult.issearchable()){	                 
	                sObjLst.add(new SelectOption(sObj.getDescribe().getName(),sObj.getDescribe().getLabel()));                                                           	                
	            }                        
	        }
	        if(sObjLst.size() > 0){
	        	sObjLst.sort();	        	
	        }	        
	    }
	    catch(Exception e){
	    	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Error...!!!'));	    	
	    }
	}
	@RemoteAction
	public static List<ObjectWrapper> showObjFields(String selectedObj){
		try{									
			getFieldName(selectedObj);									
			return fieldsWrapper;				
		}
		catch(Exception e){
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Error...!!!'));			
			return null;
		}
	}

	public static void getFieldName(String selectedObj){
		mpConField = SchemaMap.get(selectedObj).getDescribe().fields.getMap();
		fldsKeySet = mpConField.keySet();
		fldLst = new List<SelectOption>();				
		for(String fName : fldsKeySet){
			Schema.DescribeFieldResult fldResult = mpConField.get(fName).getDescribe();
			if(fldResult.isAccessible() && fldResult.isUpdateable() && fldResult.isFilterable() ){		
				ObjectWrapper ow = new ObjectWrapper();
				ow.name = fldResult.getName();
				ow.label = fldResult.getLabel(); 
				fieldsWrapper.add(ow);					
			}			
		}		
	}

}