public with sharing class FileApprovalController {
		
	public FileApprovalController() {		
	}

	@AuraEnabled
	public static void saveRecord(List<String> lstOfData){
		Schema.DescribeSObjectResult schema = Account.sObjectType.getDescribe();
		List<String>apiNames =  new list<String>();

		for(string apiName : schema.fields.getMap().keySet()){
		 	  apiNames.add(apiName);
		}	

		//System.debug('api : ' + apiNames);

		List<Account> lstOfAcc = new List<Account>();

		for(Integer i = 0; i < lstOfData.size(); i++){
				
			List<String> str = lstOfData[i].split(',');			
			Account a = new Account();			
			
			for(Integer j = 0; j < str.size() - 2; j++){
				System.debug('Enter : ' + str[j]);
				if(str[j] == '' || str[j] == null || str[j] == ' '){
					str[j] = 'abc';
				}
				//a.accountFields[j] = str[j];

			}			
		}
	}
}