({
	doInit : function(component, event, helper) {	
		// Authentication process	
      	helper.getAuthCodeHelper(component, event);      	
    },        

    deleteFolder: function(component, event, helper){
    	var id = event.getSource().get('v.value'); 
    	//Get delete folder n file id and send to helper
    	helper.deleteFolderHelper(component, event, id);
    },

    downloadFile: function(component, event, helper){
    	var id = event.getSource().get('v.value');    	
    	// Get download file id and to helper
    	helper.downloadFileHelper(component, event, id);
    },

    getFolder: function(component, event, helper){    	
    	// When user clicks on any folder show all sub folder data
    	helper.getFolderHelper(component, event);	
    },

    //Upload file
    dataFileUpload: function(component, event, helper){     	
	    var fileName = 'No File Selected..';

	    //if multiple file is true then get all files
	    if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        if(fileName != null && fileName != ''){
        	console.log('file name : ' + fileName);
        	component.set("v.fileName", fileName);
        	helper.uploadHelper(component, event);
        }   
        else{
        	console.log('file not found');
        }         	
    },

    //Navigate from subfolder to Home
    goToRootFolder: function(component, event, helper){
    	var folderId = component.get('v.folderId');

    	//User current folder directory is not root    	
    	var accessToken = component.get("v.accessToken");
    	component.set('v.folderId', 'root');
        helper.getFileName(component, event, accessToken, folderId);	    
    }
})