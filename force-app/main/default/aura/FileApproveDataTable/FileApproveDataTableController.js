({
	doInit: function(component, event, helper){
		helper.setHeaderIcon(component, event);
		helper.unWrapData(component, event);      	
	},	

	onCheck: function(component, event, helper){       

		if(component.get('v.isAllSelected') == false) {
	    	component.set('v.isAllSelected', true);
	    }
	    else{
	    	component.set('v.isAllSelected', false);	
	    }
    	const myCheckboxes = component.find('checkbox'); 
	    let chk = (myCheckboxes.length == null) ? [myCheckboxes] : myCheckboxes;        
	    chk.forEach(checkbox => checkbox.set('v.checked', component.get('v.isAllSelected')));	        
        //console.log("myCheckboxes : " + JSON.stringify(component.get("v.showData")));
        var lstOfRec = component.get("v.showData");
        var lstOfSelectedIndex = component.get("v.checkboxIndex");
        
        //console.log("all : " + JSON.stringify(lstOfSelectedIndex));

        //var saveSelectedRec = component.get("v.selectedCheckboxList");
        //console.log("before save : " + JSON.stringify(saveSelectedRec) + ' len : ' + saveSelectedRec.length);

        var selectedRec = [];
        
        for(var i = 0; i<lstOfRec.length; i++){            

            if(!lstOfSelectedIndex.includes(lstOfRec[i].index)){
                lstOfSelectedIndex.push(lstOfRec[i].index);    
                //console.log("showData : " + JSON.stringify(lstOfRec[i]))                                                                           
            }                        
        }
                
        //console.log('length : ' + lstOfSelectedIndex.length);
        component.set("v.checkboxIndex", lstOfSelectedIndex);
        component.set("v.selectedCheckboxList")
	},

	
    getSelectedCheckbox: function(component, event, header){

       	var capturedCheckboxName = event.getSource().get("v.value");     	     	      

       	var selectedCheckBoxes =  component.get("v.selectedCheckboxList");
  	    var indexVal = component.get("v.checkboxIndex");        

        if(!indexVal.includes(capturedCheckboxName.index) ){         
          indexVal.push(capturedCheckboxName.index);
        }
        else{  
          var index = indexVal.indexOf(capturedCheckboxName.index);          
          indexVal.splice(index, 1);
         
        }

  	    if(selectedCheckBoxes.indexOf(capturedCheckboxName) > -1){                        
    	      selectedCheckBoxes.splice(selectedCheckBoxes.indexOf(capturedCheckboxName), 1);             
  	    }
  	    else{	    		    	
  	        selectedCheckBoxes.push(capturedCheckboxName);	                   
  	    }                

  	    component.set("v.selectedCheckboxList", selectedCheckBoxes)	
        //console.log("get : " + JSON.stringify(component.get("v.selectedCheckboxList")));
        component.set("v.checkboxIndex", indexVal);
	  },

  	saveRecords: function(component, event, helper){
          var rec = component.get("v.selectedCheckboxList")          
          var selectedData = [];

        	for(var i=0; i<rec.length; i++){      		      		        		
        		selectedData.push((Object.values(rec[i])).toString());  	      		      		
        	}      	

        	var action = component.get("c.saveRecord");   		      		
        	action.setParams({
        		"lstOfData": selectedData
        	});

        	action.setCallback(this, function(response){
        		  var state = response.getState();        		
        	})

        	$A.enqueueAction(action);

    },

    showSearchModal: function(component, event, helper){   
      	var icon = event.getSource().getLocalId();
      	var headerVal = event.target.id;    
      
        //console.log("icon : " + icon);
      
      	if(icon == 'utility:search'){
      		helper.showModal(component, event);
      	}
      	else{  			
  			   helper.handleRemoveSearch(component, event, headerVal);
      	}
   	
    },    

    itemsChange: function(component, event, helper){    	
    	 helper.unWrapData(component, event);
    },

    changeIcon: function(component, event, helper){
      	var getIcon = component.get("v.changeIcon");
      	var icn = component.get("v.filterHeader");    	
      	icn.push(getIcon);    	
      	component.set("v.filterHeader", icn);    	
    },    
   
})