@RestResource(urlMapping='/Cases/*')
global with sharing class CaseManager {
    @HttpGet
    global static Case getCaseById() {
        RestRequest request = RestContext.request;
        // grab the caseId from the end of the URL
        String caseId = request.requestURI.substring(
          request.requestURI.lastIndexOf('/')+1);
        Case result =  [SELECT CaseNumber,Subject,Status,Origin,Priority
                        FROM Case
                        WHERE Id = :caseId];
        return result;
    }
    @HttpPost
    global static ID createCase(String subject, String status,
        String origin, String priority) {
        Case thisCase = new Case(
            Subject=subject,
            Status=status,
            Origin=origin,
            Priority=priority);
        insert thisCase;
        return thisCase.Id;
    }   
    @HttpDelete
    global static void deleteCase() {
        RestRequest request = RestContext.request;
        String caseId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Case thisCase = [SELECT Id FROM Case WHERE Id = :caseId];
        delete thisCase;
    }     
    @HttpPut
    global static ID upsertCase(String subject, String status,
        String origin, String priority, String id) {
        Case thisCase = new Case(
                Id=id,
                Subject=subject,
                Status=status,
                Origin=origin,
                Priority=priority);
        // Match case by Id, if present.
        // Otherwise, create new case.
        upsert thisCase;
        // Return the case ID.
        return thisCase.Id;
    }
    @HttpPatch
    global static ID updateCaseFields() {
        RestRequest request = RestContext.request;
        String caseId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Case thisCase = [SELECT Id FROM Case WHERE Id = :caseId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Case sObject
            thisCase.put(fieldName, params.get(fieldName));
        }
        update thisCase;
        return thisCase.Id;
    }    
}
//"5006F0000240O3GQAU"

//Clien ID :- 72641396293-4tvrlorfoqo935m2a1j8c1nrlme7poai.apps.googleusercontent.com
//Secret :- 5r3XfxYC_H9OBgZ3iR-HWoX8
//  Service Name :- drive.googleapis.com
//https://accounts.google.com/o/oauth2/v2/auth?
// RedirectUri :- 'https://accounts.google.com/o/oauth2/auth?' + 
// 'client_id=-4tvrlorfoqo935m2a1j8c1nrlme7poai.apps.googleusercontent.com' + 















/*



public class GoogleDriveController {
private String code;

public boolean val {
    get;
    set;
    }

public blob file {
    get;
    set;
    }

public String filetype {
    get;
    set;
    }
   
public String filename {
    get;
    set;
    }
private string key = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
private string secret = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
private string redirect_uri = 'https://xxxxxxxxxxxxxxx.force.com/apex/GoogleDrive';
private String accesstoken;
private Integer expiresIn;
private String tokentype;

public GoogleDriveController() {
code = ApexPages.currentPage().getParameters().get('code');
//Get the access token once we have code
if (code != '' & amp; & amp; code != null) {
AccessToken();
 }

 PageReference pg = new PageReference(GoogleDriveAuthUri(key, redirect_uri));
return pg;
}
public PageReference DriveAuth() {
//Authenticating

}

public String GoogleDriveAuthUri(String Clientkey, String redirect_uri) {
String key = EncodingUtil.urlEncode(Clientkey, 'UTF-8');
String uri = EncodingUtil.urlEncode(redirect_uri, 'UTF-8');
String authuri = '';
authuri = 'https://accounts.google.com/o/oauth2/auth?' +
      'client_id=' + key +
      '&response_type=code' +
	      '&scope=https://www.googleapis.com/auth/drive' +
	      '&redirect_uri=' + uri +
	      '&state=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' +
	       +
	      'access_type=offline';
       return authuri;
    }
public void UploadFile() {
String boundary = '----------9889464542212';
String delimiter = '\r\n--' + boundary + '\r\n';
String close_delim = '\r\n--' + boundary + '--';
String bodyEncoded = EncodingUtil.base64Encode(file);
String body = delimiter + 'Content-Type: application/json\r\n\r\n' + '{ "title" : "' + filename + '",' + ' "mimeType" : "' + filetype + '" }' + delimiter + 'Content-Type: ' + filetype + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + bodyEncoded + close_delim;
Http http = new Http();
HttpRequest req = new HttpRequest();
req.setEndpoint('https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart');
req.setHeader('Authorization', 'Bearer ' + accessToken);
req.setHeader('Content-Type', 'multipart/mixed; boundary="' + boundary + '"');
req.setHeader('Content-length', String.valueOf(body.length()));
req.setBody(body);
req.setMethod('POST');
req.setTimeout(60 * 1000);
HttpResponse resp = http.send(req);
file = null;
filetype = '';
filename = '';
}
public void AccessToken() {
//Getting access token from google
HttpRequest req = new HttpRequest();
req.setMethod('POST');
req.setEndpoint('https://accounts.google.com/o/oauth2/token');
req.setHeader('content-type', 'application/x-www-form-urlencoded');
String messageBody = 'code=' + code + '&client_id=' + key + '&client_secret=' + secret + '&redirect_uri=' + redirect_uri + '&grant_type=authorization_code';
req.setHeader('Content-length', String.valueOf(messageBody.length()));
req.setBody(messageBody);
req.setTimeout(60 * 1000);
Http h = new Http();
String resp;
HttpResponse res = h.send(req);
resp = res.getBody();
JSONParser parser = JSON.createParser(resp);
while (parser.nextToken() != null) {
    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
    String fieldName = parser.getText();
    parser.nextToken();
    if (fieldName == 'access_token') {
    accesstoken = parser.getText();
    } else if (fieldName == 'expires_in') {
     expiresIn = parser.getIntegerValue();
    } else if (fieldname == 'token_type') {
     tokentype = parser.getText();
    }
 } }
 System.debug(' You can parse the response to get the access token ::: ' + resp);
    }














    <apex:form style="margin-top:5%;margin-left:5%;width:60%">
<apex:pageblock>
<apex:commandbutton styleClass="myClass" onclick="this.value = 'Authenticating....'" action="{!DriveAuth}" value="Google Drive Authentication">
</apex:commandbutton>
<br/>
<br/>
<br/>
<br/>
<apex:inputfile value="{!file}" contentType="{!filetype}" filename="{!filename}" />
<br/>
<br/>
<br/>
<br/>
<apex:commandButton styleClass="myClass" onclick="this.value = 'Uploading...'" value="Upload file" action="{!UploadFile}" />
<br/>
<br/>
<apex:messages styleClass="error" />
<br/>
</apex:pageblock>
</apex:pageblock>
</apex:form>
</center>
</apex:page>
}*/