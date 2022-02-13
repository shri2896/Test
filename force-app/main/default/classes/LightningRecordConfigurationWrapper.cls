public with sharing class LightningRecordConfigurationWrapper {

	@AuraEnabled public String objName{get;set;}
	@AuraEnabled public String field{get;set;}
	@AuraEnabled public String recordName{get;set;}
	/*@AuraEnabled public List<String> allFields{get;set;}	*/
	@AuraEnabled public Id recId{get;set;}
	@AuraEnabled public Integer column;

	public LightningRecordConfigurationWrapper() {
		
	}

	public class storeApiNameOfObject{
		@AuraEnabled public String label{get;set;}
		@AuraEnabled public String name{get;set;}

	}

	public class setFieldsApiName{
		@AuraEnabled public String label{get;set;}
		@AuraEnabled public String name{get;set;}	
		@AuraEnabled public String fieldDataType{get;set;}			
	}

	public class JsonData{
		@AuraEnabled public String value;
		@AuraEnabled public Boolean isFirst;
		@AuraEnabled public Boolean duplicateValue;
		
	}

	public class JSON2Apex {
		@AuraEnabled public String value;
		@AuraEnabled public Boolean isFirst;
		@AuraEnabled public Boolean duplicateValue;
	}

}