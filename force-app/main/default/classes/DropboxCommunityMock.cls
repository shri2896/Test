global class DropboxCommunityMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest request){
        HttpResponse response = new HttpResponse();
        if(request.getEndpoint().contains('https://api.dropboxapi.com/oauth2/token?code')){
            response.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            response.setBody('{"access_token": "ABCDEFG", "token_type": "bearer", "account_id": "dbid:AAH4f99T0taONIb-OurWxbNQ6ywGRopQngc", "uid": "12345"}');           
        }       
        else if(request.getEndpoint().contains('https://api.dropbox.com/2/files/list_folder')){
            request.setHeader('Content-Type', 'application/Json');
            request.setHeader('Authorization', 'Bearer shrikantMittal020896');
            response.setBody('{' +
                '"entries": [' +
                '{' +
                '".tag": "file",' + 
                '"name": "Prime_Numbers.txt",' + 
                '"id": "id:a4ayc_80_OEAAAAAAAAAXw"' + 
                '},' +               
                '{' +
            '".tag": "folder",' + 
            '"name": "math",' +
            '"id": "id:a4ayc_80_OEAAAAAAAAAXz"' +
                             '}]}');
            
        }
        else if(request.getEndpoint().contains('https://api.dropboxapi.com/2/files/get_metadata')){
            request.setHeader('Content-Type', 'application/Json');
            request.setHeader('Authorization', 'Bearer sHrI2896');
            request.setBody('{' +
                            '".tag": "file",' +
                            '"name": "Prime_Numbers.txt",' +
                            '"id": "id:a4ayc_80_OEAAAAAAAAAXw",'+
                            '"path_lower": "/homework/math/prime_numbers.txt",' +
    						'"path_display": "/Homework/math/Prime_Numbers.txt"' +
                            '}');
        }
        else if(request.getEndpoint().contains('https://api.dropboxapi.com/2/files/delete_v2')){
            request.setHeader('Content-Type', 'application/Json');
            request.setHeader('Authorization', 'Bearer mIttaL2896');
            request.setBody('{"metadata": { ".tag": "file", "name": "Prime_Numbers.txt", "id": "id:a4ayc_80_OEAAAAAAAAAXw"}}');
        }       
        else if(request.getEndpoint().contains('https://api.dropboxapi.com/2/files/create_folder_v2')){
            request.setHeader('Content-Type','application/Json');
            request.setHeader('Authorization', 'Bearer shri');
            request.setBody('{"metadata": {"name": "math","id": "id:a4ayc_80_OEAAAAAAAAAXz","path_lower": "/homework/math","path_display": "/Homework/math","sharing_info": {"read_only": false,"parent_shared_folder_id": "84528192421","traverse_only": false,"no_access": false' +
            '},' +
            '"property_groups": [' +
            '{' +
             '"template_id": "ptid:1a5n2i6d3OYEAAAAAAAAAYa",' +
             '"fields": [' +
             '{' +
             '"name": "Security Policy",' +
             '"value": "Confidential"' +
             '}' +
             ']' +
             '}' +
             ']' +
            '}' +
            '}');
        }
        else if(request.getEndpoint().contains('https://content.dropboxapi.com/2/files/upload')){
            request.setHeader('Content-Type', 'application/Json');
            request.setHeader('Authorization', 'Bearer mittal.sHrI');
            request.setBody('{' +
    						'"name": "Prime_Numbers.txt",' + 
    						'"id": "id:a4ayc_80_OEAAAAAAAAAXw",' +
                            '"client_modified": "2015-05-12T15:50:38Z",' +
                            '"server_modified": "2015-05-12T15:50:38Z",' +
                            '"rev": "a1c10ce0dd78",' +
                            '"size": 7212,' +
                            '"path_lower": "/homework/math/prime_numbers.txt",' +
                            '"path_display": "/Homework/math/Prime_Numbers.txt",' +
                            '"sharing_info": {' +
                            '"read_only": true,' +
                            '"parent_shared_folder_id": "84528192421",' +
                            '"modified_by": "dbid:AAH4f99T0taONIb-OurWxbNQ6ywGRopQngc"' +
                            '},' +                    
                            '}' +
                            '],' +
                            '"has_explicit_shared_members": false,' +
                            '"content_hash": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"' +
                            '}');
        }
        else if(request.getEndpoint().contains('https://api.dropboxapi.com/2/files/get_temporary_link')){
            request.setHeader('Content-Type', 'application/Json');
            request.setHeader('Authorization', 'Bearer 123456789');
            String body = '{' +
                            ' "metadata": {' +
                            ' "name": "Prime_Numbers.txt",' +
                            '  "id": "id:a4ayc_80_OEAAAAAAAAAXw",'+
                            '"client_modified": "2015-05-12T15:50:38Z",' +
                            ' "server_modified": "2015-05-12T15:50:38Z",' +
                            '"rev": "a1c10ce0dd78",' +
                            '"size": 7212,' +
                            ' "path_lower": "/homework/math/prime_numbers.txt",' +
                            '"path_display": "/Homework/math/Prime_Numbers.txt",' +
                            '"content_hash": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"' +
                            '},' +  
                            '"link": "https://dl.dropboxusercontent.com/apitl/1/YXNkZmFzZGcyMzQyMzI0NjU2NDU2NDU2"' +
                            '}';      
            request.setBody(body);
        }
        return response;
    }
}



/*

{
    "metadata": {
        "name": "Prime_Numbers.txt",
        "id": "id:a4ayc_80_OEAAAAAAAAAXw",
        "client_modified": "2015-05-12T15:50:38Z",
        "server_modified": "2015-05-12T15:50:38Z",
        "rev": "a1c10ce0dd78",
        "size": 7212,
        "path_lower": "/homework/math/prime_numbers.txt",
        "path_display": "/Homework/math/Prime_Numbers.txt",
        "sharing_info": {
            "read_only": true,
            "parent_shared_folder_id": "84528192421",
            "modified_by": "dbid:AAH4f99T0taONIb-OurWxbNQ6ywGRopQngc"
        },
        "property_groups": [
            {
                "template_id": "ptid:1a5n2i6d3OYEAAAAAAAAAYa",
                "fields": [
                    {
                        "name": "Security Policy",
                        "value": "Confidential"
                    }
                ]
            }
        ],
        "has_explicit_shared_members": false,
        "content_hash": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
    },
    "link": "https://dl.dropboxusercontent.com/apitl/1/YXNkZmFzZGcyMzQyMzI0NjU2NDU2NDU2"
}



*/



/*     
    {
 "metadata": {
        "name": "Prime_Numbers.txt",
        "id": "id:a4ayc_80_OEAAAAAAAAAXw",
        "client_modified": "2015-05-12T15:50:38Z",
        "server_modified": "2015-05-12T15:50:38Z",
        "rev": "a1c10ce0dd78",
        "size": 7212,
        "path_lower": "/homework/math/prime_numbers.txt",
        "path_display": "/Homework/math/Prime_Numbers.txt"

    }
}

*/


/*
   String body = '{' +
                            ' "metadata": {' +
                            ' "name": "Prime_Numbers.txt",' +
                            '  "id": "id:a4ayc_80_OEAAAAAAAAAXw",'+
                            '"client_modified": "2015-05-12T15:50:38Z",' +
                            ' "server_modified": "2015-05-12T15:50:38Z",' +
                            '"rev": "a1c10ce0dd78",' +
                            '"size": 7212,' +
                            ' "path_lower": "/homework/math/prime_numbers.txt",' +
                            '"path_display": "/Homework/math/Prime_Numbers.txt", '+  
                            '"sharing_info": {' +
                            '"read_only": true,' +
                            '"parent_shared_folder_id": "84528192421",' +
                            'modified_by": "dbid:AAH4f99T0taONIb-OurWxbNQ6ywGRopQngc"' +
                            '},' +                                                        
                            '"content_hash": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"' +
                            '},' +                                                       
                            '}';      
*/