({
	// set values in pagination variables
	setPaginationData : function(component, event, pageSize) {
		var data = component.get("v.allData");	
		console.log("len : " + data.length);
		var recordStart = component.get("v.recordStart");
		var recordEnd = component.get("v.recordEnd");		
		var totalRecord = data.length;				
		var pageNumber = component.get("v.pageNumber");	
		var totalPage =  Math.ceil(data.length / pageSize); 						
		
		if(recordEnd > totalRecord){
			recordEnd = totalRecord;			
		}

		this.setPaginationAttribute(component, event, recordStart, recordEnd, totalRecord, pageNumber, totalPage);					
		this.setData(component, event);
		this.showRecords(component, data);		
	},

	// set values in all pagination attribute
	setPaginationAttribute: function(component, event, startRecord, endRecord, totalRecord, pageNumber, totalPage ){ 		

		component.set("v.recordStart", startRecord);
		component.set("v.recordEnd", endRecord);
		component.set("v.pageNumber", pageNumber);
		component.set("v.totalPages", totalPage);		
		component.set("v.totalRecords", totalRecord);		
		//console.log("get : " + component.get("v.totalRecords"));
	},

	//use for fetch data and send to table 
	showRecords: function(component){

		var lstOfData = [];
		var showData = component.get("v.showData");

		for(var i=0; i<showData.length; i++){			
			lstOfData.push(showData[i])
		}		

		var event = component.getEvent("lstOfData");
		event.setParams({"lstOfData": lstOfData}).fire();		

	},

	// use for set start index, last index, total record, pagenumber and total page
	setData: function(component, event){
		var pageNo = component.get("v.pageNumber");
		var pageSize = component.get("v.pageSize");
		var data = component.get("v.allData");

		var startIndex = (pageNo-1) * pageSize;
		var lastIndex;
		
		if(startIndex == 0){
			if((pageSize-1) < data.length){
				lastIndex = pageSize;				
			}
			else{
				lastIndex = pageSize;				
			}
		}
		else{
			lastIndex = pageSize * pageNo ;
			if(lastIndex > data.length){
				lastIndex = data.length;
			}			
		}

		this.retriveData(component, event, startIndex, lastIndex);
		//console.log("startIndex : " + startIndex + ' lastIndex : ' + lastIndex + ' totalRecord : ' + data.length);
	},

	retriveData: function(component, event, startIndex, lastIndex){

		var data = component.get("v.allData");
		var recLst = [];
		for(var i=startIndex; i<lastIndex; i++){
			recLst.push(data[i]);
		}

		component.set("v.showData", recLst);
		//console.log("final data : " + JSON.stringify(recLst));

	}

})