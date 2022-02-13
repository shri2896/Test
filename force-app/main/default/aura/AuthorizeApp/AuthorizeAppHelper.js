({
	getDataHelper: function(component, event){		
		var action = component.get("c.getRecordsController");
		action.setCallback(this, function(response){
			var state = response.getState();
			//console.log('state : ' + state + ' error : ' + JSON.stringify(response.getError()));
			//console.log('rec : ' + JSON.stringify(response.getReturnValue()));

			component.set('v.listOfRecord', response.getReturnValue());
			//console.log('listOfRecord : ', JSON.stringify(component.get('v.listOfRecord')));
		})

		$A.enqueueAction(action);
	},

    calculateTotalPriceHelper: function(component, event){
    			
		var value = event.getSource().get('v.value');   			
        if(value >= 0){
	        var Name = event.getSource().get('v.name');
	        var records = component.get("v.listOfRecord");
	        var totalAmount = 0 ;
	        for(var i = 1; i < records.length; i++) {
	            var amountPerItem = 1;
	            for(var j = records[i].sObjectData.length-1; j >= records[i].sObjectData.length-2; j--) {
	                if(records[i].sObjectData[j].fields == ''){
	                    records[i].sObjectData[j].fields = 0;
	                }
	                if(records[i].index == Name) {
	                    amountPerItem = value;
	                    j = records[i].sObjectData.length-2;
	                    amountPerItem *= records[i].sObjectData[j].fields;
	                    records[i].sObjectData[j+1].fields = value;
	                }
	                else {
	                    amountPerItem *= records[i].sObjectData[j].fields; 	                    
	                }
        	    }
            	totalAmount += amountPerItem; 
            	//console.log('totalAmount : ' + totalAmount);
        	}   

        	component.set("v.listOfRecord",records);
        	component.set('v.totalPrice', totalAmount);

        }
        else{
            console.log('quantity should be greater then 0'); 
            event.getSource().set()           
        }
    },

    processToPayHelper: function(component, event){
    	var lst = this.setSelectedData(component, event);

    	if(lst.length > 0){
    		component.set("v.selectedItems",lst);	        
	        component.set("v.viewcart","true");
    	}
    },

    setSelectedData: function(component, event){
    	var records = component.get("v.listOfRecord");	    	
        var selectedRecords = [];
        //console.log('rec: ' + JSON.stringify(records))
        for(var i = 0; i < records.length; i++){
            if(i != 0){
                if(records[i].sObjectData[3].fields > 0){
                    selectedRecords.push(records[i]);                     
                }
            }
        }        
        if(selectedRecords.length > 0  ){            	        
	        return selectedRecords;             
        }
        else{
            var msg = 'please select any product';                        
        }
    },

    showToast : function(component, event, title, message, type) {
	    var toastEvent = $A.get("e.force:showToast");
	    toastEvent.setParams({
	        "title": title,
	        "message": message,
	        "type": type
	    });
	    toastEvent.fire();
	}
})