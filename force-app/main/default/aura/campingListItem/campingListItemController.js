({
	
    doInit: function(component, event, helper) {
        console.log("call")
		var action = component.get("c.getItems");
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('State : ' + state)
            if (state === "SUCCESS") {                          
                console.log('Data : ' + response.getReturnValue())
                component.set("v.items", response.getReturnValue());                 
            }
            else{
                console.log("Error" + state.getState())
            }
        });
        
        $A.enqueueAction(action);
	}
    
   
})