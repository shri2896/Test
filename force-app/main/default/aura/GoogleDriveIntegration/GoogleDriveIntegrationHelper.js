({		
	MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB      

    getAuthCodeHelper: function(component, event){

        //Avoid case of infinate set url.
        var url_string = window.location.href
        var url = new URL(url_string);
        var code = url.searchParams.get("code");    
        console.log('auth code before if : ')
        if(code == null || code == ''){     
            console.log('auth code null in if : ');
            this.authCodeHelper(component, event);            
        }            
        else{
            console.log('auth code get for refresh token : ' + code);
            var action = component.get('c.getAccessToken');            
            action.setParams({"code": code});
            action.setCallback(this, function(response){

                var state = response.getState();
                console.log('auth code response : ' + state + ' error : ' + JSON.stringify(response.getError()));

                var accessToken = response.getReturnValue();  
                console.log('access token response : ' + JSON.stringify(accessToken));
                if(accessToken.authURL == null){
                    this.getFileName(component, event, accessToken.accessToken, 'root');                    
                }
                else{
                    console.log('acces null : file not call');
                    window.location.href = accessToken.authURL
                    var url_string1 = window.location.href
                    var url1 = new URL(url_string1);
                    var code1 = url1.searchParams.get("code");  
                }                
            })
            $A.enqueueAction(action);
        }            
    },

    authCodeHelper: function(component, event){
        console.log('authCodeHelper call')
        var action = component.get('c.getAuthCode');            
            action.setCallback(this, function(response){            
                var state = response.getState();
                console.log('auth code response : ' + state + ' error : ' + JSON.stringify(response.getError()));
                var authURL = response.getReturnValue();

                if(authURL.authURL != null){
                    // Set auth url in current url
                    window.location.href = authURL.authURL;
                    // Return current url
                    var urlStr = window.location.href;                    
                    var getURL = new URL(urlStr);
                    var authCode = getURL.searchParams.get("code");                 
                }
                else{      
                    console.log('else authURL.accessToken : accessToken : ' + authURL.accessToken)              
                    component.set('v.accessToken', authURL.accessToken);
                    this.getFileName(component, event, authURL.accessToken, 'root');
                }
            })

            $A.enqueueAction(action);
    },
    
    // Get all file n folder data
    getFileName: function(component, event, token, fId){
        console.log('token in file name : ' + token);
        var lstFolder = [];
        var lstOfFile = [];
        var action = component.get('c.getFileNames');       
        action.setParams({"accessToken": token,
                        "fId": fId
                        });

        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state : ' + state);

            if(state === 'SUCCESS'){
                var result = response.getReturnValue();                
                var data = result.files;                

                for(var i = 0; i < data.length; i++){                   
                    if(data[i].mimeType=='application/vnd.google-apps.folder'){
                        lstFolder.push(data[i]);                        
                    }
                    else{
                        lstOfFile.push(data[i]);                        
                    }
                }
                

                component.set('v.listOfFolder', lstFolder);
                component.set('v.listOfFile', lstOfFile);

                
            }
        })

        $A.enqueueAction(action)
    },


    //Delete selected file or folder
    deleteFolderHelper: function(component, event, id){

    	var accessToken = component.get('v.accessToken');    	
        var folderId = component.get('v.folderId');

    	var action = component.get('c.deleteFolder1');    	
    	action.setParams({"recId": id,
    					"access_Token":accessToken
    					});    	

    	action.setCallback(this, function(response){
    		var state = response.getState();
    		this.getFileName(component, event, accessToken, folderId);
    	})

    	$A.enqueueAction(action);

    },

    //Download file
    downloadFileHelper: function(component, event, recId){
    	var action = component.get('c.downloadFile1');
    	var accessToken = component.get('v.accessToken');

    	action.setParams({"recId": recId,
    					  "accessToken": accessToken
    					});
    	action.setCallback(this, function(response){
    		var state = response.getState();    		    		
    		var fileDownloadLink = response.getReturnValue();
    		if(fileDownloadLink == null || fileDownloadLink == ''){
    			alert('File not downloadble');
    		}
    		else{
    			window.location.href = fileDownloadLink;
    		}    		
    	})

    	$A.enqueueAction(action);
    },

    //Get current folder id and pass to getFileName for retrive all data
    getFolderHelper: function(component, event){
    	var folderId = event.target.name;
    	console.log('folder id : ' + folderId);    	
    	var accessToken = component.get('v.accessToken');        
    	component.set('v.folderId', folderId);
    	this.getFileName(component, event, accessToken, folderId);    	
    },
    
    //File upload
    uploadHelper : function(component, event){
        //Returns the all files array.
    	var fileInput = component.find("fileId").get("v.files");    	
        //Get first file from list of files(fileInput)
    	var file = fileInput[0];
    	var self = this;    	
    	if (file.size > self.MAX_FILE_SIZE) {            
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);            
            alert('file size exceed..!!! Max file size 4.5MB' )
            return;            
        }	

        var objFileReader = new FileReader();

        //Read file content.
        objFileReader.onload = $A.getCallback(function() {

            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length; 			 			
            
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method             
            self.uploadProcess(component, file, fileContents);

        });

        objFileReader.readAsDataURL(file);
    },

    uploadProcess: function(component, file, fileContents) {        
        
        var accessToken = component.get('v.accessToken');
        var action = component.get("c.saveChunk");
        var fId = component.get('v.folderId');
        //Set file name, data, folder id and access token for controller
        action.setParams({           
            filename: file.name,
            base64Data: fileContents,
            filetype: file.type,   
            fId : fId,
            accessToken: accessToken
        });
 
        // set call back 
        action.setCallback(this, function(response) {
            // store the response
            var state = response.getState();
            console.log('upload state : ' + state)
            if (state === "SUCCESS") {            	
				this.getFileName(component, event, accessToken, fId);
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert('Error...!!! : ' + errors[0].message);
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
})