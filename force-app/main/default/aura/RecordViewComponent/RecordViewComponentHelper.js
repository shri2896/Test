({
	getReocrdsHelper : function(component, event) {
        var action = component.get('c.getObjectRecords');
        
        action.setCallback(this, function(response){
            console.log('state');
            var state = response.getState();
            console.log('state : ' + state);
            
            if(state === 'SUCCESS'){
                console.log('response : ' + JSON.stringify(response.getReturnValue()));
            }
        })

        $A.enqueueAction(action);

	},

    editHelper : function(component, event, helper) {
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": component.get("v.recordId")
        });
        editRecordEvent.fire();
    }
})