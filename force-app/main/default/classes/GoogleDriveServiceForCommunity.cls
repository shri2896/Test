public class GoogleDriveServiceForCommunity {
    //private String folderId='root'; 
    public GoogleDriveServiceForCommunity(){      
    }

  public PageReference getAuthURL(String clientId, String redirectURL){
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
         return new PageReference(authurl);                        
    }     
    public HttpResponse getAccessToken(String code, String clientId, String clientsecret, String redirecturl){        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('https://accounts.google.com/o/oauth2/token');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');     
        
        String body = 'code=' + code +
        '&client_id=' + clientId +
        '&client_secret=' + clientsecret + 
        '&redirect_uri=' + redirecturl + 
        '&grant_type=authorization_code';
        
        request.setBody(body);
        request.setHeader('Content-length',String.valueOf(body.length()));
        HttpResponse response = http.send(request);    
        System.debug('Acces token response in Service : ' + response.getBody());   
        return response;
    //Function          
    }

    //Get all the data from google drive
    public FileDetailsWrapper getData(String folderId, String accessToken){
        FileDetailsWrapper lstOfFileFolder;
        try{     
            System.debug('Folder Id : ' + folderId + ' @@@@@@ ' + accessToken);       
            Http http = new Http();
            HttpRequest request = new HttpRequest();        
            request.setMethod('GET');
            request.setEndpoint('https://www.googleapis.com/drive/v3/files?'+
                                'q=%27'+folderId+'%27%20in%20parents%20and%20trashed=false&orderBy=folder');       
            request.setHeader('Content-Type', 'Application/json');  
            request.setHeader('Authorization','Bearer '+accessToken);
            request.setTimeOut(60*1000);              
            HttpResponse response = http.send(request);   
            System.debug('Respose body : ' + response.getBody() + ' @@@@@@@@ ' + response);
            System.debug('GetData Call : ' + folderId + ' token : ' + accessToken);
            lstOfFileFolder = (FileDetailsWrapper)JSON.deserialize(response.getBody(), FileDetailsWrapper.Class);            
            System.debug('Service Class : ' + lstOfFileFolder.files);
                                 
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Bad Request..!!'));
        }
        return lstOfFileFolder;
    }
    // Get access token using refresh token
    public HttpResponse getNewAccessToken(String clientId, String secret, String refreshtoken){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.googleapis.com/oauth2/v4/token');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String body = 'client_id=' + clientId + '&client_secret=' + secret + '&refresh_token=' + refreshtoken + '&grant_type=refresh_token';
        request.setBody(body);
        HttpResponse response = http.send(request);
        System.debug('Access Token response is : ' + response.getBody());
        return response;
    }

    public void createFolder(String folderName, String folderId, String accessToken){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('https://www.googleapis.com/drive/v3/files');
        request.setHeader('Content-Type','Application/json');
        request.setHeader('Authorization','Bearer ' + accessToken);
        String messageBody='';
        if(folderId!= 'root'){
            messageBody = '{"mimeType": "application/vnd.google-apps.folder", "name": '+ '"' + folderName + '","parents":["' + folderId + '"]}';
            System.debug('messageBody : ' + messageBody);
        }
        else{
            messageBody = '{"mimeType":"application/vnd.google-apps.folder", "name": "'+folderName +'"}';
            System.debug('messageBody : ' + messageBody);
        }
        /*String messageBody = '';
        if(folderId == 'root') { 
            messageBody = '{"mimeType": "application/vnd.google-apps.folder", "name": '+ '"' + folderName+'"' +'}';
        }
        else {
            messageBody = '{"mimeType": "application/vnd.google-apps.folder", "name": '+ '"' + folderName+'","parents":["'+folderId+'"]}';
        }*/
        request.setBody(messageBody);
        HttpResponse response = http.send(request);
        System.debug('Create Folder response : ' + response.getBody());
    }

    public void deleteFolder(String folderId, String accessToken){
        System.debug('Folder Id : ' + folderId);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('DELETE');
        request.setEndpoint('https://www.googleapis.com/drive/v3/files/'+folderId);
        request.setHeader('Content-Type','application/json');
        request.setHeader('Authorization','Bearer ' + accessToken);
        request.setTimeout(60*1000);
        HttpResponse response = http.send(request);
        System.debug('Delete response : ' + response.getBody());
    }

    public String downloadFile(String fileId, String accessToken){
       String downloadLink='';
       System.debug('accessToken : ' + accessToken);
       HttpResponse response = getFileResponse(fileId, accessToken);       
		   System.debug('download File response : ' + response.getBody());
       JSONParser parser = JSON.createParser(response.getBody());
       while(parser.nextToken()!=null){
            if(parser.getText()=='webContentLink'){
                parser.nextToken();
                downloadLink = parser.getText();
                break;
            }
       }
       System.debug('downloadLink : ' + downloadLink);
       if(downloadLink==null || downloadLink==''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'File is not downloadable...!!!'));
            return null;
       }
       else{            
            return downloadLink;
       }
    }

    public String viewFile(String fileId, String accessToken){
        String webViewLink='';
        HttpResponse response = getFileResponse(fileId, accessToken);
        JSONParser parser = JSON.createParser(response.getBody());

        while(parser.nextToken()!=null){
            if(parser.getText()=='alternateLink'){
                parser.nextToken();
                webViewLink = parser.getText();
                break;
            }
        }

        System.debug('webViewLink : ' + webViewLink);
        if(webViewLink==null || webViewLink==''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR...!!!'));
            return null;
        }
        else{
            return webViewLink;
        }
    }
    /*Use for get webcontentlink & webViewLink*/
    public HttpResponse getFileResponse(String fileId, String accesstoken){
       Http http = new Http();
       HttpRequest request = new HttpRequest();
       request.setMethod('GET');
       request.setEndpoint('https://www.googleapis.com/drive/v2/files/'+fileId);
       request.setHeader('Content-Type','Application/json');
       request.setHeader('Authorization', 'Bearer ' + accessToken);
       request.setTimeout(60*1000);
       HttpResponse response = http.send(request); 
       System.debug('getFileResponse : ' + response.getBody());
       return response;
    }

    public void uploadFile(String fileName, String fileType, Blob fd, String fId, String accessToken){
      try{
          System.debug('FileName : ' + fileName + ' Content-Type : ' + filetype + ' fd : ' + ' Folder Id : ' + fId);
          String boundary = '----------9889464542212';
          String delimiter = '\r\n--' + boundary + '\r\n';
          String close_delim = '\r\n--' + boundary + '--';
          String bodyEncoded = EncodingUtil.base64Encode(fd);
          string body = '';
          System.debug('if' + fId);
          if(fId=='root'){
              body = delimiter+'Content-Type: application/json\r\n\r\n'+'{ "title" : "'+ filename+'",'+' "mimeType" : "'+ fileType+ '" }'+delimiter+'Content-Type: ' + filetype + '\r\n'+'Content-Transfer-Encoding: base64\r\n'+'\r\n'+bodyEncoded+close_delim;
              System.debug('if');
          }
          else{
             body = delimiter + 'Content-Type: application/json\r\n\r\n' + '{ "title" : "'+ filename+'",'+ ' "mimeType" : "'+ fileType+ '",' + '"parents":[{"id":"'+ fId +'"}] }' + delimiter + 'Content-Type: ' + filetype + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + bodyEncoded + close_delim;
             System.debug('else');                                          
          }
          Http http = new Http();
          HttpRequest request = new HttpRequest();
          request.setMethod('POST');
          request.setEndpoint('https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart');
          request.setHeader('Authorization','Bearer ' + accesstoken);
          request.setHeader('Content-Type', 'multipart/mixed; boundary="' + boundary + '"');
          request.setHeader('Content-length',String.valueOf(body.length()));        
          request.setBody(body);
          request.setTimeout(60*1000);           
          HttpResponse response = http.send(request);
          System.debug('File Response : ' + response.getBody());
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'File size exceeds limit...!!!'));
        }
    }
}