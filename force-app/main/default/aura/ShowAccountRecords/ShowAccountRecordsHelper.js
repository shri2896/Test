({
    delRecord: function(component, rId){ 
        
        var action = component.get("c.deleteRec");          
        action.setParams({"recId": rId});
        
         action.setCallback(this, function(response){            
            var state = response.getState();                        
            if(state == "SUCCESS"){                             
                var event = component.getEvent("updatedData");                
                event.setParams({"updatedData": response.getReturnValue()});
				event.fire();                
            }
            else{
                console.log(JSON.stringify(response.getError()));                                               
            }
        });   
        
        $A.enqueueAction(action);
    },
    
    editRecord: function(component, recId){
        
        $A.createComponent('c:EditRecord', {
            'headerText': 'Edit Record',
            'SelectedRecord': recId
        },
		function(modalComponent, status, errorMessage){         
            if(status == 'SUCCESS'){               
                var body = component.find('showEditRecordModel').get("v.body")
                body.push(modalComponent)
                component.find('showEditRecordModel').set("v.body", body);                
            }                     
            else if(status === 'INCOMPLETE'){
                console.log('Server or client is offline')
            }
           else{
               console.log('error in edit model of lightning bar : ' + status )         
           }
        })
              
    },
    
    
     openModel: function(component, event, helper){  
        
        $A.createComponent('c:CreateNewAccountRecord',{     
            'headerText' : 'Create New Account Record'
       	 },
        function(modalComponent, status, errorMessage){
            if(status == 'SUCCESS'){
                var body = component.find('showChildModal').get("v.body")    
                body.push(modalComponent)
                component.find('showChildModal' ).set("v.body", body);
            }
            else if (status === "INCOMPLETE") {
                console.log('Server issue or client is offline.');
            } 
            else if (status === "ERROR") {
          	  console.log('error');
            }
        })    
    },
    

})