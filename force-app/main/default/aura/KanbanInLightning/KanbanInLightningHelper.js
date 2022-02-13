({
	getAccountRecordsHelper : function(component, event) {
		//Get all the account records
		var action = component.get('c.getAccountRecords');
		action.setCallback(this, function(response){
			var state = response.getState();
			if(state === 'SUCCESS'){				
				component.set('v.AccountsSourceList', response.getReturnValue())			
			}
			else{
				alert('Error : ' + JSON.stringify(response.getError()))
			}
		})
		$A.enqueueAction(action);
	},	

	changeSelectedRowColor: function(component, event, selectOption){

		if(selectOption == 1){		
			var index = event.currentTarget.value;
			var list = event.currentTarget.getAttribute("data-produto"); 		

			if(list == 'list1'){
				var listOfData = component.get('v.AccountsSourceList');		
				var returnValue = this.selectRecordUsingCtrl(component, event, listOfData, index);
				component.set('v.AccountsSourceList', returnValue );
			}
			else{						
				var listOfData = component.get('v.AccountsDestinationList');		
				var returnValue = this.selectRecordUsingCtrl(component, event, listOfData, index);

				component.set('v.AccountsDestinationList', returnValue );				
			}					
		}
		else if(selectOption == 2){
			var index = event.currentTarget.value;			
			var list = event.currentTarget.getAttribute("data-produto"); 		


			if(list == 'list1'){			
				var listOfData = component.get('v.AccountsSourceList');		
				var returnValue = this.selectRecordUsingShift(component, event, listOfData, index);

				component.set('v.AccountsSourceList', returnValue );
			}
			else{						
				var listOfData = component.get('v.AccountsDestinationList');		
				var returnValue = this.selectRecordUsingShift(component, event, listOfData, index);

				component.set('v.AccountsDestinationList', returnValue );
			}					
		}
		else if(selectOption == 3){
			var index = event.currentTarget.value;		
			component.set('v.selectedRecord', index);

			//Get the list no on which click. for ex. if user clicks on list one it returns list1 other wise list2			
			var list = event.currentTarget.getAttribute("data-produto"); 		

			if(list == 'list1'){			
				var listOfData = component.get('v.AccountsSourceList');		
				var returnValue = this.setColorOfRow(component, event, listOfData, index);

				component.set('v.AccountsSourceList', returnValue );
			}
			else{						
				var listOfData = component.get('v.AccountsDestinationList');		
				var returnValue = this.setColorOfRow(component, event, listOfData, index);

				component.set('v.AccountsDestinationList', returnValue );
			}				
		}
	},

	//Set background color of the selected row
	setColorOfRow : function(component, event, listOfData, index){		
		var updatedData = [];
		for(var i = 0; i < listOfData.length; i++){			
			if(i == index){				
				updatedData.push({'Id': listOfData[i].Id, 'Name': listOfData[i].Name, 'isSelected' : true, 'AccountNumber': listOfData[i].AccountNumber, 'Industry': listOfData[i].Industry});				
			}
			else{
				updatedData.push({'Id': listOfData[i].Id, 'Name': listOfData[i].Name, 'isSelected' : false, 'AccountNumber': listOfData[i].AccountNumber, 'Industry': listOfData[i].Industry});
			}
		}
		return updatedData;
	},

	showSelectedDataHelper : function(component, event){		
		var getSelectedData = component.get('v.AccountsDestinationList');		
		component.set('v.showSelectedData', getSelectedData);		
	},

	sortData: function(component, event, listOfData, dragElementIndex, dropIndex){

		var updatedData = [];
		var dragData;
		var dropData;

		//Get the drag and drop data in a variable
		for(var i = 0; i < listOfData.length; i++){			
			if(i == dragElementIndex){				
				dragData = listOfData[i];
			}
			else if(i == dropIndex){				
				dropData = listOfData[i];
			}
		}	

		//interchange the position of the drag and drop data.
		for(var i = 0; i < listOfData.length; i++){
			if(i == dragElementIndex){
				updatedData.push(dropData);
			}
			else if(i == dropIndex){
				updatedData.push(dragData);
			}
			else{
				updatedData.push(listOfData[i]);
			}
		}  
		
		return updatedData;      			
	},

	selectRecordUsingCtrl: function(component, event, listOfData, index){
		var updatedData = [];

		for(var i = 0; i < listOfData.length; i++){			
			if(i == index){								
				if(listOfData[i].isSelected == true){
					updatedData.push({'Id': listOfData[i].Id, 'Name': listOfData[i].Name, 'isSelected' : false, 'AccountNumber': listOfData[i].AccountNumber, 'Industry': listOfData[i].Industry});
				}
				else{
					updatedData.push({'Id': listOfData[i].Id, 'Name': listOfData[i].Name, 'isSelected' : true, 'AccountNumber': listOfData[i].AccountNumber, 'Industry': listOfData[i].Industry});
				}
			}
			else{
				updatedData.push({'Id': listOfData[i].Id, 'Name': listOfData[i].Name, 'isSelected' : listOfData[i].isSelected, 'AccountNumber': listOfData[i].AccountNumber, 'Industry': listOfData[i].Industry});
			}
		}

		return updatedData;
	},

	selectRecordUsingShift: function(component, event, listOfData, index){
		var startingIndex = component.get('v.selectedRecord');
		var updatedData = [];
		var count = 0;

		for(var i = 0; i < listOfData.length; i++){
			if(listOfData[i].isSelected){
				count++;
				break;
			}
		}

		if(count > 0){
			var endIndex;
			if(startingIndex > index){
				endIndex = startingIndex;
				startingIndex = index
			}
			else{
				endIndex = index;
			}		

			if(startingIndex != undefined && startingIndex != null){
				for(var i = 0; i < listOfData.length; i++){
					if(i >= startingIndex && i <= endIndex){
						updatedData.push({'Id': listOfData[i].Id, 'Name': listOfData[i].Name, 'isSelected' : true, 'AccountNumber': listOfData[i].AccountNumber, 'Industry': listOfData[i].Industry});
					}
					else{
						updatedData.push({'Id': listOfData[i].Id, 'Name': listOfData[i].Name, 'isSelected' : listOfData[i].false, 'AccountNumber': listOfData[i].AccountNumber, 'Industry': listOfData[i].Industry});
					}
				}
				return updatedData;
			}
			else{
				return listOfData
			}
		}
		else{
			updatedData = this.setColorOfRow(component, event, listOfData, Index);
			return updatedData;
		}
		
	},

	isItemSelected : function(component, event, list){
		if(list == 1){
			var listOfData = component.get('v.AccountsSourceList');
			var sDAta = [];
			var lastIndex;
			var includeIndex = [];

			for(var i = 0; i < listOfData.length; i++){
				if(listOfData[i].isSelected){
					sDAta.push(listOfData[i]);
					includeIndex.push(i);
					lastIndex = i;
				}
			}
			
			if(sDAta.length == null || sDAta.length == 0){
				return false;
			}
			else{				
				component.set('v.SelectedData', sDAta);
				component.set('v.lastIndex', lastIndex);
				component.set('v.includeIndex', includeIndex);				

				return true;
			}
		}
		else if(list == 2){
			var listOfData = component.get('v.AccountsDestinationList');
			var selectedData = [];
			var lastIndex;
			var includeIndex = [];

			for(var i = 0; i < listOfData.length; i++){
				if(listOfData[i].isSelected){
					selectedData.push(listOfData[i]);
					includeIndex.push(i);
					lastIndex = i;
				}
			}

			if(selectedData.length == null || selectedData.length == 0){
				return false;
			}
			else{
				component.set('v.SelectedData', selectedData);
				component.set('v.lastIndex', lastIndex);
				component.set('v.includeIndex', includeIndex);
				return true;
			}
		}
	},

	setData: function(component, event, dropIndex, list){
		var selectedData = component.get('v.SelectedData');
		var lastIndex = component.get('v.lastIndex');
		var dropData;
		var updatedData = [];
		
		if(dropIndex != undefined){			
			if(list == 1){					


				var listOfData = component.get('v.AccountsSourceList');			
				dropData = listOfData[dropIndex];		

				var status = this.checkDropDataExistsInSelectedRecordList(component, event, selectedData, dropData);
				
				if(!status){
					status = this.checkDragDataExistsInSelectedRecordList(component, event, selectedData);
					
					//if selected data is drag data
					if(status){
						var includeIndex = component.get('v.includeIndex');
						var lastSelectedValueIndex = includeIndex[includeIndex.length-1];

						if(dropIndex > lastSelectedValueIndex){

							var firstIndexOfSelectedItem = includeIndex[0]
							
							for(var i = 0; i < listOfData.length; i++){
								if(i == dropIndex){
									for(var j = 0; j < selectedData.length; j++){
										updatedData.push(selectedData[j]);
									}
								}
								else if(i == firstIndexOfSelectedItem){
									updatedData.push(dropData);
								}
								else{
									if(!includeIndex.includes(i)){
										updatedData.push(listOfData[i]);
									}
								}
							}	

							component.set('v.AccountsSourceList', updatedData);
						}
						else{

							for(var i = 0; i < listOfData.length; i++){
								if(i == dropIndex){
									for(var j = 0; j < selectedData.length; j++){
										updatedData.push(selectedData[j]);
									}
								}
								else if(i == lastSelectedValueIndex){
									updatedData.push(dropData);
								}
								else{
									if(!includeIndex.includes(i)){
										updatedData.push(listOfData[i]);
									}
								}
							}
						}
						
					}
					//don't need to change sequence of selected records bcz drag & drop data both are not include in selected list
					else{
						var dragData = component.get('v.dragData')
						for(var i = 0; i < listOfData.length; i++){
							if(dropData.Id == listOfData[i].Id){
								updatedData.push(dragData);
							}
							else if(listOfData[i].Id == dragData.Id){
								updatedData.push(dropData);
							}
							else{
								updatedData.push(listOfData[i]);
							}
						}
					}

					component.set('v.AccountsSourceList', updatedData);
				}
				else{					
					var result = this.setSecondListData(component, event, listOfData, firstIndexOfSelectedItem, selectedData, dropData, dropIndex);
					component.set('v.AccountsSourceList', result);
				}
				
			}
			else if(list == 2){
				var listOfData = component.get('v.AccountsDestinationList');
				dropData = listOfData[dropIndex];
				var status = this.checkDropDataExistsInSelectedRecordList(component, event, selectedData, dropData);				

				if(!status){
					status = this.checkDragDataExistsInSelectedRecordList(component, event, selectedData);
									
					//if selected data is drag data
					if(status){
						var includeIndex = component.get('v.includeIndex');
						var lastSelectedValueIndex = includeIndex[includeIndex.length-1];

						if(dropIndex > lastSelectedValueIndex){

							var firstIndexOfSelectedItem = includeIndex[0]
							
							for(var i = 0; i < listOfData.length; i++){
								if(i == dropIndex){
									for(var j = 0; j < selectedData.length; j++){
										updatedData.push(selectedData[j]);
									}
								}
								else if(i == firstIndexOfSelectedItem){
									updatedData.push(dropData);
								}
								else{
									if(!includeIndex.includes(i)){
										updatedData.push(listOfData[i]);
									}
								}
							}	

							component.set('v.AccountsDestinationList', updatedData);
						}
						else{

							for(var i = 0; i < listOfData.length; i++){
								if(i == dropIndex){
									for(var j = 0; j < selectedData.length; j++){
										updatedData.push(selectedData[j]);
									}
								}
								else if(i == lastSelectedValueIndex){
									updatedData.push(dropData);
								}
								else{
									if(!includeIndex.includes(i)){
										updatedData.push(listOfData[i]);
									}
								}
							}
						}
						
					}
					//don't need to change sequence of selected records bcz drag & drop data both are not include in selected list
					else{
						var dragData = component.get('v.dragData')
						for(var i = 0; i < listOfData.length; i++){
							if(dropData.Id == listOfData[i].Id){
								updatedData.push(dragData);
							}
							else if(listOfData[i].Id == dragData.Id){
								updatedData.push(dropData);
							}
							else{
								updatedData.push(listOfData[i]);
							}
						}
					}

					component.set('v.AccountsDestinationList', updatedData);
				}
				else{
					var result = this.setSecondListData(component, event, listOfData, firstIndexOfSelectedItem, selectedData, dropData, dropIndex);					
					component.set('v.AccountsDestinationList', result);
				}
			
			}
		}		
	},

	removeDuplicateRecords: function(component, event, recordList){	
		var seen = new Set();
		var filteredArr = recordList.filter(obj => {
			var duplicate = seen.has(obj.Id);
			seen.add(obj.Id);
			return !duplicate;
		});		
		return filteredArr;		
	},

	checkDropDataExistsInSelectedRecordList: function(component, event, recordList, dropPlace){
		//dropPlace where data was dropped.

		var status = false;				
		recordList.filter(function(obj){
			if(obj.Id == dropPlace.Id){
				status = true;
			}
		})

		return status;
	},

	checkDragDataExistsInSelectedRecordList: function(component, event, recordList){
		//Data which was dragged		
		var dropData = component.get('v.dragData');
		var status = false;

		recordList.filter(function(obj){
			if(obj.Id == dropData.Id){
				status = true;
			}
		})

		return status;	
	},

	setSecondListData : function(component, event, listOfData, firstIndexOfSelectedItem, selectedData, dropData, dropIndex){
		var includeIndex = component.get('v.includeIndex');
		var lastSelectedValueIndex = includeIndex[includeIndex.length-1];
		var updatedData = [];
		var dragItemIndex = component.get('v.dragElement');
		var dragData = listOfData[dragItemIndex]
		
		if(dropIndex > lastSelectedValueIndex){

			var firstIndexOfSelectedItem = includeIndex[0]
			

			for(var i = 0; i < listOfData.length; i++){
				if(i == dragItemIndex){
					for(var j = 0; j < selectedData.length; j++){
						updatedData.push(selectedData[j]);
					}
					i += selectedData.length;
				}
				else if(i == firstIndexOfSelectedItem){
					updatedData.push(dragData);
				}
				else{
					if(!includeIndex.includes(i)){
						updatedData.push(listOfData[i]);
					}
				}
			}	

			var result = this.removeDuplicateRecords(component, event, updatedData)
			return result;
		}
		else{			
			var lastIndex = includeIndex[includeIndex.length-1];

			if(dragItemIndex > dropIndex){
				for(var i = 0; i < listOfData.length; i++){
					if(i == dropIndex){
						updatedData.push(dragData)
					}
					else if(i == dragItemIndex){
						for(var j = 0; j < selectedData.length; j++){
							updatedData.push(selectedData[j]);
						}
					}
					else{
						if(!includeIndex.includes(i)){
							updatedData.push(listOfData[i]);
						}
					}
				}
			}
			else{
				for(var i = 0; i < listOfData.length; i++){

					if(i == lastIndex){
						updatedData.push(dragData)
					}
					else if(i == dragItemIndex){
						for(var j = 0; j < selectedData.length; j++){
							updatedData.push(selectedData[j]);
						}
					}
					else{
						if(!includeIndex.includes(i)){
							updatedData.push(listOfData[i]);
						}
					}
				}
			}
			var result = this.removeDuplicateRecords(component, event, updatedData)
			return result;
		}
	}

})