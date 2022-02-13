({
    readFile: function(component, helper, file ) {    
         
        if (!file) return;
        //console.log('file'+file.name);
        
        if(!file.name.match(/\.(csv||CSV)$/)){
            return alert('only support csv files');
        }
        else{            
            reader = new FileReader();
            reader.onerror =function errorHandler(evt) {
                switch(evt.target.error.code) {
                    case evt.target.error.NOT_FOUND_ERR:
                        alert('File Not Found!');
                        break;
                    case evt.target.error.NOT_READABLE_ERR:
                        alert('File is not readable');
                        break;
                    case evt.target.error.ABORT_ERR:
                        break; // noop
                    default:
                        alert('An error occurred reading this file.');
                };
            }
            //reader.onprogress = updateProgress;
            reader.onabort = function(e) {
                alert('File read cancelled');
            };
            reader.onloadstart = function(e) { 
                
                var output = '<ui type=\"circle\"><li><strong>'+file.name +'</strong> ('+file.type+')- '+file.size+'bytes, last modified: '+file.lastModifiedDate.toLocaleDateString()+'</li></ui>';
                component.set("v.filename",file.name);
                component.set("v.TargetFileName",output);
               
            };
            reader.onload = function(e) {
                var data=e.target.result;                
                component.set("v.fileContentData",data);                
                var allTextLines = data.split(/\r\n|\n/);/*/\r\n|\n/*/                                
                var dataRows=allTextLines.length-1;               
                //console.log("0 index : " + allTextLines[0]);
                var filecontentdata = [];                                        
                
                for (var i=0; i<allTextLines.length; i++) {                    
                    //console.log("loop : " + allTextLines[i])
                    filecontentdata.push(allTextLines[i].split(','));                      
                }       

                var tblData = [];
                var header = [];                        

                for(var j=0; j<filecontentdata.length; j++){                                                                           
                    var lstOfData = filecontentdata[j];                     
                    
                    if(j == 0){                        
                        component.set("v.header", lstOfData)                        
                        for(var k=0; k<lstOfData.length; k++){
                            header.push(lstOfData[k]);                                      
                        }                                                
                    }
                    else{                        
                        var obj = new Object();

                        for(var k=0; k<lstOfData.length; k++){                            
                            obj[header[k]] = lstOfData[k];                              
                        }                                   
                     
                        obj.index = j;                        
                        tblData.push(obj);                                                
                    }
                                        
                }                                          
                component.set("v.showMain", "false");
                               
                component.set("v.allData", tblData);   
                component.set("v.tempData", tblData);                                                       

                var recordStart;
                var recordEnd;                    
                var totalRecord = tblData.length;
                var pageNumber = component.get("v.pageNumber");
                var totalPage;
                var pageSize = component.get("v.pageSize");

                if(totalRecord == 0){
                    console.log("No data found");
                    component.set("v.allData", []);
                }
                else{
                    totalPage =  Math.ceil(totalRecord / pageSize); 
                    if(pageSize < totalRecord){
                        recordStart = 1;
                        recordEnd = pageSize;                            
                    }
                    else{
                        recordStart = 1;
                        recordEnd = pageSize;                               
                    }
                }   
               
                component.set("v.recordStart", recordStart);
                component.set("v.recordEnd", recordEnd);
                component.set("v.pageNumber", pageNumber);
                component.set("v.tempPageNumber", pageNumber);
                component.set("v.totalPages", totalPage);      
                component.set("v.totalRecords", totalRecord);                                
                
                               
                helper.setData(component, event)
            }
            reader.readAsText(file);           
            
        }
        var reader = new FileReader();
        reader.onloadend = function() {
         
        };
        reader.readAsDataURL(file);                
    },

   
    setPaginationAttribute: function(component, startRecord, endRecord, totalRecord, pageNumber, totalPage ){        

        component.set("v.recordStart", startRecord);
        component.set("v.recordEnd", endRecord);
        component.set("v.pageNumber", pageNumber);
        component.set("v.tempPageNumber", pageNumber);
        component.set("v.totalPages", totalPage);       
        component.set("v.totalRecords", totalRecord);    
        
        //console.log("get : " + totalRecord);
    },
        

	// use for set start index, last index, total record, pagenumber and total page
	setData: function(component, event){
        //console.log("Enterr in set data : ");
		var pageNo = component.get("v.pageNumber");
        var totalPage = component.get("v.totalPages");
		var pageSize = component.get("v.pageSize");
		var data = component.get("v.allData");        
		var startIndex = (pageNo-1) * pageSize;
		var lastIndex;
		        
		if(startIndex == 0){            
			if((pageSize-1) < data.length){                
				lastIndex = pageSize;		                
			}
			else{                
				lastIndex = data.length;				                
			}
		}
		else{
			lastIndex = pageSize * pageNo ;            
			if(lastIndex > data.length){
				lastIndex = data.length;                
			}			
		}        
		
		this.retriveData(component, event, startIndex, lastIndex);		
        this.setPaginationAttribute(component, (startIndex+1), lastIndex, data.length, pageNo, totalPage)

	},

	retriveData: function(component, event, startIndex, lastIndex){                
		var data = component.get("v.allData");
		var recLst = [];        

		for(var i=startIndex; i<lastIndex; i++){         
			recLst.push(data[i]);            
		}        
		component.set("v.showData", recLst);        		

	},  

    setFirstButtonData: function(component, event){

        component.set("v.pageNumber", 1);        
        component.set("v.tempPageNumber", 1);
        component.set("v.disable", true)

        this.setData(component, event);        
    },

    handleNextButton: function(component, event){

        var currentPage = parseInt(component.get("v.pageNumber"));
        var totalPage = component.get("v.totalPages");

        currentPage++;

        if(currentPage > totalPage){            
            currentPage--;
        }
        component.set("v.pageNumber", currentPage)   
        component.set("v.disable", false);
        this.setData(component, event);        
        
    },

    setLastButtonData: function(component, event){
        component.set("v.pageNumber", component.get("v.totalPages"));  
        component.set("v.tempPageNumber", component.get("v.totalPages")); 
        var lastpage = component.get("v.totalPages");
        
        if(lastpage == 1){
            component.set("v.disable", true);
        }            
        else{
            component.set("v.disable", false);
        }
        this.setData(component, event);
        
    },

    handlePreviousButtonData: function(component, event){

        var currentPage = parseInt(component.get("v.pageNumber"));          

        if(currentPage == 2){
            component.set("v.disable", true);
        }
        else{
            component.set("v.disable", false);
        }
        currentPage--;
        if(currentPage < 1){            
            currentPage++;
        }     

        component.set("v.pageNumber", currentPage);
        component.set("v.tempPageNumber", currentPage);
        this.setData(component, event);
        
    },
    
    setPageNoInTextBox: function(component, event){
        var getPageNo = component.get("v.tempPageNumber");
        var totalPage = component.get("v.totalPages");        
             

        if(getPageNo < 1){
            //console.log("enter in if : ")            
            getPageNo = 1;
            
        }
        else if(getPageNo > totalPage){
            //console.log("enter in else if : ")            
            getPageNo = totalPage;            
        }
        else if(!(getPageNo >= 1 && getPageNo <= totalPage)){
            //console.log("enter in 2nd else if : ")            
            getPageNo = 1;         
        }

        if(getPageNo == 1){
            component.set("v.disable", true);
        }
        else{
            component.set("v.disable    ", false);
        }

        component.set("v.pageNumber", getPageNo);
        component.set("v.tempPageNumber", getPageNo);

        this.setData(component, event);
    },

    //getSearch text and pass the data to the searching function. if user search for the first time than it will search from all data. if user already searched something than new filter apply on pre search data
    getSearchText: function(component, event){
        var searchText = event.getParam("searchText");
        var searchHeader = event.getParam("headerValue").replace('"', '');   
        
        component.set("v.searchHeader", searchHeader);

        var filterHeaderList = component.get("v.filterHeader");

        if(filterHeaderList.length == 0){            
            var allData = component.get("v.tempData");
            this.searching(component, event, allData, searchText, searchHeader);
        }
        else{
            var getSearchData = component.get("v.allData");            
            this.searching(component, event, getSearchData, searchText, searchHeader);
        }
        
    },

    setHeaderIcon: function(component, event, searchHeader){

        var headerVal = component.get("v.header");        

        var filterHeaderList = component.get("v.filterHeader");        

        if(filterHeaderList.length == 0){
            var filterLst = component.get("v.filterHeader");
            filterLst.push(searchHeader);                    
            component.set("v.filterHeader", filterLst);                                
        }   
        else{
            if(filterHeaderList.indexOf(searchHeader) > -1){
                //console.log("already exists : " + JSON.stringify(filterHeaderList) + ' exists : ' + searchHeader);

            }
            else{
                var filterLst = component.get("v.filterHeader");  
                                
                filterLst.push(searchHeader);                    
                component.set("v.filterHeader", filterLst);                                    
            }  
        }   

        var len = headerVal.length;
        filterHeaderList = component.get("v.filterHeader");        

        var lst = [];
        for(var i=0; i<len;  i++){
            var index = filterHeaderList.filter(function(obj, j){                
                if(obj.toLowerCase() == headerVal[i].b.toLowerCase()){                    
                    return obj;
                } 
            })                        
            var obj = new Object();            
            if(index != null && index != ''){
                obj.a = true
                obj.b = headerVal[i].b;                
            }
            else{
                obj.a = false;
                obj.b = headerVal[i].b;   
            }   
            lst.push(obj);            
        }                        

        component.set("v.header", lst);        
    },

    getSearch: function(component, event){

    },

    //use for when user click on close header icon than it will search the search according to the remaining filters.
    setAllData: function(component, event){
        var headerName = event.getParam("removeSearching");
        var filterHeader = component.get("v.filterHeader");        
        var index = filterHeader.indexOf(headerName);

        if(index > -1){            
            filterHeader.splice(index, 1);
            component.set("v.filterHeader", filterHeader);
            
        }
        else{
            console.log("not found in arrya : " )
        }
        
        var srchConditionLst = component.get("v.and"); 
        var headerList = component.get("v.header");
        var removeHeader = srchConditionLst.filter(function(obj){
            
            if(obj.header != headerName){                
                return obj;
            }
        })        

        if(removeHeader.length == 0){
            var data = component.get("v.tempData");
            var lst = [];

            var updatedHeaderList = [];
            for(var i = 0; i < headerList.length; i++){
                var obj = new Object();
                obj.a = "false";
                obj.b = headerList[i].b;
                updatedHeaderList.push(obj);   
            }
            component.set("v.header", updatedHeaderList);
            component.set("v.allData", data);
            this.setData(component, event);            
        }
        else{            
            component.set("v.and", removeHeader);
            var updatedHeaderList = [];

            for(var i = 0; i < headerList.length; i++){
                
                var status = true;
                for(var j = 0; j < removeHeader.length; j++){
                    
                    if(headerList[i].b == removeHeader[j].header){
                        
                        status = false;
                    }                
                }

                if(status == true){
                    var obj = new Object();
                    obj.a = "false";
                    obj.b = headerList[i].b;
                    updatedHeaderList.push(obj);                
                }
                else{
                    var obj = new Object();
                    obj.a = "true";
                    obj.b = headerList[i].b;
                    updatedHeaderList.push(obj);
                }                                
            }
            
            component.set("v.header", updatedHeaderList);                  
            this.searchDataAfterRemoveFilter(component, event, removeHeader)           
        }

    },

    //use for search data 
    searching: function(component, event, allData, searchText, searchHeader){
        var searchData = [];
        var pageSize  = component.get("v.pageSize");        

        if(searchText == null ||  searchText == '' || searchText == 'undefined'){
            component.set("v.pageNumber", 1);
            component.set("v.tempPageNumber", 1);
            component.set("v.disable", true)

            var tmpData = component.get("v.tempData");            
            var len = component.get("v.allData").length 
            var totalPage = Math.ceil(len / pageSize);                                
            component.set("v.totalPages", totalPage);
            this.setData(component, event);            
            
        }
        else{           
            searchData = allData.filter(function(arg){  
                var headVal = arg[searchHeader];                

                if(headVal.toLowerCase() == searchText.toLowerCase()){                        
                    return arg;
                }

            });                            
                                 
            if(searchData.length > 0){    

                var header_SearchText = new Object();
                header_SearchText.header = searchHeader;
                header_SearchText.searchText = searchText;
                
                var lst = component.get("v.and");                                
                var status = true;

                for(var i=0; i<lst.length; i++){
                    if(lst[i].header == searchHeader){
                        //console.log("found duplicate")
                        status = false;
                        break;;
                    }
                }

                if(status == true){
                    lst.push(header_SearchText);                                        
                }                                                          

                component.set("v.and", lst)

                component.set("v.pageNumber", 1);   
                component.set("v.tempPageNumber", 1); 
                component.set("v.disable", true)

                component.set("v.allData", searchData);                

                var totalPage = Math.ceil( searchData.length / pageSize);                                
                component.set("v.totalPages", totalPage);                
                this.setData(component, event);                                
                this.setHeaderIcon(component, event, searchHeader);                                                    
            }
            else{
                console.log("No record found");
                //component.set("v.allData", []);                                
                component.set("v.showData", []);
                console.log("header : " + JSON.stringify(component.get("v.header")));
                //this.setData(component, event);                                
                //this.setHeaderIcon(component, event, searchHeader);                                                    
            }                        
        }

    },

    searchDataAfterRemoveFilter: function(component, event, removeHeader){     
        var allData = component.get("v.tempData");     

        for(var i=0; i<removeHeader.length; i++){
            var searchHeader = removeHeader[i].header;
            var searchText = removeHeader[i].searchText;

            this.searching(component, event, allData, searchText, searchHeader);
            allData = component.get("v.allData");               

        }       
        
    }   
    
});