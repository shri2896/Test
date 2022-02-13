({
    
    doInit: function(component, event, helper){              
        
        var pageSize = component.find("pageSize").get("v.value");
        var pageNumber = component.get("v.PageNumber");
        //console.log("pageNumber : " + pageNumber + ' : ' + pageSize )

        helper.getAccountList(component, pageNumber, pageSize);        
                
    },
    
    
    openModel: function(component, event, helper){          
        $A.createComponent('c:CreateNewAccountRecord',{     
            'headerText' : 'Create New Account Record'
       	 },
        function(modalComponent, status, errorMessage){
            //console.log('model comp : ' + modalComponent)
            if(status == 'SUCCESS'){
                var body = component.find('showChildModal').get("v.body")    
                body.push(modalComponent)
                component.find('showChildModal' ).set("v.body", body);
            }
            else if (status === "INCOMPLETE") {
                //console.log('Server issue or client is offline.');
            } 
            else if (status === "ERROR") {
          	  //console.log('error');
            }
        })    
    },
    
     createNewRecord: function(component, event, helper){
        var insertRec = event.getParam("CreateNewAccountRecord");		    
        component.set("v.rec", insertRec)
    },
   
    
    updateAccountRecordList: function(component, event, helper){
        var getUpdatedList = event.getParam("updatedData");
        //console.log("List after deleteion : " + JSON.stringify(getUpdatedList))
         component.set("v.rec", getUpdatedList)
    },
    
    updateCountOfChildRecord: function(component, event, helper){ //delete or create new contact it will update count of child records
        //var res = event.getParam("afterDeleteUpdateContact");        
        //alert("Enter in handler : " + JSON.stringify(result));
         var action = component.get("c.getAccount");        
        	action.setCallback(this, function(response){            
            var state = response.getState();        
            if(state == 'SUCCESS'){   
                var result=response.getReturnValue();               
                component.set("v.rec",result);
            }
            else{
                alert("Error in response");
            }
        });   
        $A.enqueueAction(action);
        
    },
    
    bulkAccount: function(component, event, helper){
        $A.createComponent('c:BulkAccount',{
        	'headerText': 'BulkAccount'                    
       	},
        function(modalComponent, status, errorMessage){
            if(status == 'SUCCESS'){
            	var body = component.find('bulkAccount').get("v.body")    
                body.push(modalComponent)
                component.find('bulkAccount').set("v.body", body);                 
            }        	   
            else{
                alert("error in accountbulk : " + errorMessage);
            }
        })        
    },
    
    navigateToKanban: function(component, event, helper){
        var showKanban = component.get("v.isKanbanShow");        
        if(showKanban == true){
            showKanban = false;
        }
        else{
            showKanban = true;
        }
        component.set("v.isKanbanShow", showKanban);
    },

     onSelectChange: function(component, event, helper) {
        var page = 1;
        var pageSize = component.find("pageSize").get("v.value");
        helper.getAccountList(component, page, pageSize);
    },

    handleNext: function(component, event, helper){
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber++;
        helper.getAccountList(component, pageNumber, pageSize);
    },

    handlePrev: function(component, event, helper){
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber--;
        helper.getAccountList(component, pageNumber, pageSize);
    },

    handleFirst: function(component, event, helper){
        var pageNumber = 1;
        var pageSize = component.find("pageSize").get("v.value");
        helper.getAccountList(component, pageNumber, pageSize);
    },

    handleLast: function(component, event, helper){
        var pageNumber = component.get("v.TotalPages");
        var pageSize = component.find("pageSize").get("v.value");
        helper.getAccountList(component, pageNumber, pageSize);
    },

    goto: function(component, event, helper){
        var pageNumber = component.get("v.temp")
        component.set("v.pageSize", pageNumber)
        var pageSize = component.find("pageSize").get("v.value");
        var totalPage = component.get("v.TotalPages");
        if(pageNumber > 0){
            if(pageNumber > totalPage ){
                pageNumber = component.get("v.TotalPages")
            }            
        }
        else {
            pageNumber = 1;
        }

        console.log("val :  " + pageNumber)
        console.log("size :  " + totalPage)
        helper.getAccountList(component, pageNumber, pageSize)
    }

})