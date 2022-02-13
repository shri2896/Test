public with sharing class LightningRecordsPaginationWrapper {
	
	@AuraEnabled public String value;
	@AuraEnabled public String label;
	@AuraEnabled public String dataType;
	@AuraEnabled public Boolean isRequired;
	public LightningRecordsPaginationWrapper(String lbl, String api, String fieldDataType) {
		value = api;
		label = lbl;
		dataType = fieldDataType;
	}

	public LightningRecordsPaginationWrapper(String lbl, String api) {
		value = api;
		label = lbl;		
	}
}