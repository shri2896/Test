({
	 getAccountList: function(component, pageNumber, pageSize) {
	 	var action = component.get("c.getAccount");   
	 	//console.log("pg : " + pageNumber + ' : ' + pageSize)
        action.setParams({ "pNumber": pageNumber,
                            "pSize": pageSize
                        })     
            action.setCallback(this, function(response){            
            var state = response.getState();        
            if(state == 'SUCCESS'){   
               var result = response.getReturnValue();               
                component.set("v.rec", result.records);
                component.set("v.PageNumber", result.pageNumber);
                //temp is use for maintain first and previous button disable conssistence
                component.set("v.temp", result.pageNumber);	
                component.set("v.TotalRecords", result.totalRecords);
                component.set("v.RecordStart", result.recordStart);
                component.set("v.RecordEnd", result.recordEnd);
                component.set("v.TotalPages", Math.ceil(result.totalRecords / pageSize))
                

            }
            else{
                console.log("error : " + JSON.stringify(response.getError()))
            }
        });   
        $A.enqueueAction(action);
     
	 }
})