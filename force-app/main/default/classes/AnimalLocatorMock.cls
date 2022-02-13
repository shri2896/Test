@isTest
global class AnimalLocatorMock implements HttpCalloutMock {
    global HTTPResponse respond(HttpRequest request){
     	HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
		response.setBody('{"animal":{"id":1,"name":"Chicken","eats":"chicken food","says":"cluck cluck"}}');
        response.setStatusCode(200);
        return response;
    }      
}