({
	
	doInit : function(component, event, helper) {
		helper.getAllObjectListHelper(component, event);
	},

	getFieldList : function(component, event, helper){
		var emptyList = [];
		component.set('v.selectedFields', emptyList);
		component.set('v.nonSelectedFields', emptyList);
		component.set('v.values', emptyList);
		component.set('v.objRecords', emptyList);

		helper.getFieldsHelper(component, event);
	},

	handleChange: function (component, event, helper) {
        // This will contain an array of the "value" attribute of the selected options
        
        var selectedOptionValue = event.getParam("value");        
        helper.getSelectedValueData(component, event);        
    },

    showRecords: function (cmp, event, helper) {    	
    	helper.showRecordsHelper(cmp, event);
    }
})