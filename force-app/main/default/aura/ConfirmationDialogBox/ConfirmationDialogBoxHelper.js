({
    onOkHelper : function(component, event) {
        component.getEvent("confirmation").setParams({"confirmation" : true}).fire();
    }
})