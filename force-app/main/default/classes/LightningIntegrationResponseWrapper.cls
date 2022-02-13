public with sharing class LightningIntegrationResponseWrapper {
	
	@AuraEnabled public List<fileDetails1> files;              

	public LightningIntegrationResponseWrapper() {
		
	}
	
    public class fileDetails1 {
       @AuraEnabled public String id{get;set;}
       @AuraEnabled public String name{get;set;}
       @AuraEnabled public String mimeType{get;set;}
    }  

    // use for send auth url and access token to js. if user first time authenticate return auth url orther wise return accessToken
	public class getURL_AccessToekn{
		@AuraEnabled public String authURL;
		@AuraEnabled public String accessToken;
		@AuraEnabled public String refreshToken;
	} 
}