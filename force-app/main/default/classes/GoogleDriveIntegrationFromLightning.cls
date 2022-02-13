public with sharing class GoogleDriveIntegrationFromLightning {
	    
    private static String key='72641396293-5mngnackul8d8dqosv0aihh4kmh0dq13.apps.googleusercontent.com';
    private static String secret = '72641396293-5mngnackul8d8dqosv0aihh4kmh0dq13';
    private static String redirectURL='https://brlightcomponent-dev-ed.lightning.force.com/c/LightningComponentShowRecord.app';     
    /*private String accessToken='';    
    public String folderName;    
    public List<FileDetailsWrapper.FileDetail>lstOfFile{get;set;}    
    public Transient Blob data{get;set;}
    public Transient String recFileName{get;set;}
    public Transient String fileType{get;set;}        
       
*/

    @AuraEnabled
    public static String createAuthURL() {
    	System.debug('enter in createAuthURL');
    	
        String key = EncodingUtil.urlEncode(key,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirectURL,'UTF-8');
        String authuri = '';
        authuri = 'https://accounts.google.com/o/oauth2/auth?'+
        'client_id='+key+
        '&response_type=code'+
        '&scope=https://www.googleapis.com/auth/drive'+
        '&redirect_uri='+uri+
        '&access_type=offline';
        return authuri;
    }

    @AuraEnabled
    public static String getAccessToken(String code)
    {
        //Getting access token from google
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://accounts.google.com/o/oauth2/token');
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        String messageBody = 'code='+code+'&client_id='+key+'&client_secret='+secret+'&redirect_uri='+redirectURL+'&grant_type=authorization_code';
        req.setHeader('Content-length', String.valueOf(messageBody.length()));
        req.setBody(messageBody);
        req.setTimeout(60*1000);

        Http h = new Http();
        String resp;
        HttpResponse res = h.send(req);
        resp = res.getBody();
        Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(res.getBody()) ;  
        String token =  String.valueOf(responseMap.get('access_token'));

        System.debug('access_Token : ' + token);
        return token;

    }

    @AuraEnabled
    public static String uploadFile(String attachmentId, String accessToken) {
   		List<ContentVersion> cvFile = [SELECT VersionData,FileType,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: attachmentId];
        Blob myBlob = cvFile[0].VersionData;
       	String url = 'https://www.googleapis.com/upload/drive/v2/files?uploadType=media';
       	string authorizationHeader = 'Bearer ' + accessToken; 
       	Integer contentSize = myBlob.size();
       	HttpRequest req = new HttpRequest();
       	req.setheader('Authorization',authorizationHeader);
       	req.setheader('Content-Length',String.valueOf(contentSize));
       	req.setheader('Content-Type','image/'+cvFile[0].FileType);
       	req.setMethod('POST'); 
       	req.setEndpoint(url); 
       	req.setBodyAsBlob(myBlob); 
       	Http h = new Http(); 
      
       	Httpresponse resp = h.send(req);
	   	//After file was successfully upload we delete the file
       	delete new ContentDocument(Id = cvFile[0].ContentDocumentId);
       	return String.valueOf(resp.getStatuscode());
    }
	

	/*public GoogleDriveIntegrationFromLightning() {
		folderDirectory = new List<fileDetails1>();
		fileDetails1 fd = new fileDetails1();
		fd.Id = '0';
		fd.name='Root';
		folderDirectory.add(fd);
		lstFile = new List<fileDetails1>();
		lstFolder = new List<fileDetails1>();
		
		token=ApexPages.currentPage().getParameters().get('code');			
		System.debug('Token : ' + token);		

		if(token!='' && token!=null){
			//System.debug('inner Token call');			
			accessToken();			
		}		
	}

	public void accessToken(){
		Http http = new Http();
     	HttpRequest request = new HttpRequest();
      	request.setMethod('POST');	      
      	request.setEndpoint('https://accounts.google.com/o/oauth2/token');
      	request.setHeader('Content-Type', 'Application/x-www-form-urlencoded');	    	    
      	String messageBody = 'code=' + token + '&client_id=' + key + '&client_secret=' + secret + '&redirect_uri='+redirect_uri + '&grant_type=authorization_code';         					 
      	request.setHeader('Content-length', String.valueOf(messageBody.length()));	    
      	request.setBody(messageBody);
  		request.setTimeOut(60*1000);		
  		HttpResponse response = http.send(request);		
  		String s = response.getBody();	
  		System.debug('withour parser : ' + s);				
  		JSONParser parser = JSON.createParser(response.getBody());			
  		//System.debug('With parser : ' + parser );
  		//System.debug( ' Parser.next : ' + parser.nextToken());      
  		while(parser.nextToken()!=null){
              //System.debug('Curernt token : ' + parser.getCurrentToken());
  			if((parser.getCurrentToken()==JSONToken.FIELD_NAME) && (parser.getText() == 'access_Token')){				
  				parser.nextToken();				
  				access_Token = parser.getText();				      
  				//System.debug('Access_token : ' + access_Token);  				
  			}
        if(parser.getText()=='refresh_token'){
            parser.nextToken();
            refreshToken = parser.getText();
        }
        
		}

  		if(access_Token!= '' && access_Token != null){
  			//System.debug('access_Token : ' + access_Token);
  			getFileNames();
  		}
	}

	public PageReference DriveAuth(){
    	PageReference pageRef = new PageReference(new AuthUri(key, redirectURL).AuthenticationUri);
    	return pageRef;    	
    }
*/
}