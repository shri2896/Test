@isTest
global class GoogleDriveCommunityMock implements HttpCalloutMock {
	global HttpResponse respond(HttpRequest request){
		if(request.getEndpoint().contains('https://accounts.google.com/o/oauth2/token')){
			HttpResponse response = new HttpResponse();
			response.setHeader('Content-Type', 'application/x-www-form-urlencoded');
			response.setHeader('Authorization', 'Bearer ya29.GlyyBl38bjO_CDSZgKEjsdfxeDGpX67wzqG7jMD5FOBoL0pWcnLMgrmrDGS2r_Sjp58TI7svZQRIDI6xpnUDJiqJXWoztmWiSmDR9u_y_5ee90TQ_VIkNbj5iNAOqg');
			response.setBody('{"access_token" : "ya29.Gly0BjDvyGQTsHW0kM6JlLgRfAQZ9lfzrkU8n0TTaMs0QLyoXk9uYC_tPTOr6svVCJo0qNw81Oz3FLsmO9l4irGHGmTlup9FbIrI5w4oEGOKEgNIsSGDk-h-mGydzg","token_type":"Bearer", "expires_in": 3599, "scope": "https://www.googleapis.com/auth/drive"}');
			return response;
		}
		else if(request.getEndpoint().contains('https://www.googleapis.com/drive/v3/files')){
			HttpResponse response = new HttpResponse();
			response.setHeader('Content-Type', 'application/Json');
			response.setHeader('Authorization', 'Bearer ya29.GlyyBl38bjO_CDSZgKEjsdfxeDGpX67wzqG7jMD5FOBoL0pWcnLMgrmrDGS2r_Sjp58TI7svZQRIDI6xpnUDJiqJXWoztmWiSmDR9u_y_5ee90TQ_VIkNbj5iNAOqg');
            response.setBody('{"files" :[{"id":"root", "mimeType":"application/vnd.google-apps.folder", "name":"SUresh"}, {"id":"root","mimeType":"application/oct.stream", "name":"file"}]}');
			return response;
		}
		else if(request.getEndpoint().contains('https://www.googleapis.com/drive/v3/files')){
			HttpResponse response = new HttpResponse();
			response.setHeader('Content-Type', 'application/Json');
			response.setHeader('Authorization', 'Bearer ya29.GlyyBl38bjO_CDSZgKEjsdfxeDGpX67wzqG7jMD5FOBoL0pWcnLMgrmrDGS2r_Sjp58TI7svZQRIDI6xpnUDJiqJXWoztmWiSmDR9u_y_5ee90TQ_VIkNbj5iNAOqg');
			response.setBody('{"mimeType": "application/vnd.google-apps.folder", "name": '+ '"folderName","parents":["folderId"]}');
			return response;
		}
        else if(request.getEndpoint().contains('https://www.googleapis.com/drive/v2/files')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/Json');
            response.setHeader('Authorization','Bearer ya29.GlyyBl38bjO_CDSZgKEjsdfxeDGpX67wzqG7jMD5FOBoL0pWcnLMgrmrDGS2r_Sjp58TI7svZQRIDI6xpnUDJiqJXWoztmWiSmDR9u_y_5ee90TQ_VIkNbj5iNAOqg');
            response.setBody('{"kind":"drive#file","id":"abc","webContentLink":"https://drive.google.com/a/briskminds.com/uc?id=1T6gplnxi1C__eE-75U_lpoG7Sl5j0a0q&export=download","alternateLink": "https://drive.google.com/a/briskminds.com/file/d/1T6gplnxi1C__eE-75U_lpoG7Sl5j0a0q/view?usp=drivesdk"}');
            return response;
        }
		else{
			HttpResponse response = new HttpResponse();
			return response;			
		}
	}
}

//'{"files": [ {"id": "1ms-G6to0bxituNtU57C7wB_naQbksgRx", "name": "sHrI","mimeType": "application/vnd.google-apps.folder"},{ "id": "1RMiG9KGQcPNlFhIzWb00uI81RG9vdQOn",  "name": "BeforeInsertTrigger", "mimeType": "application/octet-stream"}]}'