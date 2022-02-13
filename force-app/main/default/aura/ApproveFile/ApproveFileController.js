({
	onDragOver : function(component, event, helper) {
		event.preventDefault();
	},
    
    onDrop : function(component, event, helper) {
		event.stopPropagation();
        event.preventDefault();
        event.dataTransfer.dropEffect='copy';
        var files=event.dataTransfer.files;
        helper.readFile(component,helper,files[0]);      

	},
        
    
    cancel : function(component,event,helper){
        component.set("v.showMain",true);
    },

     handleFirst: function(component, event, helper){
        helper.setFirstButtonData(component, event);                

    },

    handleNext: function(component, event, helper){                        
        helper.handleNextButton(component, event)        

    },

     handleLast: function(component, event, helper){
        helper.setLastButtonData(component, event);                
    },

     handlePrev: function(component, event, helper){       

        helper.handlePreviousButtonData(component, event);  

    },

    getPageNo: function(component, event, helper){
        helper.setPageNoInTextBox(component, event);

    },

     getSearchValue: function(component, event, helper){
        helper.getSearchText(component, event);
     
    },

    removeSearchingFromHeader: function(component, event, helper){        
        helper.setAllData(component, event);
    }
    
    /*changeRecordSize: function(component, event, helper){
        var pageSize = event.getParam("updatedData");
        //var startRec = parseInt(component.get("v.RecordStart"));
        //var endRec = parseInt(component.get("v.RecordEnd"));


        component.set("v.pageSize", pageSize);

        //console.log('pageSize ' + component.get("v.pageSize"));
        

        var totalRec = component.get("v.TotalRecords");
        //console.log('event handler ' + totalRec);
        


        if(pageSize < totalRec){
            
            component.set("v.RecordStart", 1);
            component.set("v.RecordEnd", pageSize);
            component.set("v.PageNumber", "1");            

            //helper.changePageSize(component, changePageSize)
            component.set("v.RecordEnd", pageSize);

            component.set("v.TotalPages", Math.ceil(totalRec / pageSize));

            //console.log("RecordEnd : " + component.get("v.TotalPages"))
        }
        else{
            component.set("v.RecordStart", 1);            
            component.set("v.PageNumber", "1");

            helper.changePageSize(component, totalRec)

            component.set("v.RecordEnd", totalRec);
            component.set("v.TotalPages", "1");
            //console.log("RecordEnd : " + component.get("v.TotalPages"))
        }

    },
  
*/


})