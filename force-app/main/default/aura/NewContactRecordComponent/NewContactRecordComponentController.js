({
	closeModal : function(component, event, helper) {
		component.destroy();
	},
    
    saveRecord: function(component, event, helper){
        var accountId = component.get('v.contactRec');                                               
        var id = component.get("v.accountId");        
        accountId.AccountId = id;
        
        component.set("v.contactRec", accountId);
        
        var getRecord = component.get("v.contactRec");
        console.log('getRecord : ' + JSON.stringify(getRecord));
        
        var action = component.get('c.createNewContactRecord');        
        
        action.setParams({'cont': getRecord, 'accId': id});
        
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){                
                helper.eventFire(component, response.getReturnValue());                
            }
            else{
                alert('Error while create contact reocrd : ' + JSON.stringify(response.getError()));
            }
        })
        $A.enqueueAction(action);
    }
})