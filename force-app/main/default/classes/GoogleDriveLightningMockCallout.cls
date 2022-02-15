@isTest
public class GoogleDriveLightningMockCallout implements HttpCalloutMock {

    protected Integer code;
    protected String status;
    protected String body;
    protected Map<String, String> responseHeaders;
	
    public GoogleDriveLightningMockCallout() {
    }
    public GoogleDriveLightningMockCallout(Integer code, String status, String body, Map<String, String> responseHeaders) {
        this.code = code;
        this.status = status;
        this.body = body;
        this.responseHeaders = responseHeaders;
    }
    
    public HTTPResponse respond(HTTPRequest request) { 
        	
        if(request.getEndpoint().contains('https://www.googleapis.com/oauth2/v4/token')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'Application/Json'); 
            response.setHeader('Authorization','Bearer ya29.GlyyBl38bjO_CDSZgKEjsdfxeDGpX67wzqG7jMD5FOBoL0pWcnLMgrmrDGS2r_Sjp58TI7svZQRIDI6xpnUDJiqJXWoztmWiSmDR9u_y_5ee90TQ_VIkNbj5iNAOqg');      
            response.setBody('{"access_Token":"ya29.Gly0BjDvyGQTsHW0kM6JlLgRfAQZ9lfzrkU8n0TTaMs0QLyoXk9uYC_tPTOr6svVCJo0qNw81Oz3FLsmO9l4irGHGmTlup9FbIrI5w4oEGOKEgNIsSGDk-h-mGydzg","token_type":"Bearer", "expires_in": 3599, "scope": "https://www.googleapis.com/auth/drive"}');    
            response.setStatusCode(200);
            response.setStatus('Pass');
             return response;
         }
        else if(request.getEndpoint().contains('https://accounts.google.com/o/oauth2/token')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'Application/json');
            response.setHeader('Authorization','Bearer ya29.GlyyBl38bjO_CDSZgKEjsdfxeDGpX67wzqG7jMD5FOBoL0pWcnLMgrmrDGS2r_Sjp58TI7svZQRIDI6xpnUDJiqJXWoztmWiSmDR9u_y_5ee90TQ_VIkNbj5iNAOqg');
            response.setBody('{"files": [ {"id": "1ms-G6to0bxituNtU57C7wB_naQbksgRx", "name": "sHrI","mimeType": "application/vnd.google-apps.folder"},{ "id": "1RMiG9KGQcPNlFhIzWb00uI81RG9vdQOn",  "name": "BeforeInsertTrigger", "mimeType": "application/octet-stream"}]}');
            return response;
        }
        else if(request.getEndpoint().contains('https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'Application/json');
            response.setHeader('Authorization','Bearer ya29.GlyyBl38bjO_CDSZgKEjsdfxeDGpX67wzqG7jMD5FOBoL0pWcnLMgrmrDGS2r_Sjp58TI7svZQRIDI6xpnUDJiqJXWoztmWiSmDR9u_y_5ee90TQ_VIkNbj5iNAOqg');
            response.setBody('{"files": [ {"id": "1ms-G6to0bxituNtU57C7wB_naQbksgRx", "name": "sHrI","mimeType": "application/vnd.google-apps.folder"},{ "id": "1RMiG9KGQcPNlFhIzWb00uI81RG9vdQOn",  "name": "BeforeInsertTrigger", "mimeType": "application/octet-stream"}]}');
            return response;
        }
        else if(request.getEndpoint().contains('https://www.googleapis.com/drive/v3/files')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'Application/json');
            response.setHeader('Authorization','Bearer ya29.GlyyBl38bjO_CDSZgKEjsdfxeDGpX67wzqG7jMD5FOBoL0pWcnLMgrmrDGS2r_Sjp58TI7svZQRIDI6xpnUDJiqJXWoztmWiSmDR9u_y_5ee90TQ_VIkNbj5iNAOqg');
            response.setBody('{"files" :[{"id":"root", "mimeType":"application/vnd.google-apps.folder", "name":"SUresh"}, {"id":"root","mimeType":"application/oct.stream", "name":"file"}]}');
            return response;
        }
        
        else if(request.getEndpoint().contains('https://www.googleapis.com/drive/v3/files')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'Application/json');
            response.setHeader('Authorization','Bearer ya29.GlyyBl38bjO_CDSZgKEjsdfxeDGpX67wzqG7jMD5FOBoL0pWcnLMgrmrDGS2r_Sjp58TI7svZQRIDI6xpnUDJiqJXWoztmWiSmDR9u_y_5ee90TQ_VIkNbj5iNAOqg');
            response.setBody('{"mimeType": "application/vnd.google-apps.folder", "name": '+ '"folderName","parents":["folderId"]}');
            return response;
        }
        
        else if(request.getEndpoint().contains('https://www.googleapis.com/drive/v2/files')){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'Application/json');
            response.setHeader('Authorization','Bearer ya29.GlyyBl38bjO_CDSZgKEjsdfxeDGpX67wzqG7jMD5FOBoL0pWcnLMgrmrDGS2r_Sjp58TI7svZQRIDI6xpnUDJiqJXWoztmWiSmDR9u_y_5ee90TQ_VIkNbj5iNAOqg');
            response.setBody('{ "webContentLink": "https://drive.google.com/a/briskminds.com/uc?id=1RMiG9KGQcPNlFhIzWb00uI81RG9vdQOn&export=download"}');
            return response;
        }
        
        return new HttpResponse();
    }

}