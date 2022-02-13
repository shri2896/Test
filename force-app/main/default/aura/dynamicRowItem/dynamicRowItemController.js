({
	addNewRow : function(component, event, helper){       
         // fire the AddNewRowEvt Lightning Event 
        component.getEvent("AddRowEvt").fire();     
    },
    
    removeRow : function(component, event, helper){
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
       component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    }, 
    
    enableDisableRow : function(component, event, helper){
    	var disableRow = component.get("v.isDisable");
         if(disableRow == "true"){                        
        	disableRow = "false";            
        }
        else{                         
            disableRow = "true";
        }
        
        component.set("v.isDisable", disableRow);
    },
    
    handleClone: function(component, event, helper){
    	var cloneData = component.get("v.AccountInstance");
    	var evnt = component.getEvent("cloneRowEvt");
    	//alert("cloneData : " + JSON.stringify(cloneData) + ' evnt : ' + evnt);
        evnt.setParams({"cloneRowEvt": cloneData});
        evnt.fire();
	}
})