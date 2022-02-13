({
	close : function(component, event, helper) {
		component.destroy();
	},

	SelectedRecord: function(component, event, helper){
		
		var searchVal = component.get("v.searchValue");		
		if(searchVal == '' || searchVal == null || searchVal == 'undefinied')
		{
			//alert("No search text found : ");
			//helper.showErrorToast(component, event)
		}
		else{
			//console.log("header in modal : " + component.get("v.searchHeader"));
			var event = component.getEvent("searchText");
			event.setParams({	"searchText" : searchVal,
								"headerValue" : component.get("v.searchHeader")
							})

			event.fire();
			component.destroy();
		}
	}
})