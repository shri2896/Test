({
    doInit: function(component, event, helper){

        component.set('v.colName', [
        {label: 'Contact Name', fieldName: 'Name', type: 'text'}]);
  
        var accLst = component.get("v.AccountList");    
        if(accLst.length == 0){
            alert('No contact record found...!!!');
        }
        else{
            var lstOfContact = [];
            
            for(var i=0; i<accLst.length; i++){
                var cont = accLst[i].Contacts;           
                for(var i=0; i< cont.length; i++){                
                    lstOfContact.push(cont[i]);
                }
            }               
            component.set("v.contacts", lstOfContact)        
        }
    },
    
	close : function(component, event, helper) {
		component.destroy();
	},
    
    createRecord: function(component, event, helper){
        var contLst = component.get('v.contacts');
        var accId = contLst[0].AccountId;
        
        console.log("Account id  : " + JSON.stringify(accId))
        
        $A.createComponent('c:NewContactRecordComponent',{
                           'headerText': 'Create new record',
            				'accountId': accId,
        },
       function(modalComponent, status, errorMessage){           
           if(status == 'SUCCESS'){
           	   var body = component.find('createRecord').get("v.body", body); 
               body.push(modalComponent);
               component.find("createRecord").set("v.body", body);
               //helper.updateContactList(modalComponent);
           }
           else{
               alert("error : " + errorMessage);    
           }
       })//create component
    },
    
    updateContactList: function(component, event, helper){
        var lstOfContact = event.getParam("updateContactList");        
        component.set("v.contacts", lstOfContact);
    },
    
    getSelectedRow: function(component, event, helper){        
        var selectedRows = event.getParam('selectedRows');
        var oldData = component.get("v.oldData");                
       
        while(oldData.length){
            oldData.pop();    
        }
            
        for (var i = 0; i < selectedRows.length; i++){
            oldData.push(selectedRows[i].Id);    
        }
    
        for(var i=0; i<oldData.length; i++){
            console.log(oldData[i]);
        }
            
        component.set("v.oldData", oldData);
        
    },
    
    deleteContact: function(component, event, helper){
        var delRec = [];
       delRec = component.get("v.oldData");
  
        console.log('Del Rec : ' + JSON.stringify(delRec));
        
        var action = component.get("c.deleteRecord");
        
        action.setParams({"rec": delRec});
        console.log('Del Rec : ' + JSON.stringify(delRec));
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state: ' + state + ' error is : ' + JSON.stringify(response.getError()));
            if(state == 'SUCCESS'){
                var result = response.getReturnValue();
                if(result == null){
                    alert('Select at least one checkbox')
                }
                else{
                	helper.updateContactList(component, result);   
                }                
            }
            else{
                alert("error in delete ContactRecordModelController : " + JSON.stringify(response.getError()));
            }
        })
        
        $A.enqueueAction(action);
    }
})