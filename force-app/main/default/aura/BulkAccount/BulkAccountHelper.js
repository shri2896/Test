({
	createObjectData: function(component, event) {
        // get the acc from component and add(push) New Object to List  
        var RowItemList = component.get("v.acc");
        RowItemList.push({
            'sobjectType': 'Account',
            'Name': '',
            'AccountNumber': '',
            'Phone': ''
        });
        // set the updated list to attribute (acc) again    
        component.set("v.acc", RowItemList);
    },
    
    validateRequired: function(component, event) {
        var isValid = true;
        var allAccountRows = component.get("v.acc");
        
        for (var indexVar = 0; indexVar < allAccountRows.length; indexVar++) {
            if (allAccountRows[indexVar].Name == '') {
                isValid = false;
                alert('Account Name Can\'t be Blank on Row Number ' + (indexVar));
            }           
        }
        return isValid;
    },
    
    reflectNewData: function(component, newData){
        var evnt = component.getEvent("updatedData").setParams({"updatedData": newData}).fire();    
    }
})