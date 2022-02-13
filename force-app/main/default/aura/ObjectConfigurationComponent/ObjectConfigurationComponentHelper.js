({
    getObject : function(component, event) {
        var obj = component.find("object").get("v.value");		
        console.log("obj : " + JSON.stringify(obj));		                

        var action = component.get("c.getFields");   	    	
        
        action.setParams({"selectedObj": obj});                
        
        action.setCallback(this, function(response){
            var state = response.getState();            
            console.log('satae : ' + state)
            if(state === 'SUCCESS'){
                var lst = [];                

                var fields = response.getReturnValue();
                
                for(var i = 0; i < fields.length; i++){							
                    var obj = new Object();
                    obj.label = fields[i].label;															
                    obj.name = fields[i].name;	
                    obj.fieldDataType = fields[i].fieldDataType										
                    lst.push(obj);	                    
                }                             
                component.set("v.allFileds", lst);	
                //console.log("fields : " + JSON.stringify(component.get("v.allFileds")))
                this.changeColumn(component, event);
                //console.log("fields : " + JSON.stringify(component.get("v.allFileds")))
                //var col = component.find("columnVal").get('v.value');                                 
            }
        })        

        $A.enqueueAction(action);
    },

    
    changeColumn: function(component, event){    	    	

    	var fields = component.get("v.allFileds");
        var col = component.find("columnVal").get('v.value'); 
        var allFieldsData = component.get('v.allFieldsData');

        console.log("allFieldsData : " + JSON.stringify(allFieldsData));
        //console.log("col : " + col + ' allFieldsData.length : ' + allFieldsData.length);

        if(col >= allFieldsData.length){        	
            for(var i = allFieldsData.length; i < col; i++)
            {            	

                var lst = [];
                lst.push({"value":fields[0].name, "isFirst":true, "duplicateValue": false, "fieldDataType": fields[0].fieldDataType});
                //console.log('value : ' + JSON.stringify(lst));
                allFieldsData.push(lst);
            }
        }
        else{        	

            for(var i = allFieldsData.length; i > col; i--)
            {            	
            	//console.log(' i : ' + i)
                allFieldsData.pop();
            }
        }
        
        console.log('chng coloumn : ' + JSON.stringify(allFieldsData));
        component.set("v.allFieldsData", allFieldsData);       
		
    },
    
    addField: function(component, event){        

    	var key = event.getSource().get("v.value");

        var fields = component.get("v.allFileds");
        var allFieldsData = component.get("v.allFieldsData");         
        
        var fieldsLst = allFieldsData[key];
                
        //console.log('fieldsLst : ' + JSON.stringify(fieldsLst));

        fieldsLst.push({"value":fields[0].name, "isFirst":false, "duplicateValue": false, "fieldDataType": fields[0].fieldDataType});
        
        //console.log('fieldsLst after push : ' + JSON.stringify(fieldsLst));
        
        allFieldsData[key] = fieldsLst;
        
        component.set("v.allFieldsData", allFieldsData);

        console.log('key : ' + key + ' : allFieldsData : ' + JSON.stringify(allFieldsData));
       
    },

    subtractFieldHelper: function(component, event){        
        var keys = event.getSource().get("v.value").split('___');
        
        //console.log('key : ' + keys);

        var fields = component.get("v.allFileds");
        var allFieldsData = component.get("v.allFieldsData");
        var fieldsLst = allFieldsData[keys[0]];
        
        fieldsLst.splice(keys[1],1)

        allFieldsData[keys[0]] = fieldsLst;
        
        //console.log('allFieldsData[keys[0]] : ' + JSON.stringify(allFieldsData[keys[0]]));
        
        component.set("v.allFieldsData", allFieldsData);
    },
    
    
   
    saveRecordHelper: function(component, event){
        var recordName = component.get("v.recordName");        
        
        if(recordName != null && recordName != '' && recordName != ' '){
   			
   			var status = this.checkValidition(component, event);

   			console.log('status : ' + status);
   			if(status == true){

	   			console.log('status : ' + status);

	            var selectedObj = component.find("object").get("v.value");
	            var column = component.find('columnVal').get('v.value');
	            var recordList = component.get("v.allFieldsData");	            
	            var converInString = JSON.stringify(recordList);
				
				console.log('converInString : ' + JSON.stringify(converInString));

	            var action = component.get("c.saveRecordInObject");
	            action.setParams({"obj":selectedObj,
	                              "lstOfFields": converInString,
	                              "recName": recordName,
	                          	  "column": column});
	            
	            action.setCallback(this, function(response){
	                var state = response.getState();
	                
	                //console.log("State : " + state + ' error : ');
	                if(state == 'SUCCESS'){
	                	component.find('columnVal').set('v.value',1);
	                	component.find('object').set('v.value','');
	                	component.set('v.recordName','');
	                	component.set('v.allFieldsData', []);
	                }
	            })
	            
	            $A.enqueueAction(action);
	        }

	        else{
	        	//console.log('duplicate key found');
	        }
        }
        else{
            alert("Invalid record name");
        }

    },

    checkValidition: function(component, event){    	

    	var selectedFields = component.get("v.allFieldsData");    	    	
    	var status = false;    	

    	var columnSize = component.find("columnVal").get('v.value'); 
    	var listOfduplicateItems = [];    	

    	for(var i = 0; i < selectedFields.length; i++){
    		var obj = selectedFields[i];
    		//console.log('obj.length : ' + obj.length);
    		var listOfRowIndex = [];

    		if(obj.length > 1){
	    		for(var j = 0; j < obj.length; j++){
	    			var innerElement = obj[j];

	    			for(var k = j + 1; k < obj.length; k++){
	    				var element = obj[k];
	    				//console.log('element : ' + JSON.stringify(element) + ' == ' + JSON.stringify(innerElement));
	    				if(element.value == innerElement.value){	    					

	    					if(!listOfRowIndex.includes(j)){
		    					listOfRowIndex.push(j);		    					
		    				}
		    				if(!listOfRowIndex.includes(k)){
	    						listOfRowIndex.push(k);
	    					}
	    				}
	    			}	    			

	    		}
	    	}

	    	listOfduplicateItems.push(listOfRowIndex)
	    	
    	}

    	console.log('listOfduplicateItems : ' + JSON.stringify(listOfduplicateItems));
    	if(status == false && columnSize > 0){    		

    		for(var i = 0; i < selectedFields.length; i++){
    			var searchElementList = selectedFields[i];    			

    			for(var j = 0; j < searchElementList.length; j++){
    				var list1IncludeItem = false;
    				var list2IncludeItem = false;

    				var searchElement = searchElementList[j];
    				
    				for(var k = i+1; k < columnSize; k++){
    					var searchList = selectedFields[k];
    					
    					for(var l = 0; l < searchList.length; l++){
							var singleRecordOfList = searchList[l];														
							
							if(singleRecordOfList.value == searchElement.value){								
								status = true;
								listOfduplicateItems.filter(function(obj, indexVar){									
									if(indexVar == i){
										obj.filter(function(itm, index){																						
											if(index == j){
												if(listOfduplicateItems[i].includes(j)){													
													list1IncludeItem = true;											
												}
											}
										})										
									}

									if(indexVar == k){
										obj.filter(function(obj, index){
											if(index == l){
												if(listOfduplicateItems[k].includes(l)){													
													list2IncludeItem = true;
												}
											}
										})
									}
								})

								if(!list1IncludeItem){
									listOfduplicateItems[i].push(j);									
								}

								if(!list2IncludeItem){									
									listOfduplicateItems[k].push(l);									
								}
							}
    					}
    					
    				}    				
    			}    			
    		}

    		console.log('all duplicate items : ' + JSON.stringify(listOfduplicateItems));
    	}    
    	
    	if(status == false)	{        		
    		return true;    		
    	}
    	else{
    		this.showErrorMessageOnDupliactedFieldSelection(component, event, listOfduplicateItems);
    		return false;
    	}

    },

    showErrorMessageOnDupliactedFieldSelection: function(component, event, listOfduplicateItems){  	
    	    	        	                       
		var listOfData = component.get('v.allFieldsData');		
		var dataList = [];		

        for(var i = 0; i < listOfData.length; i++){
        	var outerList = listOfData[i];
        	var lst = [];        	
        	
        	for(var j = 0; j < outerList.length; j++){
        		var singleRecord = outerList[j];
        		console.log('singleRecord in error : ' + JSON.stringify(singleRecord));
        		var isElementExists = false;
        		
        		listOfduplicateItems.filter(function(obj, indexVar){    			        			    			   				
        			if(indexVar == i){
	        			obj.filter(function(listItem, index){	        					        			
	        				if(listItem == j){	        					        						
        						isElementExists = true;        						        					
	        				}
	        			})
	        		}
	        		
        		})	

        		if(isElementExists){        			        			
        			lst.push({"value":singleRecord.value, "duplicateValue": true, 'fieldDataType': singleRecord.fieldDataType});        			
        		}
        		else{        			        			
        			lst.push({"value":singleRecord.value, "duplicateValue": false, 'fieldDataType': singleRecord.fieldDataType});        			
        		}
        	}        	
        	dataList.push(lst);
        }        
        component.set("v.allFieldsData", dataList);       
        
    },
    
    

    getRecords: function(component, event){		
        var action = component.get("c.getObjectRecords"); 
        action.setCallback(this, function(response){
            var state = response.getState();
            //console.log("state in getRecords : " + state + ' error : ');
            var lstOfRec = [];
            if(state === 'SUCCESS'){
                var data = response.getReturnValue();
                //console.log("panel data : " + JSON.stringify(data));
                
                for(var i = 0; i < data.length; i++){                	
                    lstOfRec.push(data[i]);                   	
                }
                
                component.set("v.listViewRecords", lstOfRec);
            }
            
        })
        
        $A.enqueueAction(action);
    },
    
    getObjectList: function(component, event){
        var action = component.get("c.getSobjectList");
        
        action.setCallback(this, function(response){
            var state = response.getState();        		
            console.log("state : " + state + ' : err######## : ' )            
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
    
    getSelectedRecordHelper: function(component, event){    	    	        	
    	var selectedRecData = event.target.name;    	    
    	var fields = event.target.value;        	    	    	
    	var obj = JSON.parse(fields);    	
    	var objectName = selectedRecData.split(',');    	

    	var listOfRecords = [];
    	for(var i = 0; i < obj.length; i++){
    		var innerListData = obj[i];
    		var lst = [];
    		
    		for(var j = 0; j < innerListData.length; j++){    			    			
    			lst.push({"value":innerListData[j].value, "isFirst":innerListData[j].isFirst, "duplicateValue": false});
    		}     	
    		listOfRecords.push(lst);
    	}

    	console.log('list : ' + JSON.stringify(listOfRecords));
        var action = component.get("c.getFields");   	    	        
        action.setParams({"selectedObj": objectName[2]});                        
        
        action.setCallback(this, function(response){
        	console.log('action');
            var state = response.getState();                        

            if(state === 'SUCCESS'){
                var lst1 = [];                

                var fields = response.getReturnValue();
                
                for(var i = 0; i < fields.length; i++){							
                    var obj = new Object();
                    obj.label = fields[i].label;															
                    obj.name = fields[i].name;
                    lst1.push(obj);	                    
                }                                               
                component.set("v.allFileds", lst1);	                
                component.set('v.recordName', objectName[1]);  /*Set record name in text box*/  	
		    	component.set('v.allFieldsData', listOfRecords);
		    	component.find("columnVal").set("v.value", objectName[3]); /*Set column value in picklist*/
		    	component.find("object").set("v.value", objectName[2]); /*Set Object name in object picklist*/
                
            }
        })   

        $A.enqueueAction(action);         	
				
	}
})