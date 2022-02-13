({
	getAllObjectListHelper : function(component, event) {
		var action = component.get('c.getObjectList');
		action.setCallback(this, function(response){
			var state = response.getState();
			//console.log('state : ' + state);

			if(state == 'SUCCESS'){
                var objList = [];
                objList.push({
                    value : '',
                    label : ' -- None --'
                });
                for(var obj in response.getReturnValue()) {
                    objList.push(response.getReturnValue()[obj]);
                }
				component.set('v.objectList',objList);
			}
			else{
				console.log('response error : ' + JSON.stringify(response.getError()));
			}
		})
		$A.enqueueAction(action);
	},

	getFieldsHelper : function(component, event){
		var objectName = component.get('v.objectName');		
		this.getFields(component, event, objectName);		
	},

	getFields : function(component, event, objectName){
		var action = component.get('c.getFilds');
		action.setParams({"objectName" :  objectName});
		action.setCallback(this, function(response){
			var state = response.getState();
			if(state === 'SUCCESS'){
                
                //console.log('resonse of fields : '+JSON.stringify(response.getReturnValue()));
				
				var nonselectedfields = [];
                var selectedfields = [];
                for(var obj in response.getReturnValue()) {
            		//console.log('response.getReturnValue()[obj] : ' + JSON.stringify(response.getReturnValue()[obj]));
                    nonselectedfields.push(response.getReturnValue()[obj]);                
                }
                component.set('v.nonSelectedFields',nonselectedfields);                
			}
		});
        $A.enqueueAction(action);
	},

	showRecordsHelper: function(component, event){					

		var obj = component.get('v.objectName')	;
		var objFlds = component.get('v.selectedFields');
		
		//console.log('selectedfields : ' + component.get('v.selectedFields'));		

		var action = component.get('c.showRecordsController');		
		action.setParams({"objectName" : obj,
						"fields" : JSON.stringify(objFlds)});
		action.setCallback(this, function(response){
			var state = response.getState();

			if(state === 'SUCCESS'){				
				component.set('v.objRecords', response.getReturnValue());
				console.log('setColumns call');
				this.setColumns(component, event);
				//this.removeSpecialCharacterFromFields(component, event);
			}
			else{
				console.log('error : ' + JSON.stringify(response.getError()));
			}
			console.log('state : ' + state);
		})
		$A.enqueueAction(action);
	},

	removeSpecialCharacterFromFields : function(component, event){
		var selectedFlds =  component.get('v.selectedFields');
		var newFieldsList = [];

		//console.log('cal : ' + JSON.stringify(selectedFlds));

		for(var i = 0; i < selectedFlds.length; i++){			
			if(i == selectedFlds.length-1){
				selectedFlds = selectedFlds[i].slice(0, -1)
				console.log('if shw : ' + selectedFlds);
				newFieldsList.push(selectedFlds);
			}
			else{
				//console.log('else = ' + JSON.stringify(selectedfields[i]));
				newFieldsList.push(selectedFlds[i]);
			}
		}

		//console.log('last : ' + JSON.stringify(newFieldsList));
		//component.set('v.selectedFields', newFieldsList);
	},

	setColumns : function(component, event){
		var column = component.get('v.selectedFieldsData');
		var colList = [];
		
		console.log('selectedfields : ', column);

		for(var i = 0; i < column.length; i++){
			if(i == column.length-1){

			}
			else{
				console.log('-------> : ' + JSON.stringify(column[i].value))
				colList.push({"label" : column[i].label, "fieldName" : column[i].value, 'type': column[i].dataType})
			}
		}
		component.set('v.columns', colList);
		console.log('col list : ' + JSON.stringify(colList));		

		this.setData(component, event);
	},

	setData : function(component, event){
		var objRecords = component.get('v.objRecords');
		var colLst = component.get('v.columns');
		var data = [];

		for(var i = 0; i < objRecords.length; i++){
			for(var j = 0; j < colLst.length; j++){
				console.log('field name in data ' + colLst[i].fieldName);
				console.log('record name in data ' + objRecords[i].fieldName);
				var lbl = colLst[i].fieldName;
				data.push({lbl : objRecords[i].fieldName});
			}
		}

		console.log('after set data : ' + JSON.stringify(data));
	},

	getSelectedValueData : function(component, event){
		var allFields = component.get('v.nonSelectedFields');
		var selectedVal = component.get('v.selectedFields');

		console.log('---selectedfields------> : ' + JSON.stringify(selectedVal));
		//console.log('---allFields------> : ' + JSON.stringify(allFields));

		var selectedFieldsData = [];

		for(var i = 0; i < selectedVal.length; i++){
			for(var j = 0; j < allFields.length; j++){
				if(selectedVal[i] == allFields[j].value ){
					selectedFieldsData.push(allFields[j]);
				}
			}
		}		
		component.set('v.selectedFieldsData', selectedFieldsData)

		//this.setColumns(component, event);
	}

})

/*
 cmp.set('v.columns', [
            {label: 'Opportunity name', fieldName: 'opportunityName', type: 'text'},
            {label: 'Account name', fieldName: 'accountName', type: 'text'},
            {label: 'Close date', fieldName: 'closeDate', type: 'date'},
            {label: 'Confidence', fieldName: 'confidence', type: 'percentage'},
            {label: 'Amount', fieldName: 'amount', type: 'currency', typeAttributes: { currencyCode: 'EUR', maximumSignificantDigits: 5}},
            {label: 'Contact Email', fieldName: 'contact', type: 'email'},
            {label: 'Contact Phone', fieldName: 'phone', type: 'phone'},
            {label: 'Website', fieldName: 'website', type: 'url', typeAttributes: { target: '_self'}},
            {label: 'Address', fieldName: 'address', type: 'location'}
        ]);


         var fetchData = {
            opportunityName: "company.companyName",
            accountName : "name.findName",
            closeDate : "date.future",
            amount : "finance.amount",
            contact: "internet.email",
            phone : "phone.phoneNumber",
            website : "internet.url",
            status : {type : "helpers.randomize", values : [ 'Pending', 'Approved', 'Complete', 'Closed' ] },
            actionLabel : {type : "helpers.randomize", values : [ 'Approve', 'Complete', 'Close', 'Closed' ]},
            confidenceDeltaIcon : {type : "helpers.randomize", values : [ 'utility:up', 'utility:down' ]}
        };
*/