({
	doInit: function(component, event, helper){

		var data = component.get("v.allData");

		if(data.length == 0){
			console.log("no data found : ");

			var startRecord = 0, endRecord = 0, totalRecord = 0, PageNumber = 0, totalPage = 0;
			//helper.setPaginationAttribute(component, event, startRecord, endRecord, totalRecord, PageNumber, totalPage);			
		}
		else{
			component.set("v.recordStart","1");
			helper.setPaginationData(component, event, component.get("v.pageSize"));
		}

	},

	onSelectChange : function(component, event, helper) {
		var pageSize = component.find("pageSize").get("v.value");

		//console.log("pageSize : " + pageSize);        		

        var evnt = component.getEvent("updatedData") 
	    evnt.setParams({"updatedData": pageSize});
	    evnt.fire();
	},

	handleFirst: function(component, evnt, helper){
		var event = component.getEvent("handleFirst");
		event.fire();
	},

	handleNext: function(component, evnt, helper){
		var event = component.getEvent("handleNext")	
		event.fire();
	},

	handlePrev: function(component, event, helper){
		var event = component.getEvent("handlePrev");
		event.fire();
	},

	handleLast: function(component, event, helper){
		var event = component.getEvent("handleLast");
		event.fire();
	},

	gotoPage: function(component, event, helper){
		var event = component.getEvent("gotoPage");
		var pageNo = component.get("v.temp");
		event.setParams({"pageNo": pageNo})
		event.fire();
	}
})