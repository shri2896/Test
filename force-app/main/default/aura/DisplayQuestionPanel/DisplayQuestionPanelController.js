({
    doInit : function(component, event, helper) {  
        helper.findUnAnsweredQuestion(component, event);
    },

    cancel : function(component, event, helper){
        component.destroy();
    },

    getSelectedQue : function(component, event, helper){        
        helper.getSelectedQueHelper(component, event);
        
    }
})