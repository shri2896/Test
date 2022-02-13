({
   
    editDelete: function(component, event, helper) {
        var btnSelected = event.getParam("value").split(',')
        var recId = btnSelected[0];
        var btnType = btnSelected[1];              
        
        if(btnType == 'edit'){        
            
            var action = component.get("c.editRecord");               
            action.setParams({"recId": recId})
            
            action.setCallback(this, function(response){
                var state = response.getState();                  
                if(state === 'SUCCESS'){                  
                    var result = response.getReturnValue();
                    console.log('Data : ' + JSON.stringify(result));
                    helper.editRecord(component, result);    
                }
                else{
                    console.log("in edit record : " + JSON.stringify(response.getError()))
                }
            })
            $A.enqueueAction(action);
                               
        }
        else if(btnType == 'delete'){
            helper.delRecord(component, recId);                                    
        }
        else if(btnType == 'contact'){                    	
			var action = component.get("c.showRelatedRecord");
            action.setParams({"recId": recId});        
            action.setCallback(this, function(response){            
                var state = response.getState();
                console.log('state : ' + state );                   
                
                if(state == 'SUCCESS'){
                    $A.createComponent('c:ContactRecordModel',{
            			'headerText' : 'Contacts Records',
                        'AccountList': response.getReturnValue(),
                    },
                    function(modalComponent, status, errorMessage){
                        if(status == 'SUCCESS'){
                            var body = component.find('ContactRecords').get("v.body")
                            body.push(modalComponent);                    
                            component.find('ContactRecords').set("v.body", body)                    
                            //helper.showRelateContact(component, recId);                    
                        }
                        else{
                            alert("Error in open model of contact records showAccountcontroller : " + errorMessage)
                        }
                    })  
                }
                else{
                    console.log('error in showAccountRecordsController : ' + JSON.stringify(response.getError()))
                }
            })
            
            $A.enqueueAction(action);
        }
    }
})