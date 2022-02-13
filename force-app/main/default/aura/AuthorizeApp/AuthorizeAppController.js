({
	doInit : function(Component, event, helper) {		
		helper.getDataHelper(Component, event);
	},

	calculateTotalPrice: function(component, event, helper){			
		helper.calculateTotalPriceHelper(component, event);		
	},

	processToPay: function(component, event, helper){	
		var totalAmount = component.get('v.totalPrice');

		if(totalAmount > 100000){
			helper.showToast(component, event, '', 'Amount should be less than 100000', 'error');
			//alert('Amount should be less than 100000');
		}
		else{					
			helper.processToPayHelper(component, event);							
		}		
	},

	processToPayViaeCheck: function(component, event, helper){
		var totalAmount = component.get('v.totalPrice');
		if(totalAmount > 100000){
			helper.showToast(component, event, '', 'Amount should be less than 100000', 'error');			
		}
		else{
			var lst = helper.setSelectedData(component, event);		
			if(lst.length > 0){
				component.set("v.selectedItems",lst);
				component.set('v.eCheck', "true")	
			}
		}
		
	}

})