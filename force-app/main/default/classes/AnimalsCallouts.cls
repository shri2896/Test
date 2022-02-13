public class AnimalsCallouts {
    public static HttpResponse makeGetCallout(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        HttpResponse response = http.send(request);
        return response;
    }	
    public static HttpResponse makePostCallout(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        HttpResponse response = http.send(request);
        if(response.getStatusCode()!=201){
            System.debug('Error in Status Code : ' + response.getStatusCode() + ' ' + response.getStatus());
        }
        else{
            System.debug(response.getBody());
        }
            
     	return response;   	
    }
}