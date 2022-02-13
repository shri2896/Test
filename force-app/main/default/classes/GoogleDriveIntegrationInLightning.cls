public class GoogleDriveIntegrationInLightning {
	    
    private static String key;
    private static String secret;
    private static String redirectURL;            
    public static List<LightningIntegrationResponseWrapper.fileDetails1> lstFolder = new List<LightningIntegrationResponseWrapper.fileDetails1>();
    public static List<LightningIntegrationResponseWrapper.fileDetails1> lstFile = new List<LightningIntegrationResponseWrapper.fileDetails1>();     
    static public LightningIntegrationResponseWrapper.getURL_AccessToekn url_accessToken = new LightningIntegrationResponseWrapper.getURL_AccessToekn();    

    @AuraEnabled
    public static LightningIntegrationResponseWrapper.getURL_AccessToekn getAuthCode(){      /*Return authentication url if user authenticate for the first time other wise get refreshtoken from object and return accesstoken using refresh token*/         

        //Getting current user record if exists
        List<GoogleDriveCredentials__c> driveUserRec = [select RefreshToken__c, UserId__c from GoogleDriveCredentials__c where userId__c = :UserInfo.getUserId() AND RefreshToken__c != null  ]; //Getting if current user already exists and refresh token not null;                               
        System.debug('driveUserRec : ' + driveUserRec);
        
        GoogleDriveLightningIntegration__c user_id_secret = GoogleDriveLightningIntegration__c.getOrgDefaults(); 
        key = user_id_secret.ClientId__c;
        secret = user_id_secret.ClientSecret__c;
        redirectURL = user_id_secret.RedirectURL__c;
          
        System.debug('Meta data records : ' +   key);
        System.debug('key : ' +   secret);
        System.debug('secret : ' +   redirectURL);        
        System.debug('refresh : ' +   driveUserRec);
        
        //If current user exists than return accesstoken
        if(driveUserRec.size() > 0){                                                
            System.debug('if part  : ' );
            System.debug('refresh : ' +   driveUserRec[0].RefreshToken__c);            
            
            url_accessToken = getAccessTokenUsingRefreshToken(key, secret, driveUserRec[0].RefreshToken__c);                        
            System.debug('getStatusCode : ' + url_accessToken);
        }
        else{
            // If user authentication for the first time
            System.debug('else in no user');                                                          
            url_accessToken.authURL = getAuthURL(key, redirectURL);
        }        

        return url_accessToken;
    }
    
    // Get access token using refresh token
    public static LightningIntegrationResponseWrapper.getURL_AccessToekn getAccessTokenUsingRefreshToken(String clientId, String secret, String refreshtoken){

      System.debug('clientId, secret, refreshtoken : ' + clientId + ' : ' + secret + ' : ' + refreshtoken);
  
        LightningIntegrationResponseWrapper.getURL_AccessToekn return_URL_accessToken = new LightningIntegrationResponseWrapper.getURL_AccessToekn();
      
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.googleapis.com/oauth2/v4/token');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String body = 'client_id=' + clientId + '&client_secret=' + secret + '&refresh_token=' + refreshtoken + '&grant_type=refresh_token';
        request.setBody(body);
        HttpResponse response = http.send(request);
        
        Map<String,object> responseMap = (Map<String,object>)JSON.deserializeUntyped(response.getBody());
        String accessToken = String.valueOf(responseMap.get('access_token'));

        System.debug('Access Token response is : ' + response.getBody());       
        if(response.getStatusCode() == 400 || response.getStatusCode() == 401){
            system.debug('refresh token expired : ');
          return_URL_accessToken.authURL = getAuthURL(key, redirectURL);
        }
        else{
            system.debug('access token found');
            return_URL_accessToken.accessToken = accessToken;
        }
        return return_URL_accessToken;
    }

    @AuraEnabled
    public static LightningIntegrationResponseWrapper.getURL_AccessToekn getAccessToken(String code)  //Get Acces token and refresh token when user first time authenticate and store their id and refresh token and access token
    {
        GoogleDriveLightningIntegration__c user_id_secret = GoogleDriveLightningIntegration__c.getOrgDefaults(); 
        String clientId = user_id_secret.ClientId__c;
        String clientSecret = user_id_secret.ClientSecret__c;
        String appRedirectURL = user_id_secret.RedirectURL__c;

        System.debug('key : ' + clientId + ' ############### : ' + clientSecret + ' ############### : \n ' + appRedirectURL);       
        System.debug('auth code : ' + code);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');        
        request.setEndpoint('https://accounts.google.com/o/oauth2/token');  
        request.setHeader('content-type', 'application/x-www-form-urlencoded');
        String messageBody = 'code='+code+'&client_id='+clientId+'&client_secret='+clientSecret+'&redirect_uri='+appRedirectURL+'&grant_type=authorization_code';        
        request.setHeader('Content-length', String.valueOf(messageBody.length()));
        request.setBody(messageBody);
        request.setTimeout(60*1000);
        HttpResponse response = http.send(request);                
        System.debug('Acces token response in Service : ' + response.getBody()); 
    String token;
        
        LightningIntegrationResponseWrapper.getURL_AccessToekn getAccessTokenUsingAuthCode = new LightningIntegrationResponseWrapper.getURL_AccessToekn();
        
        if(response.getStatusCode() == 400 || response.getStatusCode() == 401){
            List<GoogleDriveCredentials__c> driveUserRec = [select RefreshToken__c, UserId__c from GoogleDriveCredentials__c where userId__c = :UserInfo.getUserId() AND RefreshToken__c != null ];
            system.debug('no token found : ' + driveUserRec[0].RefreshToken__c);
            /*HttpResponse resp = getAccessTokenUsingRefreshToken(clientId, clientSecret, driveUserRec[0].RefreshToken__c);
            system.debug('response after getAccessTokenUsingRefreshToken : ' + resp);*/
            getAccessTokenUsingAuthCode = getAuthCode();
            system.debug('aaaaaaaaaaaaaaaaaaaaaaaaaaa : ' + getAccessTokenUsingAuthCode);
            //token = getAccessTokenUsingAuthCode.accessToken;
        }
        else{
            Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(response.getBody());
    
            System.debug('responseMap which contain refresh token and accessToken : ' + responseMap);
            System.debug('response status code : ' + response.getStatusCode());
    
            token =  String.valueOf(responseMap.get('access_token'));
            String refreshToken = String.valueOf(responseMap.get('refresh_token'));
            String userId = UserInfo.getUserId();
    
            System.debug('withour accessToken token : ' + token);
            System.debug('withour refresh_token : ' + refreshToken);
        
            getAccessTokenUsingAuthCode.accessToken = token; 
                
            List<GoogleDriveCredentials__c> driveUserRecId = [select UserId__c, RefreshToken__c, AccessToken__c, Id from GoogleDriveCredentials__c where userId__c = :UserInfo.getUserId() LIMIT 1];
             System.debug('heloo@@@@@@@@@@@@@@@@@@@@@@ : ' + driveUserRecId);
            //If refresh token expires than this method will call again and check if user account is already exists than refresh token upsert else user record insert.
            if(driveUserRecId.size() > 0){/*If user already authenticated*/
                System.debug('if : ' + driveUserRecId);
                //Getting new refresh token
                GoogleDriveCredentials__c userRecord = new GoogleDriveCredentials__c();
                userRecord.UserId__c = UserInfo.getUserId();
                userRecord.AccessToken__c = driveUserRecId[0].AccessToken__c; 
                /*if(refreshToken != null || refreshToken != ''){
                  System.debug('refreshtoken assign to object : ' + refreshToken);
                  userRecord.RefreshToken__c = refreshToken;
                }
                else{
                    System.debug('Refresh token not found');
                }*/
                userRecord.RefreshToken__c = refreshToken;
                upsert userRecord UserId__c;
            }
            else{
                // Insert user record who first tme authenticate                    
                System.debug('else : ' );
                GoogleDriveCredentials__c userRecord = new GoogleDriveCredentials__c();
                userRecord.UserId__c = userId;
                userRecord.AccessToken__c = token;
                userRecord.RefreshToken__c = refreshToken;
                insert userRecord;      
            }                
        }
        return getAccessTokenUsingAuthCode;      
    }



    
    @AuraEnabled
    public static void saveChunk(String filename, String base64Data, String filetype, String fId, String accessToken) { /*Upload file data*/
                
        Blob fileBody = Blob.valueof(base64Data);

        if(fileName != null && fileName != ''){
            String boundary = '----------9889464542212';
            String delimiter = '\r\n--' + boundary + '\r\n';
            String close_delim = '\r\n--' + boundary + '--';
            String bodyEncoded = EncodingUtil.base64Encode(fileBody);
            string body = '';            
            if(fId=='root'){
                body = delimiter+'Content-Type: application/json\r\n\r\n'+'{ "title" : "'+ filename+'",'+' "mimeType" : "'+ filetype+ '" }'+delimiter+'Content-Type: ' + filetype + '\r\n'+'Content-Transfer-Encoding: base64\r\n'+'\r\n'+bodyEncoded+close_delim;                
            }
            else{
                  body = delimiter + 'Content-Type: application/json\r\n\r\n' + '{ "title" : "'+ filename+'",'+ ' "mimeType" : "'+ filetype+ '",' + '"parents":[{"id":"'+ fId +'"}] }' + delimiter + 'Content-Type: ' + filetype + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + bodyEncoded + close_delim;                  
            }
                        
            System.debug('File fileType : ' + filetype);          
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod('POST');
            request.setEndpoint('https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart');         
            request.setHeader('Authorization','Bearer ' + accessToken);  
            request.setHeader('Content-Type', 'multipart/mixed; boundary="' + boundary + '"');
            request.setHeader('Content-length',String.valueOf(body.length()));        
            request.setBody(body);
            request.setTimeout(60*1000);           
            HttpResponse response = http.send(request);
            System.debug('File Response : ' + response.getBody());
            fileName='';
            fileType='';
            fileBody=null;
        }
    }
	
    @AuraEnabled
    public static LightningIntegrationResponseWrapper getFileNames(String accessToken, String fId) { /*Get all file and folder data*/
        System.debug('accessToken : ' + accessToken);
        if(accessToken != null){
          Http http = new Http();
          HttpRequest request = new HttpRequest();        
          request.setMethod('GET');
          request.setEndpoint('https://www.googleapis.com/drive/v3/files?'+
                              'q=%27'+fId+'%27%20in%20parents%20and%20trashed=false&orderBy=folder');       
          request.setHeader('Content-Type', 'Application/json');  
          request.setHeader('Authorization','Bearer '+ accessToken);
          request.setTimeOut(60*1000);              
          HttpResponse response = http.send(request);     
          String responseBody = response.getBody(); 
          System.debug('drive reocrd : ' + responseBody);
          lstFolder.clear();
          lstFile.clear();    
          
          LightningIntegrationResponseWrapper result = (LightningIntegrationResponseWrapper)JSON.deserialize(responseBody, LightningIntegrationResponseWrapper.class); 
          System.debug('Res ----->' + result);
          return result;
        }
        else{
          return null;
        }
    }

    @AuraEnabled
    public static void deleteFolder1(String recId, String access_Token){        /*Delete file or folder*/
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('DELETE');
        request.setEndpoint('https://www.googleapis.com/drive/v3/files/'+recId);
        request.setHeader('Authorization','Bearer ' + access_Token);
        HttpResponse response = http.send(request);       
        
    }

    @AuraEnabled
    public static String downloadFile1(String recId, String accessToken) {  /*Download file*/                      
        String webContactLink = '';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://www.googleapis.com/drive/v2/files/' + recId);
        request.setHeader('Content-Type','Application-Json');
        request.setHeader('Authorization','Bearer ' + accessToken);        
        HttpResponse response = http.send(request);        
        JSONParser parser = JSON.createParser(response.getBody());  
		
        System.debug('web view link parser : ' + parser);
        
        while(parser.nextToken()!=null){

          if(parser.getText()=='webContentLink'){
            parser.nextToken();
            webContactLink = parser.getText();          
          }
        }

        if(webContactLink=='' || webContactLink==null){          
          return null;
        }
        else
        {          
          return webContactLink;
        }
    }

    public static String getAuthURL(String clientId, String redirectURL){ /*Return authentication url*/
        System.debug('function getAuthURL : ' );
        clientId = EncodingUtil.urlEncode(clientId, 'UTF-8');
        redirectURL = EncodingUtil.urlEncode(redirectURL, 'UTF-8');

         String authurl = 'https://accounts.google.com/o/oauth2/v2/auth?'+
         'scope=https://www.googleapis.com/auth/drive'+
         '&access_type=offline'+
         '&include_granted_scopes=true'+
         '&state=state_parameter_passthrough_value'+
         '&redirect_uri=' + redirectURL +
         '&response_type=code'+
         '&client_id=' + clientId;
         System.debug('function getAuthURL : ' + authURL);
         return authurl;
    }       

}