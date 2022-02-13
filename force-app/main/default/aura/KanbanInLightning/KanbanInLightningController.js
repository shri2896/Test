({
	doInit : function(component, event, helper) {		
		helper.getAccountRecordsHelper(component, event);
	},

	allowDrop: function(component, event, helper) {
        //to allow an item to drop to other item.
        event.preventDefault();
    },
    
    drag: function (component, event, helper) {
    	
    	//Set the draggable data)
        event.dataTransfer.setData("text", event.target.id);						

        //check on which list is clicked from both list.
        var list = event.target.getAttribute("data-produto");  
        component.set('v.listName', list);       

        //get current dragge item's index 
        var index = event.currentTarget.value
        
        //set current drag item index in the attribute

        component.set('v.dragElement', index);

    },	
    
    drop: function (component, event, helper) {
       
       //to allow an item to drop to other item.
        event.preventDefault();        
        //Get the dragged data
        var data = event.dataTransfer.getData("text");        
        var index = event.currentTarget.value
        var list = component.get('v.listName');        
        var tar = event.target;         
        var listName = component.get('v.listName');

        //if user click on list1
        if(listName == 'list1'){        	
        	//get the drop place of the item. if drag and drop event in the same list than it will return the same drag and drop list string 'list1'.        	
        	var dropPlace = event.currentTarget.className        	
        	var setDragData = component.get('v.AccountsSourceList');
        	
        	for(var i = 0; i < setDragData.length; i++){        		
        		if(data == setDragData[i].Id){
        			component.set('v.dragData', setDragData[i]);
        			break;
        		}
        	}

        	if(dropPlace.includes('list1')){
        		var status = helper.isItemSelected(component, event, 1);        		
        		var selectedData = component.get('v.SelectedData');
        		if(status == true && selectedData.length > 1){
        			var dropIndex = event.target.dataset.dragId;
        			helper.setData(component, event, dropIndex, 1);
        		}
        		else{
	        		var dropIndex = event.target.dataset.dragId;

	        		//if drag and drop event in same list than it will sort data according to put the other element
	        		if(dropIndex != undefined && dropIndex != null && dropIndex != ''){	        			
	        			var listOfData = component.get('v.AccountsSourceList');
	        			var dragElementIndex = component.get('v.dragElement');

	        			//sort data when user drag an element and drop in same list and interchange their place.
	        			if(dragElementIndex != dropIndex){
		        			var updatedData = helper.sortData(component, event, listOfData, dragElementIndex, dropIndex)        			
		        			component.set('v.AccountsSourceList', updatedData);
		        		}
	        		}
	        		else{
	        			console.log('invalid index : ');
	        		}
	        	}

        	}
        	else{     
        		//if user put element in other list.        		

	        	var newData = component.get('v.AccountsSourceList');
	        	var list2 = component.get('v.AccountsDestinationList');

		        for(var i = 0; i < newData.length; i++){
		        	if(newData[i].isSelected){
		        		//set data for list2
		        		list2.push({'Id': newData[i].Id, 'Name': newData[i].Name, 'isSelected' : false, 'AccountNumber': newData[i].AccountNumber, 'Industry': newData[i].Industry})
		        		//remove element from current list.
		        		newData.splice(i, 1);
		        		i--;
		        	}        	
		        }

		        if(list2.length == null){	        	
			        component.set('v.AccountsDestinationList', list2);
			        component.set('v.AccountsSourceList',  newData);
			    }
			    else{
			    	for(var i = 0; i < newData.length; i++){
			        	if(newData[i].Id == data){
			        		//list2.push(newData[i]);
			        		list2.push({'Id': newData[i].Id, 'Name': newData[i].Name, 'isSelected' : false, 'AccountNumber': newData[i].AccountNumber, 'Industry': newData[i].Industry})
			        		newData.splice(i, 1);
			        		i--;
			        	}        	
		        	}	

		        	component.set('v.AccountsDestinationList', list2);
			        component.set('v.AccountsSourceList', newData);

			    }	        	
	        }
        }
        else if(listName == 'list2'){

        	var setDragData = component.get('v.AccountsDestinationList');
        	
        	for(var i = 0; i < setDragData.length; i++){        		
        		if(data == setDragData[i].Id){
        			component.set('v.dragData', setDragData[i]);
        			break;
        		}
        	}

        	//Get the current class Name where item is dropped
        	var dropPlace = event.currentTarget.className
        	
        	//if user drag data from list2 and drop in same list.
        	if(dropPlace.includes('list2')){   

        		var status = helper.isItemSelected(component, event, 2);
        		var selectedData = component.get('v.SelectedData');

        		if(status == true && selectedData.length > 1){
        			var dropIndex = event.target.dataset.dragId;
        			helper.setData(component, event, dropIndex, 2);
        		}
        		else{        		     		
					var dropIndex = event.target.dataset.dragId;

	        		//drop index must be not euqals to null
	        		if(dropIndex != undefined && dropIndex != null && dropIndex != ''){
	        			var listOfData = component.get('v.AccountsDestinationList');
	        			var dragElementIndex = component.get('v.dragElement');

	        			//send data for interchange the position of the drag & drop element.
	        			if(dragElementIndex == dropIndex){

	        			}
	        			else{
		        			var updatedData = helper.sortData(component, event, listOfData, dragElementIndex, dropIndex)
		        			component.set('v.AccountsDestinationList', updatedData);
		        		}
	        		}
	        		else{
	        			console.log('invalid index : ');
	        		}
	        	}
        	}
        	else{        		
	        	
	        	var list2 = component.get('v.AccountsSourceList');
	        	var newData = component.get('v.AccountsDestinationList');
	        	
		        for(var i = 0; i < newData.length; i++){
		        	if(newData[i].isSelected){		        		
		        		list2.push({'Id': newData[i].Id, 'Name': newData[i].Name, 'isSelected' : false, 'AccountNumber': newData[i].AccountNumber, 'Industry': newData[i].Industry})
		        		newData.splice(i, 1);
		        		i--;
		        	}        	
		        }		        

		        if(list2.length == null){
			        component.set('v.AccountsSourceList', list2);
			        component.set('v.AccountsDestinationList',  newData);
			    }
			    else{
			    	for(var i = 0; i < newData.length; i++){
			        	if(newData[i].Id == data){
			        		//list2.push(newData[i]);
			        		list2.push({'Id': newData[i].Id, 'Name': newData[i].Name, 'isSelected' : false, 'AccountNumber': newData[i].AccountNumber, 'Industry': newData[i].Industry})
			        		newData.splice(i, 1);
			        		i--;
			        	}        	
		        	}	

		        	component.set('v.AccountsSourceList', list2);
			        component.set('v.AccountsDestinationList', newData);
			    }	        	
	        }
        }
                       
    },

    //when user click on any list item than it will change the background color of the selected item
    itemSelected: function(component, event, helper){        	
    	if(event.ctrlKey){
    		helper.changeSelectedRowColor(component, event, 1);
    	}
    	else if(event.shiftKey){
    		helper.changeSelectedRowColor(component, event, 2);
    	}
    	else{
    		helper.changeSelectedRowColor(component, event, 3);
    	}       
    },    

    //show second list data in the table
    showData: function(component, event, helper){       	 	
    	helper.showSelectedDataHelper(component, event);
    },        
})