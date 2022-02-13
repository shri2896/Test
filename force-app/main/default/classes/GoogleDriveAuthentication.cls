public with sharing class GoogleDriveAuthentication {
	private String key = '424589915414-ggfvn5ecet5nppdh1tpg4dssk4cuk2nq.apps.googleusercontent.com';
	private String secret = 'x7Tm9m17DQJ6TxEMno_QJd8N';
	private String redirect_uri = 'https://c.ap4.visual.force.com/apex/pGoogleDriveAuthentication';
	private String token ;
	private String access_Token;
	public String FolderName{get;set;}
	private List<String> FileList; 		
	Map<String, String> mapOfId = new Map<String, String>();

    public string username{get;set;}

    //Public FileDetails fDetails{get;set;}
	String s;	
	Public List<fileDetails1> lstFolder{get;set;}
	Public List<fileDetails1> lstFile{get;set;}
	String fId='root';
	Public List<fileDetails1> folderDirectory{get;set;}
	Public Blob fileData{get;set;}	
	Public transient String fileName{get;set;}
	Public transient String fileSize{get;set;}
	Public transient String filetype{get;set;}
  Public String refreshToken='';

	public GoogleDriveAuthentication() {
		folderDirectory = new List<fileDetails1>();
		fileDetails1 fd = new fileDetails1();
		fd.Id = '0';
		fd.name='Root';
		folderDirectory.add(fd);
		lstFile = new List<fileDetails1>();
		lstFolder = new List<fileDetails1>();
		//fDetails = new FileDetails();
	   //System.debug('ApexPages'+ApexPages.currentPage());	
		token=ApexPages.currentPage().getParameters().get('code');	
		//System.debug('outer Token call');	
		System.debug('Token : ' + token);		
		if(token!='' && token!=null){
			//System.debug('inner Token call');			
			accessToken();			
		}		

	}
    
    public void showData(){
        system.debug('mehtod call success fully : ' + username);
        string param = Apexpages.currentPage().getParameters().get('myParam');
        system.debug('param is : ' + param);
        
        VFComponentController.callFromChild(username);
        
    }
    
    public PageReference DriveAuth(){
    	PageReference pg = new PageReference(new AuthUri(key, redirect_uri).AuthenticationUri);  
       /* System.debug('Token : ' + pg);*/		    	
    	return pg;    	
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
    public void getFileNames() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();	      
        request.setMethod('GET');
        request.setEndpoint('https://www.googleapis.com/drive/v3/files?'+
                            'q=%27'+fId+'%27%20in%20parents%20and%20trashed=false&orderBy=folder'); 	    
        request.setHeader('Content-Type', 'Application/json');	
        request.setHeader('Authorization','Bearer '+access_Token);
        request.setTimeOut(60*1000);  	    	    
        HttpResponse response = http.send(request);			
        s = response.getBody();	
        //System.debug('s : ' + s);
        lstFolder.clear();
        lstFile.clear();		
        
        responseWrapper result = (responseWrapper)JSON.deserialize(s, responseWrapper.class);
        //System.debug('Result : ' + result);
        for(fileDetails1 fDetails : result.files){
            if(fDetails.mimeType=='application/vnd.google-apps.folder'){
                lstFolder.add(fDetails);
                mapOfId.put(fDetails.Id,fDetails.name);
            }
            else{
                lstFile.add(fDetails);
                mapOfId.put(fDetails.Id,fDetails.name);
            }
        }        
    }

    public class responseWrapper {
      public List<fileDetails1> files;           		
    }    
    public class fileDetails1 {
        public String id{get;set;}
        public String name{get;set;}
        public String mimeType{get;set;}
    }     	

    public void createFolder(){
       Http http = new Http();
       HttpRequest request = new HttpRequest();
       request.setMethod('POST');
      // /*request.setEndpoint('https://www.googleapis.com/drive/v3/files/');
       //System.debug('Folder id is : ' + fId);
       request.setEndpoint('https://www.googleapis.com/drive/v3/files'); 	          
       request.setHeader('Content-Type','Application/Json');          
       request.setHeader('Authorization','Bearer '+access_Token);       
       	/*String messageBody = '{"mimeType": "application/vnd.google-apps.folder", "name": '+ '"' + FolderName+'"' + '}';*/
       	String messageBody = '';
       	if(fid == 'root') {
       		messageBody = '{"mimeType": "application/vnd.google-apps.folder", "name": '+ '"' + FolderName+'"' +'}';
       	}
       	else {
       		messageBody = '{"mimeType": "application/vnd.google-apps.folder", "name": '+ '"' + FolderName+'","parents":["'+fid+'"]}';
       	}
       System.debug(messageBody);
       request.setBody(messageBody);  
       request.setTimeout(60*1000);
       HttpResponse response = http.send(request);
       System.debug('Response of createFolder : ' + response.getBody());   
       accessToken();	
       //System.debug('Folder Name : ' + FolderName);	
       FolderName='';       
    }

	Public void deleteFolder(){
		/*for(String key : mapOfId.keySet()){
			System.debug(mapOfId.get(key));
		}*/	
		
		//System.debug('Param : ' + param);
		/*if(mapOfId.containsKey(param)){
			System.debug('Key contains');
		}
		else{
			System.debug('Key not contains');
		}*/		
		//String folderId = mapOfId.get(param);
		//System.debug('Folder Id : ' + folderId + ' Length : ' + folderId.length());
		String param = ApexPages.currentPage().getParameters().get('RecId');

		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setMethod('DELETE');
		request.setEndpoint('https://www.googleapis.com/drive/v3/files/'+param);
		request.setHeader('Authorization','Bearer ' + access_Token);
		HttpResponse response = http.send(request);
		System.debug('Response is : ' + response.getBody());
		accessToken();				
	}
    
    public PageReference DownloadFile(){
    	String fieldId=ApexPages.currentPage().getParameters().get('dFile');
    	/*if(mapOfId.containsKey(fieldId)){
    		fieldId = mapOfId.get(fieldId);
    	}*/
    	//System.debug('Field id : ' + fieldId);
    	String webContactLink = '';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://www.googleapis.com/drive/v2/files/' + fieldId);
        request.setHeader('Content-Type','Application-Json');
        request.setHeader('Authorization','Bearer ' + access_Token);        
        HttpResponse response = http.send(request);
        //System.debug('File Response : ' + response.getBody());
        JSONParser parser = JSON.createParser(response.getBody());	

        //System.debug('Before token ' + response.getBody());
        while(parser.nextToken()!=null){
        	//System.debug('getText ' + parser.getCurrentToken() + '  &&&&&& ' + JSONToken.FIELD_NAME + ' @@@@ ' + parser.getText());
        	if(parser.getText()=='webContentLink'){
        		parser.nextToken();
        		webContactLink = parser.getText();
        		//System.debug('webContentLink : ' + parser.getText());
        	}
        }
        if(webContactLink=='' || webContactLink==null){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'File is not downloadable...!!!'));
        	return null;
        }
        else
        {
        	PageReference pg = new PageReference(webContactLink);
        	return pg;
        }
        
    }

   	Public String openFIle(){
   		String str = '';
   		String fileId =  ApexPages.currentPage().getParameters().get('flename');
   		str = 'https://drive.google.com/open?id=' + fileId;
   		//System.debug(' @@@ ' + fileId);
   		/*if(mapOfId.containsKey(fileId)){   			
   			str = 'https://drive.google.com/open?id=' + mapOfId.get(fileId);
   		}
   		else{
   			System.debug('Key not contains');
   		}*/
   		//System.debug('Open file Link : ' + str); 	
   		return str;
    }

    Public void showChildFolder(){
      	String lst;
      	fId = ApexPages.currentPage().getParameters().get('folderId');
          System.debug('Folder id : ' + ApexPages.currentPage().getParameters());
      	if(fId=='0'){
      		fId = 'root';
      		lst='root';
      	}
      	else{
      		lst = fId;
      	}
      	
      	responseWrapper result = (responseWrapper)JSON.deserialize(s, responseWrapper.class); 
          System.debug('JSON in showFolder : ' + result);
  		for(fileDetails1 fDetails : result.files){
  			if(fDetails.id==lst){
  				folderDirectory.add(fDetails);
  				break;
  			}
  		}		    	    	
      	accessToken();
    }

    public void navigationOfFolder(){
    	Integer i=0;
    	//System.debug('ApexPages.currentPage().getHeaders().get("Host")' + ApexPages.currentPage().getHeaders().get('Host'));
		fId = ApexPages.currentPage().getParameters().get('directoryFolderName');   		 	    			
		System.debug('Navigation : ' + fId);		
		List<fileDetails1> tmp = new List<fileDetails1>();
		tmp.addAll(folderDirectory);
		System.debug('tmp size : ' + tmp.size() + ' Lst : ' + folderDirectory.size());
		for(; i<folderDirectory.size(); i++)
		{				
			System.debug(folderDirectory.get(i));
			if(folderDirectory[i].id==fId){
				//System.debug(folderDirectory[j]);				
				break;
			}
		}	
		folderDirectory.clear();	
		System.debug('tmp value : ' + tmp + ' \n : ' + ' Value of i : ' + i);	
		for(Integer j=0; j<=i; j++){				
			System.debug(tmp[j]);
			folderDirectory.add(tmp.get(j));

      if(j>=tmp.size()){
        break;
      }
			
		}				
		
		if(fId=='0'){
			fId = 'root';						
		}
		accessToken();    			    	    	
    }

    Public void uploadFile(){    	
    	if((fileName==null || fileName=='')){
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Select at least one file...!!!'));
    	}
    	else{ 
	    	if(fileName!= null && fileName!=''){
	    		if(token==null || token==''){
	    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid user...!!!'));			
	    		}
	    		else{
	    			if(Integer.valueOf(fileSize)<500000){	    		
	    				System.debug('Enter in if : ' + fileSize);
				    	String boundary = '----------9889464542212';
  						String delimiter = '\r\n--' + boundary + '\r\n';
  						String close_delim = '\r\n--' + boundary + '--';
  						String bodyEncoded = EncodingUtil.base64Encode(fileData);
                        string body = '';
                        System.debug('if' + fId);
                        if(fId=='root'){
                            body = delimiter+'Content-Type: application/json\r\n\r\n'+'{ "title" : "'+ filename+'",'+' "mimeType" : "'+ filetype+ '" }'+delimiter+'Content-Type: ' + filetype + '\r\n'+'Content-Transfer-Encoding: base64\r\n'+'\r\n'+bodyEncoded+close_delim;
                            System.debug('if');
                        }
                        else{
                              body = delimiter + 'Content-Type: application/json\r\n\r\n' + '{ "title" : "'+ filename+'",'+ ' "mimeType" : "'+ filetype+ '",' + '"parents":[{"id":"'+ fId +'"}] }' + delimiter + 'Content-Type: ' + filetype + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + bodyEncoded + close_delim;
							System.debug('else');							                            
                        }
				    	System.debug('File Size : ' + fileSize);
				    	System.debug('File fileName : ' + fileName);    	
				    	System.debug('File fileType : ' + filetype	);     	  	
				    	Http http = new Http();
				    	HttpRequest request = new HttpRequest();
				    	request.setMethod('POST');
                        request.setEndpoint('https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart');    			
				        request.setHeader('Authorization','Bearer ' + access_Token);  
				        request.setHeader('Content-Type', 'multipart/mixed; boundary="' + boundary + '"');
                            request.setHeader('Content-length',String.valueOf(body.length()));        
				        request.setBody(body);
				        request.setTimeout(60*1000);	         
				        HttpResponse response = http.send(request);
				        System.debug('File Response : ' + response.getBody());
				        fileName='';
				        fileType='';
				        fileData=null;
				    }
				    else{
				    	System.debug('Enter in else : ');
				    	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'File size exceed...!!!'));			
				    }
		    	}		    
			} 
		}
	}   
}

//1sASN5qpdlf3lPQg3kpjxBxT8V3wmn7mr
//1sASN5qpdlf3lPQg3kpjxBxT8V3wmn7mr




















// Access_token = ya29.GlyoBqBmxmKG6R5QStc6vZxnwxWtoCmJL72VzZ6x2QlmKRQW9pjyiqcl_XDls12WoqhGflnc25t258giHui4L5HDWxFoCT5PITNa1PzaLu3HFfyJDNH8Abn8z71PzQ
//				  ya29.GlyoBhbzfPFnyx92FS9hYvJHZSyOpA5LSexr0rABLdXmrWn0jDJVOmyGtTwCeKo0D154SOJUUK27_rne_Ge6WhYZy_CYgBodBJ8B93prezGX5BDToVOBq_ikebwiR