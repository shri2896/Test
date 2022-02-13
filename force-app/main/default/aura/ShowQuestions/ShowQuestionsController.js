({
	doInit : function(component, event, helper) {
		helper.getQuestionListHelper(component, event, helper);
	},

	nextQuestion : function(component, event, helper){
		helper.getNextQuestionHelper(component, event);		
	},

	previousQuestion: function(component, event, helper){
		helper.setPreviousQuestionHelper(component, event);
	},

	getSelectedValue : function(component, event, helper){
		helper.getSelectedValueHelper(component, event, helper);
	},
	
	onsubmit : function(component, event, helper){
		helper.onsubmitHelper(component, event);
	},

	getConfirmation : function(component, event, helper){
		helper.getConfirmationHelper(component, event);
	},

	allQuestionPanel : function(component, event, helper){		
		helper.allQuestionPanelHelper(component, event);
	},

	setSelectedQuestion : function(component, event, helper){
		helper.setSelectedQuestionHelper(component, event);
	}
})