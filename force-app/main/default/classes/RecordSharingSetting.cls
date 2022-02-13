public with sharing class RecordSharingSetting {
	public RecordSharingSetting() {
		
	}

	
    public static boolean manualShareRead(Id recordId, Id userOrGroupId){
    	//Create new sharing object for the custom object Job.
      	Matter_Member__Share jobShr  = new Matter_Member__Share();
   
      	// Set the ID of record being shared.
	     jobShr.ParentId = recordId;
	        
      	// Set the ID of user or group being granted access.
    	jobShr.UserOrGroupId = userOrGroupId;
	        
      	// Set the access level.
      	jobShr.AccessLevel = 'Read';
	        
      	// Set rowCause to 'manual' for manual sharing.
      	// This line can be omitted as 'manual' is the default value for sharing objects.
      	jobShr.RowCause = Schema.Matter_Member__Share.RowCause.Manual;
	        
      	// Insert the sharing record and capture the save result. 
      	// The false parameter allows for partial processing if multiple records passed 
      	// into the operation.
		Database.SaveResult sr = Database.insert(jobShr,false);
		// Process the save results.
      	if(sr.isSuccess()){
	   		// Indicates success
		   	return true;
		}
    	else {
	  	    //Get first save result error.
	        Database.Error err = sr.getErrors()[0];
    	   
    	    // Check if the error is related to trival access level.
    	    // Access level must be more permissive than the object's default.
	        // These sharing records are not required and thus an insert exception is acceptable. 
	        if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
	        	err.getMessage().contains('AccessLevel')){
	            // Indicates success.
	            return true;
	        }
	        else{
	        	// Indicates failure.
	            return false;
	        }
        }
   
	}
}

/*
trigger JobApexSharing on Job__c (after insert) {
    
    if(trigger.isInsert){
        // Create a new list of sharing objects for Job
        List<Job__Share> jobShrs  = new List<Job__Share>();
        
        // Declare variables for recruiting and hiring manager sharing
        Job__Share recruiterShr;
        Job__Share hmShr;
        
        for(Job__c job : trigger.new){
            // Instantiate the sharing objects
            recruiterShr = new Job__Share();
            hmShr = new Job__Share();
            
            // Set the ID of record being shared
            recruiterShr.ParentId = job.Id;
            hmShr.ParentId = job.Id;
            
            // Set the ID of user or group being granted access
            recruiterShr.UserOrGroupId = job.Recruiter__c;
            hmShr.UserOrGroupId = job.Hiring_Manager__c;
            
            // Set the access level
            recruiterShr.AccessLevel = 'edit';
            hmShr.AccessLevel = 'read';
            
            // Set the Apex sharing reason for hiring manager and recruiter
            recruiterShr.RowCause = Schema.Job__Share.RowCause.Recruiter__c;
            hmShr.RowCause = Schema.Job__Share.RowCause.Hiring_Manager__c;
            
            // Add objects to list for insert
            jobShrs.add(recruiterShr);
            jobShrs.add(hmShr);
        }
        
        // Insert sharing records and capture save result 
        // The false parameter allows for partial processing if multiple records are passed 
        // into the operation 
        Database.SaveResult[] lsr = Database.insert(jobShrs,false);
        
        // Create counter
        Integer i=0;
        
        // Process the save results
        for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                // Get the first save result error
                Database.Error err = sr.getErrors()[0];
                
                // Check if the error is related to a trivial access level
                // Access levels equal or more permissive than the object's default 
                // access level are not allowed. 
                // These sharing records are not required and thus an insert exception is 
                // acceptable. 
                if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  
                                               &&  err.getMessage().contains('AccessLevel'))){
                    // Throw an error when the error is not related to trivial access level.
                    trigger.newMap.get(jobShrs[i].ParentId).
                      addError(
                       'Unable to grant sharing access due to following exception: '
                       + err.getMessage());
                }
            }
            i++;
        }   
    }
    
}
*/