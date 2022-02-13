({
	doInit : function(component, event, helper) {
		helper.getObjectList(component, event);
		helper.getRecords(component, event);		
	},

	changeInObjectList: function(component, event, helper){
		helper.getObject(component, event, helper);
	},

	changeColumn: function(component, event, helper){
		//helper.changeColumn(component, event);
	},

})