({
    onOk : function(component, event, helper){        
        helper.onOkHelper(component, event);
        component.destroy();
    },

    closeModal : function(component, event, helper){
        component.destroy();        
    }
})