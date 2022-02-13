({
    createItem: function(component, expense){        
    	var action = component.get("c.saveItem")
        action.setParams({
            "item": expense  
        })
            action.setCallback(this, function(response){
        	var state = response.getState();
            if(state == 'SUCCESS'){  
                var parsedCampingItem = JSON.parse(JSON.stringify(expense));
                console.log(JSON.parse(JSON.stringify(parsedCampingItem)), JSON.stringify(parsedCampingItem));
                var campingItems = JSON.parse(JSON.stringify(component.get("v.items")));
                campingItems.push(parsedCampingItem);
                component.set("v.items",campingItems);
                component.set("v.newItem", {'Price__c': 0, 'Packed__c': false, 'Quantity__c': 0, 'Name':'', 'sobjectType': 'Camping_Item__c'})

        	}
            else{
            	alert("Error : " + state.getState())
        	}
        })      
        $A.enqueueAction(action);
    }    
    
  })