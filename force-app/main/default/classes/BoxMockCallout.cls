global class BoxMockCallout implements HttpCalloutMock{
    global HttpResponse respond(HttpRequest request	){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/Json');
        response.setHeader('Authorizatio', 'Bearer mitta.sHrI');
        
        if(request.getEndpoint().contains('https://api.box.com/oauth2/token')){
            response.setBody('{"access_token":"FgDpj1E9m9MaoXtJRJbRoIAfhEeWz5Wz","expires_in":4306,"restricted_to":[],"refresh_token":"8581vA6KGowlVYwgBO24tilkGSj0STJ7BRDvQpRzvZqA3vB61olpb6N1HT5x4T9P","token_type":"bearer"}');
        }
        else if(request.getEndpoint().contains('https://api.box.com/2.0/folders')){
        	response.setBody('{"type": "folder","id": "11446498","sequence_id": "1","etag": "1","name": "Pictures","created_at": "2012-12-12T10:53:43-08:00","modified_at": "2012-12-12T11:15:04-08:00","description": "Some pictures I took","is_collaboration_restricted_to_enterprise": true,"size": 629644,"path_collection": {"total_count": 1,{"entries": [{"type": "folder","id": "0","sequence_id": null,"etag": null,"name": "All Files"}]}}');
        }
        return response;
    }
}