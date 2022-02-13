({
	getLanguageNameHelper : function(component, event, helper) {
		var action = component.get('c.getLanguageName');
		action.setParams({'languageId' : component.get('v.selectedLanguage')});
		action.setCallback(this, function(response){
			var state = response.getState();
			if(state === 'SUCCESS'){
				var langName = response.getReturnValue();
				component.set('v.languageName', langName);			
			}
			else{
				alert('error in Question_Answer doint : ' + JSON.stringify(response.getError()));
			}
		})
		$A.enqueueAction(action);
		
	},	
})