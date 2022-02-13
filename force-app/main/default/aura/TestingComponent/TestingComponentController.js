({
	 doInit: function(component, event, helper) {        
       
        //var f = component.get("v.objFields");
        //console.log("f : " + JSON.stringify(f))
        var action = component.get("c.getKanbanWrap");
        action.setParams({
            "objName":component.get("v.objName"),
            "flds": component.get("v.objFields"),
            "kanbanField": component.get("v.kanbanPicklistField")
        });
        action.setCallback(this, function(response){            
            var state = response.getState();
            //console.log("state : " + state + ' : ' + JSON.stringify(response.getError()))
            if (state === "SUCCESS") {
                //console.dir(response.getReturnValue());
                component.set("v.kanbanData", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
     doView: function(component, event, helper) {
        var editRecordEvent = $A.get("e.force:navigateToSObject");
        editRecordEvent.setParams({
            "recordId": event.target.id
        });
        editRecordEvent.fire();
    },
    
    allowDrop: function(component, event, helper) {
        event.preventDefault();
    },
    
    drag: function (component, event, helper) {
        event.dataTransfer.setData("text", event.target.id);
    },
    
    drop: function (component, event, helper) {
       
        event.preventDefault();
        var data = event.dataTransfer.getData("text");        
        var tar = event.target;         
         while(tar.tagName != 'ul' && tar.tagName != 'UL'){
            tar = tar.parentElement;
         }
        console.log("after data : " + JSON.stringify(data))
        tar.appendChild(document.getElementById(data));
        
        console.log('aaaaaaaaaaaaa   :   ' + tar.getAttribute('data-Pick-Val'));
        //document.getElementById(data).style.backgroundColor = "#ffb75d";
        helper.updatePickVal(component,data,component.get("v.kanbanPicklistField"),tar.getAttribute('data-Pick-Val'));
    }
})