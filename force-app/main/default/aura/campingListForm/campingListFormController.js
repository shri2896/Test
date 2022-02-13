({
	 clickCreateItem : function(component, event, helper) {
    	var validCamping = component.find('campingform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
            
        if(validCamping){
           var newCampingItem = component.get("v.newItem");           
           helper.createItem(component, newCampingItem)
        }
    }
})