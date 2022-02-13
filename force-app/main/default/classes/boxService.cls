public class boxService {
	public static PageReference getAuthCode(String clientId, String redirectURL){
		PageReference pg = new PageReference('https://account.box.com/api/oauth2/authorize?response_type=code&client_id=' + clientId + '&redirect_uri='+ redirectURL + '&state=root_readwrite');
		return pg;		
	}

	public static HttpResponse getAccessToken(String clientId, String clientSecret, String authCode){
		System.debug('clientId : ' + clientId + ' secret @@@@@@@@@ : ' + clientSecret + ' authCode : ' + authCode);
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setMethod('POST');
		request.setEndpoint('https://api.box.com/oauth2/token');		
		request.setBody(
			'&grant_type=authorization_code' +
			'&code=' + authCode +
			'&client_id=' + clientId +
			'&client_secret=' + clientSecret );

		HttpResponse response = http.send(request);
		System.debug('response : ' + response.getBody());
		return response;
	}

	 public static HttpResponse getNewAccessToken(String clientId, String secret, String refreshtoken){
	 	System.debug('new accessToken : Service : ' + clientId + ' ######## ' + secret + ' @@@@@ : ' + refreshtoken);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.box.com/oauth2/token');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String body = 'client_id=' + clientId + '&client_secret=' + secret + '&refresh_token=' + refreshtoken + '&grant_type=refresh_token';
        request.setBody(body);
        HttpResponse response = http.send(request);
        System.debug('Access Token response is : ' + response.getBody());
        return response;
    }

	public static HttpResponse getData(String fId, String accessToken){
		System.debug('Service Fid : ' + fId + ' accessToken : ' + accessToken);
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setMethod('GET');
		request.setEndpoint('https://api.box.com/2.0/folders/'+fId);
		request.setHeader('Authorization', 'Bearer ' + accessToken);
		HttpResponse response = http.send(request);
		System.debug('Service cls Data : ' + response.getBody());
		return response;
	}

	public static HttpResponse deleteFileFolder(String fId, String accessToken, String type){
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setMethod('DELETE');
		if(type=='folder'){
			System.debug('Folder');
			request.setEndpoint('https://api.box.com/2.0/folders/'+ fId);
		}
		else{
			System.debug('File');
			request.setEndpoint('https://api.box.com/2.0/files/'+ fId);	
		}
		request.setHeader('Authorization', 'Bearer ' + accessToken);
		HttpResponse response = http.send(request);
		System.debug('Del response : ' + response.getBody());
		return response;		
	}

	public static String downloadFile(String fileId, String accessToken){
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setMethod('GET');
		request.setEndpoint('https://api.box.com/2.0/files/' + fileId + '/content');
		request.setHeader('Content-Type','application/json');
		request.setHeader('Authorization', 'Bearer ' + accessToken);
		HttpResponse response = http.send(request);
		System.debug('Download response : ' + response.getBody());	
		return response.getHeader('Location');
	}

	public static HttpResponse createFolder(String folderName, String parent, String accessToken){
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setMethod('POST');
		request.setEndpoint('https://api.box.com/2.0/folders');
		request.setHeader('Authorization', 'Bearer ' + accessToken);
		String body = '{' + 
						'"name":"' + folderName +
						'", "parent": {"id": "' + 
						parent +
						'"}}';
		request.setBody(body);
		HttpResponse response = http.send(request);
		System.debug('response : ' + response.getBody());
		return response;
	}	

	public static HttpResponse uploadFile(String fileName, Blob fileData, String parent, String accessToken){
		try{
			 String boundary = '----------------------------741e90d31eff';
			 String header = '--'+boundary+'\nContent-Disposition: form-data; name="file"; filename="'+fileName+'";\nContent-Type: multipart/form-data;'+'\nnon-svg='+True;
			 String footer = '--'+boundary+'--';  
		  	 String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
		  	 while(headerEncoded.endsWith('=')) {
	          	header+=' ';   
	            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
	          }

	      	 String bodyEncoded = EncodingUtil.base64Encode(fileData);
	         Blob bodyBlob = null;
	         String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());

		    if(last4Bytes.endsWith('==')) {
		      	last4Bytes = last4Bytes.substring(0,2) + '0K';
		        bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
		        String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
		        bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);    
		    }

		    else if(last4Bytes.endsWith('=')) {
		    	last4Bytes = last4Bytes.substring(0,3) + 'N';
		        bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
		        footer = '\n' + footer;
		        String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
		        bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);               
		    }

		    else{ 
		        footer = '\r\n' + footer;
		        String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
		        bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);  
	    	}
	                       
			Http http = new Http();
			HttpRequest request = new HttpRequest();
			request.setMethod('POST');
			request.setHeader('Authorization', 'Bearer ' + accessToken);
			request.setEndpoint('https://upload.box.com/api/2.0/files/content?parent_id='+parent);
			request.setHeader('Content-Type','multipart/form-data;non_svg='+True+';boundary='+boundary);
			String body = '{' + 
							'"name":"' + fileName + '", "parent":{"id":"' + parent + '"}}';
			request.setBody(body);
			request.setBodyAsBlob(bodyBlob);
			request.setHeader('Content-Length',String.valueof(request.getBodyAsBlob().size()));
			request.setTimeout(60*1000);
			HttpResponse response = http.send(request);
			System.debug('upload response : ' + response.getBody());
			return response;
		}
		catch(Exception e){
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'File size exceeds limit...!!!'));
			return null;
		}
	}
}




/*
public static String downloadFile(String access_Token, String fileId){
        request = new HttpRequest();
        request.setEndpoint('https://api.box.com/2.0/files/'+fileId+'/content');
        request.setMethod('GET');        
        request.setHeader('Content-Type','application/json');
        request.setHeader('Authorization' , 'Bearer'+' '+ access_Token);
        httpObj = new Http();
        response = httpObj.send(request);
        return response.getHeader('Location');
    }


Main class

public void downloadFile(){
       dwnldURL = Box_Integration_Service.downloadFile(access_Token,folderId);
   }

Page

function dwnldfile(dwnldurl){ console.log(dwnldurl); location.href = dwnldurl; }


Page p dwnld k link se action call krana main class wala or oncomplete p ye js ka method lga dena


*/