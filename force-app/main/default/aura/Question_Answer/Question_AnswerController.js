({
	doInit : function(component, event, helper) {
		helper.getLanguageNameHelper(component, event, helper);
	}, 

	getSelectedLanguage: function(component, event, helper){
		helper.getSelectedLanguageHelper(component, event);
	},

	getTotalQuestionCount: function(component, event, helper){
		component.set('v.totalQuestions', event.getParam('totalQuestion'));
	},

})