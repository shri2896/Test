({
	createRecord : function(component, newRec) {
		var action = component.get("c.insertRecord");
        action.setParams({"acc": newRec});
        //console.log("Helper : " )
         action.setCallback(this, function(response){           
			var state = response.getState();
            if(state === 'SUCCESS'){              
              	var evnt = component.getEvent("CreateNewAccountRecord");
                var result = response.getReturnValue();
                //console.log("Result in create New JS : " + JSON.stringify(result))
                evnt.setParams({"CreateNewAccountRecord": result});             	
                evnt.fire();             
                component.destroy();
            }            
            else{
                alert("Error")
                console.log("error in inserting")
            }
        });
    	$A.enqueueAction(action);        
    }
})