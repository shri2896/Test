({
	closeModal : function(component, event, helper) {
		// when a component is dynamically created in lightning, we use destroy() method to destroy it.
		component.destroy();
	},
 
	// action to execute when save button is clicked
	handleSave : function(component, event, helper) {
        var validExpense = component.find('accRec').reduce(function(validSoFar, inputCmp){
			inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid
        },true)
		
        if(validExpense){
            var newRec = component.get("v.accRec")
            console.log("create expense " + JSON.parse(JSON.stringify(newRec)))
            helper.createRecord(component, newRec)
        }
	}
})