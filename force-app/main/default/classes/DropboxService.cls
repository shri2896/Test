public class DropboxService {	
	public static PageReference getAuthCode(String clientid, String redirecturi){				
	  	PageReference pg = new PageReference('https://www.dropbox.com/1/oauth2/authorize?response_type=code&client_id='+clientid+'&redirect_uri='+redirecturi) ; 
	  	return pg;
	}

	public static HttpResponse getAccessToken(String authCode, String redirecturi, String clientid, String secret){
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setMethod('POST');
		request.setEndpoint('https://api.dropboxapi.com/oauth2/token?code='+authCode+
							'&grant_type=authorization_code' + 
							'&client_id=' + clientid +
							'&client_secret=' + secret + 
							'&redirect_uri=' + redirecturi); 
	  	request.setHeader('Content-Type', 'application/x-www-form-urlencoded');	  
		HttpResponse response = http.send(request);
		System.debug('Response : ' + response.getBody()); 
		return response;
	}

	public static HttpResponse getData(String accessToken, String path){
		//System.debug('accessToken : ' + accessToken);
		String body = '{\"path\":"' + path +'\"}';
		//System.debug('Body : ' + body);
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setMethod('POST');
		request.setEndpoint('https://api.dropbox.com/2/files/list_folder');
		request.setHeader('Authorization', 'Bearer ' + accessToken);
		request.setHeader('Content-Type','Application/json');
		request.setBody(body);
		HttpResponse response = http.send(request);
		//System.debug('Data : ' + response.getBody());
		return response;
		/*String allData = response.getBody().replace('.tag', 'tag');
		return allData;*/
	}

	public static void deleteFolder(String fId, String accessToken){
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setMethod('POST');
		request.setEndpoint('https://api.dropboxapi.com/2/files/delete_v2');
		request.setHeader('Content-Type', 'application/json');
		request.setHeader('Authorization', 'Bearer ' + accessToken);
		String body = '{\"path\":"'+ fId + '\"}';
		request.setBody(body);
		System.debug('Del Body ' + body);
		HttpResponse response = http.send(request);
		System.debug('Del Response : ' + response.getBody());
	}

	public static HttpResponse downloadFile(String fName, String accessToken){
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setMethod('POST');
		request.setEndpoint('https://api.dropboxapi.com/2/files/get_temporary_link');
		request.setHeader('Authorization', 'Bearer ' + accessToken);				
		request.setHeader('Content-Type', 'application/json');
		String body = '{\"path\":"'+ fName +'"}';
		request.setBody(body);
		HttpResponse response = http.send(request);
		System.debug('download File Body : ' + response.getBody());
		return response;
	}

	public static HttpResponse createFolder(String folderPath, String accessToken, String folderName){
		//System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@FolderName : ' + folderName);
		//System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@folderPath : ' + folderPath);		
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setMethod('POST');
		request.setEndpoint('https://api.dropboxapi.com/2/files/create_folder');
		request.setHeader('Authorization', 'Bearer ' + accessToken);
		request.setHeader('Content-Type', 'application/json');
		String body = '{\"path\": \"' + folderPath + '/' + folderName + '\",\"autorename\":false}';
		System.debug('#############################$$$$$$$$$$$$$$$$$$$$$$$$$$$ : ' +  body);
		request.setBody(body);
		HttpResponse response = http.send(request);
		System.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&7createFolder : ' + response.getBody());
		return response;
	}
//{"path": "/mk","autorename":true}
//{"path": "id:IDED2p_kxfAAAAAAAAAAFA/xk","autorename":true}
	public static void getFileDetails(String filePath, String accessToken){
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setMethod('POST');
		request.setEndpoint('https://api.dropboxapi.com/2/files/get_metadata');
		request.setHeader('Content-Type', 'application/json');
		request.setHeader('Authorization', 'Bearer ' + accessToken);
		String body = '{\"path\": "'+ filePath +'",' + 
		  '"include_media_info": true,'+
		  '"include_deleted": false,'+
		  '"include_has_explicit_shared_members": false'+
		'}';
		request.setBody(body);
		HttpResponse response = http.send(request);
		System.debug('File detail : ' + response.getBody());
	}

	public static void uploadFile(String fileName, Blob fileData, String path, String accessToken){
		try{
			Http http = new Http();
			HttpRequest request = new HttpRequest();
			request.setMethod('POST');
			request.setEndpoint('https://content.dropboxapi.com/2/files/upload');
			request.setHeader('Content-Type', 'application/octet-stream');
			request.setHeader('Authorization', 'Bearer ' + accessToken);
			request.setHeader('Dropbox-API-Arg', '{'+		
							    '\"path\": "' + path + '/' + fileName +'"' + 
							   	 '}');
			String body = '{' + '\"path\": "' + path + '/' + fileName + '"' + '}';
			System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ upload response : ' + body);
			request.setBodyAsBlob(fileData);
			HttpResponse response = http.send(request);
			System.debug('Service Upload Response : ' + response.getBody());
		}
		catch(Exception e){
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'File size exceeds limit...!!!'));
		}
	}
}
/*
	path": "/Homework/math/Matrices.txt",

/*
'{' + 
	'\"path\": "/id:IDED2p_kxfAAAAAAAAAADA"' +
'}';
*/