public class DropboxController {
	private String key='ci3hg81fxrox133';
	private String Secret= 'ghbfgg1wtx28z80';
	private String redirectURL = 'https://briskminds-developer-edition.ap4.force.com/cmunity/apex/DropBox';
	private String authCode;
	private String accessToken;	
	public List<FileDetailsWrapper.DropBoxFileDetail> lstOfFolder{get;set;}
	public List<FileDetailsWrapper.DropBoxFileDetail> lstOfFile{get; set;}
	/*public String path{get;set;}*/
	public List<FileDetailsWrapper.DropBoxFileDetail>breadcrum{get;set;}
	String folderId='home';
	public String RecFileName{get;set;}
	public String fileType{get;set;}
	public Blob fileData{get;set;}
	public String previewLink{get;set;}

	public DropboxController(){
		breadcrum = new List<FileDetailsWrapper.DropBoxFileDetail>();
		FileDetailsWrapper.DropBoxFileDetail initializeBreadCrum = new FileDetailsWrapper.DropBoxFileDetail();
		initializeBreadCrum.name = 'home';
		initializeBreadCrum.id = '';
		breadcrum.add(initializeBreadCrum);	
		/*path = 'Home';*/
	}
	public PageReference getAuthCode(){
		lstOfFolder = new List<FileDetailsWrapper.DropBoxFileDetail>();
		lstOfFile = new List<FileDetailsWrapper.DropBoxFileDetail>();
		HttpResponse response;	
		Community__c singleRec = new Community__c();
		List<Community__c> comunity = [select UserId__c from Community__c where UserId__c = :UserInfo.getUserId()];
		FileDetailsWrapper.DropboxTokenResponse tokenResponse = new FileDetailsWrapper.DropboxTokenResponse();

		if(comunity.size()==0){/*if user authenticate for the first time*/
			PageReference pg = DropboxService.getAuthCode(key, redirectURL);		
			authCode = ApexPages.currentPage().getParameters().get('code');
			if(authCode==null || authCode==''){
			//System.debug('authCode null' );
				return pg;
			}
			else{
				response = DropboxService.getAccessToken(authCode, redirectURL, key, Secret);
				System.debug('Controller response : ' + response.getBody());
				tokenResponse = (FileDetailsWrapper.DropboxTokenResponse)JSON.deserialize(response.getBody(), FileDetailsWrapper.DropboxTokenResponse.class);
				accessToken = tokenResponse.access_token;				
				singleRec.dropboxAccessToken__c = accessToken;
				singleRec.UserId__c = UserInfo.getUserId();
				if(accessToken!=null && accessToken!=''){
					System.debug('Token is not null : ' + accessToken);
					if(folderId=='home'){
						folderId='';
					}				
					showData();
					insert singleRec;
				}
				else{
					ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Access token not found...!!!'));
					System.debug('Controller : token not found');
				
				}
				return null;
			}
		}
		else{/*if user already authenticated from another app*/
			singleRec = [select dropboxAccessToken__c from Community__c where UserId__c = :UserInfo.getUserId() Limit 1];
			if(singleRec.dropboxAccessToken__c=='' || singleRec.dropboxAccessToken__c==null){
				PageReference pg = DropboxService.getAuthCode(key, redirectURL);		
				authCode = ApexPages.currentPage().getParameters().get('code');
				if(authCode==null || authCode==''){
				//System.debug('authCode null' );
					return pg;
				}
				else{
					response = DropboxService.getAccessToken(authCode, redirectURL, key, Secret);
					System.debug('Controller response : ' + response.getBody());
					tokenResponse = (FileDetailsWrapper.DropboxTokenResponse)JSON.deserialize(response.getBody(), FileDetailsWrapper.DropboxTokenResponse.class);
					accessToken = tokenResponse.access_token;				
					singleRec.dropboxAccessToken__c = accessToken;
					singleRec.UserId__c = UserInfo.getUserId();
					if(accessToken!=null && accessToken!=''){
						System.debug('Token is not null : ' + accessToken);
						if(folderId=='home'){
							folderId='';
						}				
						showData();
						upsert singleRec UserId__c;
					}
					else{
						ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Access token not found...!!!'));
						System.debug('Controller : token not found');					
					}
					return null;
				}		
			}
			else{/*Get access token from community object bcz it's access token never expired*/
				singleRec = [select dropboxAccessToken__c from Community__c where UserId__c = :UserInfo.getUserId() Limit 1];
				if(singleRec.dropboxAccessToken__c == null || singleRec.dropboxAccessToken__c == ''){
					ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'accessToken not found...!!!'));
				}
				else{
					accessToken = singleRec.dropboxAccessToken__c;
					showData();
				}
				return null;
			}			
		}				
	
	}

/*
System.debug('authCode not null' + authCode);
			response = DropboxService.getAccessToken(authCode, redirectURL, key, Seat);
			JSONParser parser = JSON.createParser(response.getBody());
			
			if(accessToken!=null && accessToken!=''){
				if(folderId=='home'){
					folderId='';
				}				
				showData();
			}
			//System.debug('Folder : ' + lstOfFolder + ' Size : ' + lstOfFolder.size());
			//System.debug('File : ' + lstOfFile);			
			return null;
*/
	public void deleteFolder(){
		String fId = ApexPages.currentPage().getParameters().get('fId');
		System.debug('Folder Id : ' + fId);		
		DropboxService.getFileDetails(fId ,accessToken);
		DropboxService.deleteFolder(fId, accessToken);	
		showData();				
	}

	public PageReference downloadFile(){
		String fId = ApexPages.currentPage().getParameters().get('fId');
		System.debug('fId ' + fId);
		HttpResponse response = DropboxService.downloadFile(fId, accessToken);
        System.debug('Controller : response.getBody : ' + response.getBody());
		FileDetailsWrapper.DownloadResponse fd = new FileDetailsWrapper.DownloadResponse();
		fd = (FileDetailsWrapper.DownloadResponse)JSON.deserialize(response.getBody(), FileDetailsWrapper.DownloadResponse.class);
		System.debug('downloadFile : ' + fd);		
		String link =  fd.link;
		System.debug('Link : ' + link);
		if(link!=null && link!=''){
			PageReference pg = new PageReference(link);
			return pg;
		}
		else{
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error,'File not downloadable...!!!'));
			return null;
		}
	}

	public void createFolder(){
		String folderName = ApexPages.currentPage().getParameters().get('folderName');
		
		if(folderName==null || folderName==''){
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Folder name not found...!!!'));
		}
		else{			
			if(folderName=='' || folderName==null){
				ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Folder name can not be null...!!!'));
			}
			else{
				String pathForFolderName='';
				for(Integer i=0; i<breadcrum.size(); i++){
					if(i==0){
						pathForFolderName = '';
					}
					else{
						pathForFolderName =  pathForFolderName + '/' + breadcrum[i].name ;
					}
				}

				HttpResponse response = DropboxService.createFolder(pathForFolderName,accessToken, folderName);
				//System.debug('Folder Response : ' + response.getBody());
				showData();
			}
		}
	}

	public PageReference viewFile(){
		try{				
            String fd2 = ApexPages.currentPage().getParameters().get('fileName');  
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'File Name : ' + fd2));
            String folderPath='';
            System.debug('breadcrum : ' + breadcrum);
            for(FileDetailsWrapper.DropBoxFileDetail fd : breadcrum){
                String f = fd.name;                
                f = '/' + f;
                f = f.replaceAll(' ','%20');
                folderpath = folderpath + f;
                //system.debug('dire : ' +folderpath);
            }                        
            previewLink = 'https://www.dropbox.com' + folderpath + '?preview=' + fd2.replaceAll(' ', '+');            
            /*system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@https://www.dropbox.com' + folderpath + '?preview=' + fd2.replaceAll(' ', '+'));*/   


		}
		catch(Exception e){
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Error...!!! Preview is not supported'));						
		}	
		//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Value of link : ' + previewLink));           
		return null;
	}

	public void breadcrumNavigation(){
		Integer i=0;
		folderId = ApexPages.currentPage().getParameters().get('folderId');
		System.debug('FolderName : ' + folderId);
		
		List<FileDetailsWrapper.DropBoxFileDetail> fd = new List<FileDetailsWrapper.DropBoxFileDetail>();
		fd.addAll(breadcrum);

		for( ; i<breadcrum.size(); i++){
			if(breadcrum[i].id == folderId){
				break;
			}
		}
		breadcrum.clear();
		for(Integer j=0; j<=i; j++){
			breadcrum.add(fd[j]);
			if(j==i){
				break;
			}
		}
		if(folderId=='home'){
			folderId='';
		}
		showData();
	}

	public void showSubFolder(){
		folderId = ApexPages.currentPage().getParameters().get('folderId');
		String folderName = ApexPages.currentPage().getParameters().get('folderName');
		FileDetailsWrapper.DropBoxFileDetail fd = new FileDetailsWrapper.DropBoxFileDetail();
		fd.id = folderId;
		fd.name = folderName;

		System.debug('Folder Id : ' + folderId);
		if(folderId=='home'){
			folderId = '';
		}
		breadcrum.add(fd);
		showData();
	}

	public void showData(){
		if(folderId=='home'){
			folderId='';
		}
        System.debug('Folder Id : ' + folderId);
		lstOfFolder.clear();        
		lstOfFile.clear();        
		FileDetailsWrapper fileFolderDetails = new FileDetailsWrapper();
		HttpResponse response = DropboxService.getData(accessToken,folderId);
		String allData = response.getBody().replace('.tag', 'tag');
		System.debug('Enter' + response.getBody());
		fileFolderDetails = (FileDetailsWrapper)JSON.deserialize(allData, FileDetailsWrapper.class);
		System.debug('List : ' + fileFolderDetails);
		
		for(FileDetailsWrapper.DropBoxFileDetail fd : fileFolderDetails.entries){
			if(fd.tag==('folder')){
				lstOfFolder.add(fd);				
			}
			else{
				lstOfFile.add(fd);
			}
		}
		if(folderId==''){
			folderId='home';
		}
	}

	public void uploadFile(){
		try{
			System.debug('File Name : ' + RecFileName + ' Type : ' + fileType);
			String filePath;
			if(RecFileName==null || RecFileName==''){
				ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Select at least one file for upload...!!!'));
			}
			else{
				for(Integer i=0; i<breadcrum.size(); i++){
					if(i==0){
						filePath = '';
					}
					else{
						filePath = filePath + '/' + breadcrum[i].name;
					}
				}	        
				DropboxService.uploadFile(RecFileName, fileData, filePath, accessToken);
				showData();
				RecFileName = '';
			}
		}
		catch(Exception e){
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'File size exceeds'));
		}
	}
	
}


//https://c.ap4.visual.force.com/apex/DropBox
//Key :- ci3hg81fxrox133
//Secret :- ghbfgg1wtx28z80

//'https://www.dropbox.com/1/oauth2/authorize?response_type=code&client_id=nw7mfi19tfaxak8&redirect_uri=https://c.ap2.visual.force.com/apex/Dropbox&state=Mytesting'


 /*
 
 https://www.dropbox.com/home?preview=VisualForce.docx 
 https://www.dropbox.com/home/Shri/folder%201?preview=Anant+sir+google+drive.txt 
https://www.dropbox.com/home/Shri/folder%201/A%202?preview=Anant+sir+google+drive.txt
https://www.dropbox.com/home/Shri/folder%201/folder%202/folder%203?preview=Anant+sir+google+drive.txt
https://www.dropbox.com/home/Rajat/Ram/Lakhan?preview=VisualForce.docx

 */