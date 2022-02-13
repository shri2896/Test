({
	updateContactList : function(component, lstOfContact) {
        console.log('After delete : ' + JSON.stringify(lstOfContact));
        component.set("v.contacts", lstOfContact);
        var event = component.getEvent("afterDeleteUpdateContact");
        event.setParams({"afterDeleteUpdateContact": lstOfContact});
        event.fire();
	}
})