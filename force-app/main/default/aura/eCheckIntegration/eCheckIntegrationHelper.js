({
	finalPaymentHelper : function(component, event) {
		var accountName = component.find('accountName').get('v.value')
		var routing = component.find('routing').get('v.value')
		var accountNumber = component.find('accountNumber').get('v.value')
		var confirmAccountNumber = component.find('confirmAccountNumber').get('v.value')
		var checkNumber = component.find('checkNumber').get('v.value')
		var firstName = component.find('sFname').get('v.value');
		var adrs = component.find('shipad').get('v.value');
		var city = component.find('scity').get('v.value');
		var country = component.find('scountry').get('v.value');		
		var lastName = component.find('slname').get('v.value');

		console.log('accountName : ' + accountName);
		console.log('routing : ' + routing);
		console.log('accountNumber : ' + accountNumber);
		console.log('confirmAccountNumber : ' + confirmAccountNumber);
		console.log('checkNumber : ' + checkNumber);

		console.log('scountry : ' + country);
		console.log('scity : ' + city);
		console.log('shipad : ' + adrs);
		console.log('shipad : ' + firstName);


		if(!(accountName && routing && accountNumber && confirmAccountNumber && checkNumber && firstName && adrs && city && country && lastName)){
			this.showToast(component, event, '', 'all fields are mandatory to fill', 'error');
			//alert('all fields are mandatory to fill');
		}
		else{
			console.log('accountNumber == confirmAccountNumber : ' + accountNumber == confirmAccountNumber)
			if(accountNumber != confirmAccountNumber){
				this.showToast(component, event, '', 'Account number not match...!!!', 'error');
				//alert('Account number not match...!!!');
			}
			else{
				console.log('else');
				var action = component.get('c.eCheckPayment');
				console.log('setParams');
				action.setParams({"nameOnAccount": accountName,
									"routing": routing,
									"accountNumber": accountNumber,									
									"checkNumber":checkNumber,
									"product": JSON.stringify(component.get("v.items")),
									"country":country,
									"address":adrs,
									"city":city,
									"firstName": firstName,
									"totalAmount": component.get('v.price')
								});
				console.log('after param');
				action.setCallback(this, function(response){
					var state = response.getState();
					console.log('state : ' + state);
					if(state == 'SUCCESS'){
						var data = response.getReturnValue();						
						if(data == 'Trasaction is Success'){							
							this.showToast(component, event, '', data, 'success');
						}
						else{						
							this.showToast(component, event, '', data, 'error');
						}						
						//console.log('data : ' + data);
						//alert(data);
					}
				})

				$A.enqueueAction(action);
			}
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