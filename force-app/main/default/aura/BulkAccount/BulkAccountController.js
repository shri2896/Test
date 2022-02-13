({
    
    doInit: function(component, event, helper) {
        // create a Default RowItem [Contact Instance] on first time Component Load
        // by call this helper function  
        helper.createObjectData(component, event);
    },
    
    addNewRow: function(component, event, helper) {
        // call the comman "createObjectData" helper method for add new Object Row to List  
        helper.createObjectData(component, event);
    },
    
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        // get the all List (Account attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.acc");
        //alert("index var : " + index)
        AllRowsList.splice(index, 1);
        // set the acc after remove selected row element  
        component.set("v.acc", AllRowsList);
    },
    
	close : function(component, event, helper) {
		component.destroy();
	},
    
    addCloneRow: function(component, event, helper){
    	var val = event.getParam("cloneRowEvt");
        //alert("val : " + JSON.stringify(val));
        var lstOfAcc = component.get("v.acc");
        lstOfAcc.push(val);
        component.set("v.acc", lstOfAcc);
    },
    
    addMultipleRow: function(component, event, helper){
        var rowCount = component.get("v.addMultipleRow");
        //alert("Row" + rowCount);
        var accLst = component.get("v.acc");
        
        if(rowCount != null){
            for(var i=0; i<rowCount; i++){
                accLst.push({
                    'sobjectType': 'Account',
                    'Name': '',
                    'AccountNumber': '',
                    'Phone': ''                    
                });                
            }
            component.set("v.acc", accLst);
            //alert("Account list length : " + accLst.length);
        }
        else{
            alert("Specify at least 1 row");
        }
    },
    
    saveData: function(component, event, helper){
        if (helper.validateRequired(component, event)) {
        	var data = component.get("v.acc");
        	//console.log('data length : ' + JSON.stringify(data));    
        	var action = component.get("c.insertData");
            action.setParams({"lstOfAcc": data});
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state == 'SUCCESS'){
                    //console.log("state success : " + JSON.stringify(response.getReturnValue()));
                    helper.reflectNewData(component, response.getReturnValue())
                }
                else{
                    alert("state error : " + JSON.stringify(response.getError()));
                }
            })
            $A.enqueueAction(action);                   
        }                       
    }
})