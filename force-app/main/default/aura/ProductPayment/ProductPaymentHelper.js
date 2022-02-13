({
    finalPaymentHelper : function(component, event) {
        var cardNumber = component.find("cardNumber").get("v.value");
        var amount = component.get("v.price");        
        var mobile = component.find("mobile").get("v.value");
        var cvv = component.find("cvv").get("v.value");
        var month = component.find('ExprMM').get('v.value');
        var year = component.find('ExprYY').get('v.value')

        console.log('cardNumber : ' + cardNumber);
        console.log('amount : ' + amount);        
        console.log('cvv : ' + cvv);        

        if(!(cardNumber && month && year && cvv )){	        
            //alert('All Required Fields are fill to mandatory')
            this.showToast(component, event, '', 'All Required Fields are fill to mandatory', 'error');
        }
        else{
            if(month.length != 2){
                this.showToast(component, event, '', 'Month Must be in MM format', 'error');
                //alert('Month should be in MM format');
        	  }
        	  else{
                if(year.length != 4){
          		      this.showToast(component, event, '', 'Year Must be in YYYY format', 'error');
                    //alert('Year should be in YYYY format');
          		  }
            		else{
            		    if(cvv.length != 3){
            				    this.showToast(component, event, '', 'CVV Must be 3 digits', 'error');
                        //alert('CVV should be 3 digits');
            		    }
              			else{
      			           	var date = year + '-' + month ;
        			        	console.log('cardNumber : ' + JSON.stringify(component.get("v.item")));          	
          			    		console.log('cardNumber : ' + component.find("shipad").get("v.value"));          	
          			    		console.log('cardNumber : ' + component.find("scity").get("v.value"));          	
          			    		console.log('cardNumber : ' + component.find("scountry").get("v.value"));          	
          			    		console.log('cardNumber : ' + component.find("sFname").get("v.value"));          	
          			    		console.log('cardNumber : ' + component.find("sphone").get("v.value"));          	
          			    		console.log('cardNumber : ' + component.find("semial").get("v.value"));          	
          			    		console.log('cardNumber : ' + component.find("slname").get("v.value")); 
        			    		

        				        var action = component.get("c.paymentGateWay");	       
        				        action.setParams({"cardNumber" : cardNumber,
        			                          "cvv" : cvv,
        			                          "mobile" : mobile,                          
        			                          "amount" : amount,
        			                          "shipAddress": component.find("shipad").get("v.value"),
        			                          "shipCity": component.find("scity").get("v.value") ,
        			                          "shipcountry": component.find("scountry").get("v.value"),
        			                          "firstName": component.find("sFname").get("v.value"),
        			                          "lastName": component.find("slname").get("v.value"),
        			                          "Email": component.find("semial").get("v.value"),
        			                          "phone": component.find("sphone").get("v.value"),
              						              "cart" : JSON.stringify(component.get("v.item")),
              						              "exprDate" : date
        			                          });
        				        
        				        	console.log('after param')
        				        	action.setCallback(this, function(response) { 
        				        	var state = response.getState();
        				        	console.log('state : ' + state);

        				            var result = response.getReturnValue();
        				            console.log('result of Payment : ' + JSON.stringify(result))
        				            alert(result);
        				            
        				        });
        				        $A.enqueueAction(action);
        				    }
    			      }
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