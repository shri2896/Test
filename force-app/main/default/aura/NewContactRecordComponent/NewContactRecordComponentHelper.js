({
	eventFire : function(component, lstOfContact) {        
        var event = component.getEvent('updateContactList');
        event.setParams({"updateContactList": lstOfContact});
        event.fire();
        component.destroy();
	}
})