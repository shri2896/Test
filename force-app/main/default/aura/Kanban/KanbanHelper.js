({
	updatePickVal : function(component, recId, pField, pVal) {               
		var action = component.get("c.getUpdateStage");
        action.setParams({
            "recId":recId,
            "FieldName":pField,
            "dragValue":pVal
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            //console.log("state : " + state + ' : ' + JSON.stringify(response.getError()))
            if (state === "SUCCESS") {
                //alert("Record update successfully");                
                
            }
            else{
                alert("Error in updation : " + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
	},
    
    setCountOfChild: function(component, recWrapper){       
        var pickList = recWrapper.pickVals;
        var rec = recWrapper.records;        
        var lstOfObj = [];
        
        for(var i=0; i<pickList.length; i++){
            var obj = new Object();
            var count = 0;
            for(var j=0; j<rec.length; j++) {                         
                if(pickList[i] == rec[j].Industry){
                    count++;
                }                                                                                    
            }    
            obj.Industry = pickList[i];
            obj.count = count;
            //console.log(":data : " + JSON.stringify(obj))
            lstOfObj.push(obj)
            count = 0;                                                                
        }                              
        component.set("v.countOfChild", lstOfObj);        	  
    },
    
    updateCountOfChild: function(component){
               
        var action = component.get("c.getKanbanWrap");
        action.setParams({  "objName":component.get("v.objName"),
                            "flds": component.get("v.objFields"),
                            "kanbanField": component.get("v.kanbanPicklistField")
                         })
        
        action.setCallback(this, function(response){
            var state = response.getState();
            //console.log("state : " + state + ' ER : ' + JSON.stringify(response.getError()));
            if(state == 'SUCCESS'){
                //console.log('Data : ' + JSON.stringify(response.getReturnValue()))
                var recWraper = response.getReturnValue();
                var pickLst = recWraper.pickVals;
                var rec = recWraper.records;
                //console.log('Data : ' + JSON.stringify(pickLst))

                var lstOfObj = [];
        
                for(var i=0; i<pickLst.length; i++){
                    var obj = new Object();
                    var count = 0;
                    for(var j=0; j<rec.length; j++) {                         
                        if(pickLst[i] == rec[j].Industry){
                            count++;
                        }                                                                                    
                    }    
                    obj.Industry = pickLst[i];
                    obj.count = count;
                    //console.log(":data : " + JSON.stringify(obj))
                    lstOfObj.push(obj)
                    count = 0;                                                               
                }                              
                component.set("v.countOfChild", lstOfObj);
                component.set("v.kanbanData", response.getReturnValue());
                //console.log('Data : ' + JSON.stringify(lstOfObj))    
                

            }
            else{
                console.log("Error in updateCountOfChild : " + JSON.stringify(response.getError()));
            }
        })
        $A.enqueueAction(action);
    }
})