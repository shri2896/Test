({
	doInit : function(component, event, helper) {		    	

		helper.getObjectList(component, event);
		helper.getRecords(component, event);		
	},

	changeInObjectList: function(component, event, helper){
		helper.getObject(component, event, helper);
	},

	changeColumn: function(component, event, helper){
		helper.changeColumn(component, event, helper);
	},

	addField: function(component, event, helper){		
		helper.addField(component, event);
	},

	subtractField: function(component, event, helper){
		helper.subtractFieldHelper(component, event);
	},	

	saveRecord:function(component, event, helper){
		helper.saveRecordHelper(component, event);
		helper.getRecords(component, event);
	},	

	getSelectedRecord:function(component, event, helper){		
		helper.getSelectedRecordHelper(component, event);
	}
	
})