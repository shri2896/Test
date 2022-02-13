@isTest
public with sharing class GoogleDriveLightningTest {
	public GoogleDriveLightningTest() {
		
	}

	 public static testmethod void accessTokenTest()
    {    	    
        Test.setMock(HttpCalloutMock.class, new GoogleDriveLightningMockCallout());			
		GoogleDriveCredentials__c userRec = new GoogleDriveCredentials__c();
        userRec.AccessToken__c = 'fPc5LFt3Mklb_YTS85fXaSj37G';
        userRec.UserId__c = UserInfo.getUserId();
        userRec.RefreshToken__c = '0000B7YJFQA3-98lDKxPsn6004MvHQNfjNk7eAlfyO2MQNB_eydrYt95aBcAKoHGKD2E09yt5knk4vht29O-Sj37G';
        insert userRec;
        
        Test.startTest();               
        	LightningIntegrationResponseWrapper responseWrapper = new LightningIntegrationResponseWrapper();        	        	
        
			GoogleDriveIntegrationInLightning lightningForgot=new GoogleDriveIntegrationInLightning();
        	GoogleDriveIntegration__mdt user_metaData_rec = [SELECT ClientId__c,  ClientSecret__c, RedirectURL__c FROM GoogleDriveIntegration__mdt LIMIT 1];
        	List<GoogleDriveCredentials__c> driveUserRec = [select RefreshToken__c, UserId__c from GoogleDriveCredentials__c where UserId__c = :UserInfo.getUserId() AND RefreshToken__c != null  ];        	                    	        	
        	GoogleDriveIntegrationInLightning.getAuthCode();	        	
        	GoogleDriveIntegrationInLightning.getAccessTokenUsingRefreshToken('id', 'secret', 'token');        	        	
        	GoogleDriveIntegrationInLightning.deleteFolder1('1RMiG9KGQcPNlFhIzWb00uI81RG9vdQOn', 'ya29.GlsfB7NwuyESGaQGpNYkvD5jNpXdVK8rGfPc5LFt3Mklb_Y98lDKxPsn6004MvHQNfjNk7eAlfyO2MQNB_eydrYt95aBcAKoHGKD2E09yt5knk4vht29OTS85fXa');
			GoogleDriveIntegrationInLightning.getAuthURL('clientid ','url');        
        	GoogleDriveIntegrationInLightning.downloadFile1('root', 'accessToken');			               
        	GoogleDriveIntegrationInLightning.getFileNames('token', 'root');
        	GoogleDriveIntegrationInLightning.saveChunk('fileName', 'base64Data', 'fileType', 'fId', 'accesstoken');
        	GoogleDriveIntegrationInLightning.getAccessToken('code');
		test.stoptest();	                
    }        

}