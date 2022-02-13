({
    doInit : function(component, event, helper) {        
        helper.getLanguageHelper(component, event);
    },

    getSelectedLanguage : function(component, event, helper){
        helper.getSelectedLanguage(component, event);
    },

    startQuiz : function(component, event, helper){        
        helper.startQuizHelper(component, event);        
    }
})