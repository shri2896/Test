({
    
    doInit: function(component, event, halper){
    	//var val = component.get("v.SelectedRecord")
        //console.log("SelectedRecord val is : " + val)
    },
    
	closeModal : function(component, event, helper) {
		// when a component is dynamically created in lightning, we use destroy() method to destroy it.
        //console.log('com. : ' + component)
		component.destroy();
        console.log('after destroy com. : ' + component)
	},
 
    
 
    saveUpdatedRecord: function(component, event, helper){
        var validAccount = component.find('SelectedRecord').reduce(function(validSoFar, inputCmp){  
        	inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid	
        }, true)
        
        if(validAccount){
            var newRec = component.get("v.SelectedRecord"); 
			
            console.log("New val : " + JSON.stringify(newRec) + '  : ' + newRec);
            
            var action = component.get("c.saveUpdateRecord")
            action.setParams({"acc": newRec})
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){                      
					component.destroy();                					
                }               	
                else{
					alert("error in update");
                }
            })
            $A.enqueueAction(action);            
        }
    },    
    
})