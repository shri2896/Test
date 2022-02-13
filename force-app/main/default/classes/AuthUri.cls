global with sharing class AuthUri {
	
	global String AuthenticationUri='';
	
	public AuthUri(String clientKey, String redirect_uri) {
		String key = EncodingUtil.urlEncode(clientKey, 'UTF-8')	;
		String uri = EncodingUtil.urlEncode(redirect_uri, 'UTF-8');
		/*String authUri = 'https://accounts.google.com/o/oauth2/auth?' +
            'client_id=' + key +
            '&response_type=code' +
            '&scope=https://www.googleapis.com/auth/drive' +
            '&redirect_uri=' + uri +
            '&state=https://www.googleapis.com/auth/drive' +            
            'access_type=offline';*/

         String authUri = 'https://accounts.google.com/o/oauth2/v2/auth?'+
         'scope=https://www.googleapis.com/auth/drive'+
         '&access_type=offline'+
		 '&include_granted_scopes=true'+
		 '&state=state_parameter_passthrough_value'+
		 '&redirect_uri=' + uri +
		 '&response_type=code'+
		 '&client_id=' + key;

        AuthenticationUri = authUri;
	}	
}



/*
https://accounts.google.com/o/oauth2/v2/auth?
 scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive.metadata.readonly&
 access_type=offline&
 include_granted_scopes=true&
 state=state_parameter_passthrough_value&
 redirect_uri=http%3A%2F%2Foauth2.example.com%2Fcallback&
 response_type=code&
 client_id=client_id
*/