public class boxController {
	private String clientId = 'ckk9t0cnk1u8x8jtzg3y6su15vkga26n';
	private String secret = 'PZUK2iuWF7WB4glxThRJwSZEGsfe1WMg';
	private String redirectURL = 'https://briskminds-developer-edition.ap4.force.com/cmunity/box';
	private String accessToken;
	private String refreshToken;
	private String folderPath='0';       
	String authCode='';
    public List<FileDetailsWrapper.FileDetails>breadcrum{get;set;}
	public List<FileDetailsWrapper.FileDetails>lstOfFolder{get;set;}
	public List<FileDetailsWrapper.FileDetails>lstOfFile{get;set;}
	public  transient String RecFileName{get;set;}
	public transient Blob fileData{get;set;}
	public String downloadURL{get;set;}

	public boxController(){
        breadcrum = new List<FileDetailsWrapper.FileDetails>();
		lstOfFile = new List<FileDetailsWrapper.FileDetails>();
		lstOfFolder = new List<FileDetailsWrapper.FileDetails>();
        FileDetailsWrapper.FileDetails tmp = new FileDetailsWrapper.FileDetails('home','0');        
        breadcrum.add(tmp);
	}

	public PageReference getAuthCode(){
		PageReference pg;		
		HttpResponse response;		
		List<Community__c> comunity = [select UserId__c from Community__c where UserId__c = :UserInfo.getUserId()];
		Community__c singleCommunityRec = new Community__c();
		FileDetailsWrapper.DropBoxAccessTokenResponse tokenresponse = new FileDetailsWrapper.DropBoxAccessTokenResponse();

		if(comunity.size()==0){
		    pg = BoxService.getAuthCode(clientId, redirectURL);
			authCode = ApexPages.currentPage().getParameters().get('code');
			System.debug('authcode : ' + authcode);
			if(authcode!=null && authcode!=''){				
				response = BoxService.getAccessToken(clientId, secret, authcode);
				System.debug('Controller response : ' + response.getBody());
				tokenresponse = (FileDetailsWrapper.DropBoxAccessTokenResponse)JSON.deserialize(response.getBody(), FileDetailsWrapper.DropBoxAccessTokenResponse.class);
				accessToken = tokenresponse.access_token;
				singleCommunityRec.boxRefreshtoken__c = tokenresponse.refresh_token;
				singleCommunityRec.UserId__c = UserInfo.getUserId();				
				response = BoxService.getData(folderPath, accessToken);
		        FileDetailsWrapper.ResponseWrapper lstOfFileFolder = (FileDetailsWrapper.ResponseWrapper)JSON.deserialize(response.getBody(), FileDetailsWrapper.ResponseWrapper.class);
		        diffrentiateFileFolder(lstOfFileFolder);
		        insert singleCommunityRec;
		        return null;
			}
			else{
				return pg;
			}

		}
		else{/*User id exists*/
			singleCommunityRec = [select boxRefreshtoken__c from Community__c where UserId__c = :UserInfo.getUserId() Limit 1];
			System.debug('Controller : singleCommunityRec : ' + singleCommunityRec);
			if(singleCommunityRec.boxRefreshtoken__c == null ||	 singleCommunityRec.boxRefreshtoken__c==''){								
				pg = BoxService.getAuthCode(clientId, redirectURL);
				authCode = ApexPages.currentPage().getParameters().get('code');
				System.debug('authcode : ' + authcode);
				if(authcode!=null && authcode!=''){				
					response = BoxService.getAccessToken(clientId, secret, authcode);
					System.debug('Controller response : ' + response.getBody());
					tokenresponse = (FileDetailsWrapper.DropBoxAccessTokenResponse)JSON.deserialize(response.getBody(), FileDetailsWrapper.DropBoxAccessTokenResponse.class);
					accessToken = tokenresponse.access_token;
					singleCommunityRec.boxRefreshtoken__c = tokenresponse.refresh_token;
					singleCommunityRec.UserId__c = UserInfo.getUserId();				
					response = BoxService.getData(folderPath, accessToken);
			        FileDetailsWrapper.ResponseWrapper lstOfFileFolder = (FileDetailsWrapper.ResponseWrapper)JSON.deserialize(response.getBody(), FileDetailsWrapper.ResponseWrapper.class);
			        diffrentiateFileFolder(lstOfFileFolder);
			        upsert singleCommunityRec UserId__c;
			        return null;
				}
				else{
					return pg;
				}
			}
			else{
				singleCommunityRec = [select boxRefreshtoken__c from Community__c where UserId__c = :UserInfo.getUserId() Limit 1];
				if(singleCommunityRec.boxRefreshtoken__c==null || singleCommunityRec.boxRefreshtoken__c==''){
					ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'RefreshToken token not found : '));
					return null;
				}
				else{
					singleCommunityRec = [select boxRefreshtoken__c from Community__c where UserId__c = :UserInfo.getUserId() Limit 1];
					refreshToken = singleCommunityRec.boxRefreshtoken__c;
					System.debug('refreshToken : ' + refreshToken);
					response = BoxService.getNewAccessToken(clientId, secret, refreshToken);
					
					tokenresponse = (FileDetailsWrapper.DropBoxAccessTokenResponse)JSON.deserialize(response.getBody(), FileDetailsWrapper.DropBoxAccessTokenResponse.class);
					accessToken = tokenresponse.access_token;
					singleCommunityRec.boxRefreshtoken__c = tokenresponse.refresh_token;
					singleCommunityRec.UserId__c = UserInfo.getUserId();	

					System.debug('Controller response : ' + response.getBody());
					System.debug('Controller : folder path : ' + folderPath + ' ####### : ' + accessToken);
					response = BoxService.getData(folderPath, accessToken);
			        FileDetailsWrapper.ResponseWrapper lstOfFileFolder = (FileDetailsWrapper.ResponseWrapper)JSON.deserialize(response.getBody(), FileDetailsWrapper.ResponseWrapper.class);
			        diffrentiateFileFolder(lstOfFileFolder);
			        upsert singleCommunityRec UserId__c;
			       		
				}
				 return null;
				 
			}		 

		}	
	}		
	
    public void showSubFolder(){
        folderPath = ApexPages.currentPage().getParameters().get('folderId');
        String folderName = ApexPages.currentPage().getParameters().get('folderName');
        HttpResponse response = BoxService.getData(folderPath, accessToken);
        FileDetailsWrapper.ResponseWrapper lstOfFileFolder = (FileDetailsWrapper.ResponseWrapper)JSON.deserialize(response.getBody(), FileDetailsWrapper.ResponseWrapper.class);
        diffrentiateFileFolder(lstOfFileFolder);
        FileDetailsWrapper.FileDetails tmp = new FileDetailsWrapper.FileDetails(folderName, folderPath);
        breadcrum.add(tmp);
    }

    public void navigationUsingBreadcrum(){
    	Integer i=0;
    	folderPath = ApexPages.currentPage().getParameters().get('folderId');
    	System.debug('Folder Path : ' + folderPath);
    	List<FileDetailsWrapper.FileDetails> tmp = new List<FileDetailsWrapper.FileDetails>();
    	tmp.addAll(breadcrum);

    	for( ; i<breadcrum.size(); i++){
    		if(folderPath==breadcrum[i].id){
    			break;
    		}
    	}
    	breadcrum.clear();

    	for(Integer j=0; j<=i; j++){
    		breadcrum.add(tmp[j]);
    	}
    	HttpResponse response = BoxService.getData(folderPath, accessToken);
    	FileDetailsWrapper.ResponseWrapper tmpFileFolder = (FileDetailsWrapper.ResponseWrapper)JSON.deserialize(response.getBody(), FileDetailsWrapper.ResponseWrapper.class);
    	diffrentiateFileFolder(tmpFileFolder);
    }

    public void deleteFileFolder(){
    	folderPath = ApexPages.currentPage().getParameters().get('folderId');
    	String fType = ApexPages.currentPage().getParameters().get('fType');
    	System.debug('fType : ' + fType);
    	HttpResponse response = BoxService.deleteFileFolder(folderPath, accessToken, fType);    	
    	System.debug('Folder Path : ' + folderPath);    
    	folderPath = breadcrum[breadcrum.size()-1].id;	
    	response = BoxService.getData(folderPath, accessToken);
    	FileDetailsWrapper.ResponseWrapper tmpFileFolder = (FileDetailsWrapper.ResponseWrapper)JSON.deserialize(response.getBody(), FileDetailsWrapper.ResponseWrapper.class);
    	diffrentiateFileFolder(tmpFileFolder);	
    }

    public void diffrentiateFileFolder(FileDetailsWrapper.ResponseWrapper fileFolder){
		lstOfFolder.clear();
        lstOfFile.clear();
		FileDetailsWrapper.ItemCollection fr = fileFolder.item_collection;

		for(FileDetailsWrapper.FileDetails fd : fr.entries){
			if(fd.type == 'folder'){
				lstOfFolder.add(fd);
			}
			else{
				lstOfFile.add(fd);
			}
		}					
	}

	public void downloadFile(){
		String fileId = ApexPages.currentPage().getParameters().get('fileId');	
		System.debug('Controller file id : ' + fileId);	
        downloadURL = BoxService.downloadFile(fileId, accessToken);
        System.debug('downloadURL : ' + downloadURL);   	   	
	}

	public void createFolder(){
		String folderName = ApexPages.currentPage().getParameters().get('folderName');
		if(folderName==null || folderName==''){
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Folder name not found...!!!'));
		}
		else{
			BoxService.createFolder(folderName, folderPath, accessToken);
			HttpResponse response = BoxService.getData(folderPath, accessToken);
			System.debug(response.getStatusCode() + ' status : ' + response.getStatus());
			if(response.getStatusCode()==409){
				ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error,'Folder already exists'));
			}
			else{
		    	FileDetailsWrapper.ResponseWrapper tmpFileFolder = (FileDetailsWrapper.ResponseWrapper)JSON.deserialize(response.getBody(), FileDetailsWrapper.ResponseWrapper.class);
		    	diffrentiateFileFolder(tmpFileFolder);	
		    }
		}
	}

	public void uploadFile(){
		if(RecFileName==null || fileData==null){
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Select at least one file for upload...!!!'));
		}
		else{
			try{
				BoxService.uploadFile(RecFileName, fileData, folderPath, accessToken);
				HttpResponse response = BoxService.getData(folderPath, accessToken);
				FileDetailsWrapper.ResponseWrapper tmpFileFolder = (FileDetailsWrapper.ResponseWrapper)JSON.deserialize(response.getBody(), FileDetailsWrapper.ResponseWrapper.class);
		    	diffrentiateFileFolder(tmpFileFolder);	
		    }
		    catch(Exception e){
		    	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'File size exceeds limit...!!!'));
		    }
	    }
	}

	public PageReference viewFile(){
		folderPath = ApexPages.currentPage().getParameters().get('fileId');
		return new PageReference('https://app.box.com/file/'+ folderPath);
	}
}