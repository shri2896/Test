({
	getObjectList: function(component, event){
        var action = component.get("c.getSobjectList");
        
        action.setCallback(this, function(response){
            var state = response.getState();        		
            //console.log("state : " + state + ' : err : ' )
            
            var state = response.getState();            	  		
            
            if (state === "SUCCESS") {             	
                var returnVal = response.getReturnValue();            	            	
                
                var lst = [];            	
                for(var i = 0; i<returnVal.length; i++){
                    var obj = new Object();
                    obj.label = returnVal[i].label;
                    obj.name = returnVal[i].name;
                    lst.push(obj);                  		            		
                }
                
                component.set("v.sObject", lst)
            }
        })
        $A.enqueueAction(action);
    },

    getRecords: function(component, event){		
        var action = component.get("c.getObjectRecords"); 
        action.setCallback(this, function(response){
            var state = response.getState();
            //console.log("state : " + state + ' error : ');
            var lstOfRec = [];
            if(state === 'SUCCESS'){
                var data = response.getReturnValue();
                //console.log("panel data : " + JSON.stringify(data));
                
                for(var i = 0; i < data.length; i++){
                    lstOfRec.push(data[i].recordName);
                    //console.log("loop : " + data[i].recordName);
                }
                
                component.set("v.listViewRecords", lstOfRec);
            }
            
        })
        
        $A.enqueueAction(action);
    },

    getObject : function(component, event) {
        var obj = component.find("object").get("v.value");		
        //console.log("obj : " + JSON.stringify(obj));		        

        var action = component.get("c.getFields");
        action.setParams({"selectedObj": obj});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            //console.log("fields response : " + state );
            
            if(state === 'SUCCESS'){
                var lst = [];
                
                var fields = response.getReturnValue();
                
                for(var i = 0; i < fields.length; i++){							
                    var obj = new Object();
                    obj.label = fields[i].label;															
                    obj.name = fields[i].name;											
                    lst.push(obj);												
                    
                }
                
                console.log("flds : " + JSON.stringify(lst));
                component.set("v.allFileds", lst);	
                var col = component.find("columnVal").get('v.value');                 
                //this.changeColumn(component, event);
            }
        })
        $A.enqueueAction(action);
        	
    },

     changeColumn : function(component, event){    	
        var fields = component.get("v.allFileds");        
        var col = component.find("columnVal").get('v.value');
        var lst = [];        
		
		//Change Column
		var countCol = [];
		for( var count=0; count<col; count++ ) {
			countCol.push(count);
		}
		component.set('v.displayColumn', countCol);

        for(var i = 0; i<col; i++)
        {                             
        	var obj = new Object();      	            	
            if(i == 0 ){                	
            	obj.picklist0 = fields;                  	                  	
            }
            else if(i == 1){
                obj.picklist1 = fields;
            }
            else{
                obj.picklist2 = fields;
            }                          		
            lst.push(obj);
    		                           
        }                        
        console.log("obj data = : "  + JSON.stringify(lst));				
        component.set("v.allFieldsData", lst);                  


    },
    
    
})